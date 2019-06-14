Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB4F845114
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 03:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbfFNBQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 21:16:01 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38847 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbfFNBQA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 21:16:00 -0400
Received: by mail-pf1-f196.google.com with SMTP id a186so334185pfa.5;
        Thu, 13 Jun 2019 18:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BYpsue11ogy0WJQ7gNVPo6eSXcQmDPB80/uq5wtSxFs=;
        b=ADr+3c6g0PHDWnGaqtj//WCtn2LgX8K66YeOsfnSyz7sIp2+6QzFuGg1rGyBnT2NzZ
         JmuzmhGv/77Cs8VqUmsOF9e0BBacnhiTZ2UoSQJM51RwWNtBDY0oKpu5teEoE3923CNi
         NOmnD0+Ixk36CLKk1Cou/LFWVueFzGdPb4u7/OB3lxEHy2SEc/lmlEi1651/VSbxhWth
         eTP4CKaqWlayXWd7VIO6f9XXpcCUrvquYlsD6tj9oZ72nc9V9n/zm+dzVLNJmfRDbTVy
         VBukaNv0sCsHBMKV03MGrMQxVtB3dn5SYmxzjMvSm2DxIQwD26cPRR6jCm9F5bdX3Kap
         C/oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BYpsue11ogy0WJQ7gNVPo6eSXcQmDPB80/uq5wtSxFs=;
        b=l5tQQlfWVrEJ/9HPaqo8MIqouv15DJ499tpDUV747m31BJfYNX/DdbTty7fgkw3afz
         FxvHA8y/qpldxNuc2R54XAl5mvlx075c913m/6n6/0BNa35CPAwRe03mimDDhAOe8Fns
         PY9vIgcF3Z3JKgL5dBAPkHkUZDKsrlCA0DN6KKEgl3rx0FbXCby38bBENipGxw1dz/Ah
         bezNfVD/n+AQic+7IPaOYTnjCYlHaCFfGygkxrd/Dqy8urCJGCE1h1Ccsb2HrU5Cnd8m
         a9lu7Ak6wWqDM0D02RMnypAFMAGebi+NBQg4veQ8o4TqKJvrWbSUo8pFJ+slJBfO4b4J
         ZF9g==
X-Gm-Message-State: APjAAAWD8EYbksmltUkPh0S0C2cw+DCLTJIeqnE2KG4lEaPSCqL1aPkR
        /l8tP5kr4lhu0R7m+fieOCx8HYEr
X-Google-Smtp-Source: APXvYqzNhYwlz1QCnGaJ2veisPeonTcAp2VGW0o9mepjFCq/HipbAawATHRlo3/1K6+2bdaw8pJEtA==
X-Received: by 2002:a62:5214:: with SMTP id g20mr42008506pfb.187.1560474959067;
        Thu, 13 Jun 2019 18:15:59 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id k3sm907424pgo.81.2019.06.13.18.15.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 13 Jun 2019 18:15:58 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v4 1/2] KVM: LAPIC: Optimize timer latency consider world switch time
Date:   Fri, 14 Jun 2019 09:15:49 +0800
Message-Id: <1560474949-20497-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560474949-20497-1-git-send-email-wanpengli@tencent.com>
References: <1560474949-20497-1-git-send-email-wanpengli@tencent.com>
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

The vmentry_advance_ns module parameter is conservative 25ns by default(thanks 
to Radim's kvm-unit-tests/vmentry_latency.flat), it can be tuned/reworked in 
the future.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v3 -> v4:
 * default value is 25ns
 * compute vmentry_advance_cycles in kvm_set_tsc_khz() path
v2 -> v3:
 * read-only module parameter
 * get_vmentry_advance_cycles() not inline
v1 -> v2:
 * rename get_vmentry_advance_delta to get_vmentry_advance_cycles
 * cache vmentry_advance_cycles by setting param bit 0 
 * add param max limit 

 arch/x86/kvm/lapic.c   | 21 ++++++++++++++++++---
 arch/x86/kvm/lapic.h   |  2 ++
 arch/x86/kvm/vmx/vmx.c |  3 ++-
 arch/x86/kvm/x86.c     | 12 ++++++++++--
 arch/x86/kvm/x86.h     |  2 ++
 5 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e82a18c..e92e4e5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1528,6 +1528,19 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
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
 void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
@@ -1541,7 +1554,8 @@ void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 
 	tsc_deadline = apic->lapic_timer.expired_tscdeadline;
 	apic->lapic_timer.expired_tscdeadline = 0;
-	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
+	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc()) +
+		apic->lapic_timer.vmentry_advance_cycles;
 	apic->lapic_timer.advance_expire_delta = guest_tsc - tsc_deadline;
 
 	if (guest_tsc < tsc_deadline)
@@ -1569,7 +1583,8 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
 	local_irq_save(flags);
 
 	now = ktime_get();
-	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
+	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc()) +
+		apic->lapic_timer.vmentry_advance_cycles;
 
 	ns = (tscdeadline - guest_tsc) * 1000000ULL;
 	do_div(ns, this_tsc_khz);
@@ -2326,7 +2341,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 		apic->lapic_timer.timer_advance_ns = timer_advance_ns;
 		apic->lapic_timer.timer_advance_adjust_done = true;
 	}
-
+	apic->lapic_timer.vmentry_advance_cycles = 0;
 
 	/*
 	 * APIC is created enabled. This will prevent kvm_lapic_set_base from
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 3674717..7c38950 100644
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
@@ -226,6 +227,7 @@ static inline int kvm_lapic_latched_init(struct kvm_vcpu *vcpu)
 bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
 
 void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
+u64 compute_vmentry_advance_cycles(struct kvm_vcpu *vcpu);
 
 bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq *irq,
 			struct kvm_vcpu **dest_vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8fbea03..dc81c78 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7064,7 +7064,8 @@ static int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 
 	vmx = to_vmx(vcpu);
 	tscl = rdtsc();
-	guest_tscl = kvm_read_l1_tsc(vcpu, tscl);
+	guest_tscl = kvm_read_l1_tsc(vcpu, tscl) +
+		vcpu->arch.apic->lapic_timer.vmentry_advance_cycles;
 	delta_tsc = max(guest_deadline_tsc, guest_tscl) - guest_tscl;
 	lapic_timer_advance_cycles = nsec_to_cycles(vcpu,
 						    ktimer->timer_advance_ns);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0a05a4e..5e79b6c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -145,6 +145,12 @@ module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
 static int __read_mostly lapic_timer_advance_ns = -1;
 module_param(lapic_timer_advance_ns, int, S_IRUGO | S_IWUSR);
 
+/*
+ * lapic timer vmentry advance (tscdeadline mode only) in nanoseconds.
+ */
+u32 __read_mostly vmentry_advance_ns = 25;
+module_param(vmentry_advance_ns, uint, S_IRUGO);
+
 static bool __read_mostly vector_hashing = true;
 module_param(vector_hashing, bool, S_IRUGO);
 
@@ -1592,6 +1598,8 @@ static int kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz)
 	kvm_get_time_scale(user_tsc_khz * 1000LL, NSEC_PER_SEC,
 			   &vcpu->arch.virtual_tsc_shift,
 			   &vcpu->arch.virtual_tsc_mult);
+	if (user_tsc_khz != vcpu->arch.virtual_tsc_khz)
+		compute_vmentry_advance_cycles(vcpu);
 	vcpu->arch.virtual_tsc_khz = user_tsc_khz;
 
 	/*
@@ -9134,8 +9142,6 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	}
 	vcpu->arch.pio_data = page_address(page);
 
-	kvm_set_tsc_khz(vcpu, max_tsc_khz);
-
 	r = kvm_mmu_create(vcpu);
 	if (r < 0)
 		goto fail_free_pio_data;
@@ -9148,6 +9154,8 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	} else
 		static_key_slow_inc(&kvm_no_apic_vcpu);
 
+	kvm_set_tsc_khz(vcpu, max_tsc_khz);
+
 	vcpu->arch.mce_banks = kzalloc(KVM_MAX_MCE_BANKS * sizeof(u64) * 4,
 				       GFP_KERNEL_ACCOUNT);
 	if (!vcpu->arch.mce_banks) {
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index e08a128..9998989 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -299,6 +299,8 @@ extern u64 kvm_supported_xcr0(void);
 
 extern unsigned int min_timer_period_us;
 
+extern unsigned int vmentry_advance_ns;
+
 extern bool enable_vmware_backdoor;
 
 extern struct static_key kvm_no_apic_vcpu;
-- 
2.7.4

