Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0C9693C94
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjBMCxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjBMCxW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:53:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8AB10A9E
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676256741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qidzccTnvZWTjmehoyXsqH06VDAcPWrPLs1KbiNU6rE=;
        b=HQ86609pgQXlg1c0uI3gnIpIsv7DeX7O/ounWS01dhJc3hCgd/SNujmmYixmCrJIgbpQmP
        wz//VxMQ1awGMroIja2iWvsfAGCZ/WJVilwo/PG7dBR8qc2q3Kn8yadaqFFZwwjgWbfZd9
        vpMBGsBsbQ1YpJg0yB/5k8VJS0D58qM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-607-TO7sOVION26z4kIlCi8zUA-1; Sun, 12 Feb 2023 21:52:19 -0500
X-MC-Unique: TO7sOVION26z4kIlCi8zUA-1
Received: by mail-wm1-f71.google.com with SMTP id iz20-20020a05600c555400b003dc53fcc88fso6061020wmb.2
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qidzccTnvZWTjmehoyXsqH06VDAcPWrPLs1KbiNU6rE=;
        b=gwf+CPhKC/eNuV1ch+MzJ9DW8wplqVvVnubwlt9kNEaZVeaezfUiVHX+MI5yIggyrU
         9+IEGd0wSCabJj9aDnDpiDyoW4hh95mRMKdRG6JeHA3GE9yJIngL6ApcVggBrjRSGAf5
         BoABOkiORcceN71B2HR1cqb78XjP6dCA33r8sK4HYlNAXREb0F8nKRK+oB6nXAUZDIEk
         9n6rOEHaLJiMl2RkgaMczHfyDVl08KUMx5CWtGD1efeI7avdiL3ts7LhHhe0LcOYCQlE
         ftw2dU6ysncerO28gMCcIYeL43rETh9KGVh5VBN9/N6walxd2dgwYrpkPb7g7pLlPlID
         lY9g==
X-Gm-Message-State: AO0yUKVU5Sm9mDAfin55AtaSPpoyYpwKormhU7GUxIlz9uYAx5bgB3I/
        gTbPtYlYuXBZB3dr3JXDZAYI0utQQ9vK3Grx4emAuRq/hCYoatf33T2qfTs7Vea+hRCO6SdHMP8
        nfZHvojLjOfbL
X-Received: by 2002:a05:600c:13c8:b0:3da:28a9:a900 with SMTP id e8-20020a05600c13c800b003da28a9a900mr17220610wmg.41.1676256738013;
        Sun, 12 Feb 2023 18:52:18 -0800 (PST)
X-Google-Smtp-Source: AK7set+EYzTgrB5KOoarWsUBUvZAw0+p2uCOQEO7fo/ZJqqeP3TdCyA/erTm8FfaPSMzXf6sgOxcYA==
X-Received: by 2002:a05:600c:13c8:b0:3da:28a9:a900 with SMTP id e8-20020a05600c13c800b003da28a9a900mr17220600wmg.41.1676256737845;
        Sun, 12 Feb 2023 18:52:17 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id m24-20020a05600c3b1800b003dc41a9836esm13797712wms.43.2023.02.12.18.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:52:17 -0800 (PST)
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
        Peter Xu <peterx@redhat.com>
Subject: [PULL 15/22] migration: Cleanup postcopy_preempt_setup()
Date:   Mon, 13 Feb 2023 03:51:43 +0100
Message-Id: <20230213025150.71537-16-quintela@redhat.com>
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

From: Peter Xu <peterx@redhat.com>

Since we just dropped the only case where postcopy_preempt_setup() can
return an error, it doesn't need a retval anymore because it never fails.
Move the preempt check to the caller, preparing it to be used elsewhere to
do nothing but as simple as kicking the async connection.

Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/postcopy-ram.h | 2 +-
 migration/migration.c    | 8 ++------
 migration/postcopy-ram.c | 8 +-------
 3 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/migration/postcopy-ram.h b/migration/postcopy-ram.h
index 25881c4127..d5604cbcf1 100644
--- a/migration/postcopy-ram.h
+++ b/migration/postcopy-ram.h
@@ -191,7 +191,7 @@ enum PostcopyChannels {
 };
 
 void postcopy_preempt_new_channel(MigrationIncomingState *mis, QEMUFile *file);
-int postcopy_preempt_setup(MigrationState *s, Error **errp);
+void postcopy_preempt_setup(MigrationState *s);
 int postcopy_preempt_wait_channel(MigrationState *s);
 
 #endif
diff --git a/migration/migration.c b/migration/migration.c
index f242d657e8..fb0ecf5649 100644
--- a/migration/migration.c
+++ b/migration/migration.c
@@ -4347,12 +4347,8 @@ void migrate_fd_connect(MigrationState *s, Error *error_in)
     }
 
     /* This needs to be done before resuming a postcopy */
-    if (postcopy_preempt_setup(s, &local_err)) {
-        error_report_err(local_err);
-        migrate_set_state(&s->state, MIGRATION_STATUS_SETUP,
-                          MIGRATION_STATUS_FAILED);
-        migrate_fd_cleanup(s);
-        return;
+    if (migrate_postcopy_preempt()) {
+        postcopy_preempt_setup(s);
     }
 
     if (resume) {
diff --git a/migration/postcopy-ram.c b/migration/postcopy-ram.c
index 9a9d0ecf49..de6d4a3fd4 100644
--- a/migration/postcopy-ram.c
+++ b/migration/postcopy-ram.c
@@ -1629,16 +1629,10 @@ int postcopy_preempt_wait_channel(MigrationState *s)
     return s->postcopy_qemufile_src ? 0 : -1;
 }
 
-int postcopy_preempt_setup(MigrationState *s, Error **errp)
+void postcopy_preempt_setup(MigrationState *s)
 {
-    if (!migrate_postcopy_preempt()) {
-        return 0;
-    }
-
     /* Kick an async task to connect */
     socket_send_channel_create(postcopy_preempt_send_channel_new, s);
-
-    return 0;
 }
 
 static void postcopy_pause_ram_fast_load(MigrationIncomingState *mis)
-- 
2.39.1

