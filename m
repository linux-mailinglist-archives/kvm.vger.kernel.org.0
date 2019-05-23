Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1EB327AB0
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 12:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730588AbfEWKfg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 06:35:36 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:43072 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730594AbfEWKff (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 06:35:35 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 04C95341;
        Thu, 23 May 2019 03:35:35 -0700 (PDT)
Received: from usa.arm.com (e107155-lin.cambridge.arm.com [10.1.196.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E58CD3F718;
        Thu, 23 May 2019 03:35:32 -0700 (PDT)
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH v2 06/15] arm64: KVM/VHE: enable the use PMSCR_EL12 on VHE systems
Date:   Thu, 23 May 2019 11:34:53 +0100
Message-Id: <20190523103502.25925-7-sudeep.holla@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190523103502.25925-1-sudeep.holla@arm.com>
References: <20190523103502.25925-1-sudeep.holla@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, we are just using PMSCR_EL1 in the host for non VHE systems.
We already have the {read,write}_sysreg_el*() accessors for accessing
particular ELs' sysregs in the presence of VHE.

Lets just define PMSCR_EL12 and start making use of it here which will
access the right register on both VHE and non VHE systems. This change
is required to add SPE guest support on VHE systems.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h | 1 +
 arch/arm64/kvm/hyp/debug-sr.c    | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index f61378b77c9f..782955db61dd 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -103,6 +103,7 @@
 #define afsr1_EL12              sys_reg(3, 5, 5, 1, 1)
 #define esr_EL12                sys_reg(3, 5, 5, 2, 0)
 #define far_EL12                sys_reg(3, 5, 6, 0, 0)
+#define SYS_PMSCR_EL12          sys_reg(3, 5, 9, 9, 0)
 #define mair_EL12               sys_reg(3, 5, 10, 2, 0)
 #define amair_EL12              sys_reg(3, 5, 10, 3, 0)
 #define vbar_EL12               sys_reg(3, 5, 12, 0, 0)
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index 50009766e5e5..fa51236ebcb3 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -89,8 +89,8 @@ static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
 		return;
 
 	/* Yes; save the control register and disable data generation */
-	*pmscr_el1 = read_sysreg_s(SYS_PMSCR_EL1);
-	write_sysreg_s(0, SYS_PMSCR_EL1);
+	*pmscr_el1 = read_sysreg_el1_s(SYS_PMSCR);
+	write_sysreg_el1_s(0, SYS_PMSCR);
 	isb();
 
 	/* Now drain all buffered data to memory */
@@ -107,7 +107,7 @@ static void __hyp_text __debug_restore_spe_nvhe(u64 pmscr_el1)
 	isb();
 
 	/* Re-enable data generation */
-	write_sysreg_s(pmscr_el1, SYS_PMSCR_EL1);
+	write_sysreg_el1_s(pmscr_el1, SYS_PMSCR);
 }
 
 static void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
-- 
2.17.1

