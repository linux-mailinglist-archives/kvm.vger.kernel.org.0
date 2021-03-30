Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3660A34E04B
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 06:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhC3Emn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 00:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhC3EmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Mar 2021 00:42:16 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF105C061764
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 21:42:15 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id i6so6691398ybk.2
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 21:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1np1BegAKf1p/qLgI0qb1yNV9cLibVUUhaOTRhnPJnw=;
        b=A5tlFUHBnzErekKRYMRnvdWYNIL1OvUkqbUEv0eeZcQEi7ttmhWvkUENOfs0yEf9mG
         yUeo9jApT8YXWX5UXxrJCJvJjWtFsrQK0uf/nUxj62+JzUkY82HgXMDI8RV3JGCUelDc
         WaCxw0xPce+SOcVem70HWFFanL8/DxQv+v6I357b/1JJkri1VDIKq93suioLezn6oyZl
         SSV7sPxCXbvQOS7QPHoHY30B9nhjP34PpRmCABKq3aG4cBVxvjCDnu8YHlnijT6LRQVU
         r/fDAjq7drtCoSWmu83m3x+h4PIZaRNDx9PXIB/kLxq8I9fXZpmIwMmd5S8FQOu8waJ3
         INqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1np1BegAKf1p/qLgI0qb1yNV9cLibVUUhaOTRhnPJnw=;
        b=Z91iRYXk6zoPnUk0LtFvIrDuWbH6ttySuxS1xqFy4i+WglrE32yY8KtUhf7TEVdUuc
         irUhYApac0fadNXyFVmDDfUn//1XYCd7ZlTAOXMG4VZZxX51pyVftn/bC6uv3Rd4awaG
         O8+NEeioURFZYG0c6oIKKd7aQTlS619qFO6KdsU+kyksx7fb82pzEVIAaTeBa0KlLjMn
         fJcq4s+zzjZWNe65A95eCu0WDMd4U5uvcIWhtx5drLDXsIvMutpMXcWc9S1JLDUs0X3L
         3h2+H6Rvlt7sT1IajtmR2xbQ1ej4TJCM6mf0unDga9LcoA0kj/12lrRCLNhpL/aQmiA+
         ZPQg==
X-Gm-Message-State: AOAM5301wXvGROxP3ehgI3vvEQIqD3PIfOM6Pd15o/Q5aUrQAnliueul
        u08xPp3ctszXzfstiJGwsfOy9pjDSZx1
X-Google-Smtp-Source: ABdhPJy9lPu2p4WTjuNjsi58pm7E3mssgnViCFwx4cpXi2yXv9mwI+70MJBnQ3c902v6kfAT9j/I43oB1Hv6
X-Received: from vipinsh.kir.corp.google.com ([2620:0:1008:10:8048:6a12:bd4f:a453])
 (user=vipinsh job=sendgmr) by 2002:a25:664b:: with SMTP id
 z11mr40587444ybm.437.1617079334996; Mon, 29 Mar 2021 21:42:14 -0700 (PDT)
Date:   Mon, 29 Mar 2021 21:42:04 -0700
In-Reply-To: <20210330044206.2864329-1-vipinsh@google.com>
Message-Id: <20210330044206.2864329-2-vipinsh@google.com>
Mime-Version: 1.0
References: <20210330044206.2864329-1-vipinsh@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH v4 1/3] cgroup: Add misc cgroup controller
From:   Vipin Sharma <vipinsh@google.com>
To:     tj@kernel.org, mkoutny@suse.com, jacob.jun.pan@intel.com,
        rdunlap@infradead.org, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com,
        pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com
Cc:     corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        gingell@google.com, rientjes@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Miscellaneous cgroup provides the resource limiting and tracking
mechanism for the scalar resources which cannot be abstracted like the
other cgroup resources. Controller is enabled by the CONFIG_CGROUP_MISC
config option.

A resource can be added to the controller via enum misc_res_type{} in
the include/linux/misc_cgroup.h file and the corresponding name via
misc_res_name[] in the kernel/cgroup/misc.c file. Provider of the
resource must set its capacity prior to using the resource by calling
misc_cg_set_capacity().

Once a capacity is set then the resource usage can be updated using
charge and uncharge APIs. All of the APIs to interact with misc
controller are in include/linux/misc_cgroup.h.

Miscellaneous controller provides 3 interface files. If two misc
resources (res_a and res_b) are registered then:

misc.capacity
A read-only flat-keyed file shown only in the root cgroup.  It shows
miscellaneous scalar resources available on the platform along with
their quantities::

    $ cat misc.capacity
    res_a 50
    res_b 10

misc.current
A read-only flat-keyed file shown in the non-root cgroups.  It shows
the current usage of the resources in the cgroup and its children::

    $ cat misc.current
    res_a 3
    res_b 0

misc.max
A read-write flat-keyed file shown in the non root cgroups. Allowed
maximum usage of the resources in the cgroup and its children.::

    $ cat misc.max
    res_a max
    res_b 4

Limit can be set by::

    # echo res_a 1 > misc.max

Limit can be set to max by::

    # echo res_a max > misc.max

Limits can be set more than the capacity value in the misc.capacity
file.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Reviewed-by: David Rientjes <rientjes@google.com>
---
 include/linux/cgroup_subsys.h |   4 +
 include/linux/misc_cgroup.h   | 126 +++++++++++
 init/Kconfig                  |  14 ++
 kernel/cgroup/Makefile        |   1 +
 kernel/cgroup/misc.c          | 401 ++++++++++++++++++++++++++++++++++
 5 files changed, 546 insertions(+)
 create mode 100644 include/linux/misc_cgroup.h
 create mode 100644 kernel/cgroup/misc.c

diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index acb77dcff3b4..445235487230 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -61,6 +61,10 @@ SUBSYS(pids)
 SUBSYS(rdma)
 #endif
 
+#if IS_ENABLED(CONFIG_CGROUP_MISC)
+SUBSYS(misc)
+#endif
+
 /*
  * The following subsystems are not supported on the default hierarchy.
  */
diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
new file mode 100644
index 000000000000..1195d36558b4
--- /dev/null
+++ b/include/linux/misc_cgroup.h
@@ -0,0 +1,126 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Miscellaneous cgroup controller.
+ *
+ * Copyright 2020 Google LLC
+ * Author: Vipin Sharma <vipinsh@google.com>
+ */
+#ifndef _MISC_CGROUP_H_
+#define _MISC_CGROUP_H_
+
+/**
+ * Types of misc cgroup entries supported by the host.
+ */
+enum misc_res_type {
+	MISC_CG_RES_TYPES
+};
+
+struct misc_cg;
+
+#ifdef CONFIG_CGROUP_MISC
+
+#include <linux/cgroup.h>
+
+/**
+ * struct misc_res: Per cgroup per misc type resource
+ * @max: Maximum limit on the resource.
+ * @usage: Current usage of the resource.
+ * @failed: True if charged failed for the resource in a cgroup.
+ */
+struct misc_res {
+	unsigned long max;
+	atomic_long_t usage;
+	bool failed;
+};
+
+/**
+ * struct misc_cg - Miscellaneous controller's cgroup structure.
+ * @css: cgroup subsys state object.
+ * @res: Array of misc resources usage in the cgroup.
+ */
+struct misc_cg {
+	struct cgroup_subsys_state css;
+	struct misc_res res[MISC_CG_RES_TYPES];
+};
+
+unsigned long misc_cg_res_total_usage(enum misc_res_type type);
+int misc_cg_set_capacity(enum misc_res_type type, unsigned long capacity);
+int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg,
+		       unsigned long amount);
+void misc_cg_uncharge(enum misc_res_type type, struct misc_cg *cg,
+		      unsigned long amount);
+
+/**
+ * css_misc() - Get misc cgroup from the css.
+ * @css: cgroup subsys state object.
+ *
+ * Context: Any context.
+ * Return:
+ * * %NULL - If @css is null.
+ * * struct misc_cg* - misc cgroup pointer of the passed css.
+ */
+static inline struct misc_cg *css_misc(struct cgroup_subsys_state *css)
+{
+	return css ? container_of(css, struct misc_cg, css) : NULL;
+}
+
+/*
+ * get_current_misc_cg() - Find and get the misc cgroup of the current task.
+ *
+ * Returned cgroup has its ref count increased by 1. Caller must call
+ * put_misc_cg() to return the reference.
+ *
+ * Return: Misc cgroup to which the current task belongs to.
+ */
+static inline struct misc_cg *get_current_misc_cg(void)
+{
+	return css_misc(task_get_css(current, misc_cgrp_id));
+}
+
+/*
+ * put_misc_cg() - Put the misc cgroup and reduce its ref count.
+ * @cg - cgroup to put.
+ */
+static inline void put_misc_cg(struct misc_cg *cg)
+{
+	if (cg)
+		css_put(&cg->css);
+}
+
+#else /* !CONFIG_CGROUP_MISC */
+
+unsigned long misc_cg_res_total_usage(enum misc_res_type type)
+{
+	return 0;
+}
+
+static inline int misc_cg_set_capacity(enum misc_res_type type,
+				       unsigned long capacity)
+{
+	return 0;
+}
+
+static inline int misc_cg_try_charge(enum misc_res_type type,
+				     struct misc_cg *cg,
+				     unsigned long amount)
+{
+	return 0;
+}
+
+static inline void misc_cg_uncharge(enum misc_res_type type,
+				    struct misc_cg *cg,
+				    unsigned long amount)
+{
+}
+
+static inline struct misc_cg *get_current_misc_cg(void)
+{
+	return NULL;
+}
+
+static inline void put_misc_cg(struct misc_cg *cg)
+{
+}
+
+#endif /* CONFIG_CGROUP_MISC */
+#endif /* _MISC_CGROUP_H_ */
diff --git a/init/Kconfig b/init/Kconfig
index 5f5c776ef192..18ece598a297 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1110,6 +1110,20 @@ config CGROUP_BPF
 	  BPF_CGROUP_INET_INGRESS will be executed on the ingress path of
 	  inet sockets.
 
+config CGROUP_MISC
+	bool "Misc resource controller"
+	default n
+	help
+	  Provides a controller for miscellaneous resources on a host.
+
+	  Miscellaneous scalar resources are the resources on the host system
+	  which cannot be abstracted like the other cgroups. This controller
+	  tracks and limits the miscellaneous resources used by a process
+	  attached to a cgroup hierarchy.
+
+	  For more information, please check misc cgroup section in
+	  /Documentation/admin-guide/cgroup-v2.rst.
+
 config CGROUP_DEBUG
 	bool "Debug controller"
 	default n
diff --git a/kernel/cgroup/Makefile b/kernel/cgroup/Makefile
index 5d7a76bfbbb7..12f8457ad1f9 100644
--- a/kernel/cgroup/Makefile
+++ b/kernel/cgroup/Makefile
@@ -5,4 +5,5 @@ obj-$(CONFIG_CGROUP_FREEZER) += legacy_freezer.o
 obj-$(CONFIG_CGROUP_PIDS) += pids.o
 obj-$(CONFIG_CGROUP_RDMA) += rdma.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
+obj-$(CONFIG_CGROUP_MISC) += misc.o
 obj-$(CONFIG_CGROUP_DEBUG) += debug.o
diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
new file mode 100644
index 000000000000..4352bc4a3bd5
--- /dev/null
+++ b/kernel/cgroup/misc.c
@@ -0,0 +1,401 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Miscellaneous cgroup controller
+ *
+ * Copyright 2020 Google LLC
+ * Author: Vipin Sharma <vipinsh@google.com>
+ */
+
+#include <linux/limits.h>
+#include <linux/cgroup.h>
+#include <linux/errno.h>
+#include <linux/atomic.h>
+#include <linux/slab.h>
+#include <linux/misc_cgroup.h>
+
+#define MAX_STR "max"
+#define MAX_NUM ULONG_MAX
+
+/* Miscellaneous res name, keep it in sync with enum misc_res_type */
+static const char *const misc_res_name[] = {
+};
+
+/* Root misc cgroup */
+static struct misc_cg root_cg;
+
+/*
+ * Miscellaneous resources capacity for the entire machine. 0 capacity means
+ * resource is not initialized or not present in the host.
+ *
+ * root_cg.max and capacity are independent of each other. root_cg.max can be
+ * more than the actual capacity. We are using Limits resource distribution
+ * model of cgroup for miscellaneous controller.
+ */
+static unsigned long misc_res_capacity[MISC_CG_RES_TYPES];
+
+/**
+ * parent_misc() - Get the parent of the passed misc cgroup.
+ * @cgroup: cgroup whose parent needs to be fetched.
+ *
+ * Context: Any context.
+ * Return:
+ * * struct misc_cg* - Parent of the @cgroup.
+ * * %NULL - If @cgroup is null or the passed cgroup does not have a parent.
+ */
+static struct misc_cg *parent_misc(struct misc_cg *cgroup)
+{
+	return cgroup ? css_misc(cgroup->css.parent) : NULL;
+}
+
+/**
+ * valid_type() - Check if @type is valid or not.
+ * @type: misc res type.
+ *
+ * Context: Any context.
+ * Return:
+ * * true - If valid type.
+ * * false - If not valid type.
+ */
+static inline bool valid_type(enum misc_res_type type)
+{
+	return type >= 0 && type < MISC_CG_RES_TYPES;
+}
+
+/**
+ * misc_cg_res_total_usage() - Get the current total usage of the resource.
+ * @type: misc res type.
+ *
+ * Context: Any context.
+ * Return: Current total usage of the resource.
+ */
+unsigned long misc_cg_res_total_usage(enum misc_res_type type)
+{
+	if (valid_type(type))
+		return atomic_long_read(&root_cg.res[type].usage);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(misc_cg_res_total_usage);
+
+/**
+ * misc_cg_set_capacity() - Set the capacity of the misc cgroup res.
+ * @type: Type of the misc res.
+ * @capacity: Supported capacity of the misc res on the host.
+ *
+ * If capacity is 0 then the charging a misc cgroup fails for that type.
+ *
+ * Context: Any context.
+ * Return:
+ * * %0 - Successfully registered the capacity.
+ * * %-EINVAL - If @type is invalid.
+ */
+int misc_cg_set_capacity(enum misc_res_type type, unsigned long capacity)
+{
+	if (!valid_type(type))
+		return -EINVAL;
+
+	WRITE_ONCE(misc_res_capacity[type], capacity);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(misc_cg_set_capacity);
+
+/**
+ * misc_cg_cancel_charge() - Cancel the charge from the misc cgroup.
+ * @type: Misc res type in misc cg to cancel the charge from.
+ * @cg: Misc cgroup to cancel charge from.
+ * @amount: Amount to cancel.
+ *
+ * Context: Any context.
+ */
+static void misc_cg_cancel_charge(enum misc_res_type type, struct misc_cg *cg,
+				  unsigned long amount)
+{
+	WARN_ONCE(atomic_long_add_negative(-amount, &cg->res[type].usage),
+		  "misc cgroup resource %s became less than 0",
+		  misc_res_name[type]);
+}
+
+/**
+ * misc_cg_try_charge() - Try charging the misc cgroup.
+ * @type: Misc res type to charge.
+ * @cg: Misc cgroup which will be charged.
+ * @amount: Amount to charge.
+ *
+ * Charge @amount to the misc cgroup. Caller must use the same cgroup during
+ * the uncharge call.
+ *
+ * Context: Any context.
+ * Return:
+ * * %0 - If successfully charged.
+ * * -EINVAL - If @type is invalid or misc res has 0 capacity.
+ * * -EBUSY - If max limit will be crossed or total usage will be more than the
+ *	      capacity.
+ */
+int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg,
+		       unsigned long amount)
+{
+	struct misc_cg *i, *j;
+	int ret;
+	struct misc_res *res;
+	int new_usage;
+
+	if (!(valid_type(type) && cg && READ_ONCE(misc_res_capacity[type])))
+		return -EINVAL;
+
+	if (!amount)
+		return 0;
+
+	for (i = cg; i; i = parent_misc(i)) {
+		res = &i->res[type];
+
+		new_usage = atomic_long_add_return(amount, &res->usage);
+		if (new_usage > READ_ONCE(res->max) ||
+		    new_usage > READ_ONCE(misc_res_capacity[type])) {
+			if (!res->failed) {
+				pr_info("cgroup: charge rejected by the misc controller for %s resource in ",
+					misc_res_name[type]);
+				pr_cont_cgroup_path(i->css.cgroup);
+				pr_cont("\n");
+				res->failed = true;
+			}
+			ret = -EBUSY;
+			goto err_charge;
+		}
+	}
+	return 0;
+
+err_charge:
+	for (j = cg; j != i; j = parent_misc(j))
+		misc_cg_cancel_charge(type, j, amount);
+	misc_cg_cancel_charge(type, i, amount);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(misc_cg_try_charge);
+
+/**
+ * misc_cg_uncharge() - Uncharge the misc cgroup.
+ * @type: Misc res type which was charged.
+ * @cg: Misc cgroup which will be uncharged.
+ * @amount: Charged amount.
+ *
+ * Context: Any context.
+ */
+void misc_cg_uncharge(enum misc_res_type type, struct misc_cg *cg,
+		      unsigned long amount)
+{
+	struct misc_cg *i;
+
+	if (!(amount && valid_type(type) && cg))
+		return;
+
+	for (i = cg; i; i = parent_misc(i))
+		misc_cg_cancel_charge(type, i, amount);
+}
+EXPORT_SYMBOL_GPL(misc_cg_uncharge);
+
+/**
+ * misc_cg_max_show() - Show the misc cgroup max limit.
+ * @sf: Interface file
+ * @v: Arguments passed
+ *
+ * Context: Any context.
+ * Return: 0 to denote successful print.
+ */
+static int misc_cg_max_show(struct seq_file *sf, void *v)
+{
+	int i;
+	struct misc_cg *cg = css_misc(seq_css(sf));
+	unsigned long max;
+
+	for (i = 0; i < MISC_CG_RES_TYPES; i++) {
+		if (READ_ONCE(misc_res_capacity[i])) {
+			max = READ_ONCE(cg->res[i].max);
+			if (max == MAX_NUM)
+				seq_printf(sf, "%s max\n", misc_res_name[i]);
+			else
+				seq_printf(sf, "%s %lu\n", misc_res_name[i],
+					   max);
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * misc_cg_max_write() - Update the maximum limit of the cgroup.
+ * @of: Handler for the file.
+ * @buf: Data from the user. It should be either "max", 0, or a positive
+ *	 integer.
+ * @nbytes: Number of bytes of the data.
+ * @off: Offset in the file.
+ *
+ * User can pass data like:
+ * echo sev 23 > misc.max, OR
+ * echo sev max > misc.max
+ *
+ * Context: Any context.
+ * Return:
+ * * >= 0 - Number of bytes processed in the input.
+ * * -EINVAL - If buf is not valid.
+ * * -ERANGE - If number is bigger than the unsigned long capacity.
+ */
+static ssize_t misc_cg_max_write(struct kernfs_open_file *of, char *buf,
+				 size_t nbytes, loff_t off)
+{
+	struct misc_cg *cg;
+	unsigned long max;
+	int ret = 0, i;
+	enum misc_res_type type = MISC_CG_RES_TYPES;
+	char *token;
+
+	buf = strstrip(buf);
+	token = strsep(&buf, " ");
+
+	if (!token || !buf)
+		return -EINVAL;
+
+	for (i = 0; i < MISC_CG_RES_TYPES; i++) {
+		if (!strcmp(misc_res_name[i], token)) {
+			type = i;
+			break;
+		}
+	}
+
+	if (type == MISC_CG_RES_TYPES)
+		return -EINVAL;
+
+	if (!strcmp(MAX_STR, buf)) {
+		max = MAX_NUM;
+	} else {
+		ret = kstrtoul(buf, 0, &max);
+		if (ret)
+			return ret;
+	}
+
+	cg = css_misc(of_css(of));
+
+	if (READ_ONCE(misc_res_capacity[type]))
+		WRITE_ONCE(cg->res[type].max, max);
+	else
+		ret = -EINVAL;
+
+	return ret ? ret : nbytes;
+}
+
+/**
+ * misc_cg_current_show() - Show the current usage of the misc cgroup.
+ * @sf: Interface file
+ * @v: Arguments passed
+ *
+ * Context: Any context.
+ * Return: 0 to denote successful print.
+ */
+static int misc_cg_current_show(struct seq_file *sf, void *v)
+{
+	int i;
+	unsigned long usage;
+	struct misc_cg *cg = css_misc(seq_css(sf));
+
+	for (i = 0; i < MISC_CG_RES_TYPES; i++) {
+		usage = atomic_long_read(&cg->res[i].usage);
+		if (READ_ONCE(misc_res_capacity[i]) || usage)
+			seq_printf(sf, "%s %lu\n", misc_res_name[i], usage);
+	}
+
+	return 0;
+}
+
+/**
+ * misc_cg_capacity_show() - Show the total capacity of misc res on the host.
+ * @sf: Interface file
+ * @v: Arguments passed
+ *
+ * Only present in the root cgroup directory.
+ *
+ * Context: Any context.
+ * Return: 0 to denote successful print.
+ */
+static int misc_cg_capacity_show(struct seq_file *sf, void *v)
+{
+	int i;
+	unsigned long cap;
+
+	for (i = 0; i < MISC_CG_RES_TYPES; i++) {
+		cap = READ_ONCE(misc_res_capacity[i]);
+		if (cap)
+			seq_printf(sf, "%s %lu\n", misc_res_name[i], cap);
+	}
+
+	return 0;
+}
+
+/* Misc cgroup interface files */
+static struct cftype misc_cg_files[] = {
+	{
+		.name = "max",
+		.write = misc_cg_max_write,
+		.seq_show = misc_cg_max_show,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{
+		.name = "current",
+		.seq_show = misc_cg_current_show,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{
+		.name = "capacity",
+		.seq_show = misc_cg_capacity_show,
+		.flags = CFTYPE_ONLY_ON_ROOT,
+	},
+	{}
+};
+
+/**
+ * misc_cg_alloc() - Allocate misc cgroup.
+ * @parent_css: Parent cgroup.
+ *
+ * Context: Process context.
+ * Return:
+ * * struct cgroup_subsys_state* - css of the allocated cgroup.
+ * * ERR_PTR(-ENOMEM) - No memory available to allocate.
+ */
+static struct cgroup_subsys_state *
+misc_cg_alloc(struct cgroup_subsys_state *parent_css)
+{
+	enum misc_res_type i;
+	struct misc_cg *cg;
+
+	if (!parent_css) {
+		cg = &root_cg;
+	} else {
+		cg = kzalloc(sizeof(*cg), GFP_KERNEL);
+		if (!cg)
+			return ERR_PTR(-ENOMEM);
+	}
+
+	for (i = 0; i < MISC_CG_RES_TYPES; i++) {
+		WRITE_ONCE(cg->res[i].max, MAX_NUM);
+		atomic_long_set(&cg->res[i].usage, 0);
+	}
+
+	return &cg->css;
+}
+
+/**
+ * misc_cg_free() - Free the misc cgroup.
+ * @css: cgroup subsys object.
+ *
+ * Context: Any context.
+ */
+static void misc_cg_free(struct cgroup_subsys_state *css)
+{
+	kfree(css_misc(css));
+}
+
+/* Cgroup controller callbacks */
+struct cgroup_subsys misc_cgrp_subsys = {
+	.css_alloc = misc_cg_alloc,
+	.css_free = misc_cg_free,
+	.legacy_cftypes = misc_cg_files,
+	.dfl_cftypes = misc_cg_files,
+};
-- 
2.31.0.291.g576ba9dcdaf-goog

