Return-Path: <kvm+bounces-20473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 829E1916888
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 15:01:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 239C51F228BF
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 13:01:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB8F515FA67;
	Tue, 25 Jun 2024 13:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GptRfIhf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD5F158A26;
	Tue, 25 Jun 2024 13:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719320450; cv=none; b=Uy4gP+rhqDk7SA+LhLgsyL8xy/HI7wfGxA3RZJ/toUylH0jokT37Vq72o5OE1uHWAhEA1KsmlqeKrvPBlilvYoRCWpanJhFeOl24+qOZ6wm+Ynf8nZYzYwG2ZWlq3yvMHFS6cvCFZ9QoolX4SsvgR0f66hbSHGHEIvrzhRZL8Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719320450; c=relaxed/simple;
	bh=HKHiosdszVDPIXaLiJmlPJYZG0rJiJAcy+UXCae4Ugw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P3+N/y063CcCcQrwr1OLHy4jRzb4HqKRIjnPmWt2rsQCK95UmmFWFOZW3DOuIUdL/QGqTyzGN2+P5bHgjFaMuQq8L5EcFans6MM2jBhz9kxRf83/r8ElS1fJWU5/vxhRJiguBQvO832scuncJhNjSMJBsndF8C0lgYlzQlveKp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GptRfIhf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F38C4AF0B;
	Tue, 25 Jun 2024 13:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719320449;
	bh=HKHiosdszVDPIXaLiJmlPJYZG0rJiJAcy+UXCae4Ugw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GptRfIhfumlCyM41wfNl49CuYNakMFkJCwBK72Y++mc/XbNcYsTfask/ULU19Dv0L
	 16/V95qE4UqCXt/eQJOzdXoBevKPgp+lS77UmedpkIk17Eca9zpQg3wIXDRL2G9xOX
	 dQpS+Anb+d0ewFsPBK5x4AcSIooH2HkTv9mWbzaFGAVx+A3FzNdhP8SDqEQ1nmH2p/
	 XCJrA54gSDamxl8a/SPWBlZeUyQP7h5rDaqPUoJpm613Sw/imQNazL5BqnjyMXFY0V
	 uESzIF7zBCkJP22KWvwm35BLIbyfrv6H5Aph2RwNwLyyfqpH2TEx1Lp7/L13x8FGaf
	 eF+lCTEsVwj5Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sM5mx-0079X4-UE;
	Tue, 25 Jun 2024 14:00:47 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 4/5] KVM: arm64: Make PIR{,E0}_EL1 save/restore conditional on FEAT_TCRX
Date: Tue, 25 Jun 2024 14:00:41 +0100
Message-Id: <20240625130042.259175-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240625130042.259175-1-maz@kernel.org>
References: <20240625130042.259175-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As per the architecture, if FEAT_S1PIE is implemented, then FEAT_TCRX
must be implemented as well.

Take advantage of this to avoid checking for S1PIE when TCRX isn't
implemented.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 24 +++++++++++++---------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index ea2aeeff61db7..4c0fdabaf8aec 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -73,8 +73,14 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 	ctxt_sys_reg(ctxt, TTBR0_EL1)	= read_sysreg_el1(SYS_TTBR0);
 	ctxt_sys_reg(ctxt, TTBR1_EL1)	= read_sysreg_el1(SYS_TTBR1);
 	ctxt_sys_reg(ctxt, TCR_EL1)	= read_sysreg_el1(SYS_TCR);
-	if (ctxt_has_tcrx(ctxt))
+	if (ctxt_has_tcrx(ctxt)) {
 		ctxt_sys_reg(ctxt, TCR2_EL1)	= read_sysreg_el1(SYS_TCR2);
+
+		if (ctxt_has_s1pie(ctxt)) {
+			ctxt_sys_reg(ctxt, PIR_EL1)	= read_sysreg_el1(SYS_PIR);
+			ctxt_sys_reg(ctxt, PIRE0_EL1)	= read_sysreg_el1(SYS_PIRE0);
+		}
+	}
 	ctxt_sys_reg(ctxt, ESR_EL1)	= read_sysreg_el1(SYS_ESR);
 	ctxt_sys_reg(ctxt, AFSR0_EL1)	= read_sysreg_el1(SYS_AFSR0);
 	ctxt_sys_reg(ctxt, AFSR1_EL1)	= read_sysreg_el1(SYS_AFSR1);
@@ -84,10 +90,6 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 	ctxt_sys_reg(ctxt, CONTEXTIDR_EL1) = read_sysreg_el1(SYS_CONTEXTIDR);
 	ctxt_sys_reg(ctxt, AMAIR_EL1)	= read_sysreg_el1(SYS_AMAIR);
 	ctxt_sys_reg(ctxt, CNTKCTL_EL1)	= read_sysreg_el1(SYS_CNTKCTL);
-	if (ctxt_has_s1pie(ctxt)) {
-		ctxt_sys_reg(ctxt, PIR_EL1)	= read_sysreg_el1(SYS_PIR);
-		ctxt_sys_reg(ctxt, PIRE0_EL1)	= read_sysreg_el1(SYS_PIRE0);
-	}
 	ctxt_sys_reg(ctxt, PAR_EL1)	= read_sysreg_par();
 	ctxt_sys_reg(ctxt, TPIDR_EL1)	= read_sysreg(tpidr_el1);
 
@@ -149,8 +151,14 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 	write_sysreg_el1(ctxt_sys_reg(ctxt, CPACR_EL1),	SYS_CPACR);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR0_EL1),	SYS_TTBR0);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR1_EL1),	SYS_TTBR1);
-	if (ctxt_has_tcrx(ctxt))
+	if (ctxt_has_tcrx(ctxt)) {
 		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR2_EL1),	SYS_TCR2);
+
+		if (ctxt_has_s1pie(ctxt)) {
+			write_sysreg_el1(ctxt_sys_reg(ctxt, PIR_EL1),	SYS_PIR);
+			write_sysreg_el1(ctxt_sys_reg(ctxt, PIRE0_EL1),	SYS_PIRE0);
+		}
+	}
 	write_sysreg_el1(ctxt_sys_reg(ctxt, ESR_EL1),	SYS_ESR);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, AFSR0_EL1),	SYS_AFSR0);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, AFSR1_EL1),	SYS_AFSR1);
@@ -160,10 +168,6 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 	write_sysreg_el1(ctxt_sys_reg(ctxt, CONTEXTIDR_EL1), SYS_CONTEXTIDR);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, AMAIR_EL1),	SYS_AMAIR);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, CNTKCTL_EL1), SYS_CNTKCTL);
-	if (ctxt_has_s1pie(ctxt)) {
-		write_sysreg_el1(ctxt_sys_reg(ctxt, PIR_EL1),	SYS_PIR);
-		write_sysreg_el1(ctxt_sys_reg(ctxt, PIRE0_EL1),	SYS_PIRE0);
-	}
 	write_sysreg(ctxt_sys_reg(ctxt, PAR_EL1),	par_el1);
 	write_sysreg(ctxt_sys_reg(ctxt, TPIDR_EL1),	tpidr_el1);
 
-- 
2.39.2


