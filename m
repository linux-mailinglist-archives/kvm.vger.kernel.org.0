Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F838654A8
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 12:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbfGKKoi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 06:44:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49692 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727865AbfGKKoh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 06:44:37 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 995F83084243;
        Thu, 11 Jul 2019 10:44:37 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.36.118.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 154AD60600;
        Thu, 11 Jul 2019 10:44:32 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wei Yang <richardw.yang@linux.intel.com>,
        Peter Xu <peterx@redhat.com>
Subject: [PULL 07/19] migration/multifd: sync packet_num after all thread are done
Date:   Thu, 11 Jul 2019 12:44:00 +0200
Message-Id: <20190711104412.31233-8-quintela@redhat.com>
In-Reply-To: <20190711104412.31233-1-quintela@redhat.com>
References: <20190711104412.31233-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Thu, 11 Jul 2019 10:44:37 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wei Yang <richardw.yang@linux.intel.com>

Notification from recv thread is not ordered, which means we may be
notified by one MultiFDRecvParams but adjust packet_num for another.

Move the adjustment after we are sure each recv thread are sync-ed.

Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Message-Id: <20190604023540.26532-1-richardw.yang@linux.intel.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/ram.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/migration/ram.c b/migration/ram.c
index d3d72b6f4f..96c84f770a 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -1291,15 +1291,15 @@ static void multifd_recv_sync_main(void)
 
         trace_multifd_recv_sync_main_wait(p->id);
         qemu_sem_wait(&multifd_recv_state->sem_sync);
+    }
+    for (i = 0; i < migrate_multifd_channels(); i++) {
+        MultiFDRecvParams *p = &multifd_recv_state->params[i];
+
         qemu_mutex_lock(&p->mutex);
         if (multifd_recv_state->packet_num < p->packet_num) {
             multifd_recv_state->packet_num = p->packet_num;
         }
         qemu_mutex_unlock(&p->mutex);
-    }
-    for (i = 0; i < migrate_multifd_channels(); i++) {
-        MultiFDRecvParams *p = &multifd_recv_state->params[i];
-
         trace_multifd_recv_sync_main_signal(p->id);
         qemu_sem_post(&p->sem_sync);
     }
-- 
2.21.0

