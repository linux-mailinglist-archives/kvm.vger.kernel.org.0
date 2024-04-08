Return-Path: <kvm+bounces-13889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9429389C521
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 15:53:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D28DFB21DC2
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 13:43:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B919130AF0;
	Mon,  8 Apr 2024 13:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="N7/YJds1"
X-Original-To: kvm@vger.kernel.org
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04olkn2084.outbound.protection.outlook.com [40.92.74.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6451112D76E;
	Mon,  8 Apr 2024 13:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.74.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583485; cv=fail; b=MlZdr/z1tT+xbOQcM9Pc2qUdv9vHIuOOSovl/35+ej+e1rhjz1HoeZdDoR1yTMKeCmqVLyiB3GuZjS3bukVS+RW/UxS0u9o2jaDUgxUMjBZK7YxPmjjniPUWaIvMpTbeKqaa1oQAwiFwjsbLNuyhusfGFmuh+mgASU6eHiFwMMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583485; c=relaxed/simple;
	bh=nd/KKLr3uEmUGgW3sCQOZFMpuDUs9Fvh8muPWGAXlDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oqEmb5juwUip/uczippOt/08lPuZEf1ONHV49H0eZWEXZt8YJzKKZtwc6+826Kd2n1z4jTw2xGhaBG06vFL2i56nM3aZmNU8bG1qBr9ux2pleNA5gsTrVkZ7fxGdB+8vfZAxiwFoSpRlCrd4Pa2ILT4yseDC0gsgbn9lOfEVDCQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=N7/YJds1; arc=fail smtp.client-ip=40.92.74.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l6c0aOpyww/Uoy6T1la0pBWe+SqGBZtizxzCKbGROvRAy/geBTGXlcYok/9AQYsMR8xDkWe4VksEwWYc3gsFaVyF0EiEADesOH2S3Ct7Xr1YNuq0W/avfh1J+K3tSgzOdm3PuBBDYf1RFLFmH0rrDATN8BtoCf3WnUs19X3VzGQoUnwdkhZ7ZM1bhPo0DmyCON+h7ZQglIQtJFCQLQaSuLQc2cQp+pxn8+tB2xX58FtLmm73emVq4uc+L/y/bmukHGmPhBKPAsyhdxgnFc5I6SfaJ4dKWT/5EVjDPCK3NdLX2dgFtMOdbEl8wJKcgxkIUhvBKg4FtBif6TrpEVv7TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/famEPvZr0J8tPUcehUv/adCdeNO8EXShja9tY7JAJs=;
 b=AokQgBS4gPKBzDVkTCdZgB7MR6VVg4Qi1ZzevZl6QGOrj00oSdwwUduTERgxN8aHhdE6KJBwrLCQWdJVkNOF4oWKuO2k4+ELiTCjxtDPbAAcCScPcdsVF5RYRr4rhA99OUZ6nRwESunCUzAyBICDTf68i1hpEXRQzeqioXVjmoNlJgZL0FJ63Sjp8YPuAYwGzWK5/liwt4YMpGXBAwqIL7xtplMMUgq3HhOdpBQll4lvAIRXBC/cSmQvCO2yorzJCq+DHCNf8Cvdxjv0W1AsQFQHsrTqEgtdzi19SjYztQHjRDJv8xRLiAacIiV9JGKD/JZdLmlu/LhLo5/z8zfPPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/famEPvZr0J8tPUcehUv/adCdeNO8EXShja9tY7JAJs=;
 b=N7/YJds1ZQev8RUXJz3s86di9Cpi8rfwfI8PFCtC8XotUpUeQMrva+OJqTLeIt0GrcZQosSqKDs3gzAEGQGNARKoeY3hZF+WaxUlNT9dCOapAlIzI1TdTXp2AymUR8LVHM75Id1ew6uttFEEnZcFSh7x8tL276kUq+fCfqBXqkeqGHZGuS9EPY/UjXVs8/zZQjFGaYHfk7fmgQiBp1bJp8uqsas/vQpLCdi3lbF0bxaIGOYA/oo7jY1hmsDLAFYyREKkJIUZiA66uthHfnZbI7HKc+BtIX8zTLVpLE4Kw6tL7AFIVHnFOTVK8gdjvo211AYpywM36rtuflR1mYKFPg==
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:642::8)
 by AM8P194MB1662.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:321::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.47; Mon, 8 Apr
 2024 13:37:58 +0000
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::56f0:1717:f1a8:ea4e]) by AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::56f0:1717:f1a8:ea4e%2]) with mapi id 15.20.7409.042; Mon, 8 Apr 2024
 13:37:58 +0000
From: Luigi Leonardi <luigi.leonardi@outlook.com>
To: mst@redhat.com,
	xuanzhuo@linux.alibaba.com,
	virtualization@lists.linux.dev,
	sgarzare@redhat.com,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	stefanha@redhat.com,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	kvm@vger.kernel.org,
	jasowang@redhat.com
Cc: Luigi Leonardi <luigi.leonardi@outlook.com>
Subject: [PATCH net-next v2 2/3] vsock/virtio: add SIOCOUTQ support for all virtio based transports
Date: Mon,  8 Apr 2024 15:37:48 +0200
Message-ID:
 <AS2P194MB2170FDCADD288267B874B6AC9A002@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240408133749.510520-1-luigi.leonardi@outlook.com>
References: <20240408133749.510520-1-luigi.leonardi@outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [3QOD7PN58Cqrrege9F7rHYGM+xKZ387G]
X-ClientProxiedBy: MI0P293CA0013.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:44::18) To AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:20b:642::8)
X-Microsoft-Original-Message-ID:
 <20240408133749.510520-3-luigi.leonardi@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2P194MB2170:EE_|AM8P194MB1662:EE_
X-MS-Office365-Filtering-Correlation-Id: 21362109-d51b-467e-354a-08dc57d11a2a
X-MS-Exchange-SLBlob-MailProps:
	znQPCv1HvwW17eFZrekaPBZuDTSQRy8lFytrk4eN0aM1NtOQTBoPQWHBK7AluJIVBVnOr8rIn6OuTNB1OAyTiO0v9pJLa3n/QH5M/jiUuaT909n5QpsHgBYGeCBqnYOUs87d7hhqRLyHVf1TvIAJhI6qWw3OUP5DWvoa7B8lHNK83InGSWm+H+l6p2xEtxhzYIWp10kBYoO+w6QgXSUhO3e4b8WmRun4xDbPX9PAM+Ojea6LaMnkGE3BQ+fJcc6uLLyFhzkcSWZY1bx6uWlTZ9SHhsVZUGsNLU48K9zNdvN8XaAZgJXhofqOwAsANPrJ1eaZaaPWcRw1pEOmri74zoAgYFXFlP1aLkyctw3xkvXWriZyjW2CWsXnSKl7HCk0/jEaOOQj5YA+a8L15uCfL6e/Ed2Wt7vCE37wwfdgalXGEP1MPqKBgxbhyHee5wVbK2rWxQ2veLBldMTKidcWS37N+cvWFkqvyTl9dGKahm0n/jDjVF4MDdU0hpfXTzaN4Tfk2ZJv1f0aEbeHfVh5Wv9hCQVyOB6zAKn0O7xlqfHQ6pS4GasJBwtBBD2F3i4+G+N1xSBdGWKDS6iHwJaBvEpdk0MGOKf0jp07T66z3LXgnQGz0+QpuOse6G0RbrPLkxLlxKQneBUzf27Pu8AymK45MaTdPKqVRqS1SEqR1DG7z/EZLBfZuIJKyZK7pqn99D58F7a6NYJvYA6x0750nzfTeA/oKJx4tIJmnuRx6N98PCtc82it/6Xj79UpsmWlYkGCBUZBjuM=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RpU0JugmF2zMr6aBP2U67aCY590OZlkX3gKP6EreC0zjba1haZQP0TRPmdXQhbofGiLtbStoSaelrmxq6Bsen8YKa39NUY1+pGh1jVSvHvfcph93y/c1hguVMsTxID9UeXtROvcxEqB3A5Re+O8okW2Zj/6QC1r+0owUAEAzlaXhJC9Uk2GUUD37cQivFFsRwqTmcZaV/HcC4i5ml7s3Wveie8xh5Apf2GJVXzeyNTej6Bww7tSxM8oiLLayYKrtZMvmti7Z1vt7la6h0wPXlG5d56Rij/4QISVGSam8S1krFH20fApT2teIF38xzL/bNMqoc+DsD1ByfEk1LnXjEVALNNbKgCdYBmpeRL+KJyXFfOPMbg44g/g8RjHrKpLjD0HLZSiKFW2jrxtfBVg+flwQmqoGRTFhaXDWr4lbxdxTFwn4ktNDv09/CHY4s2hkBx5dQT/vcnoEC3XHZAysneoWsm14n6QN0bv+HH2a1sbyMiMcKvFbhp04dFvqIyWXJ2UzWCuq/S3crttf+ld5e8EY0gBmIOS+OmQNKRueUf7QL6GEFN1gizxnLKAdFXBFgl0SVAnvFLp4Xw27VIPkj1Of/M/maJ/yni3qon3wrgAAcUnkiRSmSzqQ15PtZHls
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MKjDN/S5ALYys5tpRBSJIhO9VFzoKTk1cU7MbduRmQWvVa3G5gHLay+sKVXe?=
 =?us-ascii?Q?nS3+h5MzlKdhE8w/fNUke+NYk6XSHZ0LfOe2ISuC0wL7tIjQRMddWR43fqAI?=
 =?us-ascii?Q?P1pVKsw5LCHOY4qiBHQYQhtXv3GLfLRQ1Zj2OHj8511Sv84FvTxjFMsD1qhp?=
 =?us-ascii?Q?i1P6C19bnY+IVCVKTje+OYR72l/S3KJDtn0iBYx0PLagi4omAOGsI/s0wqKt?=
 =?us-ascii?Q?pvG9j+scfHP7v1/PcviTqJ14Cf0ujrjqsCIngBUctbyP+Oedx9O03mJNmRP1?=
 =?us-ascii?Q?Eubwt69KDLtUfJJnoNpzbRFjlboHT/lAqShjaUJvCxpcTFj5yqk/5RPwUpJm?=
 =?us-ascii?Q?eXqRj/LncgDoNXqt1pPvY05+oayNEGcEvM6zS3k+tBZLyHBaNRpyLmtbYXF6?=
 =?us-ascii?Q?1RG12dih0SoVUzD7jQx7uQXJEdhzpnK6L8A1E8Hw9gkvDsjg6fEVgFy+hJfr?=
 =?us-ascii?Q?GKduzvKqibTiHY/7Ho6KS8wXeaSNWXdKUEfPPRG/q9jEwU6PC/3mguAtxM3C?=
 =?us-ascii?Q?I9UFgoCQSSSgVXXnOFtCP+Lxbs12hv09FwBElDUKVlzoKlSepW4ulbwB82Mb?=
 =?us-ascii?Q?GDZnxpvO4+kmmTD44AWliUKZc1LfKPdMkQSrTPasShA9R0nGXNKI2NxAfO5T?=
 =?us-ascii?Q?BDkDjh4pFhV7IRWpUyfE5BCXCWVUjJmWKZ5JLSBaYE0Xu43QoBUquBJHcU6x?=
 =?us-ascii?Q?JqAM2YyABbRGT3b9zTfZx4ga5LTiEnC+hGtEgMqpslpziJkr4fggXTuY7X4b?=
 =?us-ascii?Q?wsMelfvliuScC17uhj39VnAZoCk6yPr8q2r5j2qJCp5jYp2o0SGkfwMvMWii?=
 =?us-ascii?Q?70FIQ5reeWWdxRtBv4qS2syn/tZplmdT1DxZVja416xbxZldgRgESWXrN7sn?=
 =?us-ascii?Q?gEw6VxYwpwifECIDC3FVdfQjo3dOtjkTuxFc5fKcXlFf06YB8MSYge37KGQW?=
 =?us-ascii?Q?MciFYAvx/baHoJn2hqfsgkMzFmrac7oWXf25rSdqEFmdhSLwoQ5I8WtrLrJC?=
 =?us-ascii?Q?rOhecnXdLF5cwQsdbabOYW3ms2oIw1rILwer1iaEtkWgfuL5pxycqVjbvW3T?=
 =?us-ascii?Q?wpOOJtaemwZXAZKsdoYT3z96BZSXRJYPkWDfNiWOaQd4OwNdzQeYuOkNghJW?=
 =?us-ascii?Q?uT/HqGrdR1+xEFze0NoZhu0cslpOEHuLxhgrONs44+2woNoJz4tyk0eVNnBk?=
 =?us-ascii?Q?PG3kxGYVaI8LBKQwcy8h5V5Db9u4o6+0FqDjZVcPxNzzIdKe1rcX4v6N7+uh?=
 =?us-ascii?Q?OmhB5TFxjefUygX0Luoj?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21362109-d51b-467e-354a-08dc57d11a2a
X-MS-Exchange-CrossTenant-AuthSource: AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2024 13:37:58.0331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8P194MB1662

This patch introduce support for stream_bytes_unsent and
seqpacket_bytes_unsent ioctl for virtio_transport, vhost_vsock
and vsock_loopback.

For all transports the unsent bytes counter is incremented
in virtio_transport_send_pkt_info.

In the virtio_transport (G2H) the counter is decremented each time the host
notifies the guest that it consumed the skbuffs.
In vhost-vsock (H2G) the counter is decremented after the skbuff is queued
in the virtqueue.
In vsock_loopback the counter is decremented after the skbuff is
dequeued.

Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
---
 drivers/vhost/vsock.c                   |  4 ++-
 include/linux/virtio_vsock.h            |  7 ++++++
 net/vmw_vsock/virtio_transport.c        |  4 ++-
 net/vmw_vsock/virtio_transport_common.c | 33 +++++++++++++++++++++++++
 net/vmw_vsock/vsock_loopback.c          |  7 ++++++
 5 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index ec20ecff85c7..dba8b3ea37bf 100644
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
@@ -451,6 +451,8 @@ static struct virtio_transport vhost_transport = {
 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
 		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
 
+		.unsent_bytes             = virtio_transport_bytes_unsent,
+
 		.read_skb = virtio_transport_read_skb,
 	},
 
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index c82089dee0c8..dbb22d45d203 100644
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
+				       bool consume);
+
 int virtio_transport_do_socket_init(struct vsock_sock *vsk,
 				 struct vsock_sock *psk);
 int
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index ee5d306a96d0..a4656d0a2567 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -311,7 +311,7 @@ static void virtio_transport_tx_work(struct work_struct *work)
 
 		virtqueue_disable_cb(vq);
 		while ((skb = virtqueue_get_buf(vq, &len)) != NULL) {
-			consume_skb(skb);
+			virtio_transport_consume_skb_sent(skb, true);
 			added = true;
 		}
 	} while (!virtqueue_enable_cb(vq));
@@ -540,6 +540,8 @@ static struct virtio_transport virtio_transport = {
 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
 		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
 
+		.unsent_bytes             = virtio_transport_bytes_unsent,
+
 		.read_skb = virtio_transport_read_skb,
 	},
 
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 16ff976a86e3..82a31a13dc32 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -419,6 +419,13 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 		 */
 		rest_len -= ret;
 
+		/* Avoid to perform an atomic_add on 0 bytes.
+		 * This is equivalent to check on VIRTIO_VSOCK_OP_RW
+		 * as is the only packet type with payload.
+		 */
+		if (ret)
+			atomic_add(ret, &vvs->bytes_unsent);
+
 		if (WARN_ONCE(ret != skb_len,
 			      "'send_pkt()' returns %i, but %zu expected\n",
 			      ret, skb_len))
@@ -463,6 +470,23 @@ void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct sk_buff *
 }
 EXPORT_SYMBOL_GPL(virtio_transport_inc_tx_pkt);
 
+void virtio_transport_consume_skb_sent(struct sk_buff *skb, bool consume)
+{
+	struct sock *s = skb->sk;
+
+	if (s && skb->len) {
+		struct vsock_sock *vs = vsock_sk(s);
+		struct virtio_vsock_sock *vvs;
+
+		vvs = vs->trans;
+		atomic_sub(skb->len, &vvs->bytes_unsent);
+	}
+
+	if (consume)
+		consume_skb(skb);
+}
+EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
+
 u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
 {
 	u32 ret;
@@ -891,6 +915,7 @@ int virtio_transport_do_socket_init(struct vsock_sock *vsk,
 		vsk->buffer_size = VIRTIO_VSOCK_MAX_BUF_SIZE;
 
 	vvs->buf_alloc = vsk->buffer_size;
+	atomic_set(&vvs->bytes_unsent, 0);
 
 	spin_lock_init(&vvs->rx_lock);
 	spin_lock_init(&vvs->tx_lock);
@@ -1090,6 +1115,14 @@ void virtio_transport_destruct(struct vsock_sock *vsk)
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
index 6dea6119f5b2..9098613561e3 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -98,6 +98,8 @@ static struct virtio_transport loopback_transport = {
 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
 		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
 
+		.unsent_bytes             = virtio_transport_bytes_unsent,
+
 		.read_skb = virtio_transport_read_skb,
 	},
 
@@ -123,6 +125,11 @@ static void vsock_loopback_work(struct work_struct *work)
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


