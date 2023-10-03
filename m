Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0BF17B746E
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 01:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbjJCXEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 19:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbjJCXEZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 19:04:25 -0400
Received: from out-203.mta0.migadu.com (out-203.mta0.migadu.com [91.218.175.203])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD2FAF
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 16:04:21 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696374259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jM6w1WMQ/Yc2/PfaTL1AXvzMaa70DQedsyE60LEQLuw=;
        b=faabb+sFH+VxDpco6svltrPaH1VrmrGLJ8ACK4lgJIsFE5KrTX2rbqLFuGwTxdLBSnswcQ
        oKGD2Mn/wBEZQhnZ8dcKPvIkNIE0MAUvcjZjreXC/6JjAG9jB2uW/J/yOuI36xVmJkKeeF
        ICldCjaHTfz8XaEEUyI70qkeXwMoSrg=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Jing Zhang <jingzhangos@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v11 01/12] KVM: arm64: Allow userspace to get the writable masks for feature ID registers
Date:   Tue,  3 Oct 2023 23:03:57 +0000
Message-ID: <20231003230408.3405722-2-oliver.upton@linux.dev>
In-Reply-To: <20231003230408.3405722-1-oliver.upton@linux.dev>
References: <20231003230408.3405722-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jing Zhang <jingzhangos@google.com>

While the Feature ID range is well defined and pretty large, it isn't
inconceivable that the architecture will eventually grow some other
ranges that will need to similarly be described to userspace.

Add a VM ioctl to allow userspace to get writable masks for feature ID
registers in below system register space:
op0 = 3, op1 = {0, 1, 3}, CRn = 0, CRm = {0 - 7}, op2 = {0 - 7}
This is used to support mix-and-match userspace and kernels for writable
ID registers, where userspace may want to know upfront whether it can
actually tweak the contents of an idreg or not.

Add a new capability (KVM_CAP_ARM_SUPPORTED_FEATURE_ID_RANGES) that
returns a bitmap of the valid ranges, which can subsequently be
retrieved, one at a time by setting the index of the set bit as the
range identifier.

Suggested-by: Marc Zyngier <maz@kernel.org>
Suggested-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  2 +
 arch/arm64/include/uapi/asm/kvm.h | 32 +++++++++++++++
 arch/arm64/kvm/arm.c              | 10 +++++
 arch/arm64/kvm/sys_regs.c         | 66 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |  2 +
 5 files changed, 112 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index af06ccb7ee34..5e3f778f81db 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1078,6 +1078,8 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 			       struct kvm_arm_copy_mte_tags *copy_tags);
 int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
 				    struct kvm_arm_counter_offset *offset);
+int kvm_vm_ioctl_get_reg_writable_masks(struct kvm *kvm,
+					struct reg_mask_range *range);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index f7ddd73a8c0f..89d2fc872d9f 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -505,6 +505,38 @@ struct kvm_smccc_filter {
 #define KVM_HYPERCALL_EXIT_SMC		(1U << 0)
 #define KVM_HYPERCALL_EXIT_16BIT	(1U << 1)
 
+/*
+ * Get feature ID registers userspace writable mask.
+ *
+ * From DDI0487J.a, D19.2.66 ("ID_AA64MMFR2_EL1, AArch64 Memory Model
+ * Feature Register 2"):
+ *
+ * "The Feature ID space is defined as the System register space in
+ * AArch64 with op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7},
+ * op2=={0-7}."
+ *
+ * This covers all currently known R/O registers that indicate
+ * anything useful feature wise, including the ID registers.
+ *
+ * If we ever need to introduce a new range, it will be described as
+ * such in the range field.
+ */
+#define KVM_ARM_FEATURE_ID_RANGE_IDX(op0, op1, crn, crm, op2)		\
+	({								\
+		__u64 __op1 = (op1) & 3;				\
+		__op1 -= (__op1 == 3);					\
+		(__op1 << 6 | ((crm) & 7) << 3 | (op2));		\
+	})
+
+#define KVM_ARM_FEATURE_ID_RANGE	0
+#define KVM_ARM_FEATURE_ID_RANGE_SIZE	(3 * 8 * 8)
+
+struct reg_mask_range {
+	__u64 addr;		/* Pointer to mask array */
+	__u32 range;		/* Requested range */
+	__u32 reserved[13];
+};
+
 #endif
 
 #endif /* __ARM_KVM_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4866b3f7b4ea..f48430ed5b8b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -317,6 +317,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES:
 		r = kvm_supported_block_sizes();
 		break;
+	case KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES:
+		r = BIT(0);
+		break;
 	default:
 		r = 0;
 	}
@@ -1629,6 +1632,13 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 
 		return kvm_vm_set_attr(kvm, &attr);
 	}
+	case KVM_ARM_GET_REG_WRITABLE_MASKS: {
+		struct reg_mask_range range;
+
+		if (copy_from_user(&range, argp, sizeof(range)))
+			return -EFAULT;
+		return kvm_vm_ioctl_get_reg_writable_masks(kvm, &range);
+	}
 	default:
 		return -EINVAL;
 	}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e92ec810d449..5b0e94367f74 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1373,6 +1373,13 @@ static inline bool is_id_reg(u32 id)
 		sys_reg_CRm(id) < 8);
 }
 
+static inline bool is_aa32_id_reg(u32 id)
+{
+	return (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
+		sys_reg_CRn(id) == 0 && sys_reg_CRm(id) >= 1 &&
+		sys_reg_CRm(id) <= 3);
+}
+
 static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
 				  const struct sys_reg_desc *r)
 {
@@ -3572,6 +3579,65 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	return write_demux_regids(uindices);
 }
 
+#define KVM_ARM_FEATURE_ID_RANGE_INDEX(r)			\
+	KVM_ARM_FEATURE_ID_RANGE_IDX(sys_reg_Op0(r),		\
+		sys_reg_Op1(r),					\
+		sys_reg_CRn(r),					\
+		sys_reg_CRm(r),					\
+		sys_reg_Op2(r))
+
+static bool is_feature_id_reg(u32 encoding)
+{
+	return (sys_reg_Op0(encoding) == 3 &&
+		(sys_reg_Op1(encoding) < 2 || sys_reg_Op1(encoding) == 3) &&
+		sys_reg_CRn(encoding) == 0 &&
+		sys_reg_CRm(encoding) <= 7);
+}
+
+int kvm_vm_ioctl_get_reg_writable_masks(struct kvm *kvm, struct reg_mask_range *range)
+{
+	const void *zero_page = page_to_virt(ZERO_PAGE(0));
+	u64 __user *masks = (u64 __user *)range->addr;
+
+	/* Only feature id range is supported, reserved[13] must be zero. */
+	if (range->range ||
+	    memcmp(range->reserved, zero_page, sizeof(range->reserved)))
+		return -EINVAL;
+
+	/* Wipe the whole thing first */
+	if (clear_user(masks, KVM_ARM_FEATURE_ID_RANGE_SIZE * sizeof(__u64)))
+		return -EFAULT;
+
+	for (int i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
+		const struct sys_reg_desc *reg = &sys_reg_descs[i];
+		u32 encoding = reg_to_encoding(reg);
+		u64 val;
+
+		if (!is_feature_id_reg(encoding) || !reg->set_user)
+			continue;
+
+		/*
+		 * For ID registers, we return the writable mask. Other feature
+		 * registers return a full 64bit mask. That's not necessary
+		 * compliant with a given revision of the architecture, but the
+		 * RES0/RES1 definitions allow us to do that.
+		 */
+		if (is_id_reg(encoding)) {
+			if (!reg->val ||
+			    (is_aa32_id_reg(encoding) && !kvm_supports_32bit_el0()))
+				continue;
+			val = reg->val;
+		} else {
+			val = ~0UL;
+		}
+
+		if (put_user(val, (masks + KVM_ARM_FEATURE_ID_RANGE_INDEX(encoding))))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
 int __init kvm_sys_reg_table_init(void)
 {
 	struct sys_reg_params params;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 13065dd96132..f49c84487200 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1192,6 +1192,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_COUNTER_OFFSET 227
 #define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 228
 #define KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES 229
+#define KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES 230
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1562,6 +1563,7 @@ struct kvm_s390_ucas_mapping {
 #define KVM_ARM_MTE_COPY_TAGS	  _IOR(KVMIO,  0xb4, struct kvm_arm_copy_mte_tags)
 /* Available with KVM_CAP_COUNTER_OFFSET */
 #define KVM_ARM_SET_COUNTER_OFFSET _IOW(KVMIO,  0xb5, struct kvm_arm_counter_offset)
+#define KVM_ARM_GET_REG_WRITABLE_MASKS _IOR(KVMIO,  0xb6, struct reg_mask_range)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
-- 
2.42.0.609.gbb76f46606-goog

