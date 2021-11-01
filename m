Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85143442315
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 23:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbhKAWMN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 18:12:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232346AbhKAWMK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 18:12:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635804574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UAlWjWoEMOZw+xZxC0WiKGp4PGVHqFH6WrrAJ6wsQRw=;
        b=TsqoTfdcFdZ6EaonwfBRtXArB1IX+dCHNN/qhEd3mVR2iSzSfKZIGD2I/sZFcDSsazxXIy
        kdo0kkhxAAJj125nnZ54cnD1ya5vOcnVvK4ZpeCv+O+ClsUBn2D4GbGPJ86JBWHSgVWG7o
        IsBbxTouquAc79ncyaLQDhsVotKss74=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-4jx57JHeOYis2k4U5itvjA-1; Mon, 01 Nov 2021 18:09:32 -0400
X-MC-Unique: 4jx57JHeOYis2k4U5itvjA-1
Received: by mail-wm1-f70.google.com with SMTP id n189-20020a1c27c6000000b00322f2e380f2so171676wmn.6
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 15:09:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UAlWjWoEMOZw+xZxC0WiKGp4PGVHqFH6WrrAJ6wsQRw=;
        b=oJhOM2+cVEFNrNmZGUP2wYJUWxt3Qghp6IrAODf6H3fC1GWH1reAaTFXhZVLcFM7gV
         kMTryqNNR4i3GQYVi5/WAxK49MAhMA4CgYIx/8MMiCJeMpDGeIAdAGPhonXQqaKAyl5a
         IJv4w7GIJkmY8mZbfA05s7h9bgAop2DFVL8HXWZb+/Y6SdFiuV6wJnkXG5NGOgsWWH1q
         bSXc21FsG9q9FCQQBbJItJHj9hG80/rb1SXsaYAzK2gIpc6O6NX6XZQIODPoyqJZfw2M
         IjqM4EBukwZrYXiT3/S0dT4WHwNUs6OLm4pH7b36czKmFGt/+8lJ+zgHk2E8nEK5cWiK
         CQmw==
X-Gm-Message-State: AOAM530q8j6JphXlef5TkgxHmtwKZYC+eQ/9ArIRJzUw/mQBKz1a2n7L
        XZ+VO2s+FD/W0e2Tc3afpDiDbH9HteyRFF3bQ5N9QwIhMPuc0Rk+1sj97/yiWJaDpwuLTFMpgM2
        gLnhA3to8ode0
X-Received: by 2002:a5d:6151:: with SMTP id y17mr33450598wrt.275.1635804571734;
        Mon, 01 Nov 2021 15:09:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwtxtTYPSTZydDNAKjX/wG8BXfEAdBg4wUEf4pzVhU0q8NeY6R4dn/NUoY2vV1PgKczmSzIOA==
X-Received: by 2002:a5d:6151:: with SMTP id y17mr33450569wrt.275.1635804571558;
        Mon, 01 Nov 2021 15:09:31 -0700 (PDT)
Received: from localhost (static-233-86-86-188.ipcom.comunitel.net. [188.86.86.233])
        by smtp.gmail.com with ESMTPSA id h16sm9219637wrm.27.2021.11.01.15.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 15:09:31 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Markus Armbruster <armbru@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        xen-devel@lists.xenproject.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>
Subject: [PULL 13/20] migration/ram: Handle RAMBlocks with a RamDiscardManager on the migration source
Date:   Mon,  1 Nov 2021 23:09:05 +0100
Message-Id: <20211101220912.10039-14-quintela@redhat.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101220912.10039-1-quintela@redhat.com>
References: <20211101220912.10039-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

We don't want to migrate memory that corresponds to discarded ranges as
managed by a RamDiscardManager responsible for the mapped memory region of
the RAMBlock. The content of these pages is essentially stale and
without any guarantees for the VM ("logically unplugged").

Depending on the underlying memory type, even reading memory might populate
memory on the source, resulting in an undesired memory consumption. Of
course, on the destination, even writing a zeropage consumes memory,
which we also want to avoid (similar to free page hinting).

Currently, virtio-mem tries achieving that goal (not migrating "unplugged"
memory that was discarded) by going via qemu_guest_free_page_hint() - but
it's hackish and incomplete.

For example, background snapshots still end up reading all memory, as
they don't do bitmap syncs. Postcopy recovery code will re-add
previously cleared bits to the dirty bitmap and migrate them.

Let's consult the RamDiscardManager after setting up our dirty bitmap
initially and when postcopy recovery code reinitializes it: clear
corresponding bits in the dirty bitmaps (e.g., of the RAMBlock and inside
KVM). It's important to fixup the dirty bitmap *after* our initial bitmap
sync, such that the corresponding dirty bits in KVM are actually cleared.

As colo is incompatible with discarding of RAM and inhibits it, we don't
have to bother.

Note: if a misbehaving guest would use discarded ranges after migration
started we would still migrate that memory: however, then we already
populated that memory on the migration source.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/ram.c | 77 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/migration/ram.c b/migration/ram.c
index ae2601bf3b..e8c06f207c 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -858,6 +858,60 @@ static inline bool migration_bitmap_clear_dirty(RAMState *rs,
     return ret;
 }
 
+static void dirty_bitmap_clear_section(MemoryRegionSection *section,
+                                       void *opaque)
+{
+    const hwaddr offset = section->offset_within_region;
+    const hwaddr size = int128_get64(section->size);
+    const unsigned long start = offset >> TARGET_PAGE_BITS;
+    const unsigned long npages = size >> TARGET_PAGE_BITS;
+    RAMBlock *rb = section->mr->ram_block;
+    uint64_t *cleared_bits = opaque;
+
+    /*
+     * We don't grab ram_state->bitmap_mutex because we expect to run
+     * only when starting migration or during postcopy recovery where
+     * we don't have concurrent access.
+     */
+    if (!migration_in_postcopy() && !migrate_background_snapshot()) {
+        migration_clear_memory_region_dirty_bitmap_range(rb, start, npages);
+    }
+    *cleared_bits += bitmap_count_one_with_offset(rb->bmap, start, npages);
+    bitmap_clear(rb->bmap, start, npages);
+}
+
+/*
+ * Exclude all dirty pages from migration that fall into a discarded range as
+ * managed by a RamDiscardManager responsible for the mapped memory region of
+ * the RAMBlock. Clear the corresponding bits in the dirty bitmaps.
+ *
+ * Discarded pages ("logically unplugged") have undefined content and must
+ * not get migrated, because even reading these pages for migration might
+ * result in undesired behavior.
+ *
+ * Returns the number of cleared bits in the RAMBlock dirty bitmap.
+ *
+ * Note: The result is only stable while migrating (precopy/postcopy).
+ */
+static uint64_t ramblock_dirty_bitmap_clear_discarded_pages(RAMBlock *rb)
+{
+    uint64_t cleared_bits = 0;
+
+    if (rb->mr && rb->bmap && memory_region_has_ram_discard_manager(rb->mr)) {
+        RamDiscardManager *rdm = memory_region_get_ram_discard_manager(rb->mr);
+        MemoryRegionSection section = {
+            .mr = rb->mr,
+            .offset_within_region = 0,
+            .size = int128_make64(qemu_ram_get_used_length(rb)),
+        };
+
+        ram_discard_manager_replay_discarded(rdm, &section,
+                                             dirty_bitmap_clear_section,
+                                             &cleared_bits);
+    }
+    return cleared_bits;
+}
+
 /* Called with RCU critical section */
 static void ramblock_sync_dirty_bitmap(RAMState *rs, RAMBlock *rb)
 {
@@ -2675,6 +2729,19 @@ static void ram_list_init_bitmaps(void)
     }
 }
 
+static void migration_bitmap_clear_discarded_pages(RAMState *rs)
+{
+    unsigned long pages;
+    RAMBlock *rb;
+
+    RCU_READ_LOCK_GUARD();
+
+    RAMBLOCK_FOREACH_NOT_IGNORED(rb) {
+            pages = ramblock_dirty_bitmap_clear_discarded_pages(rb);
+            rs->migration_dirty_pages -= pages;
+    }
+}
+
 static void ram_init_bitmaps(RAMState *rs)
 {
     /* For memory_global_dirty_log_start below.  */
@@ -2691,6 +2758,12 @@ static void ram_init_bitmaps(RAMState *rs)
     }
     qemu_mutex_unlock_ramlist();
     qemu_mutex_unlock_iothread();
+
+    /*
+     * After an eventual first bitmap sync, fixup the initial bitmap
+     * containing all 1s to exclude any discarded pages from migration.
+     */
+    migration_bitmap_clear_discarded_pages(rs);
 }
 
 static int ram_init_all(RAMState **rsp)
@@ -4119,6 +4192,10 @@ int ram_dirty_bitmap_reload(MigrationState *s, RAMBlock *block)
      */
     bitmap_complement(block->bmap, block->bmap, nbits);
 
+    /* Clear dirty bits of discarded ranges that we don't want to migrate. */
+    ramblock_dirty_bitmap_clear_discarded_pages(block);
+
+    /* We'll recalculate migration_dirty_pages in ram_state_resume_prepare(). */
     trace_ram_dirty_bitmap_reload_complete(block->idstr);
 
     /*
-- 
2.33.1

