Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5BD41B6A2
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 20:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242320AbhI1SuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 14:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242325AbhI1St7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 14:49:59 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85871C06161C
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 11:48:19 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id n19-20020ac81e13000000b0029f679691eeso101743235qtl.20
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 11:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mHySpLUqTDg2OB2pZY1bzI1vpeSiB7OP7e6Vc0QQG+g=;
        b=VdvlANnvR3RqyiBGqGl3eMdfcfQH5712cpPKL1c6Zt/rfwR0XN3tcGqfT+erFk2Pq8
         RynqD/nM+P0GjEdra9i0wRPNaexE8mA/Lp6sr1JFz5hJd4BvjZpaPybF7x7jSmJA9K+a
         kdT6bfWUVgMt02H9o9Qyq3SHi8M7uybF6kPXzkn9BGhciix4nAk5zCmToHryezn/CwpV
         pKXzG+rxAG2SUd2MxNx61Sp9V76W9fX5qpKCsV9vXUHGfV6z76HlS7P82sKShhl9dBtN
         2g/qbLi47kJb28BaIUA0D16w4MjLnuQ6JDfdV0Fjvq2rZwuFZ5MGAHq2hDj3qpDV3hvr
         wGdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mHySpLUqTDg2OB2pZY1bzI1vpeSiB7OP7e6Vc0QQG+g=;
        b=zMXrEHrmnFXOKYkpup0eVv0MiO4HX8VYJiPS/9tHz2ffgOUKsN33i5XMVB8UrEPx4S
         JX9QDaBhMk3bwa9MnpcOdaIdmiWShPb9ew3LFT/FwDmHV9AdTyGdu0rrLDbSeK347Dff
         3YfDQlt9z6HY8GD2d7V1XvlBmpPOKFruyvCb9eU0HK+omn4HXiPA6zYFBdV3bBSJrH3E
         aN6gs9gEr7YXk+UQLyMq/+CXNLiAz1EU/ddLM7OLfrGG9bGlq5UlCGV70oMlUnau0x8b
         eVkMTRM5EkOCJH0CXpHkSozVH4CnudYkwjZf/XIsN3OGYuOiedg/NJGj/nW+gAMk55m4
         swDg==
X-Gm-Message-State: AOAM530sAoNDwcj9mpbX9R7OlB5THt8JLLwjBX1FPtBsrG0vhfQ92+Ym
        /oLPy7jAHS+ksJeB+SQFIiRjR8sHW29QWkAhhsSSPSbVpRJoSMHXUNwqExozeq2dr03su+qq1Yg
        9jppYsqkBoeVojcF8D3pmcxm1+BAI/0BvnIH5KHV4HkViKoMoZbL7atQ4T+9AuLs=
X-Google-Smtp-Source: ABdhPJwQKH6fCAaEup/HmoIhJjFbFyqIH4bHW1FHY/Faj8Qt4SMle1i01LllAvPY40KlDIjaZma+5pz9qAFv4g==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a0c:a78a:: with SMTP id
 v10mr7107973qva.49.1632854898150; Tue, 28 Sep 2021 11:48:18 -0700 (PDT)
Date:   Tue, 28 Sep 2021 11:48:01 -0700
In-Reply-To: <20210928184803.2496885-1-ricarkol@google.com>
Message-Id: <20210928184803.2496885-8-ricarkol@google.com>
Mime-Version: 1.0
References: <20210928184803.2496885-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v3 07/10] KVM: arm64: selftests: Add some tests for GICv2 in vgic_init
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

Add some GICv2 tests: general KVM device tests and DIST/REDIST overlap
tests.  Do this by making test_vcpus_then_vgic and test_vgic_then_vcpus
in vgic_init GIC version agnostic.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 107 ++++++++++++------
 1 file changed, 75 insertions(+), 32 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index b24067dbdac0..92f5c6ca6b8b 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -79,74 +79,116 @@ static void vm_gic_destroy(struct vm_gic *v)
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
+ * DIST/REDIST. A RDIST region (legacy in the case of GICv3) is set at @0x0 and
+ * a DIST region is set @0x70000 for GICv3 and @0x1000 for GICv2.
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
+	if (VGIC_DEV_IS_V3(v->gic_dev_type)) {
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
@@ -256,14 +298,14 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
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
@@ -276,14 +318,14 @@ static void test_v3_vgic_then_vcpus(uint32_t gic_dev_type)
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
@@ -552,9 +594,10 @@ int test_kvm_device(uint32_t gic_dev_type)
 
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
2.33.0.685.g46640cef36-goog

