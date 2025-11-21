Return-Path: <kvm+bounces-64206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 338ABC7B476
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:18:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C2E3B4EEEB2
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B1F23546E4;
	Fri, 21 Nov 2025 18:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ydEzlBtR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5285E350D60
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763748889; cv=none; b=GYxzr/gZmGzpWDehAFBKYSPo4dmUMsBPP+QtLKpN7nwuhEYDoynoO4nmNfjJj12i+9fxgZZ+NtH1B9Zwopuh61qjJP38iM2hNxC0qa8C9x+yAfdA5oNoWMYRHnWuiJcVEAh8DGfCNC8G6hQ7OjvL/SBa+Kuy/BizgNd9Z/4HgAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763748889; c=relaxed/simple;
	bh=JrMXo1bbH2zD+C9IAEk7RcmFaSXGprQ1nQVRbpRkObI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CiiBPeoEB+m/E/Akdo1/yV1ntmF98xuc+a9i/VgTwIf9fqqZl2IrpZRaa1/N8H8dBpfEAeKmngh80LyWGM9Dj7hAgTCefF+xqaBph1hvVvBDBz6RqcbAF1t+auPiilekxom32L8+sCxtfcrA7n3tXWXrW5KqXY180Hby3VTzKu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ydEzlBtR; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-295fbc7d4abso35409195ad.1
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:14:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763748886; x=1764353686; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=blhLd4rrTqtEcsOjOcmqpT/d1FX49t9c289UH0z+u3s=;
        b=ydEzlBtRIx9xXwM+fagmXbSHYDoWqGT9apATHqsuNxl5SDb74bucN3CAfsMh1SVgUf
         thI8qq9kS2iGAgcrFUGCDCdihXBAeboyJGavtcH3EaFNPVclFYIxWcTQfDJSZCHQ4TkB
         mgme/8vfLoktNWnuDMWh5tjxLAai2NVz+2pp7Itb2PY9TV6DIIMbl6qHysJZmRIyRnUT
         qXU2x5hjdCdl6RraHh6VC0lA8JO05ofKpaLKRcxFSRQZ7fmcqAMxUtIfa7fsM6D6vrjc
         kjmUi74Y3eaF2XzOKmifbZJphZUmTHyAYBYHCkSw7moqAt2zk/ZkzmyZ2myp/goRSCzf
         QnHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763748886; x=1764353686;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=blhLd4rrTqtEcsOjOcmqpT/d1FX49t9c289UH0z+u3s=;
        b=EXqmCCfMnmTIczGBdpFVDBJyZM/kLF8TJ4iONg7ZU6ShsRUD3s9SRH0xGiecKfPktp
         mS6o5eFV9PTAuURtN2VYK4WLeg4CENm6nHbGzlAzxb1IiDNi7mLer1fA3MZTnKo27LCd
         FMhk823ttUqB0eRwKHSwJIlE0Cbu1F9P0UpTdVzoNU5jzMtJz4S4cgm/XVVa+ai0JbD3
         JedFvKZxz9JBOHggt+ZPTPKfbJkSwsEAIo62f+t7ckMTWz0TlL0hrjmD3r6+jXFqrwz6
         ShyVHbL6DcKa1jMCpKbRmScSkBK1fc7nOFNWC9JLRXDDjxUB/9IfBZYFxGzBPGA834iD
         diog==
X-Forwarded-Encrypted: i=1; AJvYcCVqEmR2/fDe/0hR9dAVWBKa1J39oBSYRs9JYlVGetA7ClT6tnrKyJ9UPcmGnWXg854ttJ8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeWWV+Kn+7Ld7ivoZ9AF8ORevYu81nxpDhKbkOua64vGr/CDLL
	jnhsnI9rnbCexUiCUXAIkoHIbEkJwIr6BBLi2G8o9pN+Wd7MPhxto/eSO4YhidxQ2FA2rmqPxOp
	hM3jBUzMcleFjVg==
X-Google-Smtp-Source: AGHT+IFDh1Mq0Cq+V8AWErkW1uaQlm6+HEp9I9J8cTlqWejTFalLZIGvnegC1ArG8b6icswYkKT9fTxcj0NSWg==
X-Received: from plmk8.prod.google.com ([2002:a17:903:1808:b0:274:6ac2:5f9f])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f609:b0:274:5030:2906 with SMTP id d9443c01a7336-29b6bf60de3mr47982835ad.46.1763748886454;
 Fri, 21 Nov 2025 10:14:46 -0800 (PST)
Date: Fri, 21 Nov 2025 18:14:16 +0000
In-Reply-To: <20251121181429.1421717-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121181429.1421717-1-dmatlack@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121181429.1421717-6-dmatlack@google.com>
Subject: [PATCH v3 05/18] vfio: selftests: Introduce struct iommu
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Alex Mastro <amastro@fb.com>, David Matlack <dmatlack@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce struct iommu, which logically represents either a VFIO
container or an iommufd IOAS, depending on which IOMMU mode is used by
the test.

This will be used in a subsequent commit to allow devices to be added to
the same container/iommufd.

Reviewed-by: Alex Mastro <amastro@fb.com>
Tested-by: Alex Mastro <amastro@fb.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/vfio/lib/include/vfio_util.h    | 16 ++--
 .../selftests/vfio/lib/vfio_pci_device.c      | 75 ++++++++++---------
 2 files changed, 49 insertions(+), 42 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools/testing/selftests/vfio/lib/include/vfio_util.h
index 2f5555138d7f..3160f2d1ea6d 100644
--- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
+++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
@@ -163,15 +163,19 @@ struct vfio_pci_driver {
 	int msi;
 };
 
+struct iommu {
+	const struct iommu_mode *mode;
+	int container_fd;
+	int iommufd;
+	u32 ioas_id;
+	struct list_head dma_regions;
+};
+
 struct vfio_pci_device {
 	int fd;
-
-	const struct iommu_mode *iommu_mode;
 	int group_fd;
-	int container_fd;
 
-	int iommufd;
-	u32 ioas_id;
+	struct iommu *iommu;
 
 	struct vfio_device_info info;
 	struct vfio_region_info config_space;
@@ -180,8 +184,6 @@ struct vfio_pci_device {
 	struct vfio_irq_info msi_info;
 	struct vfio_irq_info msix_info;
 
-	struct list_head dma_regions;
-
 	/* eventfds for MSI and MSI-x interrupts */
 	int msi_eventfds[PCI_MSIX_FLAGS_QSIZE + 1];
 
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 4a021ff4fc40..e47f3ccf6d49 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -277,7 +277,7 @@ iova_t __to_iova(struct vfio_pci_device *device, void *vaddr)
 {
 	struct vfio_dma_region *region;
 
-	list_for_each_entry(region, &device->dma_regions, link) {
+	list_for_each_entry(region, &device->iommu->dma_regions, link) {
 		if (vaddr < region->vaddr)
 			continue;
 
@@ -397,7 +397,7 @@ static int vfio_iommu_dma_map(struct vfio_pci_device *device,
 		.size = region->size,
 	};
 
-	if (ioctl(device->container_fd, VFIO_IOMMU_MAP_DMA, &args))
+	if (ioctl(device->iommu->container_fd, VFIO_IOMMU_MAP_DMA, &args))
 		return -errno;
 
 	return 0;
@@ -414,10 +414,10 @@ static int iommufd_dma_map(struct vfio_pci_device *device,
 		.user_va = (u64)region->vaddr,
 		.iova = region->iova,
 		.length = region->size,
-		.ioas_id = device->ioas_id,
+		.ioas_id = device->iommu->ioas_id,
 	};
 
-	if (ioctl(device->iommufd, IOMMU_IOAS_MAP, &args))
+	if (ioctl(device->iommu->iommufd, IOMMU_IOAS_MAP, &args))
 		return -errno;
 
 	return 0;
@@ -428,7 +428,7 @@ int __vfio_pci_dma_map(struct vfio_pci_device *device,
 {
 	int ret;
 
-	if (device->iommufd)
+	if (device->iommu->iommufd)
 		ret = iommufd_dma_map(device, region);
 	else
 		ret = vfio_iommu_dma_map(device, region);
@@ -436,7 +436,7 @@ int __vfio_pci_dma_map(struct vfio_pci_device *device,
 	if (ret)
 		return ret;
 
-	list_add(&region->link, &device->dma_regions);
+	list_add(&region->link, &device->iommu->dma_regions);
 
 	return 0;
 }
@@ -484,13 +484,14 @@ int __vfio_pci_dma_unmap(struct vfio_pci_device *device,
 {
 	int ret;
 
-	if (device->iommufd)
-		ret = iommufd_dma_unmap(device->iommufd, region->iova,
-					region->size, device->ioas_id,
+	if (device->iommu->iommufd)
+		ret = iommufd_dma_unmap(device->iommu->iommufd, region->iova,
+					region->size, device->iommu->ioas_id,
 					unmapped);
 	else
-		ret = vfio_iommu_dma_unmap(device->container_fd, region->iova,
-					   region->size, 0, unmapped);
+		ret = vfio_iommu_dma_unmap(device->iommu->container_fd,
+					   region->iova, region->size, 0,
+					   unmapped);
 
 	if (ret)
 		return ret;
@@ -505,17 +506,17 @@ int __vfio_pci_dma_unmap_all(struct vfio_pci_device *device, u64 *unmapped)
 	int ret;
 	struct vfio_dma_region *curr, *next;
 
-	if (device->iommufd)
-		ret = iommufd_dma_unmap(device->iommufd, 0, UINT64_MAX,
-					device->ioas_id, unmapped);
+	if (device->iommu->iommufd)
+		ret = iommufd_dma_unmap(device->iommu->iommufd, 0, UINT64_MAX,
+					device->iommu->ioas_id, unmapped);
 	else
-		ret = vfio_iommu_dma_unmap(device->container_fd, 0, 0,
+		ret = vfio_iommu_dma_unmap(device->iommu->container_fd, 0, 0,
 					   VFIO_DMA_UNMAP_FLAG_ALL, unmapped);
 
 	if (ret)
 		return ret;
 
-	list_for_each_entry_safe(curr, next, &device->dma_regions, link)
+	list_for_each_entry_safe(curr, next, &device->iommu->dma_regions, link)
 		list_del_init(&curr->link);
 
 	return 0;
@@ -627,28 +628,28 @@ static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf
 	ioctl_assert(device->group_fd, VFIO_GROUP_GET_STATUS, &group_status);
 	VFIO_ASSERT_TRUE(group_status.flags & VFIO_GROUP_FLAGS_VIABLE);
 
-	ioctl_assert(device->group_fd, VFIO_GROUP_SET_CONTAINER, &device->container_fd);
+	ioctl_assert(device->group_fd, VFIO_GROUP_SET_CONTAINER, &device->iommu->container_fd);
 }
 
 static void vfio_pci_container_setup(struct vfio_pci_device *device, const char *bdf)
 {
-	unsigned long iommu_type = device->iommu_mode->iommu_type;
-	const char *path = device->iommu_mode->container_path;
+	unsigned long iommu_type = device->iommu->mode->iommu_type;
+	const char *path = device->iommu->mode->container_path;
 	int version;
 	int ret;
 
-	device->container_fd = open(path, O_RDWR);
-	VFIO_ASSERT_GE(device->container_fd, 0, "open(%s) failed\n", path);
+	device->iommu->container_fd = open(path, O_RDWR);
+	VFIO_ASSERT_GE(device->iommu->container_fd, 0, "open(%s) failed\n", path);
 
-	version = ioctl(device->container_fd, VFIO_GET_API_VERSION);
+	version = ioctl(device->iommu->container_fd, VFIO_GET_API_VERSION);
 	VFIO_ASSERT_EQ(version, VFIO_API_VERSION, "Unsupported version: %d\n", version);
 
 	vfio_pci_group_setup(device, bdf);
 
-	ret = ioctl(device->container_fd, VFIO_CHECK_EXTENSION, iommu_type);
+	ret = ioctl(device->iommu->container_fd, VFIO_CHECK_EXTENSION, iommu_type);
 	VFIO_ASSERT_GT(ret, 0, "VFIO IOMMU type %lu not supported\n", iommu_type);
 
-	ioctl_assert(device->container_fd, VFIO_SET_IOMMU, (void *)iommu_type);
+	ioctl_assert(device->iommu->container_fd, VFIO_SET_IOMMU, (void *)iommu_type);
 
 	device->fd = ioctl(device->group_fd, VFIO_GROUP_GET_DEVICE_FD, bdf);
 	VFIO_ASSERT_GE(device->fd, 0);
@@ -801,12 +802,12 @@ static void vfio_pci_iommufd_setup(struct vfio_pci_device *device, const char *b
 	 * used to check if iommufd is enabled. In practice open() will never
 	 * return 0 unless stdin is closed.
 	 */
-	device->iommufd = open("/dev/iommu", O_RDWR);
-	VFIO_ASSERT_GT(device->iommufd, 0);
+	device->iommu->iommufd = open("/dev/iommu", O_RDWR);
+	VFIO_ASSERT_GT(device->iommu->iommufd, 0);
 
-	vfio_device_bind_iommufd(device->fd, device->iommufd);
-	device->ioas_id = iommufd_ioas_alloc(device->iommufd);
-	vfio_device_attach_iommufd_pt(device->fd, device->ioas_id);
+	vfio_device_bind_iommufd(device->fd, device->iommu->iommufd);
+	device->iommu->ioas_id = iommufd_ioas_alloc(device->iommu->iommufd);
+	vfio_device_attach_iommufd_pt(device->fd, device->iommu->ioas_id);
 }
 
 struct vfio_pci_device *vfio_pci_device_init(const char *bdf, const char *iommu_mode)
@@ -816,11 +817,14 @@ struct vfio_pci_device *vfio_pci_device_init(const char *bdf, const char *iommu_
 	device = calloc(1, sizeof(*device));
 	VFIO_ASSERT_NOT_NULL(device);
 
-	INIT_LIST_HEAD(&device->dma_regions);
+	device->iommu = calloc(1, sizeof(*device->iommu));
+	VFIO_ASSERT_NOT_NULL(device->iommu);
+
+	INIT_LIST_HEAD(&device->iommu->dma_regions);
 
-	device->iommu_mode = lookup_iommu_mode(iommu_mode);
+	device->iommu->mode = lookup_iommu_mode(iommu_mode);
 
-	if (device->iommu_mode->container_path)
+	if (device->iommu->mode->container_path)
 		vfio_pci_container_setup(device, bdf);
 	else
 		vfio_pci_iommufd_setup(device, bdf);
@@ -849,13 +853,14 @@ void vfio_pci_device_cleanup(struct vfio_pci_device *device)
 		VFIO_ASSERT_EQ(close(device->msi_eventfds[i]), 0);
 	}
 
-	if (device->iommufd) {
-		VFIO_ASSERT_EQ(close(device->iommufd), 0);
+	if (device->iommu->iommufd) {
+		VFIO_ASSERT_EQ(close(device->iommu->iommufd), 0);
 	} else {
 		VFIO_ASSERT_EQ(close(device->group_fd), 0);
-		VFIO_ASSERT_EQ(close(device->container_fd), 0);
+		VFIO_ASSERT_EQ(close(device->iommu->container_fd), 0);
 	}
 
+	free(device->iommu);
 	free(device);
 }
 
-- 
2.52.0.rc2.455.g230fcf2819-goog


