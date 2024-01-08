Return-Path: <kvm+bounces-5847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A05AD827577
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 17:39:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 140641F23967
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 16:39:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78C8854BE2;
	Mon,  8 Jan 2024 16:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RC+23aQk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C153D54BCC
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 16:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704731883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xM4VAbKYt5bBYtmHmlEyW+nGKsdcNTrQLabNpuLOZVM=;
	b=RC+23aQky9/v9zIEcEpuIaAyLRaiRRrfmlZlTgzA+Y5OyOT2CAOAOpHOwg1cT21UYL4vyq
	ljvYQRasB27myDRhm8gLe3DiV6CTkwVLyvhPLLCvqPiaVnAITdYGak1xIyNV/K+Zz1yxZ5
	m8nAWWIGTqIw4ve7cNXJIJ7eAHvXprc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-liNa4-U5MZa-6Yp1hKJKug-1; Mon, 08 Jan 2024 11:37:58 -0500
X-MC-Unique: liNa4-U5MZa-6Yp1hKJKug-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51594832D62;
	Mon,  8 Jan 2024 16:37:57 +0000 (UTC)
Received: from localhost (unknown [10.39.194.85])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CF54C2166B33;
	Mon,  8 Jan 2024 16:37:55 +0000 (UTC)
From: Stefan Hajnoczi <stefanha@redhat.com>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
	qemu-block@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	kvm@vger.kernel.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	qemu-arm@nongnu.org,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Jiri Slaby <jslaby@suse.cz>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Paul Durrant <paul@xen.org>,
	BALATON Zoltan <balaton@eik.bme.hu>,
	Kevin Wolf <kwolf@redhat.com>,
	Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	xen-devel@lists.xenproject.org,
	Anthony Perard <anthony.perard@citrix.com>,
	Weiwei Li <liwei1518@gmail.com>,
	qemu-ppc@nongnu.org,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Song Gao <gaosong@loongson.cn>,
	Aurelien Jarno <aurelien@aurel32.net>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Andrey Smirnov <andrew.smirnov@gmail.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	qemu-riscv@nongnu.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alexander Graf <agraf@csgraf.de>,
	Markus Armbruster <armbru@redhat.com>,
	John Snow <jsnow@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Stefan Weil <sw@weilnetz.de>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Hailiang Zhang <zhanghailiang@xfusion.com>,
	Hyman Huang <yong.huang@smartx.com>,
	Michael Roth <michael.roth@amd.com>,
	Fam Zheng <fam@euphon.net>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	David Gibson <david@gibson.dropbear.id.au>,
	Artyom Tarasenko <atar4qemu@gmail.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stafford Horne <shorne@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Cameron Esfahani <dirty@apple.com>,
	Eric Farman <farman@linux.ibm.com>,
	Jason Wang <jasowang@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Hanna Reitz <hreitz@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jagannathan Raman <jag.raman@oracle.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	Bin Meng <bin.meng@windriver.com>,
	Fabiano Rosas <farosas@suse.de>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PULL 6/6] Rename "QEMU global mutex" to "BQL" in comments and docs
Date: Mon,  8 Jan 2024 11:37:35 -0500
Message-ID: <20240108163735.254732-7-stefanha@redhat.com>
In-Reply-To: <20240108163735.254732-1-stefanha@redhat.com>
References: <20240108163735.254732-1-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

The term "QEMU global mutex" is identical to the more widely used Big
QEMU Lock ("BQL"). Update the code comments and documentation to use
"BQL" instead of "QEMU global mutex".

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Acked-by: Markus Armbruster <armbru@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Paul Durrant <paul@xen.org>
Reviewed-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Reviewed-by: Harsh Prateek Bora <harshpb@linux.ibm.com>
Message-id: 20240102153529.486531-6-stefanha@redhat.com
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 docs/devel/multi-thread-tcg.rst   |  7 +++----
 docs/devel/qapi-code-gen.rst      |  2 +-
 docs/devel/replay.rst             |  2 +-
 docs/devel/multiple-iothreads.txt | 14 +++++++-------
 include/block/blockjob.h          |  6 +++---
 include/io/task.h                 |  2 +-
 include/qemu/coroutine-core.h     |  2 +-
 include/qemu/coroutine.h          |  2 +-
 hw/block/dataplane/virtio-blk.c   |  8 ++++----
 hw/block/virtio-blk.c             |  2 +-
 hw/scsi/virtio-scsi-dataplane.c   |  6 +++---
 net/tap.c                         |  2 +-
 12 files changed, 27 insertions(+), 28 deletions(-)

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
index 4865196bde..de85767b12 100644
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
diff --git a/include/block/blockjob.h b/include/block/blockjob.h
index e594c10d23..7061ab7201 100644
--- a/include/block/blockjob.h
+++ b/include/block/blockjob.h
@@ -54,7 +54,7 @@ typedef struct BlockJob {
 
     /**
      * Speed that was set with @block_job_set_speed.
-     * Always modified and read under QEMU global mutex (GLOBAL_STATE_CODE).
+     * Always modified and read under the BQL (GLOBAL_STATE_CODE).
      */
     int64_t speed;
 
@@ -66,7 +66,7 @@ typedef struct BlockJob {
 
     /**
      * Block other operations when block job is running.
-     * Always modified and read under QEMU global mutex (GLOBAL_STATE_CODE).
+     * Always modified and read under the BQL (GLOBAL_STATE_CODE).
      */
     Error *blocker;
 
@@ -89,7 +89,7 @@ typedef struct BlockJob {
 
     /**
      * BlockDriverStates that are involved in this block job.
-     * Always modified and read under QEMU global mutex (GLOBAL_STATE_CODE).
+     * Always modified and read under the BQL (GLOBAL_STATE_CODE).
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
index 97a302cf49..ba22732497 100644
--- a/hw/block/dataplane/virtio-blk.c
+++ b/hw/block/dataplane/virtio-blk.c
@@ -84,7 +84,7 @@ apply_vq_mapping(IOThreadVirtQueueMappingList *iothread_vq_mapping_list,
     }
 }
 
-/* Context: QEMU global mutex held */
+/* Context: BQL held */
 bool virtio_blk_data_plane_create(VirtIODevice *vdev, VirtIOBlkConf *conf,
                                   VirtIOBlockDataPlane **dataplane,
                                   Error **errp)
@@ -148,7 +148,7 @@ bool virtio_blk_data_plane_create(VirtIODevice *vdev, VirtIOBlkConf *conf,
     return true;
 }
 
-/* Context: QEMU global mutex held */
+/* Context: BQL held */
 void virtio_blk_data_plane_destroy(VirtIOBlockDataPlane *s)
 {
     VirtIOBlock *vblk;
@@ -179,7 +179,7 @@ void virtio_blk_data_plane_destroy(VirtIOBlockDataPlane *s)
     g_free(s);
 }
 
-/* Context: QEMU global mutex held */
+/* Context: BQL held */
 int virtio_blk_data_plane_start(VirtIODevice *vdev)
 {
     VirtIOBlock *vblk = VIRTIO_BLK(vdev);
@@ -310,7 +310,7 @@ static void virtio_blk_data_plane_stop_vq_bh(void *opaque)
     virtio_queue_host_notifier_read(host_notifier);
 }
 
-/* Context: QEMU global mutex held */
+/* Context: BQL held */
 void virtio_blk_data_plane_stop(VirtIODevice *vdev)
 {
     VirtIOBlock *vblk = VIRTIO_BLK(vdev);
diff --git a/hw/block/virtio-blk.c b/hw/block/virtio-blk.c
index 315b7b364c..b7a344ca97 100644
--- a/hw/block/virtio-blk.c
+++ b/hw/block/virtio-blk.c
@@ -1539,7 +1539,7 @@ static void virtio_blk_resize(void *opaque)
     VirtIODevice *vdev = VIRTIO_DEVICE(opaque);
 
     /*
-     * virtio_notify_config() needs to acquire the global mutex,
+     * virtio_notify_config() needs to acquire the BQL,
      * so it can't be called from an iothread. Instead, schedule
      * it to be run in the main context BH.
      */
diff --git a/hw/scsi/virtio-scsi-dataplane.c b/hw/scsi/virtio-scsi-dataplane.c
index 135e23fe54..2806a121b2 100644
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
@@ -185,7 +185,7 @@ fail_guest_notifiers:
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
2.43.0


