Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5425313586
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 15:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbhBHOrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 09:47:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40068 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232762AbhBHOqf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 09:46:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612795510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wDyz1IFDSEAOIerG7E7i9OIec2MQQzh/7MUoQ35aflI=;
        b=cFb32JV560wVXBz9LG6xx0n0qngVWx8faTQEVacBMhRwbAQiStTiwthcz8gUOzm1wjhDkE
        4VmZ5tkZjhRZtU7fk6Y//c9b2yvE51t++wFDf011Jp+Rdxa91L2Y9UjobBc0AGk5GiBNd0
        3OgtyKFMZhe14vx/ZEXRP8SAXJYvROc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-h0NjNB0VO72XsLi_FX5LlQ-1; Mon, 08 Feb 2021 09:45:08 -0500
X-MC-Unique: h0NjNB0VO72XsLi_FX5LlQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EC11801975;
        Mon,  8 Feb 2021 14:45:07 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-115-25.ams2.redhat.com [10.36.115.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E2FBD5D740;
        Mon,  8 Feb 2021 14:44:55 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     kuba@kernel.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Asias He <asias@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH net] vsock/virtio: update credit only if socket is not closed
Date:   Mon,  8 Feb 2021 15:44:54 +0100
Message-Id: <20210208144454.84438-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the socket is closed or is being released, some resources used by
virtio_transport_space_update() such as 'vsk->trans' may be released.

To avoid a use after free bug we should only update the available credit
when we are sure the socket is still open and we have the lock held.

Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 5956939eebb7..e4370b1b7494 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1130,8 +1130,6 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 
 	vsk = vsock_sk(sk);
 
-	space_available = virtio_transport_space_update(sk, pkt);
-
 	lock_sock(sk);
 
 	/* Check if sk has been closed before lock_sock */
@@ -1142,6 +1140,8 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 		goto free_pkt;
 	}
 
+	space_available = virtio_transport_space_update(sk, pkt);
+
 	/* Update CID in case it has changed after a transport reset event */
 	vsk->local_addr.svm_cid = dst.svm_cid;
 
-- 
2.29.2

