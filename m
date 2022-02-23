Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4E84C0BEA
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238196AbiBWFZm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:25:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238213AbiBWFZC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:25:02 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3A16D3BC
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:22 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id o5-20020a25d705000000b0062499d760easo8076797ybg.7
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=J1PJHeAg+5GsFDWdvzoAJvbqIGqngaUErLJYlufPa+k=;
        b=E8ylcvEY7HObuUi7YReOD7Xi+5ii//8STuZIJO/P8zS7AqqFvr59ONAjhLdHaJFCVd
         ANMtkHwUkTCW3M7pycyZwbgMNj908KdgtDwrheZQ6geVat7tNVM68QbPQQZm1CRl1l6l
         Y4ISDUE0Oi8e8zBW/PcuKqI33TayofpiZRwi9zPR+wcWJ0CNMO0p+82XCjaXWKVoLCcG
         P0m9VyO7WwmFPDExN5wo9Zkywpckb/NizMoYl/Y1S6i3OD/kq/dMFyBf0yRW04D/GG97
         5W9at4d8tgmUGtV7LAQny8Hl7A704zcz/QnIbquS3/UrNABcFf6svGwZpVuu40Fb0cN9
         xygg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=J1PJHeAg+5GsFDWdvzoAJvbqIGqngaUErLJYlufPa+k=;
        b=XbTLVMy4XOrIOSBHqDwGAN+qBRaXFDBz/t7OdeqVsA7MoKIpZuiENwdph6pol9VrQZ
         IvV691MwZegj3BqPSmMHIwpPT1FRA2MUI+HMGh4ZvsJ1kdc2ASdrvEsf3sXFYCI4RHOd
         +yM4Xg6nX8XOW7kYCCSIeFAQVU4l+W8s8EFEZGAhT1esPw34n77+NIsJcWfBgAGYzMew
         KoJDHu/ce/JMvzys/M5DPLimadnUs3qZP7NvXIT57HKHa8JgWX1Qbko6wKed5K2zipCo
         DgLLDoH4R2y/8KQsSTmsdu7mjrhOS7iXtMZsql6WMv0di69TW8Mzp+/Tgsu6xTSZeUHb
         P5sw==
X-Gm-Message-State: AOAM531K/zxcZLrgOx2If6O/N7WdPJ83E2OPRTjB1X8IkwR+dAO2oS8y
        FL726xW38dvaLfUBWlS76j0n00ZfQK9F
X-Google-Smtp-Source: ABdhPJwO2zSkIt0Rgd4eSBL4j29VK3OAOmCOM+xoXLfQvXzLhs6JlCYQqS7jIhDe/nPgasCVydPPru7Y6T7c
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a81:106:0:b0:2d0:e682:8a7a with SMTP id
 6-20020a810106000000b002d0e6828a7amr27939534ywb.257.1645593854910; Tue, 22
 Feb 2022 21:24:14 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:21:49 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-14-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 13/47] asi: Added ASI memory cgroup flag
From:   Junaid Shahid <junaids@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     Ofir Weisse <oweisse@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com, pjt@google.com,
        alexandre.chartre@oracle.com, rppt@linux.ibm.com,
        dave.hansen@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, luto@kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ofir Weisse <oweisse@google.com>

Adds a cgroup flag to control if ASI is enabled for processes in
that cgroup.

Can be set or cleared by writing to the memory.use_asi file in the
memory cgroup. The flag only affects new processes created after
the flag was set.

In addition to the cgroup flag, we may also want to add a per-process
flag, though it will have to be something that can be set at process
creation time.

Signed-off-by: Ofir Weisse <oweisse@google.com>
Co-developed-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Junaid Shahid <junaids@google.com>


---
 arch/x86/mm/asi.c          | 14 ++++++++++++++
 include/linux/memcontrol.h |  3 +++
 include/linux/mm_types.h   | 17 +++++++++++++++++
 mm/memcontrol.c            | 30 ++++++++++++++++++++++++++++++
 4 files changed, 64 insertions(+)

diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 71348399baf1..ca50a32ecd7e 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -2,6 +2,7 @@
 
 #include <linux/init.h>
 #include <linux/memblock.h>
+#include <linux/memcontrol.h>
 
 #include <asm/asi.h>
 #include <asm/pgalloc.h>
@@ -322,7 +323,20 @@ EXPORT_SYMBOL_GPL(asi_exit);
 
 void asi_init_mm_state(struct mm_struct *mm)
 {
+	struct mem_cgroup *memcg = get_mem_cgroup_from_mm(mm);
+
 	memset(mm->asi, 0, sizeof(mm->asi));
+	mm->asi_enabled = false;
+
+	/*
+	 * TODO: In addition to a cgroup flag, we may also want a per-process
+	 * flag.
+	 */
+        if (memcg) {
+		mm->asi_enabled = boot_cpu_has(X86_FEATURE_ASI) &&
+				  memcg->use_asi;
+		css_put(&memcg->css);
+	}
 }
 
 static bool is_page_within_range(size_t addr, size_t page_size,
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0c5c403f4be6..a883cb458b06 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -259,6 +259,9 @@ struct mem_cgroup {
 	 */
 	bool oom_group;
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+        bool use_asi;
+#endif
 	/* protected by memcg_oom_lock */
 	bool		oom_lock;
 	int		under_oom;
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5b8028fcfe67..8624d2783661 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -607,6 +607,14 @@ struct mm_struct {
 		 * new_owner->alloc_lock is held
 		 */
 		struct task_struct __rcu *owner;
+
+#endif
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+                /* Is ASI enabled for this mm? ASI requires allocating extra
+                 * resources, such as ASI page tables. To prevent allocationg
+                 * these resources for every mm in the system, we expect that
+                 * only VM mm's will have this flag set. */
+		bool asi_enabled;
 #endif
 		struct user_namespace *user_ns;
 
@@ -665,6 +673,15 @@ struct mm_struct {
 
 extern struct mm_struct init_mm;
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+static inline bool mm_asi_enabled(struct mm_struct *mm)
+{
+        return mm->asi_enabled;
+}
+#else
+static inline bool mm_asi_enabled(struct mm_struct *mm) { return false; }
+#endif
+
 /* Pointer magic because the dynamic array size confuses some compilers. */
 static inline void mm_init_cpumask(struct mm_struct *mm)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2ed5f2a0879d..a66d6b222ecf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3539,6 +3539,29 @@ static int mem_cgroup_hierarchy_write(struct cgroup_subsys_state *css,
 	return -EINVAL;
 }
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+
+static u64 mem_cgroup_asi_read(struct cgroup_subsys_state *css,
+				     struct cftype *cft)
+{
+        return mem_cgroup_from_css(css)->use_asi;
+}
+
+static int mem_cgroup_asi_write(struct cgroup_subsys_state *css,
+				      struct cftype *cft, u64 val)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+
+	if (val == 1 || val == 0)
+		memcg->use_asi = val;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+#endif
+
 static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 {
 	unsigned long val;
@@ -4888,6 +4911,13 @@ static struct cftype mem_cgroup_legacy_files[] = {
 		.write_u64 = mem_cgroup_hierarchy_write,
 		.read_u64 = mem_cgroup_hierarchy_read,
 	},
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	{
+		.name = "use_asi",
+		.write_u64 = mem_cgroup_asi_write,
+		.read_u64 = mem_cgroup_asi_read,
+	},
+#endif
 	{
 		.name = "cgroup.event_control",		/* XXX: for compat */
 		.write = memcg_write_event_control,
-- 
2.35.1.473.g83b2b277ed-goog

