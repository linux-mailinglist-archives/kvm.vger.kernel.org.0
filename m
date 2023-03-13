Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF656B77FE
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 13:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbjCMMtO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 08:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbjCMMtC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 08:49:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12272DE60
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 05:48:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D785CB810B9
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 12:48:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616CFC433A7;
        Mon, 13 Mar 2023 12:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678711735;
        bh=EwxhR0jlhg4TmjwhkeNEDmh/WyqaKbEWp3FbuHlAzO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=quzY6rRWEjuBoeAcg2upbnvksFZSilc8I/1qOUa6U/LU3N+XNtPIZK2Y8yLKrUh9a
         qYwOp8d//6hz+r2J7f+Y2Y7gSYr/Y/Ou2QxooHsmC6Jpem15ulQNtidFPMeVQQs65l
         0F4Of3L05fTtEe6hLLzY+Jmtal7Uy+GgZ6g+7Csbt6iMvJTii9lWpT5LhgP1oroF5n
         5SDuzaBPqhhvfdb+t4qkznwt2DfSQXWYj/R+IGwEpDydfiyj7S8POTCQNvH6TpM2J6
         /RBV/Ns9W00yyi19x8iY00uwTg/cloVvckrKjIwtk4gzXb6UvjCA37bCpsDbVhWRx9
         apqCNRI2Aoduw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pbhbh-00HEdE-FO;
        Mon, 13 Mar 2023 12:48:53 +0000
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
Subject: [PATCH v2 08/19] KVM: arm64: timers: Allow userspace to set the global counter offset
Date:   Mon, 13 Mar 2023 12:48:26 +0000
Message-Id: <20230313124837.2264882-9-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230313124837.2264882-1-maz@kernel.org>
References: <20230313124837.2264882-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, reijiw@google.com, coltonlewis@google.com, joey.gouly@arm.com, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 097750a01497..1d1c54d1ec15 100644
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

