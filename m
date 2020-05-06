Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAA31C6D91
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 11:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729227AbgEFJul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 05:50:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44581 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729206AbgEFJuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 05:50:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588758638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O10BhkYK4SLEDgxOR3AeYFqIdU21u3W3cDnwDc7jdOs=;
        b=Y0Xk9b8bYdPuxHX5GylAE2gwqu/ZFrIUGAQvqE/8d5XE6eBAuf+lUjCwf7xMsHKxW1CEtl
        E+VIYqKdi+GUBXbduaKaYHRdRwiob06g+Y+CYRC1jitnQGn0GmHU2/aiiwPh7Q6yL8Zkjo
        F0vW7ZHKMtR+WlDqz9sAvefNyZDc7ZU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-EJvB0YQXPxi4wNhYZd1E4g-1; Wed, 06 May 2020 05:50:37 -0400
X-MC-Unique: EJvB0YQXPxi4wNhYZd1E4g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01E92107ACF2;
        Wed,  6 May 2020 09:50:36 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-17.ams2.redhat.com [10.36.113.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F02245C1BD;
        Wed,  6 May 2020 09:50:33 +0000 (UTC)
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
Subject: [PATCH v1 07/17] migration/rdma: Use ram_block_discard_set_broken()
Date:   Wed,  6 May 2020 11:49:38 +0200
Message-Id: <20200506094948.76388-8-david@redhat.com>
In-Reply-To: <20200506094948.76388-1-david@redhat.com>
References: <20200506094948.76388-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RDMA will pin all guest memory (as documented in docs/rdma.txt). We want
to mark RAM block discards to be broken - however, to keep it simple
use ram_block_discard_is_required() instead of inhibiting.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Juan Quintela <quintela@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 migration/rdma.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/migration/rdma.c b/migration/rdma.c
index f61587891b..029adbb950 100644
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
@@ -4017,8 +4018,14 @@ void rdma_start_incoming_migration(const char *hos=
t_port, Error **errp)
     Error *local_err =3D NULL;
=20
     trace_rdma_start_incoming_migration();
-    rdma =3D qemu_rdma_data_init(host_port, &local_err);
=20
+    /* Avoid ram_block_discard_set_broken(), cannot change during migrat=
ion. */
+    if (ram_block_discard_is_required()) {
+        error_setg(errp, "RDMA: cannot set discarding of RAM broken");
+        return;
+    }
+
+    rdma =3D qemu_rdma_data_init(host_port, &local_err);
     if (rdma =3D=3D NULL) {
         goto err;
     }
@@ -4064,10 +4071,17 @@ void rdma_start_outgoing_migration(void *opaque,
                             const char *host_port, Error **errp)
 {
     MigrationState *s =3D opaque;
-    RDMAContext *rdma =3D qemu_rdma_data_init(host_port, errp);
     RDMAContext *rdma_return_path =3D NULL;
+    RDMAContext *rdma;
     int ret =3D 0;
=20
+    /* Avoid ram_block_discard_set_broken(), cannot change during migrat=
ion. */
+    if (ram_block_discard_is_required()) {
+        error_setg(errp, "RDMA: cannot set discarding of RAM broken");
+        return;
+    }
+
+    rdma =3D qemu_rdma_data_init(host_port, errp);
     if (rdma =3D=3D NULL) {
         goto err;
     }
--=20
2.25.3

