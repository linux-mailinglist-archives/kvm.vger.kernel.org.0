Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4A86979A
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 17:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732266AbfGONwv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 09:52:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34508 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732259AbfGONwu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 09:52:50 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1DA67368E6;
        Mon, 15 Jul 2019 13:52:50 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.36.118.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D08B5B681;
        Mon, 15 Jul 2019 13:52:47 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Juan Quintela <quintela@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Laurent Vivier <lvivier@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Peter Xu <peterx@redhat.com>
Subject: [PULL 14/21] kvm: Persistent per kvmslot dirty bitmap
Date:   Mon, 15 Jul 2019 15:51:18 +0200
Message-Id: <20190715135125.17770-15-quintela@redhat.com>
In-Reply-To: <20190715135125.17770-1-quintela@redhat.com>
References: <20190715135125.17770-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Mon, 15 Jul 2019 13:52:50 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

When synchronizing dirty bitmap from kernel KVM we do it in a
per-kvmslot fashion and we allocate the userspace bitmap for each of
the ioctl.  This patch instead make the bitmap cache be persistent
then we don't need to g_malloc0() every time.

More importantly, the cached per-kvmslot dirty bitmap will be further
used when we want to add support for the KVM_CLEAR_DIRTY_LOG and this
cached bitmap will be used to guarantee we won't clear any unknown
dirty bits otherwise that can be a severe data loss issue for
migration code.

Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Message-Id: <20190603065056.25211-9-peterx@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 accel/kvm/kvm-all.c      | 10 +++++++---
 include/sysemu/kvm_int.h |  2 ++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index a3df19da56..23ace52b9e 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -516,17 +516,19 @@ static int kvm_physical_sync_dirty_bitmap(KVMMemoryListener *kml,
          */
         size = ALIGN(((mem->memory_size) >> TARGET_PAGE_BITS),
                      /*HOST_LONG_BITS*/ 64) / 8;
-        d.dirty_bitmap = g_malloc0(size);
+        if (!mem->dirty_bmap) {
+            /* Allocate on the first log_sync, once and for all */
+            mem->dirty_bmap = g_malloc0(size);
+        }
 
+        d.dirty_bitmap = mem->dirty_bmap;
         d.slot = mem->slot | (kml->as_id << 16);
         if (kvm_vm_ioctl(s, KVM_GET_DIRTY_LOG, &d) == -1) {
             DPRINTF("ioctl failed %d\n", errno);
-            g_free(d.dirty_bitmap);
             return -1;
         }
 
         kvm_get_dirty_pages_log_range(section, d.dirty_bitmap);
-        g_free(d.dirty_bitmap);
     }
 
     return 0;
@@ -801,6 +803,8 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
         }
 
         /* unregister the slot */
+        g_free(mem->dirty_bmap);
+        mem->dirty_bmap = NULL;
         mem->memory_size = 0;
         mem->flags = 0;
         err = kvm_set_user_memory_region(kml, mem, false);
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index f838412491..687a2ee423 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -21,6 +21,8 @@ typedef struct KVMSlot
     int slot;
     int flags;
     int old_flags;
+    /* Dirty bitmap cache for the slot */
+    unsigned long *dirty_bmap;
 } KVMSlot;
 
 typedef struct KVMMemoryListener {
-- 
2.21.0

