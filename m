Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2A132E607
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 11:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhCEKS3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 05:18:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60975 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229604AbhCEKSG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Mar 2021 05:18:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614939485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0w5JhCDF+sw1F+91O5Td776BOt0OpplL59R7NkVJgi0=;
        b=BU+znGjgORfMooxldmBZzwuT673w73kVusne5/SeqFwDm3BjugZZUUC4vFw/tsCejM8by5
        gD9pJj1zHytEFTGqMpA6xmGpIZZeh+LCN0XMKPwFXIf4/B0uxUSZKQj0bM5hRGHPAc0y8y
        k+SuqVke+nuccduQ/S0VPxvxS2GhE+o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-8CQB5JkxP02930uk4h9sCA-1; Fri, 05 Mar 2021 05:18:01 -0500
X-MC-Unique: 8CQB5JkxP02930uk4h9sCA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30AD06409C;
        Fri,  5 Mar 2021 10:17:59 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-112-194.ams2.redhat.com [10.36.112.194])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE277101E39C;
        Fri,  5 Mar 2021 10:17:54 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Murilo Opsfelder Araujo <muriloo@linux.ibm.com>,
        Greg Kurz <groug@kaod.org>,
        Liam Merwick <liam.merwick@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Igor Kotrasinski <i.kotrasinsk@partner.samsung.com>,
        Juan Quintela <quintela@redhat.com>,
        Stefan Weil <sw@weilnetz.de>, Thomas Huth <thuth@redhat.com>,
        kvm@vger.kernel.org, qemu-s390x@nongnu.org
Subject: [PATCH v2 7/9] memory: introduce RAM_NORESERVE and wire it up in qemu_ram_mmap()
Date:   Fri,  5 Mar 2021 11:16:32 +0100
Message-Id: <20210305101634.10745-8-david@redhat.com>
In-Reply-To: <20210305101634.10745-1-david@redhat.com>
References: <20210305101634.10745-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's introduce RAM_NORESERVE, allowing mmap'ing with MAP_NORESERVE. The
new flag has the following semantics:

  RAM is mmap-ed with MAP_NORESERVE. When set, reserving swap space (or
  huge pages on Linux) is skipped: will bail out if not supported. When not
  set, the OS might reserve swap space (or huge pages on Linux), depending
  on OS support.

Allow passing it into:
- memory_region_init_ram_nomigrate()
- memory_region_init_resizeable_ram()
- memory_region_init_ram_from_file()

... and teach qemu_ram_mmap() and qemu_anon_ram_alloc() about the flag.
Bail out if the flag is not supported, which is the case right now for
both, POSIX and win32. We will add the POSIX mmap implementation next and
allow specifying RAM_NORESERVE via memory backends.

The target use case is virtio-mem, which dynamically exposes memory
inside a large, sparse memory area to the VM.

Cc: Juan Quintela <quintela@redhat.com>
Cc: Halil Pasic <pasic@linux.ibm.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Stefan Weil <sw@weilnetz.de>
Cc: kvm@vger.kernel.org
Cc: qemu-s390x@nongnu.org
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/exec/cpu-common.h |  1 +
 include/exec/memory.h     | 16 +++++++++++++---
 include/exec/ram_addr.h   |  3 ++-
 include/qemu/mmap-alloc.h |  2 ++
 include/qemu/osdep.h      |  3 ++-
 migration/ram.c           |  3 +--
 softmmu/physmem.c         | 16 +++++++++++-----
 util/mmap-alloc.c         |  7 +++++++
 util/oslib-posix.c        |  6 ++++--
 util/oslib-win32.c        | 13 ++++++++++++-
 10 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 5a0a2d93e0..38a47ad4ac 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -58,6 +58,7 @@ void *qemu_ram_get_host_addr(RAMBlock *rb);
 ram_addr_t qemu_ram_get_offset(RAMBlock *rb);
 ram_addr_t qemu_ram_get_used_length(RAMBlock *rb);
 bool qemu_ram_is_shared(RAMBlock *rb);
+bool qemu_ram_is_noreserve(RAMBlock *rb);
 bool qemu_ram_is_uf_zeroable(RAMBlock *rb);
 void qemu_ram_set_uf_zeroable(RAMBlock *rb);
 bool qemu_ram_is_migratable(RAMBlock *rb);
diff --git a/include/exec/memory.h b/include/exec/memory.h
index 2d97bdf59c..1369497415 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -155,6 +155,14 @@ typedef struct IOMMUTLBEvent {
  */
 #define RAM_UF_WRITEPROTECT (1 << 6)
 
+/*
+ * RAM is mmap-ed with MAP_NORESERVE. When set, reserving swap space (or huge
+ * pages Linux) is skipped: will bail out if not supported. When not set, the
+ * OS might reserve swap space (or huge pages on Linux), depending on OS
+ * support.
+ */
+#define RAM_NORESERVE (1 << 7)
+
 static inline void iommu_notifier_init(IOMMUNotifier *n, IOMMUNotify fn,
                                        IOMMUNotifierFlag flags,
                                        hwaddr start, hwaddr end,
@@ -913,7 +921,7 @@ void memory_region_init_ram_nomigrate(MemoryRegion *mr,
  * @name: Region name, becomes part of RAMBlock name used in migration stream
  *        must be unique within any device
  * @size: size of the region.
- * @ram_flags: RamBlock flags. Supported flags: RAM_SHARED.
+ * @ram_flags: RamBlock flags. Supported flags: RAM_SHARED, RAM_NORESERVE.
  * @errp: pointer to Error*, to store an error if it happens.
  *
  * Note that this function does not do anything to cause the data in the
@@ -967,7 +975,8 @@ void memory_region_init_resizeable_ram(MemoryRegion *mr,
  * @size: size of the region.
  * @align: alignment of the region base address; if 0, the default alignment
  *         (getpagesize()) will be used.
- * @ram_flags: RamBlock flags. Supported flags: RAM_SHARED, RAM_PMEM.
+ * @ram_flags: RamBlock flags. Supported flags: RAM_SHARED, RAM_PMEM,
+ *             RAM_NORESERVE,
  * @path: the path in which to allocate the RAM.
  * @readonly: true to open @path for reading, false for read/write.
  * @errp: pointer to Error*, to store an error if it happens.
@@ -993,7 +1002,8 @@ void memory_region_init_ram_from_file(MemoryRegion *mr,
  * @owner: the object that tracks the region's reference count
  * @name: the name of the region.
  * @size: size of the region.
- * @ram_flags: RamBlock flags. Supported flags: RAM_SHARED, RAM_PMEM.
+ * @ram_flags: RamBlock flags. Supported flags: RAM_SHARED, RAM_PMEM,
+ *             RAM_NORESERVE.
  * @fd: the fd to mmap.
  * @offset: offset within the file referenced by fd
  * @errp: pointer to Error*, to store an error if it happens.
diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
index 6d4513f8e2..551876bed0 100644
--- a/include/exec/ram_addr.h
+++ b/include/exec/ram_addr.h
@@ -104,7 +104,8 @@ long qemu_maxrampagesize(void);
  * Parameters:
  *  @size: the size in bytes of the ram block
  *  @mr: the memory region where the ram block is
- *  @ram_flags: RamBlock flags. Supported flags: RAM_SHARED, RAM_PMEM.
+ *  @ram_flags: RamBlock flags. Supported flags: RAM_SHARED, RAM_PMEM,
+ *              RAM_NORESERVE.
  *  @mem_path or @fd: specify the backing file or device
  *  @readonly: true to open @path for reading, false for read/write.
  *  @errp: pointer to Error*, to store an error if it happens
diff --git a/include/qemu/mmap-alloc.h b/include/qemu/mmap-alloc.h
index 456ff87df1..4b43619bec 100644
--- a/include/qemu/mmap-alloc.h
+++ b/include/qemu/mmap-alloc.h
@@ -17,6 +17,7 @@ size_t qemu_mempath_getpagesize(const char *mem_path);
  *  @readonly: true for a read-only mapping, false for read/write.
  *  @shared: map has RAM_SHARED flag.
  *  @is_pmem: map has RAM_PMEM flag.
+ *  @noreserve: map has RAM_NORESERVE flag.
  *  @map_offset: map starts at offset of map_offset from the start of fd
  *
  * Return:
@@ -29,6 +30,7 @@ void *qemu_ram_mmap(int fd,
                     bool readonly,
                     bool shared,
                     bool is_pmem,
+                    bool noreserve,
                     off_t map_offset);
 
 void qemu_ram_munmap(int fd, void *ptr, size_t size);
diff --git a/include/qemu/osdep.h b/include/qemu/osdep.h
index ba15be9c56..d6d8ef0999 100644
--- a/include/qemu/osdep.h
+++ b/include/qemu/osdep.h
@@ -343,7 +343,8 @@ extern int daemon(int, int);
 int qemu_daemon(int nochdir, int noclose);
 void *qemu_try_memalign(size_t alignment, size_t size);
 void *qemu_memalign(size_t alignment, size_t size);
-void *qemu_anon_ram_alloc(size_t size, uint64_t *align, bool shared);
+void *qemu_anon_ram_alloc(size_t size, uint64_t *align, bool shared,
+                          bool noreserve);
 void qemu_vfree(void *ptr);
 void qemu_anon_ram_free(void *ptr, size_t size);
 
diff --git a/migration/ram.c b/migration/ram.c
index 72143da0ac..dd8daad386 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -3322,8 +3322,7 @@ int colo_init_ram_cache(void)
     WITH_RCU_READ_LOCK_GUARD() {
         RAMBLOCK_FOREACH_NOT_IGNORED(block) {
             block->colo_cache = qemu_anon_ram_alloc(block->used_length,
-                                                    NULL,
-                                                    false);
+                                                    NULL, false, false);
             if (!block->colo_cache) {
                 error_report("%s: Can't alloc memory for COLO cache of block %s,"
                              "size 0x" RAM_ADDR_FMT, __func__, block->idstr,
diff --git a/softmmu/physmem.c b/softmmu/physmem.c
index 58ac4bffe2..768e462529 100644
--- a/softmmu/physmem.c
+++ b/softmmu/physmem.c
@@ -1582,7 +1582,7 @@ static void *file_ram_alloc(RAMBlock *block,
 
     area = qemu_ram_mmap(fd, memory, block->mr->align, readonly,
                          block->flags & RAM_SHARED, block->flags & RAM_PMEM,
-                         offset);
+                         block->flags & RAM_NORESERVE, offset);
     if (area == MAP_FAILED) {
         error_setg_errno(errp, errno,
                          "unable to map backing store for guest RAM");
@@ -1702,6 +1702,11 @@ bool qemu_ram_is_shared(RAMBlock *rb)
     return rb->flags & RAM_SHARED;
 }
 
+bool qemu_ram_is_noreserve(RAMBlock *rb)
+{
+    return rb->flags & RAM_NORESERVE;
+}
+
 /* Note: Only set at the start of postcopy */
 bool qemu_ram_is_uf_zeroable(RAMBlock *rb)
 {
@@ -1930,6 +1935,7 @@ static void dirty_memory_extend(ram_addr_t old_ram_size,
 static void ram_block_add(RAMBlock *new_block, Error **errp)
 {
     const bool shared = qemu_ram_is_shared(new_block);
+    const bool noreserve = qemu_ram_is_noreserve(new_block);
     RAMBlock *block;
     RAMBlock *last_block = NULL;
     ram_addr_t old_ram_size, new_ram_size;
@@ -1952,7 +1958,7 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
         } else {
             new_block->host = qemu_anon_ram_alloc(new_block->max_length,
                                                   &new_block->mr->align,
-                                                  shared);
+                                                  shared, noreserve);
             if (!new_block->host) {
                 error_setg_errno(errp, errno,
                                  "cannot set up guest memory '%s'",
@@ -2023,7 +2029,7 @@ RAMBlock *qemu_ram_alloc_from_fd(ram_addr_t size, MemoryRegion *mr,
     int64_t file_size, file_align;
 
     /* Just support these ram flags by now. */
-    assert((ram_flags & ~(RAM_SHARED | RAM_PMEM)) == 0);
+    assert((ram_flags & ~(RAM_SHARED | RAM_PMEM | RAM_NORESERVE)) == 0);
 
     if (xen_enabled()) {
         error_setg(errp, "-mem-path not supported with Xen");
@@ -2114,7 +2120,7 @@ RAMBlock *qemu_ram_alloc_internal(ram_addr_t size, ram_addr_t max_size,
     RAMBlock *new_block;
     Error *local_err = NULL;
 
-    assert((ram_flags & ~(RAM_SHARED | RAM_RESIZEABLE)) == 0);
+    assert((ram_flags & ~(RAM_SHARED | RAM_RESIZEABLE | RAM_NORESERVE)) == 0);
 
     size = HOST_PAGE_ALIGN(size);
     max_size = HOST_PAGE_ALIGN(max_size);
@@ -2149,7 +2155,7 @@ RAMBlock *qemu_ram_alloc_from_ptr(ram_addr_t size, void *host,
 RAMBlock *qemu_ram_alloc(ram_addr_t size, uint32_t ram_flags,
                          MemoryRegion *mr, Error **errp)
 {
-    assert((ram_flags & ~RAM_SHARED) == 0);
+    assert((ram_flags & ~(RAM_SHARED | RAM_NORESERVE)) == 0);
     return qemu_ram_alloc_internal(size, size, NULL, NULL, ram_flags, mr, errp);
 }
 
diff --git a/util/mmap-alloc.c b/util/mmap-alloc.c
index 0e2bd7bc0e..397cb20a76 100644
--- a/util/mmap-alloc.c
+++ b/util/mmap-alloc.c
@@ -20,6 +20,7 @@
 #include "qemu/osdep.h"
 #include "qemu/mmap-alloc.h"
 #include "qemu/host-utils.h"
+#include "qemu/error-report.h"
 
 #define HUGETLBFS_MAGIC       0x958458f6
 
@@ -176,12 +177,18 @@ void *qemu_ram_mmap(int fd,
                     bool readonly,
                     bool shared,
                     bool is_pmem,
+                    bool noreserve,
                     off_t map_offset)
 {
     const size_t guard_pagesize = mmap_guard_pagesize(fd);
     size_t offset, total;
     void *ptr, *guardptr;
 
+    if (noreserve) {
+        error_report("Skipping reservation of swap space is not supported");
+        return MAP_FAILED;
+    }
+
     /*
      * Note: this always allocates at least one extra page of virtual address
      * space, even if size is already aligned.
diff --git a/util/oslib-posix.c b/util/oslib-posix.c
index 36820fec16..f5daf33c46 100644
--- a/util/oslib-posix.c
+++ b/util/oslib-posix.c
@@ -227,10 +227,12 @@ void *qemu_memalign(size_t alignment, size_t size)
 }
 
 /* alloc shared memory pages */
-void *qemu_anon_ram_alloc(size_t size, uint64_t *alignment, bool shared)
+void *qemu_anon_ram_alloc(size_t size, uint64_t *alignment, bool shared,
+                          bool noreserve)
 {
     size_t align = QEMU_VMALLOC_ALIGN;
-    void *ptr = qemu_ram_mmap(-1, size, align, false, shared, false, 0);
+    void *ptr = qemu_ram_mmap(-1, size, align, false, shared, false, noreserve,
+                              0);
 
     if (ptr == MAP_FAILED) {
         return NULL;
diff --git a/util/oslib-win32.c b/util/oslib-win32.c
index f68b8012bb..8cafe44179 100644
--- a/util/oslib-win32.c
+++ b/util/oslib-win32.c
@@ -39,6 +39,7 @@
 #include "trace.h"
 #include "qemu/sockets.h"
 #include "qemu/cutils.h"
+#include "qemu/error-report.h"
 #include <malloc.h>
 
 /* this must come after including "trace.h" */
@@ -77,10 +78,20 @@ static int get_allocation_granularity(void)
     return system_info.dwAllocationGranularity;
 }
 
-void *qemu_anon_ram_alloc(size_t size, uint64_t *align, bool shared)
+void *qemu_anon_ram_alloc(size_t size, uint64_t *align, bool shared,
+                          bool noreserve)
 {
     void *ptr;
 
+    if (noreserve) {
+        /*
+         * We need a MEM_COMMIT before accessing any memory in a MEM_RESERVE
+         * area; we cannot easily mimic POSIX MAP_NORESERVE semantics.
+         */
+        error_report("Skipping reservation of swap space is not supported.");
+        return NULL;
+    }
+
     ptr = VirtualAlloc(NULL, size, MEM_COMMIT, PAGE_READWRITE);
     trace_qemu_anon_ram_alloc(size, ptr);
 
-- 
2.29.2

