Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC9D353926
	for <lists+kvm@lfdr.de>; Sun,  4 Apr 2021 19:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbhDDRY4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Apr 2021 13:24:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48274 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231476AbhDDRXa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 4 Apr 2021 13:23:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617557005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0I2MazHgyt/SDjFumnOUtQWga4VUjufzasBKdiDD5lY=;
        b=MUGLg/AwBnd6FxgpxLNPBGj02mtycrA38kHKPeO12wIzzFg3Ad/94cQDJS5+s2L+8mjeP5
        8GhP3w/FbD1TbETnpmG/GDYUHFUiUhFVskkVHlE0h8nA1raICy8l4nq0Q9SEJRO/3L/hjH
        bIwQc7Nz73xivZRrLCAhdhk329LuObg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-zGy2X5-6NK6dOhKNHXq_UQ-1; Sun, 04 Apr 2021 13:23:23 -0400
X-MC-Unique: zGy2X5-6NK6dOhKNHXq_UQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9CCE107ACCD;
        Sun,  4 Apr 2021 17:23:21 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-13.ams2.redhat.com [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF5EE10027C4;
        Sun,  4 Apr 2021 17:23:18 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        pbonzini@redhat.com
Subject: [PATCH v5 8/8] KVM: selftests: aarch64/vgic-v3 init sequence tests
Date:   Sun,  4 Apr 2021 19:22:43 +0200
Message-Id: <20210404172243.504309-9-eric.auger@redhat.com>
In-Reply-To: <20210404172243.504309-1-eric.auger@redhat.com>
References: <20210404172243.504309-1-eric.auger@redhat.com>
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

v4 -> v5:
- simplify the last bit tests given the simpler interpretation
  of the spec

v3 -> v4:
- update .gitignore
- More vgic-mmio-v3.c change into the previous patch
- rename fuzz_dist_rdist into test_dist_rdist
- cleanup in run_vcpu and guest_code
- max_ipa_bits is global
- s/fuzz/subtest
- added test_kvm_device,
- moved ucall_init() just before the cpu run
- use vm_create_default_with_vcpus
- use vm_gic struct, vm_gic_create, vm_gic_destroy
- revwrite util.c helpers to comply with the usual style
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/aarch64/vgic_init.c | 585 ++++++++++++++++++
 .../testing/selftests/kvm/include/kvm_util.h  |   9 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  77 +++
 5 files changed, 673 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vgic_init.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 7bd7e776c266..bb862f91f640 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 /aarch64/get-reg-list
 /aarch64/get-reg-list-sve
+/aarch64/vgic_init
 /s390x/memop
 /s390x/resets
 /s390x/sync_regs_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 67eebb53235f..2fd4801de9ca 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -78,6 +78,7 @@ TEST_GEN_PROGS_x86_64 += steal_time
 
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list-sve
+TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
 TEST_GEN_PROGS_aarch64 += dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
new file mode 100644
index 000000000000..be1a7c0d0527
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -0,0 +1,585 @@
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
+struct vm_gic {
+	struct kvm_vm *vm;
+	int gic_fd;
+};
+
+int max_ipa_bits;
+
+/* helper to access a redistributor register */
+static int access_redist_reg(int gicv3_fd, int vcpu, int offset,
+			     uint32_t *val, bool write)
+{
+	uint64_t attr = REG_OFFSET(vcpu, offset);
+
+	return _kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_REDIST_REGS,
+				  attr, val, write);
+}
+
+/* dummy guest code */
+static void guest_code(void)
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
+	int ret;
+
+	vcpu_args_set(vm, vcpuid, 1);
+	ret = _vcpu_ioctl(vm, vcpuid, KVM_RUN, NULL);
+	get_ucall(vm, vcpuid, NULL);
+
+	if (ret)
+		return -errno;
+	return 0;
+}
+
+static struct vm_gic vm_gic_create(void)
+{
+	struct vm_gic v;
+
+	v.vm = vm_create_default_with_vcpus(NR_VCPUS, 0, 0, guest_code, NULL);
+	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	TEST_ASSERT(v.gic_fd > 0, "GICv3 device created");
+
+	return v;
+}
+
+static void vm_gic_destroy(struct vm_gic *v)
+{
+	close(v->gic_fd);
+	kvm_vm_free(v->vm);
+}
+
+/**
+ * Helper routine that performs KVM device tests in general and
+ * especially ARM_VGIC_V3 ones. Eventually the ARM_VGIC_V3
+ * device gets created, a legacy RDIST region is set at @0x0
+ * and a DIST region is set @0x60000
+ */
+static void subtest_dist_rdist(struct vm_gic *v)
+{
+	int ret;
+	uint64_t addr;
+
+	/* Check existing group/attributes */
+	ret = _kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V3_ADDR_TYPE_DIST);
+	TEST_ASSERT(!ret, "KVM_DEV_ARM_VGIC_GRP_ADDR/KVM_VGIC_V3_ADDR_TYPE_DIST supported");
+
+	ret = _kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V3_ADDR_TYPE_REDIST);
+	TEST_ASSERT(!ret, "KVM_DEV_ARM_VGIC_GRP_ADDR/KVM_VGIC_V3_ADDR_TYPE_REDIST supported");
+
+	/* check non existing attribute */
+	ret = _kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, 0);
+	TEST_ASSERT(ret == -ENXIO, "attribute not supported");
+
+	/* misaligned DIST and REDIST address settings */
+	addr = 0x1000;
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
+	TEST_ASSERT(ret == -EINVAL, "GICv3 dist base not 64kB aligned");
+
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+	TEST_ASSERT(ret == -EINVAL, "GICv3 redist base not 64kB aligned");
+
+	/* out of range address */
+	if (max_ipa_bits) {
+		addr = 1ULL << max_ipa_bits;
+		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+					 KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
+		TEST_ASSERT(ret == -E2BIG, "dist address beyond IPA limit");
+
+		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+					 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+		TEST_ASSERT(ret == -E2BIG, "redist address beyond IPA limit");
+	}
+
+	/* set REDIST base address @0x0*/
+	addr = 0x00000;
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+	TEST_ASSERT(!ret, "GICv3 redist base set");
+
+	/* Attempt to create a second legacy redistributor region */
+	addr = 0xE0000;
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+	TEST_ASSERT(ret == -EEXIST, "GICv3 redist base set again");
+
+	/* Attempt to mix legacy and new redistributor regions */
+	addr = REDIST_REGION_ATTR_ADDR(NR_VCPUS, 0x100000, 0, 0);
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret == -EINVAL, "attempt to mix GICv3 REDIST and REDIST_REGION");
+
+	/*
+	 * Set overlapping DIST / REDIST, cannot be detected here. Will be detected
+	 * on first vcpu run instead.
+	 */
+	addr = 3 * 2 * 0x10000;
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, KVM_VGIC_V3_ADDR_TYPE_DIST,
+				 &addr, true);
+	TEST_ASSERT(!ret, "dist overlapping rdist");
+}
+
+/* Test the new REDIST region API */
+static void subtest_redist_regions(struct vm_gic *v)
+{
+	uint64_t addr, expected_addr;
+	int ret;
+
+	ret = kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				     KVM_VGIC_V3_ADDR_TYPE_REDIST);
+	TEST_ASSERT(!ret, "Multiple redist regions advertised");
+
+	addr = REDIST_REGION_ATTR_ADDR(NR_VCPUS, 0x100000, 2, 0);
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret == -EINVAL, "redist region attr value with flags != 0");
+
+	addr = REDIST_REGION_ATTR_ADDR(0, 0x100000, 0, 0);
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret == -EINVAL, "redist region attr value with count== 0");
+
+	addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 1);
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret == -EINVAL, "attempt to register the first rdist region with index != 0");
+
+	addr = REDIST_REGION_ATTR_ADDR(2, 0x201000, 0, 1);
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret == -EINVAL, "rdist region with misaligned address");
+
+	addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 0);
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(!ret, "First valid redist region with 2 rdist @ 0x200000, index 0");
+
+	addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 1);
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret == -EINVAL, "register an rdist region with already used index");
+
+	addr = REDIST_REGION_ATTR_ADDR(1, 0x210000, 0, 2);
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret == -EINVAL, "register an rdist region overlapping with another one");
+
+	addr = REDIST_REGION_ATTR_ADDR(1, 0x240000, 0, 2);
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret == -EINVAL, "register redist region with index not +1");
+
+	addr = REDIST_REGION_ATTR_ADDR(1, 0x240000, 0, 1);
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(!ret, "register valid redist region with 1 rdist @ 0x220000, index 1");
+
+	addr = REDIST_REGION_ATTR_ADDR(1, 1ULL << max_ipa_bits, 0, 2);
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret == -E2BIG, "register redist region with base address beyond IPA range");
+
+	addr = 0x260000;
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+	TEST_ASSERT(ret == -EINVAL, "Mix KVM_VGIC_V3_ADDR_TYPE_REDIST and REDIST_REGION");
+
+	/*
+	 * Now there are 2 redist regions:
+	 * region 0 @ 0x200000 2 redists
+	 * region 1 @ 0x240000 1 redist
+	 * Attempt to read their characteristics
+	 */
+
+	addr = REDIST_REGION_ATTR_ADDR(0, 0, 0, 0);
+	expected_addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 0);
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, false);
+	TEST_ASSERT(!ret && addr == expected_addr, "read characteristics of region #0");
+
+	addr = REDIST_REGION_ATTR_ADDR(0, 0, 0, 1);
+	expected_addr = REDIST_REGION_ATTR_ADDR(1, 0x240000, 0, 1);
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, false);
+	TEST_ASSERT(!ret && addr == expected_addr, "read characteristics of region #1");
+
+	addr = REDIST_REGION_ATTR_ADDR(0, 0, 0, 2);
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, false);
+	TEST_ASSERT(ret == -ENOENT, "read characteristics of non existing region");
+
+	addr = 0x260000;
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
+	TEST_ASSERT(!ret, "set dist region");
+
+	addr = REDIST_REGION_ATTR_ADDR(1, 0x260000, 0, 2);
+	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(ret == -EINVAL, "register redist region colliding with dist");
+}
+
+/*
+ * VGIC KVM device is created and initialized before the secondary CPUs
+ * get created
+ */
+static void test_vgic_then_vcpus(void)
+{
+	struct vm_gic v;
+	int ret, i;
+
+	v.vm = vm_create_default(0, 0, guest_code);
+	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	TEST_ASSERT(v.gic_fd > 0, "GICv3 device created");
+
+	subtest_dist_rdist(&v);
+
+	/* Add the rest of the VCPUs */
+	for (i = 1; i < NR_VCPUS; ++i)
+		vm_vcpu_add_default(v.vm, i, guest_code);
+
+	ucall_init(v.vm, NULL);
+	ret = run_vcpu(v.vm, 3);
+	TEST_ASSERT(ret == -EINVAL, "dist/rdist overlap detected on 1st vcpu run");
+
+	vm_gic_destroy(&v);
+}
+
+/* All the VCPUs are created before the VGIC KVM device gets initialized */
+static void test_vcpus_then_vgic(void)
+{
+	struct vm_gic v;
+	int ret;
+
+	v = vm_gic_create();
+
+	subtest_dist_rdist(&v);
+
+	ucall_init(v.vm, NULL);
+	ret = run_vcpu(v.vm, 3);
+	TEST_ASSERT(ret == -EINVAL, "dist/rdist overlap detected on 1st vcpu run");
+
+	vm_gic_destroy(&v);
+}
+
+static void test_new_redist_regions(void)
+{
+	void *dummy = NULL;
+	struct vm_gic v;
+	uint64_t addr;
+	int ret;
+
+	v = vm_gic_create();
+	subtest_redist_regions(&v);
+	ret = _kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				 KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+	TEST_ASSERT(!ret, "init the vgic");
+
+	ucall_init(v.vm, NULL);
+	ret = run_vcpu(v.vm, 3);
+	TEST_ASSERT(ret == -ENXIO, "running without sufficient number of rdists");
+	vm_gic_destroy(&v);
+
+	/* step2 */
+
+	v = vm_gic_create();
+	subtest_redist_regions(&v);
+
+	addr = REDIST_REGION_ATTR_ADDR(1, 0x280000, 0, 2);
+	ret = _kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(!ret, "register a third region allowing to cover the 4 vcpus");
+
+	ucall_init(v.vm, NULL);
+	ret = run_vcpu(v.vm, 3);
+	TEST_ASSERT(ret == -EBUSY, "running without vgic explicit init");
+
+	vm_gic_destroy(&v);
+
+	/* step 3 */
+
+	v = vm_gic_create();
+	subtest_redist_regions(&v);
+
+	ret = _kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, dummy, true);
+	TEST_ASSERT(ret == -EFAULT, "register a third region allowing to cover the 4 vcpus");
+
+	addr = REDIST_REGION_ATTR_ADDR(1, 0x280000, 0, 2);
+	ret = _kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(!ret, "register a third region allowing to cover the 4 vcpus");
+
+	ret = _kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				 KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+	TEST_ASSERT(!ret, "init the vgic");
+
+	ucall_init(v.vm, NULL);
+	ret = run_vcpu(v.vm, 3);
+	TEST_ASSERT(!ret, "vcpu run");
+
+	vm_gic_destroy(&v);
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
+	ret = _kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				 KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+	TEST_ASSERT(!ret, "init the vgic after the vcpu creations");
+
+	for (i = 0; i < NR_VCPUS ; i++) {
+		ret = access_redist_reg(gicv3_fd, 0, GICR_TYPER, &val, false);
+		TEST_ASSERT(!ret && !val, "read GICR_TYPER before rdist region setting");
+	}
+
+	addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 0);
+	ret = _kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
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
+	ret = _kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
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
+	ret = _kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
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
+ * rdist regions #1 and #2 are contiguous
+ * rdist region #0 @0x100000 2 rdist capacity
+ *     rdists: 0, 3 (Last)
+ * rdist region #1 @0x240000 2 rdist capacity
+ *     rdists:  5, 4 (Last)
+ * rdist region #2 @0x200000 2 rdist capacity
+ *     rdists: 1, 2
+ */
+static void test_last_bit_redist_regions(void)
+{
+	uint32_t vcpuids[] = { 0, 3, 5, 4, 1, 2 };
+	int ret, gicv3_fd;
+	uint64_t addr;
+	struct kvm_vm *vm;
+	uint32_t val;
+
+	vm = vm_create_default_with_vcpus(6, 0, 0, guest_code, vcpuids);
+
+	gicv3_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	TEST_ASSERT(gicv3_fd >= 0, "VGIC_V3 device created");
+
+	ret = _kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				 KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+	TEST_ASSERT(!ret, "init the vgic after the vcpu creations");
+
+	addr = REDIST_REGION_ATTR_ADDR(2, 0x100000, 0, 0);
+	ret = _kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(!ret, "rdist region #0 (2 rdist)");
+
+	addr = REDIST_REGION_ATTR_ADDR(2, 0x240000, 0, 1);
+	ret = _kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(!ret, "rdist region #1 (1 rdist) contiguous with #2");
+
+	addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 2);
+	ret = _kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	TEST_ASSERT(!ret, "rdist region #2 with a capacity of 2 rdists");
+
+	ret = access_redist_reg(gicv3_fd, 0, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x000, "read typer of rdist #0");
+
+	ret = access_redist_reg(gicv3_fd, 1, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x100, "read typer of rdist #1");
+
+	ret = access_redist_reg(gicv3_fd, 2, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x200, "read typer of rdist #2");
+
+	ret = access_redist_reg(gicv3_fd, 3, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x310, "read typer of rdist #3");
+
+	ret = access_redist_reg(gicv3_fd, 5, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x500, "read typer of rdist #5");
+
+	ret = access_redist_reg(gicv3_fd, 4, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x410, "read typer of rdist #4");
+
+	close(gicv3_fd);
+	kvm_vm_free(vm);
+}
+
+/* Test last bit with legacy region */
+static void test_last_bit_single_rdist(void)
+{
+	uint32_t vcpuids[] = { 0, 3, 5, 4, 1, 2 };
+	int ret, gicv3_fd;
+	uint64_t addr;
+	struct kvm_vm *vm;
+	uint32_t val;
+
+	vm = vm_create_default_with_vcpus(6, 0, 0, guest_code, vcpuids);
+
+	gicv3_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	TEST_ASSERT(gicv3_fd >= 0, "VGIC_V3 device created");
+
+	ret = _kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				 KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+	TEST_ASSERT(!ret, "init the vgic after the vcpu creations");
+
+	addr = 0x10000;
+	ret = _kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+
+	ret = access_redist_reg(gicv3_fd, 0, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x000, "read typer of rdist #0");
+
+	ret = access_redist_reg(gicv3_fd, 3, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x300, "read typer of rdist #1");
+
+	ret = access_redist_reg(gicv3_fd, 5, GICR_TYPER, &val, false);
+	TEST_ASSERT(!ret && val == 0x500, "read typer of rdist #2");
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
+void test_kvm_device(void)
+{
+	struct vm_gic v;
+	int ret;
+
+	v.vm = vm_create_default_with_vcpus(NR_VCPUS, 0, 0, guest_code, NULL);
+
+	/* try to create a non existing KVM device */
+	ret = _kvm_create_device(v.vm, 0, true);
+	TEST_ASSERT(ret == -ENODEV, "unsupported device");
+
+	/* trial mode with VGIC_V3 device */
+	ret = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, true);
+	if (ret) {
+		print_skip("GICv3 not supported");
+		exit(KSFT_SKIP);
+	}
+	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	TEST_ASSERT(v.gic_fd, "create the GICv3 device");
+
+	ret = _kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	TEST_ASSERT(ret == -EEXIST, "create GICv3 device twice");
+
+	ret = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, true);
+	TEST_ASSERT(!ret, "create GICv3 in test mode while the same already is created");
+
+	if (!_kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V2, true)) {
+		ret = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V2, false);
+		TEST_ASSERT(ret == -EINVAL, "create GICv2 while v3 exists");
+	}
+
+	vm_gic_destroy(&v);
+}
+
+int main(int ac, char **av)
+{
+	max_ipa_bits = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
+
+	test_kvm_device();
+	test_vcpus_then_vgic();
+	test_vgic_then_vcpus();
+	test_new_redist_regions();
+	test_typer_accesses();
+	test_last_bit_redist_regions();
+	test_last_bit_single_rdist();
+
+	return 0;
+}
+
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 0f4258eaa629..2b4b325cde01 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -225,6 +225,15 @@ int vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
 #endif
 void *vcpu_map_dirty_ring(struct kvm_vm *vm, uint32_t vcpuid);
 
+int _kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr);
+int kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr);
+int _kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test);
+int kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test);
+int _kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
+		       void *val, bool write);
+int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
+		      void *val, bool write);
+
 const char *exit_reason_str(unsigned int exit_reason);
 
 void virt_pgd_alloc(struct kvm_vm *vm, uint32_t pgd_memslot);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index b8849a1aca79..db2a252be917 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1733,6 +1733,83 @@ int _kvm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg)
 	return ioctl(vm->kvm_fd, cmd, arg);
 }
 
+/*
+ * Device Ioctl
+ */
+
+int _kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr)
+{
+	struct kvm_device_attr attribute = {
+		.group = group,
+		.attr = attr,
+		.flags = 0,
+	};
+	int ret = ioctl(dev_fd, KVM_HAS_DEVICE_ATTR, &attribute);
+
+	if (ret == -1)
+		return -errno;
+	return 0;
+}
+
+int kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr)
+{
+	int ret = _kvm_device_check_attr(dev_fd, group, attr);
+
+	TEST_ASSERT(ret >= 0, "KVM_HAS_DEVICE_ATTR failed, errno: %i", errno);
+	return ret;
+}
+
+int _kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test)
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
+int kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test)
+{
+	int ret = _kvm_create_device(vm, type, test);
+
+	TEST_ASSERT(ret >= 0, "KVM_CREATE_DEVICE IOCTL failed,\n"
+		"  errno: %i", errno);
+	return ret;
+}
+
+int _kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
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
+	if (ret < 0)
+		return -errno;
+	return ret;
+}
+
+int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
+		      void *val, bool write)
+{
+	int ret = _kvm_device_access(dev_fd, group, attr, val, write);
+
+	TEST_ASSERT(ret >= 0, "KVM_SET|GET_DEVICE_ATTR IOCTL failed,\n"
+		    "  errno: %i", errno);
+	return ret;
+}
+
 /*
  * VM Dump
  *
-- 
2.26.3

