Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB10F13A2C
	for <lists+kvm@lfdr.de>; Sat,  4 May 2019 15:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbfEDNYs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 May 2019 09:24:48 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42591 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727501AbfEDNYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 May 2019 09:24:47 -0400
Received: by mail-ed1-f66.google.com with SMTP id l25so9448086eda.9
        for <kvm@vger.kernel.org>; Sat, 04 May 2019 06:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=onNfgkl3HLZ7eycGCCfeFstZLeTde1QHh6bTx3kxqqs=;
        b=YjHmuOmezYAESZFVKCHvm8U6ND6ku4q8GSZTjbK8tKvF8Zm6MT+eHIiyBHhoa7MJ3Y
         j3uEKUkYZDr6CKmqr8bc8WAtdAUNJQQbhNEc4HLNf5qcjPVW6X2qu6GKwrNASq4VEpP+
         y4YWVAxsXJjQlpn0QsY61BRjVO4byfkA1d3iPZDiErUkpIAfC5hkG7mNG0kbj4N8U2rS
         5New2YfCUrnoXn9NGnyULrOsdUTnPikiVxwcirnTV1N+X/agofGfs87Jh4RNA3yELJiZ
         /F4qnbku9XQcMxr802UaHttXrTSATNwXYfRMofex2svF+q5Zp8u3dqmOQQfN34BkR/yt
         e6og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=onNfgkl3HLZ7eycGCCfeFstZLeTde1QHh6bTx3kxqqs=;
        b=XzYht1GzXnQr0GqR5BYLzAo7/gOT3C7ArNC++D5ehyi3ZZmaveITD9Niswmgbdq/S5
         QoVC8APqd1jXPWxahc7vbOC3+PDJB28H1Q63zOSGeMuKm80NIsvVWq78DksV2ugQKyzG
         xLLCEUKsgK99m3CLud9u9qxrgY9qlOY6TJFQh0MVWmnQtsdRHyOgNfGnXR0q4JlS31/f
         F00pEE5lq24aunq5pkuQKMubrsyOKUZvMs0r9AZrsGWiNiHiT4CivqKOM+m4oXOcVWGa
         PlWnqzLVm0t9iRVZvWJtHDMcJ06JEafAYHeZTKvwd53OtxrMXQrVB5GDLBrScjpsZ78w
         T1yA==
X-Gm-Message-State: APjAAAVQT3Pk34OuACcsk6otgDFVsLZz6AkMyhLk2oEyzjHSWBUblVn5
        JfeGPMXnSW+oqKPQCzjdxUSxRw==
X-Google-Smtp-Source: APXvYqzuVVC+EiR84Wn9g4LrXjkl5RHEvJ/hbRQ+MHMfE9q3wKD4GJeREJyLtpI7kpDNNyL1d3Qn0w==
X-Received: by 2002:a50:a901:: with SMTP id l1mr14345036edc.237.1556976284585;
        Sat, 04 May 2019 06:24:44 -0700 (PDT)
Received: from localhost.localdomain ([79.97.203.116])
        by smtp.gmail.com with ESMTPSA id s53sm1391106edb.20.2019.05.04.06.24.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 06:24:44 -0700 (PDT)
From:   Tom Murphy <tmurphy@arista.com>
To:     iommu@lists.linux-foundation.org
Cc:     murphyt7@tcd.ie, Tom Murphy <tmurphy@arista.com>,
        Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will.deacon@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Andy Gross <andy.gross@linaro.org>,
        David Brown <david.brown@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org, kvm@vger.kernel.org
Subject: [RFC 6/7] iommu/vt-d: convert the intel iommu driver to the dma-iommu ops api
Date:   Sat,  4 May 2019 14:23:22 +0100
Message-Id: <20190504132327.27041-7-tmurphy@arista.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190504132327.27041-1-tmurphy@arista.com>
References: <20190504132327.27041-1-tmurphy@arista.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert the intel iommu driver to the dma-iommu api to allow us to
remove the iova handling code and the reserved region code

Signed-off-by: Tom Murphy <tmurphy@arista.com>
---
 drivers/iommu/Kconfig       |   1 +
 drivers/iommu/intel-iommu.c | 405 ++----------------------------------
 include/linux/intel-iommu.h |   1 -
 3 files changed, 20 insertions(+), 387 deletions(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 6f07f3b21816..dfed97f55b6e 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -180,6 +180,7 @@ config INTEL_IOMMU
 	select IOMMU_IOVA
 	select NEED_DMA_MAP_STATE
 	select DMAR_TABLE
+	select IOMMU_DMA
 	help
 	  DMA remapping (DMAR) devices support enables independent address
 	  translations for Direct Memory Access (DMA) from devices.
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 87622a28b854..980fc4816d72 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -39,6 +39,7 @@
 #include <linux/io.h>
 #include <linux/iova.h>
 #include <linux/iommu.h>
+#include <linux/dma-iommu.h>
 #include <linux/intel-iommu.h>
 #include <linux/syscore_ops.h>
 #include <linux/tboot.h>
@@ -1180,13 +1181,6 @@ static void dma_free_pagelist(struct page *freelist)
 	}
 }
 
-static void iova_entry_free(unsigned long data)
-{
-	struct page *freelist = (struct page *)data;
-
-	dma_free_pagelist(freelist);
-}
-
 /* iommu handling */
 static int iommu_alloc_root_entry(struct intel_iommu *iommu)
 {
@@ -1530,16 +1524,14 @@ static inline void __mapping_notify_one(struct intel_iommu *iommu,
 		iommu_flush_write_buffer(iommu);
 }
 
-static void iommu_flush_iova(struct iova_domain *iovad)
+static void iommu_flush_iova(struct iommu_domain *domain)
 {
-	struct dmar_domain *domain;
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 	int idx;
 
-	domain = container_of(iovad, struct dmar_domain, iovad);
-
-	for_each_domain_iommu(idx, domain) {
+	for_each_domain_iommu(idx, dmar_domain) {
 		struct intel_iommu *iommu = g_iommus[idx];
-		u16 did = domain->iommu_did[iommu->seq_id];
+		u16 did = dmar_domain->iommu_did[iommu->seq_id];
 
 		iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
 
@@ -1804,48 +1796,6 @@ static int domain_detach_iommu(struct dmar_domain *domain,
 	return count;
 }
 
-static struct iova_domain reserved_iova_list;
-static struct lock_class_key reserved_rbtree_key;
-
-static int dmar_init_reserved_ranges(void)
-{
-	struct pci_dev *pdev = NULL;
-	struct iova *iova;
-	int i;
-
-	init_iova_domain(&reserved_iova_list, VTD_PAGE_SIZE, IOVA_START_PFN);
-
-	lockdep_set_class(&reserved_iova_list.iova_rbtree_lock,
-		&reserved_rbtree_key);
-
-	/* IOAPIC ranges shouldn't be accessed by DMA */
-	iova = reserve_iova(&reserved_iova_list, IOVA_PFN(IOAPIC_RANGE_START),
-		IOVA_PFN(IOAPIC_RANGE_END));
-	if (!iova) {
-		pr_err("Reserve IOAPIC range failed\n");
-		return -ENODEV;
-	}
-
-	/* Reserve all PCI MMIO to avoid peer-to-peer access */
-	for_each_pci_dev(pdev) {
-		struct resource *r;
-
-		for (i = 0; i < PCI_NUM_RESOURCES; i++) {
-			r = &pdev->resource[i];
-			if (!r->flags || !(r->flags & IORESOURCE_MEM))
-				continue;
-			iova = reserve_iova(&reserved_iova_list,
-					    IOVA_PFN(r->start),
-					    IOVA_PFN(r->end));
-			if (!iova) {
-				pci_err(pdev, "Reserve iova for %pR failed\n", r);
-				return -ENODEV;
-			}
-		}
-	}
-	return 0;
-}
-
 static inline int guestwidth_to_adjustwidth(int gaw)
 {
 	int agaw;
@@ -1871,7 +1821,7 @@ static void domain_exit(struct dmar_domain *domain)
 
 	/* destroy iovas */
 	if (domain->domain.type == IOMMU_DOMAIN_DMA)
-		put_iova_domain(&domain->iovad);
+		iommu_put_dma_cookie(&domain->domain);
 
 	freelist = domain_unmap(domain, 0, DOMAIN_MAX_PFN(domain->gaw), NULL);
 
@@ -3213,296 +3163,6 @@ static int __init init_dmars(void)
 	return ret;
 }
 
-/* This takes a number of _MM_ pages, not VTD pages */
-static unsigned long intel_alloc_iova(struct device *dev,
-				     struct dmar_domain *domain,
-				     unsigned long nrpages, uint64_t dma_mask)
-{
-	unsigned long iova_pfn;
-
-	/* Restrict dma_mask to the width that the iommu can handle */
-	dma_mask = min_t(uint64_t, DOMAIN_MAX_ADDR(domain->gaw), dma_mask);
-	/* Ensure we reserve the whole size-aligned region */
-	nrpages = __roundup_pow_of_two(nrpages);
-
-	if (!dmar_forcedac && dma_mask > DMA_BIT_MASK(32)) {
-		/*
-		 * First try to allocate an io virtual address in
-		 * DMA_BIT_MASK(32) and if that fails then try allocating
-		 * from higher range
-		 */
-		iova_pfn = alloc_iova_fast(&domain->iovad, nrpages,
-					   IOVA_PFN(DMA_BIT_MASK(32)), false);
-		if (iova_pfn)
-			return iova_pfn;
-	}
-	iova_pfn = alloc_iova_fast(&domain->iovad, nrpages,
-				   IOVA_PFN(dma_mask), true);
-	if (unlikely(!iova_pfn)) {
-		dev_err(dev, "Allocating %ld-page iova failed", nrpages);
-		return 0;
-	}
-
-	return iova_pfn;
-}
-
-static dma_addr_t __intel_map_single(struct device *dev, phys_addr_t paddr,
-				     size_t size, int dir, u64 dma_mask)
-{
-	struct dmar_domain *domain;
-	phys_addr_t start_paddr;
-	unsigned long iova_pfn;
-	int prot = 0;
-	int ret;
-	struct intel_iommu *iommu;
-	unsigned long paddr_pfn = paddr >> PAGE_SHIFT;
-
-	BUG_ON(dir == DMA_NONE);
-
-	domain = find_domain(dev);
-	if (!domain)
-		return DMA_MAPPING_ERROR;
-
-	iommu = domain_get_iommu(domain);
-	size = aligned_nrpages(paddr, size);
-
-	iova_pfn = intel_alloc_iova(dev, domain, dma_to_mm_pfn(size), dma_mask);
-	if (!iova_pfn)
-		goto error;
-
-	/*
-	 * Check if DMAR supports zero-length reads on write only
-	 * mappings..
-	 */
-	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL || \
-			!cap_zlr(iommu->cap))
-		prot |= DMA_PTE_READ;
-	if (dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL)
-		prot |= DMA_PTE_WRITE;
-	/*
-	 * paddr - (paddr + size) might be partial page, we should map the whole
-	 * page.  Note: if two part of one page are separately mapped, we
-	 * might have two guest_addr mapping to the same host paddr, but this
-	 * is not a big problem
-	 */
-	ret = domain_pfn_mapping(domain, mm_to_dma_pfn(iova_pfn),
-				 mm_to_dma_pfn(paddr_pfn), size, prot);
-	if (ret)
-		goto error;
-
-	start_paddr = (phys_addr_t)iova_pfn << PAGE_SHIFT;
-	start_paddr += paddr & ~PAGE_MASK;
-	return start_paddr;
-
-error:
-	if (iova_pfn)
-		free_iova_fast(&domain->iovad, iova_pfn, dma_to_mm_pfn(size));
-	dev_err(dev, "Device request: %zx@%llx dir %d --- failed\n",
-		size, (unsigned long long)paddr, dir);
-	return DMA_MAPPING_ERROR;
-}
-
-static dma_addr_t intel_map_page(struct device *dev, struct page *page,
-				 unsigned long offset, size_t size,
-				 enum dma_data_direction dir,
-				 unsigned long attrs)
-{
-	return __intel_map_single(dev, page_to_phys(page) + offset, size,
-				  dir, *dev->dma_mask);
-}
-
-static dma_addr_t intel_map_resource(struct device *dev, phys_addr_t phys_addr,
-				     size_t size, enum dma_data_direction dir,
-				     unsigned long attrs)
-{
-	return __intel_map_single(dev, phys_addr, size, dir, *dev->dma_mask);
-}
-
-static void intel_unmap(struct device *dev, dma_addr_t dev_addr, size_t size)
-{
-	struct dmar_domain *domain;
-	unsigned long start_pfn, last_pfn;
-	unsigned long nrpages;
-	unsigned long iova_pfn;
-	struct intel_iommu *iommu;
-	struct page *freelist;
-
-	domain = find_domain(dev);
-	BUG_ON(!domain);
-
-	iommu = domain_get_iommu(domain);
-
-	iova_pfn = IOVA_PFN(dev_addr);
-
-	nrpages = aligned_nrpages(dev_addr, size);
-	start_pfn = mm_to_dma_pfn(iova_pfn);
-	last_pfn = start_pfn + nrpages - 1;
-
-	dev_dbg(dev, "Device unmapping: pfn %lx-%lx\n", start_pfn, last_pfn);
-
-	freelist = domain_unmap(domain, start_pfn, last_pfn, NULL);
-
-	if (intel_iommu_strict) {
-		iommu_flush_iotlb_psi(iommu, domain, start_pfn,
-				      nrpages, !freelist, 0);
-		/* free iova */
-		free_iova_fast(&domain->iovad, iova_pfn, dma_to_mm_pfn(nrpages));
-		dma_free_pagelist(freelist);
-	} else {
-		queue_iova(&domain->iovad, iova_pfn, nrpages,
-			   (unsigned long)freelist);
-		/*
-		 * queue up the release of the unmap to save the 1/6th of the
-		 * cpu used up by the iotlb flush operation...
-		 */
-	}
-}
-
-static void intel_unmap_page(struct device *dev, dma_addr_t dev_addr,
-			     size_t size, enum dma_data_direction dir,
-			     unsigned long attrs)
-{
-	intel_unmap(dev, dev_addr, size);
-}
-
-static void *intel_alloc_coherent(struct device *dev, size_t size,
-				  dma_addr_t *dma_handle, gfp_t flags,
-				  unsigned long attrs)
-{
-	struct page *page = NULL;
-	int order;
-
-	size = PAGE_ALIGN(size);
-	order = get_order(size);
-
-	if (dev->coherent_dma_mask < dma_get_required_mask(dev)) {
-		if (dev->coherent_dma_mask < DMA_BIT_MASK(32))
-			flags |= GFP_DMA;
-		else
-			flags |= GFP_DMA32;
-	}
-
-	if (gfpflags_allow_blocking(flags)) {
-		unsigned int count = size >> PAGE_SHIFT;
-
-		page = dma_alloc_from_contiguous(dev, count, order,
-						 flags & __GFP_NOWARN);
-	}
-
-	if (!page)
-		page = alloc_pages(flags, order);
-	if (!page)
-		return NULL;
-	memset(page_address(page), 0, size);
-
-	*dma_handle = __intel_map_single(dev, page_to_phys(page), size,
-					 DMA_BIDIRECTIONAL,
-					 dev->coherent_dma_mask);
-	if (*dma_handle != DMA_MAPPING_ERROR)
-		return page_address(page);
-	if (!dma_release_from_contiguous(dev, page, size >> PAGE_SHIFT))
-		__free_pages(page, order);
-
-	return NULL;
-}
-
-static void intel_free_coherent(struct device *dev, size_t size, void *vaddr,
-				dma_addr_t dma_handle, unsigned long attrs)
-{
-	int order;
-	struct page *page = virt_to_page(vaddr);
-
-	size = PAGE_ALIGN(size);
-	order = get_order(size);
-
-	intel_unmap(dev, dma_handle, size);
-	if (!dma_release_from_contiguous(dev, page, size >> PAGE_SHIFT))
-		__free_pages(page, order);
-}
-
-static void intel_unmap_sg(struct device *dev, struct scatterlist *sglist,
-			   int nelems, enum dma_data_direction dir,
-			   unsigned long attrs)
-{
-	dma_addr_t startaddr = sg_dma_address(sglist) & PAGE_MASK;
-	unsigned long nrpages = 0;
-	struct scatterlist *sg;
-	int i;
-
-	for_each_sg(sglist, sg, nelems, i) {
-		nrpages += aligned_nrpages(sg_dma_address(sg), sg_dma_len(sg));
-	}
-
-	intel_unmap(dev, startaddr, nrpages << VTD_PAGE_SHIFT);
-}
-
-static int intel_map_sg(struct device *dev, struct scatterlist *sglist, int nelems,
-			enum dma_data_direction dir, unsigned long attrs)
-{
-	int i;
-	struct dmar_domain *domain;
-	size_t size = 0;
-	int prot = 0;
-	unsigned long iova_pfn;
-	int ret;
-	struct scatterlist *sg;
-	unsigned long start_vpfn;
-	struct intel_iommu *iommu;
-
-	BUG_ON(dir == DMA_NONE);
-
-	domain = find_domain(dev);
-	if (!domain)
-		return 0;
-
-	iommu = domain_get_iommu(domain);
-
-	for_each_sg(sglist, sg, nelems, i)
-		size += aligned_nrpages(sg->offset, sg->length);
-
-	iova_pfn = intel_alloc_iova(dev, domain, dma_to_mm_pfn(size),
-				*dev->dma_mask);
-	if (!iova_pfn) {
-		sglist->dma_length = 0;
-		return 0;
-	}
-
-	/*
-	 * Check if DMAR supports zero-length reads on write only
-	 * mappings..
-	 */
-	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL || \
-			!cap_zlr(iommu->cap))
-		prot |= DMA_PTE_READ;
-	if (dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL)
-		prot |= DMA_PTE_WRITE;
-
-	start_vpfn = mm_to_dma_pfn(iova_pfn);
-
-	ret = domain_sg_mapping(domain, start_vpfn, sglist, size, prot);
-	if (unlikely(ret)) {
-		dma_pte_free_pagetable(domain, start_vpfn,
-				       start_vpfn + size - 1,
-				       agaw_to_level(domain->agaw) + 1);
-		free_iova_fast(&domain->iovad, iova_pfn, dma_to_mm_pfn(size));
-		return 0;
-	}
-
-	return nelems;
-}
-
-static const struct dma_map_ops intel_dma_ops = {
-	.alloc = intel_alloc_coherent,
-	.free = intel_free_coherent,
-	.map_sg = intel_map_sg,
-	.unmap_sg = intel_unmap_sg,
-	.map_page = intel_map_page,
-	.unmap_page = intel_unmap_page,
-	.map_resource = intel_map_resource,
-	.unmap_resource = intel_unmap_page,
-	.dma_supported = dma_direct_supported,
-};
-
 static inline int iommu_domain_cache_init(void)
 {
 	int ret = 0;
@@ -4229,7 +3889,7 @@ static void free_all_cpu_cached_iovas(unsigned int cpu)
 			if (!domain || domain->domain.type != IOMMU_DOMAIN_DMA)
 				continue;
 
-			free_cpu_cached_iovas(cpu, &domain->iovad);
+			iommu_dma_free_cpu_cached_iovas(cpu, &domain->domain);
 		}
 	}
 }
@@ -4440,12 +4100,6 @@ int __init intel_iommu_init(void)
 	if (list_empty(&dmar_atsr_units))
 		pr_info("No ATSR found\n");
 
-	if (dmar_init_reserved_ranges()) {
-		if (force_on)
-			panic("tboot: Failed to reserve iommu ranges\n");
-		goto out_free_reserved_range;
-	}
-
 	init_no_remapping_devices();
 
 	ret = init_dmars();
@@ -4453,7 +4107,7 @@ int __init intel_iommu_init(void)
 		if (force_on)
 			panic("tboot: Failed to initialize DMARs\n");
 		pr_err("Initialization failed\n");
-		goto out_free_reserved_range;
+		goto out_free_dmar;
 	}
 	up_write(&dmar_global_lock);
 
@@ -4492,8 +4146,6 @@ int __init intel_iommu_init(void)
 
 	return 0;
 
-out_free_reserved_range:
-	put_iova_domain(&reserved_iova_list);
 out_free_dmar:
 	intel_iommu_free_dmars();
 	up_write(&dmar_global_lock);
@@ -4587,18 +4239,6 @@ static int md_domain_init(struct dmar_domain *domain, int guest_width)
 	return 0;
 }
 
-static void intel_init_iova_domain(struct dmar_domain *dmar_domain)
-{
-	init_iova_domain(&dmar_domain->iovad, VTD_PAGE_SIZE, IOVA_START_PFN);
-	copy_reserved_iova(&reserved_iova_list, &dmar_domain->iovad);
-
-	if (init_iova_flush_queue(&dmar_domain->iovad, iommu_flush_iova,
-				iova_entry_free)) {
-		pr_warn("iova flush queue initialization failed\n");
-		intel_iommu_strict = 1;
-	}
-}
-
 static struct iommu_domain *intel_iommu_domain_alloc(unsigned type)
 {
 	struct dmar_domain *dmar_domain;
@@ -4620,8 +4260,9 @@ static struct iommu_domain *intel_iommu_domain_alloc(unsigned type)
 			return NULL;
 		}
 
-		if (type == IOMMU_DOMAIN_DMA)
-			intel_init_iova_domain(dmar_domain);
+		if (type == IOMMU_DOMAIN_DMA &&
+				iommu_get_dma_cookie(&dmar_domain->domain))
+			return NULL;
 
 		domain_update_iommu_cap(dmar_domain);
 		domain = &dmar_domain->domain;
@@ -4852,9 +4493,11 @@ static bool intel_iommu_capable(enum iommu_cap cap)
 
 static int intel_iommu_add_device(struct device *dev)
 {
+	struct dmar_domain *dmar_domain;
+	struct iommu_domain *domain;
 	struct intel_iommu *iommu;
 	struct iommu_group *group;
-	struct iommu_domain *domain;
+	dma_addr_t base;
 	u8 bus, devfn;
 
 	iommu = device_to_iommu(dev, &bus, &devfn);
@@ -4871,9 +4514,12 @@ static int intel_iommu_add_device(struct device *dev)
 	if (IS_ERR(group))
 		return PTR_ERR(group);
 
+	base = IOVA_START_PFN << VTD_PAGE_SHIFT;
 	domain = iommu_get_domain_for_dev(dev);
+	dmar_domain = to_dmar_domain(domain);
 	if (domain->type == IOMMU_DOMAIN_DMA)
-		dev->dma_ops = &intel_dma_ops;
+		iommu_setup_dma_ops(dev, base,
+				__DOMAIN_MAX_ADDR(dmar_domain->gaw) - base);
 
 	iommu_group_put(group);
 	return 0;
@@ -5002,19 +4648,6 @@ int intel_iommu_enable_pasid(struct intel_iommu *iommu, struct intel_svm_dev *sd
 	return ret;
 }
 
-static void intel_iommu_apply_resv_region(struct device *dev,
-					  struct iommu_domain *domain,
-					  struct iommu_resv_region *region)
-{
-	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
-	unsigned long start, end;
-
-	start = IOVA_PFN(region->start);
-	end   = IOVA_PFN(region->start + region->length - 1);
-
-	WARN_ON_ONCE(!reserve_iova(&dmar_domain->iovad, start, end));
-}
-
 struct intel_iommu *intel_svm_device_to_iommu(struct device *dev)
 {
 	struct intel_iommu *iommu;
@@ -5050,13 +4683,13 @@ const struct iommu_ops intel_iommu_ops = {
 	.detach_dev		= intel_iommu_detach_device,
 	.map			= intel_iommu_map,
 	.unmap			= intel_iommu_unmap,
+	.flush_iotlb_all	= iommu_flush_iova,
 	.flush_iotlb_range	= intel_iommu_flush_iotlb_range,
 	.iova_to_phys		= intel_iommu_iova_to_phys,
 	.add_device		= intel_iommu_add_device,
 	.remove_device		= intel_iommu_remove_device,
 	.get_resv_regions	= intel_iommu_get_resv_regions,
 	.put_resv_regions	= intel_iommu_put_resv_regions,
-	.apply_resv_region	= intel_iommu_apply_resv_region,
 	.device_group		= pci_device_group,
 	.def_domain_type	= intel_iommu_def_domain_type,
 	.is_attach_deferred	= intel_iommu_is_attach_deferred,
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index fa364de9db18..418073fe26d0 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -492,7 +492,6 @@ struct dmar_domain {
 
 	bool has_iotlb_device;
 	struct list_head devices;	/* all devices' list */
-	struct iova_domain iovad;	/* iova's that belong to this domain */
 
 	struct dma_pte	*pgd;		/* virtual address */
 	int		gaw;		/* max guest address width */
-- 
2.17.1

