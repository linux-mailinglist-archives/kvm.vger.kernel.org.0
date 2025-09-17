Return-Path: <kvm+bounces-57931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 576F7B81EE0
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 23:21:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F0D7A189D7C2
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 21:21:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16F093081D6;
	Wed, 17 Sep 2025 21:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V+uxs9uv"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D582F39D0
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 21:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758144064; cv=none; b=s7mVuwuCvdaGlvBIcy5MklCTfUFHZYj3ZtW7oBRssMNTFnnKeyNhGW9UqdkxKXTPvNNamWHOfruP7fa7JZuzMFVhwIfXFZKJMlnV6COTjST1jHwMDLIHR1p7tXh04zIFJf6KCg3/LEa12a/Qv4X4TmzuALohjSKASLUhtM/R6lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758144064; c=relaxed/simple;
	bh=G+OTJBIdhLjg8E8aa6uOx3nqVr7hJRB8R61wkTFn8z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khxRLJJ3tisEskDwGuUX987WyURvfZF9jCMSaQpTm9+3yCgj/wx4lror9fRI2xNWvNrybY8yxca+euQ/6YAcbV7RZi+DiWgWeB2ZvFlu+tRJgtqvSa/02Uf9fvQWaYsiBBo9ahRc7yjfGiJXi3xidxKMnA9OTj+NgiEjDPJlq+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V+uxs9uv; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758144059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xVzdgwSjY1m2eB/+6IrSHhxwjzvA5U6gO4A1LIyu3+s=;
	b=V+uxs9uv/m8JsLD0Wu4gayA22oacMWpVAqiBp88LAsHnT1rdd6CvXNOx2SBpoRQtqvtdFM
	xLNv54e4ZRUEfbOA53Gs9YMtoGwJEmaz0y/MqSBmfTlCcQgnptVXgg0f44LAnNoHrieawF
	58cQRRxbgY1Un4jVE8yTAMlFb7zimus=
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
Subject: [PATCH 01/13] KVM: arm64: selftests: Provide kvm_arch_vm_post_create() in library code
Date: Wed, 17 Sep 2025 14:20:31 -0700
Message-ID: <20250917212044.294760-2-oliver.upton@linux.dev>
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

In order to compel the default usage of EL2 in selftests, move
kvm_arch_vm_post_create() to library code and expose an opt-in for using
MTE by default.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../testing/selftests/kvm/arm64/set_id_regs.c | 19 +++++--------------
 .../selftests/kvm/include/arm64/processor.h   |  2 ++
 .../selftests/kvm/lib/arm64/processor.c       | 13 +++++++++++++
 3 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 189321e96925..a2d367a2c93c 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -15,8 +15,6 @@
 #include "test_util.h"
 #include <linux/bitfield.h>
 
-bool have_cap_arm_mte;
-
 enum ftr_type {
 	FTR_EXACT,			/* Use a predefined safe value */
 	FTR_LOWER_SAFE,			/* Smaller value is safe */
@@ -568,7 +566,9 @@ static void test_user_set_mte_reg(struct kvm_vcpu *vcpu)
 	uint64_t mte_frac;
 	int idx, err;
 
-	if (!have_cap_arm_mte) {
+	val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR1_EL1));
+	mte = FIELD_GET(ID_AA64PFR1_EL1_MTE, val);
+	if (!mte) {
 		ksft_test_result_skip("MTE capability not supported, nothing to test\n");
 		return;
 	}
@@ -593,9 +593,6 @@ static void test_user_set_mte_reg(struct kvm_vcpu *vcpu)
 	 * from unsupported (0xF) to supported (0).
 	 *
 	 */
-	val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR1_EL1));
-
-	mte = FIELD_GET(ID_AA64PFR1_EL1_MTE, val);
 	mte_frac = FIELD_GET(ID_AA64PFR1_EL1_MTE_frac, val);
 	if (mte != ID_AA64PFR1_EL1_MTE_MTE2 ||
 	    mte_frac != ID_AA64PFR1_EL1_MTE_frac_NI) {
@@ -750,14 +747,6 @@ static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu)
 	ksft_test_result_pass("%s\n", __func__);
 }
 
-void kvm_arch_vm_post_create(struct kvm_vm *vm)
-{
-	if (vm_check_cap(vm, KVM_CAP_ARM_MTE)) {
-		vm_enable_cap(vm, KVM_CAP_ARM_MTE, 0);
-		have_cap_arm_mte = true;
-	}
-}
-
 int main(void)
 {
 	struct kvm_vcpu *vcpu;
@@ -769,6 +758,8 @@ int main(void)
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_WRITABLE_IMP_ID_REGS));
 
+	test_wants_mte();
+
 	vm = vm_create(1);
 	vm_enable_cap(vm, KVM_CAP_ARM_WRITABLE_IMP_ID_REGS, 0);
 	vcpu = vm_vcpu_add(vm, 0, guest_code);
diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
index 255fed769a8a..8370fc94041d 100644
--- a/tools/testing/selftests/kvm/include/arm64/processor.h
+++ b/tools/testing/selftests/kvm/include/arm64/processor.h
@@ -300,4 +300,6 @@ void smccc_smc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
 /* Execute a Wait For Interrupt instruction. */
 void wfi(void);
 
+void test_wants_mte(void);
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index eb115123d741..caed1998c7b3 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -653,3 +653,16 @@ void wfi(void)
 {
 	asm volatile("wfi");
 }
+
+static bool request_mte;
+
+void test_wants_mte(void)
+{
+	request_mte = true;
+}
+
+void kvm_arch_vm_post_create(struct kvm_vm *vm)
+{
+	if (request_mte && vm_check_cap(vm, KVM_CAP_ARM_MTE))
+		vm_enable_cap(vm, KVM_CAP_ARM_MTE, 0);
+}
-- 
2.47.3


