Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB3267ABD90
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 05:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjIWDUg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 23:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjIWDUf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 23:20:35 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9827CA9;
        Fri, 22 Sep 2023 20:20:24 -0700 (PDT)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RsvRR2mGTztS3d;
        Sat, 23 Sep 2023 11:16:03 +0800 (CST)
Received: from [10.174.151.185] (10.174.151.185) by
 canpemm500002.china.huawei.com (7.192.104.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Sat, 23 Sep 2023 11:20:19 +0800
Subject: Re: [PATCH v1 1/4] mm: handle poisoning of pfn without struct pages
To:     <ankita@nvidia.com>
CC:     <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
        <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
        <anuaggarwal@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-edac@vger.kernel.org>,
        <kvm@vger.kernel.org>, <jgg@nvidia.com>,
        <alex.williamson@redhat.com>, <akpm@linux-foundation.org>,
        <tony.luck@intel.com>, <bp@alien8.de>, <naoya.horiguchi@nec.com>
References: <20230920140210.12663-1-ankita@nvidia.com>
 <20230920140210.12663-2-ankita@nvidia.com>
From:   Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <878264ae-f6f6-04d9-2d52-fb7ae29dca85@huawei.com>
Date:   Sat, 23 Sep 2023 11:20:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20230920140210.12663-2-ankita@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.151.185]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/9/20 22:02, ankita@nvidia.com wrote:
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

Thanks for your patch.

<snip>

>  /*
>   * Return values:
>   *   1:   the page is dissolved (if needed) and taken off from buddy,
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
> + * has claimed the memory_failure event. In all other cases, page->index
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
> @@ -440,13 +446,18 @@ static void __add_to_kill(struct task_struct *tsk, struct page *p,
>  		return;
>  	}
>  
> -	tk->addr = ksm_addr ? ksm_addr : page_address_in_vma(p, vma);
> -	if (is_zone_device_page(p)) {
> -		if (fsdax_pgoff != FSDAX_INVALID_PGOFF)
> -			tk->addr = vma_pgoff_address(fsdax_pgoff, 1, vma);
> -		tk->size_shift = dev_pagemap_mapping_shift(vma, tk->addr);
> -	} else
> -		tk->size_shift = page_shift(compound_head(p));
> +	if (vma->vm_flags | PFN_MAP) {

if (vma->vm_flags | PFN_MAP)? So this branch is always selected?

> +		tk->addr = vma_pgoff_address(pgoff, 1, vma);
> +		tk->size_shift = PAGE_SHIFT;
> +	} else {
> +		tk->addr = ksm_addr ? ksm_addr : page_address_in_vma(p, vma);
> +		if (is_zone_device_page(p)) {
> +			if (pgoff != FSDAX_INVALID_PGOFF)
> +				tk->addr = vma_pgoff_address(pgoff, 1, vma);
> +			tk->size_shift = dev_pagemap_mapping_shift(vma, tk->addr);
> +		} else
> +			tk->size_shift = page_shift(compound_head(p));
> +	}
>  

IIUC, the page passed to __add_to_kill is NULL in this case. So when tk->addr == -EFAULT, we will have problem
to do the page_to_pfn(p) in the following pr_info:

	if (tk->addr == -EFAULT) {
		pr_info("Unable to find user space address %lx in %s\n",
			page_to_pfn(p), tsk->comm);

>  	/*
>  	 * Send SIGKILL if "tk->addr == -EFAULT". Also, as
> @@ -666,8 +677,7 @@ static void collect_procs_file(struct page *page, struct list_head *to_kill,
>  	i_mmap_unlock_read(mapping);
>  }
>  

<snip>

>  /**
>   * memory_failure - Handle memory failure of a page.
>   * @pfn: Page Number of the corrupted page
> @@ -2183,6 +2271,11 @@ int memory_failure(unsigned long pfn, int flags)
>  	if (!(flags & MF_SW_SIMULATED))
>  		hw_memory_failure = true;
>  
> +	if (!pfn_valid(pfn) && !arch_is_platform_page(PFN_PHYS(pfn))) {

Could it be better to add a helper here to detect the pfns without struct page?

> +		res = memory_failure_pfn(pfn, flags);
> +		goto unlock_mutex;
> +	}
> +
>  	p = pfn_to_online_page(pfn);
>  	if (!p) {
>  		res = arch_memory_failure(pfn, flags);
> 

Thanks.
