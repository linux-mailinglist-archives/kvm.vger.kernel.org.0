Return-Path: <kvm+bounces-45644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E0A8AACB64
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:47:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43A10505F33
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:47:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51948288538;
	Tue,  6 May 2025 16:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W6Nrw2uJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735B0288507;
	Tue,  6 May 2025 16:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549855; cv=none; b=jsOVXGTgzzz2xUxYXAqWR39a9HJQ5JOglDWPljSaXBTXsGKexTBfX+2bNIp0MykFMjh5V5s1S8wbyS8jKKJaok8TmOJ+6bhWex0n+1Aqnuoeoh/Ma1SNaqGSMNYxkEi9K1kvn+7GnmLRkrzrVbw+ag1g0sNhHNg9hZY5AYrt9Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549855; c=relaxed/simple;
	bh=oRae7lrhBtQcUt8izVBbIpddqqNNscE/QAue5+QGXVM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q2Jw0Qtv8J+P3jyL7j3epS7HHTBUa4pvzdm+ssxMPGdfCsMdJT7LQI3XmXdteC0aBaGTBnIXoxZuQXJ3aO9oaBndflHu6x5aqw1QsPd+XWOhMW3LZpznv+CVBdFaIMcV1eY7EItcopVMuyEVYGFexEOLGfhMejKEC4nhCxldJ9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W6Nrw2uJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533E0C4CEEB;
	Tue,  6 May 2025 16:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746549855;
	bh=oRae7lrhBtQcUt8izVBbIpddqqNNscE/QAue5+QGXVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W6Nrw2uJkhbgGk3CcRzYwPQl/ZYU/JsszVVqrJa8VHwNL5En0v4m2vDOdPr/bI0XP
	 gS6otarOtF2Atbe5HTH+JarsvX11pbhTo2pXn+You9C8berFqLtLAkgRqVUw7mKiz/
	 8stU9835eperSvgReHGQaZ13eL3UfSTEJUqzEzyBv/MTVNLfWiMLcdxmgvBi2GEopU
	 ptwbof0aZ8P1ZtYeis3kkEbOf/V3lGKiM3d6nri8tX8zFNt6QlbpY4ZQt2VdcQtKA+
	 CZeQb6RN42DJR4grRF3g5Lv1R7I2ZYY00EqizmrXXVkURYtBFmjhiEAPqnU8LoNqYY
	 DZEkGc2pVoHmA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCLOv-00CJkN-IN;
	Tue, 06 May 2025 17:44:13 +0100
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
	Catalin Marinas <catalin.marinas@arm.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v4 32/43] KVM: arm64: Validate FGT register descriptions against RES0 masks
Date: Tue,  6 May 2025 17:43:37 +0100
Message-Id: <20250506164348.346001-33-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250506164348.346001-1-maz@kernel.org>
References: <20250506164348.346001-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, ben.horgan@arm.com
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
index 85350b883abf7..242c82eefd5e4 100644
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


