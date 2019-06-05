Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3911935A38
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2019 12:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbfFEKJc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jun 2019 06:09:32 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41763 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbfFEKJb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jun 2019 06:09:31 -0400
Received: by mail-pg1-f193.google.com with SMTP id 83so5306793pgg.8;
        Wed, 05 Jun 2019 03:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZZm7DGje/zlhjtpgaoTPoEdNdJYzoHqe7K5tKElHL8Y=;
        b=HDj23HZb4qw/LTHKStHh0a8pmk3wkgcZ3Cz/08O6TLTnSbfgsvBj6J1FdfnRi3mN1L
         L/AWVl1zcd32QUrHZzdtFRjk0NgCUHuefoDdBtuLRSCdynuajgLCxBfGLB6HcxOecTRZ
         pM7hnpwlpXwOQTlR36Gy6YoX/M+pHBcsvDZqlkYgXi4Uq/avv5BvHqSP7enukwPTImBH
         twY/c16H7mZzUQfBtGK4uD8wVc+tRVSIISZ/BlAs606vzgL0eShKJDyKshUtogS/MPVI
         6nCteP+uD7aI9uwJNg3KMjAqj8dLK62peCrY2vjA+28wQeUPK+R2UFqboO8PVd5c7U/K
         2Ifg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZZm7DGje/zlhjtpgaoTPoEdNdJYzoHqe7K5tKElHL8Y=;
        b=J73MjI0sHGBwzHOnYoH2rNUQSW+wlO6vxdlobXiwElHmxjL+pPjoXgZiYPayOoluAu
         Gk+ZoXsGl1MvHkW0Eiwh+5GpFNBd03w+Yj9igufbRXF1As7fH45ciRrmdTf+0RWXGYuk
         WtpbTel2M4aV2HN4iLBddraLesB3re+t33FATKlbiqf3BhxGUlORq+d03jiX7ZlO2+pW
         Jl2zhDOJvZZ+0SctC9/rp6oHPSxzbDNHxGK6Yb3JV7Glw62sX6WDjsosj+qEScahCCRZ
         k+IGhetxglk9akc0+K3CqY3lRA/NDNAYQGMCOSgQjTDP8Mt1qtlcLSnK+DuFOky/87Xj
         v+3g==
X-Gm-Message-State: APjAAAXzLaq5wgkfmK/HCG/NHn92mhSjDtcj+iTyH0/cIgiJk4r0SJlz
        negW2g5E6v+SmyBcuNFguJ4Z0797
X-Google-Smtp-Source: APXvYqxPsHm/fbZhg0wAMb/lhSCMH63kF+BsJoqoQWW7FESWmJnaQjWnY0J9XD+tV2jENP7lSFOemA==
X-Received: by 2002:a63:b1d:: with SMTP id 29mr3256286pgl.103.1559729370327;
        Wed, 05 Jun 2019 03:09:30 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id v9sm19030010pfm.34.2019.06.05.03.09.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 05 Jun 2019 03:09:29 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 1/3] KVM: LAPIC: Make lapic timer unpinned when timer is injected by posted-interrupt
Date:   Wed,  5 Jun 2019 18:09:09 +0800
Message-Id: <1559729351-20244-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559729351-20244-1-git-send-email-wanpengli@tencent.com>
References: <1559729351-20244-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Make lapic timer unpinned when timer is injected by posted-interrupt,
the emulated timer can be offload to the housekeeping cpus.

This patch introduces a new kvm module parameter, it is false by default.
The host admin can enable it after fine tuned, e.g. dedicated instances 
scenario w/ nohz_full cover the pCPUs which vCPUs resident, several pCPUs 
surplus for housekeeping, disable mwait/hlt/pause vmexits to occupy the 
pCPUs, fortunately preemption timer is disabled after mwait is exposed 
to guest which makes emulated timer offload can be possible. 

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/lapic.c            | 20 ++++++++++++++++----
 arch/x86/kvm/svm.c              |  5 +++++
 arch/x86/kvm/vmx/vmx.c          |  9 +++++++++
 4 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index aeadbc7..ccb3d61 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1090,6 +1090,7 @@ struct kvm_x86_ops {
 	void (*set_virtual_apic_mode)(struct kvm_vcpu *vcpu);
 	void (*set_apic_access_page_addr)(struct kvm_vcpu *vcpu, hpa_t hpa);
 	void (*deliver_posted_interrupt)(struct kvm_vcpu *vcpu, int vector);
+	bool (*pi_inject_timer_enabled)(struct kvm_vcpu *vcpu);
 	int (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index fcf42a3..8c9c14d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -127,6 +127,12 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
 	return apic->vcpu->vcpu_id;
 }
 
+static inline bool posted_interrupt_inject_timer(struct kvm_vcpu *vcpu)
+{
+	return (kvm_x86_ops->pi_inject_timer_enabled(vcpu) &&
+		kvm_mwait_in_guest(vcpu->kvm));
+}
+
 static inline bool kvm_apic_map_get_logical_dest(struct kvm_apic_map *map,
 		u32 dest_id, struct kvm_lapic ***cluster, u16 *mask) {
 	switch (map->mode) {
@@ -1581,7 +1587,9 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
 	    likely(ns > apic->lapic_timer.timer_advance_ns)) {
 		expire = ktime_add_ns(now, ns);
 		expire = ktime_sub_ns(expire, ktimer->timer_advance_ns);
-		hrtimer_start(&ktimer->timer, expire, HRTIMER_MODE_ABS_PINNED);
+		hrtimer_start(&ktimer->timer, expire,
+			posted_interrupt_inject_timer(vcpu) ?
+			HRTIMER_MODE_ABS : HRTIMER_MODE_ABS_PINNED);
 	} else
 		apic_timer_expired(apic);
 
@@ -1683,7 +1691,8 @@ static void start_sw_period(struct kvm_lapic *apic)
 
 	hrtimer_start(&apic->lapic_timer.timer,
 		apic->lapic_timer.target_expiration,
-		HRTIMER_MODE_ABS_PINNED);
+		posted_interrupt_inject_timer(apic->vcpu) ?
+		HRTIMER_MODE_ABS : HRTIMER_MODE_ABS_PINNED);
 }
 
 bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu)
@@ -2320,7 +2329,8 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 	apic->vcpu = vcpu;
 
 	hrtimer_init(&apic->lapic_timer.timer, CLOCK_MONOTONIC,
-		     HRTIMER_MODE_ABS_PINNED);
+		posted_interrupt_inject_timer(vcpu) ?
+		HRTIMER_MODE_ABS : HRTIMER_MODE_ABS_PINNED);
 	apic->lapic_timer.timer.function = apic_timer_fn;
 	if (timer_advance_ns == -1) {
 		apic->lapic_timer.timer_advance_ns = 1000;
@@ -2509,7 +2519,9 @@ void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
 
 	timer = &vcpu->arch.apic->lapic_timer.timer;
 	if (hrtimer_cancel(timer))
-		hrtimer_start_expires(timer, HRTIMER_MODE_ABS_PINNED);
+		hrtimer_start_expires(timer,
+			posted_interrupt_inject_timer(vcpu) ?
+			HRTIMER_MODE_ABS : HRTIMER_MODE_ABS_PINNED);
 }
 
 /*
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 302cb40..aee1d91 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5173,6 +5173,11 @@ static void svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
 		kvm_vcpu_wake_up(vcpu);
 }
 
+static inline bool svm_posted_interrupt_inject_timer(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 static void svm_ir_list_del(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
 {
 	unsigned long flags;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index da24f18..2b4fd61 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -101,6 +101,9 @@ module_param(fasteoi, bool, S_IRUGO);
 static bool __read_mostly enable_apicv = 1;
 module_param(enable_apicv, bool, S_IRUGO);
 
+bool __read_mostly pi_inject_timer = 0;
+module_param(pi_inject_timer, bool, S_IRUGO);
+
 /*
  * If nested=1, nested virtualization is supported, i.e., guests may use
  * VMX and be a hypervisor for its own guests. If nested=0, guests may not
@@ -3724,6 +3727,11 @@ static void vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 		kvm_vcpu_kick(vcpu);
 }
 
+static bool vmx_pi_inject_timer_enabled(struct kvm_vcpu *vcpu)
+{
+	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
+}
+
 /*
  * Set up the vmcs's constant host-state fields, i.e., host-state fields that
  * will not change in the lifetime of the guest.
@@ -7671,6 +7679,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.guest_apic_has_interrupt = vmx_guest_apic_has_interrupt,
 	.sync_pir_to_irr = vmx_sync_pir_to_irr,
 	.deliver_posted_interrupt = vmx_deliver_posted_interrupt,
+	.pi_inject_timer_enabled = vmx_pi_inject_timer_enabled,
 
 	.set_tss_addr = vmx_set_tss_addr,
 	.set_identity_map_addr = vmx_set_identity_map_addr,
-- 
2.7.4

