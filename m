Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C068691494
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 00:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjBIXgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 18:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbjBIXfp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 18:35:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A556E988
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 15:34:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675985675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JInKtzC6RF655Lncv3TKfNncp1aYsh6hnMBdswU/+NM=;
        b=K9+Ab6rwjPymC3CLyPWGcd5ueNB678weADUODEI6kSAWIMww+GVALzFxK3hZinzTneinRy
        0g9392MRdLW7IiOamao9LRwl/bPlkLHdjlzAlCHBTLsJ+VokDlnH37znWX2lDW0vAC1dSi
        WCtVv/ut3+TA0H53C137A2iWuZ3pw00=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-uGnPQdBcOLSAauHZwLs_aQ-1; Thu, 09 Feb 2023 18:34:34 -0500
X-MC-Unique: uGnPQdBcOLSAauHZwLs_aQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BAE98027EB;
        Thu,  9 Feb 2023 23:34:34 +0000 (UTC)
Received: from secure.mitica (unknown [10.39.192.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01C62175AD;
        Thu,  9 Feb 2023 23:34:31 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Li Zhang <lizhang@suse.de>
Subject: [PULL 02/17] multifd: cleanup the function multifd_channel_connect
Date:   Fri, 10 Feb 2023 00:34:11 +0100
Message-Id: <20230209233426.37811-3-quintela@redhat.com>
In-Reply-To: <20230209233426.37811-1-quintela@redhat.com>
References: <20230209233426.37811-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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

