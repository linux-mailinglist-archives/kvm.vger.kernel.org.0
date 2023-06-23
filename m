Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2117473C4F7
	for <lists+kvm@lfdr.de>; Sat, 24 Jun 2023 01:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbjFWXxx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 19:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbjFWXxs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 19:53:48 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22A92710
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 16:53:41 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-666e3dad70aso825780b3a.0
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 16:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687564421; x=1690156421;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GZ8//a8k4/ppq4ZcuNZo7A71GBV4B2OsjfDuokwVTXo=;
        b=c59RSbCEPyj90/KW+D5tTFxn2TL2cCfZzqUIIO431a4lQcfvn5qFbiF49tPT18UBmb
         PDW7tk4967hU4Er+q1dXV0VaWLMoVQnqoEx1IQO40kw4MtE8oec3Tmt5kmImoHYLU7Cb
         04Jc6gaDVCeyU3idKtZYtKXNxbXtToPtgm3pMvLmQzJ8iBWoK18s0O9cbpNZ/2pbaXFH
         XKIxaHjkXpv943nX85eBLV2MG69zG58RA235+DrPnQf2ezqeEFPNKeX8y7ewa090jyMY
         aezw1gUrVAMYS4EnSy49lJOtClzvF1aveP4IBxfA1QRVvUk+4fif17u8zUGFSjsgdtB2
         BPqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687564421; x=1690156421;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GZ8//a8k4/ppq4ZcuNZo7A71GBV4B2OsjfDuokwVTXo=;
        b=SV30R7ez4bTD6jyTnM5dBVBOwm7HSzLl8s/XdgzSTOmGy6H+q0QSR2r6ZDSPcZ1RGR
         qf/IUn9MrMgg2OzJI72PriugT3Gtic+CtnTAXeJMwsOPP0vpMd3eh/cciK02lAeNKo3e
         OJaDzAVHk+XWP0tLN3p7gYQM8esfHQmnsWEKMulMzJJDxbY+5MDINznubZsWDEpGxeCu
         F1N3WeL5Vg4Xg2me45gZ3rU4M+OySDqllPEP9YVVl7PYC+ABQHhyNseN6d2o880RlW7a
         4jfy9JhB57+wDqoWBtbvjWR5jZ7KVqIc3nlu2jEpvCdiiaAC+WUPnqd4ycGLymHY0X5p
         05DA==
X-Gm-Message-State: AC+VfDydEFmcM+2+vBZlxJztTlKjWMZOy0pGFVrnX/VQPxIRWB0nazdJ
        mMg0Nam/nNgX5rTGf56t2oTe+Hz7ujQ=
X-Google-Smtp-Source: ACHHUZ6vCcOm23GPYV5TypZFd7kfdJrzsMwKTZimKPcF/b8IZraa0vcbNSbC6Lk2YWT0GE65RMm7dxGpTKg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:234a:b0:668:9181:8e20 with SMTP id
 j10-20020a056a00234a00b0066891818e20mr3352690pfj.1.1687564421125; Fri, 23 Jun
 2023 16:53:41 -0700 (PDT)
Date:   Fri, 23 Jun 2023 16:53:39 -0700
In-Reply-To: <20230511040857.6094-14-weijiang.yang@intel.com>
Mime-Version: 1.0
References: <20230511040857.6094-1-weijiang.yang@intel.com> <20230511040857.6094-14-weijiang.yang@intel.com>
Message-ID: <ZJYwg3Lnq3nJZgQf@google.com>
Subject: Re: [PATCH v3 13/21] KVM:VMX: Emulate reads and writes to CET MSRs
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, john.allen@amd.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 11, 2023, Yang Weijiang wrote:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c872a5aafa50..0ccaa467d7d3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2093,6 +2093,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		else
>  			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
>  		break;
> +	case MSR_IA32_U_CET:
> +	case MSR_IA32_PL3_SSP:
> +		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
> +			return 1;
> +		kvm_get_xsave_msr(msr_info);
> +		break;

Please put as much MSR handling in x86.c as possible.  We quite obviously know
that AMD support is coming along, there's no reason to duplicate all of this code.
And unless I'm missing something, John's series misses several #GP checks, e.g.
for MSR_IA32_S_CET reserved bits, which means that providing a common implementation
would actually fix bugs.

For MSRs that require vendor input and/or handling, please follow what was
recently done for MSR_IA32_CR_PAT, where the common bits are handled in common
code, and vendor code does its updates.

The divergent alignment between AMD and Intel could get annoying, but I'm sure
we can figure out a solution. 

>  	case MSR_IA32_DEBUGCTLMSR:
>  		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
>  		break;
> @@ -2405,6 +2411,18 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		else
>  			vmx->pt_desc.guest.addr_a[index / 2] = data;
>  		break;
> +	case MSR_IA32_U_CET:
> +	case MSR_IA32_PL3_SSP:
> +		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
> +			return 1;
> +		if (is_noncanonical_address(data, vcpu))
> +			return 1;
> +		if (msr_index == MSR_IA32_U_CET && (data & GENMASK(9, 6)))
> +			return 1;
> +		if (msr_index == MSR_IA32_PL3_SSP && (data & GENMASK(2, 0)))

Please #define reserved bits, ideally using the inverse of the valid masks.  And
for SSP, it might be better to do IS_ALIGNED(data, 8) (or 4, pending my question
about the SDM's wording).

Side topic, what on earth does the SDM mean by this?!?

  The linear address written must be aligned to 8 bytes and bits 2:0 must be 0
  (hardware requires bits 1:0 to be 0).

I know Intel retroactively changed the alignment requirements, but the above
is nonsensical.  If ucode prevents writing bits 2:0, who cares what hardware
requires?

> +			return 1;
> +		kvm_set_xsave_msr(msr_info);
> +		break;
>  	case MSR_IA32_PERF_CAPABILITIES:
>  		if (data && !vcpu_to_pmu(vcpu)->version)
>  			return 1;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b6eec9143129..2e3a39c9297c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13630,6 +13630,26 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>  }
>  EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
>  
> +bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu, struct msr_data *msr)
> +{
> +	if (!kvm_cet_user_supported())

This feels wrong.  KVM should differentiate between SHSTK and IBT in the host.
E.g. if running in a VM with SHSTK but not IBT, or vice versa, KVM should allow
writes to non-existent MSRs.  I.e. this looks wrong:

	/*
	 * If SHSTK and IBT are available in KVM, clear CET user bit in
	 * kvm_caps.supported_xss so that kvm_cet_user_supported() returns
	 * false when called.
	 */
	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_USER;

and by extension, all dependent code is also wrong.  IIRC, there's a virtualization
hole, but I don't see any reason why KVM has to make the hole even bigger.

> +		return false;
> +
> +	if (msr->host_initiated)
> +		return true;
> +
> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
> +	    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
> +		return false;
> +
> +	if (msr->index == MSR_IA32_PL3_SSP &&
> +	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))

I probably asked this long ago, but if I did I since forgot.  Is it really just
PL3_SSP that depends on SHSTK?  I would expect all shadow stack MSRs to depend
on SHSTK.

> @@ -546,5 +557,25 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t src, unsigned int bytes,
>  int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>  			 unsigned int port, void *data,  unsigned int count,
>  			 int in);
> +bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu, struct msr_data *msr);
> +
> +/*
> + * We've already loaded guest MSRs in __msr_io() after check the MSR index.

Please avoid pronouns

> + * In case vcpu has been preempted, we need to disable preemption, check

vCPU.  And this doesn't make any sense.  The "vCPU" being preempted doesn't matter,
it's KVM, i.e. the task that's accessing vCPU state that cares about preemption.
I *think* what you're trying to say is that preemption needs to be disabled to
ensure that the guest values are resident.

> + * and reload the guest fpu states before read/write xsaves-managed MSRs.
> + */
> +static inline void kvm_get_xsave_msr(struct msr_data *msr_info)
> +{
> +	fpregs_lock_and_load();

KVM already has helpers that do exactly this, and they have far better names for
KVM: kvm_fpu_get() and kvm_fpu_put().  Can you convert kvm_fpu_get() to
fpregs_lock_and_load() and use those isntead?  And if the extra consistency checks
in fpregs_lock_and_load() fire, we definitely want to know, as it means we probably
have bugs in KVM.
