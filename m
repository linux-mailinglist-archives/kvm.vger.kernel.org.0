Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D78E421BC4
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 03:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhJEBV1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 21:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbhJEBV0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 21:21:26 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D919C061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 18:19:37 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id f8-20020a2585480000b02905937897e3daso26176987ybn.2
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 18:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xZ3lpAQvqvEeyK874ekrhdyFJaFrtuodkxZuQJWmclc=;
        b=jgZT1Lggck69qe6woDJ0WTw1urdpeGjzK3yYEYJULq1ZsKqtfYNe0hkSjvtjFxy3JV
         aAiL9OZTv2WA0JaITcIu3c4MU807tUIb9ZG0YiVzcNCWJU/ZZJDZZmoAEvWQqru8kGqV
         zQ6SMe80Ds841k7BSsck/jrTNXbKce3qabnTwZKBb7FES3n+N2kivohi2luqh+2E45DW
         IXsCEkuZ4iKC8GYxwUedf9DpSzHosJzi8inbjq0rG8PIPaH1S9CG549Qq1epj05z2D8P
         NhkEE1sB7ekIjDtwhKUhG6OjKngT1kACs72kX2ACpuYIlxIVFiGjcoNDBEV0Y/YMydwU
         BeDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xZ3lpAQvqvEeyK874ekrhdyFJaFrtuodkxZuQJWmclc=;
        b=drgFpinDv3mpwkfm/X4fDSZElEXv+NfcEsZ0PN67DZ3HmK4gAlCivYlkEm+knNJQ5M
         EUeM5gvAIjjrniv0UMg/y2jANBB8zVaq6/kL/a1tzPl76L2oyR+8p8LbUppu4N7o6m5H
         n92q64/OGjF3Z5AwXFP4xCuov/+desFSlStLpF71so4RumzPQm6a6Z+bWdVHYRuxSEQi
         x6cC5AjRk0LAhVX1K9DDnSOot97eBT6qDV8AqXz+/vil3MdRxMECC2aLlvYI6zkPu7Tb
         LizJQvntOh7Enc66YIGquVmLD3CDJjAsCymw5Ul50WOAkmp+IKxb5eOrzlQNFoGaHHZN
         ywag==
X-Gm-Message-State: AOAM533YIKE5IbWZcjtbxdZNbpMCgRV+DztfEjqhLLjW8D99+7t0fblr
        /dVcnm4OHjiw3a+1UAdQKKpe+M3r8NMPv+h+5AiWmTVjljbDnVjgCG87SAsFbqm4TGMBJ99uSjl
        3SCtws6voPlzcmzz3UVksSCP44A149RQ9VnaKW+PwsiPfiee1mtE+zvhvjT+eG6w=
X-Google-Smtp-Source: ABdhPJxQzuNxg9iNW+ZJGfZqm2MUI5dcNt8rKxttbtIEU4oUWm8qSH7TZUi5okLbCXgyrCgYEoxcL227cXvoYA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:7ec4:: with SMTP id
 z187mr18936928ybc.35.1633396776240; Mon, 04 Oct 2021 18:19:36 -0700 (PDT)
Date:   Mon,  4 Oct 2021 18:19:18 -0700
In-Reply-To: <20211005011921.437353-1-ricarkol@google.com>
Message-Id: <20211005011921.437353-9-ricarkol@google.com>
Mime-Version: 1.0
References: <20211005011921.437353-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v4 08/11] KVM: arm64: selftests: Add some tests for GICv2 in vgic_init
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

Add some GICv2 tests: general KVM device tests and DIST/CPUIF overlap
tests.  Do this by making test_vcpus_then_vgic and test_vgic_then_vcpus
in vgic_init GIC version agnostic.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 111 +++++++++++++-----
 1 file changed, 79 insertions(+), 32 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 7521dc80cf23..cb69e195ad1d 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -79,74 +79,120 @@ static void vm_gic_destroy(struct vm_gic *v)
 	kvm_vm_free(v->vm);
 }
 
+struct vgic_region_attr {
+	uint64_t attr;
+	uint64_t size;
+	uint64_t alignment;
+};
+
+struct vgic_region_attr gic_v3_dist_region = {
+	.attr = KVM_VGIC_V3_ADDR_TYPE_DIST,
+	.size = 0x10000,
+	.alignment = 0x10000,
+};
+
+struct vgic_region_attr gic_v3_redist_region = {
+	.attr = KVM_VGIC_V3_ADDR_TYPE_REDIST,
+	.size = NR_VCPUS * 0x20000,
+	.alignment = 0x10000,
+};
+
+struct vgic_region_attr gic_v2_dist_region = {
+	.attr = KVM_VGIC_V2_ADDR_TYPE_DIST,
+	.size = 0x1000,
+	.alignment = 0x1000,
+};
+
+struct vgic_region_attr gic_v2_cpu_region = {
+	.attr = KVM_VGIC_V2_ADDR_TYPE_CPU,
+	.size = 0x2000,
+	.alignment = 0x1000,
+};
+
 /**
- * Helper routine that performs KVM device tests in general and
- * especially ARM_VGIC_V3 ones. Eventually the ARM_VGIC_V3
- * device gets created, a legacy RDIST region is set at @0x0
- * and a DIST region is set @0x60000
+ * Helper routine that performs KVM device tests in general. Eventually the
+ * ARM_VGIC (GICv2 or GICv3) device gets created with an overlapping
+ * DIST/REDIST (or DIST/CPUIF for GICv2). Assumption is 4 vcpus are going to be
+ * used hence the overlap. In the case of GICv3, A RDIST region is set at @0x0
+ * and a DIST region is set @0x70000. The GICv2 case sets a CPUIF @0x0 and a
+ * DIST region @0x1000.
  */
-static void subtest_v3_dist_rdist(struct vm_gic *v)
+static void subtest_dist_rdist(struct vm_gic *v)
 {
 	int ret;
 	uint64_t addr;
+	struct vgic_region_attr rdist; /* CPU interface in GICv2*/
+	struct vgic_region_attr dist;
+
+	rdist = VGIC_DEV_IS_V3(v->gic_dev_type) ? gic_v3_redist_region
+						: gic_v2_cpu_region;
+	dist = VGIC_DEV_IS_V3(v->gic_dev_type) ? gic_v3_dist_region
+						: gic_v2_dist_region;
 
 	/* Check existing group/attributes */
 	kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			      KVM_VGIC_V3_ADDR_TYPE_DIST);
+			      dist.attr);
 
 	kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			      KVM_VGIC_V3_ADDR_TYPE_REDIST);
+			      rdist.attr);
 
 	/* check non existing attribute */
-	ret = _kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, 0);
+	ret = _kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, -1);
 	TEST_ASSERT(ret && errno == ENXIO, "attribute not supported");
 
 	/* misaligned DIST and REDIST address settings */
-	addr = 0x1000;
+	addr = dist.alignment / 0x10;
 	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
-	TEST_ASSERT(ret && errno == EINVAL, "GICv3 dist base not 64kB aligned");
+				 dist.attr, &addr, true);
+	TEST_ASSERT(ret && errno == EINVAL, "GIC dist base not aligned");
 
+	addr = rdist.alignment / 0x10;
 	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
-	TEST_ASSERT(ret && errno == EINVAL, "GICv3 redist base not 64kB aligned");
+				 rdist.attr, &addr, true);
+	TEST_ASSERT(ret && errno == EINVAL, "GIC redist/cpu base not aligned");
 
 	/* out of range address */
 	if (max_ipa_bits) {
 		addr = 1ULL << max_ipa_bits;
 		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-					 KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
+					 dist.attr, &addr, true);
 		TEST_ASSERT(ret && errno == E2BIG, "dist address beyond IPA limit");
 
 		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-					 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+					 rdist.attr, &addr, true);
 		TEST_ASSERT(ret && errno == E2BIG, "redist address beyond IPA limit");
 	}
 
 	/* set REDIST base address @0x0*/
 	addr = 0x00000;
 	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			  KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+			  rdist.attr, &addr, true);
 
 	/* Attempt to create a second legacy redistributor region */
 	addr = 0xE0000;
 	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
-	TEST_ASSERT(ret && errno == EEXIST, "GICv3 redist base set again");
+				 rdist.attr, &addr, true);
+	TEST_ASSERT(ret && errno == EEXIST, "GIC redist base set again");
 
-	/* Attempt to mix legacy and new redistributor regions */
-	addr = REDIST_REGION_ATTR_ADDR(NR_VCPUS, 0x100000, 0, 0);
-	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
-	TEST_ASSERT(ret && errno == EINVAL, "attempt to mix GICv3 REDIST and REDIST_REGION");
+	ret = _kvm_device_check_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				     KVM_VGIC_V3_ADDR_TYPE_REDIST);
+	if (!ret) {
+		/* Attempt to mix legacy and new redistributor regions */
+		addr = REDIST_REGION_ATTR_ADDR(NR_VCPUS, 0x100000, 0, 0);
+		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+					 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION,
+					 &addr, true);
+		TEST_ASSERT(ret && errno == EINVAL,
+			    "attempt to mix GICv3 REDIST and REDIST_REGION");
+	}
 
 	/*
 	 * Set overlapping DIST / REDIST, cannot be detected here. Will be detected
 	 * on first vcpu run instead.
 	 */
-	addr = 3 * 2 * 0x10000;
-	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR, KVM_VGIC_V3_ADDR_TYPE_DIST,
-			  &addr, true);
+	addr = rdist.size - rdist.alignment;
+	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			  dist.attr, &addr, true);
 }
 
 /* Test the new REDIST region API */
@@ -254,14 +300,14 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
  * VGIC KVM device is created and initialized before the secondary CPUs
  * get created
  */
-static void test_v3_vgic_then_vcpus(uint32_t gic_dev_type)
+static void test_vgic_then_vcpus(uint32_t gic_dev_type)
 {
 	struct vm_gic v;
 	int ret, i;
 
 	v = vm_gic_create_with_vcpus(gic_dev_type, 1);
 
-	subtest_v3_dist_rdist(&v);
+	subtest_dist_rdist(&v);
 
 	/* Add the rest of the VCPUs */
 	for (i = 1; i < NR_VCPUS; ++i)
@@ -274,14 +320,14 @@ static void test_v3_vgic_then_vcpus(uint32_t gic_dev_type)
 }
 
 /* All the VCPUs are created before the VGIC KVM device gets initialized */
-static void test_v3_vcpus_then_vgic(uint32_t gic_dev_type)
+static void test_vcpus_then_vgic(uint32_t gic_dev_type)
 {
 	struct vm_gic v;
 	int ret;
 
 	v = vm_gic_create_with_vcpus(gic_dev_type, NR_VCPUS);
 
-	subtest_v3_dist_rdist(&v);
+	subtest_dist_rdist(&v);
 
 	ret = run_vcpu(v.vm, 3);
 	TEST_ASSERT(ret == -EINVAL, "dist/rdist overlap detected on 1st vcpu run");
@@ -550,9 +596,10 @@ int test_kvm_device(uint32_t gic_dev_type)
 
 void run_tests(uint32_t gic_dev_type)
 {
+	test_vcpus_then_vgic(gic_dev_type);
+	test_vgic_then_vcpus(gic_dev_type);
+
 	if (VGIC_DEV_IS_V3(gic_dev_type)) {
-		test_v3_vcpus_then_vgic(gic_dev_type);
-		test_v3_vgic_then_vcpus(gic_dev_type);
 		test_v3_new_redist_regions();
 		test_v3_typer_accesses();
 		test_v3_last_bit_redist_regions();
-- 
2.33.0.800.g4c38ced690-goog

