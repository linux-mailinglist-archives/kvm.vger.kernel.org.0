Return-Path: <kvm+bounces-64794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0033AC8C568
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 00:21:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DC1E24E1E22
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 23:21:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE9EA34029E;
	Wed, 26 Nov 2025 23:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wePGeV1N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BA034B18F
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 23:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764199091; cv=none; b=a6JdR7h7guub1NCOvMhTKfVT2auQ29/injXrOdJcIX309BWjJrB1e+ud3BxfQolHERbLJqWv72asEvdiIAMFsvy5oAKLxATTVzQO8yb+JSWx0L+/AwDC3idl99r8gLTHRCWIEq9YMu+XtBwwWilxdSSjvdqgdQTKnKro6QQDR+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764199091; c=relaxed/simple;
	bh=WpySdpWplIFkyFjdRPH8mjnIr8ZWwugcwAyYN9dmoGA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=csxugTNJf/qRYwjni36K6zKQIYkj2PVbIzn34fiaoNEHAojNjg9DrnxcqQ8pSbUwN926iyiURbl0Inwzbm9MN8aIU2Kk0cDkKG3Df2NYSRC5eODKliQbxtMwKCMse3+kvKrltAtqF2yfnXQAKN9fVdYV/xMXG0yQQrgHe6uAJfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wePGeV1N; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b952a966d7so364562b3a.3
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 15:18:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764199088; x=1764803888; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W+pnV+aPRrlLst9nvfnueF4Po9qU0QkYO4ZzZSMG/yA=;
        b=wePGeV1N2xD+JfemPLRC4NW0f3uLCt0Aqy/+wI3XffuXrbwplTY04zEdET/LSxWEBb
         W2N8G6JxjjrppO0zGXyyTDlDuS/j3HvWqpLMb4MPOY49nIzHEHLe/Epx1gak0bF2XwJ5
         6XuDpFHQQ41f891P8kfSwdjANGAwE5x48WGqdR/h8WhjOAIAtO3IxNP/fIIsvyqFMRDX
         RiRJkUNe0e0K6h/KUuEJLc2UxDPGNPk0b7OESwiRYbdSE0cC0Vd3hl38mqK+s40SwH1n
         mGi68gwFQO/YwN5v6I17uG2wm89rdnQFKyz4aqxvbBmmTV6n3AzrYZ+EWlYWLtQa5OIC
         soKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764199088; x=1764803888;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W+pnV+aPRrlLst9nvfnueF4Po9qU0QkYO4ZzZSMG/yA=;
        b=oLn0P2BKd7O2Qq5aWjRTHdNKzfDWFh4Zx++b1iDmi+cxs3mFo6S5+cW9N5ym3paLb0
         37/kaHeikw/XqFStnCdhkgFGTS7fyhE2wAniXoWHrJJaG1VbHYB2pq9HGIHR4NIZacbd
         w9gxLUHRbThP8ALeQRaOieRMvp0UCGy2+BiQQBUsB2zez34tK/RsKWYGmUQVOPA0g0jt
         wlQW/dJb6DSp+m8dMMVPnZjT+eqVaRh5P2WNJtBEU+9tMofsIve0CEjHqS991pNVKukj
         f+wX0QjyNqaDrrHHlsKL+RkN6HV/qMMUdY+xqriUaDkn6qwJmbUxyxSkbQV8UT253a32
         OpKQ==
X-Forwarded-Encrypted: i=1; AJvYcCW10CAH5uRZ+FFMuKGO3usV5mm4bihPBTO4NN8AjMwIa5vm4VmPrWuoVXyZ07UHHZ/c8Ys=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkzvRgDXy1bDQJDyKiGHREb2tNzWLD7bVZBSBuzk6EOtiPaYE4
	P0TPTkzDZf0EPernDHDUdXahTI9y/QegEI/puXxskhzQkO1t8nAO5xl/6Eu1MHO2q4TLIGYDKzY
	z7YNa5fD1qbv43Q==
X-Google-Smtp-Source: AGHT+IFuic0ctn0G24phSOJnRXkr3T8Tckl/kQVJBgvphMjPTbTwnjLR0jMKiGqJ+NLnuaO7uN+8Wbs7AMCmPA==
X-Received: from pfbfj11.prod.google.com ([2002:a05:6a00:3a0b:b0:7b0:e3d3:f03e])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2e82:b0:7aa:9723:3217 with SMTP id d2e1a72fcca58-7c58e40f6dcmr19685166b3a.25.1764199088215;
 Wed, 26 Nov 2025 15:18:08 -0800 (PST)
Date: Wed, 26 Nov 2025 23:17:32 +0000
In-Reply-To: <20251126231733.3302983-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251126231733.3302983-1-dmatlack@google.com>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
Message-ID: <20251126231733.3302983-18-dmatlack@google.com>
Subject: [PATCH v4 17/18] vfio: selftests: Eliminate INVALID_IOVA
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Alex Mastro <amastro@fb.com>, David Matlack <dmatlack@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Eliminate INVALID_IOVA as there are platforms where UINT64_MAX is a
valid iova.

Reviewed-by: Alex Mastro <amastro@fb.com>
Tested-by: Alex Mastro <amastro@fb.com>
Reviewed-by: Raghavendra Rao Ananta <rananta@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/vfio/lib/include/libvfio/iommu.h     |  3 +--
 .../vfio/lib/include/libvfio/vfio_pci_device.h     |  4 ++--
 tools/testing/selftests/vfio/lib/iommu.c           | 14 +++++++++-----
 .../testing/selftests/vfio/vfio_dma_mapping_test.c |  2 +-
 4 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h b/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
index e35f13ed3f3c..5c9b9dc6d993 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
@@ -8,7 +8,6 @@
 #include <libvfio/assert.h>
 
 typedef u64 iova_t;
-#define INVALID_IOVA UINT64_MAX
 
 struct iommu_mode {
 	const char *name;
@@ -57,7 +56,7 @@ static inline void iommu_unmap_all(struct iommu *iommu)
 	VFIO_ASSERT_EQ(__iommu_unmap_all(iommu, NULL), 0);
 }
 
-iova_t __iommu_hva2iova(struct iommu *iommu, void *vaddr);
+int __iommu_hva2iova(struct iommu *iommu, void *vaddr, iova_t *iova);
 iova_t iommu_hva2iova(struct iommu *iommu, void *vaddr);
 
 struct iommu_iova_range *iommu_iova_ranges(struct iommu *iommu, u32 *nranges);
diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
index 160e003131d6..2858885a89bb 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
@@ -103,9 +103,9 @@ static inline void vfio_pci_msix_disable(struct vfio_pci_device *device)
 	vfio_pci_irq_disable(device, VFIO_PCI_MSIX_IRQ_INDEX);
 }
 
-static inline iova_t __to_iova(struct vfio_pci_device *device, void *vaddr)
+static inline int __to_iova(struct vfio_pci_device *device, void *vaddr, iova_t *iova)
 {
-	return __iommu_hva2iova(device->iommu, vaddr);
+	return __iommu_hva2iova(device->iommu, vaddr, iova);
 }
 
 static inline iova_t to_iova(struct vfio_pci_device *device, void *vaddr)
diff --git a/tools/testing/selftests/vfio/lib/iommu.c b/tools/testing/selftests/vfio/lib/iommu.c
index 52f9cdf5f171..8079d43523f3 100644
--- a/tools/testing/selftests/vfio/lib/iommu.c
+++ b/tools/testing/selftests/vfio/lib/iommu.c
@@ -67,7 +67,7 @@ static const struct iommu_mode *lookup_iommu_mode(const char *iommu_mode)
 	VFIO_FAIL("Unrecognized IOMMU mode: %s\n", iommu_mode);
 }
 
-iova_t __iommu_hva2iova(struct iommu *iommu, void *vaddr)
+int __iommu_hva2iova(struct iommu *iommu, void *vaddr, iova_t *iova)
 {
 	struct dma_region *region;
 
@@ -78,18 +78,22 @@ iova_t __iommu_hva2iova(struct iommu *iommu, void *vaddr)
 		if (vaddr >= region->vaddr + region->size)
 			continue;
 
-		return region->iova + (vaddr - region->vaddr);
+		if (iova)
+			*iova = region->iova + (vaddr - region->vaddr);
+
+		return 0;
 	}
 
-	return INVALID_IOVA;
+	return -ENOENT;
 }
 
 iova_t iommu_hva2iova(struct iommu *iommu, void *vaddr)
 {
 	iova_t iova;
+	int ret;
 
-	iova = __iommu_hva2iova(iommu, vaddr);
-	VFIO_ASSERT_NE(iova, INVALID_IOVA, "%p is not mapped into IOMMU\n", vaddr);
+	ret = __iommu_hva2iova(iommu, vaddr, &iova);
+	VFIO_ASSERT_EQ(ret, 0, "%p is not mapped into the iommu\n", vaddr);
 
 	return iova;
 }
diff --git a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
index 213fcd8dcc79..5397822c3dd4 100644
--- a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
+++ b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
@@ -199,7 +199,7 @@ TEST_F(vfio_dma_mapping_test, dma_map_unmap)
 	ASSERT_EQ(rc, 0);
 	ASSERT_EQ(unmapped, region.size);
 	printf("Unmapped IOVA 0x%lx\n", region.iova);
-	ASSERT_EQ(INVALID_IOVA, __to_iova(self->device, region.vaddr));
+	ASSERT_NE(0, __to_iova(self->device, region.vaddr, NULL));
 	ASSERT_NE(0, iommu_mapping_get(device_bdf, region.iova, &mapping));
 
 	ASSERT_TRUE(!munmap(region.vaddr, size));
-- 
2.52.0.487.g5c8c507ade-goog


