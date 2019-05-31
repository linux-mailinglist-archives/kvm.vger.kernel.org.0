Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF63308CF
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 08:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfEaGkV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 02:40:21 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46590 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbfEaGkV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 02:40:21 -0400
Received: by mail-pl1-f195.google.com with SMTP id e5so1849653pls.13;
        Thu, 30 May 2019 23:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mGboCmkg0fk3XUyk0Xb6IlpZfHbW2E2mZkDfzw34EEg=;
        b=AY7AjyyBk+Gqw+0UVpfhkkPzaAqli5ksrJrAeVzcY1fIgfhnUJBdSgsaR3LIoLIqcx
         Y/sSSgMRnLk6Xjhcol8kgqviwjlihxgQdOuCn/yZ0KeAaKvRZqyUFRCFkJwuDSkVmCO+
         fxd3luwD4v7C6rVIZePFghvLsNrUAWN2nBBtL1Y01TiK070YKtAAofhT/nvTyfPkTmdf
         np0c9WHPWLhO8g1VkZ/z4z7D6MYi3igigBxVLcxkDDSHvbOWzoErsR8aFkKiJ4cXNkZ/
         mzK/3KMiwAlPB9YZDdoi7221yZDZ7sxB8irQodEDKttdUX4vm7wC75m7GCnd+JwTA84E
         V4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mGboCmkg0fk3XUyk0Xb6IlpZfHbW2E2mZkDfzw34EEg=;
        b=Gq9oxIlQ0ISq98Q/EYuXNEv20KA6vt2kxLc5wbrKvrvvcKIWL0/I+hopg4fW366VmP
         2NShcc/4YWz3WdezvsvF7lR0TzlGdE8raUrqvLIjEk8bWP3SHV44seQ08G5eYLg9Dfrz
         SKIVodQrTEPCcCQ9/jDXSVhONBKGGQIf/FEcilJ/L4wjEToM3zDxuRApxfZmEnIPB8rC
         g9CW3040e26NLqMjWenonSCmI9Nkbx5Dlsec2pdkEF1WiGuYdrNgqZ0YMHU8zD+IohQd
         DkJVM2Fr/897dapfU3lMV8GsVcQGRSwQbqQoxyDSSC4KMbXBWjw9JGLcyac9OWjYqBTx
         r7MA==
X-Gm-Message-State: APjAAAWafubRa5+4uUgTIiHPzX5Sg5Cn+2JhU93h28AnJvyvA6wdWvXR
        I/NaERFHuXvdAiLy61cI+Q7PxFoX
X-Google-Smtp-Source: APXvYqz1QRwOUmotNrA05JC6uwgPMpyVNFg4vYH2YuZ4Uji9lQqPCSFX8seC7vVsdziDOQgkQ/vLmA==
X-Received: by 2002:a17:902:9682:: with SMTP id n2mr2746719plp.95.1559284819787;
        Thu, 30 May 2019 23:40:19 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id w4sm4658574pfi.87.2019.05.30.23.40.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 30 May 2019 23:40:19 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v2 1/2] KVM: LAPIC: Optimize timer latency consider world switch time
Date:   Fri, 31 May 2019 14:40:13 +0800
Message-Id: <1559284814-20378-1-git-send-email-wanpengli@tencent.com>
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

The vmentry_lapic_timer_advance_ns module parameter should be well tuned by 
host admin, setting bit 0 to 1 to finally cache parameter in KVM. This patch 
can reduce average cyclictest latency from 3us to 2us on Skylake server. 
(guest w/ nohz=off, idle=poll, host w/ preemption_timer=N, the cyclictest 
latency is not too sensitive when preemption_timer=Y for this optimization in 
my testing), kvm-unit-tests/tscdeadline_latency can reach 0.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
NOTE: rebase on https://lkml.org/lkml/2019/5/20/449
v1 -> v2:
 * rename get_vmentry_advance_delta to get_vmentry_advance_cycles
 * cache vmentry_advance_cycles by setting param bit 0 
 * add param max limit 

 arch/x86/kvm/lapic.c   | 38 +++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/lapic.h   |  3 +++
 arch/x86/kvm/vmx/vmx.c |  2 +-
 arch/x86/kvm/x86.c     |  9 +++++++++
 arch/x86/kvm/x86.h     |  2 ++
 5 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index fcf42a3..60587b5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1531,6 +1531,38 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
 	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
 }
 
+#define MAX_VMENTRY_ADVANCE_NS 1000
+
+u64 compute_vmentry_advance_cycles(struct kvm_vcpu *vcpu)
+{
+	u64 cycles;
+	struct kvm_lapic *apic = vcpu->arch.apic;
+	u64 val = min_t(u32, vmentry_lapic_timer_advance_ns, MAX_VMENTRY_ADVANCE_NS);
+
+	cycles = (val & ~1ULL) * vcpu->arch.virtual_tsc_khz;
+	do_div(cycles, 1000000);
+
+	/* setting bit 0 locks the value, it is cached */
+	if (val & 1)
+		apic->lapic_timer.vmentry_advance_cycles = cycles;
+
+	return cycles;
+}
+
+inline u64 get_vmentry_advance_cycles(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+
+	if (!vmentry_lapic_timer_advance_ns)
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
@@ -1544,7 +1576,7 @@ void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 
 	tsc_deadline = apic->lapic_timer.expired_tscdeadline;
 	apic->lapic_timer.expired_tscdeadline = 0;
-	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
+	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc()) + get_vmentry_advance_cycles(vcpu);
 	apic->lapic_timer.advance_expire_delta = guest_tsc - tsc_deadline;
 
 	if (guest_tsc < tsc_deadline)
@@ -1572,7 +1604,7 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
 	local_irq_save(flags);
 
 	now = ktime_get();
-	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
+	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc()) + get_vmentry_advance_cycles(vcpu);
 
 	ns = (tscdeadline - guest_tsc) * 1000000ULL;
 	do_div(ns, this_tsc_khz);
@@ -2329,7 +2361,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 		apic->lapic_timer.timer_advance_ns = timer_advance_ns;
 		apic->lapic_timer.timer_advance_adjust_done = true;
 	}
-
+	apic->lapic_timer.vmentry_advance_cycles = 0;
 
 	/*
 	 * APIC is created enabled. This will prevent kvm_lapic_set_base from
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index f974a3d..70854a9 100644
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
+inline u64 get_vmentry_advance_cycles(struct kvm_vcpu *vcpu);
 
 bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq *irq,
 			struct kvm_vcpu **dest_vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a341663..255b5d5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7047,7 +7047,7 @@ static int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 
 	vmx = to_vmx(vcpu);
 	tscl = rdtsc();
-	guest_tscl = kvm_read_l1_tsc(vcpu, tscl);
+	guest_tscl = kvm_read_l1_tsc(vcpu, tscl) + get_vmentry_advance_cycles(vcpu);
 	delta_tsc = max(guest_deadline_tsc, guest_tscl) - guest_tscl;
 	lapic_timer_advance_cycles = nsec_to_cycles(vcpu,
 						    ktimer->timer_advance_ns);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 69c3672e..0d4eb27 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -145,6 +145,13 @@ module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
 static int __read_mostly lapic_timer_advance_ns = -1;
 module_param(lapic_timer_advance_ns, int, S_IRUGO | S_IWUSR);
 
+/*
+ * lapic timer vmentry advance (tscdeadline mode only) in nanoseconds. Setting
+ * bit 0 to 1 after well manually tuning to cache vmentry advance time.
+ */
+u32 __read_mostly vmentry_lapic_timer_advance_ns = 0;
+module_param(vmentry_lapic_timer_advance_ns, uint, S_IRUGO | S_IWUSR);
+
 static bool __read_mostly vector_hashing = true;
 module_param(vector_hashing, bool, S_IRUGO);
 
@@ -1592,6 +1599,8 @@ static int kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz)
 	kvm_get_time_scale(user_tsc_khz * 1000LL, NSEC_PER_SEC,
 			   &vcpu->arch.virtual_tsc_shift,
 			   &vcpu->arch.virtual_tsc_mult);
+	if (vcpu->arch.apic && user_tsc_khz != vcpu->arch.virtual_tsc_khz)
+		compute_vmentry_advance_cycles(vcpu);
 	vcpu->arch.virtual_tsc_khz = user_tsc_khz;
 
 	/*
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 275b3b6..b0a3b84 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -294,6 +294,8 @@ extern u64 kvm_supported_xcr0(void);
 
 extern unsigned int min_timer_period_us;
 
+extern unsigned int vmentry_lapic_timer_advance_ns;
+
 extern bool enable_vmware_backdoor;
 
 extern struct static_key kvm_no_apic_vcpu;
-- 
2.7.4

