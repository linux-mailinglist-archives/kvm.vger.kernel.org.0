Return-Path: <kvm+bounces-13377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 065608957C1
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 17:06:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 70AB01F237CF
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 15:06:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4381913173C;
	Tue,  2 Apr 2024 15:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="LQzH9vYq"
X-Original-To: kvm@vger.kernel.org
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05olkn2072.outbound.protection.outlook.com [40.92.89.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5566B12D1F4;
	Tue,  2 Apr 2024 15:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.89.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712070356; cv=fail; b=lF9E+sxGvCM6FDujFmUCtJmNixTVH0VctJKCBHYiMmPRNw66HJFp4lwVc3pBVcJyotX+4/cxotLird31psNDWxkZyAbBhxh9tdwB6tK4RDzb1kcYyG9RMdI4h0a0dHxOsZaCAu+8lC6CdWR9EK2rPhxVyBsaTd6d3Qg3wPu+FU4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712070356; c=relaxed/simple;
	bh=mX/9sQIiOFOIwDgcPLc+2ovYwu0RIHzELqX5S6T4Vkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jazHqyRQ5c/B0kt0ttEmDE53uEy3xwH4A3WhZERQ/RvhK1dELhD0gizPnAhYTiaL32kvJtW8f6FpvHNegOjmrIWQ9JILivOC+1sewwR69M47wsi79Hr9UvTkM5wGASTr5P8AUA+hgJB6HMObjgODDO7Yom2wQjdW0L4VYgHQ4Vo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=LQzH9vYq; arc=fail smtp.client-ip=40.92.89.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HiznLAZDIbMuy1Ms2/dPmVsrHnH5bEn1KBcujY8FMrOIOPp+URcN4ielM90We+ulcljFoITU0gNbnC7YCY8VxuSFK2IMS0Sw8Oqga2slZ7r+Q+LshLXWFrf6nQdbAlj30BnP0k0Upy7wqO2k+AKKEx/+QStRUkOrCjwPx9x2yXnYMxLA6fO8L4TK9s55KJ66wFH+kvJlH3XWnkadlwjMEl7+HzBqsVq6daUrEj2A5vdlH3EnVaT5a3MDcQefmMB0MGeoCfywqqoZk1NbH5E4TMhQJdM7NoKVjMMu3PMQ3EvRrApQz8p5TshvdDt0vX1dIfJU5CJ3vctdm4uERfuyUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ghD2ggmV0UM5xirj1JsSNdhc8I0q1XBpOb+Ukc4jd2k=;
 b=BeVfryZfJKnVpFmL0fHyGoMWviNz+FIAR35ZBQ1wIeSXGVsQ+9ftszPU90nZzCgpUpaA03ofV2e7WvJEnqdldLe8HZB7c3ae7+VbgBZuBMd4y47OU/V6hmFlWS5lHHij612UMwVx+TrOYn7ZyRJB5azvq7IuYliprGi7gQ6ozJPjqCiPH667eSLfwDjRTzj+unfoRcf3CtG4bOKvG0I0IYq2sPHRIrCI6hizzk3xT9cL5rCauMCQhE0WN/DRp5u8HVOb5yyNkA6Sr0ufrb4yLChVt44wxe3VBr5oX7phJ1rBktGGYZmjpGcj1E4jFRjCLjHWd/WJEB0SejRFnbH4Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghD2ggmV0UM5xirj1JsSNdhc8I0q1XBpOb+Ukc4jd2k=;
 b=LQzH9vYqqxDOO9XmIiJJAX3QFPXUOw/rMnyAYan8o+grnI1Ru2Ud9EclTNj6WBqCav/B1X6FsShU9vR7LeRU0/jDg1qgoyjoLc2fv6INisMn/vT8kC/A/E+n1ZpUPsKMERl/shZcj28zZ8MDDk2yIJBOgch9MPffdOtdXIhXv1Joi6lGejoOqar3byVqUz/1QMEVF9Vp2oACnt8KIPO1X83jW6z/WAe+0iBK2Er8XGpqPqDlE76b3tMuFnNAQ55tkWgmw9d2YvVLb25JOZTCfgtWzwumzDIPVXHuOSnyEM9uFMtp/jN/GFYpEDuH5HXMeF0G/u3LWiOtG2SnltiH/w==
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:642::8)
 by AS8P194MB1141.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:2a1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Tue, 2 Apr
 2024 15:05:49 +0000
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::56f0:1717:f1a8:ea4e]) by AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::56f0:1717:f1a8:ea4e%2]) with mapi id 15.20.7409.042; Tue, 2 Apr 2024
 15:05:49 +0000
From: Luigi Leonardi <luigi.leonardi@outlook.com>
To: sgarzare@redhat.com,
	kvm@vger.kernel.org,
	jasowang@redhat.com,
	virtualization@lists.linux.dev,
	mst@redhat.com,
	kuba@kernel.org,
	xuanzhuo@linux.alibaba.com,
	netdev@vger.kernel.org,
	stefanha@redhat.com,
	pabeni@redhat.com,
	davem@davemloft.net,
	edumazet@google.com
Cc: Luigi Leonardi <luigi.leonardi@outlook.com>
Subject: [PATCH net-next 2/3] vsock/virtio: add SIOCOUTQ support for all virtio based transports
Date: Tue,  2 Apr 2024 17:05:38 +0200
Message-ID:
 <AS2P194MB2170BA1D5A32BDF70C4547B19A3E2@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240402150539.390269-1-luigi.leonardi@outlook.com>
References: <20240402150539.390269-1-luigi.leonardi@outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [mzI2LDS5ddpTTddu49afF3OK5flJWvDi]
X-ClientProxiedBy: MI2P293CA0011.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:45::11) To AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:20b:642::8)
X-Microsoft-Original-Message-ID:
 <20240402150539.390269-3-luigi.leonardi@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2P194MB2170:EE_|AS8P194MB1141:EE_
X-MS-Office365-Filtering-Correlation-Id: d5864048-bc6b-411b-1588-08dc5326614e
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Y7//6KeRhJBXhRwXnu5zhYdYbU8Lo5XvcF2ay7FytHl9lZgYn7DAFq7p4ggb8NKido/RD6ge8An7kIncwjaOaOewx4rNPX2xw5+SW+0/XI1sp49svdKGFAvUBembXyKipywZmIj3/BxMQPRq8Rm+jGtj+s7X2IB0HKZEgpX3gOs0JOEQ89j7nwZc+LvQ/XFAxtrysYUdYq13TtxqPGW4WRjMaZ0ZHgCF0p6ocnJh0WsgrdKgYD4TGMJ/og0Iw7R7ad6Jsy6mncKlt0alNS3recSYhnS/7ZA11b6imF5k/WnjgddaIKi2ZZ8AQz5RpIIw0IgNlBcshKziwX9ghawHH74tIS3gjvAryQwxBD6HApb+vm2ThCfkMQY/fs6GU6Y7+3W68j0eF+bkwoGnlo2+1xWPjouoE0151moD07tEjL/5yeliAyOZgbG9Zt1kWnWbaY42WF+fg7SeESfVic17BfPcQ2H4gkcOtNBfyLs5BMhhZW38QFNg/hA71VNW3iirHmB9LYpQg/BTvpuLM9Deon11bVYVE3W/+SDfAXEKuf10OKt3Rfr84YYWzaKIAtPjMlgbz24xV8pNxWoVzULpAQ2Nt3a65imdsXVZ2a06Mpf3tg8/NYO6vWidvuh4dK8e
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bJDxy10z/CWr7UhcCFFMaQlqku9DcMPb53XtPh0wA59+oMdfumAX/gwUW8gT?=
 =?us-ascii?Q?murnYjQTLJ1q5zKN8p72pA4IRvcclEvgSmjoP0jKzxlAdaur3rahhcRnfDIj?=
 =?us-ascii?Q?x5u8CQeJsxqBKek0aBjRBN3WJenYI8kZ9xD20QsNB5cdJw4fx+Tf7RqSrjCW?=
 =?us-ascii?Q?8sYQJKCCnhogiLom7BkDsmTvKls4CF3ljNH+Xkf8WGlaTU5ZOSzrVnvEOTkF?=
 =?us-ascii?Q?g/A7v9jl2C0M4gxEy1KOdIRKjhv2bOiTWoeM8QAM9cGk+ExiCXYYNqlTeoKN?=
 =?us-ascii?Q?SF40qPfokC8fum6okP4z9q1OCvdhu5TPb+XRHcuSZEAMHPW4jrQrJ+zLAHfx?=
 =?us-ascii?Q?SM2/YRguk6RLealE87yusJmS/m46PuGkoLn7lBrhmbP2Ql9o3gs/yPjVRJR2?=
 =?us-ascii?Q?s1wrEn/f5i39aQ/pnCsgQ+hwotXAt3QhxcrAvdFCwGT7AJUuIlR94CAOLohl?=
 =?us-ascii?Q?FIYxh+uwAqBq+/ViydIG++2/s1wV+CW+itI3bcT5apFDGhcOvb4+uBbVT9bv?=
 =?us-ascii?Q?DHN1SGUiMMZR+Q5FIa4vAtCkkDw2S5WGALDNHwadXXJLO982KWevBvkSzFsx?=
 =?us-ascii?Q?U3YqNZp+BrqDvNKYFbiJOS9BqR49QEo3NSauDnU/tSLbmppPPgrqmtXLvjnt?=
 =?us-ascii?Q?ODq8tCXlLc7POZ8pOrEJeZVOGB4XJPkMPyXVwEodGlfqYrome/rEy1LxdR29?=
 =?us-ascii?Q?xh4ImWnDpk2jKzqVl8JFQkgwO0ruzSMbOsB9mZVuMrRQwn3btf9UEu/UzsAh?=
 =?us-ascii?Q?rMQ/CpPq7acHjBVXSP5CNqwEknDF0woLl+/rl35BP2uz8xezYt6aAkBCJPWM?=
 =?us-ascii?Q?THvmG/5OHPHz9SZnxNpFFLcXjVNP3H/Zwv09+hZgCsDpgHcUW0qTm//gpN3O?=
 =?us-ascii?Q?yZmkMXgttvvP48PXUTANxb2S2BU4O4JelIl1+KIk7uuLzGQi7K/9k+UYKbuc?=
 =?us-ascii?Q?0IZuRuF1vxf6jDmj3HLq+oJ1PsQ3ym5ds4S0ZAqTItIfhev94SqGdg1HzyxE?=
 =?us-ascii?Q?PhkuSduPoWx1JeGqrE5cgCoVBwFRg6T4T1l5Z2P4+OmaEZXPllLUjl0JTOOA?=
 =?us-ascii?Q?W82EgBFAJsMUTRqf8g1DBmVjO+jOJv5mTvzt3By0DgJZFOAAucJxSz1rEHVL?=
 =?us-ascii?Q?gcMGdIujBSSgR98C7YtdyiimcJlRj8vCRpkd2TWfDCp/DVSNaXqRusv4AITv?=
 =?us-ascii?Q?aZ5OqxTUJa0BvIk1v8OQl2P679ZocuCXVwzl1U1QZJyrs5IctGL6srR5MB9X?=
 =?us-ascii?Q?pqMjSndcbRDKzyMqoX0d?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5864048-bc6b-411b-1588-08dc5326614e
X-MS-Exchange-CrossTenant-AuthSource: AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2024 15:05:48.9158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P194MB1141

This patch introduce support for stream_bytes_unsent in all
virtio based transports: virtio-transport, vhost-vsock and
vsock-loopback

For all transports the unsent bytes counter is incremented
in virtio_transport_send_pkt_info.

In the virtio-transport (G2H) the counter is decremented each time the host
notifies the guest that it consumed the skbuffs.
In vhost-vsock (H2G) the counter is decremented after the skbuff is queued
in the virtqueue.
In vsock-loopback the counter is decremented after the skbuff is
dequeued.

Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
---
 drivers/vhost/vsock.c                   |  3 ++-
 include/linux/virtio_vsock.h            |  7 ++++++
 net/vmw_vsock/virtio_transport.c        |  3 ++-
 net/vmw_vsock/virtio_transport_common.c | 30 +++++++++++++++++++++++++
 net/vmw_vsock/vsock_loopback.c          |  6 +++++
 5 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index ec20ecff85c7..9732ab944e5b 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -244,7 +244,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 					restart_tx = true;
 			}
 
-			consume_skb(skb);
+			virtio_transport_consume_skb_sent(skb, true);
 		}
 	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
 	if (added)
@@ -430,6 +430,7 @@ static struct virtio_transport vhost_transport = {
 		.stream_rcvhiwat          = virtio_transport_stream_rcvhiwat,
 		.stream_is_active         = virtio_transport_stream_is_active,
 		.stream_allow             = virtio_transport_stream_allow,
+		.stream_bytes_unsent      = virtio_transport_bytes_unsent,
 
 		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
 		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index c82089dee0c8..cdce8b051f98 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -134,6 +134,8 @@ struct virtio_vsock_sock {
 	u32 peer_fwd_cnt;
 	u32 peer_buf_alloc;
 
+	atomic_t bytes_unsent;
+
 	/* Protected by rx_lock */
 	u32 fwd_cnt;
 	u32 last_fwd_cnt;
@@ -193,6 +195,11 @@ s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
 s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
 u32 virtio_transport_seqpacket_has_data(struct vsock_sock *vsk);
 
+int virtio_transport_bytes_unsent(struct vsock_sock *vsk);
+
+void virtio_transport_consume_skb_sent(struct sk_buff *skb,
+				       bool dealloc);
+
 int virtio_transport_do_socket_init(struct vsock_sock *vsk,
 				 struct vsock_sock *psk);
 int
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 1748268e0694..d3dd0d49c2b3 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -310,7 +310,7 @@ static void virtio_transport_tx_work(struct work_struct *work)
 
 		virtqueue_disable_cb(vq);
 		while ((skb = virtqueue_get_buf(vq, &len)) != NULL) {
-			consume_skb(skb);
+			virtio_transport_consume_skb_sent(skb, true);
 			added = true;
 		}
 	} while (!virtqueue_enable_cb(vq));
@@ -518,6 +518,7 @@ static struct virtio_transport virtio_transport = {
 		.stream_rcvhiwat          = virtio_transport_stream_rcvhiwat,
 		.stream_is_active         = virtio_transport_stream_is_active,
 		.stream_allow             = virtio_transport_stream_allow,
+		.stream_bytes_unsent      = virtio_transport_bytes_unsent,
 
 		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
 		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 16ff976a86e3..3a08e720aa9c 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -419,6 +419,9 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 		 */
 		rest_len -= ret;
 
+		if (info->op == VIRTIO_VSOCK_OP_RW)
+			atomic_add(ret, &vvs->bytes_unsent);
+
 		if (WARN_ONCE(ret != skb_len,
 			      "'send_pkt()' returns %i, but %zu expected\n",
 			      ret, skb_len))
@@ -463,6 +466,24 @@ void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct sk_buff *
 }
 EXPORT_SYMBOL_GPL(virtio_transport_inc_tx_pkt);
 
+void virtio_transport_consume_skb_sent(struct sk_buff *skb, bool dealloc)
+{
+	struct sock *s = skb->sk;
+
+	if (s) {
+		struct vsock_sock *vs = vsock_sk(s);
+		struct virtio_vsock_sock *vvs;
+
+		vvs = vs->trans;
+		if (skb->len)
+			atomic_sub(skb->len, &vvs->bytes_unsent);
+	}
+
+	if (dealloc)
+		consume_skb(skb);
+}
+EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
+
 u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
 {
 	u32 ret;
@@ -891,6 +912,7 @@ int virtio_transport_do_socket_init(struct vsock_sock *vsk,
 		vsk->buffer_size = VIRTIO_VSOCK_MAX_BUF_SIZE;
 
 	vvs->buf_alloc = vsk->buffer_size;
+	atomic_set(&vvs->bytes_unsent, 0);
 
 	spin_lock_init(&vvs->rx_lock);
 	spin_lock_init(&vvs->tx_lock);
@@ -1090,6 +1112,14 @@ void virtio_transport_destruct(struct vsock_sock *vsk)
 }
 EXPORT_SYMBOL_GPL(virtio_transport_destruct);
 
+int virtio_transport_bytes_unsent(struct vsock_sock *vsk)
+{
+	struct virtio_vsock_sock *vvs = vsk->trans;
+
+	return atomic_read(&vvs->bytes_unsent);
+}
+EXPORT_SYMBOL_GPL(virtio_transport_bytes_unsent);
+
 static int virtio_transport_reset(struct vsock_sock *vsk,
 				  struct sk_buff *skb)
 {
diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 6dea6119f5b2..35fd4e47b5bf 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -77,6 +77,7 @@ static struct virtio_transport loopback_transport = {
 		.stream_rcvhiwat          = virtio_transport_stream_rcvhiwat,
 		.stream_is_active         = virtio_transport_stream_is_active,
 		.stream_allow             = virtio_transport_stream_allow,
+		.stream_bytes_unsent      = virtio_transport_bytes_unsent,
 
 		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
 		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
@@ -123,6 +124,11 @@ static void vsock_loopback_work(struct work_struct *work)
 	spin_unlock_bh(&vsock->pkt_queue.lock);
 
 	while ((skb = __skb_dequeue(&pkts))) {
+		/* Decrement the bytes_sent counter without deallocating skb
+		 * It is freed by the receiver.
+		 */
+		virtio_transport_consume_skb_sent(skb, false);
+
 		virtio_transport_deliver_tap_pkt(skb);
 		virtio_transport_recv_pkt(&loopback_transport, skb);
 	}
-- 
2.34.1


