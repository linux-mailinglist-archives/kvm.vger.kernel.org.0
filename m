Return-Path: <kvm+bounces-44422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B9C5A9DA96
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:30:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 664F47B2C10
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:28:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94C162512F3;
	Sat, 26 Apr 2025 12:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mEE/1Urx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA3F24BC1A;
	Sat, 26 Apr 2025 12:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745670533; cv=none; b=B3g3+n3YvROCvAY10kerbVaq1PpQkvfcYrgxN1FcU/fRfprTBXz/BQfCe0+2S31jN1J6ZECd1EGPRweQ9PDL7aac1Der2A5Ygi9dkmzCRp4u7Mhu3Y3r4OrgjKRni2WNjHXwFLx+wYBS1V8B+wjUwl9wtmf2s+HE9WByT3imoWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745670533; c=relaxed/simple;
	bh=BBAhuhtwHnlUbcc2gLXd+VmoCR220Lc1P5/EA9ClEZw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P6xt69lFlYc/eoqx40Ewz2K9MNPYJ3V6wH8sSH8MCpKAV1sV9sRcDpeZOodVP2bd2dsMswxlIwrzpT15+DdX5bYU7CIqzUqKM1tBqxZboCkpd7YYn4FVDy1g7djXhHfhQeMZkB8IwdXJepdd0phXe2Br/rC0WXy7gw0daUBXZhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mEE/1Urx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49905C4CEEE;
	Sat, 26 Apr 2025 12:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745670533;
	bh=BBAhuhtwHnlUbcc2gLXd+VmoCR220Lc1P5/EA9ClEZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mEE/1UrxKOBIzAcDCeQWrSccykivnP0S42xEfecsJOLJQUG9DwRkNm2FtjS6kh4Ca
	 OU13TVtkF5WSfp4DxhACyMx5wdnIapRJU7pj7HFKeod6fSmC4tZFH+YtiAEfFH4h+r
	 iAO8ol2gSmvGqZo+js7QfbqCVz2fz86CY05sfLBMrxwLQyL89UK33ZXRmbPNc6MwvI
	 taCScpFGTIok2JT6K/iJregHyF+XWezPu6xRsHoXMiAJePoVQd6pMXS1CXpz3JOjlZ
	 /RwckX9v7Bmpg0zNpZhKD8fCqYCqkea5UKShypXK6ecqAcTaUPFAByG2daGWHeuzzF
	 EXkMAoCT/iuQA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u8eeJ-0092VH-BU;
	Sat, 26 Apr 2025 13:28:51 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 11/42] arm64: Remove duplicated sysreg encodings
Date: Sat, 26 Apr 2025 13:28:05 +0100
Message-Id: <20250426122836.3341523-12-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250426122836.3341523-1-maz@kernel.org>
References: <20250426122836.3341523-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

A bunch of sysregs are now generated from the sysreg file, so no
need to carry separate definitions.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 8908eec48f313..690b6ebd118f4 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -535,7 +535,6 @@
 #define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
 
 #define SYS_VNCR_EL2			sys_reg(3, 4, 2, 2, 0)
-#define SYS_HAFGRTR_EL2			sys_reg(3, 4, 3, 1, 6)
 #define SYS_SPSR_EL2			sys_reg(3, 4, 4, 0, 0)
 #define SYS_ELR_EL2			sys_reg(3, 4, 4, 0, 1)
 #define SYS_SP_EL1			sys_reg(3, 4, 4, 1, 0)
@@ -621,28 +620,18 @@
 
 /* VHE encodings for architectural EL0/1 system registers */
 #define SYS_BRBCR_EL12			sys_reg(2, 5, 9, 0, 0)
-#define SYS_SCTLR_EL12			sys_reg(3, 5, 1, 0, 0)
-#define SYS_CPACR_EL12			sys_reg(3, 5, 1, 0, 2)
-#define SYS_SCTLR2_EL12			sys_reg(3, 5, 1, 0, 3)
-#define SYS_ZCR_EL12			sys_reg(3, 5, 1, 2, 0)
-#define SYS_TRFCR_EL12			sys_reg(3, 5, 1, 2, 1)
-#define SYS_SMCR_EL12			sys_reg(3, 5, 1, 2, 6)
 #define SYS_TTBR0_EL12			sys_reg(3, 5, 2, 0, 0)
 #define SYS_TTBR1_EL12			sys_reg(3, 5, 2, 0, 1)
-#define SYS_TCR_EL12			sys_reg(3, 5, 2, 0, 2)
-#define SYS_TCR2_EL12			sys_reg(3, 5, 2, 0, 3)
 #define SYS_SPSR_EL12			sys_reg(3, 5, 4, 0, 0)
 #define SYS_ELR_EL12			sys_reg(3, 5, 4, 0, 1)
 #define SYS_AFSR0_EL12			sys_reg(3, 5, 5, 1, 0)
 #define SYS_AFSR1_EL12			sys_reg(3, 5, 5, 1, 1)
 #define SYS_ESR_EL12			sys_reg(3, 5, 5, 2, 0)
 #define SYS_TFSR_EL12			sys_reg(3, 5, 5, 6, 0)
-#define SYS_FAR_EL12			sys_reg(3, 5, 6, 0, 0)
 #define SYS_PMSCR_EL12			sys_reg(3, 5, 9, 9, 0)
 #define SYS_MAIR_EL12			sys_reg(3, 5, 10, 2, 0)
 #define SYS_AMAIR_EL12			sys_reg(3, 5, 10, 3, 0)
 #define SYS_VBAR_EL12			sys_reg(3, 5, 12, 0, 0)
-#define SYS_CONTEXTIDR_EL12		sys_reg(3, 5, 13, 0, 1)
 #define SYS_SCXTNUM_EL12		sys_reg(3, 5, 13, 0, 7)
 #define SYS_CNTKCTL_EL12		sys_reg(3, 5, 14, 1, 0)
 #define SYS_CNTP_TVAL_EL02		sys_reg(3, 5, 14, 2, 0)
-- 
2.39.2


