Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2104C191E3E
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 01:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbgCYAlL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 20:41:11 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46652 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbgCYAlL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 20:41:11 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jGu6I-0000Gg-OE; Wed, 25 Mar 2020 01:40:55 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id DDBF2100C51; Wed, 25 Mar 2020 01:40:53 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Xiaoyao Li <xiaoyao.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, hpa@zytor.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v6 8/8] kvm: vmx: virtualize split lock detection
In-Reply-To: <20200324151859.31068-9-xiaoyao.li@intel.com>
References: <20200324151859.31068-1-xiaoyao.li@intel.com> <20200324151859.31068-9-xiaoyao.li@intel.com>
Date:   Wed, 25 Mar 2020 01:40:53 +0100
Message-ID: <87eethz2p6.fsf@nanos.tec.linutronix.de>
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
>  #ifdef CONFIG_CPU_SUP_INTEL
> +enum split_lock_detect_state {
> +	sld_off = 0,
> +	sld_warn,
> +	sld_fatal,
> +};
> +extern enum split_lock_detect_state sld_state __ro_after_init;
> +
> +static inline bool split_lock_detect_on(void)
> +{
> +	return sld_state != sld_off;
> +}

See previous reply.

> +void sld_msr_set(bool on)
> +{
> +	sld_update_msr(on);
> +}
> +EXPORT_SYMBOL_GPL(sld_msr_set);
> +
> +void sld_turn_back_on(void)
> +{
> +	sld_update_msr(true);
> +	clear_tsk_thread_flag(current, TIF_SLD);
> +}
> +EXPORT_SYMBOL_GPL(sld_turn_back_on);

First of all these functions want to be in a separate patch, but aside
of that they do not make any sense at all.

> +static inline bool guest_cpu_split_lock_detect_on(struct vcpu_vmx *vmx)
> +{
> +	return vmx->msr_test_ctrl & MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
> +}
> +
>  static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -4725,12 +4746,13 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>  	case AC_VECTOR:
>  		/*
>  		 * Reflect #AC to the guest if it's expecting the #AC, i.e. has
> -		 * legacy alignment check enabled.  Pre-check host split lock
> -		 * support to avoid the VMREADs needed to check legacy #AC,
> -		 * i.e. reflect the #AC if the only possible source is legacy
> -		 * alignment checks.
> +		 * legacy alignment check enabled or split lock detect enabled.
> +		 * Pre-check host split lock support to avoid further check of
> +		 * guest, i.e. reflect the #AC if host doesn't enable split lock
> +		 * detection.
>  		 */
>  		if (!split_lock_detect_on() ||
> +		    guest_cpu_split_lock_detect_on(vmx) ||
>  		    guest_cpu_alignment_check_enabled(vcpu)) {

If the host has split lock detection disabled then how is the guest
supposed to have it enabled in the first place?

> @@ -6631,6 +6653,14 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  	 */
>  	x86_spec_ctrl_set_guest(vmx->spec_ctrl, 0);
>  
> +	if (static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) &&
> +	    guest_cpu_split_lock_detect_on(vmx)) {
> +		if (test_thread_flag(TIF_SLD))
> +			sld_turn_back_on();

This is completely inconsistent behaviour. The only way that TIF_SLD is
set is when the host has sld_state == sld_warn and the guest triggered
a split lock #AC.

'warn' means that the split lock event is registered and a printk
emitted and after that the task runs with split lock detection disabled.

It does not matter at all if the task triggered the #AC while in guest
or in host user space mode. Stop claiming that virt is special. The only
special thing about virt is, that it is using a different mechanism to
exit kernel mode. Aside of that from the kernel POV it is completely
irrelevant whether the task triggered the split lock in host user space
or in guest mode.

If the SLD mode is fatal, then the task is killed no matter what.

Please sit down and go through your patches and rethink every single
line instead of sending out yet another half baken and hastily cobbled
together pile.

To be clear, Patch 1 and 2 make sense on their own, so I'm tempted to
pick them up right now, but the rest is going to be 5.8 material no
matter what.

Thanks,

        tglx

