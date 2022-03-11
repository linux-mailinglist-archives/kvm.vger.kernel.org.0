Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE6B4D67DD
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350864AbiCKRmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350843AbiCKRmP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:42:15 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6C91BE4D0
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:41:12 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id g11-20020a056602072b00b00645cc0735d7so6758688iox.1
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wLgTYRPMnh01Zlz1eglLJFiUoRqP8W9xVYGstLsgmmc=;
        b=DricpLg5tjBoDBtiHkYfMTnrkKupw3UlNwbYQ6+iWXD0DkRK5rAZBuE5KZ3+FcVZb4
         w993xNoyPUWCX+5Vvf5cnF6NmGFDj4mwR4ITF/ZCx9hJMMa+1LZl58G7bPE7dEi0NGfI
         iuBaVpe9ieMVaWnRrctYY7cJtaJrHtGr4FQFkB+/aRwNpGMTOvAlrZeF/0wNaaLtea7w
         7WP0z0I2+xq1kuumh0TCvP1GqnA2tKItTbLSLcDdhAMJ8Umu1jwY5D7pkSrB8SghrOQb
         0BhEdtNAfrfS/+ugtld5T+qg5v59VKuiqVDXfL676OjZEA7rAUjgK/5YWafOpYqhjlFW
         umJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wLgTYRPMnh01Zlz1eglLJFiUoRqP8W9xVYGstLsgmmc=;
        b=Rw0oW9ODc1/FiZ3LlfgdGtohd4mRWVW7YZCwjiL3K/6QTnBEXGKYEiU976cVF8fs53
         yMzC4g8sD1UFFJMzOplnIG5yUL6n6QSH5KyfROkigIL7X5DHt/ZpEXYQ7+4Jre/A8N8v
         4KvKTzoVFQS3OWuDpSXAiHIYJCRbzsvDwErSn4Z1j1tiP5O5RTV8YotBxZfDhVM66QQs
         xgjckXlAF8cCEfk8i+Nfm1bOAOpBkS5+jOxZYbeVhVGlFcsdJdpPLU75jiOs316Gvtyl
         +AhLFrPdggh7OrEKgOaH+LOBMOSNI28pkpB9FTgvcf0Gxd+wV3XB6pu2/p5FpaGqcpBL
         lvog==
X-Gm-Message-State: AOAM533KZ2c8Yx13vAvBFyCRsDfkMn9rhGPSbH76jx4dItJEr+4gSx96
        hD8Tcnt1j7cDZf1L2Dxs2MWzIstyE/4=
X-Google-Smtp-Source: ABdhPJzCQ+YYMNukL81rCk6AcaObcxLHHbQxUxPvY6bi54irylbyTsa5mWYIEmRO3OzoPMfZWTHeiZ7qRQU=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:20e8:b0:2c7:6e73:2279 with SMTP id
 q8-20020a056e0220e800b002c76e732279mr5662214ilv.60.1647020471395; Fri, 11 Mar
 2022 09:41:11 -0800 (PST)
Date:   Fri, 11 Mar 2022 17:39:56 +0000
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
Message-Id: <20220311174001.605719-11-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 10/15] KVM: arm64: Implement PSCI SYSTEM_SUSPEND
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
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/arm.c              | 12 +++++++++-
 arch/arm64/kvm/psci.c             | 25 ++++++++++++++++++++
 include/uapi/linux/kvm.h          |  2 ++
 5 files changed, 79 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 426bcdc1216d..396589e3b178 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5944,6 +5944,7 @@ should put the acknowledged interrupt vector into the 'epr' field.
   #define KVM_SYSTEM_EVENT_RESET          2
   #define KVM_SYSTEM_EVENT_CRASH          3
   #define KVM_SYSTEM_EVENT_WAKEUP         4
+  #define KVM_SYSTEM_EVENT_SUSPENDED      5
 			__u32 type;
 			__u64 flags;
 		} system_event;
@@ -5971,6 +5972,34 @@ Valid values for 'type' are:
  - KVM_SYSTEM_EVENT_WAKEUP -- the guest is in a suspended state and KVM
    has recognized a wakeup event. Userspace may honor this event by marking
    the exiting vCPU as runnable, or deny it and call KVM_RUN again.
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
 
@@ -7598,3 +7627,13 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
 of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
 the hypercalls whose corresponding bit is in the argument, and return
 ENOSYS for the others.
+
+8.35 KVM_CAP_ARM_SYSTEM_SUSPEND
+-------------------------------
+
+:Capability: KVM_CAP_ARM_SYSTEM_SUSPEND
+:Architectures: arm64
+:Type: vm
+
+When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
+type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 899f2c0b4c7b..ca3ac32e40c8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -128,6 +128,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_MTE_ENABLED			1
 	/* At least one vCPU has ran in the VM */
 #define KVM_ARCH_FLAG_HAS_RAN_ONCE			2
+	/* PSCI SYSTEM_SUSPEND enabled for the guest */
+#define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED		3
 	unsigned long flags;
 
 	/*
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b94efa05d869..c9b616ddb512 100644
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
index 78266716165e..2239143a9d6c 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -192,6 +192,11 @@ static void kvm_psci_system_reset2(struct kvm_vcpu *vcpu)
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
@@ -302,6 +307,7 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 {
 	unsigned long val = PSCI_RET_NOT_SUPPORTED;
 	u32 psci_fn = smccc_get_function(vcpu);
+	struct kvm *kvm = vcpu->kvm;
 	u32 arg;
 	int ret = 1;
 
@@ -336,6 +342,11 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
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
@@ -343,6 +354,20 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
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
index babb16c2abe5..e5bb5f15c0eb 100644
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
@@ -1136,6 +1137,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_GPA_BITS 207
 #define KVM_CAP_XSAVE2 208
 #define KVM_CAP_SYS_ATTRIBUTES 209
+#define KVM_CAP_ARM_SYSTEM_SUSPEND 210
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.35.1.723.g4982287a31-goog

