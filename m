Return-Path: <kvm+bounces-59909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E369BD4D9D
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 18:14:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0AB942311D
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 15:39:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98954311951;
	Mon, 13 Oct 2025 15:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YttuaUVj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E8331159E;
	Mon, 13 Oct 2025 15:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369192; cv=none; b=ZCP0lftBp5+mT7TvlXeXXrAT33+hCJl40mTCKsmN9DFEEF8R2rzDKTMeGXftXo7czgm90du9WweoYChmdSdnoSrcrpg+Ke6kzUHbP1YyUxZ+oIAqnCy9y61ElALM9dmaVhstmr3v72OH7ss/bL+TlwFeNqM37wRc+1Tb0q3/VDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369192; c=relaxed/simple;
	bh=nDcAY6cfJF+Hz/RDzBDDYPPxaUyhkXABHvgRNxvqTpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuvX9XNaz8n1lGMEgUNqnEni76Wl8EBvnY1seapvqQBKjOguobszEXufaw02EmkayDPHBIPTNjVB6xNnaEdeLkDMNIO0ka/16PiTQlLmuK75SmxtXGDjvUVtOcDA2c/TU3WvO0w4gOqrNEUjHlquuJtlJxCDPFNfHl3hzcAz8qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YttuaUVj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844F5C4CEE7;
	Mon, 13 Oct 2025 15:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760369192;
	bh=nDcAY6cfJF+Hz/RDzBDDYPPxaUyhkXABHvgRNxvqTpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YttuaUVj+Kp9Af1Z/wOmzqR4x6u6MKQoxsIMYnkRbbYgEmRoCGzLAnLZ8udyX3+Nj
	 fbHvebL0J/revALUa7eNsii3rFnEF/H1FJS7IDEAjRJFFBCbS0Z7DiQ4HFwJx2pfiy
	 5kltRqFbwykOv4pNIESnT4GACAyFkqxIDZ1vnJcAFikQT0VKqYLp5lH/8XM3+J/T0j
	 I7LnUgPKS8O6T4tnF2v/I89rZGyKSv+sv44qeoxlig01HaC9vpwRzbr4NDAj0F0qH9
	 ske2ZxLB8xL/DHHOBUalLCImj/dreE+P0o8GWO2gOx47UIgYlr2eZnxqOn5kaoyjof
	 Vt4E9qGd5TdqQ==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v5 1/9] PCI/P2PDMA: Separate the mmap() support from the core logic
Date: Mon, 13 Oct 2025 18:26:03 +0300
Message-ID: <1044f7aa09836d63de964d4eb6e646b3071c1fdb.1760368250.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1760368250.git.leon@kernel.org>
References: <cover.1760368250.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Currently the P2PDMA code requires a pgmap and a struct page to
function. The was serving three important purposes:

 - DMA API compatibility, where scatterlist required a struct page as
   input

 - Life cycle management, the percpu_ref is used to prevent UAF during
   device hot unplug

 - A way to get the P2P provider data through the pci_p2pdma_pagemap

The DMA API now has a new flow, and has gained phys_addr_t support, so
it no longer needs struct pages to perform P2P mapping.

Lifecycle management can be delegated to the user, DMABUF for instance
has a suitable invalidation protocol that does not require struct page.

Finding the P2P provider data can also be managed by the caller
without need to look it up from the phys_addr.

Split the P2PDMA code into two layers. The optional upper layer,
effectively, provides a way to mmap() P2P memory into a VMA by
providing struct page, pgmap, a genalloc and sysfs.

The lower layer provides the actual P2P infrastructure and is wrapped
up in a new struct p2pdma_provider. Rework the mmap layer to use new
p2pdma_provider based APIs.

Drivers that do not want to put P2P memory into VMA's can allocate a
struct p2pdma_provider after probe() starts and free it before
remove() completes. When DMA mapping the driver must convey the struct
p2pdma_provider to the DMA mapping code along with a phys_addr of the
MMIO BAR slice to map. The driver must ensure that no DMA mapping
outlives the lifetime of the struct p2pdma_provider.

The intended target of this new API layer is DMABUF. There is usually
only a single p2pdma_provider for a DMABUF exporter. Most drivers can
establish the p2pdma_provider during probe, access the single instance
during DMABUF attach and use that to drive the DMA mapping.

DMABUF provides an invalidation mechanism that can guarantee all DMA
is halted and the DMA mappings are undone prior to destroying the
struct p2pdma_provider. This ensures there is no UAF through DMABUFs
that are lingering past driver removal.

The new p2pdma_provider layer cannot be used to create P2P memory that
can be mapped into VMA's, be used with pin_user_pages(), O_DIRECT, and
so on. These use cases must still use the mmap() layer. The
p2pdma_provider layer is principally for DMABUF-like use cases where
DMABUF natively manages the life cycle and access instead of
vmas/pin_user_pages()/struct page.

In addition, remove the bus_off field from pci_p2pdma_map_state since
it duplicates information already available in the pgmap structure.
The bus_offset is only used in one location (pci_p2pdma_bus_addr_map)
and is always identical to pgmap->bus_offset.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c       | 43 ++++++++++++++++++++------------------
 include/linux/pci-p2pdma.h | 19 ++++++++++++-----
 2 files changed, 37 insertions(+), 25 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 78e108e47254..59cd6fb40e83 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -28,9 +28,8 @@ struct pci_p2pdma {
 };
 
 struct pci_p2pdma_pagemap {
-	struct pci_dev *provider;
-	u64 bus_offset;
 	struct dev_pagemap pgmap;
+	struct p2pdma_provider mem;
 };
 
 static struct pci_p2pdma_pagemap *to_p2p_pgmap(struct dev_pagemap *pgmap)
@@ -204,8 +203,8 @@ static void p2pdma_page_free(struct page *page)
 {
 	struct pci_p2pdma_pagemap *pgmap = to_p2p_pgmap(page_pgmap(page));
 	/* safe to dereference while a reference is held to the percpu ref */
-	struct pci_p2pdma *p2pdma =
-		rcu_dereference_protected(pgmap->provider->p2pdma, 1);
+	struct pci_p2pdma *p2pdma = rcu_dereference_protected(
+		to_pci_dev(pgmap->mem.owner)->p2pdma, 1);
 	struct percpu_ref *ref;
 
 	gen_pool_free_owner(p2pdma->pool, (uintptr_t)page_to_virt(page),
@@ -270,14 +269,15 @@ static int pci_p2pdma_setup(struct pci_dev *pdev)
 
 static void pci_p2pdma_unmap_mappings(void *data)
 {
-	struct pci_dev *pdev = data;
+	struct pci_p2pdma_pagemap *p2p_pgmap = data;
 
 	/*
 	 * Removing the alloc attribute from sysfs will call
 	 * unmap_mapping_range() on the inode, teardown any existing userspace
 	 * mappings and prevent new ones from being created.
 	 */
-	sysfs_remove_file_from_group(&pdev->dev.kobj, &p2pmem_alloc_attr.attr,
+	sysfs_remove_file_from_group(&p2p_pgmap->mem.owner->kobj,
+				     &p2pmem_alloc_attr.attr,
 				     p2pmem_group.name);
 }
 
@@ -328,10 +328,9 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 	pgmap->nr_range = 1;
 	pgmap->type = MEMORY_DEVICE_PCI_P2PDMA;
 	pgmap->ops = &p2pdma_pgmap_ops;
-
-	p2p_pgmap->provider = pdev;
-	p2p_pgmap->bus_offset = pci_bus_address(pdev, bar) -
-		pci_resource_start(pdev, bar);
+	p2p_pgmap->mem.owner = &pdev->dev;
+	p2p_pgmap->mem.bus_offset =
+		pci_bus_address(pdev, bar) - pci_resource_start(pdev, bar);
 
 	addr = devm_memremap_pages(&pdev->dev, pgmap);
 	if (IS_ERR(addr)) {
@@ -340,7 +339,7 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 	}
 
 	error = devm_add_action_or_reset(&pdev->dev, pci_p2pdma_unmap_mappings,
-					 pdev);
+					 p2p_pgmap);
 	if (error)
 		goto pages_free;
 
@@ -972,16 +971,16 @@ void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
 }
 EXPORT_SYMBOL_GPL(pci_p2pmem_publish);
 
-static enum pci_p2pdma_map_type pci_p2pdma_map_type(struct dev_pagemap *pgmap,
-						    struct device *dev)
+static enum pci_p2pdma_map_type
+pci_p2pdma_map_type(struct p2pdma_provider *provider, struct device *dev)
 {
 	enum pci_p2pdma_map_type type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
-	struct pci_dev *provider = to_p2p_pgmap(pgmap)->provider;
+	struct pci_dev *pdev = to_pci_dev(provider->owner);
 	struct pci_dev *client;
 	struct pci_p2pdma *p2pdma;
 	int dist;
 
-	if (!provider->p2pdma)
+	if (!pdev->p2pdma)
 		return PCI_P2PDMA_MAP_NOT_SUPPORTED;
 
 	if (!dev_is_pci(dev))
@@ -990,7 +989,7 @@ static enum pci_p2pdma_map_type pci_p2pdma_map_type(struct dev_pagemap *pgmap,
 	client = to_pci_dev(dev);
 
 	rcu_read_lock();
-	p2pdma = rcu_dereference(provider->p2pdma);
+	p2pdma = rcu_dereference(pdev->p2pdma);
 
 	if (p2pdma)
 		type = xa_to_value(xa_load(&p2pdma->map_types,
@@ -998,7 +997,7 @@ static enum pci_p2pdma_map_type pci_p2pdma_map_type(struct dev_pagemap *pgmap,
 	rcu_read_unlock();
 
 	if (type == PCI_P2PDMA_MAP_UNKNOWN)
-		return calc_map_type_and_dist(provider, client, &dist, true);
+		return calc_map_type_and_dist(pdev, client, &dist, true);
 
 	return type;
 }
@@ -1006,9 +1005,13 @@ static enum pci_p2pdma_map_type pci_p2pdma_map_type(struct dev_pagemap *pgmap,
 void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
 		struct device *dev, struct page *page)
 {
-	state->pgmap = page_pgmap(page);
-	state->map = pci_p2pdma_map_type(state->pgmap, dev);
-	state->bus_off = to_p2p_pgmap(state->pgmap)->bus_offset;
+	struct pci_p2pdma_pagemap *p2p_pgmap = to_p2p_pgmap(page_pgmap(page));
+
+	if (state->mem == &p2p_pgmap->mem)
+		return;
+
+	state->mem = &p2p_pgmap->mem;
+	state->map = pci_p2pdma_map_type(&p2p_pgmap->mem, dev);
 }
 
 /**
diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
index 951f81a38f3a..1400f3ad4299 100644
--- a/include/linux/pci-p2pdma.h
+++ b/include/linux/pci-p2pdma.h
@@ -16,6 +16,16 @@
 struct block_device;
 struct scatterlist;
 
+/**
+ * struct p2pdma_provider
+ *
+ * A p2pdma provider is a range of MMIO address space available to the CPU.
+ */
+struct p2pdma_provider {
+	struct device *owner;
+	u64 bus_offset;
+};
+
 #ifdef CONFIG_PCI_P2PDMA
 int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 		u64 offset);
@@ -139,11 +149,11 @@ enum pci_p2pdma_map_type {
 };
 
 struct pci_p2pdma_map_state {
-	struct dev_pagemap *pgmap;
+	struct p2pdma_provider *mem;
 	enum pci_p2pdma_map_type map;
-	u64 bus_off;
 };
 
+
 /* helper for pci_p2pdma_state(), do not use directly */
 void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
 		struct device *dev, struct page *page);
@@ -162,8 +172,7 @@ pci_p2pdma_state(struct pci_p2pdma_map_state *state, struct device *dev,
 		struct page *page)
 {
 	if (IS_ENABLED(CONFIG_PCI_P2PDMA) && is_pci_p2pdma_page(page)) {
-		if (state->pgmap != page_pgmap(page))
-			__pci_p2pdma_update_state(state, dev, page);
+		__pci_p2pdma_update_state(state, dev, page);
 		return state->map;
 	}
 	return PCI_P2PDMA_MAP_NONE;
@@ -181,7 +190,7 @@ static inline dma_addr_t
 pci_p2pdma_bus_addr_map(struct pci_p2pdma_map_state *state, phys_addr_t paddr)
 {
 	WARN_ON_ONCE(state->map != PCI_P2PDMA_MAP_BUS_ADDR);
-	return paddr + state->bus_off;
+	return paddr + state->mem->bus_offset;
 }
 
 #endif /* _LINUX_PCI_P2P_H */
-- 
2.51.0


