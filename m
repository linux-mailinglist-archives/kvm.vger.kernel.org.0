Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 691274E3F6
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 11:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfFUJjq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 05:39:46 -0400
Received: from foss.arm.com ([217.140.110.172]:54030 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726718AbfFUJjq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 05:39:46 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 752DD1478;
        Fri, 21 Jun 2019 02:39:45 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 218B43F246;
        Fri, 21 Jun 2019 02:39:44 -0700 (PDT)
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
Subject: [PATCH 21/59] KVM: arm64: nv: Set a handler for the system instruction traps
Date:   Fri, 21 Jun 2019 10:38:05 +0100
Message-Id: <20190621093843.220980-22-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190621093843.220980-1-marc.zyngier@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jintack Lim <jintack.lim@linaro.org>

When HCR.NV bit is set, execution of the EL2 translation regime address
aranslation instructions and TLB maintenance instructions are trapped to
EL2. In addition, execution of the EL1 translation regime address
aranslation instructions and TLB maintenance instructions that are only
accessible from EL2 and above are trapped to EL2. In these cases,
ESR_EL2.EC will be set to 0x18.

Change the existing handler to handle those system instructions as well
as MRS/MSR instructions.  Emulation of each system instructions will be
done in separate patches.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_coproc.h |  2 +-
 arch/arm64/kvm/handle_exit.c        |  2 +-
 arch/arm64/kvm/sys_regs.c           | 53 +++++++++++++++++++++++++----
 arch/arm64/kvm/trace.h              |  2 +-
 4 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_coproc.h b/arch/arm64/include/asm/kvm_coproc.h
index 0b52377a6c11..1b3d21bd8adb 100644
--- a/arch/arm64/include/asm/kvm_coproc.h
+++ b/arch/arm64/include/asm/kvm_coproc.h
@@ -43,7 +43,7 @@ int kvm_handle_cp14_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_handle_cp14_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
-int kvm_handle_sys_reg(struct kvm_vcpu *vcpu, struct kvm_run *run);
+int kvm_handle_sys(struct kvm_vcpu *vcpu, struct kvm_run *run);
 
 #define kvm_coproc_table_init kvm_sys_reg_table_init
 void kvm_sys_reg_table_init(void);
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 2517711f034f..e662f23b63a1 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -236,7 +236,7 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_SMC32]	= handle_smc,
 	[ESR_ELx_EC_HVC64]	= handle_hvc,
 	[ESR_ELx_EC_SMC64]	= handle_smc,
-	[ESR_ELx_EC_SYS64]	= kvm_handle_sys_reg,
+	[ESR_ELx_EC_SYS64]	= kvm_handle_sys,
 	[ESR_ELx_EC_SVE]	= handle_sve,
 	[ESR_ELx_EC_ERET]	= kvm_handle_eret,
 	[ESR_ELx_EC_IABT_LOW]	= kvm_handle_guest_abort,
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1d1312425cf2..e711dde4511c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2597,6 +2597,40 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
+static int emulate_tlbi(struct kvm_vcpu *vcpu,
+			     struct sys_reg_params *params)
+{
+	/* TODO: support tlbi instruction emulation*/
+	kvm_inject_undefined(vcpu);
+	return 1;
+}
+
+static int emulate_at(struct kvm_vcpu *vcpu,
+			     struct sys_reg_params *params)
+{
+	/* TODO: support address translation instruction emulation */
+	kvm_inject_undefined(vcpu);
+	return 1;
+}
+
+static int emulate_sys_instr(struct kvm_vcpu *vcpu,
+			     struct sys_reg_params *params)
+{
+	int ret = 0;
+
+	/* TLB maintenance instructions*/
+	if (params->CRn == 0b1000)
+		ret = emulate_tlbi(vcpu, params);
+	/* Address Translation instructions */
+	else if (params->CRn == 0b0111 && params->CRm == 0b1000)
+		ret = emulate_at(vcpu, params);
+
+	if (ret)
+		kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+
+	return ret;
+}
+
 static void reset_sys_reg_descs(struct kvm_vcpu *vcpu,
 			      const struct sys_reg_desc *table, size_t num)
 {
@@ -2608,18 +2642,19 @@ static void reset_sys_reg_descs(struct kvm_vcpu *vcpu,
 }
 
 /**
- * kvm_handle_sys_reg -- handles a mrs/msr trap on a guest sys_reg access
+ * kvm_handle_sys-- handles a system instruction or mrs/msr instruction trap
+		    on a guest execution
  * @vcpu: The VCPU pointer
  * @run:  The kvm_run struct
  */
-int kvm_handle_sys_reg(struct kvm_vcpu *vcpu, struct kvm_run *run)
+int kvm_handle_sys(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	struct sys_reg_params params;
 	unsigned long esr = kvm_vcpu_get_hsr(vcpu);
 	int Rt = kvm_vcpu_sys_get_rt(vcpu);
 	int ret;
 
-	trace_kvm_handle_sys_reg(esr);
+	trace_kvm_handle_sys(esr);
 
 	params.is_aarch32 = false;
 	params.is_32bit = false;
@@ -2631,10 +2666,16 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	params.regval = vcpu_get_reg(vcpu, Rt);
 	params.is_write = !(esr & 1);
 
-	ret = emulate_sys_reg(vcpu, &params);
+	if (params.Op0 == 1) {
+		/* System instructions */
+		ret = emulate_sys_instr(vcpu, &params);
+	} else {
+		/* MRS/MSR instructions */
+		ret = emulate_sys_reg(vcpu, &params);
+		if (!params.is_write)
+			vcpu_set_reg(vcpu, Rt, params.regval);
+	}
 
-	if (!params.is_write)
-		vcpu_set_reg(vcpu, Rt, params.regval);
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/trace.h b/arch/arm64/kvm/trace.h
index 797a705bb644..2a6a54ef3824 100644
--- a/arch/arm64/kvm/trace.h
+++ b/arch/arm64/kvm/trace.h
@@ -138,7 +138,7 @@ TRACE_EVENT(trap_reg,
 	TP_printk("%s %s reg %d (0x%08llx)", __entry->fn,  __entry->is_write?"write to":"read from", __entry->reg, __entry->write_value)
 );
 
-TRACE_EVENT(kvm_handle_sys_reg,
+TRACE_EVENT(kvm_handle_sys,
 	TP_PROTO(unsigned long hsr),
 	TP_ARGS(hsr),
 
-- 
2.20.1

