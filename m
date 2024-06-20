Return-Path: <kvm+bounces-20058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 538889100BB
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 11:47:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A52311F26064
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 09:47:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07DBD1A4F20;
	Thu, 20 Jun 2024 09:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iRoLBVym"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1019F2594
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 09:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718876851; cv=none; b=bBLC/Eem7LOP+Q/5cZGEEsd4dypMUna2/5Yj3ZyGq1lb9JmhjF4vANTIfOYyG07w0VWz/Rvw+t4LEd+1LAggpXSYi7oU6j0iVpmt+MQ0C33zpngCEhZxxQVjfjX4f1bsx/HT25dZRtfMQFDigFiF0Fqr8hKzZlwWw6rpJzx3ZhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718876851; c=relaxed/simple;
	bh=ZwjZCva2nPjKW6eSYSp9sTtVWFzVf5cl8CW8gcsypbU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X+BbECPGrybUUm53VWDz9JO4P+WBDjRnNJUshoapTc/da1seF0JObzc4HRv8cKKpBqQl/5aWqxBaKf5aYpjUJSaecM02VaxpfANEoMP9YwyE1OZzl55/apUkTmIqIUPD3bjIcMcFE6TZfNNe3NhauTXQM0RTj/D3PdAxLigD3SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iRoLBVym; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1f7274a453bso5576325ad.2
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 02:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718876848; x=1719481648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PgQ2VWwSRJvrka/NwQyki/HUAVlNqzJSr4msKXGLKwc=;
        b=iRoLBVym5pTVbxkuVSawUxwHMKVpWKaR3hq3MknzW1XEP1bogG/UqvZSuu0RN6zXhq
         lobgDcSenM8FMcdsTTdv11oXkTUxDVmRDImBGXpNQPNImo4363XA6bvoq55plNKrHBln
         ushW+pcvSkSLegoNXCv1hum64kR7it3v6KS2+tQbyRYRRq/JyH+FuN6vMP6lEHJaVlU0
         DhqvQOaKe8TXQ4JYByHiv7wXKEFof/GX8N9JThid/IMPJy9WYZkKMhO4ZDlNWeDEaYOx
         Ezu2JJCXcT8VQnB7/exmtoal1MI6bPMeGAyoubgIRxrF8RwHD1xCNUs/pEevFsSoxarb
         mnPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718876848; x=1719481648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PgQ2VWwSRJvrka/NwQyki/HUAVlNqzJSr4msKXGLKwc=;
        b=kf/FBHUfjZfYjnkkS1g5JKMOClkR0m5SzTBdmnUJTdboNIXgDZOK0jfmBH1qbQmji7
         g4VxEEmpuOXgs8gLFHs4iy8L3p/ffAHEO2eSqzctPkRkmxabm5mJXOyiePKcbKzZCELF
         832dpYFwM/nk41QOb1CJUU+vdVukv+vSChr8scdqDml/X7TbUiIYmgR+e1HtZSVOJevF
         dOq036OjYbeaJmHgM00nKjzRht4cnDy+5JIN+SKetMyt2nZId4ea62WstkrJiBdt0KU8
         DYosUuvncIPpxPo8qIDD+q1Qh/+1CbsHJ9+EDATJAYZjTvRkNJCUbTiZTJEw+VrXYi4n
         bplA==
X-Forwarded-Encrypted: i=1; AJvYcCUx8pfw/eBT7+X3L0UPQyOSGj2j18I26SdRy/nWPnJFAX3w3aV+mek2ipZZPKlklAx3nci4yioDo1Sr8Wz2flRu4Yb2
X-Gm-Message-State: AOJu0YxVj400pFms7NkeMeJ2Mahhf4y2u2Kaff4f5X2m5OB3bMUxWcgm
	zWc1ivkr2ejHHslA203aC53wkWIPuXoWn2+2CnO3lCzN8Ibxw+8qRbPBm/5K0UQ=
X-Google-Smtp-Source: AGHT+IHd28ZN6La1xBKTY8V5v1l/hzPQXsuSIg5jdcNTOMv+LGnSBUR0ECLIJuYXF7W5GRoA/6UpPg==
X-Received: by 2002:a17:902:f68f:b0:1f6:f82d:a8cb with SMTP id d9443c01a7336-1f9aa473dd4mr44952935ad.52.1718876847933;
        Thu, 20 Jun 2024 02:47:27 -0700 (PDT)
Received: from localhost.localdomain (KD175132079186.ppp-bb.dion.ne.jp. [175.132.79.186])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f993deb126sm49350585ad.219.2024.06.20.02.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 02:47:27 -0700 (PDT)
From: Shota Imamura <cosocaf@gmail.com>
To: qemu-devel@nongnu.org
Cc: Shota Imamura <cosocaf@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PATCH 1/2] migration: Implement dirty ring
Date: Thu, 20 Jun 2024 18:47:13 +0900
Message-Id: <20240620094714.871727-2-cosocaf@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240620094714.871727-1-cosocaf@gmail.com>
References: <20240620094714.871727-1-cosocaf@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit implements the dirty ring as an alternative dirty tracking
method to the dirty bitmap.

While the dirty ring has already been implemented in accel/kvm using KVM's
dirty ring, it was designed to set bits in the ramlist and ramblock bitmap.
This commit introduces a new dirty ring to replace the bitmap, allowing the
use of the dirty ring even without KVM. When using KVM's dirty ring, this
implementation maximizes its effectiveness.

To enable the dirty ring, specify the startup option
"-migration dirty-logging=ring,dirty-ring-size=N". To use the bitmap,
either specify nothing or "-migration dirty-logging=bitmap". If the dirty
ring becomes full, it falls back to the bitmap for that round.

Signed-off-by: Shota Imamura <cosocaf@gmail.com>
---
 accel/kvm/kvm-all.c            |  36 ++++++++-
 include/exec/ram_addr.h        | 131 +++++++++++++++++++++++++++++++--
 include/exec/ramlist.h         |  48 ++++++++++++
 include/migration/misc.h       |   4 +-
 include/qemu/bitops.h          |  23 ++++++
 migration/migration-hmp-cmds.c |   2 +
 migration/migration.c          |  27 ++++++-
 migration/migration.h          |   6 ++
 migration/ram.c                | 127 ++++++++++++++++++++++++++++----
 qemu-options.hx                |  29 ++++++++
 system/physmem.c               | 128 +++++++++++++++++++++++++++++++-
 system/vl.c                    |  63 +++++++++++++++-
 12 files changed, 597 insertions(+), 27 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 854cb86b22..91410d682f 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -667,7 +667,13 @@ static void kvm_dirty_ring_mark_page(KVMState *s, uint32_t as_id,
         return;
     }
 
-    set_bit(offset, mem->dirty_bmap);
+    if (!test_and_set_bit(offset, mem->dirty_bmap) &&
+        mem->flags & KVM_MEM_LOG_DIRTY_PAGES &&
+        migration_has_dirty_ring()) {
+        unsigned long pfn =
+            (mem->ram_start_offset >> TARGET_PAGE_BITS) + offset;
+        ram_list_enqueue_dirty(pfn);
+    }
 }
 
 static bool dirty_gfn_is_dirtied(struct kvm_dirty_gfn *gfn)
@@ -1675,6 +1681,34 @@ static void kvm_log_sync_global(MemoryListener *l, bool last_stage)
     /* Flush all kernel dirty addresses into KVMSlot dirty bitmap */
     kvm_dirty_ring_flush();
 
+    if (!ram_list_enqueue_dirty_full()) {
+        cpu_physical_memory_set_dirty_ring(ram_list_get_enqueue_dirty());
+
+        if (s->kvm_dirty_ring_with_bitmap && last_stage) {
+            kvm_slots_lock();
+            for (i = 0; i < s->nr_slots; i++) {
+                mem = &kml->slots[i];
+                if (mem->memory_size &&
+                    mem->flags & KVM_MEM_LOG_DIRTY_PAGES &&
+                    kvm_slot_get_dirty_log(s, mem)) {
+                    kvm_slot_sync_dirty_pages(mem);
+                }
+            }
+            kvm_slots_unlock();
+        }
+
+        kvm_slots_lock();
+        for (i = 0; i < s->nr_slots; i++) {
+            mem = &kml->slots[i];
+            if (mem->memory_size && mem->flags & KVM_MEM_LOG_DIRTY_PAGES) {
+                kvm_slot_reset_dirty_pages(mem);
+            }
+        }
+        kvm_slots_unlock();
+
+        return;
+    }
+
     /*
      * TODO: make this faster when nr_slots is big while there are
      * only a few used slots (small VMs).
diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
index 891c44cf2d..1eaebcf22f 100644
--- a/include/exec/ram_addr.h
+++ b/include/exec/ram_addr.h
@@ -27,6 +27,7 @@
 #include "exec/ramblock.h"
 #include "exec/exec-all.h"
 #include "qemu/rcu.h"
+#include "migration/misc.h"
 
 extern uint64_t total_dirty_pages;
 
@@ -282,7 +283,11 @@ static inline void cpu_physical_memory_set_dirty_flag(ram_addr_t addr,
 
     blocks = qatomic_rcu_read(&ram_list.dirty_memory[client]);
 
-    set_bit_atomic(offset, blocks->blocks[idx]);
+    if (!test_and_set_bit_atomic(offset, blocks->blocks[idx]) &&
+        migration_has_dirty_ring() &&
+        client == DIRTY_MEMORY_MIGRATION) {
+        ram_list_enqueue_dirty(page);
+    }
 }
 
 static inline void cpu_physical_memory_set_dirty_range(ram_addr_t start,
@@ -313,8 +318,24 @@ static inline void cpu_physical_memory_set_dirty_range(ram_addr_t start,
             unsigned long next = MIN(end, base + DIRTY_MEMORY_BLOCK_SIZE);
 
             if (likely(mask & (1 << DIRTY_MEMORY_MIGRATION))) {
-                bitmap_set_atomic(blocks[DIRTY_MEMORY_MIGRATION]->blocks[idx],
-                                  offset, next - page);
+                if (!migration_has_dirty_ring() ||
+                    ram_list_enqueue_dirty_full()) {
+                    use_dirty_bmap:
+                    bitmap_set_atomic(
+                        blocks[DIRTY_MEMORY_MIGRATION]->blocks[idx],
+                        offset,
+                        next - page);
+                } else {
+                    for (unsigned long p = page; p < next; p++) {
+                        if (!test_and_set_bit_atomic(
+                                p % DIRTY_MEMORY_BLOCK_SIZE,
+                                blocks[DIRTY_MEMORY_MIGRATION]->blocks[idx])) {
+                            if (unlikely(!ram_list_enqueue_dirty(p))) {
+                                goto use_dirty_bmap;
+                            }
+                        }
+                    }
+                }
             }
             if (unlikely(mask & (1 << DIRTY_MEMORY_VGA))) {
                 bitmap_set_atomic(blocks[DIRTY_MEMORY_VGA]->blocks[idx],
@@ -384,9 +405,29 @@ uint64_t cpu_physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
                     qatomic_or(&blocks[DIRTY_MEMORY_VGA][idx][offset], temp);
 
                     if (global_dirty_tracking) {
-                        qatomic_or(
+                        if (!migration_has_dirty_ring() ||
+                            ram_list_enqueue_dirty_full()) {
+                            use_dirty_bmap:
+                            qatomic_or(
                                 &blocks[DIRTY_MEMORY_MIGRATION][idx][offset],
                                 temp);
+                        } else {
+                            for (unsigned long p = 0; p < BITS_PER_LONG; p++) {
+                                if (temp & (1ul << p)) {
+                                    unsigned long pfn =
+                                        (k * BITS_PER_LONG + p) +
+                                        (start >> TARGET_PAGE_BITS);
+                                    if (!test_and_set_bit_atomic(
+                                            pfn % DIRTY_MEMORY_BLOCK_SIZE,
+                                            blocks[DIRTY_MEMORY_MIGRATION][idx])) {
+                                        if (unlikely(!ram_list_enqueue_dirty(pfn))) {
+                                            goto use_dirty_bmap;
+                                        }
+                                    }
+                                }
+                            }
+                        }
+
                         if (unlikely(
                             global_dirty_tracking & GLOBAL_DIRTY_DIRTY_RATE)) {
                             total_dirty_pages += nbits;
@@ -443,6 +484,53 @@ uint64_t cpu_physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
 
     return num_dirty;
 }
+
+static inline
+uint64_t cpu_physical_memory_set_dirty_ring(DirtyRing *ring)
+{
+    uint64_t num_dirty = 0;
+    unsigned long **blocks[DIRTY_MEMORY_NUM];
+
+    WITH_RCU_READ_LOCK_GUARD() {
+        for (int i = 0; i < DIRTY_MEMORY_NUM; i++) {
+            blocks[i] =
+                qatomic_rcu_read(&ram_list.dirty_memory[i])->blocks;
+        }
+
+        for (unsigned long rpos = ring->rpos, wpos = ring->wpos;
+             rpos != wpos;
+             rpos++) {
+            unsigned long page = ring->buffer[rpos & ring->mask];
+            unsigned long idx = page / DIRTY_MEMORY_BLOCK_SIZE;
+            unsigned long offset = BIT_WORD(page % DIRTY_MEMORY_BLOCK_SIZE);
+
+            qatomic_or(&blocks[DIRTY_MEMORY_VGA][idx][offset], BIT_MASK(page));
+
+            if (global_dirty_tracking) {
+                qatomic_or(
+                    &blocks[DIRTY_MEMORY_MIGRATION][idx][offset],
+                    BIT_MASK(page));
+
+                if (unlikely(
+                    global_dirty_tracking & GLOBAL_DIRTY_DIRTY_RATE)) {
+                    total_dirty_pages++;
+                }
+            }
+
+            if (tcg_enabled()) {
+                qatomic_or(&blocks[DIRTY_MEMORY_CODE][idx][offset],
+                           BIT_MASK(page));
+            }
+
+            num_dirty++;
+
+            xen_hvm_modified_memory(page << TARGET_PAGE_BITS,
+                                    TARGET_PAGE_SIZE);
+        }
+    }
+
+    return num_dirty;
+}
 #endif /* not _WIN32 */
 
 static inline void cpu_physical_memory_dirty_bits_cleared(ram_addr_t start,
@@ -484,8 +572,41 @@ uint64_t cpu_physical_memory_sync_dirty_bitmap(RAMBlock *rb,
     uint64_t num_dirty = 0;
     unsigned long *dest = rb->bmap;
 
+    if (migration_has_dirty_ring() && !ram_list_dequeue_dirty_full()) {
+        unsigned long *const *src = qatomic_rcu_read(
+                &ram_list.dirty_memory[DIRTY_MEMORY_MIGRATION])->blocks;
+
+        DirtyRing *ring = ram_list_get_dequeue_dirty();
+        for (unsigned long rpos = ring->rpos, wpos = ring->wpos;
+             rpos != wpos;
+             rpos++) {
+            unsigned long page = ring->buffer[rpos & ring->mask];
+            if (page >= ((start + rb->offset) >> TARGET_PAGE_BITS) &&
+                page < ((start + rb->offset + length) >> TARGET_PAGE_BITS)) {
+                if (!test_and_set_bit(page - (rb->offset >> TARGET_PAGE_BITS),
+                                      dest)) {
+                    num_dirty++;
+                }
+
+                unsigned long idx = page / DIRTY_MEMORY_BLOCK_SIZE;
+                unsigned long offset = BIT_WORD(page % DIRTY_MEMORY_BLOCK_SIZE);
+                src[idx][offset] &= ~BIT_MASK(page);
+            }
+        }
+
+        if (num_dirty) {
+            cpu_physical_memory_dirty_bits_cleared(start, length);
+        }
+
+        if (rb->clear_bmap) {
+            clear_bmap_set(rb, start >> TARGET_PAGE_BITS,
+                           length >> TARGET_PAGE_BITS);
+        } else {
+            memory_region_clear_dirty_bitmap(rb->mr, start, length);
+        }
+    }
     /* start address and length is aligned at the start of a word? */
-    if (((word * BITS_PER_LONG) << TARGET_PAGE_BITS) ==
+    else if (((word * BITS_PER_LONG) << TARGET_PAGE_BITS) ==
          (start + rb->offset) &&
         !(length & ((BITS_PER_LONG << TARGET_PAGE_BITS) - 1))) {
         int k;
diff --git a/include/exec/ramlist.h b/include/exec/ramlist.h
index 2ad2a81acc..598b6d5a05 100644
--- a/include/exec/ramlist.h
+++ b/include/exec/ramlist.h
@@ -5,6 +5,7 @@
 #include "qemu/thread.h"
 #include "qemu/rcu.h"
 #include "qemu/rcu_queue.h"
+#include "exec/cpu-common.h"
 
 typedef struct RAMBlockNotifier RAMBlockNotifier;
 
@@ -44,6 +45,37 @@ typedef struct {
     unsigned long *blocks[];
 } DirtyMemoryBlocks;
 
+/*
+ * Ring buffer for dirty memory tracking.
+ * This ring buffer does not support deletion of intermediate elements.
+ * Therefore, the dirty bitmap must be checked to determine if a region has
+ * been cleared.
+ */
+typedef struct {
+    /*
+     * The starting address of the dirty-ring. It is NULL if the dirty-ring
+     * is not enabled.
+     */
+    unsigned long *buffer;
+    /*
+     * The number of elements in the dirty-ring.
+     * Must be a power of 2. Note that the actual limit of elements that can
+     * be inserted is dirty_ring_size - 1 due to ring-buffer constraints.
+     */
+    unsigned long size;
+    /* The mask for obtaining the index in the dirty-ring. */
+    unsigned long mask;
+    /*
+     * The current read position in the dirty-ring.
+     * If dirty_ring_rpos == dirty_ring_wpos, the dirty-ring is empty.
+     * If dirty_ring_wpos - dirty_ring_rpos == dirty_ring_size, the dirty-ring
+     * is full.
+     */
+    unsigned long rpos;
+    /* The current write position in the dirty-ring. */
+    unsigned long wpos;
+} DirtyRing;
+
 typedef struct RAMList {
     QemuMutex mutex;
     RAMBlock *mru_block;
@@ -52,6 +84,9 @@ typedef struct RAMList {
     DirtyMemoryBlocks *dirty_memory[DIRTY_MEMORY_NUM];
     uint32_t version;
     QLIST_HEAD(, RAMBlockNotifier) ramblock_notifiers;
+    /* Used only when dirty-ring is enabled */
+    uint32_t dirty_ring_switch;
+    DirtyRing dirty_rings[2];
 } RAMList;
 extern RAMList ram_list;
 
@@ -63,6 +98,8 @@ extern RAMList ram_list;
 
 void qemu_mutex_lock_ramlist(void);
 void qemu_mutex_unlock_ramlist(void);
+/* Called from RCU critical section */
+RAMBlock *qemu_get_ram_block(ram_addr_t addr);
 
 struct RAMBlockNotifier {
     void (*ram_block_added)(RAMBlockNotifier *n, void *host, size_t size,
@@ -80,6 +117,17 @@ void ram_block_notify_add(void *host, size_t size, size_t max_size);
 void ram_block_notify_remove(void *host, size_t size, size_t max_size);
 void ram_block_notify_resize(void *host, size_t old_size, size_t new_size);
 
+DirtyRing *ram_list_get_enqueue_dirty(void);
+DirtyRing *ram_list_get_dequeue_dirty(void);
+bool ram_list_enqueue_dirty(unsigned long page);
+bool ram_list_dequeue_dirty(unsigned long *page);
+unsigned long ram_list_enqueue_dirty_capacity(void);
+unsigned long ram_list_dequeue_dirty_capacity(void);
+bool ram_list_enqueue_dirty_full(void);
+bool ram_list_dequeue_dirty_full(void);
+void ram_list_dequeue_dirty_reset(void);
+void ram_list_dirty_ring_switch(void);
+
 GString *ram_block_format(void);
 
 #endif /* RAMLIST_H */
diff --git a/include/migration/misc.h b/include/migration/misc.h
index bfadc5613b..1335e0958e 100644
--- a/include/migration/misc.h
+++ b/include/migration/misc.h
@@ -51,13 +51,15 @@ AnnounceParameters *migrate_announce_params(void);
 void dump_vmstate_json_to_file(FILE *out_fp);
 
 /* migration/migration.c */
-void migration_object_init(void);
+void migration_object_init(QDict *qdict);
 void migration_shutdown(void);
 bool migration_is_idle(void);
 bool migration_is_active(void);
 bool migration_is_device(void);
 bool migration_thread_is_self(void);
 bool migration_is_setup_or_active(void);
+bool migration_has_dirty_ring(void);
+unsigned long migration_get_dirty_ring_size(void);
 
 typedef enum MigrationEventType {
     MIG_EVENT_PRECOPY_SETUP,
diff --git a/include/qemu/bitops.h b/include/qemu/bitops.h
index 2c0a2fe751..ea5d02d0ec 100644
--- a/include/qemu/bitops.h
+++ b/include/qemu/bitops.h
@@ -108,6 +108,29 @@ static inline int test_and_set_bit(long nr, unsigned long *addr)
     return (old & mask) != 0;
 }
 
+/**
+ * test_and_set_bit_atomic - Set a bit and return its old value atomically
+ * @nr: Bit to set
+ * @addr: Address to count from
+ */
+static inline int test_and_set_bit_atomic(long nr, unsigned long *addr)
+{
+    unsigned long mask = BIT_MASK(nr);
+    unsigned long *p = addr + BIT_WORD(nr);
+    unsigned long old;
+    unsigned long desired;
+
+    do {
+        old = qatomic_read(p);
+        if (old & mask) {
+            return false;
+        }
+        desired = old | mask;
+    } while (qatomic_cmpxchg(p, old, desired) != desired);
+
+    return true;
+}
+
 /**
  * test_and_clear_bit - Clear a bit and return its old value
  * @nr: Bit to clear
diff --git a/migration/migration-hmp-cmds.c b/migration/migration-hmp-cmds.c
index 9f0e8029e0..02b1fa7b29 100644
--- a/migration/migration-hmp-cmds.c
+++ b/migration/migration-hmp-cmds.c
@@ -48,6 +48,8 @@ static void migration_global_dump(Monitor *mon)
                    ms->send_section_footer ? "on" : "off");
     monitor_printf(mon, "clear-bitmap-shift: %u\n",
                    ms->clear_bitmap_shift);
+    monitor_printf(mon, "dirty-logging-method: %s\n",
+                   migration_has_dirty_ring() ? "ring" : "bitmap");
 }
 
 void hmp_info_migrate(Monitor *mon, const QDict *qdict)
diff --git a/migration/migration.c b/migration/migration.c
index e1b269624c..a059ac7626 100644
--- a/migration/migration.c
+++ b/migration/migration.c
@@ -44,6 +44,7 @@
 #include "qapi/qapi-events-migration.h"
 #include "qapi/qmp/qerror.h"
 #include "qapi/qmp/qnull.h"
+#include "qapi/qmp/qdict.h"
 #include "qemu/rcu.h"
 #include "postcopy-ram.h"
 #include "qemu/thread.h"
@@ -207,12 +208,20 @@ static int migration_stop_vm(MigrationState *s, RunState state)
     return ret;
 }
 
-void migration_object_init(void)
+void migration_object_init(QDict *qdict)
 {
     /* This can only be called once. */
     assert(!current_migration);
     current_migration = MIGRATION_OBJ(object_new(TYPE_MIGRATION));
 
+    const char *logging_method = qdict_get_try_str(qdict, "dirty-logging");
+    if (logging_method == NULL || strcmp(logging_method, "bitmap") == 0) {
+        current_migration->dirty_ring_size = 0;
+    } else if (strcmp(logging_method, "ring") == 0) {
+        current_migration->dirty_ring_size = qdict_get_int(qdict,
+                                                           "dirty-ring-size");
+    }
+
     /*
      * Init the migrate incoming object as well no matter whether
      * we'll use it or not.
@@ -1632,6 +1641,20 @@ bool migrate_mode_is_cpr(MigrationState *s)
     return s->parameters.mode == MIG_MODE_CPR_REBOOT;
 }
 
+bool migration_has_dirty_ring(void)
+{
+    MigrationState *s = current_migration;
+
+    return s->dirty_ring_size != 0;
+}
+
+unsigned long migration_get_dirty_ring_size(void)
+{
+    MigrationState *s = current_migration;
+
+    return s->dirty_ring_size;
+}
+
 int migrate_init(MigrationState *s, Error **errp)
 {
     int ret;
@@ -3806,6 +3829,8 @@ static void migration_instance_init(Object *obj)
     qemu_sem_init(&ms->wait_unplug_sem, 0);
     qemu_sem_init(&ms->postcopy_qemufile_src_sem, 0);
     qemu_mutex_init(&ms->qemu_file_lock);
+
+    ms->dirty_ring_size = 0;
 }
 
 /*
diff --git a/migration/migration.h b/migration/migration.h
index 6af01362d4..4dfdf98acc 100644
--- a/migration/migration.h
+++ b/migration/migration.h
@@ -457,6 +457,12 @@ struct MigrationState {
     bool switchover_acked;
     /* Is this a rdma migration */
     bool rdma_migration;
+
+    /*
+     * The number of elements in the dirty-ring.
+     * It is 0 if the dirty-ring is not enabled.
+     */
+    unsigned long dirty_ring_size;
 };
 
 void migrate_set_state(int *state, int old_state, int new_state);
diff --git a/migration/ram.c b/migration/ram.c
index ceea586b06..5bf45268ec 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -387,6 +387,7 @@ struct RAMState {
     bool xbzrle_started;
     /* Are we on the last stage of migration */
     bool last_stage;
+    bool first_bitmap_scanning;
 
     /* total handled target pages at the beginning of period */
     uint64_t target_page_count_prev;
@@ -1041,6 +1042,29 @@ static void migration_trigger_throttle(RAMState *rs)
     }
 }
 
+static uint64_t migration_sync_dirty_ring(RAMBlock *block)
+{
+    uint64_t dirty_page_count = 0;
+
+    uint64_t base = block->offset >> TARGET_PAGE_BITS;
+    uint64_t size = block->used_length >> TARGET_PAGE_BITS;
+    uint64_t nr = BITS_TO_LONGS(size);
+    for (uint64_t i = 0; i < nr; i++) {
+        if (block->bmap[i]) {
+            uint64_t page = i * BITS_PER_LONG;
+            uint64_t end = MIN(page + BITS_PER_LONG, size);
+            for (; page < end; page++) {
+                if (test_bit(page, block->bmap)) {
+                    ram_list_enqueue_dirty(base + page);
+                    dirty_page_count++;
+                }
+            }
+        }
+    }
+
+    return dirty_page_count;
+}
+
 static void migration_bitmap_sync(RAMState *rs, bool last_stage)
 {
     RAMBlock *block;
@@ -1052,9 +1076,48 @@ static void migration_bitmap_sync(RAMState *rs, bool last_stage)
         rs->time_last_bitmap_sync = qemu_clock_get_ms(QEMU_CLOCK_REALTIME);
     }
 
+    if (migration_has_dirty_ring()) {
+        if (unlikely(ram_list_dequeue_dirty_full())) {
+            ram_list_dequeue_dirty_reset();
+
+            if (ram_list_enqueue_dirty_capacity() >=
+                rs->migration_dirty_pages) {
+                uint64_t dirty_page_count = 0;
+                WITH_QEMU_LOCK_GUARD(&rs->bitmap_mutex) {
+                    WITH_RCU_READ_LOCK_GUARD() {
+                        RAMBLOCK_FOREACH_NOT_IGNORED(block) {
+                            dirty_page_count +=
+                                migration_sync_dirty_ring(block);
+                            if (dirty_page_count >=
+                                rs->migration_dirty_pages) {
+                                break;
+                            }
+                        }
+                    }
+                }
+            } else {
+                DirtyRing *ring = ram_list_get_enqueue_dirty();
+                ring->wpos = ring->rpos + ring->size;
+            }
+        } else {
+            unsigned long page;
+            while (ram_list_dequeue_dirty(&page)) {
+                block = qemu_get_ram_block(page << TARGET_PAGE_BITS);
+                if (test_bit(page - (block->offset >> TARGET_PAGE_BITS),
+                             block->bmap)) {
+                    ram_list_enqueue_dirty(page);
+                }
+            }
+        }
+    }
+
     trace_migration_bitmap_sync_start();
     memory_global_dirty_log_sync(last_stage);
 
+    if (migration_has_dirty_ring()) {
+        ram_list_dirty_ring_switch();
+    }
+
     WITH_QEMU_LOCK_GUARD(&rs->bitmap_mutex) {
         WITH_RCU_READ_LOCK_GUARD() {
             RAMBLOCK_FOREACH_NOT_IGNORED(block) {
@@ -2214,7 +2277,11 @@ static int ram_save_host_page(RAMState *rs, PageSearchStatus *pss)
             return tmppages;
         }
 
-        pss_find_next_dirty(pss);
+        if (!migration_has_dirty_ring()) {
+            pss_find_next_dirty(pss);
+        } else {
+            break;
+        }
     } while (pss_within_range(pss));
 
     pss_host_page_finish(pss);
@@ -2260,24 +2327,51 @@ static int ram_find_and_save_block(RAMState *rs)
 
     pss_init(pss, rs->last_seen_block, rs->last_page);
 
-    while (true){
-        if (!get_queued_page(rs, pss)) {
-            /* priority queue empty, so just search for something dirty */
-            int res = find_dirty_block(rs, pss);
-            if (res != PAGE_DIRTY_FOUND) {
-                if (res == PAGE_ALL_CLEAN) {
-                    break;
-                } else if (res == PAGE_TRY_AGAIN) {
-                    continue;
-                } else if (res < 0) {
-                    pages = res;
-                    break;
+    if (rs->first_bitmap_scanning ||
+        !migration_has_dirty_ring() ||
+        ram_list_dequeue_dirty_full()) {
+        while (true) {
+            if (!get_queued_page(rs, pss)) {
+                /* priority queue empty, so just search for something dirty */
+                int res = find_dirty_block(rs, pss);
+                if (pss->complete_round) {
+                    rs->first_bitmap_scanning = false;
                 }
+                if (res != PAGE_DIRTY_FOUND) {
+                    if (res == PAGE_ALL_CLEAN) {
+                        break;
+                    } else if (res == PAGE_TRY_AGAIN) {
+                        continue;
+                    } else if (res < 0) {
+                        pages = res;
+                        break;
+                    }
+                }
+            }
+            pages = ram_save_host_page(rs, pss);
+            if (pages) {
+                break;
             }
         }
-        pages = ram_save_host_page(rs, pss);
-        if (pages) {
-            break;
+    } else {
+        while (get_queued_page(rs, pss)) {
+            pages = ram_save_host_page(rs, pss);
+            if (pages) {
+                break;
+            }
+        }
+
+        if (!pages) {
+            unsigned long page;
+            while (ram_list_dequeue_dirty(&page)) {
+                pss->block = qemu_get_ram_block(page << TARGET_PAGE_BITS);
+                pss->page = page - (pss->block->offset >> TARGET_PAGE_BITS);
+                pss->complete_round = false;
+                pages = ram_save_host_page(rs, pss);
+                if (pages) {
+                    break;
+                }
+            }
         }
     }
 
@@ -2404,6 +2498,7 @@ static void ram_state_reset(RAMState *rs)
     rs->last_page = 0;
     rs->last_version = ram_list.version;
     rs->xbzrle_started = false;
+    rs->first_bitmap_scanning = true;
 }
 
 #define MAX_WAIT 50 /* ms, half buffered_file limit */
diff --git a/qemu-options.hx b/qemu-options.hx
index 8ca7f34ef0..f1ec592ec0 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -556,6 +556,35 @@ SRST
         -numa hmat-cache,node-id=1,size=10K,level=1,associativity=direct,policy=write-back,line=8
 ERST
 
+DEF("migration", HAS_ARG, QEMU_OPTION_migration,
+    "-migration [dirty-logging=method][,dirty-ring-size=n]\n"
+    "                Configure migration settings.\n"
+    "                dirty-logging: Specify the dirty logging method.\n"
+    "                    bitmap: Use bitmap-based dirty logging (default).\n"
+    "                    ring: Use ring-based dirty logging.\n"
+    "                dirty-ring-size: Specify the size of the dirty ring buffer.\n"
+    "                    This option is only applicable if dirty-logging is set to ring.\n"
+    "                    The size must be a power of 2.\n"
+    "                    Example: -migration dirty-logging=ring,dirty-ring-size=1024\n", QEMU_ARCH_ALL)
+SRST
+``-migration [dirty-logging=method,dirty-ring-size=n]``
+    Configure migration settings.
+
+    ``dirty-logging=bitmap``
+        Use bitmap-based dirty logging. This is the default method for tracking changes to memory pages during migration.
+
+    ``dirty-logging=ring``
+        Use ring-based dirty logging. This method uses a ring buffer to track changes to memory pages, which can be more efficient in some scenarios.
+
+    ``dirty-ring-size=n``
+        Specify the size of the dirty ring buffer when using ring-based dirty logging. The size must be a power of 2 (e.g., 1024, 2048, 4096). This option is only applicable if dirty-logging is set to ring.
+
+    Example:
+    ::
+
+        -migration dirty-logging=ring,dirty-ring-size=1024
+ERST
+
 DEF("add-fd", HAS_ARG, QEMU_OPTION_add_fd,
     "-add-fd fd=fd,set=set[,opaque=opaque]\n"
     "                Add 'fd' to fd 'set'\n", QEMU_ARCH_ALL)
diff --git a/system/physmem.c b/system/physmem.c
index 33d09f7571..2c2ee54eae 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -783,7 +783,7 @@ AddressSpace *cpu_get_address_space(CPUState *cpu, int asidx)
 }
 
 /* Called from RCU critical section */
-static RAMBlock *qemu_get_ram_block(ram_addr_t addr)
+RAMBlock *qemu_get_ram_block(ram_addr_t addr)
 {
     RAMBlock *block;
 
@@ -1804,6 +1804,37 @@ static void dirty_memory_extend(ram_addr_t old_ram_size,
     }
 }
 
+/* Called with ram_list.mutex held */
+static bool dirty_ring_init(Error **errp)
+{
+    static bool initialized;
+    if (initialized) {
+        return true;
+    }
+
+    unsigned long dirty_ring_size = migration_get_dirty_ring_size();
+
+    for (int i = 0; i < 2; i++) {
+        DirtyRing *ring = &ram_list.dirty_rings[i];
+        ring->buffer = g_malloc(sizeof(ring->buffer[0]) * dirty_ring_size);
+
+        if (ring->buffer == NULL) {
+            error_setg(errp, "Failed to allocate dirty ring buffer");
+            return false;
+        }
+
+        ring->size = dirty_ring_size;
+        ring->mask = dirty_ring_size - 1;
+        ring->rpos = 0;
+        ring->wpos = 0;
+    }
+
+    ram_list.dirty_ring_switch = 0;
+
+    initialized = true;
+    return true;
+}
+
 static void ram_block_add(RAMBlock *new_block, Error **errp)
 {
     const bool noreserve = qemu_ram_is_noreserve(new_block);
@@ -1868,6 +1899,13 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
     if (new_ram_size > old_ram_size) {
         dirty_memory_extend(old_ram_size, new_ram_size);
     }
+
+    if (migration_has_dirty_ring()) {
+        if (!dirty_ring_init(errp)) {
+            goto out_free;
+        }
+    }
+
     /* Keep the list sorted from biggest to smallest block.  Unlike QTAILQ,
      * QLIST (which has an RCU-friendly variant) does not have insertion at
      * tail, so save the last element in last_block.
@@ -3888,3 +3926,91 @@ bool ram_block_discard_is_required(void)
     return qatomic_read(&ram_block_discard_required_cnt) ||
            qatomic_read(&ram_block_coordinated_discard_required_cnt);
 }
+
+DirtyRing *ram_list_get_enqueue_dirty(void)
+{
+    return &ram_list.dirty_rings[ram_list.dirty_ring_switch & 1];
+}
+
+DirtyRing *ram_list_get_dequeue_dirty(void)
+{
+    return &ram_list.dirty_rings[(ram_list.dirty_ring_switch + 1) & 1];
+}
+
+bool ram_list_enqueue_dirty(unsigned long page)
+{
+    DirtyRing *ring = &ram_list.dirty_rings[ram_list.dirty_ring_switch & 1];
+
+    assert(ring->buffer);
+
+    if (unlikely(ring->wpos - ring->rpos == ring->size)) {
+        return false;
+    }
+
+    ring->buffer[ring->wpos & ring->mask] = page;
+    ring->wpos++;
+
+    return true;
+}
+
+bool ram_list_dequeue_dirty(unsigned long *page)
+{
+    DirtyRing *ring =
+        &ram_list.dirty_rings[(ram_list.dirty_ring_switch + 1) & 1];
+
+    assert(ring->buffer);
+
+    if (unlikely(ring->rpos == ring->wpos)) {
+        return false;
+    }
+
+    *page = ring->buffer[ring->rpos & ring->mask];
+    ring->rpos++;
+
+    return true;
+}
+
+unsigned long ram_list_enqueue_dirty_capacity(void)
+{
+    DirtyRing *ring = &ram_list.dirty_rings[ram_list.dirty_ring_switch & 1];
+
+    return ring->size - (ring->wpos - ring->rpos);
+
+}
+
+unsigned long ram_list_dequeue_dirty_capacity(void)
+{
+    DirtyRing *ring =
+        &ram_list.dirty_rings[(ram_list.dirty_ring_switch + 1) & 1];
+
+    return ring->wpos - ring->rpos;
+}
+
+bool ram_list_enqueue_dirty_full(void)
+{
+    DirtyRing *ring = &ram_list.dirty_rings[ram_list.dirty_ring_switch & 1];
+
+    return (ring->wpos - ring->rpos) == ring->size;
+}
+
+bool ram_list_dequeue_dirty_full(void)
+{
+    DirtyRing *ring =
+        &ram_list.dirty_rings[(ram_list.dirty_ring_switch + 1) & 1];
+
+    return (ring->wpos - ring->rpos) == ring->size;
+}
+
+void ram_list_dequeue_dirty_reset(void)
+{
+    DirtyRing *ring =
+        &ram_list.dirty_rings[(ram_list.dirty_ring_switch + 1) & 1];
+
+    ring->rpos = 0;
+    ring->wpos = 0;
+}
+
+void ram_list_dirty_ring_switch(void)
+{
+    ram_list.dirty_ring_switch++;
+}
diff --git a/system/vl.c b/system/vl.c
index a3eede5fa5..305a9386da 100644
--- a/system/vl.c
+++ b/system/vl.c
@@ -163,6 +163,7 @@ static const char *accelerators;
 static bool have_custom_ram_size;
 static const char *ram_memdev_id;
 static QDict *machine_opts_dict;
+static QDict *migration_opts_dict;
 static QTAILQ_HEAD(, ObjectOption) object_opts = QTAILQ_HEAD_INITIALIZER(object_opts);
 static QTAILQ_HEAD(, DeviceOption) device_opts = QTAILQ_HEAD_INITIALIZER(device_opts);
 static int display_remote;
@@ -758,6 +759,22 @@ static QemuOptsList qemu_smp_opts = {
     },
 };
 
+static QemuOptsList qemu_migration_opts = {
+    .name = "migration-opts",
+    .merge_lists = true,
+    .head = QTAILQ_HEAD_INITIALIZER(qemu_smp_opts.head),
+    .desc = {
+        {
+            .name = "dirty-logging", /* bitmap/ring */
+            .type = QEMU_OPT_STRING,
+        }, {
+            .name = "dirty-ring-size",
+            .type = QEMU_OPT_SIZE,
+        },
+        { /*End of list */ }
+    },
+};
+
 #if defined(CONFIG_POSIX)
 static QemuOptsList qemu_run_with_opts = {
     .name = "run-with",
@@ -2742,7 +2759,7 @@ void qmp_x_exit_preconfig(Error **errp)
 void qemu_init(int argc, char **argv)
 {
     QemuOpts *opts;
-    QemuOpts *icount_opts = NULL, *accel_opts = NULL;
+    QemuOpts *icount_opts = NULL, *accel_opts = NULL, *migration_opts = NULL;
     QemuOptsList *olist;
     int optind;
     const char *optarg;
@@ -2781,6 +2798,7 @@ void qemu_init(int argc, char **argv)
     qemu_add_opts(&qemu_semihosting_config_opts);
     qemu_add_opts(&qemu_fw_cfg_opts);
     qemu_add_opts(&qemu_action_opts);
+    qemu_add_opts(&qemu_migration_opts);
     qemu_add_run_with_opts();
     module_call_init(MODULE_INIT_OPTS);
 
@@ -2812,6 +2830,7 @@ void qemu_init(int argc, char **argv)
     }
 
     machine_opts_dict = qdict_new();
+    migration_opts_dict = qdict_new();
     if (userconfig) {
         qemu_read_default_config_file(&error_fatal);
     }
@@ -3369,6 +3388,46 @@ void qemu_init(int argc, char **argv)
                 machine_parse_property_opt(qemu_find_opts("smp-opts"),
                                            "smp", optarg);
                 break;
+            case QEMU_OPTION_migration:
+                migration_opts =
+                    qemu_opts_parse_noisily(qemu_find_opts("migration-opts"),
+                                            optarg,
+                                            false);
+
+                optarg = qemu_opt_get(migration_opts, "dirty-logging");
+                if (optarg == NULL || strcmp(optarg, "bitmap") == 0) {
+                    qdict_put_str(migration_opts_dict,
+                                  "dirty-logging",
+                                  "bitmap");
+
+                    if (qemu_opt_find(migration_opts, "dirty-ring-size")) {
+                        error_report("dirty-ring-size is only supported "
+                                     "with dirty-logging=ring");
+                        exit(1);
+                    }
+                } else if (strcmp(optarg, "ring") == 0) {
+                    qdict_put_str(migration_opts_dict, "dirty-logging", "ring");
+
+                    uint64_t dirty_ring_size = qemu_opt_get_size(migration_opts,
+                                                                 "dirty-ring-size",
+                                                                 0);
+                    if (ctpop64(dirty_ring_size) != 1) {
+                        error_report("dirty-ring-size must be a power of 2");
+                        exit(1);
+                    } else if (dirty_ring_size > (uint64_t)INT64_MAX) {
+                        error_report("dirty-ring-size is too large");
+                        exit(1);
+                    }
+
+                    qdict_put_int(migration_opts_dict,
+                                  "dirty-ring-size",
+                                  dirty_ring_size);
+                } else {
+                    error_report("invalid dirty-logging option: %s", optarg);
+                    exit(1);
+                }
+
+                break;
 #ifdef CONFIG_VNC
             case QEMU_OPTION_vnc:
                 vnc_parse(optarg);
@@ -3735,7 +3794,7 @@ void qemu_init(int argc, char **argv)
      * Note: creates a QOM object, must run only after global and
      * compat properties have been set up.
      */
-    migration_object_init();
+    migration_object_init(migration_opts_dict);
 
     /* parse features once if machine provides default cpu_type */
     current_machine->cpu_type = machine_class_default_cpu_type(machine_class);
-- 
2.34.1


