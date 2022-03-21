Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665594E207E
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 07:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344553AbiCUGNT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 02:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232246AbiCUGNR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 02:13:17 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764EE65D09
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 23:11:52 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id mr5-20020a17090b238500b001c67366ae93so10985678pjb.4
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 23:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=thP6Ftyt5GZ2dlg7Jg/XERFvOFBQRlP1duoLTIvHDPQ=;
        b=JcDy6dLydkkMaly2BExvml+49ka8QDRWiOl57UzfttZZ3M22ahQk5Bwt8lwFdYEDNw
         p+Ku6wEB2DzqKLXCVYqTASjj4zk+HVrIOQ/XMAliDn9PqyIEx6faqcFjDInancoQw4ZJ
         T5LMa1DFgrfcbfRQUVKc8oMzbu3l24roMAI25/QcXvCUMTc0mDzkZxgyg9OKyOH56ftO
         WXA5nq2kVW4yuUkTGxePpfISua6EoTBH9Ou81W78iwceiDhfbucxqAKO/Gpk+pLcSnhW
         IJ/B1+TqhuMAb8G3Hfy4FnK5/DFI6dVyJD1Etvf0GvK1KYfHRthI+3o8RYEy5OPIGSzj
         F2Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=thP6Ftyt5GZ2dlg7Jg/XERFvOFBQRlP1duoLTIvHDPQ=;
        b=rAaT3d9YVWtHJaicv3sE97eNua3llVmlwc7HtP2OWZSUp+twHOIEdWMYQQ+gsbEmJP
         Fngb3srTR4Cyd7ZZpgAxpQdRTbEvfmj2sQqM8jjO0qf0zDsRO+uxG3pSu/XCkyPKFkRS
         KHP1EWdX+vVM220PrTV+IwoICVZy2B8/eMIRbcaImKjPbEaRHKFaR4hbjDDY3WvhBjt5
         P6W5HkE7Tphy+L09rdyQ+CP838dTNHGUB7/3dgF9oYqvehi0QyLMARV2wlsaGO5GOASh
         sSzhbYX16UVIVn2/l/8z2jqv2xjdyhmMBc7Urhl/MDihJhzLnuvqZdKDo1WBFWiwAsL5
         /JrA==
X-Gm-Message-State: AOAM530OpiQr6PU+AQt1zfx8Edqjs5k90s5PLUfcMudqBjy6KT08qgfq
        TkvkFDHrW/dk7lLojMmfJXaEJKMiTyXjEQ==
X-Google-Smtp-Source: ABdhPJwq+zra1tC+Y7fcaa+8GbhRA8C9su6QTaUnnU+SDkpYNlZi4v3viTo11+Ul8nn4Q+o1oCk3DA==
X-Received: by 2002:a17:90a:1b2e:b0:1c6:d5ed:3ca4 with SMTP id q43-20020a17090a1b2e00b001c6d5ed3ca4mr11146390pjq.171.1647843111411;
        Sun, 20 Mar 2022 23:11:51 -0700 (PDT)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id o5-20020a056a0015c500b004f76735be68sm18524174pfu.216.2022.03.20.23.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Mar 2022 23:11:50 -0700 (PDT)
Date:   Mon, 21 Mar 2022 06:11:47 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>,
        Bharata B Rao <bharata@amd.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v1 5/9] KVM: SVM: Implement demand page pinning
Message-ID: <YjgXIyrcDA5+u8d+@google.com>
References: <20220308043857.13652-1-nikunj@amd.com>
 <20220308043857.13652-6-nikunj@amd.com>
 <YifQbxW/NUt0HrGV@google.com>
 <03e87e5c-0345-5919-9a33-0bdf50285d8b@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03e87e5c-0345-5919-9a33-0bdf50285d8b@amd.com>
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

On Wed, Mar 09, 2022, Nikunj A. Dadhania wrote:
> On 3/9/2022 3:23 AM, Mingwei Zhang wrote:
> > On Tue, Mar 08, 2022, Nikunj A Dadhania wrote:
> >> Use the memslot metadata to store the pinned data along with the pfns.
> >> This improves the SEV guest startup time from O(n) to a constant by
> >> deferring guest page pinning until the pages are used to satisfy
> >> nested page faults. The page reference will be dropped in the memslot
> >> free path or deallocation path.
> >>
> >> Reuse enc_region structure definition as pinned_region to maintain
> >> pages that are pinned outside of MMU demand pinning. Remove rest of
> >> the code which did upfront pinning, as they are no longer needed in
> >> view of the demand pinning support.
> > 
> > I don't quite understand why we still need the enc_region. I have
> > several concerns. Details below.
> 
> With patch 9 the enc_region is used only for memory that was pinned before 
> the vcpu is online (i.e. mmu is not yet usable)
> 
> >>
> >> Retain svm_register_enc_region() and svm_unregister_enc_region() with
> >> required checks for resource limit.
> >>
> >> Guest boot time comparison
> >>   +---------------+----------------+-------------------+
> >>   | Guest Memory  |   baseline     |  Demand Pinning   |
> >>   | Size (GB)     |    (secs)      |     (secs)        |
> >>   +---------------+----------------+-------------------+
> >>   |      4        |     6.16       |      5.71         |
> >>   +---------------+----------------+-------------------+
> >>   |     16        |     7.38       |      5.91         |
> >>   +---------------+----------------+-------------------+
> >>   |     64        |    12.17       |      6.16         |
> >>   +---------------+----------------+-------------------+
> >>   |    128        |    18.20       |      6.50         |
> >>   +---------------+----------------+-------------------+
> >>   |    192        |    24.56       |      6.80         |
> >>   +---------------+----------------+-------------------+
> >>
> >> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> >> ---
> >>  arch/x86/kvm/svm/sev.c | 304 ++++++++++++++++++++++++++---------------
> >>  arch/x86/kvm/svm/svm.c |   1 +
> >>  arch/x86/kvm/svm/svm.h |   6 +-
> >>  3 files changed, 200 insertions(+), 111 deletions(-)
> >>
> >> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> >> index bd7572517c99..d0514975555d 100644
> >> --- a/arch/x86/kvm/svm/sev.c
> >> +++ b/arch/x86/kvm/svm/sev.c
> >> @@ -66,7 +66,7 @@ static unsigned int nr_asids;
> >>  static unsigned long *sev_asid_bitmap;
> >>  static unsigned long *sev_reclaim_asid_bitmap;
> >>  
> >> -struct enc_region {
> >> +struct pinned_region {
> >>  	struct list_head list;
> >>  	unsigned long npages;
> >>  	struct page **pages;
> >> @@ -257,7 +257,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >>  	if (ret)
> >>  		goto e_free;
> >>  
> >> -	INIT_LIST_HEAD(&sev->regions_list);
> >> +	INIT_LIST_HEAD(&sev->pinned_regions_list);
> >>  
> >>  	return 0;
> >>  
> >> @@ -378,16 +378,34 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >>  	return ret;
> >>  }
> >>  
> >> +static bool rlimit_memlock_exceeds(unsigned long locked, unsigned long npages)
> >> +{
> >> +	unsigned long lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> >> +	unsigned long lock_req;
> >> +
> >> +	lock_req = locked + npages;
> >> +	return (lock_req > lock_limit) && !capable(CAP_IPC_LOCK);
> >> +}
> >> +
> >> +static unsigned long get_npages(unsigned long uaddr, unsigned long ulen)
> >> +{
> >> +	unsigned long first, last;
> >> +
> >> +	/* Calculate number of pages. */
> >> +	first = (uaddr & PAGE_MASK) >> PAGE_SHIFT;
> >> +	last = ((uaddr + ulen - 1) & PAGE_MASK) >> PAGE_SHIFT;
> >> +	return last - first + 1;
> >> +}
> >> +
> >>  static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
> >>  				    unsigned long ulen, unsigned long *n,
> >>  				    int write)
> >>  {
> >>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> >> +	struct pinned_region *region;
> >>  	unsigned long npages, size;
> >>  	int npinned;
> >> -	unsigned long locked, lock_limit;
> >>  	struct page **pages;
> >> -	unsigned long first, last;
> >>  	int ret;
> >>  
> >>  	lockdep_assert_held(&kvm->lock);
> >> @@ -395,15 +413,12 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
> >>  	if (ulen == 0 || uaddr + ulen < uaddr)
> >>  		return ERR_PTR(-EINVAL);
> >>  
> >> -	/* Calculate number of pages. */
> >> -	first = (uaddr & PAGE_MASK) >> PAGE_SHIFT;
> >> -	last = ((uaddr + ulen - 1) & PAGE_MASK) >> PAGE_SHIFT;
> >> -	npages = (last - first + 1);
> >> +	npages = get_npages(uaddr, ulen);
> >>  
> >> -	locked = sev->pages_locked + npages;
> >> -	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> >> -	if (locked > lock_limit && !capable(CAP_IPC_LOCK)) {
> >> -		pr_err("SEV: %lu locked pages exceed the lock limit of %lu.\n", locked, lock_limit);
> >> +	if (rlimit_memlock_exceeds(sev->pages_to_lock, npages)) {
> >> +		pr_err("SEV: %lu locked pages exceed the lock limit of %lu.\n",
> >> +			sev->pages_to_lock + npages,
> >> +			(rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT));
> >>  		return ERR_PTR(-ENOMEM);
> >>  	}
> >>  
> >> @@ -429,7 +444,19 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
> >>  	}
> >>  
> >>  	*n = npages;
> >> -	sev->pages_locked = locked;
> >> +	sev->pages_to_lock += npages;
> >> +
> >> +	/* Maintain region list that is pinned to be unpinned in vm destroy path */
> >> +	region = kzalloc(sizeof(*region), GFP_KERNEL_ACCOUNT);
> >> +	if (!region) {
> >> +		ret = -ENOMEM;
> >> +		goto err;
> >> +	}
> >> +	region->uaddr = uaddr;
> >> +	region->size = ulen;
> >> +	region->pages = pages;
> >> +	region->npages = npages;
> >> +	list_add_tail(&region->list, &sev->pinned_regions_list);
> > 
> > Hmm. I see a duplication of the metadata. We already store the pfns in
> > memslot. But now we also do it in regions. Is this one used for
> > migration purpose?
> 
> We are not duplicating, the enc_region holds regions that are pinned other 
> than svm_register_enc_region(). Later patches add infrastructure to directly 
> fault-in those pages which will use memslot->pfns. 
> 
> > 
> > I might miss some of the context here. 
> 
> More context here:
> https://lore.kernel.org/kvm/CAMkAt6p1-82LTRNB3pkPRwYh=wGpreUN=jcUeBj_dZt8ss9w0Q@mail.gmail.com/

hmm. I think I might got the point. However, logically, I still think we
might not need double data structures for pinning. When vcpu is not
online, we could use the the array in memslot to contain the pinned
pages, right?

Since user-level code is not allowed to pin arbitrary regions of HVA, we
could check that and bail out early if the region goes out of a memslot.

From that point, the only requirement is that we need a valid memslot
before doing memory encryption and pinning. So enc_region is still not
needed from this point.

This should save some time to avoid double pinning and make the pinning
information clear.

> 
> > But we may still have to support
> > the user-level memory pinning API as legacy case. Instead of duplicating
> > the storage, can we change the region list to the list of memslot->pfns
> > instead (Or using the struct **pages in memslot instead of pfns)? This
> > way APIs could still work but we don't need extra storage burden.
> 
> Right, patch 6 and 9 will achieve this using the memslot->pfns when the MMU 
> is active. We still need to maintain this enc_region if the user tries to pin
> memory before MMU is active(i.e. vcpu is online). In my testing, I havent 
> seen enc_region being used, but added to make sure we do not break any userspace.
> 
> > Anyway, I think it might be essentially needed to unify them together,
> > Otherwise, not only the metadata size is quite large, but also it is
> > confusing to have parallel data structures doing the same thing.
> >>
> >>  	return pages;
> >>  
> >> @@ -441,14 +468,43 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
> >>  	return ERR_PTR(ret);
> >>  }
> >>  
> >> -static void sev_unpin_memory(struct kvm *kvm, struct page **pages,
> >> -			     unsigned long npages)
> >> +static void __sev_unpin_memory(struct kvm *kvm, struct page **pages,
> >> +			       unsigned long npages)
> >>  {
> >>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> >>  
> >>  	unpin_user_pages(pages, npages);
> >>  	kvfree(pages);
> >> -	sev->pages_locked -= npages;
> >> +	sev->pages_to_lock -= npages;
> >> +}
> >> +
> >> +static struct pinned_region *find_pinned_region(struct kvm *kvm,
> >> +					     struct page **pages,
> >> +					     unsigned long n)
> >> +{
> >> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> >> +	struct list_head *head = &sev->pinned_regions_list;
> >> +	struct pinned_region *i;
> >> +
> >> +	list_for_each_entry(i, head, list) {
> >> +		if (i->pages == pages && i->npages == n)
> >> +			return i;
> >> +	}
> >> +
> >> +	return NULL;
> >> +}
> >> +
> >> +static void sev_unpin_memory(struct kvm *kvm, struct page **pages,
> >> +			     unsigned long npages)
> >> +{
> >> +	struct pinned_region *region;
> >> +
> >> +	region = find_pinned_region(kvm, pages, npages);
> >> +	__sev_unpin_memory(kvm, pages, npages);
> >> +	if (region) {
> >> +		list_del(&region->list);
> >> +		kfree(region);
> >> +	}
> >>  }
> >>  
> >>  static void sev_clflush_pages(struct page *pages[], unsigned long npages)
> >> @@ -551,8 +607,9 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >>  		set_page_dirty_lock(inpages[i]);
> >>  		mark_page_accessed(inpages[i]);
> >>  	}
> >> -	/* unlock the user pages */
> >> -	sev_unpin_memory(kvm, inpages, npages);
> >> +	/* unlock the user pages on error */
> >> +	if (ret)
> >> +		sev_unpin_memory(kvm, inpages, npages);
> >>  	return ret;
> >>  }
> >>  
> >> @@ -1059,7 +1116,8 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >>  		set_page_dirty_lock(pages[i]);
> >>  		mark_page_accessed(pages[i]);
> >>  	}
> >> -	sev_unpin_memory(kvm, pages, n);
> >> +	if (ret)
> >> +		sev_unpin_memory(kvm, pages, n);
> >>  	return ret;
> >>  }
> >>  
> >> @@ -1338,7 +1396,8 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >>  e_free_hdr:
> >>  	kfree(hdr);
> >>  e_unpin:
> >> -	sev_unpin_memory(kvm, guest_page, n);
> >> +	if (ret)
> >> +		sev_unpin_memory(kvm, guest_page, n);
> >>  
> >>  	return ret;
> >>  }
> >> @@ -1508,7 +1567,8 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >>  	ret = sev_issue_cmd(kvm, SEV_CMD_RECEIVE_UPDATE_DATA, &data,
> >>  				&argp->error);
> >>  
> >> -	sev_unpin_memory(kvm, guest_page, n);
> >> +	if (ret)
> >> +		sev_unpin_memory(kvm, guest_page, n);
> >>  
> >>  e_free_trans:
> >>  	kfree(trans);
> >> @@ -1629,16 +1689,17 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
> >>  	dst->active = true;
> >>  	dst->asid = src->asid;
> >>  	dst->handle = src->handle;
> >> -	dst->pages_locked = src->pages_locked;
> >> +	dst->pages_to_lock = src->pages_to_lock;
> >>  	dst->enc_context_owner = src->enc_context_owner;
> >>  
> >>  	src->asid = 0;
> >>  	src->active = false;
> >>  	src->handle = 0;
> >> -	src->pages_locked = 0;
> >> +	src->pages_to_lock = 0;
> >>  	src->enc_context_owner = NULL;
> >>  
> >> -	list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
> >> +	list_cut_before(&dst->pinned_regions_list, &src->pinned_regions_list,
> >> +			&src->pinned_regions_list);
> >>  }
> >>  
> >>  static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
> >> @@ -1862,8 +1923,7 @@ int svm_register_enc_region(struct kvm *kvm,
> >>  			    struct kvm_enc_region *range)
> >>  {
> >>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> >> -	struct enc_region *region;
> >> -	int ret = 0;
> >> +	unsigned long npages;
> >>  
> >>  	if (!sev_guest(kvm))
> >>  		return -ENOTTY;
> >> @@ -1875,101 +1935,35 @@ int svm_register_enc_region(struct kvm *kvm,
> >>  	if (range->addr > ULONG_MAX || range->size > ULONG_MAX)
> >>  		return -EINVAL;
> >>  
> >> -	region = kzalloc(sizeof(*region), GFP_KERNEL_ACCOUNT);
> >> -	if (!region)
> >> +	npages = get_npages(range->addr, range->size);
> >> +	if (rlimit_memlock_exceeds(sev->pages_to_lock, npages)) {
> >> +		pr_err("SEV: %lu locked pages exceed the lock limit of %lu.\n",
> >> +		       sev->pages_to_lock + npages,
> >> +		       (rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT));
> >>  		return -ENOMEM;
> >> -
> >> -	mutex_lock(&kvm->lock);
> >> -	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
> >> -	if (IS_ERR(region->pages)) {
> >> -		ret = PTR_ERR(region->pages);
> >> -		mutex_unlock(&kvm->lock);
> >> -		goto e_free;
> >>  	}
> >> +	sev->pages_to_lock += npages;
> >>  
> >> -	region->uaddr = range->addr;
> >> -	region->size = range->size;
> >> -
> >> -	list_add_tail(&region->list, &sev->regions_list);
> >> -	mutex_unlock(&kvm->lock);
> >> -
> >> -	/*
> >> -	 * The guest may change the memory encryption attribute from C=0 -> C=1
> >> -	 * or vice versa for this memory range. Lets make sure caches are
> >> -	 * flushed to ensure that guest data gets written into memory with
> >> -	 * correct C-bit.
> >> -	 */
> >> -	sev_clflush_pages(region->pages, region->npages);
> >> -
> >> -	return ret;
> >> -
> >> -e_free:
> >> -	kfree(region);
> >> -	return ret;
> >> -}
> >> -
> >> -static struct enc_region *
> >> -find_enc_region(struct kvm *kvm, struct kvm_enc_region *range)
> >> -{
> >> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> >> -	struct list_head *head = &sev->regions_list;
> >> -	struct enc_region *i;
> >> -
> >> -	list_for_each_entry(i, head, list) {
> >> -		if (i->uaddr == range->addr &&
> >> -		    i->size == range->size)
> >> -			return i;
> >> -	}
> >> -
> >> -	return NULL;
> >> -}
> >> -
> >> -static void __unregister_enc_region_locked(struct kvm *kvm,
> >> -					   struct enc_region *region)
> >> -{
> >> -	sev_unpin_memory(kvm, region->pages, region->npages);
> >> -	list_del(&region->list);
> >> -	kfree(region);
> >> +	return 0;
> >>  }
> >>  
> >>  int svm_unregister_enc_region(struct kvm *kvm,
> >>  			      struct kvm_enc_region *range)
> >>  {
> >> -	struct enc_region *region;
> >> -	int ret;
> >> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> >> +	unsigned long npages;
> >>  
> >>  	/* If kvm is mirroring encryption context it isn't responsible for it */
> >>  	if (is_mirroring_enc_context(kvm))
> >>  		return -EINVAL;
> >>  
> >> -	mutex_lock(&kvm->lock);
> >> -
> >> -	if (!sev_guest(kvm)) {
> >> -		ret = -ENOTTY;
> >> -		goto failed;
> >> -	}
> >> -
> >> -	region = find_enc_region(kvm, range);
> >> -	if (!region) {
> >> -		ret = -EINVAL;
> >> -		goto failed;
> >> -	}
> >> -
> >> -	/*
> >> -	 * Ensure that all guest tagged cache entries are flushed before
> >> -	 * releasing the pages back to the system for use. CLFLUSH will
> >> -	 * not do this, so issue a WBINVD.
> >> -	 */
> >> -	wbinvd_on_all_cpus();
> >> +	if (!sev_guest(kvm))
> >> +		return -ENOTTY;
> >>  
> >> -	__unregister_enc_region_locked(kvm, region);
> >> +	npages = get_npages(range->addr, range->size);
> >> +	sev->pages_to_lock -= npages;
> >>  
> >> -	mutex_unlock(&kvm->lock);
> >>  	return 0;
> >> -
> >> -failed:
> >> -	mutex_unlock(&kvm->lock);
> >> -	return ret;
> >>  }
> >>  
> >>  int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
> >> @@ -2018,7 +2012,7 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
> >>  	mirror_sev->fd = source_sev->fd;
> >>  	mirror_sev->es_active = source_sev->es_active;
> >>  	mirror_sev->handle = source_sev->handle;
> >> -	INIT_LIST_HEAD(&mirror_sev->regions_list);
> >> +	INIT_LIST_HEAD(&mirror_sev->pinned_regions_list);
> >>  	ret = 0;
> >>  
> >>  	/*
> >> @@ -2038,8 +2032,9 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
> >>  void sev_vm_destroy(struct kvm *kvm)
> >>  {
> >>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> >> -	struct list_head *head = &sev->regions_list;
> >> +	struct list_head *head = &sev->pinned_regions_list;
> >>  	struct list_head *pos, *q;
> >> +	struct pinned_region *region;
> >>  
> >>  	WARN_ON(sev->num_mirrored_vms);
> >>  
> >> @@ -2072,8 +2067,14 @@ void sev_vm_destroy(struct kvm *kvm)
> >>  	 */
> >>  	if (!list_empty(head)) {
> >>  		list_for_each_safe(pos, q, head) {
> >> -			__unregister_enc_region_locked(kvm,
> >> -				list_entry(pos, struct enc_region, list));
> >> +			/*
> >> +			 * Unpin the memory that were pinned outside of MMU
> >> +			 * demand pinning
> >> +			 */
> >> +			region = list_entry(pos, struct pinned_region, list);
> >> +			__sev_unpin_memory(kvm, region->pages, region->npages);
> >> +			list_del(&region->list);
> >> +			kfree(region);
> >>  			cond_resched();
> >>  		}
> >>  	}
> >  So the guest memory has already been unpinned in sev_free_memslot().
> >  Why doing it again at here?
> 
> Guest memory that was demand pinned got freed using sev_free_memslot(). Regions that were 
> statically pinned for e.g. SEV_LAUNCH_UPDATE_DATA need to be freed here. This too will be 
> demand pinned in patch 9.
> 
> > 
> >> @@ -2951,13 +2952,96 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
> >>  	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
> >>  }
> >>  
> >> +bool sev_pin_pfn(struct kvm_vcpu *vcpu, struct kvm_memory_slot *memslot,
> >> +		 kvm_pfn_t pfn, hva_t hva, bool write, enum pg_level level)
> >> +{
> >> +	unsigned int npages = KVM_PAGES_PER_HPAGE(level);
> >> +	unsigned int flags = FOLL_LONGTERM, npinned;
> >> +	struct kvm_arch_memory_slot *aslot;
> >> +	struct kvm *kvm = vcpu->kvm;
> >> +	gfn_t gfn_start, rel_gfn;
> >> +	struct page *page[1];
> >> +	kvm_pfn_t old_pfn;
> >> +
> >> +	if (!sev_guest(kvm))
> >> +		return true;
> >> +
> >> +	if (WARN_ON_ONCE(!memslot->arch.pfns))
> >> +		return false;
> >> +
> >> +	if (KVM_BUG_ON(level > PG_LEVEL_1G, kvm))
> >> +		return false;
> >> +
> >> +	hva = ALIGN_DOWN(hva, npages << PAGE_SHIFT);
> >> +	flags |= write ? FOLL_WRITE : 0;
> >> +
> >> +	mutex_lock(&kvm->slots_arch_lock);
> >> +	gfn_start = hva_to_gfn_memslot(hva, memslot);
> >> +	rel_gfn = gfn_start - memslot->base_gfn;
> >> +	aslot = &memslot->arch;
> >> +	if (test_bit(rel_gfn, aslot->pinned_bitmap)) {
> >> +		old_pfn = aslot->pfns[rel_gfn];
> >> +		if (old_pfn == pfn)
> >> +			goto out;
> >> +
> >> +		/* Flush the cache before releasing the page to the system */
> >> +		sev_flush_guest_memory(to_svm(vcpu), __va(old_pfn),
> >> +				       npages * PAGE_SIZE);
> >> +		unpin_user_page(pfn_to_page(old_pfn));
> >> +	}
> >> +	/* Pin the page, KVM doesn't yet support page migration. */
> >> +	npinned = pin_user_pages_fast(hva, 1, flags, page);
> >> +	KVM_BUG(npinned != 1, kvm, "SEV: Pinning failed\n");
> >> +	KVM_BUG(pfn != page_to_pfn(page[0]), kvm, "SEV: pfn mismatch\n");
> >> +
> >> +	if (!this_cpu_has(X86_FEATURE_SME_COHERENT))
> >> +		clflush_cache_range(__va(pfn << PAGE_SHIFT), npages * PAGE_SIZE);
> >> +
> >> +	WARN_ON(rel_gfn >= memslot->npages);
> >> +	aslot->pfns[rel_gfn] = pfn;
> >> +	set_bit(rel_gfn, aslot->pinned_bitmap);
> >> +
> >> +out:
> >> +	mutex_unlock(&kvm->slots_arch_lock);
> >> +	return true;
> >> +}
> >> +
> >>  void sev_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
> >>  {
> >>  	struct kvm_arch_memory_slot *aslot = &slot->arch;
> >> +	kvm_pfn_t *pfns;
> >> +	gfn_t gfn;
> >> +	int i;
> >>  
> >>  	if (!sev_guest(kvm))
> >>  		return;
> >>  
> >> +	if (!aslot->pinned_bitmap || !slot->arch.pfns)
> >> +		goto out;
> >> +
> >> +	pfns = aslot->pfns;
> >> +
> >> +	/*
> >> +	 * Ensure that all guest tagged cache entries are flushed before
> >> +	 * releasing the pages back to the system for use. CLFLUSH will
> >> +	 * not do this, so issue a WBINVD.
> >> +	 */
> >> +	wbinvd_on_all_cpus();
> > 
> > This is a heavy-weight operation and is essentially only needed at most
> > once per VM shutdown. So, better using smaller hammer in the following
> > code. Or, alternatively, maybe passing a boolean from caller to avoid
> > flushing if true.
> 
> Or maybe I can do this in sev_vm_destroy() patch?
> 
> >> +
> >> +	/*
> >> +	 * Iterate the memslot to find the pinned pfn using the bitmap and drop
> >> +	 * the pfn stored.
> >> +	 */
> >> +	for (i = 0, gfn = slot->base_gfn; i < slot->npages; i++, gfn++) {
> >> +		if (test_and_clear_bit(i, aslot->pinned_bitmap)) {
> >> +			if (WARN_ON(!pfns[i]))
> >> +				continue;
> >> +
> >> +			unpin_user_page(pfn_to_page(pfns[i]));
> >> +		}
> >> +	}
> >> +
> >> +out:
> >>  	if (aslot->pinned_bitmap) {
> >>  		kvfree(aslot->pinned_bitmap);
> >>  		aslot->pinned_bitmap = NULL;
> >> @@ -2992,6 +3076,8 @@ int sev_alloc_memslot_metadata(struct kvm *kvm,
> >>  		return -ENOMEM;
> >>  
> >>  	aslot->pinned_bitmap = kvzalloc(pinned_bytes, GFP_KERNEL_ACCOUNT);
> >> +	new->flags |= KVM_MEMSLOT_ENCRYPTED;
> >> +
> >>  	if (!aslot->pinned_bitmap) {
> >>  		kvfree(aslot->pfns);
> >>  		aslot->pfns = NULL;
> >> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> >> index ec06421cb532..463a90ed6f83 100644
> >> --- a/arch/x86/kvm/svm/svm.c
> >> +++ b/arch/x86/kvm/svm/svm.c
> >> @@ -4661,6 +4661,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
> >>  
> >>  	.alloc_memslot_metadata = sev_alloc_memslot_metadata,
> >>  	.free_memslot = sev_free_memslot,
> >> +	.pin_pfn = sev_pin_pfn,
> >>  };
> >>  
> >>  /*
> >> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> >> index f00364020d7e..2f38e793ead0 100644
> >> --- a/arch/x86/kvm/svm/svm.h
> >> +++ b/arch/x86/kvm/svm/svm.h
> >> @@ -75,8 +75,8 @@ struct kvm_sev_info {
> >>  	unsigned int asid;	/* ASID used for this guest */
> >>  	unsigned int handle;	/* SEV firmware handle */
> >>  	int fd;			/* SEV device fd */
> >> -	unsigned long pages_locked; /* Number of pages locked */
> >> -	struct list_head regions_list;  /* List of registered regions */
> >> +	unsigned long pages_to_lock; /* Number of page that can be locked */
> >> +	struct list_head pinned_regions_list;  /* List of pinned regions */
> >>  	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
> >>  	struct kvm *enc_context_owner; /* Owner of copied encryption context */
> >>  	unsigned long num_mirrored_vms; /* Number of VMs sharing this ASID */
> >> @@ -621,5 +621,7 @@ int sev_alloc_memslot_metadata(struct kvm *kvm,
> >>  			       struct kvm_memory_slot *new);
> >>  void sev_free_memslot(struct kvm *kvm,
> >>  		      struct kvm_memory_slot *slot);
> >> +bool sev_pin_pfn(struct kvm_vcpu *vcpu, struct kvm_memory_slot *memslot,
> >> +		 kvm_pfn_t pfn, hva_t hva, bool write, enum pg_level level);
> >>  
> >>  #endif
> >> -- 
> >> 2.32.0
> >>
> 
> Thanks for the review.
> 
> Regards
> Nikunj
