Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B267017A2EC
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 11:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbgCEKOC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 05:14:02 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40013 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgCEKNz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 05:13:55 -0500
Received: by mail-wr1-f66.google.com with SMTP id r17so6252252wrj.7;
        Thu, 05 Mar 2020 02:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+xwiBse4pt803geshkaqIXQfeBC3a/woHHPXS73g1eU=;
        b=VLqnB4nk88ex/qSKxOlbqQDpn9SK79T8EeMOmTOAIHiNWtuNHzoDFTUSfKgTv1cSxM
         9s+UNG6EUf7SGkvNruSZVZX2Et95Uu527qR6zQ67s+nkIWU6vcpo2tUV+74Dw7kAJIUz
         hj6KBM0ulmhTuF4H5GvXcmtwZuzUFWmL1XoPiO1jZaR/LNY5aMsVZrCKRBLe0Oltt/JP
         lIOX2Mh+rFGVtQeEdNCQUyc2Hxcw8NWiFuuwk26x67I1AElNcxdNI9bsIMAn2qRissYR
         4zbpBy07hY9gXBx5bYXN3p50pqTSuvxUZ1hqNkSv+IKGpw1Wstp8kcM9+GdP8gL/7h2n
         Pyqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=+xwiBse4pt803geshkaqIXQfeBC3a/woHHPXS73g1eU=;
        b=txtYuoLdq2sSxmBEGFzvz2oex6eYC6V7mjLbp3rNRrpAWlpOjkZHt+d2N6c90BaxPh
         1+ZzHO+s/SMjtC6Nr/OJDRoiRVWjd0Uf6hODNGCdp6KU8B9Z/PA1Z5klqxgKTBw3pD9D
         WJrP7gCxYxJfY6on8n1m9D5FfSOkC9FH6FFiX5dBhAepHmveLoyO+zOEcOLaBcAqw71T
         gMwD3To1Jheu7VAkQ9Dy2jA3MFdO93rFkVIcbCmduA8awvsbVadIn/JcKQUhjISBiaD2
         Mkx+3C2ZpfFk5eLhTn6WRAEX5TcSW+/noJCdK0s5KDt1uo98uhqiZeAP53cYMRApmXB4
         uwpA==
X-Gm-Message-State: ANhLgQ39F+05yp7WPSWKXU1xUXNVTE+frrSpARLH6oJZ5aOAuPKz46Rz
        O3swg2RxM9y6++7kqDqsnV44Wz6u
X-Google-Smtp-Source: ADFU+vsPhWayDDOue3Jq3I6tyJGpRlf2qH1ww5lksQll8aEO2W8Q812D1c9EDi+tZ49GFkp3XY+q2w==
X-Received: by 2002:adf:de85:: with SMTP id w5mr8852269wrl.323.1583403233213;
        Thu, 05 Mar 2020 02:13:53 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id p15sm8331066wma.40.2020.03.05.02.13.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Mar 2020 02:13:52 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     cavery@redhat.com, vkuznets@redhat.com, jan.kiszka@siemens.com,
        wei.huang2@amd.com
Subject: [PATCH 3/4] KVM: nSVM: implement check_nested_events for interrupts
Date:   Thu,  5 Mar 2020 11:13:46 +0100
Message-Id: <1583403227-11432-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583403227-11432-1-git-send-email-pbonzini@redhat.com>
References: <1583403227-11432-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current implementation of physical interrupt delivery to a nested guest
is quite broken.  It relies on svm_interrupt_allowed returning false if
VINTR=1 so that the interrupt can be injected from enable_irq_window,
but this does not work for guests that do not intercept HLT or that rely
on clearing the host IF to block physical interrupts while L2 runs.

This patch can be split in two logical parts, but including only
one breaks tests so I am combining both changes together.

The first and easiest is simply to return true for svm_interrupt_allowed
if HF_VINTR_MASK is set and HIF is set.  This way the semantics of
svm_interrupt_allowed are respected: svm_interrupt_allowed being false
does not mean "call enable_irq_window", it means "interrupts cannot
be injected now".

After doing this, however, we need another place to inject the
interrupt, and fortunately we already have one, check_nested_events,
which nested SVM does not implement but which is meant exactly for this
purpose.  It is called before interrupts are injected, and it can
therefore do the L2->L1 switch while leaving inject_pending_event
none the wiser.

This patch was developed together with Cathy Avery, who wrote the
test and did a lot of the initial debugging.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm.c | 68 ++++++++++++++++++++++++------------------------------
 1 file changed, 30 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 25827b79cf96..0d773406f7ac 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3133,43 +3133,36 @@ static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 	return vmexit;
 }
 
-/* This function returns true if it is save to enable the irq window */
-static inline bool nested_svm_intr(struct vcpu_svm *svm)
+static void nested_svm_intr(struct vcpu_svm *svm)
 {
-	if (!is_guest_mode(&svm->vcpu))
-		return true;
-
-	if (!(svm->vcpu.arch.hflags & HF_VINTR_MASK))
-		return true;
-
-	if (!(svm->vcpu.arch.hflags & HF_HIF_MASK))
-		return false;
-
-	/*
-	 * if vmexit was already requested (by intercepted exception
-	 * for instance) do not overwrite it with "external interrupt"
-	 * vmexit.
-	 */
-	if (svm->nested.exit_required)
-		return false;
-
 	svm->vmcb->control.exit_code   = SVM_EXIT_INTR;
 	svm->vmcb->control.exit_info_1 = 0;
 	svm->vmcb->control.exit_info_2 = 0;
 
-	if (svm->nested.intercept & 1ULL) {
-		/*
-		 * The #vmexit can't be emulated here directly because this
-		 * code path runs with irqs and preemption disabled. A
-		 * #vmexit emulation might sleep. Only signal request for
-		 * the #vmexit here.
-		 */
-		svm->nested.exit_required = true;
-		trace_kvm_nested_intr_vmexit(svm->vmcb->save.rip);
-		return false;
+	/* nested_svm_vmexit this gets called afterwards from handle_exit */
+	svm->nested.exit_required = true;
+	trace_kvm_nested_intr_vmexit(svm->vmcb->save.rip);
+}
+
+static bool nested_exit_on_intr(struct vcpu_svm *svm)
+{
+	return (svm->nested.intercept & 1ULL);
+}
+
+static int svm_check_nested_events(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	bool block_nested_events =
+		kvm_event_needs_reinjection(vcpu) || svm->nested.exit_required;
+
+	if (kvm_cpu_has_interrupt(vcpu) && nested_exit_on_intr(svm)) {
+		if (block_nested_events)
+			return -EBUSY;
+		nested_svm_intr(svm);
+		return 0;
 	}
 
-	return true;
+	return 0;
 }
 
 /* This function returns true if it is save to enable the nmi window */
@@ -5544,18 +5537,15 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb = svm->vmcb;
-	int ret;
 
 	if (!gif_set(svm) ||
 	     (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK))
 		return 0;
 
-	ret = !!(kvm_get_rflags(vcpu) & X86_EFLAGS_IF);
-
-	if (is_guest_mode(vcpu))
-		return ret && !(svm->vcpu.arch.hflags & HF_VINTR_MASK);
-
-	return ret;
+	if (is_guest_mode(vcpu) && (svm->vcpu.arch.hflags & HF_VINTR_MASK))
+		return !!(svm->vcpu.arch.hflags & HF_HIF_MASK);
+	else
+		return !!(kvm_get_rflags(vcpu) & X86_EFLAGS_IF);
 }
 
 static void enable_irq_window(struct kvm_vcpu *vcpu)
@@ -5570,7 +5560,7 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
 	 * enabled, the STGI interception will not occur. Enable the irq
 	 * window under the assumption that the hardware will set the GIF.
 	 */
-	if ((vgif_enabled(svm) || gif_set(svm)) && nested_svm_intr(svm)) {
+	if (vgif_enabled(svm) || gif_set(svm)) {
 		/*
 		 * IRQ window is not needed when AVIC is enabled,
 		 * unless we have pending ExtINT since it cannot be injected
@@ -7465,6 +7455,8 @@ static void svm_pre_update_apicv_exec_ctrl(struct kvm *kvm, bool activate)
 	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
 
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
+
+	.check_nested_events = svm_check_nested_events,
 };
 
 static int __init svm_init(void)
-- 
1.8.3.1


