Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47974C0BF4
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238270AbiBWF0F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:26:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237287AbiBWFZi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:25:38 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78996C938
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:39 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2d6bca75aa2so141248567b3.18
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0QeFswLcX9iEWT+ZD7rOizRcb8mHIR1VarnP+zim9mU=;
        b=AoOb1g/bwih9VgHUpDsuRj472kE7mvs4Hd5rKJ629FXGqay4OsONzwnNGCn4KSszBQ
         7tR0Ehd/9kdVBMulmZqqn0EKhuRWwo5FmNiVUwzvcobRe45iRRTjqmq29bq6BO+aH2aK
         iVFm5Q63DJUj0wcMPLNxFHfvSAy/DcNXa1BAm45xpqSab7/o/iDvyz2xnot3Gux2i/bz
         ep5/x08uO4oi4Oa/VRppWnEJLR30fLBFaY+9aHNaO68XzDzENmX6oojUDxShaZpJxCzn
         AzyiCxL/E+FUObYZMNwPUDfM+bxPv2Rn6QD88aXQUJCPLfukjGOAKhVZbWGz7HVG4WwU
         EzCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0QeFswLcX9iEWT+ZD7rOizRcb8mHIR1VarnP+zim9mU=;
        b=Y0BPN+TsAuTJQD544v2kWLrgPcdgQRhBi5lQThmRJnhwmX4+t2/UD7NrhihDJ+e1c3
         5IYDtKr7K4NRkiqqpv1zKUXVMSWO+/muHnt0P6CqJ0IEhJKzSJ9tdI8xvN9cvvg9t6mY
         iVlscWZDyBlStn0k5jjfRzbZGksYtYlkatZNvf8KgyzLUOLkUQfC+PINZsmQdMd0oH/F
         Ut2y2YkJoesu+gF2zFSJKVNLiYSe9TmlvZvx+JzRW/YkBs8BLc4G7XCKkHMWNifqLoH1
         IFJutn40oGcw1VH2LTljlrRfudgGayxSaCEuh2aYiOoxChAfc25grCFdCFONBlTD/Mhx
         hvRg==
X-Gm-Message-State: AOAM532mlaBEigmnHfgHHPufT6zNjxzaBDAFBM1yKvE+M26DGaP7o6kz
        UW5TqHZ+rZ0lJqK5XH4U7JwO1KD9ddYz
X-Google-Smtp-Source: ABdhPJx4QwVPvcY0cnBZCAO3p1suuFvqTv6OhknMLXEOsTBctmZQz9YZ5chFPkEZtJ5h60746WaCODirXSsF
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a25:6fc1:0:b0:624:43a0:c16c with SMTP id
 k184-20020a256fc1000000b0062443a0c16cmr21681170ybc.222.1645593868088; Tue, 22
 Feb 2022 21:24:28 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:21:55 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-20-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 19/47] mm: asi: Support for locally nonsensitive page allocations
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

A new GFP flag, __GFP_LOCAL_NONSENSITIVE, is added to allocate pages
that are considered non-sensitive within the context of the current
process, but sensitive in the context of other processes.

For these allocations, page->asi_mm is set to the current mm during
allocation. It must be set to the same value when the page is freed.
Though it can potentially be overwritten and used for some other
purpose in the meantime, as long as it is restored before freeing.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 include/linux/gfp.h            |  5 +++-
 include/linux/mm_types.h       | 17 ++++++++++--
 include/trace/events/mmflags.h |  1 +
 mm/page_alloc.c                | 47 ++++++++++++++++++++++++++++------
 tools/perf/builtin-kmem.c      |  1 +
 5 files changed, 60 insertions(+), 11 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 07a99a463a34..2ab394adbda3 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -62,8 +62,10 @@ struct vm_area_struct;
 #endif
 #ifdef CONFIG_ADDRESS_SPACE_ISOLATION
 #define ___GFP_GLOBAL_NONSENSITIVE 0x4000000u
+#define ___GFP_LOCAL_NONSENSITIVE  0x8000000u
 #else
 #define ___GFP_GLOBAL_NONSENSITIVE 0
+#define ___GFP_LOCAL_NONSENSITIVE 0
 #endif
 /* If the above are modified, __GFP_BITS_SHIFT may need updating */
 
@@ -255,9 +257,10 @@ struct vm_area_struct;
 
 /* Allocate non-sensitive memory */
 #define __GFP_GLOBAL_NONSENSITIVE ((__force gfp_t)___GFP_GLOBAL_NONSENSITIVE)
+#define __GFP_LOCAL_NONSENSITIVE ((__force gfp_t)___GFP_LOCAL_NONSENSITIVE)
 
 /* Room for N __GFP_FOO bits */
-#define __GFP_BITS_SHIFT 27
+#define __GFP_BITS_SHIFT 28
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
 /**
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 8624d2783661..f9702d070975 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -193,8 +193,21 @@ struct page {
 		struct rcu_head rcu_head;
 
 #ifdef CONFIG_ADDRESS_SPACE_ISOLATION
-		/* Links the pages_to_free_async list */
-		struct llist_node async_free_node;
+		struct {
+			/* Links the pages_to_free_async list */
+			struct llist_node async_free_node;
+
+			unsigned long _asi_pad_1;
+			unsigned long _asi_pad_2;
+
+			/*
+			 * Upon allocation of a locally non-sensitive page, set
+			 * to the allocating mm. Must be set to the same mm when
+			 * the page is freed. May potentially be overwritten in
+			 * the meantime, as long as it is restored before free.
+			 */
+			struct mm_struct *asi_mm;
+		};
 #endif
 	};
 
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index 96e61d838bec..c00b8a4e1968 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -51,6 +51,7 @@
 	{(unsigned long)__GFP_KSWAPD_RECLAIM,	"__GFP_KSWAPD_RECLAIM"},\
 	{(unsigned long)__GFP_ZEROTAGS,		"__GFP_ZEROTAGS"},	\
 	{(unsigned long)__GFP_SKIP_KASAN_POISON,"__GFP_SKIP_KASAN_POISON"},\
+	{(unsigned long)__GFP_LOCAL_NONSENSITIVE, "__GFP_LOCAL_NONSENSITIVE"},\
 	{(unsigned long)__GFP_GLOBAL_NONSENSITIVE, "__GFP_GLOBAL_NONSENSITIVE"}\
 
 #define show_gfp_flags(flags)						\
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a4048fa1868a..01784bff2a80 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5231,19 +5231,33 @@ early_initcall(asi_page_alloc_init);
 static int asi_map_alloced_pages(struct page *page, uint order, gfp_t gfp_mask)
 {
 	uint i;
+	struct asi *asi;
+
+	VM_BUG_ON((gfp_mask & (__GFP_GLOBAL_NONSENSITIVE |
+			      __GFP_LOCAL_NONSENSITIVE)) ==
+		  (__GFP_GLOBAL_NONSENSITIVE | __GFP_LOCAL_NONSENSITIVE));
 
 	if (!static_asi_enabled())
 		return 0;
 
+	if (!(gfp_mask & (__GFP_GLOBAL_NONSENSITIVE |
+			  __GFP_LOCAL_NONSENSITIVE)))
+		return 0;
+
 	if (gfp_mask & __GFP_GLOBAL_NONSENSITIVE) {
+		asi = ASI_GLOBAL_NONSENSITIVE;
 		for (i = 0; i < (1 << order); i++)
 			__SetPageGlobalNonSensitive(page + i);
-
-		return asi_map_gfp(ASI_GLOBAL_NONSENSITIVE, page_to_virt(page),
-				   PAGE_SIZE * (1 << order), gfp_mask);
+	} else {
+		asi = ASI_LOCAL_NONSENSITIVE;
+		for (i = 0; i < (1 << order); i++) {
+			__SetPageLocalNonSensitive(page + i);
+			page[i].asi_mm = current->mm;
+		}
 	}
 
-	return 0;
+	return asi_map_gfp(asi, page_to_virt(page),
+			   PAGE_SIZE * (1 << order), gfp_mask);
 }
 
 static bool asi_unmap_freed_pages(struct page *page, unsigned int order)
@@ -5251,18 +5265,28 @@ static bool asi_unmap_freed_pages(struct page *page, unsigned int order)
 	void *va;
 	size_t len;
 	bool async_flush_needed;
+	struct asi *asi;
+
+	VM_BUG_ON(PageGlobalNonSensitive(page) && PageLocalNonSensitive(page));
 
 	if (!static_asi_enabled())
 		return true;
 
-	if (!PageGlobalNonSensitive(page))
+	if (PageGlobalNonSensitive(page))
+		asi = ASI_GLOBAL_NONSENSITIVE;
+	else if (PageLocalNonSensitive(page))
+		asi = &page->asi_mm->asi[0];
+	else
 		return true;
 
+	/* Heuristic to check that page->asi_mm is actually an mm_struct */
+	VM_BUG_ON(PageLocalNonSensitive(page) && asi->mm != page->asi_mm);
+
 	va = page_to_virt(page);
 	len = PAGE_SIZE * (1 << order);
 	async_flush_needed = irqs_disabled() || in_interrupt();
 
-	asi_unmap(ASI_GLOBAL_NONSENSITIVE, va, len, !async_flush_needed);
+	asi_unmap(asi, va, len, !async_flush_needed);
 
 	if (!async_flush_needed)
 		return true;
@@ -5476,8 +5500,15 @@ struct page *__alloc_pages(gfp_t gfp, unsigned int order, int preferred_nid,
 		return NULL;
 	}
 
-	if (static_asi_enabled() && (gfp & __GFP_GLOBAL_NONSENSITIVE))
-		gfp |= __GFP_ZERO;
+	if (static_asi_enabled()) {
+		if ((gfp & __GFP_LOCAL_NONSENSITIVE) &&
+		    !mm_asi_enabled(current->mm))
+			gfp &= ~__GFP_LOCAL_NONSENSITIVE;
+
+		if (gfp & (__GFP_GLOBAL_NONSENSITIVE |
+			   __GFP_LOCAL_NONSENSITIVE))
+			gfp |= __GFP_ZERO;
+	}
 
 	gfp &= gfp_allowed_mask;
 	/*
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 5857953cd5c1..a2337fc3404f 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -661,6 +661,7 @@ static const struct {
 	{ "__GFP_DIRECT_RECLAIM",	"DR" },
 	{ "__GFP_KSWAPD_RECLAIM",	"KR" },
 	{ "__GFP_GLOBAL_NONSENSITIVE",	"GNS" },
+	{ "__GFP_LOCAL_NONSENSITIVE",	"LNS" },
 };
 
 static size_t max_gfp_len;
-- 
2.35.1.473.g83b2b277ed-goog

