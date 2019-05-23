Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6011B27ACC
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 12:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730365AbfEWKfZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 06:35:25 -0400
Received: from foss.arm.com ([217.140.101.70]:43010 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727466AbfEWKfX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 06:35:23 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4102DA78;
        Thu, 23 May 2019 03:35:23 -0700 (PDT)
Received: from usa.arm.com (e107155-lin.cambridge.arm.com [10.1.196.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2CDA03F718;
        Thu, 23 May 2019 03:35:21 -0700 (PDT)
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
Subject: [PATCH v2 01/15] KVM: arm64: add {read,write}_sysreg_elx_s versions for new registers
Date:   Thu, 23 May 2019 11:34:48 +0100
Message-Id: <20190523103502.25925-2-sudeep.holla@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190523103502.25925-1-sudeep.holla@arm.com>
References: <20190523103502.25925-1-sudeep.holla@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM provides {read,write}_sysreg_el1() to write to ${REG}_EL1 when we
really want to read/write to the EL1 register without any VHE register
redirection.

SPE registers are not supported by many versions of GAS. For this reason
we mostly use mrs_s macro which takes sys_reg() representation.

However these SPE registers using sys_reg representation doesn't work
well with existing {read,write}_sysreg_el1 macros. We need to add
{read,write}_sysreg_el1_s versions so cope up with them.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 09fe8bd15f6e..f61378b77c9f 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -35,6 +35,15 @@
 			     : "=r" (reg));				\
 		reg;							\
 	})
+#define read_sysreg_elx_s(r,nvh,vh)					\
+	({								\
+		u64 reg;						\
+		asm volatile(ALTERNATIVE(__mrs_s("%0", r##nvh),		\
+					 __mrs_s("%0", r##vh),		\
+					 ARM64_HAS_VIRT_HOST_EXTN)	\
+			     : "=r" (reg));				\
+		reg;							\
+	})
 
 #define write_sysreg_elx(v,r,nvh,vh)					\
 	do {								\
@@ -44,6 +53,14 @@
 					 ARM64_HAS_VIRT_HOST_EXTN)	\
 					 : : "rZ" (__val));		\
 	} while (0)
+#define write_sysreg_elx_s(v,r,nvh,vh)					\
+	do {								\
+		u64 __val = (u64)(v);					\
+		asm volatile(ALTERNATIVE(__msr_s(r##nvh, "%x0"),	\
+					 __msr_s(r##vh, "%x0"),		\
+					 ARM64_HAS_VIRT_HOST_EXTN)	\
+					 : : "rZ" (__val));		\
+	} while (0)
 
 /*
  * Unified accessors for registers that have a different encoding
@@ -72,7 +89,9 @@
 #define read_sysreg_el0(r)	read_sysreg_elx(r, _EL0, _EL02)
 #define write_sysreg_el0(v,r)	write_sysreg_elx(v, r, _EL0, _EL02)
 #define read_sysreg_el1(r)	read_sysreg_elx(r, _EL1, _EL12)
+#define read_sysreg_el1_s(r)	read_sysreg_elx_s(r, _EL1, _EL12)
 #define write_sysreg_el1(v,r)	write_sysreg_elx(v, r, _EL1, _EL12)
+#define write_sysreg_el1_s(v,r)	write_sysreg_elx_s(v, r, _EL1, _EL12)
 
 /* The VHE specific system registers and their encoding */
 #define sctlr_EL12              sys_reg(3, 5, 1, 0, 0)
-- 
2.17.1

