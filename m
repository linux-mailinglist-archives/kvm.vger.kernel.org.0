Return-Path: <kvm+bounces-13465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E30858971DA
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 16:02:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 580811F26CDA
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 14:02:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A362C1494DB;
	Wed,  3 Apr 2024 14:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="JH9KYukU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26503148305
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 14:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712152887; cv=none; b=NIYI9LO4S9gAYPkWBtGWFo1nSruO/lvUaHHtMsSWsdxgcI8nWlaus2TZKHCD3E6ZYLr4SZk2X3sbj5PCR/QGcxEfOH5ta2ENJ6ZNevHnlUVbUZEf44eVXe+soGxY0XOW8Qp1Hwwk5DcqZm/X9SnQvY8fw8vhCjnBSutwAwRXDfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712152887; c=relaxed/simple;
	bh=TDctzrjvOyJsGkgtTdTPKD3E/sGdBBWNU2PAEkT4FWw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RCUk/Lus4MjD40IIHqDksfZZv9TLSl93sflWRBCGmerrbThu0O+Lzc2mzbCL1CkhYgu/yLttr2ftlZVwwFG9nMl1cSiQPijgsRzDdkHpmPlTdN6uULnkBmyqLz1xttzCckto9NgzuqZr6AfRNfAtMSU12ilgkL7zbdH4pSYXsbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=JH9KYukU; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6992ec4bbf1so261186d6.2
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 07:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1712152885; x=1712757685; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/BPGVzMI1+eo9yvIAgnlTxqk+J0LKPxHXNZYDNRJA58=;
        b=JH9KYukU0oTCHZDEXfYpMIVEVyCtwpFQMM6lm1YY/9JXIcKNCh/Y4EHvwHXbqt7R/4
         fJ8avagTe7AKzsl5yQxW/IRyoPOqTWhnNwznhHn/ooov6AULZBak0k68dKKa58jJ0vYc
         cy+3FI7DQjSnugPZsk1ilrIeoBJdbRRq7JjS0p+OBCYP75NikQ9NfnWSNfDv6kbRm0V6
         ERYOR9M6GuYi3KiJk958KYx1NxHYX5GIkk0MMcm5h6C/t6l937gvr/slczv6dioileq8
         i6eHTCmYstWhbg25ZLXSro6urFSxJrJY0xnavry+h9hZH4LjRFZqpt6uy7mN1MYbyL3J
         aOZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712152885; x=1712757685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/BPGVzMI1+eo9yvIAgnlTxqk+J0LKPxHXNZYDNRJA58=;
        b=DNIldTQtbX0LxmwpMM3GnnewNH+Kp1tTHC6t3xoWNARgi5qj5JcftWfBrYdrg28mDe
         oV8LesRN93z1dVakeo1C5bjNDUiT8nUZySY6PoegpCBWOVig0Yj0lP1qEGupaEOFf+92
         ZYiAgplk9Cp5z10reqpCVzhR43JPPaqBblZ9P1M2E5IRd1pGNq15a+ltgsxw8VzzhfhV
         2/an3vTViUBWk6gchj04aA6TuJwYVCblXD19c7OoREzLkKb52DNZlQfkYC8RdHz1Je5l
         0p76Iinq9i1zMb7rUSBRA0DogZVJvNdthSLIq1F/RQPtQEFFQG+6uNTJmuUe8vdAyY6w
         YsUA==
X-Forwarded-Encrypted: i=1; AJvYcCX4eIUkumNySKwTBXUOjZ24E84z3YwoqYqAbWjd6Ru8WXV4ROl8Zyp/wW1vh9x8tZBoimdR6+Mf7cNWxzGPz1Jr8PkZ
X-Gm-Message-State: AOJu0YyC7mPg8isnF7FnPgTJpGQQRRa8y5OZD4OBrPFc8l/W/1klvzkD
	ho95hE9O9o8Ez8uNFD9bNqSorEwHAe2iCw5uf2OIEEBdknlLBharoV9795Id/2I=
X-Google-Smtp-Source: AGHT+IGFZcEaZ2LTTabAkPrVqPjWtdW/Cz0Il+zhLsM9yKyyKZpea5NsINjyFBJZ577Vil8whyw/9g==
X-Received: by 2002:a0c:c249:0:b0:699:1fd3:95a3 with SMTP id w9-20020a0cc249000000b006991fd395a3mr3804251qvh.24.1712152884922;
        Wed, 03 Apr 2024 07:01:24 -0700 (PDT)
Received: from vinbuntup3.lan (c-73-143-21-186.hsd1.vt.comcast.net. [73.143.21.186])
        by smtp.gmail.com with ESMTPSA id gf12-20020a056214250c00b00698d06df322sm5945706qvb.122.2024.04.03.07.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Apr 2024 07:01:24 -0700 (PDT)
From: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
To: Ben Segall <bsegall@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Mel Gorman <mgorman@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>
Cc: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Joel Fernandes <joel@joelfernandes.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	himadrics@inria.fr,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [RFC PATCH v2 2/5] kvm: Implement the paravirt sched framework for kvm
Date: Wed,  3 Apr 2024 10:01:13 -0400
Message-Id: <20240403140116.3002809-3-vineeth@bitbyteword.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240403140116.3002809-1-vineeth@bitbyteword.org>
References: <20240403140116.3002809-1-vineeth@bitbyteword.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm uses the kernel's paravirt sched framework to assign an available
pvsched driver for a guest. guest vcpus registers with the pvsched
driver and calls into the driver callback to notify the events that the
driver is interested in.

This PoC doesn't do the callback on interrupt injection yet. Will be
implemented in subsequent iterations.

Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 arch/x86/kvm/Kconfig     |  13 ++++
 arch/x86/kvm/x86.c       |   3 +
 include/linux/kvm_host.h |  32 +++++++++
 virt/kvm/kvm_main.c      | 148 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 196 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 65ed14b6540b..c1776cdb5b65 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -189,4 +189,17 @@ config KVM_MAX_NR_VCPUS
 	  the memory footprint of each KVM guest, regardless of how many vCPUs are
 	  created for a given VM.
 
+config PARAVIRT_SCHED_KVM
+	bool "Enable paravirt scheduling capability for kvm"
+	depends on KVM
+	default n
+	help
+	  Paravirtualized scheduling facilitates the exchange of scheduling
+	  related information between the host and guest through shared memory,
+	  enhancing the efficiency of vCPU thread scheduling by the hypervisor.
+	  An illustrative use case involves dynamically boosting the priority of
+	  a vCPU thread when the guest is executing a latency-sensitive workload
+	  on that specific vCPU.
+	  This config enables paravirt scheduling in the kvm hypervisor.
+
 endif # VIRTUALIZATION
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ffe580169c93..d0abc2c64d47 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10896,6 +10896,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	preempt_disable();
 
+	kvm_vcpu_pvsched_notify(vcpu, PVSCHED_VCPU_VMENTER);
+
 	static_call(kvm_x86_prepare_switch_to_guest)(vcpu);
 
 	/*
@@ -11059,6 +11061,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	guest_timing_exit_irqoff();
 
 	local_irq_enable();
+	kvm_vcpu_pvsched_notify(vcpu, PVSCHED_VCPU_VMEXIT);
 	preempt_enable();
 
 	kvm_vcpu_srcu_read_lock(vcpu);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 179df96b20f8..6381569f3de8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -45,6 +45,8 @@
 #include <asm/kvm_host.h>
 #include <linux/kvm_dirty_ring.h>
 
+#include <linux/pvsched.h>
+
 #ifndef KVM_MAX_VCPU_IDS
 #define KVM_MAX_VCPU_IDS KVM_MAX_VCPUS
 #endif
@@ -832,6 +834,11 @@ struct kvm {
 	bool vm_bugged;
 	bool vm_dead;
 
+#ifdef CONFIG_PARAVIRT_SCHED_KVM
+	spinlock_t pvsched_ops_lock;
+	struct pvsched_vcpu_ops __rcu *pvsched_ops;
+#endif
+
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
 	struct notifier_block pm_notifier;
 #endif
@@ -2413,4 +2420,29 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_PRIVATE_MEM */
 
+#ifdef CONFIG_PARAVIRT_SCHED_KVM
+int kvm_vcpu_pvsched_notify(struct kvm_vcpu *vcpu, u32 events);
+int kvm_vcpu_pvsched_register(struct kvm_vcpu *vcpu);
+void kvm_vcpu_pvsched_unregister(struct kvm_vcpu *vcpu);
+
+int kvm_replace_pvsched_ops(struct kvm *kvm, char *name);
+#else
+static inline int kvm_vcpu_pvsched_notify(struct kvm_vcpu *vcpu, u32 events)
+{
+	return 0;
+}
+static inline int kvm_vcpu_pvsched_register(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+static inline void kvm_vcpu_pvsched_unregister(struct kvm_vcpu *vcpu)
+{
+}
+
+static inline int kvm_replace_pvsched_ops(struct kvm *kvm, char *name)
+{
+	return 0;
+}
+#endif
+
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0f50960b0e3a..0546814e4db7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -170,6 +170,142 @@ bool kvm_is_zone_device_page(struct page *page)
 	return is_zone_device_page(page);
 }
 
+#ifdef CONFIG_PARAVIRT_SCHED_KVM
+typedef enum {
+	PVSCHED_CB_REGISTER = 1,
+	PVSCHED_CB_UNREGISTER = 2,
+	PVSCHED_CB_NOTIFY = 3
+} pvsched_vcpu_callback_t;
+
+/*
+ * Helper function to invoke the pvsched driver callback.
+ */
+static int __vcpu_pvsched_callback(struct kvm_vcpu *vcpu, u32 events,
+		pvsched_vcpu_callback_t action)
+{
+	int ret = 0;
+	struct pid *pid;
+	struct pvsched_vcpu_ops *ops;
+
+	rcu_read_lock();
+	ops = rcu_dereference(vcpu->kvm->pvsched_ops);
+	if (!ops) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	pid = rcu_dereference(vcpu->pid);
+	if (WARN_ON_ONCE(!pid)) {
+		ret = -EINVAL;
+		goto out;
+	}
+	get_pid(pid);
+	switch(action) {
+		case PVSCHED_CB_REGISTER:
+			ops->pvsched_vcpu_register(pid);
+			break;
+		case PVSCHED_CB_UNREGISTER:
+			ops->pvsched_vcpu_unregister(pid);
+			break;
+		case PVSCHED_CB_NOTIFY:
+			if (ops->events & events) {
+				ops->pvsched_vcpu_notify_event(
+					NULL, /* TODO: Pass guest allocated sharedmem addr */
+					pid,
+					ops->events & events);
+			}
+			break;
+		default:
+			WARN_ON_ONCE(1);
+	}
+	put_pid(pid);
+
+out:
+	rcu_read_unlock();
+	return ret;
+}
+
+int kvm_vcpu_pvsched_notify(struct kvm_vcpu *vcpu, u32 events)
+{
+	return __vcpu_pvsched_callback(vcpu, events, PVSCHED_CB_NOTIFY);
+}
+
+int kvm_vcpu_pvsched_register(struct kvm_vcpu *vcpu)
+{
+	return __vcpu_pvsched_callback(vcpu, 0, PVSCHED_CB_REGISTER);
+	/*
+	 * TODO: Action if the registration fails?
+	 */
+}
+
+void kvm_vcpu_pvsched_unregister(struct kvm_vcpu *vcpu)
+{
+	__vcpu_pvsched_callback(vcpu, 0, PVSCHED_CB_UNREGISTER);
+}
+
+/*
+ * Replaces the VM's current pvsched driver.
+ * if name is NULL or empty string, unassign the
+ * current driver.
+ */
+int kvm_replace_pvsched_ops(struct kvm *kvm, char *name)
+{
+	int ret = 0;
+	unsigned long i;
+	struct kvm_vcpu *vcpu = NULL;
+	struct pvsched_vcpu_ops *ops = NULL, *prev_ops;
+
+
+	spin_lock(&kvm->pvsched_ops_lock);
+
+	prev_ops = rcu_dereference(kvm->pvsched_ops);
+
+	/*
+	 * Unassign operation if the passed in value is
+	 * NULL or an empty string.
+	 */
+	if (name && *name) {
+		ops = pvsched_get_vcpu_ops(name);
+		if (!ops) {
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	if (prev_ops) {
+		/*
+		 * Unregister current pvsched driver.
+		 */
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			kvm_vcpu_pvsched_unregister(vcpu);
+		}
+
+		pvsched_put_vcpu_ops(prev_ops);
+	}
+
+
+	rcu_assign_pointer(kvm->pvsched_ops, ops);
+	if (ops) {
+		/*
+		 * Register new pvsched driver.
+		 */
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			WARN_ON_ONCE(kvm_vcpu_pvsched_register(vcpu));
+		}
+	}
+
+out:
+	spin_unlock(&kvm->pvsched_ops_lock);
+
+	if (ret)
+		return ret;
+
+	synchronize_rcu();
+
+	return 0;
+}
+#endif
+
 /*
  * Returns a 'struct page' if the pfn is "valid" and backed by a refcounted
  * page, NULL otherwise.  Note, the list of refcounted PG_reserved page types
@@ -508,6 +644,8 @@ static void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_destroy(vcpu);
 	kvm_dirty_ring_free(&vcpu->dirty_ring);
 
+	kvm_vcpu_pvsched_unregister(vcpu);
+
 	/*
 	 * No need for rcu_read_lock as VCPU_RUN is the only place that changes
 	 * the vcpu->pid pointer, and at destruction time all file descriptors
@@ -1221,6 +1359,10 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
 
+#ifdef CONFIG_PARAVIRT_SCHED_KVM
+	spin_lock_init(&kvm->pvsched_ops_lock);
+#endif
+
 	/*
 	 * Force subsequent debugfs file creations to fail if the VM directory
 	 * is not created (by kvm_create_vm_debugfs()).
@@ -1343,6 +1485,8 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	int i;
 	struct mm_struct *mm = kvm->mm;
 
+	kvm_replace_pvsched_ops(kvm, NULL);
+
 	kvm_destroy_pm_notifier(kvm);
 	kvm_uevent_notify_change(KVM_EVENT_DESTROY_VM, kvm);
 	kvm_destroy_vm_debugfs(kvm);
@@ -3779,6 +3923,8 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		if (kvm_vcpu_check_block(vcpu) < 0)
 			break;
 
+		kvm_vcpu_pvsched_notify(vcpu, PVSCHED_VCPU_HALT);
+
 		waited = true;
 		schedule();
 	}
@@ -4434,6 +4580,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 			/* The thread running this VCPU changed. */
 			struct pid *newpid;
 
+			kvm_vcpu_pvsched_unregister(vcpu);
 			r = kvm_arch_vcpu_run_pid_change(vcpu);
 			if (r)
 				break;
@@ -4442,6 +4589,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 			rcu_assign_pointer(vcpu->pid, newpid);
 			if (oldpid)
 				synchronize_rcu();
+			kvm_vcpu_pvsched_register(vcpu);
 			put_pid(oldpid);
 		}
 		r = kvm_arch_vcpu_ioctl_run(vcpu);
-- 
2.40.1


