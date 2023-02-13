Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0432C693C98
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjBMCxj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjBMCx1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:53:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D384210415
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676256748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=826zd0O7d2WRwLdAeNQrO2BCJWaXFymU9+RS+HRc/0Y=;
        b=Su66OPcSd1XpFZVcmAsArcrRM8v+ic+UcMyvBOaDiOc02q89uJp1Xa8e7ma3CpHNlToW7i
        l6/UGi4j8cFFYoWPydicrywZMcLbRsYQtnNwXe2kSeumG1bz6VQQutcgm9hfWTgD8wDjd3
        OVhplifanq4qsH+kDJwCoU3XhlAfwS0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-434-v2OwhiGwMH2eP-nD8zf1VQ-1; Sun, 12 Feb 2023 21:52:26 -0500
X-MC-Unique: v2OwhiGwMH2eP-nD8zf1VQ-1
Received: by mail-wm1-f72.google.com with SMTP id o31-20020a05600c511f00b003dc53da325dso8379312wms.8
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=826zd0O7d2WRwLdAeNQrO2BCJWaXFymU9+RS+HRc/0Y=;
        b=cPv6VZho8cKp8epaG/jOOYDkO1a8+X6i+xlBRt0QJD94NDsTQtFK6Mydtt0Y1T1v30
         PHjnyD/pTjwR4mTgo1pv4u3QHGth4zEwk80X0pfSkHic7iKIqa7XQP9L1P1w6gCXlJSg
         SnopSR7lGwAReVAn5jl7Zw1X9R3zYya0F1GrArvoM4Z9mUss0a329Az9C6ojSynFSPqk
         L269yX8kO0Re7Oys3U+sVzJoLsz2pTSIGoJxmedV0pfbWPCpy2Z1HW3keW2tr3qyiJoV
         ybt8sbi9ox3fFCinQr+2TCPrlD5H8qtTw9pMkm3sJ/FGYC6szZiE4/58vFs1a7qiF7m0
         MFIQ==
X-Gm-Message-State: AO0yUKXzzZcMqR7NmSNrc9OvcWspOoFV2oX+PtsRUUQyuMMHIfBQYRc+
        3XQ2N4533UFpKPa22AaIk58I93CocUpCaMvSZaBhyWAKLCx1E7COruMGqEZKWkuz6WTbGJm0/9U
        hHayWRbPtUQyV
X-Received: by 2002:a05:600c:998:b0:3dc:59ee:7978 with SMTP id w24-20020a05600c099800b003dc59ee7978mr17860662wmp.38.1676256745323;
        Sun, 12 Feb 2023 18:52:25 -0800 (PST)
X-Google-Smtp-Source: AK7set/lnqPLcyhbtukqg1WPobPfl5GU8z3CthnoNbbEfoGXTfW3pja/FBl6VOTN6KkiWMDv9UH/rQ==
X-Received: by 2002:a05:600c:998:b0:3dc:59ee:7978 with SMTP id w24-20020a05600c099800b003dc59ee7978mr17860652wmp.38.1676256745119;
        Sun, 12 Feb 2023 18:52:25 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id az10-20020a05600c600a00b003dc3f07c876sm16043142wmb.46.2023.02.12.18.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:52:24 -0800 (PST)
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
Subject: [PULL 19/22] migration/multifd: Remove unnecessary assignment on multifd_load_cleanup()
Date:   Mon, 13 Feb 2023 03:51:47 +0100
Message-Id: <20230213025150.71537-20-quintela@redhat.com>
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

Before assigning "p->quit = true" for every multifd channel,
multifd_load_cleanup() will call multifd_recv_terminate_threads() which
already does the same assignment, while protected by a mutex.

So there is no point doing the same assignment again.

Fixes: b5eea99ec2 ("migration: Add yank feature")
Reported-by: Li Xiaohui <xiaohli@redhat.com>
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

