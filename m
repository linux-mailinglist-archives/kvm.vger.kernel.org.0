Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3AEA732BA5
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 11:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344108AbjFPJav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 05:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344661AbjFPJaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 05:30:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5189C3586
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 02:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686907679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1OfXeZbbLe+PasqUGtlH847Pe9BvNHvovB08N6Ny3S0=;
        b=TQI32saUrRjw8y7h8owMlXA/V8GBUEA1lx2zCWCUVNBJCDRE33QCghs6QXXjM2meqy4F45
        +sOUNLk/hdjCk8fDyido/uj7VvXVaIofx1O2HSjEdyUWAosu50dyAQ0+3+e597ShHtY5VL
        ZoYPo0RT7tl+I1cdgZO3TM3/JgJFSQo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-416-_UoqcDlnPvSTR36JX2p8oA-1; Fri, 16 Jun 2023 05:27:56 -0400
X-MC-Unique: _UoqcDlnPvSTR36JX2p8oA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86D40280AA28;
        Fri, 16 Jun 2023 09:27:55 +0000 (UTC)
Received: from t480s.fritz.box (unknown [10.39.194.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C5F131121314;
        Fri, 16 Jun 2023 09:27:52 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Michal Privoznik <mprivozn@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: [PATCH v1 14/15] memory,vhost: Allow for marking memory device memory regions unmergeable
Date:   Fri, 16 Jun 2023 11:26:53 +0200
Message-Id: <20230616092654.175518-15-david@redhat.com>
In-Reply-To: <20230616092654.175518-1-david@redhat.com>
References: <20230616092654.175518-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's allow for marking memory regions unmergeable, to teach
flatview code and vhost to not merge adjacent aliases to the same memory
region into a larger memory section; instead, we want separate aliases to
stay separate such that we can atomically map/unmap aliases without
affecting other aliases.

This is desired for virtio-mem mapping device memory located on a RAM
memory region via multiple aliases into a memory region container,
resulting in separate memslots that can get (un)mapped atomically.

As an example with virtio-mem, the layout would look something like this:
  [...]
  0000000240000000-00000020bfffffff (prio 0, i/o): device-memory
    0000000240000000-000000043fffffff (prio 0, i/o): virtio-mem
      0000000240000000-000000027fffffff (prio 0, ram): alias memslot-0 @mem2 0000000000000000-000000003fffffff
      0000000280000000-00000002bfffffff (prio 0, ram): alias memslot-1 @mem2 0000000040000000-000000007fffffff
      00000002c0000000-00000002ffffffff (prio 0, ram): alias memslot-2 @mem2 0000000080000000-00000000bfffffff
  [...]

Without unmergable memory regions, all three memslots would get merged into
a single memory section. For example, when mapping another alias (e.g.,
virtio-mem-memslot-3) or when unmapping any of the mapped aliases,
memory listeners will first get notified about the removal of the big
memory section to then get notified about re-adding of the new
(differently merged) memory section(s).

In an ideal world, memory listeners would be able to deal with that
atomically, like KVM nowadays does. However, (a) supporting this for other
memory listeners (vhost-user, vfio) is fairly hard: temporary removal
can result in all kinds of issues on concurrent access to guest memory.
(b) this handling is undesired, because temporarily removing+readding can
consume quite some time on bigger memslots and is not efficient
(e.g., vfio unpinning and repinning pages ...).

Let's allow for marking a memory region unmergeable, such that we
can atomically (un)map aliases to the same memory region, similar to
(un)mapping individual DIMMs.

Similarly, teach vhost code to not redo what flatview core stopped doing:
don't merge such sections. Merging in vhost code is really only relevant
for handling random holes in boot memory where; without this merging,
the vhost-user backend wouldn't be able to mmap() some boot memory
backed on hugetlb.

We'll use this for virtio-mem next.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/virtio/vhost.c     |  4 ++--
 include/exec/memory.h | 22 ++++++++++++++++++++++
 softmmu/memory.c      | 31 +++++++++++++++++++++++++------
 3 files changed, 49 insertions(+), 8 deletions(-)

diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index b1e2eca55d..31961d7d0a 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -708,7 +708,7 @@ static void vhost_region_add_section(struct vhost_dev *dev,
                                                mrs_size, mrs_host);
     }
 
-    if (dev->n_tmp_sections) {
+    if (dev->n_tmp_sections && !section->unmergeable) {
         /* Since we already have at least one section, lets see if
          * this extends it; since we're scanning in order, we only
          * have to look at the last one, and the FlatView that calls
@@ -741,7 +741,7 @@ static void vhost_region_add_section(struct vhost_dev *dev,
             size_t offset = mrs_gpa - prev_gpa_start;
 
             if (prev_host_start + offset == mrs_host &&
-                section->mr == prev_sec->mr) {
+                section->mr == prev_sec->mr && !prev_sec->unmergeable) {
                 uint64_t max_end = MAX(prev_host_end, mrs_host + mrs_size);
                 need_add = false;
                 prev_sec->offset_within_address_space =
diff --git a/include/exec/memory.h b/include/exec/memory.h
index 1e35a2c828..2ede78fb61 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -95,6 +95,7 @@ struct ReservedRegion {
  *     relative to the region's address space
  * @readonly: writes to this section are ignored
  * @nonvolatile: this section is non-volatile
+ * @unmergeable: this section should not get merged with adjacent sections
  */
 struct MemoryRegionSection {
     Int128 size;
@@ -104,6 +105,7 @@ struct MemoryRegionSection {
     hwaddr offset_within_address_space;
     bool readonly;
     bool nonvolatile;
+    bool unmergeable;
 };
 
 typedef struct IOMMUTLBEntry IOMMUTLBEntry;
@@ -764,6 +766,7 @@ struct MemoryRegion {
     bool nonvolatile;
     bool rom_device;
     bool flush_coalesced_mmio;
+    bool unmergeable;
     uint8_t dirty_log_mask;
     bool is_iommu;
     RAMBlock *ram_block;
@@ -2337,6 +2340,25 @@ void memory_region_set_size(MemoryRegion *mr, uint64_t size);
 void memory_region_set_alias_offset(MemoryRegion *mr,
                                     hwaddr offset);
 
+/*
+ * memory_region_set_unmergeable: Set a memory region unmergeable
+ *
+ * Mark a memory region unmergeable, resulting in the memory region (or
+ * everything contained in a memory region container) not getting merged when
+ * simplifying the address space and notifying memory listeners. Consequently,
+ * memory listeners will never get notified about ranges that are larger than
+ * the original memory regions.
+ *
+ * This is primarily useful when multiple aliases to a RAM memory region are
+ * mapped into a memory region container, and updates (e.g., enable/disable or
+ * map/unmap) of individual memory region aliases are not supposed to affect
+ * other memory regions in the same container.
+ *
+ * @mr: the #MemoryRegion to be updated
+ * @unmergeable: whether to mark the #MemoryRegion unmergeable
+ */
+void memory_region_set_unmergeable(MemoryRegion *mr, bool unmergeable);
+
 /**
  * memory_region_present: checks if an address relative to a @container
  * translates into #MemoryRegion within @container
diff --git a/softmmu/memory.c b/softmmu/memory.c
index c1e8aa133f..4e078c21af 100644
--- a/softmmu/memory.c
+++ b/softmmu/memory.c
@@ -224,6 +224,7 @@ struct FlatRange {
     bool romd_mode;
     bool readonly;
     bool nonvolatile;
+    bool unmergeable;
 };
 
 #define FOR_EACH_FLAT_RANGE(var, view)          \
@@ -240,6 +241,7 @@ section_from_flat_range(FlatRange *fr, FlatView *fv)
         .offset_within_address_space = int128_get64(fr->addr.start),
         .readonly = fr->readonly,
         .nonvolatile = fr->nonvolatile,
+        .unmergeable = fr->unmergeable,
     };
 }
 
@@ -250,7 +252,8 @@ static bool flatrange_equal(FlatRange *a, FlatRange *b)
         && a->offset_in_region == b->offset_in_region
         && a->romd_mode == b->romd_mode
         && a->readonly == b->readonly
-        && a->nonvolatile == b->nonvolatile;
+        && a->nonvolatile == b->nonvolatile
+        && a->unmergeable == b->unmergeable;
 }
 
 static FlatView *flatview_new(MemoryRegion *mr_root)
@@ -323,7 +326,8 @@ static bool can_merge(FlatRange *r1, FlatRange *r2)
         && r1->dirty_log_mask == r2->dirty_log_mask
         && r1->romd_mode == r2->romd_mode
         && r1->readonly == r2->readonly
-        && r1->nonvolatile == r2->nonvolatile;
+        && r1->nonvolatile == r2->nonvolatile
+        && !r1->unmergeable && !r2->unmergeable;
 }
 
 /* Attempt to simplify a view by merging adjacent ranges */
@@ -599,7 +603,8 @@ static void render_memory_region(FlatView *view,
                                  Int128 base,
                                  AddrRange clip,
                                  bool readonly,
-                                 bool nonvolatile)
+                                 bool nonvolatile,
+                                 bool unmergeable)
 {
     MemoryRegion *subregion;
     unsigned i;
@@ -616,6 +621,7 @@ static void render_memory_region(FlatView *view,
     int128_addto(&base, int128_make64(mr->addr));
     readonly |= mr->readonly;
     nonvolatile |= mr->nonvolatile;
+    unmergeable |= mr->unmergeable;
 
     tmp = addrrange_make(base, mr->size);
 
@@ -629,14 +635,14 @@ static void render_memory_region(FlatView *view,
         int128_subfrom(&base, int128_make64(mr->alias->addr));
         int128_subfrom(&base, int128_make64(mr->alias_offset));
         render_memory_region(view, mr->alias, base, clip,
-                             readonly, nonvolatile);
+                             readonly, nonvolatile, unmergeable);
         return;
     }
 
     /* Render subregions in priority order. */
     QTAILQ_FOREACH(subregion, &mr->subregions, subregions_link) {
         render_memory_region(view, subregion, base, clip,
-                             readonly, nonvolatile);
+                             readonly, nonvolatile, unmergeable);
     }
 
     if (!mr->terminates) {
@@ -652,6 +658,7 @@ static void render_memory_region(FlatView *view,
     fr.romd_mode = mr->romd_mode;
     fr.readonly = readonly;
     fr.nonvolatile = nonvolatile;
+    fr.unmergeable = unmergeable;
 
     /* Render the region itself into any gaps left by the current view. */
     for (i = 0; i < view->nr && int128_nz(remain); ++i) {
@@ -753,7 +760,7 @@ static FlatView *generate_memory_topology(MemoryRegion *mr)
     if (mr) {
         render_memory_region(view, mr, int128_zero(),
                              addrrange_make(int128_zero(), int128_2_64()),
-                             false, false);
+                             false, false, false);
     }
     flatview_simplify(view);
 
@@ -2751,6 +2758,18 @@ void memory_region_set_alias_offset(MemoryRegion *mr, hwaddr offset)
     memory_region_transaction_commit();
 }
 
+void memory_region_set_unmergeable(MemoryRegion *mr, bool unmergeable)
+{
+    if (unmergeable == mr->unmergeable) {
+        return;
+    }
+
+    memory_region_transaction_begin();
+    mr->unmergeable = unmergeable;
+    memory_region_update_pending |= mr->enabled;
+    memory_region_transaction_commit();
+}
+
 uint64_t memory_region_get_alignment(const MemoryRegion *mr)
 {
     return mr->align;
-- 
2.40.1

