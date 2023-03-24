Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860606C8037
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 15:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbjCXOrc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 10:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbjCXOrX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 10:47:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDDE19C59
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 07:47:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A4C662B54
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 14:47:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FF2C433A7;
        Fri, 24 Mar 2023 14:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679669240;
        bh=u28pxRIYxvg/teRjoH2iIC+k52lFEVgXijlcun+7hcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B7mVEgm7E90cS/wJuX7uREsTbkTjRdhtc/xDQBgIzp3JKHTsDdI84PWiMax0R5qZM
         VDalbenTzRYH2nSy5Li1jyRZOdn+VgGFuEdlVHVC+qkrWjE1jCHFIdSr7BDKP/jcjq
         7D0qCfli3yHvmN9R9rXrdPuSqDfh+TY6hjpcEwBjrcPp8Fp3A47/Q8K5C9beOSo1bq
         fYDarwqcFtQd+PFI4O2AYYpIeOu+7fAWGOtVyUKx1V5uXAenNPzCtfdztuRvdkpJ8m
         z/XsNUaRKAOF0vKR3CNH4jmLVSHbHSiOSgQ9LT9DB2Oo/vIxb9jZO32oCGzvw55Veh
         NwwwE9oa/v42Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pfihK-002qBP-Lj;
        Fri, 24 Mar 2023 14:47:18 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Joey Gouly <joey.gouly@arm.com>, dwmw2@infradead.org
Subject: [PATCH v3 07/18] KVM: arm64: timers: Allow userspace to set the global counter offset
Date:   Fri, 24 Mar 2023 14:46:53 +0000
Message-Id: <20230324144704.4193635-8-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230324144704.4193635-1-maz@kernel.org>
References: <20230324144704.4193635-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, reijiw@google.com, coltonlewis@google.com, joey.gouly@arm.com, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

And this is the moment you have all been waiting for: setting the
counter offset from userspace.

We expose a brand new capability that reports the ability to set
the offset for both the virtual and physical sides.

In keeping with the architecture, the offset is expressed as
a delta that is substracted from the physical counter value.

Once this new API is used, there is no going back, and the counters
cannot be written to to set the offsets implicitly (the writes
are instead ignored).

Reviewed-by: Colton Lewis <coltonlewis@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  4 +++
 arch/arm64/include/uapi/asm/kvm.h |  9 ++++++
 arch/arm64/kvm/arch_timer.c       | 46 +++++++++++++++++++++++++++----
 arch/arm64/kvm/arm.c              |  8 ++++++
 include/uapi/linux/kvm.h          |  3 ++
 5 files changed, 65 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 002a10cbade2..116233a390e9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -221,6 +221,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_EL1_32BIT				4
 	/* PSCI SYSTEM_SUSPEND enabled for the guest */
 #define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED		5
+	/* VM counter offset */
+#define KVM_ARCH_FLAG_VM_COUNTER_OFFSET			6
 
 	unsigned long flags;
 
@@ -1010,6 +1012,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 
 long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				struct kvm_arm_copy_mte_tags *copy_tags);
+int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
+				    struct kvm_arm_counter_offset *offset);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index f8129c624b07..12fb0d8a760a 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -198,6 +198,15 @@ struct kvm_arm_copy_mte_tags {
 	__u64 reserved[2];
 };
 
+/*
+ * Counter/Timer offset structure. Describe the virtual/physical offset.
+ * To be used with KVM_ARM_SET_COUNTER_OFFSET.
+ */
+struct kvm_arm_counter_offset {
+	__u64 counter_offset;
+	__u64 reserved;
+};
+
 #define KVM_ARM_TAGS_TO_GUEST		0
 #define KVM_ARM_TAGS_FROM_GUEST		1
 
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index bb64a71ae193..25625e1d6d89 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -851,9 +851,11 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 	ptimer->vcpu = vcpu;
 	ptimer->offset.vm_offset = &vcpu->kvm->arch.timer_data.poffset;
 
-	/* Synchronize cntvoff across all vtimers of a VM. */
-	timer_set_offset(vtimer, kvm_phys_timer_read());
-	timer_set_offset(ptimer, 0);
+	/* Synchronize offsets across timers of a VM if not already provided */
+	if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
+		timer_set_offset(vtimer, kvm_phys_timer_read());
+		timer_set_offset(ptimer, 0);
+	}
 
 	hrtimer_init(&timer->bg_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
 	timer->bg_timer.function = kvm_bg_timer_expire;
@@ -897,8 +899,11 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
 		kvm_arm_timer_write(vcpu, timer, TIMER_REG_CTL, value);
 		break;
 	case KVM_REG_ARM_TIMER_CNT:
-		timer = vcpu_vtimer(vcpu);
-		timer_set_offset(timer, kvm_phys_timer_read() - value);
+		if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET,
+			      &vcpu->kvm->arch.flags)) {
+			timer = vcpu_vtimer(vcpu);
+			timer_set_offset(timer, kvm_phys_timer_read() - value);
+		}
 		break;
 	case KVM_REG_ARM_TIMER_CVAL:
 		timer = vcpu_vtimer(vcpu);
@@ -908,6 +913,13 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
 		timer = vcpu_ptimer(vcpu);
 		kvm_arm_timer_write(vcpu, timer, TIMER_REG_CTL, value);
 		break;
+	case KVM_REG_ARM_PTIMER_CNT:
+		if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET,
+			      &vcpu->kvm->arch.flags)) {
+			timer = vcpu_ptimer(vcpu);
+			timer_set_offset(timer, kvm_phys_timer_read() - value);
+		}
+		break;
 	case KVM_REG_ARM_PTIMER_CVAL:
 		timer = vcpu_ptimer(vcpu);
 		kvm_arm_timer_write(vcpu, timer, TIMER_REG_CVAL, value);
@@ -1443,3 +1455,27 @@ int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 	return -ENXIO;
 }
+
+int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
+				    struct kvm_arm_counter_offset *offset)
+{
+	if (offset->reserved)
+		return -EINVAL;
+
+	if (!lock_all_vcpus(kvm))
+		return -EBUSY;
+
+	set_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &kvm->arch.flags);
+
+	/*
+	 * If userspace decides to set the offset using this API rather
+	 * than merely restoring the counter values, the offset applies
+	 * to both the virtual and physical views.
+	 */
+	kvm->arch.timer_data.voffset = offset->counter_offset;
+	kvm->arch.timer_data.poffset = offset->counter_offset;
+
+	unlock_all_vcpus(kvm);
+
+	return 0;
+}
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ae5110cc3bad..1c8a4bbae684 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -220,6 +220,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
+	case KVM_CAP_COUNTER_OFFSET:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
@@ -1479,6 +1480,13 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			return -EFAULT;
 		return kvm_vm_ioctl_mte_copy_tags(kvm, &copy_tags);
 	}
+	case KVM_ARM_SET_COUNTER_OFFSET: {
+		struct kvm_arm_counter_offset offset;
+
+		if (copy_from_user(&offset, argp, sizeof(offset)))
+			return -EFAULT;
+		return kvm_vm_ioctl_set_counter_offset(kvm, &offset);
+	}
 	default:
 		return -EINVAL;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d77aef872a0a..6a7e1a0ecf04 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1184,6 +1184,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
 #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
 #define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
+#define KVM_CAP_COUNTER_OFFSET 227
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1543,6 +1544,8 @@ struct kvm_s390_ucas_mapping {
 #define KVM_SET_PMU_EVENT_FILTER  _IOW(KVMIO,  0xb2, struct kvm_pmu_event_filter)
 #define KVM_PPC_SVM_OFF		  _IO(KVMIO,  0xb3)
 #define KVM_ARM_MTE_COPY_TAGS	  _IOR(KVMIO,  0xb4, struct kvm_arm_copy_mte_tags)
+/* Available with KVM_CAP_COUNTER_OFFSET */
+#define KVM_ARM_SET_COUNTER_OFFSET _IOW(KVMIO,  0xb5, struct kvm_arm_counter_offset)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
-- 
2.34.1

