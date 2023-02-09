Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE4B69149F
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 00:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbjBIXga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 18:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbjBIXgO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 18:36:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DE965EF6
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 15:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675985686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fGX6SXCXlMTNmOvz3fORMij97q3jPPNtDD8efrFjP+c=;
        b=ZcGbp4lVzHb2UWA1E3W3pcqbSuha7N2gGReSRZy0wFDGO3R3+iOkOsCdEm1lgSt3pe1yd4
        jWKwxMkuXdwbZ8B0/4KV66nNiy7JVfABPuFtZ99IS3gVH/7MZD00Q/P3NXuKrTEwNM9BXV
        ljx1hgxLIIzZFjEEVNpgGdaqDKgoPp8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-wV7RmLwSP2GLOMmQMyCZ6A-1; Thu, 09 Feb 2023 18:34:45 -0500
X-MC-Unique: wV7RmLwSP2GLOMmQMyCZ6A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E63F811E6E;
        Thu,  9 Feb 2023 23:34:45 +0000 (UTC)
Received: from secure.mitica (unknown [10.39.192.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 79F38175AD;
        Thu,  9 Feb 2023 23:34:43 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
Subject: [PULL 07/17] migration: Make find_dirty_block() return a single parameter
Date:   Fri, 10 Feb 2023 00:34:16 +0100
Message-Id: <20230209233426.37811-8-quintela@redhat.com>
In-Reply-To: <20230209233426.37811-1-quintela@redhat.com>
References: <20230209233426.37811-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We used to return two bools, just return a single int with the
following meaning:

old return / again / new return
false        false   PAGE_ALL_CLEAN
false        true    PAGE_TRY_AGAIN
true         true    PAGE_DIRTY_FOUND  /* We don't care about again at all */

Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/ram.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/migration/ram.c b/migration/ram.c
index dd809fec1f..3aea86c8ab 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -1546,17 +1546,23 @@ retry:
     return pages;
 }
 
+#define PAGE_ALL_CLEAN 0
+#define PAGE_TRY_AGAIN 1
+#define PAGE_DIRTY_FOUND 2
 /**
  * find_dirty_block: find the next dirty page and update any state
  * associated with the search process.
  *
- * Returns true if a page is found
+ * Returns:
+ *         PAGE_ALL_CLEAN: no dirty page found, give up
+ *         PAGE_TRY_AGAIN: no dirty page found, retry for next block
+ *         PAGE_DIRTY_FOUND: dirty page found
  *
  * @rs: current RAM state
  * @pss: data about the state of the current dirty page scan
  * @again: set to false if the search has scanned the whole of RAM
  */
-static bool find_dirty_block(RAMState *rs, PageSearchStatus *pss, bool *again)
+static int find_dirty_block(RAMState *rs, PageSearchStatus *pss)
 {
     /* Update pss->page for the next dirty bit in ramblock */
     pss_find_next_dirty(pss);
@@ -1567,8 +1573,7 @@ static bool find_dirty_block(RAMState *rs, PageSearchStatus *pss, bool *again)
          * We've been once around the RAM and haven't found anything.
          * Give up.
          */
-        *again = false;
-        return false;
+        return PAGE_ALL_CLEAN;
     }
     if (!offset_in_ramblock(pss->block,
                             ((ram_addr_t)pss->page) << TARGET_PAGE_BITS)) {
@@ -1597,13 +1602,10 @@ static bool find_dirty_block(RAMState *rs, PageSearchStatus *pss, bool *again)
             }
         }
         /* Didn't find anything this time, but try again on the new block */
-        *again = true;
-        return false;
+        return PAGE_TRY_AGAIN;
     } else {
-        /* Can go around again, but... */
-        *again = true;
-        /* We've found something so probably don't need to */
-        return true;
+        /* We've found something */
+        return PAGE_DIRTY_FOUND;
     }
 }
 
@@ -2562,18 +2564,23 @@ static int ram_find_and_save_block(RAMState *rs)
 
     pss_init(pss, rs->last_seen_block, rs->last_page);
 
-    do {
+    while (true) {
         if (!get_queued_page(rs, pss)) {
             /* priority queue empty, so just search for something dirty */
-            bool again = true;
-            if (!find_dirty_block(rs, pss, &again)) {
-                if (!again) {
+            int res = find_dirty_block(rs, pss);
+            if (res != PAGE_DIRTY_FOUND) {
+                if (res == PAGE_ALL_CLEAN) {
                     break;
+                } else if (res == PAGE_TRY_AGAIN) {
+                    continue;
                 }
             }
         }
         pages = ram_save_host_page(rs, pss);
-    } while (!pages);
+        if (pages) {
+            break;
+        }
+    }
 
     rs->last_seen_block = pss->block;
     rs->last_page = pss->page;
-- 
2.39.1

