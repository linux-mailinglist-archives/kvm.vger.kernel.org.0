Return-Path: <kvm+bounces-63950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 374A3C75B88
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:37:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3232736521C
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:31:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41ACE3A9BE8;
	Thu, 20 Nov 2025 17:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D8G85O4T"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9922C36C0D6;
	Thu, 20 Nov 2025 17:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659564; cv=none; b=P73a+ah94kHNL2NTlGHlpSP4KsrlOcktpZdqRa4d+NeJxwfd+OpTrDnUHu393cVd6ylVxslm/oL89rYFe69p7D25Ku1fqqUX751ByJqafN4GraQKUGNpAzqzhTj8KSOXWp27UvZd+f46f+xff0ZLYrw22GShlSuC51Pb+oMR+7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659564; c=relaxed/simple;
	bh=uuXDuGaawaXMBpGfHqc3VPAUhOtcPVebdv2VhuACRvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z3WCSPnQM+ajuqrz+L1Xr1WvW2AkaQoo9TBnEWkPcm2YqhgJODwcv+NWZD6yenD4DV6fVd6PN4JZLEw5EtNIHZ4D7DHps3YQW4K9AX5Q26QUYI52pnpzFPq3+MUHotXTWEpvgveL5Rs2w1G/ICcQxTwASDcaX5n/ToXKGPiS0Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D8G85O4T; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E250C4CEF1;
	Thu, 20 Nov 2025 17:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659564;
	bh=uuXDuGaawaXMBpGfHqc3VPAUhOtcPVebdv2VhuACRvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D8G85O4T5oUURqygPg8xL4mOvnpU1Sp6CEWSVGWzlGv+2l7cb9V/HpHkveNdeDQC4
	 FjBAURz8ozOIZ6IJ9tyvWo/V4VRkp2Tt0yP4QvF2Jr4WUQEt2GRBLTuxMpdvzYmtrk
	 bNzJNjTumeOhtelKSTEPowhA1aoBgwf+FYyfYtWsemrtNeaXlxbBDkPZjTMAzYUj2e
	 3R8iiGEpnI5TVuAIMguDRToL+v9x7Ebxy3gIX8DaCdIDs811PVwSUFnqR3HjY4mwdh
	 7FK/8IREPAjPeeHlQ2eeOTQue79qrzxY0+7sgfpBaaj9i7ICLi/NyQGMEJy3kYT3hV
	 20krSVHL30oJQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Py-00000006y6g-2q5M;
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
Subject: [PATCH v4 36/49] KVM: arm64: GICv3: Force exit to sync ICH_HCR_EL2.En
Date: Thu, 20 Nov 2025 17:25:26 +0000
Message-ID: <20251120172540.2267180-37-maz@kernel.org>
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

FEAT_NV2 is pretty terrible for anything that tries to enforce immediate
effects, and writing to ICH_HCR_EL2 in the hope to disable a maintenance
interrupt is vain. This only hits memory, and the guest hasn't cleared
anything -- the MI will fire.

For example, running the vgic_irq test under NV results in about 800
maintenance interrupts being actually handled by the L1 guest,
when none were expected.

As a cheap workaround, read back ICH_MISR_EL2 after writing 0 to
ICH_HCR_EL2. This is very cheap on real HW, and causes a trap to
the host in NV, giving it the opportunity to retire the pending MI.
With this, the above test runs to completion without any MI being
actually handled.

Yes, this is really poor...

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c      | 7 +++++++
 arch/arm64/kvm/vgic/vgic-v3-nested.c | 6 ++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 99342c13e1794..0b670a033fd87 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -244,6 +244,13 @@ void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if)
 	}
 
 	write_gicreg(0, ICH_HCR_EL2);
+
+	/*
+	 * Hack alert: On NV, this results in a trap so that the above write
+	 * actually takes effect... No synchronisation is necessary, as we
+	 * only care about the effects when this traps.
+	 */
+	read_gicreg(ICH_MISR_EL2);
 }
 
 void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if)
diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index 15e7033a7937e..61b44f3f2bf14 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -94,8 +94,10 @@ static int lr_map_idx_to_shadow_idx(struct shadow_if *shadow_if, int idx)
  *
  * - because most of the ICH_*_EL2 registers live in the VNCR page, the
  *   quality of emulation is poor: L1 can setup the vgic so that an MI would
- *   immediately fire, and not observe anything until the next exit. Trying
- *   to read ICH_MISR_EL2 would do the trick, for example.
+ *   immediately fire, and not observe anything until the next exit.
+ *   Similarly, a pending MI is not immediately disabled by clearing
+ *   ICH_HCR_EL2.En. Trying to read ICH_MISR_EL2 would do the trick, for
+ *   example.
  *
  * System register emulation:
  *
-- 
2.47.3


