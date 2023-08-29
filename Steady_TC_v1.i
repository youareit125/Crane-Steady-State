[Mesh]
  type = GeneratedMesh
  dim = 1
  xmin = 0
  xmax = 1
  nx = 1
[]

[Variables]
  [Ar4s]
    family = SCALAR
    initial_condition = 1e10 #m^-3
  []
  [Ar4p]
    family = SCALAR
    initial_condition = 1e10 #m^-3
  []
  [Arp]
    family = SCALAR
    initial_condition = 1e10 #m^-3
  []
  [Ar2p]
    family = SCALAR
    initial_condition = 1e10 #m^-3
  []
[]

[AuxVariables]
  [Te]
    family = SCALAR
    initial_condition = 2.17 #eV
  []
  [Ar]
    family = SCALAR
    initial_condition = 6.437e21 #m^-3
  []
  [e]
    family = SCALAR
    #ne = 3.43e17
  []
[]

[ChemicalReactions]
  [ScalarNetwork]
    species = 'Ar4s Ar4p Arp Ar2p'
    aux_species = 'Ar e'
    equation_constants = 'Tgas'
    equation_values = '300'
    equation_variables = 'Te'
    interpolation_type = 'linear'
    
    reactions = 'e + Ar -> e + e + Arp         : {2.34e-14*Te^(0.59)*exp(-17.44/Te)}
                 e + e + Arp -> e + Ar         : {1e-39*Te^(-4.5)}
                 e + Arp + Ar -> Ar + Ar       : 1e-39

                 e + Ar -> e + Ar4s            : {5e-15*Te^(0.74)*exp(-11.56/Te)}
                 e + Ar4s -> e + Ar            : {4.3e-16*Te^(0.74)}
                 e + Ar4s -> e + e + Arp       : {6.8e-15*Te^(0.67)*exp(-4.20/Te)}
                 
                 e + Ar -> e + Ar4p            : {1.4e-14*Te^(0.71)*exp(-13.2/Te)}
                 e + Ar4p -> e + Ar            : {3.9e-16*Te^(0.71)}
                 e + Ar4p -> e + e + Arp       : {1.8e-13*Te^(0.61)*exp(-2.61/Te)}

                 Ar4p -> Ar                    : 3.2e7
                 
                 Ar2p + e -> Ar4s + Ar         : {8.5e-13*(Te*11600/300.0)^(-0.67)}
                 Ar2p + e -> Ar4p + Ar         : {8.5e-13*(Te*11600/300.0)^(-0.67)}

                 Ar2p + Ar -> Arp + Ar + Ar    : {(6.06e-13/Tgas)*exp(-15130.0/Tgas)}
                 Ar4s + Ar4s -> Ar2p + e       : 6.0e-16
                 Ar4s + Ar4p -> Ar2p + e       : 6.0e-16
                 Ar4p + Ar4p -> Ar2p + e       : 6.0e-16

                 Arp + Ar + Ar -> Ar2p + Ar    : {2.25e-31*(Tgas/300.0)^(-0.4)}'
  []
[]

[AuxScalarKernels]
  [quasineutral]
    type = VariableSum
    variable = e
    args = 'Arp Ar2p'
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

[Executioner]
  type = Steady
  solve_type = 'linear'
  automatic_scaling = true
  petsc_options_iname = '-pc_type -pc_asm_overlap -sub_pc_type -sub_pc_factor_levels'
  petsc_options_value = 'asm      2               ilu          4'
  line_search = 'none'
  nl_rel_tol = 1e-12
  nl_abs_tol = 1e-13
  nl_max_its = 6
  l_tol = 1e-6
  l_max_its = 500
[]

[Outputs]
  [out]
    type = CSV
  []
[]