Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365F5693C4D
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjBMCbR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbjBMCa7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:30:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E58FF3B
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676255388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tSe+Gdu1AJDo4dQjmBB0UPRFbXEKMEpLnQVbJ+wkYp0=;
        b=jKXKO6meLxNJtFsUScFu2LmmQmbrP4JS94q1TP+bnlQOxg17ZwJS2K/GOJ2g101vl/DjVZ
        adIcomAp1nkcQ1R5wWK7bdE4XwD5kMLfRVWmGal1ZH52pp1zRe3vnLFbOgoQE/VR5s0iuR
        GFsAUVMfMp/lU3b1V2h2AsTkixcR8TE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-655-Z-cUbtCzP_2y0VVd9tQ4Kg-1; Sun, 12 Feb 2023 21:29:46 -0500
X-MC-Unique: Z-cUbtCzP_2y0VVd9tQ4Kg-1
Received: by mail-wm1-f71.google.com with SMTP id iz20-20020a05600c555400b003dc53fcc88fso6039086wmb.2
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tSe+Gdu1AJDo4dQjmBB0UPRFbXEKMEpLnQVbJ+wkYp0=;
        b=Mt6fISWzt64afW50QyX480SjJJX82//9pY8bCFN7D36WSHZcyNfJW3P2BQ0pqhegm8
         6yuja7l7Y9WV9Dbb2gZo0Fu7orAvzdwT2Af8FPxEHn/ZhUEet2hUdTjUa0am8NjTMoY2
         BlwjxO65JzGQ6SvMa2B4D9G2AstyTWmXYBhqXZJ3b2Az/tABnPbzKQH4ZL5wkPIZ2etI
         FUI3tgvRJGPhTkoTiefYUqWgNu4da2kcyvaXUz2xHNph+Qpb64JvNECWJkpLVku83gRr
         L9pANdtZNLWMUMaOzE8DXYlQMUrFRtAj2hqkk6ZXIZp7rkFfeS0mKvjM7wq1TIqL0SXL
         YQbA==
X-Gm-Message-State: AO0yUKXxePkCXZ4Uzm1Qk4dULG37p+VKOvFBKwRsqcE7s/Mr38ulnV2B
        zTU8G2MnsZBRnNF+T76TxmuZbKGMtSfdtWDISM4JAPaVW6PpJUr9ZHNNowZXwW7dRiKo/+ZcX6l
        J5aeVNaw1WRD6
X-Received: by 2002:adf:e608:0:b0:2c3:e0a0:93f with SMTP id p8-20020adfe608000000b002c3e0a0093fmr18298422wrm.8.1676255385505;
        Sun, 12 Feb 2023 18:29:45 -0800 (PST)
X-Google-Smtp-Source: AK7set+WKuAYOVOi5T8g/gwIH4YXlwRtin+i6T7IHgekqnQDqwh6cmXscxDcqMGyyd1yN/d6+Bf2LQ==
X-Received: by 2002:adf:e608:0:b0:2c3:e0a0:93f with SMTP id p8-20020adfe608000000b002c3e0a0093fmr18298417wrm.8.1676255385331;
        Sun, 12 Feb 2023 18:29:45 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id h16-20020a5d6890000000b002c553509db7sm2979924wru.52.2023.02.12.18.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:29:44 -0800 (PST)
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
Subject: [PULL 19/22] migration/multifd: Remove unnecessary assignment on multifd_load_cleanup()
Date:   Mon, 13 Feb 2023 03:29:08 +0100
Message-Id: <20230213022911.68490-20-xxx.xx@gmail.com>
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

Before assigning "p->quit = true" for every multifd channel,
multifd_load_cleanup() will call multifd_recv_terminate_threads() which
already does the same assignment, while protected by a mutex.

So there is no point doing the same assignment again.

Signed-off-by: Leonardo Bras <leobras@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/multifd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/migration/multifd.c b/migration/multifd.c
index cac8496edc..3dd569d0c9 100644
--- a/migration/multifd.c
+++ b/migration/multifd.c
@@ -1025,7 +1025,6 @@ void multifd_load_cleanup(void)
         MultiFDRecvParams *p = &multifd_recv_state->params[i];
 
         if (p->running) {
-            p->quit = true;
             /*
              * multifd_recv_thread may hung at MULTIFD_FLAG_SYNC handle code,
              * however try to wakeup it without harm in cleanup phase.
-- 
2.39.1

