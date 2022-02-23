Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67234C0BF1
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238190AbiBWFZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238198AbiBWFZe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:25:34 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABAA769CC1
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:30 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id r14-20020a5b018e000000b00624f6f97bf4so306800ybl.12
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ObwiCZnkzVE8MG/ZKfaaMbJx1EDS+iQex1h+i9r1lWc=;
        b=gZ9xDnCTT9J2il7FQZjHDQXU7P24qq79E3XEa26PGLeqDS7nHRklN55Z0YrbQllfvk
         a54Tnc7QS05X1TZviBvKI6s2J4e0JaxU2Mc4n2JddMKt6uhs1bA5ThP/H5jQeUIa+Q5L
         YzXtSBRLRL23nYFayWpilSuGrgyaEtzeVJtrSMs+fJOYlGhJTGeNFUiGfho3OKAJCQvL
         xqhDtH8EyJDw3FY1cTPmzwnJaSBjdeIgm+usm4Xbnvmu4zwwAyO/ya/YpXR5JHhjT9H0
         Wpbgj5s5UiyqBd60tJZ8fxwBXyX5DCw1p9aGG11pd0ckG2SC7DJ9q4R1uxUVnHb2V4YR
         +hNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ObwiCZnkzVE8MG/ZKfaaMbJx1EDS+iQex1h+i9r1lWc=;
        b=AWsNfPWsMKftFcIBOdPA0BMClcVDH9yRvXHNNuWjBwjytdeFD6BJoiTXUiyvnnVYOz
         jTCPBEREyV6RL/s03xvAX4pvJPGHyT0Zm21F1S83kZgmfEB9ON+tnIQ1V1euY3dTgMqF
         LRq7SRJ9WN/zkasPZlaOiGYj9/2+H6yxL5aTUrMjs+ggVM1T+4EyXUpxi5SX5BYClzQZ
         Cjqxqf7EeijOEQMal0ZZP5Kd2BtqfFv//4zUm81uODX51vXcHkFoX53FtONghmXGh3vj
         uIgYm18HRqJloXXPui3PZZDqKJhmSNOCgkh3iJV6Et5glfz1CcC5bJejpn/wft7Nn8+y
         2tvQ==
X-Gm-Message-State: AOAM530blU1/rHLvAHU1g5/pjhn3lA305S4Rxl+Wf+I6OOs/gBjmOpvs
        rIuUQYIP7gab0m0WZPSo98K76Sj4j2Xk
X-Google-Smtp-Source: ABdhPJwnMSRMCv1r9WCSdtorggC4aqKc4d1lpyRHc4R/HT3Ens8gLxTDNQT3s1kJiX6qfOat6YB18uabGISu
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a0d:db0d:0:b0:2d0:e912:3e47 with SMTP id
 d13-20020a0ddb0d000000b002d0e9123e47mr27008531ywe.23.1645593857064; Tue, 22
 Feb 2022 21:24:17 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:21:50 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-15-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 14/47] mm: asi: Disable ASI API when ASI is not enabled
 for a process
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

If ASI is not enabled for a process, then asi_init() will return a NULL
ASI pointer as output, though it will return a 0 error code. All other
ASI API functions will return without an error when they get a NULL ASI
pointer.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 arch/x86/include/asm/asi.h |  2 +-
 arch/x86/mm/asi.c          | 18 ++++++++++--------
 include/asm-generic/asi.h  |  7 ++++++-
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index 64c2b4d1dba2..f69e1f2f09a4 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -51,7 +51,7 @@ int  asi_register_class(const char *name, uint flags,
 			const struct asi_hooks *ops);
 void asi_unregister_class(int index);
 
-int  asi_init(struct mm_struct *mm, int asi_index);
+int  asi_init(struct mm_struct *mm, int asi_index, struct asi **out_asi);
 void asi_destroy(struct asi *asi);
 
 void asi_enter(struct asi *asi);
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index ca50a32ecd7e..58d1c532274a 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -207,11 +207,13 @@ static int __init asi_global_init(void)
 }
 subsys_initcall(asi_global_init)
 
-int asi_init(struct mm_struct *mm, int asi_index)
+int asi_init(struct mm_struct *mm, int asi_index, struct asi **out_asi)
 {
 	struct asi *asi = &mm->asi[asi_index];
 
-	if (!boot_cpu_has(X86_FEATURE_ASI))
+	*out_asi = NULL;
+
+	if (!boot_cpu_has(X86_FEATURE_ASI) || !mm->asi_enabled)
 		return 0;
 
 	/* Index 0 is reserved for special purposes. */
@@ -238,13 +240,15 @@ int asi_init(struct mm_struct *mm, int asi_index)
 			set_pgd(asi->pgd + i, asi_global_nonsensitive_pgd[i]);
 	}
 
+	*out_asi = asi;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(asi_init);
 
 void asi_destroy(struct asi *asi)
 {
-	if (!boot_cpu_has(X86_FEATURE_ASI))
+	if (!boot_cpu_has(X86_FEATURE_ASI) || !asi)
 		return;
 
 	asi_free_pgd(asi);
@@ -278,11 +282,9 @@ void __asi_enter(void)
 
 void asi_enter(struct asi *asi)
 {
-	if (!static_cpu_has(X86_FEATURE_ASI))
+	if (!static_cpu_has(X86_FEATURE_ASI) || !asi)
 		return;
 
-	VM_WARN_ON_ONCE(!asi);
-
 	this_cpu_write(asi_cpu_state.target_asi, asi);
 	barrier();
 
@@ -423,7 +425,7 @@ int asi_map_gfp(struct asi *asi, void *addr, size_t len, gfp_t gfp_flags)
 	size_t end = start + len;
 	size_t page_size;
 
-	if (!static_cpu_has(X86_FEATURE_ASI))
+	if (!static_cpu_has(X86_FEATURE_ASI) || !asi)
 		return 0;
 
 	VM_BUG_ON(start & ~PAGE_MASK);
@@ -514,7 +516,7 @@ void asi_unmap(struct asi *asi, void *addr, size_t len, bool flush_tlb)
 	size_t end = start + len;
 	pgtbl_mod_mask mask = 0;
 
-	if (!static_cpu_has(X86_FEATURE_ASI) || !len)
+	if (!static_cpu_has(X86_FEATURE_ASI) || !asi || !len)
 		return;
 
 	VM_BUG_ON(start & ~PAGE_MASK);
diff --git a/include/asm-generic/asi.h b/include/asm-generic/asi.h
index f918cd052722..51c9c4a488e8 100644
--- a/include/asm-generic/asi.h
+++ b/include/asm-generic/asi.h
@@ -33,7 +33,12 @@ static inline void asi_unregister_class(int asi_index) { }
 
 static inline void asi_init_mm_state(struct mm_struct *mm) { }
 
-static inline int asi_init(struct mm_struct *mm, int asi_index) { return 0; }
+static inline
+int asi_init(struct mm_struct *mm, int asi_index, struct asi **out_asi)
+{
+	*out_asi = NULL;
+	return 0;
+}
 
 static inline void asi_destroy(struct asi *asi) { }
 
-- 
2.35.1.473.g83b2b277ed-goog

