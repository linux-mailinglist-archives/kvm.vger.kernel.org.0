Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 433F9585044
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 15:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236160AbiG2NCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 09:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236177AbiG2NCK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 09:02:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 133E947B82
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 06:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659099728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uM2+YjYqpFghubDp5i9aIns4EbvMjbOWJOkNYI8L4tY=;
        b=GvBB4HS8slqWLpoMGZ4wKupyaw4eX1/mw+l8sVkAY/E0j46s5heO1nVGOfX6Hyzon2M3tA
        +RZ9T4TflEULk1iMHJERoGtCuls44YhFb04fbFjf9PQk0jh8CDzba8/WyOU8APdnLd+FGk
        5aThL6Ov6NrxHG+lGX+w4/LkuhQ88VQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-60-17C_Yy5APUimLBN3gMTCwQ-1; Fri, 29 Jul 2022 09:02:04 -0400
X-MC-Unique: 17C_Yy5APUimLBN3gMTCwQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACB03380451C;
        Fri, 29 Jul 2022 13:02:03 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D2512026D64;
        Fri, 29 Jul 2022 13:01:53 +0000 (UTC)
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
Subject: [RFC v2 06/10] Fix some direct calls from non-coroutine_fn to coroutine_fn
Date:   Fri, 29 Jul 2022 14:00:35 +0100
Message-Id: <20220729130040.1428779-7-afaria@redhat.com>
In-Reply-To: <20220729130040.1428779-1-afaria@redhat.com>
References: <20220729130040.1428779-1-afaria@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In some cases we need to use a different function, in others we need to
make the caller a coroutine_fn, and in others still we need to wrap
calls to coroutines in __allow_coroutine_fn_call().

Also fix coroutine_fn annotation disagreements between several
declarations of the same function.

These problems were found by static-analyzer.py.

Not all occurrences of these problems were fixed.

Signed-off-by: Alberto Faria <afaria@redhat.com>
---
 block.c                        |  2 +-
 block/dirty-bitmap.c           |  6 ++++--
 block/io.c                     | 18 +++++++++++-------
 block/monitor/block-hmp-cmds.c |  2 +-
 block/nvme.c                   |  3 ++-
 block/qcow2.c                  | 14 +++++++-------
 block/qcow2.h                  | 14 +++++++-------
 block/qed.c                    |  2 +-
 block/quorum.c                 |  2 +-
 block/ssh.c                    |  6 +++---
 block/throttle-groups.c        |  3 ++-
 include/block/block-hmp-cmds.h |  2 +-
 include/block/block-io.h       |  5 +++--
 include/qemu/coroutine.h       | 18 ++++++++++--------
 14 files changed, 54 insertions(+), 43 deletions(-)

diff --git a/block.c b/block.c
index bc85f46eed..9f3814cbaa 100644
--- a/block.c
+++ b/block.c
@@ -561,7 +561,7 @@ int bdrv_create(BlockDriver *drv, const char* filename,
 
     if (qemu_in_coroutine()) {
         /* Fast-path if already in coroutine context */
-        bdrv_create_co_entry(&cco);
+        __allow_coroutine_fn_call(bdrv_create_co_entry(&cco));
     } else {
         co = qemu_coroutine_create(bdrv_create_co_entry, &cco);
         qemu_coroutine_enter(co);
diff --git a/block/dirty-bitmap.c b/block/dirty-bitmap.c
index bf3dc0512a..ccf46c0b1f 100644
--- a/block/dirty-bitmap.c
+++ b/block/dirty-bitmap.c
@@ -419,7 +419,8 @@ int bdrv_remove_persistent_dirty_bitmap(BlockDriverState *bs, const char *name,
                                         Error **errp)
 {
     if (qemu_in_coroutine()) {
-        return bdrv_co_remove_persistent_dirty_bitmap(bs, name, errp);
+        return __allow_coroutine_fn_call(
+            bdrv_co_remove_persistent_dirty_bitmap(bs, name, errp));
     } else {
         Coroutine *co;
         BdrvRemovePersistentDirtyBitmapCo s = {
@@ -495,7 +496,8 @@ bool bdrv_can_store_new_dirty_bitmap(BlockDriverState *bs, const char *name,
 {
     IO_CODE();
     if (qemu_in_coroutine()) {
-        return bdrv_co_can_store_new_dirty_bitmap(bs, name, granularity, errp);
+        return __allow_coroutine_fn_call(
+            bdrv_co_can_store_new_dirty_bitmap(bs, name, granularity, errp));
     } else {
         Coroutine *co;
         BdrvCanStoreNewDirtyBitmapCo s = {
diff --git a/block/io.c b/block/io.c
index 853ed44289..c2ed14cedb 100644
--- a/block/io.c
+++ b/block/io.c
@@ -449,8 +449,9 @@ static void bdrv_do_drained_begin(BlockDriverState *bs, bool recursive,
     BdrvChild *child, *next;
 
     if (qemu_in_coroutine()) {
-        bdrv_co_yield_to_drain(bs, true, recursive, parent, ignore_bds_parents,
-                               poll, NULL);
+        __allow_coroutine_fn_call(
+            bdrv_co_yield_to_drain(bs, true, recursive, parent,
+                                   ignore_bds_parents, poll, NULL));
         return;
     }
 
@@ -516,8 +517,10 @@ static void bdrv_do_drained_end(BlockDriverState *bs, bool recursive,
     assert(drained_end_counter != NULL);
 
     if (qemu_in_coroutine()) {
-        bdrv_co_yield_to_drain(bs, false, recursive, parent, ignore_bds_parents,
-                               false, drained_end_counter);
+        __allow_coroutine_fn_call(
+            bdrv_co_yield_to_drain(bs, false, recursive, parent,
+                                   ignore_bds_parents, false,
+                                   drained_end_counter));
         return;
     }
     assert(bs->quiesce_counter > 0);
@@ -643,7 +646,8 @@ void bdrv_drain_all_begin(void)
     GLOBAL_STATE_CODE();
 
     if (qemu_in_coroutine()) {
-        bdrv_co_yield_to_drain(NULL, true, false, NULL, true, true, NULL);
+        __allow_coroutine_fn_call(
+            bdrv_co_yield_to_drain(NULL, true, false, NULL, true, true, NULL));
         return;
     }
 
@@ -2742,8 +2746,8 @@ int coroutine_fn bdrv_co_is_zero_fast(BlockDriverState *bs, int64_t offset,
     return (pnum == bytes) && (ret & BDRV_BLOCK_ZERO);
 }
 
-int coroutine_fn bdrv_is_allocated(BlockDriverState *bs, int64_t offset,
-                                   int64_t bytes, int64_t *pnum)
+int bdrv_is_allocated(BlockDriverState *bs, int64_t offset, int64_t bytes,
+                      int64_t *pnum)
 {
     int ret;
     int64_t dummy;
diff --git a/block/monitor/block-hmp-cmds.c b/block/monitor/block-hmp-cmds.c
index bfb3c043a0..b5ba9281f0 100644
--- a/block/monitor/block-hmp-cmds.c
+++ b/block/monitor/block-hmp-cmds.c
@@ -489,7 +489,7 @@ void hmp_nbd_server_stop(Monitor *mon, const QDict *qdict)
     hmp_handle_error(mon, err);
 }
 
-void hmp_block_resize(Monitor *mon, const QDict *qdict)
+void coroutine_fn hmp_block_resize(Monitor *mon, const QDict *qdict)
 {
     const char *device = qdict_get_str(qdict, "device");
     int64_t size = qdict_get_int(qdict, "size");
diff --git a/block/nvme.c b/block/nvme.c
index 01fb28aa63..c645f87142 100644
--- a/block/nvme.c
+++ b/block/nvme.c
@@ -306,7 +306,8 @@ static NVMeRequest *nvme_get_free_req(NVMeQueuePair *q)
     while (q->free_req_head == -1) {
         if (qemu_in_coroutine()) {
             trace_nvme_free_req_queue_wait(q->s, q->index);
-            qemu_co_queue_wait(&q->free_req_queue, &q->lock);
+            __allow_coroutine_fn_call(
+                qemu_co_queue_wait(&q->free_req_queue, &q->lock));
         } else {
             qemu_mutex_unlock(&q->lock);
             return NULL;
diff --git a/block/qcow2.c b/block/qcow2.c
index c6c6692fb7..d3dad0142e 100644
--- a/block/qcow2.c
+++ b/block/qcow2.c
@@ -1905,7 +1905,7 @@ static int qcow2_open(BlockDriverState *bs, QDict *options, int flags,
 
     if (qemu_in_coroutine()) {
         /* From bdrv_co_create.  */
-        qcow2_open_entry(&qoc);
+        __allow_coroutine_fn_call(qcow2_open_entry(&qoc));
     } else {
         assert(qemu_get_current_aio_context() == qemu_get_aio_context());
         qemu_coroutine_enter(qemu_coroutine_create(qcow2_open_entry, &qoc));
@@ -5226,7 +5226,7 @@ static int qcow2_has_zero_init(BlockDriverState *bs)
     bool preallocated;
 
     if (qemu_in_coroutine()) {
-        qemu_co_mutex_lock(&s->lock);
+        __allow_coroutine_fn_call(qemu_co_mutex_lock(&s->lock));
     }
     /*
      * Check preallocation status: Preallocated images have all L2
@@ -5235,7 +5235,7 @@ static int qcow2_has_zero_init(BlockDriverState *bs)
      */
     preallocated = s->l1_size > 0 && s->l1_table[0] != 0;
     if (qemu_in_coroutine()) {
-        qemu_co_mutex_unlock(&s->lock);
+        __allow_coroutine_fn_call(qemu_co_mutex_unlock(&s->lock));
     }
 
     if (!preallocated) {
@@ -5274,8 +5274,8 @@ static int64_t qcow2_check_vmstate_request(BlockDriverState *bs,
     return pos;
 }
 
-static int qcow2_save_vmstate(BlockDriverState *bs, QEMUIOVector *qiov,
-                              int64_t pos)
+static coroutine_fn int qcow2_save_vmstate(BlockDriverState *bs,
+                                           QEMUIOVector *qiov, int64_t pos)
 {
     int64_t offset = qcow2_check_vmstate_request(bs, qiov, pos);
     if (offset < 0) {
@@ -5286,8 +5286,8 @@ static int qcow2_save_vmstate(BlockDriverState *bs, QEMUIOVector *qiov,
     return bs->drv->bdrv_co_pwritev_part(bs, offset, qiov->size, qiov, 0, 0);
 }
 
-static int qcow2_load_vmstate(BlockDriverState *bs, QEMUIOVector *qiov,
-                              int64_t pos)
+static coroutine_fn int qcow2_load_vmstate(BlockDriverState *bs,
+                                           QEMUIOVector *qiov, int64_t pos)
 {
     int64_t offset = qcow2_check_vmstate_request(bs, qiov, pos);
     if (offset < 0) {
diff --git a/block/qcow2.h b/block/qcow2.h
index ba436a8d0d..e68d127d8e 100644
--- a/block/qcow2.h
+++ b/block/qcow2.h
@@ -990,13 +990,13 @@ int qcow2_truncate_bitmaps_check(BlockDriverState *bs, Error **errp);
 bool qcow2_store_persistent_dirty_bitmaps(BlockDriverState *bs,
                                           bool release_stored, Error **errp);
 int qcow2_reopen_bitmaps_ro(BlockDriverState *bs, Error **errp);
-bool qcow2_co_can_store_new_dirty_bitmap(BlockDriverState *bs,
-                                         const char *name,
-                                         uint32_t granularity,
-                                         Error **errp);
-int qcow2_co_remove_persistent_dirty_bitmap(BlockDriverState *bs,
-                                            const char *name,
-                                            Error **errp);
+bool coroutine_fn qcow2_co_can_store_new_dirty_bitmap(BlockDriverState *bs,
+                                                      const char *name,
+                                                      uint32_t granularity,
+                                                      Error **errp);
+int coroutine_fn qcow2_co_remove_persistent_dirty_bitmap(BlockDriverState *bs,
+                                                         const char *name,
+                                                         Error **errp);
 bool qcow2_supports_persistent_dirty_bitmap(BlockDriverState *bs);
 uint64_t qcow2_get_persistent_dirty_bitmap_size(BlockDriverState *bs,
                                                 uint32_t cluster_size);
diff --git a/block/qed.c b/block/qed.c
index 40943e679b..9114cde42f 100644
--- a/block/qed.c
+++ b/block/qed.c
@@ -563,7 +563,7 @@ static int bdrv_qed_open(BlockDriverState *bs, QDict *options, int flags,
 
     bdrv_qed_init_state(bs);
     if (qemu_in_coroutine()) {
-        bdrv_qed_open_entry(&qoc);
+        __allow_coroutine_fn_call(bdrv_qed_open_entry(&qoc));
     } else {
         assert(qemu_get_current_aio_context() == qemu_get_aio_context());
         qemu_coroutine_enter(qemu_coroutine_create(bdrv_qed_open_entry, &qoc));
diff --git a/block/quorum.c b/block/quorum.c
index 9c0fbd79be..3a13bf1b1f 100644
--- a/block/quorum.c
+++ b/block/quorum.c
@@ -233,7 +233,7 @@ static bool quorum_has_too_much_io_failed(QuorumAIOCB *acb)
     return false;
 }
 
-static int read_fifo_child(QuorumAIOCB *acb);
+static int coroutine_fn read_fifo_child(QuorumAIOCB *acb);
 
 static void quorum_copy_qiov(QEMUIOVector *dest, QEMUIOVector *source)
 {
diff --git a/block/ssh.c b/block/ssh.c
index a2dc646536..ceb4f4c5bc 100644
--- a/block/ssh.c
+++ b/block/ssh.c
@@ -1129,9 +1129,9 @@ static coroutine_fn int ssh_co_readv(BlockDriverState *bs,
     return ret;
 }
 
-static int ssh_write(BDRVSSHState *s, BlockDriverState *bs,
-                     int64_t offset, size_t size,
-                     QEMUIOVector *qiov)
+static coroutine_fn int ssh_write(BDRVSSHState *s, BlockDriverState *bs,
+                                  int64_t offset, size_t size,
+                                  QEMUIOVector *qiov)
 {
     ssize_t r;
     size_t written;
diff --git a/block/throttle-groups.c b/block/throttle-groups.c
index fb203c3ced..e9a14b6f2e 100644
--- a/block/throttle-groups.c
+++ b/block/throttle-groups.c
@@ -337,7 +337,8 @@ static void schedule_next_request(ThrottleGroupMember *tgm, bool is_write)
     if (!must_wait) {
         /* Give preference to requests from the current tgm */
         if (qemu_in_coroutine() &&
-            throttle_group_co_restart_queue(tgm, is_write)) {
+            __allow_coroutine_fn_call(
+                throttle_group_co_restart_queue(tgm, is_write))) {
             token = tgm;
         } else {
             ThrottleTimers *tt = &token->throttle_timers;
diff --git a/include/block/block-hmp-cmds.h b/include/block/block-hmp-cmds.h
index 50ce0247c3..ba0593c440 100644
--- a/include/block/block-hmp-cmds.h
+++ b/include/block/block-hmp-cmds.h
@@ -38,7 +38,7 @@ void hmp_nbd_server_add(Monitor *mon, const QDict *qdict);
 void hmp_nbd_server_remove(Monitor *mon, const QDict *qdict);
 void hmp_nbd_server_stop(Monitor *mon, const QDict *qdict);
 
-void hmp_block_resize(Monitor *mon, const QDict *qdict);
+void coroutine_fn hmp_block_resize(Monitor *mon, const QDict *qdict);
 void hmp_block_stream(Monitor *mon, const QDict *qdict);
 void hmp_block_passwd(Monitor *mon, const QDict *qdict);
 void hmp_block_set_io_throttle(Monitor *mon, const QDict *qdict);
diff --git a/include/block/block-io.h b/include/block/block-io.h
index fd25ffa9be..f4b183f3de 100644
--- a/include/block/block-io.h
+++ b/include/block/block-io.h
@@ -83,12 +83,13 @@ void bdrv_aio_cancel(BlockAIOCB *acb);
 void bdrv_aio_cancel_async(BlockAIOCB *acb);
 
 /* sg packet commands */
-int bdrv_co_ioctl(BlockDriverState *bs, int req, void *buf);
+int coroutine_fn bdrv_co_ioctl(BlockDriverState *bs, int req, void *buf);
 
 /* Ensure contents are flushed to disk.  */
 int coroutine_fn bdrv_co_flush(BlockDriverState *bs);
 
-int bdrv_co_pdiscard(BdrvChild *child, int64_t offset, int64_t bytes);
+int coroutine_fn bdrv_co_pdiscard(BdrvChild *child, int64_t offset,
+                                  int64_t bytes);
 bool bdrv_can_write_zeroes_with_unmap(BlockDriverState *bs);
 int bdrv_block_status(BlockDriverState *bs, int64_t offset,
                       int64_t bytes, int64_t *pnum, int64_t *map,
diff --git a/include/qemu/coroutine.h b/include/qemu/coroutine.h
index 40a4037525..26445b3176 100644
--- a/include/qemu/coroutine.h
+++ b/include/qemu/coroutine.h
@@ -289,7 +289,7 @@ void qemu_co_rwlock_init(CoRwlock *lock);
  * of a parallel writer, control is transferred to the caller of the current
  * coroutine.
  */
-void qemu_co_rwlock_rdlock(CoRwlock *lock);
+void coroutine_fn qemu_co_rwlock_rdlock(CoRwlock *lock);
 
 /**
  * Write Locks the CoRwlock from a reader.  This is a bit more efficient than
@@ -298,7 +298,7 @@ void qemu_co_rwlock_rdlock(CoRwlock *lock);
  * to the caller of the current coroutine; another writer might run while
  * @qemu_co_rwlock_upgrade blocks.
  */
-void qemu_co_rwlock_upgrade(CoRwlock *lock);
+void coroutine_fn qemu_co_rwlock_upgrade(CoRwlock *lock);
 
 /**
  * Downgrades a write-side critical section to a reader.  Downgrading with
@@ -306,20 +306,20 @@ void qemu_co_rwlock_upgrade(CoRwlock *lock);
  * followed by @qemu_co_rwlock_rdlock.  This makes it more efficient, but
  * may also sometimes be necessary for correctness.
  */
-void qemu_co_rwlock_downgrade(CoRwlock *lock);
+void coroutine_fn qemu_co_rwlock_downgrade(CoRwlock *lock);
 
 /**
  * Write Locks the mutex. If the lock cannot be taken immediately because
  * of a parallel reader, control is transferred to the caller of the current
  * coroutine.
  */
-void qemu_co_rwlock_wrlock(CoRwlock *lock);
+void coroutine_fn qemu_co_rwlock_wrlock(CoRwlock *lock);
 
 /**
  * Unlocks the read/write lock and schedules the next coroutine that was
  * waiting for this lock to be run.
  */
-void qemu_co_rwlock_unlock(CoRwlock *lock);
+void coroutine_fn qemu_co_rwlock_unlock(CoRwlock *lock);
 
 typedef struct QemuCoSleep {
     Coroutine *to_wake;
@@ -391,8 +391,9 @@ void qemu_coroutine_dec_pool_size(unsigned int additional_pool_size);
  * The same interface as qemu_sendv_recvv(), with added yielding.
  * XXX should mark these as coroutine_fn
  */
-ssize_t qemu_co_sendv_recvv(int sockfd, struct iovec *iov, unsigned iov_cnt,
-                            size_t offset, size_t bytes, bool do_send);
+ssize_t coroutine_fn qemu_co_sendv_recvv(int sockfd, struct iovec *iov,
+                                         unsigned iov_cnt, size_t offset,
+                                         size_t bytes, bool do_send);
 #define qemu_co_recvv(sockfd, iov, iov_cnt, offset, bytes) \
   qemu_co_sendv_recvv(sockfd, iov, iov_cnt, offset, bytes, false)
 #define qemu_co_sendv(sockfd, iov, iov_cnt, offset, bytes) \
@@ -401,7 +402,8 @@ ssize_t qemu_co_sendv_recvv(int sockfd, struct iovec *iov, unsigned iov_cnt,
 /**
  * The same as above, but with just a single buffer
  */
-ssize_t qemu_co_send_recv(int sockfd, void *buf, size_t bytes, bool do_send);
+ssize_t coroutine_fn qemu_co_send_recv(int sockfd, void *buf, size_t bytes,
+                                       bool do_send);
 #define qemu_co_recv(sockfd, buf, bytes) \
   qemu_co_send_recv(sockfd, buf, bytes, false)
 #define qemu_co_send(sockfd, buf, bytes) \
-- 
2.37.1

