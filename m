Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C212699727
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 15:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjBPOWL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 09:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbjBPOWC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 09:22:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6147A4740F
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 06:21:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 517E5614C3
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 14:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04AA3C433AA;
        Thu, 16 Feb 2023 14:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676557311;
        bh=EtZLldqArs/j5fGVMQwH6CKspKnc+u3YDXjWSqhCQBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QBIRS8OPL64//vUzDtfC/49Sa5zv7dIfYQgRdFI5x0UV//U7GDX7fG97FbkirZdS5
         GWMdLjDiFf8QLcit/IGpVK5gg77FuLsRJxFvae4W8NHS8CUAEW41lEdx0+lJm/LvCl
         5GgaUhxdWUspAeZBy+QgOo7tIZ03ovsJ4l1KZr/IMB76xvaCkFZAZOarANnRCJJP6N
         er2UxXd9GEXPEUDd2RXcn5kUhlJp6x3QrGgSfwlS6q2EbWdLTWGQ888Kan7xcbiMGV
         nVmFQOZRXVD73EATkXB+kcF7oNE1HuqE7g1qN77Fk1JrWYMnsSUx4TQDVYUSf48v30
         DGLxXl8+94dsg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pSf8v-00AuwB-1p;
        Thu, 16 Feb 2023 14:21:49 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>, dwmw2@infradead.org
Subject: [PATCH 08/16] KVM: arm64: timers: Allow userspace to set the counter offsets
Date:   Thu, 16 Feb 2023 14:21:15 +0000
Message-Id: <20230216142123.2638675-9-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230216142123.2638675-1-maz@kernel.org>
References: <20230216142123.2638675-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

And this is the moment you have all been waiting for: setting the
counter offsets from userspace.

We expose a brand new capability that reports the ability to set
the offsets for both the virtual and physical sides, independently.

In keeping with the architecture, the offsets are expressed as
a delta that is substracted from the physical counter value.

Once this new API is used, there is no going back, and the counters
cannot be written to to set the offsets implicitly (the writes
are instead ignored).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  4 +++
 arch/arm64/include/uapi/asm/kvm.h | 15 ++++++++++
 arch/arm64/kvm/arch_timer.c       | 46 +++++++++++++++++++++++++++----
 arch/arm64/kvm/arm.c              |  8 ++++++
 include/uapi/linux/kvm.h          |  3 ++
 5 files changed, 71 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3adac0c5e175..8514a37cf8d5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -221,6 +221,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_EL1_32BIT				4
 	/* PSCI SYSTEM_SUSPEND enabled for the guest */
 #define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED		5
+	/* VM counter offsets */
+#define KVM_ARCH_FLAG_COUNTER_OFFSETS			6
 
 	unsigned long flags;
 
@@ -1010,6 +1012,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 
 long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				struct kvm_arm_copy_mte_tags *copy_tags);
+int kvm_vm_ioctl_set_counter_offsets(struct kvm *kvm,
+				     struct kvm_arm_counter_offsets *offsets);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index f8129c624b07..2d7557a160bd 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -198,6 +198,21 @@ struct kvm_arm_copy_mte_tags {
 	__u64 reserved[2];
 };
 
+/*
+ * Counter/Timer offset structure. Describe the virtual/physical offsets.
+ * To be used with KVM_ARM_SET_CNT_OFFSETS.
+ */
+struct kvm_arm_counter_offsets {
+	__u64 virtual_offset;
+	__u64 physical_offset;
+
+#define KVM_COUNTER_SET_VOFFSET_FLAG	(1UL << 0)
+#define KVM_COUNTER_SET_POFFSET_FLAG	(1UL << 1)
+
+	__u64 flags;
+	__u64 reserved;
+};
+
 #define KVM_ARM_TAGS_TO_GUEST		0
 #define KVM_ARM_TAGS_FROM_GUEST		1
 
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 444ea6dca218..b04544b702f9 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -852,9 +852,11 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 	ptimer->vcpu = vcpu;
 	ptimer->offset.vm_offset = &vcpu->kvm->arch.offsets.poffset;
 
-	/* Synchronize cntvoff across all vtimers of a VM. */
-	timer_set_offset(vtimer, kvm_phys_timer_read());
-	timer_set_offset(ptimer, 0);
+	/* Synchronize offsets across timers of a VM if not already provided */
+	if (!test_bit(KVM_ARCH_FLAG_COUNTER_OFFSETS, &vcpu->kvm->arch.flags)) {
+		timer_set_offset(vtimer, kvm_phys_timer_read());
+		timer_set_offset(ptimer, 0);
+	}
 
 	hrtimer_init(&timer->bg_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
 	timer->bg_timer.function = kvm_bg_timer_expire;
@@ -898,8 +900,11 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
 		kvm_arm_timer_write(vcpu, timer, TIMER_REG_CTL, value);
 		break;
 	case KVM_REG_ARM_TIMER_CNT:
-		timer = vcpu_vtimer(vcpu);
-		timer_set_offset(timer, kvm_phys_timer_read() - value);
+		if (!test_bit(KVM_ARCH_FLAG_COUNTER_OFFSETS,
+			      &vcpu->kvm->arch.flags)) {
+			timer = vcpu_vtimer(vcpu);
+			timer_set_offset(timer, kvm_phys_timer_read() - value);
+		}
 		break;
 	case KVM_REG_ARM_TIMER_CVAL:
 		timer = vcpu_vtimer(vcpu);
@@ -909,6 +914,13 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
 		timer = vcpu_ptimer(vcpu);
 		kvm_arm_timer_write(vcpu, timer, TIMER_REG_CTL, value);
 		break;
+	case KVM_REG_ARM_PTIMER_CNT:
+		if (!test_bit(KVM_ARCH_FLAG_COUNTER_OFFSETS,
+			      &vcpu->kvm->arch.flags)) {
+			timer = vcpu_ptimer(vcpu);
+			timer_set_offset(timer, kvm_phys_timer_read() - value);
+		}
+		break;
 	case KVM_REG_ARM_PTIMER_CVAL:
 		timer = vcpu_ptimer(vcpu);
 		kvm_arm_timer_write(vcpu, timer, TIMER_REG_CVAL, value);
@@ -1446,3 +1458,27 @@ int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 	return -ENXIO;
 }
+
+int kvm_vm_ioctl_set_counter_offsets(struct kvm *kvm,
+				     struct kvm_arm_counter_offsets *offsets)
+{
+	if (offsets->reserved ||
+	    (offsets->flags & ~(KVM_COUNTER_SET_VOFFSET_FLAG |
+				KVM_COUNTER_SET_POFFSET_FLAG)))
+		return -EINVAL;
+
+	if (!lock_all_vcpus(kvm))
+		return -EBUSY;
+
+	set_bit(KVM_ARCH_FLAG_COUNTER_OFFSETS, &kvm->arch.flags);
+
+	if (offsets->flags & KVM_COUNTER_SET_VOFFSET_FLAG)
+		kvm->arch.offsets.voffset = offsets->virtual_offset;
+
+	if (offsets->flags & KVM_COUNTER_SET_POFFSET_FLAG)
+		kvm->arch.offsets.poffset = offsets->physical_offset;
+
+	unlock_all_vcpus(kvm);
+
+	return 0;
+}
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 097750a01497..1182d8ce7319 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -220,6 +220,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
+	case KVM_CAP_COUNTER_OFFSETS:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
@@ -1479,6 +1480,13 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			return -EFAULT;
 		return kvm_vm_ioctl_mte_copy_tags(kvm, &copy_tags);
 	}
+	case KVM_ARM_SET_CNT_OFFSETS: {
+		struct kvm_arm_counter_offsets offsets;
+
+		if (copy_from_user(&offsets, argp, sizeof(offsets)))
+			return -EFAULT;
+		return kvm_vm_ioctl_set_counter_offsets(kvm, &offsets);
+	}
 	default:
 		return -EINVAL;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 55155e262646..3753765dbc4f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1175,6 +1175,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
 #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
 #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
+#define KVM_CAP_COUNTER_OFFSETS 226
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1534,6 +1535,8 @@ struct kvm_s390_ucas_mapping {
 #define KVM_SET_PMU_EVENT_FILTER  _IOW(KVMIO,  0xb2, struct kvm_pmu_event_filter)
 #define KVM_PPC_SVM_OFF		  _IO(KVMIO,  0xb3)
 #define KVM_ARM_MTE_COPY_TAGS	  _IOR(KVMIO,  0xb4, struct kvm_arm_copy_mte_tags)
+/* Available with KVM_CAP_COUNTER_OFFSETS */
+#define KVM_ARM_SET_CNT_OFFSETS	  _IOW(KVMIO,  0xb5, struct kvm_arm_counter_offsets)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
-- 
2.34.1

