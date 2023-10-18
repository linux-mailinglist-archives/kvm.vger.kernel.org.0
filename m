Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49DE87CE958
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 22:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbjJRUql (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 16:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbjJRUqh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 16:46:37 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEC49B
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 13:46:35 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a7be940fe1so117680807b3.2
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 13:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697661995; x=1698266795; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=w+Tq8ZbDqZnNACP1ZGd4eGNbYVTAqWG4yMn2szlYYbk=;
        b=T98kk+jNDwt/ZiuSK4thE7SNRmSmHKpNUjbVFTUOUn1zp7roA0T/GxYtAivo2NfBRp
         iSok0N2azlFKcVN4CBiS6e/ST5N5Qfbc2K6a9737JC+ra4WSrvNb74LU20wMm4A8emdm
         uPM8dmBoUr9ZFKz4C9oiTP9DIR01oYLTL6QGFfMMIwG3CFyGBUYGU3CGT0y6L05aA1ay
         0OikiUefL/VdGER5iJKu+15WKaK6Xu6B6Nm+qkr/7lJETspWuQDyLSsoXwdkBcqSkpWA
         5jQ52I8t7dt9ka/SHKX7tCKAOfhYpCtpkPL1qrqY/B10qsAAQIAp0wSbn4jKeWl/80nC
         rcvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697661995; x=1698266795;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w+Tq8ZbDqZnNACP1ZGd4eGNbYVTAqWG4yMn2szlYYbk=;
        b=vYKZN8WOiSOjj07UA3Jf3Nlo6ZmslGPnE6JMGLW13mssTlxelHvhGDb4D5yKF/EVJm
         veSZnkAoU+J9BCLZDlrQU5i40MHAZSYXK319SzfVnwm/ORdArJXX4hZfVweP2/ZeBNNl
         PjETNg2XH0EZL/5KmRqxIWejkjjH/u8D9l6ywT1EabBfovRa2rL9Xt/P4VEhbohiZHmE
         fTliOL6M2tEUNqiowaik7F5Z3DNDcseqsP13LGMr7FIOi8suAVcJL9ZX9mjGcDmxmcEI
         UyKgQ/J+3iQ/xB/CLrtQQFzTeLKgnoNoQODzXoUbxG/ZWnO6RK/5vgFql4B9ugp+OJnW
         57IQ==
X-Gm-Message-State: AOJu0YwuK32wtxQSeRXkwKnoqcGjNIw80QPDnfFjueVEdIgPA3hMj2DE
        oQJbrRN1zNT57AJFBfUMspgwa2nu10s=
X-Google-Smtp-Source: AGHT+IExHueZ801GZYJL9D6wPlfFWNcPEOuWicVaYleJkmF6NjxQ6GVvUBqt4HcS+UjO0Bnn4V8/N0OPneU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:cb89:0:b0:5a7:7683:995d with SMTP id
 n131-20020a0dcb89000000b005a77683995dmr11570ywd.5.1697661995065; Wed, 18 Oct
 2023 13:46:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 18 Oct 2023 13:46:23 -0700
In-Reply-To: <20231018204624.1905300-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231018204624.1905300-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231018204624.1905300-3-seanjc@google.com>
Subject: [PATCH 2/3] KVM: Always flush async #PF workqueue when vCPU is being destroyed
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Always flush the per-vCPU async #PF workqueue when a vCPU is clearing its
completion queue, i.e. when a VM and all its vCPUs is being destroyed.
KVM must ensure that none of its workqueue callbacks is running when the
last reference to the KVM _module_ is put.  Gifting a reference to the
associated VM prevents the workqueue callback from dereferencing freed
vCPU/VM memory, but does not prevent the KVM module from being unloaded
before the callback completes.

Drop the misguided VM refcount gifting, as calling kvm_put_kvm() from
async_pf_execute() if kvm_put_kvm() flushes the async #PF workqueue will
result in deadlock.  async_pf_execute() can't return until kvm_put_kvm()
finishes, and kvm_put_kvm() can't return until async_pf_execute() finishes:

 WARNING: CPU: 8 PID: 251 at virt/kvm/kvm_main.c:1435 kvm_put_kvm+0x2d/0x320 [kvm]
 Modules linked in: vhost_net vhost vhost_iotlb tap kvm_intel kvm irqbypass
 CPU: 8 PID: 251 Comm: kworker/8:1 Tainted: G        W          6.6.0-rc1-e7af8d17224a-x86/gmem-vm #119
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
 Workqueue: events async_pf_execute [kvm]
 RIP: 0010:kvm_put_kvm+0x2d/0x320 [kvm]
 Call Trace:
  <TASK>
  async_pf_execute+0x198/0x260 [kvm]
  process_one_work+0x145/0x2d0
  worker_thread+0x27e/0x3a0
  kthread+0xba/0xe0
  ret_from_fork+0x2d/0x50
  ret_from_fork_asm+0x11/0x20
  </TASK>
 ---[ end trace 0000000000000000 ]---
 INFO: task kworker/8:1:251 blocked for more than 120 seconds.
       Tainted: G        W          6.6.0-rc1-e7af8d17224a-x86/gmem-vm #119
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 task:kworker/8:1     state:D stack:0     pid:251   ppid:2      flags:0x00004000
 Workqueue: events async_pf_execute [kvm]
 Call Trace:
  <TASK>
  __schedule+0x33f/0xa40
  schedule+0x53/0xc0
  schedule_timeout+0x12a/0x140
  __wait_for_common+0x8d/0x1d0
  __flush_work.isra.0+0x19f/0x2c0
  kvm_clear_async_pf_completion_queue+0x129/0x190 [kvm]
  kvm_arch_destroy_vm+0x78/0x1b0 [kvm]
  kvm_put_kvm+0x1c1/0x320 [kvm]
  async_pf_execute+0x198/0x260 [kvm]
  process_one_work+0x145/0x2d0
  worker_thread+0x27e/0x3a0
  kthread+0xba/0xe0
  ret_from_fork+0x2d/0x50
  ret_from_fork_asm+0x11/0x20
  </TASK>

If kvm_clear_async_pf_completion_queue() actually flushes the workqueue,
then there's no need to gift async_pf_execute() a reference because all
invocations of async_pf_execute() will be forced to complete before the
vCPU and its VM are destroyed/freed.  And that in turn fixes the module
unloading bug as __fput() won't do module_put() on the last vCPU reference
until the vCPU has been freed, e.g. if closing the vCPU file also puts the
last reference to the KVM module.

Note, commit 5f6de5cbebee ("KVM: Prevent module exit until all VMs are
freed") *tried* to fix the module refcounting issue by having VMs grab a
reference to the module, but that only made the bug slightly harder to hit
as it gave async_pf_execute() a bit more time to complete before the KVM
module could be unloaded.

Fixes: af585b921e5d ("KVM: Halt vcpu if page it tries to access is swapped out")
Cc: stable@vger.kernel.org
Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/async_pf.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index e033c79d528e..7aeb9d1f43b1 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -87,7 +87,6 @@ static void async_pf_execute(struct work_struct *work)
 	__kvm_vcpu_wake_up(vcpu);
 
 	mmput(mm);
-	kvm_put_kvm(vcpu->kvm);
 }
 
 void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
@@ -114,7 +113,6 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 #else
 		if (cancel_work_sync(&work->work)) {
 			mmput(work->mm);
-			kvm_put_kvm(vcpu->kvm); /* == work->vcpu->kvm */
 			kmem_cache_free(async_pf_cache, work);
 		}
 #endif
@@ -126,7 +124,19 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 			list_first_entry(&vcpu->async_pf.done,
 					 typeof(*work), link);
 		list_del(&work->link);
+
+		spin_unlock(&vcpu->async_pf.lock);
+
+		/*
+		 * The async #PF is "done", but KVM must wait for the work item
+		 * itself, i.e. async_pf_execute(), to run to completion.  If
+		 * KVM is a module, KVM must ensure *no* code owned by the KVM
+		 * (the module) can be run after the last call to module_put(),
+		 * i.e. after the last reference to the last vCPU's file is put.
+		 */
+		flush_work(&work->work);
 		kmem_cache_free(async_pf_cache, work);
+		spin_lock(&vcpu->async_pf.lock);
 	}
 	spin_unlock(&vcpu->async_pf.lock);
 
@@ -186,7 +196,6 @@ bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	work->arch = *arch;
 	work->mm = current->mm;
 	mmget(work->mm);
-	kvm_get_kvm(work->vcpu->kvm);
 
 	INIT_WORK(&work->work, async_pf_execute);
 
-- 
2.42.0.655.g421f12c284-goog

