Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5073A420FE
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 11:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437530AbfFLJgX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 05:36:23 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46919 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437517AbfFLJgV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 05:36:21 -0400
Received: by mail-pl1-f194.google.com with SMTP id e5so6393086pls.13;
        Wed, 12 Jun 2019 02:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8Dqc/R6tA+VMXmtA2D7t9ERetiSobjxfaHTvZxh87cs=;
        b=ogvmdw8xHe041JGpZDrMyNMTMo403aGh6dtmODfjXYMSWl/FMLryX5X8fxEErLDW0V
         NnVO7lEcxjvhnzsiJ7GYzXl/5bRpAxN7mJfjQdWziIE4UIUKr+ZiegjeP1oiztRF4OoN
         xCxacdDxIuOnIYIF3PWA+SPiRpu9NhRA3FPPEoXoyxIxdjoy5saiTQWGC7Wgdo4QaZif
         9Dkwfyr3P9FVBZQQUcySXMInu7qxfhmHwlws5m77HFWzm3WqZ7gVS7VqjzCQMN0tJ2Va
         HXT56szHTYf5LNjNafY2jRMymy1kEtSMqQ0RQ1uxJRb4Mmy1og9BwZU/CjMBR6zqdliV
         dmbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8Dqc/R6tA+VMXmtA2D7t9ERetiSobjxfaHTvZxh87cs=;
        b=EhSdwdZ34foqIGzDMYEhoNcRoywsT5aE9//ByyXtyq58VMwZtZBTq8X887DL3dDFXu
         TcEnOs37eB0B1rzQrWO3L5EtlMFF6Uybs7/ORhIa2EGyT80r6xalludtPXAG+3vtS7nl
         GFrcwehySeeqy4XxTmgJu2Ai5v3lPcryAa+y2Pa/tSpW0FtzqI/95d0RSNOWig9HMrbP
         EoTF5RB+ab5SwzWRQ5KCCE1RnbSCuhECIPaDSI2TSMw0GBRd0CJqP6GRjjqoz6XPUFYj
         N9Rj2oRBliIV2dqmqssMjsrzxyVwAtZsl2r63Pj5HIkAXxrFkEEAu8HwKg6pBCQOk+TD
         A+/Q==
X-Gm-Message-State: APjAAAVk5mpQh42osc2w2WQCcQxAfHGgfQa//AObOXTUyiFcS/3DMcWh
        +rPGCP5rn0u1SdfsRWmVr91x1cQ/
X-Google-Smtp-Source: APXvYqzfj4TXkwPGhX58WBPRcCd4Q4fhf33MmMnBqLdu3/ifQwiblBrZlPpAFaTNkbaUQcfDK/XRhA==
X-Received: by 2002:a17:902:30a3:: with SMTP id v32mr81641033plb.6.1560332180831;
        Wed, 12 Jun 2019 02:36:20 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id 27sm6148936pgl.82.2019.06.12.02.36.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 12 Jun 2019 02:36:20 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v3 5/5] KVM: LAPIC: Optimize timer latency further
Date:   Wed, 12 Jun 2019 17:36:00 +0800
Message-Id: <1560332160-17050-6-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560332160-17050-1-git-send-email-wanpengli@tencent.com>
References: <1560332160-17050-1-git-send-email-wanpengli@tencent.com>
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
the end of wait_lapic_expire and before world switch on my haswell desktop.

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
index 6b92eaf..955cfcb 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5638,6 +5638,10 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	clgi();
 	kvm_load_guest_xcr0(vcpu);
 
+	if (lapic_in_kernel(vcpu) &&
+		vcpu->arch.apic->lapic_timer.timer_advance_ns)
+		kvm_wait_lapic_expire(vcpu);
+
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
 	 * it's non-zero. Since vmentry is serialising on affected CPUs, there
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e1fa935..771d3bf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6423,6 +6423,10 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	vmx_update_hv_timer(vcpu);
 
+	if (lapic_in_kernel(vcpu) &&
+		vcpu->arch.apic->lapic_timer.timer_advance_ns)
+		kvm_wait_lapic_expire(vcpu);
+
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
 	 * it's non-zero. Since vmentry is serialising on affected CPUs, there
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4a7b00c..e154f52 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7903,9 +7903,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	}
 
 	trace_kvm_entry(vcpu->vcpu_id);
-	if (lapic_in_kernel(vcpu) &&
-	    vcpu->arch.apic->lapic_timer.timer_advance_ns)
-		wait_lapic_expire(vcpu);
 	guest_enter_irqoff();
 
 	fpregs_assert_state_consistent();
-- 
2.7.4

