Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A147D68CAF
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 15:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732322AbfGONxP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 09:53:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39272 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732302AbfGONxK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 09:53:10 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 496FC30C2534;
        Mon, 15 Jul 2019 13:53:10 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.36.118.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 04F755B681;
        Mon, 15 Jul 2019 13:53:02 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Juan Quintela <quintela@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Laurent Vivier <lvivier@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Peng Tao <tao.peng@linux.alibaba.com>,
        Yury Kotov <yury-kotov@yandex-team.ru>,
        Jiangshan Lai <laijs@hyper.sh>, Xu Wang <xu@hyper.sh>
Subject: [PULL 18/21] migration: allow private destination ram with x-ignore-shared
Date:   Mon, 15 Jul 2019 15:51:22 +0200
Message-Id: <20190715135125.17770-19-quintela@redhat.com>
In-Reply-To: <20190715135125.17770-1-quintela@redhat.com>
References: <20190715135125.17770-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Mon, 15 Jul 2019 13:53:10 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peng Tao <tao.peng@linux.alibaba.com>

By removing the share ram check, qemu is able to migrate
to private destination ram when x-ignore-shared capability
is on. Then we can create multiple destination VMs based
on the same source VM.

This changes the x-ignore-shared migration capability to
work similar to Lai's original bypass-shared-memory
work(https://lists.gnu.org/archive/html/qemu-devel/2018-04/msg00003.html)
which enables kata containers (https://katacontainers.io)
to implement the VM templating feature.

An example usage in kata containers(https://katacontainers.io):
1. Start the source VM:
   qemu-system-x86 -m 2G \
     -object memory-backend-file,id=mem0,size=2G,share=on,mem-path=/tmpfs/template-memory \
     -numa node,memdev=mem0
2. Stop the template VM, set migration x-ignore-shared capability,
   migrate "exec:cat>/tmpfs/state", quit it
3. Start target VM:
   qemu-system-x86 -m 2G \
     -object memory-backend-file,id=mem0,size=2G,share=off,mem-path=/tmpfs/template-memory \
     -numa node,memdev=mem0 \
     -incoming defer
4. connect to target VM qmp, set migration x-ignore-shared capability,
migrate_incoming "exec:cat /tmpfs/state"
5. create more target VMs repeating 3 and 4

Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: Yury Kotov <yury-kotov@yandex-team.ru>
Cc: Jiangshan Lai <laijs@hyper.sh>
Cc: Xu Wang <xu@hyper.sh>
Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Message-Id: <1560494113-1141-1-git-send-email-tao.peng@linux.alibaba.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/ram.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/migration/ram.c b/migration/ram.c
index 8a6ad61d3d..8622b4dc49 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -3426,7 +3426,6 @@ static int ram_save_setup(QEMUFile *f, void *opaque)
         }
         if (migrate_ignore_shared()) {
             qemu_put_be64(f, block->mr->addr);
-            qemu_put_byte(f, ramblock_is_ignored(block) ? 1 : 0);
         }
     }
 
@@ -4393,12 +4392,6 @@ static int ram_load(QEMUFile *f, void *opaque, int version_id)
                     }
                     if (migrate_ignore_shared()) {
                         hwaddr addr = qemu_get_be64(f);
-                        bool ignored = qemu_get_byte(f);
-                        if (ignored != ramblock_is_ignored(block)) {
-                            error_report("RAM block %s should %s be migrated",
-                                         id, ignored ? "" : "not");
-                            ret = -EINVAL;
-                        }
                         if (ramblock_is_ignored(block) &&
                             block->mr->addr != addr) {
                             error_report("Mismatched GPAs for block %s "
-- 
2.21.0

