Return-Path: <kvm+bounces-59670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F74DBC6DBC
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 01:26:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 44C644F12DC
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 23:26:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA5C02C325F;
	Wed,  8 Oct 2025 23:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tSoXARC7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF242C028C
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 23:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759965975; cv=none; b=GyviJ8UuwU2LHYpLJF80V7E5EQJVzwGRP5Iv0ua6pD2FykO+a3PZjvBW0o+PkK2zZ8ZfiOc9lzdFmfK0wj8+xzYtSv2y09qtw74zxciu12Z+e2eg9gIO/QutyOZl4rqDrUSlenpibup3Tc+UWAUVzWODHglJ7s35pbLAn6/GYnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759965975; c=relaxed/simple;
	bh=+ipW6qR2B68de+pcNXxsDRWQnJ20HK+heGmADCsbXDc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=esJYczi9Mjmf5zUs/GG1etc95ky/KlmFhsS8RjX/yQ3dBoQvI9Ebw7Jj5PBwISGeRI3Ir+cutht/UDquzydURZ/p2mW9qd3ohu0waOVPpelMzZIpBKY6Xsn9EEg1XU3LdlVSdCk3PMVbbI1JWicCdhZG06QynlYsIFxPJs/8SM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tSoXARC7; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-782063922ceso403340b3a.0
        for <kvm@vger.kernel.org>; Wed, 08 Oct 2025 16:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759965970; x=1760570770; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eW0sE7tYyGyvQRHzYuNrp8Ct58MKm1/CUUnGNm4I2rA=;
        b=tSoXARC7cWTOgxQOaXhuj7xnj56lqLd4gSPx5Tga564fRVWaD3+yGdEpHcmGU16lCz
         4wGRMeb2KSrTzq7LbKjE4mjoaOZJMmVcRYQTZo2x+xR1W84vbxSE+7NMzcnkezUzbAfu
         Qlte4RVLrkqFEb/d0GAnVERIzHnJbevGXLiw8t/uBRhuwbK4gG6Aec0aGSjkLQlYMrvD
         hMEGciorGyx2M32qhnnGOd/XIo82iPpxoTKrTm726NpkK8yDcuB7SXlNj+t8CpC+kMUK
         QMwKvGjDFmOfwHuzKEabSOn4UWp5u7Ew9FSXNKEsnj3qMB0TGRBcK85Id0NX6CAS5YYr
         xBOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759965970; x=1760570770;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eW0sE7tYyGyvQRHzYuNrp8Ct58MKm1/CUUnGNm4I2rA=;
        b=kWmPNAqrjAmRPc7CieROOjHYw88eE8X5PfWCbOFepdflRXxBsnGdr94EZmc3tBzR1n
         vC4Oq8T/W/EREIlnLSAkFXWNb620ECGhBPhqYIEY5oGu01NRPPf3JsAQqWP3W4oEHmPL
         D9nhKM70mSX9iHjVEKO0RdFJsP1yYqHLaQ2tI6kMnH86TZOpg+j7RZWmmBD8BEPbEaeO
         JDDVoH/YpIoNhOWluy5OHsYZ1eXZS0zxgongUfq4WxWTxD6JFAP+G2IyZbKAgoJ5Z+m5
         IZPFIhriWwOgzmRIr62FW0ujPe+3wVqJL3wnyIg9LOtA+Im6HrpkBMb1ktuODpI9hwfS
         +u0g==
X-Forwarded-Encrypted: i=1; AJvYcCW3Aq2PUJh/5Pr0cZAFSo1PYmJFfnWDAr1x0Zvvg5kDran5JKanfEemYsJCPiVRR1tDR3A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5WzOqNEXNl/q+kgjXWx1DbmM58rfZVcyaJe0L3sFVFxHUgJvN
	UmV30bruiUxiKOKy9U42y7GVxDO4QveiZbsYOatfTRrIZL2BgiOAvaSSqTz+anlpMVzMUloLmiu
	FjK6mojzEaHBY1w==
X-Google-Smtp-Source: AGHT+IEL5H6XgMLqpz2nc84pFYAPeiGcmOFrcD8pDEco0MTEk5hEZZ9OZkuZGN3oTRQi3Vy3L9FXJKac1Yi3nw==
X-Received: from pfbgt6.prod.google.com ([2002:a05:6a00:4e06:b0:772:3537:d602])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:9145:b0:2d9:b2ee:785e with SMTP id adf61e73a8af0-32da84618eemr6996400637.53.1759965970077;
 Wed, 08 Oct 2025 16:26:10 -0700 (PDT)
Date: Wed,  8 Oct 2025 23:25:28 +0000
In-Reply-To: <20251008232531.1152035-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251008232531.1152035-1-dmatlack@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008232531.1152035-10-dmatlack@google.com>
Subject: [PATCH 09/12] vfio: selftests: Move iommu_*() functions into iommu.c
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: David Matlack <dmatlack@google.com>, Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, 
	kvm@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Move all the iommu_*() helper functions into their own file iommu.c.
This provides a better separation between the vfio_pci_device helper
code and the iommu code.

No function change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/vfio/lib/include/vfio_util.h    |  37 ++-
 tools/testing/selftests/vfio/lib/iommu.c      | 219 ++++++++++++++++++
 tools/testing/selftests/vfio/lib/libvfio.mk   |   3 +-
 .../selftests/vfio/lib/vfio_pci_device.c      | 212 -----------------
 4 files changed, 252 insertions(+), 219 deletions(-)
 create mode 100644 tools/testing/selftests/vfio/lib/iommu.c

diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools/testing/selftests/vfio/lib/include/vfio_util.h
index cce521212348..c7932096ac2e 100644
--- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
+++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
@@ -7,6 +7,7 @@
 #include <linux/vfio.h>
 #include <linux/list.h>
 #include <linux/pci_regs.h>
+#include <sys/ioctl.h>
 
 #include "../../../kselftest.h"
 
@@ -47,6 +48,12 @@
 	VFIO_LOG_AND_EXIT(_fmt, ##__VA_ARGS__);			\
 } while (0)
 
+#define ioctl_assert(_fd, _op, _arg) do {						       \
+	void *__arg = (_arg);								       \
+	int __ret = ioctl((_fd), (_op), (__arg));					       \
+	VFIO_ASSERT_EQ(__ret, 0, "ioctl(%s, %s, %s) returned %d\n", #_fd, #_op, #_arg, __ret); \
+} while (0)
+
 #define dev_info(_dev, _fmt, ...) printf("%s: " _fmt, (_dev)->bdf, ##__VA_ARGS__)
 #define dev_err(_dev, _fmt, ...) fprintf(stderr, "%s: " _fmt, (_dev)->bdf, ##__VA_ARGS__)
 
@@ -212,6 +219,10 @@ extern const char *default_iommu_mode;
 
 struct iommu *iommu_init(const char *iommu_mode);
 void iommu_cleanup(struct iommu *iommu);
+iova_t iommu_hva2iova(struct iommu *iommu, void *vaddr);
+iova_t __iommu_hva2iova(struct iommu *iommu, void *vaddr);
+void iommu_map(struct iommu *iommu, struct dma_region *region);
+void iommu_unmap(struct iommu *iommu, struct dma_region *region);
 
 struct vfio_pci_device *__vfio_pci_device_init(const char *bdf, struct iommu *iommu);
 struct vfio_pci_device *vfio_pci_device_init(const char *bdf, const char *iommu_mode);
@@ -221,10 +232,17 @@ void vfio_pci_device_cleanup(struct vfio_pci_device *device);
 
 void vfio_pci_device_reset(struct vfio_pci_device *device);
 
-void vfio_pci_dma_map(struct vfio_pci_device *device,
-		      struct dma_region *region);
-void vfio_pci_dma_unmap(struct vfio_pci_device *device,
-			struct dma_region *region);
+static inline void vfio_pci_dma_map(struct vfio_pci_device *device,
+				    struct dma_region *region)
+{
+	return iommu_map(device->iommu, region);
+}
+
+static inline void vfio_pci_dma_unmap(struct vfio_pci_device *device,
+				      struct dma_region *region)
+{
+	return iommu_unmap(device->iommu, region);
+}
 
 void vfio_pci_config_access(struct vfio_pci_device *device, bool write,
 			    size_t config, size_t size, void *data);
@@ -286,8 +304,15 @@ static inline void vfio_pci_msix_disable(struct vfio_pci_device *device)
 	vfio_pci_irq_disable(device, VFIO_PCI_MSIX_IRQ_INDEX);
 }
 
-iova_t __to_iova(struct vfio_pci_device *device, void *vaddr);
-iova_t to_iova(struct vfio_pci_device *device, void *vaddr);
+static inline iova_t __to_iova(struct vfio_pci_device *device, void *vaddr)
+{
+	return __iommu_hva2iova(device->iommu, vaddr);
+}
+
+static inline iova_t to_iova(struct vfio_pci_device *device, void *vaddr)
+{
+	return iommu_hva2iova(device->iommu, vaddr);
+}
 
 static inline bool vfio_pci_device_match(struct vfio_pci_device *device,
 					 u16 vendor_id, u16 device_id)
diff --git a/tools/testing/selftests/vfio/lib/iommu.c b/tools/testing/selftests/vfio/lib/iommu.c
new file mode 100644
index 000000000000..a835b0d29abf
--- /dev/null
+++ b/tools/testing/selftests/vfio/lib/iommu.c
@@ -0,0 +1,219 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <dirent.h>
+#include <fcntl.h>
+#include <libgen.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+#include <sys/eventfd.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+
+#include <uapi/linux/types.h>
+#include <linux/limits.h>
+#include <linux/mman.h>
+#include <linux/types.h>
+#include <linux/vfio.h>
+#include <linux/iommufd.h>
+
+#include "../../../kselftest.h"
+#include <vfio_util.h>
+
+const char *default_iommu_mode = "iommufd";
+
+/* Reminder: Keep in sync with FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES(). */
+static const struct iommu_mode iommu_modes[] = {
+	{
+		.name = "vfio_type1_iommu",
+		.container_path = "/dev/vfio/vfio",
+		.iommu_type = VFIO_TYPE1_IOMMU,
+	},
+	{
+		.name = "vfio_type1v2_iommu",
+		.container_path = "/dev/vfio/vfio",
+		.iommu_type = VFIO_TYPE1v2_IOMMU,
+	},
+	{
+		.name = "iommufd_compat_type1",
+		.container_path = "/dev/iommu",
+		.iommu_type = VFIO_TYPE1_IOMMU,
+	},
+	{
+		.name = "iommufd_compat_type1v2",
+		.container_path = "/dev/iommu",
+		.iommu_type = VFIO_TYPE1v2_IOMMU,
+	},
+	{
+		.name = "iommufd",
+	},
+};
+
+iova_t __iommu_hva2iova(struct iommu *iommu, void *vaddr)
+{
+	struct dma_region *region;
+
+	list_for_each_entry(region, &iommu->dma_regions, link) {
+		if (vaddr < region->vaddr)
+			continue;
+
+		if (vaddr >= region->vaddr + region->size)
+			continue;
+
+		return region->iova + (vaddr - region->vaddr);
+	}
+
+	return INVALID_IOVA;
+}
+
+iova_t iommu_hva2iova(struct iommu *iommu, void *vaddr)
+{
+	iova_t iova = __iommu_hva2iova(iommu, vaddr);
+
+	VFIO_ASSERT_NE(iova, INVALID_IOVA, "VA %p is not mapped\n", vaddr);
+	return iova;
+}
+
+static void vfio_iommu_dma_map(struct iommu *iommu, struct dma_region *region)
+{
+	struct vfio_iommu_type1_dma_map args = {
+		.argsz = sizeof(args),
+		.flags = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE,
+		.vaddr = (u64)region->vaddr,
+		.iova = region->iova,
+		.size = region->size,
+	};
+
+	ioctl_assert(iommu->container_fd, VFIO_IOMMU_MAP_DMA, &args);
+}
+
+static void iommufd_dma_map(struct iommu *iommu, struct dma_region *region)
+{
+	struct iommu_ioas_map args = {
+		.size = sizeof(args),
+		.flags = IOMMU_IOAS_MAP_READABLE |
+			 IOMMU_IOAS_MAP_WRITEABLE |
+			 IOMMU_IOAS_MAP_FIXED_IOVA,
+		.user_va = (u64)region->vaddr,
+		.iova = region->iova,
+		.length = region->size,
+		.ioas_id = iommu->ioas_id,
+	};
+
+	ioctl_assert(iommu->iommufd, IOMMU_IOAS_MAP, &args);
+}
+
+void iommu_map(struct iommu *iommu, struct dma_region *region)
+{
+	if (iommu->iommufd)
+		iommufd_dma_map(iommu, region);
+	else
+		vfio_iommu_dma_map(iommu, region);
+
+	list_add(&region->link, &iommu->dma_regions);
+}
+
+static void vfio_iommu_dma_unmap(struct iommu *iommu, struct dma_region *region)
+{
+	struct vfio_iommu_type1_dma_unmap args = {
+		.argsz = sizeof(args),
+		.iova = region->iova,
+		.size = region->size,
+	};
+
+	ioctl_assert(iommu->container_fd, VFIO_IOMMU_UNMAP_DMA, &args);
+}
+
+static void iommufd_dma_unmap(struct iommu *iommu, struct dma_region *region)
+{
+	struct iommu_ioas_unmap args = {
+		.size = sizeof(args),
+		.iova = region->iova,
+		.length = region->size,
+		.ioas_id = iommu->ioas_id,
+	};
+
+	ioctl_assert(iommu->iommufd, IOMMU_IOAS_UNMAP, &args);
+}
+
+void iommu_unmap(struct iommu *iommu, struct dma_region *region)
+{
+	if (iommu->iommufd)
+		iommufd_dma_unmap(iommu, region);
+	else
+		vfio_iommu_dma_unmap(iommu, region);
+
+	list_del(&region->link);
+}
+
+static const struct iommu_mode *lookup_iommu_mode(const char *iommu_mode)
+{
+	int i;
+
+	if (!iommu_mode)
+		iommu_mode = default_iommu_mode;
+
+	for (i = 0; i < ARRAY_SIZE(iommu_modes); i++) {
+		if (strcmp(iommu_mode, iommu_modes[i].name))
+			continue;
+
+		return &iommu_modes[i];
+	}
+
+	VFIO_FAIL("Unrecognized IOMMU mode: %s\n", iommu_mode);
+}
+
+static u32 iommufd_ioas_alloc(int iommufd)
+{
+	struct iommu_ioas_alloc args = {
+		.size = sizeof(args),
+	};
+
+	ioctl_assert(iommufd, IOMMU_IOAS_ALLOC, &args);
+	return args.out_ioas_id;
+}
+
+struct iommu *iommu_init(const char *iommu_mode)
+{
+	const char *container_path;
+	struct iommu *iommu;
+	int version;
+
+	iommu = calloc(1, sizeof(*iommu));
+	VFIO_ASSERT_NOT_NULL(iommu);
+
+	INIT_LIST_HEAD(&iommu->dma_regions);
+
+	iommu->mode = lookup_iommu_mode(iommu_mode);
+
+	container_path = iommu->mode->container_path;
+	if (container_path) {
+		iommu->container_fd = open(container_path, O_RDWR);
+		VFIO_ASSERT_GE(iommu->container_fd, 0, "open(%s) failed\n", container_path);
+
+		version = ioctl(iommu->container_fd, VFIO_GET_API_VERSION);
+		VFIO_ASSERT_EQ(version, VFIO_API_VERSION, "Unsupported version: %d\n", version);
+	} else {
+		/*
+		 * Require device->iommufd to be >0 so that a simple non-0 check can be
+		 * used to check if iommufd is enabled. In practice open() will never
+		 * return 0 unless stdin is closed.
+		 */
+		iommu->iommufd = open("/dev/iommu", O_RDWR);
+		VFIO_ASSERT_GT(iommu->iommufd, 0);
+
+		iommu->ioas_id = iommufd_ioas_alloc(iommu->iommufd);
+	}
+
+	return iommu;
+}
+
+void iommu_cleanup(struct iommu *iommu)
+{
+	if (iommu->iommufd)
+		VFIO_ASSERT_EQ(close(iommu->iommufd), 0);
+	else
+		VFIO_ASSERT_EQ(close(iommu->container_fd), 0);
+
+	free(iommu);
+}
diff --git a/tools/testing/selftests/vfio/lib/libvfio.mk b/tools/testing/selftests/vfio/lib/libvfio.mk
index 5d11c3a89a28..1d53311e2610 100644
--- a/tools/testing/selftests/vfio/lib/libvfio.mk
+++ b/tools/testing/selftests/vfio/lib/libvfio.mk
@@ -3,7 +3,8 @@ ARCH ?= $(SUBARCH)
 
 VFIO_DIR := $(selfdir)/vfio
 
-LIBVFIO_C := lib/vfio_pci_device.c
+LIBVFIO_C := lib/iommu.c
+LIBVFIO_C += lib/vfio_pci_device.c
 LIBVFIO_C += lib/vfio_pci_driver.c
 
 ifeq ($(ARCH:x86_64=x86),x86)
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index c9cfba1dc62c..b026b908dcd2 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -22,39 +22,6 @@
 
 #define PCI_SYSFS_PATH	"/sys/bus/pci/devices"
 
-#define ioctl_assert(_fd, _op, _arg) do {						       \
-	void *__arg = (_arg);								       \
-	int __ret = ioctl((_fd), (_op), (__arg));					       \
-	VFIO_ASSERT_EQ(__ret, 0, "ioctl(%s, %s, %s) returned %d\n", #_fd, #_op, #_arg, __ret); \
-} while (0)
-
-iova_t __to_iova(struct vfio_pci_device *device, void *vaddr)
-{
-	struct dma_region *region;
-
-	list_for_each_entry(region, &device->iommu->dma_regions, link) {
-		if (vaddr < region->vaddr)
-			continue;
-
-		if (vaddr >= region->vaddr + region->size)
-			continue;
-
-		return region->iova + (vaddr - region->vaddr);
-	}
-
-	return INVALID_IOVA;
-}
-
-iova_t to_iova(struct vfio_pci_device *device, void *vaddr)
-{
-	iova_t iova;
-
-	iova = __to_iova(device, vaddr);
-	VFIO_ASSERT_NE(iova, INVALID_IOVA, "%p is not mapped into device.\n", vaddr);
-
-	return iova;
-}
-
 static void vfio_pci_irq_set(struct vfio_pci_device *device,
 			     u32 index, u32 vector, u32 count, int *fds)
 {
@@ -141,84 +108,6 @@ static void vfio_pci_irq_get(struct vfio_pci_device *device, u32 index,
 	ioctl_assert(device->fd, VFIO_DEVICE_GET_IRQ_INFO, irq_info);
 }
 
-static void vfio_iommu_dma_map(struct vfio_pci_device *device,
-			       struct dma_region *region)
-{
-	struct vfio_iommu_type1_dma_map args = {
-		.argsz = sizeof(args),
-		.flags = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE,
-		.vaddr = (u64)region->vaddr,
-		.iova = region->iova,
-		.size = region->size,
-	};
-
-	ioctl_assert(device->iommu->container_fd, VFIO_IOMMU_MAP_DMA, &args);
-}
-
-static void iommufd_dma_map(struct vfio_pci_device *device,
-			    struct dma_region *region)
-{
-	struct iommu_ioas_map args = {
-		.size = sizeof(args),
-		.flags = IOMMU_IOAS_MAP_READABLE |
-			 IOMMU_IOAS_MAP_WRITEABLE |
-			 IOMMU_IOAS_MAP_FIXED_IOVA,
-		.user_va = (u64)region->vaddr,
-		.iova = region->iova,
-		.length = region->size,
-		.ioas_id = device->iommu->ioas_id,
-	};
-
-	ioctl_assert(device->iommu->iommufd, IOMMU_IOAS_MAP, &args);
-}
-
-void vfio_pci_dma_map(struct vfio_pci_device *device,
-		      struct dma_region *region)
-{
-	if (device->iommu->iommufd)
-		iommufd_dma_map(device, region);
-	else
-		vfio_iommu_dma_map(device, region);
-
-	list_add(&region->link, &device->iommu->dma_regions);
-}
-
-static void vfio_iommu_dma_unmap(struct vfio_pci_device *device,
-				 struct dma_region *region)
-{
-	struct vfio_iommu_type1_dma_unmap args = {
-		.argsz = sizeof(args),
-		.iova = region->iova,
-		.size = region->size,
-	};
-
-	ioctl_assert(device->iommu->container_fd, VFIO_IOMMU_UNMAP_DMA, &args);
-}
-
-static void iommufd_dma_unmap(struct vfio_pci_device *device,
-			      struct dma_region *region)
-{
-	struct iommu_ioas_unmap args = {
-		.size = sizeof(args),
-		.iova = region->iova,
-		.length = region->size,
-		.ioas_id = device->iommu->ioas_id,
-	};
-
-	ioctl_assert(device->iommu->iommufd, IOMMU_IOAS_UNMAP, &args);
-}
-
-void vfio_pci_dma_unmap(struct vfio_pci_device *device,
-			struct dma_region *region)
-{
-	if (device->iommu->iommufd)
-		iommufd_dma_unmap(device, region);
-	else
-		vfio_iommu_dma_unmap(device, region);
-
-	list_del(&region->link);
-}
-
 static void vfio_pci_region_get(struct vfio_pci_device *device, int index,
 				struct vfio_region_info *info)
 {
@@ -408,52 +297,6 @@ const char *vfio_pci_get_cdev_path(const char *bdf)
 	return cdev_path;
 }
 
-/* Reminder: Keep in sync with FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES(). */
-static const struct iommu_mode iommu_modes[] = {
-	{
-		.name = "vfio_type1_iommu",
-		.container_path = "/dev/vfio/vfio",
-		.iommu_type = VFIO_TYPE1_IOMMU,
-	},
-	{
-		.name = "vfio_type1v2_iommu",
-		.container_path = "/dev/vfio/vfio",
-		.iommu_type = VFIO_TYPE1v2_IOMMU,
-	},
-	{
-		.name = "iommufd_compat_type1",
-		.container_path = "/dev/iommu",
-		.iommu_type = VFIO_TYPE1_IOMMU,
-	},
-	{
-		.name = "iommufd_compat_type1v2",
-		.container_path = "/dev/iommu",
-		.iommu_type = VFIO_TYPE1v2_IOMMU,
-	},
-	{
-		.name = "iommufd",
-	},
-};
-
-const char *default_iommu_mode = "iommufd";
-
-static const struct iommu_mode *lookup_iommu_mode(const char *iommu_mode)
-{
-	int i;
-
-	if (!iommu_mode)
-		iommu_mode = default_iommu_mode;
-
-	for (i = 0; i < ARRAY_SIZE(iommu_modes); i++) {
-		if (strcmp(iommu_mode, iommu_modes[i].name))
-			continue;
-
-		return &iommu_modes[i];
-	}
-
-	VFIO_FAIL("Unrecognized IOMMU mode: %s\n", iommu_mode);
-}
-
 static void vfio_device_bind_iommufd(int device_fd, int iommufd)
 {
 	struct vfio_device_bind_iommufd args = {
@@ -464,16 +307,6 @@ static void vfio_device_bind_iommufd(int device_fd, int iommufd)
 	ioctl_assert(device_fd, VFIO_DEVICE_BIND_IOMMUFD, &args);
 }
 
-static u32 iommufd_ioas_alloc(int iommufd)
-{
-	struct iommu_ioas_alloc args = {
-		.size = sizeof(args),
-	};
-
-	ioctl_assert(iommufd, IOMMU_IOAS_ALLOC, &args);
-	return args.out_ioas_id;
-}
-
 static void vfio_device_attach_iommufd_pt(int device_fd, u32 pt_id)
 {
 	struct vfio_device_attach_iommufd_pt args = {
@@ -496,41 +329,6 @@ static void vfio_pci_iommufd_setup(struct vfio_pci_device *device, const char *b
 	vfio_device_attach_iommufd_pt(device->fd, device->iommu->ioas_id);
 }
 
-struct iommu *iommu_init(const char *iommu_mode)
-{
-	const char *container_path;
-	struct iommu *iommu;
-	int version;
-
-	iommu = calloc(1, sizeof(*iommu));
-	VFIO_ASSERT_NOT_NULL(iommu);
-
-	INIT_LIST_HEAD(&iommu->dma_regions);
-
-	iommu->mode = lookup_iommu_mode(iommu_mode);
-
-	container_path = iommu->mode->container_path;
-	if (container_path) {
-		iommu->container_fd = open(container_path, O_RDWR);
-		VFIO_ASSERT_GE(iommu->container_fd, 0, "open(%s) failed\n", container_path);
-
-		version = ioctl(iommu->container_fd, VFIO_GET_API_VERSION);
-		VFIO_ASSERT_EQ(version, VFIO_API_VERSION, "Unsupported version: %d\n", version);
-	} else {
-		/*
-		 * Require device->iommufd to be >0 so that a simple non-0 check can be
-		 * used to check if iommufd is enabled. In practice open() will never
-		 * return 0 unless stdin is closed.
-		 */
-		iommu->iommufd = open("/dev/iommu", O_RDWR);
-		VFIO_ASSERT_GT(iommu->iommufd, 0);
-
-		iommu->ioas_id = iommufd_ioas_alloc(iommu->iommufd);
-	}
-
-	return iommu;
-}
-
 struct vfio_pci_device *__vfio_pci_device_init(const char *bdf, struct iommu *iommu)
 {
 	struct vfio_pci_device *device;
@@ -583,16 +381,6 @@ void __vfio_pci_device_cleanup(struct vfio_pci_device *device)
 	free(device);
 }
 
-void iommu_cleanup(struct iommu *iommu)
-{
-	if (iommu->iommufd)
-		VFIO_ASSERT_EQ(close(iommu->iommufd), 0);
-	else
-		VFIO_ASSERT_EQ(close(iommu->container_fd), 0);
-
-	free(iommu);
-}
-
 void vfio_pci_device_cleanup(struct vfio_pci_device *device)
 {
 	struct iommu *iommu = device->iommu;
-- 
2.51.0.710.ga91ca5db03-goog


