Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20FC4C0BA9
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238054AbiBWFYa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:24:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238008AbiBWFYY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:24:24 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9510569CF9
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:23:57 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id m10-20020a25800a000000b0061daa5b7151so26448948ybk.10
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LI1Qxw8YovJHKPYFPYoCf4datmDsbayp3z46DL8Kp8Q=;
        b=U7xDPHt7nJyB2GTAgVc+5mVNa5D9AiEIkeTSJpYyuShkSe5G+Xo37Cmu4z2S0ODbd3
         Wm5Eeq8cvy6TNvAv3A7bWuNv++i7NTg2KMLHM/m4eHjfRoQqwVJ2y/Yi5MDF7xrDbsQI
         j5wRAvkCT4cYk3Bc/Ve5H0pU1FD7r6VuCExamGfvXcE67Mlg9W1l1RFlwTf48DP0g9j8
         zrQbvmaWMqoIe6J4oo0xoCcquiVzfC7OAHWIqYk7V7cZwcAdfqwpYM8UaM/ZPk1iYlJM
         o8gS8/KkwFxTjJeXBM9VLMqxRp+ccKcT56QtTvv+HXupkPEETHBW4Z+e7zRt00MQFKUT
         ixgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LI1Qxw8YovJHKPYFPYoCf4datmDsbayp3z46DL8Kp8Q=;
        b=FbK5yWGvXJYtq9EkuH9FvfR6Dv76h00fM/cKLszRybhOYT4uiz40zVApmxQ7wUsPLj
         JQt6IkPVxL4rW5i9pDTa+rmA/0yNmcIRXYuZ9odP9ozvfJ8AFxXj4UDbpuZVK61cjVoq
         mPEMO/Oj5JO8n3hRZADUmw254+rloG/zznVo9IjmuY9XHozjcJMd7mi31dejTj4TDyIN
         T6r4wt0LsmgSS8yG7DY162b0D+4IW5stnML2t7q3hdVDT2ar7GCxPl9KywlqBK19LvaV
         Z31xFBJx3Ldci73nZSRy4zsgB7diSq8Tj4pb1OJpznptT2naM9V9FkcoKe4IqRHNqWaU
         fQDg==
X-Gm-Message-State: AOAM533VqD5KFtXmiWQYsj85NPf5bK1tylR+iWNUMI8MllOm2Jvwl/fe
        Qv+XvkvrtBx/SHJE359PWYd4iQNTD60R
X-Google-Smtp-Source: ABdhPJxfznelYhWgkiOo62fJh4kZWSbldwDVUL5AZ4s809e7D3FsyXFvg8XSNCQZyLZ5Vxg+VGGrfUoGnpy5
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a81:5cc3:0:b0:2d0:a2d0:9c0e with SMTP id
 q186-20020a815cc3000000b002d0a2d09c0emr27666033ywb.270.1645593836836; Tue, 22
 Feb 2022 21:23:56 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:21:41 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-6-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 05/47] mm: asi: Make __get_current_cr3_fast() ASI-aware
From:   Junaid Shahid <junaids@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        pjt@google.com, oweisse@google.com, alexandre.chartre@oracle.com,
        rppt@linux.ibm.com, dave.hansen@linux.intel.com,
        peterz@infradead.org, tglx@linutronix.de, luto@kernel.org,
        linux-mm@kvack.org
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

When ASI is active, __get_current_cr3_fast() adjusts the returned CR3
value accordingly to reflect the actual ASI CR3.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 arch/x86/include/asm/asi.h |  7 +++++++
 arch/x86/mm/tlb.c          | 20 ++++++++++++++++++--
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index 7702332c62e8..95557211dabd 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -112,6 +112,11 @@ static inline void asi_intr_exit(void)
 	}
 }
 
+static inline pgd_t *asi_pgd(struct asi *asi)
+{
+	return asi->pgd;
+}
+
 #else	/* CONFIG_ADDRESS_SPACE_ISOLATION */
 
 static inline void asi_intr_enter(void) { }
@@ -120,6 +125,8 @@ static inline void asi_intr_exit(void) { }
 
 static inline void asi_init_thread_state(struct thread_struct *thread) { }
 
+static inline pgd_t *asi_pgd(struct asi *asi) { return NULL; }
+
 #endif	/* CONFIG_ADDRESS_SPACE_ISOLATION */
 
 #endif
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 88d9298720dc..25bee959d1d3 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -17,6 +17,7 @@
 #include <asm/cacheflush.h>
 #include <asm/apic.h>
 #include <asm/perf_event.h>
+#include <asm/asi.h>
 
 #include "mm_internal.h"
 
@@ -1073,12 +1074,27 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end)
  */
 unsigned long __get_current_cr3_fast(void)
 {
-	unsigned long cr3 = build_cr3(this_cpu_read(cpu_tlbstate.loaded_mm)->pgd,
-		this_cpu_read(cpu_tlbstate.loaded_mm_asid));
+	unsigned long cr3;
+	pgd_t *pgd;
+	u16 asid = this_cpu_read(cpu_tlbstate.loaded_mm_asid);
+	struct asi *asi = asi_get_current();
+
+	if (asi)
+		pgd = asi_pgd(asi);
+	else
+		pgd = this_cpu_read(cpu_tlbstate.loaded_mm)->pgd;
+
+	cr3 = build_cr3(pgd, asid);
 
 	/* For now, be very restrictive about when this can be called. */
 	VM_WARN_ON(in_nmi() || preemptible());
 
+	/*
+	 * CR3 is unstable if the target ASI is unrestricted
+	 * and a restricted ASI is currently loaded.
+	 */
+	VM_WARN_ON_ONCE(asi && asi_is_target_unrestricted());
+
 	VM_BUG_ON(cr3 != __read_cr3());
 	return cr3;
 }
-- 
2.35.1.473.g83b2b277ed-goog

