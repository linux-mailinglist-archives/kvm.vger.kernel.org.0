Return-Path: <kvm+bounces-55930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A128B38A61
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 21:42:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE80D2049AA
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 19:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A4982F7454;
	Wed, 27 Aug 2025 19:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eb0rfVyd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8136F2F1FD9
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 19:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756323681; cv=none; b=u0GzBHFIEsxa8Bdxdf5BNmx/P9quHg8TIUJB9R3MxJ68zqSKLGW9QM5p6VtwTzoQeK6Z+JKSsRYlxHdmrdG+Efyvflim88WiFYNcP5E1uNeEgUYP42Gd9bCd+NfXyWY+ZFz8SqVQRyfdMoZh+4K3US6oowWBFHkmHhMi1zFMkXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756323681; c=relaxed/simple;
	bh=i9u6IqjMGsxbK/CQQwKcRmXhfoxNpA8OWg2LJqEDcRY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tfl8KNNvwbaSEBcqxs5yMaC2CfQXZX5p/qpYykWG7y//Uun0uqvsrg+R0oO8NP6MgYaZiWVj+xeuZUJkm0VkKBcvAI6U1QIx0SvdZ2lbWXkW0nEka7kYncFuTgp8a7E142QQ9JTLfP4ACv9Dnq8kb5MEse+f6n34GlXR7ideWtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eb0rfVyd; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3259ff53c2eso281281a91.1
        for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 12:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756323679; x=1756928479; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=V+WPD9e8xwvSU5bLer99fOwZ4SmYjxSoVKZ9uP/XO4g=;
        b=eb0rfVydbR+Y4UhiOsP8iRH3YXT+2Tq4IcZ/H9o2vaomVUqRwjCh8YktB9NI8vh9I1
         qYrXGREZ2nwblDfxij8BW3jOgaEF6e9+Z4qP8Kk0yAiRUOHFTNnH36e6m4RAVw1aze/P
         ATu8yspO8sCTBzE9fceOY4xzDmZ66OxFoGv9gQ/a7kwA05ws6foEjaYVCqV6KsX5NyRA
         k6lP+rl+tQZuFdWRqy0GLmM9xnR50QcXbQz4HQ4fu1Kjibb4ejPmMGSa4QYjOGKnoyfg
         Xx37kCpn/m0YKo47g/Z4FOfMpxreUVlBcRmkxdUlv/JFdqTDZtZ1la52wMTNSaSyFVb3
         ScWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756323679; x=1756928479;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V+WPD9e8xwvSU5bLer99fOwZ4SmYjxSoVKZ9uP/XO4g=;
        b=pK+GuhOQtDW1OaT1IWhmIBWD87NeJIVnuj/CMNBJRPRJSzFzE8p/OFccyEI2PzcMtV
         A1ypYoRCSoklYu+kWe3v1E/ZqsFIFhIwXQKLoqJiohYEEM3gwr41+xtUbQLVyEj7e2YV
         6ZEoKI4LFLPl2ynCIMNHFedIuh7jk8srjKmTHlPMqmwn/9ed9aIQVhdOLXs2bgHhV+ce
         3wbTC/Q43Od8M7wmotoMg6Cth3zdmyEVfEIOMHMXn4+Ao/Lqbyeqsri7PNqWV7H3puHG
         mvxlfGQK+Vju4nWa2bFV78/W0fm7shQ1m8Jz2wvwr4Mo1DmzG3Kw09JRk0oLUQ4+Ty51
         aEEg==
X-Gm-Message-State: AOJu0YzGmUQjJVtjT70Y0dTW2hEzaBAlhnbHvUJCl93ra0iFIIhpmk//
	eAQySE3wCKHBWRc8RIVNH+wbqzWRTGkZiUjAyTOxvYZ0iTcRCMyxJiZuhuSa+WQpc4YGmyZliyQ
	+Cu0Trw==
X-Google-Smtp-Source: AGHT+IFJRADQETHcJ/b21m/KxVbEwd3QLJppQZSM8otNcmYzujReVgpmb4RU+eVLd68HDkmWMr55KCbsQHs=
X-Received: from pjl5.prod.google.com ([2002:a17:90b:2f85:b0:327:5464:5d5c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c0b:b0:327:a295:320c
 with SMTP id 98e67ed59e1d1-327a2953816mr848186a91.3.1756323675820; Wed, 27
 Aug 2025 12:41:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Aug 2025 12:41:05 -0700
In-Reply-To: <20250827194107.4142164-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827194107.4142164-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.268.g9569e192d0-goog
Message-ID: <20250827194107.4142164-2-seanjc@google.com>
Subject: [PATCH v2 1/3] vhost_task: Don't wake KVM x86's recovery thread if
 vhost task was killed
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

Make the "default" API for waking a vhost task safe against the underlying
task exiting due to a fatal signal.  This fixes a bug in KVM x86 where KVM
attempts to wake an NX hugepage recovery task that exiting before being
explicitly stopped, resulting in a use-after-free and thus crashes, hangs,
and other badness.

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

Handle VHOST_TASK_FLAGS_KILLED in vhost_task_wake() instead of forcing KVM
to solve the problem, as KVM would literally just add an equivalent flag,
along with a new lock to protect said flag.  In general, forcing simple
usage of vhost task to care about signals _and_ take non-trivial action to
do the right thing isn't developer friendly, and is likely to lead to
similar bugs in the future.

Keep the existing behavior for vhost (by calling __vhost_task_wake()
instead of vhost_task_wake()), as vhost_worker_killed() takes extra care
to stop and flush all workers, i.e. doesn't need the extra protection, and
because  vhost_vq_work_queue() calls

  vhost_worker_queue()
  |
  -> worker->ops->wakeup(worker)
     |
     -> vhost_task_wakeup()
        |
        -> vhost_task_wake()

while holding RCU and so can't sleep, i.e. can't take exit_mutex.

        rcu_read_lock();
        worker = rcu_dereference(vq->worker);
        if (worker) {
                queued = true;
                vhost_worker_queue(worker, work);
        }
        rcu_read_unlock();

Debugged-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lore.kernel.org/all/aKkLEtoDXKxAAWju@google.com
Link: https://lore.kernel.org/all/aJ_vEP2EHj6l0xRT@google.com
Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Fixes: d96c77bd4eeb ("KVM: x86: switch hugepage recovery thread to vhost_task")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/vhost/vhost.c            |  2 +-
 include/linux/sched/vhost_task.h |  1 +
 kernel/vhost_task.c              | 52 +++++++++++++++++++++++++++-----
 3 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 8570fdf2e14a..dafce01a9c0d 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -744,7 +744,7 @@ static void vhost_workers_free(struct vhost_dev *dev)
 
 static void vhost_task_wakeup(struct vhost_worker *worker)
 {
-	return vhost_task_wake(worker->vtsk);
+	return __vhost_task_wake(worker->vtsk);
 }
 
 static void vhost_kthread_wakeup(struct vhost_worker *worker)
diff --git a/include/linux/sched/vhost_task.h b/include/linux/sched/vhost_task.h
index 25446c5d3508..1a9c2ac65c9a 100644
--- a/include/linux/sched/vhost_task.h
+++ b/include/linux/sched/vhost_task.h
@@ -10,5 +10,6 @@ struct vhost_task *vhost_task_create(bool (*fn)(void *),
 void vhost_task_start(struct vhost_task *vtsk);
 void vhost_task_stop(struct vhost_task *vtsk);
 void vhost_task_wake(struct vhost_task *vtsk);
+void __vhost_task_wake(struct vhost_task *vtsk);
 
 #endif /* _LINUX_SCHED_VHOST_TASK_H */
diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
index bc738fa90c1d..bd213d0b6da3 100644
--- a/kernel/vhost_task.c
+++ b/kernel/vhost_task.c
@@ -67,16 +67,52 @@ static int vhost_task_fn(void *data)
 	do_exit(0);
 }
 
-/**
- * vhost_task_wake - wakeup the vhost_task
- * @vtsk: vhost_task to wake
- *
- * wake up the vhost_task worker thread
- */
-void vhost_task_wake(struct vhost_task *vtsk)
+static void vhost_task_wake_up_process(struct vhost_task *vtsk)
 {
 	wake_up_process(vtsk->task);
 }
+
+/**
+ * __vhost_task_wake - wakeup the vhost_task
+ * @vtsk: vhost_task to wake
+ *
+ * Wake up the vhost_task worker thread.  The caller is responsible for ensuring
+ * that the task hasn't exited.
+ */
+void __vhost_task_wake(struct vhost_task *vtsk)
+{
+	/*
+	 * Checking VHOST_TASK_FLAGS_KILLED can race with signal delivery, but
+	 * a race can only result in false negatives and this is just a sanity
+	 * check, i.e. if KILLED is set, the caller is buggy no matter what.
+	 */
+	if (WARN_ON_ONCE(test_bit(VHOST_TASK_FLAGS_KILLED, &vtsk->flags)))
+		return;
+
+	vhost_task_wake_up_process(vtsk);
+}
+EXPORT_SYMBOL_GPL(__vhost_task_wake);
+
+/**
+ * vhost_task_wake - wakeup the vhost_task if it hasn't been killed
+ * @vtsk: vhost_task to wake
+ *
+ * Wake up the vhost_task worker thread if the task hasn't exited, e.g. due to
+ * a signal.
+ */
+void vhost_task_wake(struct vhost_task *vtsk)
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
+	vhost_task_wake_up_process(vtsk);
+}
 EXPORT_SYMBOL_GPL(vhost_task_wake);
 
 /**
@@ -91,7 +127,7 @@ void vhost_task_stop(struct vhost_task *vtsk)
 	mutex_lock(&vtsk->exit_mutex);
 	if (!test_bit(VHOST_TASK_FLAGS_KILLED, &vtsk->flags)) {
 		set_bit(VHOST_TASK_FLAGS_STOP, &vtsk->flags);
-		vhost_task_wake(vtsk);
+		vhost_task_wake_up_process(vtsk);
 	}
 	mutex_unlock(&vtsk->exit_mutex);
 
-- 
2.51.0.268.g9569e192d0-goog


