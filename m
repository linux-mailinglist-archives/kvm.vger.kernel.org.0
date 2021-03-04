Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD6B32DDB5
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 00:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbhCDXT7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 18:19:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232894AbhCDXT4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 18:19:56 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FBAC06175F
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 15:19:55 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id v19so52667qtw.19
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 15:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=j5DRItrTgG2IWxNY43tQNghR9DPpzeVwjbizUt4DdlY=;
        b=YEczDzmnoomFQx0H3Ig7/XaMis16e/lln0TeX87D+Puz3VVdro+Ep6mSH4swfTUExI
         bMd/yeQTRf0li7ww7xgy4eTxhccfrtoiF6OylBcI/o/dLk297Fe0rR2xywi5eKb4DpII
         0WPyIi3RI4OQWjOKrw60UV+3LuQGVTmIOT6u3JqmuDejnwsiOzylE90ZnzDQv1TjtPfk
         qTr8Ui6sPDQ4PZc5XYf/HIuTJ1O58oZTubHyDquXB+QwN58TxerKBABoYq9wkG+i3QiR
         9/WHGkAP2WDKhHXWvQoEn3Hkg2oDUupOsO33nFR1RhWAmJtPFDTI7wYQazHtWSNmm0mN
         rgTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=j5DRItrTgG2IWxNY43tQNghR9DPpzeVwjbizUt4DdlY=;
        b=DuimiGrSKrM8b16MExs/v/etaEeZiaBpS3RuHs2UcrAyIu68uL5zgiHFEIe5cqxrjp
         lHCIAdODh0PU3rprusTdLJG4GOb0A6F0crViNCm2BBYAbcseg5jpAJHSs7gvevXp/QX4
         PuCtEGe0mVQPOXbA0VdOJm1sz/f2mQ/eEJNvN8p8xsCnei5H6JzwUQNK7vlbTklioqPw
         HUoq9r3jx1xWRbJeE78PfN3lxry4SLeVnCfITEi9e53d1DRbsm632IUiF83ahmAAoXDf
         B29TdrIBY5B4QR2nsOCNXfZaXGyjLZ0hWsoagdLFgZ/eBgfPxByNKnBqVA4pwGnhy6/V
         /DXA==
X-Gm-Message-State: AOAM531Bfm0XaUXtQjYIDckMZo8IwI/wkhcBna58ZchV98gY86NLQdMP
        PBajSQMlFXGJwCZpO98/8SYuEBZY9SCE
X-Google-Smtp-Source: ABdhPJxs5KLD0f8CoRthokhY8fGbfL498x3TmhFJkmIY3HCMQc2yFOGMqO4rtkS4TE7P5FBKU/73Dtv3y5hq
Sender: "vipinsh via sendgmr" <vipinsh@vipinsh.kir.corp.google.com>
X-Received: from vipinsh.kir.corp.google.com ([2620:0:1008:10:1b1:4021:52a5:84d])
 (user=vipinsh job=sendgmr) by 2002:a05:6214:76f:: with SMTP id
 f15mr6433369qvz.56.1614899994866; Thu, 04 Mar 2021 15:19:54 -0800 (PST)
Date:   Thu,  4 Mar 2021 15:19:45 -0800
In-Reply-To: <20210304231946.2766648-1-vipinsh@google.com>
Message-Id: <20210304231946.2766648-2-vipinsh@google.com>
Mime-Version: 1.0
References: <20210304231946.2766648-1-vipinsh@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [Patch v3 1/2] cgroup: sev: Add misc cgroup controller
From:   Vipin Sharma <vipinsh@google.com>
To:     tj@kernel.org, mkoutny@suse.com, rdunlap@infradead.org,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com,
        eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com
Cc:     corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        gingell@google.com, rientjes@google.com, dionnaglaze@google.com,
        kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Miscellaneous cgroup provides the resource limiting and tracking
mechanism for the scalar resources which cannot be abstracted like the
other cgroup resources. Controller is enabled by the CONFIG_CGROUP_MISC
config option.

The first two resources added to the miscellaneous controller are Secure
Encrypted Virtualization (SEV) ASIDs and SEV - Encrypted State (SEV-ES)
ASIDs. These limited ASIDs are used for encrypting virtual machines
memory on the AMD platform

Miscellaneous controller provides 3 interface files:

misc.capacity
  A read-only flat-keyed file shown only in the root cgroup.  It shows
  miscellaneous scalar resources available on the platform along with
  their quantities::

	$ cat misc.capacity
	sev 50
	sev_es 10

misc.current
  A read-only flat-keyed file shown in the non-root cgroups.  It shows
  the current usage of the resources in the cgroup and its children::

	$ cat misc.current
	sev 3
	sev_es 0

misc.max
  A read-write flat-keyed file shown in the non root cgroups. Allowed
  maximum usage of the resources in the cgroup and its children.::

	$ cat misc.max
	sev max
	sev_es 4

  Limit can be set by::

	# echo sev 1 > misc.max

  Limit can be set to max by::

	# echo sev max > misc.max

  Limits can be set more than the capacity value in the misc.capacity
  file.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Reviewed-by: David Rientjes <rientjes@google.com>
---
 arch/x86/kvm/svm/sev.c        |  65 +++++-
 arch/x86/kvm/svm/svm.h        |   1 +
 include/linux/cgroup_subsys.h |   4 +
 include/linux/misc_cgroup.h   | 130 +++++++++++
 init/Kconfig                  |  14 ++
 kernel/cgroup/Makefile        |   1 +
 kernel/cgroup/misc.c          | 402 ++++++++++++++++++++++++++++++++++
 7 files changed, 607 insertions(+), 10 deletions(-)
 create mode 100644 include/linux/misc_cgroup.h
 create mode 100644 kernel/cgroup/misc.c

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 48017fef1cd9..dd05a1522862 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -14,6 +14,7 @@
 #include <linux/psp-sev.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
+#include <linux/misc_cgroup.h>
 #include <linux/processor.h>
 #include <linux/trace_events.h>
 #include <asm/fpu/internal.h>
@@ -27,6 +28,21 @@
 
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
+#ifndef CONFIG_KVM_AMD_SEV
+/*
+ * When this config is not defined, SEV feature is not supported and APIs in
+ * this file are not used but this file still gets compiled into the KVM AMD
+ * module.
+ *
+ * We will not have MISC_CG_RES_SEV and MISC_CG_RES_SEV_ES entries in the enum
+ * misc_res_type {} defined in linux/misc_cgroup.h.
+ *
+ * Below macros allow compilation to succeed.
+ */
+#define MISC_CG_RES_SEV MISC_CG_RES_TYPES
+#define MISC_CG_RES_SEV_ES MISC_CG_RES_TYPES
+#endif
+
 static u8 sev_enc_bit;
 static int sev_flush_asids(void);
 static DECLARE_RWSEM(sev_deactivate_lock);
@@ -88,8 +104,17 @@ static bool __sev_recycle_asids(int min_asid, int max_asid)
 
 static int sev_asid_new(struct kvm_sev_info *sev)
 {
-	int pos, min_asid, max_asid;
+	int pos, min_asid, max_asid, ret;
 	bool retry = true;
+	enum misc_res_type type;
+
+	type = sev->es_active ? MISC_CG_RES_SEV_ES : MISC_CG_RES_SEV;
+	sev->misc_cg = get_current_misc_cg();
+	ret = misc_cg_try_charge(type, sev->misc_cg, 1);
+	if (ret) {
+		put_misc_cg(sev->misc_cg);
+		return ret;
+	}
 
 	mutex_lock(&sev_bitmap_lock);
 
@@ -107,7 +132,8 @@ static int sev_asid_new(struct kvm_sev_info *sev)
 			goto again;
 		}
 		mutex_unlock(&sev_bitmap_lock);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto e_uncharge;
 	}
 
 	__set_bit(pos, sev_asid_bitmap);
@@ -115,6 +141,10 @@ static int sev_asid_new(struct kvm_sev_info *sev)
 	mutex_unlock(&sev_bitmap_lock);
 
 	return pos + 1;
+e_uncharge:
+	misc_cg_uncharge(type, sev->misc_cg, 1);
+	put_misc_cg(sev->misc_cg);
+	return ret;
 }
 
 static int sev_get_asid(struct kvm *kvm)
@@ -124,14 +154,15 @@ static int sev_get_asid(struct kvm *kvm)
 	return sev->asid;
 }
 
-static void sev_asid_free(int asid)
+static void sev_asid_free(struct kvm_sev_info *sev)
 {
 	struct svm_cpu_data *sd;
 	int cpu, pos;
+	enum misc_res_type type;
 
 	mutex_lock(&sev_bitmap_lock);
 
-	pos = asid - 1;
+	pos = sev->asid - 1;
 	__set_bit(pos, sev_reclaim_asid_bitmap);
 
 	for_each_possible_cpu(cpu) {
@@ -140,6 +171,10 @@ static void sev_asid_free(int asid)
 	}
 
 	mutex_unlock(&sev_bitmap_lock);
+
+	type = sev->es_active ? MISC_CG_RES_SEV_ES : MISC_CG_RES_SEV;
+	misc_cg_uncharge(type, sev->misc_cg, 1);
+	put_misc_cg(sev->misc_cg);
 }
 
 static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
@@ -187,19 +222,19 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	asid = sev_asid_new(sev);
 	if (asid < 0)
 		return ret;
+	sev->asid = asid;
 
 	ret = sev_platform_init(&argp->error);
 	if (ret)
 		goto e_free;
 
 	sev->active = true;
-	sev->asid = asid;
 	INIT_LIST_HEAD(&sev->regions_list);
 
 	return 0;
 
 e_free:
-	sev_asid_free(asid);
+	sev_asid_free(sev);
 	return ret;
 }
 
@@ -1243,12 +1278,12 @@ void sev_vm_destroy(struct kvm *kvm)
 	mutex_unlock(&kvm->lock);
 
 	sev_unbind_asid(kvm, sev->handle);
-	sev_asid_free(sev->asid);
+	sev_asid_free(sev);
 }
 
 void __init sev_hardware_setup(void)
 {
-	unsigned int eax, ebx, ecx, edx;
+	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
 
@@ -1280,7 +1315,11 @@ void __init sev_hardware_setup(void)
 	if (!sev_reclaim_asid_bitmap)
 		goto out;
 
-	pr_info("SEV supported: %u ASIDs\n", max_sev_asid - min_sev_asid + 1);
+	sev_asid_count = max_sev_asid - min_sev_asid + 1;
+	if (misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count))
+		goto out;
+
+	pr_info("SEV supported: %u ASIDs\n", sev_asid_count);
 	sev_supported = true;
 
 	/* SEV-ES support requested? */
@@ -1295,7 +1334,11 @@ void __init sev_hardware_setup(void)
 	if (min_sev_asid == 1)
 		goto out;
 
-	pr_info("SEV-ES supported: %u ASIDs\n", min_sev_asid - 1);
+	sev_es_asid_count = min_sev_asid - 1;
+	if (misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count))
+		goto out;
+
+	pr_info("SEV-ES supported: %u ASIDs\n", sev_es_asid_count);
 	sev_es_supported = true;
 
 out:
@@ -1310,6 +1353,8 @@ void sev_hardware_teardown(void)
 
 	bitmap_free(sev_asid_bitmap);
 	bitmap_free(sev_reclaim_asid_bitmap);
+	misc_cg_set_capacity(MISC_CG_RES_SEV, 0);
+	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
 
 	sev_flush_asids();
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6e7d070f8b86..8ed6ebf47885 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -79,6 +79,7 @@ struct kvm_sev_info {
 	unsigned long pages_locked; /* Number of pages locked */
 	struct list_head regions_list;  /* List of registered regions */
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
+	struct misc_cg *misc_cg; /* For misc cgroup accounting */
 };
 
 struct kvm_svm {
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
index 000000000000..c807840c9238
--- /dev/null
+++ b/include/linux/misc_cgroup.h
@@ -0,0 +1,130 @@
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
+#ifdef CONFIG_KVM_AMD_SEV
+	/* AMD SEV ASIDs resource */
+	MISC_CG_RES_SEV,
+	/* AMD SEV-ES ASIDs resource */
+	MISC_CG_RES_SEV_ES,
+#endif
+	MISC_CG_RES_TYPES
+};
+
+struct misc_cg;
+
+#ifdef CONFIG_CGROUP_MISC
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
index 29ad68325028..0b392135e555 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1105,6 +1105,20 @@ config CGROUP_BPF
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
index 000000000000..393d66c0b933
--- /dev/null
+++ b/kernel/cgroup/misc.c
@@ -0,0 +1,402 @@
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
+#ifdef CONFIG_KVM_AMD_SEV
+	"sev",
+	"sev_es",
+#endif
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
+EXPORT_SYMBOL(misc_cg_res_total_usage);
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
+	misc_res_capacity[type] = capacity;
+	return 0;
+}
+EXPORT_SYMBOL(misc_cg_set_capacity);
+
+/**
+ * misc_cg_reduce_charge() - Reduce the charge from the misc cgroup.
+ * @type: Misc res type in misc cg to reduce the charge from.
+ * @cg: Misc cgroup to reduce charge from.
+ * @amount: Amount to reduce.
+ *
+ * Context: Any context.
+ */
+static void misc_cg_reduce_charge(enum misc_res_type type, struct misc_cg *cg,
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
+	if (!(valid_type(type) && cg && misc_res_capacity[type]))
+		return -EINVAL;
+
+	if (!amount)
+		return 0;
+
+	for (i = cg; i; i = parent_misc(i)) {
+		res = &i->res[type];
+
+		new_usage = atomic_long_add_return(amount, &res->usage);
+		if (new_usage > res->max ||
+		    new_usage > misc_res_capacity[type]) {
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
+		misc_cg_reduce_charge(type, j, amount);
+	misc_cg_reduce_charge(type, i, amount);
+	return ret;
+}
+EXPORT_SYMBOL(misc_cg_try_charge);
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
+		misc_cg_reduce_charge(type, i, amount);
+}
+EXPORT_SYMBOL(misc_cg_uncharge);
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
+
+	for (i = 0; i < MISC_CG_RES_TYPES; i++) {
+		if (misc_res_capacity[i]) {
+			if (cg->res[i].max == MAX_NUM)
+				seq_printf(sf, "%s max\n", misc_res_name[i]);
+			else
+				seq_printf(sf, "%s %lu\n", misc_res_name[i],
+					   cg->res[i].max);
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
+		max = ULONG_MAX;
+	} else {
+		ret = kstrtoul(buf, 0, &max);
+		if (ret)
+			return ret;
+	}
+
+	cg = css_misc(of_css(of));
+
+	if (misc_res_capacity[type])
+		cg->res[type].max = max;
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
+	struct misc_cg *cg = css_misc(seq_css(sf));
+
+	for (i = 0; i < MISC_CG_RES_TYPES; i++) {
+		if (misc_res_capacity[i])
+			seq_printf(sf, "%s %lu\n", misc_res_name[i],
+				   atomic_long_read(&cg->res[i].usage));
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
+		cg->res[i].max = MAX_NUM;
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
2.30.1.766.gb4fecdf3b7-goog

