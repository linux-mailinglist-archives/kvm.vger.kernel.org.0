Return-Path: <kvm+bounces-21630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87F2B930F44
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 10:03:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E0FA281447
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 08:03:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 734B9184137;
	Mon, 15 Jul 2024 08:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="Yk9hl5xl"
X-Original-To: kvm@vger.kernel.org
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02olkn2046.outbound.protection.outlook.com [40.92.49.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC606AC0;
	Mon, 15 Jul 2024 08:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.49.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721030570; cv=fail; b=ab7v+JUSrqfujSgZF7xmiCUZkz4c7By7bTHfUkmBGPr7QDeWQnh46TK6QP+fvI/ih3VUhghWwynHqqfe3HwJ3J7h+MkKoR/ZD09f18FfcgLuQ30ZHJJLs8D2LiRwiqxV7GGqxmrY8Kk+AE6dQn6Xy/9UtrbCdY6M9JllojEXUVM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721030570; c=relaxed/simple;
	bh=J3PBDc5RwuxxUOttlXHmcXwLNZanY9eZYMOn+/Yik7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YtOhuzbom4zO8OHJ6ISe3dqprDHQ+Q8VV7iGLDs8p7e5mFds+BgMr4r8nh2beAnhi+LIgEuJ5wSgA9gHbNmj9wssRsbPnOXGPpBKu+aU8JydtV/lKKHJkVYoRmSNf7nIhDOX7/QUGiy89BwDLLHuJdKTSyS8XvTswbgZt9/p/OU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=Yk9hl5xl; arc=fail smtp.client-ip=40.92.49.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zza4dK2/0MVa5QusAJxo0vtZ22BKJT+g73J8CE+zmUCj2vzkoJ/HEkiBcIxrgzWoPs/I1aFxRjbSOsRaHbU7ZQNR2ManZmsdX1L1evu79jchudbKMvAvAlRPO9zwp6XRn/2pj5ehw6FmBapDYKFOKekNSUxwurpwDOEOOyto0680RM8pMBPbsqnSoVln3430SRdXrjp7mcwb3oNZJK7xSnVvmWW0DIpLzFUV+/keCoox+cT2RkLNGugS9gxCdLoMiWllgy6SqfhvH14LIApaWtkHKDN78xr/Sxdn0ZbZwddRk0dxeZw9I5m1qlwwjykGU5MaWgBe2bULsfY2VqRpzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p0sZ2goXw6nqr37fPuyomHBpj8VTnQbBl5tllQY/uy4=;
 b=m3ZKcsaWiE6ZFQfEtPp7Fy+DSo3eoFYmHKRr/M5Zxg7DROaAiuezClCbcDrBKiWPBzcFZUoKai8YRF/v+5ZGXPCmTLFeBMtix2jtu3pgaG1cSTCcVUNp/eHSSg1vDdmrUV7G/Ge9eocUGttD2dwotXW8lO757JnEn2z5q0K1g0zFh+ZAPZU4fy655H0TVxE5N8Ri/xu+37SYNEkqSG3sjtIdfZcocuYjUin5AkhPaDpq9DnF9mh3uakVdJwtwO+kpx2gvs/8v541y06lOF6gXNnb5V4ToDA9MjYLGk7J3LkSgiumuyf/5yB4lt/tacLKLDNKj6EB1YMeRiwAjBjA0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0sZ2goXw6nqr37fPuyomHBpj8VTnQbBl5tllQY/uy4=;
 b=Yk9hl5xlqGcTKddgIjEAUQgPpJEkWTjce/3ko/Ab5485XO6TLNf7iMu/06/xZ1tqu2vg+Xq9+IBFaanVWwBHHHlmpZb4LXgPdIJKwSWqji7QUkDaWZ36gRarY4ce27Ch5zYJm/bB4ZSVpjlSj6vwJRoJilRWcjQPrAva9lPkF7qpC7ez13nwVGCEdehXdEPwiZlww6OwccteVvdi4E0CirOPQBlm7SSgqWcXOINkzVRtlX+BsrFac+jbhHcfUK3iDeW75ybSG+8hlFq1Km+WhBUMBpvMy8xThMXL5MdEZVQqEmeHMlWEGtvrM+nZuZbi6LB9JsHT9SFgIPCIXpX6vg==
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:642::8)
 by AS8P194MB1015.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:2af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Mon, 15 Jul
 2024 08:02:44 +0000
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::3d63:e123:2c2f:c930]) by AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::3d63:e123:2c2f:c930%4]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 08:02:44 +0000
From: Luigi Leonardi <luigi.leonardi@outlook.com>
To: ameryhung@gmail.com
Cc: amery.hung@bytedance.com,
	bobby.eshleman@bytedance.com,
	bpf@vger.kernel.org,
	bryantan@vmware.com,
	dan.carpenter@linaro.org,
	davem@davemloft.net,
	decui@microsoft.com,
	edumazet@google.com,
	haiyangz@microsoft.com,
	jasowang@redhat.com,
	jiang.wang@bytedance.com,
	kuba@kernel.org,
	kvm@vger.kernel.org,
	kys@microsoft.com,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	netdev@vger.kernel.org,
	oxffffaa@gmail.com,
	pabeni@redhat.com,
	pv-drivers@vmware.com,
	sgarzare@redhat.com,
	simon.horman@corigine.com,
	stefanha@redhat.com,
	vdasa@vmware.com,
	virtualization@lists.linux-foundation.org,
	wei.liu@kernel.org,
	xiyou.wangcong@gmail.com,
	xuanzhuo@linux.alibaba.com,
	Luigi Leonardi <luigi.leonardi@outlook.com>
Subject: Re: [RFC PATCH net-next v6 01/14] af_vsock: generalize vsock_dgram_recvmsg() to all transports
Date: Mon, 15 Jul 2024 10:02:14 +0200
Message-ID:
 <AS2P194MB2170B9984C55A5F460F9E03E9AA12@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240710212555.1617795-2-amery.hung@bytedance.com>
References: <20240710212555.1617795-2-amery.hung@bytedance.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [y3jSCIGf9TNsy/FmRxEvzXrqEH5Cp7qR]
X-ClientProxiedBy: MI1P293CA0002.ITAP293.PROD.OUTLOOK.COM (2603:10a6:290:2::9)
 To AS2P194MB2170.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:642::8)
X-Microsoft-Original-Message-ID:
 <20240715080214.4332-1-luigi.leonardi@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2P194MB2170:EE_|AS8P194MB1015:EE_
X-MS-Office365-Filtering-Correlation-Id: 2919203d-f5bb-48ed-328c-08dca4a481fe
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|8060799006|19110799003|461199028|440099028|3412199025|1710799026;
X-Microsoft-Antispam-Message-Info:
	CW24+3VKJeU1CMDsjUxTw1xdRLX4MK0oM9qQk98ugSsciBCqHBd3QTuDwgJ0auUl8ZuapyIAX4dipTO9rcwMAiHJLZR9zxFdB7EmoeaMCJy9+IRNJPscj52zRGtmn+f4NZ/LO/cgFuoMaxhWApJ61ZdTmAKrfVNJjhemVcptP5DMUZxW+974eVltRdtDaC8YKcY4klv5dHJmnj6ISojMqh8mbjtS+gAnRLf7KbNn+hk5xcDIHNGMLf7xKKdcX7JUYD1M1RO57XlVaVe7eIB4kYD6ogv5N6+jjcuBOjwiMM9g5ewXm22nqL2OEYjBNNQgbLswIwroFReow/zqyvfWeOCaBd0xHCDUqnqy1+AKj9JAaX02x8SyPTxmUoaC30BxNONlj3477jv2R9xNmh7qlZH6W7ajBsSy/Kq6TOVR7V8PJuh1nGHYtzdS6bx7DqP0Sf4kdA6qmcy+MacJID2mPBB3SxD1k1/R/Ee0w3knGvp00U0ksSq1/bPTwV8lOiqtm9wE7kvsKp1GCXugMn1KFhb8Z9jKLYlIg0OJ1/9wkPurtzCsi0y4SLbVu3f/b6FID7d5F4vxKLDBv6JbL7Q3c+GG7RCOAl6b7YZf/qpbIa7AoVY1OnwLt4BGOy91eT0BZ6TBkQHo6RGr/GXcPHtjIpHBijsRfX5MF3IMAT8fQE9I9r0kJaziO+TSpzbNL6Vu
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5BDorPSC8hNPE14mOWjjp0+KNaqc5ZK5n9k8j61mQ0HN2ve5w29HESxsyWxV?=
 =?us-ascii?Q?xbQUs7JwxJ0EDL3I2y/rD1MA18tITwFqrOepeuE3T9bKK8xK34HkGvShoDPP?=
 =?us-ascii?Q?pxHLSH/YL8h3Ww+pjKv6Zn+GnBwBH0uEEOKAVIwPhy1De4aP5krSmdO1jU2U?=
 =?us-ascii?Q?zRTfAbvqdNNWCSTgYbj2xQYl8q6DWiLRGFF7kOunqDWvIJywrQbqUq8ahVja?=
 =?us-ascii?Q?DD3NJ3pltSoUPgPQCSk2UIOlvwP/m+PUIue/8UHZQQj7eIQTOF4foTQpKWZI?=
 =?us-ascii?Q?jcXkOXPKjTS0cz+pOLnGpkGDW7iEPwx1C3aRUPFcZDqv2BJ3mLeLx4T+aswC?=
 =?us-ascii?Q?70XR3uoFC2NWmyhthb47XtGSXsBA4oXs7sMNmkYI1qRKB+hE83eCxsEEw+Kf?=
 =?us-ascii?Q?lr8b/spqOZl4lLP5VISe8hrFK7aYL6aY64Hph8QHzDtR7TAIk/5aCrHHg3nE?=
 =?us-ascii?Q?tiJ4C+OluDMApAhoXQmEUNO9Q0OLjbz2QNhCWEswDAidlbExemTY0pPnvtX9?=
 =?us-ascii?Q?cloMEsiJkTpFYm8bQA3D7efPrCO1oCod08rxf8x274DBVSHPr1bkVncDl5bs?=
 =?us-ascii?Q?RF0fOQVLkyHe3srl1fmwdZPC4uYWd/4gUaa7bTboJWlnW9h689YdIjX8Rqth?=
 =?us-ascii?Q?QQUfoWKWHh0KJmCyZRVXYEOYRGe4oS0rRnDppDPAL59607cmopBuJc/weqWF?=
 =?us-ascii?Q?Ff8hO0j5IUqyYrdAzU+wAOGjsroGIs26ebPvBJy5OWV14fvWQa4hc31M78Hy?=
 =?us-ascii?Q?okV3xhfZeFDyq+YblilsnpzaAqUltEY/m2JavIsdSV+DtOkOxVETYyuKptrM?=
 =?us-ascii?Q?O15dcf6cEeBMq/BeHylJSFE69nUr9HrJRkJIxYzOOBu99eq5Eq79cTzaJVjV?=
 =?us-ascii?Q?5aPMl9yNCbgawPbGUlCIjDBGj6bv2pruN/HMHOVRnuYVlADmjHbmBpgqZE8L?=
 =?us-ascii?Q?ByyPL6zJGTTSF7KzGstqTeTAzWWuw2iXz2ybE8i6PgYIj1gYOmaDOu9S5Jy0?=
 =?us-ascii?Q?YAQ7rkne86uAMypwg4Ng5hKOFkVB9s8STD/2tqPgteEz2dut9wUNm7AzS69v?=
 =?us-ascii?Q?x3pWwdcOOLAQbbD/j+Q//UQpES3DfnzV6fLqZ8REsl6abPJbLqlmvlmZ2pu+?=
 =?us-ascii?Q?cfWAd+XKvvPnWMv4wVZuWGZNRcX85Wk8bLUf0Al9KA1ZoFGi0euXI1bCx/+C?=
 =?us-ascii?Q?9Lusgp+PVS43q3Ric5WE7WEFMIrvaTYY9as08iRgE4wfwSh+ejcab/u6na4H?=
 =?us-ascii?Q?zM+uGJHPOyMTel+ZjHGV?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2919203d-f5bb-48ed-328c-08dca4a481fe
X-MS-Exchange-CrossTenant-AuthSource: AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2024 08:02:44.7369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P194MB1015

Hi Amery, Bobby

> From: Bobby Eshleman <bobby.eshleman@bytedance.com>
>
> This commit drops the transport->dgram_dequeue callback and makes
> vsock_dgram_recvmsg() generic to all transports.
>
> To make this possible, two transport-level changes are introduced:
> - transport in the receiving path now stores the cid and port into
>   the control buffer of an skb when populating an skb. The information
>   later is used to initialize sockaddr_vm structure in recvmsg()
>   without referencing vsk->transport.
> - transport implementations set the skb->data pointer to the beginning
>   of the payload prior to adding the skb to the socket's receive queue.
>   That is, they must use skb_pull() before enqueuing. This is an
>   agreement between the transport and the socket layer that skb->data
>   always points to the beginning of the payload (and not, for example,
>   the packet header).
>
Like in the other patch, please use imperative in the commit message.
>
> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> Signed-off-by: Amery Hung <amery.hung@bytedance.com>
> ---
>  drivers/vhost/vsock.c                   |  1 -
>  include/linux/virtio_vsock.h            |  5 ---
>  include/net/af_vsock.h                  | 11 ++++-
>  net/vmw_vsock/af_vsock.c                | 42 +++++++++++++++++-
>  net/vmw_vsock/hyperv_transport.c        |  7 ---
>  net/vmw_vsock/virtio_transport.c        |  1 -
>  net/vmw_vsock/virtio_transport_common.c |  9 ----
>  net/vmw_vsock/vmci_transport.c          | 59 +++----------------------
>  net/vmw_vsock/vsock_loopback.c          |  1 -
>  9 files changed, 55 insertions(+), 81 deletions(-)
>
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index ec20ecff85c7..97fffa914e66 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -419,7 +419,6 @@ static struct virtio_transport vhost_transport = {
>  		.cancel_pkt               = vhost_transport_cancel_pkt,
>
>  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
> -		.dgram_dequeue            = virtio_transport_dgram_dequeue,
>  		.dgram_bind               = virtio_transport_dgram_bind,
>  		.dgram_allow              = virtio_transport_dgram_allow,
>
> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> index c82089dee0c8..8b56b8a19ddd 100644
> --- a/include/linux/virtio_vsock.h
> +++ b/include/linux/virtio_vsock.h
> @@ -177,11 +177,6 @@ virtio_transport_stream_dequeue(struct vsock_sock *vsk,
>  				size_t len,
>  				int type);
>  int
> -virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> -			       struct msghdr *msg,
> -			       size_t len, int flags);
> -
> -int
>  virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
>  				   struct msghdr *msg,
>  				   size_t len);
> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> index 535701efc1e5..7aa1f5f2b1a5 100644
> --- a/include/net/af_vsock.h
> +++ b/include/net/af_vsock.h
> @@ -120,8 +120,6 @@ struct vsock_transport {
>
>  	/* DGRAM. */
>  	int (*dgram_bind)(struct vsock_sock *, struct sockaddr_vm *);
> -	int (*dgram_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
> -			     size_t len, int flags);
>  	int (*dgram_enqueue)(struct vsock_sock *, struct sockaddr_vm *,
>  			     struct msghdr *, size_t len);
>  	bool (*dgram_allow)(u32 cid, u32 port);
> @@ -219,6 +217,15 @@ void vsock_for_each_connected_socket(struct vsock_transport *transport,
>  int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk);
>  bool vsock_find_cid(unsigned int cid);
>
> +struct vsock_skb_cb {
> +	unsigned int src_cid;
> +	unsigned int src_port;
> +};
> +
> +static inline struct vsock_skb_cb *vsock_skb_cb(struct sk_buff *skb) {
> +	return (struct vsock_skb_cb *)skb->cb;
> +};
> +
>

Running scripts/checkpatch.pl --strict --codespell on the patch shows this error:

 ERROR: open brace '{' following function definitions go on the next line
 #183: FILE: include/net/af_vsock.h:225:
 +static inline struct vsock_skb_cb *vsock_skb_cb(struct sk_buff *skb) {

 total: 1 errors, 0 warnings, 0 checks, 235 lines checked
>
>  /**** TAP ****/
>
>  struct vsock_tap {
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index 4b040285aa78..5e7d4d99ea2c 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -1273,11 +1273,15 @@ static int vsock_dgram_connect(struct socket *sock,
>  int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
>  			size_t len, int flags)
>  {
> +	struct vsock_skb_cb *vsock_cb;
>  #ifdef CONFIG_BPF_SYSCALL
>  	const struct proto *prot;
>  #endif
>  	struct vsock_sock *vsk;
> +	struct sk_buff *skb;
> +	size_t payload_len;
>  	struct sock *sk;
> +	int err;
>
>  	sk = sock->sk;
>  	vsk = vsock_sk(sk);
> @@ -1288,7 +1292,43 @@ int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
>  		return prot->recvmsg(sk, msg, len, flags, NULL);
>  #endif
>
> -	return vsk->transport->dgram_dequeue(vsk, msg, len, flags);
> +	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
> +		return -EOPNOTSUPP;
> +
> +	if (unlikely(flags & MSG_ERRQUEUE))
> +		return sock_recv_errqueue(sk, msg, len, SOL_VSOCK, 0);
>
This if statement is always false!
>
> +
> +	/* Retrieve the head sk_buff from the socket's receive queue. */
> +	err = 0;
> +	skb = skb_recv_datagram(sk_vsock(vsk), flags, &err);
> +	if (!skb)
> +		return err;
> +
> +	payload_len = skb->len;
> +
nit: I'd remove this blank line.
> +	if (payload_len > len) {
> +		payload_len = len;
> +		msg->msg_flags |= MSG_TRUNC;
> +	}
> +
> +	/* Place the datagram payload in the user's iovec. */
> +	err = skb_copy_datagram_msg(skb, 0, msg, payload_len);
> +	if (err)
> +		goto out;
> +
> +	if (msg->msg_name) {
> +		/* Provide the address of the sender. */
> +		DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_name);
> +
> +		vsock_cb = vsock_skb_cb(skb);
> +		vsock_addr_init(vm_addr, vsock_cb->src_cid, vsock_cb->src_port);
> +		msg->msg_namelen = sizeof(*vm_addr);
> +	}
> +	err = payload_len;
> +
> +out:
> +	skb_free_datagram(&vsk->sk, skb);
> +	return err;
>  }
>  EXPORT_SYMBOL_GPL(vsock_dgram_recvmsg);
>
> diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
> index e2157e387217..326dd41ee2d5 100644
> --- a/net/vmw_vsock/hyperv_transport.c
> +++ b/net/vmw_vsock/hyperv_transport.c
> @@ -556,12 +556,6 @@ static int hvs_dgram_bind(struct vsock_sock *vsk, struct sockaddr_vm *addr)
>  	return -EOPNOTSUPP;
>  }
>
> -static int hvs_dgram_dequeue(struct vsock_sock *vsk, struct msghdr *msg,
> -			     size_t len, int flags)
> -{
> -	return -EOPNOTSUPP;
> -}
> -
>  static int hvs_dgram_enqueue(struct vsock_sock *vsk,
>  			     struct sockaddr_vm *remote, struct msghdr *msg,
>  			     size_t dgram_len)
> @@ -833,7 +827,6 @@ static struct vsock_transport hvs_transport = {
>  	.shutdown                 = hvs_shutdown,
>
>  	.dgram_bind               = hvs_dgram_bind,
> -	.dgram_dequeue            = hvs_dgram_dequeue,
>  	.dgram_enqueue            = hvs_dgram_enqueue,
>  	.dgram_allow              = hvs_dgram_allow,
>
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index 43d405298857..a8c97e95622a 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -508,7 +508,6 @@ static struct virtio_transport virtio_transport = {
>  		.cancel_pkt               = virtio_transport_cancel_pkt,
>
>  		.dgram_bind               = virtio_transport_dgram_bind,
> -		.dgram_dequeue            = virtio_transport_dgram_dequeue,
>  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
>  		.dgram_allow              = virtio_transport_dgram_allow,
>
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 16ff976a86e3..4bf73d20c12a 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -810,15 +810,6 @@ virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
>  }
>  EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_enqueue);
>
> -int
> -virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> -			       struct msghdr *msg,
> -			       size_t len, int flags)
> -{
> -	return -EOPNOTSUPP;
> -}
> -EXPORT_SYMBOL_GPL(virtio_transport_dgram_dequeue);
> -
>  s64 virtio_transport_stream_has_data(struct vsock_sock *vsk)
>  {
>  	struct virtio_vsock_sock *vvs = vsk->trans;
> diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
> index b370070194fa..b39df3ed8c8d 100644
> --- a/net/vmw_vsock/vmci_transport.c
> +++ b/net/vmw_vsock/vmci_transport.c
> @@ -610,6 +610,7 @@ vmci_transport_datagram_create_hnd(u32 resource_id,
>
>  static int vmci_transport_recv_dgram_cb(void *data, struct vmci_datagram *dg)
>  {
> +	struct vsock_skb_cb *vsock_cb;
>  	struct sock *sk;
>  	size_t size;
>  	struct sk_buff *skb;
> @@ -637,10 +638,14 @@ static int vmci_transport_recv_dgram_cb(void *data, struct vmci_datagram *dg)
>  	if (!skb)
>  		return VMCI_ERROR_NO_MEM;
>
> +	vsock_cb = vsock_skb_cb(skb);
> +	vsock_cb->src_cid = dg->src.context;
> +	vsock_cb->src_port = dg->src.resource;
>  	/* sk_receive_skb() will do a sock_put(), so hold here. */
>  	sock_hold(sk);
>  	skb_put(skb, size);
>  	memcpy(skb->data, dg, size);
> +	skb_pull(skb, VMCI_DG_HEADERSIZE);
>  	sk_receive_skb(sk, skb, 0);
>
>  	return VMCI_SUCCESS;
> @@ -1731,59 +1736,6 @@ static int vmci_transport_dgram_enqueue(
>  	return err - sizeof(*dg);
>  }
>
> -static int vmci_transport_dgram_dequeue(struct vsock_sock *vsk,
> -					struct msghdr *msg, size_t len,
> -					int flags)
> -{
> -	int err;
> -	struct vmci_datagram *dg;
> -	size_t payload_len;
> -	struct sk_buff *skb;
> -
> -	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
> -		return -EOPNOTSUPP;
> -
> -	/* Retrieve the head sk_buff from the socket's receive queue. */
> -	err = 0;
> -	skb = skb_recv_datagram(&vsk->sk, flags, &err);
> -	if (!skb)
> -		return err;
> -
> -	dg = (struct vmci_datagram *)skb->data;
> -	if (!dg)
> -		/* err is 0, meaning we read zero bytes. */
> -		goto out;
> -
> -	payload_len = dg->payload_size;
> -	/* Ensure the sk_buff matches the payload size claimed in the packet. */
> -	if (payload_len != skb->len - sizeof(*dg)) {
> -		err = -EINVAL;
> -		goto out;
> -	}
> -
> -	if (payload_len > len) {
> -		payload_len = len;
> -		msg->msg_flags |= MSG_TRUNC;
> -	}
> -
> -	/* Place the datagram payload in the user's iovec. */
> -	err = skb_copy_datagram_msg(skb, sizeof(*dg), msg, payload_len);
> -	if (err)
> -		goto out;
> -
> -	if (msg->msg_name) {
> -		/* Provide the address of the sender. */
> -		DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_name);
> -		vsock_addr_init(vm_addr, dg->src.context, dg->src.resource);
> -		msg->msg_namelen = sizeof(*vm_addr);
> -	}
> -	err = payload_len;
> -
> -out:
> -	skb_free_datagram(&vsk->sk, skb);
> -	return err;
> -}
> -
>  static bool vmci_transport_dgram_allow(u32 cid, u32 port)
>  {
>  	if (cid == VMADDR_CID_HYPERVISOR) {
> @@ -2040,7 +1992,6 @@ static struct vsock_transport vmci_transport = {
>  	.release = vmci_transport_release,
>  	.connect = vmci_transport_connect,
>  	.dgram_bind = vmci_transport_dgram_bind,
> -	.dgram_dequeue = vmci_transport_dgram_dequeue,
>  	.dgram_enqueue = vmci_transport_dgram_enqueue,
>  	.dgram_allow = vmci_transport_dgram_allow,
>  	.stream_dequeue = vmci_transport_stream_dequeue,
> diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
> index 6dea6119f5b2..11488887a5cc 100644
> --- a/net/vmw_vsock/vsock_loopback.c
> +++ b/net/vmw_vsock/vsock_loopback.c
> @@ -66,7 +66,6 @@ static struct virtio_transport loopback_transport = {
>  		.cancel_pkt               = vsock_loopback_cancel_pkt,
>
>  		.dgram_bind               = virtio_transport_dgram_bind,
> -		.dgram_dequeue            = virtio_transport_dgram_dequeue,
>  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
>  		.dgram_allow              = virtio_transport_dgram_allow,
>
> --
> 2.20.1
>
>

Small changes :)
Rest LGTM!

Thanks,
Luigi

