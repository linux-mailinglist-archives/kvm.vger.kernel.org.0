Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2279585045
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 15:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236181AbiG2NCc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 09:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236156AbiG2NCb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 09:02:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9438441989
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 06:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659099749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jr0cdIeZwQm9yeviOFlC/QVSAnd2NCODQdmfBRtYP5A=;
        b=PebxDUw/5Lhbmv22lx3H6i7U+crOyZsdNCh9a6CSLRJQHd4jhvaFO1Ill3Y294JR/ktdz+
        Ap5Deip9LekRljeymkgWkJJBBFsAYvrD7JOpdt61CRse+ANMg26LWdh6Cgzd0P1WOvECuW
        JMKwUguJeZsChpyrxEoM7KYzYT60ISU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-317-jK1iQRqtMIuUylAnjF7ulQ-1; Fri, 29 Jul 2022 09:02:26 -0400
X-MC-Unique: jK1iQRqtMIuUylAnjF7ulQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 251B4380451F;
        Fri, 29 Jul 2022 13:02:24 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 418802026D64;
        Fri, 29 Jul 2022 13:02:14 +0000 (UTC)
From:   Alberto Faria <afaria@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Peter Lieven <pl@kamp.de>, kvm@vger.kernel.org,
        Xie Yongji <xieyongji@bytedance.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Jeff Cody <codyprime@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        "Denis V. Lunev" <den@openvz.org>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Christian Schoenebeck <qemu_oss@crudebyte.com>,
        Stefan Weil <sw@weilnetz.de>, Klaus Jensen <its@irrelevant.dk>,
        Laurent Vivier <lvivier@redhat.com>,
        Alberto Garcia <berto@igalia.com>,
        Michael Roth <michael.roth@amd.com>,
        Juan Quintela <quintela@redhat.com>,
        David Hildenbrand <david@redhat.com>, qemu-block@nongnu.org,
        Konstantin Kostiuk <kkostiuk@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Greg Kurz <groug@kaod.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Amit Shah <amit@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Fam Zheng <fam@euphon.net>, Thomas Huth <thuth@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        "Richard W.M. Jones" <rjones@redhat.com>,
        John Snow <jsnow@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Alberto Faria <afaria@redhat.com>
Subject: [RFC v2 08/10] Fix some bad coroutine_fn indirect calls and pointer assignments
Date:   Fri, 29 Jul 2022 14:00:37 +0100
Message-Id: <20220729130040.1428779-9-afaria@redhat.com>
In-Reply-To: <20220729130040.1428779-1-afaria@redhat.com>
References: <20220729130040.1428779-1-afaria@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These problems were found by static-analyzer.py.

Not all occurrences of these problems were fixed.

Signed-off-by: Alberto Faria <afaria@redhat.com>
---
 block/backup.c                   |  2 +-
 include/block/block_int-common.h | 12 +++++-------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/block/backup.c b/block/backup.c
index b2b649e305..6a9ad97a53 100644
--- a/block/backup.c
+++ b/block/backup.c
@@ -309,7 +309,7 @@ static void coroutine_fn backup_pause(Job *job)
     }
 }
 
-static void coroutine_fn backup_set_speed(BlockJob *job, int64_t speed)
+static void backup_set_speed(BlockJob *job, int64_t speed)
 {
     BackupBlockJob *s = container_of(job, BackupBlockJob, common);
 
diff --git a/include/block/block_int-common.h b/include/block/block_int-common.h
index 8947abab76..16c45d1262 100644
--- a/include/block/block_int-common.h
+++ b/include/block/block_int-common.h
@@ -731,13 +731,11 @@ struct BlockDriver {
     void coroutine_fn (*bdrv_co_drain_end)(BlockDriverState *bs);
 
     bool (*bdrv_supports_persistent_dirty_bitmap)(BlockDriverState *bs);
-    bool (*bdrv_co_can_store_new_dirty_bitmap)(BlockDriverState *bs,
-                                               const char *name,
-                                               uint32_t granularity,
-                                               Error **errp);
-    int (*bdrv_co_remove_persistent_dirty_bitmap)(BlockDriverState *bs,
-                                                  const char *name,
-                                                  Error **errp);
+    bool coroutine_fn (*bdrv_co_can_store_new_dirty_bitmap)(
+        BlockDriverState *bs, const char *name, uint32_t granularity,
+        Error **errp);
+    int coroutine_fn (*bdrv_co_remove_persistent_dirty_bitmap)(
+        BlockDriverState *bs, const char *name, Error **errp);
 };
 
 static inline bool block_driver_can_compress(BlockDriver *drv)
-- 
2.37.1

