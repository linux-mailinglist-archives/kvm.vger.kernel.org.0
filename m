Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32D7F5195E4
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 05:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344344AbiEDD2u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 23:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344287AbiEDD2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 23:28:44 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C1E27FCE
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 20:25:04 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id h16-20020a056902009000b00628a70584b2so205489ybs.6
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 20:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=w/QqgshLuynQgTB466qWOhG4L1sZJjE/JqxBMvksN+M=;
        b=N3jQKX+4PykOhl6nZ1drc/9Lew6WcljIYtRCDc6P4D8aORoUCyCwa1y94HDlN/auep
         U0S/tkT6hruzCY4df1lwwNeEDYzTfTTNDmjuHECFOFzqd45w0Bh4M7S2UEB2wT2xyd9V
         Om2MLD+9HY5XQns71QRKuUBs/Z89hGng1kwNwWYaqQviBfUuAfBxHFiMjkL5R8pvWtkf
         rOHMs0hg+8LmxC30toG3Je+XcQnsyhGn5YsDqalNd8ykJQd9jippv5iy5BJuZhJoSm4y
         dTbFv4OeHgHpS1+O9SybxwMazOwywAWAVyUkdcEnd3TcI8F03sV3ZCtbsDUx5eBhlOWI
         k8AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=w/QqgshLuynQgTB466qWOhG4L1sZJjE/JqxBMvksN+M=;
        b=tpg+2+gGVyXvOynhP5pxXjwfvuMBdIKjn6kHtBP4ic3PEquaXIXDW7m2HyHizJG3Tu
         HnY53ppRosS6tN4u4nfAkKTfaMEaY9LcFnonc7z/VkQyGdMQ6yHV+rzxaETZmNsKioye
         jdDdt88rdXS5WnCeLAoxnMEQhPx6h7Ka6LaYwsM9PcVr61bdLHfnoT/ysCVcKVxeKWIq
         NbZx7vrDjaM1LUQjEWlA2TQMU7xAPaMhtpfB3VwrZiGrXydYDhJ1ZsmE63FLYhUWAhWK
         bp5O46qlXxwYQRLGHyNmjHusHFCAHl6jtK6U8YOu7aOecPSRzpdkXfkWubV9QoA9+9/5
         Jwqg==
X-Gm-Message-State: AOAM530N7gsaXkiDObW4cCP2DrCgxzh/5fNXibRw4SbogrEt9YIlxaiZ
        oo0UdaPqkhcxM6K/fgqfzaDWIracDB0=
X-Google-Smtp-Source: ABdhPJxthJVzT4CGgTXTitH/slT/6c20wkW2hrOINoiHXBEgvKz6+2Jv6Hdz6oCFtbmll8gZoZteCawt0pI=
X-Received: from oupton3.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a05:6902:728:b0:64a:9af:4796 with SMTP id
 l8-20020a056902072800b0064a09af4796mr1665597ybt.2.1651634703906; Tue, 03 May
 2022 20:25:03 -0700 (PDT)
Date:   Wed,  4 May 2022 03:24:40 +0000
In-Reply-To: <20220504032446.4133305-1-oupton@google.com>
Message-Id: <20220504032446.4133305-7-oupton@google.com>
Mime-Version: 1.0
References: <20220504032446.4133305-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v6 06/12] KVM: arm64: Add support for userspace to suspend a vCPU
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        reijiw@google.com, ricarkol@google.com,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
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
 Documentation/virt/kvm/api.rst    | 37 ++++++++++++++++++++--
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              | 51 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |  2 ++
 4 files changed, 89 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 4a900cdbc62e..46ca84600dca 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1476,14 +1476,43 @@ Possible values are:
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
+     it is strongly recommended that it also restores the vCPU to its
+     original state when the vCPU is made RUNNABLE again. For example,
+     if userspace masked a pending interrupt to suppress the wakeup,
+     the interrupt should be unmasked before returning control to the
+     guest.
+
+For riscv:
+^^^^^^^^^^
 
 The only states that are valid are KVM_MP_STATE_STOPPED and
 KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
@@ -5985,6 +6014,7 @@ should put the acknowledged interrupt vector into the 'epr' field.
   #define KVM_SYSTEM_EVENT_SHUTDOWN       1
   #define KVM_SYSTEM_EVENT_RESET          2
   #define KVM_SYSTEM_EVENT_CRASH          3
+  #define KVM_SYSTEM_EVENT_WAKEUP         4
 			__u32 type;
                         __u32 ndata;
                         __u64 data[16];
@@ -6009,6 +6039,9 @@ Valid values for 'type' are:
    has requested a crash condition maintenance. Userspace can choose
    to ignore the request, or to gather VM memory core dump and/or
    reset/shutdown of the VM.
+ - KVM_SYSTEM_EVENT_WAKEUP -- the exiting vCPU is in a suspended state and
+   KVM has recognized a wakeup event. Userspace may honor this event by
+   marking the exiting vCPU as runnable, or deny it and call KVM_RUN again.
 
 If KVM_CAP_SYSTEM_EVENT_DATA is present, the 'data' field can contain
 architecture specific information for the system-level event.  Only
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f3f93d48e21a..46027b9b80ca 100644
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
index efe54aba5cce..abd32a84ed7a 100644
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
@@ -648,6 +663,39 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
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
+
+	/*
+	 * Check to make sure the vCPU is actually runnable. If so, exit to
+	 * userspace informing it of the wakeup condition.
+	 */
+	if (kvm_arch_vcpu_runnable(vcpu)) {
+		memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
+		vcpu->run->system_event.type = KVM_SYSTEM_EVENT_WAKEUP;
+		vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+		return 0;
+	}
+
+	/*
+	 * Otherwise, we were unblocked to process a different event, such as a
+	 * pending signal. Return 1 and allow kvm_arch_vcpu_ioctl_run() to
+	 * process the event.
+	 */
+	return 1;
+}
+
 /**
  * check_vcpu_requests - check and handle pending vCPU requests
  * @vcpu:	the VCPU pointer
@@ -686,6 +734,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
 			kvm_pmu_handle_pmcr(vcpu,
 					    __vcpu_sys_reg(vcpu, PMCR_EL0));
+
+		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
+			return kvm_vcpu_suspend(vcpu);
 	}
 
 	return 1;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6a184d260c7f..7f72fb7b05f2 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -444,6 +444,7 @@ struct kvm_run {
 #define KVM_SYSTEM_EVENT_SHUTDOWN       1
 #define KVM_SYSTEM_EVENT_RESET          2
 #define KVM_SYSTEM_EVENT_CRASH          3
+#define KVM_SYSTEM_EVENT_WAKEUP         4
 			__u32 type;
 			__u32 ndata;
 			union {
@@ -646,6 +647,7 @@ struct kvm_vapic_addr {
 #define KVM_MP_STATE_OPERATING         7
 #define KVM_MP_STATE_LOAD              8
 #define KVM_MP_STATE_AP_RESET_HOLD     9
+#define KVM_MP_STATE_SUSPENDED         10
 
 struct kvm_mp_state {
 	__u32 mp_state;
-- 
2.36.0.464.gb9c8b46e94-goog

