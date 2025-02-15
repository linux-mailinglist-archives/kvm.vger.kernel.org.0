Return-Path: <kvm+bounces-38307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76FD4A36FDB
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 18:39:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCAE1170CAD
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 17:39:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DD9D1FDA6A;
	Sat, 15 Feb 2025 17:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WvHKozje"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3431F9A85;
	Sat, 15 Feb 2025 17:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739641104; cv=none; b=d3nO0V/LbkugDTuaDYumRlDsksIX/JMPLb02qqaSsIf2QSlkJzvO/oRrySfb58HAQ+1gZC7cXaqhQn4w71rRP4G09ydEUtpNHT+360JQ8hLRYgrNTwmb+y4XO2wHAv8Y2cgbW/jk41a6wBx3xK8fb9orCXYdiZRctW92pHFXBqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739641104; c=relaxed/simple;
	bh=XuMX9D51rOvDLqugXxKyuaKFZB0IP1O1SmRry/eT/uc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jPAUzBQTf4mmEJQ/5x0j0aOd3Pp42VvgAKklrlhI9DeRQzYRdzcv/5cBeQIeKjBovsv9MNRSso/UpIF9pmtX999I+oPc3dRXDL1p04Bz6nR40dWEhycBgthzKTHlkN89S7QdKf7SIV2q7n5HLGE0hJrsZvN9VfXXjJR0dfG8HJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WvHKozje; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B04C4CEE4;
	Sat, 15 Feb 2025 17:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739641104;
	bh=XuMX9D51rOvDLqugXxKyuaKFZB0IP1O1SmRry/eT/uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WvHKozjea013rJ5CdYymCIVcomvPnzedyhCWg+IFXMlR5hleGEXLFFZS8W211fmbQ
	 nF7vJdiPsEysLCxJoUsb+mE0gzElLPRDbvAMg51XuHVcKRQ2IYdTwxb2Fmw4WdS+6d
	 ys97uUvr/G+cTQ+1Nbbdf/+GpuGPTkn4TT5ZKtFsTAzJWwgW3TLSU4y3TLaBvsc8nt
	 VTZ1srnGkkGHyFaTEVEHdAJfCJszhVKns9Rg1Kt+npGULYFuKW9Lva2Il2Iv62uvCK
	 fKwOxCaWsMqY0Bc1goy2H7UkPNUXvt3Vjb0SRav2VywPsD2+QCWeQ1oLvxyolAQEzA
	 8WvCNQPC96oyw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tjM7S-004Pqp-E4;
	Sat, 15 Feb 2025 17:38:22 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 11/14] KVM: arm64: Make ID_AA64MMFR4_EL1.NV_frac writable
Date: Sat, 15 Feb 2025 17:38:13 +0000
Message-Id: <20250215173816.3767330-12-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250215173816.3767330-1-maz@kernel.org>
References: <20250215173816.3767330-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com
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
index c1e050a58fb2e..db7c4e791b99c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2669,7 +2669,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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


