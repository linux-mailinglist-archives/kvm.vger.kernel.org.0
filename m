Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9233649F941
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 13:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbiA1MUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 07:20:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36524 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348444AbiA1MUQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 07:20:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4AC561AE3
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 12:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18089C340E0;
        Fri, 28 Jan 2022 12:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643372415;
        bh=Vqtiy5ffkPfftjl64++Q0XU5MRA+zRJ561BWojqb1/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ia7A5JNrthXBi3WuWEzyd0zo8RXf/L5IklqPjhgo2+f7ciMddL9QcxMMLHK31PTFi
         CQHdMQ68dktjGif9cxaqvJcceaYBkvxx92JQ3xWqKSH6slTfrqm+4FkrGsfnBhg0+p
         sWI4KG2dhT2/909uSDbn70ChItx3XwAm4gpwOu5AjwhjMGOADFKUdNuN7iChzB2fdR
         Cd2M7ZWrb9qKHjVBB+G9eJBNnfBLwO8D3eUAmTRTgKrZzLOvN0BnBnbcFUel4J0PDk
         9gW6GmRMiIgNGp+PdyD10iVIYymeNtc0KCLWMA7ro5lbWeVhVRAXbakZjJlhRZE4iM
         xqLg6uBFQ5aHg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nDQDy-003njR-NR; Fri, 28 Jan 2022 12:19:30 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: [PATCH v6 18/64] KVM: arm64: nv: Trap EL1 VM register accesses in virtual EL2
Date:   Fri, 28 Jan 2022 12:18:26 +0000
Message-Id: <20220128121912.509006-19-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220128121912.509006-1-maz@kernel.org>
References: <20220128121912.509006-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, linux@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, karl.heubaum@oracle.com, mihai.carabas@oracle.com, miguel.luis@oracle.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christoffer Dall <christoffer.dall@linaro.org>

When running in virtual EL2 mode, we actually run the hardware in EL1
and therefore have to use the EL1 registers to ensure correct operation.

By setting the HCR.TVM and HCR.TVRM we ensure that the virtual EL2 mode
doesn't shoot itself in the foot when setting up what it believes to be
a different mode's system register state (for example when preparing to
switch to a VM).

We can leverage the existing sysregs infrastructure to support trapped
accesses to these registers.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 +---
 arch/arm64/kvm/hyp/nvhe/switch.c        |  2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         |  7 ++++++-
 arch/arm64/kvm/sys_regs.c               | 19 ++++++++++++++++---
 4 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 58e14f8ead23..49c3b9eb09d7 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -110,10 +110,8 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 		write_sysreg(0, pmuserenr_el0);
 }
 
-static inline void ___activate_traps(struct kvm_vcpu *vcpu)
+static inline void ___activate_traps(struct kvm_vcpu *vcpu, u64 hcr)
 {
-	u64 hcr = vcpu->arch.hcr_el2;
-
 	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM))
 		hcr |= HCR_TVM;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 6410d21d8695..61a5627fd456 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -38,7 +38,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
-	___activate_traps(vcpu);
+	___activate_traps(vcpu, vcpu->arch.hcr_el2);
 	__activate_traps_common(vcpu);
 
 	val = vcpu->arch.cptr_el2;
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 82ddaebe66de..6ed9e4893a02 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -32,9 +32,14 @@ DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
 static void __activate_traps(struct kvm_vcpu *vcpu)
 {
+	u64 hcr = vcpu->arch.hcr_el2;
 	u64 val;
 
-	___activate_traps(vcpu);
+	/* Trap VM sysreg accesses if an EL2 guest is not using VHE. */
+	if (vcpu_is_el2(vcpu) && !vcpu_el2_e2h_is_set(vcpu))
+		hcr |= HCR_TVM | HCR_TRVM;
+
+	___activate_traps(vcpu, hcr);
 
 	val = read_sysreg(cpacr_el1);
 	val |= CPACR_EL1_TTA;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 102bc4906723..9d3520f1d17a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -322,8 +322,15 @@ static void get_access_mask(const struct sys_reg_desc *r, u64 *mask, u64 *shift)
 
 /*
  * Generic accessor for VM registers. Only called as long as HCR_TVM
- * is set. If the guest enables the MMU, we stop trapping the VM
- * sys_regs and leave it in complete control of the caches.
+ * is set.
+ *
+ * This is set in two cases: either (1) we're running at vEL2, or (2)
+ * we're running at EL1 and the guest has its MMU off.
+ *
+ * (1) TVM/TRVM is set, as we need to virtualise some of the VM
+ * registers for the guest hypervisor
+ * (2) Once the guest enables the MMU, we stop trapping the VM sys_regs
+ * and leave it in complete control of the caches.
  */
 static bool access_vm_reg(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
@@ -332,7 +339,13 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	bool was_enabled = vcpu_has_cache_enabled(vcpu);
 	u64 val, mask, shift;
 
-	BUG_ON(!p->is_write);
+	/* We don't expect TRVM on the host */
+	BUG_ON(!vcpu_is_el2(vcpu) && !p->is_write);
+
+	if (!p->is_write) {
+		p->regval = vcpu_read_sys_reg(vcpu, r->reg);
+		return true;
+	}
 
 	get_access_mask(r, &mask, &shift);
 
-- 
2.30.2

