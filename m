Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A25CF72BD8
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 11:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfGXJz4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 05:55:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34572 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726853AbfGXJz4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 05:55:56 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6CB268CB4B;
        Wed, 24 Jul 2019 09:55:56 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-189.ams2.redhat.com [10.36.116.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C18360BEC;
        Wed, 24 Jul 2019 09:55:44 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Ren <renyime@gmail.com>, Ivan Ren <ivanren@tencent.com>
Subject: [PATCH 4/4] migration: fix migrate_cancel multifd migration leads destination hung forever
Date:   Wed, 24 Jul 2019 11:55:23 +0200
Message-Id: <20190724095523.1527-5-quintela@redhat.com>
In-Reply-To: <20190724095523.1527-1-quintela@redhat.com>
References: <20190724095523.1527-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 24 Jul 2019 09:55:56 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ivan Ren <renyime@gmail.com>

When migrate_cancel a multifd migration, if run sequence like this:

        [source]                              [destination]

multifd_send_sync_main[finish]
                                    multifd_recv_thread wait &p->sem_sync
shutdown to_dst_file
                                    detect error from_src_file
send  RAM_SAVE_FLAG_EOS[fail]       [no chance to run multifd_recv_sync_main]
                                    multifd_load_cleanup
                                    join multifd receive thread forever

will lead destination qemu hung at following stack:

pthread_join
qemu_thread_join
multifd_load_cleanup
process_incoming_migration_co
coroutine_trampoline

Signed-off-by: Ivan Ren <ivanren@tencent.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Message-Id: <1561468699-9819-4-git-send-email-ivanren@tencent.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/ram.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/migration/ram.c b/migration/ram.c
index eb6716710e..889148dd84 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -1292,6 +1292,11 @@ int multifd_load_cleanup(Error **errp)
 
         if (p->running) {
             p->quit = true;
+            /*
+             * multifd_recv_thread may hung at MULTIFD_FLAG_SYNC handle code,
+             * however try to wakeup it without harm in cleanup phase.
+             */
+            qemu_sem_post(&p->sem_sync);
             qemu_thread_join(&p->thread);
         }
         object_unref(OBJECT(p->c));
-- 
2.21.0

