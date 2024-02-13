Return-Path: <kvm+bounces-8612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 15FF2852CC3
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 10:45:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FA841F27F37
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 09:45:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06CFD2C696;
	Tue, 13 Feb 2024 09:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h3OoyDDi"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1154C2BB1A;
	Tue, 13 Feb 2024 09:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707817268; cv=none; b=J9qxUOSUJUxAcVy1c397NhiDXPrWlYodIO4xwwKVvg2INX2N/Dc8xckm261T/N7rs8zSOIEIw7ar+PrBiujWh6anfRXVwNi6Ay/v1o9cVjK2wQKbY5lrCrhrlZgRtpxzbO8pCfXKFXx2GvbAPs41Gt65ETCeZ8Aj0j4IIB3dHtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707817268; c=relaxed/simple;
	bh=8TVb02k9Dj6zPDEtr5f/OpqyZHmFQzODOugGavUF2U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DObUyRcYPzhsNLgea2YlB67Wek6y8B6l5q+Au3UOHZCX5SCHVFyn/bJDWmBLOHm4qULvUq2z2uxM8ACZCgDfhpigSwxG7DItx6wVvD3VoaWclGNaY0vmsNTASKwDPaSXZIwLOp+6xmCZzXnK1jgTYsehkfH9cfwh+Fkh/2Z4f04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h3OoyDDi; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707817264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VKRKz9PHINTeNQtF9BS6pYUMzjC2ZlxpnobRHX3hMdw=;
	b=h3OoyDDiD6QEuRgNK/4ALlVm7AbyYwtw6xXgvcY1h84XkSvJ5ttORg/x19CfKC82uRxpGU
	iWAlw7qAcbX0J/HTDI8c5ZaPiMmAt/ok7dgNqvsGUu8ut6tXzNGTqQaTjU41PQWohBHrBd
	8SRGANdavhihMcSEYBzhDdvhbsvSkEI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Colton Lewis <coltonlewis@google.com>
Subject: [PATCH v2 18/23] KVM: selftests: Standardise layout of GIC frames
Date: Tue, 13 Feb 2024 09:40:54 +0000
Message-ID: <20240213094054.3961627-1-oliver.upton@linux.dev>
In-Reply-To: <20240213093250.3960069-1-oliver.upton@linux.dev>
References: <20240213093250.3960069-1-oliver.upton@linux.dev>
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
 .../selftests/kvm/include/aarch64/gic.h       | 10 +++-
 .../selftests/kvm/include/aarch64/vgic.h      |  3 +-
 tools/testing/selftests/kvm/lib/aarch64/gic.c | 18 +++---
 .../selftests/kvm/lib/aarch64/gic_private.h   |  4 +-
 .../selftests/kvm/lib/aarch64/gic_v3.c        | 56 +++++++++----------
 .../testing/selftests/kvm/lib/aarch64/vgic.c  | 18 +++---
 10 files changed, 57 insertions(+), 82 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 274b8465b42a..f5101898c46a 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -59,9 +59,6 @@ static struct test_args test_args = {
 
 #define msecs_to_usecs(msec)		((msec) * 1000LL)
 
-#define GICD_BASE_GPA			0x8000000ULL
-#define GICR_BASE_GPA			0x80A0000ULL
-
 enum guest_stage {
 	GUEST_STAGE_VTIMER_CVAL = 1,
 	GUEST_STAGE_VTIMER_TVAL,
@@ -204,8 +201,7 @@ static void guest_code(void)
 
 	local_irq_disable();
 
-	gic_init(GIC_V3, test_args.nr_vcpus,
-		(void *)GICD_BASE_GPA, (void *)GICR_BASE_GPA);
+	gic_init(GIC_V3, test_args.nr_vcpus);
 
 	timer_set_ctl(VIRTUAL, CTL_IMASK);
 	timer_set_ctl(PHYSICAL, CTL_IMASK);
@@ -391,7 +387,7 @@ static struct kvm_vm *test_vm_create(void)
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
index 9d51b5691349..496a7a3c615b 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -420,9 +420,6 @@ static void guest_code(uint64_t expected_pmcr_n)
 	GUEST_DONE();
 }
 
-#define GICD_BASE_GPA	0x8000000ULL
-#define GICR_BASE_GPA	0x80A0000ULL
-
 /* Create a VM that has one vCPU with PMUv3 configured. */
 static void create_vpmu_vm(void *guest_code)
 {
@@ -454,8 +451,7 @@ static void create_vpmu_vm(void *guest_code)
 	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
 	vpmu_vm.vcpu = aarch64_vcpu_add(vpmu_vm.vm, 0, &init, guest_code);
 	vcpu_init_descriptor_tables(vpmu_vm.vcpu);
-	vpmu_vm.gic_fd = vgic_v3_setup(vpmu_vm.vm, 1, 64,
-					GICD_BASE_GPA, GICR_BASE_GPA);
+	vpmu_vm.gic_fd = vgic_v3_setup(vpmu_vm.vm, 1, 64);
 	__TEST_REQUIRE(vpmu_vm.gic_fd >= 0,
 		       "Failed to create vgic-v3, skipping");
 
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index d374dbcf9a53..53c9d7a2611d 100644
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
index b217ea17cac5..16d944486e9c 100644
--- a/tools/testing/selftests/kvm/include/aarch64/gic.h
+++ b/tools/testing/selftests/kvm/include/aarch64/gic.h
@@ -11,6 +11,13 @@ enum gic_type {
 	GIC_TYPE_MAX,
 };
 
+#define GICD_BASE_GPA		0x8000000ULL
+#define GICR_BASE_GPA		(GICD_BASE_GPA + SZ_64K)
+
+/* The GIC is identity-mapped into the guest at the time of setup. */
+#define GICD_BASE_GVA		((void *)GICD_BASE_GPA)
+#define GICR_BASE_GVA		((void *)GICR_BASE_GPA)
+
 #define MIN_SGI			0
 #define MIN_PPI			16
 #define MIN_SPI			32
@@ -21,8 +28,7 @@ enum gic_type {
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
index cd8f0e209599..de53d193d0be 100644
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
+static inline void *gicr_base_cpu(uint32_t cpu)
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
+	void *base = cpu_or_dist & DIST_BIT ? GICD_BASE_GVA
+		: sgi_base_from_redist(gicr_base_cpu(cpu_or_dist));
 	return readl(base + offset);
 }
 
 void gicv3_reg_writel(uint32_t cpu_or_dist, uint64_t offset, uint32_t reg_val)
 {
-	void *base = cpu_or_dist & DIST_BIT ? gicv3_data.dist_base
-		: sgi_base_from_redist(gicv3_data.redist_base[cpu_or_dist]);
+	void *base = cpu_or_dist & DIST_BIT ? GICD_BASE_GVA
+		: sgi_base_from_redist(gicr_base_cpu(cpu_or_dist));
 	writel(reg_val, base + offset);
 }
 
@@ -289,13 +293,7 @@ static void gicv3_enable_redist(void *redist_base)
 	}
 }
 
-static inline void *gicr_base_cpu(void *redist_base, uint32_t cpu)
-{
-	/* Align all the redistributors sequentially */
-	return redist_base + cpu * SZ_64K * 2;
-}
-
-static void gicv3_cpu_init(unsigned int cpu, void *redist_base)
+static void gicv3_cpu_init(unsigned int cpu)
 {
 	void *sgi_base;
 	unsigned int i;
@@ -303,7 +301,7 @@ static void gicv3_cpu_init(unsigned int cpu, void *redist_base)
 
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
index b5f28d21a947..ac55b6c2e915 100644
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
2.43.0.687.g38aa6559b0-goog


