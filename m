Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65B9667168
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 16:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbfGLOcf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 10:32:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54426 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727391AbfGLOcf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 10:32:35 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2E74587633;
        Fri, 12 Jul 2019 14:32:35 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.36.118.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F0DC60920;
        Fri, 12 Jul 2019 14:32:32 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Peter Xu <peterx@redhat.com>
Subject: [PULL 09/19] migration: No need to take rcu during sync_dirty_bitmap
Date:   Fri, 12 Jul 2019 16:31:57 +0200
Message-Id: <20190712143207.4214-10-quintela@redhat.com>
In-Reply-To: <20190712143207.4214-1-quintela@redhat.com>
References: <20190712143207.4214-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Fri, 12 Jul 2019 14:32:35 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

cpu_physical_memory_sync_dirty_bitmap() has one RAMBlock* as
parameter, which means that it must be with RCU read lock held
already.  Taking it again inside seems redundant.  Removing it.
Instead comment on the functions about the RCU read lock.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
Message-Id: <20190603065056.25211-2-peterx@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 include/exec/ram_addr.h | 5 +----
 migration/ram.c         | 1 +
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
index f96777bb99..44dcc98de6 100644
--- a/include/exec/ram_addr.h
+++ b/include/exec/ram_addr.h
@@ -409,6 +409,7 @@ static inline void cpu_physical_memory_clear_dirty_range(ram_addr_t start,
 }
 
 
+/* Called with RCU critical section */
 static inline
 uint64_t cpu_physical_memory_sync_dirty_bitmap(RAMBlock *rb,
                                                ram_addr_t start,
@@ -432,8 +433,6 @@ uint64_t cpu_physical_memory_sync_dirty_bitmap(RAMBlock *rb,
                                         DIRTY_MEMORY_BLOCK_SIZE);
         unsigned long page = BIT_WORD(start >> TARGET_PAGE_BITS);
 
-        rcu_read_lock();
-
         src = atomic_rcu_read(
                 &ram_list.dirty_memory[DIRTY_MEMORY_MIGRATION])->blocks;
 
@@ -453,8 +452,6 @@ uint64_t cpu_physical_memory_sync_dirty_bitmap(RAMBlock *rb,
                 idx++;
             }
         }
-
-        rcu_read_unlock();
     } else {
         ram_addr_t offset = rb->offset;
 
diff --git a/migration/ram.c b/migration/ram.c
index 89eec7ee9d..48969db84b 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -1674,6 +1674,7 @@ static inline bool migration_bitmap_clear_dirty(RAMState *rs,
     return ret;
 }
 
+/* Called with RCU critical section */
 static void migration_bitmap_sync_range(RAMState *rs, RAMBlock *rb,
                                         ram_addr_t length)
 {
-- 
2.21.0

