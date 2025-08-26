Return-Path: <kvm+bounces-55713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 49FCEB3505D
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 02:40:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB98424260C
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 00:40:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91180279DB1;
	Tue, 26 Aug 2025 00:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IsG7c+AB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C525625F98A
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 00:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756168818; cv=none; b=HO+37ucN+tK/sOZyFqdt26F/Qt7SNbLEmG0sWYU6/EjjI9iUbU48oqrOEz9eG6YHooVxU0XbImlbhjObKAniUWn+56fVWv57iAmt5+3D9OWWnt05wBw+/XiratBhlajXANXydu5mRdil/037JnSXgHL+0pO69Ap6nmrPL9+rjZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756168818; c=relaxed/simple;
	bh=mkdifJuocRaPeE9/s8dJMI63LfJbJ5RNcEoZFWM/YBw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Zvg1uPHGyZevGlasIbTzYEIJ1IodCxA//UmLorrg9WDresWTqXxZkAgJzo7ZA4ClkAYkbWT0JO3ITUUdGuK5YRuCZc3QT2vmyteKdbRzBwHIW1oNHCm89u7VZZQTKHHrR68UsfuKi4BqKZ/EGht54mTOc/nlsYcVgoTJ8z+YD30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IsG7c+AB; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-325ce108e16so1712461a91.1
        for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 17:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756168816; x=1756773616; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=I6OP+E9wowSd53dNHDSrZPahIGECBB8CqlNw/C87dc0=;
        b=IsG7c+ABcijBf4P4L/dvXKkAiu8kv0GwNarRaAsw09h6hZt4+YPZkwae/TtOXAwtk5
         Fuv3kPTmJaAKz2pK18iXDk1lPq05zQJzh+nbHQaIJDaDwpIeeYE+utkn/7VcQH4oZVac
         MMVM3lUc6JPt3p7w9pW+M8e1JszO3TNDbm/6ZNEx2m+MhzojnOM6P8lyhi+5OGyPK1ir
         5Ked3xffcgTbKAMCLeswczWx7Y9txipEr74ZdC0FqJ8dMURvgNgTpBZzKjS/SWcKtxpt
         ZgHICWHD4I9pgdTJP86uOAJrqhVBfkW+7sTPdgp7J9d0/Ec27ekg8UrDPTskpOgpyvzI
         Tkrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756168816; x=1756773616;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I6OP+E9wowSd53dNHDSrZPahIGECBB8CqlNw/C87dc0=;
        b=GS+uj/Y9eUrYfmpPrzF4EVraSe2yHSRuHnnfqbj7sgZtpQjy8exp24cUbONbCzisu7
         PJ1YyHt54VXidlqUpkPl+GFYd4FYNX7T6Oi+w5f/2e9oCM0sEmIomg1b5R+B5icZ7Xfc
         7jv1iRLpMZ8DWh0PS7amHF5vKAlW2PhZXA3FkUPcUPR6c8pSSUIUvvoBIWHwrqIgm3ii
         F/ElywkBPX9DDqf6kwpPvwSGfLL67xsirWQ2vl8wOhVQKYTEhYtcf4gW2iA1zMdKDnOq
         8d638q0zuQN5ztm1qBsurAHCMZXAO2qMkTc8jFLUgrak67q7Ovy944qlnEH2L7S9FSJf
         g36w==
X-Gm-Message-State: AOJu0YxcXEI7srIfdXft0rOfJ695JRoP0j3ei0r4SrKtpBaRfz5yRwFP
	i/bHae3XvJnOpC1q/2vWkbZRSvjI1KkuX9+nu4wSgxtp5UI/YhHr0aNbd3QRm1JA+oHbENpRUhQ
	nmJXsyQ==
X-Google-Smtp-Source: AGHT+IHfyEsrfv35hPjuJ4cCkQ67whYQiOrrNcLejtWiTZWgV3y9MtXTxxAf+GtFvnSoCWEA5haSZ544u4g=
X-Received: from pjbqo12.prod.google.com ([2002:a17:90b:3dcc:b0:325:9f85:b74])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2ccd:b0:312:e731:5a66
 with SMTP id 98e67ed59e1d1-32515ee159bmr16515015a91.3.1756168816120; Mon, 25
 Aug 2025 17:40:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 25 Aug 2025 17:40:09 -0700
In-Reply-To: <20250826004012.3835150-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250826004012.3835150-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250826004012.3835150-2-seanjc@google.com>
Subject: [PATCH 1/3] vhost_task: KVM: Don't wake KVM x86's recovery thread if
 vhost task was killed
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

Add a vhost_task_wake_safe() variant to handle the case where a vhost task
has exited due to a signal, i.e. before being explicitly stopped by the
owner of the task, and use the "safe" API in KVM when waking NX hugepage
recovery tasks.  This fixes a bug where KVM will attempt to wake a task
that has exited, which ultimately results in all manner of badness, e.g.

  Oops: general protection fault, probably for non-canonical address 0xff0e899fa1566052: 0000 [#1] SMP
  CPU: 51 UID: 0 PID: 53807 Comm: tee Tainted: G S         O        6.17.0-smp--38183c31756a-next #826 NONE
  Tainted: [S]=CPU_OUT_OF_SPEC, [O]=OOT_MODULE
  Hardware name: Google LLC Indus/Indus_QC_03, BIOS 30.110.0 09/13/2024
  RIP: 0010:queued_spin_lock_slowpath+0x123/0x250
  Code: ... <48> 89 8c 02 c0 da 47 a2 83 79 08 00 75 08 f3 90 83 79 08 00 74 f8
  RSP: 0018:ffffbf55cffe7cf8 EFLAGS: 00010006
  RAX: ff0e899fff0e8562 RBX: 0000000000d00000 RCX: ffffa39b40aefac0
  RDX: 0000000000000030 RSI: fffffffffffffff8 RDI: ffffa39d0592e68c
  RBP: 0000000000d00000 R08: 00000000ffffff80 R09: 0000000400000000
  R10: ffffa36cce4fe401 R11: 0000000000000800 R12: 0000000000000003
  R13: 0000000000000000 R14: ffffa39d0592e68c R15: ffffa39b9e672000
  FS:  00007f233b2e9740(0000) GS:ffffa39b9e672000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f233b39fda0 CR3: 00000004d031f002 CR4: 00000000007726f0
  PKRU: 55555554
  Call Trace:
   <TASK>
   _raw_spin_lock_irqsave+0x50/0x60
   try_to_wake_up+0x4f/0x5d0
   set_nx_huge_pages+0xe4/0x1c0 [kvm]
   param_attr_store+0x89/0xf0
   module_attr_store+0x1e/0x30
   kernfs_fop_write_iter+0xe4/0x160
   vfs_write+0x2cb/0x420
   ksys_write+0x7f/0xf0
   do_syscall_64+0x6f/0x1f0
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
  RIP: 0033:0x7f233b4178b3
  R13: 0000000000000002 R14: 00000000226ff3d0 R15: 0000000000000002
   </TASK>

Provide an API in vhost task instead of forcing KVM to solve the problem,
as KVM would literally just add an equivalent to VHOST_TASK_FLAGS_KILLED,
along with a new lock to protect said flag.  In general, forcing simple
usage of vhost task to care about signals _and_ take non-trivial action to
do the right thing isn't developer friendly, and is likely to lead to
similar bugs in the future.

Debugged-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lore.kernel.org/all/aKkLEtoDXKxAAWju@google.com
Link: https://lore.kernel.org/all/aJ_vEP2EHj6l0xRT@google.com
Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Fixes: d96c77bd4eeb ("KVM: x86: switch hugepage recovery thread to vhost_task")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c           |  2 +-
 include/linux/sched/vhost_task.h |  1 +
 kernel/vhost_task.c              | 42 +++++++++++++++++++++++++++++---
 3 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6e838cb6c9e1..d11730467fd4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7376,7 +7376,7 @@ static void kvm_wake_nx_recovery_thread(struct kvm *kvm)
 	struct vhost_task *nx_thread = READ_ONCE(kvm->arch.nx_huge_page_recovery_thread);
 
 	if (nx_thread)
-		vhost_task_wake(nx_thread);
+		vhost_task_wake_safe(nx_thread);
 }
 
 static int get_nx_huge_pages(char *buffer, const struct kernel_param *kp)
diff --git a/include/linux/sched/vhost_task.h b/include/linux/sched/vhost_task.h
index 25446c5d3508..5d5c187088f7 100644
--- a/include/linux/sched/vhost_task.h
+++ b/include/linux/sched/vhost_task.h
@@ -10,5 +10,6 @@ struct vhost_task *vhost_task_create(bool (*fn)(void *),
 void vhost_task_start(struct vhost_task *vtsk);
 void vhost_task_stop(struct vhost_task *vtsk);
 void vhost_task_wake(struct vhost_task *vtsk);
+void vhost_task_wake_safe(struct vhost_task *vtsk);
 
 #endif /* _LINUX_SCHED_VHOST_TASK_H */
diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
index bc738fa90c1d..5aa8ddf88d01 100644
--- a/kernel/vhost_task.c
+++ b/kernel/vhost_task.c
@@ -67,18 +67,54 @@ static int vhost_task_fn(void *data)
 	do_exit(0);
 }
 
+static void __vhost_task_wake(struct vhost_task *vtsk)
+{
+	wake_up_process(vtsk->task);
+}
+
 /**
  * vhost_task_wake - wakeup the vhost_task
  * @vtsk: vhost_task to wake
  *
- * wake up the vhost_task worker thread
+ * Wake up the vhost_task worker thread.  The caller is responsible for ensuring
+ * that the task hasn't exited.
  */
 void vhost_task_wake(struct vhost_task *vtsk)
 {
-	wake_up_process(vtsk->task);
+	/*
+	 * Checking VHOST_TASK_FLAGS_KILLED can race with signal delivery, but
+	 * a race can only result in false negatives and this is just a sanity
+	 * check, i.e. if KILLED is set, the caller is buggy no matter what.
+	 */
+	if (WARN_ON_ONCE(test_bit(VHOST_TASK_FLAGS_KILLED, &vtsk->flags)))
+		return;
+
+	__vhost_task_wake(vtsk);
 }
 EXPORT_SYMBOL_GPL(vhost_task_wake);
 
+/**
+ * vhost_task_wake_safe - wakeup the vhost_task if it hasn't been killed
+ * @vtsk: vhost_task to wake
+ *
+ * Wake up the vhost_task worker thread if the task hasn't exited, e.g. due to
+ * a signal.
+ */
+void vhost_task_wake_safe(struct vhost_task *vtsk)
+{
+	guard(mutex)(&vtsk->exit_mutex);
+
+	/* Attempting to wake a task that has been explicitly stopped is a bug. */
+	if (WARN_ON_ONCE(test_bit(VHOST_TASK_FLAGS_STOP, &vtsk->flags)))
+		return;
+
+	if (test_bit(VHOST_TASK_FLAGS_KILLED, &vtsk->flags))
+		return;
+
+	__vhost_task_wake(vtsk);
+}
+EXPORT_SYMBOL_GPL(vhost_task_wake_safe);
+
 /**
  * vhost_task_stop - stop a vhost_task
  * @vtsk: vhost_task to stop
@@ -91,7 +127,7 @@ void vhost_task_stop(struct vhost_task *vtsk)
 	mutex_lock(&vtsk->exit_mutex);
 	if (!test_bit(VHOST_TASK_FLAGS_KILLED, &vtsk->flags)) {
 		set_bit(VHOST_TASK_FLAGS_STOP, &vtsk->flags);
-		vhost_task_wake(vtsk);
+		__vhost_task_wake(vtsk);
 	}
 	mutex_unlock(&vtsk->exit_mutex);
 
-- 
2.51.0.261.g7ce5a0a67e-goog


