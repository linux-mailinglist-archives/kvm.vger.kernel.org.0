Return-Path: <kvm+bounces-57559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C3B0B578CF
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 13:46:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9D75161D91
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:46:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 505053019DE;
	Mon, 15 Sep 2025 11:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fqORv/Os"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2EE3009ED;
	Mon, 15 Sep 2025 11:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757936699; cv=none; b=ThE6WHZjzwU4B0r9EBzirWRWCVv6vEl6sTzc2xDCRcnOlyL39MPKQBVaRTOAkVZ2QfoxLULJ9HUCD2TFGhJTIAJsFn4Sl0/WPyhfNKLM3E4AeKA6h+FC77MXf4LEHIg6rIaG1fP6rDIoltYYgImJDcrxnXFoLImxkUOsoRC2Su0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757936699; c=relaxed/simple;
	bh=CHEV3kfdyE9wl1c6Ioc5A3Xa8u3LcRzauHlZkqmRQec=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ihURQ4hTs1OZ5xypVLMeadaf0dWp920rte5RfYUs6n+ud33kNHcxjr81HpdfnEtF6gI7IoS5Ko+R0i1s64PnIvyXP+IhJKCmBKBRWfOKjFwFFb+CN8UaX+rhx3CkeXA6pPB48RMcACRhHrsQDeDLWcFdKcFQpvTy/7pD+AfFdeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fqORv/Os; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4395C4CEF7;
	Mon, 15 Sep 2025 11:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757936698;
	bh=CHEV3kfdyE9wl1c6Ioc5A3Xa8u3LcRzauHlZkqmRQec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqORv/OszNbkJa8rPhzpfQEN2avWdu6FOQLyCfA59ujY0NorbZ1/w4IxRDBCshbfF
	 1ZhTOD9VsHF6GPufnZb+tls3hHPEd5KjI6D/0ECazoXPzLgYB3Au2hdb7/+tJlOHKC
	 GoJO2sPyQLYaj3gSc7GBA4TJTqElZbdWKYgUaLk03gg0gIBvjE4HxGQ2WaIl+uqMPJ
	 I0phfSdpbT+7t+qMwsUqEaOyq0R/AiRNHOBSyQdq/e3domzQ+qXP7ZSQwGefisI0pT
	 ouP0uU6mDXoBsfm0qG9kXnUF/Y+iE1uh8qd1YrRYq8th84/d4T5+w0GlHHfhUDEkny
	 p+Y/7d9ci7RQQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uy7dh-00000006MDw-0OlV;
	Mon, 15 Sep 2025 11:44:57 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 11/16] KVM: arm64: Allow EL1 control registers to be accessed from the CPU state
Date: Mon, 15 Sep 2025 12:44:46 +0100
Message-Id: <20250915114451.660351-12-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250915114451.660351-1-maz@kernel.org>
References: <20250915114451.660351-1-maz@kernel.org>
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
index 4f6686f59d1c4..c84a021067daf 100644
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


