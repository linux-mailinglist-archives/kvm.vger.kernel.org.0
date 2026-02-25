Return-Path: <kvm+bounces-71777-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0HdFIol8nmlXVgQAu9opvQ
	(envelope-from <kvm+bounces-71777-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 05:37:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0063C1919F5
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 05:37:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E15BA3029A53
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:37:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C33B52C3251;
	Wed, 25 Feb 2026 04:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="dW/t6fFr"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9136E26E708;
	Wed, 25 Feb 2026 04:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771994236; cv=none; b=PB5UYJacMURUcaTY4fjf2BOTrtM6+AuPKRLbf7X4Six70+ZfrnHHUR1vWvzMZs4ueA2FCQkJmrnRSzi7UGbkEX8QDPKW1kMHI2kbU+kNNuxgRmd7jZL0Hi9ehRsTxmyJycx0FT42cQULwlTJo//UpP+Zt3YLJG3sX1vx/oEO3yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771994236; c=relaxed/simple;
	bh=V7yGTOLIYvJ+y17btsf2NAXw0lQUB6xkJtS6Hal8JcM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LdHz+yWyLoBnIfAWAe9jy1P7mhTIFs2yVWGkaictlHuXm3JB3olY+zKxtBgJoCY8N1I10ulx8wQ5F8brD95YqLv9+sxV9jtodIb77skUHNeiuq92GlZyU071o59w7QakzDsca+FdnTqsnn5wh1rxuv+0Pfb+EQ7kNIU/A3MUzpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=dW/t6fFr reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from h205.csg.ci.i.u-tokyo.ac.jp (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 61P4VKpR082120
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 25 Feb 2026 13:31:25 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=ZtQ5dlfNVl2+jdFm1CbTKfe5Q89iVgHpFp8aH6VaLbI=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1771993885; v=1;
        b=dW/t6fFr1TCg4raevwsnqTMSxSVHxMFKujqu9Ft+yYBpYCmHxH9liYoTw9I82eWl
         SOnzN9YDSSvwWnQwCj5NXkYkYuQ08Edv7qoREWCbalg2cwxcpaGOTmopPgwtf0JU
         8K/e5dzPfPgHeMG1DNLi1dZTUBIovIjjBjSQYvZ0Xi6KKMhoiIwsaYayj83SCKAM
         E8YQ1wUd4wfAptEAwXqrLs3SS9njOQtEqoysi3W34OOVya4KFQ00Vyum/y/FZ3Ki
         aAHeqpai+/UzLWHJgA7KiOknh28luKhr6gdo4iHsHSvQ6vCJbpFWRCekQd4VWYQU
         VbBO1a6MM9u0zhNrxaWE8g==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 25 Feb 2026 13:31:16 +0900
Subject: [PATCH v3 2/2] KVM: arm64: selftests: Test
 PMU_V3_FIXED_COUNTERS_ONLY
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260225-hybrid-v3-2-46e8fe220880@rsg.ci.i.u-tokyo.ac.jp>
References: <20260225-hybrid-v3-0-46e8fe220880@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260225-hybrid-v3-0-46e8fe220880@rsg.ci.i.u-tokyo.ac.jp>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.15-dev-5ab4c
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[u-tokyo.ac.jp : SPF not aligned (relaxed),none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	TAGGED_FROM(0.00)[bounces-71777-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	R_DKIM_PERMFAIL(0.00)[rsg.ci.i.u-tokyo.ac.jp:s=rs20250326];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[rsg.ci.i.u-tokyo.ac.jp:~];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[odaki@rsg.ci.i.u-tokyo.ac.jp,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.938];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[rsg.ci.i.u-tokyo.ac.jp:mid,u-tokyo.ac.jp:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0063C1919F5
X-Rspamd-Action: no action

Assert the following:
- KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY is unset at initialization.
- KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY can be set.
- Setting KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY for the first time
  after setting an event filter results in EBUSY.
- KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY can be set again even if an
  event filter has already been set.
- Setting KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY after running a VCPU
  results in EBUSY.
- The existing test cases pass with
  KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY set.

Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 .../selftests/kvm/arm64/vpmu_counter_access.c      | 148 +++++++++++++++++----
 1 file changed, 122 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
index ae36325c022f..156bfa636923 100644
--- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
@@ -403,12 +403,7 @@ static void create_vpmu_vm(void *guest_code)
 {
 	struct kvm_vcpu_init init;
 	uint8_t pmuver, ec;
-	uint64_t dfr0, irq = 23;
-	struct kvm_device_attr irq_attr = {
-		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
-		.attr = KVM_ARM_VCPU_PMU_V3_IRQ,
-		.addr = (uint64_t)&irq,
-	};
+	uint64_t dfr0;
 
 	/* The test creates the vpmu_vm multiple times. Ensure a clean state */
 	memset(&vpmu_vm, 0, sizeof(vpmu_vm));
@@ -434,8 +429,6 @@ static void create_vpmu_vm(void *guest_code)
 	TEST_ASSERT(pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF &&
 		    pmuver >= ID_AA64DFR0_EL1_PMUVer_IMP,
 		    "Unexpected PMUVER (0x%x) on the vCPU with PMUv3", pmuver);
-
-	vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &irq_attr);
 }
 
 static void destroy_vpmu_vm(void)
@@ -461,15 +454,25 @@ static void run_vcpu(struct kvm_vcpu *vcpu, uint64_t pmcr_n)
 	}
 }
 
-static void test_create_vpmu_vm_with_nr_counters(unsigned int nr_counters, bool expect_fail)
+static void test_create_vpmu_vm_with_nr_counters(unsigned int nr_counters,
+						 bool fixed_counters_only,
+						 bool expect_fail)
 {
 	struct kvm_vcpu *vcpu;
 	unsigned int prev;
 	int ret;
+	uint64_t irq = 23;
 
 	create_vpmu_vm(guest_code);
 	vcpu = vpmu_vm.vcpu;
 
+	if (fixed_counters_only)
+		vcpu_device_attr_set(vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+				     KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY, NULL);
+
+	vcpu_device_attr_set(vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+			     KVM_ARM_VCPU_PMU_V3_IRQ, &irq);
+
 	prev = get_pmcr_n(vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0)));
 
 	ret = __vcpu_device_attr_set(vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
@@ -489,15 +492,15 @@ static void test_create_vpmu_vm_with_nr_counters(unsigned int nr_counters, bool
  * Create a guest with one vCPU, set the PMCR_EL0.N for the vCPU to @pmcr_n,
  * and run the test.
  */
-static void run_access_test(uint64_t pmcr_n)
+static void run_access_test(uint64_t pmcr_n, bool fixed_counters_only)
 {
 	uint64_t sp;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vcpu_init init;
 
-	pr_debug("Test with pmcr_n %lu\n", pmcr_n);
+	pr_debug("Test with pmcr_n %lu, fixed_counters_only %d\n", pmcr_n, fixed_counters_only);
 
-	test_create_vpmu_vm_with_nr_counters(pmcr_n, false);
+	test_create_vpmu_vm_with_nr_counters(pmcr_n, fixed_counters_only, false);
 	vcpu = vpmu_vm.vcpu;
 
 	/* Save the initial sp to restore them later to run the guest again */
@@ -531,14 +534,14 @@ static struct pmreg_sets validity_check_reg_sets[] = {
  * Create a VM, and check if KVM handles the userspace accesses of
  * the PMU register sets in @validity_check_reg_sets[] correctly.
  */
-static void run_pmregs_validity_test(uint64_t pmcr_n)
+static void run_pmregs_validity_test(uint64_t pmcr_n, bool fixed_counters_only)
 {
 	int i;
 	struct kvm_vcpu *vcpu;
 	uint64_t set_reg_id, clr_reg_id, reg_val;
 	uint64_t valid_counters_mask, max_counters_mask;
 
-	test_create_vpmu_vm_with_nr_counters(pmcr_n, false);
+	test_create_vpmu_vm_with_nr_counters(pmcr_n, fixed_counters_only, false);
 	vcpu = vpmu_vm.vcpu;
 
 	valid_counters_mask = get_counters_mask(pmcr_n);
@@ -588,11 +591,11 @@ static void run_pmregs_validity_test(uint64_t pmcr_n)
  * the vCPU to @pmcr_n, which is larger than the host value.
  * The attempt should fail as @pmcr_n is too big to set for the vCPU.
  */
-static void run_error_test(uint64_t pmcr_n)
+static void run_error_test(uint64_t pmcr_n, bool fixed_counters_only)
 {
 	pr_debug("Error test with pmcr_n %lu (larger than the host)\n", pmcr_n);
 
-	test_create_vpmu_vm_with_nr_counters(pmcr_n, true);
+	test_create_vpmu_vm_with_nr_counters(pmcr_n, fixed_counters_only, true);
 	destroy_vpmu_vm();
 }
 
@@ -622,22 +625,115 @@ static bool kvm_supports_nr_counters_attr(void)
 	return supported;
 }
 
-int main(void)
+static void test_config(uint64_t pmcr_n, bool fixed_counters_only)
 {
-	uint64_t i, pmcr_n;
-
-	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PMU_V3));
-	TEST_REQUIRE(kvm_supports_vgic_v3());
-	TEST_REQUIRE(kvm_supports_nr_counters_attr());
+	uint64_t i;
 
-	pmcr_n = get_pmcr_n_limit();
 	for (i = 0; i <= pmcr_n; i++) {
-		run_access_test(i);
-		run_pmregs_validity_test(i);
+		run_access_test(i, fixed_counters_only);
+		run_pmregs_validity_test(i, fixed_counters_only);
 	}
 
 	for (i = pmcr_n + 1; i < ARMV8_PMU_MAX_COUNTERS; i++)
-		run_error_test(i);
+		run_error_test(i, fixed_counters_only);
+}
+
+static void test_fixed_counters_only(void)
+{
+	struct kvm_pmu_event_filter filter = { .nevents = 0 };
+	struct kvm_vm *vm;
+	struct kvm_vcpu *running_vcpu;
+	struct kvm_vcpu *stopped_vcpu;
+	struct kvm_vcpu_init init;
+	int ret;
+	uint64_t irq = 23;
+
+	create_vpmu_vm(guest_code);
+	ret = __vcpu_has_device_attr(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+				     KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY);
+	if (ret) {
+		TEST_ASSERT(ret == -1 && errno == ENXIO,
+			    KVM_IOCTL_ERROR(KVM_GET_DEVICE_ATTR, ret));
+		destroy_vpmu_vm();
+		return;
+	}
+
+	/* Assert that FIXED_COUNTERS_ONLY is unset at initialization. */
+	ret = __vcpu_device_attr_get(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+				     KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY, NULL);
+	TEST_ASSERT(ret == -1 && errno == ENXIO,
+		    KVM_IOCTL_ERROR(KVM_GET_DEVICE_ATTR, ret));
+
+	/* Assert that setting FIXED_COUNTERS_ONLY succeeds. */
+	vcpu_device_attr_set(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+			     KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY, NULL);
+
+	/* Assert that getting FIXED_COUNTERS_ONLY succeeds. */
+	vcpu_device_attr_get(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+			     KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY, NULL);
+
+	/*
+	 * Assert that setting FIXED_COUNTERS_ONLY again succeeds even if an
+	 * event filter has already been set.
+	 */
+	vcpu_device_attr_set(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+			     KVM_ARM_VCPU_PMU_V3_FILTER, &filter);
+
+	vcpu_device_attr_set(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+			     KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY, NULL);
+
+	destroy_vpmu_vm();
+
+	create_vpmu_vm(guest_code);
+
+	/*
+	 * Assert that setting FIXED_COUNTERS_ONLY results in EBUSY if an event
+	 * filter has already been set while FIXED_COUNTERS_ONLY has not.
+	 */
+	vcpu_device_attr_set(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+			     KVM_ARM_VCPU_PMU_V3_FILTER, &filter);
+
+	ret = __vcpu_device_attr_set(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+				     KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY, NULL);
+	TEST_ASSERT(ret == -1 && errno == EBUSY,
+		    KVM_IOCTL_ERROR(KVM_GET_DEVICE_ATTR, ret));
+
+	destroy_vpmu_vm();
+
+	/*
+	 * Assert that setting FIXED_COUNTERS_ONLY after running a VCPU results
+	 * in EBUSY.
+	 */
+	vm = vm_create(2);
+	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
+	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
+	running_vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
+	stopped_vcpu = aarch64_vcpu_add(vm, 1, &init, guest_code);
+	kvm_arch_vm_finalize_vcpus(vm);
+	vcpu_device_attr_set(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+			     KVM_ARM_VCPU_PMU_V3_IRQ, &irq);
+	vcpu_device_attr_set(running_vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+			     KVM_ARM_VCPU_PMU_V3_INIT, NULL);
+	vcpu_run(running_vcpu);
+
+	ret = __vcpu_device_attr_set(stopped_vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+				     KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY, NULL);
+	TEST_ASSERT(ret == -1 && errno == EBUSY,
+		    KVM_IOCTL_ERROR(KVM_GET_DEVICE_ATTR, ret));
+
+	kvm_vm_free(vm);
+
+	test_config(0, true);
+}
+
+int main(void)
+{
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PMU_V3));
+	TEST_REQUIRE(kvm_supports_vgic_v3());
+	TEST_REQUIRE(kvm_supports_nr_counters_attr());
+
+	test_config(get_pmcr_n_limit(), false);
+	test_fixed_counters_only();
 
 	return 0;
 }

-- 
2.53.0


