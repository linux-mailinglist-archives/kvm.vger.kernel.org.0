Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E300F693C47
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjBMCbJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjBMCaz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:30:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0CFFF32
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676255381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qidzccTnvZWTjmehoyXsqH06VDAcPWrPLs1KbiNU6rE=;
        b=fVRPfBHbJCXagaKS5nY53/9DWNWBlT3NxkD3rROplfqH+4Sq+kHhHlvy6WEjGwk4HGLfI3
        E41zrupa6x/KIGBaJyw0vhyMtbRxFQUAP5U97ZUuc2avxd98JHD+aVmpZYg1O0tDN0DoB6
        aTwPSjnTqoA6j56ZjlcLAndlTKB4Avo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-590-qj82gE5pNBqu3cm0Tp7l-g-1; Sun, 12 Feb 2023 21:29:40 -0500
X-MC-Unique: qj82gE5pNBqu3cm0Tp7l-g-1
Received: by mail-wm1-f70.google.com with SMTP id j37-20020a05600c1c2500b003deaf780ab6so6036037wms.4
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qidzccTnvZWTjmehoyXsqH06VDAcPWrPLs1KbiNU6rE=;
        b=E+RSqGPj9B0AQjO1cPpc7oH6ND0te4scr1MRbw0h/nQC+2oxAJhSR/V0ve+6pepFIR
         JZD0m2salTKn9HYGarGR9vqr+W4CXs10AFRXfozdkD6BrkTllrY7To7exBIVElbtusBO
         vxYfCrZ6bLhYFu+MOAzQypOvDGjQmvfKofBTk60T51Jg9J7X0XRvbPBFPxQxfBosskeO
         r4gH7L0vWOdBvwiT02ga9xi7HwdeI6p24aA9S/vNjYDhoQFbhY0Vn5/g8R/XKonBDJTJ
         VGLOEsO8nOm1UFYLk3Ks86Xb1NoIlTDW1JO7MzoNXuvVEywDKl70q9p3rDveumNFBMVN
         YGjQ==
X-Gm-Message-State: AO0yUKXva01yfk+rEvhkRwgHhrIuyRNUYMjjYfyJSqc/TUTzuxL+CxHz
        +t8/WhcadJJtJ7MqwSVV17ZTgG3H2xA/nsES3uzYSMHR5VxfBLWJFn/wNh/SnmwIGr2GBtrb2kF
        3StQrqHgtTpa+
X-Received: by 2002:a5d:6209:0:b0:2c3:ed14:8323 with SMTP id y9-20020a5d6209000000b002c3ed148323mr20756782wru.38.1676255378770;
        Sun, 12 Feb 2023 18:29:38 -0800 (PST)
X-Google-Smtp-Source: AK7set9CJkfVgcqqvmA2PK8UJ3ZRBCf5Ar3fjAkw0fGNmk0DoEJTWdD9PBXp0gaOgpZ5dijRQ5W3gA==
X-Received: by 2002:a5d:6209:0:b0:2c3:ed14:8323 with SMTP id y9-20020a5d6209000000b002c3ed148323mr20756766wru.38.1676255378547;
        Sun, 12 Feb 2023 18:29:38 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id v14-20020adfe28e000000b0027cb20605e3sm9290353wri.105.2023.02.12.18.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:29:37 -0800 (PST)
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
        Peter Xu <peterx@redhat.com>
Subject: [PULL 15/22] migration: Cleanup postcopy_preempt_setup()
Date:   Mon, 13 Feb 2023 03:29:04 +0100
Message-Id: <20230213022911.68490-16-xxx.xx@gmail.com>
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

