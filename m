Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C990066DB1B
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 11:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236328AbjAQKa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 05:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236244AbjAQKaX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 05:30:23 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF09D30EA3
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 02:29:39 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id t5so25664016wrq.1
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 02:29:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T7dOs8PraPWE1t9xSzXacBcTrkVRsrRL2d16NVql0EI=;
        b=w6CUqTkokeNFu7unZ6FuEN33oE3wprxz6Saz53JISurMg7WRgabw68JcBJ7/mMt3B3
         3sh9+tXC+J0mW+q/s/2i+F8fIecdT6Y/y1YkGOEM0h0q+SareFYhQqZazZ0J2Zasim+k
         sEJTe3dTH/iFj2414Nh4rr/QAEVdULtTOTZpdDTGmuC5T5UpouDjLSNnMene7oA4Wc7j
         s5oIYJaRJrl/LdcdXjT2xv6+HtZY4oD4EpGLZxDAEAl05QWNfRXfVJ7NFE/w8KwR1uX3
         Wv/rlhCxOW/uNOFRc+wcG5ciTBXbcFxCcXDocL+5AN2Uu5fn4ZuD2U1VtZg7U/XMtjCM
         x9HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T7dOs8PraPWE1t9xSzXacBcTrkVRsrRL2d16NVql0EI=;
        b=LqDxpk/GPyeJfmvqAcrXoC61cJICz7ji9zLWsVruM2O4LpMd4RlSQPuVSNHes1eN/J
         eVvUTAZkETVRlfOhUwKVPQBb8Z+3MYthZ0bbUdxgMt++FODfqWVacDJI05nSDWUp3cVc
         1OTulNJUMuAWO5vfFLXxgN7zyzV9XJk+aJJLguzebA6gzLpypJ76orKaHQQXRNH4v2Aj
         /JndJvya/UmJEXn/OwFkbJ3Jl5XKB9p9JU3o19Z4QahVLNFwRnxeqKV688wqbKY6da7b
         vbqzFImKDi75IFaS7mx/dOoB1mJF7EJEF+AbxXTXIyFxoKBRThFDCIHP+NbRvgjRfAbT
         z/gQ==
X-Gm-Message-State: AFqh2krELFatQhSVP800TKw2AAOC+hmWvoTi+/F6/qX+PpvHdgkg+jHm
        MVlhMdpAuRjRMQJih7SbY78cmQ==
X-Google-Smtp-Source: AMrXdXu8DXv15Zxq9n9HfzexG7yCtiKyYedtG4MJvUn1ctjQL/mEVVE5ta5JrwX60raCFdEwuqMLrw==
X-Received: by 2002:a5d:5451:0:b0:2ba:4ee8:d708 with SMTP id w17-20020a5d5451000000b002ba4ee8d708mr2449695wrv.32.1673951378355;
        Tue, 17 Jan 2023 02:29:38 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:17d8:e5ec:f870:7b46])
        by smtp.gmail.com with ESMTPSA id j15-20020a5d452f000000b0028f9132e9ddsm28389844wra.39.2023.01.17.02.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 02:29:38 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        maz@kernel.org, steven.price@arm.com, mark.rutland@arm.com,
        bagasdotme@gmail.com, pbonzini@redhat.com
Cc:     fam.zheng@bytedance.com, liangma@liangbit.com,
        punit.agrawal@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [v3 3/6] KVM: arm64: Support pvlock preempted via shared structure
Date:   Tue, 17 Jan 2023 10:29:27 +0000
Message-Id: <20230117102930.1053337-4-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230117102930.1053337-1-usama.arif@bytedance.com>
References: <20230117102930.1053337-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement the service call for configuring a shared structure between a
VCPU and the hypervisor in which the hypervisor can tell whether the
VCPU is running or not.

The preempted field is zero if the VCPU is not preempted.
Any other value means the VCPU has been preempted.

Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 Documentation/virt/kvm/arm/hypercalls.rst |  3 ++
 arch/arm64/include/asm/kvm_host.h         | 18 ++++++++++
 arch/arm64/include/uapi/asm/kvm.h         |  1 +
 arch/arm64/kvm/Makefile                   |  2 +-
 arch/arm64/kvm/arm.c                      |  8 +++++
 arch/arm64/kvm/hypercalls.c               |  8 +++++
 arch/arm64/kvm/pvlock.c                   | 43 +++++++++++++++++++++++
 tools/arch/arm64/include/uapi/asm/kvm.h   |  1 +
 8 files changed, 83 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/pvlock.c

diff --git a/Documentation/virt/kvm/arm/hypercalls.rst b/Documentation/virt/kvm/arm/hypercalls.rst
index 3e23084644ba..872a16226ace 100644
--- a/Documentation/virt/kvm/arm/hypercalls.rst
+++ b/Documentation/virt/kvm/arm/hypercalls.rst
@@ -127,6 +127,9 @@ The pseudo-firmware bitmap register are as follows:
     Bit-1: KVM_REG_ARM_VENDOR_HYP_BIT_PTP:
       The bit represents the Precision Time Protocol KVM service.
 
+    Bit-2: KVM_REG_ARM_VENDOR_HYP_BIT_PV_LOCK:
+      The bit represents the Paravirtualized lock service.
+
 Errors:
 
     =======  =============================================================
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 35a159d131b5..1d1acc5be8d7 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -501,6 +501,11 @@ struct kvm_vcpu_arch {
 		u64 last_steal;
 		gpa_t base;
 	} steal;
+
+	/* Guest PV lock state */
+	struct {
+		gpa_t base;
+	} pv_lock;
 };
 
 /*
@@ -924,6 +929,19 @@ static inline bool kvm_arm_is_pvtime_enabled(struct kvm_vcpu_arch *vcpu_arch)
 	return (vcpu_arch->steal.base != GPA_INVALID);
 }
 
+static inline void kvm_arm_pvlock_preempted_init(struct kvm_vcpu_arch *vcpu_arch)
+{
+	vcpu_arch->pv_lock.base = GPA_INVALID;
+}
+
+static inline bool kvm_arm_is_pvlock_preempted_ready(struct kvm_vcpu_arch *vcpu_arch)
+{
+	return (vcpu_arch->pv_lock.base != GPA_INVALID);
+}
+
+gpa_t kvm_init_pvlock(struct kvm_vcpu *vcpu);
+void kvm_update_pvlock_preempted(struct kvm_vcpu *vcpu, u64 preempted);
+
 void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 syndrome);
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index a7a857f1784d..34dd6df3f8eb 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -366,6 +366,7 @@ enum {
 enum {
 	KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT	= 0,
 	KVM_REG_ARM_VENDOR_HYP_BIT_PTP		= 1,
+	KVM_REG_ARM_VENDOR_HYP_BIT_PV_LOCK	= 2,
 #ifdef __KERNEL__
 	KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_COUNT,
 #endif
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 5e33c2d4645a..e1f711885916 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -10,7 +10,7 @@ include $(srctree)/virt/kvm/Makefile.kvm
 obj-$(CONFIG_KVM) += kvm.o
 obj-$(CONFIG_KVM) += hyp/
 
-kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
+kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o pvlock.o \
 	 inject_fault.o va_layout.o handle_exit.o \
 	 guest.o debug.o reset.o sys_regs.o stacktrace.o \
 	 vgic-sys-reg-v3.o fpsimd.o pkvm.o \
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9c5573bc4614..5808e6695f75 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -357,6 +357,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	kvm_arm_pvtime_vcpu_init(&vcpu->arch);
 
+	kvm_arm_pvlock_preempted_init(&vcpu->arch);
+
 	vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
 
 	err = kvm_vgic_vcpu_init(vcpu);
@@ -432,6 +434,10 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	if (vcpu_has_ptrauth(vcpu))
 		vcpu_ptrauth_disable(vcpu);
+
+	if (kvm_arm_is_pvlock_preempted_ready(&vcpu->arch))
+		kvm_update_pvlock_preempted(vcpu, 0);
+
 	kvm_arch_vcpu_load_debug_state_flags(vcpu);
 
 	if (!cpumask_test_cpu(smp_processor_id(), vcpu->kvm->arch.supported_cpus))
@@ -445,6 +451,8 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	if (has_vhe())
 		kvm_vcpu_put_sysregs_vhe(vcpu);
 	kvm_timer_vcpu_put(vcpu);
+	if (kvm_arm_is_pvlock_preempted_ready(&vcpu->arch))
+		kvm_update_pvlock_preempted(vcpu, 1);
 	kvm_vgic_put(vcpu);
 	kvm_vcpu_pmu_restore_host(vcpu);
 	kvm_arm_vmid_clear_active();
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index c9f401fa01a9..ec85b4b2a272 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -116,6 +116,9 @@ static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
 	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
 		return test_bit(KVM_REG_ARM_VENDOR_HYP_BIT_PTP,
 				&smccc_feat->vendor_hyp_bmap);
+	case ARM_SMCCC_VENDOR_HYP_KVM_PV_LOCK_FUNC_ID:
+		return test_bit(KVM_REG_ARM_VENDOR_HYP_BIT_PV_LOCK,
+				&smccc_feat->vendor_hyp_bmap);
 	default:
 		return kvm_hvc_call_default_allowed(func_id);
 	}
@@ -201,6 +204,11 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		if (gpa != GPA_INVALID)
 			val[0] = gpa;
 		break;
+	case ARM_SMCCC_VENDOR_HYP_KVM_PV_LOCK_FUNC_ID:
+		gpa = kvm_init_pvlock(vcpu);
+		if (gpa != GPA_INVALID)
+			val[0] = gpa;
+		break;
 	case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
 		val[0] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_0;
 		val[1] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_1;
diff --git a/arch/arm64/kvm/pvlock.c b/arch/arm64/kvm/pvlock.c
new file mode 100644
index 000000000000..228d24bfe281
--- /dev/null
+++ b/arch/arm64/kvm/pvlock.c
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright(c) 2019 Huawei Technologies Co., Ltd
+ * Author: Zengruan Ye <yezengruan@huawei.com>
+ *         Usama Arif <usama.arif@bytedance.com>
+ */
+
+#include <linux/arm-smccc.h>
+#include <linux/kvm_host.h>
+
+#include <asm/pvlock-abi.h>
+
+#include <kvm/arm_hypercalls.h>
+
+gpa_t kvm_init_pvlock(struct kvm_vcpu *vcpu)
+{
+	struct pvlock_vcpu_state init_values = {};
+	struct kvm *kvm = vcpu->kvm;
+	u64 base = vcpu->arch.pv_lock.base;
+	int idx;
+
+	if (base == GPA_INVALID)
+		return base;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	kvm_write_guest(kvm, base, &init_values, sizeof(init_values));
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	return base;
+}
+
+void kvm_update_pvlock_preempted(struct kvm_vcpu *vcpu, u64 preempted)
+{
+	int idx;
+	u64 offset;
+	struct kvm *kvm = vcpu->kvm;
+	u64 base = vcpu->arch.pv_lock.base;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	offset = offsetof(struct pvlock_vcpu_state, preempted);
+	kvm_put_guest(kvm, base + offset, cpu_to_le64(preempted));
+	srcu_read_unlock(&kvm->srcu, idx);
+}
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/include/uapi/asm/kvm.h
index 316917b98707..bd05ece5c590 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -365,6 +365,7 @@ enum {
 enum {
 	KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT	= 0,
 	KVM_REG_ARM_VENDOR_HYP_BIT_PTP		= 1,
+	KVM_REG_ARM_VENDOR_HYP_BIT_PV_LOCK	= 2,
 #ifdef __KERNEL__
 	KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_COUNT,
 #endif
-- 
2.25.1

