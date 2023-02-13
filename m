Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63064693C9A
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjBMCxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:53:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjBMCx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:53:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76C910243
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676256751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w+iFHSuieMPGwfVC1TUB1Z5r823JrerG+nuKKfxfBVc=;
        b=UHUvUumpt4nIcKS2v3noR3LRHnq3T1+C8Y+g8TQM90uvAjNc4g34yfH7LynS4XQZUelWXS
        8VSOc0N5MAPpMCNUY6LOAKKaisdCrTsnalaNhS9gfjcPJod8QLQwjo4f01hBkw/49waui6
        B72z1RSVNT2R91APCIYK+9o1djveCLA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-482-gXRn0hh-OyiR2O2RGAbYzg-1; Sun, 12 Feb 2023 21:52:29 -0500
X-MC-Unique: gXRn0hh-OyiR2O2RGAbYzg-1
Received: by mail-wm1-f70.google.com with SMTP id p14-20020a05600c468e00b003e0107732f4so5448008wmo.1
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w+iFHSuieMPGwfVC1TUB1Z5r823JrerG+nuKKfxfBVc=;
        b=YVly/Y+5MQUwZBo4DYkeY6/edyQnE1qiyjN/0nEqUODD5eYpKskOSBKiN5HTQuLc6L
         /dzqTC1NtlxIoniaQR51Ec63AQ5Fta/NNzKoKcYA90U4WtbEuZZ5KcwzgT/dofdDJ4tb
         qHe6l93tGPMk159nuShLCIDPnYv4EOHg5lE2NzfCJftos6gtQDoy5U2uk+QRg2YFsOjn
         O7YX1qmQdHxoLRQv4V03aDFDC6fTNdh1fXUwE2iviTA68AJKjdDrHXXW/s721ZNTPSEQ
         2BBj7xyHM+1OirX60LLQbLM5N61auuoRE0dIPDvpb6b3qwrnHzreN0RzmMCIVn139BaU
         6+Iw==
X-Gm-Message-State: AO0yUKWQu0nRbQeEJvnCnERL5R8Cspaaq7NG3laNAtjSPxiWKXdBAR84
        NCF0QFGGKyQjL0Y9BV1opF6m6t3ki2RaxKCi29uK/ytOE7f4xj0vn1vQWWAeaUODAzjT+pGFbku
        fCl46lvLH8kJ2
X-Received: by 2002:adf:fdc8:0:b0:2c5:5048:8a6a with SMTP id i8-20020adffdc8000000b002c550488a6amr3774540wrs.60.1676256748529;
        Sun, 12 Feb 2023 18:52:28 -0800 (PST)
X-Google-Smtp-Source: AK7set/qnbNBMTIX1+jGWEajvhQy9YxTtilAHQHXHMPXyXd1waXlUQgvS4VO0mzMy5H4N8K+izX9LA==
X-Received: by 2002:adf:fdc8:0:b0:2c5:5048:8a6a with SMTP id i8-20020adffdc8000000b002c550488a6amr3774532wrs.60.1676256748301;
        Sun, 12 Feb 2023 18:52:28 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id i14-20020adff30e000000b00241fab5a296sm9375986wro.40.2023.02.12.18.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:52:27 -0800 (PST)
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
Subject: [PULL 21/22] migration/multifd: Move load_cleanup inside incoming_state_destroy
Date:   Mon, 13 Feb 2023 03:51:49 +0100
Message-Id: <20230213025150.71537-22-quintela@redhat.com>
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

Fixes: b5eea99ec2 ("migration: Add yank feature")
Reported-by: Li Xiaohui <xiaohli@redhat.com>
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

