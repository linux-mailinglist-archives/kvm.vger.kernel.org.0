Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBB2130430
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 23:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfE3VyA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 May 2019 17:54:00 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:38051 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbfE3Vx7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 17:53:59 -0400
Received: by mail-ot1-f68.google.com with SMTP id s19so7171348otq.5;
        Thu, 30 May 2019 14:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Wtqhuc8tld+njwpNjaUC3LbpBQWLP9ZV0hs8fIq5ASw=;
        b=XJvjTBc1+3PwDTickpM7WozJzbnV4CpwNeBr8/C7ZbJbctSTJZ+22GmcTknusuOoDr
         2D/QL0yQASYrqIjKmMGZ3xqFG90FA2JAtq+lrDy0HQr9MXSz2qBD2cBdM4ZhHAuwE/Zd
         Q9dwWl8Ada9Zdo9/JEx9uFscSKEAWOpBTfgK529lzzWDXo6fUzrmPi2d62PgdJ29IGOa
         gK7cUg9CxpeecwgzN6TbiRfynxidJ0jNKZW5/jR6vInd5DleH5Nq3BWGpnZFvrhdNCBK
         zATeaXk0EmpgYeqnWbNJyZPrTHkkI1urnEhXtBXMhTPcPWMDJBMr1rxPelkrhnsQoH8+
         rpuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Wtqhuc8tld+njwpNjaUC3LbpBQWLP9ZV0hs8fIq5ASw=;
        b=bfGOnuYtZGNSXUuNRRr3E3bo3+YchCoLiImQuBTh5ZmHvimBQbJRp/LNjOHF76vvKm
         +6Qn65UVvRnLLdq+WRuQj6yzR8VeyHUwrYTxpnEVk2ApXRkyhVki81ei+sjVRHdNLrFE
         zNkY9Ft8Lx05X4HroyFukr8kKonx8SriWNB9oUpeKf/MY13hu1Vl8lYHJaM96i6bMnrk
         uKLIFKcAiQ4lxPEPXhlBxM2LW58Kvkzg1rdAvtCP+oDt9Q2ECyhmxIs2oziVCeCh3gNM
         sfelKqqI8xKEkbcszDcXNSKFo9a9QdvmrhFsFlfOF8kmQxaDgeqZ0z2Tor6dnA1jr6fR
         pg3g==
X-Gm-Message-State: APjAAAXSAEvitb11IIyyLU8YTvLVfzzDwR6dRAozHuhFyGBesdppdAp5
        zQ1LxY+ws+Fd7IFcnJVI+40=
X-Google-Smtp-Source: APXvYqzVcIJEh7xNp7JK47qwuZzzsGLJK5TMq9FSbM20Pm3+szfoUg8qiY/3svza+IjLBI7oHuRCkg==
X-Received: by 2002:a9d:7347:: with SMTP id l7mr4421138otk.183.1559253239042;
        Thu, 30 May 2019 14:53:59 -0700 (PDT)
Received: from localhost.localdomain (50-126-100-225.drr01.csby.or.frontiernet.net. [50.126.100.225])
        by smtp.gmail.com with ESMTPSA id o124sm1462102oig.23.2019.05.30.14.53.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 14:53:58 -0700 (PDT)
Subject: [RFC PATCH 03/11] mm: Add support for Treated Buddy pages
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Thu, 30 May 2019 14:53:56 -0700
Message-ID: <20190530215356.13974.95767.stgit@localhost.localdomain>
In-Reply-To: <20190530215223.13974.22445.stgit@localhost.localdomain>
References: <20190530215223.13974.22445.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

This patch is adding support for flagging pages as "Treated" within the
buddy allocator.

If memory aeration is not enabled then the value will always be treated as
false and the set/clear operations will have no effect.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/mmzone.h     |    1 +
 include/linux/page-flags.h |   32 ++++++++++++++++++++++++++++++++
 mm/page_alloc.c            |    5 +++++
 3 files changed, 38 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 297edb45071a..0263d5bf0b84 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -127,6 +127,7 @@ static inline void del_page_from_free_area(struct page *page,
 {
 	list_del(&page->lru);
 	__ClearPageBuddy(page);
+	__ResetPageTreated(page);
 	set_page_private(page, 0);
 	area->nr_free--;
 }
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 9f8712a4b1a5..1f8ccb98dd69 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -722,12 +722,32 @@ static inline int page_has_type(struct page *page)
 	VM_BUG_ON_PAGE(!PageType(page, 0), page);			\
 	page->page_type &= ~PG_##lname;					\
 }									\
+static __always_inline void __ResetPage##uname(struct page *page)	\
+{									\
+	VM_BUG_ON_PAGE(!PageType(page, 0), page);			\
+	page->page_type |= PG_##lname;					\
+}									\
 static __always_inline void __ClearPage##uname(struct page *page)	\
 {									\
 	VM_BUG_ON_PAGE(!Page##uname(page), page);			\
 	page->page_type |= PG_##lname;					\
 }
 
+#define PAGE_TYPE_OPS_DISABLED(uname)					\
+static __always_inline int Page##uname(struct page *page)		\
+{									\
+	return false;							\
+}									\
+static __always_inline void __SetPage##uname(struct page *page)		\
+{									\
+}									\
+static __always_inline void __ResetPage##uname(struct page *page)	\
+{									\
+}									\
+static __always_inline void __ClearPage##uname(struct page *page)	\
+{									\
+}
+
 /*
  * PageBuddy() indicates that the page is free and in the buddy system
  * (see mm/page_alloc.c).
@@ -744,6 +764,18 @@ static inline int page_has_type(struct page *page)
 PAGE_TYPE_OPS(Offline, offline)
 
 /*
+ * PageTreated() is an alias for Offline, however it is not meant to be an
+ * exclusive value. It should be combined with PageBuddy() when seen as it
+ * is meant to indicate that the page has been scrubbed while waiting in
+ * the buddy system.
+ */
+#ifdef CONFIG_AERATION
+PAGE_TYPE_OPS(Treated, offline)
+#else
+PAGE_TYPE_OPS_DISABLED(Treated)
+#endif
+
+/*
  * If kmemcg is enabled, the buddy allocator will set PageKmemcg() on
  * pages allocated with __GFP_ACCOUNT. It gets cleared on page free.
  */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2fa5bbb372bb..2894990862bd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -942,6 +942,11 @@ static inline void __free_one_page(struct page *page,
 			goto done_merging;
 		if (!page_is_buddy(page, buddy, order))
 			goto done_merging;
+
+		/* If buddy is not treated, then do not mark page treated */
+		if (!PageTreated(buddy))
+			__ResetPageTreated(page);
+
 		/*
 		 * Our buddy is free or it is CONFIG_DEBUG_PAGEALLOC guard page,
 		 * merge with it and move up one order.

