Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0DD1DDEEF
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 06:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgEVEgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 00:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgEVEgs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 00:36:48 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9A2C061A0E
        for <kvm@vger.kernel.org>; Thu, 21 May 2020 21:36:48 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id y8so7876981ybn.20
        for <kvm@vger.kernel.org>; Thu, 21 May 2020 21:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2s72EBzGOYx6MLiJ7HRWfq1usnoRef07p4Fksd+N7dA=;
        b=Xz/L+x8LjVZOP3Q1eF4WFDbbOcXV3dPkjpgfGWYLnvZl/I+1H4GFN7o+MHU+nDHGA+
         0bLiru+upZ/Ze7487oHHEiAcXFyl7jCgQ7gLl1V6YShhtubQr64A9b0G30dpsNaZU4sz
         WSIL6hT1wPAGa0/z0XdB1Pgn+GoI/MdyC+6bRQfe7fE1+ky7IcoBt/s8UZk/pWGcVyJK
         jKLB2spu2mGpYFYWRX3LI0Q1UDELAwY1in+aaErjM3v1LWWIpnbS+yf40Exkgh7/8gA7
         dVL5W/e2zj7o+mBWWVEkEsl68JmEsQyTR/p7VffzgzxiJ+2vIpZECMP+foFz6BbyFyDs
         0SOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2s72EBzGOYx6MLiJ7HRWfq1usnoRef07p4Fksd+N7dA=;
        b=AnUFE8lP1qOiVgLex3lkuhu/Zscp01ngkHvZ+hcN7aPysWb09J6HMSu0WjrEjCghgN
         fR8H7ZucwlQnNmhSHCSiikNdtHMZwHRvdjkTaEB9v9mN+aQXeSot8+f5N9PsLuUQu82M
         4pvfigyGjAXKaGdJQiBo1dnMgVhO+Exqd8xqRsG4nFZjaE32K1kxiZfPlwz338DkGlQl
         3XyI8zG8HQUO8J71+O6PB4Pm0Lkeg00C5yxx0i3huWal9hKkgTweDPFpr5wVWjUTLtjH
         EAABtb3WWU7d6a7aL0pZVKPP0+cdTV+dzIYD2/sfc8tJAy4j3GBHBDgHHOje0wZGZ8n3
         6hkQ==
X-Gm-Message-State: AOAM531jZQXMcjLhoF6h5b6zsm4OaOn9zQHkq7A//LezcQP3dxEjMqIW
        rcxuJwg6PgAMR2lkgyZiaqmDPhHH6zehtqNVovFQ290iyOThCMEaAVJR9iii5BjGes9k8sEWA58
        WmtsLDL9Jhw8bQqlvOdv2rcmOVxkhT1OxJTT5q2xl7KTtywyO3mqqEnfgdmuC6cAE1530VuBz3Y
        9zfoA=
X-Google-Smtp-Source: ABdhPJxhml+HE6vZrz1NJpO2iKfmaLgiz90O9J/LLwaE+8mhgf0v8xcM7CuANWfi8NRobMTvczK4DkCCFl1ufPdARPUq2Q==
X-Received: by 2002:a25:9107:: with SMTP id v7mr10429511ybl.0.1590122207656;
 Thu, 21 May 2020 21:36:47 -0700 (PDT)
Date:   Thu, 21 May 2020 21:36:33 -0700
In-Reply-To: <20200522043634.79779-1-makarandsonare@google.com>
Message-Id: <20200522043634.79779-2-makarandsonare@google.com>
Mime-Version: 1.0
References: <20200522043634.79779-1-makarandsonare@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH  1/2 v4] KVM: nVMX: Fix VMX preemption timer migration
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
 Documentation/virt/kvm/api.rst  |  5 +++
 arch/x86/include/uapi/asm/kvm.h |  4 +++
 arch/x86/kvm/vmx/nested.c       | 58 ++++++++++++++++++++++++++++-----
 arch/x86/kvm/vmx/vmx.h          |  2 ++
 arch/x86/kvm/x86.c              |  1 +
 include/uapi/linux/kvm.h        |  1 +
 6 files changed, 62 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d871dacb984e9..a5ebe88cb7348 100644
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

@@ -4335,8 +4338,10 @@ Errors:
   #define KVM_STATE_NESTED_VMX_SMM_VMXON	0x00000002

   struct kvm_vmx_nested_state_hdr {
+	__u32 flags;
 	__u64 vmxon_pa;
 	__u64 vmcs12_pa;
+	__u64 preemption_timer_deadline;

 	struct {
 		__u16 flags;
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 3f3f780c8c650..ae7ccb5e8747d 100644
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
@@ -403,8 +405,10 @@ struct kvm_vmx_nested_state_data {
 };

 struct kvm_vmx_nested_state_hdr {
+	__u32 flags;
 	__u64 vmxon_pa;
 	__u64 vmcs12_pa;
+	__u64 preemption_timer_deadline;

 	struct {
 		__u16 flags;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 51ebb60e1533a..a50cb99c4ed01 100644
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
+					KVM_STATE_NESTED_PREEMPTION_TIMER;
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
@@ -6056,7 +6089,8 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	 */
 	if (is_smm(vcpu) ?
 		(kvm_state->flags &
-		 (KVM_STATE_NESTED_GUEST_MODE | KVM_STATE_NESTED_RUN_PENDING))
+		 (KVM_STATE_NESTED_GUEST_MODE | KVM_STATE_NESTED_RUN_PENDING |
+		  KVM_STATE_NESTED_PREEMPTION_TIMER))
 		: kvm_state->hdr.vmx.smm.flags)
 		return -EINVAL;

@@ -6146,6 +6180,12 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 			goto error_guest_mode;
 	}

+	if (kvm_state->hdr.vmx.flags & KVM_STATE_NESTED_PREEMPTION_TIMER) {
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
index 471fccf7f8501..e73309879255c 100644
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
2.27.0.rc0.183.gde8f92d652-goog

