Return-Path: <kvm+bounces-12409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF1C5885CB1
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 16:55:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E17A71C22E00
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 15:55:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D59E12C529;
	Thu, 21 Mar 2024 15:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="evdSs+Ry"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A07F12BEB1;
	Thu, 21 Mar 2024 15:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711036473; cv=none; b=TWWOGV9Vp/YYYEBO0ISQ84xTm0AMGX8FkDslu6xi+SouB3KWP3oApYq/0E2jhFixwlF1VGKMON+OSNBbixiPXpIix7KXJCHHl5vEUQPj11sKNEViWXXxlFvdQ4WuIM0GkC/8lG5oXnBJSzw4zXm8Bc/+9aT5UklNV7ZtmSk7AFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711036473; c=relaxed/simple;
	bh=O958mgtn9nV4TgPjJ6Mafj249lAxQx44+60Sd2GqF7s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u+Nyjg6v+kt3Xx1Y5N3rvV+yxi9aPZIq3lA6qC1wj8sa7d5+HOqvMisHNhqCBOGSk4a/r30/TsvgL4xUnWu4eRZW9SRuvsTQuWmwNfQJo/MEpJ5Syux9zzyj8iDGV8UMPEenY2YTVNX+VEMtoBzB6oeEK8gu8CD39+j0PXIbnhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=evdSs+Ry; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6CCBC43394;
	Thu, 21 Mar 2024 15:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711036472;
	bh=O958mgtn9nV4TgPjJ6Mafj249lAxQx44+60Sd2GqF7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=evdSs+RyNulD+ZIws5QaJlzu1Fg3cYGAhvLNEtnyqzDpDCoQBhcWiOwDblewHWx5c
	 c7jZMR+KZU5cu9bBNANQ7F5X877W+Cdoqot7o5TnWBsl/b5lkB0I6JuLu5L43PSzwM
	 HRTwGf/8oK7Xz83AHqGeQ1FhwhSc4/brU2Jyo2TnilFrZgSVDC2JctBUNv1BVmD/M+
	 i/i8X3VkFZ7H+BAt/IA/7GQIMpSRkbBK8WWO/XyM828+7vErPeinxmfDCgjd7j4JYc
	 erz8bySAEsOARkeI2lLq0utpBOmPdOA64kkNI4aXAP5vPG1enEhgf5vseFxDshOzFU
	 q+FMBw350Qi/A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rnKkR-00EEqz-0s;
	Thu, 21 Mar 2024 15:54:31 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 08/15] KVM: arm64: nv: Honor HFGITR_EL2.ERET being set
Date: Thu, 21 Mar 2024 15:53:49 +0000
Message-Id: <20240321155356.3236459-9-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240321155356.3236459-1-maz@kernel.org>
References: <20240321155356.3236459-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

If the L1 hypervisor decides to trap ERETs while running L2,
make sure we don't try to emulate it, just like we wouldn't
if it had its NV bit set.

The exception will be reinjected from the core handler.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index eaf242b8e0cf..3ea9bdf6b555 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -220,7 +220,8 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 	 * Unless the trap has to be forwarded further down the line,
 	 * of course...
 	 */
-	if (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_NV)
+	if ((__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_NV) ||
+	    (__vcpu_sys_reg(vcpu, HFGITR_EL2) & HFGITR_EL2_ERET))
 		return false;
 
 	spsr = read_sysreg_el1(SYS_SPSR);
-- 
2.39.2


