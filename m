Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCA4375265
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 12:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234490AbhEFKel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 06:34:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48294 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234444AbhEFKel (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 06:34:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620297223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dIrauQWKrgKlJ2IkBx9XuRlcsIVoZXgHnV4iQtHeuIc=;
        b=MswXTCmnBm2jYKr4eqOQnrKNKSX7xiPm07OpO0vKauIpIVw1i20tB3xa6kJ8XMaEigneeH
        j0oGPb3gXm7U1ABhymwz9i62bhqkdg8M9kyw5I/2b2cFjQSavkYfhhha2jxXOVbhU0Z4Ql
        /5ugMDQdwWz6nxeMonc9kN80bYInw4w=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-xGZLYX0NMOu8VHt7cCv4lQ-1; Thu, 06 May 2021 06:33:41 -0400
X-MC-Unique: xGZLYX0NMOu8VHt7cCv4lQ-1
Received: by mail-wr1-f71.google.com with SMTP id 4-20020adf91840000b029010d9c088599so2016067wri.10
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 03:33:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dIrauQWKrgKlJ2IkBx9XuRlcsIVoZXgHnV4iQtHeuIc=;
        b=Z+DDNIxTfppTj3mBanHzZMiCrb/ceMIjQp5j2AWgv7R5TxoR1Rw4nCElxAAfSZi31y
         ZvskTefs4l91iJqKgzrYgfCBhs1tGNxs4YlEsedTCU/IRVSTFIcU9WzuWW75uGfH1aO7
         JqCHDyYYFtsqOamYXUyjHb7/l3/yagGs8UcsV2fRk5v6a/t8eR7cuZBEHgWcuKLP5+SM
         OaOCWM8b+x9ME0oMntf/D9o9fKsT/MkA0lytZsZgMMDH0zcHGoNAtd9WVT8M3b8bHrea
         53oAt8p31yRiY/ig1GRwiNRzqgZiH0xqnptlOcQK/Noyv2bEpVqxdzAjPZs18zEuv91h
         tNVA==
X-Gm-Message-State: AOAM5327OX+J/+mZlDxe5YI3im/3Kvy2PXf8Gw75MQwoD25wgJoTYvym
        flU2/yuBqz9DCWskJ+oWhBllzKvkohrbR+GdEIRHkHeRcwfYfq0JO2NPZYN6uNmbuXfuRRRNbPE
        PG6M1FETZe/r3
X-Received: by 2002:a05:6000:1cc:: with SMTP id t12mr4275842wrx.156.1620297220317;
        Thu, 06 May 2021 03:33:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8ioqHO8gRMvGSsg3FHVHgHVtKjHU1Wkx2j/p0e207woS8iH5h7VM09jxqtJ9vux2Z9VU6uA==
X-Received: by 2002:a05:6000:1cc:: with SMTP id t12mr4275827wrx.156.1620297220131;
        Thu, 06 May 2021 03:33:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h14sm4234316wrq.45.2021.05.06.03.33.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 03:33:39 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: x86: Prevent KVM SVM from loading on kernels with
 5-level paging
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210505204221.1934471-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5d8105ec-c350-1988-5aa1-6d3b31e8136c@redhat.com>
Date:   Thu, 6 May 2021 12:33:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210505204221.1934471-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/21 22:42, Sean Christopherson wrote:
> Disallow loading KVM SVM if 5-level paging is supported.  In theory, NPT
> for L1 should simply work, but there unknowns with respect to how the
> guest's MAXPHYADDR will be handled by hardware.
> 
> Nested NPT is more problematic, as running an L1 VMM that is using
> 2-level page tables requires stacking single-entry PDP and PML4 tables in
> KVM's NPT for L2, as there are no equivalent entries in L1's NPT to
> shadow.  Barring hardware magic, for 5-level paging, KVM would need stack
> another layer to handle PML5.
> 
> Opportunistically rename the lm_root pointer, which is used for the
> aforementioned stacking when shadowing 2-level L1 NPT, to pml4_root to
> call out that it's specifically for PML4.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  2 +-
>   arch/x86/kvm/mmu/mmu.c          | 20 ++++++++++----------
>   arch/x86/kvm/svm/svm.c          |  5 +++++
>   3 files changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3e5fc80a35c8..bf35f369b49e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -407,7 +407,7 @@ struct kvm_mmu {
>   	u32 pkru_mask;
>   
>   	u64 *pae_root;
> -	u64 *lm_root;
> +	u64 *pml4_root;
>   
>   	/*
>   	 * check zero bits on shadow page table entries, these
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 930ac8a7e7c9..04c869794ab3 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3310,12 +3310,12 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>   	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL) {
>   		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
>   
> -		if (WARN_ON_ONCE(!mmu->lm_root)) {
> +		if (WARN_ON_ONCE(!mmu->pml4_root)) {
>   			r = -EIO;
>   			goto out_unlock;
>   		}
>   
> -		mmu->lm_root[0] = __pa(mmu->pae_root) | pm_mask;
> +		mmu->pml4_root[0] = __pa(mmu->pae_root) | pm_mask;
>   	}
>   
>   	for (i = 0; i < 4; ++i) {
> @@ -3335,7 +3335,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>   	}
>   
>   	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL)
> -		mmu->root_hpa = __pa(mmu->lm_root);
> +		mmu->root_hpa = __pa(mmu->pml4_root);
>   	else
>   		mmu->root_hpa = __pa(mmu->pae_root);
>   
> @@ -3350,7 +3350,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>   static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_mmu *mmu = vcpu->arch.mmu;
> -	u64 *lm_root, *pae_root;
> +	u64 *pml4_root, *pae_root;
>   
>   	/*
>   	 * When shadowing 32-bit or PAE NPT with 64-bit NPT, the PML4 and PDP
> @@ -3369,14 +3369,14 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
>   	if (WARN_ON_ONCE(mmu->shadow_root_level != PT64_ROOT_4LEVEL))
>   		return -EIO;
>   
> -	if (mmu->pae_root && mmu->lm_root)
> +	if (mmu->pae_root && mmu->pml4_root)
>   		return 0;
>   
>   	/*
>   	 * The special roots should always be allocated in concert.  Yell and
>   	 * bail if KVM ends up in a state where only one of the roots is valid.
>   	 */
> -	if (WARN_ON_ONCE(!tdp_enabled || mmu->pae_root || mmu->lm_root))
> +	if (WARN_ON_ONCE(!tdp_enabled || mmu->pae_root || mmu->pml4_root))
>   		return -EIO;
>   
>   	/*
> @@ -3387,14 +3387,14 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
>   	if (!pae_root)
>   		return -ENOMEM;
>   
> -	lm_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
> -	if (!lm_root) {
> +	pml4_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
> +	if (!pml4_root) {
>   		free_page((unsigned long)pae_root);
>   		return -ENOMEM;
>   	}
>   
>   	mmu->pae_root = pae_root;
> -	mmu->lm_root = lm_root;
> +	mmu->pml4_root = pml4_root;
>   
>   	return 0;
>   }
> @@ -5261,7 +5261,7 @@ static void free_mmu_pages(struct kvm_mmu *mmu)
>   	if (!tdp_enabled && mmu->pae_root)
>   		set_memory_encrypted((unsigned long)mmu->pae_root, 1);
>   	free_page((unsigned long)mmu->pae_root);
> -	free_page((unsigned long)mmu->lm_root);
> +	free_page((unsigned long)mmu->pml4_root);
>   }
>   
>   static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 14ff7f0963e9..d29dfe4a6503 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -447,6 +447,11 @@ static int has_svm(void)
>   		return 0;
>   	}
>   
> +	if (pgtable_l5_enabled()) {
> +		pr_info("KVM doesn't yet support 5-level paging on AMD SVM\n");
> +		return 0;
> +	}
> +
>   	return 1;
>   }
>   
> 

Queued, thanks.

Paolo

