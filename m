Return-Path: <kvm+bounces-3773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B2494807A5E
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 22:27:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 238D41C20442
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 21:27:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F5D370960;
	Wed,  6 Dec 2023 21:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="n8esJVfM"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38CC0D5C;
	Wed,  6 Dec 2023 13:27:12 -0800 (PST)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 7EDFC120066;
	Thu,  7 Dec 2023 00:27:10 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 7EDFC120066
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1701898030;
	bh=GHNWtOPMCbudLrNVAc3MZd8FL3ABIjio3CjPcM+SRoM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=n8esJVfMhQwGDoRuF912rYf1+AWbKOjfkBXWNiFGLr418uHCc8qupouUhRs7n+r0Y
	 t1jpV7C86ZSdnY7sqEf50J1DSHQ4JkgZBqJTWO3mweXGxXiteB0lYofMESuPsscfd8
	 JcBjmvybZSxGoT3B2fYfN4dAAlDkhKMKZu9VLrJAkQM9NEzxH5uLtSTOW08D4lg/Ol
	 Oa3oRBW/yB85O0s/ZJx0EY9YUl8tBY1FmiAc04yEVYEOxX/BErK8Q7Vxu6fZkOSUjd
	 8KRmz1MpPpGd/0zS7DIq6AjHNRL3NpuI0Rg9x/OI72bz+AeytEaiFNxhTKhyMxsqeZ
	 GIfy5EbNOEHow==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Thu,  7 Dec 2023 00:27:10 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Thu, 7 Dec 2023 00:27:10 +0300
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
To: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
	<jasowang@redhat.com>, Bobby Eshleman <bobby.eshleman@bytedance.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel@sberdevices.ru>, <oxffffaa@gmail.com>, <avkrasnov@salutedevices.com>
Subject: [PATCH net-next v7 3/4] virtio/vsock: fix logic which reduces credit update messages
Date: Thu, 7 Dec 2023 00:18:48 +0300
Message-ID: <20231206211849.2707151-4-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20231206211849.2707151-1-avkrasnov@salutedevices.com>
References: <20231206211849.2707151-1-avkrasnov@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 181917 [Dec 06 2023]
X-KSMG-AntiSpam-Version: 6.0.0.2
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 5 0.3.5 98d108ddd984cca1d7e65e595eac546a62b0144b, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;100.64.160.123:7.1.2;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;127.0.0.199:7.1.2;salutedevices.com:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/12/06 19:07:00 #22622451
X-KSMG-AntiVirus-Status: Clean, skipped

Add one more condition for sending credit update during dequeue from
stream socket: when number of bytes in the rx queue is smaller than
SO_RCVLOWAT value of the socket. This is actual for non-default value
of SO_RCVLOWAT (e.g. not 1) - idea is to "kick" peer to continue data
transmission, because we need at least SO_RCVLOWAT bytes in our rx
queue to wake up user for reading data (in corner case it is also
possible to stuck both tx and rx sides, this is why 'Fixes' is used).
Also handle case when 'fwd_cnt' wraps, while 'last_fwd_cnt' is still
not.

Fixes: b89d882dc9fc ("vsock/virtio: reduce credit update messages")
Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
---
 Changelog:
 v6 -> v7:
  * Handle wrap of 'fwd_cnt'.
  * Do to send credit update when 'fwd_cnt' == 'last_fwd_cnt'.

 net/vmw_vsock/virtio_transport_common.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index e137d740804e..39f8660d825d 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -558,6 +558,8 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	struct virtio_vsock_sock *vvs = vsk->trans;
 	size_t bytes, total = 0;
 	struct sk_buff *skb;
+	u32 fwd_cnt_delta;
+	bool low_rx_bytes;
 	int err = -EFAULT;
 	u32 free_space;
 
@@ -601,7 +603,15 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 		}
 	}
 
-	free_space = vvs->buf_alloc - (vvs->fwd_cnt - vvs->last_fwd_cnt);
+	/* Handle wrap of 'fwd_cnt'. */
+	if (vvs->fwd_cnt < vvs->last_fwd_cnt)
+		fwd_cnt_delta = vvs->fwd_cnt + (U32_MAX - vvs->last_fwd_cnt);
+	else
+		fwd_cnt_delta = vvs->fwd_cnt - vvs->last_fwd_cnt;
+
+	free_space = vvs->buf_alloc - fwd_cnt_delta;
+	low_rx_bytes = (vvs->rx_bytes <
+			sock_rcvlowat(sk_vsock(vsk), 0, INT_MAX));
 
 	spin_unlock_bh(&vvs->rx_lock);
 
@@ -611,9 +621,11 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	 * too high causes extra messages. Too low causes transmitter
 	 * stalls. As stalls are in theory more expensive than extra
 	 * messages, we set the limit to a high value. TODO: experiment
-	 * with different values.
+	 * with different values. Also send credit update message when
+	 * number of bytes in rx queue is not enough to wake up reader.
 	 */
-	if (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
+	if (fwd_cnt_delta &&
+	    (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE || low_rx_bytes))
 		virtio_transport_send_credit_update(vsk);
 
 	return total;
-- 
2.25.1


