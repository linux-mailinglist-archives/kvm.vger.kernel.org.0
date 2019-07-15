Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7C2368CC1
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 15:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732387AbfGONx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 09:53:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49210 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732378AbfGONxZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 09:53:25 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3E0D9C04AC69;
        Mon, 15 Jul 2019 13:53:25 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.36.118.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B5125D772;
        Mon, 15 Jul 2019 13:53:19 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Juan Quintela <quintela@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Laurent Vivier <lvivier@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Ivan Ren <renyime@gmail.com>, Ivan Ren <ivanren@tencent.com>,
        Peter Xu <peterx@redhat.com>
Subject: [PULL 21/21] migration: always initial RAMBlock.bmap to 1 for new migration
Date:   Mon, 15 Jul 2019 15:51:25 +0200
Message-Id: <20190715135125.17770-22-quintela@redhat.com>
In-Reply-To: <20190715135125.17770-1-quintela@redhat.com>
References: <20190715135125.17770-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Mon, 15 Jul 2019 13:53:25 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ivan Ren <renyime@gmail.com>

Reproduce the problem:
migrate
migrate_cancel
migrate

Error happen for memory migration

The reason as follows:
1. qemu start, ram_list.dirty_memory[DIRTY_MEMORY_MIGRATION] all set to
   1 by a series of cpu_physical_memory_set_dirty_range
2. migration start:ram_init_bitmaps
   - memory_global_dirty_log_start: begin log diry
   - memory_global_dirty_log_sync: sync dirty bitmap to
     ram_list.dirty_memory[DIRTY_MEMORY_MIGRATION]
   - migration_bitmap_sync_range: sync ram_list.
     dirty_memory[DIRTY_MEMORY_MIGRATION] to RAMBlock.bmap
     and ram_list.dirty_memory[DIRTY_MEMORY_MIGRATION] is set to zero
3. migration data...
4. migrate_cancel, will stop log dirty
5. migration start:ram_init_bitmaps
   - memory_global_dirty_log_start: begin log diry
   - memory_global_dirty_log_sync: sync dirty bitmap to
     ram_list.dirty_memory[DIRTY_MEMORY_MIGRATION]
   - migration_bitmap_sync_range: sync ram_list.
     dirty_memory[DIRTY_MEMORY_MIGRATION] to RAMBlock.bmap
     and ram_list.dirty_memory[DIRTY_MEMORY_MIGRATION] is set to zero

   Here RAMBlock.bmap only have new logged dirty pages, don't contain
   the whole guest pages.

Signed-off-by: Ivan Ren <ivanren@tencent.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Message-Id: <1563115879-2715-1-git-send-email-ivanren@tencent.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/ram.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/migration/ram.c b/migration/ram.c
index 85bc36101c..2b0774c2bf 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -3213,11 +3213,11 @@ static int ram_state_init(RAMState **rsp)
     QSIMPLEQ_INIT(&(*rsp)->src_page_requests);
 
     /*
+     * Count the total number of pages used by ram blocks not including any
+     * gaps due to alignment or unplugs.
      * This must match with the initial values of dirty bitmap.
-     * Currently we initialize the dirty bitmap to all zeros so
-     * here the total dirty page count is zero.
      */
-    (*rsp)->migration_dirty_pages = 0;
+    (*rsp)->migration_dirty_pages = ram_bytes_total() >> TARGET_PAGE_BITS;
     ram_state_reset(*rsp);
 
     return 0;
@@ -3249,12 +3249,13 @@ static void ram_list_init_bitmaps(void)
              * The initial dirty bitmap for migration must be set with all
              * ones to make sure we'll migrate every guest RAM page to
              * destination.
-             * Here we didn't set RAMBlock.bmap simply because it is already
-             * set in ram_list.dirty_memory[DIRTY_MEMORY_MIGRATION] in
-             * ram_block_add, and that's where we'll sync the dirty bitmaps.
-             * Here setting RAMBlock.bmap would be fine too but not necessary.
+             * Here we set RAMBlock.bmap all to 1 because when rebegin a
+             * new migration after a failed migration, ram_list.
+             * dirty_memory[DIRTY_MEMORY_MIGRATION] don't include the whole
+             * guest memory.
              */
             block->bmap = bitmap_new(pages);
+            bitmap_set(block->bmap, 0, pages);
             block->clear_bmap_shift = shift;
             block->clear_bmap = bitmap_new(clear_bmap_size(pages, shift));
             if (migrate_postcopy_ram()) {
-- 
2.21.0

