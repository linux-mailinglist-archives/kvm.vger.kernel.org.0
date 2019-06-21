Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6864E3E2
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 11:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfFUJjc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 05:39:32 -0400
Received: from foss.arm.com ([217.140.110.172]:53912 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbfFUJjc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 05:39:32 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A06B147A;
        Fri, 21 Jun 2019 02:39:31 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0660F3F246;
        Fri, 21 Jun 2019 02:39:29 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Julien Thierry <julien.thierry@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 12/59] KVM: arm64: nv: Handle trapped ERET from virtual EL2
Date:   Fri, 21 Jun 2019 10:37:56 +0100
Message-Id: <20190621093843.220980-13-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190621093843.220980-1-marc.zyngier@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christoffer Dall <christoffer.dall@arm.com>

When a guest hypervisor running virtual EL2 in EL1 executes an ERET
instruction, we will have set HCR_EL2.NV which traps ERET to EL2, so
that we can emulate the exception return in software.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/esr.h     | 3 ++-
 arch/arm64/include/asm/kvm_arm.h | 2 +-
 arch/arm64/kvm/handle_exit.c     | 8 ++++++++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 0e27fe91d5ea..f85aa269082c 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -45,7 +45,8 @@
 #define ESR_ELx_EC_SMC64	(0x17)	/* EL2 and above */
 #define ESR_ELx_EC_SYS64	(0x18)
 #define ESR_ELx_EC_SVE		(0x19)
-/* Unallocated EC: 0x1A - 0x1E */
+#define ESR_ELx_EC_ERET		(0x1A)  /* EL2 only */
+/* Unallocated EC: 0x1B - 0x1E */
 #define ESR_ELx_EC_IMP_DEF	(0x1f)	/* EL3 only */
 #define ESR_ELx_EC_IABT_LOW	(0x20)
 #define ESR_ELx_EC_IABT_CUR	(0x21)
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 9d70a5362fbb..b2e363ac624d 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -333,7 +333,7 @@
 	ECN(SP_ALIGN), ECN(FP_EXC32), ECN(FP_EXC64), ECN(SERROR), \
 	ECN(BREAKPT_LOW), ECN(BREAKPT_CUR), ECN(SOFTSTP_LOW), \
 	ECN(SOFTSTP_CUR), ECN(WATCHPT_LOW), ECN(WATCHPT_CUR), \
-	ECN(BKPT32), ECN(VECTOR32), ECN(BRK64)
+	ECN(BKPT32), ECN(VECTOR32), ECN(BRK64), ECN(ERET)
 
 #define CPACR_EL1_FPEN		(3 << 20)
 #define CPACR_EL1_TTA		(1 << 28)
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 6c0ac52b34cc..2517711f034f 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -177,6 +177,13 @@ static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	/* Until SVE is supported for guests: */
 	kvm_inject_undefined(vcpu);
+
+	return 1;
+}
+
+static int kvm_handle_eret(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	kvm_emulate_nested_eret(vcpu);
 	return 1;
 }
 
@@ -231,6 +238,7 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_SMC64]	= handle_smc,
 	[ESR_ELx_EC_SYS64]	= kvm_handle_sys_reg,
 	[ESR_ELx_EC_SVE]	= handle_sve,
+	[ESR_ELx_EC_ERET]	= kvm_handle_eret,
 	[ESR_ELx_EC_IABT_LOW]	= kvm_handle_guest_abort,
 	[ESR_ELx_EC_DABT_LOW]	= kvm_handle_guest_abort,
 	[ESR_ELx_EC_SOFTSTP_LOW]= kvm_handle_guest_debug,
-- 
2.20.1

