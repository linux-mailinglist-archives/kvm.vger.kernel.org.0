Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6614403907
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 13:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351501AbhIHLnq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 07:43:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24112 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349176AbhIHLnp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Sep 2021 07:43:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631101357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0OKWbveyBp4LK+jfSbX2BcrMPG8lLWS9NwmPSKg8Irs=;
        b=WHnhxyLvxvvemgHKtBLFfJesmYwdrYUyxEas9UCehtO5JbJ6vNHu4E8gxza5Z4kKeoD+lB
        92WFq9nAi3100p/fMADPdBj+7Nz8wGIc++E3S2ptJzPayT6A+H8w4ZdeIZy0FEHISG7U7d
        GohDU6R8dN2Qo6UKRIsSfXLcEA+qADg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-20EbSMTJPlid_wF6ZA4jZg-1; Wed, 08 Sep 2021 07:42:35 -0400
X-MC-Unique: 20EbSMTJPlid_wF6ZA4jZg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BCCF8835DE0;
        Wed,  8 Sep 2021 11:42:34 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.192.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC24560C17;
        Wed,  8 Sep 2021 11:42:29 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH] vhost_net: fix OoB on sendmsg() failure.
Date:   Wed,  8 Sep 2021 13:42:09 +0200
Message-Id: <463c1b02ca6f65fc1183431d8d85ec8154a2c28e.1631090797.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the sendmsg() call in vhost_tx_batch() fails, both the 'batched_xdp'
and 'done_idx' indexes are left unchanged. If such failure happens
when batched_xdp == VHOST_NET_BATCH, the next call to
vhost_net_build_xdp() will access and write memory outside the xdp
buffers area.

Since sendmsg() can only error with EBADFD, this change addresses the
issue explicitly freeing the XDP buffers batch on error.

Fixes: 0a0be13b8fe2 ("vhost_net: batch submitting XDP buffers to underlayer sockets")
Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
Note: my understanding is that this should go through MST's tree, please
educate me otherwise, thanks!
---
 drivers/vhost/net.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 3a249ee7e144..28ef323882fb 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -467,7 +467,7 @@ static void vhost_tx_batch(struct vhost_net *net,
 		.num = nvq->batched_xdp,
 		.ptr = nvq->xdp,
 	};
-	int err;
+	int i, err;
 
 	if (nvq->batched_xdp == 0)
 		goto signal_used;
@@ -476,6 +476,15 @@ static void vhost_tx_batch(struct vhost_net *net,
 	err = sock->ops->sendmsg(sock, msghdr, 0);
 	if (unlikely(err < 0)) {
 		vq_err(&nvq->vq, "Fail to batch sending packets\n");
+
+		/* free pages owned by XDP; since this is an unlikely error path,
+		 * keep it simple and avoid more complex bulk update for the
+		 * used pages
+		 */
+		for (i = 0; i < nvq->batched_xdp; ++i)
+			put_page(virt_to_head_page(nvq->xdp[i].data));
+		nvq->batched_xdp = 0;
+		nvq->done_idx = 0;
 		return;
 	}
 
-- 
2.26.3

