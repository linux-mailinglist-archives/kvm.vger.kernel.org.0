Return-Path: <kvm+bounces-63952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 10007C75B89
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:37:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id ABB1B3593A2
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:31:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B7CD3A9BEF;
	Thu, 20 Nov 2025 17:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W9ltta9n"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0E33A8D40;
	Thu, 20 Nov 2025 17:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659565; cv=none; b=fkQDQlHnQWvIUNmmN7o1O/IOUVRCSg4EQUZazbEijGeCKw64+FjlUCBVnOgOcHEXSJvJns9sRGM5ePgUhWbwGkr2kZHYq0T3evqB1g7tlZHqN9U5SGkhd/bJ8cNClvznUKzf9vKdoTw5QAMJVcmNyA1ZxUyeEZ1JEHvl0RwDfo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659565; c=relaxed/simple;
	bh=wdtlW7oExSxObQ4jKYqfqHWLDRMqqpy/Zk8W2VvDjQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Po1g20HSQ/p6RYZ+f+ebIAuePGDaaTtCvDchjG6FiXL0Bw14eCNgga9z37JmLkp6j0xvl43aBPH4/QLZZkcDexuxhfSvD9pXSUdNq9OEcwd/Dp1Cbe/zDr+s5I9XonQpjF4yX9KPsk4445XQoR4Zmh17hYnDSMlXqLgR7gIQG7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W9ltta9n; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35494C19423;
	Thu, 20 Nov 2025 17:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659564;
	bh=wdtlW7oExSxObQ4jKYqfqHWLDRMqqpy/Zk8W2VvDjQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9ltta9nazT3SQ2ZamyMQlAZ+yuH6hyU5zlXNJ07C7fm45he3Q/Xv1bSNq0GVlbzy
	 X2af6GKESAGI7dhS+cj0/+wkk/wUA5Q6XvhABLqIIM0pTwyqLnbBzvIWtRnIq3uqpm
	 C6TACMU+Z7K1tAJP5l7qVb05FN4CmQLDd7tcrJoScrUKFbu05u5egwM6D9Id/e4Uo1
	 +zH8vxJF/LaBOWEbnH82oMGkciCUGV8CNn1w92trWhE0mJOyLF3mcnvrULmXBSOTC4
	 3ffwG1KsFpDBXIB6IkA5vZVF1evq3dTH8xbOA2NZyuUegeeiVqulPjL6hB8Di5bVwi
	 ZBNx2qB0kEQcQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Py-00000006y6g-1qDX;
	Thu, 20 Nov 2025 17:26:02 +0000
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
Subject: [PATCH v4 35/49] KVM: arm64: GICv3: nv: Plug L1 LR sync into deactivation primitive
Date: Thu, 20 Nov 2025 17:25:25 +0000
Message-ID: <20251120172540.2267180-36-maz@kernel.org>
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

Pretty much like the rest of the LR handling, deactivation of an
L2 interrupt gets reflected in the L1 LRs, and therefore must be
propagated into the L1 shadow state if the interrupt is HW-bound.

Instead of directly handling the active state (which looks a bit
off as it ignores locking and L1->L0 HW propagation), use the new
deactivation primitive to perform the deactivation and deal with
the required maintenance.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3-nested.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index 40f7a37e0685c..15e7033a7937e 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -280,7 +280,6 @@ void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
 
 	for_each_set_bit(i, &shadow_if->lr_map, kvm_vgic_global_state.nr_lr) {
 		u64 val, host_lr, lr;
-		struct vgic_irq *irq;
 
 		host_lr = __gic_v3_get_lr(lr_map_idx_to_shadow_idx(shadow_if, i));
 
@@ -290,7 +289,14 @@ void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
 		val |= host_lr & ICH_LR_STATE;
 		__vcpu_assign_sys_reg(vcpu, ICH_LRN(i), val);
 
-		if (!(lr & ICH_LR_HW) || !(lr & ICH_LR_STATE))
+		/*
+		 * Deactivation of a HW interrupt: the LR must have the HW
+		 * bit set, have been in a non-invalid state before the run,
+		 * and now be in an invalid state. If any of that doesn't
+		 * hold, we're done with this LR.
+		 */
+		if (!((lr & ICH_LR_HW) && (lr & ICH_LR_STATE) &&
+		      !(host_lr & ICH_LR_STATE)))
 			continue;
 
 		/*
@@ -298,14 +304,7 @@ void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
 		 * need to emulate the HW effect between the guest hypervisor
 		 * and the nested guest.
 		 */
-		irq = vgic_get_vcpu_irq(vcpu, FIELD_GET(ICH_LR_PHYS_ID_MASK, lr));
-		if (WARN_ON(!irq)) /* Shouldn't happen as we check on load */
-			continue;
-
-		if (!(host_lr & ICH_LR_STATE))
-			irq->active = false;
-
-		vgic_put_irq(vcpu->kvm, irq);
+		vgic_v3_deactivate(vcpu, FIELD_GET(ICH_LR_PHYS_ID_MASK, lr));
 	}
 
 	/* We need these to be synchronised to generate the MI */
-- 
2.47.3


