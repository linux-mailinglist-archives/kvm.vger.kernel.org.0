Return-Path: <kvm+bounces-45622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BB91AACB4B
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:45:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 401FD1C075C0
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BCB628643C;
	Tue,  6 May 2025 16:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PwXNqcln"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9526E2857E6;
	Tue,  6 May 2025 16:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549850; cv=none; b=LTLOwGm9zwNrZ70LdHO8arKTJO2ewckwSXl3LYOY4tk3oy2brf5bpm70w2J3D3SpJSHNlkxXW8WGYQH5veexcvjEnRqI6s7cKND+JGOWmYpe4qy3YlUSqpwRh+WSbm6iheSvtYcat68YrVEGwkLBNacG1sx8pw2IiBBnG1V9YWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549850; c=relaxed/simple;
	bh=BBAhuhtwHnlUbcc2gLXd+VmoCR220Lc1P5/EA9ClEZw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=K+vp+QUQkI4uY7PvmnquD5U7RfzCvQ4QTPL0SlfX+OOJ0Tv8iCcdy/g3TJrWv+LDrRb5cNaA3ds/kS/jroY5ZiZjhxtWBsti2eNZ1M74YFCDVDpWlJpH2z+EKyOj/u0UaaZKVarz8lYxk+4Mc06IW9NTUK8zymvXADbDwmhDjFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PwXNqcln; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741B7C4CEF4;
	Tue,  6 May 2025 16:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746549850;
	bh=BBAhuhtwHnlUbcc2gLXd+VmoCR220Lc1P5/EA9ClEZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwXNqclneWvm2NjITHwqoYs/K7YxIaxNiRZ8oZZQM/WYZljhK0+Z2A1vO7swd8SDq
	 BrVJMfuM32awUeAHHfeSkxcB3mGo21pznfu5/XAQP9O23G77zqbeypTxBhVSrShFHN
	 vhvoMFenOp6IwaCTDEHpTmsQnQq/rqS+CYgXZK2zqJJfZMqvXG4Kaz5LenplIHtlcd
	 f/qS5+YBDJFxjofdBGXgq8FLKF5K5LwvqP6bAVdp+JzVhbenKTnJDbmj21Fp6YmuLM
	 ifn/T/rA3Azd1UuABtMDzKGktdqs293KShjRmIqMr4CV2Rp6vfPTpxbe85UCLRzXB7
	 04pVsblzbLqMg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCLOq-00CJkN-Oh;
	Tue, 06 May 2025 17:44:08 +0100
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
	Catalin Marinas <catalin.marinas@arm.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v4 12/43] arm64: Remove duplicated sysreg encodings
Date: Tue,  6 May 2025 17:43:17 +0100
Message-Id: <20250506164348.346001-13-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250506164348.346001-1-maz@kernel.org>
References: <20250506164348.346001-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, ben.horgan@arm.com
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


