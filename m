Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28C6670E90
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 01:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjARAYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 19:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjARAYS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 19:24:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F333EFC9;
        Tue, 17 Jan 2023 15:42:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C2F461587;
        Tue, 17 Jan 2023 23:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D95C433EF;
        Tue, 17 Jan 2023 23:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673998970;
        bh=2ikdQhWN8QnY8MY7pt8CC+l4LYugedIuQZfZ7a0yhEU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r/1d4gQ7cape7g9hFv8XNl0XZBEZ0EVwPauBC4bqmnCoGOF+Xy+qUbw2jwW6F9vvZ
         pVmYoRCzPA7YHryO/T0MH8YnOJXt0x4w2NzJ1ACiA5g/5vPjW519asy8n+GAnyMimK
         sb06Z4wbntGBSR9tr8RZD6PYKrmIg1jc4sHeTiLeVELEsNxDwUkoohhtbCJEaQ7HRF
         yI74gK0GdlqeWP0T8Y3RVRLOobjIJcMWIfHibmefBamQhUMzKiAdSE/SoUuntNsHbc
         DNg0yxLMPeXtXszECrO3bClqp8i39Vug7emnDggHcfVbbg3/E6KmSMn+0e1TATY4XX
         iowUzbxk9j9ag==
Date:   Wed, 18 Jan 2023 01:42:45 +0200
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
        Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH RFC v7 10/64] KVM: SEV: Populate private memory fd during
 LAUNCH_UPDATE_DATA
Message-ID: <Y8cydYUfTUFwCh4K@kernel.org>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-11-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214194056.161492-11-michael.roth@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022 at 01:40:02PM -0600, Michael Roth wrote:
> From: Vishal Annapurve <vannapurve@google.com>
> 
> This change adds handling of HVA ranges to copy contents
> to private memory while doing sev launch update data.
> 
> mem_attr array is updated during LAUNCH_UPDATE_DATA to ensure
> that encrypted memory is marked as private.
> 
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> [mdr: use gfn_to_hva_memslot_prot() for shared GFN handler to deal with
>       read-only slots for ROMs]
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c   | 99 ++++++++++++++++++++++++++++++++++++----
>  include/linux/kvm_host.h |  1 +
>  virt/kvm/kvm_main.c      | 27 ++++++++---
>  3 files changed, 111 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 69dbf17f0d6a..a7e4e3005786 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -493,23 +493,26 @@ static unsigned long get_num_contig_pages(unsigned long idx,
>  	return pages;
>  }
>  
> -static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +static int sev_launch_update_shared_gfn_handler(struct kvm *kvm,
> +						struct kvm_gfn_range *range,
> +						struct kvm_sev_cmd *argp)
>  {
>  	unsigned long vaddr, vaddr_end, next_vaddr, npages, pages, size, i;
>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -	struct kvm_sev_launch_update_data params;
>  	struct sev_data_launch_update_data data;
>  	struct page **inpages;
>  	int ret;
>  
> -	if (!sev_guest(kvm))
> -		return -ENOTTY;
> -
> -	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
> -		return -EFAULT;
> +	vaddr = gfn_to_hva_memslot_prot(range->slot, range->start, NULL);
> +	pr_debug("%s: shared GFN: %llx, slot.id: %d, slot.base_gfn: %llx, slot.userspace_addr: %lx, slot.flags: %x, vaddr: %lx\n",
> +		 __func__, range->start, range->slot->id, range->slot->base_gfn,
> +		 range->slot->userspace_addr, range->slot->flags, vaddr);
> +	if (kvm_is_error_hva(vaddr)) {
> +		pr_err("vaddr is erroneous 0x%lx\n", vaddr);
> +		return -EINVAL;
> +	}
>  
> -	vaddr = params.uaddr;
> -	size = params.len;
> +	size = (range->end - range->start) << PAGE_SHIFT;
>  	vaddr_end = vaddr + size;
>  
>  	/* Lock the user memory. */
> @@ -561,6 +564,84 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return ret;
>  }
>  
> +static int sev_launch_update_priv_gfn_handler(struct kvm *kvm,
> +					      struct kvm_gfn_range *range,
> +					      struct kvm_sev_cmd *argp)
> +{
> +	struct sev_data_launch_update_data data;
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	gfn_t gfn;
> +	kvm_pfn_t pfn;
> +	struct kvm_memory_slot *memslot = range->slot;
> +	int ret = 0;
> +
> +	data.reserved = 0;
> +	data.handle = sev->handle;
> +
> +	for (gfn = range->start; gfn < range->end; gfn++) {
> +		int order;
> +		void *kvaddr;
> +
> +		ret = kvm_restricted_mem_get_pfn(memslot, gfn, &pfn, &order);
> +		if (ret)
> +			return ret;
> +
> +		kvaddr = pfn_to_kaddr(pfn);
> +		if (!virt_addr_valid(kvaddr)) {
> +			pr_err("Invalid kvaddr 0x%llx\n", (uint64_t)kvaddr);
> +			ret = -EINVAL;
> +			goto e_ret;
> +		}
> +
> +		ret = kvm_read_guest_page(kvm, gfn, kvaddr, 0, PAGE_SIZE);
> +		if (ret) {
> +			pr_err("guest read failed 0x%x\n", ret);
> +			goto e_ret;
> +		}
> +
> +		if (!this_cpu_has(X86_FEATURE_SME_COHERENT))
> +			clflush_cache_range(kvaddr, PAGE_SIZE);
> +
> +		data.len = PAGE_SIZE;
> +		data.address = __sme_set(pfn << PAGE_SHIFT);
> +		ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_DATA, &data, &argp->error);
> +		if (ret)
> +			goto e_ret;
> +		kvm_release_pfn_clean(pfn);
> +	}
> +	kvm_vm_set_region_attr(kvm, range->start, range->end,
> +		true /* priv_attr */);
> +
> +e_ret:
> +	return ret;
> +}
> +
> +static int sev_launch_update_gfn_handler(struct kvm *kvm, struct kvm_gfn_range *range,
> +					 void *data)
> +{
> +	struct kvm_sev_cmd *argp = (struct kvm_sev_cmd *)data;
> +
> +	if (kvm_slot_can_be_private(range->slot))
> +		return sev_launch_update_priv_gfn_handler(kvm, range, argp);
> +
> +	return sev_launch_update_shared_gfn_handler(kvm, range, argp);
> +}
> +
> +static int sev_launch_update_data(struct kvm *kvm,
> +		struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_launch_update_data params;
> +
> +	if (!sev_guest(kvm))
> +		return -ENOTTY;
> +
> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
> +		return -EFAULT;
> +
> +	return kvm_vm_do_hva_range_op(kvm, params.uaddr, params.uaddr + params.len,
> +		sev_launch_update_gfn_handler, argp);
> +}
> +
>  static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>  {
>  	struct sev_es_save_area *save = svm->sev_es.vmsa;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 21a539ab17f6..33fa0b1435d3 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -973,6 +973,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  void kvm_exit(void);
>  
>  void kvm_get_kvm(struct kvm *kvm);
> +int kvm_vm_set_region_attr(struct kvm *kvm, gfn_t start, gfn_t end, u64 attributes);
>  bool kvm_get_kvm_safe(struct kvm *kvm);
>  void kvm_put_kvm(struct kvm *kvm);
>  bool file_is_kvm(struct file *file);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 4ff7adaf6c56..1343070657d1 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -747,6 +747,7 @@ int kvm_vm_do_hva_range_op(struct kvm *kvm, unsigned long hva_start,
>  
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(kvm_vm_do_hva_range_op);
>  
>  static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
>  						unsigned long start,
> @@ -2595,12 +2596,28 @@ static void kvm_unmap_mem_range(struct kvm *kvm, gfn_t start, gfn_t end,
>  		kvm_flush_remote_tlbs(kvm);
>  }
>  
> +int kvm_vm_set_region_attr(struct kvm *kvm, gfn_t start, gfn_t end,
> +			   u64 attributes)
> +{
> +	gfn_t index;
> +	void *entry;
> +
> +	entry = attributes ? xa_mk_value(attributes) : NULL;
> +
> +	for (index = start; index < end; index++)
> +		if (xa_err(xa_store(&kvm->mem_attr_array, index, entry,
> +				    GFP_KERNEL_ACCOUNT)))
> +			break;
> +
> +	return index;
> +}
> +EXPORT_SYMBOL_GPL(kvm_vm_set_region_attr);
> +
>  static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
>  					   struct kvm_memory_attributes *attrs)
>  {
>  	gfn_t start, end;
>  	unsigned long i;
> -	void *entry;
>  	int idx;
>  	u64 supported_attrs = kvm_supported_mem_attributes(kvm);
>  
> @@ -2617,8 +2634,6 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
>  	start = attrs->address >> PAGE_SHIFT;
>  	end = (attrs->address + attrs->size - 1 + PAGE_SIZE) >> PAGE_SHIFT;
>  
> -	entry = attrs->attributes ? xa_mk_value(attrs->attributes) : NULL;
> -
>  	if (kvm_arch_has_private_mem(kvm)) {
>  		KVM_MMU_LOCK(kvm);
>  		kvm_mmu_invalidate_begin(kvm);
> @@ -2627,10 +2642,7 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
>  	}
>  
>  	mutex_lock(&kvm->lock);
> -	for (i = start; i < end; i++)
> -		if (xa_err(xa_store(&kvm->mem_attr_array, i, entry,
> -				    GFP_KERNEL_ACCOUNT)))
> -			break;
> +	i = kvm_vm_set_region_attr(kvm, start, end, attrs->attributes);
>  	mutex_unlock(&kvm->lock);
>  
>  	if (kvm_arch_has_private_mem(kvm)) {
> @@ -2793,6 +2805,7 @@ unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot,
>  
>  	return hva;
>  }
> +EXPORT_SYMBOL_GPL(gfn_to_hva_memslot_prot);
>  
>  unsigned long gfn_to_hva_prot(struct kvm *kvm, gfn_t gfn, bool *writable)
>  {
> -- 
> 2.25.1
> 

Hmm.. but user space is still allowed to call KVM_SET_MEMORY_ATTRIBUTES
with KVM_MEMORY_ATTRIBUTE_PRIVATE set? How do these behaviours complement
each other?

SEV specific changes and kvm_vm_set_region_attr() definition should really
be separate patches.

BR, Jarkko
