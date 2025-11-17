Return-Path: <kvm+bounces-63341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 94740C63232
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 10:22:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 42E044ED019
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 09:15:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69FD23271F2;
	Mon, 17 Nov 2025 09:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V+gSvDa/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BEC324B31;
	Mon, 17 Nov 2025 09:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763370941; cv=none; b=qxaQYlPv/5OyuNf4rSr0asQvu8+iOZGHC254NSH/R6fSpEr2v7zK7oax0rWiJDqbyMmHXteKVArlPFnNo6qiqE++KWldwkdp5KEoGURLm2LAzHWhjVhbITGy8ttPJivEfh7vOCVTVJXgTuggkpMc3HoWrpw2IZkPibw0+kUuGTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763370941; c=relaxed/simple;
	bh=+pZ+pPRp95id58hrbhMyP0vzhLBregav22mAd+QANho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3QZ36Qyb00jhSDux71CRmLR6js86o7vzwSbdtuCD2i7mCR/Gq2f02fM2xN6tUgST9GWPxqmJS9YxXB9xJpOZXGV7Fd0ODRRfwGSd9Kl+kzb3pf7ycuvvDyxCjDa03/FYrk0qEm5gHtKzE8d2/apbWQqbP8rWXXcM5gmSOuvSdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V+gSvDa/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6D1C4AF54;
	Mon, 17 Nov 2025 09:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763370941;
	bh=+pZ+pPRp95id58hrbhMyP0vzhLBregav22mAd+QANho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+gSvDa/ILB+oL4oLhVOqUWWpxfJM273ANBQnV8UYLvu4j1FTyFaxpDRzBhSKYxPg
	 0dfQvBqgEuKo8J35iBU7apZK7g8I828u4H4BMNnbAcut0RmAHfeEoaxF+IDZ+8mWm6
	 eO9F1Ry4pRQA7N9QkaPQWGrdxQJr9nsGy6ILBIyg1LBF56pH1xLn/zzvrUbVB3Bk3s
	 B658/Jpp4OwpeaErpoxKMBpfvUpPkkl2qsfZCLvzkwL3ru16o5vFjU802xDkg4Ocsj
	 SMTjdsGhfBJCo9anhIksF6YKKHlYkb92dQrIYI5XDUr2gxN0YqiL3Q4/xcuy4+A3Kf
	 Wvid+R+QHlSvA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vKvKk-00000005lB2-42Bm;
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
Subject: [PATCH v3 2/5] KVM: arm64: GICv3: Completely disable trapping on vcpu exit
Date: Mon, 17 Nov 2025 09:15:24 +0000
Message-ID: <20251117091527.1119213-3-maz@kernel.org>
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

Fuad reports that on QEMU, the DIR trapping is still effective after
a vcpu exit and that the host is running nVHE, resulting in a BUG()
(we only expect DIR to be trapped for the guest, and never the host).

As it turns out, this is an implementation-dependent behaviour, which
the architecture allows, but that seem to be relatively uncommon across
implementations.

Fix this by completely zeroing the ICH_HCR_EL2 register when the
vcpu exits.

Reported-by: Fuad Tabba <tabba@google.com>
Fixes: ca30799f7c2d0 ("KVM: arm64: Turn vgic-v3 errata traps into a patched-in constant")
Closes: https://lore.kernel.org/r/CA+EHjTzRwswNq+hZQDD5tXj+-0nr04OmR201mHmi82FJ0VHuJA@mail.gmail.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index e950efa225478..71199e1a92940 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -243,7 +243,7 @@ void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if)
 		cpu_if->vgic_hcr |= val & ICH_HCR_EL2_EOIcount;
 	}
 
-	write_gicreg(compute_ich_hcr(cpu_if) & ~ICH_HCR_EL2_En, ICH_HCR_EL2);
+	write_gicreg(0, ICH_HCR_EL2);
 }
 
 void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if)
-- 
2.47.3


