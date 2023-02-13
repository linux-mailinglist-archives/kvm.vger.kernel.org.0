Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D131693C45
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjBMCbE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjBMCay (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:30:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A019EF8C
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676255367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wLDENILmbbXHoQfh+JsgdVt2FdytPOKPN5jSF0gsIbE=;
        b=KxXp8kQAC7AZIaEK9YOFytHM4B/rApV/YoiMlfo/T+BTR4mS/Toi0OLROTh2GVR+x6N2eh
        XU/wHjevzjU3WBPAeTtX0+Z7deNUq8tmPgnPli+FqUqAgesfN8t3gpsqJPgJosOI0W8/7e
        HLcOGA56vLaegkEnwRuoChYKMJM3W8s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-450-CmdHsYVxPtuNVO_WJ4MvBQ-1; Sun, 12 Feb 2023 21:29:26 -0500
X-MC-Unique: CmdHsYVxPtuNVO_WJ4MvBQ-1
Received: by mail-wm1-f69.google.com with SMTP id a20-20020a05600c349400b003dfecb98d38so8389375wmq.0
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wLDENILmbbXHoQfh+JsgdVt2FdytPOKPN5jSF0gsIbE=;
        b=0vys3q7jUvjyCUDJV/ZMkj/+tX0RuX0NqKsEtGMWYXwZqdrOs+ZO3/ydeyjVuC0+Yf
         1DT4OpBsxkGyTPkO6BjmuG68zXSt0r3McfGPBSZgeRUtdQJ41hDfvvNADKjrbMqZm4N6
         jbzrVb+T3wxtxmDIk1bXzEsDVFBNU0SJjSyYysmyBz9Cue1Xka15eo3weXcqCCnJTCH7
         XE0NjK1Bx4cGOtuIv8FJSh7nsXRy559BT8aTxmH9UxDr3DbUfzchSNqfQpjCChWBDUvw
         PKu80NkuLmcQA8w3MVv+m99e6nAGU5jCpeT581ofMv4/KFD/WKh+W0jEMc9hwXz/1O1C
         hxsQ==
X-Gm-Message-State: AO0yUKW9O05U0YplkVlqpNOpn4J8NnEQWFChe6iixs87j2j9Ai62qDbM
        OuGnCgTHo+CNo02ISTzWdueZgOwtz9+zqccir+woMKfCZ4vddLhoXxyxAzLHeI0tZLZCMlUBbnI
        aWrQeLxxIbd//
X-Received: by 2002:a5d:4690:0:b0:2c5:4659:3e76 with SMTP id u16-20020a5d4690000000b002c546593e76mr6850621wrq.18.1676255365227;
        Sun, 12 Feb 2023 18:29:25 -0800 (PST)
X-Google-Smtp-Source: AK7set/AkBoA8CyAL0GJ1g2wkOw3Cz9udImTmfN8gkOPL2DMEdstXcGyRw9TWI/l2tbPukHMj6LEEQ==
X-Received: by 2002:a5d:4690:0:b0:2c5:4659:3e76 with SMTP id u16-20020a5d4690000000b002c546593e76mr6850609wrq.18.1676255364971;
        Sun, 12 Feb 2023 18:29:24 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id s11-20020adfdb0b000000b002c3e1e1dcd7sm9351257wri.104.2023.02.12.18.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:29:24 -0800 (PST)
From:   Xxx Xx <quintela@redhat.com>
X-Google-Original-From: Xxx Xx <xxx.xx@gmail.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
Subject: [PULL 07/22] migration: Make find_dirty_block() return a single parameter
Date:   Mon, 13 Feb 2023 03:28:56 +0100
Message-Id: <20230213022911.68490-8-xxx.xx@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213022911.68490-1-xxx.xx@gmail.com>
References: <20230213022911.68490-1-xxx.xx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Juan Quintela <quintela@redhat.com>

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
index dd809fec1f..cf577fce5c 100644
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
+    while (true){
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

