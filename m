Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAB1467F0EA
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 23:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbjA0WJq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 17:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjA0WJp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 17:09:45 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7203D4216
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 14:09:44 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id b10so5899387pjo.1
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 14:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YE+20ePuR5Q/rSYA8Kgx1qIQvuBjNbnsIq3ynDe/WNA=;
        b=lrPE+NQJISKzbSzuSk7SXCzc7j/+D9EpaJD9K7rzwRWNg1kSVQNYFtP1rQ0l84SpST
         rRyMv3exis4Bu4Mpm1x2KAq90VRt3XpaBN+ZNdbAjDbtqUwBa8wvYFUNUuDklKESaE7r
         I8G7soOT/vdp4aGepBWXgqIvgelXysNDiHs6Sx6SzPOSC2P6xo8isrjFK99t4iF0pRgn
         qIg69R5L2CZ5mSGbigoxw2wC+Ryl15wK/J5+DDaSAcyG167+uPY4z7BZWCG5LujUY3I0
         pFtbL+TdJDVbVFk68Wd5jUHG2+6VAtXhfeyeDmiUTxjA+SOVGHAEKefreamLZtNve1Kt
         8MLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YE+20ePuR5Q/rSYA8Kgx1qIQvuBjNbnsIq3ynDe/WNA=;
        b=E/c+aQHQBY2RWmV+/kYUCGE5PBMlH2u2G2RnRd1HtfzypMWQStukgsptV6OZbxraHA
         eqBsxpDlXjdLWvuh8QKJyuIOM5vuEE0C4eQQjVx/JU/Cnzz7nedLPKthHJf3Dh6DZYM6
         5Oh0xobvKpCUku/7TCtvPykKqkC9bL4lmuSXw4NMX4A3vxgSEqZNMe0acGjKb2uh4uyM
         KmcBK9n7khEGQwQMx4L1NfUI6j/iF/om15d0rnzY3iYc6ocruZJSN4ZuLyguwxFJry+5
         Oc13/ZKwhGmiyPUwDcBqhTgZrkYjHs00jCDON0WMyhA5qOeCHtOH1mpOW9Ip0wFtXkah
         XNiw==
X-Gm-Message-State: AO0yUKXnEvUjGz9y0wIV0ZTYCsOavNJRI5Lq+lDFB/+PhVdVcQvDwjCA
        F3hMFq/WGhMBgOL2PhyR+KgGkQ==
X-Google-Smtp-Source: AK7set8qBf7H7/N8KBYOlsoFn/st9/Zevw7PG0vkJYPKrtvPFqWTu5e70qoyxrKgou2jY23lLsL7mQ==
X-Received: by 2002:a05:6a20:3ca8:b0:b8:c859:7fc4 with SMTP id b40-20020a056a203ca800b000b8c8597fc4mr162205pzj.1.1674857383797;
        Fri, 27 Jan 2023 14:09:43 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y12-20020a17090a2b4c00b002293b1aa2b6sm5441275pjc.30.2023.01.27.14.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 14:09:42 -0800 (PST)
Date:   Fri, 27 Jan 2023 22:09:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, like.xu.linux@gmail.com,
        kan.liang@linux.intel.com, wei.w.wang@intel.com
Subject: Re: [PATCH v2 12/15] KVM: x86/vmx: Disable Arch LBREn bit in #DB and
 warm reset
Message-ID: <Y9RLowPBbQFCqLRf@google.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-13-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221125040604.5051-13-weijiang.yang@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 24, 2022, Yang Weijiang wrote:
> Per SDM 3B, Chapter 18:
> “On a debug breakpoint event (#DB), IA32_LBR_CTL.LBREn is cleared.”
> and "On a warm reset, all LBR MSRs, including IA32_LBR_DEPTH, have their
> values preserved. However, IA32_LBR_CTL.LBREn is cleared to 0, disabling
> LBRs.", clear the bit manually before inject #DB or when vCPU is in warm
> reset.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3bc892e8cf7a..6ad765ea4059 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1695,6 +1695,20 @@ static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
>  		vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
>  }
>  
> +static void disable_arch_lbr_ctl(struct kvm_vcpu *vcpu)
> +{
> +	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +
> +	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
> +	    test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use) &&
> +	    lbr_desc->event) {

I don't see any reason to check that an event is actually assigned.  The behavior
is architectural, whether or not KVM is actively exposing LBRs to the guest is
irrelevant.

> +		u64 ctl = vmcs_read64(GUEST_IA32_LBR_CTL);
> +
> +		vmcs_write64(GUEST_IA32_LBR_CTL, ctl & ~ARCH_LBR_CTL_LBREN);
> +	}
> +}
> +
>  static void vmx_inject_exception(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_queued_exception *ex = &vcpu->arch.exception;
> @@ -1738,6 +1752,9 @@ static void vmx_inject_exception(struct kvm_vcpu *vcpu)
>  	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
>  
>  	vmx_clear_hlt(vcpu);
> +
> +	if (ex->vector == DB_VECTOR)
> +		disable_arch_lbr_ctl(vcpu);
>  }
>  
>  static void vmx_setup_uret_msr(struct vcpu_vmx *vmx, unsigned int msr,
> @@ -4796,7 +4813,9 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  
>  	vmx_update_fb_clear_dis(vcpu, vmx);
>  
> -	if (!init_event && cpu_has_vmx_arch_lbr())
> +	if (init_event)

INIT and warm RESET are not the same thing, i.e. this is flat out wrong.

> +		disable_arch_lbr_ctl(vcpu);
> +	else if (cpu_has_vmx_arch_lbr())
>  		vmcs_write64(GUEST_IA32_LBR_CTL, 0);
>  }
>  
> @@ -4873,6 +4892,9 @@ static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
>  			INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK | NMI_VECTOR);
>  
>  	vmx_clear_hlt(vcpu);
> +
> +	if (vcpu->arch.exception.vector == DB_VECTOR)

Huh?  This is _very_ obviously injecting NMIs, not #DBs.

> +		disable_arch_lbr_ctl(vcpu);
>  }
>  
>  bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu)
> -- 
> 2.27.0
> 
