Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04EE50D0D3
	for <lists+kvm@lfdr.de>; Sun, 24 Apr 2022 11:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236341AbiDXJhk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Apr 2022 05:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236334AbiDXJh1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Apr 2022 05:37:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 83F49205C7
        for <kvm@vger.kernel.org>; Sun, 24 Apr 2022 02:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650792865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kSIpLejv7h+Qh7GF1vX9N5MH/EeI/nqqXVhbiI5Iaao=;
        b=PGy1DY1vliCY9oDyRVa3SeFyGRjf0ezu1ok41Q6sbkaVVzqE2O8cXZ2B/Ajnr6XcycDcAI
        68F/o4TL+yDSc8iYS+OPwKWttK76leIxGWa1WnI1BIru7/+8hq+M1OpiCnxxH5YSTtPJIH
        eVtrrmtWKNlSHIxYPnRDzHnTLyRJm8Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-u0DT-vpdOgay35q41ALOKg-1; Sun, 24 Apr 2022 05:34:20 -0400
X-MC-Unique: u0DT-vpdOgay35q41ALOKg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFD013806729;
        Sun, 24 Apr 2022 09:34:19 +0000 (UTC)
Received: from starship (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B45F145BEF9;
        Sun, 24 Apr 2022 09:34:17 +0000 (UTC)
Message-ID: <2327614a18d60a5e1b0d9d3aed754cccebce3117.camel@redhat.com>
Subject: Re: [PATCH v2 11/11] KVM: SVM: Drop support for CPUs without NRIPS
 (NextRIP Save) support
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Date:   Sun, 24 Apr 2022 12:34:16 +0300
In-Reply-To: <20220423021411.784383-12-seanjc@google.com>
References: <20220423021411.784383-1-seanjc@google.com>
         <20220423021411.784383-12-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-04-23 at 02:14 +0000, Sean Christopherson wrote:
> Drop support for CPUs without NRIPS along with the associated module
> param.  Requiring NRIPS simplifies a handful of paths in KVM, especially
> paths where KVM has to do silly things when nrips=false but supported in
> hardware as there is no way to tell the CPU _not_ to use NRIPS.
> 
> NRIPS was introduced in 2009, i.e. every AMD-based CPU released in the
> last decade should support NRIPS.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Not-signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/nested.c                     |  9 +--
>  arch/x86/kvm/svm/svm.c                        | 77 +++++++------------
>  .../kvm/x86_64/svm_nested_soft_inject_test.c  |  6 +-
>  3 files changed, 32 insertions(+), 60 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index a83e367ade54..f39c958c77f5 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -681,14 +681,13 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  	/*
>  	 * next_rip is consumed on VMRUN as the return address pushed on the
>  	 * stack for injected soft exceptions/interrupts.  If nrips is exposed
> -	 * to L1, take it verbatim from vmcb12.  If nrips is supported in
> -	 * hardware but not exposed to L1, stuff the actual L2 RIP to emulate
> -	 * what a nrips=0 CPU would do (L1 is responsible for advancing RIP
> -	 * prior to injecting the event).
> +	 * to L1, take it verbatim from vmcb12.  If nrips is not exposed to L1,
> +	 * stuff the actual L2 RIP to emulate what an nrips=0 CPU would do (L1
> +	 * is responsible for advancing RIP prior to injecting the event).
>  	 */
>  	if (svm->nrips_enabled)
>  		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
> -	else if (boot_cpu_has(X86_FEATURE_NRIPS))
> +	else
>  		vmcb02->control.next_rip    = vmcb12_rip;
>  
>  	if (is_evtinj_soft(vmcb02->control.event_inj)) {
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 4a912623b961..6e6530c01e34 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -162,10 +162,6 @@ module_param_named(npt, npt_enabled, bool, 0444);
>  static int nested = true;
>  module_param(nested, int, S_IRUGO);
>  
> -/* enable/disable Next RIP Save */
> -static int nrips = true;
> -module_param(nrips, int, 0444);
> -
>  /* enable/disable Virtual VMLOAD VMSAVE */
>  static int vls = true;
>  module_param(vls, int, 0444);
> @@ -355,10 +351,8 @@ static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
>  	if (sev_es_guest(vcpu->kvm))
>  		goto done;
>  
> -	if (nrips && svm->vmcb->control.next_rip != 0) {
> -		WARN_ON_ONCE(!static_cpu_has(X86_FEATURE_NRIPS));
> +	if (svm->vmcb->control.next_rip != 0)
>  		svm->next_rip = svm->vmcb->control.next_rip;
> -	}
>  
>  	if (!svm->next_rip) {
>  		if (unlikely(!commit_side_effects))
> @@ -394,15 +388,14 @@ static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
>  	 * Due to architectural shortcomings, the CPU doesn't always provide
>  	 * NextRIP, e.g. if KVM intercepted an exception that occurred while
>  	 * the CPU was vectoring an INTO/INT3 in the guest.  Temporarily skip
> -	 * the instruction even if NextRIP is supported to acquire the next
> -	 * RIP so that it can be shoved into the NextRIP field, otherwise
> -	 * hardware will fail to advance guest RIP during event injection.
> -	 * Drop the exception/interrupt if emulation fails and effectively
> -	 * retry the instruction, it's the least awful option.  If NRIPS is
> -	 * in use, the skip must not commit any side effects such as clearing
> -	 * the interrupt shadow or RFLAGS.RF.
> +	 * the instruction to acquire the next RIP so that it can be shoved
> +	 * into the NextRIP field, otherwise hardware will fail to advance
> +	 * guest RIP during event injection.  Drop the exception/interrupt if
> +	 * emulation fails and effectively retry the instruction, it's the
> +	 * least awful option.  The skip must not commit any side effects such
> +	 * as clearing the interrupt shadow or RFLAGS.RF.
>  	 */
> -	if (!__svm_skip_emulated_instruction(vcpu, !nrips))
> +	if (!__svm_skip_emulated_instruction(vcpu, false))
>  		return -EIO;
>  
>  	rip = kvm_rip_read(vcpu);
> @@ -421,11 +414,9 @@ static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
>  	svm->soft_int_old_rip = old_rip;
>  	svm->soft_int_next_rip = rip;
>  
> -	if (nrips)
> -		kvm_rip_write(vcpu, old_rip);
> +	kvm_rip_write(vcpu, old_rip);
>  
> -	if (static_cpu_has(X86_FEATURE_NRIPS))
> -		svm->vmcb->control.next_rip = rip;
> +	svm->vmcb->control.next_rip = rip;
>  
>  	return 0;
>  }
> @@ -3732,28 +3723,16 @@ static void svm_complete_soft_interrupt(struct kvm_vcpu *vcpu, u8 vector,
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
>  	/*
> -	 * If NRIPS is enabled, KVM must snapshot the pre-VMRUN next_rip that's
> -	 * associated with the original soft exception/interrupt.  next_rip is
> -	 * cleared on all exits that can occur while vectoring an event, so KVM
> -	 * needs to manually set next_rip for re-injection.  Unlike the !nrips
> -	 * case below, this needs to be done if and only if KVM is re-injecting
> -	 * the same event, i.e. if the event is a soft exception/interrupt,
> -	 * otherwise next_rip is unused on VMRUN.
> +	 * KVM must snapshot the pre-VMRUN next_rip that's associated with the
> +	 * original soft exception/interrupt.  next_rip is cleared on all exits
> +	 * that can occur while vectoring an event, so KVM needs to manually
> +	 * set next_rip for re-injection.  This needs to be done if and only if
> +	 * KVM is re-injecting the same event, i.e. if the event is a soft
> +	 * exception/interrupt, otherwise next_rip is unused on VMRUN.
>  	 */
> -	if (nrips && (is_soft || (is_exception && kvm_exception_is_soft(vector))) &&
> +	if ((is_soft || (is_exception && kvm_exception_is_soft(vector))) &&
>  	    kvm_is_linear_rip(vcpu, svm->soft_int_old_rip + svm->soft_int_csbase))
>  		svm->vmcb->control.next_rip = svm->soft_int_next_rip;
> -	/*
> -	 * If NRIPS isn't enabled, KVM must manually advance RIP prior to
> -	 * injecting the soft exception/interrupt.  That advancement needs to
> -	 * be unwound if vectoring didn't complete.  Note, the new event may
> -	 * not be the injected event, e.g. if KVM injected an INTn, the INTn
> -	 * hit a #NP in the guest, and the #NP encountered a #PF, the #NP will
> -	 * be the reported vectored event, but RIP still needs to be unwound.
> -	 */
> -	else if (!nrips && (is_soft || is_exception) &&
> -		 kvm_is_linear_rip(vcpu, svm->soft_int_next_rip + svm->soft_int_csbase))
> -		kvm_rip_write(vcpu, svm->soft_int_old_rip);
>  }
>  
>  static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
> @@ -4112,8 +4091,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  				    boot_cpu_has(X86_FEATURE_XSAVES);
>  
>  	/* Update nrips enabled cache */
> -	svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
> -			     guest_cpuid_has(vcpu, X86_FEATURE_NRIPS);
> +	svm->nrips_enabled = guest_cpuid_has(vcpu, X86_FEATURE_NRIPS);
>  
>  	svm->tsc_scaling_enabled = tsc_scaling && guest_cpuid_has(vcpu, X86_FEATURE_TSCRATEMSR);
>  	svm->lbrv_enabled = lbrv && guest_cpuid_has(vcpu, X86_FEATURE_LBRV);
> @@ -4324,9 +4302,7 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
>  		break;
>  	}
>  
> -	/* TODO: Advertise NRIPS to guest hypervisor unconditionally */
> -	if (static_cpu_has(X86_FEATURE_NRIPS))
> -		vmcb->control.next_rip  = info->next_rip;
> +	vmcb->control.next_rip  = info->next_rip;
>  	vmcb->control.exit_code = icpt_info.exit_code;
>  	vmexit = nested_svm_exit_handled(svm);
>  
> @@ -4859,9 +4835,7 @@ static __init void svm_set_cpu_caps(void)
>  	if (nested) {
>  		kvm_cpu_cap_set(X86_FEATURE_SVM);
>  		kvm_cpu_cap_set(X86_FEATURE_VMCBCLEAN);
> -
> -		if (nrips)
> -			kvm_cpu_cap_set(X86_FEATURE_NRIPS);
> +		kvm_cpu_cap_set(X86_FEATURE_NRIPS);
>  
>  		if (npt_enabled)
>  			kvm_cpu_cap_set(X86_FEATURE_NPT);
> @@ -4908,6 +4882,12 @@ static __init int svm_hardware_setup(void)
>  	int r;
>  	unsigned int order = get_order(IOPM_SIZE);
>  
> +	/* KVM no longer supports CPUs without NextRIP Save support. */
> +	if (!boot_cpu_has(X86_FEATURE_NRIPS)) {
> +		pr_err_ratelimited("NRIPS (NextRIP Save) not supported\n");
> +		return -EOPNOTSUPP;
> +	}
> +
>  	/*
>  	 * NX is required for shadow paging and for NPT if the NX huge pages
>  	 * mitigation is enabled.
> @@ -4989,11 +4969,6 @@ static __init int svm_hardware_setup(void)
>  			goto err;
>  	}
>  
> -	if (nrips) {
> -		if (!boot_cpu_has(X86_FEATURE_NRIPS))
> -			nrips = false;
> -	}
> -
>  	enable_apicv = avic = avic && npt_enabled && (boot_cpu_has(X86_FEATURE_AVIC) || force_avic);
>  
>  	if (enable_apicv) {
> diff --git a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
> index 257aa2280b5c..39a6569715fd 100644
> --- a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
> @@ -106,10 +106,8 @@ int main(int argc, char *argv[])
>  	nested_svm_check_supported();
>  
>  	cpuid = kvm_get_supported_cpuid_entry(0x8000000a);
> -	if (!(cpuid->edx & X86_FEATURE_NRIPS)) {
> -		print_skip("nRIP Save unavailable");
> -		exit(KSFT_SKIP);
> -	}
> +	TEST_ASSERT(cpuid->edx & X86_FEATURE_NRIPS,
> +		    "KVM is supposed to unconditionally advertise nRIP Save\n");
>  
>  	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
>  


The only issue would be IMHO that if (for testing/whatever) you boot a guest without NRIPS,
then the guest won't be able to use SVM
Or in other words, its true that every sane AMD cpu supports NRIPs, but a "nested AMD cpu"
in theory might not.

Best regards,
	Maxim Levitsky




