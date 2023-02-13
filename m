Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D45C8693C33
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjBMCaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:30:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjBMCaC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:30:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BCFDE046
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676255358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JInKtzC6RF655Lncv3TKfNncp1aYsh6hnMBdswU/+NM=;
        b=jV5nXhFlb4rvHKZ5LkrnX3zo7rI8kFuHv/D2g8zHZc5vCe7DQbZI9ohQDQLhQLlnlutksV
        aR+SJBGK3I7HX9aoszySPEyBkq4YcJe0jBlv9kXm3lg25JnvhE1kx8Fjz2OJMF4PWfg3jb
        LKtzpp1foW1381O/EPAml0Ton5mfvZg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-92-lP8WGDFfM2aokElhk08CwA-1; Sun, 12 Feb 2023 21:29:17 -0500
X-MC-Unique: lP8WGDFfM2aokElhk08CwA-1
Received: by mail-wm1-f72.google.com with SMTP id k9-20020a05600c1c8900b003dc5dec2ac6so8369014wms.4
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JInKtzC6RF655Lncv3TKfNncp1aYsh6hnMBdswU/+NM=;
        b=zI/0RdVEI55w3fcxbURaIYc3N3JZVAoGlIZHei+Zlz2e0NWnSt1CasF1xxHuRDmjY+
         4qaQoSakaCF+RbmZtFNx9sxIeB/7Flu/jztd5EmL8Fs0aun7vLDx1ohIxVNCHN7rueOx
         w27zHCRvdjQXkpYADxAB0BaikswghLWuTt/U84Xg8fUSxiL8Iox2B5UTqR6QWnDvFG4J
         Vf4qFUtGy7+k7+aIEATT4iXcTZEx5Wg1dRiGdU7TsCpwk58Z/vSkhPtg6b5Eju7tYuFU
         fQh2Ma40ssVxajAle8rJHtkmtxkhu+m0uDnjv7oUqMO5Sel7fv0eRetJNPqxoAdIXN7U
         1mDw==
X-Gm-Message-State: AO0yUKW+09pGtdvm+iLtUf33pN1NzVnVzMJhkiLWv0YqAywv95P2mp61
        3SnToskMnIBMcuG4ES7bawH+LkF0peiL2ZoYchlvhTaUNt6j1QOXnohiAws/H9WPhaKkMcrMNV7
        25Ett2ln6xj75
X-Received: by 2002:a05:600c:43c7:b0:3dc:5d34:dbe5 with SMTP id f7-20020a05600c43c700b003dc5d34dbe5mr17913185wmn.28.1676255355925;
        Sun, 12 Feb 2023 18:29:15 -0800 (PST)
X-Google-Smtp-Source: AK7set/rjwBb1Vl5Kn13Q3fwIW6CDKguDIQoZ6LxM9T832naRAaIwrS7qzrpAyVC0aeKaOSZ6J7vtw==
X-Received: by 2002:a05:600c:43c7:b0:3dc:5d34:dbe5 with SMTP id f7-20020a05600c43c700b003dc5d34dbe5mr17913169wmn.28.1676255355752;
        Sun, 12 Feb 2023 18:29:15 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id h8-20020a05600c314800b003e11ad0750csm11591970wmo.47.2023.02.12.18.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:29:15 -0800 (PST)
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
        Li Zhang <lizhang@suse.de>
Subject: [PULL 02/22] multifd: cleanup the function multifd_channel_connect
Date:   Mon, 13 Feb 2023 03:28:51 +0100
Message-Id: <20230213022911.68490-3-xxx.xx@gmail.com>
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

