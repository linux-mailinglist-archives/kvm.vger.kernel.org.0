Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5245E2989F6
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 11:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1768496AbgJZJvq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 05:51:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1737079AbgJZJvf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 05:51:35 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE43C22409;
        Mon, 26 Oct 2020 09:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603705893;
        bh=k6TpTdF9zeoGVgXjTXPkB7MqGhN+afdp01vXhs9WD6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AdJlf0sw85GMsI+e7KFS8Yy/GZk8uE+6sqauUshGEllb0JXvcslWXlPy9sSOCFwvj
         CMF+Wpv8vxpUVKXNOqlc0ivQ6qOsEf+kxb+qrB2bVqSDotrlH+ZCWuxuqFND5Yg30Q
         gWZjPzQD4BxO/CMfBTYepWqJvjXwL0prlJbEfl6U=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kWzA3-004HZn-Uv; Mon, 26 Oct 2020 09:51:32 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>, kernel-team@android.com
Subject: [PATCH 5/8] KVM: arm64: Turn host HVC handling into a dispatch table
Date:   Mon, 26 Oct 2020 09:51:13 +0000
Message-Id: <20201026095116.72051-6-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201026095116.72051-1-maz@kernel.org>
References: <20201026095116.72051-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com, will@kernel.org, qperret@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we can use function pointer, use a dispatch table to call
the individual HVC handlers, leading to more maintainable code.

Further improvements include helpers to declare the mapping of
local variables to values passed in the host context.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/image-vars.h     |   1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 227 +++++++++++++++++------------
 2 files changed, 134 insertions(+), 94 deletions(-)

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 61684a500914..b5b0fdd1043c 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -64,6 +64,7 @@ __efistub__ctype		= _ctype;
 /* Alternative callbacks for init-time patching of nVHE hyp code. */
 KVM_NVHE_ALIAS(kvm_patch_vector_branch);
 KVM_NVHE_ALIAS(kvm_update_va_mask);
+KVM_NVHE_ALIAS(kvm_update_kimg_phys_offset);
 
 /* Global kernel state accessed by nVHE hyp code. */
 KVM_NVHE_ALIAS(kvm_vgic_global_state);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index e2eafe2c93af..2af8a5e902af 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -12,106 +12,145 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
-#include <kvm/arm_hypercalls.h>
-
-static void handle_host_hcall(unsigned long func_id,
-			      struct kvm_cpu_context *host_ctxt)
-{
-	unsigned long ret = 0;
-
-	switch (func_id) {
-	case KVM_HOST_SMCCC_FUNC(__kvm_vcpu_run): {
-		unsigned long r1 = host_ctxt->regs.regs[1];
-		struct kvm_vcpu *vcpu = (struct kvm_vcpu *)r1;
-
-		ret = __kvm_vcpu_run(kern_hyp_va(vcpu));
-		break;
-	}
-	case KVM_HOST_SMCCC_FUNC(__kvm_flush_vm_context):
-		__kvm_flush_vm_context();
-		break;
-	case KVM_HOST_SMCCC_FUNC(__kvm_tlb_flush_vmid_ipa): {
-		unsigned long r1 = host_ctxt->regs.regs[1];
-		struct kvm_s2_mmu *mmu = (struct kvm_s2_mmu *)r1;
-		phys_addr_t ipa = host_ctxt->regs.regs[2];
-		int level = host_ctxt->regs.regs[3];
-
-		__kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
-		break;
-	}
-	case KVM_HOST_SMCCC_FUNC(__kvm_tlb_flush_vmid): {
-		unsigned long r1 = host_ctxt->regs.regs[1];
-		struct kvm_s2_mmu *mmu = (struct kvm_s2_mmu *)r1;
-
-		__kvm_tlb_flush_vmid(kern_hyp_va(mmu));
-		break;
-	}
-	case KVM_HOST_SMCCC_FUNC(__kvm_tlb_flush_local_vmid): {
-		unsigned long r1 = host_ctxt->regs.regs[1];
-		struct kvm_s2_mmu *mmu = (struct kvm_s2_mmu *)r1;
-
-		__kvm_tlb_flush_local_vmid(kern_hyp_va(mmu));
-		break;
-	}
-	case KVM_HOST_SMCCC_FUNC(__kvm_timer_set_cntvoff): {
-		u64 cntvoff = host_ctxt->regs.regs[1];
-
-		__kvm_timer_set_cntvoff(cntvoff);
-		break;
-	}
-	case KVM_HOST_SMCCC_FUNC(__kvm_enable_ssbs):
-		__kvm_enable_ssbs();
-		break;
-	case KVM_HOST_SMCCC_FUNC(__vgic_v3_get_ich_vtr_el2):
-		ret = __vgic_v3_get_ich_vtr_el2();
-		break;
-	case KVM_HOST_SMCCC_FUNC(__vgic_v3_read_vmcr):
-		ret = __vgic_v3_read_vmcr();
-		break;
-	case KVM_HOST_SMCCC_FUNC(__vgic_v3_write_vmcr): {
-		u32 vmcr = host_ctxt->regs.regs[1];
-
-		__vgic_v3_write_vmcr(vmcr);
-		break;
-	}
-	case KVM_HOST_SMCCC_FUNC(__vgic_v3_init_lrs):
-		__vgic_v3_init_lrs();
-		break;
-	case KVM_HOST_SMCCC_FUNC(__kvm_get_mdcr_el2):
-		ret = __kvm_get_mdcr_el2();
-		break;
-	case KVM_HOST_SMCCC_FUNC(__vgic_v3_save_aprs): {
-		unsigned long r1 = host_ctxt->regs.regs[1];
-		struct vgic_v3_cpu_if *cpu_if = (struct vgic_v3_cpu_if *)r1;
-
-		__vgic_v3_save_aprs(kern_hyp_va(cpu_if));
-		break;
-	}
-	case KVM_HOST_SMCCC_FUNC(__vgic_v3_restore_aprs): {
-		unsigned long r1 = host_ctxt->regs.regs[1];
-		struct vgic_v3_cpu_if *cpu_if = (struct vgic_v3_cpu_if *)r1;
-
-		__vgic_v3_restore_aprs(kern_hyp_va(cpu_if));
-		break;
-	}
-	default:
-		/* Invalid host HVC. */
-		host_ctxt->regs.regs[0] = SMCCC_RET_NOT_SUPPORTED;
-		return;
-	}
-
-	host_ctxt->regs.regs[0] = SMCCC_RET_SUCCESS;
-	host_ctxt->regs.regs[1] = ret;
+#define cpu_reg(ctxt, r)	(ctxt)->regs.regs[r]
+#define DECLARE_REG(type, name, ctxt, reg)	\
+				type name = (type)cpu_reg(ctxt, (reg))
+
+static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
+
+	cpu_reg(host_ctxt, 1) =  __kvm_vcpu_run(kern_hyp_va(vcpu));
+}
+
+static void handle___kvm_flush_vm_context(struct kvm_cpu_context *host_ctxt)
+{
+	__kvm_flush_vm_context();
+}
+
+static void handle___kvm_tlb_flush_vmid_ipa(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
+	DECLARE_REG(phys_addr_t, ipa, host_ctxt, 2);
+	DECLARE_REG(int, level, host_ctxt, 3);
+
+	__kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
+}
+
+static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
+
+	__kvm_tlb_flush_vmid(kern_hyp_va(mmu));
+}
+
+static void handle___kvm_tlb_flush_local_vmid(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
+
+	__kvm_tlb_flush_local_vmid(kern_hyp_va(mmu));
+}
+
+static void handle___kvm_timer_set_cntvoff(struct kvm_cpu_context *host_ctxt)
+{
+	__kvm_timer_set_cntvoff(cpu_reg(host_ctxt, 1));
+}
+
+static void handle___kvm_enable_ssbs(struct kvm_cpu_context *host_ctxt)
+{
+	__kvm_enable_ssbs();
+}
+
+static void handle___vgic_v3_get_ich_vtr_el2(struct kvm_cpu_context *host_ctxt)
+{
+	cpu_reg(host_ctxt, 1) = __vgic_v3_get_ich_vtr_el2();
+}
+
+static void handle___vgic_v3_read_vmcr(struct kvm_cpu_context *host_ctxt)
+{
+	cpu_reg(host_ctxt, 1) = __vgic_v3_read_vmcr();
+}
+
+static void handle___vgic_v3_write_vmcr(struct kvm_cpu_context *host_ctxt)
+{
+	__vgic_v3_write_vmcr(cpu_reg(host_ctxt, 1));
+}
+
+static void handle___vgic_v3_init_lrs(struct kvm_cpu_context *host_ctxt)
+{
+	__vgic_v3_init_lrs();
+}
+
+static void handle___kvm_get_mdcr_el2(struct kvm_cpu_context *host_ctxt)
+{
+	cpu_reg(host_ctxt, 1) = __kvm_get_mdcr_el2();
+}
+
+static void handle___vgic_v3_save_aprs(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
+
+	__vgic_v3_save_aprs(kern_hyp_va(cpu_if));
+}
+
+static void handle___vgic_v3_restore_aprs(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
+
+	__vgic_v3_restore_aprs(kern_hyp_va(cpu_if));
+}
+
+#define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = handle_##x
+
+typedef void (*hcall_t)(struct kvm_cpu_context *);
+
+static const hcall_t host_hcall[] = {
+	HANDLE_FUNC(__kvm_vcpu_run),
+	HANDLE_FUNC(__kvm_flush_vm_context),
+	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
+	HANDLE_FUNC(__kvm_tlb_flush_vmid),
+	HANDLE_FUNC(__kvm_tlb_flush_local_vmid),
+	HANDLE_FUNC(__kvm_timer_set_cntvoff),
+	HANDLE_FUNC(__kvm_enable_ssbs),
+	HANDLE_FUNC(__vgic_v3_get_ich_vtr_el2),
+	HANDLE_FUNC(__vgic_v3_read_vmcr),
+	HANDLE_FUNC(__vgic_v3_write_vmcr),
+	HANDLE_FUNC(__vgic_v3_init_lrs),
+	HANDLE_FUNC(__kvm_get_mdcr_el2),
+	HANDLE_FUNC(__vgic_v3_save_aprs),
+	HANDLE_FUNC(__vgic_v3_restore_aprs),
+};
+
+static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(unsigned long, id, host_ctxt, 0);
+	unsigned long ret = SMCCC_RET_NOT_SUPPORTED;
+	hcall_t hcall;
+
+	id -= KVM_HOST_SMCCC_ID(0);
+
+	if (unlikely(id >= ARRAY_SIZE(host_hcall)))
+		goto inval;
+
+	hcall = host_hcall[id];
+	if (unlikely(!hcall))
+		goto inval;
+
+	hcall = kimg_hyp_va(hcall);
+
+	hcall(host_ctxt);
+	ret = SMCCC_RET_SUCCESS;
+
+inval:
+	cpu_reg(host_ctxt, 0) = ret;
 }
 
 void handle_trap(struct kvm_cpu_context *host_ctxt)
 {
 	u64 esr = read_sysreg_el2(SYS_ESR);
-	unsigned long func_id;
 
-	if (ESR_ELx_EC(esr) != ESR_ELx_EC_HVC64)
+	if (unlikely(ESR_ELx_EC(esr) != ESR_ELx_EC_HVC64))
 		hyp_panic();
 
-	func_id = host_ctxt->regs.regs[0];
-	handle_host_hcall(func_id, host_ctxt);
+	handle_host_hcall(host_ctxt);
 }
-- 
2.28.0

