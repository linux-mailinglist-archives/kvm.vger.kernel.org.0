Return-Path: <kvm+bounces-40640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F351A59449
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 13:27:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D556168E33
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 12:27:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D09AD22B8C2;
	Mon, 10 Mar 2025 12:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U38UHe9L"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE7D22B597;
	Mon, 10 Mar 2025 12:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741609518; cv=none; b=Xgrx0peIrJIgOwvgU3SKbT8dpRRMFQz9kXlD35eRxWP1CTH1WpQn6P5VlG1eyUnBjlbVSJV5hLIA2AFkVtVYsj5UDUzV2Bx9sKZtU2qpI57Zkt1dKfhMUm/2Aq+LZAqv5mfFFhyE0sBlhTpsPwbxTHu+DhYfldjMu+W+97iqYFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741609518; c=relaxed/simple;
	bh=VqanVys6U0Zgtoq6VTrmGdkaMMXAYFhbvoCeIw8qE9Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mC6PRvedx9FrCM9pqpnV77KsXcDynkvLeZJ4gondnRRfTd1YPUG9ef3fyrisjUGKQig9I3VNklXdDCOeh0E/VC2as65YsU83yz66Uq08sfGTmJIJX8eFGpuwqaMMrGWLxuTGKu8twAbj7cGx5OH9FWdfNt0j8VQcUCfvD4CxwYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U38UHe9L; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5240C4CEEF;
	Mon, 10 Mar 2025 12:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741609516;
	bh=VqanVys6U0Zgtoq6VTrmGdkaMMXAYFhbvoCeIw8qE9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U38UHe9LqXiWa99e/lij2DHBiKOWyQ9+X0ZYUnS7TiAO+2AsnXOsU34bcwFYSyQSC
	 Lf4Lgf8KSuYFs459f5e9DENX3UAfLvnJ1548IjGzBASV8EQSW1d15hPbkxgqnyc4X4
	 V3shbsBu4lOUj5PhdFFX8kDw8db7AyvuwFZ5Q9Ej28JSGYecsnRB7A6T9BhXfNget2
	 RffF1noDHR56rbFgUtLrDGNBFctRLkEmejWZuNR3C0efhOAy71igEZxxwZpspcYOIZ
	 iDjLWfZqJGphTjkqVLdYRoNQE70OmptHKIzZVELtpSDRk0Fr6fngUc3FkXJw1RoyJR
	 oHwCstJLRtcAw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1trcC3-00CAea-2t;
	Mon, 10 Mar 2025 12:25:15 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 19/23] KVM: arm64: Validate FGT register descriptions against RES0 masks
Date: Mon, 10 Mar 2025 12:25:01 +0000
Message-Id: <20250310122505.2857610-20-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250310122505.2857610-1-maz@kernel.org>
References: <20250310122505.2857610-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com
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
index fa046a9ad8264..c98f7eed68142 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1565,5 +1565,6 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))
 
 void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
+void check_feature_map(void);
 
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index e38da17445926..d39f1f14e3dc4 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -494,6 +494,35 @@ static struct reg_bits_to_feat_map hafgrtr_feat_map[] = {
 		   FEAT_AMUv1),
 };
 
+static void __init check_feat_map(struct reg_bits_to_feat_map *map,
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
 static bool idreg_feat_match(struct kvm *kvm, struct reg_bits_to_feat_map *map)
 {
 	u64 regval = kvm->arch.id_regs[map->regidx];
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d3990ceaa59c2..89fc07c57e438 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5058,6 +5058,8 @@ int __init kvm_sys_reg_table_init(void)
 
 	ret = populate_nv_trap_config();
 
+	check_feature_map();
+
 	for (i = 0; !ret && i < ARRAY_SIZE(sys_reg_descs); i++)
 		ret = populate_sysreg_config(sys_reg_descs + i, i);
 
-- 
2.39.2


