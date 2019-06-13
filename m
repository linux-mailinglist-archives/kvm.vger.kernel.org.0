Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2011344829
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729523AbfFMREw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:04:52 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50213 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404677AbfFMRER (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:04:17 -0400
Received: by mail-wm1-f66.google.com with SMTP id c66so10987051wmf.0;
        Thu, 13 Jun 2019 10:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GnyD2ISmRvKW1tL/yBGfEhcX6hgHUzpqVqQQO5wbTXo=;
        b=NbCH1Z4zkWKYKB7iO9ICrZhtk6c4G3BtNEzKNeii3yr9wE5qYPUICcZlRLbu+eywEx
         Wl+abOENjcRwRP3aInVhPWKUmhUACi9l6yU+2XFdm+qInlZLK7Jm0E1IAskcP7GWrJiK
         W1cPomWFxPgDCSjh8aaIznYvNt64eQTv4qlLJPAbzKAaYyxkWBKmf/ukH1o5X1+YNh0B
         QTiBngME2nvLshQW8PdZdf7pAe5WF+rTi25EBT9ODt8CUvBDX59ZX9dJn/qN60ittdFm
         BCTf9XbPgCEyBPwUsfW1C5CuQ775BuZb9PalYpQvrWdaSQuh+jUEahWXzywQLCWamQge
         SYtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=GnyD2ISmRvKW1tL/yBGfEhcX6hgHUzpqVqQQO5wbTXo=;
        b=I8zMoCHpvRQEdYJ7+Kg6SVBl9pSkAknbIXM1opQJn7TaLOPByRUVdJslceX8wwDs4N
         L/zHKZMZzsiboh+ZKksSM7kouhVMA59WTiiu9dSZrR52eeTHq9ejrC0lHe+euEBeVNJy
         +aLaRSphXauxOQniDcJ8s6K2ZWG3pCYH57a8h6XxgY+kcLypsMRIE3Wlh7qoNOVuQMKA
         bZ9vqllnomIOADJXJ/mAedfQ/UE8ooWou+RdhQZkzvPRmLEo/G1VYtE0hiO9jObuHzAu
         7+xOPT7wwjJ3/Vta1rgMtQI/v3dMDq3MpHqN4rSsktRVwTcAC/e9miI1Rdo6c1V4bY+P
         z/dQ==
X-Gm-Message-State: APjAAAUfJq1rXjL+Q9qNeiYT0nU26CKFXA0QEP8isG37GtnX/eCXUALs
        oypcbCgmBvvCgoFzi9i1Ov8zJ37s
X-Google-Smtp-Source: APXvYqx9Whn3BuFNrZJ2hpyZh5zU81sFKsHNZ2V6aCwgvcvW3Xwi70j7/5esic+5P2OR9jh/H3nhnw==
X-Received: by 2002:a1c:544d:: with SMTP id p13mr4824014wmi.78.1560445454366;
        Thu, 13 Jun 2019 10:04:14 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.04.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:04:13 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 42/43] KVM: VMX: Leave preemption timer running when it's disabled
Date:   Thu, 13 Jun 2019 19:03:28 +0200
Message-Id: <1560445409-17363-43-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

VMWRITEs to the major VMCS controls, pin controls included, are
deceptively expensive.  CPUs with VMCS caching (Westmere and later) also
optimize away consistency checks on VM-Entry, i.e. skip consistency
checks if the relevant fields have not changed since the last successful
VM-Entry (of the cached VMCS).  Because uops are a precious commodity,
uCode's dirty VMCS field tracking isn't as precise as software would
prefer.  Notably, writing any of the major VMCS fields effectively marks
the entire VMCS dirty, i.e. causes the next VM-Entry to perform all
consistency checks, which consumes several hundred cycles.

As it pertains to KVM, toggling PIN_BASED_VMX_PREEMPTION_TIMER more than
doubles the latency of the next VM-Entry (and again when/if the flag is
toggled back).  In a non-nested scenario, running a "standard" guest
with the preemption timer enabled, toggling the timer flag is uncommon
but not rare, e.g. roughly 1 in 10 entries.  Disabling the preemption
timer can change these numbers due to its use for "immediate exits",
even when explicitly disabled by userspace.

Nested virtualization in particular is painful, as the timer flag is set
for the majority of VM-Enters, but prepare_vmcs02() initializes vmcs02's
pin controls to *clear* the flag since its the timer's final state isn't
known until vmx_vcpu_run().  I.e. the majority of nested VM-Enters end
up unnecessarily writing pin controls *twice*.

Rather than toggle the timer flag in pin controls, set the timer value
itself to the largest allowed value to put it into a "soft disabled"
state, and ignore any spurious preemption timer exits.

Sadly, the timer is a 32-bit value and so theoretically it can fire
before the head death of the universe, i.e. spurious exits are possible.
But because KVM does *not* save the timer value on VM-Exit and because
the timer runs at a slower rate than the TSC, the maximuma timer value
is still sufficiently large for KVM's purposes.  E.g. on a modern CPU
with a timer that runs at 1/32 the frequency of a 2.4ghz constant-rate
TSC, the timer will fire after ~55 seconds of *uninterrupted* guest
execution.  In other words, spurious VM-Exits are effectively only
possible if the *host* is tickless on the logical CPU, the guest is
not using the preemption timer, and the guest is not generating VM-Exits
for *any* other reason.

To be safe from bad/weird hardware, disable the preemption timer if its
maximum delay is less than ten seconds.  Ten seconds is mostly arbitrary
and was selected in no small part because it's a nice round number.
For simplicity and paranoia, fall back to __kvm_request_immediate_exit()
if the preemption timer is disabled by KVM or userspace.  Previously
KVM continued to use the preemption timer to force immediate exits even
when the timer was disabled by userspace.  Now that KVM leaves the timer
running instead of truly disabling it, allow userspace to kill it
entirely in the unlikely event the timer (or KVM) malfunctions.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c |  5 ++--
 arch/x86/kvm/vmx/vmcs.h   |  1 +
 arch/x86/kvm/vmx/vmx.c    | 60 ++++++++++++++++++++++++++++++-----------------
 3 files changed, 41 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 33d6598709cb..cdb74106b2b5 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2012,9 +2012,8 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	 * PIN CONTROLS
 	 */
 	exec_control = vmx_pin_based_exec_ctrl(vmx);
-	exec_control |= vmcs12->pin_based_vm_exec_control;
-	/* Preemption timer setting is computed directly in vmx_vcpu_run.  */
-	exec_control &= ~PIN_BASED_VMX_PREEMPTION_TIMER;
+	exec_control |= (vmcs12->pin_based_vm_exec_control &
+			 ~PIN_BASED_VMX_PREEMPTION_TIMER);
 
 	/* Posted interrupts setting is only taken from vmcs12.  */
 	if (nested_cpu_has_posted_intr(vmcs12)) {
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index 9a87a2482e3e..481ad879197b 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -61,6 +61,7 @@ struct loaded_vmcs {
 	int cpu;
 	bool launched;
 	bool nmi_known_unmasked;
+	bool hv_timer_soft_disabled;
 	/* Support for vnmi-less CPUs */
 	int soft_vnmi_blocked;
 	ktime_t entry_time;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 86f29ab22dec..aa08a16b301d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2465,6 +2465,7 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
 		return -ENOMEM;
 
 	loaded_vmcs->shadow_vmcs = NULL;
+	loaded_vmcs->hv_timer_soft_disabled = false;
 	loaded_vmcs_init(loaded_vmcs);
 
 	if (cpu_has_vmx_msr_bitmap()) {
@@ -3835,8 +3836,9 @@ u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx)
 	if (!enable_vnmi)
 		pin_based_exec_ctrl &= ~PIN_BASED_VIRTUAL_NMIS;
 
-	/* Enable the preemption timer dynamically */
-	pin_based_exec_ctrl &= ~PIN_BASED_VMX_PREEMPTION_TIMER;
+	if (!enable_preemption_timer)
+		pin_based_exec_ctrl &= ~PIN_BASED_VMX_PREEMPTION_TIMER;
+
 	return pin_based_exec_ctrl;
 }
 
@@ -5455,8 +5457,12 @@ static int handle_pml_full(struct kvm_vcpu *vcpu)
 
 static int handle_preemption_timer(struct kvm_vcpu *vcpu)
 {
-	if (!to_vmx(vcpu)->req_immediate_exit)
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (!vmx->req_immediate_exit &&
+	    !unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled))
 		kvm_lapic_expired_hv_timer(vcpu);
+
 	return 1;
 }
 
@@ -6356,12 +6362,6 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 					msrs[i].host, false);
 }
 
-static void vmx_arm_hv_timer(struct vcpu_vmx *vmx, u32 val)
-{
-	vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, val);
-	pin_controls_setbit(vmx, PIN_BASED_VMX_PREEMPTION_TIMER);
-}
-
 static void vmx_update_hv_timer(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -6369,11 +6369,9 @@ static void vmx_update_hv_timer(struct kvm_vcpu *vcpu)
 	u32 delta_tsc;
 
 	if (vmx->req_immediate_exit) {
-		vmx_arm_hv_timer(vmx, 0);
-		return;
-	}
-
-	if (vmx->hv_deadline_tsc != -1) {
+		vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, 0);
+		vmx->loaded_vmcs->hv_timer_soft_disabled = false;
+	} else if (vmx->hv_deadline_tsc != -1) {
 		tscl = rdtsc();
 		if (vmx->hv_deadline_tsc > tscl)
 			/* set_hv_timer ensures the delta fits in 32-bits */
@@ -6382,11 +6380,12 @@ static void vmx_update_hv_timer(struct kvm_vcpu *vcpu)
 		else
 			delta_tsc = 0;
 
-		vmx_arm_hv_timer(vmx, delta_tsc);
-		return;
+		vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, delta_tsc);
+		vmx->loaded_vmcs->hv_timer_soft_disabled = false;
+	} else if (!vmx->loaded_vmcs->hv_timer_soft_disabled) {
+		vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, -1);
+		vmx->loaded_vmcs->hv_timer_soft_disabled = true;
 	}
-
-	pin_controls_clearbit(vmx, PIN_BASED_VMX_PREEMPTION_TIMER);
 }
 
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
@@ -6458,7 +6457,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	atomic_switch_perf_msrs(vmx);
 
-	vmx_update_hv_timer(vcpu);
+	if (enable_preemption_timer)
+		vmx_update_hv_timer(vcpu);
 
 	if (lapic_in_kernel(vcpu) &&
 		vcpu->arch.apic->lapic_timer.timer_advance_ns)
@@ -7565,17 +7565,33 @@ static __init int hardware_setup(void)
 	}
 
 	if (!cpu_has_vmx_preemption_timer())
-		kvm_x86_ops->request_immediate_exit = __kvm_request_immediate_exit;
+		enable_preemption_timer = false;
 
-	if (cpu_has_vmx_preemption_timer() && enable_preemption_timer) {
+	if (enable_preemption_timer) {
+		u64 use_timer_freq = 5000ULL * 1000 * 1000;
 		u64 vmx_msr;
 
 		rdmsrl(MSR_IA32_VMX_MISC, vmx_msr);
 		cpu_preemption_timer_multi =
 			vmx_msr & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
-	} else {
+
+		if (tsc_khz)
+			use_timer_freq = (u64)tsc_khz * 1000;
+		use_timer_freq >>= cpu_preemption_timer_multi;
+
+		/*
+		 * KVM "disables" the preemption timer by setting it to its max
+		 * value.  Don't use the timer if it might cause spurious exits
+		 * at a rate faster than 0.1 Hz (of uninterrupted guest time).
+		 */
+		if ((0xffffffffu / use_timer_freq) < 10)
+			enable_preemption_timer = false;
+	}
+
+	if (!enable_preemption_timer) {
 		kvm_x86_ops->set_hv_timer = NULL;
 		kvm_x86_ops->cancel_hv_timer = NULL;
+		kvm_x86_ops->request_immediate_exit = __kvm_request_immediate_exit;
 	}
 
 	kvm_set_posted_intr_wakeup_handler(wakeup_handler);
-- 
1.8.3.1


