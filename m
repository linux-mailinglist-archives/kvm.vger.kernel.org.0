Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C403617CA3C
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2020 02:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgCGBTM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 20:19:12 -0500
Received: from mga06.intel.com ([134.134.136.31]:44266 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbgCGBTM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 20:19:12 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Mar 2020 17:19:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,524,1574150400"; 
   d="scan'208";a="288124344"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Mar 2020 17:19:06 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jAO7M-000EES-Hp; Sat, 07 Mar 2020 09:19:04 +0800
Date:   Sat, 7 Mar 2020 09:18:22 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, cavery@redhat.com, vkuznets@redhat.com,
        jan.kiszka@siemens.com, wei.huang2@amd.com
Subject: Re: [PATCH 3/4] KVM: nSVM: implement check_nested_events for
 interrupts
Message-ID: <202003070954.akHT8HEM%lkp@intel.com>
References: <1583403227-11432-4-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583403227-11432-4-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

I love your patch! Perhaps something to improve:

[auto build test WARNING on kvm/linux-next]
[also build test WARNING on linus/master v5.6-rc4 next-20200306]
[cannot apply to linux/master vhost/linux-next]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Paolo-Bonzini/KVM-nSVM-first-step-towards-fixing-event-injection/20200306-015933
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git linux-next
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-174-g094d5a94-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> arch/x86/kvm/svm.c:7538:32: sparse: sparse: incorrect type in initializer (different argument counts)
>> arch/x86/kvm/svm.c:7538:32: sparse:    expected int ( *check_nested_events )( ... )
>> arch/x86/kvm/svm.c:7538:32: sparse:    got int ( * )( ... )
   arch/x86/include/asm/paravirt.h:200:9: sparse: sparse: cast truncates bits from constant value (100000000 becomes 0)
   arch/x86/include/asm/paravirt.h:200:9: sparse: sparse: cast truncates bits from constant value (100000000 becomes 0)
   arch/x86/include/asm/bitops.h:77:37: sparse: sparse: cast truncates bits from constant value (ffffff7f becomes 7f)
   arch/x86/kvm/svm.c:6920:60: sparse: sparse: dereference of noderef expression
   arch/x86/kvm/svm.c:6920:60: sparse: sparse: dereference of noderef expression
   arch/x86/kvm/svm.c:6943:14: sparse: sparse: dereference of noderef expression
   arch/x86/kvm/svm.c:6949:59: sparse: sparse: dereference of noderef expression
   arch/x86/kvm/svm.c:6949:59: sparse: sparse: dereference of noderef expression
   arch/x86/kvm/svm.c:6963:14: sparse: sparse: dereference of noderef expression
   arch/x86/kvm/svm.c:6988:70: sparse: sparse: dereference of noderef expression
   arch/x86/kvm/svm.c:6988:70: sparse: sparse: dereference of noderef expression

vim +7538 arch/x86/kvm/svm.c

  7396	
  7397	static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
  7398		.cpu_has_kvm_support = has_svm,
  7399		.disabled_by_bios = is_disabled,
  7400		.hardware_setup = svm_hardware_setup,
  7401		.hardware_unsetup = svm_hardware_teardown,
  7402		.check_processor_compatibility = svm_check_processor_compat,
  7403		.hardware_enable = svm_hardware_enable,
  7404		.hardware_disable = svm_hardware_disable,
  7405		.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
  7406		.has_emulated_msr = svm_has_emulated_msr,
  7407	
  7408		.vcpu_create = svm_create_vcpu,
  7409		.vcpu_free = svm_free_vcpu,
  7410		.vcpu_reset = svm_vcpu_reset,
  7411	
  7412		.vm_alloc = svm_vm_alloc,
  7413		.vm_free = svm_vm_free,
  7414		.vm_init = svm_vm_init,
  7415		.vm_destroy = svm_vm_destroy,
  7416	
  7417		.prepare_guest_switch = svm_prepare_guest_switch,
  7418		.vcpu_load = svm_vcpu_load,
  7419		.vcpu_put = svm_vcpu_put,
  7420		.vcpu_blocking = svm_vcpu_blocking,
  7421		.vcpu_unblocking = svm_vcpu_unblocking,
  7422	
  7423		.update_bp_intercept = update_bp_intercept,
  7424		.get_msr_feature = svm_get_msr_feature,
  7425		.get_msr = svm_get_msr,
  7426		.set_msr = svm_set_msr,
  7427		.get_segment_base = svm_get_segment_base,
  7428		.get_segment = svm_get_segment,
  7429		.set_segment = svm_set_segment,
  7430		.get_cpl = svm_get_cpl,
  7431		.get_cs_db_l_bits = kvm_get_cs_db_l_bits,
  7432		.decache_cr0_guest_bits = svm_decache_cr0_guest_bits,
  7433		.decache_cr4_guest_bits = svm_decache_cr4_guest_bits,
  7434		.set_cr0 = svm_set_cr0,
  7435		.set_cr3 = svm_set_cr3,
  7436		.set_cr4 = svm_set_cr4,
  7437		.set_efer = svm_set_efer,
  7438		.get_idt = svm_get_idt,
  7439		.set_idt = svm_set_idt,
  7440		.get_gdt = svm_get_gdt,
  7441		.set_gdt = svm_set_gdt,
  7442		.get_dr6 = svm_get_dr6,
  7443		.set_dr6 = svm_set_dr6,
  7444		.set_dr7 = svm_set_dr7,
  7445		.sync_dirty_debug_regs = svm_sync_dirty_debug_regs,
  7446		.cache_reg = svm_cache_reg,
  7447		.get_rflags = svm_get_rflags,
  7448		.set_rflags = svm_set_rflags,
  7449	
  7450		.tlb_flush = svm_flush_tlb,
  7451		.tlb_flush_gva = svm_flush_tlb_gva,
  7452	
  7453		.run = svm_vcpu_run,
  7454		.handle_exit = handle_exit,
  7455		.skip_emulated_instruction = skip_emulated_instruction,
  7456		.update_emulated_instruction = NULL,
  7457		.set_interrupt_shadow = svm_set_interrupt_shadow,
  7458		.get_interrupt_shadow = svm_get_interrupt_shadow,
  7459		.patch_hypercall = svm_patch_hypercall,
  7460		.set_irq = svm_set_irq,
  7461		.set_nmi = svm_inject_nmi,
  7462		.queue_exception = svm_queue_exception,
  7463		.cancel_injection = svm_cancel_injection,
  7464		.interrupt_allowed = svm_interrupt_allowed,
  7465		.nmi_allowed = svm_nmi_allowed,
  7466		.get_nmi_mask = svm_get_nmi_mask,
  7467		.set_nmi_mask = svm_set_nmi_mask,
  7468		.enable_nmi_window = enable_nmi_window,
  7469		.enable_irq_window = enable_irq_window,
  7470		.update_cr8_intercept = update_cr8_intercept,
  7471		.set_virtual_apic_mode = svm_set_virtual_apic_mode,
  7472		.refresh_apicv_exec_ctrl = svm_refresh_apicv_exec_ctrl,
  7473		.check_apicv_inhibit_reasons = svm_check_apicv_inhibit_reasons,
  7474		.pre_update_apicv_exec_ctrl = svm_pre_update_apicv_exec_ctrl,
  7475		.load_eoi_exitmap = svm_load_eoi_exitmap,
  7476		.hwapic_irr_update = svm_hwapic_irr_update,
  7477		.hwapic_isr_update = svm_hwapic_isr_update,
  7478		.sync_pir_to_irr = kvm_lapic_find_highest_irr,
  7479		.apicv_post_state_restore = avic_post_state_restore,
  7480	
  7481		.set_tss_addr = svm_set_tss_addr,
  7482		.set_identity_map_addr = svm_set_identity_map_addr,
  7483		.get_tdp_level = get_npt_level,
  7484		.get_mt_mask = svm_get_mt_mask,
  7485	
  7486		.get_exit_info = svm_get_exit_info,
  7487	
  7488		.get_lpage_level = svm_get_lpage_level,
  7489	
  7490		.cpuid_update = svm_cpuid_update,
  7491	
  7492		.rdtscp_supported = svm_rdtscp_supported,
  7493		.invpcid_supported = svm_invpcid_supported,
  7494		.mpx_supported = svm_mpx_supported,
  7495		.xsaves_supported = svm_xsaves_supported,
  7496		.umip_emulated = svm_umip_emulated,
  7497		.pt_supported = svm_pt_supported,
  7498		.pku_supported = svm_pku_supported,
  7499	
  7500		.set_supported_cpuid = svm_set_supported_cpuid,
  7501	
  7502		.has_wbinvd_exit = svm_has_wbinvd_exit,
  7503	
  7504		.read_l1_tsc_offset = svm_read_l1_tsc_offset,
  7505		.write_l1_tsc_offset = svm_write_l1_tsc_offset,
  7506	
  7507		.set_tdp_cr3 = set_tdp_cr3,
  7508	
  7509		.check_intercept = svm_check_intercept,
  7510		.handle_exit_irqoff = svm_handle_exit_irqoff,
  7511	
  7512		.request_immediate_exit = __kvm_request_immediate_exit,
  7513	
  7514		.sched_in = svm_sched_in,
  7515	
  7516		.pmu_ops = &amd_pmu_ops,
  7517		.deliver_posted_interrupt = svm_deliver_avic_intr,
  7518		.dy_apicv_has_pending_interrupt = svm_dy_apicv_has_pending_interrupt,
  7519		.update_pi_irte = svm_update_pi_irte,
  7520		.setup_mce = svm_setup_mce,
  7521	
  7522		.smi_allowed = svm_smi_allowed,
  7523		.pre_enter_smm = svm_pre_enter_smm,
  7524		.pre_leave_smm = svm_pre_leave_smm,
  7525		.enable_smi_window = enable_smi_window,
  7526	
  7527		.mem_enc_op = svm_mem_enc_op,
  7528		.mem_enc_reg_region = svm_register_enc_region,
  7529		.mem_enc_unreg_region = svm_unregister_enc_region,
  7530	
  7531		.nested_enable_evmcs = NULL,
  7532		.nested_get_evmcs_version = NULL,
  7533	
  7534		.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
  7535	
  7536		.apic_init_signal_blocked = svm_apic_init_signal_blocked,
  7537	
> 7538		.check_nested_events = svm_check_nested_events,
  7539	};
  7540	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
