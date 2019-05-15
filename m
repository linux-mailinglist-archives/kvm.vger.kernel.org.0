Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4F3A1E757
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 06:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfEOEMK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 00:12:10 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34445 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfEOEMI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 00:12:08 -0400
Received: by mail-pg1-f196.google.com with SMTP id c13so667801pgt.1;
        Tue, 14 May 2019 21:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eb+dbUuTjVA56/xDakck36kQSbW7wCTN88gUyNWFXBA=;
        b=Ijpr+PAPbi6YKCOO4C+MQy3T9VpW9ibaRfbDFWLm1wQ9gqaPPPyKANK+i7lcYTH2Rp
         g4T/WygkDUtTrLF1QDs2P6AvTKakfHFu7b0JzepDMEJgZ3nvULp7/ue4r+sEr0jZo27c
         tbZjTApninRIetbHc132RG+2C1JpzHN0oBOeVlnXwrYvh3VwBsbnC2AbfAX6BKDMu7a0
         a4XKWM0NYuLyi2GY3QM2GBIk49umbCry8Quf8/BLp4OQtQ6ugfbb4TWozSqnqhC+9Mc9
         2nZHw0Z+4nAAaPqjBOzzJbM5we3FGAgpNreGH1j6bMVRqFXVJ3j/YgdxpHPounYDuG3o
         DiPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eb+dbUuTjVA56/xDakck36kQSbW7wCTN88gUyNWFXBA=;
        b=t2NzdFzaMmFSJezLSiRypBsj05QIw0dGvP+DkV6bpMUvJKQGBcANMFcnKXpokJy3Ig
         lU1A2fYukF5Bbf9cb0QlPhmgjL5JCmI1lsigaAsyx5Axprwtbp7WgooycWYHdWaORJuN
         w5jLYGNzuSu1KRyS3/qb1hLU4UMs2Qs5tTZiWW3/eflEaucT2/nLLyM6q9zT4LcEw1bb
         /Im3xgnW33L9FYBc/2yaUMaLOQMg5kogYarYajqm7ktK3k+E8hK4lynvIDFYufLvgX1f
         ejdQReAsbvSn5pWRa+6Qh34abmiYd9z65hKNpoJnR/9xQFqqeuZUc9iRR54BYi2mMxPM
         0Y0A==
X-Gm-Message-State: APjAAAXpITkL3kRCTnSJGhothHbzwSW6DRd7Iu5Rnqin6BDgBUCWz6wp
        iWfi4VAfas65QQA+gMvNfsW1R6mk
X-Google-Smtp-Source: APXvYqyf8wKC7JXk2fZd4GmzEdwcIs0k+ownIyOfiziiQfQeBGJrqA6R4SYZWrOj/5UWp/CUM4DRSg==
X-Received: by 2002:a65:62c4:: with SMTP id m4mr41742140pgv.308.1557893527519;
        Tue, 14 May 2019 21:12:07 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id z187sm886788pfb.132.2019.05.14.21.12.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 14 May 2019 21:12:07 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v2 4/4] KVM: LAPIC: Optimize timer latency further
Date:   Wed, 15 May 2019 12:11:54 +0800
Message-Id: <1557893514-5815-5-git-send-email-wanpengli@tencent.com>
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

Advance lapic timer tries to hidden the hypervisor overhead between the 
host emulated timer fires and the guest awares the timer is fired. However, 
it just hidden the time between apic_timer_fn/handle_preemption_timer -> 
wait_lapic_expire, instead of the real position of vmentry which is 
mentioned in the orignial commit d0659d946be0 ("KVM: x86: add option to 
advance tscdeadline hrtimer expiration"). There is 700+ cpu cycles between 
the end of wait_lapic_expire and before world switch on my haswell desktop, 
it will be 2400+ cycles if vmentry_l1d_flush is tuned to always. 

This patch tries to narrow the last gap(wait_lapic_expire -> world switch), 
it takes the real overhead time between apic_timer_fn/handle_preemption_timer
and before world switch into consideration when adaptively tuning timer 
advancement. The patch can reduce 40% latency (~1600+ cycles to ~1000+ cycles 
on a haswell desktop) for kvm-unit-tests/tscdeadline_latency when testing 
busy waits.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c   | 3 ++-
 arch/x86/kvm/lapic.h   | 2 +-
 arch/x86/kvm/svm.c     | 4 ++++
 arch/x86/kvm/vmx/vmx.c | 4 ++++
 arch/x86/kvm/x86.c     | 3 ---
 5 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index af38ece..63513de 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1531,7 +1531,7 @@ static inline void adaptive_tune_timer_advancement(struct kvm_vcpu *vcpu,
 	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
 }
 
-void wait_lapic_expire(struct kvm_vcpu *vcpu)
+void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u64 guest_tsc, tsc_deadline;
@@ -1553,6 +1553,7 @@ void wait_lapic_expire(struct kvm_vcpu *vcpu)
 	if (unlikely(!apic->lapic_timer.timer_advance_adjust_done))
 		adaptive_tune_timer_advancement(vcpu, apic->lapic_timer.advance_expire_delta);
 }
+EXPORT_SYMBOL_GPL(kvm_wait_lapic_expire);
 
 static void start_sw_tscdeadline(struct kvm_lapic *apic)
 {
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 3e72a25..f974a3d 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -220,7 +220,7 @@ static inline int kvm_lapic_latched_init(struct kvm_vcpu *vcpu)
 
 bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
 
-void wait_lapic_expire(struct kvm_vcpu *vcpu);
+void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
 
 bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq *irq,
 			struct kvm_vcpu **dest_vcpu);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 406b558..740fb3f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5646,6 +5646,10 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
 
+	if (lapic_in_kernel(vcpu) &&
+		vcpu->arch.apic->lapic_timer.timer_advance_ns)
+		kvm_wait_lapic_expire(vcpu);
+
 	local_irq_enable();
 
 	asm volatile (
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9663d41..1c49946 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6437,6 +6437,10 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.cr2 != read_cr2())
 		write_cr2(vcpu->arch.cr2);
 
+	if (lapic_in_kernel(vcpu) &&
+		vcpu->arch.apic->lapic_timer.timer_advance_ns)
+		kvm_wait_lapic_expire(vcpu);
+
 	vmx->fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
 				   vmx->loaded_vmcs->launched);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1d89cb9..0eb9549 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7894,9 +7894,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	}
 
 	trace_kvm_entry(vcpu->vcpu_id);
-	if (lapic_in_kernel(vcpu) &&
-	    vcpu->arch.apic->lapic_timer.timer_advance_ns)
-		wait_lapic_expire(vcpu);
 	guest_enter_irqoff();
 
 	fpregs_assert_state_consistent();
-- 
2.7.4

