Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5B712DF9
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbfECMpW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:45:22 -0400
Received: from foss.arm.com ([217.140.101.70]:60212 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727978AbfECMpW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:45:22 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 657BC15AD;
        Fri,  3 May 2019 05:45:21 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2E2BD3F220;
        Fri,  3 May 2019 05:45:18 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "zhang . lei" <zhang.lei@jp.fujitsu.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 11/56] KVM: arm64: Support runtime sysreg visibility filtering
Date:   Fri,  3 May 2019 13:43:42 +0100
Message-Id: <20190503124427.190206-12-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dave Martin <Dave.Martin@arm.com>

Some optional features of the Arm architecture add new system
registers that are not present in the base architecture.

Where these features are optional for the guest, the visibility of
these registers may need to depend on some runtime configuration,
such as a flag passed to KVM_ARM_VCPU_INIT.

For example, ZCR_EL1 and ID_AA64ZFR0_EL1 need to be hidden if SVE
is not enabled for the guest, even though these registers may be
present in the hardware and visible to the host at EL2.

Adding special-case checks all over the place for individual
registers is going to get messy as the number of conditionally-
visible registers grows.

In order to help solve this problem, this patch adds a new sysreg
method visibility() that can be used to hook in any needed runtime
visibility checks.  This method can currently return
REG_HIDDEN_USER to inhibit enumeration and ioctl access to the
register for userspace, and REG_HIDDEN_GUEST to inhibit runtime
access by the guest using MSR/MRS.  Wrappers are added to allow
these flags to be conveniently queried.

This approach allows a conditionally modified view of individual
system registers such as the CPU ID registers, in addition to
completely hiding register where appropriate.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 24 +++++++++++++++++++++---
 arch/arm64/kvm/sys_regs.h | 25 +++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a5d14b5e2ea4..c86a7b0d3e6b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1927,6 +1927,12 @@ static void perform_access(struct kvm_vcpu *vcpu,
 {
 	trace_kvm_sys_access(*vcpu_pc(vcpu), params, r);
 
+	/* Check for regs disabled by runtime config */
+	if (sysreg_hidden_from_guest(vcpu, r)) {
+		kvm_inject_undefined(vcpu);
+		return;
+	}
+
 	/*
 	 * Not having an accessor means that we have configured a trap
 	 * that we don't know how to handle. This certainly qualifies
@@ -2438,6 +2444,10 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	if (!r)
 		return get_invariant_sys_reg(reg->id, uaddr);
 
+	/* Check for regs disabled by runtime config */
+	if (sysreg_hidden_from_user(vcpu, r))
+		return -ENOENT;
+
 	if (r->get_user)
 		return (r->get_user)(vcpu, r, reg, uaddr);
 
@@ -2459,6 +2469,10 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	if (!r)
 		return set_invariant_sys_reg(reg->id, uaddr);
 
+	/* Check for regs disabled by runtime config */
+	if (sysreg_hidden_from_user(vcpu, r))
+		return -ENOENT;
+
 	if (r->set_user)
 		return (r->set_user)(vcpu, r, reg, uaddr);
 
@@ -2515,7 +2529,8 @@ static bool copy_reg_to_user(const struct sys_reg_desc *reg, u64 __user **uind)
 	return true;
 }
 
-static int walk_one_sys_reg(const struct sys_reg_desc *rd,
+static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
+			    const struct sys_reg_desc *rd,
 			    u64 __user **uind,
 			    unsigned int *total)
 {
@@ -2526,6 +2541,9 @@ static int walk_one_sys_reg(const struct sys_reg_desc *rd,
 	if (!(rd->reg || rd->get_user))
 		return 0;
 
+	if (sysreg_hidden_from_user(vcpu, rd))
+		return 0;
+
 	if (!copy_reg_to_user(rd, uind))
 		return -EFAULT;
 
@@ -2554,9 +2572,9 @@ static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
 		int cmp = cmp_sys_reg(i1, i2);
 		/* target-specific overrides generic entry. */
 		if (cmp <= 0)
-			err = walk_one_sys_reg(i1, &uind, &total);
+			err = walk_one_sys_reg(vcpu, i1, &uind, &total);
 		else
-			err = walk_one_sys_reg(i2, &uind, &total);
+			err = walk_one_sys_reg(vcpu, i2, &uind, &total);
 
 		if (err)
 			return err;
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 3b1bc7f01d0b..2be99508dcb9 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -64,8 +64,15 @@ struct sys_reg_desc {
 			const struct kvm_one_reg *reg, void __user *uaddr);
 	int (*set_user)(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 			const struct kvm_one_reg *reg, void __user *uaddr);
+
+	/* Return mask of REG_* runtime visibility overrides */
+	unsigned int (*visibility)(const struct kvm_vcpu *vcpu,
+				   const struct sys_reg_desc *rd);
 };
 
+#define REG_HIDDEN_USER		(1 << 0) /* hidden from userspace ioctls */
+#define REG_HIDDEN_GUEST	(1 << 1) /* hidden from guest */
+
 static inline void print_sys_reg_instr(const struct sys_reg_params *p)
 {
 	/* Look, we even formatted it for you to paste into the table! */
@@ -102,6 +109,24 @@ static inline void reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r
 	__vcpu_sys_reg(vcpu, r->reg) = r->val;
 }
 
+static inline bool sysreg_hidden_from_guest(const struct kvm_vcpu *vcpu,
+					    const struct sys_reg_desc *r)
+{
+	if (likely(!r->visibility))
+		return false;
+
+	return r->visibility(vcpu, r) & REG_HIDDEN_GUEST;
+}
+
+static inline bool sysreg_hidden_from_user(const struct kvm_vcpu *vcpu,
+					   const struct sys_reg_desc *r)
+{
+	if (likely(!r->visibility))
+		return false;
+
+	return r->visibility(vcpu, r) & REG_HIDDEN_USER;
+}
+
 static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
 			      const struct sys_reg_desc *i2)
 {
-- 
2.20.1

