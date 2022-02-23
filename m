Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47AD94C0BF5
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238329AbiBWF02 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238325AbiBWFZl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:25:41 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A0D6D87A
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:48 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id b11-20020a5b008b000000b00624ea481d55so2532575ybp.19
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eHvI/S5CbFiuxrTOsf9OKECf8MKQA40+sVHVsgBWXTI=;
        b=V0N2AQ61NCzV6BZmqiQxUYs5pGX63pZ6VVRWlptLLGQUiVMxzlkVsCzNfrYnsMXVug
         KGkm/PYQEu9If/h+TwyTP773A843C1vccvswNpzQzC+CWF0lyH9rv4lYVpwygBHxjjxF
         KtfQ48TD03/CH3MJc6uQdii7U/orjcd6yROvM49vbkxsBatJT7hHIeSSgYOHhBpNRFtZ
         ikDCPeVq4k3/1dGPRt9rMDvqd7qp2qvlw0rdUxHJz6cMzz6PpmzwFKFFGSl65Hota3P/
         hcaYP68KMD05XrecJbTtx+liHxuoMDRkdxyvRDaTUelX+R7q43SiNNrm4qp+y/niXgLp
         +m3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eHvI/S5CbFiuxrTOsf9OKECf8MKQA40+sVHVsgBWXTI=;
        b=dHIUEeSOMx5fnegQGm9viOJITsXM9581abAF2WcUl6gXXpWhpmFbUS22vg3tzVXEhG
         1x6tlFQwiWQshnNxNBFmRQumZU5Uxy9w9ZZU3FgcL4rF+1WAPEatAXvWpjzAsctH1ikb
         Md+/RFnKJLuX1QSnvvlVMscI9nHftb5VAhyvCmj9grP1h8+uehgEgNc2OMALmwo0Ft9e
         3kqqWWuHqCSibAf+xzX/YqlWFFicglnIYHR1m7yJx8P9mg0Gio4Dt1yYGrmCkomKeyOU
         iAKGBMqI0WribylqJ1C6Jrigqt4ozN7aD3F7wNVFEbc7WWLZ7DDNrryyZKI6SA7T+MR6
         989g==
X-Gm-Message-State: AOAM5338lUPABtvbk0mt+IAYKR0WDHeXZNHndKxCg64Go9P2UTLMaOn5
        BJByu6V1C35z32iOLIArgYgYsOQn3+rr
X-Google-Smtp-Source: ABdhPJylISnqnK8ITQ9nblGksWK/PwAayD9axmVlFF61BCPqFWoHn9afvvtl0MNwA3JR60UblOXBCmfjIzzy
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a81:7951:0:b0:2d6:b7bf:216a with SMTP id
 u78-20020a817951000000b002d6b7bf216amr24436525ywc.258.1645593874907; Tue, 22
 Feb 2022 21:24:34 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:21:58 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-23-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 22/47] mm: asi: Added refcounting when initilizing an asi
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

Some KVM tests initilize multiple VMs in a single process. For these
cases, we want to suppurt multiple callse to asi_init() before a single
asi_destroy is called. We want the initilization to happen exactly once.
IF asi_destroy() is called, release the resources only if the counter
reached zero. In our current implementation, asi's are tied to
a specific mm. This may change in a future implementation. In which
case, the mutex for the refcounting will need to move to struct asi.

Signed-off-by: Ofir Weisse <oweisse@google.com>


---
 arch/x86/include/asm/asi.h |  1 +
 arch/x86/mm/asi.c          | 52 +++++++++++++++++++++++++++++++++-----
 include/linux/mm_types.h   |  2 ++
 kernel/fork.c              |  3 +++
 4 files changed, 51 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index e3cbf6d8801e..2dc465f78bcc 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -40,6 +40,7 @@ struct asi {
 	pgd_t *pgd;
 	struct asi_class *class;
 	struct mm_struct *mm;
+        int64_t asi_ref_count;
 };
 
 DECLARE_PER_CPU_ALIGNED(struct asi_state, asi_cpu_state);
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 91e5ff1224ff..ac35323193a3 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -282,9 +282,25 @@ static int __init asi_global_init(void)
 }
 subsys_initcall(asi_global_init)
 
+/* We're assuming we hold mm->asi_init_lock */
+static void __asi_destroy(struct asi *asi)
+{
+	if (!boot_cpu_has(X86_FEATURE_ASI))
+		return;
+
+        /* If refcount is non-zero, it means asi_init() was called multiple
+         * times. We free the asi pgd only when the last VM is destroyed. */
+        if (--(asi->asi_ref_count) > 0)
+                return;
+
+	asi_free_pgd(asi);
+	memset(asi, 0, sizeof(struct asi));
+}
+
 int asi_init(struct mm_struct *mm, int asi_index, struct asi **out_asi)
 {
-	struct asi *asi = &mm->asi[asi_index];
+        int err = 0;
+        struct asi *asi = &mm->asi[asi_index];
 
 	*out_asi = NULL;
 
@@ -295,6 +311,15 @@ int asi_init(struct mm_struct *mm, int asi_index, struct asi **out_asi)
 	WARN_ON(asi_index == 0 || asi_index >= ASI_MAX_NUM);
 	WARN_ON(asi->pgd != NULL);
 
+        /* Currently, mm and asi structs are conceptually tied together. In
+         * future implementations an asi object might be unrelated to a specicic
+         * mm. In that future implementation - the mutex will have to be inside
+         * asi. */
+	mutex_lock(&mm->asi_init_lock);
+
+        if (asi->asi_ref_count++ > 0)
+                goto exit_unlock; /* err is 0 */
+
 	/*
 	 * For now, we allocate 2 pages to avoid any potential problems with
 	 * KPTI code. This won't be needed once KPTI is folded into the ASI
@@ -302,8 +327,10 @@ int asi_init(struct mm_struct *mm, int asi_index, struct asi **out_asi)
 	 */
 	asi->pgd = (pgd_t *)__get_free_pages(GFP_PGTABLE_USER,
 					     PGD_ALLOCATION_ORDER);
-	if (!asi->pgd)
-		return -ENOMEM;
+	if (!asi->pgd) {
+                err = -ENOMEM;
+		goto exit_unlock;
+        }
 
 	asi->class = &asi_class[asi_index];
 	asi->mm = mm;
@@ -328,19 +355,30 @@ int asi_init(struct mm_struct *mm, int asi_index, struct asi **out_asi)
 			set_pgd(asi->pgd + i, asi_global_nonsensitive_pgd[i]);
 	}
 
-	*out_asi = asi;
+exit_unlock:
+	if (err)
+		__asi_destroy(asi);
 
-	return 0;
+        /* This unlock signals future asi_init() callers that we finished. */
+	mutex_unlock(&mm->asi_init_lock);
+
+	if (!err)
+		*out_asi = asi;
+	return err;
 }
 EXPORT_SYMBOL_GPL(asi_init);
 
 void asi_destroy(struct asi *asi)
 {
+        struct mm_struct *mm;
+
 	if (!boot_cpu_has(X86_FEATURE_ASI) || !asi)
 		return;
 
-	asi_free_pgd(asi);
-	memset(asi, 0, sizeof(struct asi));
+        mm = asi->mm;
+        mutex_lock(&mm->asi_init_lock);
+        __asi_destroy(asi);
+        mutex_unlock(&mm->asi_init_lock);
 }
 EXPORT_SYMBOL_GPL(asi_destroy);
 
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index f9702d070975..e6980ae31323 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -16,6 +16,7 @@
 #include <linux/page-flags-layout.h>
 #include <linux/workqueue.h>
 #include <linux/seqlock.h>
+#include <linux/mutex.h>
 
 #include <asm/mmu.h>
 #include <asm/asi.h>
@@ -628,6 +629,7 @@ struct mm_struct {
                  * these resources for every mm in the system, we expect that
                  * only VM mm's will have this flag set. */
 		bool asi_enabled;
+                struct mutex asi_init_lock;
 #endif
 		struct user_namespace *user_ns;
 
diff --git a/kernel/fork.c b/kernel/fork.c
index dd5a86e913ea..68b3aeab55ac 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1084,6 +1084,9 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 
 	mm->user_ns = get_user_ns(user_ns);
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+        mutex_init(&mm->asi_init_lock);
+#endif
 	return mm;
 
 fail_noasi:
-- 
2.35.1.473.g83b2b277ed-goog

