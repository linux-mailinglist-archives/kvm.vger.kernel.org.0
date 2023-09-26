Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21F77AE6DE
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 09:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbjIZHb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 03:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbjIZHby (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 03:31:54 -0400
X-Greylist: delayed 506 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 26 Sep 2023 00:31:47 PDT
Received: from out-191.mta1.migadu.com (out-191.mta1.migadu.com [IPv6:2001:41d0:203:375::bf])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBCEE5
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 00:31:47 -0700 (PDT)
Date:   Tue, 26 Sep 2023 16:23:04 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695712997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BvRA0dd23uBXtSD25I/QeRtNIPOHGZm8ZMHnOsFVoZ4=;
        b=LUp0XQQPxIGFGKFD8YiV/LErHCv15nOiAH9xMvyneEYgX6e+7raX0nG2FsKCqWnBg+7xhz
        Tzgjf5D/foGY8VqyfwaGW1LXXzgag947Cdl4p8IuzPRbqiUmULLrLKrWR6iQGfip1OlH+a
        xNLm8Pzvj3fzbVTgk7PlNJRF+uFoBtE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Naoya Horiguchi <naoya.horiguchi@linux.dev>
To:     ankita@nvidia.com
Cc:     jgg@nvidia.com, alex.williamson@redhat.com,
        akpm@linux-foundation.org, tony.luck@intel.com, bp@alien8.de,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com, aniketa@nvidia.com,
        cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
        vsethi@nvidia.com, acurrid@nvidia.com, anuaggarwal@nvidia.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-edac@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v1 1/4] mm: handle poisoning of pfn without struct pages
Message-ID: <20230926072304.GA1344149@ik1-406-35019.vs.sakura.ne.jp>
References: <20230920140210.12663-1-ankita@nvidia.com>
 <20230920140210.12663-2-ankita@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230920140210.12663-2-ankita@nvidia.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 20, 2023 at 07:32:07PM +0530, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The kernel MM currently does not handle ECC errors / poison on a memory
> region that is not backed by struct pages. If a memory region is mapped
> using remap_pfn_range(), but not added to the kernel, MM will not have
> associated struct pages. Add a new mechanism to handle memory failure
> on such memory.
> 
> Make kernel MM expose a function to allow modules managing the device
> memory to register a failure function and the physical address space
> associated with the device memory. MM maintains this information as
> interval tree. The registered memory failure function is used by MM to
> notify the kernel module managing the PFN, so that the module may take
> any required action. The module for example may use the information
> to track the poisoned pages.
> 
> In this implementation, kernel MM follows the following sequence similar
> (mostly) to the memory_failure() handler for struct page backed memory:
> 1. memory_failure() is triggered on reception of a poison error. An
> absence of struct page is detected and consequently memory_failure_pfn()
> is executed.
> 2. memory_failure_pfn() call the newly introduced failure handler exposed
> by the module managing the poisoned memory to notify it of the problematic
> PFN.
> 3. memory_failure_pfn() unmaps the stage-2 mapping to the PFN.
> 4. memory_failure_pfn() collects the processes mapped to the PFN.
> 5. memory_failure_pfn() sends SIGBUS (BUS_MCEERR_AO) to all the processes
> mapping the faulty PFN using kill_procs().
> 6. An access to the faulty PFN by an operation in VM at a later point
> is trapped and user_mem_abort() is called.
> 7. The vma ops fault function gets called due to the absence of Stage-2
> mapping. It is expected to return VM_FAULT_HWPOISON on the PFN.
> 8. __gfn_to_pfn_memslot() then returns KVM_PFN_ERR_HWPOISON, which cause
> the poison with SIGBUS (BUS_MCEERR_AR) to be sent to the QEMU process
> through kvm_send_hwpoison_signal().
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>

Thanks for the patches.

A few comment below ...

...

> @@ -422,15 +428,15 @@ static unsigned long dev_pagemap_mapping_shift(struct vm_area_struct *vma,
>   * Schedule a process for later kill.
>   * Uses GFP_ATOMIC allocations to avoid potential recursions in the VM.
>   *
> - * Note: @fsdax_pgoff is used only when @p is a fsdax page and a
> - * filesystem with a memory failure handler has claimed the
> - * memory_failure event. In all other cases, page->index and
> - * page->mapping are sufficient for mapping the page back to its
> + * Notice: @pgoff is used either when @p is a fsdax page or a PFN is not
> + * backed by struct page and a filesystem with a memory failure handler
> + * has claimed the memory_failure event.

This sentense is unclear because latter part ("a filesystem with ...")
is not true for pfns not backed by struct page.  Could you separate this
notice into two (one for fsdax case and one for "non struct page" case)?

> In all other cases, page->index
> + * and page->mapping are sufficient for mapping the page back to its
>   * corresponding user virtual address.
>   */
>  static void __add_to_kill(struct task_struct *tsk, struct page *p,
>  			  struct vm_area_struct *vma, struct list_head *to_kill,
> -			  unsigned long ksm_addr, pgoff_t fsdax_pgoff)
> +			  unsigned long ksm_addr, pgoff_t pgoff)
>  {
>  	struct to_kill *tk;
>  

...

> @@ -677,9 +687,9 @@ static void add_to_kill_fsdax(struct task_struct *tsk, struct page *p,
>  /*
>   * Collect processes when the error hit a fsdax page.

Maybe you need update the comment not to restrict to fsdax page?

>   */
> -static void collect_procs_fsdax(struct page *page,
> -		struct address_space *mapping, pgoff_t pgoff,
> -		struct list_head *to_kill)
> +static void collect_procs_pgoff(struct page *page,
> +				struct address_space *mapping, pgoff_t pgoff,
> +				struct list_head *to_kill)
>  {
>  	struct vm_area_struct *vma;
>  	struct task_struct *tsk;

...

> @@ -2144,6 +2155,83 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
>  	return rc;
>  }
>  
> +int register_pfn_address_space(struct pfn_address_space *pfn_space)
> +{
> +	if (!pfn_space)
> +		return -EINVAL;
> +
> +	if (!request_mem_region(pfn_space->node.start << PAGE_SHIFT,
> +		(pfn_space->node.last - pfn_space->node.start + 1) << PAGE_SHIFT, ""))
> +		return -EBUSY;
> +
> +	mutex_lock(&pfn_space_lock);
> +	interval_tree_insert(&pfn_space->node, &pfn_space_itree);
> +	mutex_unlock(&pfn_space_lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(register_pfn_address_space);
> +
> +void unregister_pfn_address_space(struct pfn_address_space *pfn_space)
> +{
> +	if (!pfn_space)
> +		return;
> +
> +	mutex_lock(&pfn_space_lock);
> +	interval_tree_remove(&pfn_space->node, &pfn_space_itree);
> +	mutex_unlock(&pfn_space_lock);
> +	release_mem_region(pfn_space->node.start << PAGE_SHIFT,
> +		(pfn_space->node.last - pfn_space->node.start + 1) << PAGE_SHIFT);
> +}
> +EXPORT_SYMBOL_GPL(unregister_pfn_address_space);
> +
> +static int memory_failure_pfn(unsigned long pfn, int flags)
> +{
> +	struct interval_tree_node *node;
> +	int res = MF_FAILED;
> +	LIST_HEAD(tokill);
> +
> +	mutex_lock(&pfn_space_lock);
> +	/*
> +	 * Modules registers with MM the address space mapping to the device memory they
> +	 * manage. Iterate to identify exactly which address space has mapped to this
> +	 * failing PFN.
> +	 */
> +	for (node = interval_tree_iter_first(&pfn_space_itree, pfn, pfn); node;
> +	     node = interval_tree_iter_next(node, pfn, pfn)) {
> +		struct pfn_address_space *pfn_space =
> +			container_of(node, struct pfn_address_space, node);
> +		/*
> +		 * Modules managing the device memory need to be conveyed about the
> +		 * memory failure so that the poisoned PFN can be tracked.
> +		 */
> +		if (pfn_space->ops)
> +			pfn_space->ops->failure(pfn_space, pfn);
> +
> +		collect_procs_pgoff(NULL, pfn_space->mapping, pfn, &tokill);
> +
> +		unmap_mapping_range(pfn_space->mapping, pfn << PAGE_SHIFT,
> +				    PAGE_SIZE, 0);
> +
> +		res = MF_RECOVERED;
> +	}
> +	mutex_unlock(&pfn_space_lock);
> +
> +	if (res == MF_FAILED)
> +		return action_result(pfn, MF_MSG_PFN_MAP, res);
> +
> +	/*
> +	 * Unlike System-RAM there is no possibility to swap in a different
> +	 * physical page at a given virtual address, so all userspace
> +	 * consumption of direct PFN memory necessitates SIGBUS (i.e.
> +	 * MF_MUST_KILL)
> +	 */
> +	flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
> +	kill_procs(&tokill, true, false, pfn, flags);
> +
> +	return action_result(pfn, MF_MSG_PFN_MAP, MF_RECOVERED);
> +}
> +

It might not be a major issue, but these new code above seems to be used
only when CONFIG_NVGRACE_GPU_VFIO_PCI is enabled, so putting this in
#ifdef block might be helpful to save binary size without nvgrace-gpu-vfio-pci.

Thanks,
Naoya Horiguchi

>  /**
>   * memory_failure - Handle memory failure of a page.
>   * @pfn: Page Number of the corrupted page
> @@ -2183,6 +2271,11 @@ int memory_failure(unsigned long pfn, int flags)
>  	if (!(flags & MF_SW_SIMULATED))
>  		hw_memory_failure = true;
>  
> +	if (!pfn_valid(pfn) && !arch_is_platform_page(PFN_PHYS(pfn))) {
> +		res = memory_failure_pfn(pfn, flags);
> +		goto unlock_mutex;
> +	}
> +
>  	p = pfn_to_online_page(pfn);
>  	if (!p) {
>  		res = arch_memory_failure(pfn, flags);
> -- 
> 2.17.1
> 
> 
> 
