Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC1F52D9787
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 12:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405872AbgLNLjb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 06:39:31 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9876 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392388AbgLNLja (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 06:39:30 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CvfXD08TLz7DrK;
        Mon, 14 Dec 2020 19:38:04 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.179) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Mon, 14 Dec 2020 19:38:31 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <qemu-devel@nongnu.org>, <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, <wanghaibin.wang@huawei.com>,
        Zenghui Yu <yuzenghui@huawei.com>, Peter Xu <peterx@redhat.com>
Subject: [PATCH v2] kvm: Take into account the unaligned section size when preparing bitmap
Date:   Mon, 14 Dec 2020 19:37:06 +0800
Message-ID: <20201214113706.1553-1-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kernel KVM_CLEAR_DIRTY_LOG interface has align requirement on both the
start and the size of the given range of pages. We have been careful to
handle the unaligned cases when performing CLEAR on one slot. But it seems
that we forget to take the unaligned *size* case into account when
preparing bitmap for the interface, and we may end up clearing dirty status
for pages outside of [start, start + size). As an example,

    // psize = qemu_real_host_page_size;
    // slot.start_addr = 0;
    // slot.memory_size = 64 * psize;

    kvm_log_clear_one_slot(slot, as, 0 * psize, 32 * psize);   --> [1]

So the @size is not aligned with 64 pages. With [1], we'll clear dirty
status for all 64 pages within this slot whilst the caller only wants to
clear the former 32 pages.

If the size is unaligned, let's go through the slow path to manipulate a
temp bitmap for the interface so that we won't bother with those unaligned
bits at the end of bitmap.

I don't think this can happen in practice since the upper layer would
provide us with the alignment guarantee. But kvm-all shouldn't rely on it.
Carefully handle it in case someday we'll hit it.

Acked-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
* From v1:
  - Squash the misbehave example into commit message
  - Add Peter's Acked-by

 accel/kvm/kvm-all.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index baaa54249d..7644d44097 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -745,7 +745,7 @@ static int kvm_log_clear_one_slot(KVMSlot *mem, int as_id, uint64_t start,
     assert(bmap_start % BITS_PER_LONG == 0);
     /* We should never do log_clear before log_sync */
     assert(mem->dirty_bmap);
-    if (start_delta) {
+    if (start_delta || bmap_npages - size / psize) {
         /* Slow path - we need to manipulate a temp bitmap */
         bmap_clear = bitmap_new(bmap_npages);
         bitmap_copy_with_src_offset(bmap_clear, mem->dirty_bmap,
@@ -758,7 +758,10 @@ static int kvm_log_clear_one_slot(KVMSlot *mem, int as_id, uint64_t start,
         bitmap_clear(bmap_clear, 0, start_delta);
         d.dirty_bitmap = bmap_clear;
     } else {
-        /* Fast path - start address aligns well with BITS_PER_LONG */
+        /*
+         * Fast path - both start and size align well with BITS_PER_LONG
+         * (or the end of memory slot)
+         */
         d.dirty_bitmap = mem->dirty_bmap + BIT_WORD(bmap_start);
     }
 
-- 
2.19.1

