Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E8C59C486
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 19:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235725AbiHVRB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 13:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235306AbiHVRBz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 13:01:55 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA0B3CBE4
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 10:01:53 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id m2so10492733pls.4
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 10:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=hISs2+Lj2zz9ocjh89OwJmc05bBvn26H1BdqKuz/c9o=;
        b=NOz0ftgWBUONI4K6xRlOuRT36flqRPmzJBevhTDG7H5UWwyKFRMINFxIpdmfd4u4QI
         CaJiP6wqGLU2LDVGRVz1EwRbz+Ba9rpv5JXI5fZr7VxxA2CBqyD3scB9K9jOID9Ph3Rx
         0dV6+sZUwQjuybtiPFUZh66o+aKLGY9PHr0Ya/h/TmboC0deyk2mkIs1yLguUKQEOka3
         tKvfKKO2cQJT/3OfS9J5fMXMPj8ECZ7c/kr7ZX1ETDKk15j//qPrPcpp2bnY+mEpeSL4
         gjiNC6awGs/OnLdVUJ9f7qkRCUxqCvP8e5uKPOiM4Mz3EEeqKlzHQf8A8eNvGatJHh74
         1G7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=hISs2+Lj2zz9ocjh89OwJmc05bBvn26H1BdqKuz/c9o=;
        b=nVf0pYyuV1qA0i7Hs/Hc35eH874vgkRa7QKamxo3kGcAFp84F95KwPqoHiHUuGZMg4
         lHmTVA2wBQqqHXc3aKaGDbx0GqLWh6xmCPprEMjQE7vBmYzq7QUflyPxCfkdOfSLwrlh
         vxIYMZdyCA3T+vDRt1/KfnhkGb0xT3rw8D0ZwIdlL48RvABCJXxoREBYQZ3CFUDE2N4Z
         uZORZJ37gxgrKXzVFyl0Ue6JW+D0HvFAbA183Avv/AouK0MqRyCOBNIMzGhcD2KmXOLa
         CBkcZAmw87lIanmHdJov0+LYlrBBzYzjq79ZpbMS5PXyggxorjcQyVxJb/r3alw6X+E/
         Gqtw==
X-Gm-Message-State: ACgBeo3gYE/y4LM1kAEq9nS+mfG5bTXOZjSplIDj7dcKtu+axzhC7Rdn
        obmGfL1DlTqRQQWaTukqBtmU7A==
X-Google-Smtp-Source: AA6agR6y6MvImrDfOKpRHaP76KrDOZE2lPG3W4xYzVQy6r86lB96UyXhh1HAfgfxABjIE9OT1hMoCg==
X-Received: by 2002:a17:90b:1c82:b0:1ee:eb41:b141 with SMTP id oo2-20020a17090b1c8200b001eeeb41b141mr24430852pjb.143.1661187713337;
        Mon, 22 Aug 2022 10:01:53 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u64-20020a627943000000b0052c7ff2ac74sm9191026pfc.17.2022.08.22.10.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 10:01:52 -0700 (PDT)
Date:   Mon, 22 Aug 2022 17:01:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 03/26] x86/hyperv: Update 'struct hv_enlightened_vmcs'
 definition
Message-ID: <YwO2fSCGXnE/9mc2@google.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
 <20220802160756.339464-4-vkuznets@redhat.com>
 <Yv5ZFgztDHzzIQJ+@google.com>
 <875yiptvsc.fsf@redhat.com>
 <Yv59dZwP6rNUtsrn@google.com>
 <87czcsskkj.fsf@redhat.com>
 <YwOm7Ph54vIYAllm@google.com>
 <87edx8xn8h.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87edx8xn8h.fsf@redhat.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 22, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Mon, Aug 22, 2022, Vitaly Kuznetsov wrote:
> >> So I reached out to Microsoft and their answer was that for all these new
> >> eVMCS fields (including *PerfGlobalCtrl) observing architectural VMX
> >> MSRs should be enough. *PerfGlobalCtrl case is special because of Win11
> >> bug (if we expose the feature in VMX feature MSRs but don't set
> >> CPUID.0x4000000A.EBX BIT(0) it just doesn't boot).
> >
> > I.e. TSC_SCALING shouldn't be gated on the flag?  If so, then the 2-D array approach
> > is overkill since (a) the CPUID flag only controls PERF_GLOBAL_CTRL and (b) we aren't
> > expecting any more flags in the future.
> >
> 
> Unfortunately, we have to gate the presence of these new features on
> something, otherwise VMM has no way to specify which particular eVMCS
> "revision" it wants (TL;DR: we will break migration).
> 
> My initial implementation was inventing 'eVMCS revision' concept:
> https://lore.kernel.org/kvm/20220629150625.238286-7-vkuznets@redhat.com/
> 
> which is needed if we don't gate all these new fields on CPUID.0x4000000A.EBX BIT(0).
> 
> Going forward, we will still (likely) need something when new fields show up.

My comments from that thread still apply.  Adding "revisions" or feature flags
isn't maintanable, e.g. at best KVM will end up with a ridiculous number of flags.

Looking at QEMU, which I strongly suspect is the only VMM that enables
KVM_CAP_HYPERV_ENLIGHTENED_VMCS, it does the sane thing of enabling the capability
before grabbing the VMX MSRs.

So, why not simply apply filtering for host accesses as well?  E.g.

		/*
		 * New Enlightened VMCS fields always lag behind their hardware
		 * counterparts, filter out fields that are not yet defined.
		 */
		if (vmx->nested.enlightened_vmcs_enabled)
			nested_evmcs_filter_control_msr(vcpu, msr_info);

and then the eVMCS can end up being:

static bool evmcs_has_perf_global_ctrl(struct kvm_vcpu *vcpu)
{
	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);

	/*
	 * PERF_GLOBAL_CTRL is filtered only for guest accesses, and all guest
	 * accesses should be gated on Hyper-V being enabled and initialized.
	 */
	if (WARN_ON_ONCE(!hv_vcpu))
		return false;

	return hv_vcpu->cpuid_cache.nested_ebx & HV_X64_NESTED_EVMCS1_PERF_GLOBAL_CTRL;
}

static u32 evmcs_get_unsupported_ctls(struct kvm_vcpu *vcpu, u32 msr_index,
				      bool host_initiated)
{
	u32 unsupported_ctrls;

	switch (msr_index) {
	case MSR_IA32_VMX_EXIT_CTLS:
	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
		unsupported_ctrls = EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
		if (!host_initiated && !evmcs_has_perf_global_ctrl(vcpu))
			unsupported_ctrls |= VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
		return unsupported_ctrls;
	case MSR_IA32_VMX_ENTRY_CTLS:
	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
		unsupported_ctrls = EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
		if (!host_initiated && !evmcs_has_perf_global_ctrl(vcpu))
			unsupported_ctrls |= VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
		return unsupported_ctrls;
	case MSR_IA32_VMX_PROCBASED_CTLS2:
		return EVMCS1_UNSUPPORTED_2NDEXEC;
	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
	case MSR_IA32_VMX_PINBASED_CTLS:
		return EVMCS1_UNSUPPORTED_PINCTRL;
	case MSR_IA32_VMX_VMFUNC:
		return EVMCS1_UNSUPPORTED_VMFUNC;
	default:
		KVM_BUG_ON(1, vcpu->kvm);
		return 0;
	}
}

void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu,
				     struct msr_data *msr_info)
{
	u64 unsupported_ctrls;
	
	if (!msr_info->host_initiated && !vcpu->arch.hyperv_enabled)
		return;

	unsupported_ctrls = evmcs_get_unsupported_ctls(vcpu, msr_info->index,
						       msr_info->host_initiated);
	if (msr_info->index == MSR_IA32_VMX_VMFUNC)
		msr_info->data &= ~unsupported_ctrls;
	else
		msr_info->data &= ~(unsupported_ctrls << 32);
}

static bool nested_evmcs_is_valid_controls(struct kvm_vcpu *vcpu,
					   u32 msr_index, u32 val)
{
	return val & evmcs_get_unsupported_ctls(vcpu, msr_index, false);
}

