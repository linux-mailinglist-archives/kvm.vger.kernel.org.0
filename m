Return-Path: <kvm+bounces-24532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 749C2956DD6
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 16:51:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3F631C22DF8
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 14:51:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E308F1741FD;
	Mon, 19 Aug 2024 14:51:08 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33E6F1741C3;
	Mon, 19 Aug 2024 14:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724079068; cv=none; b=IZ7Wz/UttsF/y/gYngWlt7PZFxh9y2iREwESO27AqV2/DiUstOxmlNY518cIITW71yzyxxvnouQFq2vjCLG6cluwOfPjPQih7OBB2Kgfwypw+SV1aO4gnmImN+V+xOoHFf0SsOU//QB+IHbtD7+TQlp9DpOYkKVdupWn7HFxYdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724079068; c=relaxed/simple;
	bh=HFDtVUbqcgxGPIhTo0mOjNnRgr8Jm5CamJxnE7bYkbw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gQNRh3aQvyD4E8otls0iMXb+5LG4hHJyAOA3A8bIo4zhIuVhNZcIsMxjWCaXC7euvRpQ0bnzvimoLMoDeQlze8HF4p1CaFIW49S0xHUQx/BjWgtDUwzed+1jclmp1ZQqiOUoUx1s2TbD7Hqpj+HxaWgs7276mtEX4/M8JEzsTRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 96F2A339;
	Mon, 19 Aug 2024 07:51:30 -0700 (PDT)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 120E03F66E;
	Mon, 19 Aug 2024 07:51:01 -0700 (PDT)
Message-ID: <beff9162-e1ba-4f72-91ea-329eaed48dbc@arm.com>
Date: Mon, 19 Aug 2024 15:51:00 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 17/19] irqchip/gic-v3-its: Share ITS tables with a
 non-trusted hypervisor
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-18-steven.price@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240819131924.372366-18-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steven,

On 19/08/2024 14:19, Steven Price wrote:
> Within a realm guest the ITS is emulated by the host. This means the
> allocations must have been made available to the host by a call to
> set_memory_decrypted(). Introduce an allocation function which performs
> this extra call.
> 
> For the ITT use a custom genpool-based allocator that calls
> set_memory_decrypted() for each page allocated, but then suballocates
> the size needed for each ITT. Note that there is no mechanism
> implemented to return pages from the genpool, but it is unlikely the
> peak number of devices will so much larger than the normal level - so
> this isn't expected to be an issue.
> 

This may not be sufficient to make it future proof. We need to detect if
the GIC is private vs shared, before we make the allocation choice. 
Please see below :

> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Tested-by: Will Deacon <will@kernel.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v3:
>   * Use BIT() macro.
>   * Use a genpool based allocator in its_create_device() to avoid
>     allocating a full page.
>   * Fix subject to drop "realm" and use gic-v3-its.
>   * Add error handling to ITS alloc/free.
> Changes since v2:
>   * Drop 'shared' from the new its_xxx function names as they are used
>     for non-realm guests too.
>   * Don't handle the NUMA_NO_NODE case specially - alloc_pages_node()
>     should do the right thing.
>   * Drop a pointless (void *) cast.
> ---
>   drivers/irqchip/irq-gic-v3-its.c | 139 ++++++++++++++++++++++++++-----
>   1 file changed, 116 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 9b34596b3542..557214c774c3 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -12,12 +12,14 @@
>   #include <linux/crash_dump.h>
>   #include <linux/delay.h>
>   #include <linux/efi.h>
> +#include <linux/genalloc.h>
>   #include <linux/interrupt.h>
>   #include <linux/iommu.h>
>   #include <linux/iopoll.h>
>   #include <linux/irqdomain.h>
>   #include <linux/list.h>
>   #include <linux/log2.h>
> +#include <linux/mem_encrypt.h>
>   #include <linux/memblock.h>
>   #include <linux/mm.h>
>   #include <linux/msi.h>
> @@ -27,6 +29,7 @@
>   #include <linux/of_pci.h>
>   #include <linux/of_platform.h>
>   #include <linux/percpu.h>
> +#include <linux/set_memory.h>
>   #include <linux/slab.h>
>   #include <linux/syscore_ops.h>
>   
> @@ -164,6 +167,7 @@ struct its_device {
>   	struct its_node		*its;
>   	struct event_lpi_map	event_map;
>   	void			*itt;
> +	u32			itt_sz;
>   	u32			nr_ites;
>   	u32			device_id;
>   	bool			shared;
> @@ -199,6 +203,81 @@ static DEFINE_IDA(its_vpeid_ida);
>   #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
>   #define gic_data_rdist_vlpi_base()	(gic_data_rdist_rd_base() + SZ_128K)
>   
> +static struct page *its_alloc_pages_node(int node, gfp_t gfp,
> +					 unsigned int order)
> +{
> +	struct page *page;
> +	int ret = 0;
> +
> +	page = alloc_pages_node(node, gfp, order);
> +
> +	if (!page)
> +		return NULL;
> +
> +	ret = set_memory_decrypted((unsigned long)page_address(page),
> +				   1 << order);
> +	if (WARN_ON(ret))
> +		return NULL;
> +
> +	return page;
> +}
> +
> +static struct page *its_alloc_pages(gfp_t gfp, unsigned int order)
> +{
> +	return its_alloc_pages_node(NUMA_NO_NODE, gfp, order);
> +}
> +
> +static void its_free_pages(void *addr, unsigned int order)
> +{
> +	if (WARN_ON(set_memory_encrypted((unsigned long)addr, 1 << order)))
> +		return;
> +	free_pages((unsigned long)addr, order);
> +}
> +
> +static struct gen_pool *itt_pool;
> +
> +static void *itt_alloc_pool(int node, int size)
> +{
> +	unsigned long addr;
> +	struct page *page;
> +
> +	if (size >= PAGE_SIZE) {
> +		page = its_alloc_pages_node(node,
> +					    GFP_KERNEL | __GFP_ZERO,
> +					    get_order(size));
> +
> +		return page_address(page);
> +	}
> +
> +	do {
> +		addr = gen_pool_alloc(itt_pool, size);
> +		if (addr)
> +			break;
> +
> +		page = its_alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 1);
> +		if (!page)
> +			break;
> +
> +		gen_pool_add(itt_pool, (unsigned long)page_address(page),
> +			     PAGE_SIZE, node);
> +	} while (!addr);
> +
> +	return (void *)addr;
> +}
> +
> +static void itt_free_pool(void *addr, int size)
> +{
> +	if (!addr)
> +		return;
> +
> +	if (size >= PAGE_SIZE) {
> +		its_free_pages(addr, get_order(size));
> +		return;
> +	}
> +
> +	gen_pool_free(itt_pool, (unsigned long)addr, size);
> +}
> +
>   /*
>    * Skip ITSs that have no vLPIs mapped, unless we're on GICv4.1, as we
>    * always have vSGIs mapped.
> @@ -2187,7 +2266,8 @@ static struct page *its_allocate_prop_table(gfp_t gfp_flags)
>   {
>   	struct page *prop_page;
>   
> -	prop_page = alloc_pages(gfp_flags, get_order(LPI_PROPBASE_SZ));
> +	prop_page = its_alloc_pages(gfp_flags,
> +				    get_order(LPI_PROPBASE_SZ));
>   	if (!prop_page)
>   		return NULL;
>   
> @@ -2198,8 +2278,8 @@ static struct page *its_allocate_prop_table(gfp_t gfp_flags)
>   
>   static void its_free_prop_table(struct page *prop_page)
>   {
> -	free_pages((unsigned long)page_address(prop_page),
> -		   get_order(LPI_PROPBASE_SZ));
> +	its_free_pages(page_address(prop_page),
> +		       get_order(LPI_PROPBASE_SZ));
>   }
>   
>   static bool gic_check_reserved_range(phys_addr_t addr, unsigned long size)
> @@ -2321,7 +2401,8 @@ static int its_setup_baser(struct its_node *its, struct its_baser *baser,
>   		order = get_order(GITS_BASER_PAGES_MAX * psz);
>   	}
>   
> -	page = alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO, order);
> +	page = its_alloc_pages_node(its->numa_node,
> +				    GFP_KERNEL | __GFP_ZERO, order);
>   	if (!page)
>   		return -ENOMEM;
>   
> @@ -2334,7 +2415,7 @@ static int its_setup_baser(struct its_node *its, struct its_baser *baser,
>   		/* 52bit PA is supported only when PageSize=64K */
>   		if (psz != SZ_64K) {
>   			pr_err("ITS: no 52bit PA support when psz=%d\n", psz);
> -			free_pages((unsigned long)base, order);
> +			its_free_pages(base, order);
>   			return -ENXIO;
>   		}
>   
> @@ -2390,7 +2471,7 @@ static int its_setup_baser(struct its_node *its, struct its_baser *baser,
>   		pr_err("ITS@%pa: %s doesn't stick: %llx %llx\n",
>   		       &its->phys_base, its_base_type_string[type],
>   		       val, tmp);
> -		free_pages((unsigned long)base, order);
> +		its_free_pages(base, order);
>   		return -ENXIO;
>   	}
>   
> @@ -2529,8 +2610,8 @@ static void its_free_tables(struct its_node *its)
>   
>   	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
>   		if (its->tables[i].base) {
> -			free_pages((unsigned long)its->tables[i].base,
> -				   its->tables[i].order);
> +			its_free_pages(its->tables[i].base,
> +				       its->tables[i].order);
>   			its->tables[i].base = NULL;
>   		}
>   	}
> @@ -2796,7 +2877,8 @@ static bool allocate_vpe_l2_table(int cpu, u32 id)
>   
>   	/* Allocate memory for 2nd level table */
>   	if (!table[idx]) {
> -		page = alloc_pages(GFP_KERNEL | __GFP_ZERO, get_order(psz));
> +		page = its_alloc_pages(GFP_KERNEL | __GFP_ZERO,
> +				       get_order(psz));
>   		if (!page)
>   			return false;
>   
> @@ -2915,7 +2997,8 @@ static int allocate_vpe_l1_table(void)
>   
>   	pr_debug("np = %d, npg = %lld, psz = %d, epp = %d, esz = %d\n",
>   		 np, npg, psz, epp, esz);
> -	page = alloc_pages(GFP_ATOMIC | __GFP_ZERO, get_order(np * PAGE_SIZE));
> +	page = its_alloc_pages(GFP_ATOMIC | __GFP_ZERO,
> +			       get_order(np * PAGE_SIZE));
>   	if (!page)
>   		return -ENOMEM;
>   
> @@ -2961,8 +3044,8 @@ static struct page *its_allocate_pending_table(gfp_t gfp_flags)
>   {
>   	struct page *pend_page;
>   
> -	pend_page = alloc_pages(gfp_flags | __GFP_ZERO,
> -				get_order(LPI_PENDBASE_SZ));
> +	pend_page = its_alloc_pages(gfp_flags | __GFP_ZERO,
> +				    get_order(LPI_PENDBASE_SZ));
>   	if (!pend_page)
>   		return NULL;
>   
> @@ -2974,7 +3057,7 @@ static struct page *its_allocate_pending_table(gfp_t gfp_flags)
>   
>   static void its_free_pending_table(struct page *pt)
>   {
> -	free_pages((unsigned long)page_address(pt), get_order(LPI_PENDBASE_SZ));
> +	its_free_pages(page_address(pt), get_order(LPI_PENDBASE_SZ));
>   }
>   
>   /*
> @@ -3309,8 +3392,9 @@ static bool its_alloc_table_entry(struct its_node *its,
>   
>   	/* Allocate memory for 2nd level table */
>   	if (!table[idx]) {
> -		page = alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO,
> -					get_order(baser->psz));
> +		page = its_alloc_pages_node(its->numa_node,
> +					    GFP_KERNEL | __GFP_ZERO,
> +					    get_order(baser->psz));
>   		if (!page)
>   			return false;
>   
> @@ -3405,7 +3489,6 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
>   	if (WARN_ON(!is_power_of_2(nvecs)))
>   		nvecs = roundup_pow_of_two(nvecs);
>   
> -	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
>   	/*
>   	 * Even if the device wants a single LPI, the ITT must be
>   	 * sized as a power of two (and you need at least one bit...).
> @@ -3413,7 +3496,11 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
>   	nr_ites = max(2, nvecs);
>   	sz = nr_ites * (FIELD_GET(GITS_TYPER_ITT_ENTRY_SIZE, its->typer) + 1);
>   	sz = max(sz, ITS_ITT_ALIGN) + ITS_ITT_ALIGN - 1;
> -	itt = kzalloc_node(sz, GFP_KERNEL, its->numa_node);
> +
> +	itt = itt_alloc_pool(its->numa_node, sz);
> +
> +	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
> +
>   	if (alloc_lpis) {
>   		lpi_map = its_lpi_alloc(nvecs, &lpi_base, &nr_lpis);
>   		if (lpi_map)
> @@ -3425,9 +3512,9 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
>   		lpi_base = 0;
>   	}
>   
> -	if (!dev || !itt ||  !col_map || (!lpi_map && alloc_lpis)) {
> +	if (!dev || !itt || !col_map || (!lpi_map && alloc_lpis)) {
>   		kfree(dev);
> -		kfree(itt);
> +		itt_free_pool(itt, sz);
>   		bitmap_free(lpi_map);
>   		kfree(col_map);
>   		return NULL;
> @@ -3437,6 +3524,7 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
>   
>   	dev->its = its;
>   	dev->itt = itt;
> +	dev->itt_sz = sz;
>   	dev->nr_ites = nr_ites;
>   	dev->event_map.lpi_map = lpi_map;
>   	dev->event_map.col_map = col_map;
> @@ -3464,7 +3552,7 @@ static void its_free_device(struct its_device *its_dev)
>   	list_del(&its_dev->entry);
>   	raw_spin_unlock_irqrestore(&its_dev->its->lock, flags);
>   	kfree(its_dev->event_map.col_map);
> -	kfree(its_dev->itt);
> +	itt_free_pool(its_dev->itt, its_dev->itt_sz);
>   	kfree(its_dev);
>   }
>   
> @@ -5112,8 +5200,9 @@ static int __init its_probe_one(struct its_node *its)
>   		}
>   	}
>   
> -	page = alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO,
> -				get_order(ITS_CMD_QUEUE_SZ));
> +	page = its_alloc_pages_node(its->numa_node,
> +				    GFP_KERNEL | __GFP_ZERO,
> +				    get_order(ITS_CMD_QUEUE_SZ));
>   	if (!page) {
>   		err = -ENOMEM;
>   		goto out_unmap_sgir;
> @@ -5177,7 +5266,7 @@ static int __init its_probe_one(struct its_node *its)
>   out_free_tables:
>   	its_free_tables(its);
>   out_free_cmd:
> -	free_pages((unsigned long)its->cmd_base, get_order(ITS_CMD_QUEUE_SZ));
> +	its_free_pages(its->cmd_base, get_order(ITS_CMD_QUEUE_SZ));
>   out_unmap_sgir:
>   	if (its->sgir_base)
>   		iounmap(its->sgir_base);
> @@ -5663,6 +5752,10 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
>   	bool has_v4_1 = false;
>   	int err;
>   
> +	itt_pool = gen_pool_create(get_order(ITS_ITT_ALIGN), -1);
> +	if (!itt_pool)
> +		return -ENOMEM;
> +
>   	gic_rdists = rdists;
>   
>   	lpi_prop_prio = irq_prio;


How about something like this folded into this patch ? Or if this patch 
goes in independently, we could carry the following as part of the CCA
series.

diff --git a/drivers/irqchip/irq-gic-v3-its.c 
b/drivers/irqchip/irq-gic-v3-its.c
index 6f4ddf7faed1..f1a779b52210 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -209,7 +209,7 @@ static struct page *its_alloc_pages_node(int node, 
gfp_t gfp,

  	page = alloc_pages_node(node, gfp, order);

-	if (page)
+	if (gic_rdists->is_shared && page)
  		set_memory_decrypted((unsigned long)page_address(page),
  				     BIT(order));
  	return page;
@@ -222,7 +222,8 @@ static struct page *its_alloc_pages(gfp_t gfp, 
unsigned int order)

  static void its_free_pages(void *addr, unsigned int order)
  {
-	set_memory_encrypted((unsigned long)addr, BIT(order));
+	if (gic_rdists->is_shared)
+		set_memory_encrypted((unsigned long)addr, BIT(order));
  	free_pages((unsigned long)addr, order);
  }

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 6fb276504bcc..48c6b2c8dd8c 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -2015,6 +2015,8 @@ static int __init gic_init_bases(phys_addr_t 
dist_phys_base,
  	typer = readl_relaxed(gic_data.dist_base + GICD_TYPER);
  	gic_data.rdists.gicd_typer = typer;

+	gic_data.rdists.is_shared = 
!arm64_is_iomem_private(gic_data.dist_phys_base,
+							    PAGE_SIZE);
  	gic_enable_quirks(readl_relaxed(gic_data.dist_base + GICD_IIDR),
  			  gic_quirks, &gic_data);

diff --git a/include/linux/irqchip/arm-gic-v3.h 
b/include/linux/irqchip/arm-gic-v3.h
index 728691365464..1edc33608d52 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -631,6 +631,7 @@ struct rdists {
  	bool			has_rvpeid;
  	bool			has_direct_lpi;
  	bool			has_vpend_valid_dirty;
+	bool			is_shared;
  };

  struct irq_domain;

