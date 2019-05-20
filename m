Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E992E22E3C
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 10:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731251AbfETISf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 04:18:35 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35745 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731227AbfETISd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 04:18:33 -0400
Received: by mail-pg1-f193.google.com with SMTP id t1so5005363pgc.2;
        Mon, 20 May 2019 01:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pgbMJUS0t5EEMQVa4x2z1mBqXaayN9eDcVUF1ZHkpGo=;
        b=gOskyFqv4TYixDqOL3mWr4ZC8ZZtb79p7fL7c/1IBW0fSralC96MYcHJgyWH4jAal3
         bnBr/jh0vRlGAXji9LVLh90zSPAFXv8SEoxgHi6xx9dkmbtu0/XcoXX5biOqaCCqqxXO
         sWromyHdk2tw4yfYti1DPOwoMJKIvGV1b8jsWKfglEugepEdBjPdqwwKqgBK1ISr3zC9
         ugw9sWe9APCT2wiGTDK4Kol5l97HyQRDlM0AhLTsn/YSKun/5nnXrin6tTUE0llWhOar
         uDA2YRZSKPoY35rxCNYO8hvyTtoLIqEIUtU1G2lNWV2D9yaxXthEDXPoYxS8iUnzVyRs
         Q+8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pgbMJUS0t5EEMQVa4x2z1mBqXaayN9eDcVUF1ZHkpGo=;
        b=KSMELdH0UHj4b4wXE3U1k6/x00FTUOKh0JhJlRFcBEX39zfvRkG+vag/0oTIPk2mbH
         1rOZuVTuB5xMFxEf2wbQex7Jg1ZDMiuCoDq9fL1J3nFT/EwBVECliPLkA1B+dfZnE92J
         fKEXmh0kIguxQragp7PxKjxkTMiqCepUyuuuxjlpbQaDKvZChDBedBODbTwZZ1lp5UrJ
         RO3pUtEwcPUQxXd+Xs8RNSYehFzE3Jnov88p8+wgdgNgDWnT2+yeta3YhXXFI0nS7O9z
         ooSSLBpPB/Cg8jYJcx4phCsIQOvaOVMQBzMnIwHwiB5gc176qOUCMbAMr0RlVRVTv/o2
         kcgg==
X-Gm-Message-State: APjAAAX0DbUBKUZt0F2b6Xs6BzkaANhqo1+EwkA6+BLgoxW6TLoMxm7V
        3Sy0CFECCFLsGHgCK16xEYu9ycqg
X-Google-Smtp-Source: APXvYqzUZMJcNkf5rEYtW9VtjGz/GwR/ogbXpYTmexsCYg+iIbwg7uUa4IwJyHKTlVXMlRziflDLKA==
X-Received: by 2002:a65:5cca:: with SMTP id b10mr74406405pgt.444.1558340312802;
        Mon, 20 May 2019 01:18:32 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id z9sm18522110pgc.82.2019.05.20.01.18.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 20 May 2019 01:18:32 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v4 4/5] KVM: LAPIC: Delay trace advance expire delta
Date:   Mon, 20 May 2019 16:18:08 +0800
Message-Id: <1558340289-6857-5-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558340289-6857-1-git-send-email-wanpengli@tencent.com>
References: <1558340289-6857-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

wait_lapic_expire() call was moved above guest_enter_irqoff() because of 
its tracepoint, which violated the RCU extended quiescent state invoked 
by guest_enter_irqoff()[1][2]. This patch simply moves the tracepoint 
below guest_exit_irqoff() in vcpu_enter_guest(). Snapshot the delta before 
VM-Enter, but trace it after VM-Exit. This can help us to move 
wait_lapic_expire() just before vmentry in the later patch.

[1] Commit 8b89fe1f6c43 ("kvm: x86: move tracepoints outside extended quiescent state")
[2] https://patchwork.kernel.org/patch/7821111/

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 14 +++++++-------
 arch/x86/kvm/lapic.h |  1 +
 arch/x86/kvm/x86.c   |  4 ++++
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 89ac82d..6652928 100644
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
 
 	if (guest_tsc < tsc_deadline)
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
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3eb77e7..ac7353f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8017,6 +8017,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	++vcpu->stat.exits;
 
 	guest_exit_irqoff();
+	if (lapic_in_kernel(vcpu) &&
+	    vcpu->arch.apic->lapic_timer.timer_advance_ns)
+		trace_kvm_wait_lapic_expire(vcpu->vcpu_id,
+			vcpu->arch.apic->lapic_timer.advance_expire_delta);
 
 	local_irq_enable();
 	preempt_enable();
-- 
2.7.4

