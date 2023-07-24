Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB8B75F0EC
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 11:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbjGXJyS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 05:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232924AbjGXJx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 05:53:29 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9313946BC
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 02:49:32 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1b867f9198dso8898025ad.0
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 02:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690192134; x=1690796934;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hg2vi+2AAPCRuQsciRtLylYUMTgaXzyfBXLGSnv8etw=;
        b=aydgK7bn0QggjlQydoxB8/wzzA4TXTh5kAH1HczgG5x53kEUfwsZTHfAy7Oll8B5Eb
         /u8m2Fx+yVNF796ZZc3s2XmC1YIubtCHa+WaPaj49PGcqhNB+vofNP25+pjGYzLsUBey
         s8mU5+/TbPuzYxlgD12Kt4jsZqhjhd4Zmfvq3eYOMY75uxvK9h6vyhatsfe9xzUUvBHR
         65A0XriwgvV356EN5StwdT8HNZN8xypzwNZbI9gp5ddxZgA9hT9j3WwIFAc65w94K4S5
         JlPP5IHsQz3xceBVdVld1V5OEs83EDOwKVmAaZghdPj/BNMPCYQ+scOGPe5A3YPCuRcv
         ewxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690192134; x=1690796934;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hg2vi+2AAPCRuQsciRtLylYUMTgaXzyfBXLGSnv8etw=;
        b=Eh2kKwuXh5K4P1TfIwFNSiXs6IDzDG0v81qlxvKAkBOibaql2EzDF3guQH48exhMBc
         3LNBsI+Jv7NBJUf9WO2wgCImcPA15U1Pwfw6sYJ3GxAI9E+aT/fZmDx0ZEnVE9twa9ye
         5C/BE8KjjI6V4NPkllO8cWHeFSVCQE+rBZMbFHfApP/WtI4m7SpvY6tsPsYgnvVqrYLN
         WEhlJIf0S37Bq9nBgl5BEO7zR6SF0gwnA30hwYwMf6nPfU5QwWG2UKf4fjAtWv+3Ha4q
         qnb4WDsdZ06L8kCpsoGp5Is39XTsI1dO7UiDpbjr/SAAZ4QS8SOmxFNZN1a5kWiUgu+5
         h+kQ==
X-Gm-Message-State: ABy/qLa/QxqMRkBgrxs/6WkbQilXtsxNItW8stCueEQMmU2kUmsU4KB6
        WIjTjqGIdKQBXeekmoNuX02V+A==
X-Google-Smtp-Source: APBJJlFlbX7MjF6Gs1NiwvX/ojXDY5CFLHX7jflUqBVL6eloGiFWEtkN1YdVHiZpjmt9ZeBQxK8/kg==
X-Received: by 2002:a17:902:ecd2:b0:1b8:b4f6:1327 with SMTP id a18-20020a170902ecd200b001b8b4f61327mr12294253plh.6.1690192134533;
        Mon, 24 Jul 2023 02:48:54 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902c18500b001bb20380bf2sm8467233pld.13.2023.07.24.02.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 02:48:54 -0700 (PDT)
From:   Qi Zheng <zhengqi.arch@bytedance.com>
To:     akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
        vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
        brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
        steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
        yujie.liu@intel.com, gregkh@linuxfoundation.org,
        muchun.song@linux.dev
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-erofs@lists.ozlabs.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-nfs@vger.kernel.org, linux-mtd@lists.infradead.org,
        rcu@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        dm-devel@redhat.com, linux-raid@vger.kernel.org,
        linux-bcache@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 19/47] mm: thp: dynamically allocate the thp-related shrinkers
Date:   Mon, 24 Jul 2023 17:43:26 +0800
Message-Id: <20230724094354.90817-20-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use new APIs to dynamically allocate the thp-zero and thp-deferred_split
shrinkers.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/huge_memory.c | 69 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 24 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8c94b34024a2..4db5a1834d81 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -65,7 +65,11 @@ unsigned long transparent_hugepage_flags __read_mostly =
 	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG)|
 	(1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG);
 
-static struct shrinker deferred_split_shrinker;
+static struct shrinker *deferred_split_shrinker;
+static unsigned long deferred_split_count(struct shrinker *shrink,
+					  struct shrink_control *sc);
+static unsigned long deferred_split_scan(struct shrinker *shrink,
+					 struct shrink_control *sc);
 
 static atomic_t huge_zero_refcount;
 struct page *huge_zero_page __read_mostly;
@@ -229,11 +233,7 @@ static unsigned long shrink_huge_zero_page_scan(struct shrinker *shrink,
 	return 0;
 }
 
-static struct shrinker huge_zero_page_shrinker = {
-	.count_objects = shrink_huge_zero_page_count,
-	.scan_objects = shrink_huge_zero_page_scan,
-	.seeks = DEFAULT_SEEKS,
-};
+static struct shrinker *huge_zero_page_shrinker;
 
 #ifdef CONFIG_SYSFS
 static ssize_t enabled_show(struct kobject *kobj,
@@ -454,6 +454,40 @@ static inline void hugepage_exit_sysfs(struct kobject *hugepage_kobj)
 }
 #endif /* CONFIG_SYSFS */
 
+static int thp_shrinker_init(void)
+{
+	huge_zero_page_shrinker = shrinker_alloc(0, "thp-zero");
+	if (!huge_zero_page_shrinker)
+		return -ENOMEM;
+
+	deferred_split_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
+						 SHRINKER_MEMCG_AWARE |
+						 SHRINKER_NONSLAB,
+						 "thp-deferred_split");
+	if (!deferred_split_shrinker) {
+		shrinker_free_non_registered(huge_zero_page_shrinker);
+		return -ENOMEM;
+	}
+
+	huge_zero_page_shrinker->count_objects = shrink_huge_zero_page_count;
+	huge_zero_page_shrinker->scan_objects = shrink_huge_zero_page_scan;
+	huge_zero_page_shrinker->seeks = DEFAULT_SEEKS;
+	shrinker_register(huge_zero_page_shrinker);
+
+	deferred_split_shrinker->count_objects = deferred_split_count;
+	deferred_split_shrinker->scan_objects = deferred_split_scan;
+	deferred_split_shrinker->seeks = DEFAULT_SEEKS;
+	shrinker_register(deferred_split_shrinker);
+
+	return 0;
+}
+
+static void thp_shrinker_exit(void)
+{
+	shrinker_unregister(huge_zero_page_shrinker);
+	shrinker_unregister(deferred_split_shrinker);
+}
+
 static int __init hugepage_init(void)
 {
 	int err;
@@ -482,12 +516,9 @@ static int __init hugepage_init(void)
 	if (err)
 		goto err_slab;
 
-	err = register_shrinker(&huge_zero_page_shrinker, "thp-zero");
-	if (err)
-		goto err_hzp_shrinker;
-	err = register_shrinker(&deferred_split_shrinker, "thp-deferred_split");
+	err = thp_shrinker_init();
 	if (err)
-		goto err_split_shrinker;
+		goto err_shrinker;
 
 	/*
 	 * By default disable transparent hugepages on smaller systems,
@@ -505,10 +536,8 @@ static int __init hugepage_init(void)
 
 	return 0;
 err_khugepaged:
-	unregister_shrinker(&deferred_split_shrinker);
-err_split_shrinker:
-	unregister_shrinker(&huge_zero_page_shrinker);
-err_hzp_shrinker:
+	thp_shrinker_exit();
+err_shrinker:
 	khugepaged_destroy();
 err_slab:
 	hugepage_exit_sysfs(hugepage_kobj);
@@ -2851,7 +2880,7 @@ void deferred_split_folio(struct folio *folio)
 #ifdef CONFIG_MEMCG
 		if (memcg)
 			set_shrinker_bit(memcg, folio_nid(folio),
-					 deferred_split_shrinker.id);
+					 deferred_split_shrinker->id);
 #endif
 	}
 	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
@@ -2925,14 +2954,6 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 	return split;
 }
 
-static struct shrinker deferred_split_shrinker = {
-	.count_objects = deferred_split_count,
-	.scan_objects = deferred_split_scan,
-	.seeks = DEFAULT_SEEKS,
-	.flags = SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE |
-		 SHRINKER_NONSLAB,
-};
-
 #ifdef CONFIG_DEBUG_FS
 static void split_huge_pages_all(void)
 {
-- 
2.30.2

