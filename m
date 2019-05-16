Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D13D31FDEA
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 05:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfEPDGi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 23:06:38 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44470 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbfEPDGh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 23:06:37 -0400
Received: by mail-pf1-f194.google.com with SMTP id g9so1011548pfo.11;
        Wed, 15 May 2019 20:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8Dqc/R6tA+VMXmtA2D7t9ERetiSobjxfaHTvZxh87cs=;
        b=LMQKAxPNiEAw4esPWE9xHoQHd5QDjZ5hsi41ovW5fo1e5/LHao0sf4+NWU1dyvDJXK
         jH949r0+Hgu+b+AN/VF7hoZzPvXY2f1coyNiOsQfZNT+hMpa1ec4xDa0ek+XTPgjlV1y
         hlPGtnxuuFbCcf4Y8uqXjNtqyuPdTWevbiF4h3t5dXNdX1+FH7JNuWc1uBeqSrGPOsdJ
         NWBkFgJNgp/ZDa3u2wkyAUX3gxwrrbIbXYY4eV0ENFjMeXifo+zKKwRLa6eIudMjJzxv
         CkQzthtVhx6rIz1nk9ONx48qCME+TffyMWv03ocsdA86vxElcpYB02Und6uNZdt9fi19
         hwlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8Dqc/R6tA+VMXmtA2D7t9ERetiSobjxfaHTvZxh87cs=;
        b=YtLeWpmLhrYExFHnQNA915TwflDOxJ2izo6kwOqyRN+ZLTYaygrcwLa2So1TRkMl7h
         pUn1scImCHKJ1i+eq1GeTH58QCE7By9laLJt0s8mhyApSZJsVYc9eEATzPCLxsWsFKz5
         BtvuAj71OoVe4igc0I5a3es5rJ8vkWpjFwVZY+Y3U1sLPKTBSp6upSIPojYXJoKs2hks
         aE+5DdfbcwAtKo/LcuC89ltGBgo30+793Gnksk1VBKCKYs3hpNUOpM8GMcia2HaCo1/5
         nvbZeHy+mTUApskD495FDKUVqi15YNZXqxv71275lkfsG1BZYfeu7Lgrbyc2uxRLzt8r
         9n1g==
X-Gm-Message-State: APjAAAW3tLtm9Gsf3pOXTKl1rUw8r7/4/EPl+P+/AjhVK+W2J6LXTf3R
        p7FhnXdLVnJ7yO6yhC5gxugfdtFP
X-Google-Smtp-Source: APXvYqxr7R99Px+0MMIVX+pkBprPOLXsFKpqsgnYXCaTEulKIvasaZBeIxu/L9MnEkhxrU6n3CrSWA==
X-Received: by 2002:a63:e645:: with SMTP id p5mr47328343pgj.4.1557975996516;
        Wed, 15 May 2019 20:06:36 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id 204sm4247614pgh.50.2019.05.15.20.06.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 15 May 2019 20:06:36 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v3 5/5] KVM: LAPIC: Optimize timer latency further
Date:   Thu, 16 May 2019 11:06:20 +0800
Message-Id: <1557975980-9875-6-git-send-email-wanpengli@tencent.com>
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

