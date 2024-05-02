Return-Path: <kvm+bounces-16457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 67E5C8BA413
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 01:36:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8F451F244E9
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 23:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4AEC4206A;
	Thu,  2 May 2024 23:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IboQdNhj"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1C13F9D9
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 23:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714692954; cv=none; b=XI+qOTgiv0HyQjyOffeHx4FMt+A3zZOVs40qLj8+oSDkNG1Quf54tVAKk5sUNszxwp27+1G4ftVq0BkiJP+Aby8FoSU7w/sQ6AhhIR4VsRVyFZJEizXQbJ0ezPiyHYjzjQO3nEf5i9JOm/pnghU77j2+R49l0ccWKFmkBToYucM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714692954; c=relaxed/simple;
	bh=MkTKcsNjpYm67jVJq82wfXVhx/LS9ZXWyVJQ9KtOfQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sq2oLWB9v6HP0j3J99dqwYOftPCiDRzGYCfwIomB/jallSa3OnMajEtQmMVekKphy4dbTNzBJpP/zmGqnrmItU4TPjhN5oPkx8jz39RZUKSzkf0BtrruxhUzQJqMIjcYTsTAqYVyzDki6Qta1p+Oz+XvrJwwOA3s+CDIVJl6kXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IboQdNhj; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714692950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Tg7qjCxvhgA3RWWPmq2IOILHp7FltuPh3I+Xqg9cvU=;
	b=IboQdNhjnEUVyWn4TPkIH9OuLBsUPGSeoccMa844NBi0QPRDtCQXGfNx2FDsRySmiMUlkt
	N8LiP5qCGeLsSOfmaG+W/J7Th/1MIUEDfqPpm4bw7UYcx2n3MMWtuoIGEc6HD36eRuuUGO
	ZFpH3EJ8SEZb/9gsVbRlLiCDQf1AhuE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 7/7] KVM: selftests: Test vCPU-scoped feature ID registers
Date: Thu,  2 May 2024 23:35:29 +0000
Message-ID: <20240502233529.1958459-8-oliver.upton@linux.dev>
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

Test that CLIDR_EL1 and MPIDR_EL1 are modifiable from userspace and that
the values are preserved across a vCPU reset like the other feature ID
registers.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../selftests/kvm/aarch64/set_id_regs.c       | 53 ++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
index 24b248c78f5d..a7de39fa2a0a 100644
--- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
@@ -457,6 +457,53 @@ static void test_guest_reg_read(struct kvm_vcpu *vcpu)
 	}
 }
 
+/* Politely lifted from arch/arm64/include/asm/cache.h */
+/* Ctypen, bits[3(n - 1) + 2 : 3(n - 1)], for n = 1 to 7 */
+#define CLIDR_CTYPE_SHIFT(level)	(3 * (level - 1))
+#define CLIDR_CTYPE_MASK(level)		(7 << CLIDR_CTYPE_SHIFT(level))
+#define CLIDR_CTYPE(clidr, level)	\
+	(((clidr) & CLIDR_CTYPE_MASK(level)) >> CLIDR_CTYPE_SHIFT(level))
+
+static void test_clidr(struct kvm_vcpu *vcpu)
+{
+	uint64_t clidr;
+	int level;
+
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_CLIDR_EL1), &clidr);
+
+	/* find the first empty level in the cache hierarchy */
+	for (level = 1; level < 7; level++) {
+		if (!CLIDR_CTYPE(clidr, level))
+			break;
+	}
+
+	/*
+	 * If you have a mind-boggling 7 levels of cache, congratulations, you
+	 * get to fix this.
+	 */
+	TEST_ASSERT(level <= 7, "can't find an empty level in cache hierarchy");
+
+	/* stick in a unified cache level */
+	clidr |= BIT(2) << CLIDR_CTYPE_SHIFT(level);
+
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_CLIDR_EL1), clidr);
+	test_reg_vals[encoding_to_range_idx(SYS_CLIDR_EL1)] = clidr;
+}
+
+static void test_vcpu_ftr_id_regs(struct kvm_vcpu *vcpu)
+{
+	u64 val;
+
+	test_clidr(vcpu);
+
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &val);
+	val++;
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), val);
+
+	test_reg_vals[encoding_to_range_idx(SYS_MPIDR_EL1)] = val;
+	ksft_test_result_pass("%s\n", __func__);
+}
+
 static void test_assert_id_reg_unchanged(struct kvm_vcpu *vcpu, uint32_t encoding)
 {
 	size_t idx = encoding_to_range_idx(encoding);
@@ -477,6 +524,8 @@ static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu)
 	for (int i = 0; i < ARRAY_SIZE(test_regs); i++)
 		test_assert_id_reg_unchanged(vcpu, test_regs[i].reg);
 
+	test_assert_id_reg_unchanged(vcpu, SYS_CLIDR_EL1);
+
 	ksft_test_result_pass("%s\n", __func__);
 }
 
@@ -504,11 +553,13 @@ int main(void)
 		   ARRAY_SIZE(ftr_id_aa64isar2_el1) + ARRAY_SIZE(ftr_id_aa64pfr0_el1) +
 		   ARRAY_SIZE(ftr_id_aa64mmfr0_el1) + ARRAY_SIZE(ftr_id_aa64mmfr1_el1) +
 		   ARRAY_SIZE(ftr_id_aa64mmfr2_el1) + ARRAY_SIZE(ftr_id_aa64zfr0_el1) -
-		   ARRAY_SIZE(test_regs) + 1;
+		   ARRAY_SIZE(test_regs) + 2;
 
 	ksft_set_plan(test_cnt);
 
 	test_vm_ftr_id_regs(vcpu, aarch64_only);
+	test_vcpu_ftr_id_regs(vcpu);
+
 	test_guest_reg_read(vcpu);
 
 	test_reset_preserves_id_regs(vcpu);
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


