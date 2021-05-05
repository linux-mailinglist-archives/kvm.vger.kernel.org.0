Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B8C373F22
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 18:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbhEEQEE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 12:04:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30342 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233502AbhEEQEC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 12:04:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620230584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1n5eBCPheirTlmkO/V8Dkx+9HIwI6ouJJXoWwQgrT24=;
        b=Yz1atZZ4mXFDCyT5MDDSpXShlmQBqRkZknUHdUZ89lPo9948YdJrTvekIwE47SWggSFF3e
        HAv8T6T5OJYE1i2rIUwZt50tIE8uH70UT8LSxqEuxDdw4u6PryaC3dZ6hUY0COs0lD5NsJ
        ct81No/UkY+t3V7aGr3S7vqRpUyCmdc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-Xp00Ie81P86wGk1NXg0cJw-1; Wed, 05 May 2021 12:03:03 -0400
X-MC-Unique: Xp00Ie81P86wGk1NXg0cJw-1
Received: by mail-wr1-f70.google.com with SMTP id d20-20020adfc3d40000b029010e1a640bbfso871046wrg.21
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 09:03:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1n5eBCPheirTlmkO/V8Dkx+9HIwI6ouJJXoWwQgrT24=;
        b=h1cT9uKqFOgB+lgLii0tXQ6PXK7QliGgcN0fKiTjtoNxHMhom5az+g5g957+zTwD46
         HRg42FvCP7WqdB0orLZ8Ove1BAYbZTjE9jqnilen9V6XB6Jgucsnxhx9OVOZp3HbbAPV
         tSr6KvLNmO2yP2HCESYIl1BaolysSqtuAG8HmftcX7AtL2grMDKMtZNqE3vik8X8PhbD
         QCF+RK1Tr2D6sdCtE28HiT1y1E4eEPQK7j2IyKDxCILlJDMwfBDhZiO0XICo8Y3sT2SW
         SJDBY0tUSdhaJa7BZid1AGbb2d0S3dLT02YO2ILe+8oVVO3cugiHcSwYEXDYQ201dOlJ
         dhww==
X-Gm-Message-State: AOAM531bN0bHHCdBFb6TtA1ZyP+dw493bq5sJwh9Esa631st52rg6LOh
        ksIAbWfgh4sTp/wopUiuBnhbNklfoyDKhLDE11da/vIElYRftoGyO8XOCU/yYHLTvL7JAUoHaoj
        XIM2kU5iCeRop
X-Received: by 2002:a5d:6386:: with SMTP id p6mr38971809wru.36.1620230581735;
        Wed, 05 May 2021 09:03:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx5h2Nhmgyt5a32/b5XL3k/4nl0ybMktVvwzYVFkUPnV2uAcTzu0ZxPk4ltILLR23enPmxrcw==
X-Received: by 2002:a5d:6386:: with SMTP id p6mr38971784wru.36.1620230581465;
        Wed, 05 May 2021 09:03:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d22sm21146171wrc.50.2021.05.05.09.03.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 09:03:01 -0700 (PDT)
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Fix conversion to gfn-based MMU
 notifier callbacks
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Sean Christopherson <seanjc@google.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>
References: <20210505121509.1470207-1-npiggin@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9e0a256b-fb5a-4468-ed21-68d524d6ea56@redhat.com>
Date:   Wed, 5 May 2021 18:02:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210505121509.1470207-1-npiggin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/21 14:15, Nicholas Piggin wrote:
> Commit b1c5356e873c ("KVM: PPC: Convert to the gfn-based MMU notifier
> callbacks") causes unmap_gfn_range and age_gfn callbacks to only work
> on the first gfn in the range. It also makes the aging callbacks call
> into both radix and hash aging functions for radix guests. Fix this.
> 
> Add warnings for the single-gfn calls that have been converted to range
> callbacks, in case they ever receieve ranges greater than 1.
> 
> Fixes: b1c5356e873c ("KVM: PPC: Convert to the gfn-based MMU notifier callbacks")
> Reported-by: Bharata B Rao <bharata@linux.ibm.com>
> Tested-by: Bharata B Rao <bharata@linux.ibm.com>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Sorry for the breakage.  I queued this patch.

Paolo

> ---
> The e500 change in that commit also looks suspicious, why is it okay
> to remove kvm_flush_remote_tlbs() there? Also is the the change from
> returning false to true intended?
> 
> Thanks,
> Nick
> 
>   arch/powerpc/include/asm/kvm_book3s.h  |  2 +-
>   arch/powerpc/kvm/book3s_64_mmu_hv.c    | 46 ++++++++++++++++++--------
>   arch/powerpc/kvm/book3s_64_mmu_radix.c |  5 ++-
>   3 files changed, 36 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
> index a6e9a5585e61..e6b53c6e21e3 100644
> --- a/arch/powerpc/include/asm/kvm_book3s.h
> +++ b/arch/powerpc/include/asm/kvm_book3s.h
> @@ -210,7 +210,7 @@ extern void kvmppc_free_pgtable_radix(struct kvm *kvm, pgd_t *pgd,
>   				      unsigned int lpid);
>   extern int kvmppc_radix_init(void);
>   extern void kvmppc_radix_exit(void);
> -extern bool kvm_unmap_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
> +extern void kvm_unmap_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
>   			    unsigned long gfn);
>   extern bool kvm_age_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
>   			  unsigned long gfn);
> diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> index b7bd9ca040b8..2d9193cd73be 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> @@ -795,7 +795,7 @@ static void kvmppc_unmap_hpte(struct kvm *kvm, unsigned long i,
>   	}
>   }
>   
> -static bool kvm_unmap_rmapp(struct kvm *kvm, struct kvm_memory_slot *memslot,
> +static void kvm_unmap_rmapp(struct kvm *kvm, struct kvm_memory_slot *memslot,
>   			    unsigned long gfn)
>   {
>   	unsigned long i;
> @@ -829,15 +829,21 @@ static bool kvm_unmap_rmapp(struct kvm *kvm, struct kvm_memory_slot *memslot,
>   		unlock_rmap(rmapp);
>   		__unlock_hpte(hptep, be64_to_cpu(hptep[0]));
>   	}
> -	return false;
>   }
>   
>   bool kvm_unmap_gfn_range_hv(struct kvm *kvm, struct kvm_gfn_range *range)
>   {
> -	if (kvm_is_radix(kvm))
> -		return kvm_unmap_radix(kvm, range->slot, range->start);
> +	gfn_t gfn;
> +
> +	if (kvm_is_radix(kvm)) {
> +		for (gfn = range->start; gfn < range->end; gfn++)
> +			kvm_unmap_radix(kvm, range->slot, gfn);
> +	} else {
> +		for (gfn = range->start; gfn < range->end; gfn++)
> +			kvm_unmap_rmapp(kvm, range->slot, range->start);
> +	}
>   
> -	return kvm_unmap_rmapp(kvm, range->slot, range->start);
> +	return false;
>   }
>   
>   void kvmppc_core_flush_memslot_hv(struct kvm *kvm,
> @@ -924,10 +930,18 @@ static bool kvm_age_rmapp(struct kvm *kvm, struct kvm_memory_slot *memslot,
>   
>   bool kvm_age_gfn_hv(struct kvm *kvm, struct kvm_gfn_range *range)
>   {
> -	if (kvm_is_radix(kvm))
> -		kvm_age_radix(kvm, range->slot, range->start);
> +	gfn_t gfn;
> +	bool ret = false;
>   
> -	return kvm_age_rmapp(kvm, range->slot, range->start);
> +	if (kvm_is_radix(kvm)) {
> +		for (gfn = range->start; gfn < range->end; gfn++)
> +			ret |= kvm_age_radix(kvm, range->slot, gfn);
> +	} else {
> +		for (gfn = range->start; gfn < range->end; gfn++)
> +			ret |= kvm_age_rmapp(kvm, range->slot, gfn);
> +	}
> +
> +	return ret;
>   }
>   
>   static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_memory_slot *memslot,
> @@ -965,18 +979,24 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_memory_slot *memslot,
>   
>   bool kvm_test_age_gfn_hv(struct kvm *kvm, struct kvm_gfn_range *range)
>   {
> -	if (kvm_is_radix(kvm))
> -		kvm_test_age_radix(kvm, range->slot, range->start);
> +	WARN_ON(range->start + 1 != range->end);
>   
> -	return kvm_test_age_rmapp(kvm, range->slot, range->start);
> +	if (kvm_is_radix(kvm))
> +		return kvm_test_age_radix(kvm, range->slot, range->start);
> +	else
> +		return kvm_test_age_rmapp(kvm, range->slot, range->start);
>   }
>   
>   bool kvm_set_spte_gfn_hv(struct kvm *kvm, struct kvm_gfn_range *range)
>   {
> +	WARN_ON(range->start + 1 != range->end);
> +
>   	if (kvm_is_radix(kvm))
> -		return kvm_unmap_radix(kvm, range->slot, range->start);
> +		kvm_unmap_radix(kvm, range->slot, range->start);
> +	else
> +		kvm_unmap_rmapp(kvm, range->slot, range->start);
>   
> -	return kvm_unmap_rmapp(kvm, range->slot, range->start);
> +	return false;
>   }
>   
>   static int vcpus_running(struct kvm *kvm)
> diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> index ec4f58fa9f5a..d909c069363e 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> @@ -993,7 +993,7 @@ int kvmppc_book3s_radix_page_fault(struct kvm_vcpu *vcpu,
>   }
>   
>   /* Called with kvm->mmu_lock held */
> -bool kvm_unmap_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
> +void kvm_unmap_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
>   		     unsigned long gfn)
>   {
>   	pte_t *ptep;
> @@ -1002,14 +1002,13 @@ bool kvm_unmap_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
>   
>   	if (kvm->arch.secure_guest & KVMPPC_SECURE_INIT_DONE) {
>   		uv_page_inval(kvm->arch.lpid, gpa, PAGE_SHIFT);
> -		return false;
> +		return;
>   	}
>   
>   	ptep = find_kvm_secondary_pte(kvm, gpa, &shift);
>   	if (ptep && pte_present(*ptep))
>   		kvmppc_unmap_pte(kvm, ptep, gpa, shift, memslot,
>   				 kvm->arch.lpid);
> -	return false;
>   }
>   
>   /* Called with kvm->mmu_lock held */
> 

