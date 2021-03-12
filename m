Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE0433950F
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 18:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbhCLRdN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 12:33:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56949 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232930AbhCLRdG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 12:33:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615570385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UMKN5Jrsm5WOpImTpwlncJkY6fDPKzjjJOPSwpCoGnw=;
        b=fEcnADmSOcZxSK91gXQ6X87UIGq3UDq1uMzwwlem2I90wluwSd2JuHiiIP+bCdFOiMlP+g
        uu/iQ6XJ2viZVzYciWtA6UQ1/dsPH8OV2RdAxw4AsmAfNCP2y0tOxdAwzGfu46kxqbRpkV
        Eb+NBmMO8IodjyhKCC79kAcHB9BeboU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-523-Y8EiSVj0O2mQQVDVVfe-kg-1; Fri, 12 Mar 2021 12:33:03 -0500
X-MC-Unique: Y8EiSVj0O2mQQVDVVfe-kg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8A3881746A;
        Fri, 12 Mar 2021 17:33:01 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75EB51002388;
        Fri, 12 Mar 2021 17:32:56 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, shuah@kernel.org, pbonzini@redhat.com
Subject: [PATCH v3 8/8] KVM: selftests: aarch64/vgic-v3 init sequence tests
Date:   Fri, 12 Mar 2021 18:32:02 +0100
Message-Id: <20210312173202.89576-9-eric.auger@redhat.com>
In-Reply-To: <20210312173202.89576-1-eric.auger@redhat.com>
References: <20210312173202.89576-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The tests exercise the VGIC_V3 device creation including the
associated KVM_DEV_ARM_VGIC_GRP_ADDR group attributes:

- KVM_VGIC_V3_ADDR_TYPE_DIST/REDIST
- KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION

Some other tests dedicate to KVM_DEV_ARM_VGIC_GRP_REDIST_REGS group
and especially the GICR_TYPER read. The goal was to test the case
recently fixed by commit 23bde34771f1
("KVM: arm64: vgic-v3: Drop the reporting of GICR_TYPER.Last for userspace").

The API under test can be found at
Documentation/virt/kvm/devices/arm-vgic-v3.rst

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c            |   2 +-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/aarch64/vgic_init.c | 672 ++++++++++++++++++
 .../testing/selftests/kvm/include/kvm_util.h  |   5 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  51 ++
 5 files changed, 730 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vgic_init.c

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 652998ed0b55..f6a7eed1d6ad 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -260,7 +260,7 @@ static bool vgic_mmio_vcpu_rdist_is_last(struct kvm_vcpu *vcpu)
 	if (!rdreg)
 		return false;
 
-	if (!rdreg->count && vgic_cpu->rdreg_index == (rdreg->count - 1)) {
+	if (rdreg->count && vgic_cpu->rdreg_index == (rdreg->count - 1)) {
 		/* check whether there is no other contiguous rdist region */
 		struct list_head *rd_regions = &vgic->rd_regions;
 		struct vgic_redist_region *iter;
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index a6d61f451f88..4e548d7ab0ab 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -75,6 +75,7 @@ TEST_GEN_PROGS_x86_64 += steal_time
 
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list-sve
+TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
 TEST_GEN_PROGS_aarch64 += dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
new file mode 100644
index 000000000000..12205ab9fb10
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -0,0 +1,672 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * vgic init sequence tests
+ *
+ * Copyright (C) 2020, Red Hat, Inc.
+ */
+#define _GNU_SOURCE
+#include <linux/kernel.h>
+#include <sys/syscall.h>
+#include <asm/kvm.h>
+#include <asm/kvm_para.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+#define NR_VCPUS		4
+
+#define REDIST_REGION_ATTR_ADDR(count, base, flags, index) (((uint64_t)(count) << 52) | \
+	((uint64_t)((base) >> 16) << 16) | ((uint64_t)(flags) << 12) | index)
+#define REG_OFFSET(vcpu, offset) (((uint64_t)vcpu << 32) | offset)
+
+#define GICR_TYPER 0x8
+
+/* helper to access a redistributor register */
+static int access_redist_reg(int gicv3_fd, int vcpu, int offset,
+			     uint32_t *val, bool write)
+{
+	uint64_t attr = REG_OFFSET(vcpu, offset);
+
+	return kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_REDIST_REGS,
+				 attr, val, write);
+}
+
+/* dummy guest code */
+static void guest_code(int cpu)
+{
+	GUEST_SYNC(0);
+	GUEST_SYNC(1);
+	GUEST_SYNC(2);
+	GUEST_DONE();
+}
+
+/* we don't want to assert on run execution, hence that helper */
+static int run_vcpu(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	static int run;
+	struct ucall uc;
+	int ret;
+
+	vcpu_args_set(vm, vcpuid, 1, vcpuid);
+	ret = _vcpu_ioctl(vm, vcpuid, KVM_RUN, NULL);
+	get_ucall(vm, vcpuid, &uc);
+	run++;
+
+	if (ret)
+		return -errno;
+	return 0;
+}
+
+/**
+ * Helper routine that performs KVM device tests in general and
+ * especially ARM_VGIC_V3 ones. Eventually the ARM_VGIC_V3
+ * device gets created, a legacy RDIST region is set at @0x0
+ * and a DIST region is set @0x60000
+ */
+int fuzz_dist_rdist(struct kvm_vm *vm)
+{
+	int ret, gicv3_fd, max_ipa_bits;
+	uint64_t addr;
+
+	max_ipa_bits = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
+
+	/* check ARM_VGIC_V3 device exists */
+	ret = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, true);
+	if (ret) {
+		print_skip("GICv3 not supported");
+		exit(KSFT_SKIP);
+	}
+
+	/* try to create a non existing KVM device */
+	ret = kvm_create_device(vm, 0, true);
+	TEST_ASSERT(ret == -ENODEV, "unsupported device");
+
+	/* Create the ARM_VGIC_V3 device */
+	gicv3_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	TEST_ASSERT(gicv3_fd > 0, "GICv3 device created");
+
+	/* Check existing group/attributes */
+	ret = kvm_device_check_attr(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V3_ADDR_TYPE_DIST);
+	TEST_ASSERT(!ret, "KVM_DEV_ARM_VGIC_GRP_ADDR/KVM_VGIC_V3_ADDR_TYPE_DIST supported");
+
+	ret = kvm_device_check_attr(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V3_ADDR_TYPE_REDIST);
+	TEST_ASSERT(!ret, "KVM_DEV_ARM_VGIC_GRP_ADDR/KVM_VGIC_V3_ADDR_TYPE_REDIST supported");
+
+	/* check non existing attribute */
+	ret = kvm_device_check_attr(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, 0);
+	TEST_ASSERT(ret == -ENXIO, "attribute not supported");
+
+	/* misaligned DIST and REDIST address settings */
+	addr = 0x1000;
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
+	TEST_ASSERT(ret == -EINVAL, "GICv3 dist base not 64kB aligned");
+
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+	TEST_ASSERT(ret == -EINVAL, "GICv3 redist base not 64kB aligned");
+
+	/* out of range address */
+	if (max_ipa_bits) {
+		addr = 1ULL << max_ipa_bits;
+		ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+					KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
+		TEST_ASSERT(ret == -E2BIG, "dist address beyond IPA limit");
+
+		ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+					KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+		TEST_ASSERT(ret == -E2BIG, "redist address beyond IPA limit");
+	}
+
+	/* set REDIST base address @0x0*/
+	addr = 0x00000;
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+	TEST_ASSERT(!ret, "GICv3 redist base set");
+
+	/* Attempt to create a second legacy redistributor region */
+	addr = 0xE0000;
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+	TEST_ASSERT(ret == -EEXIST, "GICv3 redist base set again");
+
+	/* Attempt to mix legacy and new redistributor regions */
+	addr = REDIST_REGION_ATTR_ADDR(NR_VCPUS, 0x100000, 0, 0);
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret == -EINVAL, "attempt to mix GICv3 REDIST and REDIST_REGION");
+
+	/*
+	 * Set overlapping DIST / REDIST, cannot be detected here. Will be detected
+	 * on first vcpu run instead.
+	 */
+	addr = 3 * 2 * 0x10000;
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, KVM_VGIC_V3_ADDR_TYPE_DIST,
+				&addr, true);
+	TEST_ASSERT(!ret, "dist overlapping rdist");
+
+	ret = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	TEST_ASSERT(ret == -EEXIST, "create GICv3 device twice");
+
+	ret = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, true);
+	TEST_ASSERT(!ret, "create GICv3 in test mode while the same already is created");
+
+	if (!kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V2, true)) {
+		ret = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V2, true);
+		TEST_ASSERT(ret == -EINVAL, "create GICv2 while v3 exists");
+	}
+
+	return gicv3_fd;
+}
+
+/* Test the new REDIST region API */
+static int fuzz_redist_regions(struct kvm_vm *vm)
+{
+	int ret, max_ipa_bits, gicv3_fd;
+	uint64_t addr, expected_addr;
+
+	max_ipa_bits = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
+
+	/* trial mode */
+	ret = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, true);
+	if (ret) {
+		print_skip("GICv3 not supported");
+		exit(KSFT_SKIP);
+	}
+
+	/* Create the actual gicv3 device */
+	gicv3_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	TEST_ASSERT(gicv3_fd >= 0, "VGIC_V3 device created");
+
+	ret = kvm_device_check_attr(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V3_ADDR_TYPE_REDIST);
+	TEST_ASSERT(!ret, "Multiple redist regions advertised");
+
+	addr = REDIST_REGION_ATTR_ADDR(NR_VCPUS, 0x100000, 2, 0);
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret == -EINVAL, "redist region attr value with flags != 0");
+
+	addr = REDIST_REGION_ATTR_ADDR(0, 0x100000, 0, 0);
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret == -EINVAL, "redist region attr value with count== 0");
+
+	addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 1);
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret == -EINVAL, "attempt to register the first rdist region with index != 0");
+
+	addr = REDIST_REGION_ATTR_ADDR(2, 0x201000, 0, 1);
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret == -EINVAL, "rdist region with misaligned address");
+
+	addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 0);
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(!ret, "First valid redist region with 2 rdist @ 0x200000, index 0");
+
+	addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 1);
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret == -EINVAL, "register an rdist region with already used index");
+
+	addr = REDIST_REGION_ATTR_ADDR(1, 0x210000, 0, 2);
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret == -EINVAL, "register an rdist region overlapping with another one");
+
+	addr = REDIST_REGION_ATTR_ADDR(1, 0x240000, 0, 2);
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret == -EINVAL, "register redist region with index not +1");
+
+	addr = REDIST_REGION_ATTR_ADDR(1, 0x240000, 0, 1);
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(!ret, "register valid redist region with 1 rdist @ 0x220000, index 1");
+
+	addr = REDIST_REGION_ATTR_ADDR(1, 1ULL << max_ipa_bits, 0, 2);
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret == -E2BIG, "register redist region with base address beyond IPA range");
+
+	addr = 0x260000;
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+	TEST_ASSERT(ret == -EINVAL, "Mix KVM_VGIC_V3_ADDR_TYPE_REDIST and REDIST_REGION");
+
+	/*
+	 * Now there are 2 redist regions:
+	 * region 0 @ 0x200000 2 redists
+	 * region 1 @ 0x240000 1 redist
+	 * now attempt to read their characteristics
+	 */
+
+	addr = REDIST_REGION_ATTR_ADDR(0, 0, 0, 0);
+	expected_addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 0);
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, false);
+	TEST_ASSERT(!ret && addr == expected_addr, "read characteristics of region #0");
+
+	addr = REDIST_REGION_ATTR_ADDR(0, 0, 0, 1);
+	expected_addr = REDIST_REGION_ATTR_ADDR(1, 0x240000, 0, 1);
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, false);
+	TEST_ASSERT(!ret && addr == expected_addr, "read characteristics of region #1");
+
+	addr = REDIST_REGION_ATTR_ADDR(0, 0, 0, 2);
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, false);
+	TEST_ASSERT(ret == -ENOENT, "read characteristics of non existing region");
+
+	addr = 0x260000;
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
+	TEST_ASSERT(!ret, "set dist region");
+
+	addr = REDIST_REGION_ATTR_ADDR(1, 0x260000, 0, 2);
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret == -EINVAL, "register redist region colliding with dist");
+
+	return gicv3_fd;
+}
+
+/*
+ * VGIC KVM device is created and initialized before the secondary CPUs
+ * get created
+ */
+static void test_vgic_then_vcpus(void)
+{
+	int ret, i, gicv3_fd;
+	struct kvm_vm *vm;
+
+	vm = vm_create_default(0, 0, guest_code);
+
+	gicv3_fd = fuzz_dist_rdist(vm);
+
+	/* Add the rest of the VCPUs */
+	for (i = 1; i < NR_VCPUS; ++i)
+		vm_vcpu_add_default(vm, i, guest_code);
+
+	ret = run_vcpu(vm, 3);
+	TEST_ASSERT(ret == -EINVAL, "dist/rdist overlap detected on 1st vcpu run");
+
+	close(gicv3_fd);
+	kvm_vm_free(vm);
+}
+
+
+/* All the VCPUs are created before the VGIC KVM device gets initialized */
+static void test_vcpus_then_vgic(void)
+{
+	int ret, i, gicv3_fd;
+	struct kvm_vm *vm;
+
+	vm = vm_create_default(0, 0, guest_code);
+
+	/* Add the rest of the VCPUs */
+	for (i = 1; i < NR_VCPUS; ++i)
+		vm_vcpu_add_default(vm, i, guest_code);
+
+	gicv3_fd = fuzz_dist_rdist(vm);
+
+	ret = run_vcpu(vm, 3);
+	TEST_ASSERT(ret == -EINVAL, "dist/rdist overlap detected on 1st vcpu run");
+
+	close(gicv3_fd);
+	kvm_vm_free(vm);
+}
+
+static void redist_regions_setup(struct kvm_vm **vm, int *gicv3_fd)
+{
+	int i;
+
+	*vm = vm_create_default(0, 0, guest_code);
+	ucall_init(*vm, NULL);
+
+	/* Add the rest of the VCPUs */
+	for (i = 1; i < NR_VCPUS; ++i)
+		vm_vcpu_add_default(*vm, i, guest_code);
+
+	*gicv3_fd = fuzz_redist_regions(*vm);
+}
+
+static void test_new_redist_regions(void)
+{
+	int ret, gicv3_fd;
+	struct kvm_vm *vm;
+	uint64_t addr;
+	void *dummy = NULL;
+
+	redist_regions_setup(&vm, &gicv3_fd);
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+	TEST_ASSERT(!ret, "init the vgic");
+
+	ret = run_vcpu(vm, 3);
+	TEST_ASSERT(ret == -ENXIO, "running without sufficient number of rdists");
+
+	close(gicv3_fd);
+	kvm_vm_free(vm);
+
+	/* step2 */
+
+	redist_regions_setup(&vm, &gicv3_fd);
+
+	addr = REDIST_REGION_ATTR_ADDR(1, 0x280000, 0, 2);
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(!ret, "register a third region allowing to cover the 4 vcpus");
+
+	ret = run_vcpu(vm, 3);
+	TEST_ASSERT(ret == -EBUSY, "running without vgic explicit init");
+
+	close(gicv3_fd);
+	kvm_vm_free(vm);
+
+	/* step 3 */
+
+	redist_regions_setup(&vm, &gicv3_fd);
+
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, dummy, true);
+	TEST_ASSERT(ret == -EFAULT, "register a third region allowing to cover the 4 vcpus");
+
+	addr = REDIST_REGION_ATTR_ADDR(1, 0x280000, 0, 2);
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(!ret, "register a third region allowing to cover the 4 vcpus");
+
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+	TEST_ASSERT(!ret, "init the vgic");
+
+	ret = run_vcpu(vm, 3);
+	TEST_ASSERT(!ret, "vcpu run");
+
+	close(gicv3_fd);
+	kvm_vm_free(vm);
+}
+
+static void test_typer_accesses(void)
+{
+	int ret, i, gicv3_fd = -1;
+	uint64_t addr;
+	struct kvm_vm *vm;
+	uint32_t val;
+
+	vm = vm_create_default(0, 0, guest_code);
+	ucall_init(vm, NULL);
+
+	gicv3_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	TEST_ASSERT(gicv3_fd >= 0, "VGIC_V3 device created");
+
+	vm_vcpu_add_default(vm, 3, guest_code);
+
+	ret = access_redist_reg(gicv3_fd, 1, GICR_TYPER, &val, false);
+	TEST_ASSERT(ret == -EINVAL, "attempting to read GICR_TYPER of non created vcpu");
+
+	vm_vcpu_add_default(vm, 1, guest_code);
+
+	ret = access_redist_reg(gicv3_fd, 1, GICR_TYPER, &val, false);
+	TEST_ASSERT(ret == -EBUSY, "read GICR_TYPER before GIC initialized");
+
+	vm_vcpu_add_default(vm, 2, guest_code);
+
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+	TEST_ASSERT(!ret, "init the vgic after the vcpu creations");
+
+	for (i = 0; i < NR_VCPUS ; i++) {
+		ret = access_redist_reg(gicv3_fd, 0, GICR_TYPER, &val, false);
+		TEST_ASSERT(!ret && !val, "read GICR_TYPER before rdist region setting");
+	}
+
+	addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 0);
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(!ret, "first rdist region with a capacity of 2 rdists");
+
+	/* The 2 first rdists should be put there (vcpu 0 and 3) */
+	ret = access_redist_reg(gicv3_fd, 0, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && !val, "read typer of rdist #0");
+
+	ret = access_redist_reg(gicv3_fd, 3, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x310, "read typer of rdist #1");
+
+	addr = REDIST_REGION_ATTR_ADDR(10, 0x100000, 0, 1);
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret == -EINVAL, "collision with previous rdist region");
+
+	ret = access_redist_reg(gicv3_fd, 1, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x100,
+		    "no redist region attached to vcpu #1 yet, last cannot be returned");
+
+	ret = access_redist_reg(gicv3_fd, 2, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x200,
+		    "no redist region attached to vcpu #2, last cannot be returned");
+
+	addr = REDIST_REGION_ATTR_ADDR(10, 0x20000, 0, 1);
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(!ret, "second rdist region");
+
+	ret = access_redist_reg(gicv3_fd, 1, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x100, "read typer of rdist #1");
+
+	ret = access_redist_reg(gicv3_fd, 2, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x210,
+		    "read typer of rdist #1, last properly returned");
+
+	close(gicv3_fd);
+	kvm_vm_free(vm);
+}
+
+/**
+ * Test GICR_TYPER last bit with new redist regions
+ * 2 rdist regions that are contiguous
+ * rdist region #0 @0x200000 3 rdist capacity
+ *     rdists: 0, 2 (Last), 1
+ * rdist region #1 @0x260000 10 rdist capacity
+ *     rdists: 3, 5 (Last), 4 (Last)
+ */
+static void test_last_bit_1(void)
+{
+	int ret, gicv3_fd = -1;
+	uint64_t addr;
+	struct kvm_vm *vm;
+	uint32_t val;
+
+	vm = vm_create_default(0, 0, guest_code);
+	ucall_init(vm, NULL);
+
+	gicv3_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	TEST_ASSERT(gicv3_fd >= 0, "VGIC_V3 device created");
+
+	vm_vcpu_add_default(vm, 2, guest_code);
+	vm_vcpu_add_default(vm, 1, guest_code);
+	vm_vcpu_add_default(vm, 3, guest_code);
+	vm_vcpu_add_default(vm, 5, guest_code);
+	vm_vcpu_add_default(vm, 4, guest_code);
+
+	ret = access_redist_reg(gicv3_fd, 0, GICR_TYPER, &val, false);
+	TEST_ASSERT(ret, "read typer of rdist #0 before redist reg creation");
+
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+	TEST_ASSERT(!ret, "init the vgic after the vcpu creations");
+
+	addr = REDIST_REGION_ATTR_ADDR(3, 0x200000, 0, 0);
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(!ret, "rdist region #0 with a capacity of 3 rdists");
+
+	addr = REDIST_REGION_ATTR_ADDR(10, 0x260000, 0, 1);
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(!ret, "rdist region #1 (1 rdist) contiguous with the 1st one");
+
+	/*
+	 * rdist_region #0 should contain rdists 0, 2, 1
+	 * rdist region #1 should contain rdists 3, 5, 4
+	 */
+	ret = access_redist_reg(gicv3_fd, 0, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && !val, "read typer of rdist #0");
+
+	ret = access_redist_reg(gicv3_fd, 2, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x210, "read typer of rdist #2");
+
+	ret = access_redist_reg(gicv3_fd, 1, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x100, "read typer of rdist #1");
+
+	ret = access_redist_reg(gicv3_fd, 3, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x300, "read typer of rdist #3");
+
+	ret = access_redist_reg(gicv3_fd, 5, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x510, "read typer of rdist #3");
+
+	ret = access_redist_reg(gicv3_fd, 4, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x410, "read typer of rdist #3");
+
+	close(gicv3_fd);
+	kvm_vm_free(vm);
+}
+
+/**
+ * Test GICR_TYPER last bit with new redist regions
+ * rdist regions #1 and #2 are contiguous
+ * rdist region #0 @0x100000 1 rdist capacity
+ *     rdists: 0 (Last)
+ * rdist region #1 @0x240000 3 rdist capacity
+ *     rdists: 3, 5 (Last), 4 (Last)
+ * rdist region #2 @0x200000 2 rdist capacity
+ *     rdists: 1, 2
+ */
+static void test_last_bit_2(void)
+{
+	int ret, gicv3_fd;
+	uint64_t addr;
+	struct kvm_vm *vm;
+	uint32_t val;
+
+	vm = vm_create_default(0, 0, guest_code);
+	vm_vcpu_add_default(vm, 3, guest_code);
+	vm_vcpu_add_default(vm, 5, guest_code);
+	vm_vcpu_add_default(vm, 4, guest_code);
+	vm_vcpu_add_default(vm, 1, guest_code);
+	vm_vcpu_add_default(vm, 2, guest_code);
+
+	ucall_init(vm, NULL);
+
+	gicv3_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	TEST_ASSERT(gicv3_fd >= 0, "VGIC_V3 device created");
+
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+	TEST_ASSERT(!ret, "init the vgic after the vcpu creations");
+
+	addr = REDIST_REGION_ATTR_ADDR(1, 0x100000, 0, 0);
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(!ret, "rdist region #0 (1 rdist)");
+
+	addr = REDIST_REGION_ATTR_ADDR(3, 0x240000, 0, 1);
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(!ret, "rdist region #1 (1 rdist) contiguous with #2");
+
+	addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 2);
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(!ret, "rdist region #2 with a capacity of 3 rdists");
+
+
+	ret = access_redist_reg(gicv3_fd, 0, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x010, "read typer of rdist #0");
+
+	ret = access_redist_reg(gicv3_fd, 1, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x100, "read typer of rdist #1");
+
+	ret = access_redist_reg(gicv3_fd, 2, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x200, "read typer of rdist #2");
+
+	ret = access_redist_reg(gicv3_fd, 3, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x300, "read typer of rdist #3");
+
+	ret = access_redist_reg(gicv3_fd, 5, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x510, "read typer of rdist #3");
+
+	ret = access_redist_reg(gicv3_fd, 4, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x410, "read typer of rdist #3");
+
+	close(gicv3_fd);
+	kvm_vm_free(vm);
+}
+
+/* Test last bit with legacy region */
+static void test_last_bit_3(void)
+{
+	int ret, gicv3_fd;
+	uint64_t addr;
+	struct kvm_vm *vm;
+	uint32_t val;
+
+	vm = vm_create_default(0, 0, guest_code);
+	vm_vcpu_add_default(vm, 3, guest_code);
+	vm_vcpu_add_default(vm, 5, guest_code);
+	vm_vcpu_add_default(vm, 4, guest_code);
+	vm_vcpu_add_default(vm, 1, guest_code);
+	vm_vcpu_add_default(vm, 2, guest_code);
+
+	ucall_init(vm, NULL);
+
+	gicv3_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	TEST_ASSERT(gicv3_fd >= 0, "VGIC_V3 device created");
+
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+	TEST_ASSERT(!ret, "init the vgic after the vcpu creations");
+
+	addr = 0x10000;
+	ret = kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+
+	ret = access_redist_reg(gicv3_fd, 0, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x000, "read typer of rdist #0");
+
+	ret = access_redist_reg(gicv3_fd, 3, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x300, "read typer of rdist #1");
+
+	ret = access_redist_reg(gicv3_fd, 5, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x510, "read typer of rdist #2");
+
+	ret = access_redist_reg(gicv3_fd, 1, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x100, "read typer of rdist #3");
+
+	ret = access_redist_reg(gicv3_fd, 2, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x210, "read typer of rdist #3");
+
+	close(gicv3_fd);
+	kvm_vm_free(vm);
+}
+
+int main(int ac, char **av)
+{
+	test_vcpus_then_vgic();
+	test_vgic_then_vcpus();
+	test_new_redist_regions();
+	test_typer_accesses();
+	test_last_bit_1();
+	test_last_bit_2();
+	test_last_bit_3();
+
+	return 0;
+}
+
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 2d7eb6989e83..f82277cadc6b 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -223,6 +223,11 @@ int vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
 #endif
 void *vcpu_map_dirty_ring(struct kvm_vm *vm, uint32_t vcpuid);
 
+int kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr);
+int kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test);
+int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
+		      void *val, bool write);
+
 const char *exit_reason_str(unsigned int exit_reason);
 
 void virt_pgd_alloc(struct kvm_vm *vm, uint32_t pgd_memslot);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e5fbf16f725b..da43c1f5730e 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1728,6 +1728,57 @@ int _kvm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg)
 	return ioctl(vm->kvm_fd, cmd, arg);
 }
 
+/*
+ * Device Ioctl
+ */
+
+int kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr)
+{
+	struct kvm_device_attr attribute = {
+		.group = group,
+		.attr = attr,
+		.flags = 0,
+	};
+	int ret;
+
+	ret = ioctl(dev_fd, KVM_HAS_DEVICE_ATTR, &attribute);
+	if (ret == -1)
+		return -errno;
+	return ret;
+}
+
+int kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test)
+{
+	struct kvm_create_device create_dev;
+	int ret;
+
+	create_dev.type = type;
+	create_dev.fd = -1;
+	create_dev.flags = test ? KVM_CREATE_DEVICE_TEST : 0;
+	ret = ioctl(vm_get_fd(vm), KVM_CREATE_DEVICE, &create_dev);
+	if (ret == -1)
+		return -errno;
+	return test ? 0 : create_dev.fd;
+}
+
+int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
+		      void *val, bool write)
+{
+	struct kvm_device_attr kvmattr = {
+		.group = group,
+		.attr = attr,
+		.flags = 0,
+		.addr = (uintptr_t)val,
+	};
+	int ret;
+
+	ret = ioctl(dev_fd, write ? KVM_SET_DEVICE_ATTR : KVM_GET_DEVICE_ATTR,
+		    &kvmattr);
+	if (ret)
+		return -errno;
+	return ret;
+}
+
 /*
  * VM Dump
  *
-- 
2.26.2

