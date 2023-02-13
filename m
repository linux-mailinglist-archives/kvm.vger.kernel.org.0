Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDA6C693C86
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjBMCxG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjBMCxF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:53:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3971310262
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676256727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RiX2ATVNHT+YR9OhBWGxB6hI0Atc6OwS9KEN4HCc61Q=;
        b=iksSQf+SxhikgLE0pgpQwNY/wtHEbg+C/d5I1YLjsJIeMrKnmP5zTf74ViakGQR2MAV7kk
        vl/eblwGYJ35WvQ2Xb20Zaf9Gco+aVAMsKbbHDd/eSunUkQilkJwJpM5GscSdxu5WqrtIp
        o/o9glfibMRPFvc4wQhaJzV7saS39vg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-264-vqIi_Tn3MtSu8Ev4fZC5bg-1; Sun, 12 Feb 2023 21:52:05 -0500
X-MC-Unique: vqIi_Tn3MtSu8Ev4fZC5bg-1
Received: by mail-wm1-f69.google.com with SMTP id iz20-20020a05600c555400b003dc53fcc88fso6060805wmb.2
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RiX2ATVNHT+YR9OhBWGxB6hI0Atc6OwS9KEN4HCc61Q=;
        b=ACtohOuZuXhHTSwOxuLOmuq/Pdj6qWPWi1YBFIDUPlskM8BFmW4X9pggUiuhdQ4H9f
         2hAel0flYVt0fXC2nzC66/1SxbE4RCNzvGovjEGnVW9apQvWwak8QtcK2NXJxUDUSfr+
         Fw0ZC0HRBlzn0vL+nZo35kc3kcLTaEWUULJ7a4snF3Yy8Ni10C5xxRqoevgjigTQOP9j
         LUm7f0+xHnpksveUpjMaAc8jiPOJ1ZlJxG2NK636pNh7fgaeKS+NTiaG0JxMO2nL2q5c
         bSe5Dg6N1MBpEQJ6dGTrasb10RMLcdrdrsPU4kDqv0zXAQCJMr7iggcLMAT81YdhjLVq
         UC4w==
X-Gm-Message-State: AO0yUKXt4JxBmsZa/oPg35CcUQSuyU0u3kMSJuRvpCbyHHXkbZe6agzM
        WtEr5dwTXsLJmrqPA+2/4t+yCcfo4pnf3x5Jl/5kbgkBFCDyCFFLBdDdXpm2EjT7aLQWJeKkEfx
        c2CFNJN7quyc1
X-Received: by 2002:a05:600c:3423:b0:3dd:b0b3:811b with SMTP id y35-20020a05600c342300b003ddb0b3811bmr17493095wmp.31.1676256724593;
        Sun, 12 Feb 2023 18:52:04 -0800 (PST)
X-Google-Smtp-Source: AK7set8aZ0uDwjx349RvD6MnT+a4X4OpLksLeGxe6K/OY0hyiYuSGzPXrP7YqoGRxFeuwU93MRdeoA==
X-Received: by 2002:a05:600c:3423:b0:3dd:b0b3:811b with SMTP id y35-20020a05600c342300b003ddb0b3811bmr17493083wmp.31.1676256724377;
        Sun, 12 Feb 2023 18:52:04 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id j6-20020a05600c42c600b003df245cd853sm11800507wme.44.2023.02.12.18.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:52:03 -0800 (PST)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PULL 07/22] migration: Make find_dirty_block() return a single parameter
Date:   Mon, 13 Feb 2023 03:51:35 +0100
Message-Id: <20230213025150.71537-8-quintela@redhat.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213025150.71537-1-quintela@redhat.com>
References: <20230213025150.71537-1-quintela@redhat.com>
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

