Return-Path: <kvm+bounces-20307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1B65912DF6
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 21:38:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 296C7B26FD3
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 19:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BEB117C208;
	Fri, 21 Jun 2024 19:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="PhsCqQCv"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B82F168482;
	Fri, 21 Jun 2024 19:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.18.73.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718998662; cv=none; b=RwwMT03JCbwJKgySdAMTiGrbQLVA8VDsj10xuP7wCk1GLFfSbcCtrX1HHBU3jd5kfzTWDi6JNF3o0Pxq4xhEuzj6NVCJxxGWIEseDfv8SUIscoOySOcwrY6yvo+p+jvilVQXZppLnzU55kD309Yn7V02AWDD2xTefu7FtyW37/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718998662; c=relaxed/simple;
	bh=mRjpXsNEbhi2mQjhG5KP0CF8PUCU4S3lTnB8pLYCUI8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qk85b7YsJf+Pl3UhIlIyWKgIHoEjbUnupXHmug/CThdyjOLHNUTx0NPfPngrBgjtwTnJCQg9TeXnmcGKx/i0XfYTF/t2CXGPPv77EEZg0Llp9TYwpxVSYxyag/MPam8ExeciFlw3Hg+B9Tg7PZaqQWhLKfNHezFQjpdwnaWulJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=PhsCqQCv; arc=none smtp.client-ip=37.18.73.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Received: from p-infra-ksmg-sc-msk01.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id D544D100006;
	Fri, 21 Jun 2024 22:37:29 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru D544D100006
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1718998649;
	bh=VT5gIGGs+UzYkF+C6lwdSpMrf/K2IcA9ciJlIDD0xY4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=PhsCqQCvVzZzrzh9RSBmv47TVeVeQV4GYLPcBFu3MyZrSpEI31imYUizxOpkNMxgw
	 IhcQJKVWoPAGxh3LKjerkjy724c9y8DUhyVEzGsb0KL2qpv4BVhaJNMRMxqF62nyBI
	 eRWzhrhO267I7LbxvgDNxZcCV06vMwzoQwj4RUcytnRrrBUS8FuqNPhFlAB6lWr6B9
	 ca1L62oxJ6pP8NU/bPjrmECLwjB2Xi0TS+SN1K2Zj2ivd0//5d7b26+oxCVWbHG21Y
	 eRmrVeREXaSbRLyaJN6nmj6qmKUNZSK+EyJ+VLZJfoiAYTxqvAhKn6ln8W2owjyuH5
	 NhmpK0qQLELpg==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Fri, 21 Jun 2024 22:37:29 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Fri, 21 Jun 2024 22:37:28 +0300
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
To: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
	<jasowang@redhat.com>, Bobby Eshleman <bobby.eshleman@bytedance.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel@sberdevices.ru>, <oxffffaa@gmail.com>, <avkrasnov@salutedevices.com>
Subject: [RFC PATCH v1 1/2] virtio/vsock: rework deferred credit update logic
Date: Fri, 21 Jun 2024 22:25:40 +0300
Message-ID: <20240621192541.2082657-2-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20240621192541.2082657-1-avkrasnov@salutedevices.com>
References: <20240621192541.2082657-1-avkrasnov@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 186064 [Jun 21 2024]
X-KSMG-AntiSpam-Version: 6.1.0.4
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 20 0.3.20 743589a8af6ec90b529f2124c2bbfc3ce1d2f20f, {Tracking_from_domain_doesnt_match_to}, smtp.sberdevices.ru:7.1.1,5.0.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;100.64.160.123:7.1.2;salutedevices.com:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/06/21 16:35:00 #25651590
X-KSMG-AntiVirus-Status: Clean, skipped

Previous calculation of 'free_space' was wrong (but worked as expected
in most cases, see below), because it didn't account number of bytes in
rx queue. Let's rework 'free_space' calculation in the following way:
as this value is considered free space at rx side from tx point of view,
it must be equal to return value of 'virtio_transport_get_credit()' at
tx side. This function uses 'tx_cnt' counter and 'peer_fwd_cnt': first
is number of transmitted bytes (without wrap), second is last 'fwd_cnt'
value received from rx. So let's use same approach at rx side during
'free_space' calculation: add 'rx_cnt' counter which is number of
received bytes (also without wrap) and subtract 'last_fwd_cnt' from it.
Now we have:
1) 'rx_cnt' == 'tx_cnt' at both sides.
2) 'last_fwd_cnt' == 'peer_fwd_cnt' - because first is last 'fwd_cnt'
   sent to tx, while second is last 'fwd_cnt' received from rx.

Now 'free_space' is handled correctly and also we don't need
'low_rx_bytes' flag - this was more like a hack.

Previous calculation of 'free_space' worked (in 99% cases), because if
we take a look on behaviour of both expressions (new and previous):

'(rx_cnt - last_fwd_cnt)' and '(fwd_cnt - last_fwd_cnt)'

Both of them always grows up, with almost same "speed": only difference
is that 'rx_cnt' is incremented earlier during packet is received,
while 'fwd_cnt' in incremented when packet is read by user. So if 'rx_cnt'
grows "faster", then resulting 'free_space' become smaller also, so we
send credit updates a little bit more, but:

  * 'free_space' calculation based on 'rx_cnt' gives the same value,
    which tx sees as free space at rx side, so original idea of
    'free_space' is now implemented as planned.
  * Hack with 'low_rx_bytes' now is not needed.

Also here is some performance comparison between both versions of
'free_space' calculation:

 *------*----------*----------*
 |      | 'rx_cnt' | previous |
 *------*----------*----------*
 |H -> G|   8.42   |   7.82   |
 *------*----------*----------*
 |G -> H|   11.6   |   12.1   |
 *------*----------*----------*

As benchmark 'vsock-iperf' with default arguments was used. There is no
significant performance difference before and after this patch.

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
---
 include/linux/virtio_vsock.h            | 1 +
 net/vmw_vsock/virtio_transport_common.c | 8 +++-----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index c82089dee0c8..3579491c411e 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -135,6 +135,7 @@ struct virtio_vsock_sock {
 	u32 peer_buf_alloc;
 
 	/* Protected by rx_lock */
+	u32 rx_cnt;
 	u32 fwd_cnt;
 	u32 last_fwd_cnt;
 	u32 rx_bytes;
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 16ff976a86e3..1d4e2328e06e 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -441,6 +441,7 @@ static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
 		return false;
 
 	vvs->rx_bytes += len;
+	vvs->rx_cnt += len;
 	return true;
 }
 
@@ -558,7 +559,6 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	size_t bytes, total = 0;
 	struct sk_buff *skb;
 	u32 fwd_cnt_delta;
-	bool low_rx_bytes;
 	int err = -EFAULT;
 	u32 free_space;
 
@@ -603,9 +603,7 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	}
 
 	fwd_cnt_delta = vvs->fwd_cnt - vvs->last_fwd_cnt;
-	free_space = vvs->buf_alloc - fwd_cnt_delta;
-	low_rx_bytes = (vvs->rx_bytes <
-			sock_rcvlowat(sk_vsock(vsk), 0, INT_MAX));
+	free_space = vvs->buf_alloc - (vvs->rx_cnt - vvs->last_fwd_cnt);
 
 	spin_unlock_bh(&vvs->rx_lock);
 
@@ -619,7 +617,7 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	 * number of bytes in rx queue is not enough to wake up reader.
 	 */
 	if (fwd_cnt_delta &&
-	    (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE || low_rx_bytes))
+	    (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE))
 		virtio_transport_send_credit_update(vsk);
 
 	return total;
-- 
2.25.1


