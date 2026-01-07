Return-Path: <kvm+bounces-67266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 75FD9CFFF63
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 21:18:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6F0E93004EC5
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 20:18:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 464C133A6E0;
	Wed,  7 Jan 2026 20:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aIoRH2Wj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED1332938C
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 20:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817090; cv=none; b=PctVcIVO3g2Zc4lkQ8+GDLjqVKmHyBwf3IwjjZ7pXRXXtYtNPx6HPSJua2mTQKthmvYrNkTzoy1AMF3upRvoS5IefzKr+P3JdhCnNgAEcW8nPE4dW59DLAnR4KT1u9kXmT+MStoFfcmswTuI+MH/S/l8Hw5WFh+ut6pd0xQ8NlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817090; c=relaxed/simple;
	bh=4Pd02XCOO1b0RU5MmE2Uwo/GFJB5CoMMUmyDrSB5Hn0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SH8RrsKm9E8EuTCDzM8tdvclTFfDYOkMk8KaxVKGqWoQGweREEG2a/erjrQ5R79Q/0E93MdrwaFb92Wpal6ty5fYqjcZcleR2anTImQm0AsWvoP3FierXR6eSQE/dBXjAwMZV+ynv/Q+5xrW7I/AFnY5Yf1Mze61jx0I6OcXh1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aIoRH2Wj; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a09845b7faso23943075ad.3
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 12:18:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767817088; x=1768421888; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YbIgDevabE4WtwYsX6fHSQEhrlUTqPdnsQVPiMzIU6I=;
        b=aIoRH2WjHIDGeXHNv5++w9KWHjf3ppnHYlnOJ9kv0WcX2PPirM8tAcwjmoxeNX/X7y
         NxwSWoM23sNLaisokd/iriHBrGQMxV2QXf6BDsliSafO55MmGoIPIXsrqStwVIUj4QNX
         lK+mwiYhzyEGKJmT6dANzzc8TT/yrtf0Kegi48hG2OZbLIgmgv2mgcfh9EhZtz4zeXXW
         LfCmHHAHtGeyhFNewT53TNAlaEozzOSZd78QvaeITS0dgSvQCcGh/R6YIKYmct39pFGO
         W7SENbrFD9iGt0eI5Q46biADU6vf1sH32LTxBXDuvLHzcuY/fIhcJI19xayR1fahJn1n
         TKRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817088; x=1768421888;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YbIgDevabE4WtwYsX6fHSQEhrlUTqPdnsQVPiMzIU6I=;
        b=v6K8m1orRfi5yelg6G/n/nCA2zzKi/Fp2j/mTG+t5EAO+81DMCmcvhigMd915uJQdX
         fAa2g5WIo1m74ERvbEyZoau5X0vjYXmwqh1nrXInwJ/OYcI297ydEpFM/PRQtPltQt5f
         cUp3QH2bNvHsGeutkEYzyjqJ4qgL/bFdIdSUZmXSmGWrCEW5Bf4twbGoW2ki6B88MvSP
         BzP9ls0Er/Wn8DMDggQERaK2QyGacTb2AkigVWIA9Yjr7O4Ypmd01KANvZHrzZSacLSa
         2aY/n6/ubit9jzXEq4TLGT7hr0HbKqF1BRHyEoq2ee4PP7b/oyIXgSKWBsC21UUKhCLD
         P+dw==
X-Forwarded-Encrypted: i=1; AJvYcCVHgCZwlkjLtvKLG8ZY0d8D+qL53QW5g5h9Xol8pDWKB09gvccTzmusuAgQnmVubkQFs1E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8qe4yxgWzN+F7guKMdnZR1m8A9K0Bu/9TY8RCWtf4tD6x6ys8
	x4A7lQkfky7i6o9pHljeoY05Hof6Wru018vLpW2ADSLGtjYfcDz6iAWygPiOFcM95nPSOY6EY0g
	wGvE6j946NcnT0A==
X-Google-Smtp-Source: AGHT+IE1DFCnmny/nHtC+I3vQMTODQGJxSrSd6kNwp+xLBMyWXqHQwoP9SAPWVjXbrVNZ0Jk6FS+jUxa+UC6xw==
X-Received: from plyw19.prod.google.com ([2002:a17:902:d713:b0:2a0:f83c:bb4b])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e391:b0:2a0:9d0f:b1ed with SMTP id d9443c01a7336-2a3ee45b3b5mr21123465ad.24.1767817088271;
 Wed, 07 Jan 2026 12:18:08 -0800 (PST)
Date: Wed,  7 Jan 2026 20:18:00 +0000
In-Reply-To: <20260107201800.2486137-1-skhawaja@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260107201800.2486137-1-skhawaja@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260107201800.2486137-4-skhawaja@google.com>
Subject: [PATCH 3/3] vfio: selftests: Add iommufd hwpt replace test
From: Samiullah Khawaja <skhawaja@google.com>
To: David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	David Matlack <dmatlack@google.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, Robin Murphy <robin.murphy@arm.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Kevin Tian <kevin.tian@intel.com>, 
	Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Saeed Mahameed <saeedm@nvidia.com>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Parav Pandit <parav@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>, William Tu <witu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

Add a test that does iommufd hwpt replace while a DMA is ongoing. This
verifies the hitless replace of IOMMU domain without disrupting the DMA.

Note that the new domain is attached after mapping the required DMA
memory at the same IOVA in the new domain.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 tools/testing/selftests/vfio/Makefile         |   1 +
 .../vfio/vfio_iommufd_hwpt_replace_test.c     | 151 ++++++++++++++++++
 2 files changed, 152 insertions(+)
 create mode 100644 tools/testing/selftests/vfio/vfio_iommufd_hwpt_replace_test.c

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index 3c796ca99a50..09a1e57cc77d 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -1,5 +1,6 @@
 CFLAGS = $(KHDR_INCLUDES)
 TEST_GEN_PROGS += vfio_dma_mapping_test
+TEST_GEN_PROGS += vfio_iommufd_hwpt_replace_test
 TEST_GEN_PROGS += vfio_iommufd_setup_test
 TEST_GEN_PROGS += vfio_pci_device_test
 TEST_GEN_PROGS += vfio_pci_device_init_perf_test
diff --git a/tools/testing/selftests/vfio/vfio_iommufd_hwpt_replace_test.c b/tools/testing/selftests/vfio/vfio_iommufd_hwpt_replace_test.c
new file mode 100644
index 000000000000..efef3233494f
--- /dev/null
+++ b/tools/testing/selftests/vfio/vfio_iommufd_hwpt_replace_test.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+
+#include <linux/sizes.h>
+#include <linux/vfio.h>
+
+#include <libvfio.h>
+
+#include "kselftest_harness.h"
+
+static const char *device_bdf;
+
+static void region_setup(struct iommu *iommu,
+			 struct iova_allocator *iova_allocator,
+			 struct dma_region *region, u64 size)
+{
+	const int flags = MAP_SHARED | MAP_ANONYMOUS;
+	const int prot = PROT_READ | PROT_WRITE;
+	void *vaddr;
+
+	vaddr = mmap(NULL, size, prot, flags, -1, 0);
+	VFIO_ASSERT_NE(vaddr, MAP_FAILED);
+
+	region->vaddr = vaddr;
+	region->iova = iova_allocator_alloc(iova_allocator, size);
+	region->size = size;
+
+	iommu_map(iommu, region);
+}
+
+static void region_teardown(struct iommu *iommu, struct dma_region *region)
+{
+	iommu_unmap(iommu, region);
+	VFIO_ASSERT_EQ(munmap(region->vaddr, region->size), 0);
+}
+
+FIXTURE(vfio_iommufd_replace_hwpt_test) {
+	struct iommu *iommu;
+	struct vfio_pci_device *device;
+	struct iova_allocator *iova_allocator;
+	struct dma_region memcpy_region;
+	void *vaddr;
+
+	u64 size;
+	void *src;
+	void *dst;
+	iova_t src_iova;
+	iova_t dst_iova;
+};
+
+FIXTURE_SETUP(vfio_iommufd_replace_hwpt_test)
+{
+	struct vfio_pci_driver *driver;
+
+	self->iommu = iommu_init("iommufd");
+	self->device = vfio_pci_device_init(device_bdf, self->iommu);
+	self->iova_allocator = iova_allocator_init(self->iommu);
+
+	driver = &self->device->driver;
+
+	region_setup(self->iommu, self->iova_allocator, &self->memcpy_region, SZ_1G);
+	region_setup(self->iommu, self->iova_allocator, &driver->region, SZ_2M);
+
+	if (driver->ops)
+		vfio_pci_driver_init(self->device);
+
+	self->size = self->memcpy_region.size / 2;
+	self->src = self->memcpy_region.vaddr;
+	self->dst = self->src + self->size;
+
+	self->src_iova = to_iova(self->device, self->src);
+	self->dst_iova = to_iova(self->device, self->dst);
+}
+
+FIXTURE_TEARDOWN(vfio_iommufd_replace_hwpt_test)
+{
+	struct vfio_pci_driver *driver = &self->device->driver;
+
+	if (driver->ops)
+		vfio_pci_driver_remove(self->device);
+
+	region_teardown(self->iommu, &self->memcpy_region);
+	region_teardown(self->iommu, &driver->region);
+
+	iova_allocator_cleanup(self->iova_allocator);
+	vfio_pci_device_cleanup(self->device);
+	iommu_cleanup(self->iommu);
+}
+
+FIXTURE_VARIANT(vfio_iommufd_replace_hwpt_test) {
+	bool replace_hwpt;
+};
+
+FIXTURE_VARIANT_ADD(vfio_iommufd_replace_hwpt_test, domain_replace) {
+	.replace_hwpt = true,
+};
+
+FIXTURE_VARIANT_ADD(vfio_iommufd_replace_hwpt_test, noreplace) {
+	.replace_hwpt = false,
+};
+
+TEST_F(vfio_iommufd_replace_hwpt_test, memcpy)
+{
+	struct dma_region memcpy_region, driver_region;
+	struct iommu *iommu2;
+
+	if (self->device->driver.ops) {
+		memset(self->src, 'x', self->size);
+		memset(self->dst, 'y', self->size);
+
+		vfio_pci_driver_memcpy_start(self->device,
+					     self->src_iova,
+					     self->dst_iova,
+					     self->size,
+					     100);
+	}
+
+	if (variant->replace_hwpt) {
+		iommu2 = iommufd_iommu_init(self->iommu->iommufd,
+					    self->device->dev_id);
+
+		memcpy_region = self->memcpy_region;
+		driver_region = self->device->driver.region;
+
+		iommu_map(iommu2, &memcpy_region);
+		iommu_map(iommu2, &driver_region);
+
+		vfio_pci_device_attach_iommu(self->device, iommu2);
+	}
+
+	if (self->device->driver.ops) {
+		ASSERT_EQ(0, vfio_pci_driver_memcpy_wait(self->device));
+		ASSERT_EQ(0, memcmp(self->src, self->dst, self->size));
+	}
+
+	if (variant->replace_hwpt) {
+		vfio_pci_device_attach_iommu(self->device, self->iommu);
+
+		iommu_unmap(iommu2, &memcpy_region);
+		iommu_unmap(iommu2, &driver_region);
+		iommu_cleanup(iommu2);
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	device_bdf = vfio_selftests_get_bdf(&argc, argv);
+
+	return test_harness_run(argc, argv);
+}
-- 
2.52.0.351.gbe84eed79e-goog


