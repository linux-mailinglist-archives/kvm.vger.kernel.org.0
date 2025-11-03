Return-Path: <kvm+bounces-61868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FF9BC2D4AB
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 17:56:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E129834B8E5
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 16:56:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1535C31960A;
	Mon,  3 Nov 2025 16:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ahqsfrN6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB92D31BCA3;
	Mon,  3 Nov 2025 16:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188929; cv=none; b=UkDCxOE+pChq0rID53osoVtBJGd0QIj2hPhd88P8g27JIuy4y9vbSvAuhFkL3AYJRyD7uXgTUM/Bky9dwqnzgPOedoZO+I0cNt1eCmT/P8no2kfqrxwHy9pxHxdND/YdD2SEa28YF2oqCb7B42BRbJINWJJEMV1GgB+ei7vP7Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188929; c=relaxed/simple;
	bh=vOdulj5AFu6v0FR3uIvJYJMqreQ8YmIjlJ3xwKL3b1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rDu/CrMGl6EnEEXvziHz3Iz+va4ikf8aiXi/+CjW592p3ErzeP6ptOrHAd/qa/siJNjLP9vn8gX9x+fGiIYZ0IOFK5ijHYgs8MMZGeJiYM8+zeSALuMlKYONbUWch5l1OOjIzqE+gXNbNrixALF4sWBBJuqWJS5MVr7mH+WEJa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ahqsfrN6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCA0C16AAE;
	Mon,  3 Nov 2025 16:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762188928;
	bh=vOdulj5AFu6v0FR3uIvJYJMqreQ8YmIjlJ3xwKL3b1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ahqsfrN63SQgIwHmqrPnaXVQcSQ0Div6eXuCJkpydi14aXlvZbhRQ8AGknoAXVGZb
	 TPDuykcCPcS7brWfg350wz3UgHiRmc9YKEsxceGIZLpcYHatJadVlLYmZgA4sow58k
	 IPJfgYuo5JgxEl1RNParFZr0XcjvYEmtS5Cnq66wnyxMEPeevo5MKwVPD4sApQtxr6
	 IZTJIdB3pZknUmin9eGo1DdkAsT0Fvv7mer/kR2ZOPoUkIxIKd658tPW2z6l1XpDeN
	 ONDnULbbsD896Ti0ZqRdcOFSPWN6PxLHrwiAqjQQMAAF9ovB9s17hei24SZOJxFcmT
	 F4PwT+fD8D6qw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vFxq2-000000021VN-3HYU;
	Mon, 03 Nov 2025 16:55:26 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
Subject: [PATCH 09/33] KVM: arm64: GICv3: Drop LPI active state when folding LRs
Date: Mon,  3 Nov 2025 16:54:53 +0000
Message-ID: <20251103165517.2960148-10-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251103165517.2960148-1-maz@kernel.org>
References: <20251103165517.2960148-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Despite LPIs not having an active state, *virtual* LPIs do have
one, which gets cleared on EOI. So far, so good.

However, this leads to a small problem: when an active LPI is not
in the LRs, that EOImode==0 and that the guest EOIs it, EOIcount
doesn't get bumped up. Which means that in these condition, the
LPI would stay active forever.

Clearly, we can't have that. So if we spot an active LPI, we drop
that state. It's pretty pointless anyway, and only serves as a way
to trip SW over.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index c71cf2bcc57c9..ba2b9d4d0c778 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -72,7 +72,9 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 
 		raw_spin_lock(&irq->irq_lock);
 
-		/* Always preserve the active bit, note deactivation */
+		/* Always preserve the active bit for !LPIs, note deactivation */
+		if (irq->intid >= VGIC_MIN_LPI)
+			val &= ~ICH_LR_ACTIVE_BIT;
 		deactivated = irq->active && !(val & ICH_LR_ACTIVE_BIT);
 		irq->active = !!(val & ICH_LR_ACTIVE_BIT);
 
-- 
2.47.3


