Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868451AE4DC
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 20:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbgDQSfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 14:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729094AbgDQSfS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Apr 2020 14:35:18 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECD9C061A0C
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 11:35:16 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id q11so2720098pfq.9
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 11:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QQqAabiBFaz8mQ9VmW0Dl+mz5jUjATZVVCBZzR434Cc=;
        b=na6HeB+4EAvIxKTcfNzGBPTmnP86S3lU0FLQeHngy4Rv2mGdswiqquhdlUDDiTrcDC
         vpdqjPL04LL7zP+n6DloZdAPLKw64VbdRJ7npAogn3UAR9Z9dQO6SKCJiM8Us+aH0pAq
         ljhM4tOqEnlAHUyThGOKeKZYldQZ59og+xNJaRz+DjJbArf4qDwvDLdVvkrBgTOU0Ekg
         6IsPwj4nJt0OtZGUsHIyGjv53KDl9AZpvjB+Jnq8B6f0cE1F5DALBLdX/f0t0rVtJLXb
         NXh0vC4Tjr8vXBvzCiexPFaG2Axib/rtkrDkleDB26+RYnMMDIQBs9RRF3KyJHrcSB15
         LJBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QQqAabiBFaz8mQ9VmW0Dl+mz5jUjATZVVCBZzR434Cc=;
        b=OeB4fcSTnPobNlr8j0c49pBLN5FvD/SkYU0VQ4Bsik3OwmN0DI9h386CY/pH6t4UPa
         rl8AuzhmyywFcy1t/+QG9HUhc552XdP2T62AZ8y3qgff9LfPigtZCELotFAkTrhYAHde
         P2wjqk721BG7pI48XSgJiYKHjb86QdZoyyU8BgFl/yGxrJa4gejhRZfwuB//n3WRMrL8
         TbSUKOa+k2YQ7n1Gk/CfHK1PwXBjJnXUddPjUjc4b7vaF+pIzv9AiZb+3Hd/0enkBz0c
         PGaUx4PU5cO26aiMYvac00s3rrMb/ZFn9M2vhwSsYlPbPMdUnWeTsZj7ekZGhooW3AX7
         CEgA==
X-Gm-Message-State: AGi0Publ4QWIu5WqdzABlUGDVTNA6ekeG95Ov+FvvkaF9vVbb5VZCt8j
        RvHFjBiZ874p+b7kqkDyvW1BIRAl97f1d3OAyvgTMXngVapZLWliH264oFgyToeA/Ciq1weEKic
        PnAby7iL/+oEhGECE0eRxXbAIEyqydBZOUsw0wBBvNFhiOqeSKYLnNa3o0rVQcNeZEGtuSzHTDt
        om648=
X-Google-Smtp-Source: APiQypJDow6DhpJK7KznRuTF7lt32GWYrtA7vfKl8i6qwMdRsINM+PE6AK88G0IvU2vJmNbw8I+GcvZcfk+kTcTfvu3X+Q==
X-Received: by 2002:a63:9902:: with SMTP id d2mr4350478pge.8.1587148516380;
 Fri, 17 Apr 2020 11:35:16 -0700 (PDT)
Date:   Fri, 17 Apr 2020 11:34:51 -0700
In-Reply-To: <20200417183452.115762-1-makarandsonare@google.com>
Message-Id: <20200417183452.115762-2-makarandsonare@google.com>
Mime-Version: 1.0
References: <20200417183452.115762-1-makarandsonare@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [kvm PATCH 1/2] KVM: nVMX - enable VMX preemption timer migration
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
appended to struct kvm_vmx_nested_state_data. KVM_SET_NESTED_STATE restarts
timer using migrated state regardless of whether L1 sets
VM_EXIT_SAVE_VMX_PREEMPTION_TIMER.

Fixes: cf8b84f48a593 ("kvm: nVMX: Prepare for checkpointing L2 state")

Signed-off-by: Makarand Sonare <makarandsonare@google.com>
Signed-off-by: Peter Shier <pshier@google.com>
Change-Id: I6446aba5a547afa667f0ef4620b1b76115bf3753
---
 Documentation/virt/kvm/api.rst        |  4 ++
 arch/x86/include/uapi/asm/kvm.h       |  2 +
 arch/x86/kvm/vmx/nested.c             | 62 +++++++++++++++++++++++----
 arch/x86/kvm/vmx/vmx.h                |  1 +
 arch/x86/kvm/x86.c                    |  1 +
 include/uapi/linux/kvm.h              |  1 +
 tools/arch/x86/include/uapi/asm/kvm.h |  2 +
 7 files changed, 65 insertions(+), 8 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index efbbe570aa9b7..097e422ded063 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4326,6 +4326,9 @@ Errors:
   #define KVM_STATE_NESTED_RUN_PENDING		0x00000002
   #define KVM_STATE_NESTED_EVMCS		0x00000004
 
+  /* Available with KVM_CAP_NESTED_PREEMPTION_TIMER */
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
index cbc9ea2de28f9..5365d7e5921ea 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2014,15 +2014,16 @@ static enum hrtimer_restart vmx_preemption_timer_fn(struct hrtimer *timer)
 		container_of(timer, struct vcpu_vmx, nested.preemption_timer);
 
 	vmx->nested.preemption_timer_expired = true;
+	vmx->nested.preemption_timer_remaining = 0;
 	kvm_make_request(KVM_REQ_EVENT, &vmx->vcpu);
 	kvm_vcpu_kick(&vmx->vcpu);
 
 	return HRTIMER_NORESTART;
 }
 
-static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu)
+static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu,
+					u64 preemption_timeout)
 {
-	u64 preemption_timeout = get_vmcs12(vcpu)->vmx_preemption_timer_value;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	/*
@@ -3293,8 +3294,15 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	 * the timer.
 	 */
 	vmx->nested.preemption_timer_expired = false;
-	if (nested_cpu_has_preemption_timer(vmcs12))
-		vmx_start_preemption_timer(vcpu);
+	if (nested_cpu_has_preemption_timer(vmcs12)) {
+		u64 preemption_timeout;
+
+		if (from_vmentry)
+			preemption_timeout = get_vmcs12(vcpu)->vmx_preemption_timer_value;
+		else
+			preemption_timeout = vmx->nested.preemption_timer_remaining;
+		vmx_start_preemption_timer(vcpu, preemption_timeout);
+	}
 
 	/*
 	 * Note no nested_vmx_succeed or nested_vmx_fail here. At this point
@@ -3888,10 +3896,13 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 	else
 		vmcs12->guest_activity_state = GUEST_ACTIVITY_ACTIVE;
 
-	if (nested_cpu_has_preemption_timer(vmcs12) &&
-	    vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
+	if (nested_cpu_has_preemption_timer(vmcs12)) {
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
 
@@ -5966,6 +5995,23 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 			goto error_guest_mode;
 	}
 
+	if (kvm_state->flags & KVM_STATE_NESTED_PREEMPTION_TIMER) {
+
+		if (kvm_state->size <
+		    sizeof(*kvm_state) +
+		    sizeof(user_vmx_nested_state->vmcs12) +
+		    sizeof(user_vmx_nested_state->shadow_vmcs12) +
+		    sizeof(user_vmx_nested_state->preemption_timer_remaining))
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
index 027dfd278a973..ddad6305a0d23 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3374,6 +3374,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_GET_MSR_FEATURES:
 	case KVM_CAP_MSR_PLATFORM_INFO:
 	case KVM_CAP_EXCEPTION_PAYLOAD:
+	case KVM_CAP_NESTED_PREEMPTION_TIMER:
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 428c7dde6b4b3..489c3df0b49c8 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1017,6 +1017,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_VCPU_RESETS 179
 #define KVM_CAP_S390_PROTECTED 180
 #define KVM_CAP_PPC_SECURE_GUEST 181
+#define KVM_CAP_NESTED_PREEMPTION_TIMER 182
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 3f3f780c8c650..ac8e5d391356c 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -391,6 +391,8 @@ struct kvm_sync_regs {
 #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
 #define KVM_STATE_NESTED_EVMCS		0x00000004
 #define KVM_STATE_NESTED_MTF_PENDING	0x00000008
+/* Available with KVM_CAP_NESTED_PREEMPTION_TIMER */
+#define KVM_STATE_NESTED_PREEMPTION_TIMER	0x00000010
 
 #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
-- 
2.26.1.301.g55bc3eb7cb9-goog

