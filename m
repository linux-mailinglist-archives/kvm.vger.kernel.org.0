Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5471E623946
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 02:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232378AbiKJBye (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 20:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbiKJBy1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 20:54:27 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88D5B860;
        Wed,  9 Nov 2022 17:54:26 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668045261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e4NKzeDtoFaN8kBUL712bSOeRfxgXb7x1ONm16Q4y+o=;
        b=r+LeK2mnGqElNPkM/9TRPhVOvTFfQU8Rq0YfxxyXVdeML0jqbULDujWLfU8U1jjDWCD4C2
        bVcdvjUU6nvu6U93vhCJgsXxxiFjIGkI2iLdiUr8nLHnlO2oEX2LmV4/c/k87TwZDZINUN
        A0g7LwBg2Bp+kUYlRQ7hek5somRyq2I=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Raghavendra Rao Ananta <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [RFC PATCH 2/3] KVM: arm64: Allow userspace to trap SMCCC sub-ranges
Date:   Thu, 10 Nov 2022 01:53:26 +0000
Message-Id: <20221110015327.3389351-3-oliver.upton@linux.dev>
In-Reply-To: <20221110015327.3389351-1-oliver.upton@linux.dev>
References: <20221110015327.3389351-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As the SMCCC (and related specifications) march towards an
'everything and the kitchen sink' interface for interacting with a
system, it is less likely that KVM will implement every supported
feature.

Add a capability that allows userspace to trap hypercall ranges,
allowing the VMM to mix-and-match between calls handled in userspace vs.
KVM.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  5 ++++
 arch/arm64/include/uapi/asm/kvm.h | 15 ++++++++++
 arch/arm64/kvm/arm.c              | 10 +++++++
 arch/arm64/kvm/hypercalls.c       | 48 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |  1 +
 5 files changed, 79 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e33ed7c09a28..cc3872f1900c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -52,6 +52,9 @@
 
 #define KVM_HAVE_MMU_RWLOCK
 
+#define KVM_ARM_USER_HYPERCALL_FLAGS	\
+		GENMASK_ULL(KVM_ARM_USER_HYPERCALL_FLAGS_COUNT - 1, 0)
+
 /*
  * Mode of operation configurable with kvm-arm.mode early param.
  * See Documentation/admin-guide/kernel-parameters.txt for more information.
@@ -104,11 +107,13 @@ struct kvm_arch_memory_slot {
 /**
  * struct kvm_smccc_features: Descriptor of the hypercall services exposed to the guests
  *
+ * @user_trap_bmap: Bitmap of SMCCC function ranges trapped to userspace
  * @std_bmap: Bitmap of standard secure service calls
  * @std_hyp_bmap: Bitmap of standard hypervisor service calls
  * @vendor_hyp_bmap: Bitmap of vendor specific hypervisor service calls
  */
 struct kvm_smccc_features {
+	unsigned long user_trap_bmap;
 	unsigned long std_bmap;
 	unsigned long std_hyp_bmap;
 	unsigned long vendor_hyp_bmap;
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 316917b98707..07fa3f597e61 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -370,6 +370,21 @@ enum {
 #endif
 };
 
+enum {
+	KVM_ARM_USER_HYPERCALL_OWNER_ARCH		= 0,
+	KVM_ARM_USER_HYPERCALL_OWNER_CPU		= 1,
+	KVM_ARM_USER_HYPERCALL_OWNER_SIP		= 2,
+	KVM_ARM_USER_HYPERCALL_OWNER_OEM		= 3,
+	KVM_ARM_USER_HYPERCALL_OWNER_STANDARD		= 4,
+	KVM_ARM_USER_HYPERCALL_OWNER_STANDARD_HYP	= 5,
+	KVM_ARM_USER_HYPERCALL_OWNER_VENDOR_HYP		= 6,
+	KVM_ARM_USER_HYPERCALL_OWNER_TRUSTED_APP	= 7,
+	KVM_ARM_USER_HYPERCALL_OWNER_TRUSTED_OS		= 8,
+#ifdef __KERNEL__
+	KVM_ARM_USER_HYPERCALL_FLAGS_COUNT,
+#endif
+};
+
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
 #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 6f0b56e7f8c7..6e8a222fc295 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -100,6 +100,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		r = 0;
 		set_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags);
 		break;
+	case KVM_CAP_ARM_USER_HYPERCALLS:
+		if (cap->args[0] & ~KVM_ARM_USER_HYPERCALL_FLAGS)
+			return -EINVAL;
+
+		r = 0;
+		kvm->arch.smccc_feat.user_trap_bmap = cap->args[0];
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -285,6 +292,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
 		r = system_has_full_ptr_auth();
 		break;
+	case KVM_CAP_ARM_USER_HYPERCALLS:
+		r = KVM_ARM_USER_HYPERCALL_FLAGS;
+		break;
 	default:
 		r = 0;
 	}
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 62ce45d0d957..22a23b12201d 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -92,6 +92,49 @@ static bool kvm_hvc_call_default_allowed(u32 func_id)
 	}
 }
 
+static bool kvm_hvc_call_user_trapped(struct kvm_vcpu *vcpu, u32 func_id)
+{
+	struct kvm *kvm = vcpu->kvm;
+	unsigned long *bmap = &kvm->arch.smccc_feat.user_trap_bmap;
+
+	switch (ARM_SMCCC_OWNER_NUM(func_id)) {
+	case ARM_SMCCC_OWNER_ARCH:
+		return test_bit(KVM_ARM_USER_HYPERCALL_OWNER_ARCH, bmap);
+	case ARM_SMCCC_OWNER_CPU:
+		return test_bit(KVM_ARM_USER_HYPERCALL_OWNER_CPU, bmap);
+	case ARM_SMCCC_OWNER_SIP:
+		return test_bit(KVM_ARM_USER_HYPERCALL_OWNER_SIP, bmap);
+	case ARM_SMCCC_OWNER_OEM:
+		return test_bit(KVM_ARM_USER_HYPERCALL_OWNER_OEM, bmap);
+	case ARM_SMCCC_OWNER_STANDARD:
+		return test_bit(KVM_ARM_USER_HYPERCALL_OWNER_STANDARD, bmap);
+	case ARM_SMCCC_OWNER_STANDARD_HYP:
+		return test_bit(KVM_ARM_USER_HYPERCALL_OWNER_STANDARD_HYP, bmap);
+	case ARM_SMCCC_OWNER_VENDOR_HYP:
+		return test_bit(KVM_ARM_USER_HYPERCALL_OWNER_VENDOR_HYP, bmap);
+	case ARM_SMCCC_OWNER_TRUSTED_APP ... ARM_SMCCC_OWNER_TRUSTED_APP_END:
+		return test_bit(KVM_ARM_USER_HYPERCALL_OWNER_TRUSTED_APP, bmap);
+	case ARM_SMCCC_OWNER_TRUSTED_OS ... ARM_SMCCC_OWNER_TRUSTED_OS_END:
+		return test_bit(KVM_ARM_USER_HYPERCALL_OWNER_TRUSTED_OS, bmap);
+	default:
+		return false;
+	}
+}
+
+static void kvm_hvc_prepare_user_trap(struct kvm_vcpu *vcpu)
+{
+	struct kvm_run *run = vcpu->run;
+
+	run->exit_reason	= KVM_EXIT_HYPERCALL;
+	run->hypercall.nr	= smccc_get_function(vcpu);
+	run->hypercall.args[0]	= smccc_get_arg(vcpu, 1);
+	run->hypercall.args[1]	= smccc_get_arg(vcpu, 2);
+	run->hypercall.args[2]	= smccc_get_arg(vcpu, 3);
+	run->hypercall.args[3]	= smccc_get_arg(vcpu, 4);
+	run->hypercall.args[4]	= smccc_get_arg(vcpu, 5);
+	run->hypercall.args[5]	= smccc_get_arg(vcpu, 6);
+}
+
 static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
 {
 	struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
@@ -128,6 +171,11 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 	u32 feature;
 	gpa_t gpa;
 
+	if (kvm_hvc_call_user_trapped(vcpu, func_id)) {
+		kvm_hvc_prepare_user_trap(vcpu);
+		return 0;
+	}
+
 	if (!kvm_hvc_call_allowed(vcpu, func_id))
 		goto out;
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0d5d4419139a..ea6c1983a545 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1178,6 +1178,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_ZPCI_OP 221
 #define KVM_CAP_S390_CPU_TOPOLOGY 222
 #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
+#define KVM_CAP_ARM_USER_HYPERCALLS 224
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.38.1.431.g37b22c650d-goog

