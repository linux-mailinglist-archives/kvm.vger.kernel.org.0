Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B3A273799
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 02:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbgIVAkx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 20:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728911AbgIVAkw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 20:40:52 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41C1C061755
        for <kvm@vger.kernel.org>; Mon, 21 Sep 2020 17:40:52 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id s4so9313700pgk.17
        for <kvm@vger.kernel.org>; Mon, 21 Sep 2020 17:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=2bo/8biDCLvdc5lUd4pxIfX0ji8Irow1K8yrWLCkSEw=;
        b=MrQrOaXmVBsPDdbFCxn5Av9ptBV/TAKp8vJHFuZkt+J2XJOvvM1Q/F49uQwrOLVFUi
         sLCAcw5JyVAaGZjxOsWxrK3PlhT5jN2cDvEu5o95VeQwrDfIpssgqIaKLZtd8GZ7jSS3
         KPTx52/Dua+RFSpzYLsgoT7OWbg0l4mNy4CtSjLYHf9XGj6MwOsmBCApfvJmw5zFHrL4
         X/uNMJgHpKD5pCrZTPcU/haY7AOcZ5LQhVUjwZHWaomnOO92955x+tcfrbjt0/sJbLYR
         i/GL7zCrPtEp2IqZk9+NHjwztTJE64FrO1nUuBi6+N5FO7FrUPII+uVo8qr9Vm+/fxPd
         mDoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2bo/8biDCLvdc5lUd4pxIfX0ji8Irow1K8yrWLCkSEw=;
        b=Srrq0wCpLDtD+8/3sUyCNefyU6nUucnRph/1kdzWcti5/Fd0QZG+IGinLaQW3btnlB
         3Jbg3ulVt4XTKltGMx9ovgb/U+AMXHgpF+Oa2CbZYiM33F0twc1ZUiJFwPYuiQ82reJb
         fqJubl6E/7lWvbovCcUWPd1YEJtVUNYX7f3X1kCOQma+MgRwDMEcy/33bVdPL7RLCWal
         SS3ckmsZOfJnNapt5aCyCSa0BwUR8h9tIs+j8e7smtHxIYY9XXGZPrSgDz/JW74E/soi
         mTNhg15v9MEZt01B0LoVsLmRqDvr9WfupFL/HtFjAgejHXIwJDUr8qVJWDF/j72b8vtu
         S4HQ==
X-Gm-Message-State: AOAM532G5TjvHom2BttBkHupKz8/j87NQh8X7Z4vXA17pywUFNdB1qf1
        QY+YSR+bPN67KbTZ9dz50vaQJ9T9swfx
X-Google-Smtp-Source: ABdhPJwwEskzYpOBo5WnGw2LW4mDawGLCStzqESTwLGyzmoPZTF8h2MYozyOU2GmWIl/kNqyXTmQkdGrp2P7
Sender: "vipinsh via sendgmr" <vipinsh@vipinsh.kir.corp.google.com>
X-Received: from vipinsh.kir.corp.google.com ([2620:0:1008:10:1ea0:b8ff:fe75:b885])
 (user=vipinsh job=sendgmr) by 2002:a17:90b:1649:: with SMTP id
 il9mr1580586pjb.94.1600735252261; Mon, 21 Sep 2020 17:40:52 -0700 (PDT)
Date:   Mon, 21 Sep 2020 17:40:23 -0700
In-Reply-To: <20200922004024.3699923-1-vipinsh@google.com>
Message-Id: <20200922004024.3699923-2-vipinsh@google.com>
Mime-Version: 1.0
References: <20200922004024.3699923-1-vipinsh@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [RFC Patch 1/2] KVM: SVM: Create SEV cgroup controller.
From:   Vipin Sharma <vipinsh@google.com>
To:     thomas.lendacky@amd.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, tj@kernel.org, lizefan@huawei.com
Cc:     joro@8bytes.org, corbet@lwn.net, brijesh.singh@amd.com,
        jon.grimm@amd.com, eric.vantassell@amd.com, gingell@google.com,
        rientjes@google.com, kvm@vger.kernel.org, x86@kernel.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        Erdem Aktas <erdemaktas@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Create SEV cgroup controller for SEV ASIDs on the AMD platform.

SEV ASIDs are used to encrypt virtual machines memory and isolate the
guests from the hypervisor. However, number of SEV ASIDs are limited on
a platform. This leads to the resource constraints and cause issues
like:

1. Some applications exhausting all of the SEV ASIDs and depriving
   others on a host.
2. No capability with the system admin to allocate and limit the number
   of SEV ASIDs used by tasks.
3. Difficult for the cloud service providers to optimally schedule VMs
   and sandboxes across its fleet without knowing the overall picture of
   SEV ASIDs usage.

SEV controller tracks the usage and provides capability to limit SEV
ASIDs used by tasks.

Controller is enabled by CGROUP_SEV config option, it is dependent on
KVM_AMD_SEV option in the config file.

SEV Controller has 3 interface files:

1. max - Sets the max limit of the SEV ASIDs in the cgroup.

2. current - Shows the current count of the SEV ASIDs in the cgroup.

3. events - Event file to show the SEV ASIDs allocation denied in the
	    cgroup.

When kvm-amd module is installed it calls SEV controller API and informs
how many SEV ASIDs are available on the platform. Controller use this
value to allocate an array which stores ASID to cgroup mapping.

New SEV ASID allocation gets charged to the task's SEV cgroup. Migration
of charge is not supported, so, a charged ASID remains charged to the
same cgroup until that SEV ASID is freed. This feature is similar to the
memory cgroup as it is a stateful resource

On deletion of an empty cgroup whose tasks have moved to some other
cgroup but a SEV ASID is still charged to it, the SEV ASID gets mapped
to the parent cgroup.

Mapping array tells which cgroup to uncharge, and update mapping when
the cgroup is deleted. Mapping array is freed when kvm-amd module is
unloaded.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Reviewed-by: David Rientjes <rientjes@google.com>
Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
Reviewed-by: Erdem Aktas <erdemaktas@google.com>
---
 arch/x86/kvm/Makefile         |   1 +
 arch/x86/kvm/svm/sev.c        |  16 +-
 arch/x86/kvm/svm/sev_cgroup.c | 414 ++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/sev_cgroup.h |  40 ++++
 include/linux/cgroup_subsys.h |   3 +
 init/Kconfig                  |  14 ++
 6 files changed, 487 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kvm/svm/sev_cgroup.c
 create mode 100644 arch/x86/kvm/svm/sev_cgroup.h

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 4a3081e9f4b5..bbbf10fc1b50 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -16,6 +16,7 @@ kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
 kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
 			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o
+kvm-$(CONFIG_CGROUP_SEV)	+= svm/sev_cgroup.o
 
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o vmx/evmcs.o vmx/nested.o
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7bf7bf734979..2cc0bea21a76 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -17,6 +17,7 @@
 
 #include "x86.h"
 #include "svm.h"
+#include "sev_cgroup.h"
 
 static int sev_flush_asids(void);
 static DECLARE_RWSEM(sev_deactivate_lock);
@@ -80,7 +81,7 @@ static bool __sev_recycle_asids(void)
 static int sev_asid_new(void)
 {
 	bool retry = true;
-	int pos;
+	int pos, ret;
 
 	mutex_lock(&sev_bitmap_lock);
 
@@ -98,6 +99,12 @@ static int sev_asid_new(void)
 		return -EBUSY;
 	}
 
+	ret = sev_asid_try_charge(pos);
+	if (ret) {
+		mutex_unlock(&sev_bitmap_lock);
+		return ret;
+	}
+
 	__set_bit(pos, sev_asid_bitmap);
 
 	mutex_unlock(&sev_bitmap_lock);
@@ -127,6 +134,8 @@ static void sev_asid_free(int asid)
 		sd->sev_vmcbs[pos] = NULL;
 	}
 
+	sev_asid_uncharge(pos);
+
 	mutex_unlock(&sev_bitmap_lock);
 }
 
@@ -1143,6 +1152,9 @@ int __init sev_hardware_setup(void)
 	if (!status)
 		return 1;
 
+	if (sev_cgroup_setup(max_sev_asid))
+		return 1;
+
 	/*
 	 * Check SEV platform status.
 	 *
@@ -1157,6 +1169,7 @@ int __init sev_hardware_setup(void)
 	pr_info("SEV supported\n");
 
 err:
+	sev_cgroup_teardown();
 	kfree(status);
 	return rc;
 }
@@ -1170,6 +1183,7 @@ void sev_hardware_teardown(void)
 	bitmap_free(sev_reclaim_asid_bitmap);
 
 	sev_flush_asids();
+	sev_cgroup_teardown();
 }
 
 void pre_sev_run(struct vcpu_svm *svm, int cpu)
diff --git a/arch/x86/kvm/svm/sev_cgroup.c b/arch/x86/kvm/svm/sev_cgroup.c
new file mode 100644
index 000000000000..f76a934b8cf2
--- /dev/null
+++ b/arch/x86/kvm/svm/sev_cgroup.c
@@ -0,0 +1,414 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * SEV cgroup controller
+ *
+ * Copyright 2020 Google LLC
+ * Author: Vipin Sharma <vipinsh@google.com>
+ */
+
+#include <linux/cgroup.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/lockdep.h>
+
+#define MAX_SEV_ASIDS_STR "max"
+
+/**
+ * struct sev_cgroup - Stores SEV ASID related cgroup data.
+ * @css: cgroup subsys state object.
+ * @max: Max limit of the count of the SEV ASIDs in the cgroup.
+ * @usage: Current count of the SEV ASIDs in the cgroup.
+ * @allocation_failure_event: Number of times the SEV ASIDs allocation denied.
+ * @events_file: File handle for sev.events file.
+ */
+struct sev_cgroup {
+	struct cgroup_subsys_state css;
+	unsigned int max;
+	unsigned int usage;
+	unsigned long allocation_failure_event;
+	struct cgroup_file events_file;
+};
+
+/* Maximum number of sev asids supported in the platform */
+static unsigned int sev_max_asids;
+
+/* Global array to store which ASID is charged to which cgroup */
+static struct sev_cgroup **sev_asids_cgroup_array;
+
+/*
+ * To synchronize sev_asids_cgroup_array changes from charging/uncharging,
+ * css_offline, max, and printing used ASIDs.
+ */
+static DEFINE_MUTEX(sev_cgroup_lock);
+
+/**
+ * css_sev() - Get sev_cgroup from the css.
+ * @css: cgroup subsys state object.
+ *
+ * Context: Any context.
+ * Return:
+ * * %NULL - If @css is null.
+ * * struct sev_cgroup * - SEV cgroup of the specified css.
+ */
+static struct sev_cgroup *css_sev(struct cgroup_subsys_state *css)
+{
+	return css ? container_of(css, struct sev_cgroup, css) : NULL;
+}
+
+/**
+ * parent_sev_cgroup() - Get the parent sev cgroup in the cgroup hierarchy
+ * @sevcg: sev cgroup node whose parent is needed.
+ *
+ * Context: Any context.
+ * Return:
+ * * struct sev_cgroup * - Parent sev cgroup in the hierarchy.
+ * * %NULL - If @sevcg is null or it is the root in the hierarchy.
+ */
+static struct sev_cgroup *parent_sev_cgroup(struct sev_cgroup *sevcg)
+{
+	return sevcg ? css_sev(sevcg->css.parent) : NULL;
+}
+
+/*
+ * sev_asid_cgroup_dec() - Decrement the SEV ASID usage in the cgroup.
+ * @sevcg: SEV cgroup.
+ *
+ * Context: Any context. Expects sev_cgroup_lock mutex to be held by the
+ *	    caller.
+ */
+static void sev_asid_cgroup_dec(struct sev_cgroup *sevcg)
+{
+	lockdep_assert_held(&sev_cgroup_lock);
+	sevcg->usage--;
+	/*
+	 * If this ever becomes max then there is a bug in the SEV cgroup code.
+	 */
+	WARN_ON_ONCE(sevcg->usage == UINT_MAX);
+}
+
+/**
+ * sev_asid_try_charge() - Try charging an SEV ASID to the cgroup.
+ * @pos: Index of SEV ASID in the SEV ASIDs bitmap.
+ *
+ * Try charging an SEV ASID to the current task's cgroup and all its ancestors
+ * up to the root. If charging is not possible due to the limit constraint,
+ * then notify the event file and return -errorno.
+ *
+ * Context: Process context. Takes and release sev_cgroup_lock mutex.
+ * Return:
+ * * 0 - If successfully charged the cgroup.
+ * * -EINVAL - If pos is not valid.
+ * * -EBUSY - If usage has already reached the limit.
+ */
+int sev_asid_try_charge(int pos)
+{
+	struct sev_cgroup *start, *i, *j;
+	int ret = 0;
+
+	mutex_lock(&sev_cgroup_lock);
+
+	start = css_sev(task_css(current, sev_cgrp_id));
+
+	for (i = start; i; i = parent_sev_cgroup(i)) {
+		if (i->usage == i->max)
+			goto e_limit;
+
+		i->usage++;
+	}
+
+	sev_asids_cgroup_array[pos] = start;
+exit:
+	mutex_unlock(&sev_cgroup_lock);
+	return ret;
+
+e_limit:
+	for (j = start; j != i; j = parent_sev_cgroup(j))
+		sev_asid_cgroup_dec(j);
+
+	start->allocation_failure_event++;
+	cgroup_file_notify(&start->events_file);
+
+	ret = -EBUSY;
+	goto exit;
+}
+EXPORT_SYMBOL(sev_asid_try_charge);
+
+/**
+ * sev_asid_uncharge() - Uncharge an SEV ASID from the cgroup.
+ * @pos: Index of SEV ASID in the SEV ASIDs bitmap.
+ *
+ * Uncharge an SEV ASID from the cgroup to which it was charged in
+ * sev_asid_try_charge().
+ *
+ * Context: Process context. Takes and release sev_cgroup_lock mutex.
+ */
+void sev_asid_uncharge(int pos)
+{
+	struct sev_cgroup *i;
+
+	mutex_lock(&sev_cgroup_lock);
+
+	for (i = sev_asids_cgroup_array[pos]; i; i = parent_sev_cgroup(i))
+		sev_asid_cgroup_dec(i);
+
+	sev_asids_cgroup_array[pos] = NULL;
+
+	mutex_unlock(&sev_cgroup_lock);
+}
+EXPORT_SYMBOL(sev_asid_uncharge);
+
+/**
+ * sev_cgroup_setup() - Setup the sev cgroup before charging.
+ * @max: Maximum number of SEV ASIDs supported by the platform.
+ *
+ * Initialize the sev_asids_cgroup_array which stores ASID to cgroup mapping.
+ *
+ * Context: Process context. Takes and release sev_cgroup_lock mutex.
+ * Return:
+ * * 0 - If setup was successful.
+ * * -ENOMEM - If memory not available to allocate the array.
+ */
+int sev_cgroup_setup(unsigned int max)
+{
+	int ret = 0;
+
+	mutex_lock(&sev_cgroup_lock);
+
+	sev_max_asids = max;
+	sev_asids_cgroup_array = kcalloc(sev_max_asids,
+					 sizeof(struct sev_cgroup *),
+					 GFP_KERNEL);
+	if (!sev_asids_cgroup_array) {
+		sev_max_asids = 0;
+		ret = -ENOMEM;
+	}
+
+	mutex_unlock(&sev_cgroup_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(sev_cgroup_setup);
+
+/**
+ * sev_cgroup_teardown() - Release resources, no more charging/uncharging will
+ *			   happen.
+ *
+ * Context: Process context. Takes and release sev_cgroup_lock mutex.
+ */
+void sev_cgroup_teardown(void)
+{
+	mutex_lock(&sev_cgroup_lock);
+
+	kfree(sev_asids_cgroup_array);
+	sev_asids_cgroup_array = NULL;
+	sev_max_asids = 0;
+
+	mutex_unlock(&sev_cgroup_lock);
+}
+EXPORT_SYMBOL(sev_cgroup_teardown);
+
+/**
+ * sev_max_write() - Take user supplied max value limit for the cgroup.
+ * @of: Handler for the file.
+ * @buf: Data from the user.
+ * @nbytes: Number of bytes of the data.
+ * @off: Offset in the file.
+ *
+ * Context: Process context. Takes and release sev_cgroup_lock mutex.
+ * Return:
+ * * >= 0 - Number of bytes read in the buffer.
+ * * -EINVAL - If @buf is lower than the current usage, negative, exceeds max
+ *	       value of u32, or not a number.
+ */
+static ssize_t sev_max_write(struct kernfs_open_file *of, char *buf,
+			     size_t nbytes, loff_t off)
+{
+	struct sev_cgroup *sevcg;
+	unsigned int max;
+	int err;
+
+	buf = strstrip(buf);
+	if (!strcmp(buf, MAX_SEV_ASIDS_STR)) {
+		max = UINT_MAX;
+	} else {
+		err = kstrtouint(buf, 0, &max);
+		if (err)
+			return err;
+	}
+
+	sevcg = css_sev(of_css(of));
+
+	mutex_lock(&sev_cgroup_lock);
+
+	if (max < sevcg->usage) {
+		mutex_unlock(&sev_cgroup_lock);
+		return -EINVAL;
+	}
+
+	sevcg->max = max;
+
+	mutex_unlock(&sev_cgroup_lock);
+	return nbytes;
+}
+
+/**
+ * sev_max_show() - Print the current max limit in the cgroup.
+ * @sf: Interface file
+ * @v: Arguments passed
+ *
+ * Context: Any context.
+ * @Return: 0 to denote successful print.
+ */
+static int sev_max_show(struct seq_file *sf, void *v)
+{
+	unsigned int max = css_sev(seq_css(sf))->max;
+
+	if (max == UINT_MAX)
+		seq_printf(sf, "%s\n", MAX_SEV_ASIDS_STR);
+	else
+		seq_printf(sf, "%u\n", max);
+
+	return 0;
+}
+
+/**
+ * sev_current() - Get the current usage of SEV ASIDs in the cgroup.
+ * @css: cgroup subsys state object
+ * @cft: Handler for cgroup interface file
+ *
+ * Context: Any context.
+ * Return: Current count of SEV ASIDs used in the cgroup.
+ */
+static u64 sev_current(struct cgroup_subsys_state *css, struct cftype *cft)
+{
+	return css_sev(css)->usage;
+}
+
+/**
+ * sev_events() - Show the tally of events that occurred in the SEV cgroup.
+ * @sf: Interface file.
+ * @v: Arguments passed.
+ *
+ * Context: Any context.
+ * Return: 0 to denote the successful print.
+ */
+static int sev_events(struct seq_file *sf, void *v)
+{
+	struct cgroup_subsys_state *css = seq_css(sf);
+
+	seq_printf(sf, "max %lu\n", css_sev(css)->allocation_failure_event);
+	return 0;
+}
+
+/* sev cgroup interface files */
+static struct cftype sev_files[] = {
+	{
+		/* Maximum count of SEV ASIDs allowed */
+		.name = "max",
+		.write = sev_max_write,
+		.seq_show = sev_max_show,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{
+		/* Current usage of SEV ASIDs */
+		.name = "current",
+		.read_u64 = sev_current,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{
+		/*
+		 * Flat keyed event file.
+		 *
+		 * max %allocation_failure_event
+		 *    Number of times SEV ASIDs not allocated because current
+		 *    usage reached the max limit
+		 */
+		.name = "events",
+		.file_offset = offsetof(struct sev_cgroup, events_file),
+		.seq_show = sev_events,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{}
+};
+
+/**
+ * sev_css_alloc() - Allocate a sev cgroup node in the cgroup hieararchy.
+ * @parent_css: cgroup subsys state of the parent cgroup node.
+ *
+ * Context: Process context.
+ * Return:
+ * * struct cgroup_subsys_state * - Pointer to css field of struct sev_cgroup.
+ * * ERR_PTR(-ENOMEM) - No memory available to create sev_cgroup node.
+ */
+static struct cgroup_subsys_state *
+sev_css_alloc(struct cgroup_subsys_state *parent_css)
+{
+	struct sev_cgroup *sevcg;
+
+	sevcg = kzalloc(sizeof(*sevcg), GFP_KERNEL);
+	if (!sevcg)
+		return ERR_PTR(-ENOMEM);
+
+	sevcg->max = UINT_MAX;
+	sevcg->usage = 0;
+	sevcg->allocation_failure_event = 0;
+
+	return &sevcg->css;
+}
+
+/**
+ * sev_css_free() - Free the sev_cgroup that @css belongs to.
+ * @css: cgroup subsys state object
+ *
+ * Context: Any context.
+ */
+static void sev_css_free(struct cgroup_subsys_state *css)
+{
+	kfree(css_sev(css));
+}
+
+/**
+ * sev_css_offline() - cgroup is killed, move charges to parent.
+ * @css: css of the killed cgroup.
+ *
+ * Since charges do not migrate when the task moves, a killed css might have
+ * charges. Update the sev_asids_cgroup_array to point to the @css->parent.
+ * Parent is already charged in sev_asid_try_charge(), so its usage need not
+ * change.
+ *
+ * Context: Process context. Takes and release sev_cgroup_lock mutex.
+ */
+static void sev_css_offline(struct cgroup_subsys_state *css)
+{
+	struct sev_cgroup *sevcg, *parentcg;
+	int i;
+
+	if (!css->parent)
+		return;
+
+	sevcg = css_sev(css);
+
+	mutex_lock(&sev_cgroup_lock);
+
+	if (!sevcg->usage) {
+		mutex_unlock(&sev_cgroup_lock);
+		return;
+	}
+
+	parentcg = parent_sev_cgroup(sevcg);
+
+	for (i = 0; i < sev_max_asids; i++) {
+		if (sev_asids_cgroup_array[i] == sevcg)
+			sev_asids_cgroup_array[i] = parentcg;
+	}
+
+	mutex_unlock(&sev_cgroup_lock);
+}
+
+struct cgroup_subsys sev_cgrp_subsys = {
+	.css_alloc = sev_css_alloc,
+	.css_free = sev_css_free,
+	.css_offline = sev_css_offline,
+	.legacy_cftypes = sev_files,
+	.dfl_cftypes = sev_files
+};
diff --git a/arch/x86/kvm/svm/sev_cgroup.h b/arch/x86/kvm/svm/sev_cgroup.h
new file mode 100644
index 000000000000..d2d69870a005
--- /dev/null
+++ b/arch/x86/kvm/svm/sev_cgroup.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * SEV cgroup interface for charging and uncharging the cgroup.
+ *
+ * Copyright 2020 Google LLC
+ * Author: Vipin Sharma <vipinsh@google.com>
+ */
+
+#ifndef _SEV_CGROUP_H_
+#define _SEV_CGROUP_H_
+
+#ifdef CONFIG_CGROUP_SEV
+
+int sev_asid_try_charge(int pos);
+void sev_asid_uncharge(int pos);
+int sev_cgroup_setup(unsigned int max);
+void sev_cgroup_teardown(void);
+
+#else /* CONFIG_CGROUP_SEV */
+
+static inline int sev_asid_try_charge(int pos)
+{
+	return 0;
+}
+
+static inline void sev_asid_uncharge(int pos)
+{
+}
+
+static inline int sev_cgroup_setup(unsigned int max)
+{
+	return 0;
+}
+
+static inline void sev_cgroup_teardown(void)
+{
+}
+#endif /* CONFIG_CGROUP_SEV */
+
+#endif /* _SEV_CGROUP_H_ */
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index acb77dcff3b4..d21a5b4a2037 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -61,6 +61,9 @@ SUBSYS(pids)
 SUBSYS(rdma)
 #endif
 
+#if IS_ENABLED(CONFIG_CGROUP_SEV)
+SUBSYS(sev)
+#endif
 /*
  * The following subsystems are not supported on the default hierarchy.
  */
diff --git a/init/Kconfig b/init/Kconfig
index d6a0b31b13dc..1a57c362b803 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1101,6 +1101,20 @@ config CGROUP_BPF
 	  BPF_CGROUP_INET_INGRESS will be executed on the ingress path of
 	  inet sockets.
 
+config CGROUP_SEV
+	bool "SEV ASID controller"
+	depends on KVM_AMD_SEV
+	default n
+	help
+	  Provides a controller for AMD SEV ASIDs. This controller limits and
+	  shows the total usage of SEV ASIDs used in encrypted VMs on AMD
+	  processors. Whenever a new encrypted VM is created using SEV on an
+	  AMD processor, this controller will check the current limit in the
+	  cgroup to which the task belongs and will deny the SEV ASID if the
+	  cgroup has already reached its limit.
+
+	  Say N if unsure.
+
 config CGROUP_DEBUG
 	bool "Debug controller"
 	default n
-- 
2.28.0.681.g6f77f65b4e-goog

