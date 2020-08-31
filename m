Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5743F2581D2
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 21:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgHaTei (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 15:34:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50435 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728938AbgHaTeg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 Aug 2020 15:34:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598902474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dlm+r41ohHjW30i+MQ1d9KTTnOYk1vHfisVWqLyZbwo=;
        b=bN8YIgLVy7MHkbnRYEl0FCPxUYtohCWB/Qz308Uv3OxeZPe5Op8yGKd7H2aq488q1D3YcH
        df1B71+gRJhLVZNzMSZLhKjzDGRfBPiXiBsy52OlFlCd2WSD8Yw96xGVQP2OI2eOa/fwN/
        GiIAlTsH/YAC8ppZ9NoAKnZDZEcPS0Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-2z1t971-N1-8k9kKIHOPfA-1; Mon, 31 Aug 2020 15:34:29 -0400
X-MC-Unique: 2z1t971-N1-8k9kKIHOPfA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C3C3100747B;
        Mon, 31 Aug 2020 19:34:28 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-112.ams2.redhat.com [10.36.112.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D5ACA7EB69;
        Mon, 31 Aug 2020 19:34:25 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        qemu-devel@nongnu.org, drjones@redhat.com, andrew.murray@arm.com,
        sudeep.holla@arm.com, maz@kernel.org, will@kernel.org,
        haibo.xu@linaro.org
Subject: [kvm-unit-tests RFC 2/4] spe: Probing and Introspection Test
Date:   Mon, 31 Aug 2020 21:34:12 +0200
Message-Id: <20200831193414.6951-3-eric.auger@redhat.com>
In-Reply-To: <20200831193414.6951-1-eric.auger@redhat.com>
References: <20200831193414.6951-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test whether Statistical Profiling Extensions (SPE) are
supported and in the positive collect dimensioning data from
the IDR registers. The First test only validates those.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/Makefile.common |   1 +
 arm/spe.c           | 163 ++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg   |   8 +++
 3 files changed, 172 insertions(+)
 create mode 100644 arm/spe.c

diff --git a/arm/Makefile.common b/arm/Makefile.common
index a123e85..4e7e4eb 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -8,6 +8,7 @@ tests-common  = $(TEST_DIR)/selftest.flat
 tests-common += $(TEST_DIR)/spinlock-test.flat
 tests-common += $(TEST_DIR)/pci-test.flat
 tests-common += $(TEST_DIR)/pmu.flat
+tests-common += $(TEST_DIR)/spe.flat
 tests-common += $(TEST_DIR)/gic.flat
 tests-common += $(TEST_DIR)/psci.flat
 tests-common += $(TEST_DIR)/sieve.flat
diff --git a/arm/spe.c b/arm/spe.c
new file mode 100644
index 0000000..153c182
--- /dev/null
+++ b/arm/spe.c
@@ -0,0 +1,163 @@
+/*
+ * Copyright (C) 2020, Red Hat Inc, Eric Auger <eric.auger@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU Lesser General Public License version 2.1 and
+ * only version 2.1 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
+ * for more details.
+ */
+#include "libcflat.h"
+#include "errata.h"
+#include "asm/barrier.h"
+#include "asm/sysreg.h"
+#include "asm/processor.h"
+#include "alloc_page.h"
+#include <bitops.h>
+
+struct spe {
+	int min_interval;
+	int maxsize;
+	int countsize;
+	bool fl_cap;
+	bool ft_cap;
+	bool fe_cap;
+	int align;
+	void *buffer;
+	bool unique_record_size;
+};
+
+static struct spe spe;
+
+#ifdef __arm__
+
+static bool spe_probe(void) { return false; }
+static void test_spe_introspection(void) { }
+
+#else
+
+#define ID_DFR0_PMSVER_SHIFT	32
+#define ID_DFR0_PMSVER_MASK	0xF
+
+#define PMBIDR_EL1_ALIGN_MASK	0xF
+#define PMBIDR_EL1_P		0x10
+#define PMBIDR_EL1_F		0x20
+
+#define PMSIDR_EL1_FE		0x1
+#define PMSIDR_EL1_FT		0x2
+#define PMSIDR_EL1_FL		0x4
+#define PMSIDR_EL1_ARCHINST	0x8
+#define PMSIDR_EL1_LDS		0x10
+#define PMSIDR_EL1_ERND		0x20
+#define PMSIDR_EL1_INTERVAL_SHIFT	8
+#define PMSIDR_EL1_INTERVAL_MASK	0xFUL
+#define PMSIDR_EL1_MAXSIZE_SHIFT	12
+#define PMSIDR_EL1_MAXSIZE_MASK		0xFUL
+#define PMSIDR_EL1_COUNTSIZE_SHIFT	16
+#define PMSIDR_EL1_COUNTSIZE_MASK	0xFUL
+
+#define PMSIDR_EL1	sys_reg(3, 0, 9, 9, 7)
+
+#define PMBIDR_EL1	sys_reg(3, 0, 9, 10, 7)
+
+static int min_interval(uint8_t idr_bits)
+{
+	switch (idr_bits) {
+	case 0x0:
+		return 256;
+	case 0x2:
+		return 512;
+	case 0x3:
+		return 768;
+	case 0x4:
+		return 1024;
+	case 0x5:
+		return 1536;
+	case 0x6:
+		return 2048;
+	case 0x7:
+		return 3072;
+	case 0x8:
+		return 4096;
+	default:
+		return -1;
+	}
+}
+
+static bool spe_probe(void)
+{
+	uint64_t pmbidr_el1, pmsidr_el1;
+	uint8_t pmsver;
+
+	pmsver = (get_id_aa64dfr0() >> ID_DFR0_PMSVER_SHIFT) & ID_DFR0_PMSVER_MASK;
+
+	report_info("PMSVer = %d", pmsver);
+	if (!pmsver || pmsver > 2)
+		return false;
+
+	pmbidr_el1 = read_sysreg_s(PMBIDR_EL1);
+	if (pmbidr_el1 & PMBIDR_EL1_P) {
+		report_info("MBIDR_EL1: Profiling buffer owned by this exception level");
+		return false;
+	}
+
+	spe.align = 1 << (pmbidr_el1 & PMBIDR_EL1_ALIGN_MASK);
+
+	pmsidr_el1 = read_sysreg_s(PMSIDR_EL1);
+
+	spe.min_interval = min_interval((pmsidr_el1 >> PMSIDR_EL1_INTERVAL_SHIFT) & PMSIDR_EL1_INTERVAL_MASK);
+	spe.maxsize = 1 << ((pmsidr_el1 >> PMSIDR_EL1_MAXSIZE_SHIFT) & PMSIDR_EL1_MAXSIZE_MASK);
+	spe.countsize = (pmsidr_el1 >> PMSIDR_EL1_COUNTSIZE_SHIFT) & PMSIDR_EL1_COUNTSIZE_MASK;
+
+	spe.fl_cap = pmsidr_el1 & PMSIDR_EL1_FL;
+	spe.ft_cap = pmsidr_el1 & PMSIDR_EL1_FT;
+	spe.fe_cap = pmsidr_el1 & PMSIDR_EL1_FE;
+
+	report_info("Align= %d bytes, Min Interval=%d Single record Max Size = %d bytes",
+			spe.align, spe.min_interval, spe.maxsize);
+	report_info("Filtering Caps: Lat=%d Type=%d Events=%d", spe.fl_cap, spe.ft_cap, spe.fe_cap);
+	if (spe.align == spe.maxsize) {
+		report_info("Each record is exactly %d bytes", spe.maxsize);
+		spe.unique_record_size = true;
+	}
+
+	spe.buffer = alloc_pages(0);
+
+	return true;
+}
+
+static void test_spe_introspection(void)
+{
+	report(spe.countsize == 0x2, "PMSIDR_EL1: CountSize = 0b0010");
+	report(spe.maxsize >= 16 && spe.maxsize <= 2048,
+		"PMSIDR_EL1: Single record max size = %d bytes", spe.maxsize);
+	report(spe.min_interval >= 256 && spe.min_interval <= 4096,
+		"PMSIDR_EL1: Minimal sampling interval = %d", spe.min_interval);
+}
+
+#endif
+
+int main(int argc, char *argv[])
+{
+	if (!spe_probe()) {
+		printf("SPE not supported, test skipped...\n");
+		return report_summary();
+	}
+
+	if (argc < 2)
+		report_abort("no test specified");
+
+	report_prefix_push("spe");
+
+	if (strcmp(argv[1], "spe-introspection") == 0) {
+		report_prefix_push(argv[1]);
+		test_spe_introspection();
+		report_prefix_pop();
+	} else {
+		report_abort("Unknown sub-test '%s'", argv[1]);
+	}
+	return report_summary();
+}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index f776b66..c070939 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -134,6 +134,14 @@ extra_params = -append 'pmu-overflow-interrupt'
 #groups = pmu
 #accel = tcg
 
+[spe-introspection]
+file = spe.flat
+groups = spe
+arch = arm64
+extra_params = -append 'spe-introspection'
+accel = kvm
+arch = arm64
+
 # Test GIC emulation
 [gicv2-ipi]
 file = gic.flat
-- 
2.21.3

