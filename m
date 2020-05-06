Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E23F1C75D6
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 18:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730171AbgEFQLF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 12:11:05 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57569 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729447AbgEFQLE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 12:11:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588781462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=HwAIuhbI2U56dX/mN6y7nlnKrt0eeAS4CN/m9FbsZ4U=;
        b=MNir8VKS/4bMH02t67aV4oCq30LpDRCChuXpzYkzfIJ5oGWpLT/4/fvazRS9jquywNGjMl
        u0wyGAnZT0QT9RUdmOnuN76ah52nt36T/+zZAqH8mR75JldF6wzStQv95WCijHMdXyIB5o
        QmrlhnmCMMRNh68IgBXsVenh1o8V9uA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-qzZ-sPAZMDyWNnJRd4TIMw-1; Wed, 06 May 2020 12:10:57 -0400
X-MC-Unique: qzZ-sPAZMDyWNnJRd4TIMw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9259E107ACCA;
        Wed,  6 May 2020 16:10:56 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C90A8165F6;
        Wed,  6 May 2020 16:10:55 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wanpengli@tencent.com, linxl3@wangsu.com,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH 6/7] KVM: X86: TSCDEADLINE MSR emulation fastpath
Date:   Wed,  6 May 2020 12:10:47 -0400
Message-Id: <20200506161048.28840-7-pbonzini@redhat.com>
In-Reply-To: <20200506161048.28840-1-pbonzini@redhat.com>
References: <20200506161048.28840-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

This patch implements a fast path for emulation of writes to the TSCDEADLINE
MSR.  Besides shortcutting various housekeeping tasks in the vCPU loop,
the fast path can also deliver the timer interrupt directly without going
through KVM_REQ_PENDING_TIMER because it runs in vCPU context.

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Message-Id: <1588055009-12677-7-git-send-email-wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/lapic.c | 18 ++++++++++++------
 arch/x86/kvm/x86.c   | 16 ++++++++++++++++
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 73e51abca21d..2a3b57401a68 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1600,7 +1600,7 @@ static void kvm_apic_inject_pending_timer_irqs(struct kvm_lapic *apic)
 	}
 }
 
-static void apic_timer_expired(struct kvm_lapic *apic)
+static void apic_timer_expired(struct kvm_lapic *apic, bool from_timer_fn)
 {
 	struct kvm_vcpu *vcpu = apic->vcpu;
 	struct kvm_timer *ktimer = &apic->lapic_timer;
@@ -1611,6 +1611,12 @@ static void apic_timer_expired(struct kvm_lapic *apic)
 	if (apic_lvtt_tscdeadline(apic) || ktimer->hv_timer_in_use)
 		ktimer->expired_tscdeadline = ktimer->tscdeadline;
 
+	if (!from_timer_fn && vcpu->arch.apicv_active) {
+		WARN_ON(kvm_get_running_vcpu() != vcpu);
+		kvm_apic_inject_pending_timer_irqs(apic);
+		return;
+	}
+
 	if (kvm_use_posted_timer_interrupt(apic->vcpu)) {
 		if (apic->lapic_timer.timer_advance_ns)
 			__kvm_wait_lapic_expire(vcpu);
@@ -1650,7 +1656,7 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
 		expire = ktime_sub_ns(expire, ktimer->timer_advance_ns);
 		hrtimer_start(&ktimer->timer, expire, HRTIMER_MODE_ABS_HARD);
 	} else
-		apic_timer_expired(apic);
+		apic_timer_expired(apic, false);
 
 	local_irq_restore(flags);
 }
@@ -1758,7 +1764,7 @@ static void start_sw_period(struct kvm_lapic *apic)
 
 	if (ktime_after(ktime_get(),
 			apic->lapic_timer.target_expiration)) {
-		apic_timer_expired(apic);
+		apic_timer_expired(apic, false);
 
 		if (apic_lvtt_oneshot(apic))
 			return;
@@ -1820,7 +1826,7 @@ static bool start_hv_timer(struct kvm_lapic *apic)
 		if (atomic_read(&ktimer->pending)) {
 			cancel_hv_timer(apic);
 		} else if (expired) {
-			apic_timer_expired(apic);
+			apic_timer_expired(apic, false);
 			cancel_hv_timer(apic);
 		}
 	}
@@ -1870,7 +1876,7 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu)
 		goto out;
 	WARN_ON(rcuwait_active(&vcpu->wait));
 	cancel_hv_timer(apic);
-	apic_timer_expired(apic);
+	apic_timer_expired(apic, false);
 
 	if (apic_lvtt_period(apic) && apic->lapic_timer.period) {
 		advance_periodic_target_expiration(apic);
@@ -2376,7 +2382,7 @@ static enum hrtimer_restart apic_timer_fn(struct hrtimer *data)
 	struct kvm_timer *ktimer = container_of(data, struct kvm_timer, timer);
 	struct kvm_lapic *apic = container_of(ktimer, struct kvm_lapic, lapic_timer);
 
-	apic_timer_expired(apic);
+	apic_timer_expired(apic, true);
 
 	if (lapic_is_periodic(apic)) {
 		advance_periodic_target_expiration(apic);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 98e5b79063b7..7e46027f405a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1616,6 +1616,15 @@ static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data
 	return 1;
 }
 
+static int handle_fastpath_set_tscdeadline(struct kvm_vcpu *vcpu, u64 data)
+{
+	if (!kvm_can_use_hv_timer(vcpu))
+		return 1;
+
+	kvm_set_lapic_tscdeadline_msr(vcpu, data);
+	return 0;
+}
+
 fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 {
 	u32 msr = kvm_rcx_read(vcpu);
@@ -1630,6 +1639,13 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 			ret = EXIT_FASTPATH_EXIT_HANDLED;
                }
 		break;
+	case MSR_IA32_TSCDEADLINE:
+		data = kvm_read_edx_eax(vcpu);
+		if (!handle_fastpath_set_tscdeadline(vcpu, data)) {
+			kvm_skip_emulated_instruction(vcpu);
+			ret = EXIT_FASTPATH_REENTER_GUEST;
+		}
+		break;
 	default:
 		break;
 	}
-- 
2.18.2


