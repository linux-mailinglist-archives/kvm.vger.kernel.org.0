Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 275EA12E2F
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbfECMqn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:46:43 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:60722 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726969AbfECMqm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:46:42 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2B30780D;
        Fri,  3 May 2019 05:46:42 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E81263F220;
        Fri,  3 May 2019 05:46:38 -0700 (PDT)
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
Subject: [PATCH 34/56] KVM: arm64/sve: Miscellaneous tidyups in guest.c
Date:   Fri,  3 May 2019 13:44:05 +0100
Message-Id: <20190503124427.190206-35-marc.zyngier@arm.com>
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

 * Remove a few redundant blank lines that are stylistically
   inconsistent with code already in guest.c and are just taking up
   space.

 * Delete a couple of pointless empty default cases from switch
   statements whose behaviour is otherwise obvious anyway.

 * Fix some typos and consolidate some redundantly duplicated
   comments.

 * Respell the slice index check in sve_reg_to_region() as "> 0"
   to be more consistent with what is logically being checked here
   (i.e., "is the slice index too large"), even though we don't try
   to cope with multiple slices yet.

No functional change.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/guest.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 2e449e1dea73..f5ff7aea25aa 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -290,9 +290,10 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 #define KVM_SVE_PREG_SIZE KVM_REG_SIZE(KVM_REG_ARM64_SVE_PREG(0, 0))
 
 /*
- * number of register slices required to cover each whole SVE register on vcpu
- * NOTE: If you are tempted to modify this, you must also to rework
- * sve_reg_to_region() to match:
+ * Number of register slices required to cover each whole SVE register.
+ * NOTE: Only the first slice every exists, for now.
+ * If you are tempted to modify this, you must also rework sve_reg_to_region()
+ * to match:
  */
 #define vcpu_sve_slices(vcpu) 1
 
@@ -334,8 +335,7 @@ static int sve_reg_to_region(struct sve_state_reg_region *region,
 	/* Verify that we match the UAPI header: */
 	BUILD_BUG_ON(SVE_NUM_SLICES != KVM_ARM64_SVE_MAX_SLICES);
 
-	/* Only the first slice ever exists, for now: */
-	if ((reg->id & SVE_REG_SLICE_MASK) != 0)
+	if ((reg->id & SVE_REG_SLICE_MASK) > 0)
 		return -ENOENT;
 
 	vq = sve_vq_from_vl(vcpu->arch.sve_max_vl);
@@ -520,7 +520,6 @@ static int get_timer_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
 {
-	/* Only the first slice ever exists, for now */
 	const unsigned int slices = vcpu_sve_slices(vcpu);
 
 	if (!vcpu_has_sve(vcpu))
@@ -536,7 +535,6 @@ static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
 static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
 				u64 __user *uindices)
 {
-	/* Only the first slice ever exists, for now */
 	const unsigned int slices = vcpu_sve_slices(vcpu);
 	u64 reg;
 	unsigned int i, n;
@@ -555,7 +553,6 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
 	reg = KVM_REG_ARM64_SVE_VLS;
 	if (put_user(reg, uindices++))
 		return -EFAULT;
-
 	++num_regs;
 
 	for (i = 0; i < slices; i++) {
@@ -563,7 +560,6 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
 			reg = KVM_REG_ARM64_SVE_ZREG(n, i);
 			if (put_user(reg, uindices++))
 				return -EFAULT;
-
 			num_regs++;
 		}
 
@@ -571,14 +567,12 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
 			reg = KVM_REG_ARM64_SVE_PREG(n, i);
 			if (put_user(reg, uindices++))
 				return -EFAULT;
-
 			num_regs++;
 		}
 
 		reg = KVM_REG_ARM64_SVE_FFR(i);
 		if (put_user(reg, uindices++))
 			return -EFAULT;
-
 		num_regs++;
 	}
 
@@ -645,7 +639,6 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_CORE:	return get_core_reg(vcpu, reg);
 	case KVM_REG_ARM_FW:	return kvm_arm_get_fw_reg(vcpu, reg);
 	case KVM_REG_ARM64_SVE:	return get_sve_reg(vcpu, reg);
-	default: break; /* fall through */
 	}
 
 	if (is_timer_reg(reg->id))
@@ -664,7 +657,6 @@ int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_CORE:	return set_core_reg(vcpu, reg);
 	case KVM_REG_ARM_FW:	return kvm_arm_set_fw_reg(vcpu, reg);
 	case KVM_REG_ARM64_SVE:	return set_sve_reg(vcpu, reg);
-	default: break; /* fall through */
 	}
 
 	if (is_timer_reg(reg->id))
-- 
2.20.1

