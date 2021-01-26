Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4CB3043C3
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 17:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390743AbhAZQZk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 11:25:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:56360 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391017AbhAZJ2k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 04:28:40 -0500
IronPort-SDR: +OCM9kGIBQ3iqr/wpwLtQ2zW5mPzcwg6qXy87m+x0JyE0brwyHTJL4IV7itoNST6ySPj3636QD
 cOWIU+drC/lw==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="180019250"
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="180019250"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 01:27:09 -0800
IronPort-SDR: ZMTEK5kw4+xAWtev9E12T5gFOmKp2RcntEFf5B68NE4X2dPS+K0WyBFDZXrcb92zx2VAMqUO/x
 zjpXJr650Svw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="361919654"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga008.fm.intel.com with ESMTP; 26 Jan 2021 01:27:07 -0800
Message-ID: <0702b26fadeff53c08657afa1872a47df90c4198.camel@linux.intel.com>
Subject: Re: [RFC PATCH 03/12] kvm/vmx: Introduce the new tertiary
 processor-based VM-execution controls
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     chang.seok.bae@intel.com, kvm@vger.kernel.org, robert.hu@intel.com,
        pbonzini@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
Date:   Tue, 26 Jan 2021 17:27:06 +0800
In-Reply-To: <87czxt4amd.fsf@vitty.brq.redhat.com>
References: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
         <1611565580-47718-4-git-send-email-robert.hu@linux.intel.com>
         <87czxt4amd.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-01-25 at 10:41 +0100, Vitaly Kuznetsov wrote:
> Robert Hoo <robert.hu@linux.intel.com> writes:
> 
[...]
> >  
> >  /*
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 47b8357..12a926e 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -2376,6 +2376,7 @@ static __init int setup_vmcs_config(struct
> > vmcs_config *vmcs_conf,
> >  	u32 _pin_based_exec_control = 0;
> >  	u32 _cpu_based_exec_control = 0;
> >  	u32 _cpu_based_2nd_exec_control = 0;
> > +	u64 _cpu_based_3rd_exec_control = 0;
> >  	u32 _vmexit_control = 0;
> >  	u32 _vmentry_control = 0;
> >  
> > @@ -2397,7 +2398,8 @@ static __init int setup_vmcs_config(struct
> > vmcs_config *vmcs_conf,
> >  
> >  	opt = CPU_BASED_TPR_SHADOW |
> >  	      CPU_BASED_USE_MSR_BITMAPS |
> > -	      CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
> > +	      CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |
> > +	      CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
> >  	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_PROCBASED_CTLS,
> >  				&_cpu_based_exec_control) < 0)
> >  		return -EIO;
> > @@ -2557,6 +2559,7 @@ static __init int setup_vmcs_config(struct
> > vmcs_config *vmcs_conf,
> >  	vmcs_conf->pin_based_exec_ctrl = _pin_based_exec_control;
> >  	vmcs_conf->cpu_based_exec_ctrl = _cpu_based_exec_control;
> >  	vmcs_conf->cpu_based_2nd_exec_ctrl =
> > _cpu_based_2nd_exec_control;
> > +	vmcs_conf->cpu_based_3rd_exec_ctrl =
> > _cpu_based_3rd_exec_control;
> >  	vmcs_conf->vmexit_ctrl         = _vmexit_control;
> >  	vmcs_conf->vmentry_ctrl        = _vmentry_control;
> >  
> > @@ -4200,6 +4203,12 @@ u32 vmx_exec_control(struct vcpu_vmx *vmx)
> >  #define vmx_adjust_sec_exec_exiting(vmx, exec_control, lname,
> > uname) \
> >  	vmx_adjust_sec_exec_control(vmx, exec_control, lname, uname,
> > uname##_EXITING, true)
> >  
> > +static u64 vmx_tertiary_exec_control(struct vcpu_vmx *vmx)
> > +{
> > +	/* Though currently, no special adjustment. There might be in
> > the future*/
> > +	return vmcs_config.cpu_based_3rd_exec_ctrl;
> > +}
> > +
> >  static void vmx_compute_secondary_exec_control(struct vcpu_vmx
> > *vmx)
> >  {
> >  	struct kvm_vcpu *vcpu = &vmx->vcpu;
> > @@ -4310,6 +4319,9 @@ static void init_vmcs(struct vcpu_vmx *vmx)
> >  		secondary_exec_controls_set(vmx, vmx-
> > >secondary_exec_control);
> >  	}
> >  
> > +	if (cpu_has_tertiary_exec_ctrls())
> > +		tertiary_exec_controls_set(vmx,
> > vmx_tertiary_exec_control(vmx));
> > +
> >  	if (kvm_vcpu_apicv_active(&vmx->vcpu)) {
> >  		vmcs_write64(EOI_EXIT_BITMAP0, 0);
> >  		vmcs_write64(EOI_EXIT_BITMAP1, 0);
> > @@ -5778,6 +5790,7 @@ void dump_vmcs(void)
> >  {
> >  	u32 vmentry_ctl, vmexit_ctl;
> >  	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl,
> > secondary_exec_control;
> > +	u64 tertiary_exec_control = 0;
> >  	unsigned long cr4;
> >  	u64 efer;
> >  
> > @@ -5796,6 +5809,9 @@ void dump_vmcs(void)
> >  	if (cpu_has_secondary_exec_ctrls())
> >  		secondary_exec_control =
> > vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
> >  
> > +	if (cpu_has_tertiary_exec_ctrls())
> > +		tertiary_exec_control =
> > vmcs_read64(TERTIARY_VM_EXEC_CONTROL);
> 
> We'll have to do something about Enlightened VMCS I believe. In
> theory,
> when eVMCS is in use, 'CPU_BASED_ACTIVATE_TERTIARY_CONTROLS' should
> not
> be exposed, e.g. when KVM hosts a EVMCS enabled guest the control
> should
> be filtered out. Something like (completely untested):
> 
> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> index 41f24661af04..c44ff05f3235 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -299,6 +299,7 @@ const unsigned int nr_evmcs_1_fields =
> ARRAY_SIZE(vmcs_field_to_evmcs_1);
>  
>  __init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf)
>  {
> +       vmcs_conf->cpu_based_exec_ctrl &=
> ~EVMCS1_UNSUPPORTED_EXEC_CTRL;
>         vmcs_conf->pin_based_exec_ctrl &=
> ~EVMCS1_UNSUPPORTED_PINCTRL;
>         vmcs_conf->cpu_based_2nd_exec_ctrl &=
> ~EVMCS1_UNSUPPORTED_2NDEXEC;
>  
> diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
> index bd41d9462355..bf2c5e7a4a8f 100644
> --- a/arch/x86/kvm/vmx/evmcs.h
> +++ b/arch/x86/kvm/vmx/evmcs.h
> @@ -50,6 +50,7 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
>   */
>  #define EVMCS1_UNSUPPORTED_PINCTRL (PIN_BASED_POSTED_INTR | \
>                                     PIN_BASED_VMX_PREEMPTION_TIMER)
> +#define EVMCS1_UNSUPPORTED_EXEC_CTRL
> (CPU_BASED_ACTIVATE_TERTIARY_CONTROLS)
>  #define
> EVMCS1_UNSUPPORTED_2NDEXEC                                     \
>         (SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY
> |                         \
>          SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES
> |                      \
> 
> should do the job I think.

Agree, until L0 HyperV supports the new tertiary control, L1 KVM shall
not expose it to its guests. Thanks Vitaly pointing out, and with
detailed explanation.

BTW, when would enlightened VMCS support VMCS Tertiary Control and Key
Locker feature?
> 
> > +
> >  	pr_err("*** Guest State ***\n");
> >  	pr_err("CR0: actual=0x%016lx, shadow=0x%016lx,
> > gh_mask=%016lx\n",
> >  	       vmcs_readl(GUEST_CR0), vmcs_readl(CR0_READ_SHADOW),
> > @@ -5878,8 +5894,9 @@ void dump_vmcs(void)
> >  		       vmcs_read64(HOST_IA32_PERF_GLOBAL_CTRL));
> >  
> >  	pr_err("*** Control State ***\n");
> > -	pr_err("PinBased=%08x CPUBased=%08x SecondaryExec=%08x\n",
> > -	       pin_based_exec_ctrl, cpu_based_exec_ctrl,
> > secondary_exec_control);
> > +	pr_err("PinBased=0x%08x CPUBased=0x%08x SecondaryExec=0x%08x
> > TertiaryExec=0x%016llx\n",
> > +	       pin_based_exec_ctrl, cpu_based_exec_ctrl,
> > secondary_exec_control,
> > +	       tertiary_exec_control);
> >  	pr_err("EntryControls=%08x ExitControls=%08x\n", vmentry_ctl,
> > vmexit_ctl);
> >  	pr_err("ExceptionBitmap=%08x PFECmask=%08x PFECmatch=%08x\n",
> >  	       vmcs_read32(EXCEPTION_BITMAP),
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index f6f66e5..94f1c27 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -373,6 +373,14 @@ static inline u8 vmx_get_rvi(void)
> >  BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL)
> >  BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL)
> >  
> > +static inline void tertiary_exec_controls_set(struct vcpu_vmx
> > *vmx, u64 val)
> > +{
> > +	if (vmx->loaded_vmcs->controls_shadow.tertiary_exec != val) {
> > +		vmcs_write64(TERTIARY_VM_EXEC_CONTROL, val);
> > +		vmx->loaded_vmcs->controls_shadow.tertiary_exec = val;
> > +	}
> > +}
> > +
> >  static inline void vmx_register_cache_reset(struct kvm_vcpu *vcpu)
> >  {
> >  	vcpu->arch.regs_avail = ~((1 << VCPU_REGS_RIP) | (1 <<
> > VCPU_REGS_RSP)
> 
> 

