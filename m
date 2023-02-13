Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32382693C95
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjBMCxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbjBMCxY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:53:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71AB410AB0
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676256745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kvm5CeInbbh1Y+6Wfd0BER4Em57orWCfA6AmQdkHIMQ=;
        b=DugZcEJP104NkgycTqythns+CXixeMIrImpng8ViVDlpyCPDBbbPnkcNJx+Bux8UmfixtX
        IcZp3yKCV66ssScvaOp+WmXDQtPMZZDR3Dh/QeFtV/q6UF3DgLDoE45A8BiYjwXA/mUDDW
        nIZ8AJ790CRDGimUcPA9w7RsClai6Rk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-370-A482-wdzPniogmZml4jhVA-1; Sun, 12 Feb 2023 21:52:24 -0500
X-MC-Unique: A482-wdzPniogmZml4jhVA-1
Received: by mail-wr1-f71.google.com with SMTP id m10-20020a056000024a00b002c55068a8efso333917wrz.1
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kvm5CeInbbh1Y+6Wfd0BER4Em57orWCfA6AmQdkHIMQ=;
        b=AA/vvT5duBwHf7p3vo5WFMCTBTkCd8ENkHIBIRRQ+tB4u2JvkWyoJEoKLcp8HZkXv/
         /OHB1o0brMW/+xIt7R0ByX4GN9W9amREjNoGhPgWNy4dbCSPatSA3T+vJ3Y3Y2PP8v8q
         jXjJ1DakFCE31w5EZWqGDenw59PQtF9hQvCitoO5DbOxppZbukEjVvktaHUPfEs8y8BW
         19ZmNFR/zc8dV+0VL1VrS0yFyQS7rzpdajMg1nFEDoAB1AfdWIEul3lShzV7z+6iD0mN
         sXZ3pLwJsOzLEeEckQmTzlgYAockZtHOPyE7An+uIN5WA5K9mdnkTO2DdL67uh1jBOEh
         Hf0A==
X-Gm-Message-State: AO0yUKXpxIm0Q0/MToI1x/lgV+/2hVjicRsRBb4zWjoOZq4mjge10S7d
        wCebPzrKtk4+yyAFfFjHFexyHS8Yb51M2Y3pxs6vnakxgwFSVVVlDQ18GfNTrm3QTNZHYBnmISn
        X0bTHCo/mSs6x
X-Received: by 2002:a05:6000:183:b0:2c5:52fc:ed1a with SMTP id p3-20020a056000018300b002c552fced1amr3039913wrx.55.1676256743269;
        Sun, 12 Feb 2023 18:52:23 -0800 (PST)
X-Google-Smtp-Source: AK7set8QTsdZxrFsE5C/a7ia2LHZRzmFU1DHRlYMMrWGARW+rKgCWIO2I68jvndjNTBB/iIfhpmEOA==
X-Received: by 2002:a05:6000:183:b0:2c5:52fc:ed1a with SMTP id p3-20020a056000018300b002c552fced1amr3039900wrx.55.1676256743028;
        Sun, 12 Feb 2023 18:52:23 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id q14-20020a5d574e000000b002bfb02153d1sm9399397wrw.45.2023.02.12.18.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:52:22 -0800 (PST)
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
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Leonardo Bras <leobras@redhat.com>,
        Li Xiaohui <xiaohli@redhat.com>, Peter Xu <peterx@redhat.com>
Subject: [PULL 18/22] migration/multifd: Change multifd_load_cleanup() signature and usage
Date:   Mon, 13 Feb 2023 03:51:46 +0100
Message-Id: <20230213025150.71537-19-quintela@redhat.com>
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

Fixes: b5eea99ec2 ("migration: Add yank feature")
Reported-by: Li Xiaohui <xiaohli@redhat.com>
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

