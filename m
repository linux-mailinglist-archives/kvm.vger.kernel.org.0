Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC97218903
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 13:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfEIL3e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 07:29:34 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39264 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfEIL3d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 07:29:33 -0400
Received: by mail-pf1-f194.google.com with SMTP id z26so1177356pfg.6;
        Thu, 09 May 2019 04:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5DvFRZTUWanlthlQLd8mlru8FuUEV3Rf9+IyxekpdVY=;
        b=DqHpG4bIA6azTNVld2ZMnNz0OkMYL/l8sPZtmHj//yuXNiBPIBk2NtTBC7WLkROsaQ
         IteiQnwnXGmx2bhEuJDhNWsLK4hbgAH1/hycdH0CttqkY1NxqKehdtjVfta2wDwwtRHj
         xl9vsLtyuPcur6uYiPLNSVk7tUhrMhoLPH9f8QJv9oGoERqbCDY7KVTc/E4Sa19Cu3rf
         DX48fU0/YMDR4N2qxZ7gklqlMbcSZvfGWz8DgSf8SgzhKTQ151y5VDdmLdKRrawmIa8H
         BHfMdQWHI7aH3e/+dz2m+RhkILcZWUKg1Z1hwKBCZM81FRRFRvgG6SeJ5bjIsI16R3j2
         V/BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5DvFRZTUWanlthlQLd8mlru8FuUEV3Rf9+IyxekpdVY=;
        b=eIYgAU0HSd/4L46MEtW2gQuVnjiBoMwp/ad2a4c3JR6BEgw5Lu124iz6cNBHpi8jIU
         oVqXo4/D0GDokCAw4Kzpn7CExaSXXNntxFxGoZvqFNE3KM07k6qJZ12wX0E4DR3OxiML
         OL/CS1c6w7ezLWR80tez5gwIZcs2pQW2+W+pthGlmDcghcU01+34+iqNAkVhrnh2oSQ4
         ZugNZSBoj5S4uK1bcyXghBNm2oUMqe9mwiWAQLULwH375B/ND3vCTz2wsXCSnsHGJD+f
         qjGDxkYgn4IRLY7ixwqnjf+W73xedWG0VuUr0o7rE+viOYmWAf4yIDWyav4KHxoJBQ0K
         1a3w==
X-Gm-Message-State: APjAAAUoOIFh4FWN56/6nnO9+DgVXJxy2W8n0Mo3d6jY5/JQQoWN8hC0
        Hlp690upp5ev0Z6M+5klrEws1+cx
X-Google-Smtp-Source: APXvYqwOe6TjA1d4dpOuqWWylbPGLc2MYOiqFaQ5j2XdPW1XzFl5ynVWAH+ExOIbNeJGtSfQlyB8zQ==
X-Received: by 2002:a63:da14:: with SMTP id c20mr4674968pgh.191.1557401372357;
        Thu, 09 May 2019 04:29:32 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id j10sm2762002pfa.37.2019.05.09.04.29.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 09 May 2019 04:29:31 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH 3/3] KVM: LAPIC: Optimize timer latency further
Date:   Thu,  9 May 2019 19:29:21 +0800
Message-Id: <1557401361-3828-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557401361-3828-1-git-send-email-wanpengli@tencent.com>
References: <1557401361-3828-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Advance lapic timer tries to hidden the hypervisor overhead between host 
timer fires and the guest awares the timer is fired. However, it just hidden 
the time between apic_timer_fn/handle_preemption_timer -> wait_lapic_expire, 
instead of the real position of vmentry which is mentioned in the orignial 
commit d0659d946be0 ("KVM: x86: add option to advance tscdeadline hrtimer 
expiration"). There is 700+ cpu cycles between the end of wait_lapic_expire 
and before world switch on my haswell desktop, it will be 2400+ cycles if 
vmentry_l1d_flush is tuned to always. 

This patch tries to narrow the last gap, it measures the time between 
the end of wait_lapic_expire and before world switch, we take this 
time into consideration when busy waiting, otherwise, the guest still 
awares the latency between wait_lapic_expire and world switch, we also 
consider this when adaptively tuning the timer advancement. The patch 
can reduce 50% latency (~1600+ cycles to ~800+ cycles on a haswell 
desktop) for kvm-unit-tests/tscdeadline_latency when testing busy waits.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c   | 23 +++++++++++++++++++++--
 arch/x86/kvm/lapic.h   |  8 ++++++++
 arch/x86/kvm/vmx/vmx.c |  2 ++
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e7a0660..01d3a87 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1545,13 +1545,19 @@ void wait_lapic_expire(struct kvm_vcpu *vcpu)
 
 	tsc_deadline = apic->lapic_timer.expired_tscdeadline;
 	apic->lapic_timer.expired_tscdeadline = 0;
-	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
+	guest_tsc = kvm_read_l1_tsc(vcpu, (apic->lapic_timer.measure_delay_done == 2) ?
+		rdtsc() + apic->lapic_timer.vmentry_delay : rdtsc());
 	trace_kvm_wait_lapic_expire(vcpu->vcpu_id, guest_tsc - tsc_deadline);
 
 	if (guest_tsc < tsc_deadline)
 		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
 
 	adaptive_tune_timer_advancement(vcpu, guest_tsc, tsc_deadline);
+
+	if (!apic->lapic_timer.measure_delay_done) {
+		apic->lapic_timer.measure_delay_done = 1;
+		apic->lapic_timer.vmentry_delay = rdtsc();
+	}
 }
 
 static void start_sw_tscdeadline(struct kvm_lapic *apic)
@@ -1837,6 +1843,18 @@ static void apic_manage_nmi_watchdog(struct kvm_lapic *apic, u32 lvt0_val)
 	}
 }
 
+void kvm_lapic_measure_vmentry_delay(struct kvm_vcpu *vcpu)
+{
+	struct kvm_timer *ktimer = &vcpu->arch.apic->lapic_timer;
+
+	if (ktimer->measure_delay_done == 1) {
+		ktimer->vmentry_delay = rdtsc() -
+			ktimer->vmentry_delay;
+		ktimer->measure_delay_done = 2;
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_lapic_measure_vmentry_delay);
+
 int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 {
 	int ret = 0;
@@ -2318,7 +2336,8 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 		apic->lapic_timer.timer_advance_ns = timer_advance_ns;
 		apic->lapic_timer.timer_advance_adjust_done = true;
 	}
-
+	apic->lapic_timer.vmentry_delay = 0;
+	apic->lapic_timer.measure_delay_done = 0;
 
 	/*
 	 * APIC is created enabled. This will prevent kvm_lapic_set_base from
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index d6d049b..f1d037b 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -35,6 +35,13 @@ struct kvm_timer {
 	atomic_t pending;			/* accumulated triggered timers */
 	bool hv_timer_in_use;
 	bool timer_advance_adjust_done;
+	/**
+	 * 0 unstart measure
+	 * 1 start record
+	 * 2 get delta
+	 */
+	u32 measure_delay_done;
+	u64 vmentry_delay;
 };
 
 struct kvm_lapic {
@@ -230,6 +237,7 @@ void kvm_lapic_switch_to_hv_timer(struct kvm_vcpu *vcpu);
 void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu);
 bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu);
 void kvm_lapic_restart_hv_timer(struct kvm_vcpu *vcpu);
+void kvm_lapic_measure_vmentry_delay(struct kvm_vcpu *vcpu);
 
 static inline enum lapic_mode kvm_apic_mode(u64 apic_base)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9663d41..a939bf5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6437,6 +6437,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.cr2 != read_cr2())
 		write_cr2(vcpu->arch.cr2);
 
+	kvm_lapic_measure_vmentry_delay(vcpu);
+
 	vmx->fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
 				   vmx->loaded_vmcs->launched);
 
-- 
2.7.4

