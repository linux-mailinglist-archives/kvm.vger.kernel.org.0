Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 600F522E3D
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 10:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731264AbfETISg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 04:18:36 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40324 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731250AbfETISg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 04:18:36 -0400
Received: by mail-pg1-f193.google.com with SMTP id d30so6418191pgm.7;
        Mon, 20 May 2019 01:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kpDjSa6rGnO+8XAS5uIFDRLRqGo48wwbHZAcXP1SnMk=;
        b=ok1+HO/2AuRosAo20+uTnpWgfEx9f90VMs2K0zxSu5gGiNBCqYhvhq6MhCuI7FhtVb
         6AtiVCfGbk/I/1w28D8ltKw1dim3qX1zDUg+atNhZXlPbAlTj59J3aKUFOrNov+tuf/S
         oKB0BCif/q8W2cxZCqvLupMLQTm2p5RIP79a1HYteZi8EBW+fTm9CR6A5hRgAw453GzR
         h6JlcRe1aHFkAZ6D2ZIOOCq9Oj/HYNrwlRTn+DyYDWTXX6LScRsE2O3s3LTOEZ2W4IeS
         Orj+hUaQdK9Jfr9tAidiA6/Y4K0JBiWnz7B4oG5zq+SRhoIJWyKONJNQHEq6etOyGPkl
         snLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kpDjSa6rGnO+8XAS5uIFDRLRqGo48wwbHZAcXP1SnMk=;
        b=BdpHS2yPmJRbfSVkgqP8KVlCJ8BCGMb2uGEd0uArASFkUzdRnDyd3THXsovFDp55/C
         cEJroiX83yDJmPaVfU7LePndd9HKy3Odpznz0wtXAywIZ5qTlcz7xNEUmT3HEwzyK8Vk
         vwH6QOiR9/h5ng0d1zHZubGL/y2PtvOgmvvdCX5fblWEoLRn/CEPtoepHbltegbOcVaU
         kazWxLHRpos8k8dMgBdWhftWEFEdiS6ZooF5JTKrLTMciNBqd0yzpllBCC5OWXMOGTJo
         ijt7T2qz4m4VqZOSaOmu6jm3cJ3lvj2OBJ2AbfL0t20hZuMOjv7gq39f/OgTO3c9IVof
         aAKA==
X-Gm-Message-State: APjAAAU9qi8QN487OAQy9hHOO09NqBXuTvh10DCeASKvFJ42LHVQg2ez
        ZIMtRmj6qPJ/+41qOqXWWlN0NUZU
X-Google-Smtp-Source: APXvYqxpVxrUKsv16f4yYfyE58sT6WYTU9v2cAub2b3tv50wPdb/kGDuxeS6Wkhh6SoRB/ZKFJH3rQ==
X-Received: by 2002:a63:4852:: with SMTP id x18mr60586780pgk.14.1558340314989;
        Mon, 20 May 2019 01:18:34 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id z9sm18522110pgc.82.2019.05.20.01.18.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 20 May 2019 01:18:34 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v4 5/5] KVM: LAPIC: Optimize timer latency further
Date:   Mon, 20 May 2019 16:18:09 +0800
Message-Id: <1558340289-6857-6-git-send-email-wanpengli@tencent.com>
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
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c   | 3 ++-
 arch/x86/kvm/lapic.h   | 2 +-
 arch/x86/kvm/svm.c     | 4 ++++
 arch/x86/kvm/vmx/vmx.c | 4 ++++
 arch/x86/kvm/x86.c     | 3 ---
 5 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 6652928..db75ac5 100644
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
index a849dcb..e68c1b9 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5632,6 +5632,10 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
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
index 16d2a3e..57d0e57 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6433,6 +6433,10 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	vmx_update_hv_timer(vcpu);
 
+	if (lapic_in_kernel(vcpu) &&
+		vcpu->arch.apic->lapic_timer.timer_advance_ns)
+		kvm_wait_lapic_expire(vcpu);
+
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
 	 * it's non-zero. Since vmentry is serialising on affected CPUs, there
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac7353f..e6f05f4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7959,9 +7959,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	}
 
 	trace_kvm_entry(vcpu->vcpu_id);
-	if (lapic_in_kernel(vcpu) &&
-	    vcpu->arch.apic->lapic_timer.timer_advance_ns)
-		wait_lapic_expire(vcpu);
 	guest_enter_irqoff();
 
 	fpregs_assert_state_consistent();
-- 
2.7.4

