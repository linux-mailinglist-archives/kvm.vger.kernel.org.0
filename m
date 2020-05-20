Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94ABE1DC2D4
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 01:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbgETXWs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 19:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728824AbgETXWr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 19:22:47 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5FD4C061A0E
        for <kvm@vger.kernel.org>; Wed, 20 May 2020 16:22:47 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id a7so5391359qvl.2
        for <kvm@vger.kernel.org>; Wed, 20 May 2020 16:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VxsMS554JLWR89iPy9mpF/D/2CTXeEOUZcB+1twaBHo=;
        b=Iewzmn0SR81kwOZRE+Dgxy5GnPrvcy4y65rSBjxfbMLAAfrdyXsty+wLiRFHP2C/6I
         gzAyDyJeK5rL63PDEo7gTCRmEtj5NS8mvFfO7Gg5U/vDNLKBgOCeGzmLrPdXKnq1ryRZ
         nCxYMWW0BjijXIxV98H1OCLrz2h/v/v9O1W2Qvk01STarNqNmfitifZln0bi8d8DPfgG
         LlzLUZfK/FutKAduiKHumHBPAmbs513oJeblbCIAUEUEXYPvMEtUnStvBIsqWZ37PLxj
         RA8f8fqcmusTFVU/aZ2qXoUHF3IJNsdYMgY9f1WqyI/5HKGZMgLbzpCx0Dpgglv+31Dm
         uphQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VxsMS554JLWR89iPy9mpF/D/2CTXeEOUZcB+1twaBHo=;
        b=KR2LBkf1fLDXEbUcqAxoEqiNzVXtDUYhYgA2EnQHUN67fsQAoVoTfczV+3nsTC6/9A
         38IPMa33659nTNbs4bmyiZVCy6E2tBOKWfsMk8oRcIv5aUlzXTZcc462nZAB2KCRyk55
         b+Pzf5D02O/o/EowoQMG3xyxcPX+H8L5B1zUcenaGUscWl1EczN7D6vjMDd1qONGNX1w
         CjTgGyhwjaqzNQS8amWAPt8hBRKJP6uh8AA7ykX+hUlOkHjMv9EYkCob16TXdfMrycaF
         PMypkkB8okYFVWddmjEu5ADUCFowYeGLyQ+OJjYpe7GKHegRqq6qibOENy5mV+Vc2MBR
         2yUA==
X-Gm-Message-State: AOAM532zX6Y8g1dTQ34aOatRXEiHSNo/h7uHUCVaqp11DEca5mHiNJIl
        vN3DC2Ldm/3yx/8nDMmhfZGhfKAohUpa4zgcJF3o0SnpPlMl61gxTA+Y2cHBO8A4hTISWfLN+Cs
        7IsZu79TuoZO605FFdte3l6lmVJAqlWhnddod5oKCp0cGeDYIpKd5ocV3wFeqwPWFPYqnoY3ZE1
        mx3Ek=
X-Google-Smtp-Source: ABdhPJz5IaSkJAWK30LmL8uVGDneH3BwDRjmYAI1MrV+IQ3U2TrKpwY2RyGzVCkDHk4WeOjKgxCbZyLlX9qREhE2GPsE1A==
X-Received: by 2002:a0c:b2c5:: with SMTP id d5mr7492388qvf.36.1590016966853;
 Wed, 20 May 2020 16:22:46 -0700 (PDT)
Date:   Wed, 20 May 2020 16:22:27 -0700
In-Reply-To: <20200520232228.55084-1-makarandsonare@google.com>
Message-Id: <20200520232228.55084-2-makarandsonare@google.com>
Mime-Version: 1.0
References: <20200520232228.55084-1-makarandsonare@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH  1/2 v3] KVM: nVMX: Fix VMX preemption timer migration
From:   Makarand Sonare <makarandsonare@google.com>
To:     kvm@vger.kernel.org, pshier@google.com, jmattson@google.com
Cc:     Makarand Sonare <makarandsonare@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Shier <pshier@google.com>

Add new field to hold preemption timer expiration deadline
appended to struct kvm_vmx_nested_state_hdr. This is to prevent
the first VM-Enter after migration from incorrectly restarting the timer
with the full timer value instead of partially decayed timer value.
KVM_SET_NESTED_STATE restarts timer using migrated state regardless
of whether L1 sets VM_EXIT_SAVE_VMX_PREEMPTION_TIMER.

Fixes: cf8b84f48a593 ("kvm: nVMX: Prepare for checkpointing L2 state")

Signed-off-by: Peter Shier <pshier@google.com>
Signed-off-by: Makarand Sonare <makarandsonare@google.com>
Change-Id: I6446aba5a547afa667f0ef4620b1b76115bf3753
---
 Documentation/virt/kvm/api.rst  |  4 +++
 arch/x86/include/uapi/asm/kvm.h |  3 +++
 arch/x86/kvm/vmx/nested.c       | 45 ++++++++++++++++++++++++++++-----
 arch/x86/kvm/vmx/vmx.h          |  2 ++
 arch/x86/kvm/x86.c              |  3 ++-
 include/uapi/linux/kvm.h        |  1 +
 6 files changed, 50 insertions(+), 8 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d871dacb984e9..d84364cdc66a9 100644
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

@@ -4337,6 +4340,7 @@ Errors:
   struct kvm_vmx_nested_state_hdr {
 	__u64 vmxon_pa;
 	__u64 vmcs12_pa;
+	__u64 preemption_timer_deadline;

 	struct {
 		__u16 flags;
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 3f3f780c8c650..3b651cd583c0c 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -391,6 +391,8 @@ struct kvm_sync_regs {
 #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
 #define KVM_STATE_NESTED_EVMCS		0x00000004
 #define KVM_STATE_NESTED_MTF_PENDING	0x00000008
+/* Available with KVM_CAP_NESTED_STATE_PREEMPTION_TIMER */
+#define KVM_STATE_NESTED_PREEMPTION_TIMER	0x00000010

 #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
@@ -405,6 +407,7 @@ struct kvm_vmx_nested_state_data {
 struct kvm_vmx_nested_state_hdr {
 	__u64 vmxon_pa;
 	__u64 vmcs12_pa;
+	__u64 preemption_timer_deadline;

 	struct {
 		__u16 flags;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 51ebb60e1533a..46dc2ef731b37 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2092,9 +2092,9 @@ static enum hrtimer_restart vmx_preemption_timer_fn(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }

-static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu)
+static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu,
+					u64 preemption_timeout)
 {
-	u64 preemption_timeout = get_vmcs12(vcpu)->vmx_preemption_timer_value;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);

 	/*
@@ -3353,8 +3353,21 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	 * the timer.
 	 */
 	vmx->nested.preemption_timer_expired = false;
-	if (nested_cpu_has_preemption_timer(vmcs12))
-		vmx_start_preemption_timer(vcpu);
+	if (nested_cpu_has_preemption_timer(vmcs12)) {
+		u64 timer_value = 0;
+		u64 l1_scaled_tsc_value = (kvm_read_l1_tsc(vcpu, rdtsc())
+					   >> VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE);
+
+		if (!vmx->nested.has_preemption_timer_deadline) {
+			timer_value = vmcs12->vmx_preemption_timer_value;
+			vmx->nested.preemption_timer_deadline = timer_value +
+								l1_scaled_tsc_value;
+			vmx->nested.has_preemption_timer_deadline = true;
+		} else if (l1_scaled_tsc_value <= vmx->nested.preemption_timer_deadline)
+			timer_value = vmx->nested.preemption_timer_deadline -
+				      l1_scaled_tsc_value;
+		vmx_start_preemption_timer(vcpu, timer_value);
+	}

 	/*
 	 * Note no nested_vmx_succeed or nested_vmx_fail here. At this point
@@ -3462,6 +3475,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	 * the nested entry.
 	 */
 	vmx->nested.nested_run_pending = 1;
+	vmx->nested.has_preemption_timer_deadline = false;
 	status = nested_vmx_enter_non_root_mode(vcpu, true);
 	if (unlikely(status != NVMX_VMENTRY_SUCCESS))
 		goto vmentry_failed;
@@ -3962,9 +3976,11 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 		vmcs12->guest_activity_state = GUEST_ACTIVITY_ACTIVE;

 	if (nested_cpu_has_preemption_timer(vmcs12) &&
-	    vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
+	    !vmx->nested.nested_run_pending) {
+		if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
 			vmcs12->vmx_preemption_timer_value =
 				vmx_get_preemption_timer_value(vcpu);
+	}

 	/*
 	 * In some cases (usually, nested EPT), L2 is allowed to change its
@@ -5898,6 +5914,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 		.size = sizeof(kvm_state),
 		.hdr.vmx.vmxon_pa = -1ull,
 		.hdr.vmx.vmcs12_pa = -1ull,
+		.hdr.vmx.preemption_timer_deadline = 0,
 	};
 	struct kvm_vmx_nested_state_data __user *user_vmx_nested_state =
 		&user_kvm_nested_state->data.vmx[0];
@@ -5939,6 +5956,14 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,

 			if (vmx->nested.mtf_pending)
 				kvm_state.flags |= KVM_STATE_NESTED_MTF_PENDING;
+
+			if (nested_cpu_has_preemption_timer(vmcs12) &&
+			    vmx->nested.has_preemption_timer_deadline) {
+				kvm_state.flags |=
+					KVM_STATE_NESTED_PREEMPTION_TIMER;
+				kvm_state.hdr.vmx.preemption_timer_deadline =
+					vmx->nested.preemption_timer_deadline;
+			}
 		}
 	}

@@ -5984,7 +6009,6 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 				 get_shadow_vmcs12(vcpu), VMCS12_SIZE))
 			return -EFAULT;
 	}
-
 out:
 	return kvm_state.size;
 }
@@ -6056,7 +6080,8 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	 */
 	if (is_smm(vcpu) ?
 		(kvm_state->flags &
-		 (KVM_STATE_NESTED_GUEST_MODE | KVM_STATE_NESTED_RUN_PENDING))
+		 (KVM_STATE_NESTED_GUEST_MODE | KVM_STATE_NESTED_RUN_PENDING |
+		  KVM_STATE_NESTED_PREEMPTION_TIMER))
 		: kvm_state->hdr.vmx.smm.flags)
 		return -EINVAL;

@@ -6146,6 +6171,12 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 			goto error_guest_mode;
 	}

+	if (kvm_state->flags & KVM_STATE_NESTED_PREEMPTION_TIMER) {
+		vmx->nested.has_preemption_timer_deadline = true;
+		vmx->nested.preemption_timer_deadline =
+			kvm_state->hdr.vmx.preemption_timer_deadline;
+	}
+
 	if (nested_vmx_check_controls(vcpu, vmcs12) ||
 	    nested_vmx_check_host_state(vcpu, vmcs12) ||
 	    nested_vmx_check_guest_state(vcpu, vmcs12, &ignored))
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 298ddef79d009..672c28f17e497 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -169,6 +169,8 @@ struct nested_vmx {
 	u16 posted_intr_nv;

 	struct hrtimer preemption_timer;
+	u64 preemption_timer_deadline;
+	bool has_preemption_timer_deadline;
 	bool preemption_timer_expired;

 	/* to migrate it to L2 if VM_ENTRY_LOAD_DEBUG_CONTROLS is off */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 471fccf7f8501..ba9e62ffbb4cd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3418,6 +3418,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MSR_PLATFORM_INFO:
 	case KVM_CAP_EXCEPTION_PAYLOAD:
 	case KVM_CAP_SET_GUEST_DEBUG:
+	case KVM_CAP_NESTED_STATE_PREEMPTION_TIMER:
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
@@ -4626,7 +4627,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,

 		if (kvm_state.flags &
 		    ~(KVM_STATE_NESTED_RUN_PENDING | KVM_STATE_NESTED_GUEST_MODE
-		      | KVM_STATE_NESTED_EVMCS))
+		      | KVM_STATE_NESTED_EVMCS | KVM_STATE_NESTED_PREEMPTION_TIMER))
 			break;

 		/* nested_run_pending implies guest_mode.  */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ac9eba0289d1b..0868dce12a715 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1018,6 +1018,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_PROTECTED 180
 #define KVM_CAP_PPC_SECURE_GUEST 181
 #define KVM_CAP_HALT_POLL 182
+#define KVM_CAP_NESTED_STATE_PREEMPTION_TIMER 183

 #ifdef KVM_CAP_IRQ_ROUTING

--
2.26.2.761.g0e0b3e54be-goog

