Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AA71AAFFC
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 19:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411446AbgDORnt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 13:43:49 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:52289 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411437AbgDORnq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 13:43:46 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jOm4K-0007zn-AM; Wed, 15 Apr 2020 19:43:24 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id B228C100C47; Wed, 15 Apr 2020 19:43:22 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v8 4/4] kvm: vmx: virtualize split lock detection
In-Reply-To: <20200414063129.133630-5-xiaoyao.li@intel.com>
Date:   Wed, 15 Apr 2020 19:43:22 +0200
Message-ID: <871rooodad.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Xiaoyao Li <xiaoyao.li@intel.com> writes:
> +/*
> + * Note: for guest, feature split lock detection can only be enumerated through
> + * MSR_IA32_CORE_CAPABILITIES bit. The FMS enumeration is unsupported.

That comment is confusing at best.

> + */
> +static inline bool guest_cpu_has_feature_sld(struct kvm_vcpu *vcpu)
> +{
> +	return vcpu->arch.core_capabilities &
> +	       MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT;
> +}
> +
> +static inline bool guest_cpu_sld_on(struct vcpu_vmx *vmx)
> +{
> +	return vmx->msr_test_ctrl & MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
> +}
> +
> +static inline void vmx_update_sld(struct kvm_vcpu *vcpu, bool on)
> +{
> +	/*
> +	 * Toggle SLD if the guest wants it enabled but its been disabled for
> +	 * the userspace VMM, and vice versa.  Note, TIF_SLD is true if SLD has
> +	 * been turned off.  Yes, it's a terrible name.

Instead of writing that useless blurb you could have written a patch
which changes TIF_SLD to TIF_SLD_OFF to make it clear.

> +	 */
> +	if (sld_state == sld_warn && guest_cpu_has_feature_sld(vcpu) &&
> +	    on == test_thread_flag(TIF_SLD)) {
> +		    sld_update_msr(on);
> +		    update_thread_flag(TIF_SLD, !on);

Of course you completely fail to explain why TIF_SLD needs to be fiddled
with.

> @@ -1188,6 +1217,10 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>  #endif
>
> 	vmx_set_host_fs_gs(host_state, fs_sel, gs_sel, fs_base, gs_base);
> +
> +	vmx->host_sld_on = !test_thread_flag(TIF_SLD);

This inverted storage is non-intuitive. What's wrong with simply
reflecting the TIF_SLD state?

> +	vmx_update_sld(vcpu, guest_cpu_sld_on(vmx));
> +
>	vmx->guest_state_loaded = true;
> }
>
> @@ -1226,6 +1259,9 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
> 	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
>  #endif
> 	load_fixmap_gdt(raw_smp_processor_id());
> +
> +	vmx_update_sld(&vmx->vcpu, vmx->host_sld_on);
> +

vmx_prepare_switch_to_guest() is called via:

kvm_arch_vcpu_ioctl_run()
  vcpu_run()
    vcpu_enter_guest()
      preempt_disable();
      kvm_x86_ops.prepare_guest_switch(vcpu);

but vmx_prepare_switch_to_host() is invoked at the very end of:

kvm_arch_vcpu_ioctl_run()
  .....
  vcpu_run()
  .....
  vcpu_put()
    vmx_vcpu_put()
      vmx_prepare_switch_to_host();

That asymmetry does not make any sense without an explanation.

What's even worse is that vmx_prepare_switch_to_host() is invoked with
preemption enabled, so MSR state and TIF_SLD state can get out of sync
on preemption/migration.

> @@ -1946,9 +1992,15 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 
> 	switch (msr_index) {
> 	case MSR_TEST_CTRL:
> -		if (data)
> +		if (data & ~vmx_msr_test_ctrl_valid_bits(vcpu))
> 			return 1;
> 
> +		vmx->msr_test_ctrl = data;
> +
> +		preempt_disable();

This preempt_disable/enable() lacks explanation as well.

> +		if (vmx->guest_state_loaded)
> +			vmx_update_sld(vcpu, guest_cpu_sld_on(vmx));
> +		preempt_enable();

How is updating msr_test_ctrl valid if this is invoked from the IOCTL,
i.e. host_initiated == true?

That said, I also hate the fact that you export both the low level MSR
function _and_ the state variable. Having all these details including the
TIF mangling in the VMX code is just wrong.

Thanks,

        tglx
