Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8FF67F0F3
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 23:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjA0WL2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 17:11:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbjA0WL0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 17:11:26 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837F28324F
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 14:11:18 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id x2-20020a17090a46c200b002295ca9855aso9979608pjg.2
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 14:11:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=r60cFDeeS84qWFf+ONIXpZq61TeOlJUzT41ci/Cxlkc=;
        b=JPy3YXyPUXW9Mkdgv8PQw5yg/Zcplc4btlevXYcriy3XpsS8ltKODcDR9nS33O9bGS
         hi5oxPekw5K7FlDyEGmhF01xjIJ94sIo1KwNNLEB/2nIMLOCoPaolyZaKu6+sT2LltAW
         kmIKrj5ZU4JNTO7jNJvixpfWkeUz2AldgkgVZ/7GJGHT6gvI0gm61zfqMjt11tscwpwL
         ztemOmkzkW/w7408Cq6AqAI4HkZsjRml7o/dAj8QMZZ2RPHRCQeeUqem5jAj0PHWB5cu
         PFYqFXZ9FrwV4Ghm0LrJ8+cE7ujW2B2WDOA5+/T3WG8FrtskoJEFYjxNq+E5Z17JqNoA
         Xc0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r60cFDeeS84qWFf+ONIXpZq61TeOlJUzT41ci/Cxlkc=;
        b=aA8VHCANml9feUH29/QTdYXiMbIv3cGwmgTt9I6l9vJ3dyOc/YN/RnP552R1+S3owd
         WHTqbUbueiIMmG5EXXxf3fS9ucyLVr4avZStf16EsRFtVmdvTRGccyYnXIPD2fH7lHbw
         4mc8roXq8dMRGYOeO7SOmfmmoHfmr7+2oGcN0DLwRgJtvy4+E76rLRv0xVD53bFRfGu1
         hAW3mUZ4TarxFeVzOdLyuYQiZnLQfpyVFSQ7aBfCHvPouIbGl8GxQibRFQxjIk8GrTE+
         s1xG8FqjjC3fQl3P9aT+2w3CCNLR4K33GTTaQSFKXcwGfIxXO034qE3U+F4YzgiU7h1H
         qVaQ==
X-Gm-Message-State: AO0yUKXpHBCPXFSVKlz9YruqSJWlk1APpM3gcPjG9Ui8CfBnJfvVE8Pu
        Md43TJG1wGznbiB2+OSLHQrWrQ==
X-Google-Smtp-Source: AK7set+2NrsKnDTdOf0kvXoIk5BVDivfmXy8eEHLP0Rh0s1ujxRfC4EdrIaq8cH0R9EDL87F18d3pQ==
X-Received: by 2002:a17:90a:4f07:b0:229:f4e9:75c7 with SMTP id p7-20020a17090a4f0700b00229f4e975c7mr166879pjh.0.1674857477846;
        Fri, 27 Jan 2023 14:11:17 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id iz14-20020a170902ef8e00b0017f73caf588sm3324237plb.218.2023.01.27.14.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 14:11:16 -0800 (PST)
Date:   Fri, 27 Jan 2023 22:11:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, like.xu.linux@gmail.com,
        kan.liang@linux.intel.com, wei.w.wang@intel.com
Subject: Re: [PATCH v2 13/15] KVM: x86/vmx: Save/Restore guest Arch LBR Ctrl
 msr at SMM entry/exit
Message-ID: <Y9RMASMnzc3tPqvO@google.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-14-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125040604.5051-14-weijiang.yang@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 24, 2022, Yang Weijiang wrote:
> Per SDM 3B Chapter 18: "IA32_LBR_CTL.LBREn is saved and cleared on #SMI,
> and restored on RSM", store guest IA32_LBR_CTL in SMRAM and clear LBREn
> in VMCS at SMM entry, and do reverse things at SMM exit.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/smm.c     |  1 +
>  arch/x86/kvm/smm.h     |  3 ++-
>  arch/x86/kvm/vmx/vmx.c | 22 ++++++++++++++++++++++
>  3 files changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
> index a9c1c2af8d94..5987090b440f 100644
> --- a/arch/x86/kvm/smm.c
> +++ b/arch/x86/kvm/smm.c
> @@ -86,6 +86,7 @@ static void check_smram_offsets(void)
>  	CHECK_SMRAM64_OFFSET(smm_revison,		0xFEFC);
>  	CHECK_SMRAM64_OFFSET(smbase,			0xFF00);
>  	CHECK_SMRAM64_OFFSET(reserved4,			0xFF04);
> +	CHECK_SMRAM64_OFFSET(arch_lbr_ctl,		0xFF10);
>  	CHECK_SMRAM64_OFFSET(ssp,			0xFF18);
>  	CHECK_SMRAM64_OFFSET(svm_guest_pat,		0xFF20);
>  	CHECK_SMRAM64_OFFSET(svm_host_efer,		0xFF28);
> diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
> index a1cf2ac5bd78..5a6479205d91 100644
> --- a/arch/x86/kvm/smm.h
> +++ b/arch/x86/kvm/smm.h
> @@ -114,7 +114,8 @@ struct kvm_smram_state_64 {
>  	u32 reserved3[3];
>  	u32 smm_revison;
>  	u32 smbase;
> -	u32 reserved4[5];
> +	u32 reserved4[3];
> +	u64 arch_lbr_ctl;
>  
>  	/* ssp and svm_* fields below are not implemented by KVM */
>  	u64 ssp;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6ad765ea4059..cc782233c075 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8006,11 +8006,21 @@ static int vmx_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram)
>  	vmx->nested.smm.vmxon = vmx->nested.vmxon;
>  	vmx->nested.vmxon = false;
>  	vmx_clear_hlt(vcpu);
> +
> +	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
> +	    guest_cpuid_has(vcpu, X86_FEATURE_LM)) {

Uh, so this arbitrary dependency on 64-bit vCPUs needs to be factored into the
enabling.  And KVM should WARN if arch LBRs get enabled for a 32-bit vCPU.

> +		u64 ctl = vmcs_read64(GUEST_IA32_LBR_CTL);
> +
> +		smram->smram64.arch_lbr_ctl = ctl;
> +		vmcs_write64(GUEST_IA32_LBR_CTL, ctl & ~ARCH_LBR_CTL_LBREN);
> +	}
> +
>  	return 0;
>  }
>  
>  static int vmx_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
>  {
> +	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	int ret;
>  
> @@ -8027,6 +8037,18 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
>  		vmx->nested.nested_run_pending = 1;
>  		vmx->nested.smm.guest_mode = false;
>  	}
> +
> +	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
> +	    guest_cpuid_has(vcpu, X86_FEATURE_LM)) {
> +		u64 ctl = smram->smram64.arch_lbr_ctl;
> +
> +		vmcs_write64(GUEST_IA32_LBR_CTL, ctl & ARCH_LBR_CTL_LBREN);

IIUC, this should set only LBREn and preserve all other bits, not clobber the
entire MSR.

> +
> +		if (intel_pmu_lbr_is_enabled(vcpu) &&
> +		    (ctl & ARCH_LBR_CTL_LBREN) && !lbr_desc->event)
> +			intel_pmu_create_guest_lbr_event(vcpu);
> +	}
> +
>  	return 0;
>  }
>  
> -- 
> 2.27.0
> 
