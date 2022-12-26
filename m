Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A545265625D
	for <lists+kvm@lfdr.de>; Mon, 26 Dec 2022 13:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbiLZMDe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Dec 2022 07:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbiLZMDb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Dec 2022 07:03:31 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA5125FA
        for <kvm@vger.kernel.org>; Mon, 26 Dec 2022 04:03:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=V53mltH2dGJOTOyxyQJQeAiWpVl48aHbd5cpAjJB6RA=; b=F/J79VoJknq6u9kXYaBULCWqvr
        lE7kcuJibD8KrxzgsEbLgZ1xmRT1OxyWzGkf+A8y/EX9M7pWOmLzTkugLWhY1Klk67+WsDY2UPjhq
        Wo7xkiCSgUwru9fN/XNzkRu9ixaskUHsp03wWIbSAsElB2MM+7D3BvID7OhKpU81zjMIPZg+ox7x3
        SIDKjW5pxBhVNnQHAp3QSIahW7ykJvkS7fCIYNOfy8F/Mwq5BXED2zwV6j0AYUoAsH7ivdh40Vz62
        dDbV67p+R7N4r7BrK4uvCDYYvR1LGFFTill9qZRzm6jKLaFqnqLgdGyXB3PTLvnxNcyGMZzcQ9lHJ
        TixmtKVA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p9mCZ-006e9q-OY; Mon, 26 Dec 2022 12:03:32 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p9mCO-004ilm-Ok; Mon, 26 Dec 2022 12:03:20 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Michal Luczaj <mhal@rbox.co>,
        Sean Christopherson <seanjc@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>, kvm@vger.kernel.org,
        Paul Durrant <paul@xen.org>
Subject: [PATCH 2/6] KVM: x86/xen: Use kvm_read_guest_virt() instead of open-coding it badly
Date:   Mon, 26 Dec 2022 12:03:16 +0000
Message-Id: <20221226120320.1125390-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221226120320.1125390-1-dwmw2@infradead.org>
References: <b36fa02bc338d6892e63e37768bf47f035339e30.camel@infradead.org>
 <20221226120320.1125390-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

In particular, we shouldn't assume that being contiguous in guest virtual
address space means being contiguous in guest *physical* address space.

In dropping the manual calls to kvm_mmu_gva_to_gpa_system(), also drop
the srcu_read_lock() that was around them. All call sites are reached
from kvm_xen_hypercall() which is called from the handle_exit function
with the read lock already held.

Fixes: 2fd6df2f2 ("KVM: x86/xen: intercept EVTCHNOP_send from guests")
       536395260 ("KVM: x86/xen: handle PV timers oneshot mode")
       1a65105a5 ("KVM: x86/xen: handle PV spinlocks slowpath")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/xen.c | 56 +++++++++++++++-------------------------------
 1 file changed, 18 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index d1a98d834d18..929b887eafd7 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1184,30 +1184,22 @@ static bool wait_pending_event(struct kvm_vcpu *vcpu, int nr_ports,
 static bool kvm_xen_schedop_poll(struct kvm_vcpu *vcpu, bool longmode,
 				 u64 param, u64 *r)
 {
-	int idx, i;
 	struct sched_poll sched_poll;
 	evtchn_port_t port, *ports;
-	gpa_t gpa;
+	struct x86_exception e;
+	int i;
 
 	if (!lapic_in_kernel(vcpu) ||
 	    !(vcpu->kvm->arch.xen_hvm_config.flags & KVM_XEN_HVM_CONFIG_EVTCHN_SEND))
 		return false;
 
-	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	gpa = kvm_mmu_gva_to_gpa_system(vcpu, param, NULL);
-	srcu_read_unlock(&vcpu->kvm->srcu, idx);
-	if (!gpa) {
-		*r = -EFAULT;
-		return true;
-	}
-
 	if (IS_ENABLED(CONFIG_64BIT) && !longmode) {
 		struct compat_sched_poll sp32;
 
 		/* Sanity check that the compat struct definition is correct */
 		BUILD_BUG_ON(sizeof(sp32) != 16);
 
-		if (kvm_vcpu_read_guest(vcpu, gpa, &sp32, sizeof(sp32))) {
+		if (kvm_read_guest_virt(vcpu, param, &sp32, sizeof(sp32), &e)) {
 			*r = -EFAULT;
 			return true;
 		}
@@ -1221,8 +1213,8 @@ static bool kvm_xen_schedop_poll(struct kvm_vcpu *vcpu, bool longmode,
 		sched_poll.nr_ports = sp32.nr_ports;
 		sched_poll.timeout = sp32.timeout;
 	} else {
-		if (kvm_vcpu_read_guest(vcpu, gpa, &sched_poll,
-					sizeof(sched_poll))) {
+		if (kvm_read_guest_virt(vcpu, param, &sched_poll,
+					sizeof(sched_poll), &e)) {
 			*r = -EFAULT;
 			return true;
 		}
@@ -1244,18 +1236,13 @@ static bool kvm_xen_schedop_poll(struct kvm_vcpu *vcpu, bool longmode,
 	} else
 		ports = &port;
 
+	if (kvm_read_guest_virt(vcpu, (gva_t)sched_poll.ports, ports,
+				sched_poll.nr_ports * sizeof(*ports), &e)) {
+		*r = -EFAULT;
+		return true;
+	}
+
 	for (i = 0; i < sched_poll.nr_ports; i++) {
-		idx = srcu_read_lock(&vcpu->kvm->srcu);
-		gpa = kvm_mmu_gva_to_gpa_system(vcpu,
-						(gva_t)(sched_poll.ports + i),
-						NULL);
-		srcu_read_unlock(&vcpu->kvm->srcu, idx);
-
-		if (!gpa || kvm_vcpu_read_guest(vcpu, gpa,
-						&ports[i], sizeof(port))) {
-			*r = -EFAULT;
-			goto out;
-		}
 		if (ports[i] >= max_evtchn_port(vcpu->kvm)) {
 			*r = -EINVAL;
 			goto out;
@@ -1331,9 +1318,8 @@ static bool kvm_xen_hcall_vcpu_op(struct kvm_vcpu *vcpu, bool longmode, int cmd,
 				  int vcpu_id, u64 param, u64 *r)
 {
 	struct vcpu_set_singleshot_timer oneshot;
+	struct x86_exception e;
 	s64 delta;
-	gpa_t gpa;
-	int idx;
 
 	if (!kvm_xen_timer_enabled(vcpu))
 		return false;
@@ -1344,9 +1330,6 @@ static bool kvm_xen_hcall_vcpu_op(struct kvm_vcpu *vcpu, bool longmode, int cmd,
 			*r = -EINVAL;
 			return true;
 		}
-		idx = srcu_read_lock(&vcpu->kvm->srcu);
-		gpa = kvm_mmu_gva_to_gpa_system(vcpu, param, NULL);
-		srcu_read_unlock(&vcpu->kvm->srcu, idx);
 
 		/*
 		 * The only difference for 32-bit compat is the 4 bytes of
@@ -1364,9 +1347,8 @@ static bool kvm_xen_hcall_vcpu_op(struct kvm_vcpu *vcpu, bool longmode, int cmd,
 		BUILD_BUG_ON(sizeof_field(struct compat_vcpu_set_singleshot_timer, flags) !=
 			     sizeof_field(struct vcpu_set_singleshot_timer, flags));
 
-		if (!gpa ||
-		    kvm_vcpu_read_guest(vcpu, gpa, &oneshot, longmode ? sizeof(oneshot) :
-					sizeof(struct compat_vcpu_set_singleshot_timer))) {
+		if (kvm_read_guest_virt(vcpu, param, &oneshot, longmode ? sizeof(oneshot) :
+					sizeof(struct compat_vcpu_set_singleshot_timer), &e)) {
 			*r = -EFAULT;
 			return true;
 		}
@@ -2003,14 +1985,12 @@ static bool kvm_xen_hcall_evtchn_send(struct kvm_vcpu *vcpu, u64 param, u64 *r)
 {
 	struct evtchnfd *evtchnfd;
 	struct evtchn_send send;
-	gpa_t gpa;
-	int idx;
+	struct x86_exception e;
 
-	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	gpa = kvm_mmu_gva_to_gpa_system(vcpu, param, NULL);
-	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	/* Sanity check: this structure is the same for 32-bit and 64-bit */
+	BUILD_BUG_ON(sizeof(send) != 4);
 
-	if (!gpa || kvm_vcpu_read_guest(vcpu, gpa, &send, sizeof(send))) {
+	if (kvm_read_guest_virt(vcpu, param, &send, sizeof(send), &e)) {
 		*r = -EFAULT;
 		return true;
 	}
-- 
2.35.3

