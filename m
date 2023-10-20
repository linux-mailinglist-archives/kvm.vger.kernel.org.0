Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3113F7D08F4
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 08:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376369AbjJTG7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 02:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376317AbjJTG7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 02:59:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7751498
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 23:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697785100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z/SAByVT7Qgiw/sxJHe4WcPtyn9dHrQ/m6/DajkrD1s=;
        b=h7HoIhpCiBc2qxbHLBqn2s9USo0HXHqZo1fY6PvWcIn0IJaXcugA1F6c+Q8JkZUQrvXfaY
        RJjBml89BydjnysMp/ciqZiB8z56NH67+8VcI6CCf3Q5XjbFYejgYOhhE/Q0hbkKI1HT0a
        ZOtQg2ihbFTXmxviIfp56oAbtTzueOk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-Pqjf3sjHNzmXAG5W3v3fwQ-1; Fri, 20 Oct 2023 02:58:16 -0400
X-MC-Unique: Pqjf3sjHNzmXAG5W3v3fwQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB0F910201E5;
        Fri, 20 Oct 2023 06:58:14 +0000 (UTC)
Received: from secure.mitica (unknown [10.39.194.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 987E325C0;
        Fri, 20 Oct 2023 06:58:07 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     qemu-s390x@nongnu.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "Denis V. Lunev" <den@openvz.org>,
        Juan Quintela <quintela@redhat.com>,
        Fam Zheng <fam@euphon.net>, kvm@vger.kernel.org,
        Harsh Prateek Bora <harshpb@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jagannathan Raman <jag.raman@oracle.com>, qemu-arm@nongnu.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        qemu-ppc@nongnu.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Stefan Weil <sw@weilnetz.de>, Peter Xu <peterx@redhat.com>,
        Christian Schoenebeck <qemu_oss@crudebyte.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Jeff Cody <codyprime@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Leonardo Bras <leobras@redhat.com>,
        Fabiano Rosas <farosas@suse.de>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Greg Kurz <groug@kaod.org>, qemu-block@nongnu.org,
        Steve Sistare <steven.sistare@oracle.com>,
        Michael Galaxy <mgalaxy@akamai.com>
Subject: [PULL 02/17] migration: simplify blockers
Date:   Fri, 20 Oct 2023 08:57:36 +0200
Message-ID: <20231020065751.26047-3-quintela@redhat.com>
In-Reply-To: <20231020065751.26047-1-quintela@redhat.com>
References: <20231020065751.26047-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Steve Sistare <steven.sistare@oracle.com>

Modify migrate_add_blocker and migrate_del_blocker to take an Error **
reason.  This allows migration to own the Error object, so that if
an error occurs in migrate_add_blocker, migration code can free the Error
and clear the client handle, simplifying client code.  It also simplifies
the migrate_del_blocker call site.

In addition, this is a pre-requisite for a proposed future patch that would
add a mode argument to migration requests to support live update, and
maintain a list of blockers for each mode.  A blocker may apply to a single
mode or to multiple modes, and passing Error** will allow one Error object
to be registered for multiple modes.

No functional change.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
Tested-by: Michael Galaxy <mgalaxy@akamai.com>
Reviewed-by: Michael Galaxy <mgalaxy@akamai.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
Message-ID: <1697634216-84215-1-git-send-email-steven.sistare@oracle.com>
---
 include/migration/blocker.h  | 24 +++++++++++++++++-------
 backends/tpm/tpm_emulator.c  | 10 ++--------
 block/parallels.c            |  9 +++------
 block/qcow.c                 |  6 ++----
 block/vdi.c                  |  6 ++----
 block/vhdx.c                 |  6 ++----
 block/vmdk.c                 |  6 ++----
 block/vpc.c                  |  6 ++----
 block/vvfat.c                |  6 ++----
 dump/dump.c                  |  4 ++--
 hw/9pfs/9p.c                 | 10 ++--------
 hw/display/virtio-gpu-base.c |  8 ++------
 hw/intc/arm_gic_kvm.c        |  3 +--
 hw/intc/arm_gicv3_its_kvm.c  |  3 +--
 hw/intc/arm_gicv3_kvm.c      |  3 +--
 hw/misc/ivshmem.c            |  8 ++------
 hw/ppc/pef.c                 |  2 +-
 hw/ppc/spapr.c               |  9 +--------
 hw/ppc/spapr_events.c        |  6 +++++-
 hw/ppc/spapr_rtas.c          |  2 +-
 hw/remote/proxy.c            |  7 ++-----
 hw/s390x/s390-virtio-ccw.c   |  9 +++------
 hw/scsi/vhost-scsi.c         |  8 +++-----
 hw/vfio/common.c             | 10 ++--------
 hw/vfio/migration.c          | 16 ++--------------
 hw/virtio/vhost.c            |  8 ++------
 migration/migration.c        | 22 ++++++++++++++--------
 stubs/migr-blocker.c         |  4 ++--
 target/i386/kvm/kvm.c        |  8 ++++----
 target/i386/nvmm/nvmm-all.c  |  3 +--
 target/i386/sev.c            |  2 +-
 target/i386/whpx/whpx-all.c  |  3 +--
 ui/vdagent.c                 |  5 ++---
 33 files changed, 92 insertions(+), 150 deletions(-)

diff --git a/include/migration/blocker.h b/include/migration/blocker.h
index 9cebe2ba06..b048f301b4 100644
--- a/include/migration/blocker.h
+++ b/include/migration/blocker.h
@@ -17,19 +17,23 @@
 /**
  * @migrate_add_blocker - prevent migration from proceeding
  *
- * @reason - an error to be returned whenever migration is attempted
+ * @reasonp - address of an error to be returned whenever migration is attempted
  *
  * @errp - [out] The reason (if any) we cannot block migration right now.
  *
  * @returns - 0 on success, -EBUSY/-EACCES on failure, with errp set.
+ *
+ * *@reasonp is freed and set to NULL if failure is returned.
+ * On success, the caller must not free @reasonp, except by
+ *   calling migrate_del_blocker.
  */
-int migrate_add_blocker(Error *reason, Error **errp);
+int migrate_add_blocker(Error **reasonp, Error **errp);
 
 /**
  * @migrate_add_blocker_internal - prevent migration from proceeding without
  *                                 only-migrate implications
  *
- * @reason - an error to be returned whenever migration is attempted
+ * @reasonp - address of an error to be returned whenever migration is attempted
  *
  * @errp - [out] The reason (if any) we cannot block migration right now.
  *
@@ -38,14 +42,20 @@ int migrate_add_blocker(Error *reason, Error **errp);
  * Some of the migration blockers can be temporary (e.g., for a few seconds),
  * so it shouldn't need to conflict with "-only-migratable".  For those cases,
  * we can call this function rather than @migrate_add_blocker().
+ *
+ * *@reasonp is freed and set to NULL if failure is returned.
+ * On success, the caller must not free @reasonp, except by
+ *   calling migrate_del_blocker.
  */
-int migrate_add_blocker_internal(Error *reason, Error **errp);
+int migrate_add_blocker_internal(Error **reasonp, Error **errp);
 
 /**
- * @migrate_del_blocker - remove a blocking error from migration
+ * @migrate_del_blocker - remove a blocking error from migration and free it.
  *
- * @reason - the error blocking migration
+ * @reasonp - address of the error blocking migration
+ *
+ * This function frees *@reasonp and sets it to NULL.
  */
-void migrate_del_blocker(Error *reason);
+void migrate_del_blocker(Error **reasonp);
 
 #endif
diff --git a/backends/tpm/tpm_emulator.c b/backends/tpm/tpm_emulator.c
index 402a2d6312..bf1a90f5d7 100644
--- a/backends/tpm/tpm_emulator.c
+++ b/backends/tpm/tpm_emulator.c
@@ -534,11 +534,8 @@ static int tpm_emulator_block_migration(TPMEmulator *tpm_emu)
         error_setg(&tpm_emu->migration_blocker,
                    "Migration disabled: TPM emulator does not support "
                    "migration");
-        if (migrate_add_blocker(tpm_emu->migration_blocker, &err) < 0) {
+        if (migrate_add_blocker(&tpm_emu->migration_blocker, &err) < 0) {
             error_report_err(err);
-            error_free(tpm_emu->migration_blocker);
-            tpm_emu->migration_blocker = NULL;
-
             return -1;
         }
     }
@@ -1016,10 +1013,7 @@ static void tpm_emulator_inst_finalize(Object *obj)
 
     qapi_free_TPMEmulatorOptions(tpm_emu->options);
 
-    if (tpm_emu->migration_blocker) {
-        migrate_del_blocker(tpm_emu->migration_blocker);
-        error_free(tpm_emu->migration_blocker);
-    }
+    migrate_del_blocker(&tpm_emu->migration_blocker);
 
     tpm_sized_buffer_reset(&state_blobs->volatil);
     tpm_sized_buffer_reset(&state_blobs->permanent);
diff --git a/block/parallels.c b/block/parallels.c
index 6b46623241..1d695ce7fb 100644
--- a/block/parallels.c
+++ b/block/parallels.c
@@ -1369,9 +1369,8 @@ static int parallels_open(BlockDriverState *bs, QDict *options, int flags,
                bdrv_get_device_or_node_name(bs));
     bdrv_graph_rdunlock_main_loop();
 
-    ret = migrate_add_blocker(s->migration_blocker, errp);
+    ret = migrate_add_blocker(&s->migration_blocker, errp);
     if (ret < 0) {
-        error_setg(errp, "Migration blocker error");
         goto fail;
     }
     qemu_co_mutex_init(&s->lock);
@@ -1406,7 +1405,7 @@ static int parallels_open(BlockDriverState *bs, QDict *options, int flags,
         ret = bdrv_check(bs, &res, BDRV_FIX_ERRORS | BDRV_FIX_LEAKS);
         if (ret < 0) {
             error_setg_errno(errp, -ret, "Could not repair corrupted image");
-            migrate_del_blocker(s->migration_blocker);
+            migrate_del_blocker(&s->migration_blocker);
             goto fail;
         }
     }
@@ -1423,7 +1422,6 @@ fail:
      */
     parallels_free_used_bitmap(bs);
 
-    error_free(s->migration_blocker);
     g_free(s->bat_dirty_bmap);
     qemu_vfree(s->header);
     return ret;
@@ -1448,8 +1446,7 @@ static void parallels_close(BlockDriverState *bs)
     g_free(s->bat_dirty_bmap);
     qemu_vfree(s->header);
 
-    migrate_del_blocker(s->migration_blocker);
-    error_free(s->migration_blocker);
+    migrate_del_blocker(&s->migration_blocker);
 }
 
 static bool parallels_is_support_dirty_bitmaps(BlockDriverState *bs)
diff --git a/block/qcow.c b/block/qcow.c
index 38a16253b8..fdd4c83948 100644
--- a/block/qcow.c
+++ b/block/qcow.c
@@ -307,9 +307,8 @@ static int qcow_open(BlockDriverState *bs, QDict *options, int flags,
                bdrv_get_device_or_node_name(bs));
     bdrv_graph_rdunlock_main_loop();
 
-    ret = migrate_add_blocker(s->migration_blocker, errp);
+    ret = migrate_add_blocker(&s->migration_blocker, errp);
     if (ret < 0) {
-        error_free(s->migration_blocker);
         goto fail;
     }
 
@@ -802,8 +801,7 @@ static void qcow_close(BlockDriverState *bs)
     g_free(s->cluster_cache);
     g_free(s->cluster_data);
 
-    migrate_del_blocker(s->migration_blocker);
-    error_free(s->migration_blocker);
+    migrate_del_blocker(&s->migration_blocker);
 }
 
 static int coroutine_fn GRAPH_UNLOCKED
diff --git a/block/vdi.c b/block/vdi.c
index 3ed43b6f35..fd7e365383 100644
--- a/block/vdi.c
+++ b/block/vdi.c
@@ -498,9 +498,8 @@ static int vdi_open(BlockDriverState *bs, QDict *options, int flags,
                bdrv_get_device_or_node_name(bs));
     bdrv_graph_rdunlock_main_loop();
 
-    ret = migrate_add_blocker(s->migration_blocker, errp);
+    ret = migrate_add_blocker(&s->migration_blocker, errp);
     if (ret < 0) {
-        error_free(s->migration_blocker);
         goto fail_free_bmap;
     }
 
@@ -988,8 +987,7 @@ static void vdi_close(BlockDriverState *bs)
 
     qemu_vfree(s->bmap);
 
-    migrate_del_blocker(s->migration_blocker);
-    error_free(s->migration_blocker);
+    migrate_del_blocker(&s->migration_blocker);
 }
 
 static int vdi_has_zero_init(BlockDriverState *bs)
diff --git a/block/vhdx.c b/block/vhdx.c
index 73cb214fb4..e37f8c0926 100644
--- a/block/vhdx.c
+++ b/block/vhdx.c
@@ -985,8 +985,7 @@ static void vhdx_close(BlockDriverState *bs)
     s->bat = NULL;
     qemu_vfree(s->parent_entries);
     s->parent_entries = NULL;
-    migrate_del_blocker(s->migration_blocker);
-    error_free(s->migration_blocker);
+    migrate_del_blocker(&s->migration_blocker);
     qemu_vfree(s->log.hdr);
     s->log.hdr = NULL;
     vhdx_region_unregister_all(s);
@@ -1097,9 +1096,8 @@ static int vhdx_open(BlockDriverState *bs, QDict *options, int flags,
     error_setg(&s->migration_blocker, "The vhdx format used by node '%s' "
                "does not support live migration",
                bdrv_get_device_or_node_name(bs));
-    ret = migrate_add_blocker(s->migration_blocker, errp);
+    ret = migrate_add_blocker(&s->migration_blocker, errp);
     if (ret < 0) {
-        error_free(s->migration_blocker);
         goto fail;
     }
 
diff --git a/block/vmdk.c b/block/vmdk.c
index 8a3b152798..1335d39e16 100644
--- a/block/vmdk.c
+++ b/block/vmdk.c
@@ -1386,9 +1386,8 @@ static int vmdk_open(BlockDriverState *bs, QDict *options, int flags,
     error_setg(&s->migration_blocker, "The vmdk format used by node '%s' "
                "does not support live migration",
                bdrv_get_device_or_node_name(bs));
-    ret = migrate_add_blocker(s->migration_blocker, errp);
+    ret = migrate_add_blocker(&s->migration_blocker, errp);
     if (ret < 0) {
-        error_free(s->migration_blocker);
         goto fail;
     }
 
@@ -2867,8 +2866,7 @@ static void vmdk_close(BlockDriverState *bs)
     vmdk_free_extents(bs);
     g_free(s->create_type);
 
-    migrate_del_blocker(s->migration_blocker);
-    error_free(s->migration_blocker);
+    migrate_del_blocker(&s->migration_blocker);
 }
 
 static int64_t coroutine_fn GRAPH_RDLOCK
diff --git a/block/vpc.c b/block/vpc.c
index 945847fe4a..c30cf8689a 100644
--- a/block/vpc.c
+++ b/block/vpc.c
@@ -452,9 +452,8 @@ static int vpc_open(BlockDriverState *bs, QDict *options, int flags,
                bdrv_get_device_or_node_name(bs));
     bdrv_graph_rdunlock_main_loop();
 
-    ret = migrate_add_blocker(s->migration_blocker, errp);
+    ret = migrate_add_blocker(&s->migration_blocker, errp);
     if (ret < 0) {
-        error_free(s->migration_blocker);
         goto fail;
     }
 
@@ -1190,8 +1189,7 @@ static void vpc_close(BlockDriverState *bs)
     g_free(s->pageentry_u8);
 #endif
 
-    migrate_del_blocker(s->migration_blocker);
-    error_free(s->migration_blocker);
+    migrate_del_blocker(&s->migration_blocker);
 }
 
 static QemuOptsList vpc_create_opts = {
diff --git a/block/vvfat.c b/block/vvfat.c
index b0415798c0..266e036dcd 100644
--- a/block/vvfat.c
+++ b/block/vvfat.c
@@ -1268,9 +1268,8 @@ static int vvfat_open(BlockDriverState *bs, QDict *options, int flags,
                    "The vvfat (rw) format used by node '%s' "
                    "does not support live migration",
                    bdrv_get_device_or_node_name(bs));
-        ret = migrate_add_blocker(s->migration_blocker, errp);
+        ret = migrate_add_blocker(&s->migration_blocker, errp);
         if (ret < 0) {
-            error_free(s->migration_blocker);
             goto fail;
         }
     }
@@ -3239,8 +3238,7 @@ static void vvfat_close(BlockDriverState *bs)
     g_free(s->cluster_buffer);
 
     if (s->qcow) {
-        migrate_del_blocker(s->migration_blocker);
-        error_free(s->migration_blocker);
+        migrate_del_blocker(&s->migration_blocker);
     }
 }
 
diff --git a/dump/dump.c b/dump/dump.c
index d3578ddc62..d355ada62e 100644
--- a/dump/dump.c
+++ b/dump/dump.c
@@ -111,7 +111,7 @@ static int dump_cleanup(DumpState *s)
             qemu_mutex_unlock_iothread();
         }
     }
-    migrate_del_blocker(dump_migration_blocker);
+    migrate_del_blocker(&dump_migration_blocker);
 
     return 0;
 }
@@ -2158,7 +2158,7 @@ void qmp_dump_guest_memory(bool paging, const char *file,
      * Allows even for -only-migratable, but forbid migration during the
      * process of dump guest memory.
      */
-    if (migrate_add_blocker_internal(dump_migration_blocker, errp)) {
+    if (migrate_add_blocker_internal(&dump_migration_blocker, errp)) {
         /* Remember to release the fd before passing it over to dump state */
         close(fd);
         return;
diff --git a/hw/9pfs/9p.c b/hw/9pfs/9p.c
index 323f042e65..af636cfb2d 100644
--- a/hw/9pfs/9p.c
+++ b/hw/9pfs/9p.c
@@ -406,11 +406,7 @@ static int coroutine_fn put_fid(V9fsPDU *pdu, V9fsFidState *fidp)
              * delete the migration blocker. Ideally, this
              * should be hooked to transport close notification
              */
-            if (pdu->s->migration_blocker) {
-                migrate_del_blocker(pdu->s->migration_blocker);
-                error_free(pdu->s->migration_blocker);
-                pdu->s->migration_blocker = NULL;
-            }
+            migrate_del_blocker(&pdu->s->migration_blocker);
         }
         return free_fid(pdu, fidp);
     }
@@ -1505,10 +1501,8 @@ static void coroutine_fn v9fs_attach(void *opaque)
         error_setg(&s->migration_blocker,
                    "Migration is disabled when VirtFS export path '%s' is mounted in the guest using mount_tag '%s'",
                    s->ctx.fs_root ? s->ctx.fs_root : "NULL", s->tag);
-        err = migrate_add_blocker(s->migration_blocker, NULL);
+        err = migrate_add_blocker(&s->migration_blocker, NULL);
         if (err < 0) {
-            error_free(s->migration_blocker);
-            s->migration_blocker = NULL;
             clunk_fid(s, fid);
             goto out;
         }
diff --git a/hw/display/virtio-gpu-base.c b/hw/display/virtio-gpu-base.c
index 50c5373b65..37af256219 100644
--- a/hw/display/virtio-gpu-base.c
+++ b/hw/display/virtio-gpu-base.c
@@ -184,8 +184,7 @@ virtio_gpu_base_device_realize(DeviceState *qdev,
 
     if (virtio_gpu_virgl_enabled(g->conf)) {
         error_setg(&g->migration_blocker, "virgl is not yet migratable");
-        if (migrate_add_blocker(g->migration_blocker, errp) < 0) {
-            error_free(g->migration_blocker);
+        if (migrate_add_blocker(&g->migration_blocker, errp) < 0) {
             return false;
         }
     }
@@ -253,10 +252,7 @@ virtio_gpu_base_device_unrealize(DeviceState *qdev)
 {
     VirtIOGPUBase *g = VIRTIO_GPU_BASE(qdev);
 
-    if (g->migration_blocker) {
-        migrate_del_blocker(g->migration_blocker);
-        error_free(g->migration_blocker);
-    }
+    migrate_del_blocker(&g->migration_blocker);
 }
 
 static void
diff --git a/hw/intc/arm_gic_kvm.c b/hw/intc/arm_gic_kvm.c
index 1d588946bc..e0d9e512a3 100644
--- a/hw/intc/arm_gic_kvm.c
+++ b/hw/intc/arm_gic_kvm.c
@@ -516,8 +516,7 @@ static void kvm_arm_gic_realize(DeviceState *dev, Error **errp)
     if (!kvm_arm_gic_can_save_restore(s)) {
         error_setg(&s->migration_blocker, "This operating system kernel does "
                                           "not support vGICv2 migration");
-        if (migrate_add_blocker(s->migration_blocker, errp) < 0) {
-            error_free(s->migration_blocker);
+        if (migrate_add_blocker(&s->migration_blocker, errp) < 0) {
             return;
         }
     }
diff --git a/hw/intc/arm_gicv3_its_kvm.c b/hw/intc/arm_gicv3_its_kvm.c
index 7eda9fb86e..61c1cc7bdb 100644
--- a/hw/intc/arm_gicv3_its_kvm.c
+++ b/hw/intc/arm_gicv3_its_kvm.c
@@ -114,8 +114,7 @@ static void kvm_arm_its_realize(DeviceState *dev, Error **errp)
         GITS_CTLR)) {
         error_setg(&s->migration_blocker, "This operating system kernel "
                    "does not support vITS migration");
-        if (migrate_add_blocker(s->migration_blocker, errp) < 0) {
-            error_free(s->migration_blocker);
+        if (migrate_add_blocker(&s->migration_blocker, errp) < 0) {
             return;
         }
     } else {
diff --git a/hw/intc/arm_gicv3_kvm.c b/hw/intc/arm_gicv3_kvm.c
index 72ad916d3d..77eb37e131 100644
--- a/hw/intc/arm_gicv3_kvm.c
+++ b/hw/intc/arm_gicv3_kvm.c
@@ -878,8 +878,7 @@ static void kvm_arm_gicv3_realize(DeviceState *dev, Error **errp)
                                GICD_CTLR)) {
         error_setg(&s->migration_blocker, "This operating system kernel does "
                                           "not support vGICv3 migration");
-        if (migrate_add_blocker(s->migration_blocker, errp) < 0) {
-            error_free(s->migration_blocker);
+        if (migrate_add_blocker(&s->migration_blocker, errp) < 0) {
             return;
         }
     }
diff --git a/hw/misc/ivshmem.c b/hw/misc/ivshmem.c
index d66d912172..0447888029 100644
--- a/hw/misc/ivshmem.c
+++ b/hw/misc/ivshmem.c
@@ -903,8 +903,7 @@ static void ivshmem_common_realize(PCIDevice *dev, Error **errp)
     if (!ivshmem_is_master(s)) {
         error_setg(&s->migration_blocker,
                    "Migration is disabled when using feature 'peer mode' in device 'ivshmem'");
-        if (migrate_add_blocker(s->migration_blocker, errp) < 0) {
-            error_free(s->migration_blocker);
+        if (migrate_add_blocker(&s->migration_blocker, errp) < 0) {
             return;
         }
     }
@@ -922,10 +921,7 @@ static void ivshmem_exit(PCIDevice *dev)
     IVShmemState *s = IVSHMEM_COMMON(dev);
     int i;
 
-    if (s->migration_blocker) {
-        migrate_del_blocker(s->migration_blocker);
-        error_free(s->migration_blocker);
-    }
+    migrate_del_blocker(&s->migration_blocker);
 
     if (memory_region_is_mapped(s->ivshmem_bar2)) {
         if (!s->hostmem) {
diff --git a/hw/ppc/pef.c b/hw/ppc/pef.c
index cc44d5e339..d28ed3ba73 100644
--- a/hw/ppc/pef.c
+++ b/hw/ppc/pef.c
@@ -63,7 +63,7 @@ static int kvmppc_svm_init(ConfidentialGuestSupport *cgs, Error **errp)
     /* add migration blocker */
     error_setg(&pef_mig_blocker, "PEF: Migration is not implemented");
     /* NB: This can fail if --only-migratable is used */
-    migrate_add_blocker(pef_mig_blocker, &error_fatal);
+    migrate_add_blocker(&pef_mig_blocker, &error_fatal);
 
     cgs->ready = true;
 
diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index cb840676d3..b25093be28 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -1761,7 +1761,7 @@ static void spapr_machine_reset(MachineState *machine, ShutdownCause reason)
     /* Signal all vCPUs waiting on this condition */
     qemu_cond_broadcast(&spapr->fwnmi_machine_check_interlock_cond);
 
-    migrate_del_blocker(spapr->fwnmi_migration_blocker);
+    migrate_del_blocker(&spapr->fwnmi_migration_blocker);
 }
 
 static void spapr_create_nvram(SpaprMachineState *spapr)
@@ -2937,13 +2937,6 @@ static void spapr_machine_init(MachineState *machine)
         spapr_create_lmb_dr_connectors(spapr);
     }
 
-    if (spapr_get_cap(spapr, SPAPR_CAP_FWNMI) == SPAPR_CAP_ON) {
-        /* Create the error string for live migration blocker */
-        error_setg(&spapr->fwnmi_migration_blocker,
-            "A machine check is being handled during migration. The handler"
-            "may run and log hardware error on the destination");
-    }
-
     if (mc->nvdimm_supported) {
         spapr_create_nvdimm_dr_connectors(spapr);
     }
diff --git a/hw/ppc/spapr_events.c b/hw/ppc/spapr_events.c
index 4508e40814..deb4641505 100644
--- a/hw/ppc/spapr_events.c
+++ b/hw/ppc/spapr_events.c
@@ -920,7 +920,11 @@ void spapr_mce_req_event(PowerPCCPU *cpu, bool recovered)
      * fails when running with -only-migrate.  A proper interface to
      * delay migration completion for a bit could avoid that.
      */
-    ret = migrate_add_blocker(spapr->fwnmi_migration_blocker, NULL);
+    error_setg(&spapr->fwnmi_migration_blocker,
+        "A machine check is being handled during migration. The handler"
+        "may run and log hardware error on the destination");
+
+    ret = migrate_add_blocker(&spapr->fwnmi_migration_blocker, NULL);
     if (ret == -EBUSY) {
         warn_report("Received a fwnmi while migration was in progress");
     }
diff --git a/hw/ppc/spapr_rtas.c b/hw/ppc/spapr_rtas.c
index 7df21581c2..26c384b261 100644
--- a/hw/ppc/spapr_rtas.c
+++ b/hw/ppc/spapr_rtas.c
@@ -496,7 +496,7 @@ static void rtas_ibm_nmi_interlock(PowerPCCPU *cpu,
     spapr->fwnmi_machine_check_interlock = -1;
     qemu_cond_signal(&spapr->fwnmi_machine_check_interlock_cond);
     rtas_st(rets, 0, RTAS_OUT_SUCCESS);
-    migrate_del_blocker(spapr->fwnmi_migration_blocker);
+    migrate_del_blocker(&spapr->fwnmi_migration_blocker);
 }
 
 static struct rtas_call {
diff --git a/hw/remote/proxy.c b/hw/remote/proxy.c
index 2052d721e5..fbc85a8d36 100644
--- a/hw/remote/proxy.c
+++ b/hw/remote/proxy.c
@@ -107,8 +107,7 @@ static void pci_proxy_dev_realize(PCIDevice *device, Error **errp)
 
     error_setg(&dev->migration_blocker, "%s does not support migration",
                TYPE_PCI_PROXY_DEV);
-    if (migrate_add_blocker(dev->migration_blocker, errp) < 0) {
-        error_free(dev->migration_blocker);
+    if (migrate_add_blocker(&dev->migration_blocker, errp) < 0) {
         object_unref(dev->ioc);
         return;
     }
@@ -134,9 +133,7 @@ static void pci_proxy_dev_exit(PCIDevice *pdev)
         qio_channel_close(dev->ioc, NULL);
     }
 
-    migrate_del_blocker(dev->migration_blocker);
-
-    error_free(dev->migration_blocker);
+    migrate_del_blocker(&dev->migration_blocker);
 
     proxy_memory_listener_deconfigure(&dev->proxy_listener);
 
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index 2d75f2131f..07a5157c0f 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -332,8 +332,7 @@ static void s390_machine_unprotect(S390CcwMachineState *ms)
         s390_pv_vm_disable();
     }
     ms->pv = false;
-    migrate_del_blocker(pv_mig_blocker);
-    error_free_or_abort(&pv_mig_blocker);
+    migrate_del_blocker(&pv_mig_blocker);
     ram_block_discard_disable(false);
 }
 
@@ -356,11 +355,10 @@ static int s390_machine_protect(S390CcwMachineState *ms)
 
     error_setg(&pv_mig_blocker,
                "protected VMs are currently not migratable.");
-    rc = migrate_add_blocker(pv_mig_blocker, &local_err);
+    rc = migrate_add_blocker(&pv_mig_blocker, &local_err);
     if (rc) {
         ram_block_discard_disable(false);
         error_report_err(local_err);
-        error_free_or_abort(&pv_mig_blocker);
         return rc;
     }
 
@@ -368,8 +366,7 @@ static int s390_machine_protect(S390CcwMachineState *ms)
     rc = s390_pv_vm_enable();
     if (rc) {
         ram_block_discard_disable(false);
-        migrate_del_blocker(pv_mig_blocker);
-        error_free_or_abort(&pv_mig_blocker);
+        migrate_del_blocker(&pv_mig_blocker);
         return rc;
     }
 
diff --git a/hw/scsi/vhost-scsi.c b/hw/scsi/vhost-scsi.c
index 443f67daa4..14e23cc5b4 100644
--- a/hw/scsi/vhost-scsi.c
+++ b/hw/scsi/vhost-scsi.c
@@ -208,7 +208,7 @@ static void vhost_scsi_realize(DeviceState *dev, Error **errp)
                 "When external environment supports it (Orchestrator migrates "
                 "target SCSI device state or use shared storage over network), "
                 "set 'migratable' property to true to enable migration.");
-        if (migrate_add_blocker(vsc->migration_blocker, errp) < 0) {
+        if (migrate_add_blocker(&vsc->migration_blocker, errp) < 0) {
             goto free_virtio;
         }
     }
@@ -241,10 +241,9 @@ static void vhost_scsi_realize(DeviceState *dev, Error **errp)
  free_vqs:
     g_free(vqs);
     if (!vsc->migratable) {
-        migrate_del_blocker(vsc->migration_blocker);
+        migrate_del_blocker(&vsc->migration_blocker);
     }
  free_virtio:
-    error_free(vsc->migration_blocker);
     virtio_scsi_common_unrealize(dev);
  close_fd:
     if (vhostfd >= 0) {
@@ -260,8 +259,7 @@ static void vhost_scsi_unrealize(DeviceState *dev)
     struct vhost_virtqueue *vqs = vsc->dev.vqs;
 
     if (!vsc->migratable) {
-        migrate_del_blocker(vsc->migration_blocker);
-        error_free(vsc->migration_blocker);
+        migrate_del_blocker(&vsc->migration_blocker);
     }
 
     /* This will stop vhost backend. */
diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index 5ff5acf1d8..d806057b40 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -129,11 +129,7 @@ int vfio_block_multiple_devices_migration(VFIODevice *vbasedev, Error **errp)
     error_setg(&multiple_devices_migration_blocker,
                "Multiple VFIO devices migration is supported only if all of "
                "them support P2P migration");
-    ret = migrate_add_blocker(multiple_devices_migration_blocker, errp);
-    if (ret < 0) {
-        error_free(multiple_devices_migration_blocker);
-        multiple_devices_migration_blocker = NULL;
-    }
+    ret = migrate_add_blocker(&multiple_devices_migration_blocker, errp);
 
     return ret;
 }
@@ -145,9 +141,7 @@ void vfio_unblock_multiple_devices_migration(void)
         return;
     }
 
-    migrate_del_blocker(multiple_devices_migration_blocker);
-    error_free(multiple_devices_migration_blocker);
-    multiple_devices_migration_blocker = NULL;
+    migrate_del_blocker(&multiple_devices_migration_blocker);
 }
 
 bool vfio_viommu_preset(VFIODevice *vbasedev)
diff --git a/hw/vfio/migration.c b/hw/vfio/migration.c
index da43dcd2fe..0aaad65c06 100644
--- a/hw/vfio/migration.c
+++ b/hw/vfio/migration.c
@@ -891,8 +891,6 @@ static void vfio_migration_deinit(VFIODevice *vbasedev)
 
 static int vfio_block_migration(VFIODevice *vbasedev, Error *err, Error **errp)
 {
-    int ret;
-
     if (vbasedev->enable_migration == ON_OFF_AUTO_ON) {
         error_propagate(errp, err);
         return -EINVAL;
@@ -901,13 +899,7 @@ static int vfio_block_migration(VFIODevice *vbasedev, Error *err, Error **errp)
     vbasedev->migration_blocker = error_copy(err);
     error_free(err);
 
-    ret = migrate_add_blocker(vbasedev->migration_blocker, errp);
-    if (ret < 0) {
-        error_free(vbasedev->migration_blocker);
-        vbasedev->migration_blocker = NULL;
-    }
-
-    return ret;
+    return migrate_add_blocker(&vbasedev->migration_blocker, errp);
 }
 
 /* ---------------------------------------------------------------------- */
@@ -994,9 +986,5 @@ void vfio_migration_exit(VFIODevice *vbasedev)
         vfio_migration_deinit(vbasedev);
     }
 
-    if (vbasedev->migration_blocker) {
-        migrate_del_blocker(vbasedev->migration_blocker);
-        error_free(vbasedev->migration_blocker);
-        vbasedev->migration_blocker = NULL;
-    }
+    migrate_del_blocker(&vbasedev->migration_blocker);
 }
diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 9f37206ba0..d737671028 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -1527,9 +1527,8 @@ int vhost_dev_init(struct vhost_dev *hdev, void *opaque,
     }
 
     if (hdev->migration_blocker != NULL) {
-        r = migrate_add_blocker(hdev->migration_blocker, errp);
+        r = migrate_add_blocker(&hdev->migration_blocker, errp);
         if (r < 0) {
-            error_free(hdev->migration_blocker);
             goto fail_busyloop;
         }
     }
@@ -1597,10 +1596,7 @@ void vhost_dev_cleanup(struct vhost_dev *hdev)
         memory_listener_unregister(&hdev->memory_listener);
         QLIST_REMOVE(hdev, entry);
     }
-    if (hdev->migration_blocker) {
-        migrate_del_blocker(hdev->migration_blocker);
-        error_free(hdev->migration_blocker);
-    }
+    migrate_del_blocker(&hdev->migration_blocker);
     g_free(hdev->mem);
     g_free(hdev->mem_sections);
     if (hdev->vhost_ops) {
diff --git a/migration/migration.c b/migration/migration.c
index 05c0b801ba..818b02b707 100644
--- a/migration/migration.c
+++ b/migration/migration.c
@@ -1465,35 +1465,41 @@ int migrate_init(MigrationState *s, Error **errp)
     return 0;
 }
 
-int migrate_add_blocker_internal(Error *reason, Error **errp)
+int migrate_add_blocker_internal(Error **reasonp, Error **errp)
 {
     /* Snapshots are similar to migrations, so check RUN_STATE_SAVE_VM too. */
     if (runstate_check(RUN_STATE_SAVE_VM) || !migration_is_idle()) {
-        error_propagate_prepend(errp, error_copy(reason),
+        error_propagate_prepend(errp, *reasonp,
                                 "disallowing migration blocker "
                                 "(migration/snapshot in progress) for: ");
+        *reasonp = NULL;
         return -EBUSY;
     }
 
-    migration_blockers = g_slist_prepend(migration_blockers, reason);
+    migration_blockers = g_slist_prepend(migration_blockers, *reasonp);
     return 0;
 }
 
-int migrate_add_blocker(Error *reason, Error **errp)
+int migrate_add_blocker(Error **reasonp, Error **errp)
 {
     if (only_migratable) {
-        error_propagate_prepend(errp, error_copy(reason),
+        error_propagate_prepend(errp, *reasonp,
                                 "disallowing migration blocker "
                                 "(--only-migratable) for: ");
+        *reasonp = NULL;
         return -EACCES;
     }
 
-    return migrate_add_blocker_internal(reason, errp);
+    return migrate_add_blocker_internal(reasonp, errp);
 }
 
-void migrate_del_blocker(Error *reason)
+void migrate_del_blocker(Error **reasonp)
 {
-    migration_blockers = g_slist_remove(migration_blockers, reason);
+    if (*reasonp) {
+        migration_blockers = g_slist_remove(migration_blockers, *reasonp);
+        error_free(*reasonp);
+        *reasonp = NULL;
+    }
 }
 
 void qmp_migrate_incoming(const char *uri, Error **errp)
diff --git a/stubs/migr-blocker.c b/stubs/migr-blocker.c
index 5676a2f93c..17a5dbf87b 100644
--- a/stubs/migr-blocker.c
+++ b/stubs/migr-blocker.c
@@ -1,11 +1,11 @@
 #include "qemu/osdep.h"
 #include "migration/blocker.h"
 
-int migrate_add_blocker(Error *reason, Error **errp)
+int migrate_add_blocker(Error **reasonp, Error **errp)
 {
     return 0;
 }
 
-void migrate_del_blocker(Error *reason)
+void migrate_del_blocker(Error **reasonp)
 {
 }
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index ab72bcdfad..e7c054cc16 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1603,7 +1603,7 @@ static int hyperv_init_vcpu(X86CPU *cpu)
         error_setg(&hv_passthrough_mig_blocker,
                    "'hv-passthrough' CPU flag prevents migration, use explicit"
                    " set of hv-* flags instead");
-        ret = migrate_add_blocker(hv_passthrough_mig_blocker, &local_err);
+        ret = migrate_add_blocker(&hv_passthrough_mig_blocker, &local_err);
         if (ret < 0) {
             error_report_err(local_err);
             return ret;
@@ -1617,7 +1617,7 @@ static int hyperv_init_vcpu(X86CPU *cpu)
                    " use explicit 'hv-no-nonarch-coresharing=on' instead (but"
                    " make sure SMT is disabled and/or that vCPUs are properly"
                    " pinned)");
-        ret = migrate_add_blocker(hv_no_nonarch_cs_mig_blocker, &local_err);
+        ret = migrate_add_blocker(&hv_no_nonarch_cs_mig_blocker, &local_err);
         if (ret < 0) {
             error_report_err(local_err);
             return ret;
@@ -2213,7 +2213,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
             error_setg(&invtsc_mig_blocker,
                        "State blocked by non-migratable CPU device"
                        " (invtsc flag)");
-            r = migrate_add_blocker(invtsc_mig_blocker, &local_err);
+            r = migrate_add_blocker(&invtsc_mig_blocker, &local_err);
             if (r < 0) {
                 error_report_err(local_err);
                 return r;
@@ -2271,7 +2271,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
     return 0;
 
  fail:
-    migrate_del_blocker(invtsc_mig_blocker);
+    migrate_del_blocker(&invtsc_mig_blocker);
 
     return r;
 }
diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
index fb769868f2..7d752bc5e0 100644
--- a/target/i386/nvmm/nvmm-all.c
+++ b/target/i386/nvmm/nvmm-all.c
@@ -929,9 +929,8 @@ nvmm_init_vcpu(CPUState *cpu)
         error_setg(&nvmm_migration_blocker,
             "NVMM: Migration not supported");
 
-        if (migrate_add_blocker(nvmm_migration_blocker, &local_error) < 0) {
+        if (migrate_add_blocker(&nvmm_migration_blocker, &local_error) < 0) {
             error_report_err(local_error);
-            error_free(nvmm_migration_blocker);
             return -EINVAL;
         }
     }
diff --git a/target/i386/sev.c b/target/i386/sev.c
index fe2144c038..9a71246682 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -891,7 +891,7 @@ sev_launch_finish(SevGuestState *sev)
     /* add migration blocker */
     error_setg(&sev_mig_blocker,
                "SEV: Migration is not implemented");
-    migrate_add_blocker(sev_mig_blocker, &error_fatal);
+    migrate_add_blocker(&sev_mig_blocker, &error_fatal);
 }
 
 static void
diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index df3aba2642..d29ba916a0 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -2160,9 +2160,8 @@ int whpx_init_vcpu(CPUState *cpu)
                "State blocked due to non-migratable CPUID feature support,"
                "dirty memory tracking support, and XSAVE/XRSTOR support");
 
-        if (migrate_add_blocker(whpx_migration_blocker, &local_error) < 0) {
+        if (migrate_add_blocker(&whpx_migration_blocker, &local_error) < 0) {
             error_report_err(local_error);
-            error_free(whpx_migration_blocker);
             ret = -EINVAL;
             goto error;
         }
diff --git a/ui/vdagent.c b/ui/vdagent.c
index 00d36a8677..d8f2f95432 100644
--- a/ui/vdagent.c
+++ b/ui/vdagent.c
@@ -671,7 +671,7 @@ static void vdagent_chr_open(Chardev *chr,
     return;
 #endif
 
-    if (migrate_add_blocker(vd->migration_blocker, errp) != 0) {
+    if (migrate_add_blocker(&vd->migration_blocker, errp) != 0) {
         return;
     }
 
@@ -924,13 +924,12 @@ static void vdagent_chr_fini(Object *obj)
 {
     VDAgentChardev *vd = QEMU_VDAGENT_CHARDEV(obj);
 
-    migrate_del_blocker(vd->migration_blocker);
+    migrate_del_blocker(&vd->migration_blocker);
     vdagent_disconnect(vd);
     if (vd->mouse_hs) {
         qemu_input_handler_unregister(vd->mouse_hs);
     }
     buffer_free(&vd->outbuf);
-    error_free(vd->migration_blocker);
 }
 
 static const TypeInfo vdagent_chr_type_info = {
-- 
2.41.0

