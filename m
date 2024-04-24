Return-Path: <kvm+bounces-15853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 680408B1150
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 19:40:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 47BDEB254C5
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 17:40:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F66216D304;
	Wed, 24 Apr 2024 17:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KSR/cdr+"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE0216D4F1
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 17:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713980417; cv=none; b=X8KhOHewpFesH5JqQ7H85tiDWMn7vnJGSP5Z+/eT9jvuDASz5d/PYVCNGMjRz7zZ3p18gntWAcBP5y6OpFRerJCfK/m4l5O/rdg0pSs/Hg9DELJi3Fyd4WlJO6gA80JgdAd07Vs4sdCchE+4s1x/xqNO9gm7eptcAjpu/KdUcD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713980417; c=relaxed/simple;
	bh=XgLH8kWSTkA+WtHqtY6ncvyiTFlCFYIhHap1Lps/lNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H7/Du3/Xk3gU90G3gXcRZ/oBOGZ4YQLVnrGaYcBDjf9DYGgX6RjbF/tbeykjktDMXHZVX2J9cbdqR78oh3NSkB0n7omx30mx1SprooOT0Nh+2LcgU40PbyVBz79ELCcBLjwo/0ulCNm/Btvai1ZJEwI4NOVBwZBTRhbbZRr9X7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KSR/cdr+; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713980413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gtZdgbigg758bNTMCp0fzU9LG1Z3TPEX6lsyoV+Ixoc=;
	b=KSR/cdr+knbDDYlRlbKFF6Yn6JrRsFW64+j+11vKJjdd1K10z3+EdnndG0tGUedJTo9hGy
	mnquDDGuywYFrPAW53ONCzmbvenYfO1XQDbJHnIOEfrtBZPWHfZ+w/+09nTSuzzQpBRf0G
	pwMzHSLbcQ28R6JqZZTtc955jKdhgM8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/2] KVM: selftests: Add test for uaccesses to non-existent vgic-v2 CPUIF
Date: Wed, 24 Apr 2024 17:39:59 +0000
Message-ID: <20240424173959.3776798-3-oliver.upton@linux.dev>
In-Reply-To: <20240424173959.3776798-1-oliver.upton@linux.dev>
References: <20240424173959.3776798-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Assert that accesses to a non-existent vgic-v2 CPU interface
consistently fail across the various KVM device attr ioctls. This also
serves as a regression test for a bug wherein KVM hits a NULL
dereference when the CPUID specified in the ioctl is invalid.

Note that there is no need to print the observed errno, as TEST_ASSERT()
will take care of it.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 49 +++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index eef816b80993..ca917c71ff60 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -84,6 +84,18 @@ static struct vm_gic vm_gic_create_with_vcpus(uint32_t gic_dev_type,
 	return v;
 }
 
+static struct vm_gic vm_gic_create_barebones(uint32_t gic_dev_type)
+{
+	struct vm_gic v;
+
+	v.gic_dev_type = gic_dev_type;
+	v.vm = vm_create_barebones();
+	v.gic_fd = kvm_create_device(v.vm, gic_dev_type);
+
+	return v;
+}
+
+
 static void vm_gic_destroy(struct vm_gic *v)
 {
 	close(v->gic_fd);
@@ -357,6 +369,40 @@ static void test_vcpus_then_vgic(uint32_t gic_dev_type)
 	vm_gic_destroy(&v);
 }
 
+#define KVM_VGIC_V2_ATTR(offset, cpu) \
+	(FIELD_PREP(KVM_DEV_ARM_VGIC_OFFSET_MASK, offset) | \
+	 FIELD_PREP(KVM_DEV_ARM_VGIC_CPUID_MASK, cpu))
+
+#define GIC_CPU_CTRL	0x00
+
+static void test_v2_uaccess_cpuif_no_vcpus(void)
+{
+	struct vm_gic v;
+	u64 val = 0;
+	int ret;
+
+	v = vm_gic_create_barebones(KVM_DEV_TYPE_ARM_VGIC_V2);
+	subtest_dist_rdist(&v);
+
+	ret = __kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_REGS,
+				    KVM_VGIC_V2_ATTR(GIC_CPU_CTRL, 0));
+	TEST_ASSERT(ret && errno == EINVAL,
+		    "accessed non-existent CPU interface, want errno: %i",
+		    EINVAL);
+	ret = __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_REGS,
+				    KVM_VGIC_V2_ATTR(GIC_CPU_CTRL, 0), &val);
+	TEST_ASSERT(ret && errno == EINVAL,
+		    "accessed non-existent CPU interface, want errno: %i",
+		    EINVAL);
+	ret = __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CPU_REGS,
+				    KVM_VGIC_V2_ATTR(GIC_CPU_CTRL, 0), &val);
+	TEST_ASSERT(ret && errno == EINVAL,
+		    "accessed non-existent CPU interface, want errno: %i",
+		    EINVAL);
+
+	vm_gic_destroy(&v);
+}
+
 static void test_v3_new_redist_regions(void)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
@@ -675,6 +721,9 @@ void run_tests(uint32_t gic_dev_type)
 	test_vcpus_then_vgic(gic_dev_type);
 	test_vgic_then_vcpus(gic_dev_type);
 
+	if (VGIC_DEV_IS_V2(gic_dev_type))
+		test_v2_uaccess_cpuif_no_vcpus();
+
 	if (VGIC_DEV_IS_V3(gic_dev_type)) {
 		test_v3_new_redist_regions();
 		test_v3_typer_accesses();
-- 
2.44.0.769.g3c40516874-goog


