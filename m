Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8FA042BF73
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 14:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbhJMMGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 08:06:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230005AbhJMMGE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 08:06:04 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FBDA610E5;
        Wed, 13 Oct 2021 12:04:01 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1maczH-00GTgY-D0; Wed, 13 Oct 2021 13:03:59 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     will@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com, pbonzini@redhat.com,
        drjones@redhat.com, oupton@google.com, qperret@google.com,
        kernel-team@android.com, tabba@google.com
Subject: [PATCH v9 16/22] KVM: arm64: pkvm: Drop sysregs that should never be routed to the host
Date:   Wed, 13 Oct 2021 13:03:40 +0100
Message-Id: <20211013120346.2926621-6-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211013120346.2926621-1-maz@kernel.org>
References: <20211010145636.1950948-12-tabba@google.com>
 <20211013120346.2926621-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, will@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, pbonzini@redhat.com, drjones@redhat.com, oupton@google.com, qperret@google.com, kernel-team@android.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A bunch of system registers (most of them MM related) should never
trap to the host under any circumstance. Keep them close to our chest.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 50 ------------------------------
 1 file changed, 50 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index e2b3a9e167da..eb4ee2589316 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -371,34 +371,8 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	AARCH64(SYS_ID_AA64MMFR1_EL1),
 	AARCH64(SYS_ID_AA64MMFR2_EL1),
 
-	HOST_HANDLED(SYS_SCTLR_EL1),
-	HOST_HANDLED(SYS_ACTLR_EL1),
-	HOST_HANDLED(SYS_CPACR_EL1),
-
-	HOST_HANDLED(SYS_RGSR_EL1),
-	HOST_HANDLED(SYS_GCR_EL1),
-
 	/* Scalable Vector Registers are restricted. */
 
-	HOST_HANDLED(SYS_TTBR0_EL1),
-	HOST_HANDLED(SYS_TTBR1_EL1),
-	HOST_HANDLED(SYS_TCR_EL1),
-
-	HOST_HANDLED(SYS_APIAKEYLO_EL1),
-	HOST_HANDLED(SYS_APIAKEYHI_EL1),
-	HOST_HANDLED(SYS_APIBKEYLO_EL1),
-	HOST_HANDLED(SYS_APIBKEYHI_EL1),
-	HOST_HANDLED(SYS_APDAKEYLO_EL1),
-	HOST_HANDLED(SYS_APDAKEYHI_EL1),
-	HOST_HANDLED(SYS_APDBKEYLO_EL1),
-	HOST_HANDLED(SYS_APDBKEYHI_EL1),
-	HOST_HANDLED(SYS_APGAKEYLO_EL1),
-	HOST_HANDLED(SYS_APGAKEYHI_EL1),
-
-	HOST_HANDLED(SYS_AFSR0_EL1),
-	HOST_HANDLED(SYS_AFSR1_EL1),
-	HOST_HANDLED(SYS_ESR_EL1),
-
 	RAZ_WI(SYS_ERRIDR_EL1),
 	RAZ_WI(SYS_ERRSELR_EL1),
 	RAZ_WI(SYS_ERXFR_EL1),
@@ -408,31 +382,12 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	RAZ_WI(SYS_ERXMISC0_EL1),
 	RAZ_WI(SYS_ERXMISC1_EL1),
 
-	HOST_HANDLED(SYS_TFSR_EL1),
-	HOST_HANDLED(SYS_TFSRE0_EL1),
-
-	HOST_HANDLED(SYS_FAR_EL1),
-	HOST_HANDLED(SYS_PAR_EL1),
-
 	/* Performance Monitoring Registers are restricted. */
 
-	HOST_HANDLED(SYS_MAIR_EL1),
-	HOST_HANDLED(SYS_AMAIR_EL1),
-
 	/* Limited Ordering Regions Registers are restricted. */
 
-	HOST_HANDLED(SYS_VBAR_EL1),
-	HOST_HANDLED(SYS_DISR_EL1),
-
 	/* GIC CPU Interface registers are restricted. */
 
-	HOST_HANDLED(SYS_CONTEXTIDR_EL1),
-	HOST_HANDLED(SYS_TPIDR_EL1),
-
-	HOST_HANDLED(SYS_SCXTNUM_EL1),
-
-	HOST_HANDLED(SYS_CNTKCTL_EL1),
-
 	HOST_HANDLED(SYS_CCSIDR_EL1),
 	HOST_HANDLED(SYS_CLIDR_EL1),
 	HOST_HANDLED(SYS_CSSELR_EL1),
@@ -440,11 +395,6 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 
 	/* Performance Monitoring Registers are restricted. */
 
-	HOST_HANDLED(SYS_TPIDR_EL0),
-	HOST_HANDLED(SYS_TPIDRRO_EL0),
-
-	HOST_HANDLED(SYS_SCXTNUM_EL0),
-
 	/* Activity Monitoring Registers are restricted. */
 
 	HOST_HANDLED(SYS_CNTP_TVAL_EL0),
-- 
2.30.2

