Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5FF68C71
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 15:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732101AbfGONvl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 09:51:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52244 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731160AbfGONvk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 09:51:40 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 667652F8BD5;
        Mon, 15 Jul 2019 13:51:40 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.36.118.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A1F55B681;
        Mon, 15 Jul 2019 13:51:37 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Juan Quintela <quintela@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Laurent Vivier <lvivier@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Wei Yang <richardw.yang@linux.intel.com>
Subject: [PULL 03/21] migration/multifd: call multifd_send_sync_main when sending RAM_SAVE_FLAG_EOS
Date:   Mon, 15 Jul 2019 15:51:07 +0200
Message-Id: <20190715135125.17770-4-quintela@redhat.com>
In-Reply-To: <20190715135125.17770-1-quintela@redhat.com>
References: <20190715135125.17770-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 15 Jul 2019 13:51:40 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wei Yang <richardw.yang@linux.intel.com>

On receiving RAM_SAVE_FLAG_EOS, multifd_recv_sync_main() is called to
synchronize receive threads. Current synchronization mechanism is to wait
for each channel's sem_sync semaphore. This semaphore is triggered by a
packet with MULTIFD_FLAG_SYNC flag. While in current implementation, we
don't do multifd_send_sync_main() to send such packet when
blk_mig_bulk_active() is true.

This will leads to the receive threads won't notify
multifd_recv_sync_main() by sem_sync. And multifd_recv_sync_main() will
always wait there.

[Note]: normal migration test works, while didn't test the
blk_mig_bulk_active() case. Since not sure how to produce this
situation.

Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Message-Id: <20190612014337.11255-1-richardw.yang@linux.intel.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/ram.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/migration/ram.c b/migration/ram.c
index 908517fc2b..74c9306c78 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -3466,8 +3466,8 @@ static int ram_save_iterate(QEMUFile *f, void *opaque)
      */
     ram_control_after_iterate(f, RAM_CONTROL_ROUND);
 
-    multifd_send_sync_main();
 out:
+    multifd_send_sync_main();
     qemu_put_be64(f, RAM_SAVE_FLAG_EOS);
     qemu_fflush(f);
     ram_counters.transferred += 8;
-- 
2.21.0

