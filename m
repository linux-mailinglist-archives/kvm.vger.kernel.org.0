Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95FC91B643E
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 21:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgDWTIP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 15:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgDWTIO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 15:08:14 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F94C09B042
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 12:08:14 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 84so6187552pfx.20
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 12:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=9zqjAygbKwCfmex7bCTXn/vr+vDswobmnvfUoS/bgJQ=;
        b=D25/DfTq5AcA9dE/gtw1GoOJSaERPJuxNHFmrgNfIYhtg9y9/2oTC349EmSjIAusPr
         nW2TcIq5toc7MXPRSv639BMP7cmCqKvUJJ/LGsN2bjvi/+kjMxyPy4wZpMKJ5WJ/6u7c
         zWlDrZzcLPysFhRrUdoPIN0feZCJ4ybVKsjpTTJX0VQGcfFNc3Q8QJLBhM6Q+wmsW78h
         v8tstFjY/+v6Dyr7bKIAHWCIvlLYAG7ESrRQ4qTYkwRE5E7TGVXVeDrNPGKE8rmFEK9I
         t/OBkIaUvWzsoPi0f4IhxN6frymWNBG0i8fAXOugzUL6p2XtpnkYdEcwuUTXvDi+zOiC
         NzzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=9zqjAygbKwCfmex7bCTXn/vr+vDswobmnvfUoS/bgJQ=;
        b=KwbauaVJEE/90onJHWp994ZUptSxigM+nenDQiKPM6pUX5uqdS8+XIGqptqVgso6Wt
         W0x/TddaZnXXSj3wxL6EFTPBzUTv/rSCsX/YIT4gWY+0JCjfvCnIVwlMTS2ApAw7ctxy
         UEvHJ+Remy12viaeg+BN41E23PWYvaeq4EXL98G1PSV0f69ggYeUaXscnATqk3fqtosd
         mCzFdhAXmAMfsBytMyv6D6la8/f8JqL5O4HjCaBo4QhVHv24EAuqNGvxlc5mUnkdzSqC
         Gaaru+UAwq+9J7JMSH/bTKlZXcvNUz9PsDaz7qp5VxDqbnPbw0ss+s5xEQ8IkGXy33nS
         NJIg==
X-Gm-Message-State: AGi0Pubw39yoQZLXlJH+pzQeMu0YWHqkhA8wuNr1xXGkoxdu+a+B4w6M
        z9YMLwUj85Ct0A77dlx4EeVm7w4MyxOli6dSFuv8nHNpkS6H2u3n64Y552spfRrdWCk4sWkPJEz
        FVd4MuM0dXxtv0hb3hkP+YwTSj4oho9UCoF4RpJNIBZnwdERvj0xP2N32latkz7h2B2uM/pCtGs
        kZcv4=
X-Google-Smtp-Source: APiQypL7NY8z3azwEyQfdJYmW9xgKq/jxiqKckktEt16MqYth8JgdtKucRl+jJ3lJ/1qI8H/4HQ7ON3KaqiQG+ofmnTk4A==
X-Received: by 2002:a17:90a:9e9:: with SMTP id 96mr2261700pjo.41.1587668893263;
 Thu, 23 Apr 2020 12:08:13 -0700 (PDT)
Date:   Thu, 23 Apr 2020 12:08:05 -0700
Message-Id: <20200423190805.110201-1-makarandsonare@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v3] KVM: nVMX: Fix VMX preemption timer migration
From:   Makarand Sonare <makarandsonare@google.com>
To:     kvm@vger.kernel.org, pshier@google.com, jmattson@google.com
Cc:     Makarand Sonare <makarandsonare@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Shier <pshier@google.com>

Add new field to hold preemption timer remaining until expiration
appended to struct kvm_vmx_nested_state_data. This is to prevent
the first VM-Enter after migration from incorrectly restarting the timer
with the full timer value instead of partially decayed timer value.
KVM_SET_NESTED_STATE restarts timer using migrated state regardless
of whether L1 sets VM_EXIT_SAVE_VMX_PREEMPTION_TIMER.

Fixes: cf8b84f48a593 ("kvm: nVMX: Prepare for checkpointing L2 state")

Signed-off-by: Peter Shier <pshier@google.com>
Signed-off-by: Makarand Sonare <makarandsonare@google.com>
Change-Id: I6446aba5a547afa667f0ef4620b1b76115bf3753
---
 Documentation/virt/kvm/api.rst        |  4 ++
 arch/x86/include/uapi/asm/kvm.h       |  2 +
 arch/x86/kvm/vmx/nested.c             | 58 +++++++++++++++++++++++----
 arch/x86/kvm/vmx/vmx.h                |  1 +
 arch/x86/kvm/x86.c                    |  1 +
 include/uapi/linux/kvm.h              |  1 +
 tools/arch/x86/include/uapi/asm/kvm.h |  2 +
 7 files changed, 62 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index efbbe570aa9b7..89415f20fd089 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4326,6 +4326,9 @@ Errors:
   #define KVM_STATE_NESTED_RUN_PENDING		0x00000002
   #define KVM_STATE_NESTED_EVMCS		0x00000004
 
+  /* Available with KVM_CAP_NESTED_STATE_PREEMPTION_TIMER */
+  #define KVM_STATE_NESTED_PREEMPTION_TIMER	0x00000010
+
   #define KVM_STATE_NESTED_FORMAT_VMX		0
   #define KVM_STATE_NESTED_FORMAT_SVM		1
 
@@ -4346,6 +4349,7 @@ Errors:
   struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
 	__u8 shadow_vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
+	__u32 preemption_timer_remaining;
   };
 
 This ioctl copies the vcpu's nested virtualization state from the kernel to
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 3f3f780c8c650..abaddea6f8ff4 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -391,6 +391,7 @@ struct kvm_sync_regs {
 #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
 #define KVM_STATE_NESTED_EVMCS		0x00000004
 #define KVM_STATE_NESTED_MTF_PENDING	0x00000008
+#define KVM_STATE_NESTED_PREEMPTION_TIMER	0x00000010
 
 #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
@@ -400,6 +401,7 @@ struct kvm_sync_regs {
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
 	__u8 shadow_vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
+	__u32 preemption_timer_remaining;
 };
 
 struct kvm_vmx_nested_state_hdr {
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index cbc9ea2de28f9..7381a3dbb0e5b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2020,9 +2020,9 @@ static enum hrtimer_restart vmx_preemption_timer_fn(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
-static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu)
+static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu,
+					u64 preemption_timeout)
 {
-	u64 preemption_timeout = get_vmcs12(vcpu)->vmx_preemption_timer_value;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	/*
@@ -3293,8 +3293,15 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	 * the timer.
 	 */
 	vmx->nested.preemption_timer_expired = false;
-	if (nested_cpu_has_preemption_timer(vmcs12))
-		vmx_start_preemption_timer(vcpu);
+	if (nested_cpu_has_preemption_timer(vmcs12)) {
+		u64 timer_value;
+
+		if (from_vmentry)
+			timer_value = vmcs12->vmx_preemption_timer_value;
+		else
+			timer_value = vmx->nested.preemption_timer_remaining;
+		vmx_start_preemption_timer(vcpu, timer_value);
+	}
 
 	/*
 	 * Note no nested_vmx_succeed or nested_vmx_fail here. At this point
@@ -3889,9 +3896,13 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 		vmcs12->guest_activity_state = GUEST_ACTIVITY_ACTIVE;
 
 	if (nested_cpu_has_preemption_timer(vmcs12) &&
-	    vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
+	    !vmx->nested.nested_run_pending) {
+		vmx->nested.preemption_timer_remaining =
+			vmx_get_preemption_timer_value(vcpu);
+		if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
 			vmcs12->vmx_preemption_timer_value =
-				vmx_get_preemption_timer_value(vcpu);
+				vmx->nested.preemption_timer_remaining;
+	}
 
 	/*
 	 * In some cases (usually, nested EPT), L2 is allowed to change its
@@ -5759,6 +5770,13 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 
 			if (vmx->nested.mtf_pending)
 				kvm_state.flags |= KVM_STATE_NESTED_MTF_PENDING;
+
+			if (nested_cpu_has_preemption_timer(vmcs12)) {
+				kvm_state.flags |=
+					KVM_STATE_NESTED_PREEMPTION_TIMER;
+				kvm_state.size +=
+					sizeof(user_vmx_nested_state->preemption_timer_remaining);
+			}
 		}
 	}
 
@@ -5790,6 +5808,9 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 
 	BUILD_BUG_ON(sizeof(user_vmx_nested_state->vmcs12) < VMCS12_SIZE);
 	BUILD_BUG_ON(sizeof(user_vmx_nested_state->shadow_vmcs12) < VMCS12_SIZE);
+	BUILD_BUG_ON(sizeof(user_vmx_nested_state->preemption_timer_remaining)
+		    != sizeof(vmx->nested.preemption_timer_remaining));
+
 
 	/*
 	 * Copy over the full allocated size of vmcs12 rather than just the size
@@ -5805,6 +5826,13 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 			return -EFAULT;
 	}
 
+	if (kvm_state.flags & KVM_STATE_NESTED_PREEMPTION_TIMER) {
+		if (copy_to_user(&user_vmx_nested_state->preemption_timer_remaining,
+				 &vmx->nested.preemption_timer_remaining,
+				 sizeof(vmx->nested.preemption_timer_remaining)))
+			return -EFAULT;
+	}
+
 out:
 	return kvm_state.size;
 }
@@ -5876,7 +5904,8 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	 */
 	if (is_smm(vcpu) ?
 		(kvm_state->flags &
-		 (KVM_STATE_NESTED_GUEST_MODE | KVM_STATE_NESTED_RUN_PENDING))
+		 (KVM_STATE_NESTED_GUEST_MODE | KVM_STATE_NESTED_RUN_PENDING |
+		  KVM_STATE_NESTED_PREEMPTION_TIMER))
 		: kvm_state->hdr.vmx.smm.flags)
 		return -EINVAL;
 
@@ -5966,6 +5995,21 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 			goto error_guest_mode;
 	}
 
+	if (kvm_state->flags & KVM_STATE_NESTED_PREEMPTION_TIMER) {
+
+		if (kvm_state->size <
+		    offsetof(struct kvm_nested_state, hdr.vmx) +
+		    offsetofend(struct kvm_vmx_nested_state_data, preemption_timer_remaining))
+			goto error_guest_mode;
+
+		if (copy_from_user(&vmx->nested.preemption_timer_remaining,
+				   &user_vmx_nested_state->preemption_timer_remaining,
+				   sizeof(user_vmx_nested_state->preemption_timer_remaining))) {
+			ret = -EFAULT;
+			goto error_guest_mode;
+		}
+	}
+
 	if (nested_vmx_check_controls(vcpu, vmcs12) ||
 	    nested_vmx_check_host_state(vcpu, vmcs12) ||
 	    nested_vmx_check_guest_state(vcpu, vmcs12, &exit_qual))
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index aab9df55336ef..0098c7dc2e254 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -167,6 +167,7 @@ struct nested_vmx {
 	u16 posted_intr_nv;
 
 	struct hrtimer preemption_timer;
+	u32 preemption_timer_remaining;
 	bool preemption_timer_expired;
 
 	/* to migrate it to L2 if VM_ENTRY_LOAD_DEBUG_CONTROLS is off */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 027dfd278a973..c9758ca1b5714 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3374,6 +3374,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_GET_MSR_FEATURES:
 	case KVM_CAP_MSR_PLATFORM_INFO:
 	case KVM_CAP_EXCEPTION_PAYLOAD:
+	case KVM_CAP_NESTED_STATE_PREEMPTION_TIMER:
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 428c7dde6b4b3..4d6fc8fe30388 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1017,6 +1017,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_VCPU_RESETS 179
 #define KVM_CAP_S390_PROTECTED 180
 #define KVM_CAP_PPC_SECURE_GUEST 181
+#define KVM_CAP_NESTED_STATE_PREEMPTION_TIMER 182
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 3f3f780c8c650..60701178b9cc1 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -391,6 +391,8 @@ struct kvm_sync_regs {
 #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
 #define KVM_STATE_NESTED_EVMCS		0x00000004
 #define KVM_STATE_NESTED_MTF_PENDING	0x00000008
+/* Available with KVM_CAP_NESTED_STATE_PREEMPTION_TIMER */
+#define KVM_STATE_NESTED_PREEMPTION_TIMER	0x00000010
 
 #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
-- 
2.26.1.301.g55bc3eb7cb9-goog

