Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B83B71A2C3
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 17:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235109AbjFAPb1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 11:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233812AbjFAPbK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 11:31:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B2EE51
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 08:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685633278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LUW/UViDGW02kQ/3j6Afz3hRTQNvXIZflOpv+pi7CHk=;
        b=LcMlSEXQWUOXJKQ8XgHEdgMH8VYIjjMYeodFxLyp44cwg/ZU3N80cjL3dGcTWJCgSMjp+d
        5/oyrDoJl/tgi73E2Zg4lvQZMKRAgpPH5DBMCPhhjaCP2E6TkbjobYvebsWbhm/xNBcER4
        e3G5xJ4xBEkUNTY6plGags5HIw/T1ok=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-97tanEttN06cpnPrWUSb1A-1; Thu, 01 Jun 2023 11:26:19 -0400
X-MC-Unique: 97tanEttN06cpnPrWUSb1A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3741C803CA2;
        Thu,  1 Jun 2023 15:25:57 +0000 (UTC)
Received: from localhost (unknown [10.39.194.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7572F20296C6;
        Thu,  1 Jun 2023 15:25:56 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     qemu-block@nongnu.org, Stefano Stabellini <sstabellini@kernel.org>,
        Aarushi Mehta <mehta.aaru20@gmail.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Thomas Huth <thuth@redhat.com>,
        Julia Suvorova <jusual@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fam Zheng <fam@euphon.net>, Hanna Reitz <hreitz@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        xen-devel@lists.xenproject.org, Paul Durrant <paul@xen.org>,
        Kevin Wolf <kwolf@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eric Blake <eblake@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        kvm@vger.kernel.org
Subject: [PULL 1/8] block: add blk_io_plug_call() API
Date:   Thu,  1 Jun 2023 11:25:45 -0400
Message-Id: <20230601152552.1603119-2-stefanha@redhat.com>
In-Reply-To: <20230601152552.1603119-1-stefanha@redhat.com>
References: <20230601152552.1603119-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a new API for thread-local blk_io_plug() that does not
traverse the block graph. The goal is to make blk_io_plug() multi-queue
friendly.

Instead of having block drivers track whether or not we're in a plugged
section, provide an API that allows them to defer a function call until
we're unplugged: blk_io_plug_call(fn, opaque). If blk_io_plug_call() is
called multiple times with the same fn/opaque pair, then fn() is only
called once at the end of the function - resulting in batching.

This patch introduces the API and changes blk_io_plug()/blk_io_unplug().
blk_io_plug()/blk_io_unplug() no longer require a BlockBackend argument
because the plug state is now thread-local.

Later patches convert block drivers to blk_io_plug_call() and then we
can finally remove .bdrv_co_io_plug() once all block drivers have been
converted.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Eric Blake <eblake@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Kevin Wolf <kwolf@redhat.com>
Message-id: 20230530180959.1108766-2-stefanha@redhat.com
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 MAINTAINERS                       |   1 +
 include/sysemu/block-backend-io.h |  13 +--
 block/block-backend.c             |  22 -----
 block/plug.c                      | 159 ++++++++++++++++++++++++++++++
 hw/block/dataplane/xen-block.c    |   8 +-
 hw/block/virtio-blk.c             |   4 +-
 hw/scsi/virtio-scsi.c             |   6 +-
 block/meson.build                 |   1 +
 8 files changed, 173 insertions(+), 41 deletions(-)
 create mode 100644 block/plug.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 4b025a7b63..89f274f85e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2650,6 +2650,7 @@ F: util/aio-*.c
 F: util/aio-*.h
 F: util/fdmon-*.c
 F: block/io.c
+F: block/plug.c
 F: migration/block*
 F: include/block/aio.h
 F: include/block/aio-wait.h
diff --git a/include/sysemu/block-backend-io.h b/include/sysemu/block-backend-io.h
index d62a7ee773..be4dcef59d 100644
--- a/include/sysemu/block-backend-io.h
+++ b/include/sysemu/block-backend-io.h
@@ -100,16 +100,9 @@ void blk_iostatus_set_err(BlockBackend *blk, int error);
 int blk_get_max_iov(BlockBackend *blk);
 int blk_get_max_hw_iov(BlockBackend *blk);
 
-/*
- * blk_io_plug/unplug are thread-local operations. This means that multiple
- * IOThreads can simultaneously call plug/unplug, but the caller must ensure
- * that each unplug() is called in the same IOThread of the matching plug().
- */
-void coroutine_fn blk_co_io_plug(BlockBackend *blk);
-void co_wrapper blk_io_plug(BlockBackend *blk);
-
-void coroutine_fn blk_co_io_unplug(BlockBackend *blk);
-void co_wrapper blk_io_unplug(BlockBackend *blk);
+void blk_io_plug(void);
+void blk_io_unplug(void);
+void blk_io_plug_call(void (*fn)(void *), void *opaque);
 
 AioContext *blk_get_aio_context(BlockBackend *blk);
 BlockAcctStats *blk_get_stats(BlockBackend *blk);
diff --git a/block/block-backend.c b/block/block-backend.c
index 241f643507..4009ed5fed 100644
--- a/block/block-backend.c
+++ b/block/block-backend.c
@@ -2582,28 +2582,6 @@ void blk_add_insert_bs_notifier(BlockBackend *blk, Notifier *notify)
     notifier_list_add(&blk->insert_bs_notifiers, notify);
 }
 
-void coroutine_fn blk_co_io_plug(BlockBackend *blk)
-{
-    BlockDriverState *bs = blk_bs(blk);
-    IO_CODE();
-    GRAPH_RDLOCK_GUARD();
-
-    if (bs) {
-        bdrv_co_io_plug(bs);
-    }
-}
-
-void coroutine_fn blk_co_io_unplug(BlockBackend *blk)
-{
-    BlockDriverState *bs = blk_bs(blk);
-    IO_CODE();
-    GRAPH_RDLOCK_GUARD();
-
-    if (bs) {
-        bdrv_co_io_unplug(bs);
-    }
-}
-
 BlockAcctStats *blk_get_stats(BlockBackend *blk)
 {
     IO_CODE();
diff --git a/block/plug.c b/block/plug.c
new file mode 100644
index 0000000000..98a155d2f4
--- /dev/null
+++ b/block/plug.c
@@ -0,0 +1,159 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Block I/O plugging
+ *
+ * Copyright Red Hat.
+ *
+ * This API defers a function call within a blk_io_plug()/blk_io_unplug()
+ * section, allowing multiple calls to batch up. This is a performance
+ * optimization that is used in the block layer to submit several I/O requests
+ * at once instead of individually:
+ *
+ *   blk_io_plug(); <-- start of plugged region
+ *   ...
+ *   blk_io_plug_call(my_func, my_obj); <-- deferred my_func(my_obj) call
+ *   blk_io_plug_call(my_func, my_obj); <-- another
+ *   blk_io_plug_call(my_func, my_obj); <-- another
+ *   ...
+ *   blk_io_unplug(); <-- end of plugged region, my_func(my_obj) is called once
+ *
+ * This code is actually generic and not tied to the block layer. If another
+ * subsystem needs this functionality, it could be renamed.
+ */
+
+#include "qemu/osdep.h"
+#include "qemu/coroutine-tls.h"
+#include "qemu/notify.h"
+#include "qemu/thread.h"
+#include "sysemu/block-backend.h"
+
+/* A function call that has been deferred until unplug() */
+typedef struct {
+    void (*fn)(void *);
+    void *opaque;
+} UnplugFn;
+
+/* Per-thread state */
+typedef struct {
+    unsigned count;       /* how many times has plug() been called? */
+    GArray *unplug_fns;   /* functions to call at unplug time */
+} Plug;
+
+/* Use get_ptr_plug() to fetch this thread-local value */
+QEMU_DEFINE_STATIC_CO_TLS(Plug, plug);
+
+/* Called at thread cleanup time */
+static void blk_io_plug_atexit(Notifier *n, void *value)
+{
+    Plug *plug = get_ptr_plug();
+    g_array_free(plug->unplug_fns, TRUE);
+}
+
+/* This won't involve coroutines, so use __thread */
+static __thread Notifier blk_io_plug_atexit_notifier;
+
+/**
+ * blk_io_plug_call:
+ * @fn: a function pointer to be invoked
+ * @opaque: a user-defined argument to @fn()
+ *
+ * Call @fn(@opaque) immediately if not within a blk_io_plug()/blk_io_unplug()
+ * section.
+ *
+ * Otherwise defer the call until the end of the outermost
+ * blk_io_plug()/blk_io_unplug() section in this thread. If the same
+ * @fn/@opaque pair has already been deferred, it will only be called once upon
+ * blk_io_unplug() so that accumulated calls are batched into a single call.
+ *
+ * The caller must ensure that @opaque is not freed before @fn() is invoked.
+ */
+void blk_io_plug_call(void (*fn)(void *), void *opaque)
+{
+    Plug *plug = get_ptr_plug();
+
+    /* Call immediately if we're not plugged */
+    if (plug->count == 0) {
+        fn(opaque);
+        return;
+    }
+
+    GArray *array = plug->unplug_fns;
+    if (!array) {
+        array = g_array_new(FALSE, FALSE, sizeof(UnplugFn));
+        plug->unplug_fns = array;
+        blk_io_plug_atexit_notifier.notify = blk_io_plug_atexit;
+        qemu_thread_atexit_add(&blk_io_plug_atexit_notifier);
+    }
+
+    UnplugFn *fns = (UnplugFn *)array->data;
+    UnplugFn new_fn = {
+        .fn = fn,
+        .opaque = opaque,
+    };
+
+    /*
+     * There won't be many, so do a linear search. If this becomes a bottleneck
+     * then a binary search (glib 2.62+) or different data structure could be
+     * used.
+     */
+    for (guint i = 0; i < array->len; i++) {
+        if (memcmp(&fns[i], &new_fn, sizeof(new_fn)) == 0) {
+            return; /* already exists */
+        }
+    }
+
+    g_array_append_val(array, new_fn);
+}
+
+/**
+ * blk_io_plug: Defer blk_io_plug_call() functions until blk_io_unplug()
+ *
+ * blk_io_plug/unplug are thread-local operations. This means that multiple
+ * threads can simultaneously call plug/unplug, but the caller must ensure that
+ * each unplug() is called in the same thread of the matching plug().
+ *
+ * Nesting is supported. blk_io_plug_call() functions are only called at the
+ * outermost blk_io_unplug().
+ */
+void blk_io_plug(void)
+{
+    Plug *plug = get_ptr_plug();
+
+    assert(plug->count < UINT32_MAX);
+
+    plug->count++;
+}
+
+/**
+ * blk_io_unplug: Run any pending blk_io_plug_call() functions
+ *
+ * There must have been a matching blk_io_plug() call in the same thread prior
+ * to this blk_io_unplug() call.
+ */
+void blk_io_unplug(void)
+{
+    Plug *plug = get_ptr_plug();
+
+    assert(plug->count > 0);
+
+    if (--plug->count > 0) {
+        return;
+    }
+
+    GArray *array = plug->unplug_fns;
+    if (!array) {
+        return;
+    }
+
+    UnplugFn *fns = (UnplugFn *)array->data;
+
+    for (guint i = 0; i < array->len; i++) {
+        fns[i].fn(fns[i].opaque);
+    }
+
+    /*
+     * This resets the array without freeing memory so that appending is cheap
+     * in the future.
+     */
+    g_array_set_size(array, 0);
+}
diff --git a/hw/block/dataplane/xen-block.c b/hw/block/dataplane/xen-block.c
index 2597f38805..3b6f2b0aa2 100644
--- a/hw/block/dataplane/xen-block.c
+++ b/hw/block/dataplane/xen-block.c
@@ -537,7 +537,7 @@ static bool xen_block_handle_requests(XenBlockDataPlane *dataplane)
      * is below us.
      */
     if (inflight_atstart > IO_PLUG_THRESHOLD) {
-        blk_io_plug(dataplane->blk);
+        blk_io_plug();
     }
     while (rc != rp) {
         /* pull request from ring */
@@ -577,12 +577,12 @@ static bool xen_block_handle_requests(XenBlockDataPlane *dataplane)
 
         if (inflight_atstart > IO_PLUG_THRESHOLD &&
             batched >= inflight_atstart) {
-            blk_io_unplug(dataplane->blk);
+            blk_io_unplug();
         }
         xen_block_do_aio(request);
         if (inflight_atstart > IO_PLUG_THRESHOLD) {
             if (batched >= inflight_atstart) {
-                blk_io_plug(dataplane->blk);
+                blk_io_plug();
                 batched = 0;
             } else {
                 batched++;
@@ -590,7 +590,7 @@ static bool xen_block_handle_requests(XenBlockDataPlane *dataplane)
         }
     }
     if (inflight_atstart > IO_PLUG_THRESHOLD) {
-        blk_io_unplug(dataplane->blk);
+        blk_io_unplug();
     }
 
     return done_something;
diff --git a/hw/block/virtio-blk.c b/hw/block/virtio-blk.c
index 4ca66b5860..39e7f23fab 100644
--- a/hw/block/virtio-blk.c
+++ b/hw/block/virtio-blk.c
@@ -1134,7 +1134,7 @@ void virtio_blk_handle_vq(VirtIOBlock *s, VirtQueue *vq)
     bool suppress_notifications = virtio_queue_get_notification(vq);
 
     aio_context_acquire(blk_get_aio_context(s->blk));
-    blk_io_plug(s->blk);
+    blk_io_plug();
 
     do {
         if (suppress_notifications) {
@@ -1158,7 +1158,7 @@ void virtio_blk_handle_vq(VirtIOBlock *s, VirtQueue *vq)
         virtio_blk_submit_multireq(s, &mrb);
     }
 
-    blk_io_unplug(s->blk);
+    blk_io_unplug();
     aio_context_release(blk_get_aio_context(s->blk));
 }
 
diff --git a/hw/scsi/virtio-scsi.c b/hw/scsi/virtio-scsi.c
index 4a8849cc7e..9c8ef0aaa6 100644
--- a/hw/scsi/virtio-scsi.c
+++ b/hw/scsi/virtio-scsi.c
@@ -799,7 +799,7 @@ static int virtio_scsi_handle_cmd_req_prepare(VirtIOSCSI *s, VirtIOSCSIReq *req)
         return -ENOBUFS;
     }
     scsi_req_ref(req->sreq);
-    blk_io_plug(d->conf.blk);
+    blk_io_plug();
     object_unref(OBJECT(d));
     return 0;
 }
@@ -810,7 +810,7 @@ static void virtio_scsi_handle_cmd_req_submit(VirtIOSCSI *s, VirtIOSCSIReq *req)
     if (scsi_req_enqueue(sreq)) {
         scsi_req_continue(sreq);
     }
-    blk_io_unplug(sreq->dev->conf.blk);
+    blk_io_unplug();
     scsi_req_unref(sreq);
 }
 
@@ -836,7 +836,7 @@ static void virtio_scsi_handle_cmd_vq(VirtIOSCSI *s, VirtQueue *vq)
                 while (!QTAILQ_EMPTY(&reqs)) {
                     req = QTAILQ_FIRST(&reqs);
                     QTAILQ_REMOVE(&reqs, req, next);
-                    blk_io_unplug(req->sreq->dev->conf.blk);
+                    blk_io_unplug();
                     scsi_req_unref(req->sreq);
                     virtqueue_detach_element(req->vq, &req->elem, 0);
                     virtio_scsi_free_req(req);
diff --git a/block/meson.build b/block/meson.build
index 486dda8b85..fb4332bd66 100644
--- a/block/meson.build
+++ b/block/meson.build
@@ -23,6 +23,7 @@ block_ss.add(files(
   'mirror.c',
   'nbd.c',
   'null.c',
+  'plug.c',
   'qapi.c',
   'qcow2-bitmap.c',
   'qcow2-cache.c',
-- 
2.40.1

