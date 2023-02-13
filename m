Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23583693C8C
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjBMCxO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjBMCxN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:53:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8362F10277
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676256730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x0yBf49pSQR7yhFHwz1wdYBEEVUVzX6IxyfnhrL83Mc=;
        b=gg7vvnBM/dKbQqOL8xeZ7HzX7mywSYN2SLpVvwEg7O0e6ldFDD1OLGFG2f84+mMpUPpyD7
        qW8UD7mywKby4wgfH6q2y7YT5YfY7rvyq4nmTmaKoVCtbgz8YrF+YxUPYuXpHCYlYaQvuw
        muDnzaBpqN2fu97ZHl6Mx79zBn45eaI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-344-4c3ctWRcOgW_mmemGE2DPQ-1; Sun, 12 Feb 2023 21:52:08 -0500
X-MC-Unique: 4c3ctWRcOgW_mmemGE2DPQ-1
Received: by mail-wm1-f72.google.com with SMTP id o31-20020a05600c511f00b003dc53da325dso8379060wms.8
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x0yBf49pSQR7yhFHwz1wdYBEEVUVzX6IxyfnhrL83Mc=;
        b=tbTL9mkobNCkLVw8Wxhm/gfMuVLR23p6/PRBpEycJ7uYxAmlqfbQ1StZNNO1IEsNwJ
         x5apco9NWVbgVVbU26++GMxciSE3za5xI1kFowW2xgcGXgu1xlRqiVP40HQJ5Qubwz8g
         4IXqcOgizDoAZCsOPdog+aovGXCT3xIlyGQ9z4oZAcPwMw2GecGl60HfpB+hRGN0Dm2D
         0DbFlsgUzWPtrycrhb9yhLbPP9w6D+GDj65dW+KkywrV+M8GKxE5F6/dPj4yCHJKjDdE
         9Ox12DzDdoOfeG8KDiNphHQtpVwQWjqignKaptiyN0nu2TScNfH7TJYxARgn+TB6wpi9
         S+Ig==
X-Gm-Message-State: AO0yUKWYcMX8mq6dlMjS5W/I4HrmDTWnPH0OHyhrAuq7qC7td3b53q1Q
        sqhUJnoX4mdMngv0j7/D057CDEH48wR6fmMzEA/tFqTI7tjS3sazK+nKtv3FFSnPT/9eFFwForH
        JdCLoO4eh0qGv
X-Received: by 2002:a5d:6707:0:b0:293:1868:3a14 with SMTP id o7-20020a5d6707000000b0029318683a14mr18081503wru.0.1676256727874;
        Sun, 12 Feb 2023 18:52:07 -0800 (PST)
X-Google-Smtp-Source: AK7set9tc3eKcmHV81AV7FTi/F+cUpXgHE4iVfjahlFPUDi5eQMBm9rcSPprLob0mPFtARQR1H/hjw==
X-Received: by 2002:a5d:6707:0:b0:293:1868:3a14 with SMTP id o7-20020a5d6707000000b0029318683a14mr18081500wru.0.1676256727676;
        Sun, 12 Feb 2023 18:52:07 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id s7-20020a5d5107000000b002c556a4f1casm2251510wrt.42.2023.02.12.18.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:52:07 -0800 (PST)
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
Subject: [PULL 09/22] migration: Calculate ram size once
Date:   Mon, 13 Feb 2023 03:51:37 +0100
Message-Id: <20230213025150.71537-10-quintela@redhat.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213025150.71537-1-quintela@redhat.com>
References: <20230213025150.71537-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

We are recalculating ram size continously, when we know that it don't
change during migration.  Create a field in RAMState to track it.

Signed-off-by: Juan Quintela <quintela@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 migration/ram.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/migration/ram.c b/migration/ram.c
index 1727fe5ef6..6abfe075f2 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -330,6 +330,8 @@ struct RAMState {
     PageSearchStatus pss[RAM_CHANNEL_MAX];
     /* UFFD file descriptor, used in 'write-tracking' migration */
     int uffdio_fd;
+    /* total ram size in bytes */
+    uint64_t ram_bytes_total;
     /* Last block that we have visited searching for dirty pages */
     RAMBlock *last_seen_block;
     /* Last dirty target page we have sent */
@@ -2546,7 +2548,7 @@ static int ram_find_and_save_block(RAMState *rs)
     int pages = 0;
 
     /* No dirty page as there is zero RAM */
-    if (!ram_bytes_total()) {
+    if (!rs->ram_bytes_total) {
         return pages;
     }
 
@@ -3009,13 +3011,14 @@ static int ram_state_init(RAMState **rsp)
     qemu_mutex_init(&(*rsp)->bitmap_mutex);
     qemu_mutex_init(&(*rsp)->src_page_req_mutex);
     QSIMPLEQ_INIT(&(*rsp)->src_page_requests);
+    (*rsp)->ram_bytes_total = ram_bytes_total();
 
     /*
      * Count the total number of pages used by ram blocks not including any
      * gaps due to alignment or unplugs.
      * This must match with the initial values of dirty bitmap.
      */
-    (*rsp)->migration_dirty_pages = ram_bytes_total() >> TARGET_PAGE_BITS;
+    (*rsp)->migration_dirty_pages = (*rsp)->ram_bytes_total >> TARGET_PAGE_BITS;
     ram_state_reset(*rsp);
 
     return 0;
-- 
2.39.1

