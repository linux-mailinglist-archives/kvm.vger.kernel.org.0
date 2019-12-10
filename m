Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60791118569
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 11:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbfLJKnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 05:43:24 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45738 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727412AbfLJKnV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Dec 2019 05:43:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575974600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tnXvqpFpNzP8oPTla7hKks1vt4Ju8zKblazbqfdN9vI=;
        b=c1ncx/iQdjW5xNL2XOuE+Rdn1F3whxUFvLefXUx2hKz9ZdSFYcRutmui0dE+qSQA/zYwwp
        iXsBErDRPa2mk7bl02Frp/9aJnjHZOoJ32JF2wgeDlhj4L0ZckRkFK5+C6dvy9vlLEtpjJ
        81XJ6/13dzbUCFPZVJxM8bWNeLRu8VU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-cxDu77_YMKiBjb-D9Pf9LQ-1; Tue, 10 Dec 2019 05:43:19 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6E17800D5E;
        Tue, 10 Dec 2019 10:43:17 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-168.ams2.redhat.com [10.36.117.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7B5660568;
        Tue, 10 Dec 2019 10:43:15 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Dexuan Cui <decui@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH net-next v2 2/6] vsock: add VMADDR_CID_LOCAL definition
Date:   Tue, 10 Dec 2019 11:43:03 +0100
Message-Id: <20191210104307.89346-3-sgarzare@redhat.com>
In-Reply-To: <20191210104307.89346-1-sgarzare@redhat.com>
References: <20191210104307.89346-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: cxDu77_YMKiBjb-D9Pf9LQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The VMADDR_CID_RESERVED (1) was used by VMCI, but now it is not
used anymore, so we can reuse it for local communication
(loopback) adding the new well-know CID: VMADDR_CID_LOCAL.

Cc: Jorgen Hansen <jhansen@vmware.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/uapi/linux/vm_sockets.h | 8 +++++---
 net/vmw_vsock/vmci_transport.c  | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_socket=
s.h
index 68d57c5e99bc..fd0ed7221645 100644
--- a/include/uapi/linux/vm_sockets.h
+++ b/include/uapi/linux/vm_sockets.h
@@ -99,11 +99,13 @@
=20
 #define VMADDR_CID_HYPERVISOR 0
=20
-/* This CID is specific to VMCI and can be considered reserved (even VMCI
- * doesn't use it anymore, it's a legacy value from an older release).
+/* Use this as the destination CID in an address when referring to the
+ * local communication (loopback).
+ * (This was VMADDR_CID_RESERVED, but even VMCI doesn't use it anymore,
+ * it was a legacy value from an older release).
  */
=20
-#define VMADDR_CID_RESERVED 1
+#define VMADDR_CID_LOCAL 1
=20
 /* Use this as the destination CID in an address when referring to the hos=
t
  * (any process other than the hypervisor).  VMCI relies on it being 2, bu=
t
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.=
c
index 644d32e43d23..4b8b1150a738 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -648,7 +648,7 @@ static int vmci_transport_recv_dgram_cb(void *data, str=
uct vmci_datagram *dg)
 static bool vmci_transport_stream_allow(u32 cid, u32 port)
 {
 =09static const u32 non_socket_contexts[] =3D {
-=09=09VMADDR_CID_RESERVED,
+=09=09VMADDR_CID_LOCAL,
 =09};
 =09int i;
=20
--=20
2.23.0

