Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1FD51BB67B
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 08:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgD1GX7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 02:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726526AbgD1GX6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 02:23:58 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54B7C03C1A9;
        Mon, 27 Apr 2020 23:23:56 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id n16so9811206pgb.7;
        Mon, 27 Apr 2020 23:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0Bu4Zd3dsV7URxWqUsHu8lketvap8gr0AXXVtw9yqAM=;
        b=XF8PTyECj50vdI++0IB6Q2n9T+9XCqbbOBSfyM7RQe3689NG0EoGuFSqnApTfrMMBG
         8bGwENVwfGEcNeF8hp1jHeNqI33Iz6bimDgf/ROynVfOMFe/DGDXn9wVDbo/lCVFe8tk
         Ty/z3EoHNQ+zySNTj/HbZYBqjAxZOnnSngmQN6GXGqcxgOTzA5nOZqQeNakHvSRqV+wO
         w2QrCru40ViOo1czLFWttsgyo+qP2hstxO4Nb8iqqOD1yIgsajVitrgXUf/W+1e/ybHe
         oJ9nTu7o8TGXczjGz/ql0Or6YfnbHqqp6H5ZcUyXqJFwaDnbJ77onGNuU0Q+EVCW93zr
         wS0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0Bu4Zd3dsV7URxWqUsHu8lketvap8gr0AXXVtw9yqAM=;
        b=LRfAj0/1Od3WF7W1y34Pv2qUc8tqkR6Hhprvv+nJBXwNHHHw7PHDO/GJ4UIMeElR55
         lIVcx0xrHDvQ3evdaJntazCKcuheS2sTZp1w8dd67N2IT2abBd1S/K3jtdA/HlNydX/l
         DxIiFApcXth4t+cyoHMsCNgXMO5f31ZW2p7LeGUvZkY4mQAl4CW/zaMVDEBIewgAgUWH
         4ep+qhdnjekOL4rsXTz8uzpD7AzknmCljKf4RQULSQwVw3Rbo2mehfUeZDNrQ4yhwjRo
         G/O1IoVAdA4h7dHn2Hjgn8HT59tBJwmCqzIQOtF0U2ozgrAsvEc3bKrsb/92mn+rLWRT
         rpsg==
X-Gm-Message-State: AGi0Pub89AcFYfjB0IE6fUuPFw3lJxQcCqNH+o8ybBVP6YCVbx2zmv5n
        D1PzKavXbC/IniLPu1aQtdzU72fn
X-Google-Smtp-Source: APiQypLSqmV3V1oAkhuUWHZMJgVrTwPZnAvh5rL2Y5gXYLMNs4ozWDv5FaFSrgenCITB9WfzTFPyiA==
X-Received: by 2002:a63:7050:: with SMTP id a16mr15041579pgn.105.1588055036254;
        Mon, 27 Apr 2020 23:23:56 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id u188sm14183071pfu.33.2020.04.27.23.23.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Apr 2020 23:23:55 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH v4 6/7] KVM: X86: TSCDEADLINE MSR emulation fastpath
Date:   Tue, 28 Apr 2020 14:23:28 +0800
Message-Id: <1588055009-12677-7-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588055009-12677-1-git-send-email-wanpengli@tencent.com>
References: <1588055009-12677-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

This patch implements tscdealine msr emulation fastpath, after wrmsr 
tscdeadline vmexit, handle it as soon as possible and vmentry immediately 
without checking various kvm stuff when possible.

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c   | 18 ++++++++++++------
 arch/x86/kvm/vmx/vmx.c | 12 ++++++++----
 arch/x86/kvm/x86.c     | 30 ++++++++++++++++++++++++------
 3 files changed, 44 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 38f7dc9..3589237 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1593,7 +1593,7 @@ static void kvm_apic_inject_pending_timer_irqs(struct kvm_lapic *apic)
 	}
 }
 
-static void apic_timer_expired(struct kvm_lapic *apic)
+static void apic_timer_expired(struct kvm_lapic *apic, bool from_timer_fn)
 {
 	struct kvm_vcpu *vcpu = apic->vcpu;
 	struct kvm_timer *ktimer = &apic->lapic_timer;
@@ -1604,6 +1604,12 @@ static void apic_timer_expired(struct kvm_lapic *apic)
 	if (apic_lvtt_tscdeadline(apic) || ktimer->hv_timer_in_use)
 		ktimer->expired_tscdeadline = ktimer->tscdeadline;
 
+	if (!from_timer_fn && vcpu->arch.apicv_active) {
+		WARN_ON(kvm_get_running_vcpu() != vcpu);
+		kvm_apic_inject_pending_timer_irqs(apic);
+		return;
+	}
+
 	if (kvm_use_posted_timer_interrupt(apic->vcpu)) {
 		if (apic->lapic_timer.timer_advance_ns)
 			__kvm_wait_lapic_expire(vcpu);
@@ -1643,7 +1649,7 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
 		expire = ktime_sub_ns(expire, ktimer->timer_advance_ns);
 		hrtimer_start(&ktimer->timer, expire, HRTIMER_MODE_ABS_HARD);
 	} else
-		apic_timer_expired(apic);
+		apic_timer_expired(apic, false);
 
 	local_irq_restore(flags);
 }
@@ -1751,7 +1757,7 @@ static void start_sw_period(struct kvm_lapic *apic)
 
 	if (ktime_after(ktime_get(),
 			apic->lapic_timer.target_expiration)) {
-		apic_timer_expired(apic);
+		apic_timer_expired(apic, false);
 
 		if (apic_lvtt_oneshot(apic))
 			return;
@@ -1813,7 +1819,7 @@ static bool start_hv_timer(struct kvm_lapic *apic)
 		if (atomic_read(&ktimer->pending)) {
 			cancel_hv_timer(apic);
 		} else if (expired) {
-			apic_timer_expired(apic);
+			apic_timer_expired(apic, false);
 			cancel_hv_timer(apic);
 		}
 	}
@@ -1863,7 +1869,7 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu)
 		goto out;
 	WARN_ON(swait_active(&vcpu->wq));
 	cancel_hv_timer(apic);
-	apic_timer_expired(apic);
+	apic_timer_expired(apic, false);
 
 	if (apic_lvtt_period(apic) && apic->lapic_timer.period) {
 		advance_periodic_target_expiration(apic);
@@ -2369,7 +2375,7 @@ static enum hrtimer_restart apic_timer_fn(struct hrtimer *data)
 	struct kvm_timer *ktimer = container_of(data, struct kvm_timer, timer);
 	struct kvm_lapic *apic = container_of(ktimer, struct kvm_lapic, lapic_timer);
 
-	apic_timer_expired(apic);
+	apic_timer_expired(apic, true);
 
 	if (lapic_is_periodic(apic)) {
 		advance_periodic_target_expiration(apic);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ce19b0e..bb5c4f1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5994,7 +5994,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	if (exit_fastpath == EXIT_FASTPATH_SKIP_EMUL_INS) {
 		kvm_skip_emulated_instruction(vcpu);
 		return 1;
-	}
+	} else if (exit_fastpath == EXIT_FASTPATH_NOP)
+		return 1;
 
 	if (exit_reason >= kvm_vmx_max_exit_handlers)
 		goto unexpected_vmexit;
@@ -6605,6 +6606,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long cr3, cr4;
 
+REENTER_GUEST:
 	/* Record the guest's net vcpu time for enforced NMI injections. */
 	if (unlikely(!enable_vnmi &&
 		     vmx->loaded_vmcs->soft_vnmi_blocked))
@@ -6779,10 +6781,12 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
 	if (exit_fastpath == EXIT_FASTPATH_REENTER_GUEST) {
-		if (!kvm_vcpu_exit_request(vcpu))
+		if (!kvm_vcpu_exit_request(vcpu)) {
 			vmx_sync_pir_to_irr(vcpu);
-		else
-			exit_fastpath = EXIT_FASTPATH_NOP;
+			/* static call is better with retpolines */
+			goto REENTER_GUEST;
+		}
+		exit_fastpath = EXIT_FASTPATH_NOP;
 	}
 
 	return exit_fastpath;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index afe052c..f3a5fe4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1616,27 +1616,45 @@ static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data
 	return 1;
 }
 
+static int handle_fastpath_set_tscdeadline(struct kvm_vcpu *vcpu, u64 data)
+{
+	if (!kvm_x86_ops.set_hv_timer ||
+		kvm_mwait_in_guest(vcpu->kvm) ||
+		kvm_can_post_timer_interrupt(vcpu))
+		return 1;
+
+	kvm_set_lapic_tscdeadline_msr(vcpu, data);
+	return 0;
+}
+
 fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 {
 	u32 msr = kvm_rcx_read(vcpu);
 	u64 data;
-	int ret = 0;
+	int ret = EXIT_FASTPATH_NONE;
 
 	switch (msr) {
 	case APIC_BASE_MSR + (APIC_ICR >> 4):
 		data = kvm_read_edx_eax(vcpu);
-		ret = handle_fastpath_set_x2apic_icr_irqoff(vcpu, data);
+		if (!handle_fastpath_set_x2apic_icr_irqoff(vcpu, data))
+			ret = EXIT_FASTPATH_SKIP_EMUL_INS;
+		break;
+	case MSR_IA32_TSCDEADLINE:
+		data = kvm_read_edx_eax(vcpu);
+		if (!handle_fastpath_set_tscdeadline(vcpu, data))
+			ret = EXIT_FASTPATH_REENTER_GUEST;
 		break;
 	default:
-		return EXIT_FASTPATH_NONE;
+		ret = EXIT_FASTPATH_NONE;
 	}
 
-	if (!ret) {
+	if (ret != EXIT_FASTPATH_NONE) {
 		trace_kvm_msr_write(msr, data);
-		return EXIT_FASTPATH_SKIP_EMUL_INS;
+		if (ret == EXIT_FASTPATH_REENTER_GUEST)
+			kvm_skip_emulated_instruction(vcpu);
 	}
 
-	return EXIT_FASTPATH_NONE;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(handle_fastpath_set_msr_irqoff);
 
-- 
2.7.4

