Return-Path: <kvm+bounces-24611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 02B5E9584C7
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:38:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A15A11F26575
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95B3A18EFD4;
	Tue, 20 Aug 2024 10:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kjv8B9Cy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9AB18E744;
	Tue, 20 Aug 2024 10:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724150287; cv=none; b=C7KwjnZasJLpJPFDC0KVReQcS4sqj3D22aNzkMHaU1+qsFjcNrwOhFEETD9LwMPNSg1GR+9YfsH53DoEK2rdGkza972XVLcRER8io+xecGC/qraKuUxEhBQ09T8aE/ML6Fp+DDzPlSqKHuvY15vi58pGurKX+43+DwYFs5WNmA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724150287; c=relaxed/simple;
	bh=Mpd41u/OQb/mH4vQMFgyLtSbBnfY5mHwiO+lMECYSFQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f6OcsFIK93HZjthuz7eqmeaSXEyecGRx/zkzijMi1yXARZAPoQoEGa/2F09EuYSN4+8tjiPgPQdS7aFRl1JrpFMGu3DTDUNiz4ysanwQHBivkjnjioWsHgnP8yBpZHLo0FNQ7iWOC6tTFIYvCk9ExbM0YhjZIHLb3+rT3wI7KD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kjv8B9Cy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE49C4AF1A;
	Tue, 20 Aug 2024 10:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724150287;
	bh=Mpd41u/OQb/mH4vQMFgyLtSbBnfY5mHwiO+lMECYSFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kjv8B9Cyf7gqRyOgJUsB0soGhuwWfFV6cWmIeFLNyB92IkUz6ZKmSAOSg8/TMLhMF
	 UM884dnrsv07nsxdM8q/TMuPk8U+05DnHY955GEY1fE6lv4Up8HajgMldgAuPznQD1
	 3mefEOI8YSzr5EQvB4LAx6z3JZJVvJ6ddsfbXhkrLsbBtt/W2JI4z0/qvhbrFeJA6o
	 rEIsY4/GNgMvvJehpdcxhbgJz6s/pZ/SH1lbY86RtSmI0MYxpvscns8nCVHyRZGq6O
	 Wm4QpN1xBzfZQE10+PaoED+lKJngO5XWyYxupg2W2gYESPDH9IIsclmOeGr57eh2SL
	 dfUvhUAhzCV1g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgMFZ-005Ea3-JK;
	Tue, 20 Aug 2024 11:38:05 +0100
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
Subject: [PATCH v4 08/18] KVM: arm64: nv: Honor absence of FEAT_PAN2
Date: Tue, 20 Aug 2024 11:37:46 +0100
Message-Id: <20240820103756.3545976-9-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240820103756.3545976-1-maz@kernel.org>
References: <20240820103756.3545976-1-maz@kernel.org>
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


