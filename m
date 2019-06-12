Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2E6842131
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 11:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437541AbfFLJkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 05:40:25 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34668 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437412AbfFLJkZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 05:40:25 -0400
Received: by mail-pg1-f196.google.com with SMTP id p10so2775070pgn.1;
        Wed, 12 Jun 2019 02:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3/PDT3zPhVInYWO+uoWMhotkvoWOvRBQ7+7+0SzCvBw=;
        b=USX63tJiwuJMg0aic+KVHTnIBYRcpZ0vF5ab1BWNp/1kzFvcQJoMmSfdOoK3ampUvN
         E6INQfQMOX5XGoVOSJv/52NQ7f061YwFYWzyxE38ctNK4etoR2nwYrooL2ozl1CqYweA
         K14nqgo65cwfTM1KiMuF4NmYFDmSxEtUOPd3LRL7CcexsCCEBMbfmLqE5nq5XdGcR3jb
         4hbPIjUJj1mvRDWbUunYHHMtDxyS0661otTio7w0npEQisJVYG6uEQjqQV1vUEkM7eU1
         mgR5Or3ZAhQphcPdgE4ViLFw2izvpqUuS6zQoiM8gezMo/VaBQ4ZmhU38oE7Grp32o+D
         h34w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3/PDT3zPhVInYWO+uoWMhotkvoWOvRBQ7+7+0SzCvBw=;
        b=KP1I1R1ecrgrlfdztrUXkdPilCR+H4Uc0tPxAnHuazzQ1EwG+kxWFvs0NGT2Fpdv33
         epovz01eXdQXvkWsrSBN1AAfrNziPQs7ZTtpMSQCOlWK62aLZu17XfhF/u/XU2ndyLbf
         /vgW55aF2iDT5kplLjGmP2t4u1nNQJ1PvkMqk2Egx0dR7q0u4T8H9IK1oyE6VSzSr+Ds
         kags892T8HTNn8ILiN02YBSUeJkR07DaW+X0au9SKGBcWRwIl9mlVywHY7L5wZvJDFEc
         5A+4YOaDyHY9HuwD739TPvgUCOzEntvvqd3MS9fiYCtrUhR8+7r78NkPQSpQTWkesPIw
         7P5Q==
X-Gm-Message-State: APjAAAXbXVs6jNJAJZqwW1iaG0gejQcWYv2s8aDZ/nSJtvmAjS/36HCt
        jafxLRbPKnrMmio0A4sHKIwCL4f1
X-Google-Smtp-Source: APXvYqxlZa/rPUUalIoZGjpD2xov2m/61qAww6bxIotkX0tCLB3reK0n3+Sng/jmnG/ISbAMP4iz6g==
X-Received: by 2002:a62:68c4:: with SMTP id d187mr87492769pfc.245.1560332423812;
        Wed, 12 Jun 2019 02:40:23 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id k1sm4706993pjp.2.2019.06.12.02.40.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 12 Jun 2019 02:40:23 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v3 1/2] KVM: LAPIC: Optimize timer latency consider world switch time
Date:   Wed, 12 Jun 2019 17:40:18 +0800
Message-Id: <1560332419-17195-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
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
even though after more sustaining optimizations, kvm-unit-tests/tscdeadline_latency 
still awares ~1000 cycles latency since we lost the time between the end of 
wait_lapic_expire and the guest awares the timer is fired. There are 
codes between the end of wait_lapic_expire and the world switch, furthermore, 
the world switch itself also has overhead. Actually the guest_tsc is equal 
to the target deadline time in wait_lapic_expire is too late, guest will
aware the latency between the end of wait_lapic_expire() and after vmentry 
to the guest. This patch takes this time into consideration. 

The vmentry+vmexit time which is measured by kvm-unit-tests/vmexit.falt is 
1800 cycles on my 2.5GHz Skylake server, the vmentry_advance_ns module 
parameter default value is 300ns, it can be tuned/reworked in the further.
This patch can reduce average cyclictest latency from 3us to 2us on Skylake 
server. (guest w/ nohz=off, idle=poll, host w/ preemption_timer=N, the 
cyclictest latency is not too sensitive when preemption_timer=Y for this 
optimization in my testing).

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v2 -> v3:
 * read-only module parameter
 * get_vmentry_advance_cycles() not inline
v1 -> v2:
 * rename get_vmentry_advance_delta to get_vmentry_advance_cycles
 * cache vmentry_advance_cycles by setting param bit 0 
 * add param max limit 

 arch/x86/kvm/lapic.c   | 33 ++++++++++++++++++++++++++++++---
 arch/x86/kvm/lapic.h   |  3 +++
 arch/x86/kvm/vmx/vmx.c |  2 +-
 arch/x86/kvm/x86.c     |  8 ++++++++
 arch/x86/kvm/x86.h     |  2 ++
 5 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index fcf42a3..c6d76f9 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1531,6 +1531,33 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
 	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
 }
 
+u64 compute_vmentry_advance_cycles(struct kvm_vcpu *vcpu)
+{
+	u64 cycles;
+	struct kvm_lapic *apic = vcpu->arch.apic;
+
+	cycles = vmentry_advance_ns * vcpu->arch.virtual_tsc_khz;
+	do_div(cycles, 1000000);
+
+	apic->lapic_timer.vmentry_advance_cycles = cycles;
+
+	return cycles;
+}
+
+u64 get_vmentry_advance_cycles(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+
+	if (unlikely(!vmentry_advance_ns))
+		return 0;
+
+	if (likely(apic->lapic_timer.vmentry_advance_cycles))
+		return apic->lapic_timer.vmentry_advance_cycles;
+
+	return compute_vmentry_advance_cycles(vcpu);
+}
+EXPORT_SYMBOL_GPL(get_vmentry_advance_cycles);
+
 void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
@@ -1544,7 +1571,7 @@ void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 
 	tsc_deadline = apic->lapic_timer.expired_tscdeadline;
 	apic->lapic_timer.expired_tscdeadline = 0;
-	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
+	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc()) + get_vmentry_advance_cycles(vcpu);
 	apic->lapic_timer.advance_expire_delta = guest_tsc - tsc_deadline;
 
 	if (guest_tsc < tsc_deadline)
@@ -1572,7 +1599,7 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
 	local_irq_save(flags);
 
 	now = ktime_get();
-	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
+	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc()) + get_vmentry_advance_cycles(vcpu);
 
 	ns = (tscdeadline - guest_tsc) * 1000000ULL;
 	do_div(ns, this_tsc_khz);
@@ -2329,7 +2356,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 		apic->lapic_timer.timer_advance_ns = timer_advance_ns;
 		apic->lapic_timer.timer_advance_adjust_done = true;
 	}
-
+	apic->lapic_timer.vmentry_advance_cycles = 0;
 
 	/*
 	 * APIC is created enabled. This will prevent kvm_lapic_set_base from
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index f974a3d..fb32e69 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -33,6 +33,7 @@ struct kvm_timer {
 	u64 expired_tscdeadline;
 	u32 timer_advance_ns;
 	s64 advance_expire_delta;
+	u64 vmentry_advance_cycles;
 	atomic_t pending;			/* accumulated triggered timers */
 	bool hv_timer_in_use;
 	bool timer_advance_adjust_done;
@@ -221,6 +222,8 @@ static inline int kvm_lapic_latched_init(struct kvm_vcpu *vcpu)
 bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
 
 void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
+u64 compute_vmentry_advance_cycles(struct kvm_vcpu *vcpu);
+u64 get_vmentry_advance_cycles(struct kvm_vcpu *vcpu);
 
 bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq *irq,
 			struct kvm_vcpu **dest_vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0861c71..0751a44 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7041,7 +7041,7 @@ static int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 
 	vmx = to_vmx(vcpu);
 	tscl = rdtsc();
-	guest_tscl = kvm_read_l1_tsc(vcpu, tscl);
+	guest_tscl = kvm_read_l1_tsc(vcpu, tscl) + get_vmentry_advance_cycles(vcpu);
 	delta_tsc = max(guest_deadline_tsc, guest_tscl) - guest_tscl;
 	lapic_timer_advance_cycles = nsec_to_cycles(vcpu,
 						    ktimer->timer_advance_ns);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 553c292..4b983bb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -145,6 +145,12 @@ module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
 static int __read_mostly lapic_timer_advance_ns = -1;
 module_param(lapic_timer_advance_ns, int, S_IRUGO | S_IWUSR);
 
+/*
+ * lapic timer vmentry advance (tscdeadline mode only) in nanoseconds.
+ */
+u32 __read_mostly vmentry_advance_ns = 300;
+module_param(vmentry_advance_ns, uint, S_IRUGO);
+
 static bool __read_mostly vector_hashing = true;
 module_param(vector_hashing, bool, S_IRUGO);
 
@@ -1592,6 +1598,8 @@ static int kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz)
 	kvm_get_time_scale(user_tsc_khz * 1000LL, NSEC_PER_SEC,
 			   &vcpu->arch.virtual_tsc_shift,
 			   &vcpu->arch.virtual_tsc_mult);
+	if (vcpu->arch.apic && user_tsc_khz != vcpu->arch.virtual_tsc_khz)
+		compute_vmentry_advance_cycles(vcpu);
 	vcpu->arch.virtual_tsc_khz = user_tsc_khz;
 
 	/*
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a470ff0..2174355 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -294,6 +294,8 @@ extern u64 kvm_supported_xcr0(void);
 
 extern unsigned int min_timer_period_us;
 
+extern unsigned int vmentry_advance_ns;
+
 extern bool enable_vmware_backdoor;
 
 extern struct static_key kvm_no_apic_vcpu;
-- 
2.7.4

