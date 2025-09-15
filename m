Return-Path: <kvm+bounces-57560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5925DB578D8
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 13:46:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D6B4443B34
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DAFD302146;
	Mon, 15 Sep 2025 11:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RmzyqXcl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9313009EE;
	Mon, 15 Sep 2025 11:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757936699; cv=none; b=CyP17bnbmu2yGdar4UyGLbLZhIAy0TwhLE5X8q8JpCS0YcbzZczlgtz6ovWfU4u6RkCsh04iyCYSMe74zYNnNK5VIRLrG18Pdeu1MxoiIyK6UC9vnb9eFHDt4z0Dm7dlefhXgbVewBqaoUHIAoQPLQQ30tTMIaeMlR9nS22gxQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757936699; c=relaxed/simple;
	bh=6s66At4Y3xWWNXiyYuFX05mylZmGoxm2uLgtoUWeXiA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qfyc4nhZMBS9HVCTNBuz+M7dLi1P5++B4e0/NPuK+NpQyzQ4a5zcT0N9cxJOWLiSb24CFS+pDct9ygQ+vM+JV9qGuGkF1GQHWQTEKLgV8N75PVHipe9/mTjlzyJv8sxQBlj8idBiDY5jDKUnsENP5Xbe38ayARlfTZrOSiEU1H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RmzyqXcl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0F4C4CEFE;
	Mon, 15 Sep 2025 11:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757936699;
	bh=6s66At4Y3xWWNXiyYuFX05mylZmGoxm2uLgtoUWeXiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RmzyqXcl6lY6d8jCKbzMWnQBIMj3Qdmm2RH23MLhQZOXrKEGnJUBWe7YEsSa9wUkZ
	 FRlPSg+IM2zog2EAzaJw8H+utTAzH5D6qYzRCyHYjljn2hvXnLdVKhoSe7l82SmKno
	 f9jhArycNs4MOz2dycgH6Fsdu05UQHkT/VVFn3Hv14mEpRPE8E+byp/AcSxASme0/P
	 rYTanIspErJCI5b9MqaE9x5aJ2CyfYj3AVmJ6QoVgVCxkaFDrtxq4O4psAc9w7K4w3
	 1GHLQ0Gn777onNovviQc6VXwmg0meaCmezWJcGii89dh63iozOZnEtuzzWb5NkYl+0
	 kimjNBQvJcDjg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uy7dh-00000006MDw-2Bbe;
	Mon, 15 Sep 2025 11:44:57 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 13/16] KVM: arm64: Add filtering hook to S1 page table walk
Date: Mon, 15 Sep 2025 12:44:48 +0100
Message-Id: <20250915114451.660351-14-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250915114451.660351-1-maz@kernel.org>
References: <20250915114451.660351-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add a filtering hook that can get called on each level of the
walk, and providing access to the full state.

Crucially, this is called *before* the access is made, so that
it is possible to track down the level of a faulting access.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 14 ++++++++++++++
 arch/arm64/kvm/at.c                 | 11 +++++++++++
 2 files changed, 25 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index f3135ded47b7d..cce0e4cb54484 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -288,7 +288,21 @@ enum trans_regime {
 	TR_EL2,
 };
 
+struct s1_walk_info;
+
+struct s1_walk_context {
+	struct s1_walk_info	*wi;
+	u64			table_ipa;
+	int			level;
+};
+
+struct s1_walk_filter {
+	int	(*fn)(struct s1_walk_context *, void *);
+	void	*priv;
+};
+
 struct s1_walk_info {
+	struct s1_walk_filter	*filter;
 	u64	     		baddr;
 	enum trans_regime	regime;
 	unsigned int		max_oa_bits;
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 2f6f83cc8d19d..c099bab30cb0d 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -413,6 +413,17 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 			ipa = kvm_s2_trans_output(&s2_trans);
 		}
 
+		if (wi->filter) {
+			ret = wi->filter->fn(&(struct s1_walk_context)
+					     {
+						     .wi	= wi,
+						     .table_ipa	= baddr,
+						     .level	= level,
+					     }, wi->filter->priv);
+			if (ret)
+				return ret;
+		}
+
 		ret = kvm_read_guest(vcpu->kvm, ipa, &desc, sizeof(desc));
 		if (ret) {
 			fail_s1_walk(wr, ESR_ELx_FSC_SEA_TTW(level), false);
-- 
2.39.2


