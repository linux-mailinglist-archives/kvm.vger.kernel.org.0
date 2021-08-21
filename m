Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2B83F3779
	for <lists+kvm@lfdr.de>; Sat, 21 Aug 2021 02:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240401AbhHUAFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 20:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbhHUAFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 20:05:47 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABEEC061575
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 17:05:08 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id 70-20020a370b49000000b003d2f5f0dcc6so7525727qkl.9
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 17:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=kVx73D6XY9WnkgLDCtvUK86oIG4mWyewqtNDbC73fTQ=;
        b=Zy+1ProZTKEaNuzZzlHNClKbKRbOOnG121Gz9zMTryFRrnI32fkox/C/N8jYbFB6AE
         GaO3LEL5nTDFXVIZ4g5mAOxx4uCUfgZuGnDKu8Hnpoo2xd3ryN9zBqNVBaEQxZjVoF0D
         dEU8Ngf/k6Cz5BzMKxNRtzfiB7gun6rltPtIbELZDTQ7MSNUwstnhPkbkyxE3r/DvtW9
         66BqXFOLIwQsTi77nSD0LJRX84pVyOlPW/QiYb4lo5gw+zu1TejKJ7Qv9MyziCsI9xS7
         PS/ktZ4D8xFT1GX3CbEHTgej5eu47wSWtXk+meYgmA3Z6tjVt2TVJg5pN0tg/XHp8NUX
         yHZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=kVx73D6XY9WnkgLDCtvUK86oIG4mWyewqtNDbC73fTQ=;
        b=OpYZ0JXs/X9l2cOtGvxbrNirQplEFUeqhLL5GbM5rrZMpPZtS35hYeCn9ibTBrxZ/9
         l3twv6ltYt3p4/AtkYhBPVZhsk2FqSl6qdoMPWzkGqLF6wsqAZ1wmdCkIDLO4UX7deew
         uQs/DYm6JrsD9zRHIc+hum98QOq2OfwQUbICFoZ/CrDYaqPHxn3ifTau8nITnx/0Kv4i
         5CHtW2mxkfDQ3Q2lbe3bVr/HcxSZGfSkzWko8RI3qjOYeGaN6NwAMZ/hKVitpgETZJ7A
         cfj1RJcgrZlHVj80D2+W0CmcxrYVpZW8QJPRT7BcyUV5joj3BZJMrU9n2H37A4hlPt3x
         FNpA==
X-Gm-Message-State: AOAM532pZJcPIEcOfDnu/Ur4+hWHpM20gScenlQpdbIWzmQYQT8kWRxT
        7Zw25rHLOHObwU0Nmsbvt8w8fWvfoU4=
X-Google-Smtp-Source: ABdhPJxmOIerFGne81KYEW16ywWpeOg2WMmNaPMnb+MM2p2p3SVg3ptHDT4wp2KLszt3yPm/GWtCakcI3Mg=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:f11d:a281:af9b:5de6])
 (user=seanjc job=sendgmr) by 2002:a05:6214:9ce:: with SMTP id
 dp14mr22740210qvb.42.1629504307784; Fri, 20 Aug 2021 17:05:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 20 Aug 2021 17:05:00 -0700
In-Reply-To: <20210821000501.375978-1-seanjc@google.com>
Message-Id: <20210821000501.375978-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210821000501.375978-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH 1/2] KVM: Clean up benign vcpu->cpu data races when kicking vCPUs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Venkatesh Srinivas <venkateshs@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
2.33.0.rc2.250.ged5fa647cd-goog

