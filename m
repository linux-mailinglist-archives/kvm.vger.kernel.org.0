Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83487693C58
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjBMCbx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjBMCbi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:31:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019CE10246
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676255393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W0nw1KUXQEI1xmDznSZCB7Y0xnFRisWgzKRd5bzpoYs=;
        b=N7ydoWpw9e6GAmZTZzJUn2DyXoYuDDUqAM9zBI+/Tz5xrVOWN6ZcmrkqKJ+hrn/VNa6Ldw
        mDTMiHamwJFCQSNB2Xpp6tVdAWTMbH2I41z2U1oYEi0QQbLuZyv+3XuHSKb3SOiNN56l+V
        /f7mzTgiN8S58ozIt0Rfh7hmhuAlXAo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-401-58zEFgLAOsSo7Rdjmfi2kg-1; Sun, 12 Feb 2023 21:29:48 -0500
X-MC-Unique: 58zEFgLAOsSo7Rdjmfi2kg-1
Received: by mail-wm1-f71.google.com with SMTP id s11-20020a05600c384b00b003dffc7343c3so5432936wmr.0
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W0nw1KUXQEI1xmDznSZCB7Y0xnFRisWgzKRd5bzpoYs=;
        b=N3SFrkwi8hJW5MTeZfTsfd8t9k992sv5rXpvrlRZNjpSUMHWCyZmet8fEjKVmAZDGN
         IrnMciMrRouX/nhoiHdJ9mhfGRZABKrr0/GkzDsIqrxZ9JZi+HCuywwgIFsaIrF9UdHX
         i3KP6ftwuI6Qd5UWNRFIpqXuTJnB079j39ni9lQExSsTma2LiBnFwlsAVkmc2YJ1lcTp
         YWtaayRRnjVV2t7RekVrArgu29jzs7eWaUzbpi/yWdjkMY3OWA7ZJnxb9LRKmCbBJie2
         ST4iqr8EU/yWIjlm/O9tPIzln5vurjXG+81/2l7lsl1C2c8nccAE5EAB9Wvu3JvGrhwM
         uiVA==
X-Gm-Message-State: AO0yUKVm3dCjLVpoK1nShriPrtAmNhuQPFJxLeyvgcsWiICrH5eBrjBs
        rCvYWrycEBUOU4nexKKsZ69+ylBF7lljRP5w50/YQLAitStVcKcJlgjwBFPXwy5ajRbjRdbNiXQ
        FIa4imkhoUh/O
X-Received: by 2002:a5d:54c2:0:b0:2c5:5574:5d5f with SMTP id x2-20020a5d54c2000000b002c555745d5fmr2753739wrv.57.1676255387445;
        Sun, 12 Feb 2023 18:29:47 -0800 (PST)
X-Google-Smtp-Source: AK7set+IfMyiKrMVGyZxcMV28tfgSW1ky+Zg7v8is/7d+LHfzSAxPDuD2M7ITqxcYPHG9kILEX7i7g==
X-Received: by 2002:a5d:54c2:0:b0:2c5:5574:5d5f with SMTP id x2-20020a5d54c2000000b002c555745d5fmr2753729wrv.57.1676255387278;
        Sun, 12 Feb 2023 18:29:47 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id h18-20020a5d4312000000b002c54d970fd8sm5217585wrq.36.2023.02.12.18.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:29:46 -0800 (PST)
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
Subject: [PULL 20/22] migration/multifd: Join all multifd threads in order to avoid leaks
Date:   Mon, 13 Feb 2023 03:29:09 +0100
Message-Id: <20230213022911.68490-21-xxx.xx@gmail.com>
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

Current approach will only join threads that are still running.

For the threads not joined, resources or private memory are always kept in
the process space and never reclaimed before process end, and this risks
serious memory leaks.

This should usually not represent a big problem, since multifd migration
is usually just ran at most a few times, and after it succeeds there is
not much to be done before exiting the process.

Yet still, it should not hurt performance to join all of them.

Signed-off-by: Leonardo Bras <leobras@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/multifd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/migration/multifd.c b/migration/multifd.c
index 3dd569d0c9..840d5814e4 100644
--- a/migration/multifd.c
+++ b/migration/multifd.c
@@ -1030,8 +1030,9 @@ void multifd_load_cleanup(void)
              * however try to wakeup it without harm in cleanup phase.
              */
             qemu_sem_post(&p->sem_sync);
-            qemu_thread_join(&p->thread);
         }
+
+        qemu_thread_join(&p->thread);
     }
     for (i = 0; i < migrate_multifd_channels(); i++) {
         MultiFDRecvParams *p = &multifd_recv_state->params[i];
-- 
2.39.1

