Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63BFE4E55D6
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 16:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245341AbiCWQBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 12:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiCWQBN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 12:01:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E3F287B113
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 08:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648051179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o50NJwR5mgZsamaAapDbxJAQbABUft0T0AVGmtxJbJ4=;
        b=Ht5YyrTDZR2xeNX9ivbLlreg13kM7Bo1FSDQwscC7BmCj9VPbjYYuuW/BMI+ZMaKokyKoR
        ZWa4ekqihgxgwYZ0C+OrA+GR9Ouix34ko+FeWZSCd0FbWBjg7H8/rCh/oc6xdOnMNXgNO4
        YS6GxzkHCrGZRxIWY97904QEONQaiws=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-319-OKWhc8r8M_CI5BdpsK56lg-1; Wed, 23 Mar 2022 11:59:35 -0400
X-MC-Unique: OKWhc8r8M_CI5BdpsK56lg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 097FF802C16;
        Wed, 23 Mar 2022 15:59:34 +0000 (UTC)
Received: from localhost (unknown [10.39.208.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 023C84B8D43;
        Wed, 23 Mar 2022 15:59:30 +0000 (UTC)
From:   marcandre.lureau@redhat.com
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        "Denis V. Lunev" <den@openvz.org>,
        Vladimir Sementsov-Ogievskiy <v.sementsov-og@mail.ru>,
        Warner Losh <imp@bsdimp.com>, Kyle Evans <kevans@freebsd.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>,
        Yuval Shaia <yuval.shaia.ml@gmail.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Colin Xu <colin.xu@intel.com>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Stefan Weil <sw@weilnetz.de>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs),
        qemu-block@nongnu.org (open list:Block layer core),
        qemu-s390x@nongnu.org (open list:S390 general arch...),
        qemu-ppc@nongnu.org (open list:New World (mac99)),
        haxm-team@intel.com (open list:X86 HAXM CPUs)
Subject: [PATCH 11/32] Replace qemu_real_host_page variables with inlined functions
Date:   Wed, 23 Mar 2022 19:57:22 +0400
Message-Id: <20220323155743.1585078-12-marcandre.lureau@redhat.com>
In-Reply-To: <20220323155743.1585078-1-marcandre.lureau@redhat.com>
References: <20220323155743.1585078-1-marcandre.lureau@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc-André Lureau <marcandre.lureau@redhat.com>

Replace the global variables with inlined helper functions. getpagesize() is very
likely annotated with a "const" function attribute (at least with glibc), and thus
optimization should apply even better.

This avoids the need for a constructor initialization too.

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
---
 include/exec/cpu-common.h          |  2 +-
 include/exec/ram_addr.h            |  2 +-
 include/qemu/osdep.h               | 15 +++++++++++----
 accel/hvf/hvf-accel-ops.c          |  2 +-
 accel/kvm/kvm-all.c                | 20 ++++++++++----------
 backends/hostmem.c                 |  2 +-
 block.c                            |  4 ++--
 block/file-posix.c                 |  6 +++---
 block/io.c                         |  2 +-
 block/nvme.c                       | 22 +++++++++++-----------
 block/parallels.c                  |  2 +-
 block/qcow2-cache.c                |  2 +-
 bsd-user/elfload.c                 |  2 +-
 bsd-user/mmap.c                    |  2 +-
 contrib/vhost-user-gpu/vugbm.c     |  2 +-
 cpu.c                              |  2 +-
 hw/display/qxl.c                   |  2 +-
 hw/intc/s390_flic_kvm.c            |  2 +-
 hw/nvram/fw_cfg.c                  |  6 +++---
 hw/ppc/mac_newworld.c              |  2 +-
 hw/ppc/spapr_pci.c                 |  2 +-
 hw/rdma/vmw/pvrdma_main.c          |  2 +-
 hw/scsi/scsi-generic.c             |  2 +-
 hw/tpm/tpm_ppi.c                   |  2 +-
 hw/vfio/common.c                   | 24 ++++++++++++------------
 hw/vfio/pci.c                      | 10 +++++-----
 hw/vfio/spapr.c                    |  8 ++++----
 hw/virtio/vhost-iova-tree.c        |  4 ++--
 hw/virtio/vhost-shadow-virtqueue.c |  8 ++++----
 hw/virtio/vhost-user.c             |  4 ++--
 hw/virtio/vhost-vdpa.c             |  6 +++---
 hw/virtio/virtio-mem.c             | 10 +++++-----
 linux-user/elfload.c               |  4 ++--
 linux-user/mmap.c                  |  2 +-
 migration/migration.c              |  2 +-
 migration/postcopy-ram.c           |  4 ++--
 monitor/misc.c                     |  2 +-
 softmmu/physmem.c                  |  6 +++---
 target/i386/hax/hax-mem.c          | 10 +++++-----
 target/i386/nvmm/nvmm-all.c        |  8 ++++----
 target/i386/whpx/whpx-all.c        |  8 ++++----
 target/ppc/kvm.c                   |  2 +-
 tcg/region.c                       |  8 ++++----
 tests/vhost-user-bridge.c          |  8 ++++----
 util/cutils.c                      |  4 ++--
 util/mmap-alloc.c                  | 10 +++++-----
 util/osdep.c                       |  4 ++--
 util/oslib-posix.c                 |  8 ++++----
 util/oslib-win32.c                 |  2 +-
 util/pagesize.c                    | 18 ------------------
 util/vfio-helpers.c                | 14 +++++++-------
 scripts/checkpatch.pl              |  4 ++--
 util/meson.build                   |  1 -
 53 files changed, 150 insertions(+), 162 deletions(-)
 delete mode 100644 util/pagesize.c

diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index c7d50fac955c..5979fc1f8e1b 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -26,7 +26,7 @@ extern uintptr_t qemu_host_page_size;
 extern intptr_t qemu_host_page_mask;
 
 #define HOST_PAGE_ALIGN(addr) ROUND_UP((addr), qemu_host_page_size)
-#define REAL_HOST_PAGE_ALIGN(addr) ROUND_UP((addr), qemu_real_host_page_size)
+#define REAL_HOST_PAGE_ALIGN(addr) ROUND_UP((addr), qemu_real_host_page_size())
 
 /* The CPU list lock nests outside page_(un)lock or mmap_(un)lock */
 void qemu_init_cpu_list(void);
diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
index 64fb936c7c74..f3e0c78161d1 100644
--- a/include/exec/ram_addr.h
+++ b/include/exec/ram_addr.h
@@ -343,7 +343,7 @@ static inline void cpu_physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
     hwaddr addr;
     ram_addr_t ram_addr;
     unsigned long len = (pages + HOST_LONG_BITS - 1) / HOST_LONG_BITS;
-    unsigned long hpratio = qemu_real_host_page_size / TARGET_PAGE_SIZE;
+    unsigned long hpratio = qemu_real_host_page_size() / TARGET_PAGE_SIZE;
     unsigned long page = BIT_WORD(start >> TARGET_PAGE_BITS);
 
     /* start address is aligned at the start of a word? */
diff --git a/include/qemu/osdep.h b/include/qemu/osdep.h
index 95a14914d13b..240b48707ecc 100644
--- a/include/qemu/osdep.h
+++ b/include/qemu/osdep.h
@@ -431,9 +431,9 @@ extern int madvise(char *, size_t, int);
    /* Use 1 MiB (segment size) alignment so gmap can be used by KVM. */
 #  define QEMU_VMALLOC_ALIGN (256 * 4096)
 #elif defined(__linux__) && defined(__sparc__)
-#  define QEMU_VMALLOC_ALIGN MAX(qemu_real_host_page_size, SHMLBA)
+#  define QEMU_VMALLOC_ALIGN MAX(qemu_real_host_page_size(), SHMLBA)
 #else
-#  define QEMU_VMALLOC_ALIGN qemu_real_host_page_size
+#  define QEMU_VMALLOC_ALIGN qemu_real_host_page_size()
 #endif
 
 #ifdef CONFIG_POSIX
@@ -590,8 +590,15 @@ pid_t qemu_fork(Error **errp);
 /* Using intptr_t ensures that qemu_*_page_mask is sign-extended even
  * when intptr_t is 32-bit and we are aligning a long long.
  */
-extern uintptr_t qemu_real_host_page_size;
-extern intptr_t qemu_real_host_page_mask;
+static inline uintptr_t qemu_real_host_page_size(void)
+{
+    return getpagesize();
+}
+
+static inline intptr_t qemu_real_host_page_mask(void)
+{
+    return -(intptr_t)qemu_real_host_page_size();
+}
 
 /*
  * After using getopt or getopt_long, if you need to parse another set
diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index 54457c76c2f3..a70e2eb375dc 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -122,7 +122,7 @@ static void hvf_set_phys_mem(MemoryRegionSection *section, bool add)
     MemoryRegion *area = section->mr;
     bool writeable = !area->readonly && !area->rom_device;
     hv_memory_flags_t flags;
-    uint64_t page_size = qemu_real_host_page_size;
+    uint64_t page_size = qemu_real_host_page_size();
 
     if (!memory_region_is_ram(area)) {
         if (writeable) {
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 8d9d2367ee02..32e177bd26b4 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -59,7 +59,7 @@
 #ifdef PAGE_SIZE
 #undef PAGE_SIZE
 #endif
-#define PAGE_SIZE qemu_real_host_page_size
+#define PAGE_SIZE qemu_real_host_page_size()
 
 #ifndef KVM_GUESTDBG_BLOCKIRQ
 #define KVM_GUESTDBG_BLOCKIRQ 0
@@ -324,14 +324,14 @@ static hwaddr kvm_align_section(MemoryRegionSection *section,
        with sub-page size and unaligned start address. Pad the start
        address to next and truncate size to previous page boundary. */
     aligned = ROUND_UP(section->offset_within_address_space,
-                       qemu_real_host_page_size);
+                       qemu_real_host_page_size());
     delta = aligned - section->offset_within_address_space;
     *start = aligned;
     if (delta > size) {
         return 0;
     }
 
-    return (size - delta) & qemu_real_host_page_mask;
+    return (size - delta) & qemu_real_host_page_mask();
 }
 
 int kvm_physical_memory_addr_from_host(KVMState *s, void *ram,
@@ -626,7 +626,7 @@ static void kvm_log_stop(MemoryListener *listener,
 static void kvm_slot_sync_dirty_pages(KVMSlot *slot)
 {
     ram_addr_t start = slot->ram_start_offset;
-    ram_addr_t pages = slot->memory_size / qemu_real_host_page_size;
+    ram_addr_t pages = slot->memory_size / qemu_real_host_page_size();
 
     cpu_physical_memory_set_dirty_lebitmap(slot->dirty_bmap, start, pages);
 }
@@ -662,7 +662,7 @@ static void kvm_slot_init_dirty_bitmap(KVMSlot *mem)
      * And mem->memory_size is aligned to it (otherwise this mem can't
      * be registered to KVM).
      */
-    hwaddr bitmap_size = ALIGN(mem->memory_size / qemu_real_host_page_size,
+    hwaddr bitmap_size = ALIGN(mem->memory_size / qemu_real_host_page_size(),
                                         /*HOST_LONG_BITS*/ 64) / 8;
     mem->dirty_bmap = g_malloc0(bitmap_size);
     mem->dirty_bmap_size = bitmap_size;
@@ -707,7 +707,7 @@ static void kvm_dirty_ring_mark_page(KVMState *s, uint32_t as_id,
     mem = &kml->slots[slot_id];
 
     if (!mem->memory_size || offset >=
-        (mem->memory_size / qemu_real_host_page_size)) {
+        (mem->memory_size / qemu_real_host_page_size())) {
         return;
     }
 
@@ -895,7 +895,7 @@ static void kvm_physical_sync_dirty_bitmap(KVMMemoryListener *kml,
 
 /* Alignment requirement for KVM_CLEAR_DIRTY_LOG - 64 pages */
 #define KVM_CLEAR_LOG_SHIFT  6
-#define KVM_CLEAR_LOG_ALIGN  (qemu_real_host_page_size << KVM_CLEAR_LOG_SHIFT)
+#define KVM_CLEAR_LOG_ALIGN  (qemu_real_host_page_size() << KVM_CLEAR_LOG_SHIFT)
 #define KVM_CLEAR_LOG_MASK   (-KVM_CLEAR_LOG_ALIGN)
 
 static int kvm_log_clear_one_slot(KVMSlot *mem, int as_id, uint64_t start,
@@ -904,7 +904,7 @@ static int kvm_log_clear_one_slot(KVMSlot *mem, int as_id, uint64_t start,
     KVMState *s = kvm_state;
     uint64_t end, bmap_start, start_delta, bmap_npages;
     struct kvm_clear_dirty_log d;
-    unsigned long *bmap_clear = NULL, psize = qemu_real_host_page_size;
+    unsigned long *bmap_clear = NULL, psize = qemu_real_host_page_size();
     int ret;
 
     /*
@@ -1335,7 +1335,7 @@ kvm_check_extension_list(KVMState *s, const KVMCapabilityInfo *list)
 void kvm_set_max_memslot_size(hwaddr max_slot_size)
 {
     g_assert(
-        ROUND_UP(max_slot_size, qemu_real_host_page_size) == max_slot_size
+        ROUND_UP(max_slot_size, qemu_real_host_page_size()) == max_slot_size
     );
     kvm_max_slot_size = max_slot_size;
 }
@@ -2341,7 +2341,7 @@ static int kvm_init(MachineState *ms)
      * even with KVM.  TARGET_PAGE_SIZE is assumed to be the minimum
      * page size for the system though.
      */
-    assert(TARGET_PAGE_SIZE <= qemu_real_host_page_size);
+    assert(TARGET_PAGE_SIZE <= qemu_real_host_page_size());
 
     s->sigmask_len = 8;
 
diff --git a/backends/hostmem.c b/backends/hostmem.c
index b2a5e905e866..a7bae3d713c9 100644
--- a/backends/hostmem.c
+++ b/backends/hostmem.c
@@ -319,7 +319,7 @@ size_t host_memory_backend_pagesize(HostMemoryBackend *memdev)
 #else
 size_t host_memory_backend_pagesize(HostMemoryBackend *memdev)
 {
-    return qemu_real_host_page_size;
+    return qemu_real_host_page_size();
 }
 #endif
 
diff --git a/block.c b/block.c
index 718e4cae8b3a..8cd16e757e32 100644
--- a/block.c
+++ b/block.c
@@ -135,7 +135,7 @@ size_t bdrv_opt_mem_align(BlockDriverState *bs)
 {
     if (!bs || !bs->drv) {
         /* page size or 4k (hdd sector size) should be on the safe side */
-        return MAX(4096, qemu_real_host_page_size);
+        return MAX(4096, qemu_real_host_page_size());
     }
     IO_CODE();
 
@@ -146,7 +146,7 @@ size_t bdrv_min_mem_align(BlockDriverState *bs)
 {
     if (!bs || !bs->drv) {
         /* page size or 4k (hdd sector size) should be on the safe side */
-        return MAX(4096, qemu_real_host_page_size);
+        return MAX(4096, qemu_real_host_page_size());
     }
     IO_CODE();
 
diff --git a/block/file-posix.c b/block/file-posix.c
index 39a3d6dbe6e2..61b02d85ebf1 100644
--- a/block/file-posix.c
+++ b/block/file-posix.c
@@ -386,7 +386,7 @@ static void raw_probe_alignment(BlockDriverState *bs, int fd, Error **errp)
 {
     BDRVRawState *s = bs->opaque;
     char *buf;
-    size_t max_align = MAX(MAX_BLOCKSIZE, qemu_real_host_page_size);
+    size_t max_align = MAX(MAX_BLOCKSIZE, qemu_real_host_page_size());
     size_t alignments[] = {1, 512, 1024, 2048, 4096};
 
     /* For SCSI generic devices the alignment is not really used.
@@ -1261,7 +1261,7 @@ static void raw_refresh_limits(BlockDriverState *bs, Error **errp)
     raw_probe_alignment(bs, s->fd, errp);
 
     bs->bl.min_mem_alignment = s->buf_align;
-    bs->bl.opt_mem_alignment = MAX(s->buf_align, qemu_real_host_page_size);
+    bs->bl.opt_mem_alignment = MAX(s->buf_align, qemu_real_host_page_size());
 
     /*
      * Maximum transfers are best effort, so it is okay to ignore any
@@ -1886,7 +1886,7 @@ static int allocate_first_block(int fd, size_t max_size)
     size_t write_size = (max_size < MAX_BLOCKSIZE)
         ? BDRV_SECTOR_SIZE
         : MAX_BLOCKSIZE;
-    size_t max_align = MAX(MAX_BLOCKSIZE, qemu_real_host_page_size);
+    size_t max_align = MAX(MAX_BLOCKSIZE, qemu_real_host_page_size());
     void *buf;
     ssize_t n;
     int ret;
diff --git a/block/io.c b/block/io.c
index 3280144a17d4..9769ec53b0ee 100644
--- a/block/io.c
+++ b/block/io.c
@@ -201,7 +201,7 @@ void bdrv_refresh_limits(BlockDriverState *bs, Transaction *tran, Error **errp)
 
     if (!have_limits) {
         bs->bl.min_mem_alignment = 512;
-        bs->bl.opt_mem_alignment = qemu_real_host_page_size;
+        bs->bl.opt_mem_alignment = qemu_real_host_page_size();
 
         /* Safe default since most protocols use readv()/writev()/etc */
         bs->bl.max_iov = IOV_MAX;
diff --git a/block/nvme.c b/block/nvme.c
index 552029931d59..01fb28aa638b 100644
--- a/block/nvme.c
+++ b/block/nvme.c
@@ -169,9 +169,9 @@ static bool nvme_init_queue(BDRVNVMeState *s, NVMeQueue *q,
     size_t bytes;
     int r;
 
-    bytes = ROUND_UP(nentries * entry_bytes, qemu_real_host_page_size);
+    bytes = ROUND_UP(nentries * entry_bytes, qemu_real_host_page_size());
     q->head = q->tail = 0;
-    q->queue = qemu_try_memalign(qemu_real_host_page_size, bytes);
+    q->queue = qemu_try_memalign(qemu_real_host_page_size(), bytes);
     if (!q->queue) {
         error_setg(errp, "Cannot allocate queue");
         return false;
@@ -232,8 +232,8 @@ static NVMeQueuePair *nvme_create_queue_pair(BDRVNVMeState *s,
     trace_nvme_create_queue_pair(idx, q, size, aio_context,
                                  event_notifier_get_fd(s->irq_notifier));
     bytes = QEMU_ALIGN_UP(s->page_size * NVME_NUM_REQS,
-                          qemu_real_host_page_size);
-    q->prp_list_pages = qemu_try_memalign(qemu_real_host_page_size, bytes);
+                          qemu_real_host_page_size());
+    q->prp_list_pages = qemu_try_memalign(qemu_real_host_page_size(), bytes);
     if (!q->prp_list_pages) {
         error_setg(errp, "Cannot allocate PRP page list");
         goto fail;
@@ -533,9 +533,9 @@ static bool nvme_identify(BlockDriverState *bs, int namespace, Error **errp)
         .opcode = NVME_ADM_CMD_IDENTIFY,
         .cdw10 = cpu_to_le32(0x1),
     };
-    size_t id_size = QEMU_ALIGN_UP(sizeof(*id), qemu_real_host_page_size);
+    size_t id_size = QEMU_ALIGN_UP(sizeof(*id), qemu_real_host_page_size());
 
-    id = qemu_try_memalign(qemu_real_host_page_size, id_size);
+    id = qemu_try_memalign(qemu_real_host_page_size(), id_size);
     if (!id) {
         error_setg(errp, "Cannot allocate buffer for identify response");
         goto out;
@@ -1048,7 +1048,7 @@ static coroutine_fn int nvme_cmd_map_qiov(BlockDriverState *bs, NvmeCmd *cmd,
         bool retry = true;
         uint64_t iova;
         size_t len = QEMU_ALIGN_UP(qiov->iov[i].iov_len,
-                                   qemu_real_host_page_size);
+                                   qemu_real_host_page_size());
 try_map:
         r = qemu_vfio_dma_map(s->vfio,
                               qiov->iov[i].iov_base,
@@ -1224,8 +1224,8 @@ static inline bool nvme_qiov_aligned(BlockDriverState *bs,
 
     for (i = 0; i < qiov->niov; ++i) {
         if (!QEMU_PTR_IS_ALIGNED(qiov->iov[i].iov_base,
-                                 qemu_real_host_page_size) ||
-            !QEMU_IS_ALIGNED(qiov->iov[i].iov_len, qemu_real_host_page_size)) {
+                                 qemu_real_host_page_size()) ||
+            !QEMU_IS_ALIGNED(qiov->iov[i].iov_len, qemu_real_host_page_size())) {
             trace_nvme_qiov_unaligned(qiov, i, qiov->iov[i].iov_base,
                                       qiov->iov[i].iov_len, s->page_size);
             return false;
@@ -1241,7 +1241,7 @@ static int nvme_co_prw(BlockDriverState *bs, uint64_t offset, uint64_t bytes,
     int r;
     QEMU_AUTO_VFREE uint8_t *buf = NULL;
     QEMUIOVector local_qiov;
-    size_t len = QEMU_ALIGN_UP(bytes, qemu_real_host_page_size);
+    size_t len = QEMU_ALIGN_UP(bytes, qemu_real_host_page_size());
     assert(QEMU_IS_ALIGNED(offset, s->page_size));
     assert(QEMU_IS_ALIGNED(bytes, s->page_size));
     assert(bytes <= s->max_transfer);
@@ -1251,7 +1251,7 @@ static int nvme_co_prw(BlockDriverState *bs, uint64_t offset, uint64_t bytes,
     }
     s->stats.unaligned_accesses++;
     trace_nvme_prw_buffered(s, offset, bytes, qiov->niov, is_write);
-    buf = qemu_try_memalign(qemu_real_host_page_size, len);
+    buf = qemu_try_memalign(qemu_real_host_page_size(), len);
 
     if (!buf) {
         return -ENOMEM;
diff --git a/block/parallels.c b/block/parallels.c
index cd23e02d06c1..8879b7027a19 100644
--- a/block/parallels.c
+++ b/block/parallels.c
@@ -870,7 +870,7 @@ static int parallels_open(BlockDriverState *bs, QDict *options, int flags,
         }
     }
 
-    s->bat_dirty_block = 4 * qemu_real_host_page_size;
+    s->bat_dirty_block = 4 * qemu_real_host_page_size();
     s->bat_dirty_bmap =
         bitmap_new(DIV_ROUND_UP(s->header_size, s->bat_dirty_block));
 
diff --git a/block/qcow2-cache.c b/block/qcow2-cache.c
index 8a0105911f7e..539f9ca2d501 100644
--- a/block/qcow2-cache.c
+++ b/block/qcow2-cache.c
@@ -75,7 +75,7 @@ static void qcow2_cache_table_release(Qcow2Cache *c, int i, int num_tables)
 /* Using MADV_DONTNEED to discard memory is a Linux-specific feature */
 #ifdef CONFIG_LINUX
     void *t = qcow2_cache_get_table_addr(c, i);
-    int align = qemu_real_host_page_size;
+    int align = qemu_real_host_page_size();
     size_t mem_size = (size_t) c->table_size * num_tables;
     size_t offset = QEMU_ALIGN_UP((uintptr_t) t, align) - (uintptr_t) t;
     size_t length = QEMU_ALIGN_DOWN(mem_size - offset, align);
diff --git a/bsd-user/elfload.c b/bsd-user/elfload.c
index 142a5bfac260..f8edb22f2ab1 100644
--- a/bsd-user/elfload.c
+++ b/bsd-user/elfload.c
@@ -246,7 +246,7 @@ static void padzero(abi_ulong elf_bss, abi_ulong last_bss)
      * patch target_mmap(), but it is more complicated as the file
      * size must be known.
      */
-    if (qemu_real_host_page_size < qemu_host_page_size) {
+    if (qemu_real_host_page_size() < qemu_host_page_size) {
         abi_ulong end_addr, end_addr1;
         end_addr1 = REAL_HOST_PAGE_ALIGN(elf_bss);
         end_addr = HOST_PAGE_ALIGN(elf_bss);
diff --git a/bsd-user/mmap.c b/bsd-user/mmap.c
index 13cb32dba13e..07aa0a634dff 100644
--- a/bsd-user/mmap.c
+++ b/bsd-user/mmap.c
@@ -515,7 +515,7 @@ abi_long target_mmap(abi_ulong start, abi_ulong len, int prot,
      * up to the targets page boundary.
      */
 
-    if ((qemu_real_host_page_size < qemu_host_page_size) && fd != -1) {
+    if ((qemu_real_host_page_size() < qemu_host_page_size) && fd != -1) {
         struct stat sb;
 
         if (fstat(fd, &sb) == -1) {
diff --git a/contrib/vhost-user-gpu/vugbm.c b/contrib/vhost-user-gpu/vugbm.c
index fb15d0372c25..503d0a4566f8 100644
--- a/contrib/vhost-user-gpu/vugbm.c
+++ b/contrib/vhost-user-gpu/vugbm.c
@@ -53,7 +53,7 @@ struct udmabuf_create {
 static size_t
 udmabuf_get_size(struct vugbm_buffer *buf)
 {
-    return ROUND_UP(buf->width * buf->height * 4, qemu_real_host_page_size);
+    return ROUND_UP(buf->width * buf->height * 4, qemu_real_host_page_size());
 }
 
 static bool
diff --git a/cpu.c b/cpu.c
index d34c3439bbf3..ab2c7c81e460 100644
--- a/cpu.c
+++ b/cpu.c
@@ -481,7 +481,7 @@ void page_size_init(void)
     /* NOTE: we can always suppose that qemu_host_page_size >=
        TARGET_PAGE_SIZE */
     if (qemu_host_page_size == 0) {
-        qemu_host_page_size = qemu_real_host_page_size;
+        qemu_host_page_size = qemu_real_host_page_size();
     }
     if (qemu_host_page_size < TARGET_PAGE_SIZE) {
         qemu_host_page_size = TARGET_PAGE_SIZE;
diff --git a/hw/display/qxl.c b/hw/display/qxl.c
index adbdbcaeb612..2db34714fbd9 100644
--- a/hw/display/qxl.c
+++ b/hw/display/qxl.c
@@ -320,7 +320,7 @@ static ram_addr_t qxl_rom_size(void)
 #define QXL_ROM_SZ 8192
 
     QEMU_BUILD_BUG_ON(QXL_REQUIRED_SZ > QXL_ROM_SZ);
-    return QEMU_ALIGN_UP(QXL_REQUIRED_SZ, qemu_real_host_page_size);
+    return QEMU_ALIGN_UP(QXL_REQUIRED_SZ, qemu_real_host_page_size());
 }
 
 static void init_qxl_rom(PCIQXLDevice *d)
diff --git a/hw/intc/s390_flic_kvm.c b/hw/intc/s390_flic_kvm.c
index efe5054182c3..4e86d2d43670 100644
--- a/hw/intc/s390_flic_kvm.c
+++ b/hw/intc/s390_flic_kvm.c
@@ -24,7 +24,7 @@
 #include "trace.h"
 #include "qom/object.h"
 
-#define FLIC_SAVE_INITIAL_SIZE qemu_real_host_page_size
+#define FLIC_SAVE_INITIAL_SIZE qemu_real_host_page_size()
 #define FLIC_FAILED (-1UL)
 #define FLIC_SAVEVM_VERSION 1
 
diff --git a/hw/nvram/fw_cfg.c b/hw/nvram/fw_cfg.c
index e5f3c981841d..ea2d56f9f2af 100644
--- a/hw/nvram/fw_cfg.c
+++ b/hw/nvram/fw_cfg.c
@@ -622,9 +622,9 @@ static bool fw_cfg_acpi_mr_restore(void *opaque)
     FWCfgState *s = opaque;
     bool mr_aligned;
 
-    mr_aligned = QEMU_IS_ALIGNED(s->table_mr_size, qemu_real_host_page_size) &&
-                 QEMU_IS_ALIGNED(s->linker_mr_size, qemu_real_host_page_size) &&
-                 QEMU_IS_ALIGNED(s->rsdp_mr_size, qemu_real_host_page_size);
+    mr_aligned = QEMU_IS_ALIGNED(s->table_mr_size, qemu_real_host_page_size()) &&
+                 QEMU_IS_ALIGNED(s->linker_mr_size, qemu_real_host_page_size()) &&
+                 QEMU_IS_ALIGNED(s->rsdp_mr_size, qemu_real_host_page_size());
     return s->acpi_mr_restore && !mr_aligned;
 }
 
diff --git a/hw/ppc/mac_newworld.c b/hw/ppc/mac_newworld.c
index 4bddb529c2a6..7b5a205309af 100644
--- a/hw/ppc/mac_newworld.c
+++ b/hw/ppc/mac_newworld.c
@@ -456,7 +456,7 @@ static void ppc_core99_init(MachineState *machine)
     }
 
     /* The NewWorld NVRAM is not located in the MacIO device */
-    if (kvm_enabled() && qemu_real_host_page_size > 4096) {
+    if (kvm_enabled() && qemu_real_host_page_size() > 4096) {
         /* We can't combine read-write and read-only in a single page, so
            move the NVRAM out of ROM again for KVM */
         nvram_addr = 0xFFE00000;
diff --git a/hw/ppc/spapr_pci.c b/hw/ppc/spapr_pci.c
index 5bfd4aa9e5aa..b2f5fbef0c83 100644
--- a/hw/ppc/spapr_pci.c
+++ b/hw/ppc/spapr_pci.c
@@ -1978,7 +1978,7 @@ static void spapr_phb_realize(DeviceState *dev, Error **errp)
      * our memory slot is of page size granularity.
      */
     if (kvm_enabled()) {
-        msi_window_size = qemu_real_host_page_size;
+        msi_window_size = qemu_real_host_page_size();
     }
 
     memory_region_init_io(&sphb->msiwindow, OBJECT(sphb), &spapr_msi_ops, spapr,
diff --git a/hw/rdma/vmw/pvrdma_main.c b/hw/rdma/vmw/pvrdma_main.c
index 91206dbb8eb0..27a76224320e 100644
--- a/hw/rdma/vmw/pvrdma_main.c
+++ b/hw/rdma/vmw/pvrdma_main.c
@@ -608,7 +608,7 @@ static void pvrdma_realize(PCIDevice *pdev, Error **errp)
     rdma_info_report("Initializing device %s %x.%x", pdev->name,
                      PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
 
-    if (TARGET_PAGE_SIZE != qemu_real_host_page_size) {
+    if (TARGET_PAGE_SIZE != qemu_real_host_page_size()) {
         error_setg(errp, "Target page size must be the same as host page size");
         return;
     }
diff --git a/hw/scsi/scsi-generic.c b/hw/scsi/scsi-generic.c
index 0306ccc7b1e4..0ab00ef85c95 100644
--- a/hw/scsi/scsi-generic.c
+++ b/hw/scsi/scsi-generic.c
@@ -183,7 +183,7 @@ static int scsi_handle_inquiry_reply(SCSIGenericReq *r, SCSIDevice *s, int len)
             uint32_t max_iov = blk_get_max_hw_iov(s->conf.blk);
 
             assert(max_transfer);
-            max_transfer = MIN_NON_ZERO(max_transfer, max_iov * qemu_real_host_page_size)
+            max_transfer = MIN_NON_ZERO(max_transfer, max_iov * qemu_real_host_page_size())
                 / s->blocksize;
             stl_be_p(&r->buf[8], max_transfer);
             /* Also take care of the opt xfer len. */
diff --git a/hw/tpm/tpm_ppi.c b/hw/tpm/tpm_ppi.c
index c89ac53e65e6..7f74e26ec6c9 100644
--- a/hw/tpm/tpm_ppi.c
+++ b/hw/tpm/tpm_ppi.c
@@ -47,7 +47,7 @@ void tpm_ppi_reset(TPMPPI *tpmppi)
 void tpm_ppi_init(TPMPPI *tpmppi, MemoryRegion *m,
                   hwaddr addr, Object *obj)
 {
-    tpmppi->buf = qemu_memalign(qemu_real_host_page_size,
+    tpmppi->buf = qemu_memalign(qemu_real_host_page_size(),
                                 HOST_PAGE_ALIGN(TPM_PPI_ADDR_SIZE));
     memory_region_init_ram_device_ptr(&tpmppi->ram, obj, "tpm-ppi",
                                       TPM_PPI_ADDR_SIZE, tpmppi->buf);
diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index 080046e3f511..2b1f78fdfaeb 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -397,7 +397,7 @@ static int vfio_dma_unmap_bitmap(VFIOContainer *container,
 {
     struct vfio_iommu_type1_dma_unmap *unmap;
     struct vfio_bitmap *bitmap;
-    uint64_t pages = REAL_HOST_PAGE_ALIGN(size) / qemu_real_host_page_size;
+    uint64_t pages = REAL_HOST_PAGE_ALIGN(size) / qemu_real_host_page_size();
     int ret;
 
     unmap = g_malloc0(sizeof(*unmap) + sizeof(*bitmap));
@@ -414,7 +414,7 @@ static int vfio_dma_unmap_bitmap(VFIOContainer *container,
      * to qemu_real_host_page_size.
      */
 
-    bitmap->pgsize = qemu_real_host_page_size;
+    bitmap->pgsize = qemu_real_host_page_size();
     bitmap->size = ROUND_UP(pages, sizeof(__u64) * BITS_PER_BYTE) /
                    BITS_PER_BYTE;
 
@@ -882,8 +882,8 @@ static void vfio_listener_region_add(MemoryListener *listener,
     }
 
     if (unlikely((section->offset_within_address_space &
-                  ~qemu_real_host_page_mask) !=
-                 (section->offset_within_region & ~qemu_real_host_page_mask))) {
+                  ~qemu_real_host_page_mask()) !=
+                 (section->offset_within_region & ~qemu_real_host_page_mask()))) {
         error_report("%s received unaligned region", __func__);
         return;
     }
@@ -891,7 +891,7 @@ static void vfio_listener_region_add(MemoryListener *listener,
     iova = REAL_HOST_PAGE_ALIGN(section->offset_within_address_space);
     llend = int128_make64(section->offset_within_address_space);
     llend = int128_add(llend, section->size);
-    llend = int128_and(llend, int128_exts64(qemu_real_host_page_mask));
+    llend = int128_and(llend, int128_exts64(qemu_real_host_page_mask()));
 
     if (int128_ge(int128_make64(iova), llend)) {
         if (memory_region_is_ram_device(section->mr)) {
@@ -899,7 +899,7 @@ static void vfio_listener_region_add(MemoryListener *listener,
                 memory_region_name(section->mr),
                 section->offset_within_address_space,
                 int128_getlo(section->size),
-                qemu_real_host_page_size);
+                qemu_real_host_page_size());
         }
         return;
     }
@@ -1118,8 +1118,8 @@ static void vfio_listener_region_del(MemoryListener *listener,
     }
 
     if (unlikely((section->offset_within_address_space &
-                  ~qemu_real_host_page_mask) !=
-                 (section->offset_within_region & ~qemu_real_host_page_mask))) {
+                  ~qemu_real_host_page_mask()) !=
+                 (section->offset_within_region & ~qemu_real_host_page_mask()))) {
         error_report("%s received unaligned region", __func__);
         return;
     }
@@ -1150,7 +1150,7 @@ static void vfio_listener_region_del(MemoryListener *listener,
     iova = REAL_HOST_PAGE_ALIGN(section->offset_within_address_space);
     llend = int128_make64(section->offset_within_address_space);
     llend = int128_add(llend, section->size);
-    llend = int128_and(llend, int128_exts64(qemu_real_host_page_mask));
+    llend = int128_and(llend, int128_exts64(qemu_real_host_page_mask()));
 
     if (int128_ge(int128_make64(iova), llend)) {
         return;
@@ -1272,9 +1272,9 @@ static int vfio_get_dirty_bitmap(VFIOContainer *container, uint64_t iova,
      * qemu_real_host_page_size to mark those dirty. Hence set bitmap's pgsize
      * to qemu_real_host_page_size.
      */
-    range->bitmap.pgsize = qemu_real_host_page_size;
+    range->bitmap.pgsize = qemu_real_host_page_size();
 
-    pages = REAL_HOST_PAGE_ALIGN(range->size) / qemu_real_host_page_size;
+    pages = REAL_HOST_PAGE_ALIGN(range->size) / qemu_real_host_page_size();
     range->bitmap.size = ROUND_UP(pages, sizeof(__u64) * BITS_PER_BYTE) /
                                          BITS_PER_BYTE;
     range->bitmap.data = g_try_malloc0(range->bitmap.size);
@@ -1970,7 +1970,7 @@ static void vfio_get_iommu_info_migration(VFIOContainer *container,
      * cpu_physical_memory_set_dirty_lebitmap() supports pages in bitmap of
      * qemu_real_host_page_size to mark those dirty.
      */
-    if (cap_mig->pgsize_bitmap & qemu_real_host_page_size) {
+    if (cap_mig->pgsize_bitmap & qemu_real_host_page_size()) {
         container->dirty_pages_supported = true;
         container->max_dirty_bitmap_size = cap_mig->max_dirty_bitmap_size;
         container->dirty_pgsizes = cap_mig->pgsize_bitmap;
diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 67a183f17bff..9fd9faee1d14 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -1087,8 +1087,8 @@ static void vfio_sub_page_bar_update_mapping(PCIDevice *pdev, int bar)
 
     /* If BAR is mapped and page aligned, update to fill PAGE_SIZE */
     if (bar_addr != PCI_BAR_UNMAPPED &&
-        !(bar_addr & ~qemu_real_host_page_mask)) {
-        size = qemu_real_host_page_size;
+        !(bar_addr & ~qemu_real_host_page_mask())) {
+        size = qemu_real_host_page_size();
     }
 
     memory_region_transaction_begin();
@@ -1204,7 +1204,7 @@ void vfio_pci_write_config(PCIDevice *pdev,
         for (bar = 0; bar < PCI_ROM_SLOT; bar++) {
             if (old_addr[bar] != pdev->io_regions[bar].addr &&
                 vdev->bars[bar].region.size > 0 &&
-                vdev->bars[bar].region.size < qemu_real_host_page_size) {
+                vdev->bars[bar].region.size < qemu_real_host_page_size()) {
                 vfio_sub_page_bar_update_mapping(pdev, bar);
             }
         }
@@ -1292,7 +1292,7 @@ static void vfio_pci_fixup_msix_region(VFIOPCIDevice *vdev)
     }
 
     /* MSI-X table start and end aligned to host page size */
-    start = vdev->msix->table_offset & qemu_real_host_page_mask;
+    start = vdev->msix->table_offset & qemu_real_host_page_mask();
     end = REAL_HOST_PAGE_ALIGN((uint64_t)vdev->msix->table_offset +
                                (vdev->msix->entries * PCI_MSIX_ENTRY_SIZE));
 
@@ -2478,7 +2478,7 @@ static int vfio_pci_load_config(VFIODevice *vbasedev, QEMUFile *f)
          */
         if (old_addr[bar] != pdev->io_regions[bar].addr &&
             vdev->bars[bar].region.size > 0 &&
-            vdev->bars[bar].region.size < qemu_real_host_page_size) {
+            vdev->bars[bar].region.size < qemu_real_host_page_size()) {
             vfio_sub_page_bar_update_mapping(pdev, bar);
         }
     }
diff --git a/hw/vfio/spapr.c b/hw/vfio/spapr.c
index 04c6e67f8fba..9ec1e95f6da7 100644
--- a/hw/vfio/spapr.c
+++ b/hw/vfio/spapr.c
@@ -44,7 +44,7 @@ static void vfio_prereg_listener_region_add(MemoryListener *listener,
     const hwaddr gpa = section->offset_within_address_space;
     hwaddr end;
     int ret;
-    hwaddr page_mask = qemu_real_host_page_mask;
+    hwaddr page_mask = qemu_real_host_page_mask();
     struct vfio_iommu_spapr_register_memory reg = {
         .argsz = sizeof(reg),
         .flags = 0,
@@ -102,7 +102,7 @@ static void vfio_prereg_listener_region_del(MemoryListener *listener,
     const hwaddr gpa = section->offset_within_address_space;
     hwaddr end;
     int ret;
-    hwaddr page_mask = qemu_real_host_page_mask;
+    hwaddr page_mask = qemu_real_host_page_mask();
     struct vfio_iommu_spapr_register_memory reg = {
         .argsz = sizeof(reg),
         .flags = 0,
@@ -199,12 +199,12 @@ int vfio_spapr_create_window(VFIOContainer *container,
      * Below we look at qemu_real_host_page_size as TCEs are allocated from
      * system pages.
      */
-    bits_per_level = ctz64(qemu_real_host_page_size) + 8;
+    bits_per_level = ctz64(qemu_real_host_page_size()) + 8;
     create.levels = bits_total / bits_per_level;
     if (bits_total % bits_per_level) {
         ++create.levels;
     }
-    max_levels = (64 - create.page_shift) / ctz64(qemu_real_host_page_size);
+    max_levels = (64 - create.page_shift) / ctz64(qemu_real_host_page_size());
     for ( ; create.levels <= max_levels; ++create.levels) {
         ret = ioctl(container->fd, VFIO_IOMMU_SPAPR_TCE_CREATE, &create);
         if (!ret) {
diff --git a/hw/virtio/vhost-iova-tree.c b/hw/virtio/vhost-iova-tree.c
index 55fed1fefb43..67bf6d57ab9c 100644
--- a/hw/virtio/vhost-iova-tree.c
+++ b/hw/virtio/vhost-iova-tree.c
@@ -11,7 +11,7 @@
 #include "qemu/iova-tree.h"
 #include "vhost-iova-tree.h"
 
-#define iova_min_addr qemu_real_host_page_size
+#define iova_min_addr qemu_real_host_page_size()
 
 /**
  * VhostIOVATree, able to:
@@ -86,7 +86,7 @@ const DMAMap *vhost_iova_tree_find_iova(const VhostIOVATree *tree,
 int vhost_iova_tree_map_alloc(VhostIOVATree *tree, DMAMap *map)
 {
     /* Some vhost devices do not like addr 0. Skip first page */
-    hwaddr iova_first = tree->iova_first ?: qemu_real_host_page_size;
+    hwaddr iova_first = tree->iova_first ?: qemu_real_host_page_size();
 
     if (map->translated_addr + map->size < map->translated_addr ||
         map->perm == IOMMU_NONE) {
diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-shadow-virtqueue.c
index b232803d1b19..1e5cfe2af63e 100644
--- a/hw/virtio/vhost-shadow-virtqueue.c
+++ b/hw/virtio/vhost-shadow-virtqueue.c
@@ -471,14 +471,14 @@ size_t vhost_svq_driver_area_size(const VhostShadowVirtqueue *svq)
     size_t avail_size = offsetof(vring_avail_t, ring) +
                                              sizeof(uint16_t) * svq->vring.num;
 
-    return ROUND_UP(desc_size + avail_size, qemu_real_host_page_size);
+    return ROUND_UP(desc_size + avail_size, qemu_real_host_page_size());
 }
 
 size_t vhost_svq_device_area_size(const VhostShadowVirtqueue *svq)
 {
     size_t used_size = offsetof(vring_used_t, ring) +
                                     sizeof(vring_used_elem_t) * svq->vring.num;
-    return ROUND_UP(used_size, qemu_real_host_page_size);
+    return ROUND_UP(used_size, qemu_real_host_page_size());
 }
 
 /**
@@ -533,11 +533,11 @@ void vhost_svq_start(VhostShadowVirtqueue *svq, VirtIODevice *vdev,
     svq->vring.num = virtio_queue_get_num(vdev, virtio_get_queue_index(vq));
     driver_size = vhost_svq_driver_area_size(svq);
     device_size = vhost_svq_device_area_size(svq);
-    svq->vring.desc = qemu_memalign(qemu_real_host_page_size, driver_size);
+    svq->vring.desc = qemu_memalign(qemu_real_host_page_size(), driver_size);
     desc_size = sizeof(vring_desc_t) * svq->vring.num;
     svq->vring.avail = (void *)((char *)svq->vring.desc + desc_size);
     memset(svq->vring.desc, 0, driver_size);
-    svq->vring.used = qemu_memalign(qemu_real_host_page_size, device_size);
+    svq->vring.used = qemu_memalign(qemu_real_host_page_size(), device_size);
     memset(svq->vring.used, 0, device_size);
     svq->ring_id_maps = g_new0(VirtQueueElement *, svq->vring.num);
     for (unsigned i = 0; i < svq->vring.num - 1; i++) {
diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index 6abbc9da3202..9c4f84f35f61 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -1166,7 +1166,7 @@ static int vhost_user_set_vring_num(struct vhost_dev *dev,
 static void vhost_user_host_notifier_free(VhostUserHostNotifier *n)
 {
     assert(n && n->unmap_addr);
-    munmap(n->unmap_addr, qemu_real_host_page_size);
+    munmap(n->unmap_addr, qemu_real_host_page_size());
     n->unmap_addr = NULL;
 }
 
@@ -1503,7 +1503,7 @@ static int vhost_user_slave_handle_vring_host_notifier(struct vhost_dev *dev,
                                                        int fd)
 {
     int queue_idx = area->u64 & VHOST_USER_VRING_IDX_MASK;
-    size_t page_size = qemu_real_host_page_size;
+    size_t page_size = qemu_real_host_page_size();
     struct vhost_user *u = dev->opaque;
     VhostUserState *user = u->user;
     VirtIODevice *vdev = dev->vdev;
diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
index c5ed7a377939..2075f336e2ad 100644
--- a/hw/virtio/vhost-vdpa.c
+++ b/hw/virtio/vhost-vdpa.c
@@ -468,7 +468,7 @@ err:
 static void vhost_vdpa_host_notifier_uninit(struct vhost_dev *dev,
                                             int queue_index)
 {
-    size_t page_size = qemu_real_host_page_size;
+    size_t page_size = qemu_real_host_page_size();
     struct vhost_vdpa *v = dev->opaque;
     VirtIODevice *vdev = dev->vdev;
     VhostVDPAHostNotifier *n;
@@ -485,7 +485,7 @@ static void vhost_vdpa_host_notifier_uninit(struct vhost_dev *dev,
 
 static int vhost_vdpa_host_notifier_init(struct vhost_dev *dev, int queue_index)
 {
-    size_t page_size = qemu_real_host_page_size;
+    size_t page_size = qemu_real_host_page_size();
     struct vhost_vdpa *v = dev->opaque;
     VirtIODevice *vdev = dev->vdev;
     VhostVDPAHostNotifier *n;
@@ -875,7 +875,7 @@ static bool vhost_vdpa_svq_unmap_ring(struct vhost_vdpa *v,
         return false;
     }
 
-    size = ROUND_UP(result->size, qemu_real_host_page_size);
+    size = ROUND_UP(result->size, qemu_real_host_page_size());
     r = vhost_vdpa_dma_unmap(v, result->iova, size);
     return r == 0;
 }
diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index f55dcf61f203..35cbf1f21946 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -53,11 +53,11 @@ static uint32_t virtio_mem_default_thp_size(void)
 #if defined(__x86_64__) || defined(__arm__) || defined(__powerpc64__)
     default_thp_size = 2 * MiB;
 #elif defined(__aarch64__)
-    if (qemu_real_host_page_size == 4 * KiB) {
+    if (qemu_real_host_page_size() == 4 * KiB) {
         default_thp_size = 2 * MiB;
-    } else if (qemu_real_host_page_size == 16 * KiB) {
+    } else if (qemu_real_host_page_size() == 16 * KiB) {
         default_thp_size = 32 * MiB;
-    } else if (qemu_real_host_page_size == 64 * KiB) {
+    } else if (qemu_real_host_page_size() == 64 * KiB) {
         default_thp_size = 512 * MiB;
     }
 #endif
@@ -120,7 +120,7 @@ static uint64_t virtio_mem_default_block_size(RAMBlock *rb)
     const uint64_t page_size = qemu_ram_pagesize(rb);
 
     /* We can have hugetlbfs with a page size smaller than the THP size. */
-    if (page_size == qemu_real_host_page_size) {
+    if (page_size == qemu_real_host_page_size()) {
         return MAX(page_size, virtio_mem_thp_size());
     }
     return MAX(page_size, VIRTIO_MEM_MIN_BLOCK_SIZE);
@@ -135,7 +135,7 @@ static bool virtio_mem_has_shared_zeropage(RAMBlock *rb)
      * fresh page, consuming actual memory.
      */
     return !qemu_ram_is_shared(rb) && rb->fd < 0 &&
-           qemu_ram_pagesize(rb) == qemu_real_host_page_size;
+           qemu_ram_pagesize(rb) == qemu_real_host_page_size();
 }
 #endif /* VIRTIO_MEM_HAS_LEGACY_GUESTS */
 
diff --git a/linux-user/elfload.c b/linux-user/elfload.c
index 796acdcdbd2c..0b130b83c99f 100644
--- a/linux-user/elfload.c
+++ b/linux-user/elfload.c
@@ -1916,8 +1916,8 @@ static abi_ulong setup_arg_pages(struct linux_binprm *bprm,
         size = STACK_LOWER_LIMIT;
     }
     guard = TARGET_PAGE_SIZE;
-    if (guard < qemu_real_host_page_size) {
-        guard = qemu_real_host_page_size;
+    if (guard < qemu_real_host_page_size()) {
+        guard = qemu_real_host_page_size();
     }
 
     error = target_mmap(0, size + guard, PROT_READ | PROT_WRITE,
diff --git a/linux-user/mmap.c b/linux-user/mmap.c
index c125031b9046..a861f1e1d144 100644
--- a/linux-user/mmap.c
+++ b/linux-user/mmap.c
@@ -494,7 +494,7 @@ abi_long target_mmap(abi_ulong start, abi_ulong len, int target_prot,
        may need to truncate file maps at EOF and add extra anonymous pages
        up to the targets page boundary.  */
 
-    if ((qemu_real_host_page_size < qemu_host_page_size) &&
+    if ((qemu_real_host_page_size() < qemu_host_page_size) &&
         !(flags & MAP_ANONYMOUS)) {
         struct stat sb;
 
diff --git a/migration/migration.c b/migration/migration.c
index 695f0f29000c..4dcb511bb60d 100644
--- a/migration/migration.c
+++ b/migration/migration.c
@@ -2652,7 +2652,7 @@ static struct rp_cmd_args {
 static void migrate_handle_rp_req_pages(MigrationState *ms, const char* rbname,
                                        ram_addr_t start, size_t len)
 {
-    long our_host_ps = qemu_real_host_page_size;
+    long our_host_ps = qemu_real_host_page_size();
 
     trace_migrate_handle_rp_req_pages(rbname, start, len);
 
diff --git a/migration/postcopy-ram.c b/migration/postcopy-ram.c
index 32c52f4b1d9e..a66dd536d939 100644
--- a/migration/postcopy-ram.c
+++ b/migration/postcopy-ram.c
@@ -319,7 +319,7 @@ static bool ufd_check_and_apply(int ufd, MigrationIncomingState *mis)
         return false;
     }
 
-    if (qemu_real_host_page_size != ram_pagesize_summary()) {
+    if (qemu_real_host_page_size() != ram_pagesize_summary()) {
         bool have_hp = false;
         /* We've got a huge page */
 #ifdef UFFD_FEATURE_MISSING_HUGETLBFS
@@ -357,7 +357,7 @@ static int test_ramblock_postcopiable(RAMBlock *rb, void *opaque)
  */
 bool postcopy_ram_supported_by_host(MigrationIncomingState *mis)
 {
-    long pagesize = qemu_real_host_page_size;
+    long pagesize = qemu_real_host_page_size();
     int ufd = -1;
     bool ret = false; /* Error unless we change it */
     void *testarea = NULL;
diff --git a/monitor/misc.c b/monitor/misc.c
index a756dbd6db0c..b0fc0e5843a4 100644
--- a/monitor/misc.c
+++ b/monitor/misc.c
@@ -720,7 +720,7 @@ static uint64_t vtop(void *ptr, Error **errp)
     uint64_t pinfo;
     uint64_t ret = -1;
     uintptr_t addr = (uintptr_t) ptr;
-    uintptr_t pagesize = qemu_real_host_page_size;
+    uintptr_t pagesize = qemu_real_host_page_size();
     off_t offset = addr / pagesize * sizeof(pinfo);
     int fd;
 
diff --git a/softmmu/physmem.c b/softmmu/physmem.c
index 4e1b27a20ecc..cdf0db733e57 100644
--- a/softmmu/physmem.c
+++ b/softmmu/physmem.c
@@ -1383,11 +1383,11 @@ long qemu_maxrampagesize(void)
 #else
 long qemu_minrampagesize(void)
 {
-    return qemu_real_host_page_size;
+    return qemu_real_host_page_size();
 }
 long qemu_maxrampagesize(void)
 {
-    return qemu_real_host_page_size;
+    return qemu_real_host_page_size();
 }
 #endif
 
@@ -2163,7 +2163,7 @@ RAMBlock *qemu_ram_alloc_internal(ram_addr_t size, ram_addr_t max_size,
     new_block->max_length = max_size;
     assert(max_size >= size);
     new_block->fd = -1;
-    new_block->page_size = qemu_real_host_page_size;
+    new_block->page_size = qemu_real_host_page_size();
     new_block->host = host;
     new_block->flags = ram_flags;
     ram_block_add(new_block, &local_err);
diff --git a/target/i386/hax/hax-mem.c b/target/i386/hax/hax-mem.c
index a226d174d8ef..05dbe8cce3ae 100644
--- a/target/i386/hax/hax-mem.c
+++ b/target/i386/hax/hax-mem.c
@@ -188,15 +188,15 @@ static void hax_process_section(MemoryRegionSection *section, uint8_t flags)
     /* Adjust start_pa and size so that they are page-aligned. (Cf
      * kvm_set_phys_mem() in kvm-all.c).
      */
-    delta = qemu_real_host_page_size - (start_pa & ~qemu_real_host_page_mask);
-    delta &= ~qemu_real_host_page_mask;
+    delta = qemu_real_host_page_size() - (start_pa & ~qemu_real_host_page_mask());
+    delta &= ~qemu_real_host_page_mask();
     if (delta > size) {
         return;
     }
     start_pa += delta;
     size -= delta;
-    size &= qemu_real_host_page_mask;
-    if (!size || (start_pa & ~qemu_real_host_page_mask)) {
+    size &= qemu_real_host_page_mask();
+    if (!size || (start_pa & ~qemu_real_host_page_mask())) {
         return;
     }
 
@@ -214,7 +214,7 @@ static void hax_process_section(MemoryRegionSection *section, uint8_t flags)
      * call into the kernel. Instead, we split the mapping into smaller ones,
      * and call hax_update_mapping() on each.
      */
-    max_mapping_size = UINT32_MAX & qemu_real_host_page_mask;
+    max_mapping_size = UINT32_MAX & qemu_real_host_page_mask();
     while (size > max_mapping_size) {
         hax_update_mapping(start_pa, max_mapping_size, host_va, flags);
         start_pa += max_mapping_size;
diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
index b97d091a502d..9f940413318c 100644
--- a/target/i386/nvmm/nvmm-all.c
+++ b/target/i386/nvmm/nvmm-all.c
@@ -1075,15 +1075,15 @@ nvmm_process_section(MemoryRegionSection *section, int add)
     }
 
     /* Adjust start_pa and size so that they are page-aligned. */
-    delta = qemu_real_host_page_size - (start_pa & ~qemu_real_host_page_mask);
-    delta &= ~qemu_real_host_page_mask;
+    delta = qemu_real_host_page_size() - (start_pa & ~qemu_real_host_page_mask());
+    delta &= ~qemu_real_host_page_mask();
     if (delta > size) {
         return;
     }
     start_pa += delta;
     size -= delta;
-    size &= qemu_real_host_page_mask;
-    if (!size || (start_pa & ~qemu_real_host_page_mask)) {
+    size &= qemu_real_host_page_mask();
+    if (!size || (start_pa & ~qemu_real_host_page_mask())) {
         return;
     }
 
diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index 03ba52da89fb..68a4ebe909ad 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -1572,15 +1572,15 @@ static void whpx_process_section(MemoryRegionSection *section, int add)
         return;
     }
 
-    delta = qemu_real_host_page_size - (start_pa & ~qemu_real_host_page_mask);
-    delta &= ~qemu_real_host_page_mask;
+    delta = qemu_real_host_page_size() - (start_pa & ~qemu_real_host_page_mask());
+    delta &= ~qemu_real_host_page_mask();
     if (delta > size) {
         return;
     }
     start_pa += delta;
     size -= delta;
-    size &= qemu_real_host_page_mask;
-    if (!size || (start_pa & ~qemu_real_host_page_mask)) {
+    size &= qemu_real_host_page_mask();
+    if (!size || (start_pa & ~qemu_real_host_page_mask())) {
         return;
     }
 
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index d1f07c4f41d4..8644b85de847 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -418,7 +418,7 @@ void kvm_check_mmu(PowerPCCPU *cpu, Error **errp)
          * will be a normal mapping, not a special hugepage one used
          * for RAM.
          */
-        if (qemu_real_host_page_size < 0x10000) {
+        if (qemu_real_host_page_size() < 0x10000) {
             error_setg(errp,
                        "KVM can't supply 64kiB CI pages, which guest expects");
         }
diff --git a/tcg/region.c b/tcg/region.c
index 97ca5291d52f..71ea81d6713f 100644
--- a/tcg/region.c
+++ b/tcg/region.c
@@ -488,14 +488,14 @@ static int alloc_code_gen_buffer(size_t tb_size, int splitwx, Error **errp)
     /* page-align the beginning and end of the buffer */
     buf = static_code_gen_buffer;
     end = static_code_gen_buffer + sizeof(static_code_gen_buffer);
-    buf = QEMU_ALIGN_PTR_UP(buf, qemu_real_host_page_size);
-    end = QEMU_ALIGN_PTR_DOWN(end, qemu_real_host_page_size);
+    buf = QEMU_ALIGN_PTR_UP(buf, qemu_real_host_page_size());
+    end = QEMU_ALIGN_PTR_DOWN(end, qemu_real_host_page_size());
 
     size = end - buf;
 
     /* Honor a command-line option limiting the size of the buffer.  */
     if (size > tb_size) {
-        size = QEMU_ALIGN_DOWN(tb_size, qemu_real_host_page_size);
+        size = QEMU_ALIGN_DOWN(tb_size, qemu_real_host_page_size());
     }
 
     region.start_aligned = buf;
@@ -729,7 +729,7 @@ static int alloc_code_gen_buffer(size_t size, int splitwx, Error **errp)
  */
 void tcg_region_init(size_t tb_size, int splitwx, unsigned max_cpus)
 {
-    const size_t page_size = qemu_real_host_page_size;
+    const size_t page_size = qemu_real_host_page_size();
     size_t region_size;
     int have_prot, need_prot;
 
diff --git a/tests/vhost-user-bridge.c b/tests/vhost-user-bridge.c
index 35088dd67f78..9b1dab2f2883 100644
--- a/tests/vhost-user-bridge.c
+++ b/tests/vhost-user-bridge.c
@@ -468,8 +468,8 @@ vubr_queue_set_started(VuDev *dev, int qidx, bool started)
 
     if (started && vubr->notifier.fd >= 0) {
         vu_set_queue_host_notifier(dev, vq, vubr->notifier.fd,
-                                   qemu_real_host_page_size,
-                                   qidx * qemu_real_host_page_size);
+                                   qemu_real_host_page_size(),
+                                   qidx * qemu_real_host_page_size());
     }
 
     if (qidx % 2 == 1) {
@@ -601,7 +601,7 @@ static void *notifier_thread(void *arg)
 {
     VuDev *dev = (VuDev *)arg;
     VubrDev *vubr = container_of(dev, VubrDev, vudev);
-    int pagesize = qemu_real_host_page_size;
+    int pagesize = qemu_real_host_page_size();
     int qidx;
 
     while (true) {
@@ -637,7 +637,7 @@ vubr_host_notifier_setup(VubrDev *dev)
     void *addr;
     int fd;
 
-    length = qemu_real_host_page_size * VHOST_USER_BRIDGE_MAX_QUEUES;
+    length = qemu_real_host_page_size() * VHOST_USER_BRIDGE_MAX_QUEUES;
 
     fd = mkstemp(template);
     if (fd < 0) {
diff --git a/util/cutils.c b/util/cutils.c
index 0d475ec4cddd..1173ce3b88f3 100644
--- a/util/cutils.c
+++ b/util/cutils.c
@@ -175,7 +175,7 @@ int qemu_fdatasync(int fd)
 int qemu_msync(void *addr, size_t length, int fd)
 {
 #ifdef CONFIG_POSIX
-    size_t align_mask = ~(qemu_real_host_page_size - 1);
+    size_t align_mask = ~(qemu_real_host_page_size() - 1);
 
     /**
      * There are no strict reqs as per the length of mapping
@@ -183,7 +183,7 @@ int qemu_msync(void *addr, size_t length, int fd)
      * alignment changes. Additionally - round the size to the multiple
      * of PAGE_SIZE
      */
-    length += ((uintptr_t)addr & (qemu_real_host_page_size - 1));
+    length += ((uintptr_t)addr & (qemu_real_host_page_size() - 1));
     length = (length + ~align_mask) & align_mask;
 
     addr = (void *)((uintptr_t)addr & align_mask);
diff --git a/util/mmap-alloc.c b/util/mmap-alloc.c
index 893d864354a1..5b90cb68ea7d 100644
--- a/util/mmap-alloc.c
+++ b/util/mmap-alloc.c
@@ -50,7 +50,7 @@ size_t qemu_fd_getpagesize(int fd)
 #endif
 #endif
 
-    return qemu_real_host_page_size;
+    return qemu_real_host_page_size();
 }
 
 size_t qemu_mempath_getpagesize(const char *mem_path)
@@ -81,7 +81,7 @@ size_t qemu_mempath_getpagesize(const char *mem_path)
 #endif
 #endif
 
-    return qemu_real_host_page_size;
+    return qemu_real_host_page_size();
 }
 
 #define OVERCOMMIT_MEMORY_PATH "/proc/sys/vm/overcommit_memory"
@@ -101,7 +101,7 @@ static bool map_noreserve_effective(int fd, uint32_t qemu_map_flags)
      *    MAP_NORESERVE.
      * b) MAP_NORESERVE is not affected by /proc/sys/vm/overcommit_memory.
      */
-    if (qemu_fd_getpagesize(fd) != qemu_real_host_page_size) {
+    if (qemu_fd_getpagesize(fd) != qemu_real_host_page_size()) {
         return true;
     }
 
@@ -166,7 +166,7 @@ static void *mmap_reserve(size_t size, int fd)
      * We do this unless we are using the system page size, in which case
      * anonymous memory is OK.
      */
-    if (fd == -1 || qemu_fd_getpagesize(fd) == qemu_real_host_page_size) {
+    if (fd == -1 || qemu_fd_getpagesize(fd) == qemu_real_host_page_size()) {
         fd = -1;
         flags |= MAP_ANONYMOUS;
     } else {
@@ -243,7 +243,7 @@ static inline size_t mmap_guard_pagesize(int fd)
     /* Mappings in the same segment must share the same page size */
     return qemu_fd_getpagesize(fd);
 #else
-    return qemu_real_host_page_size;
+    return qemu_real_host_page_size();
 #endif
 }
 
diff --git a/util/osdep.c b/util/osdep.c
index 84575ec21881..97dc9bc65b45 100644
--- a/util/osdep.c
+++ b/util/osdep.c
@@ -69,8 +69,8 @@ int qemu_madvise(void *addr, size_t len, int advice)
 
 static int qemu_mprotect__osdep(void *addr, size_t size, int prot)
 {
-    g_assert(!((uintptr_t)addr & ~qemu_real_host_page_mask));
-    g_assert(!(size & ~qemu_real_host_page_mask));
+    g_assert(!((uintptr_t)addr & ~qemu_real_host_page_mask()));
+    g_assert(!(size & ~qemu_real_host_page_mask()));
 
 #ifdef _WIN32
     DWORD old_protect;
diff --git a/util/oslib-posix.c b/util/oslib-posix.c
index 2ebfb7505787..577c855612cb 100644
--- a/util/oslib-posix.c
+++ b/util/oslib-posix.c
@@ -767,7 +767,7 @@ void *qemu_alloc_stack(size_t *sz)
 #ifdef CONFIG_DEBUG_STACK_USAGE
     void *ptr2;
 #endif
-    size_t pagesz = qemu_real_host_page_size;
+    size_t pagesz = qemu_real_host_page_size();
 #ifdef _SC_THREAD_STACK_MIN
     /* avoid stacks smaller than _SC_THREAD_STACK_MIN */
     long min_stack_sz = sysconf(_SC_THREAD_STACK_MIN);
@@ -829,7 +829,7 @@ void qemu_free_stack(void *stack, size_t sz)
     unsigned int usage;
     void *ptr;
 
-    for (ptr = stack + qemu_real_host_page_size; ptr < stack + sz;
+    for (ptr = stack + qemu_real_host_page_size(); ptr < stack + sz;
          ptr += sizeof(uint32_t)) {
         if (*(uint32_t *)ptr != 0xdeadbeaf) {
             break;
@@ -927,10 +927,10 @@ size_t qemu_get_host_physmem(void)
 #ifdef _SC_PHYS_PAGES
     long pages = sysconf(_SC_PHYS_PAGES);
     if (pages > 0) {
-        if (pages > SIZE_MAX / qemu_real_host_page_size) {
+        if (pages > SIZE_MAX / qemu_real_host_page_size()) {
             return SIZE_MAX;
         } else {
-            return pages * qemu_real_host_page_size;
+            return pages * qemu_real_host_page_size();
         }
     }
 #endif
diff --git a/util/oslib-win32.c b/util/oslib-win32.c
index 4b1ce0be4b0e..91d2f45cfe1f 100644
--- a/util/oslib-win32.c
+++ b/util/oslib-win32.c
@@ -339,7 +339,7 @@ void os_mem_prealloc(int fd, char *area, size_t memory, int smp_cpus,
                      Error **errp)
 {
     int i;
-    size_t pagesize = qemu_real_host_page_size;
+    size_t pagesize = qemu_real_host_page_size();
 
     memory = (memory + pagesize - 1) & -pagesize;
     for (i = 0; i < memory / pagesize; i++) {
diff --git a/util/pagesize.c b/util/pagesize.c
deleted file mode 100644
index 998632cf6ee6..000000000000
--- a/util/pagesize.c
+++ /dev/null
@@ -1,18 +0,0 @@
-/*
- * pagesize.c - query the host about its page size
- *
- * Copyright (C) 2017, Emilio G. Cota <cota@braap.org>
- * License: GNU GPL, version 2 or later.
- *   See the COPYING file in the top-level directory.
- */
-
-#include "qemu/osdep.h"
-
-uintptr_t qemu_real_host_page_size;
-intptr_t qemu_real_host_page_mask;
-
-static void __attribute__((constructor)) init_real_host_page_size(void)
-{
-    qemu_real_host_page_size = getpagesize();
-    qemu_real_host_page_mask = -(intptr_t)qemu_real_host_page_size;
-}
diff --git a/util/vfio-helpers.c b/util/vfio-helpers.c
index b037d5faa51e..5ba01177bf9d 100644
--- a/util/vfio-helpers.c
+++ b/util/vfio-helpers.c
@@ -163,7 +163,7 @@ void *qemu_vfio_pci_map_bar(QEMUVFIOState *s, int index,
                             Error **errp)
 {
     void *p;
-    assert(QEMU_IS_ALIGNED(offset, qemu_real_host_page_size));
+    assert(QEMU_IS_ALIGNED(offset, qemu_real_host_page_size()));
     assert_bar_index_valid(s, index);
     p = mmap(NULL, MIN(size, s->bar_region_info[index].size - offset),
              prot, MAP_SHARED,
@@ -591,9 +591,9 @@ static IOVAMapping *qemu_vfio_add_mapping(QEMUVFIOState *s,
     IOVAMapping m = {.host = host, .size = size, .iova = iova};
     IOVAMapping *insert;
 
-    assert(QEMU_IS_ALIGNED(size, qemu_real_host_page_size));
-    assert(QEMU_IS_ALIGNED(s->low_water_mark, qemu_real_host_page_size));
-    assert(QEMU_IS_ALIGNED(s->high_water_mark, qemu_real_host_page_size));
+    assert(QEMU_IS_ALIGNED(size, qemu_real_host_page_size()));
+    assert(QEMU_IS_ALIGNED(s->low_water_mark, qemu_real_host_page_size()));
+    assert(QEMU_IS_ALIGNED(s->high_water_mark, qemu_real_host_page_size()));
     trace_qemu_vfio_new_mapping(s, host, size, index, iova);
 
     assert(index >= 0);
@@ -644,7 +644,7 @@ static void qemu_vfio_undo_mapping(QEMUVFIOState *s, IOVAMapping *mapping,
 
     index = mapping - s->mappings;
     assert(mapping->size > 0);
-    assert(QEMU_IS_ALIGNED(mapping->size, qemu_real_host_page_size));
+    assert(QEMU_IS_ALIGNED(mapping->size, qemu_real_host_page_size()));
     assert(index >= 0 && index < s->nr_mappings);
     if (ioctl(s->container, VFIO_IOMMU_UNMAP_DMA, &unmap)) {
         error_setg_errno(errp, errno, "VFIO_UNMAP_DMA failed");
@@ -752,8 +752,8 @@ int qemu_vfio_dma_map(QEMUVFIOState *s, void *host, size_t size,
     IOVAMapping *mapping;
     uint64_t iova0;
 
-    assert(QEMU_PTR_IS_ALIGNED(host, qemu_real_host_page_size));
-    assert(QEMU_IS_ALIGNED(size, qemu_real_host_page_size));
+    assert(QEMU_PTR_IS_ALIGNED(host, qemu_real_host_page_size()));
+    assert(QEMU_IS_ALIGNED(size, qemu_real_host_page_size()));
     trace_qemu_vfio_dma_map(s, host, size, temporary, iova);
     QEMU_LOCK_GUARD(&s->lock);
     mapping = qemu_vfio_find_mapping(s, host, &index);
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index ddc6003de280..910a6c74dff9 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2974,10 +2974,10 @@ sub process {
 			ERROR("use memset() instead of bzero()\n" . $herecurr);
 		}
 		if ($line =~ /\bgetpagesize\(\)/) {
-			ERROR("use qemu_real_host_page_size instead of getpagesize()\n" . $herecurr);
+			ERROR("use qemu_real_host_page_size() instead of getpagesize()\n" . $herecurr);
 		}
 		if ($line =~ /\bsysconf\(_SC_PAGESIZE\)/) {
-			ERROR("use qemu_real_host_page_size instead of sysconf(_SC_PAGESIZE)\n" . $herecurr);
+			ERROR("use qemu_real_host_page_size() instead of sysconf(_SC_PAGESIZE)\n" . $herecurr);
 		}
 		my $non_exit_glib_asserts = qr{g_assert_cmpstr|
 						g_assert_cmpint|
diff --git a/util/meson.build b/util/meson.build
index f8f0643318c3..2d71ab57a42e 100644
--- a/util/meson.build
+++ b/util/meson.build
@@ -42,7 +42,6 @@ if have_membarrier
   util_ss.add(files('sys_membarrier.c'))
 endif
 util_ss.add(files('log.c'))
-util_ss.add(files('pagesize.c'))
 util_ss.add(files('qdist.c'))
 util_ss.add(files('qht.c'))
 util_ss.add(files('qsp.c'))
-- 
2.35.1.273.ge6ebfd0e8cbb

