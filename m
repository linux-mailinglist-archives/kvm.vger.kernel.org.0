Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3943CAF2
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 14:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390279AbfFKMR3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 08:17:29 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33744 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390255AbfFKMR2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 08:17:28 -0400
Received: by mail-pg1-f195.google.com with SMTP id k187so6387109pga.0;
        Tue, 11 Jun 2019 05:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zl129qCafYKm/UgUhbto8qNJe6wjq7BYqf7bJFFzUjo=;
        b=fj005MJvwJ8AqqO6dU9s1PH7QL1JXBhN4sDYVRVOCaksASvnxV2Hx4ju3fbjyv2LwL
         QGJN0AP6XFEACZh6LZnMRduy5r+c+4zgH3biQxPCzSRI536lAHR8xIh7X4/cMrIUFGUn
         +CFyU+CibjYbbzqWqcDsSL5wRdD8z2ECXdapQudcHcHQ364LlWMib9pVesgvEKlM3NjW
         tO89fLXbPZEoJYZLcYlrnswSq9x2aQ3Eum3MOKdZ7mZcm9H7ejOvB2Y59kOQ7M3l/oNr
         yE0d+7ZyEQudeSvf0eeFlfRrmG0ARNfgJnL1Lfk5C+u535TMR+4u9jRrjZT7OdHXX0YI
         r6xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zl129qCafYKm/UgUhbto8qNJe6wjq7BYqf7bJFFzUjo=;
        b=t9RvQ50N7O+6CyJy3+vpfIld2g/Lhv24ssj1LcBzTsSizietNUi6Rmcy+u90WQ6lDR
         6DGF7GEXlpdptgTSImN6wt29ICGr3+twFZFVMDDMP4sLaGV03Ps4zI0x6vcFtH0I7GL7
         DfAUNqQl8r7CUsmaH2rs4b3+dyktDWsaLKSYLI7b6qKA2iNhhMfbl7PYsvBI9X/6cuhK
         6e7Q9l3J+XzurdA6TNl81zVDVXWXkDiEda+gWHq3zqpvWag/hVQLsCmRr5vE3IViI62w
         XrmGqBCxK6/YHJVwbhZ7zMu+d1jwVHFOJxYfoteLGS0ykSU9N2SBVHXeqLYxvyxiyWPV
         bxoA==
X-Gm-Message-State: APjAAAVLlerByurNmkjQidc/t6E0w+ZqdjqPJtx7BFji+ZYnUj6gMUbe
        POrmq0d6Sl02QtCg67EWx60ApMSC
X-Google-Smtp-Source: APXvYqz9bh8LBHagGEr/glCqWR8X4LH7zy42kImlhi+fW4kAeB5HdKPZ3Clh7f0EqRJ9M0kfmhayMQ==
X-Received: by 2002:a62:a508:: with SMTP id v8mr78125294pfm.87.1560255447865;
        Tue, 11 Jun 2019 05:17:27 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id v4sm19649478pff.45.2019.06.11.05.17.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 11 Jun 2019 05:17:27 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v3 4/4] KVM: LAPIC: add advance timer support to pi_inject_timer
Date:   Tue, 11 Jun 2019 20:17:09 +0800
Message-Id: <1560255429-7105-5-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560255429-7105-1-git-send-email-wanpengli@tencent.com>
References: <1560255429-7105-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Wait before calling posted-interrupt deliver function directly to add 
advance timer support to pi_inject_timer.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c   | 6 ++++--
 arch/x86/kvm/lapic.h   | 2 +-
 arch/x86/kvm/svm.c     | 2 +-
 arch/x86/kvm/vmx/vmx.c | 2 +-
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index c21bab2..8f1fc94 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1470,6 +1470,8 @@ static void apic_timer_expired(struct kvm_lapic *apic)
 		return;
 
 	if (can_posted_interrupt_inject_timer(apic->vcpu)) {
+		if (apic->lapic_timer.timer_advance_ns)
+			kvm_wait_lapic_expire(vcpu, true);
 		kvm_apic_inject_pending_timer_irqs(apic);
 		return;
 	}
@@ -1561,7 +1563,7 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
 	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
 }
 
-void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
+void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu, bool pi_inject)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u64 guest_tsc, tsc_deadline;
@@ -1569,7 +1571,7 @@ void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 	if (apic->lapic_timer.expired_tscdeadline == 0)
 		return;
 
-	if (!lapic_timer_int_injected(vcpu))
+	if (!lapic_timer_int_injected(vcpu) && !pi_inject)
 		return;
 
 	tsc_deadline = apic->lapic_timer.expired_tscdeadline;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 7b85a7c..4520164 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -220,7 +220,7 @@ static inline int kvm_lapic_latched_init(struct kvm_vcpu *vcpu)
 
 bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
 
-void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
+void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu, bool pi_inject);
 
 bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq *irq,
 			struct kvm_vcpu **dest_vcpu);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 302cb40..049ba64 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5648,7 +5648,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	if (lapic_in_kernel(vcpu) &&
 		vcpu->arch.apic->lapic_timer.timer_advance_ns)
-		kvm_wait_lapic_expire(vcpu);
+		kvm_wait_lapic_expire(vcpu, false);
 
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6d3c0b1..155aba6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6447,7 +6447,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	if (lapic_in_kernel(vcpu) &&
 		vcpu->arch.apic->lapic_timer.timer_advance_ns)
-		kvm_wait_lapic_expire(vcpu);
+		kvm_wait_lapic_expire(vcpu, false);
 
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
-- 
2.7.4

