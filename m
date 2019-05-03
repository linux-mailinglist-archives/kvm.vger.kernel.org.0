Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B368412E0A
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbfECMpu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:45:50 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:60388 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727737AbfECMpu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:45:50 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9BD6F1682;
        Fri,  3 May 2019 05:45:49 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6478D3F220;
        Fri,  3 May 2019 05:45:46 -0700 (PDT)
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
Subject: [PATCH 19/56] KVM: arm64: Enumerate SVE register indices for KVM_GET_REG_LIST
Date:   Fri,  3 May 2019 13:43:50 +0100
Message-Id: <20190503124427.190206-20-marc.zyngier@arm.com>
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

This patch includes the SVE register IDs in the list returned by
KVM_GET_REG_LIST, as appropriate.

On a non-SVE-enabled vcpu, no new IDs are added.

On an SVE-enabled vcpu, IDs for the FPSIMD V-registers are removed
from the list, since userspace is required to access the Z-
registers instead in order to access the V-register content.  For
the variably-sized SVE registers, the appropriate set of slice IDs
are enumerated, depending on the maximum vector length for the
vcpu.

As it currently stands, the SVE architecture never requires more
than one slice to exist per register, so this patch adds no
explicit support for enumerating multiple slices.  The code can be
extended straightforwardly to support this in the future, if
needed.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/guest.c | 63 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 736d8cb8dad7..2aa80a59e2a2 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -222,6 +222,13 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 #define KVM_SVE_ZREG_SIZE KVM_REG_SIZE(KVM_REG_ARM64_SVE_ZREG(0, 0))
 #define KVM_SVE_PREG_SIZE KVM_REG_SIZE(KVM_REG_ARM64_SVE_PREG(0, 0))
 
+/*
+ * number of register slices required to cover each whole SVE register on vcpu
+ * NOTE: If you are tempted to modify this, you must also to rework
+ * sve_reg_to_region() to match:
+ */
+#define vcpu_sve_slices(vcpu) 1
+
 /* Bounds of a single SVE register slice within vcpu->arch.sve_state */
 struct sve_state_reg_region {
 	unsigned int koffset;	/* offset into sve_state in kernel memory */
@@ -411,6 +418,56 @@ static int get_timer_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)) ? -EFAULT : 0;
 }
 
+static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
+{
+	/* Only the first slice ever exists, for now */
+	const unsigned int slices = vcpu_sve_slices(vcpu);
+
+	if (!vcpu_has_sve(vcpu))
+		return 0;
+
+	return slices * (SVE_NUM_PREGS + SVE_NUM_ZREGS + 1 /* FFR */);
+}
+
+static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
+				u64 __user *uindices)
+{
+	/* Only the first slice ever exists, for now */
+	const unsigned int slices = vcpu_sve_slices(vcpu);
+	u64 reg;
+	unsigned int i, n;
+	int num_regs = 0;
+
+	if (!vcpu_has_sve(vcpu))
+		return 0;
+
+	for (i = 0; i < slices; i++) {
+		for (n = 0; n < SVE_NUM_ZREGS; n++) {
+			reg = KVM_REG_ARM64_SVE_ZREG(n, i);
+			if (put_user(reg, uindices++))
+				return -EFAULT;
+
+			num_regs++;
+		}
+
+		for (n = 0; n < SVE_NUM_PREGS; n++) {
+			reg = KVM_REG_ARM64_SVE_PREG(n, i);
+			if (put_user(reg, uindices++))
+				return -EFAULT;
+
+			num_regs++;
+		}
+
+		reg = KVM_REG_ARM64_SVE_FFR(i);
+		if (put_user(reg, uindices++))
+			return -EFAULT;
+
+		num_regs++;
+	}
+
+	return num_regs;
+}
+
 /**
  * kvm_arm_num_regs - how many registers do we present via KVM_GET_ONE_REG
  *
@@ -421,6 +478,7 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
 	unsigned long res = 0;
 
 	res += num_core_regs(vcpu);
+	res += num_sve_regs(vcpu);
 	res += kvm_arm_num_sys_reg_descs(vcpu);
 	res += kvm_arm_get_fw_num_regs(vcpu);
 	res += NUM_TIMER_REGS;
@@ -442,6 +500,11 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 		return ret;
 	uindices += ret;
 
+	ret = copy_sve_reg_indices(vcpu, uindices);
+	if (ret)
+		return ret;
+	uindices += ret;
+
 	ret = kvm_arm_copy_fw_reg_indices(vcpu, uindices);
 	if (ret)
 		return ret;
-- 
2.20.1

