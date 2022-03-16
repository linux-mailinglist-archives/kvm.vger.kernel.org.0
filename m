Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE9894DAE38
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 11:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355134AbiCPK2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 06:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344542AbiCPK2N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 06:28:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D9C6E5BD2A
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 03:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647426418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E9sc2QKvZ6jQfVnVaYNv02EOzH/XkSDclOIFBmE3wrg=;
        b=igOPGCZLsMmj4vHw1W/4EFF/3L9vWZHr3tVz+Te53t+ghnCGWjPkTPoJXJQ7j0coIDmnQK
        wExMk2rWKXbidEMrw6BFV5x3QxHA6SdpbaVoyoOgKLsqGdzxyy+TGjrL+ArgDs3HjPm0WR
        3L0q4nDXVmnWwk9wk58qr5Px6bxuvig=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-483-gEd2hBigPH-8WKD1ULyawg-1; Wed, 16 Mar 2022 06:26:56 -0400
X-MC-Unique: gEd2hBigPH-8WKD1ULyawg-1
Received: by mail-pj1-f70.google.com with SMTP id o6-20020a17090a9f8600b001c640fa1499so1484150pjp.3
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 03:26:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E9sc2QKvZ6jQfVnVaYNv02EOzH/XkSDclOIFBmE3wrg=;
        b=nysYEVMJuSjL5iXMvHvbekLITxxeOnUg/7nAhwmf4V/h1Pja859+FGEl5mIXUz8z6G
         CfcAbD7DqV9qM3gIEwiMtqvxmUGhMwYIapOXxq+BhlICWh13vdPOpz9Ov+7GaRFOusHW
         bprigeNT7ZV2Seat7sNrPhaXjORO/jqF7xLiBtwxa3MR74qkLboPLaTnY2gQajHL7s5V
         rg7H6h4mZrvmHdaL1GkfIneXeZDnVQdP24Eg4yk3Nbx/iUb5PByg72oBFdOPySfDHSjB
         wWvKFuEOPl3I+3GYNVknQ/+JmERyQEuxGbPYt86kerH7rdGOUiUwFworMGOB1cIRp3HK
         1wTA==
X-Gm-Message-State: AOAM533ueW83FS/5x6sCP10rJTgx+ReHriljJRntgI6ALWTgL/hHFfSV
        D8l5623OG6oqK7DeN+KWHi4DZVp3vrYSZv+G9dYdJUYFRS0caxBHM+1Zso4Q/3skYuas16FgKUT
        J1iOcUV8Km4t7
X-Received: by 2002:a17:903:110c:b0:153:1293:5624 with SMTP id n12-20020a170903110c00b0015312935624mr32609976plh.149.1647426415346;
        Wed, 16 Mar 2022 03:26:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMSKIOGyF7c+akd053X7Mrr2oeKncFSJFsXk0tI1zZhQcz46nFkjBsMeAlw53IG1hZZsUshg==
X-Received: by 2002:a17:903:110c:b0:153:1293:5624 with SMTP id n12-20020a170903110c00b0015312935624mr32609927plh.149.1647426414887;
        Wed, 16 Mar 2022 03:26:54 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.128])
        by smtp.gmail.com with ESMTPSA id j67-20020a636e46000000b003740d689ca9sm2122395pgc.62.2022.03.16.03.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 03:26:54 -0700 (PDT)
Date:   Wed, 16 Mar 2022 18:26:46 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH v2 20/26] KVM: x86/mmu: Extend Eager Page Splitting to
 the shadow MMU
Message-ID: <YjG7Zh4zwTDsO3L1@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-21-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220311002528.2230172-21-dmatlack@google.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 11, 2022 at 12:25:22AM +0000, David Matlack wrote:
> Extend KVM's eager page splitting to also split huge pages that are
> mapped by the shadow MMU. Specifically, walk through the rmap splitting
> all 1GiB pages to 2MiB pages, and splitting all 2MiB pages to 4KiB
> pages.
> 
> Splitting huge pages mapped by the shadow MMU requries dealing with some
> extra complexity beyond that of the TDP MMU:
> 
> (1) The shadow MMU has a limit on the number of shadow pages that are
>     allowed to be allocated. So, as a policy, Eager Page Splitting
>     refuses to split if there are KVM_MIN_FREE_MMU_PAGES or fewer
>     pages available.
> 
> (2) Huge pages may be mapped by indirect shadow pages which have the
>     possibility of being unsync. As a policy we opt not to split such
>     pages as their translation may no longer be valid.
> 
> (3) Splitting a huge page may end up re-using an existing lower level
>     shadow page tables. This is unlike the TDP MMU which always allocates
>     new shadow page tables when splitting.  This commit does *not*
>     handle such aliasing and opts not to split such huge pages.
> 
> (4) When installing the lower level SPTEs, they must be added to the
>     rmap which may require allocating additional pte_list_desc structs.
>     This commit does *not* handle such cases and instead opts to leave
>     such lower-level SPTEs non-present. In this situation TLBs must be
>     flushed before dropping the MMU lock as a portion of the huge page
>     region is being unmapped.
> 
> Suggested-by: Peter Feiner <pfeiner@google.com>
> [ This commit is based off of the original implementation of Eager Page
>   Splitting from Peter in Google's kernel from 2016. ]
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |   3 -
>  arch/x86/kvm/mmu/mmu.c                        | 307 ++++++++++++++++++
>  2 files changed, 307 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 05161afd7642..495f6ac53801 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2360,9 +2360,6 @@
>  			the KVM_CLEAR_DIRTY ioctl, and only for the pages being
>  			cleared.
>  
> -			Eager page splitting currently only supports splitting
> -			huge pages mapped by the TDP MMU.
> -
>  			Default is Y (on).
>  
>  	kvm.enable_vmware_backdoor=[KVM] Support VMware backdoor PV interface.
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 926ddfaa9e1a..dd56b5b9624f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -727,6 +727,11 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
>  
>  static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_mmu_memory_cache *cache)
>  {
> +	static const gfp_t gfp_nocache = GFP_ATOMIC | __GFP_ACCOUNT | __GFP_ZERO;
> +
> +	if (WARN_ON_ONCE(!cache))
> +		return kmem_cache_alloc(pte_list_desc_cache, gfp_nocache);
> +

I also think this is not proper to be added into this patch.  Maybe it'll
be more suitable for the rmap_add() rework patch previously, or maybe it
can be dropped directly if it should never trigger at all. Then we die hard
at below when referencing it.

>  	return kvm_mmu_memory_cache_alloc(cache);
>  }
>  
> @@ -743,6 +748,28 @@ static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
>  	return sp->gfn + (index << ((sp->role.level - 1) * PT64_LEVEL_BITS));
>  }
>  
> +static gfn_t sptep_to_gfn(u64 *sptep)
> +{
> +	struct kvm_mmu_page *sp = sptep_to_sp(sptep);
> +
> +	return kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
> +}
> +
> +static unsigned int kvm_mmu_page_get_access(struct kvm_mmu_page *sp, int index)
> +{
> +	if (!sp->role.direct)
> +		return sp->shadowed_translation[index].access;
> +
> +	return sp->role.access;
> +}
> +
> +static unsigned int sptep_to_access(u64 *sptep)
> +{
> +	struct kvm_mmu_page *sp = sptep_to_sp(sptep);
> +
> +	return kvm_mmu_page_get_access(sp, sptep - sp->spt);
> +}
> +
>  static void kvm_mmu_page_set_gfn_access(struct kvm_mmu_page *sp, int index,
>  					gfn_t gfn, u32 access)
>  {
> @@ -912,6 +939,9 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
>  	return count;
>  }
>  
> +static struct kvm_rmap_head *gfn_to_rmap(gfn_t gfn, int level,
> +					 const struct kvm_memory_slot *slot);
> +
>  static void
>  pte_list_desc_remove_entry(struct kvm_rmap_head *rmap_head,
>  			   struct pte_list_desc *desc, int i,
> @@ -2125,6 +2155,23 @@ static struct kvm_mmu_page *__kvm_mmu_find_shadow_page(struct kvm *kvm,
>  	return sp;
>  }
>  
> +static struct kvm_mmu_page *kvm_mmu_find_direct_sp(struct kvm *kvm, gfn_t gfn,
> +						   union kvm_mmu_page_role role)
> +{
> +	struct kvm_mmu_page *sp;
> +	LIST_HEAD(invalid_list);
> +
> +	BUG_ON(!role.direct);
> +
> +	sp = __kvm_mmu_find_shadow_page(kvm, gfn, role, &invalid_list);
> +
> +	/* Direct SPs are never unsync. */
> +	WARN_ON_ONCE(sp && sp->unsync);
> +
> +	kvm_mmu_commit_zap_page(kvm, &invalid_list);
> +	return sp;
> +}
> +
>  /*
>   * Looks up an existing SP for the given gfn and role if one exists. The
>   * return SP is guaranteed to be synced.
> @@ -6063,12 +6110,266 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
>  		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
>  }
>  
> +static int prepare_to_split_huge_page(struct kvm *kvm,
> +				      const struct kvm_memory_slot *slot,
> +				      u64 *huge_sptep,
> +				      struct kvm_mmu_page **spp,
> +				      bool *flush,
> +				      bool *dropped_lock)
> +{
> +	int r = 0;
> +
> +	*dropped_lock = false;
> +
> +	if (kvm_mmu_available_pages(kvm) <= KVM_MIN_FREE_MMU_PAGES)
> +		return -ENOSPC;
> +
> +	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
> +		goto drop_lock;
> +

Not immediately clear on whether there'll be case that *spp is set within
the current function.  Some sanity check might be nice?

> +	*spp = kvm_mmu_alloc_direct_sp_for_split(true);
> +	if (r)
> +		goto drop_lock;
> +
> +	return 0;
> +
> +drop_lock:
> +	if (*flush)
> +		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> +
> +	*flush = false;
> +	*dropped_lock = true;
> +
> +	write_unlock(&kvm->mmu_lock);
> +	cond_resched();
> +	*spp = kvm_mmu_alloc_direct_sp_for_split(false);
> +	if (!*spp)
> +		r = -ENOMEM;
> +	write_lock(&kvm->mmu_lock);
> +
> +	return r;
> +}
> +
> +static struct kvm_mmu_page *kvm_mmu_get_sp_for_split(struct kvm *kvm,
> +						     const struct kvm_memory_slot *slot,
> +						     u64 *huge_sptep,
> +						     struct kvm_mmu_page **spp)
> +{
> +	struct kvm_mmu_page *split_sp;
> +	union kvm_mmu_page_role role;
> +	unsigned int access;
> +	gfn_t gfn;
> +
> +	gfn = sptep_to_gfn(huge_sptep);
> +	access = sptep_to_access(huge_sptep);
> +
> +	/*
> +	 * Huge page splitting always uses direct shadow pages since we are
> +	 * directly mapping the huge page GFN region with smaller pages.
> +	 */
> +	role = kvm_mmu_child_role(huge_sptep, true, access);
> +	split_sp = kvm_mmu_find_direct_sp(kvm, gfn, role);
> +
> +	/*
> +	 * Opt not to split if the lower-level SP already exists. This requires
> +	 * more complex handling as the SP may be already partially filled in
> +	 * and may need extra pte_list_desc structs to update parent_ptes.
> +	 */
> +	if (split_sp)
> +		return NULL;

This smells tricky..

Firstly we're trying to lookup the existing SPs that has shadowed this huge
page in split way, with the access bits fetched from the shadow cache (so
without hugepage nx effect).  However could the pages be mapped with
different permissions from the currently hugely mapped page?

IIUC all these is for the fact that we can't allocate pte_list_desc and we
want to make sure we won't make the pte list to be >1.

But I also see that the pte_list check below...

> +
> +	swap(split_sp, *spp);
> +	init_shadow_page(kvm, split_sp, slot, gfn, role);
> +	trace_kvm_mmu_get_page(split_sp, true);
> +
> +	return split_sp;
> +}
> +
> +static int kvm_mmu_split_huge_page(struct kvm *kvm,
> +				   const struct kvm_memory_slot *slot,
> +				   u64 *huge_sptep, struct kvm_mmu_page **spp,
> +				   bool *flush)
> +
> +{
> +	struct kvm_mmu_page *split_sp;
> +	u64 huge_spte, split_spte;
> +	int split_level, index;
> +	unsigned int access;
> +	u64 *split_sptep;
> +	gfn_t split_gfn;
> +
> +	split_sp = kvm_mmu_get_sp_for_split(kvm, slot, huge_sptep, spp);
> +	if (!split_sp)
> +		return -EOPNOTSUPP;
> +
> +	/*
> +	 * Since we did not allocate pte_list_desc_structs for the split, we
> +	 * cannot add a new parent SPTE to parent_ptes. This should never happen
> +	 * in practice though since this is a fresh SP.
> +	 *
> +	 * Note, this makes it safe to pass NULL to __link_shadow_page() below.
> +	 */
> +	if (WARN_ON_ONCE(split_sp->parent_ptes.val))
> +		return -EINVAL;
> +
> +	huge_spte = READ_ONCE(*huge_sptep);
> +
> +	split_level = split_sp->role.level;
> +	access = split_sp->role.access;
> +
> +	for (index = 0; index < PT64_ENT_PER_PAGE; index++) {
> +		split_sptep = &split_sp->spt[index];
> +		split_gfn = kvm_mmu_page_get_gfn(split_sp, index);
> +
> +		BUG_ON(is_shadow_present_pte(*split_sptep));
> +
> +		/*
> +		 * Since we did not allocate pte_list_desc structs for the
> +		 * split, we can't add a new SPTE that maps this GFN.
> +		 * Skipping this SPTE means we're only partially mapping the
> +		 * huge page, which means we'll need to flush TLBs before
> +		 * dropping the MMU lock.
> +		 *
> +		 * Note, this make it safe to pass NULL to __rmap_add() below.
> +		 */
> +		if (gfn_to_rmap(split_gfn, split_level, slot)->val) {
> +			*flush = true;
> +			continue;
> +		}

... here.

IIUC this check should already be able to cover all the cases and it's
accurate on the fact that we don't want to grow any rmap to >1 len.

> +
> +		split_spte = make_huge_page_split_spte(
> +				huge_spte, split_level + 1, index, access);
> +
> +		mmu_spte_set(split_sptep, split_spte);
> +		__rmap_add(kvm, NULL, slot, split_sptep, split_gfn, access);

__rmap_add() with a NULL cache pointer is weird.. same as
__link_shadow_page() below.

I'll stop here for now I guess.. Have you considered having rmap allocation
ready altogether, rather than making this intermediate step but only add
that later?  Because all these look hackish to me..  It's also possible
that I missed something important, if so please shoot.

Thanks,

> +	}
> +
> +	/*
> +	 * Replace the huge spte with a pointer to the populated lower level
> +	 * page table. Since we are making this change without a TLB flush vCPUs
> +	 * will see a mix of the split mappings and the original huge mapping,
> +	 * depending on what's currently in their TLB. This is fine from a
> +	 * correctness standpoint since the translation will either be identical
> +	 * or non-present. To account for non-present mappings, the TLB will be
> +	 * flushed prior to dropping the MMU lock.
> +	 */
> +	__drop_large_spte(kvm, huge_sptep, false);
> +	__link_shadow_page(NULL, huge_sptep, split_sp);
> +
> +	return 0;
> +}

-- 
Peter Xu

