Return-Path: <kvm+bounces-33138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 026839E569D
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 14:23:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B091C287D18
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 13:23:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A185421C18D;
	Thu,  5 Dec 2024 13:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RPr7ALUa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED4D218AD1;
	Thu,  5 Dec 2024 13:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733404903; cv=none; b=IZfPC9STdLAULVI3cdowqiSevN1uP+rs1l9IaBoKDiG/eX7z0IsbmZzc1fswjamMsxFFOT7Fhp7pksFKR6yodOu3vsT5mHPVEgzN5Xi7Cysn+YMgDLuwWiRifnyoX+OQydbYOAcvpeaTiqC+3d+uKwp6S0qFzxv6b4G6XxiSYTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733404903; c=relaxed/simple;
	bh=VDNJrNgrvXeiKwTQI653m0SaajGvRheByl4V4Wf2JY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2gFmdMfxfv8bUfVvrR70SoxgnshokUizI+8a7lPs4pAWi/MQe1V0qEEQXqvd94dv63Q43U062BfDyHWLQXlWCzzPewSxbYxLxudSzzambukoRPi4yg/kdQGSR9TFX1UEb3OOtFj94O5LaItThVgziaFBj5opK0sBpalV9hJfFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RPr7ALUa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF8DC4CEDD;
	Thu,  5 Dec 2024 13:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733404903;
	bh=VDNJrNgrvXeiKwTQI653m0SaajGvRheByl4V4Wf2JY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RPr7ALUaMhuypEqnOZAReGPsJO+L7CxPCXOtIRW390pP3BgIq43qVAlYTCBl50Tbq
	 AYLMWWZEi1Wf4ldGPrnc+Cn9gGcnH1q/N8n2YizrGGPvKhMmV8i7CB0YsnQu9W4RIy
	 r23PPnc9oFtb7FGHBWlz8+3XmxQDarPEGuOS3STWY2u7wIf69ZigOhPi96tgHvPxCC
	 YSqEJ9uf4DMnaj+VJaog96+zDb56sp50z1+PreCl7/Ifk5VyRiXRpQLJ+ASdXeTURE
	 GEXRyiz661D9BBLygBY64ddV7oTPuKAw293jbjhYaAPogLRmlENxCxlOzuck2YzWcG
	 pORaBiUE8Rx5Q==
From: Leon Romanovsky <leon@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v4 04/18] iommu: add kernel-doc for iommu_unmap and iommu_unmap_fast
Date: Thu,  5 Dec 2024 15:21:03 +0200
Message-ID: <da4827fda833e69dbe487ef404a9333c51d8ed2e.1733398913.git.leon@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1733398913.git.leon@kernel.org>
References: <cover.1733398913.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Add kernel-doc section for iommu_unmap and iommu_unmap_fast to document
existing limitation of underlying functions which can't split individual
ranges.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/iommu.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index ec75d14497bf..9eb7c7d7aa70 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2590,6 +2590,24 @@ size_t iommu_unmap(struct iommu_domain *domain,
 }
 EXPORT_SYMBOL_GPL(iommu_unmap);
 
+/**
+ * iommu_unmap_fast() - Remove mappings from a range of IOVA without IOTLB sync
+ * @domain: Domain to manipulate
+ * @iova: IO virtual address to start
+ * @size: Length of the range starting from @iova
+ * @iotlb_gather: range information for a pending IOTLB flush
+ *
+ * iommu_unmap_fast() will remove a translation created by iommu_map(). It cannot
+ * subdivide a mapping created by iommu_map(), so it should be called with IOVA
+ * ranges that match what was passed to iommu_map(). The range can aggregate
+ * contiguous iommu_map() calls so long as no individual range is split.
+ *
+ * Basicly iommu_unmap_fast() as the same as iommu_unmap() but for callers
+ * which manage IOTLB flush range externaly to perform batched sync.
+ *
+ * Returns: Number of bytes of IOVA unmapped. iova + res will be the point
+ * unmapping stopped.
+ */
 size_t iommu_unmap_fast(struct iommu_domain *domain,
 			unsigned long iova, size_t size,
 			struct iommu_iotlb_gather *iotlb_gather)
-- 
2.47.0


