Return-Path: <kvm+bounces-15568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC8DA8AD58C
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 22:04:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73514283092
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 20:04:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE1DF156C6E;
	Mon, 22 Apr 2024 20:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xxmB4jqx"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1A2156C51
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 20:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713816161; cv=none; b=ALhpFhiZ05QrnK4J5KPOaoYHy6MkQOc1eyC2UjIavRRopXuc5B3gDS448CfQ2kAn0ZWs0eMJDpB4BM7/tlFqUqhxvx2hGlkwF5zURsMJo0IYtfFwuQl82AR935UcLS6lf+b8cEbHochL+Q5UJ3KgoCpVB5+1Ka5AmwAp+Uxirz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713816161; c=relaxed/simple;
	bh=pCcBOMeaC2Uqpr8olIZoAWP/v8mURQIrYVkWQDwXNAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qp1e0WpuhG3nso5+y1cUrQRC+/u4Dx6ehKj1USbWqyI7nziY8e4AEQmpaCyVRQ9jFwBfjK1+Wd3Wb57VBxJRvq911QLfJrSrS7cQ01ZM+LecBnA4OV74hrPxu4Mkzozo2Vq3HO0067I0XocgKE/BfftNQFu24GAGne1m5I+j5NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xxmB4jqx; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713816157;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BSccpoZiRET6HzjyV/P2nRuMHuMBvr4PDdY1QDEwMiE=;
	b=xxmB4jqx7BXBi32Q4ieIAXcvEQTrVCd/pjsZF3tPeYrfu1eh1P9vGCn/ugNbHN99ulH1/a
	VmI52iX42uFo1ZBaRezjjeiLgBEM33V13bFIZlwsqQ3arXCuNAleORHXYXY0tBj1Jzx44K
	VUjMNVzBHBOzg9G6l282li1KAT9dn1E=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Colton Lewis <coltonlewis@google.com>
Subject: [PATCH v3 14/19] KVM: selftests: Standardise layout of GIC frames
Date: Mon, 22 Apr 2024 20:01:53 +0000
Message-ID: <20240422200158.2606761-15-oliver.upton@linux.dev>
In-Reply-To: <20240422200158.2606761-1-oliver.upton@linux.dev>
References: <20240422200158.2606761-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

It would appear that all of the selftests are using the same exact
layout for the GIC frames. Fold this back into the library
implementation to avoid defining magic values all over the selftests.

This is an extension of Colton's change, ripping out parameterization of
from the library internals in addition to the public interfaces.

Co-developed-by: Colton Lewis <coltonlewis@google.com>
Signed-off-by: Colton Lewis <coltonlewis@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../selftests/kvm/aarch64/arch_timer.c        |  8 +--
 .../testing/selftests/kvm/aarch64/vgic_irq.c  | 11 +---
 .../kvm/aarch64/vpmu_counter_access.c         |  6 +-
 .../selftests/kvm/dirty_log_perf_test.c       |  5 +-
 .../selftests/kvm/include/aarch64/gic.h       | 12 +++-
 .../selftests/kvm/include/aarch64/vgic.h      |  3 +-
 tools/testing/selftests/kvm/lib/aarch64/gic.c | 18 +++---
 .../selftests/kvm/lib/aarch64/gic_private.h   |  4 +-
 .../selftests/kvm/lib/aarch64/gic_v3.c        | 62 +++++++++----------
 .../testing/selftests/kvm/lib/aarch64/vgic.c  | 18 +++---
 10 files changed, 62 insertions(+), 85 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 4eaba83cdcf3..89be559cdb7e 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -14,9 +14,6 @@
 #include "timer_test.h"
 #include "vgic.h"
 
-#define GICD_BASE_GPA			0x8000000ULL
-#define GICR_BASE_GPA			0x80A0000ULL
-
 enum guest_stage {
 	GUEST_STAGE_VTIMER_CVAL = 1,
 	GUEST_STAGE_VTIMER_TVAL,
@@ -149,8 +146,7 @@ static void guest_code(void)
 
 	local_irq_disable();
 
-	gic_init(GIC_V3, test_args.nr_vcpus,
-		(void *)GICD_BASE_GPA, (void *)GICR_BASE_GPA);
+	gic_init(GIC_V3, test_args.nr_vcpus);
 
 	timer_set_ctl(VIRTUAL, CTL_IMASK);
 	timer_set_ctl(PHYSICAL, CTL_IMASK);
@@ -209,7 +205,7 @@ struct kvm_vm *test_vm_create(void)
 		vcpu_init_descriptor_tables(vcpus[i]);
 
 	test_init_timer_irq(vm);
-	gic_fd = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
+	gic_fd = vgic_v3_setup(vm, nr_vcpus, 64);
 	__TEST_REQUIRE(gic_fd >= 0, "Failed to create vgic-v3");
 
 	/* Make all the test's cmdline args visible to the guest */
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index d61a6302f467..a51dbd2a5f84 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -19,9 +19,6 @@
 #include "gic_v3.h"
 #include "vgic.h"
 
-#define GICD_BASE_GPA		0x08000000ULL
-#define GICR_BASE_GPA		0x080A0000ULL
-
 /*
  * Stores the user specified args; it's passed to the guest and to every test
  * function.
@@ -49,9 +46,6 @@ struct test_args {
 #define IRQ_DEFAULT_PRIO	(LOWEST_PRIO - 1)
 #define IRQ_DEFAULT_PRIO_REG	(IRQ_DEFAULT_PRIO << KVM_PRIO_SHIFT) /* 0xf0 */
 
-static void *dist = (void *)GICD_BASE_GPA;
-static void *redist = (void *)GICR_BASE_GPA;
-
 /*
  * The kvm_inject_* utilities are used by the guest to ask the host to inject
  * interrupts (e.g., using the KVM_IRQ_LINE ioctl).
@@ -478,7 +472,7 @@ static void guest_code(struct test_args *args)
 	bool level_sensitive = args->level_sensitive;
 	struct kvm_inject_desc *f, *inject_fns;
 
-	gic_init(GIC_V3, 1, dist, redist);
+	gic_init(GIC_V3, 1);
 
 	for (i = 0; i < nr_irqs; i++)
 		gic_irq_enable(i);
@@ -764,8 +758,7 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
 	memcpy(addr_gva2hva(vm, args_gva), &args, sizeof(args));
 	vcpu_args_set(vcpu, 1, args_gva);
 
-	gic_fd = vgic_v3_setup(vm, 1, nr_irqs,
-			GICD_BASE_GPA, GICR_BASE_GPA);
+	gic_fd = vgic_v3_setup(vm, 1, nr_irqs);
 	__TEST_REQUIRE(gic_fd >= 0, "Failed to create vgic-v3, skipping");
 
 	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT,
diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
index f2fb0e3f14bc..d31b9f64ba14 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -404,9 +404,6 @@ static void guest_code(uint64_t expected_pmcr_n)
 	GUEST_DONE();
 }
 
-#define GICD_BASE_GPA	0x8000000ULL
-#define GICR_BASE_GPA	0x80A0000ULL
-
 /* Create a VM that has one vCPU with PMUv3 configured. */
 static void create_vpmu_vm(void *guest_code)
 {
@@ -438,8 +435,7 @@ static void create_vpmu_vm(void *guest_code)
 	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
 	vpmu_vm.vcpu = aarch64_vcpu_add(vpmu_vm.vm, 0, &init, guest_code);
 	vcpu_init_descriptor_tables(vpmu_vm.vcpu);
-	vpmu_vm.gic_fd = vgic_v3_setup(vpmu_vm.vm, 1, 64,
-					GICD_BASE_GPA, GICR_BASE_GPA);
+	vpmu_vm.gic_fd = vgic_v3_setup(vpmu_vm.vm, 1, 64);
 	__TEST_REQUIRE(vpmu_vm.gic_fd >= 0,
 		       "Failed to create vgic-v3, skipping");
 
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 504f6fe980e8..61535c4f3405 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -22,9 +22,6 @@
 #ifdef __aarch64__
 #include "aarch64/vgic.h"
 
-#define GICD_BASE_GPA			0x8000000ULL
-#define GICR_BASE_GPA			0x80A0000ULL
-
 static int gic_fd;
 
 static void arch_setup_vm(struct kvm_vm *vm, unsigned int nr_vcpus)
@@ -33,7 +30,7 @@ static void arch_setup_vm(struct kvm_vm *vm, unsigned int nr_vcpus)
 	 * The test can still run even if hardware does not support GICv3, as it
 	 * is only an optimization to reduce guest exits.
 	 */
-	gic_fd = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
+	gic_fd = vgic_v3_setup(vm, nr_vcpus, 64);
 }
 
 static void arch_cleanup_vm(struct kvm_vm *vm)
diff --git a/tools/testing/selftests/kvm/include/aarch64/gic.h b/tools/testing/selftests/kvm/include/aarch64/gic.h
index b217ea17cac5..53617b3f52cf 100644
--- a/tools/testing/selftests/kvm/include/aarch64/gic.h
+++ b/tools/testing/selftests/kvm/include/aarch64/gic.h
@@ -6,11 +6,20 @@
 #ifndef SELFTEST_KVM_GIC_H
 #define SELFTEST_KVM_GIC_H
 
+#include <asm/kvm.h>
+
 enum gic_type {
 	GIC_V3,
 	GIC_TYPE_MAX,
 };
 
+#define GICD_BASE_GPA		0x8000000ULL
+#define GICR_BASE_GPA		(GICD_BASE_GPA + KVM_VGIC_V3_DIST_SIZE)
+
+/* The GIC is identity-mapped into the guest at the time of setup. */
+#define GICD_BASE_GVA		((volatile void *)GICD_BASE_GPA)
+#define GICR_BASE_GVA		((volatile void *)GICR_BASE_GPA)
+
 #define MIN_SGI			0
 #define MIN_PPI			16
 #define MIN_SPI			32
@@ -21,8 +30,7 @@ enum gic_type {
 #define INTID_IS_PPI(intid)	(MIN_PPI <= (intid) && (intid) < MIN_SPI)
 #define INTID_IS_SPI(intid)	(MIN_SPI <= (intid) && (intid) <= MAX_SPI)
 
-void gic_init(enum gic_type type, unsigned int nr_cpus,
-		void *dist_base, void *redist_base);
+void gic_init(enum gic_type type, unsigned int nr_cpus);
 void gic_irq_enable(unsigned int intid);
 void gic_irq_disable(unsigned int intid);
 unsigned int gic_get_and_ack_irq(void);
diff --git a/tools/testing/selftests/kvm/include/aarch64/vgic.h b/tools/testing/selftests/kvm/include/aarch64/vgic.h
index 0ac6f05c63f9..ce19aa0a8360 100644
--- a/tools/testing/selftests/kvm/include/aarch64/vgic.h
+++ b/tools/testing/selftests/kvm/include/aarch64/vgic.h
@@ -16,8 +16,7 @@
 	((uint64_t)(flags) << 12) | \
 	index)
 
-int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs,
-		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa);
+int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs);
 
 #define VGIC_MAX_RESERVED	1023
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic.c b/tools/testing/selftests/kvm/lib/aarch64/gic.c
index 55668631d546..7abbf8866512 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic.c
@@ -17,13 +17,12 @@
 static const struct gic_common_ops *gic_common_ops;
 static struct spinlock gic_lock;
 
-static void gic_cpu_init(unsigned int cpu, void *redist_base)
+static void gic_cpu_init(unsigned int cpu)
 {
-	gic_common_ops->gic_cpu_init(cpu, redist_base);
+	gic_common_ops->gic_cpu_init(cpu);
 }
 
-static void
-gic_dist_init(enum gic_type type, unsigned int nr_cpus, void *dist_base)
+static void gic_dist_init(enum gic_type type, unsigned int nr_cpus)
 {
 	const struct gic_common_ops *gic_ops = NULL;
 
@@ -40,7 +39,7 @@ gic_dist_init(enum gic_type type, unsigned int nr_cpus, void *dist_base)
 
 	GUEST_ASSERT(gic_ops);
 
-	gic_ops->gic_init(nr_cpus, dist_base);
+	gic_ops->gic_init(nr_cpus);
 	gic_common_ops = gic_ops;
 
 	/* Make sure that the initialized data is visible to all the vCPUs */
@@ -49,18 +48,15 @@ gic_dist_init(enum gic_type type, unsigned int nr_cpus, void *dist_base)
 	spin_unlock(&gic_lock);
 }
 
-void gic_init(enum gic_type type, unsigned int nr_cpus,
-		void *dist_base, void *redist_base)
+void gic_init(enum gic_type type, unsigned int nr_cpus)
 {
 	uint32_t cpu = guest_get_vcpuid();
 
 	GUEST_ASSERT(type < GIC_TYPE_MAX);
-	GUEST_ASSERT(dist_base);
-	GUEST_ASSERT(redist_base);
 	GUEST_ASSERT(nr_cpus);
 
-	gic_dist_init(type, nr_cpus, dist_base);
-	gic_cpu_init(cpu, redist_base);
+	gic_dist_init(type, nr_cpus);
+	gic_cpu_init(cpu);
 }
 
 void gic_irq_enable(unsigned int intid)
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_private.h b/tools/testing/selftests/kvm/lib/aarch64/gic_private.h
index 75d07313c893..d24e9ecc96c6 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic_private.h
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic_private.h
@@ -8,8 +8,8 @@
 #define SELFTEST_KVM_GIC_PRIVATE_H
 
 struct gic_common_ops {
-	void (*gic_init)(unsigned int nr_cpus, void *dist_base);
-	void (*gic_cpu_init)(unsigned int cpu, void *redist_base);
+	void (*gic_init)(unsigned int nr_cpus);
+	void (*gic_cpu_init)(unsigned int cpu);
 	void (*gic_irq_enable)(unsigned int intid);
 	void (*gic_irq_disable)(unsigned int intid);
 	uint64_t (*gic_read_iar)(void);
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
index cd8f0e209599..515335179045 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
@@ -24,8 +24,6 @@
 #define ICC_PMR_DEF_PRIO		0xf0
 
 struct gicv3_data {
-	void *dist_base;
-	void *redist_base[GICV3_MAX_CPUS];
 	unsigned int nr_cpus;
 	unsigned int nr_spis;
 };
@@ -46,17 +44,23 @@ static void gicv3_gicd_wait_for_rwp(void)
 {
 	unsigned int count = 100000; /* 1s */
 
-	while (readl(gicv3_data.dist_base + GICD_CTLR) & GICD_CTLR_RWP) {
+	while (readl(GICD_BASE_GVA + GICD_CTLR) & GICD_CTLR_RWP) {
 		GUEST_ASSERT(count--);
 		udelay(10);
 	}
 }
 
-static void gicv3_gicr_wait_for_rwp(void *redist_base)
+static inline volatile void *gicr_base_cpu(uint32_t cpu)
+{
+	/* Align all the redistributors sequentially */
+	return GICR_BASE_GVA + cpu * SZ_64K * 2;
+}
+
+static void gicv3_gicr_wait_for_rwp(uint32_t cpu)
 {
 	unsigned int count = 100000; /* 1s */
 
-	while (readl(redist_base + GICR_CTLR) & GICR_CTLR_RWP) {
+	while (readl(gicr_base_cpu(cpu) + GICR_CTLR) & GICR_CTLR_RWP) {
 		GUEST_ASSERT(count--);
 		udelay(10);
 	}
@@ -67,7 +71,7 @@ static void gicv3_wait_for_rwp(uint32_t cpu_or_dist)
 	if (cpu_or_dist & DIST_BIT)
 		gicv3_gicd_wait_for_rwp();
 	else
-		gicv3_gicr_wait_for_rwp(gicv3_data.redist_base[cpu_or_dist]);
+		gicv3_gicr_wait_for_rwp(cpu_or_dist);
 }
 
 static enum gicv3_intid_range get_intid_range(unsigned int intid)
@@ -127,15 +131,15 @@ static void gicv3_set_eoi_split(bool split)
 
 uint32_t gicv3_reg_readl(uint32_t cpu_or_dist, uint64_t offset)
 {
-	void *base = cpu_or_dist & DIST_BIT ? gicv3_data.dist_base
-		: sgi_base_from_redist(gicv3_data.redist_base[cpu_or_dist]);
+	volatile void *base = cpu_or_dist & DIST_BIT ? GICD_BASE_GVA
+			: sgi_base_from_redist(gicr_base_cpu(cpu_or_dist));
 	return readl(base + offset);
 }
 
 void gicv3_reg_writel(uint32_t cpu_or_dist, uint64_t offset, uint32_t reg_val)
 {
-	void *base = cpu_or_dist & DIST_BIT ? gicv3_data.dist_base
-		: sgi_base_from_redist(gicv3_data.redist_base[cpu_or_dist]);
+	volatile void *base = cpu_or_dist & DIST_BIT ? GICD_BASE_GVA
+			: sgi_base_from_redist(gicr_base_cpu(cpu_or_dist));
 	writel(reg_val, base + offset);
 }
 
@@ -274,7 +278,7 @@ static bool gicv3_irq_get_pending(uint32_t intid)
 	return gicv3_read_reg(intid, GICD_ISPENDR, 32, 1);
 }
 
-static void gicv3_enable_redist(void *redist_base)
+static void gicv3_enable_redist(volatile void *redist_base)
 {
 	uint32_t val = readl(redist_base + GICR_WAKER);
 	unsigned int count = 100000; /* 1s */
@@ -289,21 +293,15 @@ static void gicv3_enable_redist(void *redist_base)
 	}
 }
 
-static inline void *gicr_base_cpu(void *redist_base, uint32_t cpu)
+static void gicv3_cpu_init(unsigned int cpu)
 {
-	/* Align all the redistributors sequentially */
-	return redist_base + cpu * SZ_64K * 2;
-}
-
-static void gicv3_cpu_init(unsigned int cpu, void *redist_base)
-{
-	void *sgi_base;
+	volatile void *sgi_base;
 	unsigned int i;
-	void *redist_base_cpu;
+	volatile void *redist_base_cpu;
 
 	GUEST_ASSERT(cpu < gicv3_data.nr_cpus);
 
-	redist_base_cpu = gicr_base_cpu(redist_base, cpu);
+	redist_base_cpu = gicr_base_cpu(cpu);
 	sgi_base = sgi_base_from_redist(redist_base_cpu);
 
 	gicv3_enable_redist(redist_base_cpu);
@@ -321,7 +319,7 @@ static void gicv3_cpu_init(unsigned int cpu, void *redist_base)
 		writel(GICD_INT_DEF_PRI_X4,
 				sgi_base + GICR_IPRIORITYR0 + i);
 
-	gicv3_gicr_wait_for_rwp(redist_base_cpu);
+	gicv3_gicr_wait_for_rwp(cpu);
 
 	/* Enable the GIC system register (ICC_*) access */
 	write_sysreg_s(read_sysreg_s(SYS_ICC_SRE_EL1) | ICC_SRE_EL1_SRE,
@@ -332,17 +330,14 @@ static void gicv3_cpu_init(unsigned int cpu, void *redist_base)
 
 	/* Enable non-secure Group-1 interrupts */
 	write_sysreg_s(ICC_IGRPEN1_EL1_MASK, SYS_ICC_IGRPEN1_EL1);
-
-	gicv3_data.redist_base[cpu] = redist_base_cpu;
 }
 
 static void gicv3_dist_init(void)
 {
-	void *dist_base = gicv3_data.dist_base;
 	unsigned int i;
 
 	/* Disable the distributor until we set things up */
-	writel(0, dist_base + GICD_CTLR);
+	writel(0, GICD_BASE_GVA + GICD_CTLR);
 	gicv3_gicd_wait_for_rwp();
 
 	/*
@@ -350,33 +345,32 @@ static void gicv3_dist_init(void)
 	 * Also, deactivate and disable them.
 	 */
 	for (i = 32; i < gicv3_data.nr_spis; i += 32) {
-		writel(~0, dist_base + GICD_IGROUPR + i / 8);
-		writel(~0, dist_base + GICD_ICACTIVER + i / 8);
-		writel(~0, dist_base + GICD_ICENABLER + i / 8);
+		writel(~0, GICD_BASE_GVA + GICD_IGROUPR + i / 8);
+		writel(~0, GICD_BASE_GVA + GICD_ICACTIVER + i / 8);
+		writel(~0, GICD_BASE_GVA + GICD_ICENABLER + i / 8);
 	}
 
 	/* Set a default priority for all the SPIs */
 	for (i = 32; i < gicv3_data.nr_spis; i += 4)
 		writel(GICD_INT_DEF_PRI_X4,
-				dist_base + GICD_IPRIORITYR + i);
+				GICD_BASE_GVA + GICD_IPRIORITYR + i);
 
 	/* Wait for the settings to sync-in */
 	gicv3_gicd_wait_for_rwp();
 
 	/* Finally, enable the distributor globally with ARE */
 	writel(GICD_CTLR_ARE_NS | GICD_CTLR_ENABLE_G1A |
-			GICD_CTLR_ENABLE_G1, dist_base + GICD_CTLR);
+			GICD_CTLR_ENABLE_G1, GICD_BASE_GVA + GICD_CTLR);
 	gicv3_gicd_wait_for_rwp();
 }
 
-static void gicv3_init(unsigned int nr_cpus, void *dist_base)
+static void gicv3_init(unsigned int nr_cpus)
 {
 	GUEST_ASSERT(nr_cpus <= GICV3_MAX_CPUS);
 
 	gicv3_data.nr_cpus = nr_cpus;
-	gicv3_data.dist_base = dist_base;
 	gicv3_data.nr_spis = GICD_TYPER_SPIS(
-				readl(gicv3_data.dist_base + GICD_TYPER));
+				readl(GICD_BASE_GVA + GICD_TYPER));
 	if (gicv3_data.nr_spis > 1020)
 		gicv3_data.nr_spis = 1020;
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index 184378d593e9..7738fdb0cea1 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -19,8 +19,6 @@
  * Input args:
  *	vm - KVM VM
  *	nr_vcpus - Number of vCPUs supported by this VM
- *	gicd_base_gpa - Guest Physical Address of the Distributor region
- *	gicr_base_gpa - Guest Physical Address of the Redistributor region
  *
  * Output args: None
  *
@@ -30,11 +28,10 @@
  * redistributor regions of the guest. Since it depends on the number of
  * vCPUs for the VM, it must be called after all the vCPUs have been created.
  */
-int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs,
-		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa)
+int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs)
 {
 	int gic_fd;
-	uint64_t redist_attr;
+	uint64_t attr;
 	struct list_head *iter;
 	unsigned int nr_gic_pages, nr_vcpus_created = 0;
 
@@ -60,18 +57,19 @@ int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs,
 	kvm_device_attr_set(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
 			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
 
+	attr = GICD_BASE_GPA;
 	kvm_device_attr_set(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			    KVM_VGIC_V3_ADDR_TYPE_DIST, &gicd_base_gpa);
+			    KVM_VGIC_V3_ADDR_TYPE_DIST, &attr);
 	nr_gic_pages = vm_calc_num_guest_pages(vm->mode, KVM_VGIC_V3_DIST_SIZE);
-	virt_map(vm, gicd_base_gpa, gicd_base_gpa,  nr_gic_pages);
+	virt_map(vm, GICD_BASE_GPA, GICD_BASE_GPA, nr_gic_pages);
 
 	/* Redistributor setup */
-	redist_attr = REDIST_REGION_ATTR_ADDR(nr_vcpus, gicr_base_gpa, 0, 0);
+	attr = REDIST_REGION_ATTR_ADDR(nr_vcpus, GICR_BASE_GPA, 0, 0);
 	kvm_device_attr_set(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &redist_attr);
+			    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &attr);
 	nr_gic_pages = vm_calc_num_guest_pages(vm->mode,
 						KVM_VGIC_V3_REDIST_SIZE * nr_vcpus);
-	virt_map(vm, gicr_base_gpa, gicr_base_gpa,  nr_gic_pages);
+	virt_map(vm, GICR_BASE_GPA, GICR_BASE_GPA, nr_gic_pages);
 
 	kvm_device_attr_set(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
 			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
-- 
2.44.0.769.g3c40516874-goog


