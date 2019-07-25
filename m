Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE5C774C48
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 12:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391331AbfGYK5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 06:57:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36550 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391079AbfGYK5f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 06:57:35 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9E2DE30C133C;
        Thu, 25 Jul 2019 10:57:35 +0000 (UTC)
Received: from localhost.localdomain (ovpn-117-190.ams2.redhat.com [10.36.117.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 522C619C7F;
        Thu, 25 Jul 2019 10:57:33 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Ren <renyime@gmail.com>, Ivan Ren <ivanren@tencent.com>
Subject: [PULL 2/4] migration: fix migrate_cancel leads live_migration thread hung forever
Date:   Thu, 25 Jul 2019 12:57:22 +0200
Message-Id: <20190725105724.2562-3-quintela@redhat.com>
In-Reply-To: <20190725105724.2562-1-quintela@redhat.com>
References: <20190725105724.2562-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Thu, 25 Jul 2019 10:57:35 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ivan Ren <renyime@gmail.com>

When we 'migrate_cancel' a multifd migration, live_migration thread may
hung forever at some points, because of multifd_send_thread has already
exit for socket error:
1. multifd_send_pages may hung at qemu_sem_wait(&multifd_send_state->
   channels_ready)
2. multifd_send_sync_main my hung at qemu_sem_wait(&multifd_send_state->
   sem_sync)

Signed-off-by: Ivan Ren <ivanren@tencent.com>
Message-Id: <1561468699-9819-3-git-send-email-ivanren@tencent.com>
Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>

---

Remove spurious not needed bits
---
 migration/ram.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/migration/ram.c b/migration/ram.c
index 52a2d498e4..87bb7da8e2 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -1097,7 +1097,8 @@ static void *multifd_send_thread(void *opaque)
 {
     MultiFDSendParams *p = opaque;
     Error *local_err = NULL;
-    int ret;
+    int ret = 0;
+    uint32_t flags = 0;
 
     trace_multifd_send_thread_start(p->id);
     rcu_register_thread();
@@ -1115,7 +1116,7 @@ static void *multifd_send_thread(void *opaque)
         if (p->pending_job) {
             uint32_t used = p->pages->used;
             uint64_t packet_num = p->packet_num;
-            uint32_t flags = p->flags;
+            flags = p->flags;
 
             p->next_packet_size = used * qemu_target_page_size();
             multifd_send_fill_packet(p);
@@ -1164,6 +1165,17 @@ out:
         multifd_send_terminate_threads(local_err);
     }
 
+    /*
+     * Error happen, I will exit, but I can't just leave, tell
+     * who pay attention to me.
+     */
+    if (ret != 0) {
+        if (flags & MULTIFD_FLAG_SYNC) {
+            qemu_sem_post(&multifd_send_state->sem_sync);
+        }
+        qemu_sem_post(&multifd_send_state->channels_ready);
+    }
+
     qemu_mutex_lock(&p->mutex);
     p->running = false;
     qemu_mutex_unlock(&p->mutex);
-- 
2.21.0

