Return-Path: <kvm+bounces-55904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4585FB38786
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 18:12:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4232D7B89E0
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 16:10:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EF8035CEA3;
	Wed, 27 Aug 2025 16:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dy5ZuCBj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3E535A29E;
	Wed, 27 Aug 2025 16:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756311051; cv=none; b=PMLgELzv9UU589fU3EkAOXouo1D76J+Usg0vCQ04Z9ZXN8AMGwyC0+Ww8dqRBgFULG+c7hBtnTLU6jGT1EtZ1fkUKOUPgI9g3NKjvvJ6RAc43jndD5BHVeW6ZBIV5OGK5jS9QaOxtAA321mc806l+FKf1kqVg2f1hbpWv7/7aNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756311051; c=relaxed/simple;
	bh=WGAcyYYKKfrubRZESqblkQKkoN12vcYQEG40OL+z1s0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cgrMku/VcP2+I50QvB7oITq7Ccxt87210VBMMAsyCqMjuZ9FaDkBH65Cb6NKGZwmQtKKsKGWMrQpMicpt2GxlnmmtigwIMKlGct9/Oalohqo7SR0do6BdolQcqGho6mn9by0+QubyWycIrefAwVxfad3XiXxk1HLTO5oFaSke64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dy5ZuCBj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB04C4CEF5;
	Wed, 27 Aug 2025 16:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756311050;
	bh=WGAcyYYKKfrubRZESqblkQKkoN12vcYQEG40OL+z1s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dy5ZuCBjZ6nIpEAXUOkvlBh2x+jPXvauu+3bejaco+paybytZosks5wJw8Vmt6eWg
	 0bHtlrY7LO0R9wsAX1Jk6uPHM12FukCHW3X3nYhVs3+zYpypeSDVDvqZai7G+DMimA
	 tOI9Ay0P5BpEEOeSHWuMl24tTUM0/5G9WqmufEb6+w3u3tTnYO4BCKonHIwcWMailv
	 2ZGgo+3JsfZf4r5S30OAgUuwyNy9w20f5STiQ+tgekBiWIlEPLLyMH/4+5PAUZiP6A
	 vIqn9ZaLMUESQeNHBjF7lwONq6yeL7g0JBdxaMP2CjpQuSRmvAsKJ1LJUUMimcRzh7
	 zLQ+DCVWCMW7A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1urIjZ-00000000yGc-0LZK;
	Wed, 27 Aug 2025 16:10:49 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 13/16] KVM: arm64: Add filtering hook to S1 page table walk
Date: Wed, 27 Aug 2025 17:10:35 +0100
Message-Id: <20250827161039.938958-14-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250827161039.938958-1-maz@kernel.org>
References: <20250827161039.938958-1-maz@kernel.org>
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
index 6e767ae3c495a..f77c16225557f 100644
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


