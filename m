Return-Path: <kvm+bounces-55542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CDE58B3245E
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 23:29:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BCB11D63E1D
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 21:29:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6677434DCDF;
	Fri, 22 Aug 2025 21:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zc1Mlpct"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF52934A338
	for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 21:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755897988; cv=none; b=Hy2SeBF6dJrn5rPj+H0fwfT/ftL2xHqWDIYFFUXr+rbgy1uiiTTSkOIOzKM4/YDZFtltM2pEOxu8hw3byu2tzt5mYUXn1MjvvFPVdWAY1I7YQ+HCDlC+lmLYMwCA8kBRiesFdLFVFqzbpMrDRKKkOYWVHk+pdUNqBxLs2qaJKqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755897988; c=relaxed/simple;
	bh=/6mrO0l8vd9nplF0DJMuWoy7/PKZqHEBZboOT8qQ/W8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Dv1+XJffq3KHWZB63XQCgqaMVIjFJ13CAfCssP9e03ihIBYmtTSZEPmTzOrVOaJpP/0KuZV3+VXYgRSJvG8J0lakqD60Jh4zySrwwr2RnW3+9lNw2ziSjumVew2OfOairQHeY61m0FoGPi+iip1JvxWVnJjPHyj3CUqEDkKXObY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zc1Mlpct; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3251d634cdbso1165398a91.1
        for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 14:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755897986; x=1756502786; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eKVJ3VP6K6vVA1aB4Do/8o3kjp9P0Sl9e4i23cq3YNA=;
        b=zc1Mlpct1VVR9u71696T0hyPv7pTcwYke65BxExasCf65IIRWCpj8l6VWCOJv0DFxK
         FBMz1CPe0mUjls5PMAwPOgimYPBSl4NcRVF5k907//EhLq6kknEh9IzVEJ20cCqU6d1D
         6LdXCC+FfjP64vntpmldsAF6o/eCwqBGlf6lc72Sx7YPl3jY7RXayE5Uv3hEgVx0CEjx
         LV72oOIWq9Byn1PYP3Yg+BrWiyDN7vtz5KX8VGPc+fsZcR3O+iUlRBfSQD4KPfFaNKfb
         1PoOdCmWWoWi+vB9NglGYBGMT+ry5xU1MKYEenZZTg9PlVBpYAhbQj525annfwCe5A/l
         O0tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755897986; x=1756502786;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eKVJ3VP6K6vVA1aB4Do/8o3kjp9P0Sl9e4i23cq3YNA=;
        b=hV3aVumFlV+MrKNjW9jx3Kl9ul3B/91iqtvDNZBiy/83zn9l8o6Wnmmecrn6BKe23E
         NixWRKCcSaccyXudJNaYHbH4Ut8t3T51i29NRCzCYXCUWpEwaBDwhdVpan6sp7SDtYKt
         n2qqt3m74tbZJ654vtxhUXOClqGDDss5JZ14r3x0HDa64YJ5QRwdUNRA0VKSwaXJ0Zy5
         4ultmfiQIun2+Q3oF6J9914uYrF9MxB8/Up8I0yLov578PpCdufr3sZjw0WOwi12qEa6
         dgQbnQB2K8jA8nXwSeGU9tYzLKqm7tScT0f7lxeztyFy9Ym0bqo5cBwKSBgmO/5eSJgo
         sX9g==
X-Forwarded-Encrypted: i=1; AJvYcCXLzCiqRvOS8k6XsAWJZcW1ADxqigox7CjlNIn8iDd2ACyHSnfqqmmppeYfN7Sm0zk43kA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9jrohhzW2V/kY6Ic5WNuEc+P9xHL4mz6x/Y47SEBe54vNy/9l
	+3wbRG65JtBAt7goW7v33GKrAZJKu22jI/QJD9k/vzndxvLcagCzzbXqRxO/FjVBDaZq7ptvnxP
	jKQBkCgkyYmOrGQ==
X-Google-Smtp-Source: AGHT+IGIcX5zikRz2HAW6MqTLJi0XDnCUP6bmUL30f38SCCOQrBmoAKQAMde5kkreILF/jf/l//8FHpW5+0/PQ==
X-Received: from pjl3.prod.google.com ([2002:a17:90b:2f83:b0:31c:4a51:8b75])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5543:b0:31e:c1fb:dbc6 with SMTP id 98e67ed59e1d1-32515eaee89mr5118379a91.22.1755897986161;
 Fri, 22 Aug 2025 14:26:26 -0700 (PDT)
Date: Fri, 22 Aug 2025 21:24:59 +0000
In-Reply-To: <20250822212518.4156428-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250822212518.4156428-1-dmatlack@google.com>
X-Mailer: git-send-email 2.51.0.rc2.233.g662b1ed5c5-goog
Message-ID: <20250822212518.4156428-13-dmatlack@google.com>
Subject: [PATCH v2 12/30] vfio: selftests: Add driver framework
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Aaron Lewis <aaronlewis@google.com>, 
	Adhemerval Zanella <adhemerval.zanella@linaro.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, 
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	David Matlack <dmatlack@google.com>, dmaengine@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Joel Granados <joel.granados@kernel.org>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Vinicius Costa Gomes <vinicius.gomes@intel.com>, Vipin Sharma <vipinsh@google.com>, 
	"Yury Norov [NVIDIA]" <yury.norov@gmail.com>, Shuah Khan <skhan@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"

Add a driver framework to VFIO selftests, so that devices can generate
DMA and interrupts in a common way that can be then utilized by tests.
This will enable VFIO selftests to exercise real hardware DMA and
interrupt paths, without needing any device-specific code in the test
itself.

Subsequent commits will introduce drivers for specific devices.

Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/vfio/lib/include/vfio_util.h    |  92 ++++++++++++++
 tools/testing/selftests/vfio/lib/libvfio.mk   |   1 +
 .../selftests/vfio/lib/vfio_pci_device.c      |   5 +
 .../selftests/vfio/lib/vfio_pci_driver.c      | 116 ++++++++++++++++++
 4 files changed, 214 insertions(+)
 create mode 100644 tools/testing/selftests/vfio/lib/vfio_pci_driver.c

diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools/testing/selftests/vfio/lib/include/vfio_util.h
index a51c971004cd..a7d05a4299a1 100644
--- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
+++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
@@ -63,6 +63,85 @@ struct vfio_dma_region {
 	u64 size;
 };
 
+struct vfio_pci_device;
+
+struct vfio_pci_driver_ops {
+	const char *name;
+
+	/**
+	 * @probe() - Check if the driver supports the given device.
+	 *
+	 * Return: 0 on success, non-0 on failure.
+	 */
+	int (*probe)(struct vfio_pci_device *device);
+
+	/**
+	 * @init() - Initialize the driver for @device.
+	 *
+	 * Must be called after device->driver.region has been initialized.
+	 */
+	void (*init)(struct vfio_pci_device *device);
+
+	/**
+	 * remove() - Deinitialize the driver for @device.
+	 */
+	void (*remove)(struct vfio_pci_device *device);
+
+	/**
+	 * memcpy_start() - Kick off @count repeated memcpy operations from
+	 * [@src, @src + @size) to [@dst, @dst + @size).
+	 *
+	 * Guarantees:
+	 *  - The device will attempt DMA reads on [src, src + size).
+	 *  - The device will attempt DMA writes on [dst, dst + size).
+	 *  - The device will not generate any interrupts.
+	 *
+	 * memcpy_start() returns immediately, it does not wait for the
+	 * copies to complete.
+	 */
+	void (*memcpy_start)(struct vfio_pci_device *device,
+			     iova_t src, iova_t dst, u64 size, u64 count);
+
+	/**
+	 * memcpy_wait() - Wait until the memcpy operations started by
+	 * memcpy_start() have finished.
+	 *
+	 * Guarantees:
+	 *  - All in-flight DMAs initiated by memcpy_start() are fully complete
+	 *    before memcpy_wait() returns.
+	 *
+	 * Returns non-0 if the driver detects that an error occurred during the
+	 * memcpy, 0 otherwise.
+	 */
+	int (*memcpy_wait)(struct vfio_pci_device *device);
+
+	/**
+	 * send_msi() - Make the device send the MSI device->driver.msi.
+	 *
+	 * Guarantees:
+	 *  - The device will send the MSI once.
+	 */
+	void (*send_msi)(struct vfio_pci_device *device);
+};
+
+struct vfio_pci_driver {
+	const struct vfio_pci_driver_ops *ops;
+	bool initialized;
+	bool memcpy_in_progress;
+
+	/* Region to be used by the driver (e.g. for in-memory descriptors) */
+	struct vfio_dma_region region;
+
+	/* The maximum size that can be passed to memcpy_start(). */
+	u64 max_memcpy_size;
+
+	/* The maximum count that can be passed to memcpy_start(). */
+	u64 max_memcpy_count;
+
+	/* The MSI vector the device will signal in ops->send_msi(). */
+	int msi;
+};
+
 struct vfio_pci_device {
 	int fd;
 	int group_fd;
@@ -79,6 +158,8 @@ struct vfio_pci_device {
 
 	/* eventfds for MSI and MSI-x interrupts */
 	int msi_eventfds[PCI_MSIX_FLAGS_QSIZE + 1];
+
+	struct vfio_pci_driver driver;
 };
 
 /*
@@ -174,4 +255,15 @@ static inline bool vfio_pci_device_match(struct vfio_pci_device *device,
 		(device_id == vfio_pci_config_readw(device, PCI_DEVICE_ID));
 }
 
+void vfio_pci_driver_probe(struct vfio_pci_device *device);
+void vfio_pci_driver_init(struct vfio_pci_device *device);
+void vfio_pci_driver_remove(struct vfio_pci_device *device);
+int vfio_pci_driver_memcpy(struct vfio_pci_device *device,
+			   iova_t src, iova_t dst, u64 size);
+void vfio_pci_driver_memcpy_start(struct vfio_pci_device *device,
+				  iova_t src, iova_t dst, u64 size,
+				  u64 count);
+int vfio_pci_driver_memcpy_wait(struct vfio_pci_device *device);
+void vfio_pci_driver_send_msi(struct vfio_pci_device *device);
+
 #endif /* SELFTESTS_VFIO_LIB_INCLUDE_VFIO_UTIL_H */
diff --git a/tools/testing/selftests/vfio/lib/libvfio.mk b/tools/testing/selftests/vfio/lib/libvfio.mk
index 72e55a560eeb..a3c3bc9a7c00 100644
--- a/tools/testing/selftests/vfio/lib/libvfio.mk
+++ b/tools/testing/selftests/vfio/lib/libvfio.mk
@@ -1,6 +1,7 @@
 VFIO_DIR := $(selfdir)/vfio
 
 LIBVFIO_C := lib/vfio_pci_device.c
+LIBVFIO_C += lib/vfio_pci_driver.c
 
 LIBVFIO_O := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBVFIO_C))
 
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 36b4b30b75cf..d8bb227e869d 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -344,6 +344,8 @@ struct vfio_pci_device *vfio_pci_device_init(const char *bdf, int iommu_type)
 	vfio_pci_iommu_setup(device, iommu_type);
 	vfio_pci_device_setup(device, bdf);
 
+	vfio_pci_driver_probe(device);
+
 	return device;
 }
 
@@ -351,6 +353,9 @@ void vfio_pci_device_cleanup(struct vfio_pci_device *device)
 {
 	int i;
 
+	if (device->driver.initialized)
+		vfio_pci_driver_remove(device);
+
 	vfio_pci_bar_unmap_all(device);
 
 	VFIO_ASSERT_EQ(close(device->fd), 0);
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c b/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
new file mode 100644
index 000000000000..c98bd2d31d8a
--- /dev/null
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
@@ -0,0 +1,116 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <stdio.h>
+
+#include "../../../kselftest.h"
+#include <vfio_util.h>
+
+static struct vfio_pci_driver_ops *driver_ops[] = {};
+
+void vfio_pci_driver_probe(struct vfio_pci_device *device)
+{
+	struct vfio_pci_driver_ops *ops;
+	int i;
+
+	VFIO_ASSERT_NULL(device->driver.ops);
+
+	for (i = 0; i < ARRAY_SIZE(driver_ops); i++) {
+		ops = driver_ops[i];
+
+		if (ops->probe(device))
+			continue;
+
+		printf("Driver found: %s\n", ops->name);
+		device->driver.ops = ops;
+	}
+}
+
+static void vfio_check_driver_op(struct vfio_pci_driver *driver, void *op,
+				 const char *op_name)
+{
+	VFIO_ASSERT_NOT_NULL(driver->ops);
+	VFIO_ASSERT_NOT_NULL(op, "Driver has no %s()\n", op_name);
+	VFIO_ASSERT_EQ(driver->initialized, op != driver->ops->init);
+	VFIO_ASSERT_EQ(driver->memcpy_in_progress, op == driver->ops->memcpy_wait);
+}
+
+#define VFIO_CHECK_DRIVER_OP(_driver, _op) do {				\
+	struct vfio_pci_driver *__driver = (_driver);			\
+	vfio_check_driver_op(__driver, __driver->ops->_op, #_op);	\
+} while (0)
+
+void vfio_pci_driver_init(struct vfio_pci_device *device)
+{
+	struct vfio_pci_driver *driver = &device->driver;
+
+	VFIO_ASSERT_NOT_NULL(driver->region.vaddr);
+	VFIO_CHECK_DRIVER_OP(driver, init);
+
+	driver->ops->init(device);
+
+	driver->initialized = true;
+
+	printf("%s: region: vaddr %p, iova 0x%lx, size 0x%lx\n",
+	       driver->ops->name,
+	       driver->region.vaddr,
+	       driver->region.iova,
+	       driver->region.size);
+
+	printf("%s: max_memcpy_size 0x%lx, max_memcpy_count 0x%lx\n",
+	       driver->ops->name,
+	       driver->max_memcpy_size,
+	       driver->max_memcpy_count);
+}
+
+void vfio_pci_driver_remove(struct vfio_pci_device *device)
+{
+	struct vfio_pci_driver *driver = &device->driver;
+
+	VFIO_CHECK_DRIVER_OP(driver, remove);
+
+	driver->ops->remove(device);
+	driver->initialized = false;
+}
+
+void vfio_pci_driver_send_msi(struct vfio_pci_device *device)
+{
+	struct vfio_pci_driver *driver = &device->driver;
+
+	VFIO_CHECK_DRIVER_OP(driver, send_msi);
+
+	driver->ops->send_msi(device);
+}
+
+void vfio_pci_driver_memcpy_start(struct vfio_pci_device *device,
+				  iova_t src, iova_t dst, u64 size,
+				  u64 count)
+{
+	struct vfio_pci_driver *driver = &device->driver;
+
+	VFIO_ASSERT_LE(size, driver->max_memcpy_size);
+	VFIO_ASSERT_LE(count, driver->max_memcpy_count);
+	VFIO_CHECK_DRIVER_OP(driver, memcpy_start);
+
+	driver->ops->memcpy_start(device, src, dst, size, count);
+	driver->memcpy_in_progress = true;
+}
+
+int vfio_pci_driver_memcpy_wait(struct vfio_pci_device *device)
+{
+	struct vfio_pci_driver *driver = &device->driver;
+	int r;
+
+	VFIO_CHECK_DRIVER_OP(driver, memcpy_wait);
+
+	r = driver->ops->memcpy_wait(device);
+	driver->memcpy_in_progress = false;
+
+	return r;
+}
+
+int vfio_pci_driver_memcpy(struct vfio_pci_device *device,
+			   iova_t src, iova_t dst, u64 size)
+{
+	vfio_pci_driver_memcpy_start(device, src, dst, size, 1);
+
+	return vfio_pci_driver_memcpy_wait(device);
+}
-- 
2.51.0.rc2.233.g662b1ed5c5-goog


