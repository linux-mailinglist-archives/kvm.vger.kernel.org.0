Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A010D1DB342
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 14:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgETMch (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 08:32:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28407 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726443AbgETMcg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 08:32:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589977955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ltKYoFTOFOwpgkCR+dwMIxXVVeSfSRqAc7bfSqKPYMw=;
        b=IP+stV+1X126LqE8K5CGN3asm64esuNAPIiY+gj4MGfQ1CfzYzR/Zf7AINgpR4vPNLkLcQ
        ERph7HesCno4yvhs0airzUBhV0Tud2hxQp24LVE3H/PngOVyufWVwqjakX8bEubyoHdczy
        LmaOBNjUm9xbzF+N9Lb6oB3rHQg5XXI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-aSsHCautMRepCBYq4ho0cA-1; Wed, 20 May 2020 08:32:33 -0400
X-MC-Unique: aSsHCautMRepCBYq4ho0cA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9997718FE868;
        Wed, 20 May 2020 12:32:32 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-76.ams2.redhat.com [10.36.113.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 870C46AD16;
        Wed, 20 May 2020 12:32:30 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Juan Quintela <quintela@redhat.com>
Subject: [PATCH v2 07/19] migration/rdma: Use ram_block_discard_disable()
Date:   Wed, 20 May 2020 14:31:40 +0200
Message-Id: <20200520123152.60527-8-david@redhat.com>
In-Reply-To: <20200520123152.60527-1-david@redhat.com>
References: <20200520123152.60527-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RDMA will pin all guest memory (as documented in docs/rdma.txt). We want
to disable RAM block discards - however, to keep it simple use
ram_block_discard_is_required() instead of inhibiting.

Note: It is not sufficient to limit disabling to pin_all. Even when only
conditionally pinning 1 MB chunks, as soon as one page within such a
chunk was discarded and one page not, the discarded pages will be pinned
as well.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Juan Quintela <quintela@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 migration/rdma.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/migration/rdma.c b/migration/rdma.c
index 967fda5b0c..57e2cbc8ca 100644
--- a/migration/rdma.c
+++ b/migration/rdma.c
@@ -29,6 +29,7 @@
 #include "qemu/sockets.h"
 #include "qemu/bitmap.h"
 #include "qemu/coroutine.h"
+#include "exec/memory.h"
 #include <sys/socket.h>
 #include <netdb.h>
 #include <arpa/inet.h>
@@ -4017,8 +4018,14 @@ void rdma_start_incoming_migration(const char *host_port, Error **errp)
     Error *local_err = NULL;
 
     trace_rdma_start_incoming_migration();
-    rdma = qemu_rdma_data_init(host_port, &local_err);
 
+    /* Avoid ram_block_discard_disable(), cannot change during migration. */
+    if (ram_block_discard_is_required()) {
+        error_setg(errp, "RDMA: cannot disable RAM discard");
+        return;
+    }
+
+    rdma = qemu_rdma_data_init(host_port, &local_err);
     if (rdma == NULL) {
         goto err;
     }
@@ -4065,10 +4072,17 @@ void rdma_start_outgoing_migration(void *opaque,
                             const char *host_port, Error **errp)
 {
     MigrationState *s = opaque;
-    RDMAContext *rdma = qemu_rdma_data_init(host_port, errp);
     RDMAContext *rdma_return_path = NULL;
+    RDMAContext *rdma;
     int ret = 0;
 
+    /* Avoid ram_block_discard_disable(), cannot change during migration. */
+    if (ram_block_discard_is_required()) {
+        error_setg(errp, "RDMA: cannot disable RAM discard");
+        return;
+    }
+
+    rdma = qemu_rdma_data_init(host_port, errp);
     if (rdma == NULL) {
         goto err;
     }
-- 
2.25.4

