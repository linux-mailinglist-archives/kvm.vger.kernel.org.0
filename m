Return-Path: <kvm+bounces-38702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA71EA3DBB0
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 14:50:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E017177C24
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 13:50:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E5E31FE46E;
	Thu, 20 Feb 2025 13:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z3+CA5w2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA661FC7C1;
	Thu, 20 Feb 2025 13:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740059355; cv=none; b=mqZRK1by9BeLo6NN0NRrKar1Oplo29KMl/uN4EG68kl17p2hWRF9plWsq26573g8N1eRLYHrSPnbsfC5H9L158UBN+RkL3xTaBKf+LlBYzfrujlZvvcBMMef6n1Rg1eCtrSSCRKV6pO1iT0BwpL64JzYlrTTqy5+LtPw0R0peRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740059355; c=relaxed/simple;
	bh=XPusa/GmQMNqrhdWCp6rHpZE8+86Ko8D1+HDlpC47Ks=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I/fEbMQcM5LNPKznaEW8PsA9YNxevt4ADML675rWXxGZoF+vxMbLbiz7x+cLqJgTO2uacAa4HO8moJgxloko6OT79RD3I1we0s//3eyyLRdWWUWdpGlRtvjTpmDDmgx+R7PFniIogF8RQXMduM5dAdSlsu/16IR5n6sOMEanABE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z3+CA5w2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80329C4CEED;
	Thu, 20 Feb 2025 13:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740059355;
	bh=XPusa/GmQMNqrhdWCp6rHpZE8+86Ko8D1+HDlpC47Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z3+CA5w2wo+D8OkEMEQJS6XhdrRz7RieBN0Jb2vJRZIR92i3OiHpq7VtmgHtO/oQF
	 GKyYTbh9axo6Kgxex+rMUbp0TsCM8ruMMALh9i61VchNWrqYez9jR39fPAfIRuYDW9
	 JBuErhNImtDb8FFhp1JBACGRQfuxiggk9nCXwFkRMJ5Ddi7sWXkMyRkoJB6xBHlF6q
	 3elWoEcBONi69Qm4+AJupZmLpIYTLlX6v6wK38+cdYn/Nx5tUgL+iS1lu2YITp7kV4
	 x9CK+TNk5490nm0S/ynN5++qgAXL+ni+YvP/BMMZLo1I4RbVd+3WQpIEDhqpM2BAEw
	 C1/W4DePHICXA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tl6vR-006DXp-Oh;
	Thu, 20 Feb 2025 13:49:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	gankulkarni@os.amperecomputing.com
Subject: [PATCH v2 11/14] KVM: arm64: Make ID_AA64MMFR4_EL1.NV_frac writable
Date: Thu, 20 Feb 2025 13:49:04 +0000
Message-Id: <20250220134907.554085-12-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250220134907.554085-1-maz@kernel.org>
References: <20250220134907.554085-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We want to make sure that it is possible for userspace to configure
whether recursive NV is possible. Make NV_frac writable for that
purpose.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 87f165289fb9f..5de542b045ac8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2666,7 +2666,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_WRITABLE(ID_AA64MMFR3_EL1, (ID_AA64MMFR3_EL1_TCRX	|
 				       ID_AA64MMFR3_EL1_S1PIE   |
 				       ID_AA64MMFR3_EL1_S1POE)),
-	ID_SANITISED(ID_AA64MMFR4_EL1),
+	ID_WRITABLE(ID_AA64MMFR4_EL1, ID_AA64MMFR4_EL1_NV_frac),
 	ID_UNALLOCATED(7,5),
 	ID_UNALLOCATED(7,6),
 	ID_UNALLOCATED(7,7),
-- 
2.39.2


