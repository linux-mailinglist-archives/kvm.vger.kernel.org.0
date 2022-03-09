Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF73B4D3114
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 15:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbiCIOj6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 09:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233220AbiCIOjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 09:39:54 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4C612D21A
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 06:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=D2qHPJbThFRFu5RRUUNQhouTK+5EfXU9noky1T3t8ss=; b=fKTRaRsJe7hnX2UHxd7+wabIHU
        1kRdnCBVP1NceTB9xXUmmJbo1rghRkDL0L2WQ/fn3Okf+fBS0KtKFn6dOvf2TKgwDtRk2PmMk8XC2
        pleEdG9R1Y6FABBC8xv079HxOcYqqqK+PBgUzOxzd4he5zdolubemtLqOcAju3ehcPY8Cf+raM6nB
        N/8QpOHTrZCxtC88PEo1I9pLNHjB4/RPU86Ph2aDPY/LBWCXu3A9PKFFV22Z58oOAhbwhfN+HYE/i
        YUB8wsaWxLwD/nffa3Fyfi7S1Tn3o2H1+ENKkrtImxp/YEaEsCLCJ/whfNr5hZfr/eC9Q700memqS
        uFycuMwg==;
Received: from [2001:8b0:10b:1:85c4:81a:fb42:714d] (helo=i7.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nRxSX-00GmoR-Qi; Wed, 09 Mar 2022 14:38:38 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nRxSX-00143h-4p; Wed, 09 Mar 2022 14:38:37 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>,
        Paul Durrant <pdurrant@amazon.co.uk>
Subject: [PATCH 1/2] KVM: x86/xen: PV oneshot timer fixes
Date:   Wed,  9 Mar 2022 14:38:34 +0000
Message-Id: <20220309143835.253911-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220309143835.253911-1-dwmw2@infradead.org>
References: <20220309143835.253911-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Fix the case where a restored timer is supposed to have triggered not
just in the past, but before this kernel even booted. The resulting
integer wrap caused the timer to be set a very long time into the future,
and thus effectively never trigger. Trigger timers immediately when
delta_ns <= 0 to avoid that situation.

Also switch to using HRTIMER_MODE_ABS_HARD, following the changes in the
local APIC timer in commits 2c0d278f3293f ("KVM: LAPIC: Mark hrtimer to
expire in hard interrupt context") and 4d151bf3b89e7 ("KVM: LAPIC: Make
lapic timer unpinned")... and the change I'm about to submit to fix the
local APIC timer not to gratuitously cancel and restart the hrtimer on
migration, since it isn't pinned any more anyway.

On serializing the timer state for migration, only set the expires_ns
if the timer is still active, otherwise return zero in that field.

Finally, fix the 'delta' in kvm_xen_hcall_set_timer_op() to explicitly
use 'int64_t' instead of 'long' to make the sanity check shift by 50
bits work correctly in the 32-bit build. That last one was

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/irq.c |  1 -
 arch/x86/kvm/xen.c | 37 +++++++++++++++----------------------
 arch/x86/kvm/xen.h |  1 -
 3 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index af2d26fc5458..f371f1292ca3 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -156,7 +156,6 @@ void __kvm_migrate_timers(struct kvm_vcpu *vcpu)
 {
 	__kvm_migrate_apic_timer(vcpu);
 	__kvm_migrate_pit_timer(vcpu);
-	__kvm_migrate_xen_timer(vcpu);
 	static_call_cond(kvm_x86_migrate_timers)(vcpu);
 }
 
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 8c85a71aa8ca..2131e21ce6c7 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -150,29 +150,19 @@ static enum hrtimer_restart xen_timer_callback(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
-void __kvm_migrate_xen_timer(struct kvm_vcpu *vcpu)
+static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs, s64 delta_ns)
 {
-	struct hrtimer *timer;
-
-	if (!kvm_xen_timer_enabled(vcpu))
-		return;
-
-	timer = &vcpu->arch.xen.timer;
-	if (hrtimer_cancel(timer))
-		hrtimer_start_expires(timer, HRTIMER_MODE_ABS_PINNED);
-}
-
-static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs, u64 delta_ns)
-{
-	ktime_t ktime_now;
-
 	atomic_set(&vcpu->arch.xen.timer_pending, 0);
 	vcpu->arch.xen.timer_expires = guest_abs;
 
-	ktime_now = ktime_get();
-	hrtimer_start(&vcpu->arch.xen.timer,
-		      ktime_add_ns(ktime_now, delta_ns),
-		      HRTIMER_MODE_ABS_PINNED);
+	if (delta_ns <= 0) {
+		xen_timer_callback(&vcpu->arch.xen.timer);
+	} else {
+		ktime_t ktime_now = ktime_get();
+		hrtimer_start(&vcpu->arch.xen.timer,
+			      ktime_add_ns(ktime_now, delta_ns),
+			      HRTIMER_MODE_ABS_HARD);
+	}
 }
 
 static void kvm_xen_stop_timer(struct kvm_vcpu *vcpu)
@@ -185,7 +175,7 @@ static void kvm_xen_stop_timer(struct kvm_vcpu *vcpu)
 static void kvm_xen_init_timer(struct kvm_vcpu *vcpu)
 {
 	hrtimer_init(&vcpu->arch.xen.timer, CLOCK_MONOTONIC,
-		     HRTIMER_MODE_ABS_PINNED);
+		     HRTIMER_MODE_ABS_HARD);
 	vcpu->arch.xen.timer.function = xen_timer_callback;
 }
 
@@ -839,7 +829,10 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 	case KVM_XEN_VCPU_ATTR_TYPE_TIMER:
 		data->u.timer.port = vcpu->arch.xen.timer_virq;
 		data->u.timer.priority = KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
-		data->u.timer.expires_ns = vcpu->arch.xen.timer_expires;
+		if (hrtimer_active(&vcpu->arch.xen.timer))
+			data->u.timer.expires_ns = vcpu->arch.xen.timer_expires;
+		else
+			data->u.timer.expires_ns = 0;
 		r = 0;
 		break;
 
@@ -1204,7 +1197,7 @@ static bool kvm_xen_hcall_set_timer_op(struct kvm_vcpu *vcpu, uint64_t timeout,
 
 	if (timeout) {
 		uint64_t guest_now = get_kvmclock_ns(vcpu->kvm);
-		long delta = timeout - guest_now;
+		int64_t delta = timeout - guest_now;
 
 		/* Xen has a 'Linux workaround' in do_set_timer_op() which
 		 * checks for negative absolute timeout values (caused by
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index ad0876a7c301..2bbbc1a3953e 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -75,7 +75,6 @@ static inline int kvm_xen_has_pending_timer(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-void __kvm_migrate_xen_timer(struct kvm_vcpu *vcpu);
 void kvm_xen_inject_timer_irqs(struct kvm_vcpu *vcpu);
 #else
 static inline int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
-- 
2.33.1

