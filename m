Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4634D67D5
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350862AbiCKRmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350824AbiCKRmO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:42:14 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F69F1C60D4
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:41:11 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id f7-20020a056602088700b00645ebbe277cso6711699ioz.22
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:41:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=N08wvp33WkcjIpobnqWK/suWPKt+tAxx4i2VnS0cwgQ=;
        b=s2H+Z/ODb8asiSTyd1Y7/XpBFYNpChZn/EXdpezoLfZOJh3I2KOjRFQ0/12EhgS0Ou
         +3tjHSRLye2xwojCbc2BrvQda8Z/8nrqcDle3jbChXPDde1+NyJbrM4i7kRyc2P9HPqp
         vz9ZvTZkZkd+vUNMBi3uiwkaqmzJ+q9V1pDYeGtHQoTA4wztJsCLEiPotuYv7BvEcX/8
         m5KxNh6A+bhueDVEhb/OhQR4qOb2TQC+uARkW4qHcI3ZCDDjlQ9vkgbfDxXsSAiFJLkp
         L3sobRPAcsYjfI1Kl+TUDdLl6phNnl/6uEnujdpEcA8mEfcBOdCJczcfMn5/0u0bnhN2
         aIeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=N08wvp33WkcjIpobnqWK/suWPKt+tAxx4i2VnS0cwgQ=;
        b=DdBV4xHKhOS3glB/8tsL7OW2AvuUxrXNQrdUf8DjjYquArDMtJz4rnrTkwA+F+pUH1
         8Pm+PdQkhY1PxVEmDrHGIOIw6CuviBLxNfIyQ6vAo7a1/yjGCYIrE4bvfMC/Bk2AdQ7H
         VLhHdUyoEL+AmYdVbwPMSG+UUoQJqDavGZ9+35bwc/koihcK64In+wqXAOUq1UP3//dl
         n/RlnN19yljjKQ3/oEFYBx9aHreIDJe5t9TurQA2nz4beIT4v0yaQzhKtkL+qEQK8Nkn
         TNP80R/87eXEY9WqSZhuJmEIkWlgWHm1EeI/s2nXG2hnpzKibPxmTB18YXdQA5KfBtPW
         c3tg==
X-Gm-Message-State: AOAM53018cDXu6kghVkd803gJFBe5EZge3HFpHdENKGa7xl5TnKtljLR
        ZwoQIWzKiVoBMzbmOD+As6fPNuWe22Y=
X-Google-Smtp-Source: ABdhPJxJnhqOztOXute1W6oxfMwLBZR4LpePt0v06BaWe3xlqWgLApO6bsYqsLwco3kSxcDDWgE/ZI7lj2E=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:5d0:b0:2c6:23cb:2fa9 with SMTP id
 l16-20020a056e0205d000b002c623cb2fa9mr8091751ils.68.1647020470492; Fri, 11
 Mar 2022 09:41:10 -0800 (PST)
Date:   Fri, 11 Mar 2022 17:39:55 +0000
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
Message-Id: <20220311174001.605719-10-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 09/15] KVM: arm64: Add support for userspace to suspend a vCPU
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

Introduce a new MP state, KVM_MP_STATE_SUSPENDED, which indicates a vCPU
is in a suspended state. In the suspended state the vCPU will block
until a wakeup event (pending interrupt) is recognized.

Add a new system event type, KVM_SYSTEM_EVENT_WAKEUP, to indicate to
userspace that KVM has recognized one such wakeup event. It is the
responsibility of userspace to then make the vCPU runnable, or leave it
suspended until the next wakeup event.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/api.rst    | 37 +++++++++++++++++++++++++++++--
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              | 35 +++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |  2 ++
 4 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 5625c08b4a0e..426bcdc1216d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1482,14 +1482,43 @@ Possible values are:
                                  [s390]
    KVM_MP_STATE_LOAD             the vcpu is in a special load/startup state
                                  [s390]
+   KVM_MP_STATE_SUSPENDED        the vcpu is in a suspend state and is waiting
+                                 for a wakeup event [arm64]
    ==========================    ===============================================
 
 On x86, this ioctl is only useful after KVM_CREATE_IRQCHIP. Without an
 in-kernel irqchip, the multiprocessing state must be maintained by userspace on
 these architectures.
 
-For arm64/riscv:
-^^^^^^^^^^^^^^^^
+For arm64:
+^^^^^^^^^^
+
+If a vCPU is in the KVM_MP_STATE_SUSPENDED state, KVM will emulate the
+architectural execution of a WFI instruction.
+
+If a wakeup event is recognized, KVM will exit to userspace with a
+KVM_SYSTEM_EVENT exit, where the event type is KVM_SYSTEM_EVENT_WAKEUP. If
+userspace wants to honor the wakeup, it must set the vCPU's MP state to
+KVM_MP_STATE_RUNNABLE. If it does not, KVM will continue to await a wakeup
+event in subsequent calls to KVM_RUN.
+
+.. warning::
+
+     If userspace intends to keep the vCPU in a SUSPENDED state, it is
+     strongly recommended that userspace take action to suppress the
+     wakeup event (such as masking an interrupt). Otherwise, subsequent
+     calls to KVM_RUN will immediately exit with a KVM_SYSTEM_EVENT_WAKEUP
+     event and inadvertently waste CPU cycles.
+
+     Additionally, if userspace takes action to suppress a wakeup event,
+     it is strongly recommended that it also restore the vCPU to its
+     original state when the vCPU is made RUNNABLE again. For example,
+     if userspace masked a pending interrupt to suppress the wakeup,
+     the interrupt should be unmasked before returning control to the
+     guest.
+
+For riscv:
+^^^^^^^^^^
 
 The only states that are valid are KVM_MP_STATE_STOPPED and
 KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
@@ -5914,6 +5943,7 @@ should put the acknowledged interrupt vector into the 'epr' field.
   #define KVM_SYSTEM_EVENT_SHUTDOWN       1
   #define KVM_SYSTEM_EVENT_RESET          2
   #define KVM_SYSTEM_EVENT_CRASH          3
+  #define KVM_SYSTEM_EVENT_WAKEUP         4
 			__u32 type;
 			__u64 flags;
 		} system_event;
@@ -5938,6 +5968,9 @@ Valid values for 'type' are:
    has requested a crash condition maintenance. Userspace can choose
    to ignore the request, or to gather VM memory core dump and/or
    reset/shutdown of the VM.
+ - KVM_SYSTEM_EVENT_WAKEUP -- the guest is in a suspended state and KVM
+   has recognized a wakeup event. Userspace may honor this event by marking
+   the exiting vCPU as runnable, or deny it and call KVM_RUN again.
 
 Valid flags are:
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index da58eb96d2a8..899f2c0b4c7b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -46,6 +46,7 @@
 #define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
 #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
 #define KVM_REQ_RELOAD_PMU	KVM_ARCH_REQ(5)
+#define KVM_REQ_SUSPEND		KVM_ARCH_REQ(6)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8eed0556ccaa..b94efa05d869 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -444,6 +444,18 @@ bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu)
 	return vcpu->arch.mp_state.mp_state == KVM_MP_STATE_STOPPED;
 }
 
+static void kvm_arm_vcpu_suspend(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.mp_state.mp_state = KVM_MP_STATE_SUSPENDED;
+	kvm_make_request(KVM_REQ_SUSPEND, vcpu);
+	kvm_vcpu_kick(vcpu);
+}
+
+static bool kvm_arm_vcpu_suspended(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.mp_state.mp_state == KVM_MP_STATE_SUSPENDED;
+}
+
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
@@ -464,6 +476,9 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 	case KVM_MP_STATE_STOPPED:
 		kvm_arm_vcpu_power_off(vcpu);
 		break;
+	case KVM_MP_STATE_SUSPENDED:
+		kvm_arm_vcpu_suspend(vcpu);
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -648,6 +663,23 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
 	preempt_enable();
 }
 
+static int kvm_vcpu_suspend(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_arm_vcpu_suspended(vcpu))
+		return 1;
+
+	kvm_vcpu_wfi(vcpu);
+
+	/*
+	 * The suspend state is sticky; we do not leave it until userspace
+	 * explicitly marks the vCPU as runnable. Request that we suspend again
+	 * later.
+	 */
+	kvm_make_request(KVM_REQ_SUSPEND, vcpu);
+	kvm_vcpu_set_system_event_exit(vcpu, KVM_SYSTEM_EVENT_WAKEUP, 0);
+	return 0;
+}
+
 /**
  * check_vcpu_requests - check and handle pending vCPU requests
  * @vcpu:	the VCPU pointer
@@ -686,6 +718,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
 			kvm_pmu_handle_pmcr(vcpu,
 					    __vcpu_sys_reg(vcpu, PMCR_EL0));
+
+		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
+			return kvm_vcpu_suspend(vcpu);
 	}
 
 	return 1;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5191b57e1562..babb16c2abe5 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -444,6 +444,7 @@ struct kvm_run {
 #define KVM_SYSTEM_EVENT_SHUTDOWN       1
 #define KVM_SYSTEM_EVENT_RESET          2
 #define KVM_SYSTEM_EVENT_CRASH          3
+#define KVM_SYSTEM_EVENT_WAKEUP         4
 			__u32 type;
 			__u64 flags;
 		} system_event;
@@ -634,6 +635,7 @@ struct kvm_vapic_addr {
 #define KVM_MP_STATE_OPERATING         7
 #define KVM_MP_STATE_LOAD              8
 #define KVM_MP_STATE_AP_RESET_HOLD     9
+#define KVM_MP_STATE_SUSPENDED         10
 
 struct kvm_mp_state {
 	__u32 mp_state;
-- 
2.35.1.723.g4982287a31-goog

