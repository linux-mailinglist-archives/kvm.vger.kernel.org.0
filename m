Return-Path: <kvm+bounces-62432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AE44C443D2
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:17:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DF7714E960C
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3252A3081A4;
	Sun,  9 Nov 2025 17:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s6eWqtNs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45ADF307482;
	Sun,  9 Nov 2025 17:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708592; cv=none; b=M7Y1vspPNs5WMRtuKcbSXo3kW78PMOENUpLazTKJAXhWUSo+QaTjkEXCtT8jUjQ1671HxlBzjJMGvN99gfAzDUFjvbCqUfrFm0gV+aX8FsXJSCJ3/11ni6ld2fIYPaWHB0HaStdS5vgLuHuaIw1fWZ1r6AQmVAY/g7SD4HYavtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708592; c=relaxed/simple;
	bh=kWoh0WbC/Y4kIFVS60fKkmQMxaj8UxkbJZiL9Sdz734=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4Jay4FdaO0x9EfxRz3ke2ee8tjpnp/Pjtsg+x99ZMQc3JuBjz2nwFNjO1/KTPsB2nM4zIF/axtSdM0q0bHRDi+FoJEMOXiGKWtF8A8eIo/2IIAEJo+oIKzEzaClHfCGa0Ik5hPxtUZiOqmukKxREab+3u79ixOJzoUgwuLOqZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s6eWqtNs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B35CC19422;
	Sun,  9 Nov 2025 17:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708592;
	bh=kWoh0WbC/Y4kIFVS60fKkmQMxaj8UxkbJZiL9Sdz734=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s6eWqtNsy+YPOKsxhtkQNveZzZe8K+2RyAQ66AAYSNfEs8r26bBSku3afYqS3dvwL
	 csAlBHdaKKpvQect2RyGszB0Y31hn/IGK/5BFFDM50PAYkeGi4QQNi1VsPSu+yTDxg
	 pvhgzG6z/1XaOTfm/WMGOkItzh+Hmc6lGXqD2KY2nQFpysJTSEK/ZIaVG8WY39kuOV
	 6wXMCYqS+bA1r1Jyc8eYW1PqFP1Im5qiOmmkKF+5dAxl2UvZuzDaZ3uNOXThtudqlZ
	 gIDaU9LAlZVlHn/jC/kCLX53XsTVLguaUfHDfVFdqhyROx3ow6G0cD7iSqV8VjWe6x
	 s+hdb2KpleyMg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91i-00000003exw-1L5i;
	Sun, 09 Nov 2025 17:16:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v2 09/45] KVM: arm64: GICv3: Drop LPI active state when folding LRs
Date: Sun,  9 Nov 2025 17:15:43 +0000
Message-ID: <20251109171619.1507205-10-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251109171619.1507205-1-maz@kernel.org>
References: <20251109171619.1507205-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com, yaoyuan@linux.alibaba.com
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
index 58942abd2f4e7..3ede79e381513 100644
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


