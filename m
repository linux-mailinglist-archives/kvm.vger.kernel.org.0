Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01DF8F50A8
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 17:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfKHQI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 11:08:59 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55683 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726036AbfKHQI7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Nov 2019 11:08:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573229338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=K93xC4W4XxB9V/XDY2JHTux4Xj+XQzupJKYWOTL6WL8=;
        b=c7ZMerKlfRKJ2H93YM+oF0OGzVsrGZNSQ8Ke/1uY8xoPjN+HtrPerX+asLLhbVTGyPI5uE
        NB418KZGA1d5BEZVx8mmkKinLOtSRCrJSUUTfpP8DfVtyCcVOoS2KoU34MQrhCzgY/F9gG
        l7kdpbvXQJl6/Qc5verSIAu7tj+ra+o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-ko3GzfECMG-Z6GrtGtEBvw-1; Fri, 08 Nov 2019 11:08:57 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EDCC1005500;
        Fri,  8 Nov 2019 16:08:55 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-238.ams2.redhat.com [10.36.117.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E69AC60BE2;
        Fri,  8 Nov 2019 16:08:50 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Stephen Barber <smbarber@chromium.org>,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH] vsock/virtio: fix sock refcnt holding during the shutdown
Date:   Fri,  8 Nov 2019 17:08:50 +0100
Message-Id: <20191108160850.51278-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: ko3GzfECMG-Z6GrtGtEBvw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "42f5cda5eaf4" commit rightly set SOCK_DONE on peer shutdown,
but there is an issue if we receive the SHUTDOWN(RDWR) while the
virtio_transport_close_timeout() is scheduled.
In this case, when the timeout fires, the SOCK_DONE is already
set and the virtio_transport_close_timeout() will not call
virtio_transport_reset() and virtio_transport_do_close().
This causes that both sockets remain open and will never be released,
preventing the unloading of [virtio|vhost]_transport modules.

This patch fixes this issue, calling virtio_transport_reset() and
virtio_transport_do_close() when we receive the SHUTDOWN(RDWR)
and there is nothing left to read.

Fixes: 42f5cda5eaf4 ("vsock/virtio: set SOCK_DONE on peer shutdown")
Cc: Stephen Barber <smbarber@chromium.org>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio=
_transport_common.c
index 481f7f8a1655..fb2060dffb0a 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -947,9 +947,11 @@ virtio_transport_recv_connected(struct sock *sk,
 =09=09if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SHUTDOWN_SEND)
 =09=09=09vsk->peer_shutdown |=3D SEND_SHUTDOWN;
 =09=09if (vsk->peer_shutdown =3D=3D SHUTDOWN_MASK &&
-=09=09    vsock_stream_has_data(vsk) <=3D 0) {
-=09=09=09sock_set_flag(sk, SOCK_DONE);
-=09=09=09sk->sk_state =3D TCP_CLOSING;
+=09=09    vsock_stream_has_data(vsk) <=3D 0 &&
+=09=09    !sock_flag(sk, SOCK_DONE)) {
+=09=09=09(void)virtio_transport_reset(vsk, NULL);
+
+=09=09=09virtio_transport_do_close(vsk, true);
 =09=09}
 =09=09if (le32_to_cpu(pkt->hdr.flags))
 =09=09=09sk->sk_state_change(sk);
--=20
2.21.0

