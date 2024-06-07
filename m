Return-Path: <kvm+bounces-19075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16AED90097A
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 17:45:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E52B41C212D5
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 15:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E69F6199253;
	Fri,  7 Jun 2024 15:45:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE7E142069;
	Fri,  7 Jun 2024 15:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717775123; cv=none; b=BdNTgxPRCf2FWTIxGIy5VT5Z42DX2i2g2fwQeTAVenz3plz5R4R2JsnPSEe/sNInaL++qscjgyGNds364BF2kvAg/DfrLqeEOC6QF9JIdBaxDImjon1zAE3XbWwf6cCRqAQwBAngu2vookQ6XnaGMiw2+ujP2wAgrMZjXPb5Ud4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717775123; c=relaxed/simple;
	bh=SdgeWxAowhAFLP9MPioaHEfNQKZwAXqR0IToCOG0RTw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uTSz0EZPl7pzARSte9kNKjGJ0Eh39a7afoSZD1OHy6qZP9dEkO7x7n+rmi6YFkenKxeh+OIXMfe+2bzw/XALbw7ABj48UiAZxGOMPhXkFB2pJgFQRiSn9ozuRVfP86DLrGMWdqE9PmqNsYoe1lUqhiaMgCWqWq1AiMlrFFfw2KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6378715A1;
	Fri,  7 Jun 2024 08:45:44 -0700 (PDT)
Received: from [10.1.39.15] (e122027.cambridge.arm.com [10.1.39.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A83143F792;
	Fri,  7 Jun 2024 08:45:16 -0700 (PDT)
Message-ID: <0ea597d3-6520-4ab3-8050-d967c173bc23@arm.com>
Date: Fri, 7 Jun 2024 16:45:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/14] arm64: realm: Support nonsecure ITS emulation
 shared
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Will Deacon
 <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <20240605093006.145492-13-steven.price@arm.com>
 <86a5jzld9g.wl-maz@kernel.org> <4c363476-e5b5-42ff-9f30-a02a92b6751b@arm.com>
 <867cf2l6in.wl-maz@kernel.org> <ZmICEN8JvWM7M9Ch@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <ZmICEN8JvWM7M9Ch@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 06/06/2024 19:38, Catalin Marinas wrote:
> On Thu, Jun 06, 2024 at 11:17:36AM +0100, Marc Zyngier wrote:
>> On Wed, 05 Jun 2024 16:08:49 +0100,
>> Steven Price <steven.price@arm.com> wrote:
>>> 2. Use a special (global) memory allocator that does the
>>> set_memory_decrypted() dance on the pages that it allocates but allows
>>> packing the allocations. I'm not aware of an existing kernel API for
>>> this, so it's potentially quite a bit of code. The benefit is that it
>>> reduces memory consumption in a realm guest, although fragmentation
>>> still means we're likely to see a (small) growth.
>>>
>>> Any thoughts on what you think would be best?
>>
>> I would expect that something similar to kmem_cache could be of help,
>> only with the ability to deal with variable object sizes (in this
>> case: minimum of 256 bytes, in increments defined by the
>> implementation, and with a 256 byte alignment).
> 
> Hmm, that's doable but not that easy to make generic. We'd need a new
> class of kmalloc-* caches (e.g. kmalloc-decrypted-*) which use only
> decrypted pages together with a GFP_DECRYPTED flag or something to get
> the slab allocator to go for these pages and avoid merging with other
> caches. It would actually be the page allocator parsing this gfp flag,
> probably in post_alloc_hook() to set the page decrypted and re-encrypt
> it in free_pages_prepare(). A slight problem here is that free_pages()
> doesn't get the gfp flag, so we'd need to store some bit in the page
> flags. Maybe the flag is not that bad, do we have something like for
> page_to_phys() to give us the high IPA address for decrypted pages?
> 
> Similarly if we go for a kmem_cache (or a few for multiple sizes). One
> can specify a constructor which could set the memory decrypted but
> there's no destructor (and also the constructor is per object, not per
> page, so we'd need some refcounting).
> 
> Another approach contained within the driver is to use mempool_create()
> with our own _alloc_fn/_free_fn that sets the memory decrypted/encrypted
> accordingly, though sub-page allocations need additional tracking. Also
> that's fairly similar to kmem_cache, fixed size.
> 
> Yet another option would be to wire it somehow in the DMA API but the
> minimum allocation is already a page size, so we don't gain anything.
> 
> What gets somewhat closer to what we need is gen_pool. It can track
> different sizes, we just need to populate the chunks as needed. I don't
> think this would work as a generic allocator but may be good enough
> within the ITS code.
> 
> If there's a need for such generic allocations in other parts of the
> kernel, my preference would be something around kmalloc caches and a new
> GFP flag (first option; subject to the selling it to the mm folk). But
> that's more of a separate prototyping effort that may or may not
> succeed.
> 
> Anyway, we could do some hacking around gen_pool as a temporary solution
> (maybe as a set of patches on top of this series to be easier to revert)
> and start investigating a proper decrypted page allocator in parallel.
> We just need to find a victim that has the page allocator fresh in mind
> (Ryan or Alexandru ;)).

Thanks for the suggestions Catalin. I had a go at implementing something
with gen_pool - the below (very lightly tested) hack seems to work. This
is on top of the current series.

I *think* it should also be safe to drop the whole alignment part with
this custom allocator, which could actually save memory. But I haven't
quite got my head around that yet.

Steve

----8<-----
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index ca72f830f4cc..e78634d4d22c 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -12,6 +12,7 @@
 #include <linux/crash_dump.h>
 #include <linux/delay.h>
 #include <linux/efi.h>
+#include <linux/genalloc.h>
 #include <linux/interrupt.h>
 #include <linux/iommu.h>
 #include <linux/iopoll.h>
@@ -165,7 +166,7 @@ struct its_device {
 	struct its_node		*its;
 	struct event_lpi_map	event_map;
 	void			*itt;
-	u32			itt_order;
+	u32			itt_sz;
 	u32			nr_ites;
 	u32			device_id;
 	bool			shared;
@@ -225,6 +226,50 @@ static void its_free_pages(void *addr, unsigned int order)
 	free_pages((unsigned long)addr, order);
 }
 
+static struct gen_pool *itt_pool;
+
+static void *itt_alloc_pool(int node, int size)
+{
+	unsigned long addr;
+	struct page *page;
+
+	if (size >= PAGE_SIZE) {
+		page = its_alloc_pages_node(node,
+					    GFP_KERNEL | __GFP_ZERO,
+					    get_order(size));
+
+		return page_address(page);
+	}
+
+	do {
+		addr = gen_pool_alloc(itt_pool, size);
+		if (addr)
+			break;
+
+		page = its_alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 1);
+		if (!page)
+			break;
+
+		gen_pool_add(itt_pool, (unsigned long)page_address(page),
+			     PAGE_SIZE, node);
+	} while (!addr);
+
+	return (void*)addr;
+}
+
+static void itt_free_pool(void *addr, int size)
+{
+	if (!addr)
+		return;
+
+	if (size >= PAGE_SIZE) {
+		its_free_pages(addr, get_order(size));
+		return;
+	}
+
+	gen_pool_free(itt_pool, (unsigned long)addr, size);
+}
+
 /*
  * Skip ITSs that have no vLPIs mapped, unless we're on GICv4.1, as we
  * always have vSGIs mapped.
@@ -3450,9 +3495,7 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 	unsigned long *lpi_map = NULL;
 	unsigned long flags;
 	u16 *col_map = NULL;
-	struct page *page;
 	void *itt;
-	int itt_order;
 	int lpi_base;
 	int nr_lpis;
 	int nr_ites;
@@ -3471,13 +3514,8 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 	nr_ites = max(2, nvecs);
 	sz = nr_ites * (FIELD_GET(GITS_TYPER_ITT_ENTRY_SIZE, its->typer) + 1);
 	sz = max(sz, ITS_ITT_ALIGN) + ITS_ITT_ALIGN - 1;
-	itt_order = get_order(sz);
-	page = its_alloc_pages_node(its->numa_node,
-				    GFP_KERNEL | __GFP_ZERO,
-				    itt_order);
-	if (!page)
-		return NULL;
-	itt = page_address(page);
+
+	itt = itt_alloc_pool(its->numa_node, sz);
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 
@@ -3492,9 +3530,9 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 		lpi_base = 0;
 	}
 
-	if (!dev || !col_map || (!lpi_map && alloc_lpis)) {
+	if (!dev || !itt || !col_map || (!lpi_map && alloc_lpis)) {
 		kfree(dev);
-		its_free_pages(itt, itt_order);
+		itt_free_pool(itt, sz);
 		bitmap_free(lpi_map);
 		kfree(col_map);
 		return NULL;
@@ -3504,7 +3542,7 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 
 	dev->its = its;
 	dev->itt = itt;
-	dev->itt_order = itt_order;
+	dev->itt_sz = sz;
 	dev->nr_ites = nr_ites;
 	dev->event_map.lpi_map = lpi_map;
 	dev->event_map.col_map = col_map;
@@ -3532,7 +3570,7 @@ static void its_free_device(struct its_device *its_dev)
 	list_del(&its_dev->entry);
 	raw_spin_unlock_irqrestore(&its_dev->its->lock, flags);
 	kfree(its_dev->event_map.col_map);
-	its_free_pages(its_dev->itt, its_dev->itt_order);
+	itt_free_pool(its_dev->itt, its_dev->itt_sz);
 	kfree(its_dev);
 }
 
@@ -5722,6 +5760,10 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
 	bool has_v4_1 = false;
 	int err;
 
+	itt_pool = gen_pool_create(get_order(ITS_ITT_ALIGN), -1);
+	if (!itt_pool)
+		return -ENOMEM;
+
 	gic_rdists = rdists;
 
 	its_parent = parent_domain;


