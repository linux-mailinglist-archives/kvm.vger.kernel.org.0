Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA14693C8E
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjBMCxQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjBMCxO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:53:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97E910431
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676256732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J1PvApjmhG7oH9VG9BIS8wCFWPQBXA149/Jod5H/WXU=;
        b=ei9Aisyf/YHFysCqeb2SlRvEpeK8KgXu8dLCZkvYTHtiunTKbgh8bc5o/7lDIX6r6taIq5
        xVO/gqv1hfBv0dVy30Qu5jqBvVGLeok0TxeauMjAYJKd2Y1DopmaWvD5xymCBgny0fHLOV
        9BogUduAu6ifO2bVoJhpb9hwDGxQqxI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-376-Rc_qE2dDMyWQS1wn2yZJPg-1; Sun, 12 Feb 2023 21:52:10 -0500
X-MC-Unique: Rc_qE2dDMyWQS1wn2yZJPg-1
Received: by mail-wm1-f70.google.com with SMTP id bd21-20020a05600c1f1500b003dc5cb10dcfso5433248wmb.9
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J1PvApjmhG7oH9VG9BIS8wCFWPQBXA149/Jod5H/WXU=;
        b=0+oaJaPDJRF5YOquXZLHN8x0K06a6x3fWF+dNyO1irOpLC62CG0/l8HgLg5bLExpWz
         1V9AU/RhJo9KiGKhd1IXnOkduFFjOXXCqrTkJZtImpNlSi8C4326Quyyat1guDbJUbpg
         LWWWMATWH9cjNo7zDxvxl6JPrC14HqxeBdel56EK16PxQ8Z/XHcw8uvmFLgtbOCesLOk
         3RaTtm2/c0W8cScwoO0BscGttEDEiEYHcWbYLQhW8NODRLtwy4GXyhc6gVb6vgnqpilz
         Q9dZgfcYz2bIKzBgeSFLPLNpr/CGWXVFxyoeJ2ySdHdXTyk1T2xBj8SZXNeKKRD0oa4M
         aalA==
X-Gm-Message-State: AO0yUKXaNZV51C8RAlftxtcJZS5NR+wkEJehm8lonL0kGdRP0i+V/bui
        3uPVI3mYQqcXnO+YsTVINowtVYx/MvdrUCAkr8AJZ8Z2QGW876uUECsBSrh2+nDyg1NMXSFZbtB
        2sYSAO4nCzRay
X-Received: by 2002:a05:600c:4b1c:b0:3df:eb5d:c583 with SMTP id i28-20020a05600c4b1c00b003dfeb5dc583mr17722581wmp.17.1676256729429;
        Sun, 12 Feb 2023 18:52:09 -0800 (PST)
X-Google-Smtp-Source: AK7set80qYH099JdKFySD+5GaT3LkHTvatWgrRV2CSsU+tF2I5QJyqKHD1sZPkB+q5ZeqkpW3CZSsw==
X-Received: by 2002:a05:600c:4b1c:b0:3df:eb5d:c583 with SMTP id i28-20020a05600c4b1c00b003dfeb5dc583mr17722579wmp.17.1676256729240;
        Sun, 12 Feb 2023 18:52:09 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id r14-20020a05600c35ce00b003dc4ecfc4d7sm13314982wmq.29.2023.02.12.18.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:52:08 -0800 (PST)
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
Subject: [PULL 10/22] migration: Make ram_save_target_page() a pointer
Date:   Mon, 13 Feb 2023 03:51:38 +0100
Message-Id: <20230213025150.71537-11-quintela@redhat.com>
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

We are going to create a new function for multifd latest in the series.

Signed-off-by: Juan Quintela <quintela@redhat.com>
Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 migration/ram.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/migration/ram.c b/migration/ram.c
index 6abfe075f2..0890816a30 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -452,6 +452,13 @@ void dirty_sync_missed_zero_copy(void)
     ram_counters.dirty_sync_missed_zero_copy++;
 }
 
+struct MigrationOps {
+    int (*ram_save_target_page)(RAMState *rs, PageSearchStatus *pss);
+};
+typedef struct MigrationOps MigrationOps;
+
+MigrationOps *migration_ops;
+
 CompressionStats compression_counters;
 
 struct CompressParam {
@@ -2295,14 +2302,14 @@ static bool save_compress_page(RAMState *rs, PageSearchStatus *pss,
 }
 
 /**
- * ram_save_target_page: save one target page
+ * ram_save_target_page_legacy: save one target page
  *
  * Returns the number of pages written
  *
  * @rs: current RAM state
  * @pss: data about the page we want to send
  */
-static int ram_save_target_page(RAMState *rs, PageSearchStatus *pss)
+static int ram_save_target_page_legacy(RAMState *rs, PageSearchStatus *pss)
 {
     RAMBlock *block = pss->block;
     ram_addr_t offset = ((ram_addr_t)pss->page) << TARGET_PAGE_BITS;
@@ -2428,7 +2435,7 @@ static int ram_save_host_page_urgent(PageSearchStatus *pss)
 
         if (page_dirty) {
             /* Be strict to return code; it must be 1, or what else? */
-            if (ram_save_target_page(rs, pss) != 1) {
+            if (migration_ops->ram_save_target_page(rs, pss) != 1) {
                 error_report_once("%s: ram_save_target_page failed", __func__);
                 ret = -1;
                 goto out;
@@ -2497,7 +2504,7 @@ static int ram_save_host_page(RAMState *rs, PageSearchStatus *pss)
             if (preempt_active) {
                 qemu_mutex_unlock(&rs->bitmap_mutex);
             }
-            tmppages = ram_save_target_page(rs, pss);
+            tmppages = migration_ops->ram_save_target_page(rs, pss);
             if (tmppages >= 0) {
                 pages += tmppages;
                 /*
@@ -2697,6 +2704,8 @@ static void ram_save_cleanup(void *opaque)
     xbzrle_cleanup();
     compress_threads_save_cleanup();
     ram_state_cleanup(rsp);
+    g_free(migration_ops);
+    migration_ops = NULL;
 }
 
 static void ram_state_reset(RAMState *rs)
@@ -3252,6 +3261,8 @@ static int ram_save_setup(QEMUFile *f, void *opaque)
     ram_control_before_iterate(f, RAM_CONTROL_SETUP);
     ram_control_after_iterate(f, RAM_CONTROL_SETUP);
 
+    migration_ops = g_malloc0(sizeof(MigrationOps));
+    migration_ops->ram_save_target_page = ram_save_target_page_legacy;
     ret =  multifd_send_sync_main(f);
     if (ret < 0) {
         return ret;
-- 
2.39.1

