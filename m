Return-Path: <kvm+bounces-55900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5905BB38784
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 18:12:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B24885E2161
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 16:11:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F6A235AAA5;
	Wed, 27 Aug 2025 16:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F5RBkcLo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901C4352FC4;
	Wed, 27 Aug 2025 16:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756311050; cv=none; b=AuUCDhCffdpV12RlLBDV293I0aP1lJRYBgY6P6zaVBtlLpAOtuGjtYRnd1zVwsTQIotme7yWWPbz2Q3PjRs71w1W+KcvyeXsGqcomgP+re6Gzd0Z5Mh36pyPekR5kezArxDs/DjBgvpNOebLA9f25L/xEwE3X0tE7M6ZZMe9UhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756311050; c=relaxed/simple;
	bh=0JfVi/NdEr3Jmqv7ipgStx4GVp4BrTWb9UY9wl/dGbk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qbry21UoxjuJUXFahThfjq7GubJfNz2ebVWbf4TNNR/MsYb0YOZ/IvCXZwd1flVK3skDhmpoGjIrptSOPBs5GT2OF8hD99kAk8OsqB9MAgUz5pzd9Gdel/rMidASD/74ZgzT4Njb0ToK6sT4jv9xS7vb7abkF2s+BUJiF7sNweQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F5RBkcLo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72531C4CEF5;
	Wed, 27 Aug 2025 16:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756311050;
	bh=0JfVi/NdEr3Jmqv7ipgStx4GVp4BrTWb9UY9wl/dGbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5RBkcLoZPVDgY0frJlYiEetLJnmdNW73TTKnahRv+R3fBJPA/ZuwJtjF6dr673Mn
	 SQ4de6u08IY7DDTwOKBZYXCex/8lUOruI2xoyEBR9OTtRJgkfTze3kyylrVPdmrloK
	 2zyeKvwYb7Gn9jer96cZUi0dxrjIRNZDWAamGLpwaj9RW6g7DgG9OS/loxKKxokBA8
	 5vYUTayZCRUPZ7zk8f1vpopjG7NLFSthvDRaVVypXTLBxOVeBQTBn8uATnrzFwiZ6B
	 WCsuzHjLK+z0pa7BXfrcuKYQLNAaDxXVGrV8imkQtWiMhfck1Fioq78JdcYWXLa9xf
	 DqAcJjMF6SpAQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1urIjY-00000000yGc-2tGi;
	Wed, 27 Aug 2025 16:10:48 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 11/16] KVM: arm64: Allow EL1 control registers to be accessed from the CPU state
Date: Wed, 27 Aug 2025 17:10:33 +0100
Message-Id: <20250827161039.938958-12-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250827161039.938958-1-maz@kernel.org>
References: <20250827161039.938958-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As we are about to plug the SW PTW into the EL1-only code, we can
no longer assume that the EL1 state is not resident on the CPU,
as we don't necessarily get there from EL2 traps.

Turn the __vcpu_sys_reg() access on the EL1 state into calls to
the vcpu_read_sys_reg() helper, which is guaranteed to do the
right thing.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 48406328b74e3..76745e81bd9c8 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -110,7 +110,7 @@ static bool s1pie_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
 	case TR_EL10:
 		return ((!vcpu_has_nv(vcpu) ||
 			 (__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TCR2En)) &&
-			(__vcpu_sys_reg(vcpu, TCR2_EL1) & TCR2_EL1_PIE));
+			(vcpu_read_sys_reg(vcpu, TCR2_EL1) & TCR2_EL1_PIE));
 	default:
 		BUG();
 	}
@@ -139,7 +139,7 @@ static void compute_s1poe(struct kvm_vcpu *vcpu, struct s1_walk_info *wi)
 			return;
 		}
 
-		val = __vcpu_sys_reg(vcpu, TCR2_EL1);
+		val = vcpu_read_sys_reg(vcpu, TCR2_EL1);
 		wi->poe = val & TCR2_EL1_POE;
 		wi->e0poe = val & TCR2_EL1_E0POE;
 	}
@@ -965,7 +965,7 @@ static void compute_s1_direct_permissions(struct kvm_vcpu *vcpu,
 		wxn = (vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_ELx_WXN);
 		break;
 	case TR_EL10:
-		wxn = (__vcpu_sys_reg(vcpu, SCTLR_EL1) & SCTLR_ELx_WXN);
+		wxn = (vcpu_read_sys_reg(vcpu, SCTLR_EL1) & SCTLR_ELx_WXN);
 		break;
 	}
 
-- 
2.39.2


