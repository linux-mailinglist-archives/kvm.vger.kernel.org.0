Return-Path: <kvm+bounces-14518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 19A9A8A2C83
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:37:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD5D71F239A0
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:37:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9626758AD6;
	Fri, 12 Apr 2024 10:35:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C27B758ACE
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 10:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918125; cv=none; b=Y2MQrs29PlGJNRkfsdQU80HvmTcGf/BsUyoF4w0lj6FDQD1UpqYVJYa3gl/PpXSWOhfH45KOGmiQ98nvyoCjJ1QY5Fn6Nul/Pq3Sd+bth2VESMzq2U1TBwsyUGoTvuPuTafaBPADxGGfN7OlIbEFNyYUQ70o5KQf4EGdY3BFZsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918125; c=relaxed/simple;
	bh=cS46VWdNhnMXNP7L6xDVjgUS7fCRT6ut00MGNI+G8p0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PswrBzONW9azbIXE7nq342sa44EexbSp94nf0Os59eMnIsTeIM0vVx2E4wLifplsfNQZV1LWbPAiy8PEYW/rCCrUvff1PN9XnOX3FfofNiwPnlPzMkfXhsyxO/ozKJFf4vhGvsKTaEZgk4kiaBOV0URiiWgwBCp/kerDfPBbHXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B00A91655;
	Fri, 12 Apr 2024 03:35:52 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B1CCB3F64C;
	Fri, 12 Apr 2024 03:35:21 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	steven.price@arm.com,
	james.morse@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvm-unit-tests PATCH 32/33] arm: Add memtest support
Date: Fri, 12 Apr 2024 11:34:07 +0100
Message-Id: <20240412103408.2706058-33-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joey Gouly <joey.gouly@arm.com>

Add a test to touch all memory allocated to the guest.
Provides options to allocate in block, shared mode etc.
Also adds a "memstress" variant which would test all the
combinations in order.

PS: The memory allocator fragments the available memory
on page allocation and doesn't allow merging them for a
higher order allocation. Hence, all the block alloc tests
are run one after the other, before any page allocation
tests are run

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/selftest.c | 123 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 122 insertions(+), 1 deletion(-)

diff --git a/arm/selftest.c b/arm/selftest.c
index 7bc5fb76..d9fd9750 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -9,6 +9,7 @@
 #include <util.h>
 #include <devicetree.h>
 #include <memregions.h>
+#include <alloc_page.h>
 #include <vmalloc.h>
 #include <asm/setup.h>
 #include <asm/ptrace.h>
@@ -435,6 +436,123 @@ static void cpu_report(void *data __unused)
 	report_info("CPU%3d: MPIDR=%010" PRIx64, cpu, mpidr);
 }
 
+
+/*
+ * do_memtest: Accepts the following paramters.
+ *
+ * shared[=0/1] - Use shared page for the memtests.
+ * block[=0/1]  - Use SZ_2M allocation/free.
+ * nofree	- Do not free the pages after the test.
+ */
+static void do_memtest(int argc, char *argv[])
+{
+	int i;
+	int npages = 0;
+	bool result = true;
+	const char pattern = 0xFB;
+	void *prev_page = NULL;
+	uintptr_t *page_to_free = NULL;
+	int size;
+	void* (*alloc_order_fn)(unsigned int);
+	void (*free_order_fn)(void *, unsigned int);
+	bool shared = false;
+	bool block = false;
+	bool nofree = false;
+	int order = 0;
+
+	for (i = 2; i < argc; i++) {
+		long val, len;
+
+		len = parse_keyval(argv[i], &val);
+		if (len == -1) {
+			if (!strcmp(argv[i], "shared")) {
+				shared = true;
+				continue;
+			} else if (!strcmp(argv[i], "nofree")) {
+				nofree = true;
+				continue;
+			} else if (!strcmp(argv[i], "block")) {
+				block = true;
+			} else {
+				printf("Unknown options %s\n", argv[i]);
+				abort();
+			}
+		} else if (!strncmp(argv[i], "block", len)) {
+			block = !!val;
+		} else if (!strncmp(argv[i], "shared", len)) {
+			shared = !!val;
+		}
+	}
+
+	/* Block mapping is 2MB */
+	if (block)
+		order = (21 - PAGE_SHIFT);
+
+	size = (1 << order) * PAGE_SIZE;
+	if (shared) {
+		alloc_order_fn = &alloc_pages_shared;
+		free_order_fn = &free_pages_shared_by_order;
+	} else {
+		alloc_order_fn = &alloc_pages;
+		free_order_fn = &free_pages_by_order;
+	}
+
+	report_info("Running %smemtest with size %dK%s, order=%d",
+		    shared ? "shared " : "",
+		    size >> 10,
+		    nofree ? " with no freeing" :"",
+		    order);
+
+	while (1) {
+		void *page = alloc_order_fn(order);
+
+		if (!page)
+			break;
+		npages += 1;
+
+		memset(page, pattern, size);
+
+		for (i = 0; i < size; i += 1) {
+			if (((char *)page)[i] != pattern) {
+				result = false;
+				report(false, "Failed to find the pattern in page %p, expected: %d, got: %d\n",
+					page, pattern, ((char *)page)[i]);
+				goto exit;
+			}
+		}
+
+		/*
+		 * Save a pointer to the allocated page so that it can be
+		 * free'd at the end of the test.
+		*/
+		*(uintptr_t *)page = (uintptr_t)prev_page;
+		prev_page = page;
+	}
+
+	page_to_free = prev_page;
+	while (!nofree && page_to_free) {
+		prev_page = (uintptr_t *)(*page_to_free);
+		free_order_fn(page_to_free, order);
+		page_to_free = prev_page;
+	}
+
+exit:
+	report(result, "Tested with %dKB", (npages  * size) >> 10);
+}
+
+static void do_memstress(void)
+{
+	char shared[16] = "shared";
+	char block[16] = "block";
+	char nofree[16] = "nofree";
+	char null[4] = "";
+
+	do_memtest(4, &((char *[]){ null, null, shared, block })[0]);
+	do_memtest(3, &((char *[]){ null, null, block })[0]);
+	do_memtest(3, &((char *[]){ null, null, shared })[0]);
+	do_memtest(3, &((char *[]){ null, null, nofree })[0]);
+}
+
 int main(int argc, char **argv)
 {
 	report_prefix_push("selftest");
@@ -466,7 +584,10 @@ int main(int argc, char **argv)
 		smp_rmb();		/* Paired with wmb in cpu_report(). */
 		report(cpumask_full(&valid), "MPIDR test on all CPUs");
 		report_info("%d CPUs reported back", nr_cpus);
-
+	} else if (strcmp(argv[1], "memtest") == 0) {
+		do_memtest(argc, argv);
+	} else if (strcmp(argv[1], "memstress") == 0) {
+		do_memstress();
 	} else {
 		printf("Unknown subtest\n");
 		abort();
-- 
2.34.1


