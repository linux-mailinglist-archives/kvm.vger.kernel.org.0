Return-Path: <kvm+bounces-14517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 49CD78A2C82
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:37:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A2525B21CD7
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:37:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C08258AC8;
	Fri, 12 Apr 2024 10:35:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D14F558AB2
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 10:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918123; cv=none; b=NgWkuVRO/c5m7vUrhTlJDyEGfsFqjsbfgVs1Hd+7VDKAB9B5NMlK/RWTos0YCvB9pMRCUQ8qLxcBsYm2MdZ4IjOTLK4CSwk9ewU++jxa1ZcHS06cVNeKZtRnnmvfVYEy3vNfI3d7PymWFqwXBE+27zmGtnHFtX928obKve5922k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918123; c=relaxed/simple;
	bh=oYpaKPDZZUEB8h55LH9osV+NKs+2zNB4M/v9NtEQT/A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HJQiFji97+Tx0K1aP660DA4ODj6c7Y4fEa0AzNkgHlZzetApgp5Egjfyl8uJzwIFOLehuVBwKZk8/YV0iGhFnfnsIOyBrPbbmZY5SQcT6WyQaYWxg/DsyZlHpRWEai9hHC1zNcOjeNINip/s37pGz3x5sWWDlvXtB0usl75gh4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2D74113E;
	Fri, 12 Apr 2024 03:35:50 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BAA253F64C;
	Fri, 12 Apr 2024 03:35:19 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH 31/33] arm: realm: Add a test for shared memory
Date: Fri, 12 Apr 2024 11:34:06 +0100
Message-Id: <20240412103408.2706058-32-suzuki.poulose@arm.com>
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

Do some basic tests that trigger marking a memory region as
RIPAS_EMPTY and accessing the shared memory. Also, convert it back
to RAM and make sure the contents are scrubbed.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/Makefile.arm64    |  1 +
 arm/realm-ns-memory.c | 86 +++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg     |  8 ++++
 3 files changed, 95 insertions(+)
 create mode 100644 arm/realm-ns-memory.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 7a56029e..bd8c947d 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -68,6 +68,7 @@ tests += $(TEST_DIR)/fpu.$(exe)
 tests += $(TEST_DIR)/realm-rsi.$(exe)
 tests += $(TEST_DIR)/realm-sea.$(exe)
 tests += $(TEST_DIR)/realm-attest.$(exe)
+tests += $(TEST_DIR)/realm-ns-memory.$(exe)
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
diff --git a/arm/realm-ns-memory.c b/arm/realm-ns-memory.c
new file mode 100644
index 00000000..8360c371
--- /dev/null
+++ b/arm/realm-ns-memory.c
@@ -0,0 +1,86 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+
+#include <asm/io.h>
+#include <alloc_page.h>
+#include <bitops.h>
+
+#define GRANULE_SIZE 	0x1000
+#define BUF_SIZE	(PAGE_SIZE * 2)
+#define BUF_PAGES	(BUF_SIZE / PAGE_SIZE)
+#define BUF_GRANULES	(BUF_SIZE / GRANULE_SIZE)
+
+static char __attribute__((aligned(PAGE_SIZE))) buffer[BUF_SIZE];
+
+static void static_shared_buffer_test(void)
+{
+	int i;
+
+	set_memory_decrypted((unsigned long)buffer, sizeof(buffer));
+	for (i = 0; i < sizeof(buffer); i += GRANULE_SIZE)
+		buffer[i] = (char)i;
+
+	/*
+	 * Verify the content of the NS buffer
+	 */
+	for (i = 0; i < sizeof(buffer); i += GRANULE_SIZE) {
+		if (buffer[i] != (char)i) {
+			report(false, "Failed to set Non Secure memory");
+			return;
+		}
+	}
+
+	/* Make the buffer back to protected... */
+	set_memory_encrypted((unsigned long)buffer, sizeof(buffer));
+	/* .. and check if the contents were destroyed */
+	for (i = 0; i < sizeof(buffer); i += GRANULE_SIZE) {
+		if (buffer[i] != 0) {
+			report(false, "Failed to scrub protected memory");
+			return;
+		}
+	}
+
+	report(true, "Conversion of protected memory to shared and back");
+}
+
+static void dynamic_shared_buffer_test(void)
+{
+	char *ns_buffer;
+	int i;
+	int order = get_order(BUF_PAGES);
+
+	ns_buffer = alloc_pages_shared(order);
+	assert(ns_buffer);
+	for (i = 0; i < sizeof(buffer); i += GRANULE_SIZE)
+		ns_buffer[i] = (char)i;
+
+	/*
+	 * Verify the content of the NS buffer
+	 */
+	for (i = 0; i < sizeof(buffer); i += GRANULE_SIZE) {
+		if (ns_buffer[i] != (char)i) {
+			report(false, "Failed to set Non Secure memory");
+			return;
+		}
+	}
+	free_pages_shared(ns_buffer);
+	report(true, "Dynamic allocation and free of shared memory\n");
+}
+
+static void ns_test(void)
+{
+	static_shared_buffer_test();
+	dynamic_shared_buffer_test();
+}
+
+int main(int argc, char **argv)
+{
+	report_prefix_pushf("ns-memory");
+	ns_test();
+	report_prefix_pop();
+
+	return report_summary();
+}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index f95fc1ba..55a17f2b 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -367,3 +367,11 @@ smp = 1
 extra_params = -m 32 -append 'measurement'
 accel = kvm
 arch = arm64
+
+[realm-ns-memory]
+file=realm-ns-memory.flat
+groups = nodefault realms
+smp = 1
+extra_params = -m 32
+accel = kvm
+arch = arm64
-- 
2.34.1


