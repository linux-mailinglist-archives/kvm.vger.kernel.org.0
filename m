Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 802FD4CED88
	for <lists+kvm@lfdr.de>; Sun,  6 Mar 2022 20:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233896AbiCFTt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Mar 2022 14:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233332AbiCFTt2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Mar 2022 14:49:28 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885C124F36
        for <kvm@vger.kernel.org>; Sun,  6 Mar 2022 11:48:33 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 195so11881582pgc.6
        for <kvm@vger.kernel.org>; Sun, 06 Mar 2022 11:48:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V8o345/U/xZ+bjJ6j5/nCCvu5f93SiHdFcgtIE5P7Zk=;
        b=Q13DY70WzeqD2z7eQAmEC27U76Nromlg2gNrZaiy9555jWwZUmFFmgtBdSxDQh0gGK
         /5FhG4FwcX31wP9pIiE44ho9bkCUs8WDOBMf11CfkabE/GoT7MSJUF7euYclAksuZU/5
         29kRR0vsocPETEo60yoEk0gl9UzWFaZyGxGt8H1Br1YxPcMGSXXixiUMgONBHWf2Hokj
         ftyDnTkY+awDd5/+l8J8JFN1WXPneh84kGO/zDwQ4SPE0hncM+OhSSRWDrgkCvtppRt+
         v59+oI5TyTF/pyp91PpFVfN4oZ9YCIvips6IfJoKNurL7lDYwDuBvJvFCVXnK6Cq2Rp1
         oaYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V8o345/U/xZ+bjJ6j5/nCCvu5f93SiHdFcgtIE5P7Zk=;
        b=DLRQzjIJ5RMw6f8bZ2nwZjE/38GMWO9k+zOoMAI+UryV3xN4fCC3eewUwcMmbJ+5Pv
         oSFVz7yEoHy2SnQ/PV5t2Jbx1Uw8k1x9gMyTf6yMIBmZuQnwe+SjGZmgW5TmklWwNVzu
         6iajT2NP2KDWVSIBAPbbqGSwhJw8Ax5ar42xRzgiM1fwDi3XMk4aN9w15zQaUEIpMUv5
         dhK9iNjnoPULHoDrMnI1gLoMVe7urhHpq3+fBJ0qc/2gjBbT79xyrem5nNGRIRmkJA9r
         rV/9mjmGM3bpjQLi5L2NVCuEURp49kPxVHAHFx3Gv1/cSrYa6IbwP5IolZM74YjRwA6A
         /KMw==
X-Gm-Message-State: AOAM530lcv5E3xDToJsT2d1ZrqxKn+RkhWnR5psE2/vg7NjwETMf1Rxe
        1HguWeyTPjZDqFQ8kHJ/J/W2yQ==
X-Google-Smtp-Source: ABdhPJyISgIo1e0238uVrMNqaSgm1KHuW+wPkREa40+KO5ke+bD8eIlApLP+OX3NJImk6X/aAtsUDQ==
X-Received: by 2002:a05:6a00:14d6:b0:4f6:f496:c1e2 with SMTP id w22-20020a056a0014d600b004f6f496c1e2mr3057932pfu.45.1646596112702;
        Sun, 06 Mar 2022 11:48:32 -0800 (PST)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id q10-20020a056a00150a00b004f6f1ddafd4sm2683798pfu.191.2022.03.06.11.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 11:48:31 -0800 (PST)
Date:   Sun, 6 Mar 2022 19:48:28 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Nikunj A Dadhania <nikunj@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/6] KVM: SVM: Implement demand page pinning
Message-ID: <YiUQDHdT0DB/mYVc@google.com>
References: <20220118110621.62462-1-nikunj@amd.com>
 <20220118110621.62462-4-nikunj@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118110621.62462-4-nikunj@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 18, 2022, Nikunj A Dadhania wrote:
> Use the memslot metadata to store the pinned data along with the pfns.
> This improves the SEV guest startup time from O(n) to a constant by
> deferring guest page pinning until the pages are used to satisfy nested
> page faults. The page reference will be dropped in the memslot free
> path.
> 
> Remove the enc_region structure definition and the code which did
> upfront pinning, as they are no longer needed in view of the demand
> pinning support.
> 
> Leave svm_register_enc_region() and svm_unregister_enc_region() as stubs
> since qemu is dependent on this API.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 208 ++++++++++++++++-------------------------
>  arch/x86/kvm/svm/svm.c |   1 +
>  arch/x86/kvm/svm/svm.h |   3 +-
>  3 files changed, 81 insertions(+), 131 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index d972ab4956d4..a962bed97a0b 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -66,14 +66,6 @@ static unsigned int nr_asids;
>  static unsigned long *sev_asid_bitmap;
>  static unsigned long *sev_reclaim_asid_bitmap;
>  
> -struct enc_region {
> -	struct list_head list;
> -	unsigned long npages;
> -	struct page **pages;
> -	unsigned long uaddr;
> -	unsigned long size;
> -};
> -
>  /* Called with the sev_bitmap_lock held, or on shutdown  */
>  static int sev_flush_asids(int min_asid, int max_asid)
>  {
> @@ -257,8 +249,6 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	if (ret)
>  		goto e_free;
>  
> -	INIT_LIST_HEAD(&sev->regions_list);
> -
>  	return 0;
>  
>  e_free:
> @@ -1637,8 +1627,6 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
>  	src->handle = 0;
>  	src->pages_locked = 0;
>  	src->enc_context_owner = NULL;
> -
> -	list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
>  }
>  
>  static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
> @@ -1861,115 +1849,13 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  int svm_register_enc_region(struct kvm *kvm,
>  			    struct kvm_enc_region *range)
>  {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -	struct enc_region *region;
> -	int ret = 0;
> -
> -	if (!sev_guest(kvm))
> -		return -ENOTTY;
> -
> -	/* If kvm is mirroring encryption context it isn't responsible for it */
> -	if (is_mirroring_enc_context(kvm))
> -		return -EINVAL;
> -
> -	if (range->addr > ULONG_MAX || range->size > ULONG_MAX)
> -		return -EINVAL;
> -
> -	region = kzalloc(sizeof(*region), GFP_KERNEL_ACCOUNT);
> -	if (!region)
> -		return -ENOMEM;
> -
> -	mutex_lock(&kvm->lock);
> -	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
> -	if (IS_ERR(region->pages)) {
> -		ret = PTR_ERR(region->pages);
> -		mutex_unlock(&kvm->lock);
> -		goto e_free;
> -	}
> -
> -	region->uaddr = range->addr;
> -	region->size = range->size;
> -
> -	list_add_tail(&region->list, &sev->regions_list);
> -	mutex_unlock(&kvm->lock);
> -
> -	/*
> -	 * The guest may change the memory encryption attribute from C=0 -> C=1
> -	 * or vice versa for this memory range. Lets make sure caches are
> -	 * flushed to ensure that guest data gets written into memory with
> -	 * correct C-bit.
> -	 */
> -	sev_clflush_pages(region->pages, region->npages);
> -
> -	return ret;
> -
> -e_free:
> -	kfree(region);
> -	return ret;
> -}
> -
> -static struct enc_region *
> -find_enc_region(struct kvm *kvm, struct kvm_enc_region *range)
> -{
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -	struct list_head *head = &sev->regions_list;
> -	struct enc_region *i;
> -
> -	list_for_each_entry(i, head, list) {
> -		if (i->uaddr == range->addr &&
> -		    i->size == range->size)
> -			return i;
> -	}
> -
> -	return NULL;
> -}
> -
> -static void __unregister_enc_region_locked(struct kvm *kvm,
> -					   struct enc_region *region)
> -{
> -	sev_unpin_memory(kvm, region->pages, region->npages);
> -	list_del(&region->list);
> -	kfree(region);
> +	return 0;
>  }
>  
>  int svm_unregister_enc_region(struct kvm *kvm,
>  			      struct kvm_enc_region *range)
>  {
> -	struct enc_region *region;
> -	int ret;
> -
> -	/* If kvm is mirroring encryption context it isn't responsible for it */
> -	if (is_mirroring_enc_context(kvm))
> -		return -EINVAL;
> -
> -	mutex_lock(&kvm->lock);
> -
> -	if (!sev_guest(kvm)) {
> -		ret = -ENOTTY;
> -		goto failed;
> -	}
> -
> -	region = find_enc_region(kvm, range);
> -	if (!region) {
> -		ret = -EINVAL;
> -		goto failed;
> -	}
> -
> -	/*
> -	 * Ensure that all guest tagged cache entries are flushed before
> -	 * releasing the pages back to the system for use. CLFLUSH will
> -	 * not do this, so issue a WBINVD.
> -	 */
> -	wbinvd_on_all_cpus();
> -
> -	__unregister_enc_region_locked(kvm, region);
> -
> -	mutex_unlock(&kvm->lock);
>  	return 0;
> -
> -failed:
> -	mutex_unlock(&kvm->lock);
> -	return ret;
>  }
>  
>  int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
> @@ -2018,7 +1904,6 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>  	mirror_sev->fd = source_sev->fd;
>  	mirror_sev->es_active = source_sev->es_active;
>  	mirror_sev->handle = source_sev->handle;
> -	INIT_LIST_HEAD(&mirror_sev->regions_list);
>  	ret = 0;
>  
>  	/*
> @@ -2038,8 +1923,6 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>  void sev_vm_destroy(struct kvm *kvm)
>  {
>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -	struct list_head *head = &sev->regions_list;
> -	struct list_head *pos, *q;
>  
>  	WARN_ON(sev->num_mirrored_vms);
>  
> @@ -2066,18 +1949,6 @@ void sev_vm_destroy(struct kvm *kvm)
>  	 */
>  	wbinvd_on_all_cpus();
>  
> -	/*
> -	 * if userspace was terminated before unregistering the memory regions
> -	 * then lets unpin all the registered memory.
> -	 */
> -	if (!list_empty(head)) {
> -		list_for_each_safe(pos, q, head) {
> -			__unregister_enc_region_locked(kvm,
> -				list_entry(pos, struct enc_region, list));
> -			cond_resched();
> -		}
> -	}
> -
>  	sev_unbind_asid(kvm, sev->handle);
>  	sev_asid_free(sev);
>  }
> @@ -2946,13 +2817,90 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>  	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
>  }
>  
> +void sev_pin_spte(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> +		  kvm_pfn_t pfn)
> +{
> +	struct kvm_arch_memory_slot *aslot;
> +	struct kvm_memory_slot *slot;
> +	gfn_t rel_gfn, pin_pfn;
> +	unsigned long npages;
> +	kvm_pfn_t old_pfn;
> +	int i;
> +
> +	if (!sev_guest(kvm))
> +		return;
> +
> +	if (WARN_ON_ONCE(is_error_noslot_pfn(pfn) || kvm_is_reserved_pfn(pfn)))
> +		return;
> +
> +	/* Tested till 1GB pages */
> +	if (KVM_BUG_ON(level > PG_LEVEL_1G, kvm))
> +		return;
> +
> +	slot = gfn_to_memslot(kvm, gfn);
> +	if (!slot || !slot->arch.pfns)
> +		return;
> +
> +	/*
> +	 * Use relative gfn index within the memslot for the bitmap as well as
> +	 * the pfns array
> +	 */
> +	rel_gfn = gfn - slot->base_gfn;
> +	aslot = &slot->arch;
> +	pin_pfn = pfn;
> +	npages = KVM_PAGES_PER_HPAGE(level);
> +
> +	/* Pin the page, KVM doesn't yet support page migration. */
> +	for (i = 0; i < npages; i++, rel_gfn++, pin_pfn++) {
> +		if (test_bit(rel_gfn, aslot->pinned_bitmap)) {
> +			old_pfn = aslot->pfns[rel_gfn];
> +			if (old_pfn == pin_pfn)
> +				continue;
> +
> +			put_page(pfn_to_page(old_pfn));

You need to flush the old pfn using VMPAGE_FLUSH before doing put_page.
Normally, this should not happen. But if the user-level VMM is
malicious, then it could just munmap() the region (not the memslot);
mmap() it again; let the guest VM touches the page and you will see this
path get executed.

Clearly, this will slow down the faulting path if this happens.  So,
alternatively, you can register a hook in mmu_notifier and shoot a flush
there according to the bitmap. Either way should work.

> +		}
> +
> +		set_bit(rel_gfn, aslot->pinned_bitmap);
> +		aslot->pfns[rel_gfn] = pin_pfn;
> +		get_page(pfn_to_page(pin_pfn));
> +	}
> +
> +	/*
> +	 * Flush any cached lines of the page being added since "ownership" of
> +	 * it will be transferred from the host to an encrypted guest.
> +	 */
> +	clflush_cache_range(__va(pfn << PAGE_SHIFT), page_level_size(level));
> +}
> +
>  void sev_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
>  {
>  	struct kvm_arch_memory_slot *aslot = &slot->arch;
> +	kvm_pfn_t *pfns;
> +	gfn_t gfn;
> +	int i;
>  
>  	if (!sev_guest(kvm))
>  		return;
>  
> +	if (!aslot->pinned_bitmap || !slot->arch.pfns)
> +		goto out;
> +
> +	pfns = aslot->pfns;
> +
> +	/*
> +	 * Iterate the memslot to find the pinned pfn using the bitmap and drop
> +	 * the pfn stored.
> +	 */
> +	for (i = 0, gfn = slot->base_gfn; i < slot->npages; i++, gfn++) {
> +		if (test_and_clear_bit(i, aslot->pinned_bitmap)) {
> +			if (WARN_ON(!pfns[i]))
> +				continue;
> +
> +			put_page(pfn_to_page(pfns[i]));

Here, you get lucky that you don't have to flush the cache. However,
this is because sev_free_memslots is called after the
kvm_arch_destroy_vm, which flushes the cache system wise.
> +		}
> +	}
> +
> +out:
>  	if (aslot->pinned_bitmap) {
>  		kvfree(aslot->pinned_bitmap);
>  		aslot->pinned_bitmap = NULL;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3fb19974f719..22535c680b3f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4743,6 +4743,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  
>  	.alloc_memslot_metadata = sev_alloc_memslot_metadata,
>  	.free_memslot = sev_free_memslot,
> +	.pin_spte = sev_pin_spte,
>  };
>  
>  static struct kvm_x86_init_ops svm_init_ops __initdata = {
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index b2f8b3b52680..c731bc91ea8f 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -77,7 +77,6 @@ struct kvm_sev_info {
>  	unsigned int handle;	/* SEV firmware handle */
>  	int fd;			/* SEV device fd */
>  	unsigned long pages_locked; /* Number of pages locked */
> -	struct list_head regions_list;  /* List of registered regions */
>  	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
>  	struct kvm *enc_context_owner; /* Owner of copied encryption context */
>  	unsigned long num_mirrored_vms; /* Number of VMs sharing this ASID */
> @@ -648,5 +647,7 @@ int sev_alloc_memslot_metadata(struct kvm *kvm,
>  			       struct kvm_memory_slot *new);
>  void sev_free_memslot(struct kvm *kvm,
>  		      struct kvm_memory_slot *slot);
> +void sev_pin_spte(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> +		  kvm_pfn_t pfn);
>  
>  #endif
> -- 
> 2.32.0
> 
