Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39432693C41
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjBMCa4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjBMCax (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:30:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFC2E052
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676255366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OVgMt+TdJwmeIvY3Hw47YNm8dYS4wVaPDdNlXTwlDwQ=;
        b=I5ChttIW9lsmBz+O8QeBx3y1TmkUn4fOdA4dXyN+Krh0WWhF6kVMuhMGL1GPuR7O+cSWJ/
        n2ItEU1pnrkc1jq9Zg2JfJczmahXgIo10omwvagoaaeGEihGrKSs+5xSsJHQGsemtBLT2X
        R2PnND/5L/tpizmHdJQ4+A+w7GXP9ec=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-147-1qw9YlXOPIa6dYZ8GovoyA-1; Sun, 12 Feb 2023 21:29:24 -0500
X-MC-Unique: 1qw9YlXOPIa6dYZ8GovoyA-1
Received: by mail-wm1-f70.google.com with SMTP id x10-20020a05600c21ca00b003dc5584b516so8362343wmj.7
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OVgMt+TdJwmeIvY3Hw47YNm8dYS4wVaPDdNlXTwlDwQ=;
        b=rBcKEed28zrELFp15vdvuyor3zuCkrhLCpsOHdvEs0iBxRXSDb+luKeisnRkc36cgY
         m0NKwVrVz4w6v6mIGMEad3cqIk/o4g04aWQaVrXJ5XZeCLv8mvl/AD2GsecxXejawRPR
         7pQAiZG23x29qqjZvngrxq//ff52rxyPW8Y4WrXYtKW+ykjg5lQem25U0uYyzDconGqR
         3QsEGiMmanCuWtDE7c9szvBZrlV1Z3SkGlzgbSldPPEe40Hqah6kGt+sPrgoQx44ZHEG
         edSQZuhWAEiJ7bbvYKWNNqqJhNkhkuyCJDn417eJBII8PZtmO9tEsOiaQtMgDSdY48wB
         ADXw==
X-Gm-Message-State: AO0yUKXpddPz14qiIRzi/UuYRawhPSoXYeM8FPWcvKajNHc2X/Qz2gu0
        7ITvoWgJvDHGCchO8lcG6zl7TagmeNKPdFBYXn31WI9rF6e//X/e8uwT9Q9V7klz//4a39YsqMf
        6rg6ILWw1PK5B
X-Received: by 2002:a5d:595f:0:b0:2c5:585d:74c5 with SMTP id e31-20020a5d595f000000b002c5585d74c5mr1617018wri.22.1676255363516;
        Sun, 12 Feb 2023 18:29:23 -0800 (PST)
X-Google-Smtp-Source: AK7set+1AvjRljtPucQVqwFkeTx727Y5hrIJrWAWmfJIZuoPIp9WAfMkp3jkVQMcApV1qaza2muSpA==
X-Received: by 2002:a5d:595f:0:b0:2c5:585d:74c5 with SMTP id e31-20020a5d595f000000b002c5585d74c5mr1617009wri.22.1676255363296;
        Sun, 12 Feb 2023 18:29:23 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id t9-20020adfeb89000000b002be0b1e556esm9231047wrn.59.2023.02.12.18.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:29:22 -0800 (PST)
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
Subject: [PULL 06/22] migration: Simplify ram_find_and_save_block()
Date:   Mon, 13 Feb 2023 03:28:55 +0100
Message-Id: <20230213022911.68490-7-xxx.xx@gmail.com>
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

We will need later that find_dirty_block() return errors, so
simplify the loop.

Signed-off-by: Juan Quintela <quintela@redhat.com>
Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/ram.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/migration/ram.c b/migration/ram.c
index b966e148c2..dd809fec1f 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -2542,7 +2542,6 @@ static int ram_find_and_save_block(RAMState *rs)
 {
     PageSearchStatus *pss = &rs->pss[RAM_CHANNEL_PRECOPY];
     int pages = 0;
-    bool again, found;
 
     /* No dirty page as there is zero RAM */
     if (!ram_bytes_total()) {
@@ -2564,18 +2563,17 @@ static int ram_find_and_save_block(RAMState *rs)
     pss_init(pss, rs->last_seen_block, rs->last_page);
 
     do {
-        again = true;
-        found = get_queued_page(rs, pss);
-
-        if (!found) {
+        if (!get_queued_page(rs, pss)) {
             /* priority queue empty, so just search for something dirty */
-            found = find_dirty_block(rs, pss, &again);
+            bool again = true;
+            if (!find_dirty_block(rs, pss, &again)) {
+                if (!again) {
+                    break;
+                }
+            }
         }
-
-        if (found) {
-            pages = ram_save_host_page(rs, pss);
-        }
-    } while (!pages && again);
+        pages = ram_save_host_page(rs, pss);
+    } while (!pages);
 
     rs->last_seen_block = pss->block;
     rs->last_page = pss->page;
-- 
2.39.1

