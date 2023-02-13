Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64C3693C59
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjBMCby (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:31:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbjBMCbj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:31:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5764910243
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676255392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1yhUeN6PMDjGLlmfRv43ztKFKB+CFUSApjprBMF/DVs=;
        b=cFRWuHbvypJNcwea3nEaFnSgPt6xDLxntEKtqETqyj4gmGrjmhYymaEzFMJd3H70tnWlsC
        qRAeHUKDbYVUNBbdmYQCdfy/4f7ZJOn+hoNVL/W6Ljonn8xdjsfmK94a8hnDfc+9eM11k9
        gCmmNrKia6BFPL3rsaPioIEL83+TZhc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-593-dah-WIUPM1-7Cd8WMOkMEg-1; Sun, 12 Feb 2023 21:29:50 -0500
X-MC-Unique: dah-WIUPM1-7Cd8WMOkMEg-1
Received: by mail-wm1-f70.google.com with SMTP id l38-20020a05600c1d2600b003ddff4b9a40so6033404wms.9
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1yhUeN6PMDjGLlmfRv43ztKFKB+CFUSApjprBMF/DVs=;
        b=qSXRiic6vBXMKct8j32t7MxTLYbdy2mOR3P0iRLGq2BwMmRI5v+2EY8oB7l5Lf8Th7
         ktgC/MbGyST0tObtlaCiaHy809UW8L8HhQDc7SO3mIsNQjSbSB9KsK+wS30wYfl4yBvC
         Vczdp2bTHT7h/xhhvIoo50pReNY18sS4juv+vbx8/sttIQ4ZMR4k6+KQKoR6IYPRlG54
         rHPG7ScfQiMZitiulNwER0OyX6/DIfx48rfScCLWrawsM8uKJPAulfthpQ/t/yyTEI01
         5Fph7KSR40jU0WrxYoL92DopZMDej6Fvo2Kb89utiRag3w5B/KGzNt734t8sr51VKu6+
         YFaA==
X-Gm-Message-State: AO0yUKW53BdA/teTTSvR01dHJTC81ZwP1HWV3fq89/1pFuu2NAPOcEPM
        pB0B7yFLd3huRcjRHL3Bl8jQ+mwmVmfLjbsbAqe5uklKiWxBlVijBDtZnBq1igptHsrR08pvSGX
        Im7c7Q34AIAiZ
X-Received: by 2002:a05:600c:1694:b0:3de:27c3:ef13 with SMTP id k20-20020a05600c169400b003de27c3ef13mr17673794wmn.9.1676255389379;
        Sun, 12 Feb 2023 18:29:49 -0800 (PST)
X-Google-Smtp-Source: AK7set8MM5ZCkie7NV7W++wxJDBegmWHyipkHejCobgGbh9/xnuobYvLzGnVHhdOuw7GmHpn5yPvNA==
X-Received: by 2002:a05:600c:1694:b0:3de:27c3:ef13 with SMTP id k20-20020a05600c169400b003de27c3ef13mr17673782wmn.9.1676255389180;
        Sun, 12 Feb 2023 18:29:49 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id j40-20020a05600c1c2800b003dc4480df80sm17346274wms.34.2023.02.12.18.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:29:48 -0800 (PST)
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
Subject: [PULL 21/22] migration/multifd: Move load_cleanup inside incoming_state_destroy
Date:   Mon, 13 Feb 2023 03:29:10 +0100
Message-Id: <20230213022911.68490-22-xxx.xx@gmail.com>
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

Currently running migration_incoming_state_destroy() without first running
multifd_load_cleanup() will cause a yank error:

qemu-system-x86_64: ../util/yank.c:107: yank_unregister_instance:
Assertion `QLIST_EMPTY(&entry->yankfns)' failed.
(core dumped)

The above error happens in the target host, when multifd is being used
for precopy, and then postcopy is triggered and the migration finishes.
This will crash the VM in the target host.

To avoid that, move multifd_load_cleanup() inside
migration_incoming_state_destroy(), so that the load cleanup becomes part
of the incoming state destroying process.

Running multifd_load_cleanup() twice can become an issue, though, but the
only scenario it could be ran twice is on process_incoming_migration_bh().
So removing this extra call is necessary.

On the other hand, this multifd_load_cleanup() call happens way before the
migration_incoming_state_destroy() and having this happening before
dirty_bitmap_mig_before_vm_start() and vm_start() may be a need.

So introduce a new function multifd_load_shutdown() that will mainly stop
all multifd threads and close their QIOChannels. Then use this function
instead of multifd_load_cleanup() to make sure nothing else is received
before dirty_bitmap_mig_before_vm_start().

Signed-off-by: Leonardo Bras <leobras@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/multifd.h   | 1 +
 migration/migration.c | 4 +++-
 migration/multifd.c   | 7 +++++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/migration/multifd.h b/migration/multifd.h
index 9a7e1a8826..7cfc265148 100644
--- a/migration/multifd.h
+++ b/migration/multifd.h
@@ -17,6 +17,7 @@ int multifd_save_setup(Error **errp);
 void multifd_save_cleanup(void);
 int multifd_load_setup(Error **errp);
 void multifd_load_cleanup(void);
+void multifd_load_shutdown(void);
 bool multifd_recv_all_channels_created(void);
 void multifd_recv_new_channel(QIOChannel *ioc, Error **errp);
 void multifd_recv_sync_main(void);
diff --git a/migration/migration.c b/migration/migration.c
index 5bf332fdd2..90fca70cb7 100644
--- a/migration/migration.c
+++ b/migration/migration.c
@@ -315,6 +315,8 @@ void migration_incoming_state_destroy(void)
 {
     struct MigrationIncomingState *mis = migration_incoming_get_current();
 
+    multifd_load_cleanup();
+
     if (mis->to_src_file) {
         /* Tell source that we are done */
         migrate_send_rp_shut(mis, qemu_file_get_error(mis->from_src_file) != 0);
@@ -559,7 +561,7 @@ static void process_incoming_migration_bh(void *opaque)
      */
     qemu_announce_self(&mis->announce_timer, migrate_announce_params());
 
-    multifd_load_cleanup();
+    multifd_load_shutdown();
 
     dirty_bitmap_mig_before_vm_start();
 
diff --git a/migration/multifd.c b/migration/multifd.c
index 840d5814e4..5e85c3ea9b 100644
--- a/migration/multifd.c
+++ b/migration/multifd.c
@@ -1013,6 +1013,13 @@ static void multifd_recv_terminate_threads(Error *err)
     }
 }
 
+void multifd_load_shutdown(void)
+{
+    if (migrate_use_multifd()) {
+        multifd_recv_terminate_threads(NULL);
+    }
+}
+
 void multifd_load_cleanup(void)
 {
     int i;
-- 
2.39.1

