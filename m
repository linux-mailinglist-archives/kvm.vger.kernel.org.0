Return-Path: <kvm+bounces-16456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 336CE8BA412
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 01:36:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6539C1C21EB7
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 23:36:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42BD54122C;
	Thu,  2 May 2024 23:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O8PfJNoA"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F6A339A8
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 23:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714692952; cv=none; b=vFbAEUImJ3SUA/VeVYoAU1sOFEUcvnOBMjL+X4LFbZx52mZPMdPQXzj5cUpA5dYM2jernbgwt3s596pQjW7xeiOY0zzsBve6iSqyEvQkIqqu/LRIv1DIRa0EIp/ExHpfthsUYrG/YbvFu0wNB7UVZyIIQwt+v9io6cnH24HIZII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714692952; c=relaxed/simple;
	bh=Sf8KR1FiJvDcfhRPmoXAtp3U6syBd4yvxVFtSa5Vveo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AD/6Gg3Bwpb5aZP8ETE4+/mOjsGTpoVXnD5WBDQ6xr6p9lQ9N8+EZ98/ut7m9ywE76ZXP5VbGWGVniOUZdMvjHOqfkqJWb9xHGOpSWi8UzrUQSyTPdFnDbUUdrbz5yRMD+tbDoXRkMEkrqzMTfRNvMc2/Vn4XanleAIEVyLHzJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O8PfJNoA; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714692949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z2t+/nGPWsZzHMfkZst0Uh87al0pl45Cohj1IfEDGRE=;
	b=O8PfJNoA10kYdvzq7Rzxo2Du/N8Q1agkw5T7DhrnB/BO5bQZjdbcMldh/l0UlRI2K4/hpd
	9OXzcssBz1OEQezpyYYTBTmP7JWFLZQfsJMNtcILOcO4qt8KmaWBvEDOYGsmvcDO8tbcmU
	P/xtbEpQdUOv6nS/B2ksJsoi65Cg+C4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6/7] KVM: arm64: Test that feature ID regs survive a reset
Date: Thu,  2 May 2024 23:35:28 +0000
Message-ID: <20240502233529.1958459-7-oliver.upton@linux.dev>
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

One of the expectations with feature ID registers is that their values
survive a vCPU reset. Start testing that.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../selftests/kvm/aarch64/set_id_regs.c       | 41 +++++++++++++++----
 1 file changed, 33 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
index 7c8d33fa2ae6..24b248c78f5d 100644
--- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
@@ -457,13 +457,36 @@ static void test_guest_reg_read(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void test_assert_id_reg_unchanged(struct kvm_vcpu *vcpu, uint32_t encoding)
+{
+	size_t idx = encoding_to_range_idx(encoding);
+	uint64_t observed;
+
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(encoding), &observed);
+	TEST_ASSERT_EQ(test_reg_vals[idx], observed);
+}
+
+static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Calls KVM_ARM_VCPU_INIT behind the scenes, which will do an
+	 * architectural reset of the vCPU.
+	 */
+	aarch64_vcpu_setup(vcpu, NULL);
+
+	for (int i = 0; i < ARRAY_SIZE(test_regs); i++)
+		test_assert_id_reg_unchanged(vcpu, test_regs[i].reg);
+
+	ksft_test_result_pass("%s\n", __func__);
+}
+
 int main(void)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	bool aarch64_only;
 	uint64_t val, el0;
-	int ftr_cnt;
+	int test_cnt;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES));
 
@@ -476,18 +499,20 @@ int main(void)
 
 	ksft_print_header();
 
-	ftr_cnt = ARRAY_SIZE(ftr_id_aa64dfr0_el1) + ARRAY_SIZE(ftr_id_dfr0_el1) +
-		  ARRAY_SIZE(ftr_id_aa64isar0_el1) + ARRAY_SIZE(ftr_id_aa64isar1_el1) +
-		  ARRAY_SIZE(ftr_id_aa64isar2_el1) + ARRAY_SIZE(ftr_id_aa64pfr0_el1) +
-		  ARRAY_SIZE(ftr_id_aa64mmfr0_el1) + ARRAY_SIZE(ftr_id_aa64mmfr1_el1) +
-		  ARRAY_SIZE(ftr_id_aa64mmfr2_el1) + ARRAY_SIZE(ftr_id_aa64zfr0_el1) -
-		  ARRAY_SIZE(test_regs);
+	test_cnt = ARRAY_SIZE(ftr_id_aa64dfr0_el1) + ARRAY_SIZE(ftr_id_dfr0_el1) +
+		   ARRAY_SIZE(ftr_id_aa64isar0_el1) + ARRAY_SIZE(ftr_id_aa64isar1_el1) +
+		   ARRAY_SIZE(ftr_id_aa64isar2_el1) + ARRAY_SIZE(ftr_id_aa64pfr0_el1) +
+		   ARRAY_SIZE(ftr_id_aa64mmfr0_el1) + ARRAY_SIZE(ftr_id_aa64mmfr1_el1) +
+		   ARRAY_SIZE(ftr_id_aa64mmfr2_el1) + ARRAY_SIZE(ftr_id_aa64zfr0_el1) -
+		   ARRAY_SIZE(test_regs) + 1;
 
-	ksft_set_plan(ftr_cnt);
+	ksft_set_plan(test_cnt);
 
 	test_vm_ftr_id_regs(vcpu, aarch64_only);
 	test_guest_reg_read(vcpu);
 
+	test_reset_preserves_id_regs(vcpu);
+
 	kvm_vm_free(vm);
 
 	ksft_finished();
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


