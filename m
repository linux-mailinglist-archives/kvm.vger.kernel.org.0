Return-Path: <kvm+bounces-42901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6144CA7FD52
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 13:01:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E548D1893756
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 10:56:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8313026B97B;
	Tue,  8 Apr 2025 10:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l+UTcX1O"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A472526868F;
	Tue,  8 Apr 2025 10:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109559; cv=none; b=pspFCrs9aLoQQl/Gx3ZmPThG3apPlylQq+lSNiSdDpC1SDAJn0FQkLcXciKE1S+agA/DG+Nr/f2Skp8MzvmLcYQ10Qih9dwOdRDIDqkeSu8zHQN2Guxkm89mfd3N+1GwvOz/NkkW3LpfNzKKFCEx7twyPvcjgGcLL16xy9d/Z2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109559; c=relaxed/simple;
	bh=SYD6thAU4YhsuRfrEjI6mcpdzWaukNuKKyQAnLgGfHs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aoP8TzYeqb+ZPdaoOdGJIeBOm5gQwmUrbxnfc3Ul4FEL+YwRbu6SZ3EW+qVUfV96B2RQFjhcvg5GMN1RLDJPOyTIJ0sDlkK18r6cXeUMKedsAV1KsAc1AVdzND6aGHxpsiE9uQ6dMYvbPIbUkSlwF3aNsbwNqwBfT6rBptx2VuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l+UTcX1O; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836C1C4CEEB;
	Tue,  8 Apr 2025 10:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744109559;
	bh=SYD6thAU4YhsuRfrEjI6mcpdzWaukNuKKyQAnLgGfHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+UTcX1O6OHTISdpTg0oCc/VZNlOK3yzbXKqOCTTBkRzrsAYx9eZF2rLYK4uLQv8m
	 MSSyeRxj3fI9jbPmMfDRidtLnKzGmZPT+xY0Xqs1ZaxTuvC68YWxRyi8JiR/vhpcVR
	 subv53J2M4pEvS+k0xkhyLx6VrJxKW1su+wlLnCSuAJuetUrHjppD8WkrU+faynkiP
	 Ek9eadizRF9T400bt+RZMnfBOr3i6Gxvic1QiKk1nyqPmHmLrBqT4/SqU7bAZWhwbK
	 7tbsebKwxOBuzHHib6T7h61LzmIkOBkyaOhYqaHPxX2VgN+kZvk1Qqd/Nl92h8pOjD
	 nGWC9yt1nH6PQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u26ZJ-003QX2-AY;
	Tue, 08 Apr 2025 11:52:37 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 01/17] arm64: sysreg: Add layout for VNCR_EL2
Date: Tue,  8 Apr 2025 11:52:09 +0100
Message-Id: <20250408105225.4002637-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250408105225.4002637-1-maz@kernel.org>
References: <20250408105225.4002637-1-maz@kernel.org>
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

Now that we're about to emulate VNCR_EL2, we need its full layout.
Add it to the sysreg file.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 1 -
 arch/arm64/tools/sysreg         | 6 ++++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 2639d3633073d..b8842e092014a 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -521,7 +521,6 @@
 #define SYS_VTTBR_EL2			sys_reg(3, 4, 2, 1, 0)
 #define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
 
-#define SYS_VNCR_EL2			sys_reg(3, 4, 2, 2, 0)
 #define SYS_HAFGRTR_EL2			sys_reg(3, 4, 3, 1, 6)
 #define SYS_SPSR_EL2			sys_reg(3, 4, 4, 0, 0)
 #define SYS_ELR_EL2			sys_reg(3, 4, 4, 0, 1)
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index f9476848a2edf..8f3fa39838132 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2971,6 +2971,12 @@ Sysreg	SMCR_EL2	3	4	1	2	6
 Fields	SMCR_ELx
 EndSysreg
 
+Sysreg	VNCR_EL2	3	4	2	2	0
+Field	63:57	RESS
+Field	56:12	BADDR
+Res0	11:0
+EndSysreg
+
 Sysreg	GCSCR_EL2	3	4	2	5	0
 Fields	GCSCR_ELx
 EndSysreg
-- 
2.39.2


