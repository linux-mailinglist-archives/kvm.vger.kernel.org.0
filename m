Return-Path: <kvm+bounces-64211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26488C7B464
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:18:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79D423A70F1
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:15:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B5E534FF72;
	Fri, 21 Nov 2025 18:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f3DXwxhd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0426C355035
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763748900; cv=none; b=KnQgSXBqisWNdjuaBxfioQXvkcN2fOXJbCWxvELG9cCALTbhwqVcd/jmzCHkYzxgBqQ2c3+xIJXBTk7mutkxD1eoA7BFKLgSRM7UGFxbvEp56G7TL2D6A9EUNALj0WoKYg1nebot4EUnFJk9joGw2NddXnPXm3OFNgX8Kdtwmgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763748900; c=relaxed/simple;
	bh=5+r9tKht6ww+IqzhMEcI27XtdT+trwXLGUM2y9av5Y4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qat9w6jGIlyqbMSQSTMn24aSv1lyDV+9QjMUf97UShCWVtBWqoNAQJ0oDqOcb2+yhZsLBtRWgfL2091k4pbS5flK5XLUUZQjTKMRVjW+UmlYdSU6843ltT3Vok9WPMEZJRyOqLXH7O6PvmYRhkqMHrKhH6uWUffUi2q0p7GjaTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f3DXwxhd; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-340c261fb38so4277854a91.0
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763748894; x=1764353694; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IcgowuhKD7SZv+r4qHVnhttbmNLzYB67hIpXpmKWxiE=;
        b=f3DXwxhdJQx9hnQIu4jaQDu7vdSIiQxlJNHE77vORU2JFrwpguuexxgB2rMfFXo6sI
         Onmg9PUYZOxb96Y6I6gqWY8EJo906t3agQVqnTD4HKNZW+k1UddzgdtAaQvnPMQsphUA
         kmdRuFKSlNZuo15eqAm49TvGaxv83cHTzLCHqVscYUwfmwbxMzgJyv658LAiVC/MCGhT
         W+f88loqM+zWufhJApmaXf3KvQbtInnYal+uzeTyTfXtAlSbUY2GA7ETOTz1WVPMeRu/
         ASDZSymngCpvFz4A8wfMvx0vXodd2lUorpbKFeZzY86JgzqCqB70ZFotPb9cuwVz94CI
         eBtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763748894; x=1764353694;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IcgowuhKD7SZv+r4qHVnhttbmNLzYB67hIpXpmKWxiE=;
        b=rV00TXhGe5lAN8qw3udHCrD2FMXgPlrDOhLP9iURhU+bXK7eOixxiOVTzXKKf00n4U
         ayYT94hveNr5nBxc4LjrNuC/uj84SEby60h8XUV36Lu9d+aRF18aVJNkfD4kH4BzvyjE
         RAy1uPV7KF2OukbUwdMd4Fs3sEJv9aZPZIJ/z4jokB9ZC6WJOtgxnMIRk4a2PWpUlmWa
         eZckx3HduFuuXqprLGMFwE7Pj6lvN6b5ZfV4GXaTKSIzmba9JVt44E1BMF3OS7VFuc2L
         0UVJoi/4SQPx+5kQLwFeJPYLpPbVqCP8GdxDponE3JNvz7UnatZ/txzP7zmCK5a7ksjQ
         B0WQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1UoFTxHEMMocT8Y/7S1ni+Vdx9bEEtX42F2fk6UQZaH/BXbz2jK9eq9vn0MRYTqRw5IM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8S18VGcxyUepmu9rePptMSYFpdbDP7qjZwEuyVKQA9iQouJNr
	uYGLn3vWZgmwpQ9KCnNbXsNQUkwSukHdZ030DLW7IWQ6KoRaOmSN/0AY3JqjPf9x5BvjMQ0xedX
	XRQXw1Co85Nv49g==
X-Google-Smtp-Source: AGHT+IEZu3uRBpM789cZ5tqcDrIxej0byI6xLLeXvIL6Few5RFNFFv6w4Lq7+JNtnRLkvoly5g85/4CuFDVoRA==
X-Received: from pjbsk6.prod.google.com ([2002:a17:90b:2dc6:b0:341:7640:eb1e])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3c01:b0:340:cb39:74cd with SMTP id 98e67ed59e1d1-34733f589e8mr3391916a91.32.1763748894507;
 Fri, 21 Nov 2025 10:14:54 -0800 (PST)
Date: Fri, 21 Nov 2025 18:14:21 +0000
In-Reply-To: <20251121181429.1421717-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121181429.1421717-1-dmatlack@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121181429.1421717-11-dmatlack@google.com>
Subject: [PATCH v3 10/18] vfio: selftests: Rename struct vfio_dma_region to dma_region
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Alex Mastro <amastro@fb.com>, David Matlack <dmatlack@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Rename struct vfio_dma_region to dma_region. This is in preparation for
separating the VFIO PCI device library code from the IOMMU library code.
This name change also better reflects the fact that DMA mappings can be
managed by either VFIO or IOMMUFD. i.e. the "vfio_" prefix is
misleading.

Reviewed-by: Alex Mastro <amastro@fb.com>
Tested-by: Alex Mastro <amastro@fb.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/lib/include/vfio_util.h | 12 ++++++------
 tools/testing/selftests/vfio/lib/vfio_pci_device.c   | 12 ++++++------
 tools/testing/selftests/vfio/vfio_dma_mapping_test.c | 12 ++++++------
 tools/testing/selftests/vfio/vfio_pci_driver_test.c  |  6 +++---
 4 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools/testing/selftests/vfio/lib/include/vfio_util.h
index babbf90688e8..7784422116de 100644
--- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
+++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
@@ -80,7 +80,7 @@ typedef u64 iova_t;
 
 #define INVALID_IOVA UINT64_MAX
 
-struct vfio_dma_region {
+struct dma_region {
 	struct list_head link;
 	void *vaddr;
 	iova_t iova;
@@ -154,7 +154,7 @@ struct vfio_pci_driver {
 	bool memcpy_in_progress;
 
 	/* Region to be used by the driver (e.g. for in-memory descriptors) */
-	struct vfio_dma_region region;
+	struct dma_region region;
 
 	/* The maximum size that can be passed to memcpy_start(). */
 	u64 max_memcpy_size;
@@ -236,20 +236,20 @@ void iova_allocator_cleanup(struct iova_allocator *allocator);
 iova_t iova_allocator_alloc(struct iova_allocator *allocator, size_t size);
 
 int __vfio_pci_dma_map(struct vfio_pci_device *device,
-		       struct vfio_dma_region *region);
+		       struct dma_region *region);
 int __vfio_pci_dma_unmap(struct vfio_pci_device *device,
-			 struct vfio_dma_region *region,
+			 struct dma_region *region,
 			 u64 *unmapped);
 int __vfio_pci_dma_unmap_all(struct vfio_pci_device *device, u64 *unmapped);
 
 static inline void vfio_pci_dma_map(struct vfio_pci_device *device,
-				    struct vfio_dma_region *region)
+				    struct dma_region *region)
 {
 	VFIO_ASSERT_EQ(__vfio_pci_dma_map(device, region), 0);
 }
 
 static inline void vfio_pci_dma_unmap(struct vfio_pci_device *device,
-				      struct vfio_dma_region *region)
+				      struct dma_region *region)
 {
 	VFIO_ASSERT_EQ(__vfio_pci_dma_unmap(device, region, NULL), 0);
 }
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index f3aea724695d..877b145cef63 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -275,7 +275,7 @@ iova_t iova_allocator_alloc(struct iova_allocator *allocator, size_t size)
 
 iova_t __to_iova(struct vfio_pci_device *device, void *vaddr)
 {
-	struct vfio_dma_region *region;
+	struct dma_region *region;
 
 	list_for_each_entry(region, &device->iommu->dma_regions, link) {
 		if (vaddr < region->vaddr)
@@ -387,7 +387,7 @@ static void vfio_pci_irq_get(struct vfio_pci_device *device, u32 index,
 }
 
 static int vfio_iommu_dma_map(struct vfio_pci_device *device,
-			       struct vfio_dma_region *region)
+			       struct dma_region *region)
 {
 	struct vfio_iommu_type1_dma_map args = {
 		.argsz = sizeof(args),
@@ -404,7 +404,7 @@ static int vfio_iommu_dma_map(struct vfio_pci_device *device,
 }
 
 static int iommufd_dma_map(struct vfio_pci_device *device,
-			    struct vfio_dma_region *region)
+			    struct dma_region *region)
 {
 	struct iommu_ioas_map args = {
 		.size = sizeof(args),
@@ -424,7 +424,7 @@ static int iommufd_dma_map(struct vfio_pci_device *device,
 }
 
 int __vfio_pci_dma_map(struct vfio_pci_device *device,
-		      struct vfio_dma_region *region)
+		      struct dma_region *region)
 {
 	int ret;
 
@@ -480,7 +480,7 @@ static int iommufd_dma_unmap(int fd, u64 iova, u64 length, u32 ioas_id,
 }
 
 int __vfio_pci_dma_unmap(struct vfio_pci_device *device,
-			 struct vfio_dma_region *region, u64 *unmapped)
+			 struct dma_region *region, u64 *unmapped)
 {
 	int ret;
 
@@ -504,7 +504,7 @@ int __vfio_pci_dma_unmap(struct vfio_pci_device *device,
 int __vfio_pci_dma_unmap_all(struct vfio_pci_device *device, u64 *unmapped)
 {
 	int ret;
-	struct vfio_dma_region *curr, *next;
+	struct dma_region *curr, *next;
 
 	if (device->iommu->iommufd)
 		ret = iommufd_dma_unmap(device->iommu->iommufd, 0, UINT64_MAX,
diff --git a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
index 4727feb214c8..289af4665803 100644
--- a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
+++ b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
@@ -136,7 +136,7 @@ TEST_F(vfio_dma_mapping_test, dma_map_unmap)
 {
 	const u64 size = variant->size ?: getpagesize();
 	const int flags = variant->mmap_flags;
-	struct vfio_dma_region region;
+	struct dma_region region;
 	struct iommu_mapping mapping;
 	u64 mapping_size = size;
 	u64 unmapped;
@@ -208,7 +208,7 @@ TEST_F(vfio_dma_mapping_test, dma_map_unmap)
 FIXTURE(vfio_dma_map_limit_test) {
 	struct iommu *iommu;
 	struct vfio_pci_device *device;
-	struct vfio_dma_region region;
+	struct dma_region region;
 	size_t mmap_size;
 };
 
@@ -227,7 +227,7 @@ FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES();
 
 FIXTURE_SETUP(vfio_dma_map_limit_test)
 {
-	struct vfio_dma_region *region = &self->region;
+	struct dma_region *region = &self->region;
 	struct iommu_iova_range *ranges;
 	u64 region_size = getpagesize();
 	iova_t last_iova;
@@ -264,7 +264,7 @@ FIXTURE_TEARDOWN(vfio_dma_map_limit_test)
 
 TEST_F(vfio_dma_map_limit_test, unmap_range)
 {
-	struct vfio_dma_region *region = &self->region;
+	struct dma_region *region = &self->region;
 	u64 unmapped;
 	int rc;
 
@@ -278,7 +278,7 @@ TEST_F(vfio_dma_map_limit_test, unmap_range)
 
 TEST_F(vfio_dma_map_limit_test, unmap_all)
 {
-	struct vfio_dma_region *region = &self->region;
+	struct dma_region *region = &self->region;
 	u64 unmapped;
 	int rc;
 
@@ -292,7 +292,7 @@ TEST_F(vfio_dma_map_limit_test, unmap_all)
 
 TEST_F(vfio_dma_map_limit_test, overflow)
 {
-	struct vfio_dma_region *region = &self->region;
+	struct dma_region *region = &self->region;
 	int rc;
 
 	region->iova = ~(iova_t)0 & ~(region->size - 1);
diff --git a/tools/testing/selftests/vfio/vfio_pci_driver_test.c b/tools/testing/selftests/vfio/vfio_pci_driver_test.c
index b0c7d812de1f..057aa9bbe13e 100644
--- a/tools/testing/selftests/vfio/vfio_pci_driver_test.c
+++ b/tools/testing/selftests/vfio/vfio_pci_driver_test.c
@@ -20,7 +20,7 @@ static const char *device_bdf;
 
 static void region_setup(struct vfio_pci_device *device,
 			 struct iova_allocator *iova_allocator,
-			 struct vfio_dma_region *region, u64 size)
+			 struct dma_region *region, u64 size)
 {
 	const int flags = MAP_SHARED | MAP_ANONYMOUS;
 	const int prot = PROT_READ | PROT_WRITE;
@@ -37,7 +37,7 @@ static void region_setup(struct vfio_pci_device *device,
 }
 
 static void region_teardown(struct vfio_pci_device *device,
-			    struct vfio_dma_region *region)
+			    struct dma_region *region)
 {
 	vfio_pci_dma_unmap(device, region);
 	VFIO_ASSERT_EQ(munmap(region->vaddr, region->size), 0);
@@ -47,7 +47,7 @@ FIXTURE(vfio_pci_driver_test) {
 	struct iommu *iommu;
 	struct vfio_pci_device *device;
 	struct iova_allocator *iova_allocator;
-	struct vfio_dma_region memcpy_region;
+	struct dma_region memcpy_region;
 	void *vaddr;
 	int msi_fd;
 
-- 
2.52.0.rc2.455.g230fcf2819-goog


