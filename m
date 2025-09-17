Return-Path: <kvm+bounces-57935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D05FB81EEC
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 23:21:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 080304A37E0
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 21:21:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 714F3304963;
	Wed, 17 Sep 2025 21:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kSnuHcWh"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C912F39D0
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 21:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758144093; cv=none; b=BhGTNvs/bNTsZnawNr/Nac+HjYpa+oQHXlpc0eJvVi90FCXu4tiZOOmsXxeo9j+92BHu39tPHyI8KQuOLdqlqiz4INW4K4LwwFeDMmvv92as2eF3JiBj9aC/JGe/2VB7P+RTd+2BSuX9t4zWS6TS9rBmXdb4y1r8DC0feE5yDAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758144093; c=relaxed/simple;
	bh=xKWc9naraT1OzP2X0BHoLXSXV3f/X4yj5pfICFI8g6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCzb0iM/OR6v82jMkOkLXf+lTk6OpbEmEx4Y7HZ84seHtI3xOlMmxMCbUtd3x4A5cj+9o8fQO+jm5NfBY2coojHJuh+nSwen/Tv8yYz7p22r7VsXIO38qgVh/lul6DEQuKj1m5+XdC2g0quXW6B+GYxlZOtrxALecJnWGJwbXp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kSnuHcWh; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758144089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oAb+spbQ9qYFhNbgGGMdgmieInJx+oz2hBmcppkb2YQ=;
	b=kSnuHcWhgSl9q9fN0wsqLvTQVMTbogjk8lbowJlAtai5KTzm2e3zz4PTId3VxhEicrSg56
	cTytNZjAb/cU0XH6QAPPMvEF/v7Y3USVyiZAF35TslFx3F8rk8/3njpfhVMOd92w9bbcnB
	YwVgo2wjOjk/J/DH7nssNMcT0uwcNrU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 05/13] KVM: arm64: selftests: Create a VGICv3 for 'default' VMs
Date: Wed, 17 Sep 2025 14:20:35 -0700
Message-ID: <20250917212044.294760-6-oliver.upton@linux.dev>
In-Reply-To: <20250917212044.294760-1-oliver.upton@linux.dev>
References: <20250917212044.294760-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Start creating a VGICv3 by default unless explicitly opted-out by the
test. While having an interrupt controller is nice, the real benefit
here is clearing a hurdle for EL2 VMs which mandate the presence of a
VGIC.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../testing/selftests/kvm/arm64/arch_timer.c  |  4 ---
 .../kvm/arm64/arch_timer_edge_cases.c         |  4 ---
 .../testing/selftests/kvm/arm64/no-vgic-v3.c  |  2 ++
 tools/testing/selftests/kvm/arm64/psci_test.c |  1 +
 .../testing/selftests/kvm/arm64/set_id_regs.c |  1 +
 .../selftests/kvm/arm64/smccc_filter.c        |  1 +
 tools/testing/selftests/kvm/arm64/vgic_init.c |  2 ++
 tools/testing/selftests/kvm/arm64/vgic_irq.c  |  1 +
 .../selftests/kvm/arm64/vgic_lpi_stress.c     |  4 +--
 .../selftests/kvm/arm64/vpmu_counter_access.c |  5 ++-
 .../selftests/kvm/dirty_log_perf_test.c       | 35 -------------------
 tools/testing/selftests/kvm/dirty_log_test.c  |  1 +
 .../kvm/include/arm64/kvm_util_arch.h         |  5 ++-
 .../selftests/kvm/include/arm64/processor.h   |  1 +
 .../testing/selftests/kvm/include/kvm_util.h  |  4 ++-
 .../selftests/kvm/lib/arm64/processor.c       | 26 +++++++++++++-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 15 ++++++--
 .../testing/selftests/kvm/lib/x86/processor.c |  2 +-
 tools/testing/selftests/kvm/s390/cmma_test.c  |  2 +-
 19 files changed, 60 insertions(+), 56 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/arch_timer.c b/tools/testing/selftests/kvm/arm64/arch_timer.c
index aaf4285f832a..c753013319bc 100644
--- a/tools/testing/selftests/kvm/arm64/arch_timer.c
+++ b/tools/testing/selftests/kvm/arm64/arch_timer.c
@@ -176,8 +176,6 @@ static void test_init_timer_irq(struct kvm_vm *vm)
 	pr_debug("ptimer_irq: %d; vtimer_irq: %d\n", ptimer_irq, vtimer_irq);
 }
 
-static int gic_fd;
-
 struct kvm_vm *test_vm_create(void)
 {
 	struct kvm_vm *vm;
@@ -206,7 +204,6 @@ struct kvm_vm *test_vm_create(void)
 		vcpu_init_descriptor_tables(vcpus[i]);
 
 	test_init_timer_irq(vm);
-	gic_fd = vgic_v3_setup(vm, nr_vcpus, 64);
 
 	/* Make all the test's cmdline args visible to the guest */
 	sync_global_to_guest(vm, test_args);
@@ -216,6 +213,5 @@ struct kvm_vm *test_vm_create(void)
 
 void test_vm_cleanup(struct kvm_vm *vm)
 {
-	close(gic_fd);
 	kvm_vm_free(vm);
 }
diff --git a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
index d349d80d8418..5c60262f4c2e 100644
--- a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
+++ b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
@@ -935,8 +935,6 @@ static void test_init_timer_irq(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	pr_debug("ptimer_irq: %d; vtimer_irq: %d\n", ptimer_irq, vtimer_irq);
 }
 
-static int gic_fd;
-
 static void test_vm_create(struct kvm_vm **vm, struct kvm_vcpu **vcpu,
 			   enum arch_timer timer)
 {
@@ -951,7 +949,6 @@ static void test_vm_create(struct kvm_vm **vm, struct kvm_vcpu **vcpu,
 	vcpu_args_set(*vcpu, 1, timer);
 
 	test_init_timer_irq(*vm, *vcpu);
-	gic_fd = vgic_v3_setup(*vm, 1, 64);
 
 	sync_global_to_guest(*vm, test_args);
 	sync_global_to_guest(*vm, CVAL_MAX);
@@ -960,7 +957,6 @@ static void test_vm_create(struct kvm_vm **vm, struct kvm_vcpu **vcpu,
 
 static void test_vm_cleanup(struct kvm_vm *vm)
 {
-	close(gic_fd);
 	kvm_vm_free(vm);
 }
 
diff --git a/tools/testing/selftests/kvm/arm64/no-vgic-v3.c b/tools/testing/selftests/kvm/arm64/no-vgic-v3.c
index f222538e6084..152c34776981 100644
--- a/tools/testing/selftests/kvm/arm64/no-vgic-v3.c
+++ b/tools/testing/selftests/kvm/arm64/no-vgic-v3.c
@@ -163,6 +163,8 @@ int main(int argc, char *argv[])
 	struct kvm_vm *vm;
 	uint64_t pfr0;
 
+	test_disable_default_vgic();
+
 	vm = vm_create_with_one_vcpu(&vcpu, NULL);
 	pfr0 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1));
 	__TEST_REQUIRE(FIELD_GET(ID_AA64PFR0_EL1_GIC, pfr0),
diff --git a/tools/testing/selftests/kvm/arm64/psci_test.c b/tools/testing/selftests/kvm/arm64/psci_test.c
index ab491ee9e5f7..cf208390fd0e 100644
--- a/tools/testing/selftests/kvm/arm64/psci_test.c
+++ b/tools/testing/selftests/kvm/arm64/psci_test.c
@@ -95,6 +95,7 @@ static struct kvm_vm *setup_vm(void *guest_code, struct kvm_vcpu **source,
 	*source = aarch64_vcpu_add(vm, 0, &init, guest_code);
 	*target = aarch64_vcpu_add(vm, 1, &init, guest_code);
 
+	kvm_arch_vm_finalize_vcpus(vm);
 	return vm;
 }
 
diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index a2d367a2c93c..77718628facf 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -763,6 +763,7 @@ int main(void)
 	vm = vm_create(1);
 	vm_enable_cap(vm, KVM_CAP_ARM_WRITABLE_IMP_ID_REGS, 0);
 	vcpu = vm_vcpu_add(vm, 0, guest_code);
+	kvm_arch_vm_finalize_vcpus(vm);
 
 	/* Check for AARCH64 only system */
 	val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1));
diff --git a/tools/testing/selftests/kvm/arm64/smccc_filter.c b/tools/testing/selftests/kvm/arm64/smccc_filter.c
index 2d189f3da228..eb5551d21dbe 100644
--- a/tools/testing/selftests/kvm/arm64/smccc_filter.c
+++ b/tools/testing/selftests/kvm/arm64/smccc_filter.c
@@ -73,6 +73,7 @@ static struct kvm_vm *setup_vm(struct kvm_vcpu **vcpu)
 	init.features[0] |= (1 << KVM_ARM_VCPU_PSCI_0_2);
 
 	*vcpu = aarch64_vcpu_add(vm, 0, &init, guest_main);
+	kvm_arch_vm_finalize_vcpus(vm);
 	return vm;
 }
 
diff --git a/tools/testing/selftests/kvm/arm64/vgic_init.c b/tools/testing/selftests/kvm/arm64/vgic_init.c
index a8e0f46bc0ab..8d6d3a4ae4db 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_init.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_init.c
@@ -994,6 +994,8 @@ int main(int ac, char **av)
 	int pa_bits;
 	int cnt_impl = 0;
 
+	test_disable_default_vgic();
+
 	pa_bits = vm_guest_mode_params[VM_MODE_DEFAULT].pa_bits;
 	max_phys_size = 1ULL << pa_bits;
 
diff --git a/tools/testing/selftests/kvm/arm64/vgic_irq.c b/tools/testing/selftests/kvm/arm64/vgic_irq.c
index 9fc9e8e44ecd..6338f5bbdb70 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_irq.c
@@ -802,6 +802,7 @@ int main(int argc, char **argv)
 	bool eoi_split = false;
 
 	TEST_REQUIRE(kvm_supports_vgic_v3());
+	test_disable_default_vgic();
 
 	while ((opt = getopt(argc, argv, "hn:e:l:")) != -1) {
 		switch (opt) {
diff --git a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
index cc2b21d374af..87922a89b134 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
@@ -27,7 +27,7 @@ static vm_paddr_t gpa_base;
 
 static struct kvm_vm *vm;
 static struct kvm_vcpu **vcpus;
-static int gic_fd, its_fd;
+static int its_fd;
 
 static struct test_data {
 	bool		request_vcpus_stop;
@@ -214,7 +214,6 @@ static void setup_test_data(void)
 
 static void setup_gic(void)
 {
-	gic_fd = vgic_v3_setup(vm, test_data.nr_cpus, 64);
 	its_fd = vgic_its_setup(vm);
 }
 
@@ -353,7 +352,6 @@ static void setup_vm(void)
 static void destroy_vm(void)
 {
 	close(its_fd);
-	close(gic_fd);
 	kvm_vm_free(vm);
 	free(vcpus);
 }
diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
index 01f61657de45..4a7e8e85a1b8 100644
--- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
@@ -28,7 +28,6 @@
 struct vpmu_vm {
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
-	int gic_fd;
 };
 
 static struct vpmu_vm vpmu_vm;
@@ -435,7 +434,8 @@ static void create_vpmu_vm(void *guest_code)
 	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
 	vpmu_vm.vcpu = aarch64_vcpu_add(vpmu_vm.vm, 0, &init, guest_code);
 	vcpu_init_descriptor_tables(vpmu_vm.vcpu);
-	vpmu_vm.gic_fd = vgic_v3_setup(vpmu_vm.vm, 1, 64);
+
+	kvm_arch_vm_finalize_vcpus(vpmu_vm.vm);
 
 	/* Make sure that PMUv3 support is indicated in the ID register */
 	dfr0 = vcpu_get_reg(vpmu_vm.vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1));
@@ -451,7 +451,6 @@ static void create_vpmu_vm(void *guest_code)
 
 static void destroy_vpmu_vm(void)
 {
-	close(vpmu_vm.gic_fd);
 	kvm_vm_free(vpmu_vm.vm);
 }
 
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index e79817bd0e29..0a1ea1d1e2d8 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -20,38 +20,6 @@
 #include "guest_modes.h"
 #include "ucall_common.h"
 
-#ifdef __aarch64__
-#include "arm64/vgic.h"
-
-static int gic_fd;
-
-static void arch_setup_vm(struct kvm_vm *vm, unsigned int nr_vcpus)
-{
-	/*
-	 * The test can still run even if hardware does not support GICv3, as it
-	 * is only an optimization to reduce guest exits.
-	 */
-	gic_fd = vgic_v3_setup(vm, nr_vcpus, 64);
-}
-
-static void arch_cleanup_vm(struct kvm_vm *vm)
-{
-	if (gic_fd > 0)
-		close(gic_fd);
-}
-
-#else /* __aarch64__ */
-
-static void arch_setup_vm(struct kvm_vm *vm, unsigned int nr_vcpus)
-{
-}
-
-static void arch_cleanup_vm(struct kvm_vm *vm)
-{
-}
-
-#endif
-
 /* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
 #define TEST_HOST_LOOP_N		2UL
 
@@ -166,8 +134,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		vm_enable_cap(vm, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2,
 			      dirty_log_manual_caps);
 
-	arch_setup_vm(vm, nr_vcpus);
-
 	/* Start the iterations */
 	iteration = 0;
 	host_quit = false;
@@ -285,7 +251,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	}
 
 	memstress_free_bitmaps(bitmaps, p->slots);
-	arch_cleanup_vm(vm);
 	memstress_destroy_vm(vm);
 }
 
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 23593d9eeba9..d58a641b0e6a 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -585,6 +585,7 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, struct kvm_vcpu **vcpu,
 
 	log_mode_create_vm_done(vm);
 	*vcpu = vm_vcpu_add(vm, 0, guest_code);
+	kvm_arch_vm_finalize_vcpus(vm);
 	return vm;
 }
 
diff --git a/tools/testing/selftests/kvm/include/arm64/kvm_util_arch.h b/tools/testing/selftests/kvm/include/arm64/kvm_util_arch.h
index e43a57d99b56..b973bb2c64a6 100644
--- a/tools/testing/selftests/kvm/include/arm64/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/arm64/kvm_util_arch.h
@@ -2,6 +2,9 @@
 #ifndef SELFTEST_KVM_UTIL_ARCH_H
 #define SELFTEST_KVM_UTIL_ARCH_H
 
-struct kvm_vm_arch {};
+struct kvm_vm_arch {
+	bool	has_gic;
+	int	gic_fd;
+};
 
 #endif  // SELFTEST_KVM_UTIL_ARCH_H
diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
index 8370fc94041d..8c066ba1deb5 100644
--- a/tools/testing/selftests/kvm/include/arm64/processor.h
+++ b/tools/testing/selftests/kvm/include/arm64/processor.h
@@ -301,5 +301,6 @@ void smccc_smc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
 void wfi(void);
 
 void test_wants_mte(void);
+void test_disable_default_vgic(void);
 
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 23a506d7eca3..3ab1fffbc3f2 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -1257,7 +1257,9 @@ static inline int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
  */
 void kvm_selftest_arch_init(void);
 
-void kvm_arch_vm_post_create(struct kvm_vm *vm);
+void kvm_arch_vm_post_create(struct kvm_vm *vm, unsigned int nr_vcpus);
+void kvm_arch_vm_finalize_vcpus(struct kvm_vm *vm);
+void kvm_arch_vm_release(struct kvm_vm *vm);
 
 bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr);
 
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index caed1998c7b3..de77d9a7e0cd 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -12,6 +12,7 @@
 #include "kvm_util.h"
 #include "processor.h"
 #include "ucall_common.h"
+#include "vgic.h"
 
 #include <linux/bitfield.h>
 #include <linux/sizes.h>
@@ -655,14 +656,37 @@ void wfi(void)
 }
 
 static bool request_mte;
+static bool request_vgic = true;
 
 void test_wants_mte(void)
 {
 	request_mte = true;
 }
 
-void kvm_arch_vm_post_create(struct kvm_vm *vm)
+void test_disable_default_vgic(void)
+{
+	request_vgic = false;
+}
+
+void kvm_arch_vm_post_create(struct kvm_vm *vm, unsigned int nr_vcpus)
 {
 	if (request_mte && vm_check_cap(vm, KVM_CAP_ARM_MTE))
 		vm_enable_cap(vm, KVM_CAP_ARM_MTE, 0);
+
+	if (request_vgic && kvm_supports_vgic_v3()) {
+		vm->arch.gic_fd = __vgic_v3_setup(vm, nr_vcpus, 64);
+		vm->arch.has_gic = true;
+	}
+}
+
+void kvm_arch_vm_finalize_vcpus(struct kvm_vm *vm)
+{
+	if (vm->arch.has_gic)
+		__vgic_v3_init(vm->arch.gic_fd);
+}
+
+void kvm_arch_vm_release(struct kvm_vm *vm)
+{
+	if (vm->arch.has_gic)
+		close(vm->arch.gic_fd);
 }
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index c3f5142b0a54..67f32d41a59c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -517,7 +517,7 @@ struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
 	guest_rng = new_guest_random_state(guest_random_seed);
 	sync_global_to_guest(vm, guest_rng);
 
-	kvm_arch_vm_post_create(vm);
+	kvm_arch_vm_post_create(vm, nr_runnable_vcpus);
 
 	return vm;
 }
@@ -555,6 +555,7 @@ struct kvm_vm *__vm_create_with_vcpus(struct vm_shape shape, uint32_t nr_vcpus,
 	for (i = 0; i < nr_vcpus; ++i)
 		vcpus[i] = vm_vcpu_add(vm, i, guest_code);
 
+	kvm_arch_vm_finalize_vcpus(vm);
 	return vm;
 }
 
@@ -805,6 +806,8 @@ void kvm_vm_release(struct kvm_vm *vmp)
 
 	/* Free cached stats metadata and close FD */
 	kvm_stats_release(&vmp->stats);
+
+	kvm_arch_vm_release(vmp);
 }
 
 static void __vm_mem_region_delete(struct kvm_vm *vm,
@@ -2330,7 +2333,15 @@ void kvm_get_stat(struct kvm_binary_stats *stats, const char *name,
 	TEST_FAIL("Unable to find stat '%s'", name);
 }
 
-__weak void kvm_arch_vm_post_create(struct kvm_vm *vm)
+__weak void kvm_arch_vm_post_create(struct kvm_vm *vm, unsigned int nr_vcpus)
+{
+}
+
+__weak void kvm_arch_vm_finalize_vcpus(struct kvm_vm *vm)
+{
+}
+
+__weak void kvm_arch_vm_release(struct kvm_vm *vm)
 {
 }
 
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index d4c19ac885a9..bff75aa341bf 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -625,7 +625,7 @@ void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
 		REPORT_GUEST_ASSERT(uc);
 }
 
-void kvm_arch_vm_post_create(struct kvm_vm *vm)
+void kvm_arch_vm_post_create(struct kvm_vm *vm, unsigned int nr_vcpus)
 {
 	int r;
 
diff --git a/tools/testing/selftests/kvm/s390/cmma_test.c b/tools/testing/selftests/kvm/s390/cmma_test.c
index 85cc8c18d6e7..e39a724fe860 100644
--- a/tools/testing/selftests/kvm/s390/cmma_test.c
+++ b/tools/testing/selftests/kvm/s390/cmma_test.c
@@ -145,7 +145,7 @@ static void finish_vm_setup(struct kvm_vm *vm)
 	slot0 = memslot2region(vm, 0);
 	ucall_init(vm, slot0->region.guest_phys_addr + slot0->region.memory_size);
 
-	kvm_arch_vm_post_create(vm);
+	kvm_arch_vm_post_create(vm, 0);
 }
 
 static struct kvm_vm *create_vm_two_memslots(void)
-- 
2.47.3


