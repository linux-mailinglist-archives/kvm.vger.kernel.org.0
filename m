Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C6A44A4D4
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 03:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241425AbhKICmE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 21:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238491AbhKICmD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 21:42:03 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2240C061570
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 18:39:18 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id q9-20020ad45749000000b003bdeb0612c5so10616298qvx.8
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 18:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hAgPV3xFyyvPsO0tGe3b/FMKmByO5nfhAdx996Q4woA=;
        b=J1wu4iwXjHJfHIDEyBesp37qGjNRGqslkAdb3lWsA1VUH4QWX6ioijCBorRe8lsaD5
         KgYuQ8vO8gFdVEYZ4ti/biaEBy+zhkaf/TrlPDtlqBIudlmQjS7NQ2cxj6n4TEhjc7tp
         xi74xZD4sgSQvvNZHZ9wMEqZLSQQI7gzRor1azpzQzMXCsHDklG6A0X6a9E/uSm/a1De
         /cnwgOkzJ1gugbSuXcnvkIRHN88cQEl5sQJ9IgvCl9MpEI3EsBumZtKPAZWwfOW/u13j
         pwXAXzG6hDmpudh7+Cq0NNXq4YIKg5s8/Z7WoHotpTP0At9FnC1kRmZsB451jgytjuP2
         mWnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hAgPV3xFyyvPsO0tGe3b/FMKmByO5nfhAdx996Q4woA=;
        b=VmlkmEXVSQHflQLGNhItJyIVZzddXxNqAHojWVVNJUgMPmStH7ORk748oKr+GnDsxD
         wnQ0Aywr0gr+jO7IqkVUs8POoNJa4txpFUNJwk2v1Kvbvjko8RvxZxQgcIB5O8f6P3qV
         6KUN2nEpyVyYB3bS6rcrlQvLIj4gYf8/cak6CMCm/TtGyHgx48pyicCz2zBcTcIAE340
         c4D4LWLBojTY4ZFbca9bQ9xLq/HsGvsxm1HQxnf6h27Q5lcdDGvjnd6YL85NPM7a5Y4s
         SayNw3qhFrEIoBK+On2FhxEzaX0jlu7UqwuhIe5mFqCt2rNJYJY1Ls3QHSY2xe5S1HHM
         I4gw==
X-Gm-Message-State: AOAM530LGs/VCwZybMCI81I9BbrvoQFe+RtHI6SXWQHEsGH32RB3sLe9
        zCGDMU+bNXI99BzQuaS4AvsoAHRumWOC2XPpsTSuC+FMK59IVOhXM23JWWnEiCnHnk22KLWBu8Y
        l30hcf+JI/O2zDhGRIVvLcuv1/Wlx1EqEv7I+fIW1R1q5Kl2M2MzymEXFFealhts=
X-Google-Smtp-Source: ABdhPJzshOLNQDU11XH2FvYs2Wq6hLMDiKnHEcAtWCt1tloFz/p13cI0EDFuEO562W0HLuOwPCVqDUFw0N2oWw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:ac8:58c5:: with SMTP id
 u5mr4665298qta.199.1636425557761; Mon, 08 Nov 2021 18:39:17 -0800 (PST)
Date:   Mon,  8 Nov 2021 18:38:52 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 03/17] KVM: selftests: aarch64: add GICv3 register accessor
 library functions
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add library functions for accessing GICv3 registers: DIR, PMR, CTLR,
ISACTIVER, ISPENDR.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/aarch64/gic.h       | 16 ++++
 .../selftests/kvm/include/aarch64/gic_v3.h    | 12 +++
 tools/testing/selftests/kvm/lib/aarch64/gic.c | 66 ++++++++++++++
 .../selftests/kvm/lib/aarch64/gic_private.h   | 11 +++
 .../selftests/kvm/lib/aarch64/gic_v3.c        | 90 +++++++++++++++++--
 5 files changed, 189 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/gic.h b/tools/testing/selftests/kvm/include/aarch64/gic.h
index 85dd1e53048e..c932cf3d0771 100644
--- a/tools/testing/selftests/kvm/include/aarch64/gic.h
+++ b/tools/testing/selftests/kvm/include/aarch64/gic.h
@@ -17,5 +17,21 @@ void gic_irq_enable(unsigned int intid);
 void gic_irq_disable(unsigned int intid);
 unsigned int gic_get_and_ack_irq(void);
 void gic_set_eoi(unsigned int intid);
+void gic_set_dir(unsigned int intid);
+
+/*
+ * Sets the EOI mode. When split is false, EOI just drops the priority. When
+ * split is true, EOI drops the priority and deactivates the interrupt.
+ */
+void gic_set_eoi_split(bool split);
+void gic_set_priority_mask(uint64_t mask);
+void gic_set_priority(uint32_t intid, uint32_t prio);
+void gic_irq_set_active(unsigned int intid);
+void gic_irq_clear_active(unsigned int intid);
+bool gic_irq_get_active(unsigned int intid);
+void gic_irq_set_pending(unsigned int intid);
+void gic_irq_clear_pending(unsigned int intid);
+bool gic_irq_get_pending(unsigned int intid);
+void gic_irq_set_config(unsigned int intid, bool is_edge);
 
 #endif /* SELFTEST_KVM_GIC_H */
diff --git a/tools/testing/selftests/kvm/include/aarch64/gic_v3.h b/tools/testing/selftests/kvm/include/aarch64/gic_v3.h
index b51536d469a6..ba0886e8a2bb 100644
--- a/tools/testing/selftests/kvm/include/aarch64/gic_v3.h
+++ b/tools/testing/selftests/kvm/include/aarch64/gic_v3.h
@@ -16,8 +16,12 @@
 #define GICD_IGROUPR			0x0080
 #define GICD_ISENABLER			0x0100
 #define GICD_ICENABLER			0x0180
+#define GICD_ISPENDR			0x0200
+#define GICD_ICPENDR			0x0280
 #define GICD_ICACTIVER			0x0380
+#define GICD_ISACTIVER			0x0300
 #define GICD_IPRIORITYR			0x0400
+#define GICD_ICFGR			0x0C00
 
 /*
  * The assumption is that the guest runs in a non-secure mode.
@@ -49,16 +53,24 @@
 #define GICR_IGROUPR0			GICD_IGROUPR
 #define GICR_ISENABLER0			GICD_ISENABLER
 #define GICR_ICENABLER0			GICD_ICENABLER
+#define GICR_ISPENDR0			GICD_ISPENDR
+#define GICR_ISACTIVER0			GICD_ISACTIVER
 #define GICR_ICACTIVER0			GICD_ICACTIVER
+#define GICR_ICENABLER			GICD_ICENABLER
+#define GICR_ICACTIVER			GICD_ICACTIVER
 #define GICR_IPRIORITYR0		GICD_IPRIORITYR
 
 /* CPU interface registers */
 #define SYS_ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
 #define SYS_ICC_IAR1_EL1		sys_reg(3, 0, 12, 12, 0)
 #define SYS_ICC_EOIR1_EL1		sys_reg(3, 0, 12, 12, 1)
+#define SYS_ICC_DIR_EL1			sys_reg(3, 0, 12, 11, 1)
+#define SYS_ICC_CTLR_EL1		sys_reg(3, 0, 12, 12, 4)
 #define SYS_ICC_SRE_EL1			sys_reg(3, 0, 12, 12, 5)
 #define SYS_ICC_GRPEN1_EL1		sys_reg(3, 0, 12, 12, 7)
 
+#define SYS_ICV_AP1R0_EL1		sys_reg(3, 0, 12, 9, 0)
+
 #define ICC_PMR_DEF_PRIO		0xf0
 
 #define ICC_SRE_EL1_SRE			(1U << 0)
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic.c b/tools/testing/selftests/kvm/lib/aarch64/gic.c
index fff4fc27504d..55668631d546 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic.c
@@ -93,3 +93,69 @@ void gic_set_eoi(unsigned int intid)
 	GUEST_ASSERT(gic_common_ops);
 	gic_common_ops->gic_write_eoir(intid);
 }
+
+void gic_set_dir(unsigned int intid)
+{
+	GUEST_ASSERT(gic_common_ops);
+	gic_common_ops->gic_write_dir(intid);
+}
+
+void gic_set_eoi_split(bool split)
+{
+	GUEST_ASSERT(gic_common_ops);
+	gic_common_ops->gic_set_eoi_split(split);
+}
+
+void gic_set_priority_mask(uint64_t pmr)
+{
+	GUEST_ASSERT(gic_common_ops);
+	gic_common_ops->gic_set_priority_mask(pmr);
+}
+
+void gic_set_priority(unsigned int intid, unsigned int prio)
+{
+	GUEST_ASSERT(gic_common_ops);
+	gic_common_ops->gic_set_priority(intid, prio);
+}
+
+void gic_irq_set_active(unsigned int intid)
+{
+	GUEST_ASSERT(gic_common_ops);
+	gic_common_ops->gic_irq_set_active(intid);
+}
+
+void gic_irq_clear_active(unsigned int intid)
+{
+	GUEST_ASSERT(gic_common_ops);
+	gic_common_ops->gic_irq_clear_active(intid);
+}
+
+bool gic_irq_get_active(unsigned int intid)
+{
+	GUEST_ASSERT(gic_common_ops);
+	return gic_common_ops->gic_irq_get_active(intid);
+}
+
+void gic_irq_set_pending(unsigned int intid)
+{
+	GUEST_ASSERT(gic_common_ops);
+	gic_common_ops->gic_irq_set_pending(intid);
+}
+
+void gic_irq_clear_pending(unsigned int intid)
+{
+	GUEST_ASSERT(gic_common_ops);
+	gic_common_ops->gic_irq_clear_pending(intid);
+}
+
+bool gic_irq_get_pending(unsigned int intid)
+{
+	GUEST_ASSERT(gic_common_ops);
+	return gic_common_ops->gic_irq_get_pending(intid);
+}
+
+void gic_irq_set_config(unsigned int intid, bool is_edge)
+{
+	GUEST_ASSERT(gic_common_ops);
+	gic_common_ops->gic_irq_set_config(intid, is_edge);
+}
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_private.h b/tools/testing/selftests/kvm/lib/aarch64/gic_private.h
index d81d739433dc..75d07313c893 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic_private.h
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic_private.h
@@ -14,6 +14,17 @@ struct gic_common_ops {
 	void (*gic_irq_disable)(unsigned int intid);
 	uint64_t (*gic_read_iar)(void);
 	void (*gic_write_eoir)(uint32_t irq);
+	void (*gic_write_dir)(uint32_t irq);
+	void (*gic_set_eoi_split)(bool split);
+	void (*gic_set_priority_mask)(uint64_t mask);
+	void (*gic_set_priority)(uint32_t intid, uint32_t prio);
+	void (*gic_irq_set_active)(uint32_t intid);
+	void (*gic_irq_clear_active)(uint32_t intid);
+	bool (*gic_irq_get_active)(uint32_t intid);
+	void (*gic_irq_set_pending)(uint32_t intid);
+	void (*gic_irq_clear_pending)(uint32_t intid);
+	bool (*gic_irq_get_pending)(uint32_t intid);
+	void (*gic_irq_set_config)(uint32_t intid, bool is_edge);
 };
 
 extern const struct gic_common_ops gicv3_ops;
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
index 00e944fd8148..00f613c0583c 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
@@ -90,6 +90,29 @@ static void gicv3_write_eoir(uint32_t irq)
 	isb();
 }
 
+static void gicv3_write_dir(uint32_t irq)
+{
+	write_sysreg_s(irq, SYS_ICC_DIR_EL1);
+	isb();
+}
+
+static void gicv3_set_priority_mask(uint64_t mask)
+{
+	write_sysreg_s(mask, SYS_ICC_PMR_EL1);
+}
+
+static void gicv3_set_eoi_split(bool split)
+{
+	uint32_t val;
+
+	/* All other fields are read-only, so no need to read CTLR first. In
+	 * fact, the kernel does the same.
+	 */
+	val = split ? (1U << 1) : 0;
+	write_sysreg_s(val, SYS_ICC_CTLR_EL1);
+	isb();
+}
+
 uint32_t gicv3_reg_readl(uint32_t cpu_or_dist, uint64_t offset)
 {
 	void *base = cpu_or_dist & DIST_BIT ? gicv3_data.dist_base
@@ -174,26 +197,70 @@ static uint32_t gicv3_read_reg(uint32_t intid, uint64_t offset,
 	return val;
 }
 
-static void gicv3_irq_enable(unsigned int intid)
+static void gicv3_set_priority(uint32_t intid, uint32_t prio)
+{
+	gicv3_write_reg(intid, GICD_IPRIORITYR, 32, 8, prio);
+}
+
+/* Sets the intid to be level-sensitive or edge-triggered. */
+static void gicv3_irq_set_config(uint32_t intid, bool is_edge)
+{
+	uint32_t val;
+
+	/* N/A for private interrupts. */
+	GUEST_ASSERT(get_intid_range(intid) == SPI_RANGE);
+	val = is_edge ? 2 : 0;
+	gicv3_write_reg(intid, GICD_ICFGR, 32, 2, val);
+}
+
+static void gicv3_irq_enable(uint32_t intid)
 {
 	bool is_spi = get_intid_range(intid) == SPI_RANGE;
-	unsigned int val = 1;
 	uint32_t cpu = guest_get_vcpuid();
 
-	gicv3_write_reg(intid, GICD_ISENABLER, 32, 1, val);
+	gicv3_write_reg(intid, GICD_ISENABLER, 32, 1, 1);
 	gicv3_wait_for_rwp(is_spi ? DIST_BIT : cpu);
 }
 
-static void gicv3_irq_disable(unsigned int intid)
+static void gicv3_irq_disable(uint32_t intid)
 {
 	bool is_spi = get_intid_range(intid) == SPI_RANGE;
-	uint32_t val = 1;
 	uint32_t cpu = guest_get_vcpuid();
 
-	gicv3_write_reg(intid, GICD_ICENABLER, 32, 1, val);
+	gicv3_write_reg(intid, GICD_ICENABLER, 32, 1, 1);
 	gicv3_wait_for_rwp(is_spi ? DIST_BIT : cpu);
 }
 
+static void gicv3_irq_set_active(uint32_t intid)
+{
+	gicv3_write_reg(intid, GICD_ISACTIVER, 32, 1, 1);
+}
+
+static void gicv3_irq_clear_active(uint32_t intid)
+{
+	gicv3_write_reg(intid, GICD_ICACTIVER, 32, 1, 1);
+}
+
+static bool gicv3_irq_get_active(uint32_t intid)
+{
+	return gicv3_read_reg(intid, GICD_ISACTIVER, 32, 1);
+}
+
+static void gicv3_irq_set_pending(uint32_t intid)
+{
+	gicv3_write_reg(intid, GICD_ISPENDR, 32, 1, 1);
+}
+
+static void gicv3_irq_clear_pending(uint32_t intid)
+{
+	gicv3_write_reg(intid, GICD_ICPENDR, 32, 1, 1);
+}
+
+static bool gicv3_irq_get_pending(uint32_t intid)
+{
+	return gicv3_read_reg(intid, GICD_ISPENDR, 32, 1);
+}
+
 static void gicv3_enable_redist(void *redist_base)
 {
 	uint32_t val = readl(redist_base + GICR_WAKER);
@@ -315,4 +382,15 @@ const struct gic_common_ops gicv3_ops = {
 	.gic_irq_disable = gicv3_irq_disable,
 	.gic_read_iar = gicv3_read_iar,
 	.gic_write_eoir = gicv3_write_eoir,
+	.gic_write_dir = gicv3_write_dir,
+	.gic_set_priority_mask = gicv3_set_priority_mask,
+	.gic_set_eoi_split = gicv3_set_eoi_split,
+	.gic_set_priority = gicv3_set_priority,
+	.gic_irq_set_active = gicv3_irq_set_active,
+	.gic_irq_clear_active = gicv3_irq_clear_active,
+	.gic_irq_get_active = gicv3_irq_get_active,
+	.gic_irq_set_pending = gicv3_irq_set_pending,
+	.gic_irq_clear_pending = gicv3_irq_clear_pending,
+	.gic_irq_get_pending = gicv3_irq_get_pending,
+	.gic_irq_set_config = gicv3_irq_set_config,
 };
-- 
2.34.0.rc0.344.g81b53c2807-goog

