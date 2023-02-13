Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD36693C36
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjBMCaM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjBMCaK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:30:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76414E04B
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676255360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fijRSvjFkArAa0ryGscnf/miuX0tMpTEdiQbyj+yK9k=;
        b=NbLSC+iIqFWtBOGYlLf9FKOGN1Ky82OGVJjJ0tQVZVxhH55XUv2FxwrP7Du6yoToXTdq7H
        GTMlVkYIGHe+Hofghg2mZUJJSHMO1mmoSYsVXWNU6FvnzNDuPppn/wEi9JHkKNb9lGQsQe
        yqXwKf4ilS45krhod58kLZ4tN2TzszU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-271-nE_CLDISN5-v1-es6_G2Ig-1; Sun, 12 Feb 2023 21:29:19 -0500
X-MC-Unique: nE_CLDISN5-v1-es6_G2Ig-1
Received: by mail-wm1-f69.google.com with SMTP id k9-20020a05600c1c8900b003dc5dec2ac6so8369044wms.4
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fijRSvjFkArAa0ryGscnf/miuX0tMpTEdiQbyj+yK9k=;
        b=kLKWNTy345FKFi6D5RN2SLNPNPonR1ex9GaD6kWNWuvyIBXh748/HwUWX1Imm9aSUg
         JOWl5QcZZ/IySwFMPSoRO7SPaSjFusRaJ8f2BdS7il33vHMviEyhR+gVdrhrcE6Xhqdv
         8nKWBzKM+89aBNQPN+hz0SfSTnoIP9r1Kc+/4Fkz2gYV5MxZQ7ow0LtPWJ1dI0OEtOU8
         gKe8aFLGiV4bPr9tTOe5UFwwRrjUm8sRkTM28iVJggrh5wjtkhQkYiJ5JCq+EB4+aYY7
         FvHUikS3j/dE3DAgq7564/dm8kYgsBSs/C35yVNblxpGpOL3EX3QDZ7ijTkeAVCf96IW
         5cag==
X-Gm-Message-State: AO0yUKXF0if/vPapMj9KSRUU47gWh2LEBQYa+P4KYFHBIlhxfUp/m174
        tPT5ayVyKzDmslCcvfh981bYc2laWVhEyJB5AmAMyDtB1OX/nccup4pOA7HMKn0pWaoVwTUmvHo
        /9U5eE6VtDSlFOw/xTA==
X-Received: by 2002:a05:600c:2e95:b0:3da:50b0:e96a with SMTP id p21-20020a05600c2e9500b003da50b0e96amr17717812wmn.29.1676255357648;
        Sun, 12 Feb 2023 18:29:17 -0800 (PST)
X-Google-Smtp-Source: AK7set/ePT7yZrSLaWTYTHkBPJUuVE73ZelgzSYQoSEBhGWKGcLJkV+9MQOnbGiclZ+GH13iJCa+/g==
X-Received: by 2002:a05:600c:2e95:b0:3da:50b0:e96a with SMTP id p21-20020a05600c2e9500b003da50b0e96amr17717809wmn.29.1676255357431;
        Sun, 12 Feb 2023 18:29:17 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id a1-20020a05600c348100b003db0ee277b2sm15824328wmq.5.2023.02.12.18.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:29:16 -0800 (PST)
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
Subject: [PULL 03/22] multifd: Remove some redundant code
Date:   Mon, 13 Feb 2023 03:28:52 +0100
Message-Id: <20230213022911.68490-4-xxx.xx@gmail.com>
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

Clean up some unnecessary code

Signed-off-by: Li Zhang <lizhang@suse.de>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/multifd.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/migration/multifd.c b/migration/multifd.c
index c8132ab7e8..7aa030fb19 100644
--- a/migration/multifd.c
+++ b/migration/multifd.c
@@ -892,19 +892,15 @@ static void multifd_new_send_channel_async(QIOTask *task, gpointer opaque)
     Error *local_err = NULL;
 
     trace_multifd_new_send_channel_async(p->id);
-    if (qio_task_propagate_error(task, &local_err)) {
-        goto cleanup;
-    } else {
+    if (!qio_task_propagate_error(task, &local_err)) {
         p->c = QIO_CHANNEL(sioc);
         qio_channel_set_delay(p->c, false);
         p->running = true;
-        if (!multifd_channel_connect(p, sioc, local_err)) {
-            goto cleanup;
+        if (multifd_channel_connect(p, sioc, local_err)) {
+            return;
         }
-        return;
     }
 
-cleanup:
     multifd_new_send_channel_cleanup(p, sioc, local_err);
 }
 
@@ -1115,10 +1111,7 @@ static void *multifd_recv_thread(void *opaque)
 
         ret = qio_channel_read_all_eof(p->c, (void *)p->packet,
                                        p->packet_len, &local_err);
-        if (ret == 0) {   /* EOF */
-            break;
-        }
-        if (ret == -1) {   /* Error */
+        if (ret == 0 || ret == -1) {   /* 0: EOF  -1: Error */
             break;
         }
 
-- 
2.39.1

