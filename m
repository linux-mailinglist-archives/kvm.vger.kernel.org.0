Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96984693C97
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjBMCxh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjBMCx0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:53:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64321042F
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676256750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aku3Smvsd7foub2ZcjYodstE9WWFFvGfDbRG9BvKPnM=;
        b=OxdYnoR5rzH+c+reuNeUHyI6KLnRgkUq97ISQ0BlwfrYSU22f1deWtjjsSzln29fHhTsdB
        3t9w8R/oyFi0DB5yKl4Eaw8p0dOgzI4S/jjOqrPbGrsb0a+PDOO7enJfNiz+gu3fVUr4D1
        ACdadcaPmYWdjJcw/pLBQZcZoUA5FKk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-263-c_wGH_R8MJWI1Ystkod2AA-1; Sun, 12 Feb 2023 21:52:27 -0500
X-MC-Unique: c_wGH_R8MJWI1Ystkod2AA-1
Received: by mail-wm1-f70.google.com with SMTP id s11-20020a05600c384b00b003dffc7343c3so5451443wmr.0
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aku3Smvsd7foub2ZcjYodstE9WWFFvGfDbRG9BvKPnM=;
        b=2ixZ2QHmoCUeqPEqzuekDWZuhqcZFOaMUdhs/ZMhHc5k7z3AhMYi3BsEoBhHfvC5Fl
         7c8U31vOGZxOr/56g1APJEvfepAxC6UOqXo8fmL6YFq5CDFV1hrJtkzjN89mx5D6KGd1
         dD0s55y8oKx4Bvn/15X3tU9Y9gCGkqdBQELngpsvOtxFfUIVjSVfnS6B1AMvjASpmJpN
         HPDI+MygcXhuTzhBZ9e3qfvQz3607UKWYxSZ8h7T28v1/ygyehqzHlvnC+I/8YsgvQTU
         PQmq6EsvRaqBM7CUs2zb/ol+R92oVmS5ISbcsQuEAre8vVc4K4He5/Qx6QggVTZYn3cA
         RwYA==
X-Gm-Message-State: AO0yUKWJVffOsHoRw9uRiaK0hVUlOZ2GnFwL6qyIVIV/tMytYftY3VoY
        HnNJhFJERupchYxUY/lgI25KDLH4yaBxj1Hso6cZdtjrYLSg3xSgYTsqFwUauWLcq8pygVQJ2YH
        sO81pquz0W1Co
X-Received: by 2002:a1c:545e:0:b0:3df:9858:c03f with SMTP id p30-20020a1c545e000000b003df9858c03fmr4483872wmi.20.1676256746819;
        Sun, 12 Feb 2023 18:52:26 -0800 (PST)
X-Google-Smtp-Source: AK7set+S3+gDNfnn+jOTzy9l1YpKX33WuB9LJ3aeiZkM4Qf3sBxd+W06a96lPgLIX4LtF7uwJNMqAQ==
X-Received: by 2002:a1c:545e:0:b0:3df:9858:c03f with SMTP id p30-20020a1c545e000000b003df9858c03fmr4483863wmi.20.1676256746658;
        Sun, 12 Feb 2023 18:52:26 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id k21-20020a05600c1c9500b003dd1c45a7b0sm13099849wms.23.2023.02.12.18.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:52:26 -0800 (PST)
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
Subject: [PULL 20/22] migration/multifd: Join all multifd threads in order to avoid leaks
Date:   Mon, 13 Feb 2023 03:51:48 +0100
Message-Id: <20230213025150.71537-21-quintela@redhat.com>
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

Current approach will only join threads that are still running.

For the threads not joined, resources or private memory are always kept in
the process space and never reclaimed before process end, and this risks
serious memory leaks.

This should usually not represent a big problem, since multifd migration
is usually just ran at most a few times, and after it succeeds there is
not much to be done before exiting the process.

Yet still, it should not hurt performance to join all of them.

Fixes: b5eea99ec2 ("migration: Add yank feature")
Reported-by: Li Xiaohui <xiaohli@redhat.com>
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

