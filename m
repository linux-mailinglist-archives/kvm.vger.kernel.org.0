Return-Path: <kvm+bounces-44443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 02674A9DAAE
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:32:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3CEC91BC051A
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:32:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FEE0254AE0;
	Sat, 26 Apr 2025 12:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jrsz/sXC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8358D253F34;
	Sat, 26 Apr 2025 12:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745670539; cv=none; b=YOOyhThUHBSG6ZwlOuhsvqRdA17tu5Acsaf51daliqQKsoIdKpEcsn3PGLg6fxJqrAuJK50f9nBCIDmeCZJMcS4WTH0E2MhzZdx7nHmEz4FpCiQlTDldoLLlogYKONZGyhtLWXoTcgyjlTXcmLRk3B7XVJoUfm8K7kH9v7AHDcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745670539; c=relaxed/simple;
	bh=CxQCVzkzvqSJClLnMRI9lECQJg4Ao53JSRIOCSPF7FM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ltn3N7lEE7LcVKBKlWRdP3boneA10M21vyloGL555IJIvdoHX1SVrGMSxzzX57JAKdw0Xm9UEBPHHZYlPm/NYJKKeS4BI5ine4klyylpt+p97XtukQ2dtpRUZjQ/TC/fbjsAQKY4SBKnX1d9msq37JdwoysuWj0nnoxzpOGEG7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jrsz/sXC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F97CC4CEEB;
	Sat, 26 Apr 2025 12:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745670539;
	bh=CxQCVzkzvqSJClLnMRI9lECQJg4Ao53JSRIOCSPF7FM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jrsz/sXCgkzYzS85cy/fwJCzZgE4Njx2m3osho2KmpZhDHMCpqbALlNR4OtxjZmaO
	 aKuEWN/8sw2qA4Rjvwv1HKMVcfT94Wf9HySFa3giG1zVnFo7T/v48x0zKaFWXXpEaG
	 jdIMt6ufbAwo+CGJwVIi1GGj/el9hMi9w87O5f2FcHBECYJjUNiDV6rwD/usrigVHX
	 5fwfIyDKA6Tl81aEzEeNCsf3FcHIjQktinQJwtcMe97R4GfBR7vKIBK8pWhrpxYfFD
	 MITxDsocWTuAyo1UaHvxkL7Rg+c/0oYZtZV4v1UlPZIHhgNyf3iJqUTVqQ1l1IabX0
	 gYoNOhLgw6ZhQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u8eeP-0092VH-HN;
	Sat, 26 Apr 2025 13:28:57 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 31/42] KVM: arm64: Validate FGT register descriptions against RES0 masks
Date: Sat, 26 Apr 2025 13:28:25 +0100
Message-Id: <20250426122836.3341523-32-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250426122836.3341523-1-maz@kernel.org>
References: <20250426122836.3341523-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

In order to point out to the unsuspecting KVM hacker that they
are missing something somewhere, validate that the known FGT bits
do not intersect with the corresponding RES0 mask, as computed at
boot time.

THis check is also performed at boot time, ensuring that there is
no runtime overhead.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/config.c           | 29 +++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c         |  2 ++
 3 files changed, 32 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9386f15cdc252..59bfb049ce987 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1611,5 +1611,6 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))
 
 void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
+void check_feature_map(void);
 
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 8813ecbb45763..8d567db03e8a5 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -494,6 +494,35 @@ static const struct reg_bits_to_feat_map hafgrtr_feat_map[] = {
 		   FEAT_AMUv1),
 };
 
+static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
+				  int map_size, u64 res0, const char *str)
+{
+	u64 mask = 0;
+
+	for (int i = 0; i < map_size; i++)
+		mask |= map[i].bits;
+
+	if (mask != ~res0)
+		kvm_err("Undefined %s behaviour, bits %016llx\n",
+			str, mask ^ ~res0);
+}
+
+void __init check_feature_map(void)
+{
+	check_feat_map(hfgrtr_feat_map, ARRAY_SIZE(hfgrtr_feat_map),
+		       hfgrtr_masks.res0, hfgrtr_masks.str);
+	check_feat_map(hfgwtr_feat_map, ARRAY_SIZE(hfgwtr_feat_map),
+		       hfgwtr_masks.res0, hfgwtr_masks.str);
+	check_feat_map(hfgitr_feat_map, ARRAY_SIZE(hfgitr_feat_map),
+		       hfgitr_masks.res0, hfgitr_masks.str);
+	check_feat_map(hdfgrtr_feat_map, ARRAY_SIZE(hdfgrtr_feat_map),
+		       hdfgrtr_masks.res0, hdfgrtr_masks.str);
+	check_feat_map(hdfgwtr_feat_map, ARRAY_SIZE(hdfgwtr_feat_map),
+		       hdfgwtr_masks.res0, hdfgwtr_masks.str);
+	check_feat_map(hafgrtr_feat_map, ARRAY_SIZE(hafgrtr_feat_map),
+		       hafgrtr_masks.res0, hafgrtr_masks.str);
+}
+
 static bool idreg_feat_match(struct kvm *kvm, const struct reg_bits_to_feat_map *map)
 {
 	u64 regval = kvm->arch.id_regs[map->regidx];
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b3e53a899c1fe..f24d1a7d9a8f4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5208,6 +5208,8 @@ int __init kvm_sys_reg_table_init(void)
 
 	ret = populate_nv_trap_config();
 
+	check_feature_map();
+
 	for (i = 0; !ret && i < ARRAY_SIZE(sys_reg_descs); i++)
 		ret = populate_sysreg_config(sys_reg_descs + i, i);
 
-- 
2.39.2


