Return-Path: <kvm+bounces-2804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FCB47FE1E5
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 22:27:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 164392831AA
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 21:27:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B2122B9CA;
	Wed, 29 Nov 2023 21:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gu8Ymmv4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B341729
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 13:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701293214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BpLNXxP4Yehpq7UvX9OuyGYKLdha9NvrROrpeAtoX0o=;
	b=Gu8Ymmv44Elij5mK8jFXcUituPCnDLYAJpD9KXKFLVX9MubljpeNOfIwTcsSvP9jqYTB1P
	LoyVPmeqlu8HMZqSUUsezu+7M6v0GUxt0cKJNErFjcdaKZYaG1Qhrje96yCL7jQiJ2WsVf
	C4GQj6L64KW/yT8mcvzvDN1y5Fb5OHc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-333-k_vygxEVMguyIFoRnuPTCg-1; Wed,
 29 Nov 2023 16:26:50 -0500
X-MC-Unique: k_vygxEVMguyIFoRnuPTCg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 639F138049EF;
	Wed, 29 Nov 2023 21:26:49 +0000 (UTC)
Received: from localhost (unknown [10.39.192.91])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 41F60492BE0;
	Wed, 29 Nov 2023 21:26:48 +0000 (UTC)
From: Stefan Hajnoczi <stefanha@redhat.com>
To: qemu-devel@nongnu.org
Cc: Jean-Christophe Dubois <jcd@tribudubois.net>,
	Fabiano Rosas <farosas@suse.de>,
	qemu-s390x@nongnu.org,
	Song Gao <gaosong@loongson.cn>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Thomas Huth <thuth@redhat.com>,
	Hyman Huang <yong.huang@smartx.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Andrey Smirnov <andrew.smirnov@gmail.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Kevin Wolf <kwolf@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Artyom Tarasenko <atar4qemu@gmail.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Paul Durrant <paul@xen.org>,
	Jagannathan Raman <jag.raman@oracle.com>,
	Juan Quintela <quintela@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	qemu-arm@nongnu.org,
	Jason Wang <jasowang@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	BALATON Zoltan <balaton@eik.bme.hu>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Hailiang Zhang <zhanghailiang@xfusion.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Fam Zheng <fam@euphon.net>,
	Eric Blake <eblake@redhat.com>,
	Jiri Slaby <jslaby@suse.cz>,
	Alexander Graf <agraf@csgraf.de>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Eric Farman <farman@linux.ibm.com>,
	Stafford Horne <shorne@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Cameron Esfahani <dirty@apple.com>,
	xen-devel@lists.xenproject.org,
	Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
	qemu-riscv@nongnu.org,
	Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
	John Snow <jsnow@redhat.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Michael Roth <michael.roth@amd.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Bin Meng <bin.meng@windriver.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	kvm@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>,
	qemu-block@nongnu.org,
	Halil Pasic <pasic@linux.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	Anthony Perard <anthony.perard@citrix.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	qemu-ppc@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Leonardo Bras <leobras@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 6/6] Rename "QEMU global mutex" to "BQL" in comments and docs
Date: Wed, 29 Nov 2023 16:26:25 -0500
Message-ID: <20231129212625.1051502-7-stefanha@redhat.com>
In-Reply-To: <20231129212625.1051502-1-stefanha@redhat.com>
References: <20231129212625.1051502-1-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

The term "QEMU global mutex" is identical to the more widely used Big
QEMU Lock ("BQL"). Update the code comments and documentation to use
"BQL" instead of "QEMU global mutex".

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 docs/devel/multi-thread-tcg.rst   |  7 +++----
 docs/devel/qapi-code-gen.rst      |  2 +-
 docs/devel/replay.rst             |  2 +-
 docs/devel/multiple-iothreads.txt | 16 ++++++++--------
 include/block/blockjob.h          |  6 +++---
 include/io/task.h                 |  2 +-
 include/qemu/coroutine-core.h     |  2 +-
 include/qemu/coroutine.h          |  2 +-
 hw/block/dataplane/virtio-blk.c   |  8 ++++----
 hw/block/virtio-blk.c             |  2 +-
 hw/scsi/virtio-scsi-dataplane.c   |  6 +++---
 net/tap.c                         |  2 +-
 12 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/docs/devel/multi-thread-tcg.rst b/docs/devel/multi-thread-tcg.rst
index c9541a7b20..7302c3bf53 100644
--- a/docs/devel/multi-thread-tcg.rst
+++ b/docs/devel/multi-thread-tcg.rst
@@ -226,10 +226,9 @@ instruction. This could be a future optimisation.
 Emulated hardware state
 -----------------------
 
-Currently thanks to KVM work any access to IO memory is automatically
-protected by the global iothread mutex, also known as the BQL (Big
-QEMU Lock). Any IO region that doesn't use global mutex is expected to
-do its own locking.
+Currently thanks to KVM work any access to IO memory is automatically protected
+by the BQL (Big QEMU Lock). Any IO region that doesn't use the BQL is expected
+to do its own locking.
 
 However IO memory isn't the only way emulated hardware state can be
 modified. Some architectures have model specific registers that
diff --git a/docs/devel/qapi-code-gen.rst b/docs/devel/qapi-code-gen.rst
index 7f78183cd4..ea8228518c 100644
--- a/docs/devel/qapi-code-gen.rst
+++ b/docs/devel/qapi-code-gen.rst
@@ -594,7 +594,7 @@ blocking the guest and other background operations.
 Coroutine safety can be hard to prove, similar to thread safety.  Common
 pitfalls are:
 
-- The global mutex isn't held across ``qemu_coroutine_yield()``, so
+- The BQL isn't held across ``qemu_coroutine_yield()``, so
   operations that used to assume that they execute atomically may have
   to be more careful to protect against changes in the global state.
 
diff --git a/docs/devel/replay.rst b/docs/devel/replay.rst
index 0244be8b9c..effd856f0c 100644
--- a/docs/devel/replay.rst
+++ b/docs/devel/replay.rst
@@ -184,7 +184,7 @@ modes.
 Reading and writing requests are created by CPU thread of QEMU. Later these
 requests proceed to block layer which creates "bottom halves". Bottom
 halves consist of callback and its parameters. They are processed when
-main loop locks the global mutex. These locks are not synchronized with
+main loop locks the BQL. These locks are not synchronized with
 replaying process because main loop also processes the events that do not
 affect the virtual machine state (like user interaction with monitor).
 
diff --git a/docs/devel/multiple-iothreads.txt b/docs/devel/multiple-iothreads.txt
index a3e949f6b3..828e5527a3 100644
--- a/docs/devel/multiple-iothreads.txt
+++ b/docs/devel/multiple-iothreads.txt
@@ -5,7 +5,7 @@ the COPYING file in the top-level directory.
 
 
 This document explains the IOThread feature and how to write code that runs
-outside the QEMU global mutex.
+outside the BQL.
 
 The main loop and IOThreads
 ---------------------------
@@ -29,13 +29,13 @@ scalability bottleneck on hosts with many CPUs.  Work can be spread across
 several IOThreads instead of just one main loop.  When set up correctly this
 can improve I/O latency and reduce jitter seen by the guest.
 
-The main loop is also deeply associated with the QEMU global mutex, which is a
-scalability bottleneck in itself.  vCPU threads and the main loop use the QEMU
-global mutex to serialize execution of QEMU code.  This mutex is necessary
-because a lot of QEMU's code historically was not thread-safe.
+The main loop is also deeply associated with the BQL, which is a
+scalability bottleneck in itself.  vCPU threads and the main loop use the BQL
+to serialize execution of QEMU code.  This mutex is necessary because a lot of
+QEMU's code historically was not thread-safe.
 
 The fact that all I/O processing is done in a single main loop and that the
-QEMU global mutex is contended by all vCPU threads and the main loop explain
+BQL is contended by all vCPU threads and the main loop explain
 why it is desirable to place work into IOThreads.
 
 The experimental virtio-blk data-plane implementation has been benchmarked and
@@ -66,7 +66,7 @@ There are several old APIs that use the main loop AioContext:
 
 Since they implicitly work on the main loop they cannot be used in code that
 runs in an IOThread.  They might cause a crash or deadlock if called from an
-IOThread since the QEMU global mutex is not held.
+IOThread since the BQL is not held.
 
 Instead, use the AioContext functions directly (see include/block/aio.h):
  * aio_set_fd_handler() - monitor a file descriptor
@@ -105,7 +105,7 @@ used in the block layer and can lead to hangs.
 
 There is currently no lock ordering rule if a thread needs to acquire multiple
 AioContexts simultaneously.  Therefore, it is only safe for code holding the
-QEMU global mutex to acquire other AioContexts.
+BQL to acquire other AioContexts.
 
 Side note: the best way to schedule a function call across threads is to call
 aio_bh_schedule_oneshot().  No acquire/release or locking is needed.
diff --git a/include/block/blockjob.h b/include/block/blockjob.h
index e594c10d23..b2bc7c04d6 100644
--- a/include/block/blockjob.h
+++ b/include/block/blockjob.h
@@ -54,7 +54,7 @@ typedef struct BlockJob {
 
     /**
      * Speed that was set with @block_job_set_speed.
-     * Always modified and read under QEMU global mutex (GLOBAL_STATE_CODE).
+     * Always modified and read under BQL (GLOBAL_STATE_CODE).
      */
     int64_t speed;
 
@@ -66,7 +66,7 @@ typedef struct BlockJob {
 
     /**
      * Block other operations when block job is running.
-     * Always modified and read under QEMU global mutex (GLOBAL_STATE_CODE).
+     * Always modified and read under BQL (GLOBAL_STATE_CODE).
      */
     Error *blocker;
 
@@ -89,7 +89,7 @@ typedef struct BlockJob {
 
     /**
      * BlockDriverStates that are involved in this block job.
-     * Always modified and read under QEMU global mutex (GLOBAL_STATE_CODE).
+     * Always modified and read under BQL (GLOBAL_STATE_CODE).
      */
     GSList *nodes;
 } BlockJob;
diff --git a/include/io/task.h b/include/io/task.h
index dc7d32ebd0..0b5342ee84 100644
--- a/include/io/task.h
+++ b/include/io/task.h
@@ -149,7 +149,7 @@ typedef void (*QIOTaskWorker)(QIOTask *task,
  * lookups) to be easily run non-blocking. Reporting the
  * results in the main thread context means that the caller
  * typically does not need to be concerned about thread
- * safety wrt the QEMU global mutex.
+ * safety wrt the BQL.
  *
  * For example, the socket_listen() method will block the caller
  * while DNS lookups take place if given a name, instead of IP
diff --git a/include/qemu/coroutine-core.h b/include/qemu/coroutine-core.h
index 230bb56517..503bad6e0e 100644
--- a/include/qemu/coroutine-core.h
+++ b/include/qemu/coroutine-core.h
@@ -22,7 +22,7 @@
  * rather than callbacks, for operations that need to give up control while
  * waiting for events to complete.
  *
- * These functions are re-entrant and may be used outside the global mutex.
+ * These functions are re-entrant and may be used outside the BQL.
  *
  * Functions that execute in coroutine context cannot be called
  * directly from normal functions.  Use @coroutine_fn to mark such
diff --git a/include/qemu/coroutine.h b/include/qemu/coroutine.h
index a65be6697f..e6aff45301 100644
--- a/include/qemu/coroutine.h
+++ b/include/qemu/coroutine.h
@@ -26,7 +26,7 @@
  * rather than callbacks, for operations that need to give up control while
  * waiting for events to complete.
  *
- * These functions are re-entrant and may be used outside the global mutex.
+ * These functions are re-entrant and may be used outside the BQL.
  *
  * Functions that execute in coroutine context cannot be called
  * directly from normal functions.  Use @coroutine_fn to mark such
diff --git a/hw/block/dataplane/virtio-blk.c b/hw/block/dataplane/virtio-blk.c
index f83bb0f116..eafc573407 100644
--- a/hw/block/dataplane/virtio-blk.c
+++ b/hw/block/dataplane/virtio-blk.c
@@ -47,7 +47,7 @@ void virtio_blk_data_plane_notify(VirtIOBlockDataPlane *s, VirtQueue *vq)
     virtio_notify_irqfd(s->vdev, vq);
 }
 
-/* Context: QEMU global mutex held */
+/* Context: BQL held */
 bool virtio_blk_data_plane_create(VirtIODevice *vdev, VirtIOBlkConf *conf,
                                   VirtIOBlockDataPlane **dataplane,
                                   Error **errp)
@@ -100,7 +100,7 @@ bool virtio_blk_data_plane_create(VirtIODevice *vdev, VirtIOBlkConf *conf,
     return true;
 }
 
-/* Context: QEMU global mutex held */
+/* Context: BQL held */
 void virtio_blk_data_plane_destroy(VirtIOBlockDataPlane *s)
 {
     VirtIOBlock *vblk;
@@ -117,7 +117,7 @@ void virtio_blk_data_plane_destroy(VirtIOBlockDataPlane *s)
     g_free(s);
 }
 
-/* Context: QEMU global mutex held */
+/* Context: BQL held */
 int virtio_blk_data_plane_start(VirtIODevice *vdev)
 {
     VirtIOBlock *vblk = VIRTIO_BLK(vdev);
@@ -261,7 +261,7 @@ static void virtio_blk_data_plane_stop_bh(void *opaque)
     }
 }
 
-/* Context: QEMU global mutex held */
+/* Context: BQL held */
 void virtio_blk_data_plane_stop(VirtIODevice *vdev)
 {
     VirtIOBlock *vblk = VIRTIO_BLK(vdev);
diff --git a/hw/block/virtio-blk.c b/hw/block/virtio-blk.c
index a1f8e15522..2a5f6544cc 100644
--- a/hw/block/virtio-blk.c
+++ b/hw/block/virtio-blk.c
@@ -1500,7 +1500,7 @@ static void virtio_blk_resize(void *opaque)
     VirtIODevice *vdev = VIRTIO_DEVICE(opaque);
 
     /*
-     * virtio_notify_config() needs to acquire the global mutex,
+     * virtio_notify_config() needs to acquire the BQL,
      * so it can't be called from an iothread. Instead, schedule
      * it to be run in the main context BH.
      */
diff --git a/hw/scsi/virtio-scsi-dataplane.c b/hw/scsi/virtio-scsi-dataplane.c
index 1e684beebe..56ecc5b12e 100644
--- a/hw/scsi/virtio-scsi-dataplane.c
+++ b/hw/scsi/virtio-scsi-dataplane.c
@@ -20,7 +20,7 @@
 #include "scsi/constants.h"
 #include "hw/virtio/virtio-bus.h"
 
-/* Context: QEMU global mutex held */
+/* Context: BQL held */
 void virtio_scsi_dataplane_setup(VirtIOSCSI *s, Error **errp)
 {
     VirtIOSCSICommon *vs = VIRTIO_SCSI_COMMON(s);
@@ -93,7 +93,7 @@ static void virtio_scsi_dataplane_stop_bh(void *opaque)
     }
 }
 
-/* Context: QEMU global mutex held */
+/* Context: BQL held */
 int virtio_scsi_dataplane_start(VirtIODevice *vdev)
 {
     int i;
@@ -191,7 +191,7 @@ fail_guest_notifiers:
     return -ENOSYS;
 }
 
-/* Context: QEMU global mutex held */
+/* Context: BQL held */
 void virtio_scsi_dataplane_stop(VirtIODevice *vdev)
 {
     BusState *qbus = qdev_get_parent_bus(DEVICE(vdev));
diff --git a/net/tap.c b/net/tap.c
index c23d0323c2..c698b70475 100644
--- a/net/tap.c
+++ b/net/tap.c
@@ -219,7 +219,7 @@ static void tap_send(void *opaque)
 
         /*
          * When the host keeps receiving more packets while tap_send() is
-         * running we can hog the QEMU global mutex.  Limit the number of
+         * running we can hog the BQL.  Limit the number of
          * packets that are processed per tap_send() callback to prevent
          * stalling the guest.
          */
-- 
2.42.0


