Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7176A58503C
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 15:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235143AbiG2NBd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 09:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235862AbiG2NBb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 09:01:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9C2F42AE03
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 06:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659099685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NOtAXHQaPw4y4uaTOzPJv0+QlgM+OgPcQarWqMjto7s=;
        b=C6muXh7GOdAbBR6Isny/hWJopRuxoCJVgTsShionxLsXTo3Wzfp5EE8m6iKlKPLc7GSjed
        k3a1dF7i5dRFsmjzFMZlWaGaHBo63EBatzgxM+pGmF0xzesHbya719qHKYZVq5k0gPSMZz
        iBgdYUIhOm1WiqeoF40hAWJTddVMf1M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-421-3CHgTbu4OpWDK8OEXA3Uqg-1; Fri, 29 Jul 2022 09:01:24 -0400
X-MC-Unique: 3CHgTbu4OpWDK8OEXA3Uqg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A58123804523;
        Fri, 29 Jul 2022 13:01:22 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 598FF2026D64;
        Fri, 29 Jul 2022 13:01:12 +0000 (UTC)
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
Subject: [RFC v2 02/10] Drop unused static function return values
Date:   Fri, 29 Jul 2022 14:00:31 +0100
Message-Id: <20220729130040.1428779-3-afaria@redhat.com>
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

Make non-void static functions whose return values are ignored by
all callers return void instead.

These functions were found by static-analyzer.py.

Not all occurrences of this problem were fixed.

Signed-off-by: Alberto Faria <afaria@redhat.com>
---
 accel/kvm/kvm-all.c                       | 12 ++---
 accel/tcg/plugin-gen.c                    |  9 ++--
 accel/tcg/translate-all.c                 |  9 ++--
 audio/audio.c                             |  5 +-
 block/block-copy.c                        |  4 +-
 block/file-posix.c                        |  6 +--
 block/io.c                                | 30 +++++-------
 block/qcow2-bitmap.c                      |  6 +--
 block/quorum.c                            |  5 +-
 block/vpc.c                               |  4 +-
 block/vvfat.c                             | 11 ++---
 chardev/char-ringbuf.c                    |  4 +-
 contrib/ivshmem-server/main.c             |  4 +-
 contrib/vhost-user-blk/vhost-user-blk.c   |  5 +-
 dump/dump.c                               |  4 +-
 fsdev/virtfs-proxy-helper.c               |  3 +-
 gdbstub.c                                 | 18 +++-----
 hw/audio/intel-hda.c                      |  7 ++-
 hw/audio/pcspk.c                          |  7 +--
 hw/char/virtio-serial-bus.c               | 14 +++---
 hw/display/cirrus_vga.c                   |  5 +-
 hw/hyperv/vmbus.c                         | 10 ++--
 hw/i386/intel_iommu.c                     | 28 ++++++------
 hw/i386/pc_q35.c                          |  5 +-
 hw/ide/pci.c                              |  4 +-
 hw/net/rtl8139.c                          |  3 +-
 hw/net/virtio-net.c                       |  6 +--
 hw/net/vmxnet3.c                          |  3 +-
 hw/nvme/ctrl.c                            | 17 ++-----
 hw/nvram/fw_cfg.c                         |  3 +-
 hw/scsi/megasas.c                         |  6 +--
 hw/scsi/mptconfig.c                       |  7 +--
 hw/scsi/mptsas.c                          | 14 ++----
 hw/scsi/scsi-bus.c                        |  6 +--
 hw/usb/dev-audio.c                        | 13 +++---
 hw/usb/hcd-ehci.c                         |  6 +--
 hw/usb/hcd-ohci.c                         |  4 +-
 hw/usb/hcd-xhci.c                         | 56 +++++++++++------------
 hw/vfio/common.c                          | 21 +++++----
 hw/virtio/vhost-vdpa.c                    |  3 +-
 hw/virtio/vhost.c                         | 11 ++---
 hw/virtio/virtio-iommu.c                  |  4 +-
 hw/virtio/virtio-mem.c                    |  9 ++--
 io/channel-command.c                      | 10 ++--
 migration/migration.c                     | 12 ++---
 net/dump.c                                | 16 +++----
 net/vhost-vdpa.c                          |  8 ++--
 qemu-img.c                                |  6 +--
 qga/commands-posix-ssh.c                  | 10 ++--
 softmmu/physmem.c                         | 18 ++++----
 softmmu/qtest.c                           |  5 +-
 subprojects/libvduse/libvduse.c           | 12 ++---
 subprojects/libvhost-user/libvhost-user.c | 24 ++++------
 target/i386/host-cpu.c                    |  3 +-
 target/i386/kvm/kvm.c                     | 19 ++++----
 tcg/optimize.c                            |  3 +-
 tests/qtest/libqos/malloc.c               |  5 +-
 tests/qtest/libqos/qgraph.c               |  3 +-
 tests/qtest/test-x86-cpuid-compat.c       |  8 ++--
 tests/qtest/virtio-9p-test.c              |  6 +--
 tests/unit/test-aio-multithread.c         |  5 +-
 tests/vhost-user-bridge.c                 | 19 +++-----
 ui/vnc.c                                  | 23 ++++------
 util/aio-posix.c                          |  7 +--
 util/uri.c                                | 18 +++-----
 65 files changed, 248 insertions(+), 403 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f165074e99..748e9d6a2a 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -759,7 +759,7 @@ static uint32_t kvm_dirty_ring_reap_one(KVMState *s, CPUState *cpu)
 }
 
 /* Must be with slots_lock held */
-static uint64_t kvm_dirty_ring_reap_locked(KVMState *s, CPUState* cpu)
+static void kvm_dirty_ring_reap_locked(KVMState *s, CPUState* cpu)
 {
     int ret;
     uint64_t total = 0;
@@ -785,18 +785,14 @@ static uint64_t kvm_dirty_ring_reap_locked(KVMState *s, CPUState* cpu)
     if (total) {
         trace_kvm_dirty_ring_reap(total, stamp / 1000);
     }
-
-    return total;
 }
 
 /*
  * Currently for simplicity, we must hold BQL before calling this.  We can
  * consider to drop the BQL if we're clear with all the race conditions.
  */
-static uint64_t kvm_dirty_ring_reap(KVMState *s, CPUState *cpu)
+static void kvm_dirty_ring_reap(KVMState *s, CPUState *cpu)
 {
-    uint64_t total;
-
     /*
      * We need to lock all kvm slots for all address spaces here,
      * because:
@@ -813,10 +809,8 @@ static uint64_t kvm_dirty_ring_reap(KVMState *s, CPUState *cpu)
      *     reset below.
      */
     kvm_slots_lock();
-    total = kvm_dirty_ring_reap_locked(s, cpu);
+    kvm_dirty_ring_reap_locked(s, cpu);
     kvm_slots_unlock();
-
-    return total;
 }
 
 static void do_kvm_cpu_synchronize_kick(CPUState *cpu, run_on_cpu_data arg)
diff --git a/accel/tcg/plugin-gen.c b/accel/tcg/plugin-gen.c
index 3d0b101e34..ca84f1f1f8 100644
--- a/accel/tcg/plugin-gen.c
+++ b/accel/tcg/plugin-gen.c
@@ -239,21 +239,18 @@ static TCGOp *find_op(TCGOp *op, TCGOpcode opc)
     return NULL;
 }
 
-static TCGOp *rm_ops_range(TCGOp *begin, TCGOp *end)
+static void rm_ops_range(TCGOp *begin, TCGOp *end)
 {
-    TCGOp *ret = QTAILQ_NEXT(end, link);
-
     QTAILQ_REMOVE_SEVERAL(&tcg_ctx->ops, begin, end, link);
-    return ret;
 }
 
 /* remove all ops until (and including) plugin_cb_end */
-static TCGOp *rm_ops(TCGOp *op)
+static void rm_ops(TCGOp *op)
 {
     TCGOp *end_op = find_op(op, INDEX_op_plugin_cb_end);
 
     tcg_debug_assert(end_op);
-    return rm_ops_range(op, end_op);
+    rm_ops_range(op, end_op);
 }
 
 static TCGOp *copy_op_nocheck(TCGOp **begin_op, TCGOp *op)
diff --git a/accel/tcg/translate-all.c b/accel/tcg/translate-all.c
index ef62a199c7..0c93c3143d 100644
--- a/accel/tcg/translate-all.c
+++ b/accel/tcg/translate-all.c
@@ -329,8 +329,8 @@ static int encode_search(TranslationBlock *tb, uint8_t *block)
  * When reset_icount is true, current TB will be interrupted and
  * icount should be recalculated.
  */
-static int cpu_restore_state_from_tb(CPUState *cpu, TranslationBlock *tb,
-                                     uintptr_t searched_pc, bool reset_icount)
+static void cpu_restore_state_from_tb(CPUState *cpu, TranslationBlock *tb,
+                                      uintptr_t searched_pc, bool reset_icount)
 {
     target_ulong data[TARGET_INSN_START_WORDS] = { tb->pc };
     uintptr_t host_pc = (uintptr_t)tb->tc.ptr;
@@ -345,7 +345,7 @@ static int cpu_restore_state_from_tb(CPUState *cpu, TranslationBlock *tb,
     searched_pc -= GETPC_ADJ;
 
     if (searched_pc < host_pc) {
-        return -1;
+        return;
     }
 
     /* Reconstruct the stored insn data while looking for the point at
@@ -359,7 +359,7 @@ static int cpu_restore_state_from_tb(CPUState *cpu, TranslationBlock *tb,
             goto found;
         }
     }
-    return -1;
+    return;
 
  found:
     if (reset_icount && (tb_cflags(tb) & CF_USE_ICOUNT)) {
@@ -375,7 +375,6 @@ static int cpu_restore_state_from_tb(CPUState *cpu, TranslationBlock *tb,
                 prof->restore_time + profile_getclock() - ti);
     qatomic_set(&prof->restore_count, prof->restore_count + 1);
 #endif
-    return 0;
 }
 
 bool cpu_restore_state(CPUState *cpu, uintptr_t host_pc, bool will_exit)
diff --git a/audio/audio.c b/audio/audio.c
index a02f3ce5c6..79022b2325 100644
--- a/audio/audio.c
+++ b/audio/audio.c
@@ -478,7 +478,7 @@ static void audio_detach_capture (HWVoiceOut *hw)
     }
 }
 
-static int audio_attach_capture (HWVoiceOut *hw)
+static void audio_attach_capture(HWVoiceOut *hw)
 {
     AudioState *s = hw->s;
     CaptureVoiceOut *cap;
@@ -504,7 +504,7 @@ static int audio_attach_capture (HWVoiceOut *hw)
         if (!sw->rate) {
             dolog ("Could not start rate conversion for `%s'\n", SW_NAME (sw));
             g_free (sw);
-            return -1;
+            return;
         }
         QLIST_INSERT_HEAD (&hw_cap->sw_head, sw, entries);
         QLIST_INSERT_HEAD (&hw->cap_head, sc, entries);
@@ -518,7 +518,6 @@ static int audio_attach_capture (HWVoiceOut *hw)
             audio_capture_maybe_changed (cap, 1);
         }
     }
-    return 0;
 }
 
 /*
diff --git a/block/block-copy.c b/block/block-copy.c
index bb947afdda..20a1b425d5 100644
--- a/block/block-copy.c
+++ b/block/block-copy.c
@@ -820,7 +820,7 @@ void block_copy_kick(BlockCopyCallState *call_state)
  * it means that some I/O operation failed in context of _this_ block_copy call,
  * not some parallel operation.
  */
-static int coroutine_fn block_copy_common(BlockCopyCallState *call_state)
+static void coroutine_fn block_copy_common(BlockCopyCallState *call_state)
 {
     int ret;
     BlockCopyState *s = call_state->s;
@@ -879,8 +879,6 @@ static int coroutine_fn block_copy_common(BlockCopyCallState *call_state)
     qemu_co_mutex_lock(&s->lock);
     QLIST_REMOVE(call_state, list);
     qemu_co_mutex_unlock(&s->lock);
-
-    return ret;
 }
 
 static void coroutine_fn block_copy_async_co_entry(void *opaque)
diff --git a/block/file-posix.c b/block/file-posix.c
index 48cd096624..a4641da7f9 100644
--- a/block/file-posix.c
+++ b/block/file-posix.c
@@ -1895,7 +1895,7 @@ static int handle_aiocb_discard(void *opaque)
  * Returns: 0 on success, -errno on failure. Since this is an optimization,
  * caller may ignore failures.
  */
-static int allocate_first_block(int fd, size_t max_size)
+static void allocate_first_block(int fd, size_t max_size)
 {
     size_t write_size = (max_size < MAX_BLOCKSIZE)
         ? BDRV_SECTOR_SIZE
@@ -1903,7 +1903,6 @@ static int allocate_first_block(int fd, size_t max_size)
     size_t max_align = MAX(MAX_BLOCKSIZE, qemu_real_host_page_size());
     void *buf;
     ssize_t n;
-    int ret;
 
     buf = qemu_memalign(max_align, write_size);
     memset(buf, 0, write_size);
@@ -1912,10 +1911,7 @@ static int allocate_first_block(int fd, size_t max_size)
         n = pwrite(fd, buf, write_size, 0);
     } while (n == -1 && errno == EINTR);
 
-    ret = (n == -1) ? -errno : 0;
-
     qemu_vfree(buf);
-    return ret;
 }
 
 static int handle_aiocb_truncate(void *opaque)
diff --git a/block/io.c b/block/io.c
index 0a8cbefe86..853ed44289 100644
--- a/block/io.c
+++ b/block/io.c
@@ -934,20 +934,16 @@ void bdrv_dec_in_flight(BlockDriverState *bs)
     bdrv_wakeup(bs);
 }
 
-static bool coroutine_fn bdrv_wait_serialising_requests(BdrvTrackedRequest *self)
+static void coroutine_fn
+bdrv_wait_serialising_requests(BdrvTrackedRequest *self)
 {
     BlockDriverState *bs = self->bs;
-    bool waited = false;
 
-    if (!qatomic_read(&bs->serialising_in_flight)) {
-        return false;
+    if (qatomic_read(&bs->serialising_in_flight)) {
+        qemu_co_mutex_lock(&bs->reqs_lock);
+        bdrv_wait_serialising_requests_locked(self);
+        qemu_co_mutex_unlock(&bs->reqs_lock);
     }
-
-    qemu_co_mutex_lock(&bs->reqs_lock);
-    waited = bdrv_wait_serialising_requests_locked(self);
-    qemu_co_mutex_unlock(&bs->reqs_lock);
-
-    return waited;
 }
 
 bool coroutine_fn bdrv_make_request_serialising(BdrvTrackedRequest *req,
@@ -1644,10 +1640,10 @@ static bool bdrv_init_padding(BlockDriverState *bs,
     return true;
 }
 
-static int bdrv_padding_rmw_read(BdrvChild *child,
-                                 BdrvTrackedRequest *req,
-                                 BdrvRequestPadding *pad,
-                                 bool zero_middle)
+static void bdrv_padding_rmw_read(BdrvChild *child,
+                                  BdrvTrackedRequest *req,
+                                  BdrvRequestPadding *pad,
+                                  bool zero_middle)
 {
     QEMUIOVector local_qiov;
     BlockDriverState *bs = child->bs;
@@ -1670,7 +1666,7 @@ static int bdrv_padding_rmw_read(BdrvChild *child,
         ret = bdrv_aligned_preadv(child, req, req->overlap_offset, bytes,
                                   align, &local_qiov, 0, 0);
         if (ret < 0) {
-            return ret;
+            return;
         }
         if (pad->head) {
             bdrv_debug_event(bs, BLKDBG_PWRITEV_RMW_AFTER_HEAD);
@@ -1693,7 +1689,7 @@ static int bdrv_padding_rmw_read(BdrvChild *child,
                 req->overlap_offset + req->overlap_bytes - align,
                 align, align, &local_qiov, 0, 0);
         if (ret < 0) {
-            return ret;
+            return;
         }
         bdrv_debug_event(bs, BLKDBG_PWRITEV_RMW_AFTER_TAIL);
     }
@@ -1702,8 +1698,6 @@ zero_mem:
     if (zero_middle) {
         memset(pad->buf + pad->head, 0, pad->buf_len - pad->head - pad->tail);
     }
-
-    return 0;
 }
 
 static void bdrv_padding_destroy(BdrvRequestPadding *pad)
diff --git a/block/qcow2-bitmap.c b/block/qcow2-bitmap.c
index e98bafe0f4..14e55cefac 100644
--- a/block/qcow2-bitmap.c
+++ b/block/qcow2-bitmap.c
@@ -257,14 +257,14 @@ fail:
     return ret;
 }
 
-static int free_bitmap_clusters(BlockDriverState *bs, Qcow2BitmapTable *tb)
+static void free_bitmap_clusters(BlockDriverState *bs, Qcow2BitmapTable *tb)
 {
     int ret;
     uint64_t *bitmap_table;
 
     ret = bitmap_table_load(bs, tb, &bitmap_table);
     if (ret < 0) {
-        return ret;
+        return;
     }
 
     clear_bitmap_table(bs, bitmap_table, tb->size);
@@ -274,8 +274,6 @@ static int free_bitmap_clusters(BlockDriverState *bs, Qcow2BitmapTable *tb)
 
     tb->offset = 0;
     tb->size = 0;
-
-    return 0;
 }
 
 /* load_bitmap_data
diff --git a/block/quorum.c b/block/quorum.c
index f33f30d36b..9c0fbd79be 100644
--- a/block/quorum.c
+++ b/block/quorum.c
@@ -293,7 +293,7 @@ static void quorum_rewrite_entry(void *opaque)
     }
 }
 
-static bool quorum_rewrite_bad_versions(QuorumAIOCB *acb,
+static void quorum_rewrite_bad_versions(QuorumAIOCB *acb,
                                         QuorumVoteValue *value)
 {
     QuorumVoteVersion *version;
@@ -331,9 +331,6 @@ static bool quorum_rewrite_bad_versions(QuorumAIOCB *acb,
             qemu_coroutine_enter(co);
         }
     }
-
-    /* return true if any rewrite is done else false */
-    return count;
 }
 
 static void quorum_count_vote(QuorumVotes *votes,
diff --git a/block/vpc.c b/block/vpc.c
index 4f49ef207f..03d65505d1 100644
--- a/block/vpc.c
+++ b/block/vpc.c
@@ -782,7 +782,7 @@ static int coroutine_fn vpc_co_block_status(BlockDriverState *bs,
  * the hardware EIDE and ATA-2 limit of 16 heads (max disk size of 127 GB)
  * and instead allow up to 255 heads.
  */
-static int calculate_geometry(int64_t total_sectors, uint16_t *cyls,
+static void calculate_geometry(int64_t total_sectors, uint16_t *cyls,
     uint8_t *heads, uint8_t *secs_per_cyl)
 {
     uint32_t cyls_times_heads;
@@ -816,8 +816,6 @@ static int calculate_geometry(int64_t total_sectors, uint16_t *cyls,
     }
 
     *cyls = cyls_times_heads / *heads;
-
-    return 0;
 }
 
 static int create_dynamic_disk(BlockBackend *blk, VHDFooter *footer,
diff --git a/block/vvfat.c b/block/vvfat.c
index d6dd919683..6c4c66eff7 100644
--- a/block/vvfat.c
+++ b/block/vvfat.c
@@ -154,9 +154,9 @@ static inline int array_remove_slice(array_t* array,int index, int count)
     return 0;
 }
 
-static int array_remove(array_t* array,int index)
+static void array_remove(array_t* array,int index)
 {
-    return array_remove_slice(array, index, 1);
+    array_remove_slice(array, index, 1);
 }
 
 /* return the index for a given member */
@@ -2968,13 +2968,12 @@ DLOG(checkpoint());
     return 0;
 }
 
-static int try_commit(BDRVVVFATState* s)
+static void try_commit(BDRVVVFATState* s)
 {
     vvfat_close_current_file(s);
 DLOG(checkpoint());
-    if(!is_consistent(s))
-        return -1;
-    return do_commit(s);
+    if (is_consistent(s))
+        do_commit(s);
 }
 
 static int vvfat_write(BlockDriverState *bs, int64_t sector_num,
diff --git a/chardev/char-ringbuf.c b/chardev/char-ringbuf.c
index d40d21d3cf..335d75e824 100644
--- a/chardev/char-ringbuf.c
+++ b/chardev/char-ringbuf.c
@@ -71,7 +71,7 @@ static int ringbuf_chr_write(Chardev *chr, const uint8_t *buf, int len)
     return len;
 }
 
-static int ringbuf_chr_read(Chardev *chr, uint8_t *buf, int len)
+static void ringbuf_chr_read(Chardev *chr, uint8_t *buf, int len)
 {
     RingBufChardev *d = RINGBUF_CHARDEV(chr);
     int i;
@@ -81,8 +81,6 @@ static int ringbuf_chr_read(Chardev *chr, uint8_t *buf, int len)
         buf[i] = d->cbuf[d->cons++ & (d->size - 1)];
     }
     qemu_mutex_unlock(&chr->chr_write_lock);
-
-    return i;
 }
 
 static void char_ringbuf_finalize(Object *obj)
diff --git a/contrib/ivshmem-server/main.c b/contrib/ivshmem-server/main.c
index 224dbeb547..67a0d7a497 100644
--- a/contrib/ivshmem-server/main.c
+++ b/contrib/ivshmem-server/main.c
@@ -143,7 +143,7 @@ ivshmem_server_parse_args(IvshmemServerArgs *args, int argc, char *argv[])
 
 /* wait for events on listening server unix socket and connected client
  * sockets */
-static int
+static void
 ivshmem_server_poll_events(IvshmemServer *server)
 {
     fd_set fds;
@@ -174,8 +174,6 @@ ivshmem_server_poll_events(IvshmemServer *server)
             break;
         }
     }
-
-    return ret;
 }
 
 static void
diff --git a/contrib/vhost-user-blk/vhost-user-blk.c b/contrib/vhost-user-blk/vhost-user-blk.c
index 9cb78ca1d0..e4df9a074c 100644
--- a/contrib/vhost-user-blk/vhost-user-blk.c
+++ b/contrib/vhost-user-blk/vhost-user-blk.c
@@ -66,8 +66,8 @@ static size_t vub_iov_size(const struct iovec *iov,
     return len;
 }
 
-static size_t vub_iov_to_buf(const struct iovec *iov,
-                             const unsigned int iov_cnt, void *buf)
+static void vub_iov_to_buf(const struct iovec *iov,
+                           const unsigned int iov_cnt, void *buf)
 {
     size_t len;
     unsigned int i;
@@ -77,7 +77,6 @@ static size_t vub_iov_to_buf(const struct iovec *iov,
         memcpy(buf + len,  iov[i].iov_base, iov[i].iov_len);
         len += iov[i].iov_len;
     }
-    return len;
 }
 
 static void vub_panic_cb(VuDev *vu_dev, const char *buf)
diff --git a/dump/dump.c b/dump/dump.c
index 4d9658ffa2..5080ecf574 100644
--- a/dump/dump.c
+++ b/dump/dump.c
@@ -92,7 +92,7 @@ uint64_t cpu_to_dump64(DumpState *s, uint64_t val)
     return val;
 }
 
-static int dump_cleanup(DumpState *s)
+static void dump_cleanup(DumpState *s)
 {
     guest_phys_blocks_free(&s->guest_phys_blocks);
     memory_mapping_list_free(&s->list);
@@ -109,8 +109,6 @@ static int dump_cleanup(DumpState *s)
         }
     }
     migrate_del_blocker(dump_migration_blocker);
-
-    return 0;
 }
 
 static int fd_write_vmcore(const void *buf, size_t size, void *opaque)
diff --git a/fsdev/virtfs-proxy-helper.c b/fsdev/virtfs-proxy-helper.c
index 2dde27922f..b91f730120 100644
--- a/fsdev/virtfs-proxy-helper.c
+++ b/fsdev/virtfs-proxy-helper.c
@@ -829,7 +829,7 @@ static int process_reply(int sock, int type,
     return 0;
 }
 
-static int process_requests(int sock)
+static void process_requests(int sock)
 {
     int flags;
     int size = 0;
@@ -1016,7 +1016,6 @@ static int process_requests(int sock)
 err_out:
     g_free(in_iovec.iov_base);
     g_free(out_iovec.iov_base);
-    return -1;
 }
 
 int main(int argc, char **argv)
diff --git a/gdbstub.c b/gdbstub.c
index cf869b10e3..f73461848c 100644
--- a/gdbstub.c
+++ b/gdbstub.c
@@ -506,10 +506,9 @@ static inline void gdb_continue(void)
  * Resume execution, per CPU actions. For user-mode emulation it's
  * equivalent to gdb_continue.
  */
-static int gdb_continue_partial(char *newstates)
+static void gdb_continue_partial(char *newstates)
 {
     CPUState *cpu;
-    int res = 0;
 #ifdef CONFIG_USER_ONLY
     /*
      * This is not exactly accurate, but it's an improvement compared to the
@@ -535,7 +534,7 @@ static int gdb_continue_partial(char *newstates)
         }
 
         if (vm_prepare_start(step_requested)) {
-            return 0;
+            return;
         }
 
         CPU_FOREACH(cpu) {
@@ -555,7 +554,6 @@ static int gdb_continue_partial(char *newstates)
                 flag = 1;
                 break;
             default:
-                res = -1;
                 break;
             }
         }
@@ -564,7 +562,6 @@ static int gdb_continue_partial(char *newstates)
         qemu_clock_enable(QEMU_CLOCK_VIRTUAL, true);
     }
 #endif
-    return res;
 }
 
 static void put_buffer(const uint8_t *buf, int len)
@@ -665,8 +662,7 @@ static void hexdump(const char *buf, int len,
     }
 }
 
-/* return -1 if error, 0 if OK */
-static int put_packet_binary(const char *buf, int len, bool dump)
+static void put_packet_binary(const char *buf, int len, bool dump)
 {
     int csum, i;
     uint8_t footer[3];
@@ -696,22 +692,20 @@ static int put_packet_binary(const char *buf, int len, bool dump)
 #ifdef CONFIG_USER_ONLY
         i = get_char();
         if (i < 0)
-            return -1;
+            return;
         if (i == '+')
             break;
 #else
         break;
 #endif
     }
-    return 0;
 }
 
-/* return -1 if error, 0 if OK */
-static int put_packet(const char *buf)
+static void put_packet(const char *buf)
 {
     trace_gdbstub_io_reply(buf);
 
-    return put_packet_binary(buf, strlen(buf), false);
+    put_packet_binary(buf, strlen(buf), false);
 }
 
 static void put_strbuf(void)
diff --git a/hw/audio/intel-hda.c b/hw/audio/intel-hda.c
index f38117057b..19284c5c9d 100644
--- a/hw/audio/intel-hda.c
+++ b/hw/audio/intel-hda.c
@@ -283,7 +283,7 @@ static void intel_hda_update_irq(IntelHDAState *d)
     }
 }
 
-static int intel_hda_send_command(IntelHDAState *d, uint32_t verb)
+static void intel_hda_send_command(IntelHDAState *d, uint32_t verb)
 {
     uint32_t cad, nid, data;
     HDACodecDevice *codec;
@@ -293,7 +293,7 @@ static int intel_hda_send_command(IntelHDAState *d, uint32_t verb)
     if (verb & (1 << 27)) {
         /* indirect node addressing, not specified in HDA 1.0 */
         dprint(d, 1, "%s: indirect node addressing (guest bug?)\n", __func__);
-        return -1;
+        return;
     }
     nid = (verb >> 20) & 0x7f;
     data = verb & 0xfffff;
@@ -301,11 +301,10 @@ static int intel_hda_send_command(IntelHDAState *d, uint32_t verb)
     codec = hda_codec_find(&d->codecs, cad);
     if (codec == NULL) {
         dprint(d, 1, "%s: addressed non-existing codec\n", __func__);
-        return -1;
+        return;
     }
     cdc = HDA_CODEC_DEVICE_GET_CLASS(codec);
     cdc->command(codec, nid, data);
-    return 0;
 }
 
 static void intel_hda_corb_run(IntelHDAState *d)
diff --git a/hw/audio/pcspk.c b/hw/audio/pcspk.c
index daf92a4ce1..027c04a88e 100644
--- a/hw/audio/pcspk.c
+++ b/hw/audio/pcspk.c
@@ -114,13 +114,13 @@ static void pcspk_callback(void *opaque, int free)
     }
 }
 
-static int pcspk_audio_init(PCSpkState *s)
+static void pcspk_audio_init(PCSpkState *s)
 {
     struct audsettings as = {PCSPK_SAMPLE_RATE, 1, AUDIO_FORMAT_U8, 0};
 
     if (s->voice) {
         /* already initialized */
-        return 0;
+        return;
     }
 
     AUD_register_card(s_spk, &s->card);
@@ -128,10 +128,7 @@ static int pcspk_audio_init(PCSpkState *s)
     s->voice = AUD_open_out(&s->card, s->voice, s_spk, s, pcspk_callback, &as);
     if (!s->voice) {
         AUD_log(s_spk, "Could not open voice\n");
-        return -1;
     }
-
-    return 0;
 }
 
 static uint64_t pcspk_io_read(void *opaque, hwaddr addr,
diff --git a/hw/char/virtio-serial-bus.c b/hw/char/virtio-serial-bus.c
index 7d4601cb5d..5196b8d5ea 100644
--- a/hw/char/virtio-serial-bus.c
+++ b/hw/char/virtio-serial-bus.c
@@ -221,19 +221,19 @@ static void flush_queued_data(VirtIOSerialPort *port)
     do_flush_queued_data(port, port->ovq, VIRTIO_DEVICE(port->vser));
 }
 
-static size_t send_control_msg(VirtIOSerial *vser, void *buf, size_t len)
+static void send_control_msg(VirtIOSerial *vser, void *buf, size_t len)
 {
     VirtQueueElement *elem;
     VirtQueue *vq;
 
     vq = vser->c_ivq;
     if (!virtio_queue_ready(vq)) {
-        return 0;
+        return;
     }
 
     elem = virtqueue_pop(vq, sizeof(VirtQueueElement));
     if (!elem) {
-        return 0;
+        return;
     }
 
     /* TODO: detect a buffer that's too short, set NEEDS_RESET */
@@ -242,12 +242,10 @@ static size_t send_control_msg(VirtIOSerial *vser, void *buf, size_t len)
     virtqueue_push(vq, elem, len);
     virtio_notify(VIRTIO_DEVICE(vser), vq);
     g_free(elem);
-
-    return len;
 }
 
-static size_t send_control_event(VirtIOSerial *vser, uint32_t port_id,
-                                 uint16_t event, uint16_t value)
+static void send_control_event(VirtIOSerial *vser, uint32_t port_id,
+                               uint16_t event, uint16_t value)
 {
     VirtIODevice *vdev = VIRTIO_DEVICE(vser);
     struct virtio_console_control cpkt;
@@ -257,7 +255,7 @@ static size_t send_control_event(VirtIOSerial *vser, uint32_t port_id,
     virtio_stw_p(vdev, &cpkt.value, value);
 
     trace_virtio_serial_send_control_event(port_id, event, value);
-    return send_control_msg(vser, &cpkt, sizeof(cpkt));
+    send_control_msg(vser, &cpkt, sizeof(cpkt));
 }
 
 /* Functions for use inside qemu to open and read from/write to ports */
diff --git a/hw/display/cirrus_vga.c b/hw/display/cirrus_vga.c
index 3bb6a58698..f8e7e2d077 100644
--- a/hw/display/cirrus_vga.c
+++ b/hw/display/cirrus_vga.c
@@ -696,12 +696,12 @@ static int cirrus_bitblt_common_patterncopy(CirrusVGAState *s)
 
 /* fill */
 
-static int cirrus_bitblt_solidfill(CirrusVGAState *s, int blt_rop)
+static void cirrus_bitblt_solidfill(CirrusVGAState *s, int blt_rop)
 {
     cirrus_fill_t rop_func;
 
     if (blit_is_unsafe(s, true)) {
-        return 0;
+        return;
     }
     rop_func = cirrus_fill[rop_to_index[blt_rop]][s->cirrus_blt_pixelwidth - 1];
     rop_func(s, s->cirrus_blt_dstaddr,
@@ -711,7 +711,6 @@ static int cirrus_bitblt_solidfill(CirrusVGAState *s, int blt_rop)
 			     s->cirrus_blt_dstpitch, s->cirrus_blt_width,
 			     s->cirrus_blt_height);
     cirrus_bitblt_reset(s);
-    return 1;
 }
 
 /***************************************
diff --git a/hw/hyperv/vmbus.c b/hw/hyperv/vmbus.c
index 30bc04e1c4..c18e4942e3 100644
--- a/hw/hyperv/vmbus.c
+++ b/hw/hyperv/vmbus.c
@@ -728,9 +728,8 @@ bool vmbus_channel_is_open(VMBusChannel *chan)
  * flag (more recent guests) or setting a bit in the interrupt page and firing
  * the VMBus SINT (older guests).
  */
-static int vmbus_channel_notify_guest(VMBusChannel *chan)
+static void vmbus_channel_notify_guest(VMBusChannel *chan)
 {
-    int res = 0;
     unsigned long *int_map, mask;
     unsigned idx;
     hwaddr addr = chan->vmbus->int_page_gpa;
@@ -739,25 +738,24 @@ static int vmbus_channel_notify_guest(VMBusChannel *chan)
     trace_vmbus_channel_notify_guest(chan->id);
 
     if (!addr) {
-        return hyperv_set_event_flag(chan->notify_route, chan->id);
+        hyperv_set_event_flag(chan->notify_route, chan->id);
+        return;
     }
 
     int_map = cpu_physical_memory_map(addr, &len, 1);
     if (len != TARGET_PAGE_SIZE / 2) {
-        res = -ENXIO;
         goto unmap;
     }
 
     idx = BIT_WORD(chan->id);
     mask = BIT_MASK(chan->id);
     if ((qatomic_fetch_or(&int_map[idx], mask) & mask) != mask) {
-        res = hyperv_sint_route_set_sint(chan->notify_route);
+        hyperv_sint_route_set_sint(chan->notify_route);
         dirty = len;
     }
 
 unmap:
     cpu_physical_memory_unmap(int_map, len, 1, dirty);
-    return res;
 }
 
 #define VMBUS_PKT_TRAILER      sizeof(uint64_t)
diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 2162394e08..970ba19593 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -146,12 +146,11 @@ static void vtd_set_quad_raw(IntelIOMMUState *s, hwaddr addr, uint64_t val)
     stq_le_p(&s->csr[addr], val);
 }
 
-static uint32_t vtd_set_clear_mask_long(IntelIOMMUState *s, hwaddr addr,
-                                        uint32_t clear, uint32_t mask)
+static void vtd_set_clear_mask_long(IntelIOMMUState *s, hwaddr addr,
+                                    uint32_t clear, uint32_t mask)
 {
     uint32_t new_val = (ldl_le_p(&s->csr[addr]) & ~clear) | mask;
     stl_le_p(&s->csr[addr], new_val);
-    return new_val;
 }
 
 static uint64_t vtd_set_clear_mask_quad(IntelIOMMUState *s, hwaddr addr,
@@ -1312,15 +1311,15 @@ next:
  * @end: IOVA range end address (start <= addr < end)
  * @info: page walking information struct
  */
-static int vtd_page_walk(IntelIOMMUState *s, VTDContextEntry *ce,
-                         uint64_t start, uint64_t end,
-                         vtd_page_walk_info *info)
+static void vtd_page_walk(IntelIOMMUState *s, VTDContextEntry *ce,
+                          uint64_t start, uint64_t end,
+                          vtd_page_walk_info *info)
 {
     dma_addr_t addr = vtd_get_iova_pgtbl_base(s, ce);
     uint32_t level = vtd_get_iova_level(s, ce);
 
     if (!vtd_iova_range_check(s, start, ce, info->aw)) {
-        return -VTD_FR_ADDR_BEYOND_MGAW;
+        return;
     }
 
     if (!vtd_iova_range_check(s, end, ce, info->aw)) {
@@ -1328,7 +1327,7 @@ static int vtd_page_walk(IntelIOMMUState *s, VTDContextEntry *ce,
         end = vtd_iova_limit(s, ce, info->aw);
     }
 
-    return vtd_page_walk_level(addr, start, end, level, true, true, info);
+    vtd_page_walk_level(addr, start, end, level, true, true, info);
 }
 
 static int vtd_root_entry_rsvd_bits_check(IntelIOMMUState *s,
@@ -1488,7 +1487,7 @@ static uint16_t vtd_get_domain_id(IntelIOMMUState *s,
     return VTD_CONTEXT_ENTRY_DID(ce->hi);
 }
 
-static int vtd_sync_shadow_page_table_range(VTDAddressSpace *vtd_as,
+static void vtd_sync_shadow_page_table_range(VTDAddressSpace *vtd_as,
                                             VTDContextEntry *ce,
                                             hwaddr addr, hwaddr size)
 {
@@ -1502,17 +1501,17 @@ static int vtd_sync_shadow_page_table_range(VTDAddressSpace *vtd_as,
         .domain_id = vtd_get_domain_id(s, ce),
     };
 
-    return vtd_page_walk(s, ce, addr, addr + size, &info);
+    vtd_page_walk(s, ce, addr, addr + size, &info);
 }
 
-static int vtd_sync_shadow_page_table(VTDAddressSpace *vtd_as)
+static void vtd_sync_shadow_page_table(VTDAddressSpace *vtd_as)
 {
     int ret;
     VTDContextEntry ce;
     IOMMUNotifier *n;
 
     if (!(vtd_as->iommu.iommu_notify_flags & IOMMU_NOTIFIER_IOTLB_EVENTS)) {
-        return 0;
+        return;
     }
 
     ret = vtd_dev_to_context_entry(vtd_as->iommu_state,
@@ -1532,12 +1531,11 @@ static int vtd_sync_shadow_page_table(VTDAddressSpace *vtd_as)
             IOMMU_NOTIFIER_FOREACH(n, &vtd_as->iommu) {
                 vtd_address_space_unmap(vtd_as, n);
             }
-            ret = 0;
         }
-        return ret;
+        return;
     }
 
-    return vtd_sync_shadow_page_table_range(vtd_as, &ce, 0, UINT64_MAX);
+    vtd_sync_shadow_page_table_range(vtd_as, &ce, 0, UINT64_MAX);
 }
 
 /*
diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
index 3a35193ff7..aa7f9d778a 100644
--- a/hw/i386/pc_q35.c
+++ b/hw/i386/pc_q35.c
@@ -76,7 +76,7 @@ static const struct ehci_companions ich9_1a[] = {
     { .name = "ich9-usb-uhci6", .func = 2, .port = 4 },
 };
 
-static int ehci_create_ich9_with_companions(PCIBus *bus, int slot)
+static void ehci_create_ich9_with_companions(PCIBus *bus, int slot)
 {
     const struct ehci_companions *comp;
     PCIDevice *ehci, *uhci;
@@ -94,7 +94,7 @@ static int ehci_create_ich9_with_companions(PCIBus *bus, int slot)
         comp = ich9_1a;
         break;
     default:
-        return -1;
+        return;
     }
 
     ehci = pci_new_multifunction(PCI_DEVFN(slot, 7), true, name);
@@ -108,7 +108,6 @@ static int ehci_create_ich9_with_companions(PCIBus *bus, int slot)
         qdev_prop_set_uint32(&uhci->qdev, "firstport", comp[i].port);
         pci_realize_and_unref(uhci, bus, &error_fatal);
     }
-    return 0;
 }
 
 /* PC hardware initialisation */
diff --git a/hw/ide/pci.c b/hw/ide/pci.c
index 84ba733548..7d45923113 100644
--- a/hw/ide/pci.c
+++ b/hw/ide/pci.c
@@ -381,7 +381,7 @@ static int ide_bmdma_pre_save(void *opaque)
 /* This function accesses bm->bus->error_status which is loaded only after
  * BMDMA itself. This is why the function is called from ide_pci_post_load
  * instead of being registered with VMState where it would run too early. */
-static int ide_bmdma_post_load(void *opaque, int version_id)
+static void ide_bmdma_post_load(void *opaque, int version_id)
 {
     BMDMAState *bm = opaque;
     uint8_t abused_bits = BM_MIGRATION_COMPAT_STATUS_BITS;
@@ -395,8 +395,6 @@ static int ide_bmdma_post_load(void *opaque, int version_id)
         bm->bus->retry_nsector = bm->migration_retry_nsector;
         bm->bus->retry_unit = bm->migration_retry_unit;
     }
-
-    return 0;
 }
 
 static const VMStateDescription vmstate_bmdma_current = {
diff --git a/hw/net/rtl8139.c b/hw/net/rtl8139.c
index 6b65823b4b..e5511ec5ce 100644
--- a/hw/net/rtl8139.c
+++ b/hw/net/rtl8139.c
@@ -86,9 +86,8 @@
 #  define DPRINTF(fmt, ...) \
     do { fprintf(stderr, "RTL8139: " fmt, ## __VA_ARGS__); } while (0)
 #else
-static inline G_GNUC_PRINTF(1, 2) int DPRINTF(const char *fmt, ...)
+static inline G_GNUC_PRINTF(1, 2) void DPRINTF(const char *fmt, ...)
 {
-    return 0;
 }
 #endif
 
diff --git a/hw/net/virtio-net.c b/hw/net/virtio-net.c
index dd0d056fde..392ac7eb3a 100644
--- a/hw/net/virtio-net.c
+++ b/hw/net/virtio-net.c
@@ -1218,14 +1218,14 @@ static void virtio_net_detach_epbf_rss(VirtIONet *n)
     virtio_net_attach_ebpf_to_backend(n->nic, -1);
 }
 
-static bool virtio_net_load_ebpf(VirtIONet *n)
+static void virtio_net_load_ebpf(VirtIONet *n)
 {
     if (!virtio_net_attach_ebpf_to_backend(n->nic, -1)) {
         /* backend does't support steering ebpf */
-        return false;
+        return;
     }
 
-    return ebpf_rss_load(&n->ebpf_rss);
+    ebpf_rss_load(&n->ebpf_rss);
 }
 
 static void virtio_net_unload_ebpf(VirtIONet *n)
diff --git a/hw/net/vmxnet3.c b/hw/net/vmxnet3.c
index 0b7acf7f89..078cf77ae3 100644
--- a/hw/net/vmxnet3.c
+++ b/hw/net/vmxnet3.c
@@ -609,7 +609,7 @@ vmxnet3_pop_next_tx_descr(VMXNET3State *s,
     return false;
 }
 
-static bool
+static void
 vmxnet3_send_packet(VMXNET3State *s, uint32_t qidx)
 {
     Vmxnet3PktStatus status = VMXNET3_PKT_STATUS_OK;
@@ -630,7 +630,6 @@ vmxnet3_send_packet(VMXNET3State *s, uint32_t qidx)
 
 func_exit:
     vmxnet3_on_tx_done_update_stats(s, qidx, status);
-    return (status == VMXNET3_PKT_STATUS_OK);
 }
 
 static void vmxnet3_process_tx_queue(VMXNET3State *s, int qidx)
diff --git a/hw/nvme/ctrl.c b/hw/nvme/ctrl.c
index 533ad14e7a..686c580026 100644
--- a/hw/nvme/ctrl.c
+++ b/hw/nvme/ctrl.c
@@ -1815,7 +1815,7 @@ static uint16_t nvme_zrm_close(NvmeNamespace *ns, NvmeZone *zone)
     }
 }
 
-static uint16_t nvme_zrm_reset(NvmeNamespace *ns, NvmeZone *zone)
+static void nvme_zrm_reset(NvmeNamespace *ns, NvmeZone *zone)
 {
     switch (nvme_get_zone_state(zone)) {
     case NVME_ZONE_STATE_EXPLICITLY_OPEN:
@@ -1837,11 +1837,8 @@ static uint16_t nvme_zrm_reset(NvmeNamespace *ns, NvmeZone *zone)
         zone->d.wp = zone->w_ptr;
         nvme_assign_zone_state(ns, zone, NVME_ZONE_STATE_EMPTY);
         /* fallthrough */
-    case NVME_ZONE_STATE_EMPTY:
-        return NVME_SUCCESS;
-
     default:
-        return NVME_ZONE_INVAL_TRANSITION;
+        break;
     }
 }
 
@@ -7319,16 +7316,14 @@ static void nvme_init_sriov(NvmeCtrl *n, PCIDevice *pci_dev, uint16_t offset)
                               PCI_BASE_ADDRESS_MEM_TYPE_64, bar_size);
 }
 
-static int nvme_add_pm_capability(PCIDevice *pci_dev, uint8_t offset)
+static void nvme_add_pm_capability(PCIDevice *pci_dev, uint8_t offset)
 {
     Error *err = NULL;
-    int ret;
 
-    ret = pci_add_capability(pci_dev, PCI_CAP_ID_PM, offset,
-                             PCI_PM_SIZEOF, &err);
+    pci_add_capability(pci_dev, PCI_CAP_ID_PM, offset, PCI_PM_SIZEOF, &err);
     if (err) {
         error_report_err(err);
-        return ret;
+        return;
     }
 
     pci_set_word(pci_dev->config + offset + PCI_PM_PMC,
@@ -7337,8 +7332,6 @@ static int nvme_add_pm_capability(PCIDevice *pci_dev, uint8_t offset)
                  PCI_PM_CTRL_NO_SOFT_RESET);
     pci_set_word(pci_dev->wmask + offset + PCI_PM_CTRL,
                  PCI_PM_CTRL_STATE_MASK);
-
-    return 0;
 }
 
 static int nvme_init_pci(NvmeCtrl *n, PCIDevice *pci_dev, Error **errp)
diff --git a/hw/nvram/fw_cfg.c b/hw/nvram/fw_cfg.c
index d605f3f45a..fb8e06538b 100644
--- a/hw/nvram/fw_cfg.c
+++ b/hw/nvram/fw_cfg.c
@@ -265,7 +265,7 @@ static inline uint32_t fw_cfg_max_entry(const FWCfgState *s)
     return FW_CFG_FILE_FIRST + fw_cfg_file_slots(s);
 }
 
-static int fw_cfg_select(FWCfgState *s, uint16_t key)
+static void fw_cfg_select(FWCfgState *s, uint16_t key)
 {
     int arch, ret;
     FWCfgEntry *e;
@@ -286,7 +286,6 @@ static int fw_cfg_select(FWCfgState *s, uint16_t key)
     }
 
     trace_fw_cfg_select(s, key, trace_key_name(key), ret);
-    return ret;
 }
 
 static uint64_t fw_cfg_data_read(void *opaque, hwaddr addr, unsigned size)
diff --git a/hw/scsi/megasas.c b/hw/scsi/megasas.c
index d5dfb412ba..32a0b489b9 100644
--- a/hw/scsi/megasas.c
+++ b/hw/scsi/megasas.c
@@ -325,7 +325,7 @@ unmap:
 /*
  * passthrough sense and io sense are at the same offset
  */
-static int megasas_build_sense(MegasasCmd *cmd, uint8_t *sense_ptr,
+static void megasas_build_sense(MegasasCmd *cmd, uint8_t *sense_ptr,
     uint8_t sense_len)
 {
     PCIDevice *pcid = PCI_DEVICE(cmd->state);
@@ -346,7 +346,6 @@ static int megasas_build_sense(MegasasCmd *cmd, uint8_t *sense_ptr,
         pci_dma_write(pcid, pa, sense_ptr, sense_len);
         cmd->frame->header.sense_len = sense_len;
     }
-    return sense_len;
 }
 
 static void megasas_write_sense(MegasasCmd *cmd, SCSISense sense)
@@ -376,7 +375,7 @@ static void megasas_copy_sense(MegasasCmd *cmd)
 /*
  * Format an INQUIRY CDB
  */
-static int megasas_setup_inquiry(uint8_t *cdb, int pg, int len)
+static void megasas_setup_inquiry(uint8_t *cdb, int pg, int len)
 {
     memset(cdb, 0, 6);
     cdb[0] = INQUIRY;
@@ -385,7 +384,6 @@ static int megasas_setup_inquiry(uint8_t *cdb, int pg, int len)
         cdb[2] = pg;
     }
     stw_be_p(&cdb[3], len);
-    return len;
 }
 
 /*
diff --git a/hw/scsi/mptconfig.c b/hw/scsi/mptconfig.c
index 19d01f39fa..195fcdad26 100644
--- a/hw/scsi/mptconfig.c
+++ b/hw/scsi/mptconfig.c
@@ -127,16 +127,13 @@ static size_t vpack(uint8_t **p_data, const char *fmt, va_list ap1)
     return vfill(data, size, fmt, ap1);
 }
 
-static size_t fill(uint8_t *data, size_t size, const char *fmt, ...)
+static void fill(uint8_t *data, size_t size, const char *fmt, ...)
 {
     va_list ap;
-    size_t ret;
 
     va_start(ap, fmt);
-    ret = vfill(data, size, fmt, ap);
+    vfill(data, size, fmt, ap);
     va_end(ap);
-
-    return ret;
 }
 
 /* Functions to build the page header and fill in the length, always used
diff --git a/hw/scsi/mptsas.c b/hw/scsi/mptsas.c
index 706cf0df3a..78325ef797 100644
--- a/hw/scsi/mptsas.c
+++ b/hw/scsi/mptsas.c
@@ -287,9 +287,9 @@ static int mptsas_scsi_device_find(MPTSASState *s, int bus, int target,
     return 0;
 }
 
-static int mptsas_process_scsi_io_request(MPTSASState *s,
-                                          MPIMsgSCSIIORequest *scsi_io,
-                                          hwaddr addr)
+static void mptsas_process_scsi_io_request(MPTSASState *s,
+                                           MPIMsgSCSIIORequest *scsi_io,
+                                           hwaddr addr)
 {
     MPTSASRequest *req;
     MPIMsgSCSIIOReply reply;
@@ -352,7 +352,7 @@ static int mptsas_process_scsi_io_request(MPTSASState *s,
     if (scsi_req_enqueue(req->sreq)) {
         scsi_req_continue(req->sreq);
     }
-    return 0;
+    return;
 
 overrun:
     trace_mptsas_scsi_overflow(s, scsi_io->MsgContext, req->sreq->cmd.xfer,
@@ -374,8 +374,6 @@ bad:
 
     mptsas_fix_scsi_io_reply_endianness(&reply);
     mptsas_reply(s, (MPIDefaultReply *)&reply);
-
-    return 0;
 }
 
 typedef struct {
@@ -944,7 +942,7 @@ disable:
     s->diagnostic_idx = 0;
 }
 
-static int mptsas_hard_reset(MPTSASState *s)
+static void mptsas_hard_reset(MPTSASState *s)
 {
     mptsas_soft_reset(s);
 
@@ -955,8 +953,6 @@ static int mptsas_hard_reset(MPTSASState *s)
     s->reply_frame_size = 0;
     s->max_devices = MPTSAS_NUM_PORTS;
     s->max_buses = 1;
-
-    return 0;
 }
 
 static void mptsas_interrupt_status_write(MPTSASState *s)
diff --git a/hw/scsi/scsi-bus.c b/hw/scsi/scsi-bus.c
index b2e2bc3c96..c4b89bc48c 100644
--- a/hw/scsi/scsi-bus.c
+++ b/hw/scsi/scsi-bus.c
@@ -20,7 +20,7 @@
 static char *scsibus_get_dev_path(DeviceState *dev);
 static char *scsibus_get_fw_dev_path(DeviceState *dev);
 static void scsi_req_dequeue(SCSIRequest *req);
-static uint8_t *scsi_target_alloc_buf(SCSIRequest *req, size_t len);
+static void scsi_target_alloc_buf(SCSIRequest *req, size_t len);
 static void scsi_target_free_buf(SCSIRequest *req);
 
 static int next_scsi_bus;
@@ -649,14 +649,12 @@ static uint8_t *scsi_target_get_buf(SCSIRequest *req)
     return r->buf;
 }
 
-static uint8_t *scsi_target_alloc_buf(SCSIRequest *req, size_t len)
+static void scsi_target_alloc_buf(SCSIRequest *req, size_t len)
 {
     SCSITargetReq *r = DO_UPCAST(SCSITargetReq, req, req);
 
     r->buf = g_malloc(len);
     r->buf_len = len;
-
-    return r->buf;
 }
 
 static void scsi_target_free_buf(SCSIRequest *req)
diff --git a/hw/usb/dev-audio.c b/hw/usb/dev-audio.c
index 8748c1ba04..610fbbf8c9 100644
--- a/hw/usb/dev-audio.c
+++ b/hw/usb/dev-audio.c
@@ -600,15 +600,16 @@ static void streambuf_fini(struct streambuf *buf)
     buf->data = NULL;
 }
 
-static int streambuf_put(struct streambuf *buf, USBPacket *p, uint32_t channels)
+static void streambuf_put(struct streambuf *buf, USBPacket *p,
+                          uint32_t channels)
 {
     int64_t free = buf->size - (buf->prod - buf->cons);
 
     if (free < USBAUDIO_PACKET_SIZE(channels)) {
-        return 0;
+        return;
     }
     if (p->iov.size != USBAUDIO_PACKET_SIZE(channels)) {
-        return 0;
+        return;
     }
 
     /* can happen if prod overflows */
@@ -616,7 +617,6 @@ static int streambuf_put(struct streambuf *buf, USBPacket *p, uint32_t channels)
     usb_packet_copy(p, buf->data + (buf->prod % buf->size),
                     USBAUDIO_PACKET_SIZE(channels));
     buf->prod += USBAUDIO_PACKET_SIZE(channels);
-    return USBAUDIO_PACKET_SIZE(channels);
 }
 
 static uint8_t *streambuf_get(struct streambuf *buf, size_t *len)
@@ -681,7 +681,7 @@ static void output_callback(void *opaque, int avail)
     }
 }
 
-static int usb_audio_set_output_altset(USBAudioState *s, int altset)
+static void usb_audio_set_output_altset(USBAudioState *s, int altset)
 {
     switch (altset) {
     case ALTSET_OFF:
@@ -697,14 +697,13 @@ static int usb_audio_set_output_altset(USBAudioState *s, int altset)
         AUD_set_active_out(s->out.voice, true);
         break;
     default:
-        return -1;
+        return;
     }
 
     if (s->debug) {
         fprintf(stderr, "usb-audio: set interface %d\n", altset);
     }
     s->out.altset = altset;
-    return 0;
 }
 
 /*
diff --git a/hw/usb/hcd-ehci.c b/hw/usb/hcd-ehci.c
index d4da8dcb8d..8e3766e579 100644
--- a/hw/usb/hcd-ehci.c
+++ b/hw/usb/hcd-ehci.c
@@ -392,7 +392,7 @@ static inline int get_dwords(EHCIState *ehci, uint32_t addr,
 }
 
 /* Put an array of dwords in to main memory */
-static inline int put_dwords(EHCIState *ehci, uint32_t addr,
+static inline void put_dwords(EHCIState *ehci, uint32_t addr,
                              uint32_t *buf, int num)
 {
     int i;
@@ -401,7 +401,7 @@ static inline int put_dwords(EHCIState *ehci, uint32_t addr,
         ehci_raise_irq(ehci, USBSTS_HSE);
         ehci->usbcmd &= ~USBCMD_RUNSTOP;
         trace_usb_ehci_dma_error();
-        return -1;
+        return;
     }
 
     for (i = 0; i < num; i++, buf++, addr += sizeof(*buf)) {
@@ -409,8 +409,6 @@ static inline int put_dwords(EHCIState *ehci, uint32_t addr,
         dma_memory_write(ehci->as, addr, &tmp, sizeof(tmp),
                          MEMTXATTRS_UNSPECIFIED);
     }
-
-    return num;
 }
 
 static int ehci_get_pid(EHCIqtd *qtd)
diff --git a/hw/usb/hcd-ohci.c b/hw/usb/hcd-ohci.c
index 895b29fb86..1eaba710f1 100644
--- a/hw/usb/hcd-ohci.c
+++ b/hw/usb/hcd-ohci.c
@@ -1226,7 +1226,7 @@ static void ohci_frame_boundary(void *opaque)
 /* Start sending SOF tokens across the USB bus, lists are processed in
  * next frame
  */
-static int ohci_bus_start(OHCIState *ohci)
+static void ohci_bus_start(OHCIState *ohci)
 {
     trace_usb_ohci_start(ohci->name);
 
@@ -1237,8 +1237,6 @@ static int ohci_bus_start(OHCIState *ohci)
 
     ohci->sof_time = qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL);
     ohci_eof_timer(ohci);
-
-    return 1;
 }
 
 /* Stop sending SOF tokens on the bus */
diff --git a/hw/usb/hcd-xhci.c b/hw/usb/hcd-xhci.c
index 296cc6c8e6..f8b5f458d5 100644
--- a/hw/usb/hcd-xhci.c
+++ b/hw/usb/hcd-xhci.c
@@ -304,8 +304,8 @@ typedef struct XHCIEvRingSeg {
 static void xhci_kick_ep(XHCIState *xhci, unsigned int slotid,
                          unsigned int epid, unsigned int streamid);
 static void xhci_kick_epctx(XHCIEPContext *epctx, unsigned int streamid);
-static TRBCCode xhci_disable_ep(XHCIState *xhci, unsigned int slotid,
-                                unsigned int epid);
+static void xhci_disable_ep(XHCIState *xhci, unsigned int slotid,
+                            unsigned int epid);
 static void xhci_xfer_report(XHCITransfer *xfer);
 static void xhci_event(XHCIState *xhci, XHCIEvent *event, int v);
 static void xhci_write_event(XHCIState *xhci, XHCIEvent *event, int v);
@@ -1215,8 +1215,8 @@ static int xhci_ep_nuke_xfers(XHCIState *xhci, unsigned int slotid,
     return killed;
 }
 
-static TRBCCode xhci_disable_ep(XHCIState *xhci, unsigned int slotid,
-                               unsigned int epid)
+static void xhci_disable_ep(XHCIState *xhci, unsigned int slotid,
+                            unsigned int epid)
 {
     XHCISlot *slot;
     XHCIEPContext *epctx;
@@ -1229,7 +1229,7 @@ static TRBCCode xhci_disable_ep(XHCIState *xhci, unsigned int slotid,
 
     if (!slot->eps[epid-1]) {
         DPRINTF("xhci: slot %d ep %d already disabled\n", slotid, epid);
-        return CC_SUCCESS;
+        return;
     }
 
     xhci_ep_nuke_xfers(xhci, slotid, epid, 0);
@@ -1248,8 +1248,6 @@ static TRBCCode xhci_disable_ep(XHCIState *xhci, unsigned int slotid,
     timer_free(epctx->kick_timer);
     g_free(epctx);
     slot->eps[epid-1] = NULL;
-
-    return CC_SUCCESS;
 }
 
 static TRBCCode xhci_stop_ep(XHCIState *xhci, unsigned int slotid,
@@ -1390,7 +1388,7 @@ static TRBCCode xhci_set_ep_dequeue(XHCIState *xhci, unsigned int slotid,
     return CC_SUCCESS;
 }
 
-static int xhci_xfer_create_sgl(XHCITransfer *xfer, int in_xfer)
+static void xhci_xfer_create_sgl(XHCITransfer *xfer, int in_xfer)
 {
     XHCIState *xhci = xfer->epctx->xhci;
     int i;
@@ -1430,12 +1428,11 @@ static int xhci_xfer_create_sgl(XHCITransfer *xfer, int in_xfer)
         }
     }
 
-    return 0;
+    return;
 
 err:
     qemu_sglist_destroy(&xfer->sgl);
     xhci_die(xhci);
-    return -1;
 }
 
 static void xhci_xfer_unmap(XHCITransfer *xfer)
@@ -1580,20 +1577,20 @@ static int xhci_setup_packet(XHCITransfer *xfer)
     return 0;
 }
 
-static int xhci_try_complete_packet(XHCITransfer *xfer)
+static void xhci_try_complete_packet(XHCITransfer *xfer)
 {
     if (xfer->packet.status == USB_RET_ASYNC) {
         trace_usb_xhci_xfer_async(xfer);
         xfer->running_async = 1;
         xfer->running_retry = 0;
         xfer->complete = 0;
-        return 0;
+        return;
     } else if (xfer->packet.status == USB_RET_NAK) {
         trace_usb_xhci_xfer_nak(xfer);
         xfer->running_async = 0;
         xfer->running_retry = 1;
         xfer->complete = 0;
-        return 0;
+        return;
     } else {
         xfer->running_async = 0;
         xfer->running_retry = 0;
@@ -1605,7 +1602,7 @@ static int xhci_try_complete_packet(XHCITransfer *xfer)
         trace_usb_xhci_xfer_success(xfer, xfer->packet.actual_length);
         xfer->status = CC_SUCCESS;
         xhci_xfer_report(xfer);
-        return 0;
+        return;
     }
 
     /* error */
@@ -1632,10 +1629,9 @@ static int xhci_try_complete_packet(XHCITransfer *xfer)
                 xfer->packet.status);
         FIXME("unhandled USB_RET_*");
     }
-    return 0;
 }
 
-static int xhci_fire_ctl_transfer(XHCIState *xhci, XHCITransfer *xfer)
+static void xhci_fire_ctl_transfer(XHCIState *xhci, XHCITransfer *xfer)
 {
     XHCITRB *trb_setup, *trb_status;
     uint8_t bmRequestType;
@@ -1655,21 +1651,21 @@ static int xhci_fire_ctl_transfer(XHCIState *xhci, XHCITransfer *xfer)
     if (TRB_TYPE(*trb_setup) != TR_SETUP) {
         DPRINTF("xhci: ep0 first TD not SETUP: %d\n",
                 TRB_TYPE(*trb_setup));
-        return -1;
+        return;
     }
     if (TRB_TYPE(*trb_status) != TR_STATUS) {
         DPRINTF("xhci: ep0 last TD not STATUS: %d\n",
                 TRB_TYPE(*trb_status));
-        return -1;
+        return;
     }
     if (!(trb_setup->control & TRB_TR_IDT)) {
         DPRINTF("xhci: Setup TRB doesn't have IDT set\n");
-        return -1;
+        return;
     }
     if ((trb_setup->status & 0x1ffff) != 8) {
         DPRINTF("xhci: Setup TRB has bad length (%d)\n",
                 (trb_setup->status & 0x1ffff));
-        return -1;
+        return;
     }
 
     bmRequestType = trb_setup->parameter;
@@ -1679,13 +1675,12 @@ static int xhci_fire_ctl_transfer(XHCIState *xhci, XHCITransfer *xfer)
     xfer->timed_xfer = false;
 
     if (xhci_setup_packet(xfer) < 0) {
-        return -1;
+        return;
     }
     xfer->packet.parameter = trb_setup->parameter;
 
     usb_handle_packet(xfer->packet.ep->dev, &xfer->packet);
     xhci_try_complete_packet(xfer);
-    return 0;
 }
 
 static void xhci_calc_intr_kick(XHCIState *xhci, XHCITransfer *xfer,
@@ -1736,7 +1731,8 @@ static void xhci_check_intr_iso_kick(XHCIState *xhci, XHCITransfer *xfer,
 }
 
 
-static int xhci_submit(XHCIState *xhci, XHCITransfer *xfer, XHCIEPContext *epctx)
+static void xhci_submit(XHCIState *xhci, XHCITransfer *xfer,
+                        XHCIEPContext *epctx)
 {
     uint64_t mfindex;
 
@@ -1754,7 +1750,7 @@ static int xhci_submit(XHCIState *xhci, XHCITransfer *xfer, XHCIEPContext *epctx
         xhci_calc_intr_kick(xhci, xfer, epctx, mfindex);
         xhci_check_intr_iso_kick(xhci, xfer, epctx, mfindex);
         if (xfer->running_retry) {
-            return -1;
+            return;
         }
         break;
     case ET_BULK_OUT:
@@ -1772,27 +1768,27 @@ static int xhci_submit(XHCIState *xhci, XHCITransfer *xfer, XHCIEPContext *epctx
         xhci_calc_iso_kick(xhci, xfer, epctx, mfindex);
         xhci_check_intr_iso_kick(xhci, xfer, epctx, mfindex);
         if (xfer->running_retry) {
-            return -1;
+            return;
         }
         break;
     default:
         trace_usb_xhci_unimplemented("endpoint type", epctx->type);
-        return -1;
+        return;
     }
 
     if (xhci_setup_packet(xfer) < 0) {
-        return -1;
+        return;
     }
     usb_handle_packet(xfer->packet.ep->dev, &xfer->packet);
     xhci_try_complete_packet(xfer);
-    return 0;
 }
 
-static int xhci_fire_transfer(XHCIState *xhci, XHCITransfer *xfer, XHCIEPContext *epctx)
+static void xhci_fire_transfer(XHCIState *xhci, XHCITransfer *xfer,
+                               XHCIEPContext *epctx)
 {
     trace_usb_xhci_xfer_start(xfer, xfer->epctx->slotid,
                               xfer->epctx->epid, xfer->streamid);
-    return xhci_submit(xhci, xfer, epctx);
+    xhci_submit(xhci, xfer, epctx);
 }
 
 static void xhci_kick_ep(XHCIState *xhci, unsigned int slotid,
diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index ace9562a9b..3f823bbe42 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -1390,8 +1390,8 @@ static int vfio_ram_discard_get_dirty_bitmap(MemoryRegionSection *section,
     return vfio_get_dirty_bitmap(vrdl->container, iova, size, ram_addr);
 }
 
-static int vfio_sync_ram_discard_listener_dirty_bitmap(VFIOContainer *container,
-                                                   MemoryRegionSection *section)
+static void vfio_sync_ram_discard_listener_dirty_bitmap(
+    VFIOContainer *container, MemoryRegionSection *section)
 {
     RamDiscardManager *rdm = memory_region_get_ram_discard_manager(section->mr);
     VFIORamDiscardListener *vrdl = NULL;
@@ -1412,13 +1412,13 @@ static int vfio_sync_ram_discard_listener_dirty_bitmap(VFIOContainer *container,
      * We only want/can synchronize the bitmap for actually mapped parts -
      * which correspond to populated parts. Replay all populated parts.
      */
-    return ram_discard_manager_replay_populated(rdm, section,
-                                              vfio_ram_discard_get_dirty_bitmap,
-                                                &vrdl);
+    ram_discard_manager_replay_populated(rdm, section,
+                                         vfio_ram_discard_get_dirty_bitmap,
+                                         &vrdl);
 }
 
-static int vfio_sync_dirty_bitmap(VFIOContainer *container,
-                                  MemoryRegionSection *section)
+static void vfio_sync_dirty_bitmap(VFIOContainer *container,
+                                   MemoryRegionSection *section)
 {
     ram_addr_t ram_addr;
 
@@ -1447,15 +1447,16 @@ static int vfio_sync_dirty_bitmap(VFIOContainer *container,
                 break;
             }
         }
-        return 0;
+        return;
     } else if (memory_region_has_ram_discard_manager(section->mr)) {
-        return vfio_sync_ram_discard_listener_dirty_bitmap(container, section);
+        vfio_sync_ram_discard_listener_dirty_bitmap(container, section);
+        return;
     }
 
     ram_addr = memory_region_get_ram_addr(section->mr) +
                section->offset_within_region;
 
-    return vfio_get_dirty_bitmap(container,
+    vfio_get_dirty_bitmap(container,
                    REAL_HOST_PAGE_ALIGN(section->offset_within_address_space),
                    int128_get64(section->size), ram_addr);
 }
diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
index 3ff9ce3501..9321d5f7c5 100644
--- a/hw/virtio/vhost-vdpa.c
+++ b/hw/virtio/vhost-vdpa.c
@@ -730,7 +730,7 @@ static int vhost_vdpa_get_vq_index(struct vhost_dev *dev, int idx)
     return idx;
 }
 
-static int vhost_vdpa_set_vring_ready(struct vhost_dev *dev)
+static void vhost_vdpa_set_vring_ready(struct vhost_dev *dev)
 {
     int i;
     trace_vhost_vdpa_set_vring_ready(dev);
@@ -741,7 +741,6 @@ static int vhost_vdpa_set_vring_ready(struct vhost_dev *dev)
         };
         vhost_vdpa_call(dev, VHOST_VDPA_SET_VRING_ENABLE, &state);
     }
-    return 0;
 }
 
 static void vhost_vdpa_dump_config(struct vhost_dev *dev, const uint8_t *config,
diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 0827d631c0..f305f5988d 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -106,17 +106,17 @@ static void vhost_dev_sync_region(struct vhost_dev *dev,
     }
 }
 
-static int vhost_sync_dirty_bitmap(struct vhost_dev *dev,
-                                   MemoryRegionSection *section,
-                                   hwaddr first,
-                                   hwaddr last)
+static void vhost_sync_dirty_bitmap(struct vhost_dev *dev,
+                                    MemoryRegionSection *section,
+                                    hwaddr first,
+                                    hwaddr last)
 {
     int i;
     hwaddr start_addr;
     hwaddr end_addr;
 
     if (!dev->log_enabled || !dev->started) {
-        return 0;
+        return;
     }
     start_addr = section->offset_within_address_space;
     end_addr = range_get_last(start_addr, int128_get64(section->size));
@@ -140,7 +140,6 @@ static int vhost_sync_dirty_bitmap(struct vhost_dev *dev,
         vhost_dev_sync_region(dev, section, start_addr, end_addr, vq->used_phys,
                               range_get_last(vq->used_phys, vq->used_size));
     }
-    return 0;
 }
 
 static void vhost_log_sync(MemoryListener *listener,
diff --git a/hw/virtio/virtio-iommu.c b/hw/virtio/virtio-iommu.c
index 62e07ec2e4..03dd3a623e 100644
--- a/hw/virtio/virtio-iommu.c
+++ b/hw/virtio/virtio-iommu.c
@@ -98,7 +98,7 @@ unlock:
 }
 
 /* Return whether the device is using IOMMU translation. */
-static bool virtio_iommu_switch_address_space(IOMMUDevice *sdev)
+static void virtio_iommu_switch_address_space(IOMMUDevice *sdev)
 {
     bool use_remapping;
 
@@ -119,8 +119,6 @@ static bool virtio_iommu_switch_address_space(IOMMUDevice *sdev)
         memory_region_set_enabled(MEMORY_REGION(&sdev->iommu_mr), false);
         memory_region_set_enabled(&sdev->bypass_mr, true);
     }
-
-    return use_remapping;
 }
 
 static void virtio_iommu_switch_address_space_all(VirtIOIOMMU *s)
diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index 30d03e987a..413212cafe 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -258,10 +258,10 @@ static int virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
     return ret;
 }
 
-static int virtio_mem_for_each_unplugged_section(const VirtIOMEM *vmem,
-                                                 MemoryRegionSection *s,
-                                                 void *arg,
-                                                 virtio_mem_section_cb cb)
+static void virtio_mem_for_each_unplugged_section(const VirtIOMEM *vmem,
+                                                  MemoryRegionSection *s,
+                                                  void *arg,
+                                                  virtio_mem_section_cb cb)
 {
     unsigned long first_bit, last_bit;
     uint64_t offset, size;
@@ -287,7 +287,6 @@ static int virtio_mem_for_each_unplugged_section(const VirtIOMEM *vmem,
         first_bit = find_next_zero_bit(vmem->bitmap, vmem->bitmap_size,
                                        last_bit + 2);
     }
-    return ret;
 }
 
 static int virtio_mem_notify_populate_cb(MemoryRegionSection *s, void *arg)
diff --git a/io/channel-command.c b/io/channel-command.c
index 9f2f4a1793..59f3c144f6 100644
--- a/io/channel-command.c
+++ b/io/channel-command.c
@@ -172,8 +172,8 @@ qio_channel_command_new_spawn(const char *const argv[],
 #endif /* WIN32 */
 
 #ifndef WIN32
-static int qio_channel_command_abort(QIOChannelCommand *ioc,
-                                     Error **errp)
+static void qio_channel_command_abort(QIOChannelCommand *ioc,
+                                      Error **errp)
 {
     pid_t ret;
     int status;
@@ -193,7 +193,7 @@ static int qio_channel_command_abort(QIOChannelCommand *ioc,
             error_setg_errno(errp, errno,
                              "Cannot wait on pid %llu",
                              (unsigned long long)ioc->pid);
-            return -1;
+            return;
         }
     } else if (ret == 0) {
         if (step == 0) {
@@ -204,14 +204,12 @@ static int qio_channel_command_abort(QIOChannelCommand *ioc,
             error_setg(errp,
                        "Process %llu refused to die",
                        (unsigned long long)ioc->pid);
-            return -1;
+            return;
         }
         step++;
         usleep(10 * 1000);
         goto rewait;
     }
-
-    return 0;
 }
 #endif /* ! WIN32 */
 
diff --git a/migration/migration.c b/migration/migration.c
index e03f698a3c..4698080f96 100644
--- a/migration/migration.c
+++ b/migration/migration.c
@@ -175,7 +175,7 @@ static MigrationIncomingState *current_incoming;
 
 static GSList *migration_blockers;
 
-static bool migration_object_check(MigrationState *ms, Error **errp);
+static void migration_object_check(MigrationState *ms, Error **errp);
 static int migration_maybe_pause(MigrationState *s,
                                  int *current_active_state,
                                  int new_state);
@@ -4485,15 +4485,15 @@ static void migration_instance_init(Object *obj)
  * Return true if check pass, false otherwise. Error will be put
  * inside errp if provided.
  */
-static bool migration_object_check(MigrationState *ms, Error **errp)
+static void migration_object_check(MigrationState *ms, Error **errp)
 {
     MigrationCapabilityStatusList *head = NULL;
     /* Assuming all off */
-    bool cap_list[MIGRATION_CAPABILITY__MAX] = { 0 }, ret;
+    bool cap_list[MIGRATION_CAPABILITY__MAX] = { 0 };
     int i;
 
     if (!migrate_params_check(&ms->parameters, errp)) {
-        return false;
+        return;
     }
 
     for (i = 0; i < MIGRATION_CAPABILITY__MAX; i++) {
@@ -4502,12 +4502,10 @@ static bool migration_object_check(MigrationState *ms, Error **errp)
         }
     }
 
-    ret = migrate_caps_check(cap_list, head, errp);
+    migrate_caps_check(cap_list, head, errp);
 
     /* It works with head == NULL */
     qapi_free_MigrationCapabilityStatusList(head);
-
-    return ret;
 }
 
 static const TypeInfo migration_type = {
diff --git a/net/dump.c b/net/dump.c
index 6a63b15359..6fde1501a9 100644
--- a/net/dump.c
+++ b/net/dump.c
@@ -61,7 +61,7 @@ struct pcap_sf_pkthdr {
     uint32_t len;
 };
 
-static ssize_t dump_receive_iov(DumpState *s, const struct iovec *iov, int cnt)
+static void dump_receive_iov(DumpState *s, const struct iovec *iov, int cnt)
 {
     struct pcap_sf_pkthdr hdr;
     int64_t ts;
@@ -71,7 +71,7 @@ static ssize_t dump_receive_iov(DumpState *s, const struct iovec *iov, int cnt)
 
     /* Early return in case of previous error. */
     if (s->fd < 0) {
-        return size;
+        return;
     }
 
     ts = qemu_clock_get_us(QEMU_CLOCK_VIRTUAL);
@@ -91,8 +91,6 @@ static ssize_t dump_receive_iov(DumpState *s, const struct iovec *iov, int cnt)
         close(s->fd);
         s->fd = -1;
     }
-
-    return size;
 }
 
 static void dump_cleanup(DumpState *s)
@@ -101,8 +99,8 @@ static void dump_cleanup(DumpState *s)
     s->fd = -1;
 }
 
-static int net_dump_state_init(DumpState *s, const char *filename,
-                               int len, Error **errp)
+static void net_dump_state_init(DumpState *s, const char *filename,
+                                int len, Error **errp)
 {
     struct pcap_file_hdr hdr;
     struct tm tm;
@@ -111,7 +109,7 @@ static int net_dump_state_init(DumpState *s, const char *filename,
     fd = open(filename, O_CREAT | O_TRUNC | O_WRONLY | O_BINARY, 0644);
     if (fd < 0) {
         error_setg_errno(errp, errno, "net dump: can't open %s", filename);
-        return -1;
+        return;
     }
 
     hdr.magic = PCAP_MAGIC;
@@ -125,7 +123,7 @@ static int net_dump_state_init(DumpState *s, const char *filename,
     if (write(fd, &hdr, sizeof(hdr)) < sizeof(hdr)) {
         error_setg_errno(errp, errno, "net dump write error");
         close(fd);
-        return -1;
+        return;
     }
 
     s->fd = fd;
@@ -133,8 +131,6 @@ static int net_dump_state_init(DumpState *s, const char *filename,
 
     qemu_get_timedate(&tm, 0);
     s->start_ts = mktime(&tm);
-
-    return 0;
 }
 
 #define TYPE_FILTER_DUMP "filter-dump"
diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
index 6abad276a6..11e4f64a31 100644
--- a/net/vhost-vdpa.c
+++ b/net/vhost-vdpa.c
@@ -506,12 +506,10 @@ static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
     return nc;
 }
 
-static int vhost_vdpa_get_iova_range(int fd,
-                                     struct vhost_vdpa_iova_range *iova_range)
+static void vhost_vdpa_get_iova_range(int fd,
+                                      struct vhost_vdpa_iova_range *iova_range)
 {
-    int ret = ioctl(fd, VHOST_VDPA_GET_IOVA_RANGE, iova_range);
-
-    return ret < 0 ? -errno : 0;
+    ioctl(fd, VHOST_VDPA_GET_IOVA_RANGE, iova_range);
 }
 
 static int vhost_vdpa_get_features(int fd, uint64_t *features, Error **errp)
diff --git a/qemu-img.c b/qemu-img.c
index 7d4b33b3da..d90ad1d298 100644
--- a/qemu-img.c
+++ b/qemu-img.c
@@ -289,16 +289,14 @@ static QemuOptsList qemu_source_opts = {
     },
 };
 
-static int G_GNUC_PRINTF(2, 3) qprintf(bool quiet, const char *fmt, ...)
+static void G_GNUC_PRINTF(2, 3) qprintf(bool quiet, const char *fmt, ...)
 {
-    int ret = 0;
     if (!quiet) {
         va_list args;
         va_start(args, fmt);
-        ret = vprintf(fmt, args);
+        vprintf(fmt, args);
         va_end(args);
     }
-    return ret;
 }
 
 
diff --git a/qga/commands-posix-ssh.c b/qga/commands-posix-ssh.c
index f3a580b8cc..ddabc33502 100644
--- a/qga/commands-posix-ssh.c
+++ b/qga/commands-posix-ssh.c
@@ -111,7 +111,7 @@ check_openssh_pub_keys(strList *keys, size_t *nkeys, Error **errp)
     return true;
 }
 
-static bool
+static void
 write_authkeys(const char *path, const GStrv keys,
                const struct passwd *p, Error **errp)
 {
@@ -121,22 +121,20 @@ write_authkeys(const char *path, const GStrv keys,
     contents = g_strjoinv("\n", keys);
     if (!g_file_set_contents(path, contents, -1, &err)) {
         error_setg(errp, "failed to write to '%s': %s", path, err->message);
-        return false;
+        return;
     }
 
     if (chown(path, p->pw_uid, p->pw_gid) == -1) {
         error_setg(errp, "failed to set ownership of directory '%s': %s",
                    path, g_strerror(errno));
-        return false;
+        return;
     }
 
     if (chmod(path, 0600) == -1) {
         error_setg(errp, "failed to set permissions of '%s': %s",
                    path, g_strerror(errno));
-        return false;
+        return;
     }
-
-    return true;
 }
 
 static GStrv
diff --git a/softmmu/physmem.c b/softmmu/physmem.c
index dc3c3e5f2e..ef7d724a77 100644
--- a/softmmu/physmem.c
+++ b/softmmu/physmem.c
@@ -1158,8 +1158,8 @@ hwaddr memory_region_section_get_iotlb(CPUState *cpu,
     return section - d->map.sections;
 }
 
-static int subpage_register(subpage_t *mmio, uint32_t start, uint32_t end,
-                            uint16_t section);
+static void subpage_register(subpage_t *mmio, uint32_t start, uint32_t end,
+                             uint16_t section);
 static subpage_t *subpage_init(FlatView *fv, hwaddr base);
 
 static uint16_t phys_section_add(PhysPageMap *map,
@@ -1823,14 +1823,14 @@ size_t qemu_ram_pagesize_largest(void)
     return largest;
 }
 
-static int memory_try_enable_merging(void *addr, size_t len)
+static void memory_try_enable_merging(void *addr, size_t len)
 {
     if (!machine_mem_merge(current_machine)) {
         /* disabled by the user */
-        return 0;
+        return;
     }
 
-    return qemu_madvise(addr, len, QEMU_MADV_MERGEABLE);
+    qemu_madvise(addr, len, QEMU_MADV_MERGEABLE);
 }
 
 /*
@@ -2526,13 +2526,13 @@ static const MemoryRegionOps subpage_ops = {
     .endianness = DEVICE_NATIVE_ENDIAN,
 };
 
-static int subpage_register(subpage_t *mmio, uint32_t start, uint32_t end,
-                            uint16_t section)
+static void subpage_register(subpage_t *mmio, uint32_t start, uint32_t end,
+                             uint16_t section)
 {
     int idx, eidx;
 
     if (start >= TARGET_PAGE_SIZE || end >= TARGET_PAGE_SIZE)
-        return -1;
+        return;
     idx = SUBPAGE_IDX(start);
     eidx = SUBPAGE_IDX(end);
 #if defined(DEBUG_SUBPAGE)
@@ -2542,8 +2542,6 @@ static int subpage_register(subpage_t *mmio, uint32_t start, uint32_t end,
     for (; idx <= eidx; idx++) {
         mmio->sub_section[idx] = section;
     }
-
-    return 0;
 }
 
 static subpage_t *subpage_init(FlatView *fv, hwaddr base)
diff --git a/softmmu/qtest.c b/softmmu/qtest.c
index f8acef2628..d0c1c72292 100644
--- a/softmmu/qtest.c
+++ b/softmmu/qtest.c
@@ -875,7 +875,7 @@ void qtest_server_init(const char *qtest_chrdev, const char *qtest_log, Error **
     object_unref(qtest);
 }
 
-static bool qtest_server_start(QTest *q, Error **errp)
+static void qtest_server_start(QTest *q, Error **errp)
 {
     Chardev *chr = q->chr;
     const char *qtest_log = q->log;
@@ -889,7 +889,7 @@ static bool qtest_server_start(QTest *q, Error **errp)
     }
 
     if (!qemu_chr_fe_init(&q->qtest_chr, chr, errp)) {
-        return false;
+        return;
     }
     qemu_chr_fe_set_handlers(&q->qtest_chr, qtest_can_read, qtest_read,
                              qtest_event, NULL, &q->qtest_chr, NULL, true);
@@ -901,7 +901,6 @@ static bool qtest_server_start(QTest *q, Error **errp)
         qtest_server_set_send_handler(qtest_server_char_be_send, &q->qtest_chr);
     }
     qtest = q;
-    return true;
 }
 
 void qtest_server_set_send_handler(void (*send)(void*, const char*),
diff --git a/subprojects/libvduse/libvduse.c b/subprojects/libvduse/libvduse.c
index 9a2bcec282..a61552758c 100644
--- a/subprojects/libvduse/libvduse.c
+++ b/subprojects/libvduse/libvduse.c
@@ -278,33 +278,27 @@ static int vduse_queue_check_inflights(VduseVirtq *vq)
     return 0;
 }
 
-static int vduse_queue_inflight_get(VduseVirtq *vq, int desc_idx)
+static void vduse_queue_inflight_get(VduseVirtq *vq, int desc_idx)
 {
     vq->log->inflight.desc[desc_idx].counter = vq->counter++;
 
     barrier();
 
     vq->log->inflight.desc[desc_idx].inflight = 1;
-
-    return 0;
 }
 
-static int vduse_queue_inflight_pre_put(VduseVirtq *vq, int desc_idx)
+static void vduse_queue_inflight_pre_put(VduseVirtq *vq, int desc_idx)
 {
     vq->log->inflight.last_batch_head = desc_idx;
-
-    return 0;
 }
 
-static int vduse_queue_inflight_post_put(VduseVirtq *vq, int desc_idx)
+static void vduse_queue_inflight_post_put(VduseVirtq *vq, int desc_idx)
 {
     vq->log->inflight.desc[desc_idx].inflight = 0;
 
     barrier();
 
     vq->log->inflight.used_idx = vq->used_idx;
-
-    return 0;
 }
 
 static void vduse_iova_remove_region(VduseDev *dev, uint64_t start,
diff --git a/subprojects/libvhost-user/libvhost-user.c b/subprojects/libvhost-user/libvhost-user.c
index ffed4729a3..f3cea908b5 100644
--- a/subprojects/libvhost-user/libvhost-user.c
+++ b/subprojects/libvhost-user/libvhost-user.c
@@ -2632,48 +2632,44 @@ vu_queue_map_desc(VuDev *dev, VuVirtq *vq, unsigned int idx, size_t sz)
     return elem;
 }
 
-static int
+static void
 vu_queue_inflight_get(VuDev *dev, VuVirtq *vq, int desc_idx)
 {
     if (!vu_has_protocol_feature(dev, VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD)) {
-        return 0;
+        return;
     }
 
     if (unlikely(!vq->inflight)) {
-        return -1;
+        return;
     }
 
     vq->inflight->desc[desc_idx].counter = vq->counter++;
     vq->inflight->desc[desc_idx].inflight = 1;
-
-    return 0;
 }
 
-static int
+static void
 vu_queue_inflight_pre_put(VuDev *dev, VuVirtq *vq, int desc_idx)
 {
     if (!vu_has_protocol_feature(dev, VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD)) {
-        return 0;
+        return;
     }
 
     if (unlikely(!vq->inflight)) {
-        return -1;
+        return;
     }
 
     vq->inflight->last_batch_head = desc_idx;
-
-    return 0;
 }
 
-static int
+static void
 vu_queue_inflight_post_put(VuDev *dev, VuVirtq *vq, int desc_idx)
 {
     if (!vu_has_protocol_feature(dev, VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD)) {
-        return 0;
+        return;
     }
 
     if (unlikely(!vq->inflight)) {
-        return -1;
+        return;
     }
 
     barrier();
@@ -2683,8 +2679,6 @@ vu_queue_inflight_post_put(VuDev *dev, VuVirtq *vq, int desc_idx)
     barrier();
 
     vq->inflight->used_idx = vq->used_idx;
-
-    return 0;
 }
 
 void *
diff --git a/target/i386/host-cpu.c b/target/i386/host-cpu.c
index 10f8aba86e..4866a24858 100644
--- a/target/i386/host-cpu.c
+++ b/target/i386/host-cpu.c
@@ -114,7 +114,7 @@ bool host_cpu_realizefn(CPUState *cs, Error **errp)
  * The function does NOT add a null terminator to the string
  * automatically.
  */
-static int host_cpu_fill_model_id(char *str)
+static void host_cpu_fill_model_id(char *str)
 {
     uint32_t eax = 0, ebx = 0, ecx = 0, edx = 0;
     int i;
@@ -126,7 +126,6 @@ static int host_cpu_fill_model_id(char *str)
         memcpy(str + i * 16 +  8, &ecx, 4);
         memcpy(str + i * 16 + 12, &edx, 4);
     }
-    return 0;
 }
 
 void host_cpu_vendor_fms(char *vendor, int *family, int *model, int *stepping)
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index f148a6d52f..a2504f1a8b 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -208,7 +208,7 @@ bool kvm_hv_vpindex_settable(void)
     return hv_vpindex_settable;
 }
 
-static int kvm_get_tsc(CPUState *cs)
+static void kvm_get_tsc(CPUState *cs)
 {
     X86CPU *cpu = X86_CPU(cs);
     CPUX86State *env = &cpu->env;
@@ -216,18 +216,17 @@ static int kvm_get_tsc(CPUState *cs)
     int ret;
 
     if (env->tsc_valid) {
-        return 0;
+        return;
     }
 
     env->tsc_valid = !runstate_is_running();
 
     ret = kvm_get_one_msr(cpu, MSR_IA32_TSC, &value);
     if (ret < 0) {
-        return ret;
+        return;
     }
 
     env->tsc = value;
-    return 0;
 }
 
 static inline void do_kvm_synchronize_tsc(CPUState *cpu, run_on_cpu_data arg)
@@ -2212,16 +2211,16 @@ void kvm_arch_do_init_vcpu(X86CPU *cpu)
     }
 }
 
-static int kvm_get_supported_feature_msrs(KVMState *s)
+static void kvm_get_supported_feature_msrs(KVMState *s)
 {
     int ret = 0;
 
     if (kvm_feature_msrs != NULL) {
-        return 0;
+        return;
     }
 
     if (!kvm_check_extension(s, KVM_CAP_GET_MSR_FEATURES)) {
-        return 0;
+        return;
     }
 
     struct kvm_msr_list msr_list;
@@ -2231,7 +2230,7 @@ static int kvm_get_supported_feature_msrs(KVMState *s)
     if (ret < 0 && ret != -E2BIG) {
         error_report("Fetch KVM feature MSR list failed: %s",
             strerror(-ret));
-        return ret;
+        return;
     }
 
     assert(msr_list.nmsrs > 0);
@@ -2247,10 +2246,8 @@ static int kvm_get_supported_feature_msrs(KVMState *s)
             strerror(-ret));
         g_free(kvm_feature_msrs);
         kvm_feature_msrs = NULL;
-        return ret;
+        return;
     }
-
-    return 0;
 }
 
 static int kvm_get_supported_msrs(KVMState *s)
diff --git a/tcg/optimize.c b/tcg/optimize.c
index ae081ab29c..b04b2b79a6 100644
--- a/tcg/optimize.c
+++ b/tcg/optimize.c
@@ -1200,7 +1200,7 @@ static bool fold_bswap(OptContext *ctx, TCGOp *op)
     return fold_masks(ctx, op);
 }
 
-static bool fold_call(OptContext *ctx, TCGOp *op)
+static void fold_call(OptContext *ctx, TCGOp *op)
 {
     TCGContext *s = ctx->tcg;
     int nb_oargs = TCGOP_CALLO(op);
@@ -1229,7 +1229,6 @@ static bool fold_call(OptContext *ctx, TCGOp *op)
 
     /* Stop optimizing MB across calls. */
     ctx->prev_mb = NULL;
-    return true;
 }
 
 static bool fold_count_zeros(OptContext *ctx, TCGOp *op)
diff --git a/tests/qtest/libqos/malloc.c b/tests/qtest/libqos/malloc.c
index f0c8f950c8..816e8dfa9c 100644
--- a/tests/qtest/libqos/malloc.c
+++ b/tests/qtest/libqos/malloc.c
@@ -52,7 +52,7 @@ static MemBlock *mlist_find_space(MemList *head, uint64_t size)
     return NULL;
 }
 
-static MemBlock *mlist_sort_insert(MemList *head, MemBlock *insr)
+static void mlist_sort_insert(MemList *head, MemBlock *insr)
 {
     MemBlock *node;
     g_assert(head && insr);
@@ -60,12 +60,11 @@ static MemBlock *mlist_sort_insert(MemList *head, MemBlock *insr)
     QTAILQ_FOREACH(node, head, MLIST_ENTNAME) {
         if (insr->addr < node->addr) {
             QTAILQ_INSERT_BEFORE(node, insr, MLIST_ENTNAME);
-            return insr;
+            return;
         }
     }
 
     QTAILQ_INSERT_TAIL(head, insr, MLIST_ENTNAME);
-    return insr;
 }
 
 static inline uint64_t mlist_boundary(MemBlock *node)
diff --git a/tests/qtest/libqos/qgraph.c b/tests/qtest/libqos/qgraph.c
index 0a2dddfafa..a270ffea00 100644
--- a/tests/qtest/libqos/qgraph.c
+++ b/tests/qtest/libqos/qgraph.c
@@ -349,7 +349,7 @@ static QOSStackElement *qos_tos(void)
 }
 
 /* qos_pop(): pops an element from the tos, setting it unvisited*/
-static QOSStackElement *qos_pop(void)
+static void qos_pop(void)
 {
     if (qos_node_tos == 0) {
         g_printerr("QOSStack: empty stack, cannot pop");
@@ -358,7 +358,6 @@ static QOSStackElement *qos_pop(void)
     QOSStackElement *e = qos_tos();
     e->node->visited = false;
     qos_node_tos--;
-    return e;
 }
 
 /**
diff --git a/tests/qtest/test-x86-cpuid-compat.c b/tests/qtest/test-x86-cpuid-compat.c
index b39c9055b3..cde4416a31 100644
--- a/tests/qtest/test-x86-cpuid-compat.c
+++ b/tests/qtest/test-x86-cpuid-compat.c
@@ -149,10 +149,9 @@ static void test_feature_flag(const void *data)
  * either "feature-words" or "filtered-features", when running QEMU
  * using cmdline
  */
-static FeatureTestArgs *add_feature_test(const char *name, const char *cmdline,
-                                         uint32_t eax, uint32_t ecx,
-                                         const char *reg, int bitnr,
-                                         bool expected_value)
+static void add_feature_test(const char *name, const char *cmdline,
+                             uint32_t eax, uint32_t ecx, const char *reg,
+                             int bitnr, bool expected_value)
 {
     FeatureTestArgs *args = g_new0(FeatureTestArgs, 1);
     args->cmdline = cmdline;
@@ -162,7 +161,6 @@ static FeatureTestArgs *add_feature_test(const char *name, const char *cmdline,
     args->bitnr = bitnr;
     args->expected_value = expected_value;
     qtest_add_data_func(name, args, test_feature_flag);
-    return args;
 }
 
 static void test_plus_minus_subprocess(void)
diff --git a/tests/qtest/virtio-9p-test.c b/tests/qtest/virtio-9p-test.c
index 25305a4cf7..0762d3664c 100644
--- a/tests/qtest/virtio-9p-test.c
+++ b/tests/qtest/virtio-9p-test.c
@@ -1319,8 +1319,8 @@ static void do_mkdir(QVirtio9P *v9p, const char *path, const char *cname)
 }
 
 /* create a regular file with Tlcreate and return file's fid */
-static uint32_t do_lcreate(QVirtio9P *v9p, const char *path,
-                           const char *cname)
+static void do_lcreate(QVirtio9P *v9p, const char *path,
+                       const char *cname)
 {
     g_autofree char *name = g_strdup(cname);
     uint32_t fid;
@@ -1331,8 +1331,6 @@ static uint32_t do_lcreate(QVirtio9P *v9p, const char *path,
     req = v9fs_tlcreate(v9p, fid, name, 0, 0750, 0, 0);
     v9fs_req_wait_for_reply(req, NULL);
     v9fs_rlcreate(req, NULL, NULL);
-
-    return fid;
 }
 
 /* create symlink named @a clink in directory @a path pointing to @a to */
diff --git a/tests/unit/test-aio-multithread.c b/tests/unit/test-aio-multithread.c
index a555cc8835..02a778f5ea 100644
--- a/tests/unit/test-aio-multithread.c
+++ b/tests/unit/test-aio-multithread.c
@@ -114,14 +114,14 @@ static int count_retry;
 static int count_here;
 static int count_other;
 
-static bool schedule_next(int n)
+static void schedule_next(int n)
 {
     Coroutine *co;
 
     co = qatomic_xchg(&to_schedule[n], NULL);
     if (!co) {
         qatomic_inc(&count_retry);
-        return false;
+        return;
     }
 
     if (n == id) {
@@ -131,7 +131,6 @@ static bool schedule_next(int n)
     }
 
     aio_co_schedule(ctx[n], co);
-    return true;
 }
 
 static void finish_cb(void *opaque)
diff --git a/tests/vhost-user-bridge.c b/tests/vhost-user-bridge.c
index 9b1dab2f28..89784f2791 100644
--- a/tests/vhost-user-bridge.c
+++ b/tests/vhost-user-bridge.c
@@ -85,22 +85,21 @@ vubr_die(const char *s)
     exit(1);
 }
 
-static int
+static void
 dispatcher_init(Dispatcher *dispr)
 {
     FD_ZERO(&dispr->fdset);
     dispr->max_sock = -1;
-    return 0;
 }
 
-static int
+static void
 dispatcher_add(Dispatcher *dispr, int sock, void *ctx, CallbackFunc cb)
 {
     if (sock >= FD_SETSIZE) {
         fprintf(stderr,
                 "Error: Failed to add new event. sock %d should be less than %d\n",
                 sock, FD_SETSIZE);
-        return -1;
+        return;
     }
 
     dispr->events[sock].ctx = ctx;
@@ -112,26 +111,24 @@ dispatcher_add(Dispatcher *dispr, int sock, void *ctx, CallbackFunc cb)
     }
     DPRINT("Added sock %d for watching. max_sock: %d\n",
            sock, dispr->max_sock);
-    return 0;
 }
 
-static int
+static void
 dispatcher_remove(Dispatcher *dispr, int sock)
 {
     if (sock >= FD_SETSIZE) {
         fprintf(stderr,
                 "Error: Failed to remove event. sock %d should be less than %d\n",
                 sock, FD_SETSIZE);
-        return -1;
+        return;
     }
 
     FD_CLR(sock, &dispr->fdset);
     DPRINT("Sock %d removed from dispatcher watch.\n", sock);
-    return 0;
 }
 
 /* timeout in us */
-static int
+static void
 dispatcher_wait(Dispatcher *dispr, uint32_t timeout)
 {
     struct timeval tv;
@@ -149,7 +146,7 @@ dispatcher_wait(Dispatcher *dispr, uint32_t timeout)
 
     /* Timeout */
     if (rc == 0) {
-        return 0;
+        return;
     }
 
     /* Now call callback for every ready socket. */
@@ -165,8 +162,6 @@ dispatcher_wait(Dispatcher *dispr, uint32_t timeout)
             e->callback(sock, e->ctx);
         }
     }
-
-    return 0;
 }
 
 static void
diff --git a/ui/vnc.c b/ui/vnc.c
index 6a05d06147..03c9d10423 100644
--- a/ui/vnc.c
+++ b/ui/vnc.c
@@ -68,7 +68,7 @@ static const struct timeval VNC_REFRESH_LOSSY = { 2, 0 };
 static QTAILQ_HEAD(, VncDisplay) vnc_displays =
     QTAILQ_HEAD_INITIALIZER(vnc_displays);
 
-static int vnc_cursor_define(VncState *vs);
+static void vnc_cursor_define(VncState *vs);
 static void vnc_update_throttle_offset(VncState *vs);
 
 static void vnc_set_share_mode(VncState *vs, VncShareMode mode)
@@ -996,13 +996,13 @@ static void vnc_mouse_set(DisplayChangeListener *dcl,
     /* can we ask the client(s) to move the pointer ??? */
 }
 
-static int vnc_cursor_define(VncState *vs)
+static void vnc_cursor_define(VncState *vs)
 {
     QEMUCursor *c = vs->vd->cursor;
     int isize;
 
     if (!vs->vd->cursor) {
-        return -1;
+        return;
     }
 
     if (vnc_has_feature(vs, VNC_FEATURE_ALPHA_CURSOR)) {
@@ -1015,9 +1015,7 @@ static int vnc_cursor_define(VncState *vs)
         vnc_write_s32(vs, VNC_ENCODING_RAW);
         vnc_write(vs, c->data, c->width * c->height * 4);
         vnc_unlock_output(vs);
-        return 0;
-    }
-    if (vnc_has_feature(vs, VNC_FEATURE_RICH_CURSOR)) {
+    } else if (vnc_has_feature(vs, VNC_FEATURE_RICH_CURSOR)) {
         vnc_lock_output(vs);
         vnc_write_u8(vs,  VNC_MSG_SERVER_FRAMEBUFFER_UPDATE);
         vnc_write_u8(vs,  0);  /*  padding     */
@@ -1028,9 +1026,7 @@ static int vnc_cursor_define(VncState *vs)
         vnc_write_pixels_generic(vs, c->data, isize);
         vnc_write(vs, vs->vd->cursor_mask, vs->vd->cursor_msize);
         vnc_unlock_output(vs);
-        return 0;
     }
-    return -1;
 }
 
 static void vnc_dpy_cursor_define(DisplayChangeListener *dcl,
@@ -1438,11 +1434,10 @@ size_t vnc_client_write_buf(VncState *vs, const uint8_t *data, size_t datalen)
  * as possible without blocking. If all buffered data is written,
  * will switch the FD poll() handler back to read monitoring.
  *
- * Returns the number of bytes written, which may be less than
- * the buffered output data if the socket would block.  Returns
- * 0 on I/O error, and disconnects the client socket.
+ * May write less than the buffered output data if the socket would
+ * block. On I/O error, disconnects the client socket.
  */
-static size_t vnc_client_write_plain(VncState *vs)
+static void vnc_client_write_plain(VncState *vs)
 {
     size_t offset;
     size_t ret;
@@ -1462,7 +1457,7 @@ static size_t vnc_client_write_plain(VncState *vs)
 #endif /* CONFIG_VNC_SASL */
         ret = vnc_client_write_buf(vs, vs->output.buffer, vs->output.offset);
     if (!ret)
-        return 0;
+        return;
 
     if (ret >= vs->force_update_offset) {
         if (vs->force_update_offset != 0) {
@@ -1487,8 +1482,6 @@ static size_t vnc_client_write_plain(VncState *vs)
             vs->ioc, G_IO_IN | G_IO_HUP | G_IO_ERR,
             vnc_client_io, vs, NULL);
     }
-
-    return ret;
 }
 
 
diff --git a/util/aio-posix.c b/util/aio-posix.c
index 731f3826c0..bedaf2efae 100644
--- a/util/aio-posix.c
+++ b/util/aio-posix.c
@@ -403,16 +403,13 @@ static bool aio_dispatch_ready_handlers(AioContext *ctx,
 }
 
 /* Slower than aio_dispatch_ready_handlers() but only used via glib */
-static bool aio_dispatch_handlers(AioContext *ctx)
+static void aio_dispatch_handlers(AioContext *ctx)
 {
     AioHandler *node, *tmp;
-    bool progress = false;
 
     QLIST_FOREACH_SAFE_RCU(node, &ctx->aio_handlers, node, tmp) {
-        progress = aio_dispatch_handler(ctx, node) || progress;
+        aio_dispatch_handler(ctx, node);
     }
-
-    return progress;
 }
 
 void aio_dispatch(AioContext *ctx)
diff --git a/util/uri.c b/util/uri.c
index ff72c6005f..7078cff857 100644
--- a/util/uri.c
+++ b/util/uri.c
@@ -1364,15 +1364,13 @@ void uri_free(URI *uri)
  * Section 5.2, steps 6.c through 6.g.
  *
  * Normalization occurs directly on the string, no new allocation is done
- *
- * Returns 0 or an error code
  */
-static int normalize_uri_path(char *path)
+static void normalize_uri_path(char *path)
 {
     char *cur, *out;
 
     if (path == NULL) {
-        return -1;
+        return;
     }
 
     /* Skip all initial "/" chars.  We want to get to the beginning of the
@@ -1383,7 +1381,7 @@ static int normalize_uri_path(char *path)
         ++cur;
     }
     if (cur[0] == '\0') {
-        return 0;
+        return;
     }
 
     /* Keep everything we've seen so far.  */
@@ -1437,7 +1435,7 @@ done_cd:
         ++cur;
     }
     if (cur[0] == '\0') {
-        return 0;
+        return;
     }
 
     /*
@@ -1558,8 +1556,6 @@ done_cd:
             out[0] = 0;
         }
     }
-
-    return 0;
 }
 
 static int is_hex(char c)
@@ -2213,8 +2209,8 @@ struct QueryParams *query_params_new(int init_alloc)
 /* Ensure there is space to store at least one more parameter
  * at the end of the set.
  */
-static int query_params_append(struct QueryParams *ps, const char *name,
-                               const char *value)
+static void query_params_append(struct QueryParams *ps, const char *name,
+                                const char *value)
 {
     if (ps->n >= ps->alloc) {
         ps->p = g_renew(QueryParam, ps->p, ps->alloc * 2);
@@ -2225,8 +2221,6 @@ static int query_params_append(struct QueryParams *ps, const char *name,
     ps->p[ps->n].value = g_strdup(value);
     ps->p[ps->n].ignore = 0;
     ps->n++;
-
-    return 0;
 }
 
 void query_params_free(struct QueryParams *ps)
-- 
2.37.1

