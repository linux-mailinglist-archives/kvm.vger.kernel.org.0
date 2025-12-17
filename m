Return-Path: <kvm+bounces-66102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 39CA5CC5DE6
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 04:10:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 37FBA301CD06
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 03:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16EC029BD94;
	Wed, 17 Dec 2025 03:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="KCvIGR+6"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F043B1B3;
	Wed, 17 Dec 2025 03:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765941019; cv=none; b=Upg45I6J4lEr53Wv2LY60NgbuP+3mOhadaDa6TT5bOI7EdvOZp7oj7brw3b9tp52F3XbmW4deZWWKmpHUgI8DNrA0xfpjhaNenVCVB0kOrmxy8crl/9P91v1tlX8oiw1t5QEL1exjq10T0Uoux82YeScj9MRB3oPbFN1MO+11cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765941019; c=relaxed/simple;
	bh=WNqHZI7KJTkRxa7G8xlCYAKQ66Di7c7gSmm2tzvuM34=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=qAuqK4GCc/HuI2FDzPx12FA8XtPn6zFnl8ZKfHG1DsEvDlFO2undj09HfTjRAyK+SCMT7zg7v2HB55pct3KGfHE2kD0CeXiEsPpIZRXB40Y+VgIgJWxaYoaIX3JIniQpg63B9jLBvXRRYl+1i8xBtaKBb8otAmICBiIOHZ+7g6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=KCvIGR+6; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Hbw9zR0xEpNm9A0Pc6HSS0+c52olIIH10RNS2pDgzjs=;
	b=KCvIGR+6Fj9i8JqE2aOH3ZT7Ll4mDUiB1+4jFjDbno13RnDEFL0vddTBuxsYXAK8IqvPJfOC5
	eIDGY7bSeSCftA4ReTD2b3uoaCuk7lku20l2CYrd4VQn/ys574cTYHcBCtcueyQfs8WamJAE9sR
	iTfELMeilc1vFhS+AdFbEJk=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4dWJcT2PcBz1cyPb;
	Wed, 17 Dec 2025 11:07:05 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 55EFF1401E9;
	Wed, 17 Dec 2025 11:10:07 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 17 Dec 2025 11:10:07 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 17 Dec 2025 11:10:06 +0800
Subject: Re: [PATCH v2 1/3] mm: fixup pfnmap memory failure handling to use
 pgoff
To: <ankita@nvidia.com>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <vsethi@nvidia.com>,
	<jgg@nvidia.com>, <mochs@nvidia.com>, <jgg@ziepe.ca>,
	<skolothumtho@nvidia.com>, <alex@shazbot.org>, <akpm@linux-foundation.org>,
	<nao.horiguchi@gmail.com>
References: <20251213044708.3610-1-ankita@nvidia.com>
 <20251213044708.3610-2-ankita@nvidia.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <f871d90d-11e0-1719-c946-1c0bf341042a@huawei.com>
Date: Wed, 17 Dec 2025 11:10:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251213044708.3610-2-ankita@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq500010.china.huawei.com (7.202.194.235)

On 2025/12/13 12:47, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The memory failure handling implementation for the PFNMAP memory with no
> struct pages is faulty. The VA of the mapping is determined based on the
> the PFN. It should instead be based on the file mapping offset.
> 
> At the occurrence of poison, the memory_failure_pfn is triggered on the
> poisoned PFN. Introduce a callback function that allows mm to translate
> the PFN to the corresponding file page offset. The kernel module using
> the registration API must implement the callback function and provide the
> translation. The translated value is then used to determine the VA
> information and sending the SIGBUS to the usermode process mapped to
> the poisoned PFN.
> 
> The callback is also useful for the driver to be notified of the poisoned
> PFN, which may then track it.
> 
> Fixes: 2ec41967189c ("mm: handle poisoning of pfn without struct pages")
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>

Thanks for your patch.

> ---
>  include/linux/memory-failure.h |  2 ++
>  mm/memory-failure.c            | 29 ++++++++++++++++++-----------
>  2 files changed, 20 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/memory-failure.h b/include/linux/memory-failure.h
> index bc326503d2d2..7b5e11cf905f 100644
> --- a/include/linux/memory-failure.h
> +++ b/include/linux/memory-failure.h
> @@ -9,6 +9,8 @@ struct pfn_address_space;
>  struct pfn_address_space {
>  	struct interval_tree_node node;
>  	struct address_space *mapping;
> +	int (*pfn_to_vma_pgoff)(struct vm_area_struct *vma,
> +				unsigned long pfn, pgoff_t *pgoff);
>  };
>  
>  int register_pfn_address_space(struct pfn_address_space *pfn_space);
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index fbc5a01260c8..c80c2907da33 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2161,6 +2161,9 @@ int register_pfn_address_space(struct pfn_address_space *pfn_space)
>  {
>  	guard(mutex)(&pfn_space_lock);
>  
> +	if (!pfn_space->pfn_to_vma_pgoff)
> +		return -EINVAL;
> +
>  	if (interval_tree_iter_first(&pfn_space_itree,
>  				     pfn_space->node.start,
>  				     pfn_space->node.last))
> @@ -2183,10 +2186,10 @@ void unregister_pfn_address_space(struct pfn_address_space *pfn_space)
>  }
>  EXPORT_SYMBOL_GPL(unregister_pfn_address_space);
>  
> -static void add_to_kill_pfn(struct task_struct *tsk,
> -			    struct vm_area_struct *vma,
> -			    struct list_head *to_kill,
> -			    unsigned long pfn)
> +static void add_to_kill_pgoff(struct task_struct *tsk,
> +			      struct vm_area_struct *vma,
> +			      struct list_head *to_kill,
> +			      pgoff_t pgoff)
>  {
>  	struct to_kill *tk;
>  
> @@ -2197,12 +2200,12 @@ static void add_to_kill_pfn(struct task_struct *tsk,
>  	}
>  
>  	/* Check for pgoff not backed by struct page */
> -	tk->addr = vma_address(vma, pfn, 1);
> +	tk->addr = vma_address(vma, pgoff, 1);
>  	tk->size_shift = PAGE_SHIFT;
>  
>  	if (tk->addr == -EFAULT)
>  		pr_info("Unable to find address %lx in %s\n",
> -			pfn, tsk->comm);
> +			pgoff, tsk->comm);
>  
>  	get_task_struct(tsk);
>  	tk->tsk = tsk;
> @@ -2212,11 +2215,12 @@ static void add_to_kill_pfn(struct task_struct *tsk,
>  /*
>   * Collect processes when the error hit a PFN not backed by struct page.
>   */
> -static void collect_procs_pfn(struct address_space *mapping,
> +static void collect_procs_pfn(struct pfn_address_space *pfn_space,
>  			      unsigned long pfn, struct list_head *to_kill)
>  {
>  	struct vm_area_struct *vma;
>  	struct task_struct *tsk;
> +	struct address_space *mapping = pfn_space->mapping;
>  
>  	i_mmap_lock_read(mapping);
>  	rcu_read_lock();
> @@ -2226,9 +2230,12 @@ static void collect_procs_pfn(struct address_space *mapping,
>  		t = task_early_kill(tsk, true);
>  		if (!t)
>  			continue;
> -		vma_interval_tree_foreach(vma, &mapping->i_mmap, pfn, pfn) {
> -			if (vma->vm_mm == t->mm)
> -				add_to_kill_pfn(t, vma, to_kill, pfn);
> +		vma_interval_tree_foreach(vma, &mapping->i_mmap, 0, ULONG_MAX) {
> +			pgoff_t pgoff;

IIUC, all vma will be traversed to find the final pgoff. This might not be a good idea
because rcu lock is held and this traversal might take a really long time. Or am I miss
something?

Thanks.
.

