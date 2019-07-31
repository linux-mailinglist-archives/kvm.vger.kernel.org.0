Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 632487CAA5
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 19:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbfGaRhP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 13:37:15 -0400
Received: from foss.arm.com ([217.140.110.172]:52532 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729208AbfGaRhM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 13:37:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5569B15AB;
        Wed, 31 Jul 2019 10:37:12 -0700 (PDT)
Received: from big-swifty.lan (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A5A813F71F;
        Wed, 31 Jul 2019 10:37:09 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        Andrew Murray <andrew.murray@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 4/5] KVM: arm64: Update kvm_arm_exception_class and esr_class_str for new EC
Date:   Wed, 31 Jul 2019 18:36:49 +0100
Message-Id: <20190731173650.12627-5-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190731173650.12627-1-maz@kernel.org>
References: <20190731173650.12627-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zenghui Yu <yuzenghui@huawei.com>

We've added two ESR exception classes for new ARM hardware extensions:
ESR_ELx_EC_PAC and ESR_ELx_EC_SVE, but failed to update the strings
used in tracing and other debug.

Let's update "kvm_arm_exception_class" for these two EC, which the
new EC will be visible to user-space via kvm_exit trace events
Also update to "esr_class_str" for ESR_ELx_EC_PAC, by which we can
get more readable debug info.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h | 7 ++++---
 arch/arm64/kernel/traps.c        | 1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index a8b205e5c4a8..ddf9d762ac62 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -316,9 +316,10 @@
 
 #define kvm_arm_exception_class \
 	ECN(UNKNOWN), ECN(WFx), ECN(CP15_32), ECN(CP15_64), ECN(CP14_MR), \
-	ECN(CP14_LS), ECN(FP_ASIMD), ECN(CP10_ID), ECN(CP14_64), ECN(SVC64), \
-	ECN(HVC64), ECN(SMC64), ECN(SYS64), ECN(IMP_DEF), ECN(IABT_LOW), \
-	ECN(IABT_CUR), ECN(PC_ALIGN), ECN(DABT_LOW), ECN(DABT_CUR), \
+	ECN(CP14_LS), ECN(FP_ASIMD), ECN(CP10_ID), ECN(PAC), ECN(CP14_64), \
+	ECN(SVC64), ECN(HVC64), ECN(SMC64), ECN(SYS64), ECN(SVE), \
+	ECN(IMP_DEF), ECN(IABT_LOW), ECN(IABT_CUR), \
+	ECN(PC_ALIGN), ECN(DABT_LOW), ECN(DABT_CUR), \
 	ECN(SP_ALIGN), ECN(FP_EXC32), ECN(FP_EXC64), ECN(SERROR), \
 	ECN(BREAKPT_LOW), ECN(BREAKPT_CUR), ECN(SOFTSTP_LOW), \
 	ECN(SOFTSTP_CUR), ECN(WATCHPT_LOW), ECN(WATCHPT_CUR), \
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 8c03456dade6..969e1565152b 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -734,6 +734,7 @@ static const char *esr_class_str[] = {
 	[ESR_ELx_EC_CP14_LS]		= "CP14 LDC/STC",
 	[ESR_ELx_EC_FP_ASIMD]		= "ASIMD",
 	[ESR_ELx_EC_CP10_ID]		= "CP10 MRC/VMRS",
+	[ESR_ELx_EC_PAC]		= "PAC",
 	[ESR_ELx_EC_CP14_64]		= "CP14 MCRR/MRRC",
 	[ESR_ELx_EC_ILL]		= "PSTATE.IL",
 	[ESR_ELx_EC_SVC32]		= "SVC (AArch32)",
-- 
2.20.1

