Return-Path: <kvm+bounces-62943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 44B50C54294
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 20:35:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3DE754EF5D8
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 19:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E4D53559D1;
	Wed, 12 Nov 2025 19:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WQ6bABC/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA9335502E
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 19:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762975394; cv=none; b=QBk3D47qqyyF+KH2wty3wBBj+P8KBtLTbkTk3L/cGveBZ+/BzROje9A31FjAjqv9pb2zNXthD2/1Yq3scZrrmN5UE0Qav6i8ySu5V53HoIpbVWNqal9IWhqVviyd5ID8j4Sk4KcpjFAZWe4aBTXwiLZgsXSB8CTd542ZvADVATc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762975394; c=relaxed/simple;
	bh=rNjCVJoNwWvayt/bmiXSzISNxmpCcsT2tGf1NIUi/4Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KkvtJVHv+tQq2m2eqEY41vX3kFrbS05tGCiVyARpy4cWatWSU6fG4J53095brWZtfR52ulXmlgZAsAPVl0xpLwMbSM+3wZMLw52FrW3fFmxMtW1qTsUG5IDM4vkBvoqigJ+hesSjxRSQzo4RII1IpAjbxTYiijH7eDYTYkXyUAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WQ6bABC/; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b8a12f0cb4so461952b3a.3
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 11:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762975390; x=1763580190; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OKdUfWA8VBozuhxSSZUtzJUgC9/JHS2oDYkkS/YkkQc=;
        b=WQ6bABC/a1jngvzP34qzEOQVA/j3LFw5ynsoL1xdyUCTJDBhEpWpmvaUGZC27osVzN
         0zYAlUFSNMR5kzf5HxSjLQIjyvhIS7ssHcMf2iplmgnNWLpa2ZD6rOQ5bO7Tf9U0pVt5
         d0uK73TCjMTrl2jRiffK2WUG4TJntfNcC8kLL9PFPms9cNY/FQqai36ypfD2XL/WRGCa
         uEBkC/zCe4n2FUrQdMev69plSpBbdhpttJ/EwH771q+iM1nRoXwGryHYNZRjZDMOk71i
         mULb5rxiSPV9HqYIf/Q56pWWvpjbvKPOGj7FWQbQwZCrfelkeIAVdPK4JMqDEEC06VfH
         Az6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762975390; x=1763580190;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OKdUfWA8VBozuhxSSZUtzJUgC9/JHS2oDYkkS/YkkQc=;
        b=omOE3d8KnGqJ/FGsdIKVEC8c1sL1cydYO/1PnCZhNTyN7Dqe93asgJhqrR57eUR09/
         knFmByCHpFkDAtX/1uwCDDplJ2gL59mAocjZgQABm4q62ynARn9bHwGKwzP1NnTDIUXf
         7Q3RDrrmGmjAO2LRVuDoipJbWWoi9tgUbFziYvabTUEL4yw9UcnrRgJg1CwxdyMfjIH1
         kNfIEOHmDEmfysh/DqVj6PDXl+nwRut1mivy4bGakeCjciVk0w7lu8D9PGIY3OqLhHA9
         MhM0usEndjcFrb3V5kOY+Oyuz8hKzSElUIirvIR7z2/6nbbwMBhe+QQLrOeY8NufEIVw
         hOTA==
X-Forwarded-Encrypted: i=1; AJvYcCXpeX3rJ3P8lQjYmZkLkZ3KrS5P5PUnQmMlpd/Gy5xQEVpeB0KMIClFVezmXRcyGAdIcnQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCPP3QsqX9Ck5PpqXp2eWyuZLwLQJyBf68SPNLpkx+fAETzrtL
	ZITh/yVJ+Io02PFcNocB0ZMpGCvMqIK3Ha7WbpUws0QIzDkwRQssseHytNfHuwSjqXMfJX6hIil
	ZrCoSksENZ00new==
X-Google-Smtp-Source: AGHT+IFjHf53fSJAaoMvCAese1c2CReJLQvyP5+luooP4uX3A9bXodM94tdWMuD8m4gMAoe/7TUQGi6B8lf6sg==
X-Received: from pfwo11.prod.google.com ([2002:a05:6a00:1bcb:b0:7ae:55f2:2f4a])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3a20:b0:7ab:39a2:919b with SMTP id d2e1a72fcca58-7b7a48f5738mr4337298b3a.20.1762975390455;
 Wed, 12 Nov 2025 11:23:10 -0800 (PST)
Date: Wed, 12 Nov 2025 19:22:31 +0000
In-Reply-To: <20251112192232.442761-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251112192232.442761-1-dmatlack@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251112192232.442761-18-dmatlack@google.com>
Subject: [PATCH v2 17/18] vfio: selftests: Eliminate INVALID_IOVA
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alex Mastro <amastro@fb.com>, Alex Williamson <alex@shazbot.org>, 
	David Matlack <dmatlack@google.com>, Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Raghavendra Rao Ananta <rananta@google.com>, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Eliminate INVALID_IOVA as there are platforms where UINT64_MAX is a
valid iova.

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
2.52.0.rc1.455.g30608eb744-goog


