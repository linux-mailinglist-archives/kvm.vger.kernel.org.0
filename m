Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF91A585047
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 15:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236203AbiG2NDO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 09:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236197AbiG2NDB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 09:03:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B122A5D0E2
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 06:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659099768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0xP+lFnNULgHBGbENutgPROn5Equ5OosJJYBLOV7HEY=;
        b=jMMzM7ttRKW86AEMk3vNHb1eVd769NJHgww8wWhxwdQKmDAKqibSMDHACysdF4KN6GBXa4
        UpjHf5h/Q06cBL+4QAgM3UTKq2ZQtqhYCXrGqzla+edoFTAYG73k3cgcBa6vi0v9YuIFaE
        C+qpRw8hIT5vdgRzk2vOdIDukxvAxfM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-o3zjz8VVMzyvPZSuEIPnfw-1; Fri, 29 Jul 2022 09:02:45 -0400
X-MC-Unique: o3zjz8VVMzyvPZSuEIPnfw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4663885A585;
        Fri, 29 Jul 2022 13:02:43 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 92F492026D64;
        Fri, 29 Jul 2022 13:02:34 +0000 (UTC)
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
Subject: [RFC v2 10/10] Fix some calls from coroutine_fn to no_coroutine_fn
Date:   Fri, 29 Jul 2022 14:00:39 +0100
Message-Id: <20220729130040.1428779-11-afaria@redhat.com>
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

These calls were found by static-analyzer.py.

Not all occurrences of this problem were fixed.

Signed-off-by: Alberto Faria <afaria@redhat.com>
---
 block/commit.c         |  2 +-
 block/io.c             |  4 ++--
 block/mirror.c         |  4 ++--
 block/parallels.c      | 28 ++++++++++++++--------------
 block/qcow.c           | 10 +++++-----
 block/qcow2-snapshot.c |  6 +++---
 block/qcow2.c          | 24 ++++++++++++------------
 block/qed-table.c      |  2 +-
 block/qed.c            | 12 ++++++------
 block/vdi.c            | 17 +++++++++--------
 block/vhdx.c           |  8 ++++----
 block/vmdk.c           | 11 ++++++-----
 blockdev.c             |  2 +-
 13 files changed, 66 insertions(+), 64 deletions(-)

diff --git a/block/commit.c b/block/commit.c
index 38571510cb..945945de05 100644
--- a/block/commit.c
+++ b/block/commit.c
@@ -135,7 +135,7 @@ static int coroutine_fn commit_run(Job *job, Error **errp)
     }
 
     if (base_len < len) {
-        ret = blk_truncate(s->base, len, false, PREALLOC_MODE_OFF, 0, NULL);
+        ret = blk_co_truncate(s->base, len, false, PREALLOC_MODE_OFF, 0, NULL);
         if (ret) {
             return ret;
         }
diff --git a/block/io.c b/block/io.c
index c2ed14cedb..a7d16eae02 100644
--- a/block/io.c
+++ b/block/io.c
@@ -2736,8 +2736,8 @@ int coroutine_fn bdrv_co_is_zero_fast(BlockDriverState *bs, int64_t offset,
         return 1;
     }
 
-    ret = bdrv_common_block_status_above(bs, NULL, false, false, offset,
-                                         bytes, &pnum, NULL, NULL, NULL);
+    ret = bdrv_co_common_block_status_above(bs, NULL, false, false, offset,
+                                            bytes, &pnum, NULL, NULL, NULL);
 
     if (ret < 0) {
         return ret;
diff --git a/block/mirror.c b/block/mirror.c
index 3c4ab1159d..3cbb610118 100644
--- a/block/mirror.c
+++ b/block/mirror.c
@@ -921,8 +921,8 @@ static int coroutine_fn mirror_run(Job *job, Error **errp)
      * active layer. */
     if (s->base == blk_bs(s->target)) {
         if (s->bdev_length > target_length) {
-            ret = blk_truncate(s->target, s->bdev_length, false,
-                               PREALLOC_MODE_OFF, 0, NULL);
+            ret = blk_co_truncate(s->target, s->bdev_length, false,
+                                  PREALLOC_MODE_OFF, 0, NULL);
             if (ret < 0) {
                 goto immediate_exit;
             }
diff --git a/block/parallels.c b/block/parallels.c
index a229c06f25..46baea6387 100644
--- a/block/parallels.c
+++ b/block/parallels.c
@@ -204,18 +204,18 @@ static int64_t allocate_clusters(BlockDriverState *bs, int64_t sector_num,
          * force the safer-but-slower fallocate.
          */
         if (s->prealloc_mode == PRL_PREALLOC_MODE_TRUNCATE) {
-            ret = bdrv_truncate(bs->file,
-                                (s->data_end + space) << BDRV_SECTOR_BITS,
-                                false, PREALLOC_MODE_OFF, BDRV_REQ_ZERO_WRITE,
-                                NULL);
+            ret = bdrv_co_truncate(bs->file,
+                                   (s->data_end + space) << BDRV_SECTOR_BITS,
+                                   false, PREALLOC_MODE_OFF,
+                                   BDRV_REQ_ZERO_WRITE, NULL);
             if (ret == -ENOTSUP) {
                 s->prealloc_mode = PRL_PREALLOC_MODE_FALLOCATE;
             }
         }
         if (s->prealloc_mode == PRL_PREALLOC_MODE_FALLOCATE) {
-            ret = bdrv_pwrite_zeroes(bs->file,
-                                     s->data_end << BDRV_SECTOR_BITS,
-                                     space << BDRV_SECTOR_BITS, 0);
+            ret = bdrv_co_pwrite_zeroes(bs->file,
+                                        s->data_end << BDRV_SECTOR_BITS,
+                                        space << BDRV_SECTOR_BITS, 0);
         }
         if (ret < 0) {
             return ret;
@@ -277,8 +277,8 @@ static coroutine_fn int parallels_co_flush_to_os(BlockDriverState *bs)
         if (off + to_write > s->header_size) {
             to_write = s->header_size - off;
         }
-        ret = bdrv_pwrite(bs->file, off, to_write, (uint8_t *)s->header + off,
-                          0);
+        ret = bdrv_co_pwrite(bs->file, off, to_write,
+                             (uint8_t *)s->header + off, 0);
         if (ret < 0) {
             qemu_co_mutex_unlock(&s->lock);
             return ret;
@@ -503,8 +503,8 @@ static int coroutine_fn parallels_co_check(BlockDriverState *bs,
              * In order to really repair the image, we must shrink it.
              * That means we have to pass exact=true.
              */
-            ret = bdrv_truncate(bs->file, res->image_end_offset, true,
-                                PREALLOC_MODE_OFF, 0, &local_err);
+            ret = bdrv_co_truncate(bs->file, res->image_end_offset, true,
+                                   PREALLOC_MODE_OFF, 0, &local_err);
             if (ret < 0) {
                 error_report_err(local_err);
                 res->check_errors++;
@@ -599,12 +599,12 @@ static int coroutine_fn parallels_co_create(BlockdevCreateOptions* opts,
     memset(tmp, 0, sizeof(tmp));
     memcpy(tmp, &header, sizeof(header));
 
-    ret = blk_pwrite(blk, 0, BDRV_SECTOR_SIZE, tmp, 0);
+    ret = blk_co_pwrite(blk, 0, BDRV_SECTOR_SIZE, tmp, 0);
     if (ret < 0) {
         goto exit;
     }
-    ret = blk_pwrite_zeroes(blk, BDRV_SECTOR_SIZE,
-                            (bat_sectors - 1) << BDRV_SECTOR_BITS, 0);
+    ret = blk_co_pwrite_zeroes(blk, BDRV_SECTOR_SIZE,
+                               (bat_sectors - 1) << BDRV_SECTOR_BITS, 0);
     if (ret < 0) {
         goto exit;
     }
diff --git a/block/qcow.c b/block/qcow.c
index 311aaa8705..7dc29358ba 100644
--- a/block/qcow.c
+++ b/block/qcow.c
@@ -890,14 +890,14 @@ static int coroutine_fn qcow_co_create(BlockdevCreateOptions *opts,
     }
 
     /* write all the data */
-    ret = blk_pwrite(qcow_blk, 0, sizeof(header), &header, 0);
+    ret = blk_co_pwrite(qcow_blk, 0, sizeof(header), &header, 0);
     if (ret < 0) {
         goto exit;
     }
 
     if (qcow_opts->has_backing_file) {
-        ret = blk_pwrite(qcow_blk, sizeof(header), backing_filename_len,
-                         qcow_opts->backing_file, 0);
+        ret = blk_co_pwrite(qcow_blk, sizeof(header), backing_filename_len,
+                            qcow_opts->backing_file, 0);
         if (ret < 0) {
             goto exit;
         }
@@ -906,8 +906,8 @@ static int coroutine_fn qcow_co_create(BlockdevCreateOptions *opts,
     tmp = g_malloc0(BDRV_SECTOR_SIZE);
     for (i = 0; i < DIV_ROUND_UP(sizeof(uint64_t) * l1_size, BDRV_SECTOR_SIZE);
          i++) {
-        ret = blk_pwrite(qcow_blk, header_size + BDRV_SECTOR_SIZE * i,
-                         BDRV_SECTOR_SIZE, tmp, 0);
+        ret = blk_co_pwrite(qcow_blk, header_size + BDRV_SECTOR_SIZE * i,
+                            BDRV_SECTOR_SIZE, tmp, 0);
         if (ret < 0) {
             g_free(tmp);
             goto exit;
diff --git a/block/qcow2-snapshot.c b/block/qcow2-snapshot.c
index d1d46facbf..62e8a0335d 100644
--- a/block/qcow2-snapshot.c
+++ b/block/qcow2-snapshot.c
@@ -441,9 +441,9 @@ int coroutine_fn qcow2_check_read_snapshot_table(BlockDriverState *bs,
     } QEMU_PACKED snapshot_table_pointer;
 
     /* qcow2_do_open() discards this information in check mode */
-    ret = bdrv_pread(bs->file, offsetof(QCowHeader, nb_snapshots),
-                     sizeof(snapshot_table_pointer), &snapshot_table_pointer,
-                     0);
+    ret = bdrv_co_pread(bs->file, offsetof(QCowHeader, nb_snapshots),
+                        sizeof(snapshot_table_pointer), &snapshot_table_pointer,
+                        0);
     if (ret < 0) {
         result->check_errors++;
         fprintf(stderr, "ERROR failed to read the snapshot table pointer from "
diff --git a/block/qcow2.c b/block/qcow2.c
index d3dad0142e..524207fcfe 100644
--- a/block/qcow2.c
+++ b/block/qcow2.c
@@ -1305,7 +1305,7 @@ static int coroutine_fn qcow2_do_open(BlockDriverState *bs, QDict *options,
     uint64_t l1_vm_state_index;
     bool update_header = false;
 
-    ret = bdrv_pread(bs->file, 0, sizeof(header), &header, 0);
+    ret = bdrv_co_pread(bs->file, 0, sizeof(header), &header, 0);
     if (ret < 0) {
         error_setg_errno(errp, -ret, "Could not read qcow2 header");
         goto fail;
@@ -1381,9 +1381,9 @@ static int coroutine_fn qcow2_do_open(BlockDriverState *bs, QDict *options,
     if (header.header_length > sizeof(header)) {
         s->unknown_header_fields_size = header.header_length - sizeof(header);
         s->unknown_header_fields = g_malloc(s->unknown_header_fields_size);
-        ret = bdrv_pread(bs->file, sizeof(header),
-                         s->unknown_header_fields_size,
-                         s->unknown_header_fields, 0);
+        ret = bdrv_co_pread(bs->file, sizeof(header),
+                            s->unknown_header_fields_size,
+                            s->unknown_header_fields, 0);
         if (ret < 0) {
             error_setg_errno(errp, -ret, "Could not read unknown qcow2 header "
                              "fields");
@@ -1578,8 +1578,8 @@ static int coroutine_fn qcow2_do_open(BlockDriverState *bs, QDict *options,
             ret = -ENOMEM;
             goto fail;
         }
-        ret = bdrv_pread(bs->file, s->l1_table_offset, s->l1_size * L1E_SIZE,
-                         s->l1_table, 0);
+        ret = bdrv_co_pread(bs->file, s->l1_table_offset, s->l1_size * L1E_SIZE,
+                            s->l1_table, 0);
         if (ret < 0) {
             error_setg_errno(errp, -ret, "Could not read L1 table");
             goto fail;
@@ -1696,8 +1696,8 @@ static int coroutine_fn qcow2_do_open(BlockDriverState *bs, QDict *options,
             ret = -EINVAL;
             goto fail;
         }
-        ret = bdrv_pread(bs->file, header.backing_file_offset, len,
-                         bs->auto_backing_file, 0);
+        ret = bdrv_co_pread(bs->file, header.backing_file_offset, len,
+                            bs->auto_backing_file, 0);
         if (ret < 0) {
             error_setg_errno(errp, -ret, "Could not read backing file name");
             goto fail;
@@ -3666,7 +3666,7 @@ qcow2_co_create(BlockdevCreateOptions *create_options, Error **errp)
             cpu_to_be64(QCOW2_INCOMPAT_EXTL2);
     }
 
-    ret = blk_pwrite(blk, 0, cluster_size, header, 0);
+    ret = blk_co_pwrite(blk, 0, cluster_size, header, 0);
     g_free(header);
     if (ret < 0) {
         error_setg_errno(errp, -ret, "Could not write qcow2 header");
@@ -3676,7 +3676,7 @@ qcow2_co_create(BlockdevCreateOptions *create_options, Error **errp)
     /* Write a refcount table with one refcount block */
     refcount_table = g_malloc0(2 * cluster_size);
     refcount_table[0] = cpu_to_be64(2 * cluster_size);
-    ret = blk_pwrite(blk, cluster_size, 2 * cluster_size, refcount_table, 0);
+    ret = blk_co_pwrite(blk, cluster_size, 2 * cluster_size, refcount_table, 0);
     g_free(refcount_table);
 
     if (ret < 0) {
@@ -3731,8 +3731,8 @@ qcow2_co_create(BlockdevCreateOptions *create_options, Error **errp)
     }
 
     /* Okay, now that we have a valid image, let's give it the right size */
-    ret = blk_truncate(blk, qcow2_opts->size, false, qcow2_opts->preallocation,
-                       0, errp);
+    ret = blk_co_truncate(blk, qcow2_opts->size, false,
+                          qcow2_opts->preallocation, 0, errp);
     if (ret < 0) {
         error_prepend(errp, "Could not resize image: ");
         goto out;
diff --git a/block/qed-table.c b/block/qed-table.c
index 1cc844b1a5..aa203f2627 100644
--- a/block/qed-table.c
+++ b/block/qed-table.c
@@ -100,7 +100,7 @@ static int coroutine_fn qed_write_table(BDRVQEDState *s, uint64_t offset,
     }
 
     if (flush) {
-        ret = bdrv_flush(s->bs);
+        ret = bdrv_co_flush(s->bs);
         if (ret < 0) {
             goto out;
         }
diff --git a/block/qed.c b/block/qed.c
index 9114cde42f..72e95852de 100644
--- a/block/qed.c
+++ b/block/qed.c
@@ -387,7 +387,7 @@ static int coroutine_fn bdrv_qed_do_open(BlockDriverState *bs, QDict *options,
     int64_t file_size;
     int ret;
 
-    ret = bdrv_pread(bs->file, 0, sizeof(le_header), &le_header, 0);
+    ret = bdrv_co_pread(bs->file, 0, sizeof(le_header), &le_header, 0);
     if (ret < 0) {
         error_setg(errp, "Failed to read QED header");
         return ret;
@@ -485,7 +485,7 @@ static int coroutine_fn bdrv_qed_do_open(BlockDriverState *bs, QDict *options,
         }
 
         /* From here on only known autoclear feature bits are valid */
-        bdrv_flush(bs->file->bs);
+        bdrv_co_flush(bs->file->bs);
     }
 
     s->l1_table = qed_alloc_table(s);
@@ -686,7 +686,7 @@ static int coroutine_fn bdrv_qed_co_create(BlockdevCreateOptions *opts,
      * The QED format associates file length with allocation status,
      * so a new file (which is empty) must have a length of 0.
      */
-    ret = blk_truncate(blk, 0, true, PREALLOC_MODE_OFF, 0, errp);
+    ret = blk_co_truncate(blk, 0, true, PREALLOC_MODE_OFF, 0, errp);
     if (ret < 0) {
         goto out;
     }
@@ -705,18 +705,18 @@ static int coroutine_fn bdrv_qed_co_create(BlockdevCreateOptions *opts,
     }
 
     qed_header_cpu_to_le(&header, &le_header);
-    ret = blk_pwrite(blk, 0, sizeof(le_header), &le_header, 0);
+    ret = blk_co_pwrite(blk, 0, sizeof(le_header), &le_header, 0);
     if (ret < 0) {
         goto out;
     }
-    ret = blk_pwrite(blk, sizeof(le_header), header.backing_filename_size,
+    ret = blk_co_pwrite(blk, sizeof(le_header), header.backing_filename_size,
                      qed_opts->backing_file, 0);
     if (ret < 0) {
         goto out;
     }
 
     l1_table = g_malloc0(l1_size);
-    ret = blk_pwrite(blk, header.l1_table_offset, l1_size, l1_table, 0);
+    ret = blk_co_pwrite(blk, header.l1_table_offset, l1_size, l1_table, 0);
     if (ret < 0) {
         goto out;
     }
diff --git a/block/vdi.c b/block/vdi.c
index e942325455..2ecf47216a 100644
--- a/block/vdi.c
+++ b/block/vdi.c
@@ -664,7 +664,8 @@ vdi_co_pwritev(BlockDriverState *bs, int64_t offset, int64_t bytes,
              * so this full-cluster write does not overlap a partial write
              * of the same cluster, issued from the "else" branch.
              */
-            ret = bdrv_pwrite(bs->file, data_offset, s->block_size, block, 0);
+            ret = bdrv_co_pwrite(bs->file, data_offset, s->block_size, block,
+                                 0);
             qemu_co_rwlock_unlock(&s->bmap_lock);
         } else {
 nonallocating_write:
@@ -709,7 +710,7 @@ nonallocating_write:
         assert(VDI_IS_ALLOCATED(bmap_first));
         *header = s->header;
         vdi_header_to_le(header);
-        ret = bdrv_pwrite(bs->file, 0, sizeof(*header), header, 0);
+        ret = bdrv_co_pwrite(bs->file, 0, sizeof(*header), header, 0);
         g_free(header);
 
         if (ret < 0) {
@@ -726,8 +727,8 @@ nonallocating_write:
         base = ((uint8_t *)&s->bmap[0]) + bmap_first * SECTOR_SIZE;
         logout("will write %u block map sectors starting from entry %u\n",
                n_sectors, bmap_first);
-        ret = bdrv_pwrite(bs->file, offset * SECTOR_SIZE,
-                          n_sectors * SECTOR_SIZE, base, 0);
+        ret = bdrv_co_pwrite(bs->file, offset * SECTOR_SIZE,
+                             n_sectors * SECTOR_SIZE, base, 0);
     }
 
     return ret;
@@ -845,7 +846,7 @@ static int coroutine_fn vdi_co_do_create(BlockdevCreateOptions *create_options,
         vdi_header_print(&header);
     }
     vdi_header_to_le(&header);
-    ret = blk_pwrite(blk, offset, sizeof(header), &header, 0);
+    ret = blk_co_pwrite(blk, offset, sizeof(header), &header, 0);
     if (ret < 0) {
         error_setg(errp, "Error writing header");
         goto exit;
@@ -866,7 +867,7 @@ static int coroutine_fn vdi_co_do_create(BlockdevCreateOptions *create_options,
                 bmap[i] = VDI_UNALLOCATED;
             }
         }
-        ret = blk_pwrite(blk, offset, bmap_size, bmap, 0);
+        ret = blk_co_pwrite(blk, offset, bmap_size, bmap, 0);
         if (ret < 0) {
             error_setg(errp, "Error writing bmap");
             goto exit;
@@ -875,8 +876,8 @@ static int coroutine_fn vdi_co_do_create(BlockdevCreateOptions *create_options,
     }
 
     if (image_type == VDI_TYPE_STATIC) {
-        ret = blk_truncate(blk, offset + blocks * block_size, false,
-                           PREALLOC_MODE_OFF, 0, errp);
+        ret = blk_co_truncate(blk, offset + blocks * block_size, false,
+                              PREALLOC_MODE_OFF, 0, errp);
         if (ret < 0) {
             error_prepend(errp, "Failed to statically allocate file");
             goto exit;
diff --git a/block/vhdx.c b/block/vhdx.c
index e10e78ebfd..f7dd4eb092 100644
--- a/block/vhdx.c
+++ b/block/vhdx.c
@@ -2012,15 +2012,15 @@ static int coroutine_fn vhdx_co_create(BlockdevCreateOptions *opts,
     creator = g_utf8_to_utf16("QEMU v" QEMU_VERSION, -1, NULL,
                               &creator_items, NULL);
     signature = cpu_to_le64(VHDX_FILE_SIGNATURE);
-    ret = blk_pwrite(blk, VHDX_FILE_ID_OFFSET, sizeof(signature), &signature,
-                     0);
+    ret = blk_co_pwrite(blk, VHDX_FILE_ID_OFFSET, sizeof(signature), &signature,
+                        0);
     if (ret < 0) {
         error_setg_errno(errp, -ret, "Failed to write file signature");
         goto delete_and_exit;
     }
     if (creator) {
-        ret = blk_pwrite(blk, VHDX_FILE_ID_OFFSET + sizeof(signature),
-                         creator_items * sizeof(gunichar2), creator, 0);
+        ret = blk_co_pwrite(blk, VHDX_FILE_ID_OFFSET + sizeof(signature),
+                            creator_items * sizeof(gunichar2), creator, 0);
         if (ret < 0) {
             error_setg_errno(errp, -ret, "Failed to write creator field");
             goto delete_and_exit;
diff --git a/block/vmdk.c b/block/vmdk.c
index fe07a54866..d7886a52e1 100644
--- a/block/vmdk.c
+++ b/block/vmdk.c
@@ -1897,7 +1897,8 @@ static int vmdk_read_extent(VmdkExtent *extent, int64_t cluster_offset,
     cluster_buf = g_malloc(buf_bytes);
     uncomp_buf = g_malloc(cluster_bytes);
     BLKDBG_EVENT(extent->file, BLKDBG_READ_COMPRESSED);
-    ret = bdrv_pread(extent->file, cluster_offset, buf_bytes, cluster_buf, 0);
+    ret = bdrv_co_pread(extent->file, cluster_offset, buf_bytes, cluster_buf,
+                        0);
     if (ret < 0) {
         goto out;
     }
@@ -2142,8 +2143,8 @@ vmdk_co_pwritev_compressed(BlockDriverState *bs, int64_t offset, int64_t bytes,
                 return length;
             }
             length = QEMU_ALIGN_UP(length, BDRV_SECTOR_SIZE);
-            ret = bdrv_truncate(s->extents[i].file, length, false,
-                                PREALLOC_MODE_OFF, 0, NULL);
+            ret = bdrv_co_truncate(s->extents[i].file, length, false,
+                                   PREALLOC_MODE_OFF, 0, NULL);
             if (ret < 0) {
                 return ret;
             }
@@ -2584,7 +2585,7 @@ static int coroutine_fn vmdk_co_do_create(int64_t size,
         desc_offset = 0x200;
     }
 
-    ret = blk_pwrite(blk, desc_offset, desc_len, desc, 0);
+    ret = blk_co_pwrite(blk, desc_offset, desc_len, desc, 0);
     if (ret < 0) {
         error_setg_errno(errp, -ret, "Could not write description");
         goto exit;
@@ -2592,7 +2593,7 @@ static int coroutine_fn vmdk_co_do_create(int64_t size,
     /* bdrv_pwrite write padding zeros to align to sector, we don't need that
      * for description file */
     if (desc_offset == 0) {
-        ret = blk_truncate(blk, desc_len, false, PREALLOC_MODE_OFF, 0, errp);
+        ret = blk_co_truncate(blk, desc_len, false, PREALLOC_MODE_OFF, 0, errp);
         if (ret < 0) {
             goto exit;
         }
diff --git a/blockdev.c b/blockdev.c
index 9230888e34..beeb51211a 100644
--- a/blockdev.c
+++ b/blockdev.c
@@ -2453,7 +2453,7 @@ void coroutine_fn qmp_block_resize(bool has_device, const char *device,
     bdrv_co_unlock(bs);
 
     old_ctx = bdrv_co_enter(bs);
-    blk_truncate(blk, size, false, PREALLOC_MODE_OFF, 0, errp);
+    blk_co_truncate(blk, size, false, PREALLOC_MODE_OFF, 0, errp);
     bdrv_co_leave(bs, old_ctx);
 
     bdrv_co_lock(bs);
-- 
2.37.1

