Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7F804FAA6B
	for <lists+kvm@lfdr.de>; Sat,  9 Apr 2022 20:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243107AbiDISsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Apr 2022 14:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243104AbiDISsQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Apr 2022 14:48:16 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372A1238675
        for <kvm@vger.kernel.org>; Sat,  9 Apr 2022 11:46:07 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id o15-20020a056e02092f00b002ca7b493a07so4849173ilt.21
        for <kvm@vger.kernel.org>; Sat, 09 Apr 2022 11:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zj2+euUL3auyx6dpsodC/84HnUVSm/J2G8LuVpKVDAk=;
        b=M8Ftpz4KqpDX2B7qeSY2qkVQ6eB1sD31ORPYYzuUn6ACmk/ohZ8nFK1yexc1Gi9IE0
         vT+F4kVhm9DIU73abVUFDQaCBaVwGtnyQLg75YQ2Mxxej/ZyD1clNaqJWCSBXBLyJcXd
         6zAoxNQt8PSOTTZmXTZ9KIssaHDVitxGgoDYXQlWkoKPC4QX4Vgs4dJP4xsy/d7prYbr
         7II/qE3H/k+/IM7ZWenrXuVaSVbciJ0FO3SEKTEwpiEYPPNbgT61cMS2XxGb6G1IJ7FB
         Et6U/+SGkebXhGah4fE3AGIUpR0KmhPnJdUEnbd8cEbj5Ph9SptdyDlHQYL/wJEhhoHX
         yKAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zj2+euUL3auyx6dpsodC/84HnUVSm/J2G8LuVpKVDAk=;
        b=H4sfNCzhqoQWh1WKYKrisOqho6QQkmvrmWlw3yYlgr18Ezlj6LYchQceySCLysfzSk
         5QMFY/fvbzGCEgXpQyf9ujRqjPmx8oOH6PUxDsX2fNPPuPTEm/cg8S/wSOqfNacoiXDk
         wa+El3n+DPtp8VluHGtkbjx43C3Qt3wruA1AVzjNKjaTcTGssneSYJEU36aJVPDoyOUM
         goVY2EwnQwEmMhkt3MLfABDWZCTq8qPX3ioQya576gYWIZGs2Aplnxzspz7iXK7k3NFW
         bfQq8E3rkB4puYBHQryBfcQ/E4Wv4gacDI+IBTPcGAqy0KVHZFc1uZQnGbszoYRNbl6T
         3lzw==
X-Gm-Message-State: AOAM5328cubnXw4/7dS8HB9ZUv5Hdjd2AWFGzrH6YG0BjlDT4mdulnW4
        FP3nKQVdo3vvYYFjXMVHmJzohL46TSE=
X-Google-Smtp-Source: ABdhPJwMnPABQ5X99KeLX3PB5h8wVa6j0F8sIIkl+QhgI7mc8DvI1tgmkIEXyR0J7zF3t4MOGoT7UrC2hNs=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:ac89:0:b0:323:7aae:c30b with SMTP id
 x9-20020a02ac89000000b003237aaec30bmr12556207jan.133.1649529967443; Sat, 09
 Apr 2022 11:46:07 -0700 (PDT)
Date:   Sat,  9 Apr 2022 18:45:44 +0000
In-Reply-To: <20220409184549.1681189-1-oupton@google.com>
Message-Id: <20220409184549.1681189-9-oupton@google.com>
Mime-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 08/13] KVM: arm64: Implement PSCI SYSTEM_SUSPEND
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     alexandru.elisei@arm.com, anup@brainfault.org,
        atishp@atishpatra.org, james.morse@arm.com, jingzhangos@google.com,
        jmattson@google.com, joro@8bytes.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org,
        pbonzini@redhat.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, ricarkol@google.com, seanjc@google.com,
        suzuki.poulose@arm.com, vkuznets@redhat.com, wanpengli@tencent.com,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ARM DEN0022D.b 5.19 "SYSTEM_SUSPEND" describes a PSCI call that allows
software to request that a system be placed in the deepest possible
low-power state. Effectively, software can use this to suspend itself to
RAM.

Unfortunately, there really is no good way to implement a system-wide
PSCI call in KVM. Any precondition checks done in the kernel will need
to be repeated by userspace since there is no good way to protect a
critical section that spans an exit to userspace. SYSTEM_RESET and
SYSTEM_OFF are equally plagued by this issue, although no users have
seemingly cared for the relatively long time these calls have been
supported.

The solution is to just make the whole implementation userspace's
problem. Introduce a new system event, KVM_SYSTEM_EVENT_SUSPEND, that
indicates to userspace a calling vCPU has invoked PSCI SYSTEM_SUSPEND.
Additionally, add a CAP to get buy-in from userspace for this new exit
type.

Only advertise the SYSTEM_SUSPEND PSCI call if userspace has opted in.
If a vCPU calls SYSTEM_SUSPEND, punt straight to userspace. Provide
explicit documentation of userspace's responsibilites for the exit and
point to the PSCI specification to describe the actual PSCI call.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/api.rst    | 39 +++++++++++++++++++++++++++++++
 arch/arm64/include/asm/kvm_host.h |  3 ++-
 arch/arm64/kvm/arm.c              | 12 +++++++++-
 arch/arm64/kvm/psci.c             | 25 ++++++++++++++++++++
 include/uapi/linux/kvm.h          |  2 ++
 5 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d104e34ad703..24e2fac2fea7 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6015,6 +6015,7 @@ should put the acknowledged interrupt vector into the 'epr' field.
   #define KVM_SYSTEM_EVENT_RESET          2
   #define KVM_SYSTEM_EVENT_CRASH          3
   #define KVM_SYSTEM_EVENT_WAKEUP         4
+  #define KVM_SYSTEM_EVENT_SUSPENDED      5
 			__u32 type;
 			__u64 flags;
 		} system_event;
@@ -6042,6 +6043,34 @@ Valid values for 'type' are:
  - KVM_SYSTEM_EVENT_WAKEUP -- the exiting vCPU is in a suspended state and
    KVM has recognized a wakeup event. Userspace may honor this event by
    marking the exiting vCPU as runnable, or deny it and call KVM_RUN again.
+ - KVM_SYSTEM_EVENT_SUSPENDED -- the guest has requested a suspension of
+   the VM.
+
+For arm/arm64:
+^^^^^^^^^^^^^^
+
+   KVM_SYSTEM_EVENT_SUSPENDED exits are enabled with the
+   KVM_CAP_ARM_SYSTEM_SUSPEND VM capability. If a guest invokes the PSCI
+   SYSTEM_SUSPEND function, KVM will exit to userspace with this event
+   type.
+
+   It is the sole responsibility of userspace to implement the PSCI
+   SYSTEM_SUSPEND call according to ARM DEN0022D.b 5.19 "SYSTEM_SUSPEND".
+   KVM does not change the vCPU's state before exiting to userspace, so
+   the call parameters are left in-place in the vCPU registers.
+
+   Userspace is _required_ to take action for such an exit. It must
+   either:
+
+    - Honor the guest request to suspend the VM. Userspace can request
+      in-kernel emulation of suspension by setting the calling vCPU's
+      state to KVM_MP_STATE_SUSPENDED. Userspace must configure the vCPU's
+      state according to the parameters passed to the PSCI function when
+      the calling vCPU is resumed. See ARM DEN0022D.b 5.19.1 "Intended use"
+      for details on the function parameters.
+
+    - Deny the guest request to suspend the VM. See ARM DEN0022D.b 5.19.2
+      "Caller responsibilities" for possible return values.
 
 Valid flags are:
 
@@ -7756,6 +7785,16 @@ At this time, KVM_PMU_CAP_DISABLE is the only capability.  Setting
 this capability will disable PMU virtualization for that VM.  Usermode
 should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
 
+8.36 KVM_CAP_ARM_SYSTEM_SUSPEND
+-------------------------------
+
+:Capability: KVM_CAP_ARM_SYSTEM_SUSPEND
+:Architectures: arm64
+:Type: vm
+
+When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
+type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
+
 9. Known KVM API problems
 =========================
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 46027b9b80ca..9243115c9d7b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -137,7 +137,8 @@ struct kvm_arch {
 	 */
 #define KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED		3
 #define KVM_ARCH_FLAG_EL1_32BIT				4
-
+	/* PSCI SYSTEM_SUSPEND enabled for the guest */
+#define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED		5
 	unsigned long flags;
 
 	/*
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e9641b86d375..1714aa55db9c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -97,6 +97,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_ARM_SYSTEM_SUSPEND:
+		r = 0;
+		set_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags);
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -210,6 +214,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
+	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
@@ -447,8 +452,13 @@ bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu)
 static void kvm_arm_vcpu_suspend(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.mp_state.mp_state = KVM_MP_STATE_SUSPENDED;
+
+	/*
+	 * Since this is only called from the intended vCPU, the target vCPU is
+	 * guaranteed to not be running. As such there is no need to kick the
+	 * target to handle the request.
+	 */
 	kvm_make_request(KVM_REQ_SUSPEND, vcpu);
-	kvm_vcpu_kick(vcpu);
 }
 
 static bool kvm_arm_vcpu_suspended(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 362d2a898b83..58b5e2c2ff6a 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -191,6 +191,11 @@ static void kvm_psci_system_reset2(struct kvm_vcpu *vcpu)
 				 KVM_SYSTEM_EVENT_RESET_FLAG_PSCI_RESET2);
 }
 
+static void kvm_psci_system_suspend(struct kvm_vcpu *vcpu)
+{
+	kvm_vcpu_set_system_event_exit(vcpu, KVM_SYSTEM_EVENT_SUSPEND, 0);
+}
+
 static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
 {
 	int i;
@@ -296,6 +301,7 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 {
 	unsigned long val = PSCI_RET_NOT_SUPPORTED;
 	u32 psci_fn = smccc_get_function(vcpu);
+	struct kvm *kvm = vcpu->kvm;
 	u32 arg;
 	int ret = 1;
 
@@ -327,6 +333,11 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 		case ARM_SMCCC_VERSION_FUNC_ID:
 			val = 0;
 			break;
+		case PSCI_1_0_FN_SYSTEM_SUSPEND:
+		case PSCI_1_0_FN64_SYSTEM_SUSPEND:
+			if (test_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags))
+				val = 0;
+			break;
 		case PSCI_1_1_FN_SYSTEM_RESET2:
 		case PSCI_1_1_FN64_SYSTEM_RESET2:
 			if (minor >= 1)
@@ -334,6 +345,20 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 			break;
 		}
 		break;
+	case PSCI_1_0_FN_SYSTEM_SUSPEND:
+		kvm_psci_narrow_to_32bit(vcpu);
+		fallthrough;
+	case PSCI_1_0_FN64_SYSTEM_SUSPEND:
+		/*
+		 * Return directly to userspace without changing the vCPU's
+		 * registers. Userspace depends on reading the SMCCC parameters
+		 * to implement SYSTEM_SUSPEND.
+		 */
+		if (test_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags)) {
+			kvm_psci_system_suspend(vcpu);
+			return 0;
+		}
+		break;
 	case PSCI_1_1_FN_SYSTEM_RESET2:
 		kvm_psci_narrow_to_32bit(vcpu);
 		fallthrough;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 64e5f9d83a7a..752e4a5c3ce6 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -445,6 +445,7 @@ struct kvm_run {
 #define KVM_SYSTEM_EVENT_RESET          2
 #define KVM_SYSTEM_EVENT_CRASH          3
 #define KVM_SYSTEM_EVENT_WAKEUP         4
+#define KVM_SYSTEM_EVENT_SUSPEND        5
 			__u32 type;
 			__u64 flags;
 		} system_event;
@@ -1146,6 +1147,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_MEM_OP_EXTENSION 211
 #define KVM_CAP_PMU_CAPABILITY 212
 #define KVM_CAP_DISABLE_QUIRKS2 213
+#define KVM_CAP_ARM_SYSTEM_SUSPEND 214
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.35.1.1178.g4f1659d476-goog

