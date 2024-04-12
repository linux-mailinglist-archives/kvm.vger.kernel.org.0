Return-Path: <kvm+bounces-14499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 93BFA8A2C70
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:35:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EDC1284929
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E9E64436E;
	Fri, 12 Apr 2024 10:34:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1D7655C3A
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 10:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918086; cv=none; b=Tso8Ugz1vlV8YgUvtSeS96LozE7Mv8wA/a3wAo9vDKD8g7CrPGA6/aSZ/adrVERL6f9H8TKbwS0Ea1cfkZfLDPOyvR2Ti0fk3ybk6bOXRZzrtZzz4u7P3LpA3s8AAU679/lSe37M+ujrebhU4PsZ/MD/p2Ikp0ozMg7jdY35ENk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918086; c=relaxed/simple;
	bh=nozHs0KZimfxIaYYA8fGicVWbIDfNSY5D4zYC7kpQss=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CGOK0af2+LnW/zMWvZPyV8A8V96CyK6BfKIZxXVpAodTwxQKpSAei3mkH+GnVDosWuRHEt53JdlJGAXkTbk/c2wK5XihfoHsxppo1UFpOMVUV7EtsQwYLEWFEe93gYXJnjQUP0khgjK7qGZeL0b8unLZpnbhRi/DvnIijsKzZzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6A153113E;
	Fri, 12 Apr 2024 03:35:14 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 73B8B3F64C;
	Fri, 12 Apr 2024 03:34:43 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH 13/33] arm: realm: Add RSI version test
Date: Fri, 12 Apr 2024 11:33:48 +0100
Message-Id: <20240412103408.2706058-14-suzuki.poulose@arm.com>
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

Add basic test for checking the RSI version command.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/Makefile.arm64 |  1 +
 arm/realm-rsi.c    | 51 ++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg  |  7 +++++++
 3 files changed, 59 insertions(+)
 create mode 100644 arm/realm-rsi.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index bd167db1..90d95e79 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -49,6 +49,7 @@ tests = $(TEST_DIR)/timer.$(exe)
 tests += $(TEST_DIR)/micro-bench.$(exe)
 tests += $(TEST_DIR)/cache.$(exe)
 tests += $(TEST_DIR)/debug.$(exe)
+tests += $(TEST_DIR)/realm-rsi.$(exe)
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
diff --git a/arm/realm-rsi.c b/arm/realm-rsi.c
new file mode 100644
index 00000000..6c228e42
--- /dev/null
+++ b/arm/realm-rsi.c
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+
+#include <libcflat.h>
+#include <asm/io.h>
+#include <asm/page.h>
+#include <asm/processor.h>
+#include <asm/psci.h>
+#include <alloc_page.h>
+#include <asm/rsi.h>
+#include <asm/pgtable.h>
+#include <asm/processor.h>
+
+static void rsi_test_version(void)
+{
+	struct smccc_result res;
+	int ret, version;
+
+	report_prefix_push("version");
+
+	ret = __rsi_get_version(RSI_ABI_VERSION, &res);
+	if (ret < 0) {
+		report(false, "SMC_RSI_ABI_VERSION failed (%d)", ret);
+		return;
+	}
+
+	version = res.r1;
+	report(res.r0 == RSI_SUCCESS, "RSI ABI version %u.%u (expected: %u.%u)",
+	       RSI_ABI_VERSION_GET_MAJOR(version),
+	       RSI_ABI_VERSION_GET_MINOR(version),
+	       RSI_ABI_VERSION_GET_MAJOR(RSI_ABI_VERSION),
+	       RSI_ABI_VERSION_GET_MINOR(RSI_ABI_VERSION));
+	report_prefix_pop();
+}
+
+int main(int argc, char **argv)
+{
+	report_prefix_push("rsi");
+
+	if (!is_realm()) {
+		report_skip("Not a realm, skipping tests");
+		goto exit;
+	}
+
+	rsi_test_version();
+exit:
+	return report_summary();
+}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index fe601cbb..a46c9ec7 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -281,3 +281,10 @@ file = debug.flat
 arch = arm64
 extra_params = -append 'ss-migration'
 groups = debug migration
+
+# Realm RSI ABI test
+[realm-rsi]
+file = realm-rsi.flat
+groups = nodefault realms
+accel = kvm
+arch = arm64
-- 
2.34.1


