Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0967E4E401
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 11:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfFUJj4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 05:39:56 -0400
Received: from foss.arm.com ([217.140.110.172]:54104 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbfFUJj4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 05:39:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 659541478;
        Fri, 21 Jun 2019 02:39:56 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 11C903F246;
        Fri, 21 Jun 2019 02:39:54 -0700 (PDT)
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
Subject: [PATCH 28/59] KVM: arm64: nv: Respect the virtual HCR_EL2.NV1 bit setting
Date:   Fri, 21 Jun 2019 10:38:12 +0100
Message-Id: <20190621093843.220980-29-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190621093843.220980-1-marc.zyngier@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jintack Lim <jintack@cs.columbia.edu>

Forward ELR_EL1, SPSR_EL1 and VBAR_EL1 traps to the virtual EL2 if the
virtual HCR_EL2.NV bit is set.

This is for recursive nested virtualization.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h |  1 +
 arch/arm64/kvm/sys_regs.c        | 19 +++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index d21486274eeb..55f4525c112c 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -24,6 +24,7 @@
 
 /* Hyp Configuration Register (HCR) bits */
 #define HCR_FWB		(UL(1) << 46)
+#define HCR_NV1		(UL(1) << 43)
 #define HCR_NV		(UL(1) << 42)
 #define HCR_API		(UL(1) << 41)
 #define HCR_APK		(UL(1) << 40)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0f74b9277a86..beadebcfc888 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -473,8 +473,10 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	if (el12_reg(p) && forward_nv_traps(vcpu))
 		return false;
 
-	if (!el12_reg(p) && forward_vm_traps(vcpu, p))
-		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
+	if (!el12_reg(p) && forward_vm_traps(vcpu, p)) {
+		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
+		return false;
+	}
 
 	BUG_ON(!vcpu_mode_el2(vcpu) && !p->is_write);
 
@@ -1643,6 +1645,13 @@ static bool access_sp_el1(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+
+/* This function is to support the recursive nested virtualization */
+static bool forward_nv1_traps(struct kvm_vcpu *vcpu, struct sys_reg_params *p)
+{
+	return forward_traps(vcpu, HCR_NV1);
+}
+
 static bool access_elr(struct kvm_vcpu *vcpu,
 		       struct sys_reg_params *p,
 		       const struct sys_reg_desc *r)
@@ -1650,6 +1659,9 @@ static bool access_elr(struct kvm_vcpu *vcpu,
 	if (el12_reg(p) && forward_nv_traps(vcpu))
 		return false;
 
+	if (!el12_reg(p) && forward_nv1_traps(vcpu, p))
+		return false;
+
 	if (p->is_write)
 		vcpu->arch.ctxt.gp_regs.elr_el1 = p->regval;
 	else
@@ -1665,6 +1677,9 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
 	if (el12_reg(p) && forward_nv_traps(vcpu))
 		return false;
 
+	if (!el12_reg(p) && forward_nv1_traps(vcpu, p))
+		return false;
+
 	if (p->is_write)
 		vcpu->arch.ctxt.gp_regs.spsr[KVM_SPSR_EL1] = p->regval;
 	else
-- 
2.20.1

