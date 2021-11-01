Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89450442316
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 23:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbhKAWMO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 18:12:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24828 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232284AbhKAWML (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 18:12:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635804577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d6xzgvfaRH7wOf37zGfKB0deqCxxsFVowA0eQT7aDxo=;
        b=Xvd/2WNQ90mqyu1g9An2sFIzS6fLiYI7/gp77Y+fGCLP1AtrzHb5CnHDiORFIk/GetcwEH
        xrgy65OHE80Bimxl89xdMovvVioVP0TgEC/w2vivE4nAkG4CraIVl6NVUsGIY160XeYwzO
        Ospe0b2KVUEWQTQcrXxJh9kheKNAVpo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-4YAtllsAMQKzGfdJkNcLqw-1; Mon, 01 Nov 2021 18:09:35 -0400
X-MC-Unique: 4YAtllsAMQKzGfdJkNcLqw-1
Received: by mail-wr1-f71.google.com with SMTP id z5-20020a5d6405000000b00182083d7d2aso2347700wru.13
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 15:09:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d6xzgvfaRH7wOf37zGfKB0deqCxxsFVowA0eQT7aDxo=;
        b=i+as+MNbzuf3wTgjn7pDzHPyr8WF/LZt/2FeFSHRcx6QWadEOCSGx/Y8EBS2VHj1Gd
         V6A/7s8TXBEynq03sF9HJvSaN/BC0ymqx/CNfPXOnhwXIML4URIVLY/X0/sQ//a7YFaA
         xdVeiGffj0gF4+hnN/JoTM7MlrQ1Av+ZMX7u/5660Ktt0jYWkj8choH/SnrJLBDPiqIc
         rswzkp6ZoocFVdduNwgWkz+hyxjG2QMVCVRkc1xrCTk2T9lQYcCYHwNlTz7bkWiCp2i9
         US1uKPuhtoGj29Rg2suuVJ2c9pFdkCeNyNIocBfW3kQOd6eEqN6hl/RIU823+IBXq4Tl
         UO8w==
X-Gm-Message-State: AOAM530P4/Fj1qlGZg97ZianLC24w07ZmZ47SaKXr3VRbc2wx20nHeHJ
        Cm3laFiJVHoicPSlZHPLdmOERmTI25uynPe3I7hh7jwYYpGBQO3k76rKrlczb6DrNx8+T9FTLy3
        q5NQXvbefeYdr
X-Received: by 2002:a7b:c344:: with SMTP id l4mr2036325wmj.64.1635804574701;
        Mon, 01 Nov 2021 15:09:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxo7AHQlwU2kKnhA6BjMO/H58USugS+QmilgTuoi4heYyTz0HB9ONCrlie6M4WQHi9L+TU2pA==
X-Received: by 2002:a7b:c344:: with SMTP id l4mr2036289wmj.64.1635804574465;
        Mon, 01 Nov 2021 15:09:34 -0700 (PDT)
Received: from localhost (static-233-86-86-188.ipcom.comunitel.net. [188.86.86.233])
        by smtp.gmail.com with ESMTPSA id m34sm702738wms.25.2021.11.01.15.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 15:09:34 -0700 (PDT)
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
Subject: [PULL 15/20] migration/postcopy: Handle RAMBlocks with a RamDiscardManager on the destination
Date:   Mon,  1 Nov 2021 23:09:07 +0100
Message-Id: <20211101220912.10039-16-quintela@redhat.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101220912.10039-1-quintela@redhat.com>
References: <20211101220912.10039-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

Currently, when someone (i.e., the VM) accesses discarded parts inside a
RAMBlock with a RamDiscardManager managing the corresponding mapped memory
region, postcopy will request migration of the corresponding page from the
source. The source, however, will never answer, because it refuses to
migrate such pages with undefined content ("logically unplugged"): the
pages are never dirty, and get_queued_page() will consequently skip
processing these postcopy requests.

Especially reading discarded ("logically unplugged") ranges is supposed to
work in some setups (for example with current virtio-mem), although it
barely ever happens: still, not placing a page would currently stall the
VM, as it cannot make forward progress.

Let's check the state via the RamDiscardManager (the state e.g.,
of virtio-mem is migrated during precopy) and avoid sending a request
that will never get answered. Place a fresh zero page instead to keep
the VM working. This is the same behavior that would happen
automatically without userfaultfd being active, when accessing virtual
memory regions without populated pages -- "populate on demand".

For now, there are valid cases (as documented in the virtio-mem spec) where
a VM might read discarded memory; in the future, we will disallow that.
Then, we might want to handle that case differently, e.g., warning the
user that the VM seems to be mis-behaving.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/ram.h          |  1 +
 migration/postcopy-ram.c | 31 +++++++++++++++++++++++++++----
 migration/ram.c          | 21 +++++++++++++++++++++
 3 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/migration/ram.h b/migration/ram.h
index 4833e9fd5b..dda1988f3d 100644
--- a/migration/ram.h
+++ b/migration/ram.h
@@ -72,6 +72,7 @@ void ramblock_recv_bitmap_set_range(RAMBlock *rb, void *host_addr, size_t nr);
 int64_t ramblock_recv_bitmap_send(QEMUFile *file,
                                   const char *block_name);
 int ram_dirty_bitmap_reload(MigrationState *s, RAMBlock *rb);
+bool ramblock_page_is_discarded(RAMBlock *rb, ram_addr_t start);
 
 /* ram cache */
 int colo_init_ram_cache(void);
diff --git a/migration/postcopy-ram.c b/migration/postcopy-ram.c
index 2e9697bdd2..3609ce7e52 100644
--- a/migration/postcopy-ram.c
+++ b/migration/postcopy-ram.c
@@ -671,6 +671,29 @@ int postcopy_wake_shared(struct PostCopyFD *pcfd,
     return ret;
 }
 
+static int postcopy_request_page(MigrationIncomingState *mis, RAMBlock *rb,
+                                 ram_addr_t start, uint64_t haddr)
+{
+    void *aligned = (void *)(uintptr_t)ROUND_DOWN(haddr, qemu_ram_pagesize(rb));
+
+    /*
+     * Discarded pages (via RamDiscardManager) are never migrated. On unlikely
+     * access, place a zeropage, which will also set the relevant bits in the
+     * recv_bitmap accordingly, so we won't try placing a zeropage twice.
+     *
+     * Checking a single bit is sufficient to handle pagesize > TPS as either
+     * all relevant bits are set or not.
+     */
+    assert(QEMU_IS_ALIGNED(start, qemu_ram_pagesize(rb)));
+    if (ramblock_page_is_discarded(rb, start)) {
+        bool received = ramblock_recv_bitmap_test_byte_offset(rb, start);
+
+        return received ? 0 : postcopy_place_page_zero(mis, aligned, rb);
+    }
+
+    return migrate_send_rp_req_pages(mis, rb, start, haddr);
+}
+
 /*
  * Callback from shared fault handlers to ask for a page,
  * the page must be specified by a RAMBlock and an offset in that rb
@@ -690,7 +713,7 @@ int postcopy_request_shared_page(struct PostCopyFD *pcfd, RAMBlock *rb,
                                         qemu_ram_get_idstr(rb), rb_offset);
         return postcopy_wake_shared(pcfd, client_addr, rb);
     }
-    migrate_send_rp_req_pages(mis, rb, aligned_rbo, client_addr);
+    postcopy_request_page(mis, rb, aligned_rbo, client_addr);
     return 0;
 }
 
@@ -984,8 +1007,8 @@ retry:
              * Send the request to the source - we want to request one
              * of our host page sizes (which is >= TPS)
              */
-            ret = migrate_send_rp_req_pages(mis, rb, rb_offset,
-                                            msg.arg.pagefault.address);
+            ret = postcopy_request_page(mis, rb, rb_offset,
+                                        msg.arg.pagefault.address);
             if (ret) {
                 /* May be network failure, try to wait for recovery */
                 if (ret == -EIO && postcopy_pause_fault_thread(mis)) {
@@ -993,7 +1016,7 @@ retry:
                     goto retry;
                 } else {
                     /* This is a unavoidable fault */
-                    error_report("%s: migrate_send_rp_req_pages() get %d",
+                    error_report("%s: postcopy_request_page() get %d",
                                  __func__, ret);
                     break;
                 }
diff --git a/migration/ram.c b/migration/ram.c
index e8c06f207c..4f629de7d0 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -912,6 +912,27 @@ static uint64_t ramblock_dirty_bitmap_clear_discarded_pages(RAMBlock *rb)
     return cleared_bits;
 }
 
+/*
+ * Check if a host-page aligned page falls into a discarded range as managed by
+ * a RamDiscardManager responsible for the mapped memory region of the RAMBlock.
+ *
+ * Note: The result is only stable while migrating (precopy/postcopy).
+ */
+bool ramblock_page_is_discarded(RAMBlock *rb, ram_addr_t start)
+{
+    if (rb->mr && memory_region_has_ram_discard_manager(rb->mr)) {
+        RamDiscardManager *rdm = memory_region_get_ram_discard_manager(rb->mr);
+        MemoryRegionSection section = {
+            .mr = rb->mr,
+            .offset_within_region = start,
+            .size = int128_make64(qemu_ram_pagesize(rb)),
+        };
+
+        return !ram_discard_manager_is_populated(rdm, &section);
+    }
+    return false;
+}
+
 /* Called with RCU critical section */
 static void ramblock_sync_dirty_bitmap(RAMState *rs, RAMBlock *rb)
 {
-- 
2.33.1

