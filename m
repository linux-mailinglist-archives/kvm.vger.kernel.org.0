Return-Path: <kvm+bounces-63344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0211EC6324A
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 10:23:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D2D734EDB2A
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 09:16:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1AE13277B1;
	Mon, 17 Nov 2025 09:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="boymVtrN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9761326938;
	Mon, 17 Nov 2025 09:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763370941; cv=none; b=JZiNQnO/CKt7snUMtv+mm/IJDiTjOpym6lJRJtQ2MkZsD3RVgN7yfyTbO3J2HTOkbDXb/EQdIx8x2pEKIrRzPwL7UGfJ/AfwdEltBy3nf4Kl6xx0S/l251VyOu1/lsL1HgG6BLwpQLerRJdIN89Oiaq++tQkk1fkNlXh75ijdF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763370941; c=relaxed/simple;
	bh=pOniaDpg1ssIIVZiNyGjODYWvRzJsYp/OU7Z8zQYRTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VyTFjvFiCjAS6eBcfmyizuDrL2BgFMHQi8lGwxNasMOP1UAfhyDkJZ413wBKJcjPgQlCuhsMO1BVYqFpAnp6NqN0pKB62fTaTEAUHfiSAx6YD5K/zH1we7NoUHgLg1Xc/hhoH9sADuu/7nisggTuLML0vulpJCF+GVhsNlrz9VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=boymVtrN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E49C4AF66;
	Mon, 17 Nov 2025 09:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763370941;
	bh=pOniaDpg1ssIIVZiNyGjODYWvRzJsYp/OU7Z8zQYRTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=boymVtrN4mxIXbc5wLw+2GucZh67VyH9jdb724NQG65eSANlhXIdJNp6gXgZPVyer
	 NJVeCqVMVLW+utF7hoyBddCdacvmR9t9qSuD+PkHBudNP7UD8/CGEqirC1D23s7gOr
	 A5C8ch203yZ47EdQHNuwiqvb7uyea/3r94vseaGQw+wXmfda3B8KSDTb+6CJUKLcZR
	 8QTbryIF4WAFkxsEOa8PES9VwUFXCdlgIzg9U9NME8DkyEfIMbDHQqyPAo+2tuSoxB
	 6HydtULHckTVnTAc73sI2rndypTvOZyHMLZ31bg2xlyntZ7eeggQPLH4UwNjgun+Jk
	 xgxDFZRCaJ5tw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vKvKl-00000005lB2-2jTl;
	Mon, 17 Nov 2025 09:15:39 +0000
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
Subject: [PATCH v3 5/5] KVM: arm64: GICv3: Force exit to sync ICH_HCR_EL2.En
Date: Mon, 17 Nov 2025 09:15:27 +0000
Message-ID: <20251117091527.1119213-6-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117091527.1119213-1-maz@kernel.org>
References: <20251117091527.1119213-1-maz@kernel.org>
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
the host in NV, giving it the opportunity to retire the pending
MI. With this, the above test tuns to completion without any MI
being actually handled.

Yes, this is really poor...

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c      | 7 +++++++
 arch/arm64/kvm/vgic/vgic-v3-nested.c | 6 ++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 99342c13e1794..f503cf01ac82c 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -244,6 +244,13 @@ void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if)
 	}
 
 	write_gicreg(0, ICH_HCR_EL2);
+
+	/*
+	 * Hack alert: On NV, this results in a trap so that the above
+	 * write actually takes effect...
+	 */
+	isb();
+	read_gicreg(ICH_MISR_EL2);
 }
 
 void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if)
diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index 40f7a37e0685c..d6797632157a0 100644
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


