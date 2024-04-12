Return-Path: <kvm+bounces-14496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B10C8A2C6D
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:35:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B61A61F23792
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:35:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67C8154FA1;
	Fri, 12 Apr 2024 10:34:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C79954909
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 10:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918080; cv=none; b=DjL0WY2MFUchXq0Zf34Du+4V+GKQuWQ5l9EFvr0JtgBDDVefDvTAWhgVDQW9/G/LSChrsKq2OJqf26N3kdF7OfZ0nPPYrUHbRZ3X7OxM3fYKCCeORbkpW686ESDrCWmGWcVM8YwrIYKCAo9RXW7mzCN388zlxxNzX3E28wXoa28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918080; c=relaxed/simple;
	bh=6dzhwVemihqB2YGCnHg7alk7mTvDxcxFOWZ3Iu7tX04=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tE67PEVVxahZ/K48lA6GVPs5LMzYVOS4ToqGVRKRQwWKWlkzpxh+BtRxwMYq7j9SJZjV0Q0jM3oXVzj8I2L4ea0W3ePE/xJqr+sTk/beU6zeVY88L1K4KqidR7B7dVqUoWVXiO88fyZK+0/BmXSn0Oa5QiVbxX4YDJP7faDaj7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6AA5E339;
	Fri, 12 Apr 2024 03:35:08 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7444D3F7C5;
	Fri, 12 Apr 2024 03:34:37 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH 10/33] arm: realm: Add support for changing the state of memory
Date: Fri, 12 Apr 2024 11:33:45 +0100
Message-Id: <20240412103408.2706058-11-suzuki.poulose@arm.com>
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

For a Realm, the guest physical address (in reality the IPA/GPA of the VM)
has an associated state (Realm IPA State, RIPAS) which is one of :
   RIPAS_RAM
   RIPAS_EMPTY
   RIPAS_DESTROYED

The state of the physical address decides certain behaviors. e.g., any access
to a RIPAS_EMPTY PA will generate a Synchronous External Abort back to the Realm,
from the RMM.

All "PA" that represents RAM for the Realm, must be set to RIPAS_RAM before
an access is made. When the initial image (e.g., test, DTB) of a Realm is
loaded, the hypervisor/VMM can transition the state of the loaded "area" to
RIPAS_RAM. The rest of the "RAM" must be transitioned by the test payload
before any access is made.

Similarly, a Realm could set an "IPA" to RIPAS_EMPTY, when it is about to use
the "unprotected" alias of the IPA. This is a hint for the host to reclaim the
page from the protected "IPA.

RIPAS_DESTROYED indicates that the Host has destroyed a data granule at the IPA,
without the consent from the realm and is not reachable by a Realm action.

This patchs adds supporting helpers for setting the IPA state from Realm. These
will be used later for the Realm.

Co-developed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 lib/arm/asm/rsi.h   |  3 +++
 lib/arm/mmu.c       |  1 +
 lib/arm64/asm/rsi.h |  9 +++++++
 lib/arm64/rsi.c     | 63 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 76 insertions(+)

diff --git a/lib/arm/asm/rsi.h b/lib/arm/asm/rsi.h
index 5ff8d011..98e75303 100644
--- a/lib/arm/asm/rsi.h
+++ b/lib/arm/asm/rsi.h
@@ -14,5 +14,8 @@ static inline bool is_realm(void)
 }
 
 static inline void arm_rsi_init(void) {}
+static inline void arm_set_memory_protected(unsigned long va, size_t size) {}
+static inline void arm_set_memory_protected_safe(unsigned long va, size_t size) {}
+static inline void arm_set_memory_shared(unsigned long va, size_t size) {}
 
 #endif /* __ASMARM_RSI_H_ */
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 41a8304d..16ceffcc 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -13,6 +13,7 @@
 #include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/io.h>
+#include <asm/rsi.h>
 
 #include "alloc_page.h"
 #include "vmalloc.h"
diff --git a/lib/arm64/asm/rsi.h b/lib/arm64/asm/rsi.h
index 37103210..0b726684 100644
--- a/lib/arm64/asm/rsi.h
+++ b/lib/arm64/asm/rsi.h
@@ -34,4 +34,13 @@ static inline bool is_realm(void)
 	return rsi_present;
 }
 
+enum ripas_t {
+	RIPAS_EMPTY,
+	RIPAS_RAM,
+};
+
+void arm_set_memory_protected(unsigned long va, size_t size);
+void arm_set_memory_protected_safe(unsigned long va, size_t size);
+void arm_set_memory_shared(unsigned long va, size_t size);
+
 #endif /* __ASMARM64_RSI_H_ */
diff --git a/lib/arm64/rsi.c b/lib/arm64/rsi.c
index c4560866..e58d9660 100644
--- a/lib/arm64/rsi.c
+++ b/lib/arm64/rsi.c
@@ -71,3 +71,66 @@ void arm_rsi_init(void)
 	/* Set the upper bit of the IPA as the NS_SHARED pte attribute */
 	prot_ns_shared = (1UL << phys_mask_shift);
 }
+
+static unsigned rsi_set_addr_range_state(unsigned long start, unsigned long end,
+					 enum ripas_t state, unsigned int flags,
+					 unsigned long *top)
+{
+	struct smccc_result res;
+
+	rsi_invoke(SMC_RSI_IPA_STATE_SET, start, end, state, flags,
+		   0, 0, 0, 0, 0, 0, 0, &res);
+	*top = res.r1;
+	return res.r0;
+}
+
+static void arm_set_memory_state(unsigned long start,
+				 unsigned long size,
+				 unsigned int ripas,
+				 unsigned int flags)
+{
+	int ret;
+	unsigned long end, top;
+	unsigned long old_start = start;
+
+	if (!is_realm())
+		return;
+
+	start = ALIGN_DOWN(start, RSI_GRANULE_SIZE);
+	if (start != old_start)
+		size += old_start - start;
+	end = ALIGN(start + size, RSI_GRANULE_SIZE);
+	while (start != end) {
+		ret = rsi_set_addr_range_state(start, end, ripas, flags, &top);
+		assert(!ret);
+		assert(top <= end);
+		start = top;
+	}
+}
+
+/*
+ * Convert the IPA state of the given range to RIPAS_RAM, ignoring the
+ * fact that the host could have destroyed the contents and we don't
+ * rely on the previous state of the contents.
+ */
+void arm_set_memory_protected(unsigned long start, unsigned long size)
+{
+	arm_set_memory_state(start, size, RIPAS_RAM, RSI_CHANGE_DESTROYED);
+}
+
+/*
+ * Convert the IPA state of the given range to RSI_RAM, ensuring that the
+ * host has not destroyed any of the contents in the IPA range. Useful in
+ * converting a range of addresses where some of the IPA may already be in
+ * RSI_RAM state (e.g., images loaded at boot) and we want to make sure the
+ * host hasn't modified (by destroying them) the contents.
+ */
+void arm_set_memory_protected_safe(unsigned long start, unsigned long size)
+{
+	arm_set_memory_state(start, size, RIPAS_RAM, RSI_NO_CHANGE_DESTROYED);
+}
+
+void arm_set_memory_shared(unsigned long start, unsigned long size)
+{
+	arm_set_memory_state(start, size, RIPAS_EMPTY, RSI_CHANGE_DESTROYED);
+}
-- 
2.34.1


