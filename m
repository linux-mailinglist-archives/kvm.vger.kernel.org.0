Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74573693C80
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjBMCw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjBMCwv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:52:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183961040D
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:51:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676256717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JInKtzC6RF655Lncv3TKfNncp1aYsh6hnMBdswU/+NM=;
        b=gOnDuyzxVp+LYSPo4rLrkUH75ZhG6TbGyIQ0SjrGUmV0/9BHJPk4vQNzQqrKATJkngdIcj
        JwArwqVNN8QQFBtXz2sgCyb6K19ZshgSqaVuQwjBa1uxkUWcj2q6Tt0jobhEwvSwVGGw44
        R5PXFe2gCz0+qy5j8WkeuSer54WV+IM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-630-ZaOyH_y0N-S61pnp5sFuRQ-1; Sun, 12 Feb 2023 21:51:56 -0500
X-MC-Unique: ZaOyH_y0N-S61pnp5sFuRQ-1
Received: by mail-wm1-f70.google.com with SMTP id b19-20020a05600c4e1300b003e10d3e1c23so8039596wmq.1
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:51:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JInKtzC6RF655Lncv3TKfNncp1aYsh6hnMBdswU/+NM=;
        b=5t2L1l4ACxZ3IhYGnBpxYuz0Sh20w4QCn8I/gtUusyF/7Bv42IFXQ3MhNgUJCfSFei
         rtsf1vcquxHKORVbiatecRID9kN6Vx46t4yuiMvw81utprzy+9YBFImWHLbJkMg+z0dP
         YnKE+sQzXL/B6ChcqXc+PTyvlHi9PZC7jy3YXRHxvR5Btr8WD+rB/4xPQtapbjiVFsQ3
         PuDf4yubxpVAFBRxNjOvgjipyYkVjDhhTOXW9Wl3wqxM5ktE7FPbkVhLQ/Os3RoQ1FsJ
         A9EB/+Y8UiSh2KS8A6lUNLK79NUUCy+VL3txos24W5QPFu86wEa2Fy2hreJ3kicTOhQz
         yJTA==
X-Gm-Message-State: AO0yUKXE23EZ+TqfvNyr58xQl2r05AhNHjW0fvNuGaHOMlCtHM6ovaWN
        CYnmPVZGtJdgdj2o3ANDI3Loi5joHC2o+FACzW+y+IsiLluCnAWU3vfxG5VDto82Ge3pF8MGSCo
        gW0gfyluJngR5
X-Received: by 2002:adf:e60c:0:b0:2c3:eaff:aaef with SMTP id p12-20020adfe60c000000b002c3eaffaaefmr19755190wrm.18.1676256715501;
        Sun, 12 Feb 2023 18:51:55 -0800 (PST)
X-Google-Smtp-Source: AK7set+vbmy11F2J9n6YDP85+T3aaDiW+U7B0hYtIgECTAckwoUqEZISnP7TIWsV5ayWcY9imD7VdQ==
X-Received: by 2002:adf:e60c:0:b0:2c3:eaff:aaef with SMTP id p12-20020adfe60c000000b002c3eaffaaefmr19755184wrm.18.1676256715321;
        Sun, 12 Feb 2023 18:51:55 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id e1-20020adfe381000000b002c54f39d34csm4746148wrm.111.2023.02.12.18.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:51:54 -0800 (PST)
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
        Li Zhang <lizhang@suse.de>
Subject: [PULL 02/22] multifd: cleanup the function multifd_channel_connect
Date:   Mon, 13 Feb 2023 03:51:30 +0100
Message-Id: <20230213025150.71537-3-quintela@redhat.com>
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

From: Li Zhang <lizhang@suse.de>

Cleanup multifd_channel_connect

Signed-off-by: Li Zhang <lizhang@suse.de>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/multifd.c | 43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/migration/multifd.c b/migration/multifd.c
index b7ad7002e0..c8132ab7e8 100644
--- a/migration/multifd.c
+++ b/migration/multifd.c
@@ -843,30 +843,29 @@ static bool multifd_channel_connect(MultiFDSendParams *p,
         ioc, object_get_typename(OBJECT(ioc)),
         migrate_get_current()->hostname, error);
 
-    if (!error) {
-        if (migrate_channel_requires_tls_upgrade(ioc)) {
-            multifd_tls_channel_connect(p, ioc, &error);
-            if (!error) {
-                /*
-                 * tls_channel_connect will call back to this
-                 * function after the TLS handshake,
-                 * so we mustn't call multifd_send_thread until then
-                 */
-                return true;
-            } else {
-                return false;
-            }
+    if (error) {
+        return false;
+    }
+    if (migrate_channel_requires_tls_upgrade(ioc)) {
+        multifd_tls_channel_connect(p, ioc, &error);
+        if (!error) {
+            /*
+             * tls_channel_connect will call back to this
+             * function after the TLS handshake,
+             * so we mustn't call multifd_send_thread until then
+             */
+            return true;
         } else {
-            migration_ioc_register_yank(ioc);
-            p->registered_yank = true;
-            p->c = ioc;
-            qemu_thread_create(&p->thread, p->name, multifd_send_thread, p,
-                                   QEMU_THREAD_JOINABLE);
-       }
-       return true;
+            return false;
+        }
+    } else {
+        migration_ioc_register_yank(ioc);
+        p->registered_yank = true;
+        p->c = ioc;
+        qemu_thread_create(&p->thread, p->name, multifd_send_thread, p,
+                           QEMU_THREAD_JOINABLE);
     }
-
-    return false;
+    return true;
 }
 
 static void multifd_new_send_channel_cleanup(MultiFDSendParams *p,
-- 
2.39.1

