Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8734577EC1F
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 23:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346621AbjHPVow (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 17:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346659AbjHPVob (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 17:44:31 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149BF273B
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 14:44:27 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5646e695ec1so10509065a12.1
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 14:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692222266; x=1692827066;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7aJZe8+CPSzm1uQ31UW15d4LYpFiin9OTY1YmG5+H2o=;
        b=5FnFmr0h3gjr+/vpDpnpYnX5gIhkCQ4jEG1gSS7nJJAppTjOcaxDoFqgcIXvY7h/d2
         a0Z47gC4syP1XGsTzyh5eMyJLZbwtKk3CUWhffe/MVgdDpWHQAuEIm1I5rQHuRHFYYMf
         nM5zBOKmA3EySxHeLEUE5+NIC03+C0EyBB+5/L0q52W0pvV+wkx34CLyQpHOzOjRnD9B
         jJ4qq54VpzsihbVPJ2cNOpCllRUgbLASkaNsh45bNmQMTg9OBKIZuW9WvD/b/f4VgPWJ
         KHXEETo1KapA27A1ayPOROfeBJdqOYlYOZ/Bl0RzPNZXUGaF2Y9pIpzesy8dGvI7mnjM
         CjXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692222266; x=1692827066;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7aJZe8+CPSzm1uQ31UW15d4LYpFiin9OTY1YmG5+H2o=;
        b=Lxym6xf86jgu7DXXDp60IqoF227cqaDs6CrQgVPqL+fxYRUKe3nZCYi9rkPF+Kf+Oj
         Aiu14ayvr3cQEL81c/XSmuN4Jw21TUZsSPamWjqkD0iAVdkQeCAGD+7gy1GoKfDedEwD
         /p902gnzNGb/dpxhse+1r0D0SaACo3EAXl0Mp9bKkzwn3+y6J++0h69SAeW77VY7ojlq
         T3ZDgONKEsWSHDy1DCXhCmi7mMJK7nPRkgH1PaFYsX/oURUdceM6H4jADANFCFbQbvlf
         Z0cQ+9KTV0k2nM3l1+oVeYrQvLRCLULIIs+cIKyDdhZmjGj0SKsD5D3GwvVkc7wSW8W0
         /T+w==
X-Gm-Message-State: AOJu0YyH+UcrPYxBO1eD/6kP0MD1+H3mUYvXU21jnK/8tncwpPn0UXPm
        YNJWzwNNhSaiY9a8xl+G935XF6A3v5c=
X-Google-Smtp-Source: AGHT+IHQ5b8bXt+vgSEAeURRHYKMC28i0AKm9/yVRY0BGqX1G7iOdGibZ10hhforoeesRKRFiCL3cxRmWJI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:715b:0:b0:567:c791:ce64 with SMTP id
 b27-20020a63715b000000b00567c791ce64mr159671pgn.8.1692222266642; Wed, 16 Aug
 2023 14:44:26 -0700 (PDT)
Date:   Wed, 16 Aug 2023 14:44:24 -0700
In-Reply-To: <20230719144131.29052-6-binbin.wu@linux.intel.com>
Mime-Version: 1.0
References: <20230719144131.29052-1-binbin.wu@linux.intel.com> <20230719144131.29052-6-binbin.wu@linux.intel.com>
Message-ID: <ZN1DOHiIS618oeuY@google.com>
Subject: Re: [PATCH v10 5/9] KVM: x86: Virtualize CR3.LAM_{U48,U57}
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

On Wed, Jul 19, 2023, Binbin Wu wrote:
> Add support to allow guests to set two new CR3 non-address control bits for
> guests to enable the new Intel CPU feature Linear Address Masking (LAM) on user
> pointers.

Same feedback as the LAM_SUP patch.

> ---
>  arch/x86/kvm/cpuid.h   | 3 +++
>  arch/x86/kvm/mmu.h     | 8 ++++++++
>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  arch/x86/kvm/vmx/vmx.c | 3 ++-
>  4 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 8b26d946f3e3..274f41d2250b 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -285,6 +285,9 @@ static __always_inline bool guest_can_use(struct kvm_vcpu *vcpu,
>  
>  static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>  {
> +	if (guest_can_use(vcpu, X86_FEATURE_LAM))
> +		cr3 &= ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
> +
>  	return kvm_vcpu_is_legal_gpa(vcpu, cr3);
>  }
>  
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 92d5a1924fc1..e92395e6b876 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -144,6 +144,14 @@ static inline unsigned long kvm_get_active_pcid(struct kvm_vcpu *vcpu)
>  	return kvm_get_pcid(vcpu, kvm_read_cr3(vcpu));
>  }
>  
> +static inline unsigned long kvm_get_active_cr3_lam_bits(struct kvm_vcpu *vcpu)
> +{
> +	if (!guest_can_use(vcpu, X86_FEATURE_LAM))
> +		return 0;
> +
> +	return kvm_read_cr3(vcpu) & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
> +}
> +
>  static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
>  {
>  	u64 root_hpa = vcpu->arch.mmu->root.hpa;
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ec169f5c7dce..0285536346c1 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3819,7 +3819,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  	hpa_t root;
>  
>  	root_pgd = kvm_mmu_get_guest_pgd(vcpu, mmu);
> -	root_gfn = root_pgd >> PAGE_SHIFT;
> +	root_gfn = (root_pgd & __PT_BASE_ADDR_MASK) >> PAGE_SHIFT;

And as mentioned previously, this should be in the patch that adds __PT_BASE_ADDR_MASK.

>  	if (mmu_check_root(vcpu, root_gfn))
>  		return 1;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a0d6ea87a2d0..bcee5dc3dd0b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3358,7 +3358,8 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>  			update_guest_cr3 = false;
>  		vmx_ept_load_pdptrs(vcpu);
>  	} else {
> -		guest_cr3 = root_hpa | kvm_get_active_pcid(vcpu);
> +		guest_cr3 = root_hpa | kvm_get_active_pcid(vcpu) |
> +		            kvm_get_active_cr3_lam_bits(vcpu);
>  	}
>  
>  	if (update_guest_cr3)
> -- 
> 2.25.1
> 
