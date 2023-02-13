Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59A7B693C87
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjBMCxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjBMCxF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:53:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057B010A90
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676256725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uHOT9wZeB+0b4Ejcrcd0vvTrtjiS44Q0GkTx2lSsIMo=;
        b=QTc/BcXmCALjXE2qXkENGxicdKZNmJZHrRoNbWfKxdom02h8uAuL8e4x0HLDc9abGau7mV
        7uAHEj8nwg1eBpFVNjQUgEHxU4dqnpLlY0Vp6jASGuIwvIoRN0GcZpn58IV2i1axEuLCQ3
        cSGvnyyvO99MUonF7pg9+zZEk2AGxLo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-523-OdAUjnbWMHCvX3Rl33EkhA-1; Sun, 12 Feb 2023 21:52:04 -0500
X-MC-Unique: OdAUjnbWMHCvX3Rl33EkhA-1
Received: by mail-wm1-f71.google.com with SMTP id k17-20020a05600c1c9100b003dd41ad974bso6055131wms.3
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uHOT9wZeB+0b4Ejcrcd0vvTrtjiS44Q0GkTx2lSsIMo=;
        b=eSyoPmaEmPCWCjhfuFEyo/N8YNlxqKeuO/x0WzKtvd7ubrDHBLOo2NU6SkuT6og+2/
         3GuwsqMv8TsDK1YHwtcaPP+zHGfUn3iovujAMf02eJ+VETRxK+W6I/5oHupK13dWs6IL
         9hrE0elhPLsuCvSHj9U7tS3pMvYXazon9oat3i74hTIULtkSwFvZknIe2fiidgbwd73A
         WTIyQAw8kyLRFgOMRwmybn5UpYDWFbQL4Xn4Cw+gMzvKfk8zWjvQS7k2AEgERx4LGgRZ
         jA68BKm6VS6zDpCAN4g0zqGS7HF0KZ1HF4WtSGV02UNfeD9uEb1Zz3SeEGUrSNxcDHaJ
         +OWA==
X-Gm-Message-State: AO0yUKXE182Fpi3bNYWmTxSVqQRkwiljZyy44rh3H6vzWdsyTSartZcg
        vB6kTl6fdGJ38h37Mr1Mmi6wzBd0mnDnpxlmXjz42fuGem56FeO82UWhTduZdipUqPzbReGtQji
        ULNDMu3zjRwmL
X-Received: by 2002:a5d:4e10:0:b0:2bf:e5cc:91c1 with SMTP id p16-20020a5d4e10000000b002bfe5cc91c1mr18791506wrt.52.1676256722940;
        Sun, 12 Feb 2023 18:52:02 -0800 (PST)
X-Google-Smtp-Source: AK7set/ZUvoGO8d5b9/7tMfXpFX/Wth0Q2LoQ0rqE3qpN9qVxe3b+muIwr58Yxf6rIMemoBgrsYs6Q==
X-Received: by 2002:a5d:4e10:0:b0:2bf:e5cc:91c1 with SMTP id p16-20020a5d4e10000000b002bfe5cc91c1mr18791498wrt.52.1676256722720;
        Sun, 12 Feb 2023 18:52:02 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id h12-20020adff4cc000000b002be505ab59asm9439807wrp.97.2023.02.12.18.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:52:02 -0800 (PST)
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
Subject: [PULL 06/22] migration: Simplify ram_find_and_save_block()
Date:   Mon, 13 Feb 2023 03:51:34 +0100
Message-Id: <20230213025150.71537-7-quintela@redhat.com>
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

