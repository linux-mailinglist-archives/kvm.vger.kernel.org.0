Return-Path: <kvm+bounces-62437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B933CC443E9
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:18:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C42343B39F7
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:17:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14A1B30AAAE;
	Sun,  9 Nov 2025 17:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MUubn1ZJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295F93090D7;
	Sun,  9 Nov 2025 17:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708594; cv=none; b=rzbwiEJrc7lN4qmyhoxEGiwSnONWGSe+KkrMSfO+0aXrYLw1nQO34O6xs6uDCLQJU+UmI2772GLJ6JH9wjaM1TROkYIDKVF1Usr0debaDiOW49QYbx62f9v83uTGQWNGw+68u7jsZktYjQy68eeQrq3H0cXMnUUnAHx5fEUWE88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708594; c=relaxed/simple;
	bh=v01Vg22EJGqDANe+d5iFLhgxo6rRA09Yj1ZORRZolzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1eR+H4Oxkk5PJ6d/G87lKcyftvj3DshlC/jPH3umB0tiMY2Fn4Gi/ucMOSPHmn8oE/BmZKeB4h8PpC84k/BrOn6eNJEH2c5NSiFybgNyw6IUXeJcKaS+k0JbUt37j2L9mjeGx6/uuzRA5ffpMSUnwd325eL28WToIeMcdWdKHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MUubn1ZJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7BDC19421;
	Sun,  9 Nov 2025 17:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708593;
	bh=v01Vg22EJGqDANe+d5iFLhgxo6rRA09Yj1ZORRZolzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MUubn1ZJ+zSf+4NyOFWohrK/U48k0KxuO3ckPFA1E6UeuG/YGGh3l3wtzZAussoQM
	 C1L3lFJMGCnBK0BchXpoLdk/QmOAi3T982NTiJDB8/ohSP/irTaVLRXtng+zYM5Iuw
	 e6VBg6C8l7CUM28RWIrHo0lp24frv4MKHEaSy+V1cZ4+BYp12P5MYa5U8MSLYzpfcS
	 tTc1rPLeGrKkrd/qPzXq/riU7uKwePTv9+R5CYAG8O8foKj8MnGPBq4+oyoQbwuC4V
	 5txj2gAXm9vpIewYJC8YQwnmJte4Bq8rLVkQOb0+J/JoCtzzoeMJvo+tXcZbe95l2E
	 avU8gopj+1RxA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91j-00000003exw-2gnG;
	Sun, 09 Nov 2025 17:16:31 +0000
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
Subject: [PATCH v2 14/45] KVM: arm64: GICv2: Preserve EOIcount on exit
Date: Sun,  9 Nov 2025 17:15:48 +0000
Message-ID: <20251109171619.1507205-15-maz@kernel.org>
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

EOIcount is how the virtual CPU interface signals that the guest
is deactivating interrupts outside of the LRs when EOImode==0.

We therefore need to preserve that information so that we can find
out what actually needs deactivating, just like we already do on
GICv3.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v2.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 74efacba38d42..5cfbe58983428 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -437,6 +437,12 @@ void vgic_v2_save_state(struct kvm_vcpu *vcpu)
 		return;
 
 	if (used_lrs) {
+		if (vcpu->arch.vgic_cpu.vgic_v2.vgic_hcr & GICH_HCR_LRENPIE) {
+			u32 val = readl_relaxed(base + GICH_HCR);
+
+			vcpu->arch.vgic_cpu.vgic_v2.vgic_hcr &= ~GICH_HCR_EOICOUNT;
+			vcpu->arch.vgic_cpu.vgic_v2.vgic_hcr |= val & GICH_HCR_EOICOUNT;
+		}
 		save_lrs(vcpu, base);
 		writel_relaxed(0, base + GICH_HCR);
 	}
-- 
2.47.3


