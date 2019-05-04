Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2EE413A40
	for <lists+kvm@lfdr.de>; Sat,  4 May 2019 15:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbfEDNYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 May 2019 09:24:24 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35373 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727265AbfEDNYY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 May 2019 09:24:24 -0400
Received: by mail-ed1-f68.google.com with SMTP id p26so9469494edr.2
        for <kvm@vger.kernel.org>; Sat, 04 May 2019 06:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MGv2a159/utSNPRrKthALX+gwTy5XSWgBBtVZtxsUEs=;
        b=fUiRrk1KYySTZz5QtSC78v3sitRc/Xx4j8p1zc8HH22cDSu0OyFgp0BEaA6TRxJWhW
         laPz07843slSKo/TznYWA5pBlVNJtjZHd5nxJBKiX7BWyvNtTa7VfIKHzWAI1eVjjAfR
         ScqC8iqD5aTMb2F7mCM6HFA4NXzW3JgbKjHJ3g8bcxzTfQNYD0QrmLqD3AHKKWCFL3Iv
         iE2/oxpyYMuBQBZtoGE8WdvMrKEJFxZ7t20XF+UqQ5mRVoVcYUQ1pgw5IQEfRyrW3tlk
         snTxLt00MSL4L01LJEfrywVq2EoOGR9tWjliB0NjrCbZ1tczVjPxyyl6jZT9DVAeVYpv
         v79A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MGv2a159/utSNPRrKthALX+gwTy5XSWgBBtVZtxsUEs=;
        b=mx94EJUCtvxbuUNeFHNJw83QxBIwr9w7rCjMM6+/ipksqJlIFP5J8+HMVY5WMiGGAJ
         hkHIX0ZuZKPswhRA4BC37C1ZuTlmSFOiF7XW7UvYlkCigf3g9q1vGtpCVOsELX5hxzWp
         QANTalTpgrIsFGLrylco7dAmSNGxl7OrxVfa6qqmrPRbLjnhIusl3ylt9E90cxj+pBcy
         AJJcf1y/RZbcRrRww9RcWjcv4yJGcRZ1MdSBqgBAgFSbep8wziMR+LbN+wA4dYmrmdcm
         mJxlGrOO0kG6uHBedBZkt9jzOkL7AY14vxyJqcbiTN0lHPlVqXpeOAFIU6q9py5s46DD
         1lJg==
X-Gm-Message-State: APjAAAXeHxK5nD5fLM7Jv0pwbANFDqJtN2YO1ExTC+ejgyism/D6YsNf
        AG4gw07DCz/zz9XABinmcKwj4w==
X-Google-Smtp-Source: APXvYqywxlAbHXAeC69FkqfxEDfFcgcXMIm9JfImG/Xg1J0FSEmx+0RS7eL7cjdmPk25eN3Z2+sYWA==
X-Received: by 2002:a50:b4bb:: with SMTP id w56mr14985726edd.40.1556976261711;
        Sat, 04 May 2019 06:24:21 -0700 (PDT)
Received: from localhost.localdomain ([79.97.203.116])
        by smtp.gmail.com with ESMTPSA id s53sm1391106edb.20.2019.05.04.06.24.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 06:24:21 -0700 (PDT)
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
Subject: [RFC 1/7] iommu/vt-d: Set the dma_ops per device so we can remove the iommu_no_mapping code
Date:   Sat,  4 May 2019 14:23:17 +0100
Message-Id: <20190504132327.27041-2-tmurphy@arista.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190504132327.27041-1-tmurphy@arista.com>
References: <20190504132327.27041-1-tmurphy@arista.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set the dma_ops per device so we can remove the iommu_no_mapping code.

Signed-off-by: Tom Murphy <tmurphy@arista.com>
---
 drivers/iommu/intel-iommu.c | 85 +++----------------------------------
 1 file changed, 6 insertions(+), 79 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index eace915602f0..2db1dc47e7e4 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2622,17 +2622,6 @@ static int __init si_domain_init(int hw)
 	return 0;
 }
 
-static int identity_mapping(struct device *dev)
-{
-	struct device_domain_info *info;
-
-	info = dev->archdata.iommu;
-	if (info && info != DUMMY_DEVICE_DOMAIN_INFO)
-		return (info->domain == si_domain);
-
-	return 0;
-}
-
 static int domain_add_dev_info(struct dmar_domain *domain, struct device *dev)
 {
 	struct dmar_domain *ndomain;
@@ -3270,43 +3259,6 @@ static unsigned long intel_alloc_iova(struct device *dev,
 	return iova_pfn;
 }
 
-/* Check if the dev needs to go through non-identity map and unmap process.*/
-static int iommu_no_mapping(struct device *dev)
-{
-	int found;
-
-	if (iommu_dummy(dev))
-		return 1;
-
-	found = identity_mapping(dev);
-	if (found) {
-		/*
-		 * If the device's dma_mask is less than the system's memory
-		 * size then this is not a candidate for identity mapping.
-		 */
-		u64 dma_mask = *dev->dma_mask;
-
-		if (dev->coherent_dma_mask &&
-		    dev->coherent_dma_mask < dma_mask)
-			dma_mask = dev->coherent_dma_mask;
-
-		if (dma_mask < dma_get_required_mask(dev)) {
-			/*
-			 * 32 bit DMA is removed from si_domain and fall back
-			 * to non-identity mapping.
-			 */
-			dmar_remove_one_dev_info(dev);
-			dev_warn(dev, "32bit DMA uses non-identity mapping\n");
-
-			return 0;
-		}
-
-		return 1;
-	}
-
-	return 0;
-}
-
 static dma_addr_t __intel_map_single(struct device *dev, phys_addr_t paddr,
 				     size_t size, int dir, u64 dma_mask)
 {
@@ -3320,9 +3272,6 @@ static dma_addr_t __intel_map_single(struct device *dev, phys_addr_t paddr,
 
 	BUG_ON(dir == DMA_NONE);
 
-	if (iommu_no_mapping(dev))
-		return paddr;
-
 	domain = find_domain(dev);
 	if (!domain)
 		return DMA_MAPPING_ERROR;
@@ -3391,9 +3340,6 @@ static void intel_unmap(struct device *dev, dma_addr_t dev_addr, size_t size)
 	struct intel_iommu *iommu;
 	struct page *freelist;
 
-	if (iommu_no_mapping(dev))
-		return;
-
 	domain = find_domain(dev);
 	BUG_ON(!domain);
 
@@ -3442,9 +3388,7 @@ static void *intel_alloc_coherent(struct device *dev, size_t size,
 	size = PAGE_ALIGN(size);
 	order = get_order(size);
 
-	if (!iommu_no_mapping(dev))
-		flags &= ~(GFP_DMA | GFP_DMA32);
-	else if (dev->coherent_dma_mask < dma_get_required_mask(dev)) {
+	if (dev->coherent_dma_mask < dma_get_required_mask(dev)) {
 		if (dev->coherent_dma_mask < DMA_BIT_MASK(32))
 			flags |= GFP_DMA;
 		else
@@ -3456,11 +3400,6 @@ static void *intel_alloc_coherent(struct device *dev, size_t size,
 
 		page = dma_alloc_from_contiguous(dev, count, order,
 						 flags & __GFP_NOWARN);
-		if (page && iommu_no_mapping(dev) &&
-		    page_to_phys(page) + size > dev->coherent_dma_mask) {
-			dma_release_from_contiguous(dev, page, count);
-			page = NULL;
-		}
 	}
 
 	if (!page)
@@ -3510,20 +3449,6 @@ static void intel_unmap_sg(struct device *dev, struct scatterlist *sglist,
 	intel_unmap(dev, startaddr, nrpages << VTD_PAGE_SHIFT);
 }
 
-static int intel_nontranslate_map_sg(struct device *hddev,
-	struct scatterlist *sglist, int nelems, int dir)
-{
-	int i;
-	struct scatterlist *sg;
-
-	for_each_sg(sglist, sg, nelems, i) {
-		BUG_ON(!sg_page(sg));
-		sg->dma_address = sg_phys(sg);
-		sg->dma_length = sg->length;
-	}
-	return nelems;
-}
-
 static int intel_map_sg(struct device *dev, struct scatterlist *sglist, int nelems,
 			enum dma_data_direction dir, unsigned long attrs)
 {
@@ -3538,8 +3463,6 @@ static int intel_map_sg(struct device *dev, struct scatterlist *sglist, int nele
 	struct intel_iommu *iommu;
 
 	BUG_ON(dir == DMA_NONE);
-	if (iommu_no_mapping(dev))
-		return intel_nontranslate_map_sg(dev, sglist, nelems, dir);
 
 	domain = find_domain(dev);
 	if (!domain)
@@ -4570,7 +4493,6 @@ int __init intel_iommu_init(void)
 #if defined(CONFIG_X86) && defined(CONFIG_SWIOTLB)
 	swiotlb = 0;
 #endif
-	dma_ops = &intel_dma_ops;
 
 	init_iommu_pm_ops();
 
@@ -4949,6 +4871,7 @@ static int intel_iommu_add_device(struct device *dev)
 {
 	struct intel_iommu *iommu;
 	struct iommu_group *group;
+	struct iommu_domain *domain;
 	u8 bus, devfn;
 
 	iommu = device_to_iommu(dev, &bus, &devfn);
@@ -4965,6 +4888,10 @@ static int intel_iommu_add_device(struct device *dev)
 	if (IS_ERR(group))
 		return PTR_ERR(group);
 
+	domain = iommu_get_domain_for_dev(dev);
+	if (domain->type == IOMMU_DOMAIN_DMA)
+		dev->dma_ops = &intel_dma_ops;
+
 	iommu_group_put(group);
 	return 0;
 }
-- 
2.17.1

