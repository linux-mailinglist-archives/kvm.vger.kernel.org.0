Return-Path: <kvm+bounces-63925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id BF1B0C75B5A
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:35:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D3B414E8C27
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:29:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68C39371A2F;
	Thu, 20 Nov 2025 17:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m6md+j+N"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A59936C5B5;
	Thu, 20 Nov 2025 17:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659558; cv=none; b=YbJ+LQFYpA7d9gBuyCF76cWYL9GMXWuxphlcKGaHE3k/JCSAsNDhEHBCWAp7pStfM384myT+pVwUweX5yENY9+5fs1M5gvtr6WN2F6PKVt9ToxTdBn/CUGA8r8eeUcMmo+VZqEN1FNegXqVzffnSr7iWTgdKPwdWYYSQoXEO5x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659558; c=relaxed/simple;
	bh=Phnjr10/3FSU814EfoeZq4CTVio4OIfPI7Xamjqjd9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBhfCZ795ofo6dyqt6crGVrjBKLKZqt90USMIWq3iQeeaJBklgNF/e2H47SwMx4FlUUMLzdUg6plB6IM0sX4N9ryzE5VJOIPiGtONO2TKmtXAQMfIZ+FQ6dQVx5kjjbiHqY63VWOcyf6ktz+pHg6Q6oJiWh5Lsx/ph89OC/b6HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m6md+j+N; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3052C19421;
	Thu, 20 Nov 2025 17:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659558;
	bh=Phnjr10/3FSU814EfoeZq4CTVio4OIfPI7Xamjqjd9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m6md+j+NSq+asIjrap5hOKsHaUMm1LXwNUJk2deeiAQ9aTWLbFOD49vyusxWHU03B
	 +jvvGtDcZKGLR0Zf8MSOoQd4jpWOiaOAM3tsGl3nX27/AkLm7l3fsto5PW28avaY1F
	 7FxU9jN8r0CLblbxga+HNp0LMZpdbn6P2Li5AJInZAEn2Q3F4Q8WnEWrWFRqTi141A
	 MmcKZ6ZCnragJlZIa1l+I1v3yDuAEKsZOoxGsYiJ/73vUJ1tTJ9vmmcOiHGQZLI7zV
	 6UqhYMGbuxpCtjwCvVYJkWMxR081OQWtVwZgUmCQCVjF+8+5QsOoicjpLmx+GwD0RT
	 U8URsKlZrL+dw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Ps-00000006y6g-12j3;
	Thu, 20 Nov 2025 17:25:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 10/49] KVM: arm64: GICv3: Drop LPI active state when folding LRs
Date: Thu, 20 Nov 2025 17:25:00 +0000
Message-ID: <20251120172540.2267180-11-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251120172540.2267180-1-maz@kernel.org>
References: <20251120172540.2267180-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, tabba@google.com, broonie@kernel.org
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

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index e3f4b27e0225f..81d22f615fa66 100644
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


