Return-Path: <kvm+bounces-14505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FE2E8A2C76
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:36:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EEC372854F2
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 487A456B85;
	Fri, 12 Apr 2024 10:34:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 985F020310
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 10:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918098; cv=none; b=jhxIGS824ilatjkVlrPhuc9MORmlSTttXdUGacD4GUqPMlrtDXOEl3nsSrqDnGc27cW02ShtM8MyJMRgI0MtWSrbWNsp+n3DaruWeibS+LIe69YKaW3BHPXwnupse+tlyyVjOfD2CefqfjCn2HVwVR/amTYzNkzo7yDDfSQ9NdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918098; c=relaxed/simple;
	bh=AhiXtCiFfnKWDvEtxDp2OamHNP4syIGGdvaexWE4fjE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qSd2BgKtFdWgAha2DrKpoVGmaGgDxKoX8nVKwXWTQD0Lb0FoYxwWBGuBZfrutwIWXR8b4pYSvj5e3Vq62NuobRwtIV2vC7eg/N4uYPnkMig1pnp2gX1g3C14NA6W5/7uWeRpOTzruyQT8KrI/88H0dx8KAYOsijClwGuKtDZY2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 857E71596;
	Fri, 12 Apr 2024 03:35:26 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8F3033F64C;
	Fri, 12 Apr 2024 03:34:55 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH 19/33] arm64: selftest: add realm SVE VL test
Date: Fri, 12 Apr 2024 11:33:54 +0100
Message-Id: <20240412103408.2706058-20-suzuki.poulose@arm.com>
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

Check that the requested SVE vector length matches what
the Realm was configured with.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
[ Fix build failures on arm ]
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/selftest.c              |  6 ++++++
 arm/unittests.cfg           |  2 +-
 lib/arm/asm/sve-vl-test.h   |  9 +++++++++
 lib/arm64/asm/sve-vl-test.h | 28 ++++++++++++++++++++++++++++
 4 files changed, 44 insertions(+), 1 deletion(-)
 create mode 100644 lib/arm/asm/sve-vl-test.h
 create mode 100644 lib/arm64/asm/sve-vl-test.h

diff --git a/arm/selftest.c b/arm/selftest.c
index 8caadad3..7bc5fb76 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -21,6 +21,8 @@
 #include <asm/barrier.h>
 #include <asm/rsi.h>
 
+#include <asm/sve-vl-test.h>
+
 static cpumask_t ready, valid;
 
 static void __user_psci_system_off(void)
@@ -60,6 +62,10 @@ static void check_setup(int argc, char **argv)
 			       "number of CPUs matches expectation");
 			report_info("found %d CPUs", nr_cpus);
 			++nr_tests;
+
+		} else if (strcmp(argv[i], "sve-vl") == 0) {
+			if (check_arm_sve_vl(val))
+				nr_tests++;
 		}
 
 		report_prefix_pop();
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index e35e8506..3cf6b719 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -33,7 +33,7 @@
 [selftest-setup]
 file = selftest.flat
 smp = 2
-extra_params = -m 256 -append 'setup smp=2 mem=256'
+extra_params = -m 256 -append 'setup smp=2 mem=256 sve-vl'
 groups = selftest
 
 # Test vector setup and exception handling (kernel mode).
diff --git a/lib/arm/asm/sve-vl-test.h b/lib/arm/asm/sve-vl-test.h
new file mode 100644
index 00000000..19eaf669
--- /dev/null
+++ b/lib/arm/asm/sve-vl-test.h
@@ -0,0 +1,9 @@
+#ifndef __ARM_SVE_VL_TEST_H
+#define __ARM_SVE_VL_TEST_H
+
+static bool check_arm_sve_vl(long val)
+{
+	return false;
+}
+
+#endif
diff --git a/lib/arm64/asm/sve-vl-test.h b/lib/arm64/asm/sve-vl-test.h
new file mode 100644
index 00000000..c82ea154
--- /dev/null
+++ b/lib/arm64/asm/sve-vl-test.h
@@ -0,0 +1,28 @@
+#ifndef __ARM_SVE_VL_TEST_H_
+#define __ARM_SVE_VL_TEST_H_
+
+#include <asm/processor.h>
+#include <asm/sysreg.h>
+
+static bool check_arm_sve_vl(long val)
+{
+	unsigned long vl;
+
+	if (!system_supports_sve()) {
+		report_skip("SVE is not supported\n");
+	} else {
+		/* Enable the maxium SVE vector length */
+		write_sysreg(ZCR_EL1_LEN, ZCR_EL1);
+		vl = sve_vl();
+		/* Realms are configured with a SVE VL */
+		if (is_realm()) {
+			report(vl == val,
+				"SVE VL expected (%ld), detected (%ld)",
+				val, vl);
+		} else {
+			report(true, "Detected SVE VL %ld\n", vl);
+		}
+	}
+	return true;
+}
+#endif
-- 
2.34.1


