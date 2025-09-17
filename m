Return-Path: <kvm+bounces-57940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DDDCB81EFE
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 23:22:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE1011C23B1F
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 21:22:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46B9630AAB6;
	Wed, 17 Sep 2025 21:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sWocmLbh"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FAA2749CE
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 21:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758144126; cv=none; b=slSxVyzHgGM+LXNA0HPvjws9isNPvcza/bidlAW7RwvA1TPg0vOttR7qm7QTiP3XvBKVyjJt+mYju+AI/R7u6rQTU5qWRpaLlf8r4rKeyytZHVilh83OaLNlYVa95F6lrjqfA1ZUzITG80I+b8BlmeRIHCvIgLqIrtcIVIDt6QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758144126; c=relaxed/simple;
	bh=SzHRTvydUAOnrNTctQ/cxubaMWZQ2gSpHeYkGiI6J20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZvBH/evweEU+ljT/VV//MlurGcWBhj2mj+9SjtVp1liV2qTVW7UyXqCDZHGmT16ktRLznbTGUXUMiOUk8qTtuffqiVPMHL67d07UNWF9ZtaPdf6tAvG9fphGGu5Hi3PyiDWtqx4R1+QM0iRX+hRwDwGaYAl94/5CaN6ZqpcngQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sWocmLbh; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758144122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mo4OqzfGjmLC2N8F8wqwEshYuK+X6JdNA0FmDWCtBF8=;
	b=sWocmLbhjmzHXxx9/n9OktxXOouX5Z9bF0An0NYSKi5RsOhXwodpmX8rtwH0+GchLsqJgr
	1iRTAEwfKvXgHw38Oyx1Ku/2byxp/NYEwQbIqpp9kzZ0/mBXC/BMmk3qmxSKnm4Cq6K/yZ
	uiDQRKSV3p6avOqpTq/jv3ZWNReRaTA=
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
Subject: [PATCH 10/13] KVM: arm64: selftests: Use the vCPU attr for setting nr of PMU counters
Date: Wed, 17 Sep 2025 14:20:40 -0700
Message-ID: <20250917212044.294760-11-oliver.upton@linux.dev>
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

Configuring the number of implemented counters via PMCR_EL0.N was a bad
idea in retrospect as it interacts poorly with nested. Migrate the
selftest to use the vCPU attribute instead of the KVM_SET_ONE_REG
mechanism.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../selftests/kvm/arm64/vpmu_counter_access.c | 59 +++++++++----------
 1 file changed, 28 insertions(+), 31 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
index 2a8f31c8e59f..ae36325c022f 100644
--- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
@@ -44,11 +44,6 @@ static uint64_t get_pmcr_n(uint64_t pmcr)
 	return FIELD_GET(ARMV8_PMU_PMCR_N, pmcr);
 }
 
-static void set_pmcr_n(uint64_t *pmcr, uint64_t pmcr_n)
-{
-	u64p_replace_bits((__u64 *) pmcr, pmcr_n, ARMV8_PMU_PMCR_N);
-}
-
 static uint64_t get_counters_mask(uint64_t n)
 {
 	uint64_t mask = BIT(ARMV8_PMU_CYCLE_IDX);
@@ -414,10 +409,6 @@ static void create_vpmu_vm(void *guest_code)
 		.attr = KVM_ARM_VCPU_PMU_V3_IRQ,
 		.addr = (uint64_t)&irq,
 	};
-	struct kvm_device_attr init_attr = {
-		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
-		.attr = KVM_ARM_VCPU_PMU_V3_INIT,
-	};
 
 	/* The test creates the vpmu_vm multiple times. Ensure a clean state */
 	memset(&vpmu_vm, 0, sizeof(vpmu_vm));
@@ -444,9 +435,7 @@ static void create_vpmu_vm(void *guest_code)
 		    pmuver >= ID_AA64DFR0_EL1_PMUVer_IMP,
 		    "Unexpected PMUVER (0x%x) on the vCPU with PMUv3", pmuver);
 
-	/* Initialize vPMU */
 	vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &irq_attr);
-	vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &init_attr);
 }
 
 static void destroy_vpmu_vm(void)
@@ -472,33 +461,28 @@ static void run_vcpu(struct kvm_vcpu *vcpu, uint64_t pmcr_n)
 	}
 }
 
-static void test_create_vpmu_vm_with_pmcr_n(uint64_t pmcr_n, bool expect_fail)
+static void test_create_vpmu_vm_with_nr_counters(unsigned int nr_counters, bool expect_fail)
 {
 	struct kvm_vcpu *vcpu;
-	uint64_t pmcr, pmcr_orig;
+	unsigned int prev;
+	int ret;
 
 	create_vpmu_vm(guest_code);
 	vcpu = vpmu_vm.vcpu;
 
-	pmcr_orig = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0));
-	pmcr = pmcr_orig;
+	prev = get_pmcr_n(vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0)));
 
-	/*
-	 * Setting a larger value of PMCR.N should not modify the field, and
-	 * return a success.
-	 */
-	set_pmcr_n(&pmcr, pmcr_n);
-	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), pmcr);
-	pmcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0));
+	ret = __vcpu_device_attr_set(vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+				     KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS, &nr_counters);
 
 	if (expect_fail)
-		TEST_ASSERT(pmcr_orig == pmcr,
-			    "PMCR.N modified by KVM to a larger value (PMCR: 0x%lx) for pmcr_n: 0x%lx",
-			    pmcr, pmcr_n);
+		TEST_ASSERT(ret && errno == EINVAL,
+			    "Setting more PMU counters (%u) than available (%u) unexpectedly succeeded",
+			    nr_counters, prev);
 	else
-		TEST_ASSERT(pmcr_n == get_pmcr_n(pmcr),
-			    "Failed to update PMCR.N to %lu (received: %lu)",
-			    pmcr_n, get_pmcr_n(pmcr));
+		TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_SET_DEVICE_ATTR, ret));
+
+	vcpu_device_attr_set(vcpu, KVM_ARM_VCPU_PMU_V3_CTRL, KVM_ARM_VCPU_PMU_V3_INIT, NULL);
 }
 
 /*
@@ -513,7 +497,7 @@ static void run_access_test(uint64_t pmcr_n)
 
 	pr_debug("Test with pmcr_n %lu\n", pmcr_n);
 
-	test_create_vpmu_vm_with_pmcr_n(pmcr_n, false);
+	test_create_vpmu_vm_with_nr_counters(pmcr_n, false);
 	vcpu = vpmu_vm.vcpu;
 
 	/* Save the initial sp to restore them later to run the guest again */
@@ -554,7 +538,7 @@ static void run_pmregs_validity_test(uint64_t pmcr_n)
 	uint64_t set_reg_id, clr_reg_id, reg_val;
 	uint64_t valid_counters_mask, max_counters_mask;
 
-	test_create_vpmu_vm_with_pmcr_n(pmcr_n, false);
+	test_create_vpmu_vm_with_nr_counters(pmcr_n, false);
 	vcpu = vpmu_vm.vcpu;
 
 	valid_counters_mask = get_counters_mask(pmcr_n);
@@ -608,7 +592,7 @@ static void run_error_test(uint64_t pmcr_n)
 {
 	pr_debug("Error test with pmcr_n %lu (larger than the host)\n", pmcr_n);
 
-	test_create_vpmu_vm_with_pmcr_n(pmcr_n, true);
+	test_create_vpmu_vm_with_nr_counters(pmcr_n, true);
 	destroy_vpmu_vm();
 }
 
@@ -626,12 +610,25 @@ static uint64_t get_pmcr_n_limit(void)
 	return get_pmcr_n(pmcr);
 }
 
+static bool kvm_supports_nr_counters_attr(void)
+{
+	bool supported;
+
+	create_vpmu_vm(NULL);
+	supported = !__vcpu_has_device_attr(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+					    KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS);
+	destroy_vpmu_vm();
+
+	return supported;
+}
+
 int main(void)
 {
 	uint64_t i, pmcr_n;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PMU_V3));
 	TEST_REQUIRE(kvm_supports_vgic_v3());
+	TEST_REQUIRE(kvm_supports_nr_counters_attr());
 
 	pmcr_n = get_pmcr_n_limit();
 	for (i = 0; i <= pmcr_n; i++) {
-- 
2.47.3


