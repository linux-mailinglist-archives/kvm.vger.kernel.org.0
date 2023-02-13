Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC9A693C9B
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjBMCxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjBMCx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:53:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9E010A80
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676256750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6F1ytG82HghmM9+Be+OnSoaHtAltN0OwlcsGh3hnda0=;
        b=B16SUJq/Ok2Nn97bNMWvWfIXSneVmJXGZ4M6AonFD5Za8wIul6b8pBXiSuLGZfdhiymR3D
        XJ0knfLmDmLSBGXL42JNjEf0dTeQaamc8N7c5bqUdBjyS+6OZyZW9JLFEmM9ixfUHXNW9E
        EePljKu82xk9GiipDMrnSfQOQiEAxek=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-399-ZFomTCmsPTKXzlb8ERE7Sw-1; Sun, 12 Feb 2023 21:52:21 -0500
X-MC-Unique: ZFomTCmsPTKXzlb8ERE7Sw-1
Received: by mail-wm1-f69.google.com with SMTP id n4-20020a05600c3b8400b003dfe223de49so8394005wms.5
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6F1ytG82HghmM9+Be+OnSoaHtAltN0OwlcsGh3hnda0=;
        b=doEpIIpYQ58EjW5b0CtYPRqhwJKDFnFhccuY5TFjnW6q2sN7/U45zWdzzztRL32/zJ
         2iFAHDCaHQpXGPc12BZRu9L3om64OewrZoPXPtp7OMDEG5gf1nCuotAY7GefxF0ezeHd
         HC69czYOz08aXxS6s4NUSpUd3oMwaRiiDeCgGKBPkVPJXd5FUzOaPff3XJPg9Bxgav3J
         Cy/k3mnZR8GuTU/4LIrOlVXtciJttSMuZ3j0YfMqcW2rgpeXJjswo6uJpN9iQrGSze4m
         gv947Gtav5JaaZYi7Qr+96rGJLsbO7wi+VOFZJXA83paFjhxiKK8k5+2JL80NW5ixTzt
         vhfQ==
X-Gm-Message-State: AO0yUKXIpfQ7yUN08qYnM93Y7TOAx0XpWyZrM7AosoKDb7AJkKrjSI0+
        GoqtM75bDCkI71jZSEJMFWWonieubccAse47YuVXLcv6kqGjxESBgNeZU9+LvQZJrvfJ9VDwwOK
        iRpoOm14QXO8A
X-Received: by 2002:a05:600c:4da5:b0:3dd:1c45:fe3a with SMTP id v37-20020a05600c4da500b003dd1c45fe3amr3413603wmp.16.1676256739991;
        Sun, 12 Feb 2023 18:52:19 -0800 (PST)
X-Google-Smtp-Source: AK7set9rghx0DQjPAU9VrEkfJWsHDnyh4R9fsu4JMX8E/jlKi4RkpYrD8tZ48AksHhVP4o/cODgzjg==
X-Received: by 2002:a05:600c:4da5:b0:3dd:1c45:fe3a with SMTP id v37-20020a05600c4da500b003dd1c45fe3amr3413587wmp.16.1676256739765;
        Sun, 12 Feb 2023 18:52:19 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id p5-20020a1c5445000000b003dc492e4430sm12389664wmi.28.2023.02.12.18.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:52:19 -0800 (PST)
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
        Peter Xu <peterx@redhat.com>
Subject: [PULL 16/22] migration: Add a semaphore to count PONGs
Date:   Mon, 13 Feb 2023 03:51:44 +0100
Message-Id: <20230213025150.71537-17-quintela@redhat.com>
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

From: Peter Xu <peterx@redhat.com>

This is mostly useless, but useful for us to know whether the main channel
is correctly established without changing the migration protocol.

Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/migration.h | 6 ++++++
 migration/migration.c | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/migration/migration.h b/migration/migration.h
index c351872360..4cb1cb6fa8 100644
--- a/migration/migration.h
+++ b/migration/migration.h
@@ -276,6 +276,12 @@ struct MigrationState {
          */
         bool          rp_thread_created;
         QemuSemaphore rp_sem;
+        /*
+         * We post to this when we got one PONG from dest. So far it's an
+         * easy way to know the main channel has successfully established
+         * on dest QEMU.
+         */
+        QemuSemaphore rp_pong_acks;
     } rp_state;
 
     double mbps;
diff --git a/migration/migration.c b/migration/migration.c
index fb0ecf5649..a2e362541d 100644
--- a/migration/migration.c
+++ b/migration/migration.c
@@ -3025,6 +3025,7 @@ retry:
         case MIG_RP_MSG_PONG:
             tmp32 = ldl_be_p(buf);
             trace_source_return_path_thread_pong(tmp32);
+            qemu_sem_post(&ms->rp_state.rp_pong_acks);
             break;
 
         case MIG_RP_MSG_REQ_PAGES:
@@ -4524,6 +4525,7 @@ static void migration_instance_finalize(Object *obj)
     qemu_sem_destroy(&ms->postcopy_pause_sem);
     qemu_sem_destroy(&ms->postcopy_pause_rp_sem);
     qemu_sem_destroy(&ms->rp_state.rp_sem);
+    qemu_sem_destroy(&ms->rp_state.rp_pong_acks);
     qemu_sem_destroy(&ms->postcopy_qemufile_src_sem);
     error_free(ms->error);
 }
@@ -4570,6 +4572,7 @@ static void migration_instance_init(Object *obj)
     qemu_sem_init(&ms->postcopy_pause_sem, 0);
     qemu_sem_init(&ms->postcopy_pause_rp_sem, 0);
     qemu_sem_init(&ms->rp_state.rp_sem, 0);
+    qemu_sem_init(&ms->rp_state.rp_pong_acks, 0);
     qemu_sem_init(&ms->rate_limit_sem, 0);
     qemu_sem_init(&ms->wait_unplug_sem, 0);
     qemu_sem_init(&ms->postcopy_qemufile_src_sem, 0);
-- 
2.39.1

