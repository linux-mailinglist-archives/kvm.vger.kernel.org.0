Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4BB1DB34A
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 14:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgETMcq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 08:32:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35468 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726818AbgETMcp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 08:32:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589977964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DnXExit5PY6ETETLTGktLhqdgOJgmypIUygrxNoshzw=;
        b=hl+q1FY0xqgilOWV2dx6yxGdzkuNiDEQlBiTDGDX1LYvkNQ+r45wFlixVEotSbu00aCI0b
        MLQBMx8giRAwm5XnuvBhcW4Bb+Lfm9AkrabRs4rW99n8exg4NRBFTDipib3CPnnknpv0Ne
        ygthqCE6yFz4v4mXMvDIeAWYNnSTTcs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-gQZkinsyNUGWAI2wvH9gAA-1; Wed, 20 May 2020 08:32:42 -0400
X-MC-Unique: gQZkinsyNUGWAI2wvH9gAA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 793F1100A8E8;
        Wed, 20 May 2020 12:32:41 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-76.ams2.redhat.com [10.36.113.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC87B61547;
        Wed, 20 May 2020 12:32:32 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Hailiang Zhang <zhang.zhanghailiang@huawei.com>,
        Juan Quintela <quintela@redhat.com>
Subject: [PATCH v2 08/19] migration/colo: Use ram_block_discard_disable()
Date:   Wed, 20 May 2020 14:31:41 +0200
Message-Id: <20200520123152.60527-9-david@redhat.com>
In-Reply-To: <20200520123152.60527-1-david@redhat.com>
References: <20200520123152.60527-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

COLO will copy all memory in a RAM block, disable discarding of RAM.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Hailiang Zhang <zhang.zhanghailiang@huawei.com>
Cc: Juan Quintela <quintela@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/migration/colo.h |  2 +-
 migration/migration.c    |  8 +++++++-
 migration/savevm.c       | 11 +++++++++--
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/migration/colo.h b/include/migration/colo.h
index 1636e6f907..768e1f04c3 100644
--- a/include/migration/colo.h
+++ b/include/migration/colo.h
@@ -25,7 +25,7 @@ void migrate_start_colo_process(MigrationState *s);
 bool migration_in_colo_state(void);
 
 /* loadvm */
-void migration_incoming_enable_colo(void);
+int migration_incoming_enable_colo(void);
 void migration_incoming_disable_colo(void);
 bool migration_incoming_colo_enabled(void);
 void *colo_process_incoming_thread(void *opaque);
diff --git a/migration/migration.c b/migration/migration.c
index 06000ef136..d71c46ac55 100644
--- a/migration/migration.c
+++ b/migration/migration.c
@@ -338,12 +338,18 @@ bool migration_incoming_colo_enabled(void)
 
 void migration_incoming_disable_colo(void)
 {
+    ram_block_discard_disable(false);
     migration_colo_enabled = false;
 }
 
-void migration_incoming_enable_colo(void)
+int migration_incoming_enable_colo(void)
 {
+    if (ram_block_discard_disable(true)) {
+        error_report("COLO: cannot disable RAM discard");
+        return -EBUSY;
+    }
     migration_colo_enabled = true;
+    return 0;
 }
 
 void migrate_add_address(SocketAddress *address)
diff --git a/migration/savevm.c b/migration/savevm.c
index c00a6807d9..19b4f9600d 100644
--- a/migration/savevm.c
+++ b/migration/savevm.c
@@ -2111,8 +2111,15 @@ static int loadvm_handle_recv_bitmap(MigrationIncomingState *mis,
 
 static int loadvm_process_enable_colo(MigrationIncomingState *mis)
 {
-    migration_incoming_enable_colo();
-    return colo_init_ram_cache();
+    int ret = migration_incoming_enable_colo();
+
+    if (!ret) {
+        ret = colo_init_ram_cache();
+        if (ret) {
+            migration_incoming_disable_colo();
+        }
+    }
+    return ret;
 }
 
 /*
-- 
2.25.4

