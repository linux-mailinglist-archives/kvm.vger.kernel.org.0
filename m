Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E183F4C62
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 16:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhHWOcb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 10:32:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27226 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230225AbhHWOc3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 10:32:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629729106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IYFUg3KjJacWl8OLaf6vH1G2cmWUV+wxHB9g+ejqdCs=;
        b=azXVdd4F3tJNwWUmfIC7vPCUtrF+1E6PZKGPC9S76KPWsAcGl1X+kNEG+bMDB1+zMEjw7H
        WYToCoxKFjiQuuUVZoUtS+twNOadbuvLnkNvKhSbMwL9iJKcS5HUa2Xbigirz2ZaQJr7ue
        bfzSpqllGWDJOkomMapnKZ2F4DxcBc0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-hRW3pwkzMmGFHNHC6pAsnA-1; Mon, 23 Aug 2021 10:30:41 -0400
X-MC-Unique: hRW3pwkzMmGFHNHC6pAsnA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4AD81026200;
        Mon, 23 Aug 2021 14:30:39 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D2D5727091;
        Mon, 23 Aug 2021 14:30:37 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] KVM: Clean up benign vcpu->cpu data races when kicking vCPUs
Date:   Mon, 23 Aug 2021 16:30:25 +0200
Message-Id: <20210823143028.649818-2-vkuznets@redhat.com>
In-Reply-To: <20210823143028.649818-1-vkuznets@redhat.com>
References: <20210823143028.649818-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Fix a benign data race reported by syzbot+KCSAN[*] by ensuring vcpu->cpu
is read exactly once, and by ensuring the vCPU is booted from guest mode
if kvm_arch_vcpu_should_kick() returns true.  Fix a similar race in
kvm_make_vcpus_request_mask() by ensuring the vCPU is interrupted if
kvm_request_needs_ipi() returns true.

Reading vcpu->cpu before vcpu->mode (via kvm_arch_vcpu_should_kick() or
kvm_request_needs_ipi()) means the target vCPU could get migrated (change
vcpu->cpu) and enter !OUTSIDE_GUEST_MODE between reading vcpu->cpud and
reading vcpu->mode.  If that happens, the kick/IPI will be sent to the
old pCPU, not the new pCPU that is now running the vCPU or reading SPTEs.

Although failing to kick the vCPU is not exactly ideal, practically
speaking it cannot cause a functional issue unless there is also a bug in
the caller, and any such bug would exist regardless of kvm_vcpu_kick()'s
behavior.

The purpose of sending an IPI is purely to get a vCPU into the host (or
out of reading SPTEs) so that the vCPU can recognize a change in state,
e.g. a KVM_REQ_* request.  If vCPU's handling of the state change is
required for correctness, KVM must ensure either the vCPU sees the change
before entering the guest, or that the sender sees the vCPU as running in
guest mode.  All architectures handle this by (a) sending the request
before calling kvm_vcpu_kick() and (b) checking for requests _after_
setting vcpu->mode.

x86's READING_SHADOW_PAGE_TABLES has similar requirements; KVM needs to
ensure it kicks and waits for vCPUs that started reading SPTEs _before_
MMU changes were finalized, but any vCPU that starts reading after MMU
changes were finalized will see the new state and can continue on
uninterrupted.

For uses of kvm_vcpu_kick() that are not paired with a KVM_REQ_*, e.g.
x86's kvm_arch_sync_dirty_log(), the order of the kick must not be relied
upon for functional correctness, e.g. in the dirty log case, userspace
cannot assume it has a 100% complete log if vCPUs are still running.

All that said, eliminate the benign race since the cost of doing so is an
"extra" atomic cmpxchg() in the case where the target vCPU is loaded by
the current pCPU or is not loaded at all.  I.e. the kick will be skipped
due to kvm_vcpu_exiting_guest_mode() seeing a compatible vcpu->mode as
opposed to the kick being skipped because of the cpu checks.

Keep the "cpu != me" checks even though they appear useless/impossible at
first glance.  x86 processes guest IPI writes in a fast path that runs in
IN_GUEST_MODE, i.e. can call kvm_vcpu_kick() from IN_GUEST_MODE.  And
calling kvm_vm_bugged()->kvm_make_vcpus_request_mask() from IN_GUEST or
READING_SHADOW_PAGE_TABLES is perfectly reasonable.

Note, a race with the cpu_online() check in kvm_vcpu_kick() likely
persists, e.g. the vCPU could exit guest mode and get offlined between
the cpu_online() check and the sending of smp_send_reschedule().  But,
the online check appears to exist only to avoid a WARN in x86's
native_smp_send_reschedule() that fires if the target CPU is not online.
The reschedule WARN exists because CPU offlining takes the CPU out of the
scheduling pool, i.e. the WARN is intended to detect the case where the
kernel attempts to schedule a task on an offline CPU.  The actual sending
of the IPI is a non-issue as at worst it will simpy be dropped on the
floor.  In other words, KVM's usurping of the reschedule IPI could
theoretically trigger a WARN if the stars align, but there will be no
loss of functionality.

[*] https://syzkaller.appspot.com/bug?extid=cd4154e502f43f10808a

Cc: Venkatesh Srinivas <venkateshs@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Fixes: 97222cc83163 ("KVM: Emulate local APIC in kernel")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 virt/kvm/kvm_main.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3e67c93ca403..786b914db98f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -273,14 +273,26 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 			continue;
 
 		kvm_make_request(req, vcpu);
-		cpu = vcpu->cpu;
 
 		if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
 			continue;
 
-		if (tmp != NULL && cpu != -1 && cpu != me &&
-		    kvm_request_needs_ipi(vcpu, req))
-			__cpumask_set_cpu(cpu, tmp);
+		/*
+		 * Note, the vCPU could get migrated to a different pCPU at any
+		 * point after kvm_request_needs_ipi(), which could result in
+		 * sending an IPI to the previous pCPU.  But, that's ok because
+		 * the purpose of the IPI is to ensure the vCPU returns to
+		 * OUTSIDE_GUEST_MODE, which is satisfied if the vCPU migrates.
+		 * Entering READING_SHADOW_PAGE_TABLES after this point is also
+		 * ok, as the requirement is only that KVM wait for vCPUs that
+		 * were reading SPTEs _before_ any changes were finalized.  See
+		 * kvm_vcpu_kick() for more details on handling requests.
+		 */
+		if (tmp != NULL && kvm_request_needs_ipi(vcpu, req)) {
+			cpu = READ_ONCE(vcpu->cpu);
+			if (cpu != -1 && cpu != me)
+				__cpumask_set_cpu(cpu, tmp);
+		}
 	}
 
 	called = kvm_kick_many_cpus(tmp, !!(req & KVM_REQUEST_WAIT));
@@ -3309,16 +3321,24 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_wake_up);
  */
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 {
-	int me;
-	int cpu = vcpu->cpu;
+	int me, cpu;
 
 	if (kvm_vcpu_wake_up(vcpu))
 		return;
 
+	/*
+	 * Note, the vCPU could get migrated to a different pCPU at any point
+	 * after kvm_arch_vcpu_should_kick(), which could result in sending an
+	 * IPI to the previous pCPU.  But, that's ok because the purpose of the
+	 * IPI is to force the vCPU to leave IN_GUEST_MODE, and migrating the
+	 * vCPU also requires it to leave IN_GUEST_MODE.
+	 */
 	me = get_cpu();
-	if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
-		if (kvm_arch_vcpu_should_kick(vcpu))
+	if (kvm_arch_vcpu_should_kick(vcpu)) {
+		cpu = READ_ONCE(vcpu->cpu);
+		if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
 			smp_send_reschedule(cpu);
+	}
 	put_cpu();
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_kick);
-- 
2.31.1

