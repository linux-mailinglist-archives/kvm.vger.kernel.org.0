Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3D377EC11
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 23:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346591AbjHPVmN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 17:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346627AbjHPVls (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 17:41:48 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127D82D4A
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 14:41:36 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-58c583f885cso26990327b3.1
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 14:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692222095; x=1692826895;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TsYuTaSOsfwoUfIhRlrKvY32E50+S15G9LijBCHGyrU=;
        b=Jucm9s2GWuF08tuKKlcouSI/r5ZfGZfg4Cf8kO7ENSxpx2LLd2Mccj4JJ/nRYnBp2g
         o52Xy79FlQlvRobKzgaBMdk/udiMgR1loB8R9vm2TpzYJIYP+LfEUCFvpJ2cGWJfzI/L
         MEBpYmdpR0GtbARk3kTRy4s/EN+RJtZHkxc9nzZvZ6IA5zyJdVLtDg21L8qnkUwwrZm9
         Vaqs5HSLtJdQE/HOOVsPhf5trydIU4Ju0dUajd5QVgxcHU80XiaP0oRJhfSSy4f7Me3o
         XNtVY7jzhUVe56QYeYRXad6ZrA5cUYTWXhMbgAGX0KGqDyxoBZEIyUp2xkLt9CAMwgts
         jtKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692222095; x=1692826895;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TsYuTaSOsfwoUfIhRlrKvY32E50+S15G9LijBCHGyrU=;
        b=ODE3Wm0V/c3WM/v6HhmaqlNCiq2blDTTKHr19TYbhMjB1KT2RAcaPRXMY936GI8PU6
         hGHDnhv4aUGjQzJy4x9dAHUGWyVXnjXhQNxH85X3G9e+qZ62s2oihSVimIrmo2WVyBLL
         VsTmkdmJnKqNAJFsBalyepYC/H6vLN+ua/c87A8Pr5kbshah7iRhWCCpjjP9usGvcl5K
         fpWZl2S6mV0IAI/0Zv5KJ9o6Tyym7/kj7O6OQj0ZXpBPN5Ho4iI6//oBBLzLpbPYKK6z
         D5pZ/c3GdQMxHKpmfPGPK2bYRSZMr1GyE3A84CwWTdFWr3hIjRLc9dPmm1sdrrZfdzuW
         WUWg==
X-Gm-Message-State: AOJu0YyaWhSE249C5J5VlYgNEszf43sUD2BfiSZ0CuSiobUU2P3Z2XIe
        JFsBspBdLRkm/tYhJsZnFouIkbvQ9tM=
X-Google-Smtp-Source: AGHT+IEiKexpH65z/3ob4P3GzM4VmLMOzuc++j2jgqrwf3M6ZzbavNQxJ65hw7yzlCAttFXohCNW7FMqdMw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4524:0:b0:58c:74ec:3394 with SMTP id
 s36-20020a814524000000b0058c74ec3394mr47263ywa.5.1692222095367; Wed, 16 Aug
 2023 14:41:35 -0700 (PDT)
Date:   Wed, 16 Aug 2023 14:41:33 -0700
In-Reply-To: <20230719144131.29052-5-binbin.wu@linux.intel.com>
Mime-Version: 1.0
References: <20230719144131.29052-1-binbin.wu@linux.intel.com> <20230719144131.29052-5-binbin.wu@linux.intel.com>
Message-ID: <ZN1CjTQ0zWiOxk6j@google.com>
Subject: Re: [PATCH v10 4/9] KVM: x86: Virtualize CR4.LAM_SUP
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@aculab.com, robert.hu@linux.intel.com,
        guang.zeng@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch doesn't virtualize LAM_SUP, it simply allows the guest to enable
CR4.LAM_SUP (ignoring that that's not possible at this point because KVM will
reject CR4 values that *KVM* doesn't support).

Actually virtualizing LAM_SUP requires the bits from "KVM: VMX: Implement and wire
get_untagged_addr() for LAM".  You can still separate LAM_SUP from LAM_U*, but
these patches should come *after* the get_untagged_addr() hook is added.  The
first of LAM_SUP vs. LAM_U* can then implement vmx_get_untagged_addr(), and simply
return the raw gva in the "other" case.  E.g. if you add LAM_SUP first, the code
can be:

	if (!(gva & BIT_ULL(63))) {
		/* KVM doesn't yet virtualize LAM_U{48,57}. */
		return false;
	} else {
		if (!kvm_is_cr4_bit_set(vcpu, X86_CR4_LAM_SUP))
			return gva;

		lam_bit = kvm_is_cr4_bit_set(vcpu, X86_CR4_LA57) ? 56 : 47;
	}

On Wed, Jul 19, 2023, Binbin Wu wrote:
> From: Robert Hoo <robert.hu@linux.intel.com>
> 
> Add support to allow guests to set the new CR4 control bit for guests to enable
> the new Intel CPU feature Linear Address Masking (LAM) on supervisor pointers.
> 
> LAM modifies the checking that is applied to 64-bit linear addresses, allowing
> software to use of the untranslated address bits for metadata and masks the
> metadata bits before using them as linear addresses to access memory. LAM uses
> CR4.LAM_SUP (bit 28) to configure LAM for supervisor pointers. LAM also changes
> VMENTER to allow the bit to be set in VMCS's HOST_CR4 and GUEST_CR4 for
> virtualization. Note CR4.LAM_SUP is allowed to be set even not in 64-bit mode,
> but it will not take effect since LAM only applies to 64-bit linear addresses.
> 
> Move CR4.LAM_SUP out of CR4_RESERVED_BITS and its reservation depends on vcpu
> supporting LAM feature or not. Leave the bit intercepted to prevent guest from
> setting CR4.LAM_SUP bit if LAM is not exposed to guest as well as to avoid vmread
> every time when KVM fetches its value, with the expectation that guest won't
> toggle the bit frequently.
> 
> Set CR4.LAM_SUP bit in the emulated IA32_VMX_CR4_FIXED1 MSR for guests to allow
> guests to enable LAM for supervisor pointers in nested VMX operation.
> 
> Hardware is not required to do TLB flush when CR4.LAM_SUP toggled, KVM doesn't
> need to emulate TLB flush based on it.
> There's no other features/vmx_exec_controls connection, no other code needed in
> {kvm,vmx}_set_cr4().
> 
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 3 ++-
>  arch/x86/kvm/vmx/vmx.c          | 3 +++
>  arch/x86/kvm/x86.h              | 2 ++
>  3 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e8e1101a90c8..881a0be862e1 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -125,7 +125,8 @@
>  			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
>  			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
>  			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
> -			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
> +			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
> +			  | X86_CR4_LAM_SUP))
>  
>  #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ae47303c88d7..a0d6ea87a2d0 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7646,6 +7646,9 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
>  	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
>  	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
>  
> +	entry = kvm_find_cpuid_entry_index(vcpu, 0x7, 1);
> +	cr4_fixed1_update(X86_CR4_LAM_SUP,    eax, feature_bit(LAM));
> +
>  #undef cr4_fixed1_update
>  }
>  
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 82e3dafc5453..24e2b56356b8 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -528,6 +528,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
>  		__reserved_bits |= X86_CR4_VMXE;        \
>  	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
>  		__reserved_bits |= X86_CR4_PCIDE;       \
> +	if (!__cpu_has(__c, X86_FEATURE_LAM))           \
> +		__reserved_bits |= X86_CR4_LAM_SUP;     \
>  	__reserved_bits;                                \
>  })
>  
> -- 
> 2.25.1
> 
