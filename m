Return-Path: <kvm+bounces-22949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B797D944ED4
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 17:12:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BE2628292B
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 15:12:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1FCD13B5A5;
	Thu,  1 Aug 2024 15:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fZxZZbUv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627AD22064;
	Thu,  1 Aug 2024 15:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722525120; cv=fail; b=CT6UKQBnx1eKi7wCil55v/62ol2J7cQLGxpkidAX9sr6k0t/Xu/NFLJmd99g1K19GU28CEgCSFAPR7YAlF9uvxBHzuPTLXckKglRFkRtq3bSTvfwLwt9VHmyKmwT0Rxdx0dzYbD+nKrhP7kGQAiowsEqJ3B2LDPG5RarXs7ieS4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722525120; c=relaxed/simple;
	bh=7Xzs+XIsiCBfw4zDeighDDZ1+h3jfaEjzsxr9cng4co=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=F0dYneJzWFX5mq774sSzEjJJim39EWQ7qXVCF+OOaglAeQEuwlft21p5Y2a6/YxH0JlGUUnU+Vh0gSXVjTUcITIRQWYxMMoOtiLrs0TzD/9VYkPsmdSU0bEP5CpYaUH+E+z7Af70m5chhN6QV0fbPXEFYTbHtWLKU8h1tF+84c4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fZxZZbUv; arc=fail smtp.client-ip=40.107.243.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G74dVZyEsMrWOerjN2BtUZDqblyWkJT00wtwSKgGeiQbTzM6wkQfjwuAFF1YyAppLqWY2fU1enjTHy4A2tLw5fhfkcPJ5+HKPZ2KNOdB/p8s5FFs22keE359bMYHrWIYgQt6DRwaJi5o2+dRVaHLCYU6D47FFB2hfrNyyDaU1/82rvP4k51/xkphb6Q9XtjiVS8f7WBGbFWsntpdWCdZb13pbT/ugnUGnt2p7VNDb1NKXHfp0fL6XhkO1E10H2ySEjIKgtHcum4g0S9AV8qucYIBV/xOvR/kvvq8kETxJQccejzk8QqrmEmEdvGAGyZCghVEQXaehKP8BNpt8xB6Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fu8rmhbJnl7tgcFCis1wrZ3Uh6mk200GBW6OiM+Y1aU=;
 b=E7xdY6pQXzsJS3QGvBfQsBqTCdvPEb1mcS46q+WirpJYIaodmzhBLt6gHmuSzgnhZ1fgsAjth7YWw/71J7xIOlzDkDdA1t5qItlrRr7K8AUbEDP4wmJhGiaEt5B113BlIBh+QQiudf7+KHmW6IoYVHKf2VevZ9VHS5gX/LPYv76hCCL0yB2wq2i+L24LP36a7Uv/1D8Rx6XYsGJ1C+Uih2fW47kXQIiJzjdAFSj8hU9dTwmEtgfxPSkeQOUWu3/HNo0goEn8fGY3tdkU+umONT8EKe8gD5y5G54B/k82Q6cMQfQ1xP1A8ny7g2uqIaPBoQqQJeowfCqKKVjEAegKcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fu8rmhbJnl7tgcFCis1wrZ3Uh6mk200GBW6OiM+Y1aU=;
 b=fZxZZbUvxaOTgwetmomlWALcpO7bQF9etxiB8ZwotuNY3sZMs1fzKtZM6kvIoyIFC8Ryywmm5At45xw7EiXjES29cV6oYugXY1Uf9EZUvQrvcI8oHd72Nwn5Yt/3nY8cYfzfo5OtsGKB9YlJWSemxKnUQtlDJI81AMNkXIojIBEpxUDsPPYRPh2Bgbs4sPfye4cazwpCBzIeE3NCzSr7dj6L7Po4krurHSShCQ4dQBqeUS+yTYHqA4/q4bDtNtoDJ5CEzILrzchLuXg0V6Rf7f5TqYTu1+3z5c2RtB8AaigBCvTVg60gpJb3w/0y11LQj4gTF/kSyB8Q8kPN/PB8uA==
Received: from BN9PR03CA0130.namprd03.prod.outlook.com (2603:10b6:408:fe::15)
 by CY8PR12MB9035.namprd12.prod.outlook.com (2603:10b6:930:77::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.28; Thu, 1 Aug
 2024 15:11:54 +0000
Received: from BN3PEPF0000B371.namprd21.prod.outlook.com
 (2603:10b6:408:fe:cafe::28) by BN9PR03CA0130.outlook.office365.com
 (2603:10b6:408:fe::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22 via Frontend
 Transport; Thu, 1 Aug 2024 15:11:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN3PEPF0000B371.mail.protection.outlook.com (10.167.243.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.11 via Frontend Transport; Thu, 1 Aug 2024 15:11:54 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 1 Aug 2024
 08:11:41 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 1 Aug 2024 08:11:40 -0700
Received: from r-arch-stor03.mtr.labs.mlnx (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Thu, 1 Aug 2024 08:11:38 -0700
From: Max Gurtovoy <mgurtovoy@nvidia.com>
To: <stefanha@redhat.com>, <virtualization@lists.linux.dev>, <mst@redhat.com>,
	<axboe@kernel.dk>
CC: <kvm@vger.kernel.org>, <linux-block@vger.kernel.org>, <oren@nvidia.com>,
	Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 1/1] virtio_blk: implement init_hctx MQ operation
Date: Thu, 1 Aug 2024 18:11:37 +0300
Message-ID: <20240801151137.14430-1-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B371:EE_|CY8PR12MB9035:EE_
X-MS-Office365-Filtering-Correlation-Id: f6970d8e-06d3-4280-4cd4-08dcb23c477f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xTD1iqV5IMdCE5t5qpR/iVd4CTBVLqHI35gPVCYTVwhG3UIbopwIXWD5Vekn?=
 =?us-ascii?Q?2g5xFQTncmHwk5aP74nkzJKU8Cp3zZBtnUnZrgfk73/W5lBHyD6JSgdZfeYC?=
 =?us-ascii?Q?Ze/93swxS71pyW4iMrWJbpyHf9R7PfUhxrIzLVDKNe5Q+S7uWzitNj67PFW3?=
 =?us-ascii?Q?SR1MmqJWsxdDg7y2Of1kCTy62tbiB3cWaG1kdu9YdjxQNSQX6CJebgi3Dlr+?=
 =?us-ascii?Q?ziRkBKR1t/rd+TLm0kyFAfHucA2dBWmAe1tuJNvkgNLjpaNakLH+PC9SQKUZ?=
 =?us-ascii?Q?PE+OsZiSWKSdbhSSH8iX37DvhTyDFj6D9IV63yn2Uwlx8UigcEtbnh6nU6YZ?=
 =?us-ascii?Q?OpbYw6Zf7jUM75d6ORJ1NxrhNKWDQ4SRncOuOWBEgBJLtEES0ids8kHzySHR?=
 =?us-ascii?Q?VHHoq5xP9E+JhiSQn7uiq9CKvV5se3NhoZ37LpO4879FIgOGHnRb5cvCS4RC?=
 =?us-ascii?Q?CUOAP2u/EWnj66B/k3ue+I+3/5nwmjR0sDWCyMf4IvI86kZ7hfBgicNW/16f?=
 =?us-ascii?Q?KeN++1NJv/knjQPRcMZNiXlcyCU5MqSbmYRwG6MWlAvfOkROEhDAx09cFoxe?=
 =?us-ascii?Q?iAH1e0FwQpHFADrM1D8kyCUjDKZmUNXmdFn7QBMtJcKYAOoW4J65M7xk1fSY?=
 =?us-ascii?Q?/eIW9DgolLQuTztTrER6VivpkX77PmpnfRgjdOrQUoJna3Jk+3072zDQUci/?=
 =?us-ascii?Q?FmEtCMMhjyGCJnBIhrFh6WDhdPlOoAYu9CD0JqYNY0DgJ413Icb6qbxVBGr4?=
 =?us-ascii?Q?w3x/xRZCqFKK05/CJIM5WYtQxm5Lu8fRlzwXYO9SI+SYMyUsDCXGkOGcm1y7?=
 =?us-ascii?Q?kwrqoVTBYg6DIdbfav2W0sKYkRd0Rb5x7EH6poMlt9k2Bezpm8S9YSlkpyuK?=
 =?us-ascii?Q?ulP2AClvj2BwGa2Wl9MierE/e9ahasAcfKPjRQpTQTeZ7QdMKzzmd6qksWvZ?=
 =?us-ascii?Q?rtjU1yxWrkvQvrrlLBgCXvNrcIulyxXzXJ+pnBaw9rgl2IPp/R8a077DdYwT?=
 =?us-ascii?Q?drJ2J0YKVTqlt3pSY9Io2yqtS497NM6+hvU0HVJ2JF1eId0Fdv2vG2lihL9B?=
 =?us-ascii?Q?9tFKvA1miWS0lJ3YUVR3ht71UPdLy5YQG/k0TvWdJhgIy+nZXderuxuXjw98?=
 =?us-ascii?Q?WlGpUeoSb0WD9qdnD0HXe0mrKNjwQuXFo5/9EsqqK2Pjulf8UDeg4xxGcFMr?=
 =?us-ascii?Q?1atPf8jJuP+8S2Cp7E/OCNJA/VOZTfY4cfl7VK3bXtMTqgIA3Yin3mOdnC0b?=
 =?us-ascii?Q?RX/a40+JXC7VIIBfirZVcoBxH4rpazGKih4st90zvR2sgwf8Y/SgIXa/SkSL?=
 =?us-ascii?Q?JFLL2dgbO4nhkGCInAi7OSJcxiEIjsDYwdtc2F0Vraz+KSCdK4yW4AInv5rT?=
 =?us-ascii?Q?/w8OLgVaX4fNssLobBIPmW+wABZx4NB5I7Dl/SeWrf3mVefirbi5pdJ6VFvD?=
 =?us-ascii?Q?3ylTTAKoQOLBo6Aup0zylotGK9PZYhQ5?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2024 15:11:54.5199
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6970d8e-06d3-4280-4cd4-08dcb23c477f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B371.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB9035

In this operation set the driver data of the hctx to point to the virtio
block queue. By doing so, we can use this reference in the and reduce
the number of operations in the fast path.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/block/virtio_blk.c | 42 ++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 2351f411fa46..35a7a586f6f5 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -129,14 +129,6 @@ static inline blk_status_t virtblk_result(u8 status)
 	}
 }
 
-static inline struct virtio_blk_vq *get_virtio_blk_vq(struct blk_mq_hw_ctx *hctx)
-{
-	struct virtio_blk *vblk = hctx->queue->queuedata;
-	struct virtio_blk_vq *vq = &vblk->vqs[hctx->queue_num];
-
-	return vq;
-}
-
 static int virtblk_add_req(struct virtqueue *vq, struct virtblk_req *vbr)
 {
 	struct scatterlist out_hdr, in_hdr, *sgs[3];
@@ -377,8 +369,7 @@ static void virtblk_done(struct virtqueue *vq)
 
 static void virtio_commit_rqs(struct blk_mq_hw_ctx *hctx)
 {
-	struct virtio_blk *vblk = hctx->queue->queuedata;
-	struct virtio_blk_vq *vq = &vblk->vqs[hctx->queue_num];
+	struct virtio_blk_vq *vq = hctx->driver_data;
 	bool kick;
 
 	spin_lock_irq(&vq->lock);
@@ -428,10 +419,10 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
 			   const struct blk_mq_queue_data *bd)
 {
 	struct virtio_blk *vblk = hctx->queue->queuedata;
+	struct virtio_blk_vq *vq = hctx->driver_data;
 	struct request *req = bd->rq;
 	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
 	unsigned long flags;
-	int qid = hctx->queue_num;
 	bool notify = false;
 	blk_status_t status;
 	int err;
@@ -440,26 +431,26 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (unlikely(status))
 		return status;
 
-	spin_lock_irqsave(&vblk->vqs[qid].lock, flags);
-	err = virtblk_add_req(vblk->vqs[qid].vq, vbr);
+	spin_lock_irqsave(&vq->lock, flags);
+	err = virtblk_add_req(vq->vq, vbr);
 	if (err) {
-		virtqueue_kick(vblk->vqs[qid].vq);
+		virtqueue_kick(vq->vq);
 		/* Don't stop the queue if -ENOMEM: we may have failed to
 		 * bounce the buffer due to global resource outage.
 		 */
 		if (err == -ENOSPC)
 			blk_mq_stop_hw_queue(hctx);
-		spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
+		spin_unlock_irqrestore(&vq->lock, flags);
 		virtblk_unmap_data(req, vbr);
 		return virtblk_fail_to_queue(req, err);
 	}
 
-	if (bd->last && virtqueue_kick_prepare(vblk->vqs[qid].vq))
+	if (bd->last && virtqueue_kick_prepare(vq->vq))
 		notify = true;
-	spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
+	spin_unlock_irqrestore(&vq->lock, flags);
 
 	if (notify)
-		virtqueue_notify(vblk->vqs[qid].vq);
+		virtqueue_notify(vq->vq);
 	return BLK_STS_OK;
 }
 
@@ -504,7 +495,7 @@ static void virtio_queue_rqs(struct request **rqlist)
 	struct request *requeue_list = NULL;
 
 	rq_list_for_each_safe(rqlist, req, next) {
-		struct virtio_blk_vq *vq = get_virtio_blk_vq(req->mq_hctx);
+		struct virtio_blk_vq *vq = req->mq_hctx->driver_data;
 		bool kick;
 
 		if (!virtblk_prep_rq_batch(req)) {
@@ -1164,6 +1155,16 @@ static const struct attribute_group *virtblk_attr_groups[] = {
 	NULL,
 };
 
+static int virtblk_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
+		unsigned int hctx_idx)
+{
+	struct virtio_blk *vblk = data;
+	struct virtio_blk_vq *vq = &vblk->vqs[hctx_idx];
+
+	hctx->driver_data = vq;
+	return 0;
+}
+
 static void virtblk_map_queues(struct blk_mq_tag_set *set)
 {
 	struct virtio_blk *vblk = set->driver_data;
@@ -1205,7 +1206,7 @@ static void virtblk_complete_batch(struct io_comp_batch *iob)
 static int virtblk_poll(struct blk_mq_hw_ctx *hctx, struct io_comp_batch *iob)
 {
 	struct virtio_blk *vblk = hctx->queue->queuedata;
-	struct virtio_blk_vq *vq = get_virtio_blk_vq(hctx);
+	struct virtio_blk_vq *vq = hctx->driver_data;
 	struct virtblk_req *vbr;
 	unsigned long flags;
 	unsigned int len;
@@ -1236,6 +1237,7 @@ static const struct blk_mq_ops virtio_mq_ops = {
 	.queue_rqs	= virtio_queue_rqs,
 	.commit_rqs	= virtio_commit_rqs,
 	.complete	= virtblk_request_done,
+	.init_hctx	= virtblk_init_hctx,
 	.map_queues	= virtblk_map_queues,
 	.poll		= virtblk_poll,
 };
-- 
2.18.1


