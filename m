Return-Path: <kvm+bounces-22812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 34C2E943693
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 21:41:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D2F5F1F2212F
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 19:41:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89E7F16C6BD;
	Wed, 31 Jul 2024 19:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a0xMjMiB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97975166302;
	Wed, 31 Jul 2024 19:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722454856; cv=none; b=dwfVtt70a8lNVFXezvHgF67vePDaSIhq/bull3F7d9Gaa5ESmFXvv1+ncd0W4FHaAjAR+Ak2T9qXnA5H/Wh9WVgDtlRC7HCfYZImgwIhS3+4/jVtH20ct+9TUvMJEsCg0o7TGPnsIP2mxWPyWmKSwHO06J3xI+eSmcfwCK+AiJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722454856; c=relaxed/simple;
	bh=Mpd41u/OQb/mH4vQMFgyLtSbBnfY5mHwiO+lMECYSFQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T/RKnuhgzVc9nwYfx1rnkwr1KSqP3V9ugP+UboH2SUf5q4uVjz+6idDpg7NwFo//pkbe0MSkMCXPlz0I4N8D4PgTEdEizDExEL9Za7pEUT88WaFMbUmV8/SPU4EcER55LwfrPWeLZfGRuE3ie7IKJ26udUACAEWEPK0yFdIBhYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a0xMjMiB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36863C4AF0B;
	Wed, 31 Jul 2024 19:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722454856;
	bh=Mpd41u/OQb/mH4vQMFgyLtSbBnfY5mHwiO+lMECYSFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a0xMjMiBQY39gzExvuTNIBbwOxuKOpoIs6rZQTjU2hxWMhAgFfbi6y8YZvlGnBrew
	 3ZYL6r8O09Cmc/XWetL+AmHoBysCF/2T/Ra2wFGUpDnnGJxO9tjoWjZ/wq5UqffQky
	 kBWRWSHxDm8uUMq8EuoiGr6TWLkiw3hBgouSYZ4zCWLWrRuQ1kJ7/uff7aOYVVF/O6
	 zX3iO4+RBd/6bjWvguSBBvRCxSx+Qta2xyKz+DKhRg5SbtszX7NmP8WoVuxiJCZccB
	 u31nRlTw81AoKJDvZZ6Bcz8kF4rQ7ty64cAp6JbIkdI/GBurlHjGIWeO5NAEZEOY2h
	 qmU9D/XAO6fDQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sZFBu-00H6Gh-FC;
	Wed, 31 Jul 2024 20:40:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Przemyslaw Gaj <pgaj@cadence.com>
Subject: [PATCH v2 07/17] KVM: arm64: nv: Honor absence of FEAT_PAN2
Date: Wed, 31 Jul 2024 20:40:20 +0100
Message-Id: <20240731194030.1991237-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240731194030.1991237-1-maz@kernel.org>
References: <20240731194030.1991237-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, anshuman.khandual@arm.com, pgaj@cadence.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

If our guest has been configured without PAN2, make sure that
AT S1E1{R,W}P will generate an UNDEF.

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c90324060436..e7e5e0df119e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4600,6 +4600,10 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 						HFGITR_EL2_TLBIRVAAE1OS	|
 						HFGITR_EL2_TLBIRVAE1OS);
 
+	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, PAN, PAN2))
+		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_ATS1E1RP |
+						HFGITR_EL2_ATS1E1WP);
+
 	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
 		kvm->arch.fgu[HFGxTR_GROUP] |= (HFGxTR_EL2_nPIRE0_EL1 |
 						HFGxTR_EL2_nPIR_EL1);
-- 
2.39.2


