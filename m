Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0E3412E30
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbfECMqq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:46:46 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:60742 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728044AbfECMqq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:46:46 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A5BF6374;
        Fri,  3 May 2019 05:46:45 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6E4283F220;
        Fri,  3 May 2019 05:46:42 -0700 (PDT)
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
Subject: [PATCH 35/56] KVM: arm64/sve: Make register ioctl access errors more consistent
Date:   Fri,  3 May 2019 13:44:06 +0100
Message-Id: <20190503124427.190206-36-marc.zyngier@arm.com>
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

Currently, the way error codes are generated when processing the
SVE register access ioctls in a bit haphazard.

This patch refactors the code so that the behaviour is more
consistent: now, -EINVAL should be returned only for unrecognised
register IDs or when some other runtime error occurs.  -ENOENT is
returned for register IDs that are recognised, but whose
corresponding register (or slice) does not exist for the vcpu.

To this end, in {get,set}_sve_reg() we now delegate the
vcpu_has_sve() check down into {get,set}_sve_vls() and
sve_reg_to_region().  The KVM_REG_ARM64_SVE_VLS special case is
picked off first, then sve_reg_to_region() plays the role of
exhaustively validating or rejecting the register ID and (where
accepted) computing the applicable register region as before.

sve_reg_to_region() is rearranged so that -ENOENT or -EPERM is not
returned prematurely, before checking whether reg->id is in a
recognised range.

-EPERM is now only returned when an attempt is made to access an
actually existing register slice on an unfinalized vcpu.

Fixes: e1c9c98345b3 ("KVM: arm64/sve: Add SVE support to register access ioctl interface")
Fixes: 9033bba4b535 ("KVM: arm64/sve: Add pseudo-register for the guest's vector lengths")
Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/guest.c | 52 +++++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index f5ff7aea25aa..e45a042c0628 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -221,6 +221,9 @@ static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	unsigned int max_vq, vq;
 	u64 vqs[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)];
 
+	if (!vcpu_has_sve(vcpu))
+		return -ENOENT;
+
 	if (WARN_ON(!sve_vl_valid(vcpu->arch.sve_max_vl)))
 		return -EINVAL;
 
@@ -242,6 +245,9 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	unsigned int max_vq, vq;
 	u64 vqs[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)];
 
+	if (!vcpu_has_sve(vcpu))
+		return -ENOENT;
+
 	if (kvm_arm_vcpu_sve_finalized(vcpu))
 		return -EPERM; /* too late! */
 
@@ -304,7 +310,10 @@ struct sve_state_reg_region {
 	unsigned int upad;	/* extra trailing padding in user memory */
 };
 
-/* Get sanitised bounds for user/kernel SVE register copy */
+/*
+ * Validate SVE register ID and get sanitised bounds for user/kernel SVE
+ * register copy
+ */
 static int sve_reg_to_region(struct sve_state_reg_region *region,
 			     struct kvm_vcpu *vcpu,
 			     const struct kvm_one_reg *reg)
@@ -335,25 +344,30 @@ static int sve_reg_to_region(struct sve_state_reg_region *region,
 	/* Verify that we match the UAPI header: */
 	BUILD_BUG_ON(SVE_NUM_SLICES != KVM_ARM64_SVE_MAX_SLICES);
 
-	if ((reg->id & SVE_REG_SLICE_MASK) > 0)
-		return -ENOENT;
-
-	vq = sve_vq_from_vl(vcpu->arch.sve_max_vl);
-
 	reg_num = (reg->id & SVE_REG_ID_MASK) >> SVE_REG_ID_SHIFT;
 
 	if (reg->id >= zreg_id_min && reg->id <= zreg_id_max) {
+		if (!vcpu_has_sve(vcpu) || (reg->id & SVE_REG_SLICE_MASK) > 0)
+			return -ENOENT;
+
+		vq = sve_vq_from_vl(vcpu->arch.sve_max_vl);
+
 		reqoffset = SVE_SIG_ZREG_OFFSET(vq, reg_num) -
 				SVE_SIG_REGS_OFFSET;
 		reqlen = KVM_SVE_ZREG_SIZE;
 		maxlen = SVE_SIG_ZREG_SIZE(vq);
 	} else if (reg->id >= preg_id_min && reg->id <= preg_id_max) {
+		if (!vcpu_has_sve(vcpu) || (reg->id & SVE_REG_SLICE_MASK) > 0)
+			return -ENOENT;
+
+		vq = sve_vq_from_vl(vcpu->arch.sve_max_vl);
+
 		reqoffset = SVE_SIG_PREG_OFFSET(vq, reg_num) -
 				SVE_SIG_REGS_OFFSET;
 		reqlen = KVM_SVE_PREG_SIZE;
 		maxlen = SVE_SIG_PREG_SIZE(vq);
 	} else {
-		return -ENOENT;
+		return -EINVAL;
 	}
 
 	sve_state_size = vcpu_sve_state_size(vcpu);
@@ -369,24 +383,22 @@ static int sve_reg_to_region(struct sve_state_reg_region *region,
 
 static int get_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
+	int ret;
 	struct sve_state_reg_region region;
 	char __user *uptr = (char __user *)reg->addr;
 
-	if (!vcpu_has_sve(vcpu))
-		return -ENOENT;
-
 	/* Handle the KVM_REG_ARM64_SVE_VLS pseudo-reg as a special case: */
 	if (reg->id == KVM_REG_ARM64_SVE_VLS)
 		return get_sve_vls(vcpu, reg);
 
-	/* Otherwise, reg is an architectural SVE register... */
+	/* Try to interpret reg ID as an architectural SVE register... */
+	ret = sve_reg_to_region(&region, vcpu, reg);
+	if (ret)
+		return ret;
 
 	if (!kvm_arm_vcpu_sve_finalized(vcpu))
 		return -EPERM;
 
-	if (sve_reg_to_region(&region, vcpu, reg))
-		return -ENOENT;
-
 	if (copy_to_user(uptr, vcpu->arch.sve_state + region.koffset,
 			 region.klen) ||
 	    clear_user(uptr + region.klen, region.upad))
@@ -397,24 +409,22 @@ static int get_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 static int set_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
+	int ret;
 	struct sve_state_reg_region region;
 	const char __user *uptr = (const char __user *)reg->addr;
 
-	if (!vcpu_has_sve(vcpu))
-		return -ENOENT;
-
 	/* Handle the KVM_REG_ARM64_SVE_VLS pseudo-reg as a special case: */
 	if (reg->id == KVM_REG_ARM64_SVE_VLS)
 		return set_sve_vls(vcpu, reg);
 
-	/* Otherwise, reg is an architectural SVE register... */
+	/* Try to interpret reg ID as an architectural SVE register... */
+	ret = sve_reg_to_region(&region, vcpu, reg);
+	if (ret)
+		return ret;
 
 	if (!kvm_arm_vcpu_sve_finalized(vcpu))
 		return -EPERM;
 
-	if (sve_reg_to_region(&region, vcpu, reg))
-		return -ENOENT;
-
 	if (copy_from_user(vcpu->arch.sve_state + region.koffset, uptr,
 			   region.klen))
 		return -EFAULT;
-- 
2.20.1

