Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505081C75E2
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 18:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbgEFQLA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 12:11:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45455 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729486AbgEFQLA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 12:11:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588781458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=tE0RNlfkVSsFXv1Adm2aK1m5ERlZRj3B9rN5o9lTDaY=;
        b=WxOZ2YOXNCwHLK2YQgATy1dGS0qMIhAA8WxKZ3YbpUzu5U0nnjhp8giQqDqc2qgohw8gsG
        IE7nVEagnQvNfk8rjHDXlNhzaC68LDpT6Bb/RXw4dMfOfTK624TUh4trSCJRvBQW4L/WNm
        E+4+QdYoA8JMkyUbRPg5c6cJ+DjhXQA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-oVQHjmX5MeKBCoGRE3q3ag-1; Wed, 06 May 2020 12:10:56 -0400
X-MC-Unique: oVQHjmX5MeKBCoGRE3q3ag-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9965F80058A;
        Wed,  6 May 2020 16:10:55 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9BBC27CC3;
        Wed,  6 May 2020 16:10:54 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wanpengli@tencent.com, linxl3@wangsu.com
Subject: [PATCH 5/7] KVM: x86: introduce kvm_can_use_hv_timer
Date:   Wed,  6 May 2020 12:10:46 -0400
Message-Id: <20200506161048.28840-6-pbonzini@redhat.com>
In-Reply-To: <20200506161048.28840-1-pbonzini@redhat.com>
References: <20200506161048.28840-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace the ad hoc test in vmx_set_hv_timer with a test in the caller,
start_hv_timer.  This test is not Intel-specific and would be duplicated
when introducing the fast path for the TSC deadline MSR.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/lapic.c   | 13 ++++++++++---
 arch/x86/kvm/lapic.h   |  2 +-
 arch/x86/kvm/vmx/vmx.c |  4 ----
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 42cd2e3ec6fd..73e51abca21d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -110,11 +110,18 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
 	return apic->vcpu->vcpu_id;
 }
 
-bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
+static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
 {
 	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_can_post_timer_interrupt);
+
+bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
+{
+	return kvm_x86_ops.set_hv_timer
+	       && !(kvm_mwait_in_guest(vcpu->kvm) ||
+		    kvm_can_post_timer_interrupt(vcpu));
+}
+EXPORT_SYMBOL_GPL(kvm_can_use_hv_timer);
 
 static bool kvm_use_posted_timer_interrupt(struct kvm_vcpu *vcpu)
 {
@@ -1788,7 +1795,7 @@ static bool start_hv_timer(struct kvm_lapic *apic)
 	bool expired;
 
 	WARN_ON(preemptible());
-	if (!kvm_x86_ops.set_hv_timer)
+	if (!kvm_can_use_hv_timer(vcpu))
 		return false;
 
 	if (!ktimer->tscdeadline)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 7f15f9e69efe..754f29beb83e 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -250,7 +250,7 @@ void kvm_lapic_switch_to_hv_timer(struct kvm_vcpu *vcpu);
 void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu);
 bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu);
 void kvm_lapic_restart_hv_timer(struct kvm_vcpu *vcpu);
-bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu);
+bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu);
 
 static inline enum lapic_mode kvm_apic_mode(u64 apic_base)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b980481436e9..60065e01f1cd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7395,10 +7395,6 @@ static int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 	u64 tscl, guest_tscl, delta_tsc, lapic_timer_advance_cycles;
 	struct kvm_timer *ktimer = &vcpu->arch.apic->lapic_timer;
 
-	if (kvm_mwait_in_guest(vcpu->kvm) ||
-		kvm_can_post_timer_interrupt(vcpu))
-		return -EOPNOTSUPP;
-
 	vmx = to_vmx(vcpu);
 	tscl = rdtsc();
 	guest_tscl = kvm_read_l1_tsc(vcpu, tscl);
-- 
2.18.2


