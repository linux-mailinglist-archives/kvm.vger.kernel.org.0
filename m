Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9BFF3DAAC1
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 20:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbhG2SGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 14:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbhG2SGG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 14:06:06 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED135C061765
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 11:06:01 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id c16so7891349plh.7
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 11:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z9uu0cd2lnN8oSL+u8vP5mHwZ8c5FSPLKBv7lJJsB34=;
        b=aWeEFMtnEiWHValdduzHUnKl/mgt6HAEt+enCInV1+Jr0YztLfKLbgMZU/d+YitVBA
         c1oEOmsP2LxVGgiwcJFH6xlbNTODDM+xAy5yXfQwXnqPRxO+s/EHrREI6cx0TrY4r5sM
         +1FurXSAXam7Owt2g/aH/eqGfwFzchj3IKbdpUKqsiWw1M7EdWCMa2v0+XHvAM9W40yJ
         /8pWFKoYK1WU+ChMHD06srQNrkhQIDt+CCV2XzA0Pjcuso9NQEf/6Rhd8+hemDcjTPPD
         /G6z1kOQRdQ6S8vU/9QSNsPze0ua+cfAPRsQU8ekeP+s66DOZtmhQc4utpyetbsWj+Ri
         9cQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z9uu0cd2lnN8oSL+u8vP5mHwZ8c5FSPLKBv7lJJsB34=;
        b=LyD5jfzNXg849kH7wTPLkExvdVhfJpiIxioDwIoSECuwt0g2fgYjQj+UwFXETlBLo+
         W6sTS7Sm9axwX9LgT5l2BSHksPFID2GeUfV5q0AX2akn6PhoLGAvtEX1jJnYjV2gWTMv
         xP//M2WYWVRpFTh8kPYEtDuP8wtxw3jwLxjWHu4xQ3jrpUk2vrB+oMlFxPkuRtOcLyVk
         A5PE4AaRjl3566EZS3PHypYEKaMQ75FzNpzqnMc2/LE71uyasBEYANnMyyBWBvS2Rimn
         CVUpcuUSohtvn8mq4mh+MdsmknONPUZQ0GGp9/KiIo7ctPha9dCb4ydm7NM8oBWT/xkS
         GeNA==
X-Gm-Message-State: AOAM533vp8rjUpNV2OMqkh8LaEXaJXsEHIjxoFKgOXpECMZn1MG7XGcK
        KW/vDUyDY4uASzM3BaNVUHV+Bw==
X-Google-Smtp-Source: ABdhPJwAOXL6U3YNQdOk5b6/susf0vJvD3nQfZADXWEYP9AvZFlFtgZ39c+xKIE3EYeskD0fxmthCA==
X-Received: by 2002:aa7:95a1:0:b029:359:ca4e:d25d with SMTP id a1-20020aa795a10000b0290359ca4ed25dmr6451767pfk.51.1627581961258;
        Thu, 29 Jul 2021 11:06:01 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o1sm4505123pfp.84.2021.07.29.11.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 11:06:00 -0700 (PDT)
Date:   Thu, 29 Jul 2021 18:05:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC PATCH] kvm/x86: Keep root hpa in prev_roots as much as
 possible
Message-ID: <YQLuBDZ2MlNlIoH4@google.com>
References: <20210525213920.3340-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525213920.3340-1-jiangshanlai@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 26, 2021, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> Pagetable roots in prev_roots[] are likely to be reused soon and
> there is no much overhead to keep it with a new need_sync field
> introduced.
> 
> With the help of the new need_sync field, pagetable roots are
> kept as much as possible, and they will be re-synced before reused
> instead of being dropped.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
> 
> This patch is just for RFC.
>   Is the idea Ok?

Yes, the idea is definitely a good one.

>   If the idea is Ok, we need to reused one bit from pgd or hpa
>     as need_sync to save memory.  Which one is better?

Ha, we can do this without increasing the memory footprint and without co-opting
a bit from pgd or hpa.  Because of compiler alignment/padding, the u8s and bools
between mmu_role and prev_roots already occupy 8 bytes, even though the actual
size is 4 bytes.  In total, we need room for 4 roots (3 previous + current), i.e.
4 bytes.  If a separate array is used, no additional memory is consumed and no
masking is needed when reading/writing e.g. pgd.

The cost is an extra swap() when updating the prev_roots LRU, but that's peanuts
and would likely be offset by masking anyways.

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 99f37781a6fc..13bb3c3a60b4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -424,10 +424,12 @@ struct kvm_mmu {
        hpa_t root_hpa;
        gpa_t root_pgd;
        union kvm_mmu_role mmu_role;
+       bool root_unsync;
        u8 root_level;
        u8 shadow_root_level;
        u8 ept_ad;
        bool direct_map;
+       bool unsync_roots[KVM_MMU_NUM_PREV_ROOTS];
        struct kvm_mmu_root_info prev_roots[KVM_MMU_NUM_PREV_ROOTS];

        /*


>  arch/x86/include/asm/kvm_host.h |  3 ++-
>  arch/x86/kvm/mmu/mmu.c          |  6 ++++++
>  arch/x86/kvm/vmx/nested.c       | 12 ++++--------
>  arch/x86/kvm/x86.c              |  9 +++++----
>  4 files changed, 17 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 55efbacfc244..19a337cf7aa6 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -354,10 +354,11 @@ struct rsvd_bits_validate {
>  struct kvm_mmu_root_info {
>  	gpa_t pgd;
>  	hpa_t hpa;
> +	bool need_sync;

Hmm, use "unsync" instead of "need_sync", purely to match the existing terminology
in KVM's MMU for this sort of behavior.

>  };
>  
>  #define KVM_MMU_ROOT_INFO_INVALID \
> -	((struct kvm_mmu_root_info) { .pgd = INVALID_PAGE, .hpa = INVALID_PAGE })
> +	((struct kvm_mmu_root_info) { .pgd = INVALID_PAGE, .hpa = INVALID_PAGE, .need_sync = true})
>  
>  #define KVM_MMU_NUM_PREV_ROOTS 3
>  
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5e60b00e8e50..147827135549 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3878,6 +3878,7 @@ static bool cached_root_available(struct kvm_vcpu *vcpu, gpa_t new_pgd,
>  
>  	root.pgd = mmu->root_pgd;
>  	root.hpa = mmu->root_hpa;
> +	root.need_sync = false;
>  
>  	if (is_root_usable(&root, new_pgd, new_role))
>  		return true;
> @@ -3892,6 +3893,11 @@ static bool cached_root_available(struct kvm_vcpu *vcpu, gpa_t new_pgd,
>  	mmu->root_hpa = root.hpa;
>  	mmu->root_pgd = root.pgd;
>  
> +	if (i < KVM_MMU_NUM_PREV_ROOTS && root.need_sync) {

Probably makes sense to write this as:

	if (i >= KVM_MMU_NUM_PREV_ROOTS)
		return false;

	if (root.need_sync) {
		kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
	}
	return true;

The "i < KVM_MMU_NUM_PREV_ROOTS == success" logic is just confusing enough that
it'd be nice to write it only once.

And that would also play nicely with deferring a sync for the "current" root
(see below), e.g.

	...
	unsync = mmu->root_unsync;

	if (is_root_usable(&root, new_pgd, new_role))
		goto found_root;

	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
		swap(root, mmu->prev_roots[i]);
		swap(unsync, mmu->unsync_roots[i]);

		if (is_root_usable(&root, new_pgd, new_role))
			break;
	}

        if (i >= KVM_MMU_NUM_PREV_ROOTS)
                return false;

found_root:
        if (unsync) {
                kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
                kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
        }
        return true;

> +		kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
> +		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> +	}
> +
>  	return i < KVM_MMU_NUM_PREV_ROOTS;
>  }
>  
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 6058a65a6ede..ab7069ac6dc5 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5312,7 +5312,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	u32 vmx_instruction_info, types;
> -	unsigned long type, roots_to_free;
> +	unsigned long type;
>  	struct kvm_mmu *mmu;
>  	gva_t gva;
>  	struct x86_exception e;
> @@ -5361,29 +5361,25 @@ static int handle_invept(struct kvm_vcpu *vcpu)
>  			return nested_vmx_fail(vcpu,
>  				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
>  
> -		roots_to_free = 0;
>  		if (nested_ept_root_matches(mmu->root_hpa, mmu->root_pgd,
>  					    operand.eptp))
> -			roots_to_free |= KVM_MMU_ROOT_CURRENT;
> +			kvm_mmu_free_roots(vcpu, mmu, KVM_MMU_ROOT_CURRENT);

For a non-RFC series, I think this should do two things:

  1. Separate INVEPT from INVPCID, i.e. do only INVPCID first.
  2. Enhance INVEPT to SYNC+FLUSH the current root instead of freeing it

As alluded to above, this can be done by deferring the sync+flush (which can't
be done right away because INVEPT runs in L1 context, whereas KVM needs to sync+flush
L2 EPT context).

>  		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
>  			if (nested_ept_root_matches(mmu->prev_roots[i].hpa,
>  						    mmu->prev_roots[i].pgd,
>  						    operand.eptp))
> -				roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
> +				mmu->prev_roots[i].need_sync = true;
>  		}
>  		break;
>  	case VMX_EPT_EXTENT_GLOBAL:
> -		roots_to_free = KVM_MMU_ROOTS_ALL;
> +		kvm_mmu_free_roots(vcpu, mmu, KVM_MMU_ROOTS_ALL);
>  		break;
>  	default:
>  		BUG();
>  		break;
>  	}
>  
> -	if (roots_to_free)
> -		kvm_mmu_free_roots(vcpu, mmu, roots_to_free);
> -
>  	return nested_vmx_succeed(vcpu);
>  }
