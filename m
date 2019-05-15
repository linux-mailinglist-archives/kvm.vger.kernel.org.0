Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 186B11E758
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 06:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfEOEMJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 00:12:09 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39238 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbfEOEMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 00:12:06 -0400
Received: by mail-pf1-f193.google.com with SMTP id z26so642582pfg.6;
        Tue, 14 May 2019 21:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FRhCay0gyIZMyq2UxiW86hyINdu7rUa3vMrWeCWaFDM=;
        b=O5DmFBxInL1znEntSZUdWv14ySAL1DedU+4BXCp3nCmh+agvC49VoGi03K6JvF0sBb
         JiUEOGVORhmrXFp3oF1xVqB5qOI1yIUMOjpHyIUtjKJp+1cy9NbjD5mViQQBmCmY0Ege
         bfmWLkm4FUYA6+Gh6ZscewV9A1Pnj11IOZvyinsEtnvt9VPeskeFqH2LELa0pk0gc2RV
         JT+U5E/MnplEmfDwxGfMLTfm5QSi6SjL6KRPMX5WXLgUDRwJ/49uowQ+xzoD4xNV3xsO
         m7qkupDGHWNsdAiG65MGjGmY5WVwpczTwYKEKM+T+L3JI/xMjAOyHFuhaocIIk1il4tW
         frGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FRhCay0gyIZMyq2UxiW86hyINdu7rUa3vMrWeCWaFDM=;
        b=Dug4m+gDsHPzBs8UYHRvEeEVVBi/J8vxC+KoKlO03uWAmqm+bSUps49UG2gtxXlxO+
         3WyNWAYk3tvvHROw4HbW0XGMNDo+FERQ6KuP1wWtwTyJsgX07XUfMZbyoyrfu8qbr6gF
         D9t6GoiUFdHA1l3XH++bbnxQ3kQ60SmdcFRaxFVSKAeKHo+J1JweA5AhtYdTb9+vkQX+
         g14iAKdSR8w88zOsHSRvFMhS4I+MeNBYUuXJN5u+Rxlsr+cIx2COHCZzdS5ma/cRdwWT
         eDI9I/t5lbKlqAecORLIJzpenTupoOdVKW8EB8Zw+y1R8kxZNnlM/vB20oUiXvWvZ81d
         M9ew==
X-Gm-Message-State: APjAAAUnJFEAFr7irI3Zm+Pdl5ETmvjE4g2Zt7K0Fx2g4QE3FxDTkUBs
        ZSnqxCN4t+7XkajL0bQdOZ/Wl8wD
X-Google-Smtp-Source: APXvYqzhqFk7NcnrFTbfIPAe1Jjma/LpjFuu7hN++1aib1F5Qvbomku1fp0U4AMcJLhB8/96lJdinw==
X-Received: by 2002:a65:5304:: with SMTP id m4mr21540788pgq.126.1557893525249;
        Tue, 14 May 2019 21:12:05 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id z187sm886788pfb.132.2019.05.14.21.12.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 14 May 2019 21:12:04 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v2 3/4] KVM: LAPIC: Expose per-vCPU timer adavance information to userspace
Date:   Wed, 15 May 2019 12:11:53 +0800
Message-Id: <1557893514-5815-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557893514-5815-1-git-send-email-wanpengli@tencent.com>
References: <1557893514-5815-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Expose the per-vCPU advancement information to the user via per-vCPU debugfs 
entry. wait_lapic_expire() call was moved above guest_enter_irqoff() because 
of its tracepoint, which violated the RCU extended quiescent state invoked 
by guest_enter_irqoff()[1][2]. This patch simply removes the tracepoint, 
which would allow moving wait_lapic_expire(). Sean pointed out:

| Now that the advancement time is tracked per-vCPU, realizing a change 
| in the advancement time requires creating a new VM. For all intents 
| and purposes this makes it impractical to hand tune the advancement 
| in real time using the tracepoint as the feedback mechanism.

[1] Commit 8b89fe1f6c43 ("kvm: x86: move tracepoints outside extended quiescent state")
[2] https://patchwork.kernel.org/patch/7821111/

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/debugfs.c | 16 ++++++++++++++++
 arch/x86/kvm/lapic.c   | 16 ++++++++--------
 arch/x86/kvm/lapic.h   |  1 +
 arch/x86/kvm/trace.h   | 20 --------------------
 4 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index c19c7ed..8cf542e 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -9,12 +9,22 @@
  */
 #include <linux/kvm_host.h>
 #include <linux/debugfs.h>
+#include "lapic.h"
 
 bool kvm_arch_has_vcpu_debugfs(void)
 {
 	return true;
 }
 
+static int vcpu_get_timer_expire_delta(void *data, u64 *val)
+{
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
+	*val = vcpu->arch.apic->lapic_timer.advance_expire_delta;
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(vcpu_timer_expire_delta_fops, vcpu_get_timer_expire_delta, NULL, "%lld\n");
+
 static int vcpu_get_tsc_offset(void *data, u64 *val)
 {
 	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
@@ -51,6 +61,12 @@ int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 	if (!ret)
 		return -ENOMEM;
 
+	ret = debugfs_create_file("advance_expire_delta", 0444,
+							vcpu->debugfs_dentry,
+							vcpu, &vcpu_timer_expire_delta_fops);
+	if (!ret)
+		return -ENOMEM;
+
 	if (kvm_has_tsc_control) {
 		ret = debugfs_create_file("tsc-scaling-ratio", 0444,
 							vcpu->debugfs_dentry,
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 2f364fe..af38ece 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1502,27 +1502,27 @@ static inline void __wait_lapic_expire(struct kvm_vcpu *vcpu, u64 guest_cycles)
 }
 
 static inline void adaptive_tune_timer_advancement(struct kvm_vcpu *vcpu,
-				u64 guest_tsc, u64 tsc_deadline)
+				s64 advance_expire_delta)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns;
 	u64 ns;
 
 	/* too early */
-	if (guest_tsc < tsc_deadline) {
-		ns = (tsc_deadline - guest_tsc) * 1000000ULL;
+	if (advance_expire_delta < 0) {
+		ns = -advance_expire_delta * 1000000ULL;
 		do_div(ns, vcpu->arch.virtual_tsc_khz);
 		timer_advance_ns -= min((u32)ns,
 			timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
 	} else {
 	/* too late */
-		ns = (guest_tsc - tsc_deadline) * 1000000ULL;
+		ns = advance_expire_delta * 1000000ULL;
 		do_div(ns, vcpu->arch.virtual_tsc_khz);
 		timer_advance_ns += min((u32)ns,
 			timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
 	}
 
-	if (abs(guest_tsc - tsc_deadline) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
+	if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
 		apic->lapic_timer.timer_advance_adjust_done = true;
 	if (unlikely(timer_advance_ns > 5000)) {
 		timer_advance_ns = 0;
@@ -1545,13 +1545,13 @@ void wait_lapic_expire(struct kvm_vcpu *vcpu)
 	tsc_deadline = apic->lapic_timer.expired_tscdeadline;
 	apic->lapic_timer.expired_tscdeadline = 0;
 	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
-	trace_kvm_wait_lapic_expire(vcpu->vcpu_id, guest_tsc - tsc_deadline);
+	apic->lapic_timer.advance_expire_delta = guest_tsc - tsc_deadline;
 
-	if (guest_tsc < tsc_deadline)
+	if (apic->lapic_timer.advance_expire_delta < 0)
 		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
 
 	if (unlikely(!apic->lapic_timer.timer_advance_adjust_done))
-		adaptive_tune_timer_advancement(vcpu, guest_tsc, tsc_deadline);
+		adaptive_tune_timer_advancement(vcpu, apic->lapic_timer.advance_expire_delta);
 }
 
 static void start_sw_tscdeadline(struct kvm_lapic *apic)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index d6d049b..3e72a25 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -32,6 +32,7 @@ struct kvm_timer {
 	u64 tscdeadline;
 	u64 expired_tscdeadline;
 	u32 timer_advance_ns;
+	s64 advance_expire_delta;
 	atomic_t pending;			/* accumulated triggered timers */
 	bool hv_timer_in_use;
 	bool timer_advance_adjust_done;
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 4d47a26..3f9bc62 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -953,26 +953,6 @@ TRACE_EVENT(kvm_pvclock_update,
 		  __entry->flags)
 );
 
-TRACE_EVENT(kvm_wait_lapic_expire,
-	TP_PROTO(unsigned int vcpu_id, s64 delta),
-	TP_ARGS(vcpu_id, delta),
-
-	TP_STRUCT__entry(
-		__field(	unsigned int,	vcpu_id		)
-		__field(	s64,		delta		)
-	),
-
-	TP_fast_assign(
-		__entry->vcpu_id	   = vcpu_id;
-		__entry->delta             = delta;
-	),
-
-	TP_printk("vcpu %u: delta %lld (%s)",
-		  __entry->vcpu_id,
-		  __entry->delta,
-		  __entry->delta < 0 ? "early" : "late")
-);
-
 TRACE_EVENT(kvm_enter_smm,
 	TP_PROTO(unsigned int vcpu_id, u64 smbase, bool entering),
 	TP_ARGS(vcpu_id, smbase, entering),
-- 
2.7.4

