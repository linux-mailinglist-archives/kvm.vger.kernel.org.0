Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77BE356E03
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 15:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352682AbhDGOAG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 10:00:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44664 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241807AbhDGOAE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 10:00:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617803994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mMv5MhbUUu7Utl16hMjH+qt0aua0QujUTZwObrmQeo0=;
        b=SMQ8L9nNDecq4D2P1iZem12+PGktIHaLhVZsuegLBQYlA+tmXFMUaEiQPpQa6RDA/vZW8z
        LId5wNOEDqY8yEFF+gUbzk/0j+7Z0CSV6TBjqu3z2w3NY0aAGsKmGSA3zcM6wH6N9c6Vv5
        ZPHbEKTxaEuOrPjKTFq1ryL8XvZsDro=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-TcpDJ0g1NmGXTVZrO8nzgA-1; Wed, 07 Apr 2021 09:59:50 -0400
X-MC-Unique: TcpDJ0g1NmGXTVZrO8nzgA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E84761006C83;
        Wed,  7 Apr 2021 13:59:48 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-184.ams2.redhat.com [10.36.113.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 691BD5D9D0;
        Wed,  7 Apr 2021 13:59:42 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        pbonzini@redhat.com
Subject: [PATCH] KVM: selftests: vgic_init kvm selftests fixup
Date:   Wed,  7 Apr 2021 15:59:37 +0200
Message-Id: <20210407135937.533141-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bring some improvements/rationalization over the first version
of the vgic_init selftests:

- ucall_init is moved in run_cpu()
- vcpu_args_set is not called as not needed
- whenever a helper is supposed to succeed, call the non "_" version
- helpers do not return -errno, instead errno is checked by the caller
- vm_gic struct is used whenever possible, as well as vm_gic_destroy
- _kvm_create_device takes an addition fd parameter

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Suggested-by: Andrew Jones <drjones@redhat.com>

---

Applies on top of [PATCH v6 0/9] KVM/ARM: Some vgic fixes
and init sequence KVM selftests, put on kvm-arm64/vgic-5.13

The whole patchset can be found at
https://github.com/eauger/linux/tree/vgic_kvmselftests_v7
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 275 ++++++++----------
 .../testing/selftests/kvm/include/kvm_util.h  |   2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  30 +-
 3 files changed, 136 insertions(+), 171 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index be1a7c0d0527..682e753fdc59 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -27,7 +27,7 @@ struct vm_gic {
 	int gic_fd;
 };
 
-int max_ipa_bits;
+static int max_ipa_bits;
 
 /* helper to access a redistributor register */
 static int access_redist_reg(int gicv3_fd, int vcpu, int offset,
@@ -51,12 +51,8 @@ static void guest_code(void)
 /* we don't want to assert on run execution, hence that helper */
 static int run_vcpu(struct kvm_vm *vm, uint32_t vcpuid)
 {
-	int ret;
-
-	vcpu_args_set(vm, vcpuid, 1);
-	ret = _vcpu_ioctl(vm, vcpuid, KVM_RUN, NULL);
-	get_ucall(vm, vcpuid, NULL);
-
+	ucall_init(vm, NULL);
+	int ret = _vcpu_ioctl(vm, vcpuid, KVM_RUN, NULL);
 	if (ret)
 		return -errno;
 	return 0;
@@ -68,7 +64,6 @@ static struct vm_gic vm_gic_create(void)
 
 	v.vm = vm_create_default_with_vcpus(NR_VCPUS, 0, 0, guest_code, NULL);
 	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
-	TEST_ASSERT(v.gic_fd > 0, "GICv3 device created");
 
 	return v;
 }
@@ -91,66 +86,62 @@ static void subtest_dist_rdist(struct vm_gic *v)
 	uint64_t addr;
 
 	/* Check existing group/attributes */
-	ret = _kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				    KVM_VGIC_V3_ADDR_TYPE_DIST);
-	TEST_ASSERT(!ret, "KVM_DEV_ARM_VGIC_GRP_ADDR/KVM_VGIC_V3_ADDR_TYPE_DIST supported");
+	kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			      KVM_VGIC_V3_ADDR_TYPE_DIST);
 
-	ret = _kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				    KVM_VGIC_V3_ADDR_TYPE_REDIST);
-	TEST_ASSERT(!ret, "KVM_DEV_ARM_VGIC_GRP_ADDR/KVM_VGIC_V3_ADDR_TYPE_REDIST supported");
+	kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			      KVM_VGIC_V3_ADDR_TYPE_REDIST);
 
 	/* check non existing attribute */
 	ret = _kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, 0);
-	TEST_ASSERT(ret == -ENXIO, "attribute not supported");
+	TEST_ASSERT(ret && errno == ENXIO, "attribute not supported");
 
 	/* misaligned DIST and REDIST address settings */
 	addr = 0x1000;
 	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				 KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
-	TEST_ASSERT(ret == -EINVAL, "GICv3 dist base not 64kB aligned");
+	TEST_ASSERT(ret && errno == EINVAL, "GICv3 dist base not 64kB aligned");
 
 	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
-	TEST_ASSERT(ret == -EINVAL, "GICv3 redist base not 64kB aligned");
+	TEST_ASSERT(ret && errno == EINVAL, "GICv3 redist base not 64kB aligned");
 
 	/* out of range address */
 	if (max_ipa_bits) {
 		addr = 1ULL << max_ipa_bits;
 		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 					 KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
-		TEST_ASSERT(ret == -E2BIG, "dist address beyond IPA limit");
+		TEST_ASSERT(ret && errno == E2BIG, "dist address beyond IPA limit");
 
 		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 					 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
-		TEST_ASSERT(ret == -E2BIG, "redist address beyond IPA limit");
+		TEST_ASSERT(ret && errno == E2BIG, "redist address beyond IPA limit");
 	}
 
 	/* set REDIST base address @0x0*/
 	addr = 0x00000;
-	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
-	TEST_ASSERT(!ret, "GICv3 redist base set");
+	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			  KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
 
 	/* Attempt to create a second legacy redistributor region */
 	addr = 0xE0000;
 	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
-	TEST_ASSERT(ret == -EEXIST, "GICv3 redist base set again");
+	TEST_ASSERT(ret && errno == EEXIST, "GICv3 redist base set again");
 
 	/* Attempt to mix legacy and new redistributor regions */
 	addr = REDIST_REGION_ATTR_ADDR(NR_VCPUS, 0x100000, 0, 0);
 	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
-	TEST_ASSERT(ret == -EINVAL, "attempt to mix GICv3 REDIST and REDIST_REGION");
+	TEST_ASSERT(ret && errno == EINVAL, "attempt to mix GICv3 REDIST and REDIST_REGION");
 
 	/*
 	 * Set overlapping DIST / REDIST, cannot be detected here. Will be detected
 	 * on first vcpu run instead.
 	 */
 	addr = 3 * 2 * 0x10000;
-	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, KVM_VGIC_V3_ADDR_TYPE_DIST,
-				 &addr, true);
-	TEST_ASSERT(!ret, "dist overlapping rdist");
+	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, KVM_VGIC_V3_ADDR_TYPE_DIST,
+			  &addr, true);
 }
 
 /* Test the new REDIST region API */
@@ -166,57 +157,59 @@ static void subtest_redist_regions(struct vm_gic *v)
 	addr = REDIST_REGION_ATTR_ADDR(NR_VCPUS, 0x100000, 2, 0);
 	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
-	TEST_ASSERT(ret == -EINVAL, "redist region attr value with flags != 0");
+	TEST_ASSERT(ret && errno == EINVAL, "redist region attr value with flags != 0");
 
 	addr = REDIST_REGION_ATTR_ADDR(0, 0x100000, 0, 0);
 	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
-	TEST_ASSERT(ret == -EINVAL, "redist region attr value with count== 0");
+	TEST_ASSERT(ret && errno == EINVAL, "redist region attr value with count== 0");
 
 	addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 1);
 	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
-	TEST_ASSERT(ret == -EINVAL, "attempt to register the first rdist region with index != 0");
+	TEST_ASSERT(ret && errno == EINVAL,
+		    "attempt to register the first rdist region with index != 0");
 
 	addr = REDIST_REGION_ATTR_ADDR(2, 0x201000, 0, 1);
 	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
-	TEST_ASSERT(ret == -EINVAL, "rdist region with misaligned address");
+	TEST_ASSERT(ret && errno == EINVAL, "rdist region with misaligned address");
 
 	addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 0);
-	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
-	TEST_ASSERT(!ret, "First valid redist region with 2 rdist @ 0x200000, index 0");
+	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
 
 	addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 1);
 	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
-	TEST_ASSERT(ret == -EINVAL, "register an rdist region with already used index");
+	TEST_ASSERT(ret && errno == EINVAL, "register an rdist region with already used index");
 
 	addr = REDIST_REGION_ATTR_ADDR(1, 0x210000, 0, 2);
 	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
-	TEST_ASSERT(ret == -EINVAL, "register an rdist region overlapping with another one");
+	TEST_ASSERT(ret && errno == EINVAL,
+		    "register an rdist region overlapping with another one");
 
 	addr = REDIST_REGION_ATTR_ADDR(1, 0x240000, 0, 2);
 	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
-	TEST_ASSERT(ret == -EINVAL, "register redist region with index not +1");
+	TEST_ASSERT(ret && errno == EINVAL, "register redist region with index not +1");
 
 	addr = REDIST_REGION_ATTR_ADDR(1, 0x240000, 0, 1);
-	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
-	TEST_ASSERT(!ret, "register valid redist region with 1 rdist @ 0x220000, index 1");
+	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
 
 	addr = REDIST_REGION_ATTR_ADDR(1, 1ULL << max_ipa_bits, 0, 2);
 	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
-	TEST_ASSERT(ret == -E2BIG, "register redist region with base address beyond IPA range");
+	TEST_ASSERT(ret && errno == E2BIG,
+		    "register redist region with base address beyond IPA range");
 
 	addr = 0x260000;
 	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
-	TEST_ASSERT(ret == -EINVAL, "Mix KVM_VGIC_V3_ADDR_TYPE_REDIST and REDIST_REGION");
+	TEST_ASSERT(ret && errno == EINVAL,
+		    "Mix KVM_VGIC_V3_ADDR_TYPE_REDIST and REDIST_REGION");
 
 	/*
 	 * Now there are 2 redist regions:
@@ -240,17 +233,16 @@ static void subtest_redist_regions(struct vm_gic *v)
 	addr = REDIST_REGION_ATTR_ADDR(0, 0, 0, 2);
 	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, false);
-	TEST_ASSERT(ret == -ENOENT, "read characteristics of non existing region");
+	TEST_ASSERT(ret && errno == ENOENT, "read characteristics of non existing region");
 
 	addr = 0x260000;
-	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
-	TEST_ASSERT(!ret, "set dist region");
+	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			  KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
 
 	addr = REDIST_REGION_ATTR_ADDR(1, 0x260000, 0, 2);
 	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
-	TEST_ASSERT(ret == -EINVAL, "register redist region colliding with dist");
+	TEST_ASSERT(ret && errno == EINVAL, "register redist region colliding with dist");
 }
 
 /*
@@ -264,7 +256,6 @@ static void test_vgic_then_vcpus(void)
 
 	v.vm = vm_create_default(0, 0, guest_code);
 	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
-	TEST_ASSERT(v.gic_fd > 0, "GICv3 device created");
 
 	subtest_dist_rdist(&v);
 
@@ -272,7 +263,6 @@ static void test_vgic_then_vcpus(void)
 	for (i = 1; i < NR_VCPUS; ++i)
 		vm_vcpu_add_default(v.vm, i, guest_code);
 
-	ucall_init(v.vm, NULL);
 	ret = run_vcpu(v.vm, 3);
 	TEST_ASSERT(ret == -EINVAL, "dist/rdist overlap detected on 1st vcpu run");
 
@@ -289,7 +279,6 @@ static void test_vcpus_then_vgic(void)
 
 	subtest_dist_rdist(&v);
 
-	ucall_init(v.vm, NULL);
 	ret = run_vcpu(v.vm, 3);
 	TEST_ASSERT(ret == -EINVAL, "dist/rdist overlap detected on 1st vcpu run");
 
@@ -305,11 +294,9 @@ static void test_new_redist_regions(void)
 
 	v = vm_gic_create();
 	subtest_redist_regions(&v);
-	ret = _kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
-				 KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
-	TEST_ASSERT(!ret, "init the vgic");
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
 
-	ucall_init(v.vm, NULL);
 	ret = run_vcpu(v.vm, 3);
 	TEST_ASSERT(ret == -ENXIO, "running without sufficient number of rdists");
 	vm_gic_destroy(&v);
@@ -320,11 +307,9 @@ static void test_new_redist_regions(void)
 	subtest_redist_regions(&v);
 
 	addr = REDIST_REGION_ATTR_ADDR(1, 0x280000, 0, 2);
-	ret = _kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
-	TEST_ASSERT(!ret, "register a third region allowing to cover the 4 vcpus");
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
 
-	ucall_init(v.vm, NULL);
 	ret = run_vcpu(v.vm, 3);
 	TEST_ASSERT(ret == -EBUSY, "running without vgic explicit init");
 
@@ -335,20 +320,18 @@ static void test_new_redist_regions(void)
 	v = vm_gic_create();
 	subtest_redist_regions(&v);
 
-	ret = _kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, dummy, true);
-	TEST_ASSERT(ret == -EFAULT, "register a third region allowing to cover the 4 vcpus");
+	_kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, dummy, true);
+	TEST_ASSERT(ret && errno == EFAULT,
+		    "register a third region allowing to cover the 4 vcpus");
 
 	addr = REDIST_REGION_ATTR_ADDR(1, 0x280000, 0, 2);
-	ret = _kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
-	TEST_ASSERT(!ret, "register a third region allowing to cover the 4 vcpus");
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
 
-	ret = _kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
-				 KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
-	TEST_ASSERT(!ret, "init the vgic");
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
 
-	ucall_init(v.vm, NULL);
 	ret = run_vcpu(v.vm, 3);
 	TEST_ASSERT(!ret, "vcpu run");
 
@@ -357,76 +340,71 @@ static void test_new_redist_regions(void)
 
 static void test_typer_accesses(void)
 {
-	int ret, i, gicv3_fd = -1;
+	struct vm_gic v;
 	uint64_t addr;
-	struct kvm_vm *vm;
 	uint32_t val;
+	int ret, i;
 
-	vm = vm_create_default(0, 0, guest_code);
+	v.vm = vm_create_default(0, 0, guest_code);
 
-	gicv3_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
-	TEST_ASSERT(gicv3_fd >= 0, "VGIC_V3 device created");
+	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
 
-	vm_vcpu_add_default(vm, 3, guest_code);
+	vm_vcpu_add_default(v.vm, 3, guest_code);
 
-	ret = access_redist_reg(gicv3_fd, 1, GICR_TYPER, &val, false);
-	TEST_ASSERT(ret == -EINVAL, "attempting to read GICR_TYPER of non created vcpu");
+	ret = access_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
+	TEST_ASSERT(ret && errno == EINVAL, "attempting to read GICR_TYPER of non created vcpu");
 
-	vm_vcpu_add_default(vm, 1, guest_code);
+	vm_vcpu_add_default(v.vm, 1, guest_code);
 
-	ret = access_redist_reg(gicv3_fd, 1, GICR_TYPER, &val, false);
-	TEST_ASSERT(ret == -EBUSY, "read GICR_TYPER before GIC initialized");
+	ret = access_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
+	TEST_ASSERT(ret && errno == EBUSY, "read GICR_TYPER before GIC initialized");
 
-	vm_vcpu_add_default(vm, 2, guest_code);
+	vm_vcpu_add_default(v.vm, 2, guest_code);
 
-	ret = _kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
-				 KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
-	TEST_ASSERT(!ret, "init the vgic after the vcpu creations");
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
 
 	for (i = 0; i < NR_VCPUS ; i++) {
-		ret = access_redist_reg(gicv3_fd, 0, GICR_TYPER, &val, false);
+		ret = access_redist_reg(v.gic_fd, 0, GICR_TYPER, &val, false);
 		TEST_ASSERT(!ret && !val, "read GICR_TYPER before rdist region setting");
 	}
 
 	addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 0);
-	ret = _kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
-	TEST_ASSERT(!ret, "first rdist region with a capacity of 2 rdists");
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
 
 	/* The 2 first rdists should be put there (vcpu 0 and 3) */
-	ret = access_redist_reg(gicv3_fd, 0, GICR_TYPER, &val, false);
+	ret = access_redist_reg(v.gic_fd, 0, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && !val, "read typer of rdist #0");
 
-	ret = access_redist_reg(gicv3_fd, 3, GICR_TYPER, &val, false);
+	ret = access_redist_reg(v.gic_fd, 3, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x310, "read typer of rdist #1");
 
 	addr = REDIST_REGION_ATTR_ADDR(10, 0x100000, 0, 1);
-	ret = _kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+	ret = _kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
-	TEST_ASSERT(ret == -EINVAL, "collision with previous rdist region");
+	TEST_ASSERT(ret && errno == EINVAL, "collision with previous rdist region");
 
-	ret = access_redist_reg(gicv3_fd, 1, GICR_TYPER, &val, false);
+	ret = access_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x100,
 		    "no redist region attached to vcpu #1 yet, last cannot be returned");
 
-	ret = access_redist_reg(gicv3_fd, 2, GICR_TYPER, &val, false);
+	ret = access_redist_reg(v.gic_fd, 2, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x200,
 		    "no redist region attached to vcpu #2, last cannot be returned");
 
 	addr = REDIST_REGION_ATTR_ADDR(10, 0x20000, 0, 1);
-	ret = _kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
-	TEST_ASSERT(!ret, "second rdist region");
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
 
-	ret = access_redist_reg(gicv3_fd, 1, GICR_TYPER, &val, false);
+	ret = access_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x100, "read typer of rdist #1");
 
-	ret = access_redist_reg(gicv3_fd, 2, GICR_TYPER, &val, false);
+	ret = access_redist_reg(v.gic_fd, 2, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x210,
 		    "read typer of rdist #1, last properly returned");
 
-	close(gicv3_fd);
-	kvm_vm_free(vm);
+	vm_gic_destroy(&v);
 }
 
 /**
@@ -442,127 +420,116 @@ static void test_typer_accesses(void)
 static void test_last_bit_redist_regions(void)
 {
 	uint32_t vcpuids[] = { 0, 3, 5, 4, 1, 2 };
-	int ret, gicv3_fd;
+	struct vm_gic v;
 	uint64_t addr;
-	struct kvm_vm *vm;
 	uint32_t val;
+	int ret;
 
-	vm = vm_create_default_with_vcpus(6, 0, 0, guest_code, vcpuids);
+	v.vm = vm_create_default_with_vcpus(6, 0, 0, guest_code, vcpuids);
 
-	gicv3_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
-	TEST_ASSERT(gicv3_fd >= 0, "VGIC_V3 device created");
+	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
 
-	ret = _kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
-				 KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
-	TEST_ASSERT(!ret, "init the vgic after the vcpu creations");
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
 
 	addr = REDIST_REGION_ATTR_ADDR(2, 0x100000, 0, 0);
-	ret = _kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
-	TEST_ASSERT(!ret, "rdist region #0 (2 rdist)");
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
 
 	addr = REDIST_REGION_ATTR_ADDR(2, 0x240000, 0, 1);
-	ret = _kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
-	TEST_ASSERT(!ret, "rdist region #1 (1 rdist) contiguous with #2");
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
 
 	addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 2);
-	ret = _kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
-	TEST_ASSERT(!ret, "rdist region #2 with a capacity of 2 rdists");
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
 
-	ret = access_redist_reg(gicv3_fd, 0, GICR_TYPER, &val, false);
+	ret = access_redist_reg(v.gic_fd, 0, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x000, "read typer of rdist #0");
 
-	ret = access_redist_reg(gicv3_fd, 1, GICR_TYPER, &val, false);
+	ret = access_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x100, "read typer of rdist #1");
 
-	ret = access_redist_reg(gicv3_fd, 2, GICR_TYPER, &val, false);
+	ret = access_redist_reg(v.gic_fd, 2, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x200, "read typer of rdist #2");
 
-	ret = access_redist_reg(gicv3_fd, 3, GICR_TYPER, &val, false);
+	ret = access_redist_reg(v.gic_fd, 3, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x310, "read typer of rdist #3");
 
-	ret = access_redist_reg(gicv3_fd, 5, GICR_TYPER, &val, false);
+	ret = access_redist_reg(v.gic_fd, 5, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x500, "read typer of rdist #5");
 
-	ret = access_redist_reg(gicv3_fd, 4, GICR_TYPER, &val, false);
+	ret = access_redist_reg(v.gic_fd, 4, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x410, "read typer of rdist #4");
 
-	close(gicv3_fd);
-	kvm_vm_free(vm);
+	vm_gic_destroy(&v);
 }
 
 /* Test last bit with legacy region */
 static void test_last_bit_single_rdist(void)
 {
 	uint32_t vcpuids[] = { 0, 3, 5, 4, 1, 2 };
-	int ret, gicv3_fd;
+	struct vm_gic v;
 	uint64_t addr;
-	struct kvm_vm *vm;
 	uint32_t val;
+	int ret;
 
-	vm = vm_create_default_with_vcpus(6, 0, 0, guest_code, vcpuids);
+	v.vm = vm_create_default_with_vcpus(6, 0, 0, guest_code, vcpuids);
 
-	gicv3_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
-	TEST_ASSERT(gicv3_fd >= 0, "VGIC_V3 device created");
+	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
 
-	ret = _kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
-				 KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
-	TEST_ASSERT(!ret, "init the vgic after the vcpu creations");
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
 
 	addr = 0x10000;
-	ret = _kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			  KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
 
-	ret = access_redist_reg(gicv3_fd, 0, GICR_TYPER, &val, false);
+	ret = access_redist_reg(v.gic_fd, 0, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x000, "read typer of rdist #0");
 
-	ret = access_redist_reg(gicv3_fd, 3, GICR_TYPER, &val, false);
+	ret = access_redist_reg(v.gic_fd, 3, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x300, "read typer of rdist #1");
 
-	ret = access_redist_reg(gicv3_fd, 5, GICR_TYPER, &val, false);
+	ret = access_redist_reg(v.gic_fd, 5, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x500, "read typer of rdist #2");
 
-	ret = access_redist_reg(gicv3_fd, 1, GICR_TYPER, &val, false);
+	ret = access_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x100, "read typer of rdist #3");
 
-	ret = access_redist_reg(gicv3_fd, 2, GICR_TYPER, &val, false);
+	ret = access_redist_reg(v.gic_fd, 2, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x210, "read typer of rdist #3");
 
-	close(gicv3_fd);
-	kvm_vm_free(vm);
+	vm_gic_destroy(&v);
 }
 
 void test_kvm_device(void)
 {
 	struct vm_gic v;
-	int ret;
+	int ret, fd;
 
 	v.vm = vm_create_default_with_vcpus(NR_VCPUS, 0, 0, guest_code, NULL);
 
 	/* try to create a non existing KVM device */
-	ret = _kvm_create_device(v.vm, 0, true);
-	TEST_ASSERT(ret == -ENODEV, "unsupported device");
+	ret = _kvm_create_device(v.vm, 0, true, &fd);
+	TEST_ASSERT(ret && errno == ENODEV, "unsupported device");
 
 	/* trial mode with VGIC_V3 device */
-	ret = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, true);
+	ret = _kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, true, &fd);
 	if (ret) {
 		print_skip("GICv3 not supported");
 		exit(KSFT_SKIP);
 	}
 	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
-	TEST_ASSERT(v.gic_fd, "create the GICv3 device");
 
-	ret = _kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
-	TEST_ASSERT(ret == -EEXIST, "create GICv3 device twice");
+	ret = _kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false, &fd);
+	TEST_ASSERT(ret && errno == EEXIST, "create GICv3 device twice");
 
-	ret = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, true);
-	TEST_ASSERT(!ret, "create GICv3 in test mode while the same already is created");
+	kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, true);
 
-	if (!_kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V2, true)) {
-		ret = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V2, false);
-		TEST_ASSERT(ret == -EINVAL, "create GICv2 while v3 exists");
+	if (!_kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V2, true, &fd)) {
+		ret = _kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V2, false, &fd);
+		TEST_ASSERT(ret && errno == EINVAL, "create GICv2 while v3 exists");
 	}
 
 	vm_gic_destroy(&v);
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 2b4b325cde01..56ac3cf76168 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -227,7 +227,7 @@ void *vcpu_map_dirty_ring(struct kvm_vm *vm, uint32_t vcpuid);
 
 int _kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr);
 int kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr);
-int _kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test);
+int _kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test, int *fd);
 int kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test);
 int _kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 		       void *val, bool write);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index db2a252be917..77111241aba7 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1744,22 +1744,19 @@ int _kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr)
 		.attr = attr,
 		.flags = 0,
 	};
-	int ret = ioctl(dev_fd, KVM_HAS_DEVICE_ATTR, &attribute);
 
-	if (ret == -1)
-		return -errno;
-	return 0;
+	return ioctl(dev_fd, KVM_HAS_DEVICE_ATTR, &attribute);
 }
 
 int kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr)
 {
 	int ret = _kvm_device_check_attr(dev_fd, group, attr);
 
-	TEST_ASSERT(ret >= 0, "KVM_HAS_DEVICE_ATTR failed, errno: %i", errno);
+	TEST_ASSERT(ret >= 0, "KVM_HAS_DEVICE_ATTR failed, rc: %i errno: %i", ret, errno);
 	return ret;
 }
 
-int _kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test)
+int _kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test, int *fd)
 {
 	struct kvm_create_device create_dev;
 	int ret;
@@ -1768,17 +1765,21 @@ int _kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test)
 	create_dev.fd = -1;
 	create_dev.flags = test ? KVM_CREATE_DEVICE_TEST : 0;
 	ret = ioctl(vm_get_fd(vm), KVM_CREATE_DEVICE, &create_dev);
-	if (ret == -1)
-		return -errno;
-	return test ? 0 : create_dev.fd;
+	*fd = create_dev.fd;
+	return ret;
 }
 
 int kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test)
 {
-	int ret = _kvm_create_device(vm, type, test);
+	int fd, ret;
 
-	TEST_ASSERT(ret >= 0, "KVM_CREATE_DEVICE IOCTL failed,\n"
-		"  errno: %i", errno);
+	ret = _kvm_create_device(vm, type, test, &fd);
+
+	if (!test) {
+		TEST_ASSERT(ret >= 0,
+			    "KVM_CREATE_DEVICE IOCTL failed, rc: %i errno: %i", ret, errno);
+		return fd;
+	}
 	return ret;
 }
 
@@ -1795,8 +1796,6 @@ int _kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 
 	ret = ioctl(dev_fd, write ? KVM_SET_DEVICE_ATTR : KVM_GET_DEVICE_ATTR,
 		    &kvmattr);
-	if (ret < 0)
-		return -errno;
 	return ret;
 }
 
@@ -1805,8 +1804,7 @@ int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 {
 	int ret = _kvm_device_access(dev_fd, group, attr, val, write);
 
-	TEST_ASSERT(ret >= 0, "KVM_SET|GET_DEVICE_ATTR IOCTL failed,\n"
-		    "  errno: %i", errno);
+	TEST_ASSERT(ret >= 0, "KVM_SET|GET_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
 	return ret;
 }
 
-- 
2.26.3

