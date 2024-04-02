Return-Path: <kvm+bounces-13376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C9928957BE
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 17:06:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 26E9E1F22A84
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 15:06:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DE5912DD98;
	Tue,  2 Apr 2024 15:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="COlLZPdX"
X-Original-To: kvm@vger.kernel.org
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05olkn2072.outbound.protection.outlook.com [40.92.89.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA7D12BF2E;
	Tue,  2 Apr 2024 15:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.89.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712070354; cv=fail; b=VC6Ba6A1cIOXh8sy3+foHX0q76Ycm/tfGfNSsMeVESZ5hqerDEymZARvw5MQKcJiD1FXnJephz4lX/RR+/34KMX8Q8lXk4guuxmfMPLg5Y66s6fjN60ms+TDH7zX022tTboGp3Cmokz7jUvNBvzoyG1wV0XMftEa/uPt9lHQnuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712070354; c=relaxed/simple;
	bh=0dTJ2U60uWtQ/87g8RRnNf/yot49oSETi/iblkhzSMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TLjYnAxNNMDsm+GxRLYmiar7pun46dJOFXd5suJKdipU3bJq0dCHTT0ylcv6styAkNzzCinD3+XphRvUKfiGfjCmyE4hMD+dXtJEivX1fIVURYfzXEyHoDxUmiqGwCYHsh0NPml6HGTjEUzSARQn2/r1aXpN+S4xWPeyElPlQcQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=COlLZPdX; arc=fail smtp.client-ip=40.92.89.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jINq5xV2t3wItXP/G2LCt/9l+YvGs2LMmVAfmrLIWgdMX0/p028Mcs+9RD8XuLt/HhW4yPRT8OmAi8HT4xxmZyfWCeNecM9V0XWdzrNX/bLNiQuOomJPQIcVW2NapzcvsbU0Ly4HLJJ8gWmz/iOEB6jlnCOJn1kckKS5uAVSjTpRmKCNu3i1ZeC/CuBko1WCgRzJWGYpaMPYIHhlhWbAy8YZQYUdAYq+fhYhLY9V5vaIPYLx0XYDiCRDvLLdJZ9O2SVpOPUzb+bVljJ+1fhtl6Ys+7MfgvVPsHPnGoohxpyBn6RbIvI9qMNCVBBoG+a+hgcIkZwuyQXZsMadHiJdJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hgYWAKGkLoXFj0mLyWjgqkSs0joUrCocUz7O89WkFBw=;
 b=P3PC54qYoOao1AP7hzYyxUh2N+VYNUMBIIWlKMkDaS1fbgAwKlQupm6gXVkklDVbUH/MRW1FVcqBsfn7lMruh20rOOOUKc2gPpSyhzEaathDc18yQLtup9A7RnjZV/ekkT6Gp8Ce/z1aujeikJzZmGVo7UtxUrmsmeHBGqu3wV6CB/2EUVzd03xLIaW780jeKabKN6h968tORXpREiOeivSDcM7jJeaOArrxjfbgOqW+rrTMPQ9OyHXGZkUOaF3iO3WASrdjNah5dFEFox4g1FnBHyrDy8QRTsgcGUwIDq36BhAxbxIbNbocD6uX76vjrv/nwbZPYugVybtFGACNBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hgYWAKGkLoXFj0mLyWjgqkSs0joUrCocUz7O89WkFBw=;
 b=COlLZPdXbEgYkvWGodRQT+66S7dPczZQJO8fyBFc4SkbGCXFNVO5HxKGzkzpemUsUOSf3Gh4glbL1JK/O/h8FmQBA4QYosHRVu9wR6qJRQL7Vh0ymsznbkq+qTCP53KPyB4F4/MzpQWRpPMsj+nlkPX4Zxz+t+ToDcEuHH7cfVe9qqBYzaH8n1p87J+Eb2s/9+T4jpkq4JEXxGmVGl3j5/QNx2koSeNCU0K1v7V8jFCwQdkxzQ984kKKq4OgI4i6pQ8tzP3s8jF+PepIbhEP2PLXGhvdicDL45of5yhMBaki3R8k0tp9BzmSDXMLkAc17p1qpFcOEtFYoHU3i7PJYA==
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:642::8)
 by AS8P194MB1141.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:2a1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Tue, 2 Apr
 2024 15:05:48 +0000
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::56f0:1717:f1a8:ea4e]) by AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::56f0:1717:f1a8:ea4e%2]) with mapi id 15.20.7409.042; Tue, 2 Apr 2024
 15:05:48 +0000
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
Cc: Luigi Leonardi <luigi.leonardi@outlook.com>,
	Daan De Meyer <daan.j.demeyer@gmail.com>
Subject: [PATCH net-next 1/3] vsock: add support for SIOCOUTQ ioctl for all vsock socket types.
Date: Tue,  2 Apr 2024 17:05:37 +0200
Message-ID:
 <AS2P194MB2170C0FC43DDA2CB637CE6B29A3E2@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240402150539.390269-1-luigi.leonardi@outlook.com>
References: <20240402150539.390269-1-luigi.leonardi@outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [YfZMwJEaIJIoytVTjmSTOgzXeMW2d2uB]
X-ClientProxiedBy: MI2P293CA0011.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:45::11) To AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:20b:642::8)
X-Microsoft-Original-Message-ID:
 <20240402150539.390269-2-luigi.leonardi@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2P194MB2170:EE_|AS8P194MB1141:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d7c6727-268a-4640-bee6-08dc532660ad
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	x7dF4LpUHSVHkxfayECyIV5pBqocuLRxH1qrEGdcvsGS/geDfBwKSX+amZV/3ZgBLlTVjOy7mOGI5cBpzUYabmDH5qc4ulyTl+K4BnwFPNzZlACCo52Q6B0p21ZsHWOwS6xWreGMkqH27NV+uRfePvrlMEnB5kZUFOB+lFf4KMdQGYSpczldStOt6KNqzAj3sXfhvWAvGgUA6MT5o4WznzEYYKtGo03TMrMRxjOELvvDQAWYYMVNzgwrC55CmucTE4yQu/ZkYwF/FxZv3Y80Dn08aGqkBuwLbnzQSAX+sdZf9vBIDjloFbqETI71WBKdUbWAO0wTdrZMD/zIDrAdyfhceYkoEUYW/hxfScxTvCyPNZEdf/LiGVbPBsE+cT1zdGUUpfkmw/hK4a3IZKh1Oc38lk0o1jNjgHeYM9Zqv34nQ13BT76HdXLQ9HW2Zk0yHkp6PrLdz6oAQBwNVQW+BNsOATg1LMj0ripDRToafxmM/C5XDXyvJnGAfhHZ0r7KiU17YlhhJk214lc/gIFNBdG3BLJiHwy2OpVQB7q7gKg/q08hnBKLOmMusPhthH/5IpNH92iOvtrynFi88jRS/OoNHzvaY9owLEwItuuD0JpFCP98vZc67XBFyaccJaqx
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?n6LAnzBYhPdWkXGNg6fIO6z+/NcYb9xakFEViqv1Gohj7AophzUuYDm3H+Nl?=
 =?us-ascii?Q?ivPC+zOEAbLvEbBhUPz0Vas1zGiQXGImb9dIwgmts+CtMx8yv30AgYugjXV3?=
 =?us-ascii?Q?5Cf6u5FUO/cvwFDHNRIPZqvxSfMMcNItd21qs133HuNVshefmLPGsvlraiFQ?=
 =?us-ascii?Q?DVwx5etOuMBhX7SooGkeodt0q99gfFKCxmqfppG8GvBFkuAjs0VoGHIijXGS?=
 =?us-ascii?Q?hYrVBcuTFVB5gEIybeaQdKzkCu4EX2Em9qKUe8uHnoJPThH/OZTTTofCyzHE?=
 =?us-ascii?Q?fFMUlyrtFrt7BkYwVNeOeJSg+T7d8dNHsG6HXxSg21e7SUkUe58KzdcQPAXm?=
 =?us-ascii?Q?BEqXHMfr1126/1FlV+I3wyIzUDNgoE+RDXXdMV/YdDbM6UGHKdvcfS4lcZp/?=
 =?us-ascii?Q?sgL8GiWs/TnMp6JOlYQjTAU/1e168KIjQL/5NZCSzEPKtnxuzOyDZ3d1D02J?=
 =?us-ascii?Q?C/4TtIRURRf7bcOsOWoA0sMpzCWqJGYAOqXV2+MA22k0dOqbeNdWVTdJKOhW?=
 =?us-ascii?Q?r8n7cGvW02dJ+m4UhnuI+Wk17sx4PHD+OOTbo5xYu70VYluceOamGhf89oYv?=
 =?us-ascii?Q?PB6TAMdunTHgHmoK26nOg8RgpL9D3M2mFMGxGCMqXRg6bUd9ABnK8J9c77kn?=
 =?us-ascii?Q?slhtUZ26hWnXh82ViHWUIa6l1R4tlVq7a7BIaGZuI1KtIjilRLMmtgd7YxwI?=
 =?us-ascii?Q?uqKQqU52iNGGFFI6kr3KIUQSG416goGTg5kZc5TUzwXn3BbqcAck5vJ30WtI?=
 =?us-ascii?Q?vaSWuuVdZViIqIMLUiIX5g5UX3ydLXH6NNw0UMiAPzIFp4Vzx/gGtq5eANrK?=
 =?us-ascii?Q?7EWPTDPPE2MzgPdy7kVVEoRte8LoB+zeGRbs6pzGVl5zLSSRYLsngCwXDgmy?=
 =?us-ascii?Q?eG0AGp0U9ALLviYk2pY/8MgbNkiP9fhTiBqJHbPk7FFcO2j0W7Oyg44gJR1Q?=
 =?us-ascii?Q?C0OSzIcYVtIK3VjRlw8Pf0Kgak66+DDlHDbRNZHaGNsY4LL6L2MTPYEp+rvP?=
 =?us-ascii?Q?9c0X+Objf/VEepFnKXjPxCNtF0xZPw6AbwM3izlK2Yyz8Ryq31IriZOAqn3U?=
 =?us-ascii?Q?CJl3WfDrZ6O6RfRsCMUkGWz/QgITbuRavnblVMlVY6DTW4pF+WAqNFagaOEt?=
 =?us-ascii?Q?3JZaX8m0p4nmuHjx9Y0uD7147diptzrheLp/mrTFFoa2RJUKkz1atq4odJie?=
 =?us-ascii?Q?3cI6NGn45+SHx5UKfLUAk3vR5W7nr62AkrxbgCW5YcpmV1FHHsysvgOIPyfO?=
 =?us-ascii?Q?AU7oghawN/hsib6kbGgr?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d7c6727-268a-4640-bee6-08dc532660ad
X-MS-Exchange-CrossTenant-AuthSource: AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2024 15:05:48.0011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P194MB1141

This add support for ioctl(s) for SOCK_STREAM SOCK_SEQPACKET and SOCK_DGRAM
in AF_VSOCK.
The only ioctl available is SIOCOUTQ/TIOCOUTQ, which returns the number
of unsent bytes in the socket. This information is transport-specific
and is delegated to them using a callback.

Suggested-by: Daan De Meyer <daan.j.demeyer@gmail.com>
Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
---
 include/net/af_vsock.h   |  1 +
 net/vmw_vsock/af_vsock.c | 42 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 535701efc1e5..cd4311abd3c9 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -137,6 +137,7 @@ struct vsock_transport {
 	u64 (*stream_rcvhiwat)(struct vsock_sock *);
 	bool (*stream_is_active)(struct vsock_sock *);
 	bool (*stream_allow)(u32 cid, u32 port);
+	int (*stream_bytes_unsent)(struct vsock_sock *vsk);
 
 	/* SEQ_PACKET. */
 	ssize_t (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 54ba7316f808..991e9edfa743 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -112,6 +112,7 @@
 #include <net/sock.h>
 #include <net/af_vsock.h>
 #include <uapi/linux/vm_sockets.h>
+#include <uapi/asm-generic/ioctls.h>
 
 static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr);
 static void vsock_sk_destruct(struct sock *sk);
@@ -1292,6 +1293,41 @@ int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 }
 EXPORT_SYMBOL_GPL(vsock_dgram_recvmsg);
 
+static int vsock_do_ioctl(struct socket *sock, unsigned int cmd,
+			  int __user *arg)
+{
+	struct sock *sk = sock->sk;
+	int retval = -EOPNOTSUPP;
+	struct vsock_sock *vsk;
+
+	vsk = vsock_sk(sk);
+
+	switch (cmd) {
+	case SIOCOUTQ:
+		if (vsk->transport->stream_bytes_unsent) {
+			if (sk->sk_state == TCP_LISTEN)
+				return -EINVAL;
+			retval = vsk->transport->stream_bytes_unsent(vsk);
+		}
+		break;
+	default:
+		retval = -EOPNOTSUPP;
+	}
+
+	if (retval >= 0) {
+		put_user(retval, arg);
+		retval = 0;
+	}
+
+	return retval;
+}
+
+static int vsock_ioctl(struct socket *sock, unsigned int cmd,
+		       unsigned long arg)
+{
+	return vsock_do_ioctl(sock, cmd, (int __user *)arg);
+}
+
 static const struct proto_ops vsock_dgram_ops = {
 	.family = PF_VSOCK,
 	.owner = THIS_MODULE,
@@ -1302,7 +1338,7 @@ static const struct proto_ops vsock_dgram_ops = {
 	.accept = sock_no_accept,
 	.getname = vsock_getname,
 	.poll = vsock_poll,
-	.ioctl = sock_no_ioctl,
+	.ioctl = vsock_ioctl,
 	.listen = sock_no_listen,
 	.shutdown = vsock_shutdown,
 	.sendmsg = vsock_dgram_sendmsg,
@@ -2286,7 +2322,7 @@ static const struct proto_ops vsock_stream_ops = {
 	.accept = vsock_accept,
 	.getname = vsock_getname,
 	.poll = vsock_poll,
-	.ioctl = sock_no_ioctl,
+	.ioctl = vsock_ioctl,
 	.listen = vsock_listen,
 	.shutdown = vsock_shutdown,
 	.setsockopt = vsock_connectible_setsockopt,
@@ -2308,7 +2344,7 @@ static const struct proto_ops vsock_seqpacket_ops = {
 	.accept = vsock_accept,
 	.getname = vsock_getname,
 	.poll = vsock_poll,
-	.ioctl = sock_no_ioctl,
+	.ioctl = vsock_ioctl,
 	.listen = vsock_listen,
 	.shutdown = vsock_shutdown,
 	.setsockopt = vsock_connectible_setsockopt,
-- 
2.34.1


