Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF4A693C43
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjBMCa7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:30:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjBMCay (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:30:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB01FF1A
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676255372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PZlebtb52gHEYf4LdFiVz+W2gRdaAlvhDiXn8io+x3s=;
        b=IgUC4GbVY8btRKx5beq8uw+Kk8OLwW5zdELwXW+FrKqgmXzdaLWhayviWOdErhJozA9kf+
        r9OHO7Z7mGzoTybP8lwHvdOqYFlONP7w4EKvKGna7RhwBNJvcjMwfcgan/yf9aVD7sxKtW
        nGVxSzTAKma16zY1SA+dwDhRW5VQwtA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-365-2cpMCh_SMl-biv98d1dVOQ-1; Sun, 12 Feb 2023 21:29:31 -0500
X-MC-Unique: 2cpMCh_SMl-biv98d1dVOQ-1
Received: by mail-wm1-f72.google.com with SMTP id bg9-20020a05600c3c8900b003e1e7d3db06so1721397wmb.5
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PZlebtb52gHEYf4LdFiVz+W2gRdaAlvhDiXn8io+x3s=;
        b=2Zdj6KEc4qdvs/0Wi/ebnoBy7Woyf1nHJrsdPPNoQE+ATM0/ibOIOQX6exI9Y2lSa5
         MWxb4elSPqgPjda4wmyDKgZGDq6/UAQt1J7ZJVyYHuuHpiLkl5wTxgFQFzR7f6cmASpm
         lIOwyFPjco8Pbq+fqjDt2NYRXh1vOZ52fgZLuIEs7DfK5syVaM2VtQzz5vbvJ4M6PQDr
         8aZFQHH947cXH6saF5esqsDdBy5ZXWL1hRUDkPb4KRgU7aFJMTjcYNHkWuokuKIUty99
         71vHD/PNe/SAHRYOQgjAQSLUC2jd9jwMWqKCZsAGDMmix8APcZo+OZZobxfrJd8TxJ+O
         W05Q==
X-Gm-Message-State: AO0yUKX/iuIW6brJkYOci4ZD7PA1pdMvgoJtrHNOESayRrVTxin4NWMm
        qAwgHgN0E3rSTenHKze8d5xXUhnE7b1QSSL0DHNZC3eGeVuh7T2mwHR36eJ99MpIi8+QnW9rEPS
        gvHIkMgSpiu86
X-Received: by 2002:a5d:5088:0:b0:2c5:4c7c:6aad with SMTP id a8-20020a5d5088000000b002c54c7c6aadmr6289440wrt.8.1676255370102;
        Sun, 12 Feb 2023 18:29:30 -0800 (PST)
X-Google-Smtp-Source: AK7set8/GQc1nte9GQy9mwEksu9qfWqfwiFlIzARDdce28uDL0iyRZPoyWc9DPV4HT3Wb6MpMnVIhw==
X-Received: by 2002:a5d:5088:0:b0:2c5:4c7c:6aad with SMTP id a8-20020a5d5088000000b002c54c7c6aadmr6289433wrt.8.1676255369924;
        Sun, 12 Feb 2023 18:29:29 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id bi5-20020a05600c3d8500b003d9aa76dc6asm16368498wmb.0.2023.02.12.18.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:29:29 -0800 (PST)
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
Subject: [PULL 10/22] migration: Make ram_save_target_page() a pointer
Date:   Mon, 13 Feb 2023 03:28:59 +0100
Message-Id: <20230213022911.68490-11-xxx.xx@gmail.com>
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

