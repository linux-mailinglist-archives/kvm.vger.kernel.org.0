Return-Path: <kvm+bounces-45652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 03F62AACB6D
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:48:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D74D83BB092
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46AC6288CBF;
	Tue,  6 May 2025 16:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YBy/vWP6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D4B288C3B;
	Tue,  6 May 2025 16:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549857; cv=none; b=aexsTjHHukX8kak1gRpTCNBMO6pM20heF542T6Nb9kv0jDrr4jxNpCf4li1wfZ880LmmwUVxpq7P7ZQmlyJrgxfee1303HjrwcmaSIrmVAxWugbONV9US2LkH1VVzBMrUWV0ug9qeIk501he+Nu86YOyhKp93tMUogYbc3TqwRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549857; c=relaxed/simple;
	bh=GiGc1R1Pi1q8F7lTqhQerLhx4turyXGHxprlQAfaI0g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NTOxNJ4X1SCZG3BCtwK4seBoL/1JaVc7+uzzhMR3WqE0wT3QUF0lDp8ewY4/hA3Kl6SAT4ALZPccvA6aYB6X4D92y6sSiPt4erG1ZOS8yQnUFQIyyaDVF1WUc35iyocXh4CPtmQE13xncmP63Q9YUJo0I3iJAsflIXVu/mlSLC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YBy/vWP6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF245C4CEEB;
	Tue,  6 May 2025 16:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746549857;
	bh=GiGc1R1Pi1q8F7lTqhQerLhx4turyXGHxprlQAfaI0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YBy/vWP6RdVVZRGfCOow4wh68Lp8BIwlYEaiYUglDsQ2Yywas7sKrz/os0d+n+ykl
	 hWrWKrKPRcmBXApF75DKrk8rcY4DRQAEGE1zzkBx9ZLoVhoSBckCt5K5dcQU5iZJ9x
	 Gy8iuU2Ss5Jlc6og07ulyn8i7adzE9XY1B8IdX9jEmSq8UtVKK3KUO5m7T76yx+HYX
	 3tZJSehkTc/lUAAS0W4yy6+CqESkDEooVp1FUWHFtkk0ngF77oJG7KmrZEqeNGk6Mn
	 sIzcBORO6CRbWU0vpzSLfqLFyUwFxX4klyAcu+PTau89Yqg+MEOEN4BAeQYa9V54Nf
	 Ck/mmoq3zvhhQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCLOx-00CJkN-7f;
	Tue, 06 May 2025 17:44:15 +0100
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
Subject: [PATCH v4 39/43] KVM: arm64: Add trap routing for FEAT_FGT2 registers
Date: Tue,  6 May 2025 17:43:44 +0100
Message-Id: <20250506164348.346001-40-maz@kernel.org>
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

Similarly to the FEAT_FGT registers, pick the correct FEAT_FGT2
register when a sysreg trap indicates they could be responsible
for the exception.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 3312aefa095e0..e2a843675da96 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2485,6 +2485,18 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
 		}
 		break;
 
+	case HFGRTR2_GROUP:
+		fgtreg = is_read ? HFGRTR2_EL2 : HFGWTR2_EL2;
+		break;
+
+	case HDFGRTR2_GROUP:
+		fgtreg = is_read ? HDFGRTR2_EL2 : HDFGWTR2_EL2;
+		break;
+
+	case HFGITR2_GROUP:
+		fgtreg = HFGITR2_EL2;
+		break;
+
 	default:
 		/* Something is really wrong, bail out */
 		WARN_ONCE(1, "Bad FGT group (encoding %08x, config %016llx)\n",
-- 
2.39.2


