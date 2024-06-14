Return-Path: <kvm+bounces-19675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 95FFE908CCA
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 15:56:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88E2B1C263A3
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 13:56:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C65CEAD6;
	Fri, 14 Jun 2024 13:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="dLfUj49/"
X-Original-To: kvm@vger.kernel.org
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03olkn2057.outbound.protection.outlook.com [40.92.59.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15FABE65;
	Fri, 14 Jun 2024 13:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.59.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718373360; cv=fail; b=gpkcIzoTo3Lrt2GheGa3mb3POlN1Dm5htcgHJRU0xa1IDszohdBg/bhtl7Zqa8cyv69kdoV9uODupUa7toiRuhzr+z7NGT5TRsNUoPE9+7r875pjSZ5dz2UaadCHNIG1cmYktzV6T9ORReCVHeoKid7LNbkYRYRheelZ2QSapjg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718373360; c=relaxed/simple;
	bh=PbcR8chyGrvRobCuehcXslLl+Q50d6BejioPRAdAJOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hJAIiv35YQLCeSdKUDHSYg7MVXggAS6GfYauyMxF616sgXMRa8V6Av7ZkZMahcJZIHpk5iVjSjCC2pkV2vMVe7g/EKJGAyYXFiqYr5a7HZ+e9BpM2vV+No+yRfcXBZCr5EhHQqhxVwS9ms6A6ZXrZCribfXqPOfMf/8VqE31DGg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=dLfUj49/; arc=fail smtp.client-ip=40.92.59.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E2DaS/H4saj1To0E2acGxi9jQxMWbt2h3MTmV8TzgP7IRyVGzFAEKdk7ar4yOec9XFsXvf3C7eAVDBJf+27cDiWizU7MZwIigGldJElLXEOc9hoIBgWrwGEcIuFHSwNyb/SIIOHFjyWytu34Ls7fjyNYsFq/5WbpXKyJDjG841ghaCncL5I8d9ymFL13b8yiVPflN+v8ogoHEjqzXNE18t8HfuLjwFftfDym8f52JQzRn/sSWOAHtoCsSi64ZO8YRzLvFAE4Qb6oEFWRRh5pC4xtRJrkFlbD5kHKSv7BJ4zS7dKSau/SzymB9vVqjJNyIf+aNIEIPTgXuBT60CkgZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vbq4SBZ24qmRTbz8LqgCwYGwTDk8D5Sa4oWquQYwEhM=;
 b=SLlDDuglFE/1LZjte4Y48COo1ICmM1G8iWWGiIzpzhI6rC5zqfU4DQJG/NtVpngm5B8Y14ht9HB1TdrgkIcKBVkmFXcKDitK2B4cCanVzcHgv4BL3gxyc7auAhnMGawQPUos7dI7JtRvG7lWKZxHutM0eIowWYkHduUkyEyerW4T4ulbsHM6Fkiq+H6IXasVDXKwBxdBcAMQqc5EmupHT7/K1K6Elxwyzpl7NRWUls11GcEpZHYmr/JYfn39VoxyJ1zk/cz9GbmmRgbCDtwiaDWJtQOgciKaA/5yMrLffx4EN15769WAlr5qJ3qebdGp+K4UZ6TRkqxckSuvmhLzOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vbq4SBZ24qmRTbz8LqgCwYGwTDk8D5Sa4oWquQYwEhM=;
 b=dLfUj49/C5ACfMGcm2Rkvk1bXciMnwKmjzKs+MveUT+BPo1Sat3EHFQbdnNTFYpIYQ/m0MmMwtMBZm8DeAGjVJe2sdi4+oW463rfzL+EJzL/lJ7co5n1QzKn2pwiZw5jJRMyI+Cn7tlmLLnEFKquTEtZ7HU2ZZfBC1wt0BSAKfTncRDRM0SLrGSiWLjFsPdPimJlFaNfY0hGUeW6FY9+bKBjdOW24z6QFuCt1DrFwTCFA1aDa6Pd9osC5Jvomv3uGYLrG/WOhFsuEbEmKkWKLFP3ervGf28H3W8KqTBGv0kgxd4jMGqMQNH62zcP0Apvd/5B1xJWI0K3NPQh7bldyg==
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:642::8)
 by PAXP194MB1469.EURP194.PROD.OUTLOOK.COM (2603:10a6:102:1a8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.24; Fri, 14 Jun
 2024 13:55:51 +0000
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::3d63:e123:2c2f:c930]) by AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::3d63:e123:2c2f:c930%3]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 13:55:51 +0000
From: Luigi Leonardi <luigi.leonardi@outlook.com>
To: sgarzare@redhat.com,
	edumazet@google.com,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	kvm@vger.kernel.org,
	stefanha@redhat.com,
	pabeni@redhat.com,
	davem@davemloft.net
Cc: Marco Pinna <marco.pinn95@gmail.com>,
	Luigi Leonardi <luigi.leonardi@outlook.com>
Subject: [PATCH net-next 2/2] vsock/virtio: avoid enqueue packets when work queue is empty
Date: Fri, 14 Jun 2024 15:55:43 +0200
Message-ID:
 <AS2P194MB21706E349197C1466937052C9AC22@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240614135543.31515-1-luigi.leonardi@outlook.com>
References: <20240614135543.31515-1-luigi.leonardi@outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [zmAx0oZ3aW9aLNZjpKtjFc1D5puwy8oS]
X-ClientProxiedBy: MI0P293CA0015.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:44::8) To AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:20b:642::8)
X-Microsoft-Original-Message-ID:
 <20240614135543.31515-3-luigi.leonardi@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2P194MB2170:EE_|PAXP194MB1469:EE_
X-MS-Office365-Filtering-Correlation-Id: 76ae548f-9d8b-46db-c92a-08dc8c79b3b9
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199025|3412199022|440099025|1710799023;
X-Microsoft-Antispam-Message-Info:
	WW/B1PvIk5+eqfQhx3R2kSqmMKWbQevi5x8gs1W3/3v/3NrEFRxD2ig37z7hTazVM2HqZizQKLNnLfQS8+ZOhVx/ZODmeNnqpwyIjddVTLqB3uVUR99KMHSHODY4syjMDpIouP5hAM9IGX9Tz50G7YX8+KYWMN9otMLm6N5f9I9yUQ0yfoqgG2qDs+vQ9MT8REdNFQrn8T7QSNLNnTdt1ylMF9zT+bPqNPrrG0tDA+Em0d1d0/iI5Xn1KbRVbzoFO9npNsfeM1a4ge9F0R6I/c7lBsqy4X8GIsLURSxi+sFHn+/vnV0/HaiNZ4ZWY+fotIWHOw+U7CG10XsZb1yfKLTt2YGjOTnjwwNo16PfirBzKTKyxnnd5nxOmkoyAzjbxHT2EEf4T/SlUfRbAoprtWo+ZFLVy5cJTvpvb0Aw3Lnv+GpNI/2XKxZsWWH5fsmFxrY0617zFBRWJF0oMD4aA7O7YbPecsse59AFQst2vHAzojwDbWGJ6qDLmi0mg1hng60Uo7c5gKXE6gwZaszUSBXR4eqiFsZjmkumusHsGbRizDy/s6k8GU1H5WXFyT9S/cBlcgGBP5Fz7pS2J7xzxVXO4ztG3E9Ggz9u7WY6fq5M5qNJTVxlvThMyLxNC/kU
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?38IOLlKAPMECLKOWiFCXC/SnZAHV6noRMaF1OMct1BM9BEK55wniP5uzjmYd?=
 =?us-ascii?Q?7DQPghEZPFAzC8sHropJnPYBf+CG8arg76HB8UmHPGDlh6pkBoc/Xo1Sspk6?=
 =?us-ascii?Q?vqtce8CUZLGH6lJYzOpouRwURQMGKUNgx34TVcwlMufx8quHemUisL/ov/kb?=
 =?us-ascii?Q?fb8XOdjpEKABkfpt0dga5ZuItbWTPGAWi6HCuO7bWgIpoA5TtFoI8KSH8CW7?=
 =?us-ascii?Q?/PQJNTdndUVGli50j5flyL85ZcJ7mtkLdakS4x7lYfRfmKSaLZhYRsuI5wIP?=
 =?us-ascii?Q?2axe6bBI0oeYQQwaGT6QLl5/4b7ybI4+ALeFgl6xSVz8S/ZSl4ltRwBTVrSE?=
 =?us-ascii?Q?xDaMNpi5pRL31/rR4kVNIqbVWZQ8pwRVyfY5JI9g4YYKOM4AS4iGerkH6V5K?=
 =?us-ascii?Q?1stn6HaHv3fiw9geawr9dMptNNFThOx7HP5nqulhhAopw/dfBpTLu3yBxRmd?=
 =?us-ascii?Q?mD3nyeEuMYfmUAbN3BUic9Al1pimZys10RLsyt0iEY4vG0lrosRWqGfs58x8?=
 =?us-ascii?Q?bWloyzfe2IhuYf/m7uIjfYKA5LIgmCHbtE23Aur0bVRBpPCwOD3HUS63poeC?=
 =?us-ascii?Q?nBeSRWhpBmiZ3b2nuyfLRwolZCoxuVBBo0fZYjcDKvu4VuY/UeN4iDgAzQX7?=
 =?us-ascii?Q?LXVuOWol2Nw7Dn413pOCYWqOPV4X/uCysmjOc8IB6dQYrI/UvNxdvN7ACxLg?=
 =?us-ascii?Q?OndpO8sZqF+jzH+7jcNYzvI1Xx/I+h0iXQHGJp6zvzOsGSX/3UPXG5M+pgwk?=
 =?us-ascii?Q?OtIw2S9IB6r6vbCv3lIfphdfgsp6LXsleAWqO4JMhlJnIjZp5DX/bPL5Deky?=
 =?us-ascii?Q?GHZBV7zIbOKId4JUe9/CNkIraT+8oDo7Mw/cPKlQVdCJtYtUsD3ZDoLDtpga?=
 =?us-ascii?Q?SsKx3Tuf5spBQhdTuNDMjMjcNb/fxve8Y+qpl7ojrkwXDppELXkxPvu0kCzj?=
 =?us-ascii?Q?//4KFLCx9gN/OKgrQsCJxgLnEBlqwI42Yb/1LYTk1HPyyXXrRUrE/oQj83Ez?=
 =?us-ascii?Q?Esmz/cPLBN9GDKOypfsaBFWZMDWgL9QfF+Xv2mb2DvvxoW8poBwZTakFKmw+?=
 =?us-ascii?Q?lYQBJG8uu4opw6uIdqldUM2Uv9d2iRWWnMSANzZnUGVM6UPRseGCFPo2CqmM?=
 =?us-ascii?Q?Alvd1UI2RIPSIo4UXUXMZB55c5EQ8219GE+CSrMBbOuqj6Lg7Qfa7psfSkH2?=
 =?us-ascii?Q?aFY2Z8gK5xsBTeedydfh0ZAthGOXXae6M46vMVr8PrXI/Cs8ibFQroIO2Rmc?=
 =?us-ascii?Q?OzRba2sgKKapYxDj/V/S?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76ae548f-9d8b-46db-c92a-08dc8c79b3b9
X-MS-Exchange-CrossTenant-AuthSource: AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 13:55:51.5906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXP194MB1469

From: Marco Pinna <marco.pinn95@gmail.com>

This introduces an optimization in virtio_transport_send_pkt:
when the work queue (send_pkt_queue) is empty the packet is
put directly in the virtqueue reducing latency.

In the following benchmark (pingpong mode) the host sends
a payload to the guest and waits for the same payload back.

Tool: Fio version 3.37-56
Env: Phys host + L1 Guest
Payload: 4k
Runtime-per-test: 50s
Mode: pingpong (h-g-h)
Test runs: 50
Type: SOCK_STREAM

Before (Linux 6.8.11)
------
mean(1st percentile):     722.45 ns
mean(overall):           1686.23 ns
mean(99th percentile):  35379.27 ns

After
------
mean(1st percentile):     602.62 ns
mean(overall):           1248.83 ns
mean(99th percentile):  17557.33 ns

Co-developed-by: Luigi Leonardi <luigi.leonardi@outlook.com>
Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
Signed-off-by: Marco Pinna <marco.pinn95@gmail.com>
---
 net/vmw_vsock/virtio_transport.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index c930235ecaec..e89bf87282b2 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -214,7 +214,9 @@ virtio_transport_send_pkt(struct sk_buff *skb)
 {
 	struct virtio_vsock_hdr *hdr;
 	struct virtio_vsock *vsock;
+	bool use_worker = true;
 	int len = skb->len;
+	int ret = -1;
 
 	hdr = virtio_vsock_hdr(skb);
 
@@ -235,8 +237,34 @@ virtio_transport_send_pkt(struct sk_buff *skb)
 	if (virtio_vsock_skb_reply(skb))
 		atomic_inc(&vsock->queued_replies);
 
-	virtio_vsock_skb_queue_tail(&vsock->send_pkt_queue, skb);
-	queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
+	/* If the send_pkt_queue is empty there is no need to enqueue the packet.
+	 * Just put it on the ringbuff using virtio_transport_send_skb.
+	 */
+
+	if (skb_queue_empty_lockless(&vsock->send_pkt_queue)) {
+		bool restart_rx = false;
+		struct virtqueue *vq;
+
+		mutex_lock(&vsock->tx_lock);
+
+		vq = vsock->vqs[VSOCK_VQ_TX];
+
+		ret = virtio_transport_send_skb(skb, vq, vsock, &restart_rx);
+		if (ret == 0) {
+			use_worker = false;
+			virtqueue_kick(vq);
+		}
+
+		mutex_unlock(&vsock->tx_lock);
+
+		if (restart_rx)
+			queue_work(virtio_vsock_workqueue, &vsock->rx_work);
+	}
+
+	if (use_worker) {
+		virtio_vsock_skb_queue_tail(&vsock->send_pkt_queue, skb);
+		queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
+	}
 
 out_rcu:
 	rcu_read_unlock();
-- 
2.45.2


