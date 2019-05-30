Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9141D3044A
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 23:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbfE3Vy7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 May 2019 17:54:59 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:39903 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727075AbfE3Vy6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 17:54:58 -0400
Received: by mail-oi1-f194.google.com with SMTP id v2so6183695oie.6;
        Thu, 30 May 2019 14:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=tFR5eWyyHKLzv/rG+/k1EP28VfnvmUHd1en3f8cuet4=;
        b=QntIfn3QP7w8OAf3KeLsA35GzvqasynhBr/LPKQ9UMSeS7sqkj18UbNYx/lJnWUJpx
         f9XhduhHSqYQrgukNTzCY6WtbcIgGHsNYgnGj2IhxiM0AVHY2+kyTEyxdSCPnZMVDLIx
         9F25FqTBOpb+X9YuJjyHH3ZeN/n7u048oiFLngFfpUu8oI0RouCxcc88D1IA4PwTWbV6
         YeeIFLwG3GLDmk1UTKsyorsyB8oh3Cc+b4Ql1DRnh02Uyw3Mddx82RmNGlqoHGX8YCHx
         neY4bedgWaliCWNuwj2x5E4P1f3BsPX6mffX4wlZD7UVun/2Shv7YNn8yRoAMtSRlhmk
         Enrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=tFR5eWyyHKLzv/rG+/k1EP28VfnvmUHd1en3f8cuet4=;
        b=LMMseEKlSNSmzCYwqqFLuqEcinAe8xbhNXntLvVE1bcZw6U2of7TlkYCnU80eG7S3l
         FhljUUYYK2GR2j7jIuE1JdVLVVlzHzWPgBcIbuHM4dg3K8nVkbynopNkH1hYk+kCFEd9
         ynBNl1iDwHhCyBGGcuZt/Pc/DAcvtqCR76lrv4XxSvxdPzTP9tWnvQ6YV/g4+L5SsL1f
         w28avHQp/r7XSAOtZ5cwpyl4LmHfw++DTp07JcZWIhAY3BSD9O4TLz+Zg3hUYZwrAucx
         1DFGgVZA4vwMeCkhWIBbRoupjgDVYfc7HSaninW/vNGMvT4Wtm8J2MFINgBKkRtIrVb2
         W5kg==
X-Gm-Message-State: APjAAAVhdTCNcylZwvyZT2wzf2fkcADyEJozArmb3Q3d9cX0sr7G5fac
        lpt2SPBSXHV5r2Awy1n0Ysk=
X-Google-Smtp-Source: APXvYqxfGBCA97YkaWM4wjgbjBJNwlQrAjyiLnkd5V2gUCN0ncNK3/MIrN/Ma+crH/dforiEy7/ROg==
X-Received: by 2002:aca:4e42:: with SMTP id c63mr4187588oib.170.1559253298022;
        Thu, 30 May 2019 14:54:58 -0700 (PDT)
Received: from localhost.localdomain (50-126-100-225.drr01.csby.or.frontiernet.net. [50.126.100.225])
        by smtp.gmail.com with ESMTPSA id 33sm1412918otb.56.2019.05.30.14.54.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 14:54:57 -0700 (PDT)
Subject: [RFC PATCH 11/11] mm: Add free page notification hook
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Thu, 30 May 2019 14:54:55 -0700
Message-ID: <20190530215455.13974.87717.stgit@localhost.localdomain>
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

Add a hook so that we are notified when a new page is available. We will
use this hook to notify the virtio aeration system when we have achieved
enough free higher-order pages to justify the process of pulling some pages
and hinting on them.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 arch/x86/include/asm/page.h |   11 +++++++++++
 include/linux/gfp.h         |    4 ++++
 mm/page_alloc.c             |    2 ++
 3 files changed, 17 insertions(+)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 7555b48803a8..dfd546230120 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -18,6 +18,17 @@
 
 struct page;
 
+#ifdef CONFIG_AERATION
+#include <linux/memory_aeration.h>
+
+#define HAVE_ARCH_FREE_PAGE_NOTIFY
+static inline void
+arch_free_page_notify(struct page *page, struct zone *zone, int order)
+{
+	aerator_notify_free(page, zone, order);
+}
+
+#endif
 #include <linux/range.h>
 extern struct range pfn_mapped[];
 extern int nr_pfn_mapped;
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 407a089d861f..d975e7eabbf8 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -459,6 +459,10 @@ static inline struct zonelist *node_zonelist(int nid, gfp_t flags)
 #ifndef HAVE_ARCH_FREE_PAGE
 static inline void arch_free_page(struct page *page, int order) { }
 #endif
+#ifndef HAVE_ARCH_FREE_PAGE_NOTIFY
+static inline void
+arch_free_page_notify(struct page *page, struct zone *zone, int order) { }
+#endif
 #ifndef HAVE_ARCH_ALLOC_PAGE
 static inline void arch_alloc_page(struct page *page, int order) { }
 #endif
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e3800221414b..104763034ce3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -999,6 +999,8 @@ static inline void __free_one_page(struct page *page,
 		add_to_free_area_tail(page, area, migratetype);
 	else
 		add_to_free_area(page, area, migratetype);
+
+	arch_free_page_notify(page, zone, order);
 }
 
 /*

