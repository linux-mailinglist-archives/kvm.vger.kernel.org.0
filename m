Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7DD46D67BD
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 17:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235916AbjDDPmI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 11:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235929AbjDDPmF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 11:42:05 -0400
Received: from out-46.mta0.migadu.com (out-46.mta0.migadu.com [91.218.175.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E74B46BC
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 08:41:45 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680622886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hu6Jzs9Jb4x0EU/aPzfV4CfH6E+q7hXBPM7EfsBJyRE=;
        b=goRNlGQUsyZfbzgOMzCmtoyEWSnBFsGJapu/eZljQ2sdv65D+iAnBbD240N9ou/kM1Ley6
        PJVKrBzk6bYiEB66d52vILsPgd81s6EhertAw+pEDzRxMrFCxllZg40YExdc8sjLhpZi0J
        fcFvQXDz4qKPYbgjkTJwBgEBB4pDA4Y=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Sean Christopherson <seanjc@google.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 07/13] KVM: arm64: Use a maple tree to represent the SMCCC filter
Date:   Tue,  4 Apr 2023 15:40:44 +0000
Message-Id: <20230404154050.2270077-8-oliver.upton@linux.dev>
In-Reply-To: <20230404154050.2270077-1-oliver.upton@linux.dev>
References: <20230404154050.2270077-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maple tree is an efficient B-tree implementation that is intended for
storing non-overlapping intervals. Such a data structure is a good fit
for the SMCCC filter as it is desirable to sparsely allocate the 32 bit
function ID space.

To that end, add a maple tree to kvm_arch and correctly init/teardown
along with the VM. Wire in a test against the hypercall filter for HVCs
which does nothing until the controls are exposed to userspace.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  5 ++-
 arch/arm64/kvm/arm.c              |  2 ++
 arch/arm64/kvm/hypercalls.c       | 57 +++++++++++++++++++++++++++++++
 include/kvm/arm_hypercalls.h      |  1 +
 4 files changed, 64 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d091d1c9890b..2682b3fd0881 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -16,6 +16,7 @@
 #include <linux/types.h>
 #include <linux/jump_label.h>
 #include <linux/kvm_types.h>
+#include <linux/maple_tree.h>
 #include <linux/percpu.h>
 #include <linux/psci.h>
 #include <asm/arch_gicv3.h>
@@ -221,7 +222,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_EL1_32BIT				4
 	/* PSCI SYSTEM_SUSPEND enabled for the guest */
 #define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED		5
-
+	/* SMCCC filter initialized for the VM */
+#define KVM_ARCH_FLAG_SMCCC_FILTER_CONFIGURED		6
 	unsigned long flags;
 
 	/*
@@ -242,6 +244,7 @@ struct kvm_arch {
 
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
+	struct maple_tree smccc_filter;
 
 	/*
 	 * For an untrusted host VM, 'pkvm.handle' is used to lookup
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b6e26c0e65e5..1202ac03bee0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -192,6 +192,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_destroy_vcpus(kvm);
 
 	kvm_unshare_hyp(kvm, kvm + 1);
+
+	kvm_arm_teardown_hypercalls(kvm);
 }
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 0be974e2f1fc..ba7cd84c6668 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -121,8 +121,58 @@ static bool kvm_smccc_test_fw_bmap(struct kvm_vcpu *vcpu, u32 func_id)
 	}
 }
 
+#define SMCCC_ARCH_RANGE_BEGIN	ARM_SMCCC_VERSION_FUNC_ID
+#define SMCCC_ARCH_RANGE_END				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
+			   ARM_SMCCC_SMC_32,		\
+			   0, ARM_SMCCC_FUNC_MASK)
+
+static void init_smccc_filter(struct kvm *kvm)
+{
+	int r;
+
+	mt_init(&kvm->arch.smccc_filter);
+
+	/*
+	 * Prevent userspace from handling any SMCCC calls in the architecture
+	 * range, avoiding the risk of misrepresenting Spectre mitigation status
+	 * to the guest.
+	 */
+	r = mtree_insert_range(&kvm->arch.smccc_filter,
+			       SMCCC_ARCH_RANGE_BEGIN, SMCCC_ARCH_RANGE_END,
+			       xa_mk_value(KVM_SMCCC_FILTER_HANDLE),
+			       GFP_KERNEL_ACCOUNT);
+	WARN_ON_ONCE(r);
+}
+
+static u8 kvm_smccc_filter_get_action(struct kvm *kvm, u32 func_id)
+{
+	unsigned long idx = func_id;
+	void *val;
+
+	if (!test_bit(KVM_ARCH_FLAG_SMCCC_FILTER_CONFIGURED, &kvm->arch.flags))
+		return KVM_SMCCC_FILTER_HANDLE;
+
+	/*
+	 * But where's the error handling, you say?
+	 *
+	 * mt_find() returns NULL if no entry was found, which just so happens
+	 * to match KVM_SMCCC_FILTER_HANDLE.
+	 */
+	val = mt_find(&kvm->arch.smccc_filter, &idx, idx);
+	return xa_to_value(val);
+}
+
 static u8 kvm_smccc_get_action(struct kvm_vcpu *vcpu, u32 func_id)
 {
+	/*
+	 * Intervening actions in the SMCCC filter take precedence over the
+	 * pseudo-firmware register bitmaps.
+	 */
+	u8 action = kvm_smccc_filter_get_action(vcpu->kvm, func_id);
+	if (action != KVM_SMCCC_FILTER_HANDLE)
+		return action;
+
 	if (kvm_smccc_test_fw_bmap(vcpu, func_id) ||
 	    kvm_smccc_default_allowed(func_id))
 		return KVM_SMCCC_FILTER_HANDLE;
@@ -263,6 +313,13 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
 	smccc_feat->std_bmap = KVM_ARM_SMCCC_STD_FEATURES;
 	smccc_feat->std_hyp_bmap = KVM_ARM_SMCCC_STD_HYP_FEATURES;
 	smccc_feat->vendor_hyp_bmap = KVM_ARM_SMCCC_VENDOR_HYP_FEATURES;
+
+	init_smccc_filter(kvm);
+}
+
+void kvm_arm_teardown_hypercalls(struct kvm *kvm)
+{
+	mtree_destroy(&kvm->arch.smccc_filter);
 }
 
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index 8f4e33bc43e8..fe6c31575b05 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -43,6 +43,7 @@ static inline void smccc_set_retval(struct kvm_vcpu *vcpu,
 struct kvm_one_reg;
 
 void kvm_arm_init_hypercalls(struct kvm *kvm);
+void kvm_arm_teardown_hypercalls(struct kvm *kvm);
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu);
 int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
 int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
-- 
2.40.0.348.gf938b09366-goog

