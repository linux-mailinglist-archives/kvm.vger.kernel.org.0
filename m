Return-Path: <kvm+bounces-66625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 59DC5CDACA1
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 00:01:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7EEBD30456BB
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 23:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5071E27380A;
	Tue, 23 Dec 2025 23:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W0P/IthI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD622E62D9
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 23:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766530864; cv=none; b=HLOJrX+H6WtILfipqUTFPNy3qJc7DM9VVsyvTrEd7CQ6bnkH5PDcWVj2ULwTcNrfHQjPxabm8Cc4oOfnJ64YettCq9Dh4V9Ky1ZbqMF8mES/MRaDvTGsvNJyABEX4+ieOm23zavXLYghhRJEI1TM45bI0sDnqc9tW7U3iyplsEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766530864; c=relaxed/simple;
	bh=/36vnhEQRSZK//3+V3VFig2s2AZAKDQe65ME5A4VaQg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O1Rib/hPb+ZajpR9Pc+Cm1WJczftfirfadcxSqlYqWX0XV/4M/BCT15qkaiO5Sa1XDwLCDi3Y0s7YjXeJl3exzTuKR1MZPmDxe/iqAl/K3OLRpQayjNX+hPiS3P7BQ8mcRcL1bXTZ4qC9KPmDOUFvNCLSmJNp6hue1gYySbVZ9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W0P/IthI; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-ba4c6ac8406so4418395a12.0
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 15:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766530862; x=1767135662; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bv3s2RDHQ4OszlXNEdG1Pt4RQgFWzpLzAv9r2lb2HV0=;
        b=W0P/IthI4xLXvpe1m3wtOQGvRn4qXwesueWw2rkJUABE79Ccfbsrzx+yYETCYv/k94
         jj6QLKbx07CCG7J2OZO3zMdVkiyxXGbqQG5eHhkXm1aWjFnsUxKdbkKedl392wpCvzgq
         SYUUDjRjCyOqVfbNGE4rbMMBVcFXV7k7bOAvzm5MaDABoGWorQhXdeG1AoxsBHzysmza
         54a/YU+P1vua5W9Y3GASSD6F2r/MqPXNmSGaDdudko4LQwDjlXHrM+LDQDsXxHhr8x/t
         mCAr5meB2JAq38Ptf53rhKE6HjeLQoavXxwcOIz+CqbxXjpN14QbjjEnX/1+PofufKWH
         iNew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766530862; x=1767135662;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bv3s2RDHQ4OszlXNEdG1Pt4RQgFWzpLzAv9r2lb2HV0=;
        b=k+I+r3MOT5jXG+JzT2zR0iduoGJ7yooQ2iGAwMTEvUtd9yi0mkF6maCRycMXjookLX
         MjV2I2aAQBnhtO/yuQEcIyzPXC2jJVbfo36swxfnvk+fZeIPcLZCwYSmRvx5d1xwNQmV
         HEIfVGhUE4yMcjZ7vPmxhI9UZxJUdXHNl7FBo2+UnbSHUyDPNHJmgcE/AKx6MbU+NswZ
         09bd3oYOdA1G35tneHOEm6g15ExrebTQNvDfJnOIT8bjNAANwrAa7GWK6CT4LO1eZBOG
         UyOZblwGzZqztHm79MI0nq6eUI+2Rdvn6o52H6kvnfeh5rTBrOTv97bPwPEGEnY/kcgN
         D7pg==
X-Gm-Message-State: AOJu0YxDnJ8saqrFBVOLwSiMNbNNHhOZcAP6JLkE5HQyEOcs/ck7EXWw
	9aB9d2QKmTrH3SQ4AOg0+nZRoGuQQKxwtQpqVPui6M1Bx6zuiLFxgBXy8BY2RX3dPqBvfLaiqs+
	Mh5fTTm1GcQRCGytfUFv62w==
X-Google-Smtp-Source: AGHT+IFm270QgbuKvBYXeGkbDYksU3QTFPj/bf0AbeaSaQCJSRwnSGRC5TVOqCVqcueW1P/BJyk9lOsAQPtlmohv
X-Received: from dlbrl11.prod.google.com ([2002:a05:7022:f50b:b0:120:56f0:7b38])
 (user=aaronlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:170c:b0:11e:3e9:3ea0 with SMTP id a92af1059eb24-12172305ba1mr13010464c88.49.1766530861826;
 Tue, 23 Dec 2025 15:01:01 -0800 (PST)
Date: Tue, 23 Dec 2025 23:00:44 +0000
In-Reply-To: <20251223230044.2617028-1-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251223230044.2617028-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251223230044.2617028-3-aaronlewis@google.com>
Subject: [RFC PATCH 2/2] vfio: selftest: Add vfio_dma_mapping_perf_test
From: Aaron Lewis <aaronlewis@google.com>
To: alex.williamson@redhat.com, jgg@nvidia.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, seanjc@google.com, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a selftest to help investigate latencies when mapping pages in vfio.

To disabiguate the prefetch time from the pinning time the mmap() flag
MAP_POPULATE is used.  With prefetching done in mmap() that exposes
pinning latencies when mapping gigantic pages.

For this test 8G of memory is pinned to keep the test responsive. Pinning
more memory could result in the test timing out, e.g. if it pinned 256G.
The majority of that time is spent prefetching the memory in mmap().

This test has 4 main phases: mmap(), iova_alloc(), iommu_map(), and
iommu_unmap().  Each of these stages are timed and reported in
milliseconds.

This test doesn't set targets for any of its phases as targets are error
prone and lead to flaky tests.  Therefore, instead of having targets
this test simply reports how long each phase took.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/vfio/Makefile         |   1 +
 .../vfio/vfio_dma_mapping_perf_test.c         | 247 ++++++++++++++++++
 2 files changed, 248 insertions(+)
 create mode 100644 tools/testing/selftests/vfio/vfio_dma_mapping_perf_test.c

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index 3c796ca99a509..134ce40b81790 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -1,5 +1,6 @@
 CFLAGS = $(KHDR_INCLUDES)
 TEST_GEN_PROGS += vfio_dma_mapping_test
+TEST_GEN_PROGS += vfio_dma_mapping_perf_test
 TEST_GEN_PROGS += vfio_iommufd_setup_test
 TEST_GEN_PROGS += vfio_pci_device_test
 TEST_GEN_PROGS += vfio_pci_device_init_perf_test
diff --git a/tools/testing/selftests/vfio/vfio_dma_mapping_perf_test.c b/tools/testing/selftests/vfio/vfio_dma_mapping_perf_test.c
new file mode 100644
index 0000000000000..c70f6935e0291
--- /dev/null
+++ b/tools/testing/selftests/vfio/vfio_dma_mapping_perf_test.c
@@ -0,0 +1,247 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <stdio.h>
+#include <sys/mman.h>
+#include <time.h>
+#include <unistd.h>
+
+#include <uapi/linux/types.h>
+#include <linux/iommufd.h>
+#include <linux/limits.h>
+#include <linux/mman.h>
+#include <linux/sizes.h>
+#include <linux/time64.h>
+#include <linux/vfio.h>
+
+#include <libvfio.h>
+
+#include "../kselftest_harness.h"
+
+static const char *device_bdf;
+
+struct iommu_mapping {
+	u64 pgd;
+	u64 p4d;
+	u64 pud;
+	u64 pmd;
+	u64 pte;
+};
+
+static s64 to_ns(struct timespec ts)
+{
+	return (s64)ts.tv_nsec + NSEC_PER_SEC * (s64)ts.tv_sec;
+}
+
+static double to_ms(struct timespec ts)
+{
+	return to_ns(ts) / 1000.0 / 1000.0;
+}
+
+static struct timespec to_timespec(s64 ns)
+{
+	struct timespec ts = {
+		.tv_nsec = ns % NSEC_PER_SEC,
+		.tv_sec = ns / NSEC_PER_SEC,
+	};
+
+	return ts;
+}
+
+static struct timespec timespec_sub(struct timespec a, struct timespec b)
+{
+	return to_timespec(to_ns(a) - to_ns(b));
+}
+
+static double timespec_elapsed_ms(struct timespec start)
+{
+	struct timespec end;
+
+	clock_gettime(CLOCK_MONOTONIC, &end);
+	return to_ms(timespec_sub(end, start));
+}
+
+
+static void parse_next_value(char **line, u64 *value)
+{
+	char *token;
+
+	token = strtok_r(*line, " \t|\n", line);
+	if (!token)
+		return;
+
+	/* Caller verifies `value`. No need to check return value. */
+	sscanf(token, "0x%lx", value);
+}
+
+static int intel_iommu_mapping_get(const char *bdf, u64 iova,
+				   struct iommu_mapping *mapping)
+{
+	char iommu_mapping_path[PATH_MAX], line[PATH_MAX];
+	u64 line_iova = -1;
+	int ret = -ENOENT;
+	FILE *file;
+	char *rest;
+
+	snprintf(iommu_mapping_path, sizeof(iommu_mapping_path),
+		 "/sys/kernel/debug/iommu/intel/%s/domain_translation_struct",
+		 bdf);
+
+	file = fopen(iommu_mapping_path, "r");
+	VFIO_ASSERT_NOT_NULL(file, "fopen(%s) failed", iommu_mapping_path);
+
+	while (fgets(line, sizeof(line), file)) {
+		rest = line;
+
+		parse_next_value(&rest, &line_iova);
+		if (line_iova != (iova / getpagesize()))
+			continue;
+
+		/*
+		 * Ensure each struct field is initialized in case of empty
+		 * page table values.
+		 */
+		memset(mapping, 0, sizeof(*mapping));
+		parse_next_value(&rest, &mapping->pgd);
+		parse_next_value(&rest, &mapping->p4d);
+		parse_next_value(&rest, &mapping->pud);
+		parse_next_value(&rest, &mapping->pmd);
+		parse_next_value(&rest, &mapping->pte);
+
+		ret = 0;
+		break;
+	}
+
+	fclose(file);
+
+	return ret;
+}
+
+static int iommu_mapping_get(const char *bdf, u64 iova,
+			     struct iommu_mapping *mapping)
+{
+	if (!access("/sys/kernel/debug/iommu/intel", F_OK))
+		return intel_iommu_mapping_get(bdf, iova, mapping);
+
+	return -EOPNOTSUPP;
+}
+
+FIXTURE(vfio_dma_mapping_perf_test) {
+	struct iommu *iommu;
+	struct vfio_pci_device *device;
+	struct iova_allocator *iova_allocator;
+};
+
+FIXTURE_VARIANT(vfio_dma_mapping_perf_test) {
+	const char *iommu_mode;
+	u64 size;
+	int mmap_flags;
+	const char *file;
+};
+
+#define FIXTURE_VARIANT_ADD_IOMMU_MODE(_iommu_mode, _name, _size, _mmap_flags) \
+FIXTURE_VARIANT_ADD(vfio_dma_mapping_perf_test, _iommu_mode ## _ ## _name) {   \
+	.iommu_mode = #_iommu_mode,					       \
+	.size = (_size),						       \
+	.mmap_flags = MAP_ANONYMOUS | MAP_PRIVATE |			       \
+		      MAP_POPULATE | (_mmap_flags), 			       \
+}
+
+FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES(anonymous_hugetlb_1gb, SZ_1G, MAP_HUGETLB | MAP_HUGE_1GB);
+
+#undef FIXTURE_VARIANT_ADD_IOMMU_MODE
+
+FIXTURE_SETUP(vfio_dma_mapping_perf_test)
+{
+	self->iommu = iommu_init(variant->iommu_mode);
+	self->device = vfio_pci_device_init(device_bdf, self->iommu);
+	self->iova_allocator = iova_allocator_init(self->iommu);
+}
+
+FIXTURE_TEARDOWN(vfio_dma_mapping_perf_test)
+{
+	iova_allocator_cleanup(self->iova_allocator);
+	vfio_pci_device_cleanup(self->device);
+	iommu_cleanup(self->iommu);
+}
+
+TEST_F(vfio_dma_mapping_perf_test, dma_map_unmap)
+{
+	u64 mapping_size = variant->size ?: getpagesize();
+	const u64 size = 8ULL * /*1GB=*/(1ULL << 30);
+	const int flags = variant->mmap_flags;
+	struct dma_region region;
+	struct iommu_mapping mapping;
+	struct timespec start;
+	u64 unmapped;
+	int rc;
+
+	clock_gettime(CLOCK_MONOTONIC, &start);
+	region.vaddr = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, -1, 0);
+	printf("Mmap duration = %.2lfms\n", timespec_elapsed_ms(start));
+
+	/* Skip the test if there aren't enough HugeTLB pages available. */
+	if (flags & MAP_HUGETLB && region.vaddr == MAP_FAILED)
+		SKIP(return, "mmap() failed: %s (%d)\n", strerror(errno), errno);
+	else
+		ASSERT_NE(region.vaddr, MAP_FAILED);
+
+	clock_gettime(CLOCK_MONOTONIC, &start);
+	region.iova = iova_allocator_alloc(self->iova_allocator, size);
+	region.size = size;
+	printf("IOVA alloc duration = %.2lfms\n", timespec_elapsed_ms(start));
+
+	clock_gettime(CLOCK_MONOTONIC, &start);
+	iommu_map(self->iommu, &region);
+	printf("DMA map duration = %.2lfms\n", timespec_elapsed_ms(start));
+
+	ASSERT_EQ(region.iova, to_iova(self->device, region.vaddr));
+
+	rc = iommu_mapping_get(device_bdf, region.iova, &mapping);
+	if (rc == -EOPNOTSUPP) {
+		goto unmap;
+	}
+
+
+	/*
+	 * IOMMUFD compatibility-mode does not support huge mappings when
+	 * using VFIO_TYPE1_IOMMU.
+	 */
+	if (!strcmp(variant->iommu_mode, "iommufd_compat_type1"))
+		mapping_size = SZ_4K;
+
+
+	ASSERT_EQ(0, rc);
+
+	switch (mapping_size) {
+	case SZ_4K:
+		ASSERT_NE(0, mapping.pte);
+		break;
+	case SZ_2M:
+		ASSERT_EQ(0, mapping.pte);
+		ASSERT_NE(0, mapping.pmd);
+		break;
+	case SZ_1G:
+		ASSERT_EQ(0, mapping.pte);
+		ASSERT_EQ(0, mapping.pmd);
+		ASSERT_NE(0, mapping.pud);
+		break;
+	default:
+		VFIO_FAIL("Unrecognized size: 0x%lx\n", mapping_size);
+	}
+
+unmap:
+	clock_gettime(CLOCK_MONOTONIC, &start);
+	rc = __iommu_unmap(self->iommu, &region, &unmapped);
+	printf("DMA unmap duration = %.2lfms\n", timespec_elapsed_ms(start));
+	ASSERT_EQ(rc, 0);
+	ASSERT_EQ(unmapped, region.size);
+	ASSERT_NE(0, __to_iova(self->device, region.vaddr, NULL));
+	ASSERT_NE(0, iommu_mapping_get(device_bdf, region.iova, &mapping));
+
+	ASSERT_TRUE(!munmap(region.vaddr, size));
+}
+
+int main(int argc, char *argv[])
+{
+	device_bdf = vfio_selftests_get_bdf(&argc, argv);
+	return test_harness_run(argc, argv);
+}
-- 
2.52.0.351.gbe84eed79e-goog


