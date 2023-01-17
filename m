Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B55670E75
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 01:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjARAOT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 19:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjARAN4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 19:13:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E798CD200;
        Tue, 17 Jan 2023 15:31:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7640761588;
        Tue, 17 Jan 2023 23:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E87AC433EF;
        Tue, 17 Jan 2023 23:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673998263;
        bh=gX7M02TttoCc8S5RPwEXyV27eIRgsayZQ2pGPcyLZ3M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ixzAcMagECl/baI4IaKYNOpGdQJOJkjkfXvuJn87XqFVcXiosbOzAmy96L8R0nGiD
         9+zsVxepnnCJhKPfWv3acTFjNcVBYfSWEaLGw0TcWDtuafprlLKoH8L2ZZOyTqeIQl
         +yl/lDlTOuGpnQiS/0o5KBF1BwW73ZnoJAJtdRzZR1mnKqjrkANaZN6L9XrwfH0ANP
         k02FE2C3dEuYdsmcWUc73EdzYdLH/Ln5GuOhk37qqYeZYTAZISbRt5f1FEBTrTuM2I
         je/v+iTB/IvQ4ppRIdzhyFIGT6CZ4JTNstc9MyXk9gtXYiXTRGjz4vHKK68XqKGQG3
         +DtD30WIT6xig==
Date:   Wed, 18 Jan 2023 01:30:57 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, ashish.kalra@amd.com, harald@profian.com,
        Nikunj A Dadhania <nikunj@amd.com>
Subject: Re: [PATCH RFC v7 11/64] KVM: SEV: Support private pages in
 LAUNCH_UPDATE_DATA
Message-ID: <Y8cvsS27o1BaUNPz@kernel.org>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-12-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214194056.161492-12-michael.roth@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022 at 01:40:03PM -0600, Michael Roth wrote:
> From: Nikunj A Dadhania <nikunj@amd.com>
> 
> Pre-boot guest payload needs to be encrypted and VMM has copied it
> over to the private-fd. Add support to get the pfn from the memfile fd
> for encrypting the payload in-place.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 79 ++++++++++++++++++++++++++++++++++--------
>  1 file changed, 64 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a7e4e3005786..ae4920aeb281 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -107,6 +107,11 @@ static inline bool is_mirroring_enc_context(struct kvm *kvm)
>  	return !!to_kvm_svm(kvm)->sev_info.enc_context_owner;
>  }
>  
> +static bool kvm_is_upm_enabled(struct kvm *kvm)
> +{
> +	return kvm->arch.upm_mode;
> +}
> +
>  /* Must be called with the sev_bitmap_lock held */
>  static bool __sev_recycle_asids(int min_asid, int max_asid)
>  {
> @@ -382,6 +387,38 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return ret;
>  }
>  
> +static int sev_get_memfile_pfn_handler(struct kvm *kvm, struct kvm_gfn_range *range, void *data)
> +{
> +	struct kvm_memory_slot *memslot = range->slot;
> +	struct page **pages = data;
> +	int ret = 0, i = 0;
> +	kvm_pfn_t pfn;
> +	gfn_t gfn;
> +
> +	for (gfn = range->start; gfn < range->end; gfn++) {
> +		int order;
> +
> +		ret = kvm_restricted_mem_get_pfn(memslot, gfn, &pfn, &order);
> +		if (ret)
> +			return ret;
> +
> +		if (is_error_noslot_pfn(pfn))
> +			return -EFAULT;
> +
> +		pages[i++] = pfn_to_page(pfn);
> +	}
> +
> +	return ret;
> +}
> +
> +static int sev_get_memfile_pfn(struct kvm *kvm, unsigned long addr,
> +			       unsigned long size, unsigned long npages,
> +			       struct page **pages)
> +{
> +	return kvm_vm_do_hva_range_op(kvm, addr, size,
> +				      sev_get_memfile_pfn_handler, pages);
> +}
> +
>  static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>  				    unsigned long ulen, unsigned long *n,
>  				    int write)
> @@ -424,16 +461,25 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>  	if (!pages)
>  		return ERR_PTR(-ENOMEM);
>  
> -	/* Pin the user virtual address. */
> -	npinned = pin_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pages);
> -	if (npinned != npages) {
> -		pr_err("SEV: Failure locking %lu pages.\n", npages);
> -		ret = -ENOMEM;
> -		goto err;
> +	if (kvm_is_upm_enabled(kvm)) {
> +		/* Get the PFN from memfile */
> +		if (sev_get_memfile_pfn(kvm, uaddr, ulen, npages, pages)) {
> +			pr_err("%s: ERROR: unable to find slot for uaddr %lx", __func__, uaddr);
> +			ret = -ENOMEM;
> +			goto err;
> +		}
> +	} else {
> +		/* Pin the user virtual address. */
> +		npinned = pin_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pages);
> +		if (npinned != npages) {
> +			pr_err("SEV: Failure locking %lu pages.\n", npages);
> +			ret = -ENOMEM;
> +			goto err;
> +		}
> +		sev->pages_locked = locked;
>  	}
>  
>  	*n = npages;
> -	sev->pages_locked = locked;
>  
>  	return pages;
>  
> @@ -514,6 +560,7 @@ static int sev_launch_update_shared_gfn_handler(struct kvm *kvm,
>  
>  	size = (range->end - range->start) << PAGE_SHIFT;
>  	vaddr_end = vaddr + size;
> +	WARN_ON(size < PAGE_SIZE);
>  
>  	/* Lock the user memory. */
>  	inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1);
> @@ -554,13 +601,16 @@ static int sev_launch_update_shared_gfn_handler(struct kvm *kvm,
>  	}
>  
>  e_unpin:
> -	/* content of memory is updated, mark pages dirty */
> -	for (i = 0; i < npages; i++) {
> -		set_page_dirty_lock(inpages[i]);
> -		mark_page_accessed(inpages[i]);
> +	if (!kvm_is_upm_enabled(kvm)) {
> +		/* content of memory is updated, mark pages dirty */
> +		for (i = 0; i < npages; i++) {
> +			set_page_dirty_lock(inpages[i]);
> +			mark_page_accessed(inpages[i]);
> +		}
> +		/* unlock the user pages */
> +		sev_unpin_memory(kvm, inpages, npages);
>  	}
> -	/* unlock the user pages */
> -	sev_unpin_memory(kvm, inpages, npages);
> +
>  	return ret;
>  }
>  
> @@ -609,9 +659,8 @@ static int sev_launch_update_priv_gfn_handler(struct kvm *kvm,
>  			goto e_ret;
>  		kvm_release_pfn_clean(pfn);
>  	}
> -	kvm_vm_set_region_attr(kvm, range->start, range->end,
> -		true /* priv_attr */);
>  
> +	kvm_vm_set_region_attr(kvm, range->start, range->end, KVM_MEMORY_ATTRIBUTE_PRIVATE);
>  e_ret:
>  	return ret;
>  }
> -- 
> 2.25.1
> 

kvm_vm_set_region_attr() should be fixed already in:

https://lore.kernel.org/all/20221214194056.161492-11-michael.roth@amd.com/

BR, Jarkko

