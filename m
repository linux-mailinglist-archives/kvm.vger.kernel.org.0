Return-Path: <kvm+bounces-5846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20B29827576
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 17:38:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 57BB8B2202E
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 16:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B80353E25;
	Mon,  8 Jan 2024 16:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WD2sPYzW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3825C54BCC
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 16:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704731879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q5R88m0lIMdycowjTn/znMnJ0lu6hU6xW7ar/0WOWHk=;
	b=WD2sPYzWmnmuqdIq5iadNxjA62UQUbHnu+GeV0GjNIXhbJ9kkwkdYZmIjdL6StqX5MMver
	PTzVJsq4gmsp2uLhRka4F2bc/9UhM88GJ3kyHSJD2+/UanP6SZFzuV00c1oMiXV7bUGvuG
	0/qCmDuU80W9x2sqa2944BOMHY+RRAA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-n1nKO3YcPsyehAWXEoc_Kw-1; Mon, 08 Jan 2024 11:37:55 -0500
X-MC-Unique: n1nKO3YcPsyehAWXEoc_Kw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1081C832D65;
	Mon,  8 Jan 2024 16:37:54 +0000 (UTC)
Received: from localhost (unknown [10.39.194.85])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A6913492BF0;
	Mon,  8 Jan 2024 16:37:52 +0000 (UTC)
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
Subject: [PULL 5/6] Replace "iothread lock" with "BQL" in comments
Date: Mon,  8 Jan 2024 11:37:34 -0500
Message-ID: <20240108163735.254732-6-stefanha@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

The term "iothread lock" is obsolete. The APIs use Big QEMU Lock (BQL)
in their names. Update the code comments to use "BQL" instead of
"iothread lock".

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Paul Durrant <paul@xen.org>
Reviewed-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Reviewed-by: Harsh Prateek Bora <harshpb@linux.ibm.com>
Message-id: 20240102153529.486531-5-stefanha@redhat.com
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 docs/devel/reset.rst             |  2 +-
 hw/display/qxl.h                 |  2 +-
 include/exec/cpu-common.h        |  2 +-
 include/exec/memory.h            |  4 ++--
 include/exec/ramblock.h          |  2 +-
 include/migration/register.h     |  8 ++++----
 target/arm/internals.h           |  4 ++--
 accel/tcg/cputlb.c               |  4 ++--
 accel/tcg/tcg-accel-ops-icount.c |  2 +-
 hw/remote/mpqemu-link.c          |  2 +-
 migration/block-dirty-bitmap.c   | 10 +++++-----
 migration/block.c                | 22 +++++++++++-----------
 migration/colo.c                 |  2 +-
 migration/migration.c            |  2 +-
 migration/ram.c                  |  4 ++--
 system/physmem.c                 |  6 +++---
 target/arm/helper.c              |  2 +-
 ui/spice-core.c                  |  2 +-
 util/rcu.c                       |  2 +-
 audio/coreaudio.m                |  4 ++--
 ui/cocoa.m                       |  6 +++---
 21 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/docs/devel/reset.rst b/docs/devel/reset.rst
index 38ed1790f7..d4e79718ba 100644
--- a/docs/devel/reset.rst
+++ b/docs/devel/reset.rst
@@ -19,7 +19,7 @@ Triggering reset
 
 This section documents the APIs which "users" of a resettable object should use
 to control it. All resettable control functions must be called while holding
-the iothread lock.
+the BQL.
 
 You can apply a reset to an object using ``resettable_assert_reset()``. You need
 to call ``resettable_release_reset()`` to release the object from reset. To
diff --git a/hw/display/qxl.h b/hw/display/qxl.h
index fdac14edad..e0a85a5ca4 100644
--- a/hw/display/qxl.h
+++ b/hw/display/qxl.h
@@ -159,7 +159,7 @@ OBJECT_DECLARE_SIMPLE_TYPE(PCIQXLDevice, PCI_QXL)
  *
  * Use with care; by the time this function returns, the returned pointer is
  * not protected by RCU anymore.  If the caller is not within an RCU critical
- * section and does not hold the iothread lock, it must have other means of
+ * section and does not hold the BQL, it must have other means of
  * protecting the pointer, such as a reference to the region that includes
  * the incoming ram_addr_t.
  *
diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 41115d8919..fef3138d29 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -92,7 +92,7 @@ RAMBlock *qemu_ram_block_by_name(const char *name);
  *
  * By the time this function returns, the returned pointer is not protected
  * by RCU anymore.  If the caller is not within an RCU critical section and
- * does not hold the iothread lock, it must have other means of protecting the
+ * does not hold the BQL, it must have other means of protecting the
  * pointer, such as a reference to the memory region that owns the RAMBlock.
  */
 RAMBlock *qemu_ram_block_from_host(void *ptr, bool round_offset,
diff --git a/include/exec/memory.h b/include/exec/memory.h
index 48c11ca743..177be23db7 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -1982,7 +1982,7 @@ int memory_region_get_fd(MemoryRegion *mr);
  *
  * Use with care; by the time this function returns, the returned pointer is
  * not protected by RCU anymore.  If the caller is not within an RCU critical
- * section and does not hold the iothread lock, it must have other means of
+ * section and does not hold the BQL, it must have other means of
  * protecting the pointer, such as a reference to the region that includes
  * the incoming ram_addr_t.
  *
@@ -1999,7 +1999,7 @@ MemoryRegion *memory_region_from_host(void *ptr, ram_addr_t *offset);
  *
  * Use with care; by the time this function returns, the returned pointer is
  * not protected by RCU anymore.  If the caller is not within an RCU critical
- * section and does not hold the iothread lock, it must have other means of
+ * section and does not hold the BQL, it must have other means of
  * protecting the pointer, such as a reference to the region that includes
  * the incoming ram_addr_t.
  *
diff --git a/include/exec/ramblock.h b/include/exec/ramblock.h
index 69c6a53902..3eb79723c6 100644
--- a/include/exec/ramblock.h
+++ b/include/exec/ramblock.h
@@ -34,7 +34,7 @@ struct RAMBlock {
     ram_addr_t max_length;
     void (*resized)(const char*, uint64_t length, void *host);
     uint32_t flags;
-    /* Protected by iothread lock.  */
+    /* Protected by the BQL.  */
     char idstr[256];
     /* RCU-enabled, writes protected by the ramlist lock */
     QLIST_ENTRY(RAMBlock) next;
diff --git a/include/migration/register.h b/include/migration/register.h
index fed1d04a3c..9ab1f79512 100644
--- a/include/migration/register.h
+++ b/include/migration/register.h
@@ -17,7 +17,7 @@
 #include "hw/vmstate-if.h"
 
 typedef struct SaveVMHandlers {
-    /* This runs inside the iothread lock.  */
+    /* This runs inside the BQL.  */
     SaveStateHandler *save_state;
 
     /*
@@ -30,7 +30,7 @@ typedef struct SaveVMHandlers {
     int (*save_live_complete_postcopy)(QEMUFile *f, void *opaque);
     int (*save_live_complete_precopy)(QEMUFile *f, void *opaque);
 
-    /* This runs both outside and inside the iothread lock.  */
+    /* This runs both outside and inside the BQL.  */
     bool (*is_active)(void *opaque);
     bool (*has_postcopy)(void *opaque);
 
@@ -43,14 +43,14 @@ typedef struct SaveVMHandlers {
      */
     bool (*is_active_iterate)(void *opaque);
 
-    /* This runs outside the iothread lock in the migration case, and
+    /* This runs outside the BQL in the migration case, and
      * within the lock in the savevm case.  The callback had better only
      * use data that is local to the migration thread or protected
      * by other locks.
      */
     int (*save_live_iterate)(QEMUFile *f, void *opaque);
 
-    /* This runs outside the iothread lock!  */
+    /* This runs outside the BQL!  */
     /* Note for save_live_pending:
      * must_precopy:
      * - must be migrated in precopy or in stopped state
diff --git a/target/arm/internals.h b/target/arm/internals.h
index 143d57c0fe..71d6c70bf3 100644
--- a/target/arm/internals.h
+++ b/target/arm/internals.h
@@ -940,7 +940,7 @@ static inline const char *aarch32_mode_name(uint32_t psr)
  *
  * Update the CPU_INTERRUPT_VIRQ bit in cs->interrupt_request, following
  * a change to either the input VIRQ line from the GIC or the HCR_EL2.VI bit.
- * Must be called with the iothread lock held.
+ * Must be called with the BQL held.
  */
 void arm_cpu_update_virq(ARMCPU *cpu);
 
@@ -949,7 +949,7 @@ void arm_cpu_update_virq(ARMCPU *cpu);
  *
  * Update the CPU_INTERRUPT_VFIQ bit in cs->interrupt_request, following
  * a change to either the input VFIQ line from the GIC or the HCR_EL2.VF bit.
- * Must be called with the iothread lock held.
+ * Must be called with the BQL held.
  */
 void arm_cpu_update_vfiq(ARMCPU *cpu);
 
diff --git a/accel/tcg/cputlb.c b/accel/tcg/cputlb.c
index 5698a9fd8e..3facfcbb24 100644
--- a/accel/tcg/cputlb.c
+++ b/accel/tcg/cputlb.c
@@ -1975,7 +1975,7 @@ static void *atomic_mmu_lookup(CPUState *cpu, vaddr addr, MemOpIdx oi,
  * @size: number of bytes
  * @mmu_idx: virtual address context
  * @ra: return address into tcg generated code, or 0
- * Context: iothread lock held
+ * Context: BQL held
  *
  * Load @size bytes from @addr, which is memory-mapped i/o.
  * The bytes are concatenated in big-endian order with @ret_be.
@@ -2521,7 +2521,7 @@ static Int128 do_ld16_mmu(CPUState *cpu, vaddr addr,
  * @size: number of bytes
  * @mmu_idx: virtual address context
  * @ra: return address into tcg generated code, or 0
- * Context: iothread lock held
+ * Context: BQL held
  *
  * Store @size bytes at @addr, which is memory-mapped i/o.
  * The bytes to store are extracted in little-endian order from @val_le;
diff --git a/accel/tcg/tcg-accel-ops-icount.c b/accel/tcg/tcg-accel-ops-icount.c
index 5824d92580..9e1ae66f65 100644
--- a/accel/tcg/tcg-accel-ops-icount.c
+++ b/accel/tcg/tcg-accel-ops-icount.c
@@ -123,7 +123,7 @@ void icount_prepare_for_run(CPUState *cpu, int64_t cpu_budget)
 
     if (cpu->icount_budget == 0) {
         /*
-         * We're called without the iothread lock, so must take it while
+         * We're called without the BQL, so must take it while
          * we're calling timer handlers.
          */
         bql_lock();
diff --git a/hw/remote/mpqemu-link.c b/hw/remote/mpqemu-link.c
index d04ac93621..4394dc4d82 100644
--- a/hw/remote/mpqemu-link.c
+++ b/hw/remote/mpqemu-link.c
@@ -58,7 +58,7 @@ bool mpqemu_msg_send(MPQemuMsg *msg, QIOChannel *ioc, Error **errp)
     assert(qemu_in_coroutine() || !iothread);
 
     /*
-     * Skip unlocking/locking iothread lock when the IOThread is running
+     * Skip unlocking/locking BQL when the IOThread is running
      * in co-routine context. Co-routine context is asserted above
      * for IOThread case.
      * Also skip lock handling while in a co-routine in the main context.
diff --git a/migration/block-dirty-bitmap.c b/migration/block-dirty-bitmap.c
index 92e031b6fa..2708abf3d7 100644
--- a/migration/block-dirty-bitmap.c
+++ b/migration/block-dirty-bitmap.c
@@ -464,7 +464,7 @@ static void send_bitmap_bits(QEMUFile *f, DBMSaveState *s,
     g_free(buf);
 }
 
-/* Called with iothread lock taken.  */
+/* Called with the BQL taken.  */
 static void dirty_bitmap_do_save_cleanup(DBMSaveState *s)
 {
     SaveBitmapState *dbms;
@@ -479,7 +479,7 @@ static void dirty_bitmap_do_save_cleanup(DBMSaveState *s)
     }
 }
 
-/* Called with iothread lock taken. */
+/* Called with the BQL taken. */
 static int add_bitmaps_to_list(DBMSaveState *s, BlockDriverState *bs,
                                const char *bs_name, GHashTable *alias_map)
 {
@@ -598,7 +598,7 @@ static int add_bitmaps_to_list(DBMSaveState *s, BlockDriverState *bs,
     return 0;
 }
 
-/* Called with iothread lock taken. */
+/* Called with the BQL taken. */
 static int init_dirty_bitmap_migration(DBMSaveState *s)
 {
     BlockDriverState *bs;
@@ -607,7 +607,7 @@ static int init_dirty_bitmap_migration(DBMSaveState *s)
     BlockBackend *blk;
     GHashTable *alias_map = NULL;
 
-    /* Runs in the migration thread, but holds the iothread lock */
+    /* Runs in the migration thread, but holds the BQL */
     GLOBAL_STATE_CODE();
     GRAPH_RDLOCK_GUARD_MAINLOOP();
 
@@ -742,7 +742,7 @@ static int dirty_bitmap_save_iterate(QEMUFile *f, void *opaque)
     return s->bulk_completed;
 }
 
-/* Called with iothread lock taken.  */
+/* Called with the BQL taken.  */
 
 static int dirty_bitmap_save_complete(QEMUFile *f, void *opaque)
 {
diff --git a/migration/block.c b/migration/block.c
index b731d7d778..8c6ebafacc 100644
--- a/migration/block.c
+++ b/migration/block.c
@@ -101,7 +101,7 @@ typedef struct BlkMigState {
     int prev_progress;
     int bulk_completed;
 
-    /* Lock must be taken _inside_ the iothread lock.  */
+    /* Lock must be taken _inside_ the BQL.  */
     QemuMutex lock;
 } BlkMigState;
 
@@ -117,7 +117,7 @@ static void blk_mig_unlock(void)
     qemu_mutex_unlock(&block_mig_state.lock);
 }
 
-/* Must run outside of the iothread lock during the bulk phase,
+/* Must run outside of the BQL during the bulk phase,
  * or the VM will stall.
  */
 
@@ -327,7 +327,7 @@ static int mig_save_device_bulk(QEMUFile *f, BlkMigDevState *bmds)
     return (bmds->cur_sector >= total_sectors);
 }
 
-/* Called with iothread lock taken.  */
+/* Called with the BQL taken.  */
 
 static int set_dirty_tracking(void)
 {
@@ -354,7 +354,7 @@ fail:
     return ret;
 }
 
-/* Called with iothread lock taken.  */
+/* Called with the BQL taken.  */
 
 static void unset_dirty_tracking(void)
 {
@@ -505,7 +505,7 @@ static void blk_mig_reset_dirty_cursor(void)
     }
 }
 
-/* Called with iothread lock taken.  */
+/* Called with the BQL taken.  */
 
 static int mig_save_device_dirty(QEMUFile *f, BlkMigDevState *bmds,
                                  int is_async)
@@ -587,7 +587,7 @@ error:
     return ret;
 }
 
-/* Called with iothread lock taken.
+/* Called with the BQL taken.
  *
  * return value:
  * 0: too much data for max_downtime
@@ -649,7 +649,7 @@ static int flush_blks(QEMUFile *f)
     return ret;
 }
 
-/* Called with iothread lock taken.  */
+/* Called with the BQL taken.  */
 
 static int64_t get_remaining_dirty(void)
 {
@@ -667,7 +667,7 @@ static int64_t get_remaining_dirty(void)
 
 
 
-/* Called with iothread lock taken.  */
+/* Called with the BQL taken.  */
 static void block_migration_cleanup_bmds(void)
 {
     BlkMigDevState *bmds;
@@ -690,7 +690,7 @@ static void block_migration_cleanup_bmds(void)
     }
 }
 
-/* Called with iothread lock taken.  */
+/* Called with the BQL taken.  */
 static void block_migration_cleanup(void *opaque)
 {
     BlkMigBlock *blk;
@@ -767,7 +767,7 @@ static int block_save_iterate(QEMUFile *f, void *opaque)
             }
             ret = 0;
         } else {
-            /* Always called with iothread lock taken for
+            /* Always called with the BQL taken for
              * simplicity, block_save_complete also calls it.
              */
             bql_lock();
@@ -795,7 +795,7 @@ static int block_save_iterate(QEMUFile *f, void *opaque)
     return (delta_bytes > 0);
 }
 
-/* Called with iothread lock taken.  */
+/* Called with the BQL taken.  */
 
 static int block_save_complete(QEMUFile *f, void *opaque)
 {
diff --git a/migration/colo.c b/migration/colo.c
index 2a74efdd77..315e31fe32 100644
--- a/migration/colo.c
+++ b/migration/colo.c
@@ -945,7 +945,7 @@ int coroutine_fn colo_incoming_co(void)
     qemu_thread_join(&th);
     bql_lock();
 
-    /* We hold the global iothread lock, so it is safe here */
+    /* We hold the global BQL, so it is safe here */
     colo_release_ram_cache();
 
     return 0;
diff --git a/migration/migration.c b/migration/migration.c
index be173cd0f9..98c5c3e140 100644
--- a/migration/migration.c
+++ b/migration/migration.c
@@ -2551,7 +2551,7 @@ fail:
 
 /**
  * migration_maybe_pause: Pause if required to by
- * migrate_pause_before_switchover called with the iothread locked
+ * migrate_pause_before_switchover called with the BQL locked
  * Returns: 0 on success
  */
 static int migration_maybe_pause(MigrationState *s,
diff --git a/migration/ram.c b/migration/ram.c
index 08dc7e2909..890f31cf66 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -2395,7 +2395,7 @@ static void ram_save_cleanup(void *opaque)
 
     /* We don't use dirty log with background snapshots */
     if (!migrate_background_snapshot()) {
-        /* caller have hold iothread lock or is in a bh, so there is
+        /* caller have hold BQL or is in a bh, so there is
          * no writing race against the migration bitmap
          */
         if (global_dirty_tracking & GLOBAL_DIRTY_MIGRATION) {
@@ -3131,7 +3131,7 @@ out:
  *
  * Returns zero to indicate success or negative on error
  *
- * Called with iothread lock
+ * Called with the BQL
  *
  * @f: QEMUFile where to send the data
  * @opaque: RAMState pointer
diff --git a/system/physmem.c b/system/physmem.c
index 4937e67bad..cc68a79763 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -799,7 +799,7 @@ static RAMBlock *qemu_get_ram_block(ram_addr_t addr)
     abort();
 
 found:
-    /* It is safe to write mru_block outside the iothread lock.  This
+    /* It is safe to write mru_block outside the BQL.  This
      * is what happens:
      *
      *     mru_block = xxx
@@ -1597,7 +1597,7 @@ int qemu_ram_get_fd(RAMBlock *rb)
     return rb->fd;
 }
 
-/* Called with iothread lock held.  */
+/* Called with the BQL held.  */
 void qemu_ram_set_idstr(RAMBlock *new_block, const char *name, DeviceState *dev)
 {
     RAMBlock *block;
@@ -1625,7 +1625,7 @@ void qemu_ram_set_idstr(RAMBlock *new_block, const char *name, DeviceState *dev)
     }
 }
 
-/* Called with iothread lock held.  */
+/* Called with the BQL held.  */
 void qemu_ram_unset_idstr(RAMBlock *block)
 {
     /* FIXME: arch_init.c assumes that this is not called throughout
diff --git a/target/arm/helper.c b/target/arm/helper.c
index 7dfd0a1094..7889fd45d6 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -5844,7 +5844,7 @@ static void do_hcr_write(CPUARMState *env, uint64_t value, uint64_t valid_mask)
      * Updates to VI and VF require us to update the status of
      * virtual interrupts, which are the logical OR of these bits
      * and the state of the input lines from the GIC. (This requires
-     * that we have the iothread lock, which is done by marking the
+     * that we have the BQL, which is done by marking the
      * reginfo structs as ARM_CP_IO.)
      * Note that if a write to HCR pends a VIRQ or VFIQ it is never
      * possible for it to be taken immediately, because VIRQ and
diff --git a/ui/spice-core.c b/ui/spice-core.c
index b6ee495a8f..37b277fd09 100644
--- a/ui/spice-core.c
+++ b/ui/spice-core.c
@@ -217,7 +217,7 @@ static void channel_event(int event, SpiceChannelEventInfo *info)
      * not do that.  It isn't that easy to fix it in spice and even
      * when it is fixed we still should cover the already released
      * spice versions.  So detect that we've been called from another
-     * thread and grab the iothread lock if so before calling qemu
+     * thread and grab the BQL if so before calling qemu
      * functions.
      */
     bool need_lock = !qemu_thread_is_self(&me);
diff --git a/util/rcu.c b/util/rcu.c
index bb7f633b5c..fa32c942e4 100644
--- a/util/rcu.c
+++ b/util/rcu.c
@@ -409,7 +409,7 @@ static void rcu_init_complete(void)
 
     qemu_event_init(&rcu_call_ready_event, false);
 
-    /* The caller is assumed to have iothread lock, so the call_rcu thread
+    /* The caller is assumed to have BQL, so the call_rcu thread
      * must have been quiescent even after forking, just recreate it.
      */
     qemu_thread_create(&thread, "call_rcu", call_rcu_thread,
diff --git a/audio/coreaudio.m b/audio/coreaudio.m
index 9d2db9883c..ab632b9bbb 100644
--- a/audio/coreaudio.m
+++ b/audio/coreaudio.m
@@ -299,7 +299,7 @@ static ret_type glue(coreaudio_, name)args_decl             \
 #undef COREAUDIO_WRAPPER_FUNC
 
 /*
- * callback to feed audiooutput buffer. called without iothread lock.
+ * callback to feed audiooutput buffer. called without BQL.
  * allowed to lock "buf_mutex", but disallowed to have any other locks.
  */
 static OSStatus audioDeviceIOProc(
@@ -538,7 +538,7 @@ static void update_device_playback_state(coreaudioVoiceOut *core)
     }
 }
 
-/* called without iothread lock. */
+/* called without BQL. */
 static OSStatus handle_voice_change(
     AudioObjectID in_object_id,
     UInt32 in_number_addresses,
diff --git a/ui/cocoa.m b/ui/cocoa.m
index 5ebb535070..eb99064bee 100644
--- a/ui/cocoa.m
+++ b/ui/cocoa.m
@@ -113,7 +113,7 @@ static void cocoa_switch(DisplayChangeListener *dcl,
 static QemuClipboardInfo *cbinfo;
 static QemuEvent cbevent;
 
-// Utility functions to run specified code block with iothread lock held
+// Utility functions to run specified code block with the BQL held
 typedef void (^CodeBlock)(void);
 typedef bool (^BoolCodeBlock)(void);
 
@@ -548,7 +548,7 @@ - (void) setContentDimensions
 
 - (void) updateUIInfoLocked
 {
-    /* Must be called with the iothread lock, i.e. via updateUIInfo */
+    /* Must be called with the BQL, i.e. via updateUIInfo */
     NSSize frameSize;
     QemuUIInfo info;
 
@@ -2075,7 +2075,7 @@ static void cocoa_display_init(DisplayState *ds, DisplayOptions *opts)
      * Create the menu entries which depend on QEMU state (for consoles
      * and removable devices). These make calls back into QEMU functions,
      * which is OK because at this point we know that the second thread
-     * holds the iothread lock and is synchronously waiting for us to
+     * holds the BQL and is synchronously waiting for us to
      * finish.
      */
     add_console_menu_entries();
-- 
2.43.0


