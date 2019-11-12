Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1DEDF9BF4
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 22:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfKLVVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 16:21:49 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35234 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727149AbfKLVVs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 16:21:48 -0500
Received: by mail-wm1-f68.google.com with SMTP id 8so4541962wmo.0;
        Tue, 12 Nov 2019 13:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id:in-reply-to:references;
        bh=5SLyH1nDWOPlnVhDgIdXQ2ND4eWF21LKVjlVwt+jC+8=;
        b=L1B8BrrAkRaYgvqgzKNslsy/tmTX2z+NCLVKjRV6elm1lfHbuCfIQoDe2eu4veWWS7
         Necyca1bmAaSEbZMgrwA492jfUSI3aPhqBCQOuXofbVegkUnIE+fvURCfgI1bt86wLbO
         iza8UI1SpmdeGX+EUSTq0XAZ96gcxrxIcIol/oziFhKcSl4+5Bw5Zpe/a2LqwpNVt8t5
         WSCVoU7Hdq6FjgekXfndMI8Ta549qCAAjEq4G0FRmg9WcrCq7obF7C5n1WtMbB+7IJPZ
         hsvgw0QjWhfrUvcDavkrz7M2OXCA+BvtE+Ksh5bnYWQ3Pjdizi8jFmcFs7qVQA63/6oL
         FAHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id
         :in-reply-to:references;
        bh=5SLyH1nDWOPlnVhDgIdXQ2ND4eWF21LKVjlVwt+jC+8=;
        b=iRISTCjC1xmx9QVVjhrOGtMFxqW15qCJVMmnVWYIq/2j7fr6b8eRwdPr/ckScL3djP
         7J1/crDViOPvj4lIgnWdDDbyzVNOffZkQj4uxJt2QddYqiyE4so2dCRwlVhRTRlm9h9m
         tgtZlLVOvXNWnkDe1X+l5N8FVRU67br6lVq9mD51wwa1yIBWW5uKbsOTrhVq4ccZwpLf
         zrQLdhvR0XCu6tprRlUdN9pCjXnhzu0FzC1yJ/jlJtOggz5qV//yRz8hJ2gMQXA7PGVu
         JTfa1WQ2dCIPWnPzojqdG1MQX47SIqyN2NVT8a/wMonBLgss6UwUXxVKzv+oIbEpwkIs
         FIgQ==
X-Gm-Message-State: APjAAAXgxjAlZXZ5Iw+/eEYXvnk9+4ub7Lcg2qzDUSCFraNwDsot/s9U
        tTQtbOqG52IBLVQnzicsjEKhBgT+
X-Google-Smtp-Source: APXvYqwC156ld0vXOWC7AXdT2zIcV1I4HDFNqh3IdHCI+fy+UGAPfAUjqOKuQk9cuzgvNXislw6KHg==
X-Received: by 2002:a7b:c38c:: with SMTP id s12mr6147544wmj.84.1573593705210;
        Tue, 12 Nov 2019 13:21:45 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id q25sm198664wra.3.2019.11.12.13.21.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Nov 2019 13:21:43 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 5/7] kvm: Add helper function for creating VM worker threads
Date:   Tue, 12 Nov 2019 22:21:35 +0100
Message-Id: <1573593697-25061-6-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573593697-25061-1-git-send-email-pbonzini@redhat.com>
References: <1573593697-25061-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Junaid Shahid <junaids@google.com>

Add a function to create a kernel thread associated with a given VM. In
particular, it ensures that the worker thread inherits the priority and
cgroups of the calling thread.

Signed-off-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/kvm_host.h |  6 ++++
 virt/kvm/kvm_main.c      | 84 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 719fc3e15ea4..52ed5f66e8f9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1382,4 +1382,10 @@ static inline int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE */
 
+typedef int (*kvm_vm_thread_fn_t)(struct kvm *kvm, uintptr_t data);
+
+int kvm_vm_create_worker_thread(struct kvm *kvm, kvm_vm_thread_fn_t thread_fn,
+				uintptr_t data, const char *name,
+				struct task_struct **thread_ptr);
+
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d6f0696d98ef..8aed32b604d9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -50,6 +50,7 @@
 #include <linux/bsearch.h>
 #include <linux/io.h>
 #include <linux/lockdep.h>
+#include <linux/kthread.h>
 
 #include <asm/processor.h>
 #include <asm/ioctl.h>
@@ -4371,3 +4372,86 @@ void kvm_exit(void)
 	kvm_vfio_ops_exit();
 }
 EXPORT_SYMBOL_GPL(kvm_exit);
+
+struct kvm_vm_worker_thread_context {
+	struct kvm *kvm;
+	struct task_struct *parent;
+	struct completion init_done;
+	kvm_vm_thread_fn_t thread_fn;
+	uintptr_t data;
+	int err;
+};
+
+static int kvm_vm_worker_thread(void *context)
+{
+	/*
+	 * The init_context is allocated on the stack of the parent thread, so
+	 * we have to locally copy anything that is needed beyond initialization
+	 */
+	struct kvm_vm_worker_thread_context *init_context = context;
+	struct kvm *kvm = init_context->kvm;
+	kvm_vm_thread_fn_t thread_fn = init_context->thread_fn;
+	uintptr_t data = init_context->data;
+	int err;
+
+	err = kthread_park(current);
+	/* kthread_park(current) is never supposed to return an error */
+	WARN_ON(err != 0);
+	if (err)
+		goto init_complete;
+
+	err = cgroup_attach_task_all(init_context->parent, current);
+	if (err) {
+		kvm_err("%s: cgroup_attach_task_all failed with err %d\n",
+			__func__, err);
+		goto init_complete;
+	}
+
+	set_user_nice(current, task_nice(init_context->parent));
+
+init_complete:
+	init_context->err = err;
+	complete(&init_context->init_done);
+	init_context = NULL;
+
+	if (err)
+		return err;
+
+	/* Wait to be woken up by the spawner before proceeding. */
+	kthread_parkme();
+
+	if (!kthread_should_stop())
+		err = thread_fn(kvm, data);
+
+	return err;
+}
+
+int kvm_vm_create_worker_thread(struct kvm *kvm, kvm_vm_thread_fn_t thread_fn,
+				uintptr_t data, const char *name,
+				struct task_struct **thread_ptr)
+{
+	struct kvm_vm_worker_thread_context init_context = {};
+	struct task_struct *thread;
+
+	*thread_ptr = NULL;
+	init_context.kvm = kvm;
+	init_context.parent = current;
+	init_context.thread_fn = thread_fn;
+	init_context.data = data;
+	init_completion(&init_context.init_done);
+
+	thread = kthread_run(kvm_vm_worker_thread, &init_context,
+			     "%s-%d", name, task_pid_nr(current));
+	if (IS_ERR(thread))
+		return PTR_ERR(thread);
+
+	/* kthread_run is never supposed to return NULL */
+	WARN_ON(thread == NULL);
+
+	wait_for_completion(&init_context.init_done);
+
+	if (!init_context.err)
+		*thread_ptr = thread;
+
+	return init_context.err;
+}
-- 
1.8.3.1


