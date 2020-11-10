Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0482AD865
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 15:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730945AbgKJONS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 09:13:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:34364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730200AbgKJONR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 09:13:17 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBDF820825;
        Tue, 10 Nov 2020 14:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605017596;
        bh=AaEmnUUc/m5rPRgMVUlzTP7zCIYmOa/6NPk0n9WQRZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O98f5jh1Su6JXXdAGghUyHG0fOZH1I2o62/Xm2L1HPFoGa9kSv62a5uD+DYYFn73v
         z2TLFhkZ1qfHgsXRJeBcuyQS3ljXJtj8fUTLJ4k0GZbncv8RIz/MzeX+mdhoQJmd2y
         jGIvZ+gxhqVvmzV9V18jLh6FgoNOXZRa/avwPq+4=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kcUOY-009T8Q-29; Tue, 10 Nov 2020 14:13:14 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     Peng Liang <liangpeng10@huawei.com>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH v2 3/3] KVM: arm64: Handle SCXTNUM_ELx traps
Date:   Tue, 10 Nov 2020 14:13:08 +0000
Message-Id: <20201110141308.451654-4-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201110141308.451654-1-maz@kernel.org>
References: <20201110141308.451654-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, liangpeng10@huawei.com, will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As the kernel never sets HCR_EL2.EnSCXT, accesses to SCXTNUM_ELx
will trap to EL2. Let's handle that as gracefully as possible
by injecting an UNDEF exception into the guest. This is consistent
with the guest's view of ID_AA64PFR0_EL1.CSV2 being at most 1.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 4 ++++
 arch/arm64/kvm/sys_regs.c       | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 174817ba119c..e2ef4c2edf06 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -372,6 +372,8 @@
 #define SYS_CONTEXTIDR_EL1		sys_reg(3, 0, 13, 0, 1)
 #define SYS_TPIDR_EL1			sys_reg(3, 0, 13, 0, 4)
 
+#define SYS_SCXTNUM_EL1			sys_reg(3, 0, 13, 0, 7)
+
 #define SYS_CNTKCTL_EL1			sys_reg(3, 0, 14, 1, 0)
 
 #define SYS_CCSIDR_EL1			sys_reg(3, 1, 0, 0, 0)
@@ -404,6 +406,8 @@
 #define SYS_TPIDR_EL0			sys_reg(3, 3, 13, 0, 2)
 #define SYS_TPIDRRO_EL0			sys_reg(3, 3, 13, 0, 3)
 
+#define SYS_SCXTNUM_EL0			sys_reg(3, 3, 13, 0, 7)
+
 /* Definitions for system register interface to AMU for ARMv8.4 onwards */
 #define SYS_AM_EL0(crm, op2)		sys_reg(3, 3, 13, (crm), (op2))
 #define SYS_AMCR_EL0			SYS_AM_EL0(2, 0)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6155285b2f9b..ea1ef71c1394 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1640,6 +1640,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CONTEXTIDR_EL1), access_vm_reg, reset_val, CONTEXTIDR_EL1, 0 },
 	{ SYS_DESC(SYS_TPIDR_EL1), NULL, reset_unknown, TPIDR_EL1 },
 
+	{ SYS_DESC(SYS_SCXTNUM_EL1), undef_access },
+
 	{ SYS_DESC(SYS_CNTKCTL_EL1), NULL, reset_val, CNTKCTL_EL1, 0},
 
 	{ SYS_DESC(SYS_CCSIDR_EL1), access_ccsidr },
@@ -1668,6 +1670,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_TPIDR_EL0), NULL, reset_unknown, TPIDR_EL0 },
 	{ SYS_DESC(SYS_TPIDRRO_EL0), NULL, reset_unknown, TPIDRRO_EL0 },
 
+	{ SYS_DESC(SYS_SCXTNUM_EL0), undef_access },
+
 	{ SYS_DESC(SYS_AMCR_EL0), undef_access },
 	{ SYS_DESC(SYS_AMCFGR_EL0), undef_access },
 	{ SYS_DESC(SYS_AMCGCR_EL0), undef_access },
-- 
2.28.0

