Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DCE1E317C
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 23:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389442AbgEZVvX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 17:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389149AbgEZVvW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 17:51:22 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CB1C03E96D
        for <kvm@vger.kernel.org>; Tue, 26 May 2020 14:51:21 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f187so1146220ybc.2
        for <kvm@vger.kernel.org>; Tue, 26 May 2020 14:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JWHMF6JVg9lYwlo4tr9+Htsvw+KzVzNxLnrw8YBwH6c=;
        b=MhqEZpLG03Wq1E83RP3x30fTHcGwsPZ/E+OFRrDz0noKa0hIrFa99Hd71ByeBL1Cbo
         skGcdkFfUaDG+XD+CZPR1NrkGKK5n0IDXQto3vjkd+cM+eZucb0W9gHreDIsnRwU1NsI
         SadoAPlpi9WBkiE3Ebn2PV4rVfOPJlSQqovp/BB7kS1CBGhwNDyNCTOQI53ruwyd/fa2
         eTYD/qfstMsrL3NNoyeYePnJiYj3r5vAWl6JMEh0X+G8iuCJDCwWP/PgWfImpxB2eCKZ
         Ok2P07olFErkrxgeRS1nhSpSGhYPRZUevMYsNF9CGXlETCViqI0AYUfHDpXhAjA8rdp/
         F4DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JWHMF6JVg9lYwlo4tr9+Htsvw+KzVzNxLnrw8YBwH6c=;
        b=WLt1H+u4xpWOnMxIWHsjZtNfzaVWes74TiMRkDIJHrwwSuEvTh8qFAiAxxetmxt5lJ
         ySchVb3gWxbu6nwlFQc3dEsUGLKm9xavlWnel1oNZ0P1VjtE9T5uIUHrMuMms2o0qvWa
         TDOfmm597f7tKtHR/87kUZBN5WiTYvaWfkOv2y03ApiDb8+tBkAvaaRv+OWysonoNo7a
         zTItT0+pvxYAdS+GD90FJkLj1jxqtNP+mKJ7ViiV/a7ukASIr7Tmg9x3HE6FBVm+7TvE
         W7VcofLuQ+1GwdnCZW/TLZ4UPYaxtCXrD7/EzQx6T8cYj6cvuaY9NEgMCMKJ/ywVUytn
         YzBg==
X-Gm-Message-State: AOAM533fMbxKKJ2YzjYGbZoZ5214quW0Lg1CLdIBMYyOPc5mInB6FFl0
        VuzFsZUEiDW5q54RGQ1wyVfTjPB1NUrlKxOSgip53wmnB1CJSt2HcdBKBSTCVysPbR6m8v2n0B/
        peXwAlMqzG4t6LFacbQKyBA03tKSxLIuuJc9mfHSlWN0D5G0AfUuiy9w5MYsJmWRt8JpEi9DhYZ
        HcfMY=
X-Google-Smtp-Source: ABdhPJxg3x4U0WIFdPA4MmlaQ/QG/G6ofjN4hRENHhXBx5fBqV7hcnty4PB2VL+O5fedW4m4w+5aAAU1tJKslM8sW0Gspw==
X-Received: by 2002:a25:b70b:: with SMTP id t11mr5071882ybj.171.1590529880720;
 Tue, 26 May 2020 14:51:20 -0700 (PDT)
Date:   Tue, 26 May 2020 14:51:06 -0700
In-Reply-To: <20200526215107.205814-1-makarandsonare@google.com>
Message-Id: <20200526215107.205814-2-makarandsonare@google.com>
Mime-Version: 1.0
References: <20200526215107.205814-1-makarandsonare@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH  1/2 v5] KVM: nVMX: Fix VMX preemption timer migration
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
---
 Documentation/virt/kvm/api.rst  |  4 +++
 arch/x86/include/uapi/asm/kvm.h |  4 +++
 arch/x86/kvm/vmx/nested.c       | 55 ++++++++++++++++++++++++++++-----
 arch/x86/kvm/vmx/vmx.h          |  2 ++
 4 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d871dacb984e9..31d6402cb6532 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4334,9 +4334,13 @@ Errors:
   #define KVM_STATE_NESTED_VMX_SMM_GUEST_MODE	0x00000001
   #define KVM_STATE_NESTED_VMX_SMM_VMXON	0x00000002

+#define KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE 0x00000001
+
   struct kvm_vmx_nested_state_hdr {
+	__u32 flags;
 	__u64 vmxon_pa;
 	__u64 vmcs12_pa;
+	__u64 preemption_timer_deadline;

 	struct {
 		__u16 flags;
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 3f3f780c8c650..acc26eb880eec 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -397,14 +397,18 @@ struct kvm_sync_regs {

 #define KVM_STATE_NESTED_VMX_VMCS_SIZE	0x1000

+#define KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE	0x00000001
+
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
 	__u8 shadow_vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
 };

 struct kvm_vmx_nested_state_hdr {
+	__u32 flags;
 	__u64 vmxon_pa;
 	__u64 vmcs12_pa;
+	__u64 preemption_timer_deadline;

 	struct {
 		__u16 flags;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 51ebb60e1533a..00db8a04d3c87 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2092,9 +2092,29 @@ static enum hrtimer_restart vmx_preemption_timer_fn(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }

-static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu)
+static u64 vmx_calc_preemption_timer_value(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+	u64 timer_value = 0;
+
+	u64 l1_scaled_tsc = kvm_read_l1_tsc(vcpu, rdtsc()) >>
+			    VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE;
+
+	if (!vmx->nested.has_preemption_timer_deadline) {
+		timer_value = vmcs12->vmx_preemption_timer_value;
+		vmx->nested.preemption_timer_deadline = timer_value +
+							l1_scaled_tsc;
+		vmx->nested.has_preemption_timer_deadline = true;
+	} else if (l1_scaled_tsc < vmx->nested.preemption_timer_deadline)
+		timer_value = vmx->nested.preemption_timer_deadline -
+			      l1_scaled_tsc;
+	return timer_value;
+}
+
+static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu,
+					u64 preemption_timeout)
 {
-	u64 preemption_timeout = get_vmcs12(vcpu)->vmx_preemption_timer_value;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);

 	/*
@@ -3353,8 +3373,10 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	 * the timer.
 	 */
 	vmx->nested.preemption_timer_expired = false;
-	if (nested_cpu_has_preemption_timer(vmcs12))
-		vmx_start_preemption_timer(vcpu);
+	if (nested_cpu_has_preemption_timer(vmcs12)) {
+		u64 timer_value = vmx_calc_preemption_timer_value(vcpu);
+		vmx_start_preemption_timer(vcpu, timer_value);
+	}

 	/*
 	 * Note no nested_vmx_succeed or nested_vmx_fail here. At this point
@@ -3462,6 +3484,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	 * the nested entry.
 	 */
 	vmx->nested.nested_run_pending = 1;
+	vmx->nested.has_preemption_timer_deadline = false;
 	status = nested_vmx_enter_non_root_mode(vcpu, true);
 	if (unlikely(status != NVMX_VMENTRY_SUCCESS))
 		goto vmentry_failed;
@@ -3962,9 +3985,10 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 		vmcs12->guest_activity_state = GUEST_ACTIVITY_ACTIVE;

 	if (nested_cpu_has_preemption_timer(vmcs12) &&
-	    vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
-			vmcs12->vmx_preemption_timer_value =
-				vmx_get_preemption_timer_value(vcpu);
+	    vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER &&
+	    !vmx->nested.nested_run_pending)
+		vmcs12->vmx_preemption_timer_value =
+			vmx_get_preemption_timer_value(vcpu);

 	/*
 	 * In some cases (usually, nested EPT), L2 is allowed to change its
@@ -5896,8 +5920,10 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 		.flags = 0,
 		.format = KVM_STATE_NESTED_FORMAT_VMX,
 		.size = sizeof(kvm_state),
+		.hdr.vmx.flags = 0,
 		.hdr.vmx.vmxon_pa = -1ull,
 		.hdr.vmx.vmcs12_pa = -1ull,
+		.hdr.vmx.preemption_timer_deadline = 0,
 	};
 	struct kvm_vmx_nested_state_data __user *user_vmx_nested_state =
 		&user_kvm_nested_state->data.vmx[0];
@@ -5939,6 +5965,14 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,

 			if (vmx->nested.mtf_pending)
 				kvm_state.flags |= KVM_STATE_NESTED_MTF_PENDING;
+
+			if (nested_cpu_has_preemption_timer(vmcs12) &&
+			    vmx->nested.has_preemption_timer_deadline) {
+				kvm_state.hdr.vmx.flags |=
+					KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE;
+				kvm_state.hdr.vmx.preemption_timer_deadline =
+					vmx->nested.preemption_timer_deadline;
+			}
 		}
 	}

@@ -5984,7 +6018,6 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 				 get_shadow_vmcs12(vcpu), VMCS12_SIZE))
 			return -EFAULT;
 	}
-
 out:
 	return kvm_state.size;
 }
@@ -6146,6 +6179,12 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 			goto error_guest_mode;
 	}

+	if (kvm_state->hdr.vmx.flags & KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE) {
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
--
2.27.0.rc0.183.gde8f92d652-goog

