Return-Path: <kvm+bounces-42326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A67BEA77F8B
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 17:52:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18940189101D
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 15:51:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D31C211A1E;
	Tue,  1 Apr 2025 15:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XuZXeNoC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F2620F094
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 15:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743522561; cv=none; b=td/j95z9FOQILzTpJZ19r9mz/pYXIlbtJYJ90ssKyZW2uhsyjWH54kpUetxmozVvx9E5jgtmXzTvHRYtkNuxilp9s+0h+aLd5d9lXjK+m1gW5fVm+94VA1LI9AOGnpn3uJkB3lVp5PyuAN+Pwd0uZvMPTet7xyLyAHawMeBr9IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743522561; c=relaxed/simple;
	bh=gLK58HHSD3/s9+5+CMqOiJMgocg0/qBgCo1ULcStcuk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S386EY5hQoHJcp5EoXSjubVjEAJWRBrRlG6VejNNCMJBs13Hwc5gYqN4y74+FnUfOvpEsu9dqPKAYvxm9bdCuZpdOhWItMKwlXiqygyq8ZE5ROz4TEWtf6CSpXl+rpuI1Fw4LqXj62oV1UxkXJTY2zuwzwdm8Qsv4Q7BIkkvckY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XuZXeNoC; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-229170fbe74so85484485ad.2
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 08:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743522557; x=1744127357; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NEoKKraLkus5TSEUW8Vu6zSvk2yZjVwDVKYenBySZQo=;
        b=XuZXeNoCfaTQ9eqeARFWLaTlcWi1Fa5WDJBUDc06FWkCn+KB6/3sxTe8X0Nlq2NYCt
         EdjitEQtkHXzHyEVQMNMxpeuGJojXFddQ+LmmTiZgFZdyaEeoNIJ/A8mZu0Doc8IgXKL
         j4OrJ2iB8pK5kJJNE6HIVKgsaJcU4c2ljwEvsPHCAxsY3zxp5e5IrfkXfGQJp67DrXwD
         jgOXQxGj3KpL4XiS61UC3cAGW+Imbg0MoHrDxRLxiIdhYL6ConXV51UncSKsheIOMtx8
         OU25YjcZ8uK5jF5paGkmlznGjC7g05saOLEAzbXUnjy6eLzPM9Uzft1Ip2H7oEyJ9LQQ
         zmpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743522557; x=1744127357;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NEoKKraLkus5TSEUW8Vu6zSvk2yZjVwDVKYenBySZQo=;
        b=sz/bNHgTgM7kJgWaxq7dbCTAshSOIPuNo81nMrimrQxMtNhPZz0XFANKOLMSv/+uVn
         tJ/2b/Fwpb4W9tS9Di7kfNU4YpFoEtuoP9yuhXJP4+ISrqjbYcsG8MF3kUa/hu+FeoEc
         lO0w0LBZp+e+djMrk7LP85VAL+EvOm2yvYFJdsbrjK0hWTsGhbVdk6JD3Y/G8Kc+Vz/l
         fZqZslcQVK/CIvzEIXP4e7HvoVS9VxfQafn0BYA9jChvHmRyTekAeAdJi7ehmZO6XaIM
         +PeK4A4YRPV2U2XUxxa62GwZ1c2dRwvHA+vdKAq2nbxB0R30qKz1YOxxMajkjkwMvuF1
         +rXw==
X-Gm-Message-State: AOJu0Yxho5kCBNXp3frbhnTBYmhN212m3WA4mplP/kiG5QJU8B8Co1qs
	dVZf8veTOX/Prg57/Bf3o4Ss3yyVfZ1MvdYGKpqGwf/9v2y99rz1r2eoCC7Elk77PndwCInpKNV
	sXQ==
X-Google-Smtp-Source: AGHT+IGbhkLRRFTUQ7bxiQyU2fg0e5+VIELmG5bgHhONmz/4t+jU7czIP6A4Q16LN9DgWQLrpb52LAhd85I=
X-Received: from pfbjw37.prod.google.com ([2002:a05:6a00:92a5:b0:736:6fb6:7fc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ce09:b0:224:10a2:cae1
 with SMTP id d9443c01a7336-2292f9df155mr209876235ad.37.1743522556908; Tue, 01
 Apr 2025 08:49:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 08:47:27 -0700
In-Reply-To: <20250401154727.835231-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401154727.835231-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250401154727.835231-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: VMX: Use separate subclasses for PI wakeup lock to
 squash false positive
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Yan Zhao <yan.y.zhao@intel.com>

Use a separate subclass when acquiring KVM's per-CPU posted interrupts
wakeup lock in the scheduled out path, i.e. when adding a vCPU on the list
of vCPUs to wake, to workaround a false positive deadlock.

  Chain exists of:
   &p->pi_lock --> &rq->__lock --> &per_cpu(wakeup_vcpus_on_cpu_lock, cpu)

  Possible unsafe locking scenario:

        CPU0                CPU1
        ----                ----
   lock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
                            lock(&rq->__lock);
                            lock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
   lock(&p->pi_lock);

  *** DEADLOCK ***

In the wakeup handler, the callchain is *always*:

  sysvec_kvm_posted_intr_wakeup_ipi()
  |
  --> pi_wakeup_handler()
      |
      --> kvm_vcpu_wake_up()
          |
          --> try_to_wake_up(),

and the lock order is:

  &per_cpu(wakeup_vcpus_on_cpu_lock, cpu) --> &p->pi_lock.

For the schedule out path, the callchain is always (for all intents and
purposes; if the kernel is preemptible, kvm_sched_out() can be called from
something other than schedule(), but the beginning of the callchain will
be the same point in vcpu_block()):

  vcpu_block()
  |
  --> schedule()
      |
      --> kvm_sched_out()
          |
          --> vmx_vcpu_put()
              |
              --> vmx_vcpu_pi_put()
                  |
                  --> pi_enable_wakeup_handler()

and the lock order is:

  &rq->__lock --> &per_cpu(wakeup_vcpus_on_cpu_lock, cpu)

I.e. lockdep sees AB+BC ordering for schedule out, and CA ordering for
wakeup, and complains about the A=>C versus C=>A inversion.  In practice,
deadlock can't occur between schedule out and the wakeup handler as they
are mutually exclusive.  The entirely of the schedule out code that runs
with the problematic scheduler locks held, does so with IRQs disabled,
i.e. can't run concurrently with the wakeup handler.

Use a subclass instead disabling lockdep entirely, and tell lockdep that
both subclasses are being acquired when loading a vCPU, as the sched_out
and sched_in paths are NOT mutually exclusive, e.g.

      CPU 0                 CPU 1
  ---------------     ---------------
  vCPU0 sched_out
  vCPU1 sched_in
  vCPU1 sched_out      vCPU 0 sched_in

where vCPU0's sched_in may race with vCPU1's sched_out, on CPU 0's wakeup
list+lock.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 840d435229a8..51116fe69a50 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -31,6 +31,8 @@ static DEFINE_PER_CPU(struct list_head, wakeup_vcpus_on_cpu);
  */
 static DEFINE_PER_CPU(raw_spinlock_t, wakeup_vcpus_on_cpu_lock);
 
+#define PI_LOCK_SCHED_OUT SINGLE_DEPTH_NESTING
+
 static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 {
 	return &(to_vmx(vcpu)->pi_desc);
@@ -89,9 +91,20 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 	 * current pCPU if the task was migrated.
 	 */
 	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR) {
-		raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
+		raw_spinlock_t *spinlock = &per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu);
+
+		/*
+		 * In addition to taking the wakeup lock for the regular/IRQ
+		 * context, tell lockdep it is being taken for the "sched out"
+		 * context as well.  vCPU loads happens in task context, and
+		 * this is taking the lock of the *previous* CPU, i.e. can race
+		 * with both the scheduler and the wakeup handler.
+		 */
+		raw_spin_lock(spinlock);
+		spin_acquire(&spinlock->dep_map, PI_LOCK_SCHED_OUT, 0, _RET_IP_);
 		list_del(&vmx->pi_wakeup_list);
-		raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
+		spin_release(&spinlock->dep_map, _RET_IP_);
+		raw_spin_unlock(spinlock);
 	}
 
 	dest = cpu_physical_id(cpu);
@@ -151,7 +164,20 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
 
 	lockdep_assert_irqs_disabled();
 
-	raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
+	/*
+	 * Acquire the wakeup lock using the "sched out" context to workaround
+	 * a lockdep false positive.  When this is called, schedule() holds
+	 * various per-CPU scheduler locks.  When the wakeup handler runs, it
+	 * holds this CPU's wakeup lock while calling try_to_wake_up(), which
+	 * can eventually take the aforementioned scheduler locks, which causes
+	 * lockdep to assume there is deadlock.
+	 *
+	 * Deadlock can't actually occur because IRQs are disabled for the
+	 * entirety of the sched_out critical section, i.e. the wakeup handler
+	 * can't run while the scheduler locks are held.
+	 */
+	raw_spin_lock_nested(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu),
+			     PI_LOCK_SCHED_OUT);
 	list_add_tail(&vmx->pi_wakeup_list,
 		      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
 	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
-- 
2.49.0.472.ge94155a9ec-goog


