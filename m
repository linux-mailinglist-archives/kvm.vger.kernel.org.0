Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404A4693C83
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjBMCxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbjBMCw4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:52:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8C41043E
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676256719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fijRSvjFkArAa0ryGscnf/miuX0tMpTEdiQbyj+yK9k=;
        b=AmfmQe0PxY833gqNPhkRK2DV81c07cTpNDcjANJ00b0xwVyytENytzxRdNrfAarb+60/Jz
        7O2uJvkDDTyy9E2mjiMoHAI3UUJYKZJP2g2bnDeCQqltCaXosdoh5sqeQhZDytVY12rDUH
        XaQFzwIhyFNAbVUFNyKNLnNviPBGMHA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-453-2k-OqRWINp6BYzoX_XDjKg-1; Sun, 12 Feb 2023 21:51:58 -0500
X-MC-Unique: 2k-OqRWINp6BYzoX_XDjKg-1
Received: by mail-wm1-f71.google.com with SMTP id bd21-20020a05600c1f1500b003dc5cb10dcfso5433133wmb.9
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:51:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fijRSvjFkArAa0ryGscnf/miuX0tMpTEdiQbyj+yK9k=;
        b=ULtd+VWWtsXHJJw1F1vD4DLFC+U6288BeJWtRcKMR7M7CPl+hc10z5yKlsXA6QGEsq
         uRmrvARvgEPxXIWQURf8Q8wl+yqNKUdftMIhQycPea3rqbWaDJHKLvv+BD7HeJ5JHpWj
         r4lZ6hlHwSzTSjzsz7D0foEzZAxtjfziQkWC4NwzZvW6tfz5IXQp+PSlPLr25rb1Fo1/
         tENcUMMokZk7XFrdJKNSnNHF3nnvANnnM3X5GI3OLNcOvuc5Ym578fk1GgPLdXQ1O5/R
         BDLnyx5pZPoXcN3B7NWo4WteHcg/5f/s6IDRox6XddmXkW2mFbycv1DMQ9ke38pJjbn/
         U7VA==
X-Gm-Message-State: AO0yUKV1+9lzHCeDEgb//GFs8TOLuwSuRrwD4KzJAQNM2tvsdGPzPQaY
        595u4hNdmz5VEqe6LsfkX8wNoHeSvavIniPQB0rJAGEond3V9uKIw6mNsPl0zhAY3fVA4qTPsZW
        XWvPO3RhvxnSc
X-Received: by 2002:a5d:4385:0:b0:2c5:4e12:3849 with SMTP id i5-20020a5d4385000000b002c54e123849mr4293384wrq.61.1676256717169;
        Sun, 12 Feb 2023 18:51:57 -0800 (PST)
X-Google-Smtp-Source: AK7set+/my6h3mPqrmWiAHdxsUOCoxyNa7Ib5UwDQpLIRYv0xscLvxfhNCM0IH4W6XpkL2zna4Xtdw==
X-Received: by 2002:a5d:4385:0:b0:2c5:4e12:3849 with SMTP id i5-20020a5d4385000000b002c54e123849mr4293380wrq.61.1676256716977;
        Sun, 12 Feb 2023 18:51:56 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id a28-20020a5d457c000000b002bdda9856b5sm9466395wrc.50.2023.02.12.18.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:51:56 -0800 (PST)
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
Subject: [PULL 03/22] multifd: Remove some redundant code
Date:   Mon, 13 Feb 2023 03:51:31 +0100
Message-Id: <20230213025150.71537-4-quintela@redhat.com>
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

