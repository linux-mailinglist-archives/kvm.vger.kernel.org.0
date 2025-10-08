Return-Path: <kvm+bounces-59672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DAFCBC6DC2
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 01:27:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B73234EC6D0
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 23:26:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A52272D0C76;
	Wed,  8 Oct 2025 23:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IhTEaYos"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C882D062A
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 23:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759965976; cv=none; b=KDLOeSMwTLT+kdpKQlHpfgfzlmXCovzM7u2tLkMFaemh5wJeByceFd6XmwgReu7hJPWvWkzBOwFjrZPvCMvSCcg5kRp9qXvKfKaUMOMYIUm8xZdZURSWnHbEwX11Ik+T+V+4fn4FjijCNAYkt/7op3UOOqAqg+ndlbLKkzrwZAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759965976; c=relaxed/simple;
	bh=rWB3QI8V7TPNGqIaW6GQB3xCQWPk17yYIzlYcfdoGiM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NALpsxqlcRioBUjbx4tLWB3kAhaRPQ9NAdrbXtxRca+xaHk0CkeISNdsO17QsNg50jtCN+O2whZ3zDcMehlLsryLrJBH1zbPKeZUdw/Ivg4tp7fEQ2ScsP4X4K+RDkKin2BD6F9+j46J8UbFhI8s/+mswg5Tq6l1B5jxh7Zvmpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IhTEaYos; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76e2eb787f2so396524b3a.3
        for <kvm@vger.kernel.org>; Wed, 08 Oct 2025 16:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759965975; x=1760570775; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a1/Olf0vwMpDhTV7Aa0L2Ctx+GQPvJUJhR9ST7uRiu4=;
        b=IhTEaYoslZwaLOwk44Y0TySJjArUxx9fEg34Co7GPo5Usy7bN7uIiHSh340ohR5CbM
         JAS/+I/aC/bZfzYnCZToN4IPqgMpO9iTkmrhK2qspFpr+WtUq0yqoa6c9PJ60EyFInG6
         stcj1ZU/BxrDKlcpMaMg6s8vRZ02h6SIXaCtdcb9J32zTeA6/U9Fxt2TUl2jCQnkBSmD
         WS/xuCoAiHtr1tyuaF6iacKZ1p1HGtOADRMrysa3mfkDJvnFRFYZZAWMhmPoq0FCU0qK
         vkSu5PHlZvgPNdogwps2mXx76UvLN7jK9rMapyhC3FefZSicpCN1NOXVqlPlOCvZiYbm
         Knlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759965975; x=1760570775;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a1/Olf0vwMpDhTV7Aa0L2Ctx+GQPvJUJhR9ST7uRiu4=;
        b=MptmuAx5Zx/WTeP23jkRgvhLMmQPKAJ3R4wi2i1Ns3REkFrfXU7ZDj/39MAnnr8/A/
         LJYg7q2tgOr3ON3+dcGv9uaFsEf6kBRW3yY25btH4TynSprouDO4YxAIwVnH/Lb3xxH0
         l02i0enwKrLAjOY/vjlfHwMEKbarUIz6KhQq3g0ehOyaMF2COw3mrl6cGy6sC5qTimEJ
         L8sosOs+Qq9JPlo16bz1oCGRgei/3UolZ+ApxtuZUEpf2nPWkGM7zR4WqcQ9U+WVEYkE
         R30xktf2xj80rguQu0JpWNjvKZnlwaBpkrN/nDikUkB0TFEtgc8BVtW/pNndAC1f8/Cg
         rywg==
X-Forwarded-Encrypted: i=1; AJvYcCXzTxEPx5O8dUDYTOM6IV7aNHsnFghzq9smQtyI04hhdTscRDhLkxkuUteWf9EnJ4YaVJk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCME2n4essgvd5G58Ld7Zeo94ap1FUcu34hd/W3poaisLeljFS
	Sp/CkHOm1lQMYbCNjEbv721+6e0OpyMWV4zB8Jv1TlEdVtSWEUMmJXsxWr7a3NEYujUBG+QhFgJ
	0+PjBll7C0OKqUw==
X-Google-Smtp-Source: AGHT+IH72I3ReC4srTbobD8N5+Y1VQN732z52v3UTUThWxMk2J6eayFq1jHNZW7sBMecNreXAIxdlX5JuPaA6w==
X-Received: from pfbmc49.prod.google.com ([2002:a05:6a00:76b1:b0:77f:6432:dc05])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1706:b0:77f:50df:df31 with SMTP id d2e1a72fcca58-793870523b6mr4917674b3a.20.1759965974586;
 Wed, 08 Oct 2025 16:26:14 -0700 (PDT)
Date: Wed,  8 Oct 2025 23:25:31 +0000
In-Reply-To: <20251008232531.1152035-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251008232531.1152035-1-dmatlack@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008232531.1152035-13-dmatlack@google.com>
Subject: [PATCH 12/12] vfio: selftests: Add vfio_pci_device_init_perf_test
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: David Matlack <dmatlack@google.com>, Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, 
	kvm@vger.kernel.org, Vipin Sharma <vipinsh@google.com>, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a new VFIO selftest for measuring the time it takes to run
vfio_pci_device_init() in parallel for one or more devices.

This test serves as manual regression test for the performance
improvement of commit e908f58b6beb ("vfio/pci: Separate SR-IOV VF
dev_set"). For example, when running this test with 64 VFs under the
same PF:

Before:

  $ ./vfio_pci_device_init_perf_test -r vfio_pci_device_init_perf_test.iommufd.init 0000:1a:00.0 0000:1a:00.1 ...
  ...
  Wall time: 6.653234463s
  Min init time (per device): 0.101215344s
  Max init time (per device): 6.652755941s
  Avg init time (per device): 3.377609608s

After:

  $ ./vfio_pci_device_init_perf_test -r vfio_pci_device_init_perf_test.iommufd.init 0000:1a:00.0 0000:1a:00.1 ...
  ...
  Wall time: 0.122978332s
  Min init time (per device): 0.108121915s
  Max init time (per device): 0.122762761s
  Avg init time (per device): 0.113816748s

This test does not make any assertions about performance, since any such
assertion is likely to be flaky due to system differences and random
noise. However this test can be fed into automation to detect
regressions, and can be used by developers in the future to measure
performance optimizations.

Suggested-by: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/Makefile         |   3 +
 .../vfio/vfio_pci_device_init_perf_test.c     | 163 ++++++++++++++++++
 2 files changed, 166 insertions(+)
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_device_init_perf_test.c

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index 324ba0175a33..7b69375ee6ea 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -2,6 +2,7 @@ CFLAGS = $(KHDR_INCLUDES)
 TEST_GEN_PROGS += vfio_dma_mapping_test
 TEST_GEN_PROGS += vfio_iommufd_setup_test
 TEST_GEN_PROGS += vfio_pci_device_test
+TEST_GEN_PROGS += vfio_pci_device_init_perf_test
 TEST_GEN_PROGS += vfio_pci_driver_test
 TEST_PROGS_EXTENDED := run.sh
 include ../lib.mk
@@ -11,6 +12,8 @@ CFLAGS += -I$(top_srcdir)/tools/include
 CFLAGS += -MD
 CFLAGS += $(EXTRA_CFLAGS)
 
+LDFLAGS += -pthread
+
 $(TEST_GEN_PROGS): %: %.o $(LIBVFIO_O)
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $< $(LIBVFIO_O) $(LDLIBS) -o $@
 
diff --git a/tools/testing/selftests/vfio/vfio_pci_device_init_perf_test.c b/tools/testing/selftests/vfio/vfio_pci_device_init_perf_test.c
new file mode 100644
index 000000000000..b09005c0f27f
--- /dev/null
+++ b/tools/testing/selftests/vfio/vfio_pci_device_init_perf_test.c
@@ -0,0 +1,163 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <pthread.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+
+#include <linux/sizes.h>
+#include <linux/vfio.h>
+
+#include <libvfio.h>
+
+#include "../kselftest_harness.h"
+
+static char **device_bdfs;
+static int nr_devices;
+
+struct thread_args {
+	struct iommu *iommu;
+	int device_index;
+	struct timespec start;
+	struct timespec end;
+	pthread_barrier_t *barrier;
+};
+
+FIXTURE(vfio_pci_device_init_perf_test) {
+	pthread_t *threads;
+	pthread_barrier_t barrier;
+	struct thread_args *thread_args;
+	struct iommu *iommu;
+};
+
+FIXTURE_VARIANT(vfio_pci_device_init_perf_test) {
+	const char *iommu_mode;
+};
+
+#define FIXTURE_VARIANT_ADD_IOMMU_MODE(_iommu_mode)			\
+FIXTURE_VARIANT_ADD(vfio_pci_device_init_perf_test, _iommu_mode) {	\
+	.iommu_mode = #_iommu_mode,					\
+}
+
+FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES();
+
+FIXTURE_SETUP(vfio_pci_device_init_perf_test)
+{
+	int i;
+
+	self->iommu = iommu_init(variant->iommu_mode);
+	self->threads = calloc(nr_devices, sizeof(self->threads[0]));
+	self->thread_args = calloc(nr_devices, sizeof(self->thread_args[0]));
+
+	pthread_barrier_init(&self->barrier, NULL, nr_devices);
+
+	for (i = 0; i < nr_devices; i++) {
+		self->thread_args[i].iommu = self->iommu;
+		self->thread_args[i].barrier = &self->barrier;
+		self->thread_args[i].device_index = i;
+	}
+}
+
+FIXTURE_TEARDOWN(vfio_pci_device_init_perf_test)
+{
+	iommu_cleanup(self->iommu);
+	free(self->threads);
+	free(self->thread_args);
+}
+
+static s64 to_ns(struct timespec ts)
+{
+	return (s64)ts.tv_nsec + 1000000000LL * (s64)ts.tv_sec;
+}
+
+static struct timespec to_timespec(s64 ns)
+{
+	struct timespec ts = {
+		.tv_nsec = ns % 1000000000LL,
+		.tv_sec = ns / 1000000000LL,
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
+static struct timespec timespec_min(struct timespec a, struct timespec b)
+{
+	return to_ns(a) < to_ns(b) ? a : b;
+}
+
+static struct timespec timespec_max(struct timespec a, struct timespec b)
+{
+	return to_ns(a) > to_ns(b) ? a : b;
+}
+
+static void *thread_main(void *__args)
+{
+	struct thread_args *args = __args;
+	struct vfio_pci_device *device;
+
+	pthread_barrier_wait(args->barrier);
+
+	clock_gettime(CLOCK_MONOTONIC, &args->start);
+	device = __vfio_pci_device_init(device_bdfs[args->device_index], args->iommu);
+	clock_gettime(CLOCK_MONOTONIC, &args->end);
+
+	pthread_barrier_wait(args->barrier);
+
+	__vfio_pci_device_cleanup(device);
+	return NULL;
+}
+
+TEST_F(vfio_pci_device_init_perf_test, init)
+{
+	struct timespec start = to_timespec(INT64_MAX), end = {};
+	struct timespec min = to_timespec(INT64_MAX);
+	struct timespec max = {};
+	struct timespec avg = {};
+	struct timespec wall_time;
+	s64 thread_ns = 0;
+	int i;
+
+	for (i = 0; i < nr_devices; i++) {
+		pthread_create(&self->threads[i], NULL, thread_main,
+			       &self->thread_args[i]);
+	}
+
+	for (i = 0; i < nr_devices; i++) {
+		struct thread_args *args = &self->thread_args[i];
+		struct timespec init_time;
+
+		pthread_join(self->threads[i], NULL);
+
+		start = timespec_min(start, args->start);
+		end = timespec_max(end, args->end);
+
+		init_time = timespec_sub(args->end, args->start);
+		min = timespec_min(min, init_time);
+		max = timespec_max(max, init_time);
+		thread_ns += to_ns(init_time);
+	}
+
+	avg = to_timespec(thread_ns / nr_devices);
+	wall_time = timespec_sub(end, start);
+
+	printf("Wall time: %lu.%09lus\n",
+	       wall_time.tv_sec, wall_time.tv_nsec);
+	printf("Min init time (per device): %lu.%09lus\n",
+	       min.tv_sec, min.tv_nsec);
+	printf("Max init time (per device): %lu.%09lus\n",
+	       max.tv_sec, max.tv_nsec);
+	printf("Avg init time (per device): %lu.%09lus\n",
+	       avg.tv_sec, avg.tv_nsec);
+}
+
+int main(int argc, char *argv[])
+{
+	device_bdfs = vfio_selftests_get_bdfs(&argc, argv, &nr_devices);
+
+	printf("Number of devices: %d\n", nr_devices);
+
+	return test_harness_run(argc, argv);
+}
-- 
2.51.0.710.ga91ca5db03-goog


