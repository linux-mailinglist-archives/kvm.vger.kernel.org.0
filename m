Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5E452D4DF
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbiESNrm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239083AbiESNqx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:46:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1D536324
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:46:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 751F0B824B0
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C082FC34116;
        Thu, 19 May 2022 13:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967987;
        bh=JS4X8UXFmd8TMeGhdyRSyVoZggCXiskjb7wg/m/cY/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qmX602WiwPws7twhIK8JNNaBUANeZSnlzbsXwkwyEb8+oOrI18ctAaTLp1TVOxuMd
         ZAi/HVCQqRf3kUNCXvHTyo+FQnmTC371TiBt8nF8Vy+Zs1/pkNqkCpPMihwkEc7Niv
         Bqb3VV2iimil/mttC7u9JJtsp9fTliYEEoMuKyZZFbThhsReQJrX1jDVln4gqoOSPE
         muCZ76Cthq9T+sA/ymDx3ZL0FrhUZmBF48gZn+ruAs/GstotTRvTV0aG9WK736Z1O4
         /Z9PIJHw4W/ZMExV7C18GZ6jfl/k4jEL2wB8tK55BOR9L5dNMfKLnB0x6wmXSCkPiU
         m4rd18YhIsRlA==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 61/89] KVM: arm64: Reset sysregs for protected VMs
Date:   Thu, 19 May 2022 14:41:36 +0100
Message-Id: <20220519134204.5379-62-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Fuad Tabba <tabba@google.com>

Create a framework for resetting protected VM system registers to
their architecturally defined reset values.

No functional change intended as these are not hooked in yet.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  1 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c     | 84 +++++++++++++++++++++++++-
 2 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index d070400b5616..e772f9835a86 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -98,6 +98,7 @@ struct kvm_shadow_vcpu_state *pkvm_loaded_shadow_vcpu_state(void);
 u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
 bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
 bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
+void kvm_reset_pvm_sys_regs(struct kvm_vcpu *vcpu);
 int kvm_check_pvm_sysreg_table(void);
 
 #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index e732826f9624..aeea565d84b8 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -470,8 +470,85 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	/* Performance Monitoring Registers are restricted. */
 };
 
+/* A structure to track reset values for system registers in protected vcpus. */
+struct sys_reg_desc_reset {
+	/* Index into sys_reg[]. */
+	int reg;
+
+	/* Reset function. */
+	void (*reset)(struct kvm_vcpu *, const struct sys_reg_desc_reset *);
+
+	/* Reset value. */
+	u64 value;
+};
+
+static void reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc_reset *r)
+{
+	__vcpu_sys_reg(vcpu, r->reg) = read_sysreg(actlr_el1);
+}
+
+static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc_reset *r)
+{
+	__vcpu_sys_reg(vcpu, r->reg) = read_sysreg(amair_el1);
+}
+
+static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc_reset *r)
+{
+	__vcpu_sys_reg(vcpu, r->reg) = calculate_mpidr(vcpu);
+}
+
+static void reset_value(struct kvm_vcpu *vcpu, const struct sys_reg_desc_reset *r)
+{
+	__vcpu_sys_reg(vcpu, r->reg) = r->value;
+}
+
+/* Specify the register's reset value. */
+#define RESET_VAL(REG, RESET_VAL) {  REG, reset_value, RESET_VAL }
+
+/* Specify a function that calculates the register's reset value. */
+#define RESET_FUNC(REG, RESET_FUNC) {  REG, RESET_FUNC, 0 }
+
+/*
+ * Architected system registers reset values for Protected VMs.
+ * Important: Must be sorted ascending by REG (index into sys_reg[])
+ */
+static const struct sys_reg_desc_reset pvm_sys_reg_reset_vals[] = {
+	RESET_FUNC(MPIDR_EL1, reset_mpidr),
+	RESET_VAL(SCTLR_EL1, 0x00C50078),
+	RESET_FUNC(ACTLR_EL1, reset_actlr),
+	RESET_VAL(CPACR_EL1, 0),
+	RESET_VAL(ZCR_EL1, 0),
+	RESET_VAL(TCR_EL1, 0),
+	RESET_VAL(VBAR_EL1, 0),
+	RESET_VAL(CONTEXTIDR_EL1, 0),
+	RESET_FUNC(AMAIR_EL1, reset_amair_el1),
+	RESET_VAL(CNTKCTL_EL1, 0),
+	RESET_VAL(MDSCR_EL1, 0),
+	RESET_VAL(MDCCINT_EL1, 0),
+	RESET_VAL(DISR_EL1, 0),
+	RESET_VAL(PMCCFILTR_EL0, 0),
+	RESET_VAL(PMUSERENR_EL0, 0),
+};
+
 /*
- * Checks that the sysreg table is unique and in-order.
+ * Sets system registers to reset value
+ *
+ * This function finds the right entry and sets the registers on the protected
+ * vcpu to their architecturally defined reset values.
+ */
+void kvm_reset_pvm_sys_regs(struct kvm_vcpu *vcpu)
+{
+	unsigned long i;
+
+	for (i = 0; i < ARRAY_SIZE(pvm_sys_reg_reset_vals); i++) {
+		const struct sys_reg_desc_reset *r = &pvm_sys_reg_reset_vals[i];
+
+		r->reset(vcpu, r);
+	}
+}
+
+/*
+ * Checks that the sysreg tables are unique and in-order.
  *
  * Returns 0 if the table is consistent, or 1 otherwise.
  */
@@ -484,6 +561,11 @@ int kvm_check_pvm_sysreg_table(void)
 			return 1;
 	}
 
+	for (i = 1; i < ARRAY_SIZE(pvm_sys_reg_reset_vals); i++) {
+		if (pvm_sys_reg_reset_vals[i-1].reg >= pvm_sys_reg_reset_vals[i].reg)
+			return 1;
+	}
+
 	return 0;
 }
 
-- 
2.36.1.124.g0e6072fb45-goog

