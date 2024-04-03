Return-Path: <kvm+bounces-13464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3CF88971D9
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 16:01:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C738D1C266B7
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 14:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81A1814901E;
	Wed,  3 Apr 2024 14:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="TZOnuuqC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED2D148FE2
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 14:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712152886; cv=none; b=UD+4oMrbYvlRPhWbfdmx1oWuuJEBq1/2CkCB1ty4nvvKKOtHJGvPnILaItzPpxdEgEF/zHNlWqLv8x2KqCKUznbpza7mMPa9KIBQBD8HzNvy7u7idcwoGjzjfSJs7FuwauqCc5OLxTF1dcx8qvYbJMIkA37Fw+F+ExNH4gOyltQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712152886; c=relaxed/simple;
	bh=lpEab+19m9Mx7BY7SwMTKJYnA5tlJh+0D6EDugugn/0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TbQX4K/e2/8cG61Cs3HfwpLW9BSMweLSCqqqNddj3O6ZrO9DG1f0O0Z6Xx/fQFjKUI30Xv89EomVvKpBLt/W2RtKtKoEvZJisKpL3qWo6vGoVWx3BNDk+9wPajlX9w23tgzSLrQvermeixPzaKftdanViKgDyLCW6tgPygfWi9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=TZOnuuqC; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-78d33e20cbfso80406685a.0
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 07:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1712152884; x=1712757684; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UONGPslpRt306kqZsCmGTE/b37ydkUsAJesjvT1tJpY=;
        b=TZOnuuqCWQeykS4xx0VCry+S8i7MXpSO9vMoFgCzqKiZyCp/I8S2Um7vg0thOCZgJf
         7UaNcUxP3yUXZZT6TQ8O5f8N/jalmIxY1FnTf1Uhkw0FUeP2Y13+EBpKchrPPJWorJdW
         I3HrlKMeGHvl7cziEfxEMhY+RMAEYlSuCFwUP3iUzd/05ziPD/hWiwjohlkAnzWJfDGx
         Jbkg1na5dkHQLAHjVqBbTtG8fibHn2zZTQicobvWq2GG/DrCUT8lSZGf31GjTJ5m6RkQ
         O6Cofmxlwr/ey490UI32Vb7SRyJBjHS4FzaQ72EGEFKltjhfFbAKar07t4Cyspz5Plsh
         UAQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712152884; x=1712757684;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UONGPslpRt306kqZsCmGTE/b37ydkUsAJesjvT1tJpY=;
        b=Zh5nDCJ5B14jvt4bElKvnc4MRjdsP8t+3ZCKFGJWFW8HsFGDln8XlTwZvstnm0VLXB
         yIGNNgSa9cSg7cpex0sIJPCxtP3V4U9yIdpW2qi9guSV2bzRGk8+MzuAkwYRbOt5ueVq
         4maoXWFBUMbegvZexE8WbFiTi1chojJdXvCA6ZioDOAVeeDVfZq1MyD4cE53N9cTCuJR
         LxaoLGiozKuU5Rn82FSmiobt4BY4LomB0KBwVvqNC8Svjw4Ch+ysGJu6ZUgkJbWhPa3r
         XrLVrSRiQ82DkbRz629cFK92bedjGhWBr2/M8epXcfuh7XWrQGd8nhtOIOe1IOd6bYNh
         c04g==
X-Forwarded-Encrypted: i=1; AJvYcCWNO5j5YXsD4lw5YYfzNikzUkb93ByOEU2N5v9/zb1x+vsE7k1WOq0zzjWrPq1mPLfsa+KqF82kRPuaJs37a2a31Nog
X-Gm-Message-State: AOJu0Yy3UV0/487ysTH1S0WynAR/k8HzLHsxEHqkSn6VkXABanxEbRKR
	9crdtwJ+sMR+YkMfDOxpbHmqFRW5KxwfZGJRn+JD5+QL1kTl5XH+X0hUAqv6o4A=
X-Google-Smtp-Source: AGHT+IHyvTEQNqSIQcjpHeGqJ7SNEPZRIYtalkAiLrynTgcv4Dtsm9x9wS8IfPIQOAxIX49l9lI3dg==
X-Received: by 2002:a05:6214:8f2:b0:699:2ad4:3dc4 with SMTP id dr18-20020a05621408f200b006992ad43dc4mr1251372qvb.42.1712152883304;
        Wed, 03 Apr 2024 07:01:23 -0700 (PDT)
Received: from vinbuntup3.lan (c-73-143-21-186.hsd1.vt.comcast.net. [73.143.21.186])
        by smtp.gmail.com with ESMTPSA id gf12-20020a056214250c00b00698d06df322sm5945706qvb.122.2024.04.03.07.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Apr 2024 07:01:22 -0700 (PDT)
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
Subject: [RFC PATCH v2 1/5] pvsched: paravirt scheduling framework
Date: Wed,  3 Apr 2024 10:01:12 -0400
Message-Id: <20240403140116.3002809-2-vineeth@bitbyteword.org>
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

Implement a paravirt scheduling framework for linux kernel.

The framework allows for pvsched driver to register to the kernel and
receive callbacks from hypervisor(eg: kvm) for interested vcpu events
like VMENTER, VMEXIT etc.

The framework also allows hypervisor to select a pvsched driver (from
the available list of registered drivers) for each guest.

Also implement a sysctl for listing the available pvsched drivers.

Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 Kconfig                 |   2 +
 include/linux/pvsched.h | 102 +++++++++++++++++++
 kernel/sysctl.c         |  27 +++++
 virt/Makefile           |   2 +-
 virt/pvsched/Kconfig    |  12 +++
 virt/pvsched/Makefile   |   2 +
 virt/pvsched/pvsched.c  | 215 ++++++++++++++++++++++++++++++++++++++++
 7 files changed, 361 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/pvsched.h
 create mode 100644 virt/pvsched/Kconfig
 create mode 100644 virt/pvsched/Makefile
 create mode 100644 virt/pvsched/pvsched.c

diff --git a/Kconfig b/Kconfig
index 745bc773f567..4a52eaa21166 100644
--- a/Kconfig
+++ b/Kconfig
@@ -29,4 +29,6 @@ source "lib/Kconfig"
 
 source "lib/Kconfig.debug"
 
+source "virt/pvsched/Kconfig"
+
 source "Documentation/Kconfig"
diff --git a/include/linux/pvsched.h b/include/linux/pvsched.h
new file mode 100644
index 000000000000..59df6b44aacb
--- /dev/null
+++ b/include/linux/pvsched.h
@@ -0,0 +1,102 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2024 Google  */
+
+#ifndef _LINUX_PVSCHED_H
+#define _LINUX_PVSCHED_H 1
+
+/*
+ * List of events for which hypervisor calls back into pvsched driver.
+ * Driver can specify the events it is interested in.
+ */
+enum pvsched_vcpu_events {
+	PVSCHED_VCPU_VMENTER = 0x1,
+	PVSCHED_VCPU_VMEXIT = 0x2,
+	PVSCHED_VCPU_HALT = 0x4,
+	PVSCHED_VCPU_INTR_INJ = 0x8,
+};
+
+#define PVSCHED_NAME_MAX	32
+#define PVSCHED_MAX		8
+#define PVSCHED_DRV_BUF_MAX	(PVSCHED_NAME_MAX * PVSCHED_MAX + PVSCHED_MAX)
+
+/*
+ * pvsched driver callbacks.
+ * TODO: versioning support for better compatibility with the guest
+ *       component implementing this feature.
+ */
+struct pvsched_vcpu_ops {
+	/*
+	 * pvsched_vcpu_register() - Register the vcpu with pvsched driver.
+	 * @pid: pid of the vcpu task.
+	 *
+	 * pvsched driver can store the pid internally and initialize
+	 * itself to prepare for receiving callbacks from thsi vcpu.
+	 */
+	int (*pvsched_vcpu_register)(struct pid *pid);
+
+	/*
+	 * pvsched_vcpu_unregister() - Un-register the vcpu with pvsched driver.
+	 * @pid: pid of the vcpu task.
+	 */
+	void (*pvsched_vcpu_unregister)(struct pid *pid);
+
+	/*
+	 * pvsched_vcpu_notify_event() - Callback for pvsched events
+	 * @addr: Address of the memory region shared with guest
+	 * @pid: pid of the vcpu task.
+	 * @events: bit mask of the events that hypervisor wants to notify.
+	 */
+	void (*pvsched_vcpu_notify_event)(void *addr, struct pid *pid, u32 event);
+
+	char name[PVSCHED_NAME_MAX];
+	struct module *owner;
+	struct list_head list;
+	u32 events;
+	u32 key;
+};
+
+#ifdef CONFIG_PARAVIRT_SCHED_HOST
+int pvsched_get_available_drivers(char *buf, size_t maxlen);
+
+int pvsched_register_vcpu_ops(struct pvsched_vcpu_ops *ops);
+void pvsched_unregister_vcpu_ops(struct pvsched_vcpu_ops *ops);
+
+struct pvsched_vcpu_ops *pvsched_get_vcpu_ops(char *name);
+void pvsched_put_vcpu_ops(struct pvsched_vcpu_ops *ops);
+
+static inline int pvsched_validate_vcpu_ops(struct pvsched_vcpu_ops *ops)
+{
+	/*
+	 * All callbacks are mandatory.
+	 */
+	if (!ops->pvsched_vcpu_register || !ops->pvsched_vcpu_unregister ||
+			!ops->pvsched_vcpu_notify_event)
+		return -EINVAL;
+
+	return 0;
+}
+#else
+static inline void pvsched_get_available_drivers(char *buf, size_t maxlen)
+{
+}
+
+static inline int pvsched_register_vcpu_ops(struct pvsched_vcpu_ops *ops)
+{
+	return -ENOTSUPP;
+}
+
+static inline void pvsched_unregister_vcpu_ops(struct pvsched_vcpu_ops *ops)
+{
+}
+
+static inline struct pvsched_vcpu_ops *pvsched_get_vcpu_ops(char *name)
+{
+	return NULL;
+}
+
+static inline void pvsched_put_vcpu_ops(struct pvsched_vcpu_ops *ops)
+{
+}
+#endif
+
+#endif
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 157f7ce2942d..10a18a791b4f 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -63,6 +63,7 @@
 #include <linux/mount.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/pid.h>
+#include <linux/pvsched.h>
 
 #include "../lib/kstrtox.h"
 
@@ -1615,6 +1616,24 @@ int proc_do_static_key(struct ctl_table *table, int write,
 	return ret;
 }
 
+#ifdef CONFIG_PARAVIRT_SCHED_HOST
+static int proc_pvsched_available_drivers(struct ctl_table *ctl,
+						 int write, void *buffer,
+						 size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table tbl = { .maxlen = PVSCHED_DRV_BUF_MAX, };
+	int ret;
+
+	tbl.data = kmalloc(tbl.maxlen, GFP_USER);
+	if (!tbl.data)
+		return -ENOMEM;
+	pvsched_get_available_drivers(tbl.data, PVSCHED_DRV_BUF_MAX);
+	ret = proc_dostring(&tbl, write, buffer, lenp, ppos);
+	kfree(tbl.data);
+	return ret;
+}
+#endif
+
 static struct ctl_table kern_table[] = {
 	{
 		.procname	= "panic",
@@ -2033,6 +2052,14 @@ static struct ctl_table kern_table[] = {
 		.extra1		= SYSCTL_ONE,
 		.extra2		= SYSCTL_INT_MAX,
 	},
+#endif
+#ifdef CONFIG_PARAVIRT_SCHED_HOST
+	{
+		.procname	= "pvsched_available_drivers",
+		.maxlen		= PVSCHED_DRV_BUF_MAX,
+		.mode		= 0444,
+		.proc_handler   = proc_pvsched_available_drivers,
+	},
 #endif
 	{ }
 };
diff --git a/virt/Makefile b/virt/Makefile
index 1cfea9436af9..9d0f32d775a1 100644
--- a/virt/Makefile
+++ b/virt/Makefile
@@ -1,2 +1,2 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-y	+= lib/
+obj-y	+= lib/ pvsched/
diff --git a/virt/pvsched/Kconfig b/virt/pvsched/Kconfig
new file mode 100644
index 000000000000..5ca2669060cb
--- /dev/null
+++ b/virt/pvsched/Kconfig
@@ -0,0 +1,12 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config PARAVIRT_SCHED_HOST
+	bool "Paravirt scheduling framework in the host kernel"
+	default n
+	help
+	  Paravirtualized scheduling facilitates the exchange of scheduling
+	  related information between the host and guest through shared memory,
+	  enhancing the efficiency of vCPU thread scheduling by the hypervisor.
+	  An illustrative use case involves dynamically boosting the priority of
+	  a vCPU thread when the guest is executing a latency-sensitive workload
+	  on that specific vCPU.
+	  This config enables paravirt scheduling framework in the host kernel.
diff --git a/virt/pvsched/Makefile b/virt/pvsched/Makefile
new file mode 100644
index 000000000000..4ca38e30479b
--- /dev/null
+++ b/virt/pvsched/Makefile
@@ -0,0 +1,2 @@
+
+obj-$(CONFIG_PARAVIRT_SCHED_HOST) += pvsched.o
diff --git a/virt/pvsched/pvsched.c b/virt/pvsched/pvsched.c
new file mode 100644
index 000000000000..610c85cf90d2
--- /dev/null
+++ b/virt/pvsched/pvsched.c
@@ -0,0 +1,215 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2024 Google  */
+
+/*
+ *  Paravirt scheduling framework
+ *
+ */
+
+/*
+ * Heavily inspired from tcp congestion avoidance implementation.
+ * (net/ipv4/tcp_cong.c)
+ */
+
+#define pr_fmt(fmt) "PVSCHED: " fmt
+
+#include <linux/module.h>
+#include <linux/bpf.h>
+#include <linux/gfp.h>
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/jhash.h>
+#include <linux/pvsched.h>
+
+static DEFINE_SPINLOCK(pvsched_drv_list_lock);
+static int nr_pvsched_drivers = 0;
+static LIST_HEAD(pvsched_drv_list);
+
+/*
+ * Retrieve pvsched_vcpu_ops given the name.
+ */
+static struct pvsched_vcpu_ops *pvsched_find_vcpu_ops_name(char *name)
+{
+	struct pvsched_vcpu_ops *ops;
+
+	list_for_each_entry_rcu(ops, &pvsched_drv_list, list) {
+		if (strcmp(ops->name, name) == 0)
+			return ops;
+	}
+
+	return NULL;
+}
+
+/*
+ * Retrieve pvsched_vcpu_ops given the hash key.
+ */
+static struct pvsched_vcpu_ops *pvsched_find_vcpu_ops_key(u32 key)
+{
+	struct pvsched_vcpu_ops *ops;
+
+	list_for_each_entry_rcu(ops, &pvsched_drv_list, list) {
+		if (ops->key == key)
+			return ops;
+	}
+
+	return NULL;
+}
+
+/*
+ * pvsched_get_available_drivers() - Copy space separated list of pvsched
+ * driver names.
+ * @buf: buffer to store the list of driver names
+ * @maxlen: size of the buffer
+ *
+ * Return: 0 on success, negative value on error.
+ */
+int pvsched_get_available_drivers(char *buf, size_t maxlen)
+{
+	struct pvsched_vcpu_ops *ops;
+	size_t offs = 0;
+
+	if (!buf)
+		return -EINVAL;
+
+	if (maxlen > PVSCHED_DRV_BUF_MAX)
+		maxlen = PVSCHED_DRV_BUF_MAX;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(ops, &pvsched_drv_list, list) {
+		offs += snprintf(buf + offs, maxlen - offs,
+				 "%s%s",
+				 offs == 0 ? "" : " ", ops->name);
+
+		if (WARN_ON_ONCE(offs >= maxlen))
+			break;
+	}
+	rcu_read_unlock();
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pvsched_get_available_drivers);
+
+/*
+ * pvsched_register_vcpu_ops() - Register the driver in the kernel.
+ * @ops: Driver data(callbacks)
+ *
+ * After the registration, driver will be exposed to the hypervisor
+ * for assignment to the guest VMs.
+ *
+ * Return: 0 on success, negative value on error.
+ */
+int pvsched_register_vcpu_ops(struct pvsched_vcpu_ops *ops)
+{
+	int ret = 0;
+
+	ops->key = jhash(ops->name, sizeof(ops->name), strlen(ops->name));
+	spin_lock(&pvsched_drv_list_lock);
+	if (nr_pvsched_drivers > PVSCHED_MAX) {
+		ret = -ENOSPC;
+	} if (pvsched_find_vcpu_ops_key(ops->key)) {
+		ret = -EEXIST;
+	} else if (!(ret = pvsched_validate_vcpu_ops(ops))) {
+		list_add_tail_rcu(&ops->list, &pvsched_drv_list);
+		nr_pvsched_drivers++;
+	}
+	spin_unlock(&pvsched_drv_list_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pvsched_register_vcpu_ops);
+
+/*
+ * pvsched_register_vcpu_ops() - Un-register the driver from the kernel.
+ * @ops: Driver data(callbacks)
+ *
+ * After un-registration, driver will not be visible to hypervisor.
+ */
+void pvsched_unregister_vcpu_ops(struct pvsched_vcpu_ops *ops)
+{
+	spin_lock(&pvsched_drv_list_lock);
+	list_del_rcu(&ops->list);
+	nr_pvsched_drivers--;
+	spin_unlock(&pvsched_drv_list_lock);
+
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(pvsched_unregister_vcpu_ops);
+
+/*
+ * pvsched_get_vcpu_ops: Acquire the driver.
+ * @name: Name of the driver to be acquired.
+ *
+ * Hypervisor can use this API to get the driver structure for
+ * assigning it to guest VMs. This API takes a reference on the
+ * module/bpf program so that driver doesn't vanish under the
+ * hypervisor.
+ *
+ * Return: driver structure if found, else NULL.
+ */
+struct pvsched_vcpu_ops *pvsched_get_vcpu_ops(char *name)
+{
+	struct pvsched_vcpu_ops *ops;
+
+	if (!name || (strlen(name) >= PVSCHED_NAME_MAX))
+		return NULL;
+
+	rcu_read_lock();
+	ops = pvsched_find_vcpu_ops_name(name);
+	if (!ops)
+		goto out;
+
+	if (unlikely(!bpf_try_module_get(ops, ops->owner))) {
+		ops = NULL;
+		goto out;
+	}
+
+out:
+	rcu_read_unlock();
+	return ops;
+}
+EXPORT_SYMBOL_GPL(pvsched_get_vcpu_ops);
+
+/*
+ * pvsched_put_vcpu_ops: Release the driver.
+ * @name: Name of the driver to be releases.
+ *
+ * Hypervisor can use this API to release the driver.
+ */
+void pvsched_put_vcpu_ops(struct pvsched_vcpu_ops *ops)
+{
+	bpf_module_put(ops, ops->owner);
+}
+EXPORT_SYMBOL_GPL(pvsched_put_vcpu_ops);
+
+/*
+ * NOP vm_ops Sample implementation.
+ * This driver doesn't do anything other than registering itself.
+ * Placeholder for adding some default logic when the feature is
+ * complete.
+ */
+static int nop_pvsched_vcpu_register(struct pid *pid)
+{
+	return 0;
+}
+static void nop_pvsched_vcpu_unregister(struct pid *pid)
+{
+}
+static void nop_pvsched_notify_event(void *addr, struct pid *pid, u32 event)
+{
+}
+
+struct pvsched_vcpu_ops nop_vcpu_ops = {
+	.events = PVSCHED_VCPU_VMENTER | PVSCHED_VCPU_VMEXIT | PVSCHED_VCPU_HALT,
+	.pvsched_vcpu_register = nop_pvsched_vcpu_register,
+	.pvsched_vcpu_unregister = nop_pvsched_vcpu_unregister,
+	.pvsched_vcpu_notify_event = nop_pvsched_notify_event,
+	.name = "pvsched_nop",
+	.owner = THIS_MODULE,
+};
+
+static int __init pvsched_init(void)
+{
+	return WARN_ON(pvsched_register_vcpu_ops(&nop_vcpu_ops));
+}
+
+late_initcall(pvsched_init);
-- 
2.40.1


