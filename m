Return-Path: <kvm+bounces-59664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D10FBC6DAA
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 01:26:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DA45E4EFA93
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 23:26:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1B9A2C21D1;
	Wed,  8 Oct 2025 23:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qe+pnXDi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74466242D65
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 23:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759965965; cv=none; b=FlXIhICYd3yUSCz27be6ou9DUmzJY1/PrUulykLpqxIASsEKfEITkzGUz2LB+YAnEnQgs9SMaeZGUJzpWE5s1i9PiiBwV8HQ3VnoRjBiKlqipfjZyg9WlD1+EH4zWeOooosvNk9BE8ATStyjPgdlwjKy7gCIpmGQslGQZy4ZUkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759965965; c=relaxed/simple;
	bh=X+zKKmXfVwBFzLJSLGkMiOmwr3qmqj7IxVwkz/0TPys=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Pm+ftdUuI1+NUzAHTDWuVCF5Uf6c1TnbtPcDTCs0QVWeSfsnPZuPFSqP0EuvHkpUnxJyVYKifcKW/XQ+cBNuyqXbOouFAUKoc11bjsfUQmt0Y4MHoo/Qz2sljFtu32gPmKQazMC09Gif8Gz8HzwqCg5BJMTnmbOfMlOx705Q4ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qe+pnXDi; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-782063922ceso403218b3a.0
        for <kvm@vger.kernel.org>; Wed, 08 Oct 2025 16:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759965963; x=1760570763; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ky5YX4n37SzA1RE73u80Lq7SNWvHET6IIpNflu5rzMI=;
        b=qe+pnXDibVWvsNwgWTnvW4ERxA+sBCf325iCFTFAS3Yz5iUg/L70Yj6ZWIn8Jvz9+X
         LdvNSMZWATwtA5Y1DV741TD+dKv1tN8WggiuY827j63hGKe0k5ic895auvEmbOhm3h9/
         1sJHRTyPZ+snWnUAnf45Ar/yuei9p3n0bJ7S2zVK36G6Gaeqfod3oFWIE2FmImjhmBDQ
         K9YR5K5Q+kDxhgwmN5Um88GTL01mzMa+drJMa3beETCWuBX5XQcI/15BzWwdwM4Syp3U
         BwGffKWaoFbM8QG1lqkrRANFB9NdxQGlKS9MXFFpWZVbJ+N92ybwMXKDLJ9qZWuSX9k/
         GjPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759965963; x=1760570763;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ky5YX4n37SzA1RE73u80Lq7SNWvHET6IIpNflu5rzMI=;
        b=TVrwsyOXPw4lwH/TPn4Qik4hogwP8NPyAr6tOcSz8TuYoRlBfykBdIvYNNuPfiKPYL
         3M8grby3KdwKj0S1Sa6Jt3l57Z17JlcjPMOw8iVZnf5Cd9VYLRnmRSPsuMAIulEEWE/j
         rn65aNvKJLquKvgmoGF87vlNg518gTjnSaGFiEm/2r9mFzsnCWKkprFxzYMRutjiUAsz
         hWtTGlIIH2d5hrRuFjO9JPrkia/dcZyy3nH7U8PJNtN64ffMCsQneBUSHp6fodV2mVyF
         4ilfB9ybAUXEBK167I67Z38YZOH+wtO6UNSrxGS+o+ZtcYRigzcQitjj5OIjfmriDv3W
         A21g==
X-Forwarded-Encrypted: i=1; AJvYcCUTsApxtBdWY0WVnfM6AAzKMYBIZ0c7QBBWcUrk2uJyztFyR0Aw2iXe/Zg4FJn2aR894qw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTjnV/WNtf4Eym4j1K+ltcgHaThRO/YH1nCefaVZp8KP7rRnva
	ClSsXgPRiAIS5/khrOzRzbm5JU04V8ewhMluudyxrZ/MoMAhrgN4vkxBhRNkGJNg8xwu3qNs+zC
	mqPNiQXYqtHHG0Q==
X-Google-Smtp-Source: AGHT+IGcR/2x1DyCXmj4Nl5cgbgScaLGwCk/Bpg1CunebTQRlkHZ2YEtbDInGIEKL53uY6gD0ezBOQQbukRArg==
X-Received: from pfbna4.prod.google.com ([2002:a05:6a00:3e04:b0:77f:64ef:a4a9])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:847:b0:77f:4b9b:8c34 with SMTP id d2e1a72fcca58-79387ff6c26mr6056575b3a.31.1759965962701;
 Wed, 08 Oct 2025 16:26:02 -0700 (PDT)
Date: Wed,  8 Oct 2025 23:25:23 +0000
In-Reply-To: <20251008232531.1152035-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251008232531.1152035-1-dmatlack@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008232531.1152035-5-dmatlack@google.com>
Subject: [PATCH 04/12] vfio: selftests: Introduce struct iommu
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: David Matlack <dmatlack@google.com>, Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, 
	kvm@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce struct iommu, which logically represents either a VFIO
container or an iommufd IOAS, depending on which IOMMU mode is used by
the test.

This will be used in a subsequent commit to allow devices to be added to
the same container/iommufd.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/vfio/lib/include/vfio_util.h    | 16 ++---
 .../selftests/vfio/lib/vfio_pci_device.c      | 62 ++++++++++---------
 2 files changed, 42 insertions(+), 36 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools/testing/selftests/vfio/lib/include/vfio_util.h
index 5b8d5444f105..14cd0bec45c0 100644
--- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
+++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
@@ -160,15 +160,19 @@ struct vfio_pci_driver {
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
@@ -177,8 +181,6 @@ struct vfio_pci_device {
 	struct vfio_irq_info msi_info;
 	struct vfio_irq_info msix_info;
 
-	struct list_head dma_regions;
-
 	/* eventfds for MSI and MSI-x interrupts */
 	int msi_eventfds[PCI_MSIX_FLAGS_QSIZE + 1];
 
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index da8edf297a4d..e4596a570422 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -32,7 +32,7 @@ iova_t __to_iova(struct vfio_pci_device *device, void *vaddr)
 {
 	struct vfio_dma_region *region;
 
-	list_for_each_entry(region, &device->dma_regions, link) {
+	list_for_each_entry(region, &device->iommu->dma_regions, link) {
 		if (vaddr < region->vaddr)
 			continue;
 
@@ -152,7 +152,7 @@ static void vfio_iommu_dma_map(struct vfio_pci_device *device,
 		.size = region->size,
 	};
 
-	ioctl_assert(device->container_fd, VFIO_IOMMU_MAP_DMA, &args);
+	ioctl_assert(device->iommu->container_fd, VFIO_IOMMU_MAP_DMA, &args);
 }
 
 static void iommufd_dma_map(struct vfio_pci_device *device,
@@ -166,21 +166,21 @@ static void iommufd_dma_map(struct vfio_pci_device *device,
 		.user_va = (u64)region->vaddr,
 		.iova = region->iova,
 		.length = region->size,
-		.ioas_id = device->ioas_id,
+		.ioas_id = device->iommu->ioas_id,
 	};
 
-	ioctl_assert(device->iommufd, IOMMU_IOAS_MAP, &args);
+	ioctl_assert(device->iommu->iommufd, IOMMU_IOAS_MAP, &args);
 }
 
 void vfio_pci_dma_map(struct vfio_pci_device *device,
 		      struct vfio_dma_region *region)
 {
-	if (device->iommufd)
+	if (device->iommu->iommufd)
 		iommufd_dma_map(device, region);
 	else
 		vfio_iommu_dma_map(device, region);
 
-	list_add(&region->link, &device->dma_regions);
+	list_add(&region->link, &device->iommu->dma_regions);
 }
 
 static void vfio_iommu_dma_unmap(struct vfio_pci_device *device,
@@ -192,7 +192,7 @@ static void vfio_iommu_dma_unmap(struct vfio_pci_device *device,
 		.size = region->size,
 	};
 
-	ioctl_assert(device->container_fd, VFIO_IOMMU_UNMAP_DMA, &args);
+	ioctl_assert(device->iommu->container_fd, VFIO_IOMMU_UNMAP_DMA, &args);
 }
 
 static void iommufd_dma_unmap(struct vfio_pci_device *device,
@@ -202,16 +202,16 @@ static void iommufd_dma_unmap(struct vfio_pci_device *device,
 		.size = sizeof(args),
 		.iova = region->iova,
 		.length = region->size,
-		.ioas_id = device->ioas_id,
+		.ioas_id = device->iommu->ioas_id,
 	};
 
-	ioctl_assert(device->iommufd, IOMMU_IOAS_UNMAP, &args);
+	ioctl_assert(device->iommu->iommufd, IOMMU_IOAS_UNMAP, &args);
 }
 
 void vfio_pci_dma_unmap(struct vfio_pci_device *device,
 			struct vfio_dma_region *region)
 {
-	if (device->iommufd)
+	if (device->iommu->iommufd)
 		iommufd_dma_unmap(device, region);
 	else
 		vfio_iommu_dma_unmap(device, region);
@@ -325,28 +325,28 @@ static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf
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
@@ -499,12 +499,12 @@ static void vfio_pci_iommufd_setup(struct vfio_pci_device *device, const char *b
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
@@ -514,11 +514,14 @@ struct vfio_pci_device *vfio_pci_device_init(const char *bdf, const char *iommu_
 	device = calloc(1, sizeof(*device));
 	VFIO_ASSERT_NOT_NULL(device);
 
-	INIT_LIST_HEAD(&device->dma_regions);
+	device->iommu = calloc(1, sizeof(*device->iommu));
+	VFIO_ASSERT_NOT_NULL(device->iommu);
 
-	device->iommu_mode = lookup_iommu_mode(iommu_mode);
+	INIT_LIST_HEAD(&device->iommu->dma_regions);
 
-	if (device->iommu_mode->container_path)
+	device->iommu->mode = lookup_iommu_mode(iommu_mode);
+
+	if (device->iommu->mode->container_path)
 		vfio_pci_container_setup(device, bdf);
 	else
 		vfio_pci_iommufd_setup(device, bdf);
@@ -547,13 +550,14 @@ void vfio_pci_device_cleanup(struct vfio_pci_device *device)
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
2.51.0.710.ga91ca5db03-goog


