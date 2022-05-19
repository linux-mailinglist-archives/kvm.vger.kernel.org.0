Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD7F52D4FE
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239209AbiESNss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239229AbiESNsA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:48:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50EBDE33E
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:47:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EED00B824AE
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:47:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D87C34117;
        Thu, 19 May 2022 13:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652968034;
        bh=RYzz4i/BOxS0OcFaoS3qfD1miQC80/tTsW0x1NowfrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N2c/oSD/VTDmAKjYyy2DWTAOgsB/u/4It/Wha8qRNDwDUsXaJayc3PyaaTuNTUuiA
         bms34Goz8eJ/lek44x643XoUqlOU1I5URcPJ7mskY6GN2/z5QTSFBthBx6mMCGCfvL
         cN8Z3QsPPKzjGcodk70XSYWwF0tnMrfBJtE6ADD/7yl596PKP1N+FDHg1bre3mZ/Do
         oBYtr6LcycuM+4mcApwNoGN8d3/P+yPfSD69YieyaJglK9jLYv7ZcetwHZlitdX6BY
         G5qrFbP2sw3Xe9KeOpkBpESviRMZisKlJGQcWIhPAbRc6cjgajMMj7V/vPvPT6rv0J
         EYbQ3h2cOwXmg==
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
Subject: [PATCH 73/89] KVM: arm64: Add HVC handling for protected guests at EL2
Date:   Thu, 19 May 2022 14:41:48 +0100
Message-Id: <20220519134204.5379-74-will@kernel.org>
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

Rather than forwarding guest hypercalls back to the host for handling,
implement some basic handling at EL2 which will later be extending to
provide additional functionality such as PSCI.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  2 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c     | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 22 ++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c       |  1 +
 4 files changed, 49 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index e772f9835a86..33d34cc639ea 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -101,4 +101,6 @@ bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
 void kvm_reset_pvm_sys_regs(struct kvm_vcpu *vcpu);
 int kvm_check_pvm_sysreg_table(void);
 
+bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code);
+
 #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 1e39dc7eab4d..26c8709f5494 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -4,6 +4,8 @@
  * Author: Andrew Scull <ascull@google.com>
  */
 
+#include <kvm/arm_hypercalls.h>
+
 #include <hyp/adjust_pc.h>
 
 #include <asm/pgtable-types.h>
@@ -42,6 +44,13 @@ static void handle_pvm_entry_wfx(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *sh
 				   KVM_ARM64_INCREMENT_PC;
 }
 
+static void handle_pvm_entry_hvc64(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *shadow_vcpu)
+{
+	u64 ret = READ_ONCE(host_vcpu->arch.ctxt.regs.regs[0]);
+
+	vcpu_set_reg(shadow_vcpu, 0, ret);
+}
+
 static void handle_pvm_entry_sys64(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *shadow_vcpu)
 {
 	unsigned long host_flags;
@@ -195,6 +204,19 @@ static void handle_pvm_exit_sys64(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *s
 	}
 }
 
+static void handle_pvm_exit_hvc64(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *shadow_vcpu)
+{
+	int i;
+
+	WRITE_ONCE(host_vcpu->arch.fault.esr_el2,
+		   shadow_vcpu->arch.fault.esr_el2);
+
+	/* Pass the hvc function id (r0) as well as any potential arguments. */
+	for (i = 0; i < 8; i++)
+		WRITE_ONCE(host_vcpu->arch.ctxt.regs.regs[i],
+			   vcpu_get_reg(shadow_vcpu, i));
+}
+
 static void handle_pvm_exit_iabt(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *shadow_vcpu)
 {
 	WRITE_ONCE(host_vcpu->arch.fault.esr_el2,
@@ -273,6 +295,7 @@ static void handle_vm_exit_abt(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *shad
 static const shadow_entry_exit_handler_fn entry_pvm_shadow_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
 	[ESR_ELx_EC_WFx]		= handle_pvm_entry_wfx,
+	[ESR_ELx_EC_HVC64]		= handle_pvm_entry_hvc64,
 	[ESR_ELx_EC_SYS64]		= handle_pvm_entry_sys64,
 	[ESR_ELx_EC_IABT_LOW]		= handle_pvm_entry_iabt,
 	[ESR_ELx_EC_DABT_LOW]		= handle_pvm_entry_dabt,
@@ -281,6 +304,7 @@ static const shadow_entry_exit_handler_fn entry_pvm_shadow_handlers[] = {
 static const shadow_entry_exit_handler_fn exit_pvm_shadow_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
 	[ESR_ELx_EC_WFx]		= handle_pvm_exit_wfx,
+	[ESR_ELx_EC_HVC64]		= handle_pvm_exit_hvc64,
 	[ESR_ELx_EC_SYS64]		= handle_pvm_exit_sys64,
 	[ESR_ELx_EC_IABT_LOW]		= handle_pvm_exit_iabt,
 	[ESR_ELx_EC_DABT_LOW]		= handle_pvm_exit_dabt,
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 9feeb0b5433a..92e60ebeced5 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -7,6 +7,8 @@
 #include <linux/kvm_host.h>
 #include <linux/mm.h>
 
+#include <kvm/arm_hypercalls.h>
+
 #include <asm/kvm_emulate.h>
 
 #include <nvhe/mem_protect.h>
@@ -797,3 +799,23 @@ int __pkvm_teardown_shadow(unsigned int shadow_handle)
 	hyp_spin_unlock(&shadow_lock);
 	return err;
 }
+
+/*
+ * Handler for protected VM HVC calls.
+ *
+ * Returns true if the hypervisor has handled the exit, and control should go
+ * back to the guest, or false if it hasn't.
+ */
+bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	u32 fn = smccc_get_function(vcpu);
+
+	switch (fn) {
+	case ARM_SMCCC_VERSION_FUNC_ID:
+		/* Nothing to be handled by the host. Go back to the guest. */
+		smccc_set_retval(vcpu, ARM_SMCCC_VERSION_1_1, 0, 0, 0);
+		return true;
+	default:
+		return false;
+	}
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 6bb979ee51cc..87338775288c 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -205,6 +205,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 
 static const exit_handler_fn pvm_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
+	[ESR_ELx_EC_HVC64]		= kvm_handle_pvm_hvc64,
 	[ESR_ELx_EC_SYS64]		= kvm_handle_pvm_sys64,
 	[ESR_ELx_EC_SVE]		= kvm_handle_pvm_restricted,
 	[ESR_ELx_EC_FP_ASIMD]		= kvm_handle_pvm_fpsimd,
-- 
2.36.1.124.g0e6072fb45-goog

