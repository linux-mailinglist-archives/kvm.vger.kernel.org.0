Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C76B693C5A
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjBMCb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjBMCbo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:31:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8679F1024B
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676255393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dUfdlqTOaMY/BDBu9wtEDIhadSAGMERvz+eZij4EHiY=;
        b=I+S6muwpKhmNIBKQI8OiA1WkyHwZmuechRhIfsskktxZxYH0uBMv4kswjywbM7jQYIJwxd
        ICnpiHLMjUyJXYqfOSIHzXA0nzfYmj4JDXC/gtCQDGN8tJdCp2GjknLhyCZGkPqOu5Q1OT
        epIlvS7QDgb8r1B/OBFFyUY1jFvudgE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-529-xxzEvlyBPoe678tVjRSlPQ-1; Sun, 12 Feb 2023 21:29:44 -0500
X-MC-Unique: xxzEvlyBPoe678tVjRSlPQ-1
Received: by mail-wm1-f72.google.com with SMTP id k9-20020a05600c1c8900b003dc5dec2ac6so8369427wms.4
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dUfdlqTOaMY/BDBu9wtEDIhadSAGMERvz+eZij4EHiY=;
        b=AgvkbvcvlHkiRXoyaorjt8q3g4Z40EfgUSTyeN0ktyuTMp3lBkImVul5HS0+OFUBNw
         1gV7++ja0LU442dRPFwnvwKlhL+5GOPgN2bhAl4cri3NS8K/02kZ2//np+bDgJk8C93s
         drRbyO3i4y60z49hzGzaQl7imDhSSPAq946oYiZlVbujCJXuavx04uWZ3TJg6yu+m16v
         FlXmW3RGoC7BjYikDLce9+f7GtLMNB3xNAbErOeDtSiE6QpCtANGKrhExm/cxvRH49KN
         G9N350/nfDxyQDxKEreQX7a981C0U40WM000HsxR/qhQbrJ5GAcVOfSZgUK04VMQr41r
         vSkA==
X-Gm-Message-State: AO0yUKWtIP2a4KLozeo0MYSZDxG6Xpd/QotrBFJUdBkf9uBEGfiLAm/z
        0sc2SkgluJl6yMbDOVwuzSSnikKj3AkW2am7HQUf5moePT4EF48EcNznK/FBc28AtWrk49QyWlw
        ChIQRIZWBSyV2
X-Received: by 2002:a05:600c:16c4:b0:3da:270b:ba6b with SMTP id l4-20020a05600c16c400b003da270bba6bmr19254506wmn.41.1676255383792;
        Sun, 12 Feb 2023 18:29:43 -0800 (PST)
X-Google-Smtp-Source: AK7set8Qn//cbEFCcD4e2+XicGyA204Lx92VcE6cIPopwYnuJH8nb0AvOSENVD2dZOQN6mpvOm8Cmg==
X-Received: by 2002:a05:600c:16c4:b0:3da:270b:ba6b with SMTP id l4-20020a05600c16c400b003da270bba6bmr19254490wmn.41.1676255383583;
        Sun, 12 Feb 2023 18:29:43 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id k7-20020a05600c080700b003daf672a616sm11843175wmp.22.2023.02.12.18.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:29:43 -0800 (PST)
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
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Leonardo Bras <leobras@redhat.com>,
        Peter Xu <peterx@redhat.com>
Subject: [PULL 18/22] migration/multifd: Change multifd_load_cleanup() signature and usage
Date:   Mon, 13 Feb 2023 03:29:07 +0100
Message-Id: <20230213022911.68490-19-xxx.xx@gmail.com>
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

From: Leonardo Bras <leobras@redhat.com>

Since it's introduction in commit f986c3d256 ("migration: Create multifd
migration threads"), multifd_load_cleanup() never returned any value
different than 0, neither set up any error on errp.

Even though, on process_incoming_migration_bh() an if clause uses it's
return value to decide on setting autostart = false, which will never
happen.

In order to simplify the codebase, change multifd_load_cleanup() signature
to 'void multifd_load_cleanup(void)', and for every usage remove error
handling or decision made based on return value != 0.

Signed-off-by: Leonardo Bras <leobras@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/multifd.h   |  2 +-
 migration/migration.c | 14 ++++----------
 migration/multifd.c   |  6 ++----
 3 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/migration/multifd.h b/migration/multifd.h
index ff3aa2e2e9..9a7e1a8826 100644
--- a/migration/multifd.h
+++ b/migration/multifd.h
@@ -16,7 +16,7 @@
 int multifd_save_setup(Error **errp);
 void multifd_save_cleanup(void);
 int multifd_load_setup(Error **errp);
-int multifd_load_cleanup(Error **errp);
+void multifd_load_cleanup(void);
 bool multifd_recv_all_channels_created(void);
 void multifd_recv_new_channel(QIOChannel *ioc, Error **errp);
 void multifd_recv_sync_main(void);
diff --git a/migration/migration.c b/migration/migration.c
index a5c22e327d..5bf332fdd2 100644
--- a/migration/migration.c
+++ b/migration/migration.c
@@ -559,13 +559,7 @@ static void process_incoming_migration_bh(void *opaque)
      */
     qemu_announce_self(&mis->announce_timer, migrate_announce_params());
 
-    if (multifd_load_cleanup(&local_err) != 0) {
-        error_report_err(local_err);
-        autostart = false;
-    }
-    /* If global state section was not received or we are in running
-       state, we need to obey autostart. Any other state is set with
-       runstate_set. */
+    multifd_load_cleanup();
 
     dirty_bitmap_mig_before_vm_start();
 
@@ -665,9 +659,9 @@ fail:
     migrate_set_state(&mis->state, MIGRATION_STATUS_ACTIVE,
                       MIGRATION_STATUS_FAILED);
     qemu_fclose(mis->from_src_file);
-    if (multifd_load_cleanup(&local_err) != 0) {
-        error_report_err(local_err);
-    }
+
+    multifd_load_cleanup();
+
     exit(EXIT_FAILURE);
 }
 
diff --git a/migration/multifd.c b/migration/multifd.c
index 99a59830c8..cac8496edc 100644
--- a/migration/multifd.c
+++ b/migration/multifd.c
@@ -1013,12 +1013,12 @@ static void multifd_recv_terminate_threads(Error *err)
     }
 }
 
-int multifd_load_cleanup(Error **errp)
+void multifd_load_cleanup(void)
 {
     int i;
 
     if (!migrate_use_multifd()) {
-        return 0;
+        return;
     }
     multifd_recv_terminate_threads(NULL);
     for (i = 0; i < migrate_multifd_channels(); i++) {
@@ -1058,8 +1058,6 @@ int multifd_load_cleanup(Error **errp)
     multifd_recv_state->params = NULL;
     g_free(multifd_recv_state);
     multifd_recv_state = NULL;
-
-    return 0;
 }
 
 void multifd_recv_sync_main(void)
-- 
2.39.1

