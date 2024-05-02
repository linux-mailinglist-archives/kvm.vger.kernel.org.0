Return-Path: <kvm+bounces-16455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AE788BA411
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 01:36:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1713A281CEF
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 23:36:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F6744CDE0;
	Thu,  2 May 2024 23:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="l/xBGqiM"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5840B482FA
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 23:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714692950; cv=none; b=qvnUkhi2fOPmaGlhQjYOmOJTkjm4/j/uFI8u2PMawfAbN+n7XH8jw4C6i9UsoZmYXxnGlRlQ69CyGXTg1FZ0CxF6MozPKceyExorchFO8Eh+PU9VPxZsY7+nowWg3hcH7PhgWrfHPva5b7LDmoAUCeNfKDDme5M6b6HqIH8bYPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714692950; c=relaxed/simple;
	bh=+ObM6iwUmcKWBk0DKkRhiQ146SDTSHWxx+kjj6ZUO4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NiLIyd958dsYi3QOVYL5VV/aQFXAhMt/KjoMqPb/NKfO60iyQxynm4G3gmiHXOrmSDhlc8ApULIV4AHmmeLwP+jPBLLZAu8RrjrPTWCdbRrc93WwQtOM2n8vZWOXJhUIghWqB3kRr8TzeBCvsvJ3622XpiTfzXZVSEMqi4jFLgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=l/xBGqiM; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714692947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gAV4Ra5Jbxd6Br0ovgZsuIuL9CViiGIWC5+ez/0DGWQ=;
	b=l/xBGqiMSCK/iVKYNzqkOf1D5C/P3uXntOcjAFD/Tr3cNKxlt+sMJpGDT5aj7aZ8SzJujP
	bmxibsh0BrakV2uEh8q4cSiyuwC+9jIVBuZknJj+5xPziSnEVCvd2EYm09KU5mkAzRrTyY
	TktQhAhii/G2intM/pXwSAUyKaAlVMM=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 5/7] KVM: selftests: Store expected register value in set_id_regs
Date: Thu,  2 May 2024 23:35:27 +0000
Message-ID: <20240502233529.1958459-6-oliver.upton@linux.dev>
In-Reply-To: <20240502233529.1958459-1-oliver.upton@linux.dev>
References: <20240502233529.1958459-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Rather than comparing against what is returned by the ioctl, store
expected values for the feature ID registers in a table and compare with
that instead.

This will prove useful for subsequent tests involving vCPU reset.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../selftests/kvm/aarch64/set_id_regs.c       | 27 ++++++++++++-------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
index 3d0ce49f9b78..7c8d33fa2ae6 100644
--- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
@@ -327,8 +327,8 @@ uint64_t get_invalid_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
 	return ftr;
 }
 
-static void test_reg_set_success(struct kvm_vcpu *vcpu, uint64_t reg,
-				 const struct reg_ftr_bits *ftr_bits)
+static uint64_t test_reg_set_success(struct kvm_vcpu *vcpu, uint64_t reg,
+				     const struct reg_ftr_bits *ftr_bits)
 {
 	uint8_t shift = ftr_bits->shift;
 	uint64_t mask = ftr_bits->mask;
@@ -346,6 +346,8 @@ static void test_reg_set_success(struct kvm_vcpu *vcpu, uint64_t reg,
 	vcpu_set_reg(vcpu, reg, val);
 	vcpu_get_reg(vcpu, reg, &new_val);
 	TEST_ASSERT_EQ(new_val, val);
+
+	return new_val;
 }
 
 static void test_reg_set_fail(struct kvm_vcpu *vcpu, uint64_t reg,
@@ -374,6 +376,14 @@ static void test_reg_set_fail(struct kvm_vcpu *vcpu, uint64_t reg,
 	TEST_ASSERT_EQ(val, old_val);
 }
 
+static uint64_t test_reg_vals[KVM_ARM_FEATURE_ID_RANGE_SIZE];
+
+#define encoding_to_range_idx(encoding)							\
+	KVM_ARM_FEATURE_ID_RANGE_IDX(sys_reg_Op0(encoding), sys_reg_Op1(encoding),	\
+				     sys_reg_CRn(encoding), sys_reg_CRm(encoding),	\
+				     sys_reg_Op2(encoding))
+
+
 static void test_vm_ftr_id_regs(struct kvm_vcpu *vcpu, bool aarch64_only)
 {
 	uint64_t masks[KVM_ARM_FEATURE_ID_RANGE_SIZE];
@@ -398,9 +408,7 @@ static void test_vm_ftr_id_regs(struct kvm_vcpu *vcpu, bool aarch64_only)
 		int idx;
 
 		/* Get the index to masks array for the idreg */
-		idx = KVM_ARM_FEATURE_ID_RANGE_IDX(sys_reg_Op0(reg_id), sys_reg_Op1(reg_id),
-						   sys_reg_CRn(reg_id), sys_reg_CRm(reg_id),
-						   sys_reg_Op2(reg_id));
+		idx = encoding_to_range_idx(reg_id);
 
 		for (int j = 0;  ftr_bits[j].type != FTR_END; j++) {
 			/* Skip aarch32 reg on aarch64 only system, since they are RAZ/WI. */
@@ -414,7 +422,9 @@ static void test_vm_ftr_id_regs(struct kvm_vcpu *vcpu, bool aarch64_only)
 			TEST_ASSERT_EQ(masks[idx] & ftr_bits[j].mask, ftr_bits[j].mask);
 
 			test_reg_set_fail(vcpu, reg, &ftr_bits[j]);
-			test_reg_set_success(vcpu, reg, &ftr_bits[j]);
+
+			test_reg_vals[idx] = test_reg_set_success(vcpu, reg,
+								  &ftr_bits[j]);
 
 			ksft_test_result_pass("%s\n", ftr_bits[j].name);
 		}
@@ -425,7 +435,6 @@ static void test_guest_reg_read(struct kvm_vcpu *vcpu)
 {
 	bool done = false;
 	struct ucall uc;
-	uint64_t val;
 
 	while (!done) {
 		vcpu_run(vcpu);
@@ -436,8 +445,8 @@ static void test_guest_reg_read(struct kvm_vcpu *vcpu)
 			break;
 		case UCALL_SYNC:
 			/* Make sure the written values are seen by guest */
-			vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(uc.args[2]), &val);
-			TEST_ASSERT_EQ(val, uc.args[3]);
+			TEST_ASSERT_EQ(test_reg_vals[encoding_to_range_idx(uc.args[2])],
+				       uc.args[3]);
 			break;
 		case UCALL_DONE:
 			done = true;
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


