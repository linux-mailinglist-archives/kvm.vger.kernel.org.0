Return-Path: <kvm+bounces-23586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5874394B332
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 00:42:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B8F51C21390
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 22:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EF7D155325;
	Wed,  7 Aug 2024 22:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Xmny7Ji3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B30F84037;
	Wed,  7 Aug 2024 22:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723070511; cv=fail; b=aSet6G5pPVXg9qEXhbhsijxSMqI0PpwsKVNNqV9A+ALDjmbSCdhobPjXes8RGXfsbWxwpphsvhJduhGrEUSkqa547js8ExmdCXCyiozlTer84mZCHrmXoneVGDvfTOg9v3BucuTco8/OT83PfDHEAlJV3xY8GJK7G3+NvMFvcUw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723070511; c=relaxed/simple;
	bh=+OOVJx+oZ3mA7y2n2ucNNovYvh+RsakGflK1nEG3wmo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=E+LESF9uYx1WbLHUW2JPnryn9mUmtXJ/ccyzUEB8eB2QNJH8nYDNUL7cNpXzaxYk7CzoKGfSD/YbJB07QyZBwVD0dhR7SnTM5YJkYaVksHUuLcKex49Rp3+E5QwYxH7GMZPXoGsMxfLgGu93kfkvK7SF6WCXv8m74Hi4591JL2A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Xmny7Ji3; arc=fail smtp.client-ip=40.107.243.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p0ld5f1CngEpcnZvbltQKgWiUukeVg6J1SxqkXhn6rN3pjhAv3bVrm0Lct+UKbA72Rk4HS/tcxXRSe4/ThSPDCwT+mILkZkpZsXyFYtmn8KNIAKTuDBiNMSkDvXfKez7+3oob3GX7YPCT9MsAV3xWOkcUDyNQvFgp//K6Zae9HQ1WsU3zvSQZ3ix8sm1YcUaGoQfhYk+/IL6ratd+/Ny3DeJRwsHVZ7ftJ1yU0gJt2kzifNnLgXqAyf7u4tsPhLW2Hf791TcrOowgMppFFHHKjKnv0REdxQ8t04s4XrJURIC89Gx6svki/cBFdhnkCD1l453mEvebhBjN6Qdn7ocLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H2CzQ0CmMxzzrpO0I/9AQ4gzwGh/pa5CVmBoWKnSsZc=;
 b=KCGf43v9+NCvy5WcETB/rDuUDBb2dKaGVKB0UMV9478H06OZk3lO9VHOq58qKCx/QwpmkUsOfJnTfcKir0PF8U7yA+3HwSqrh/2aPpHP0ZixUFGOATBPfn99JDnYI7ceC3q1uV3s2Dr787rIa2isFnklZ1St8y42xqzYouchzN5HnFXmWvBMwZFlxz+gY/n8Jggh05yDOr6e1WD9gEdW8AP66S/hZG6NZHnnE9DH6vG/6ltpfCJzlrlBCH2UNil84BG4WcY97EkjwnZMR7FH3bqOEbF2V/1ixJ/PMFsnlq352gIpYuDTCLVtXMI7JZi1bcLHAfNNb95aOpgH4S769g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H2CzQ0CmMxzzrpO0I/9AQ4gzwGh/pa5CVmBoWKnSsZc=;
 b=Xmny7Ji3CSFqwdGYS4W0LPvMDIrYeo0D/BfHtNE0t4hRsERowuJqYYXdiIRrRlgroo9tVswQJZYRizcwBi+InZ5nUtWiUBkBAtzO8/l/nM3rVgVmGWn9WkZAGpX/mQ927yBVoVmgSHJUzLCGx40DUhwkP3Oo1J41P0v7fJH+L+/VhS8hnK2uVALHdJkbHSiz8/h2ctVhPxVpYHJ0SzQBfpNAScQClNQp5BQMRUHRys1S7KZdD8FntgkD2bR5ggdZljMlvxN2l7SvzndZnNNkx681/8RYdTQsjdBbywPeKh+4yeF/ayCJhlVm472ftuUGRHUZck04xOLtApj25l11Iw==
Received: from BN9PR03CA0589.namprd03.prod.outlook.com (2603:10b6:408:10d::24)
 by PH8PR12MB6699.namprd12.prod.outlook.com (2603:10b6:510:1ce::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Wed, 7 Aug
 2024 22:41:46 +0000
Received: from BN2PEPF000044A1.namprd02.prod.outlook.com
 (2603:10b6:408:10d:cafe::d2) by BN9PR03CA0589.outlook.office365.com
 (2603:10b6:408:10d::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.30 via Frontend
 Transport; Wed, 7 Aug 2024 22:41:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN2PEPF000044A1.mail.protection.outlook.com (10.167.243.152) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7849.8 via Frontend Transport; Wed, 7 Aug 2024 22:41:45 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 7 Aug 2024
 15:41:32 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 7 Aug 2024 15:41:32 -0700
Received: from r-arch-stor03.mtr.labs.mlnx (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 7 Aug 2024 15:41:30 -0700
From: Max Gurtovoy <mgurtovoy@nvidia.com>
To: <stefanha@redhat.com>, <virtualization@lists.linux.dev>, <mst@redhat.com>,
	<axboe@kernel.dk>
CC: <kvm@vger.kernel.org>, <linux-block@vger.kernel.org>, <oren@nvidia.com>,
	Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH v2] virtio_blk: implement init_hctx MQ operation
Date: Thu, 8 Aug 2024 01:41:29 +0300
Message-ID: <20240807224129.34237-1-mgurtovoy@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A1:EE_|PH8PR12MB6699:EE_
X-MS-Office365-Filtering-Correlation-Id: 288d3d4b-9851-41e4-0805-08dcb7321dc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Nbh1s61WkqWkJ59r+u4oEixuIC3hmGzTKkfp54xN6IQeGFhxA7fTlwzUx6Tt?=
 =?us-ascii?Q?5ABH42pflMB7PqhARL0E+M5jA0pjUOTXVIwgDLQ+Bvlwzd7u+CjQkiPHrXkJ?=
 =?us-ascii?Q?UCnG44yDEoy16aT1QdD4+o/ws21aUEBYUvLZUfB2h3r8HiO9IZ5YcjyAqk5o?=
 =?us-ascii?Q?hbORji387daofbw2afzhR1curlai6Gnyozspn7Rg/MLCFmKfLqM2j1m5H24R?=
 =?us-ascii?Q?QI3GYD8e5e8SgZccHLscR+pj36tC9lAMke+XzK2YFXuwJejviRljNUa5aC3R?=
 =?us-ascii?Q?I8HuR+7dIYj73eGVxS2/5gfpV0s3cU5sJxfsfnwZUtbJNUWDfTAO2oMTXOj/?=
 =?us-ascii?Q?UTpwf0Dhjaaagg3Plk8Ur3ZOBr9Ao3eL+FVsWlwpbhtaYepAyLCwOWkzNecE?=
 =?us-ascii?Q?NE0jWX0KdreMINl9TU8UnGWgke5/omKhD5tw23PNAD2pPWIFvKag0xBeccNS?=
 =?us-ascii?Q?JLhUPIyHLPwwcNurn1U2tGUUVulKfmzLcXZ+eA9oRHaDt3ZewSTaB8A67SdK?=
 =?us-ascii?Q?5QjoKl4Zootkngu0egUeGJTdKw/ATT10hzriQwEkdZAa9U1mpMzlwW53eNO4?=
 =?us-ascii?Q?4UIVbXCDAjaEpB5FA1cY1KQkoBIcFcPnJsG2Tsqw/LhfJDlAvXLReQEmmg03?=
 =?us-ascii?Q?t01iEBM081OHXnG6RA1wGi3tS+FcbQbUwpVVaX14OnboDMdHrZEQ3r6eDbff?=
 =?us-ascii?Q?EAS0T1BzzrPF5MZDhcR/xS4L0LPt+BqwhiSZj1dYs7OaccaC0G2UG2kLM/Gd?=
 =?us-ascii?Q?RFXav87GeynPi1PhPIVe4TCbdYS5XoaynkrSytoWdAd5pN7o6108MRIxlcrZ?=
 =?us-ascii?Q?2laPBeRqewdASJ6Gwf/Ql3pl3nLF/GjCeI9fgGtZQ8Sg6Ybz8gemWv8wZ+aw?=
 =?us-ascii?Q?VqKAEi+Wcgy/X+W3zeotK8vQdvrZeHYl3Hk1FJ+0A07wsd8PaGGQnde6h2sS?=
 =?us-ascii?Q?zV5cztCxvmvbjPZ5+jAInj8Prg41D4TqCCP9DCd4XfQSNzkd86ZK9QS+7Rqb?=
 =?us-ascii?Q?lwdbpnLkOag2VSOIU1oLQf7F5wpyrlVRfaKNBrcdJWW409tManxu1K+ZtS33?=
 =?us-ascii?Q?KSdqsAJhGq7mAb0agjvFwmUehUKDkfTDKW3VNpntr4zcBQfXP2UC/cKmzVX+?=
 =?us-ascii?Q?93mrvwMSHABe6YNNCiFMj8pGGtQ43djexGrlyjrisdPFs1/6vt/7HsdIKVyB?=
 =?us-ascii?Q?fTAIKeFEmZMoxN+u1hY20f4jj2yNjwAWW2bYWvstiAZcKK1Esv698rP/2lEH?=
 =?us-ascii?Q?wLQLSeHH3XlfzfAeLgWbemn9ICVTZRNQ+D8yGKkajyQRa5kuHJgYlyCZmCpl?=
 =?us-ascii?Q?nsllLNcFEmOr72OSLm7hCZuO0NVLjgJR4UCJ220Sb0/si1xGtrgvhr3tO7W9?=
 =?us-ascii?Q?UPqEKjLSCj/Klj+kk/c+lht7X5LTyxBZp6skCrHDLIDdnfroO5j/W5vgPjXH?=
 =?us-ascii?Q?jh5HhI3EpqzRzgSbRtGpIBBts/S5YRKH?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2024 22:41:45.3330
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 288d3d4b-9851-41e4-0805-08dcb7321dc1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A1.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6699

Set the driver data of the hardware context (hctx) to point directly to
the virtio block queue. This cleanup improves code readability and
reduces the number of dereferences in the fast path.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
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


