Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 295B31FDED
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 05:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfEPDGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 23:06:47 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44853 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbfEPDGf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 23:06:35 -0400
Received: by mail-pg1-f195.google.com with SMTP id z16so781281pgv.11;
        Wed, 15 May 2019 20:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XpEnBE6bGmJdt1K4+jFodyaadPKkbgqY+88bNzccZ0Y=;
        b=dGeAMAJG2bZ/yeIR71y4IF/FlNGT0zSIFDR2x5GE2ZlO3IIud72kpqPjtqgOBDXn8S
         SApMvuR7WDwAZUCAfJ50SggD5QU9Lu1qBdtdNjH+NjJOVZCoDT1P+rVuFQu79Gdx0ior
         GO1cBV2Mw68xAGUISwk+yhFjKQ+CVdykNBI4++GfGDuwU4yXEJ11Ow6PfpWGKuoAD9ep
         /8To0DkPMZjDJwK+pBI62x6rND8lEN7DccCE+QJyGX4wpL1yIyG4PRSHXMAlfLRBUwis
         g2aSO9+4392HZJXE+LCBmWGkZwXmQzhuQlWj9hxMwt4kMgzc4c7c44xo3+oZd2GQf4ct
         fk0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XpEnBE6bGmJdt1K4+jFodyaadPKkbgqY+88bNzccZ0Y=;
        b=qbkyjFsbU9ZxXo/zKUYWPtZSQ6200age1Ffpla2+kvQHKE4pY0Qcp/0ryLfUVfBXnj
         WsfBZNbC0mt7SS0sEHvx0OjFjDfQ7Jn/FqkF+ovrs/ki82c02YIGzWNChHogXCV2o4E3
         OFXMkPWUaJ9K2dnp1ZYr3p0vXU4QbNPMPHZeyUWmabn2BSDOKXoM9wKZYyYjr3bOaeSR
         q8Z+UGTg3b/gLgq7wEepqCi+HG09mUaTg8hVMshAoxpnBoFWEcgC5LGqq2T/RyWHODlM
         0rKsSK1ROPA1bOeumIfEicMt+lrinCk7V2hUCnFzFR6YpvItt7LfcAq2s8Hya9uAp4QH
         KLdA==
X-Gm-Message-State: APjAAAWyx7sPeNb7O8wgYeoQahWV3qVJ5N29P8Y4HCskF5SKIKFMTemI
        gYQbBWWbgmgwG3hdTU86k+3CsQ2p
X-Google-Smtp-Source: APXvYqxNvIimj9uGBpX0dEBuJ8vFLB21xw+11vLQE5rpWHvnWZoRbpahiJdYS0Pt0hbmS09FKInElQ==
X-Received: by 2002:aa7:99dd:: with SMTP id v29mr52938927pfi.252.1557975994329;
        Wed, 15 May 2019 20:06:34 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id 204sm4247614pgh.50.2019.05.15.20.06.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 15 May 2019 20:06:33 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v3 4/5] KVM: LAPIC: Delay trace advance expire delta
Date:   Thu, 16 May 2019 11:06:19 +0800
Message-Id: <1557975980-9875-5-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557975980-9875-1-git-send-email-wanpengli@tencent.com>
References: <1557975980-9875-1-git-send-email-wanpengli@tencent.com>
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
 arch/x86/kvm/lapic.c | 16 ++++++++--------
 arch/x86/kvm/lapic.h |  1 +
 arch/x86/kvm/x86.c   |  2 ++
 3 files changed, 11 insertions(+), 8 deletions(-)

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
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f2e3847..4a7b00c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7961,6 +7961,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	++vcpu->stat.exits;
 
 	guest_exit_irqoff();
+	trace_kvm_wait_lapic_expire(vcpu->vcpu_id,
+		vcpu->arch.apic->lapic_timer.advance_expire_delta);
 
 	local_irq_enable();
 	preempt_enable();
-- 
2.7.4

