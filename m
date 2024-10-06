Return-Path: <kvm+bounces-28039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D76D992075
	for <lists+kvm@lfdr.de>; Sun,  6 Oct 2024 20:44:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5496281F77
	for <lists+kvm@lfdr.de>; Sun,  6 Oct 2024 18:44:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03CF92C853;
	Sun,  6 Oct 2024 18:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="buOv7Vq6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98268189BB6
	for <kvm@vger.kernel.org>; Sun,  6 Oct 2024 18:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728240238; cv=fail; b=kmHHpABuiZLj3vhAC970xl6Tw5ZzQ7ybUJxtvbJSDVDgTNmjYdIAn3d4KERMhUeHzaXdIQVvpMEORz1ZFgE5SjaF8RgcMAak+nh3Db8lkgRKhzRWAsVwKNvANGw9rlW1oZPfJsqi5gFP8GnAbs44BoxhXpVsSWcVD2/7vYefLuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728240238; c=relaxed/simple;
	bh=CVd+1feB99vCBg+t+t9Tsk7AkITt2MbvxHr+t7hwguc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=i6VvOhxZhbO2Fu2rYDRjBzUG3OXCfgKWd2haXtkLwfIMDFCu7c6Bz3OetsvDnMNv130GkM6a5ss5CRONEYK+3lNLefDo0h0aCgFw91KiPLyiC3NxRyDlBPsVFH032iabeFCc5WfQnPoND63mEyugG6mtoss/vJrp04Vh8Q+gCDc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=buOv7Vq6; arc=fail smtp.client-ip=40.107.92.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MJyEgWOI3yOOyEWszHUb87zohXiR9yUjgplsXpGfKL8orV6gu3zaoeIvQOk+Jd1rEdzmL4NB8+mej0UfTUBGP8+7oLTxj3gYF5LLh9Uupn3rBnh88bJZ0eugq/qQtI+uiBvJ9hwlL+ju3ZaZDRP2tx7oC/URkr5Iw23vRnZCZKrdAq7ix+u/7H+BNHhpRdUWqlcRZ7yZ9yxKtLjR+WUjZjGo+ZYvQNg2runX8nNGrlLojcgd/cwM9GdgnJTi0HUXPBRgo+Vlpu39pD6h0v3oM+KSdnuvpEb8YfNCU+Fh+hggrH3KITOJpD2UhtPpq5GV1CxJwekxeJ/m7zUEMaj5KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y3kgHiVG+ohhu+YzMcpN/r3cM6hXzyzIdsHDHTIfFo8=;
 b=V8HXjmTh4DSgrLm2xoOwBm7uuAqU1RWpf/rnHaWu64xbzK5GGdVlKPRV1jQQNY539bDGZ6781U6oV/7NLEzwYNY0gwWZ/FY3a/kly+D+TtvCsUVzQjgRnvNfufIZY9itUL7wDTeK544i+qNZ4Zn4M+ox5k7LFUz/iX0ow6Eu09s+tF+U+U8pPDVX5QDnCAGqc7qIz4iJ5Hlm0MdGIYGgc5hgLVEtSYJLReB243w3uOaojS4avdqOAPysgJKklwaZyCHzQGyFu46DmULKA05MARpUcHQZW1TbJS6oeStUoNbegYzfJFM/h4QKKGWGUa1/2Kd7kmFepXzXlCSyHYVmdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y3kgHiVG+ohhu+YzMcpN/r3cM6hXzyzIdsHDHTIfFo8=;
 b=buOv7Vq68XLwMcWwMQYD+ht8Fteoprh9Wo2gFulw2kd9L07lic70M+t4o8mpNsItYjSrQUyNkxi7fAVyqGnQMLUm3ngSD1XE4aQQbx6C6Pg8EssDeadsOmmfG4vaGQJF0Gc4vK/IhTaMDMVIYak09VbXsfbObTkzU1A5tCF8F1ziuAtlXtou7rkKjxLphknHq78E8uoquepjwXHsTRnahaI2huP9Rkkxw3I7u1J1nH4BlDlRQSRdCNH/SadUvb0+P1+YytovvVbEOmSasy/LNucTB7GpUlRRqZfxOxUWVVay+BDFR6HfziuLe71d8i02DLUMrD8O9uoaDM0vVNKdhg==
Received: from DM6PR04CA0029.namprd04.prod.outlook.com (2603:10b6:5:334::34)
 by BY5PR12MB4290.namprd12.prod.outlook.com (2603:10b6:a03:20e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.20; Sun, 6 Oct
 2024 18:43:51 +0000
Received: from DS1PEPF00017092.namprd03.prod.outlook.com
 (2603:10b6:5:334:cafe::d4) by DM6PR04CA0029.outlook.office365.com
 (2603:10b6:5:334::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.20 via Frontend
 Transport; Sun, 6 Oct 2024 18:43:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF00017092.mail.protection.outlook.com (10.167.17.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.13 via Frontend Transport; Sun, 6 Oct 2024 18:43:51 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 6 Oct 2024
 11:43:45 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 6 Oct 2024
 11:43:44 -0700
Received: from r-arch-stor03.mtr.labs.mlnx (10.127.8.14) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sun, 6 Oct 2024 11:43:42 -0700
From: Max Gurtovoy <mgurtovoy@nvidia.com>
To: <stefanha@redhat.com>, <virtualization@lists.linux.dev>, <mst@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>
CC: <kvm@vger.kernel.org>, <pgootzen@nvidia.com>, <larora@nvidia.com>,
	<oren@nvidia.com>, Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 1/1] virtio_fs: store actual queue index in mq_map
Date: Sun, 6 Oct 2024 21:43:41 +0300
Message-ID: <20241006184341.9081-1-mgurtovoy@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017092:EE_|BY5PR12MB4290:EE_
X-MS-Office365-Filtering-Correlation-Id: af15e7f0-c820-42b3-7a7e-08dce636d26c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GHvHYCz4GA1gmDCBVdz3DH9FEgsoWQoTs7bbegUdKPZMv3qJj9SpSVv0vgis?=
 =?us-ascii?Q?yE2gUhdf6FWD81Z4G3PKtvaoFL6ypvNli02gO2RUYEscKJva2I6jAjLSc2N1?=
 =?us-ascii?Q?8iMJtRIRy0Ng3e7PPbC84RcOKsJiN9+q3Q8GwcCTb7m9yXJBCzjCIY6qTWle?=
 =?us-ascii?Q?AOW0tuANp67vg/ZXhQcLHTtFDsF6VaLcZDbqoAIWKKUJbXVpv4DRPjXo08sZ?=
 =?us-ascii?Q?GXYYbaWdy/kiy8g9bziz+P0Yq4Ej0tP8q0/0Uz5O+B94k95LCuGPFVeqCjiB?=
 =?us-ascii?Q?hcJkRj1tKP8GLgrE8WWJdic2YFs0PdEtYcKcbj57co9jXHEGQGUYSFCcMYmI?=
 =?us-ascii?Q?uOdQx9dD9oSI+HwxZJ8k+KUufIlpBeXNzJIjj/H72/Hm8x4bltTeEk1mT6jn?=
 =?us-ascii?Q?6JYguMSvBMQhZM9LIQaAxVNaZdLDHqtU1e2+cruHKxvHSo0IOMQouxj4L9gb?=
 =?us-ascii?Q?/1BiFLiIk5jVQowHRt/gLZwx0RByXMv2IcC/DLboRyK3jETnBL6rphXHQo0X?=
 =?us-ascii?Q?dPByTtCWVT9uAifi/qHN1iSHJz04tNxDQspPrUo2FHf1x3ct7mNjxVajckNH?=
 =?us-ascii?Q?iCzQkWIALHS3RYNcKngBNtm28baXBb+VeeDyqyGazk/1ZW6jWyIHb/A1ZyEM?=
 =?us-ascii?Q?9zOc0cpcEKvn+C0vit0MzGOOdRRmjFuuMoxi7AOzAc5wzxdcti+RT8lBXKW6?=
 =?us-ascii?Q?HRszfWN0GAfqXXV543RHwbL8JXfKpOJpRMPXnpidXLb4CSDSIC0sBtnprZXW?=
 =?us-ascii?Q?mJZuIaagF/DWsMJzt0pSALKKTtJC1jZSbK/JX5nn6URYSvCkDTHAe5R4doNO?=
 =?us-ascii?Q?4sJbrR62FxVPrb/8V2KatO+8TLgF/+FLzGqz/hKNSCTINHYnFAmoxPP+QVLj?=
 =?us-ascii?Q?ICtTuuLOu8w/9Cpw1yw2VtAfVv+lumBU0eoO6cA3DajniI0PyjPBhQ+QUz7m?=
 =?us-ascii?Q?vNq7MImyGxiypb8GjF91xC0fNiXN+epcGVuVgL/2JJRJSIbVFlg7/yl7kJIL?=
 =?us-ascii?Q?Utrgz5A3bYhoutiLLOpr1IIM66sS3FD44TfIrAtZqIqt5EdtVUSUO8W+Uomg?=
 =?us-ascii?Q?0Fgl+hwgtpslsx62IOghdovz0QJD6oQIbsyQesMX7rPF/TxgA2SBWrLWilH1?=
 =?us-ascii?Q?lpkChWeMX7euPCIZ01KWPpkEirUwS1FBK/RBmwj+XeOZX5wcJzBcJphoznrr?=
 =?us-ascii?Q?DDzaqnJbk7MPpusrguz+tu7PAYJWpmpN6lkqpUcD/IRKBQ+RSijgk66QZyft?=
 =?us-ascii?Q?iUmOfiJrrx7jOwvbrD8Ey0K6lh5YhCyNKQ90jW7rhhhnyUKcyo944xVS+Sug?=
 =?us-ascii?Q?9bYe5WbmPFAvgefT0p5EXBhNNLeNw6XonwgtN3RtASkngZH0khNwwgyCENEA?=
 =?us-ascii?Q?uQ7XlNgXrkGG+zm2LahghIBQSSzS?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2024 18:43:51.1308
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af15e7f0-c820-42b3-7a7e-08dce636d26c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017092.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4290

This will eliminate the need for index recalculation during the fast
path.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 fs/fuse/virtio_fs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 78f579463cca..44f2580db4c2 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -242,7 +242,7 @@ static ssize_t cpu_list_show(struct kobject *kobj,
 
 	qid = fsvq->vq->index;
 	for (cpu = 0; cpu < nr_cpu_ids; cpu++) {
-		if (qid < VQ_REQUEST || (fs->mq_map[cpu] == qid - VQ_REQUEST)) {
+		if (qid < VQ_REQUEST || (fs->mq_map[cpu] == qid)) {
 			if (first)
 				ret = snprintf(buf + pos, size - pos, "%u", cpu);
 			else
@@ -870,23 +870,23 @@ static void virtio_fs_map_queues(struct virtio_device *vdev, struct virtio_fs *f
 			goto fallback;
 
 		for_each_cpu(cpu, mask)
-			fs->mq_map[cpu] = q;
+			fs->mq_map[cpu] = q + VQ_REQUEST;
 	}
 
 	return;
 fallback:
 	/* Attempt to map evenly in groups over the CPUs */
 	masks = group_cpus_evenly(fs->num_request_queues);
-	/* If even this fails we default to all CPUs use queue zero */
+	/* If even this fails we default to all CPUs use first request queue */
 	if (!masks) {
 		for_each_possible_cpu(cpu)
-			fs->mq_map[cpu] = 0;
+			fs->mq_map[cpu] = VQ_REQUEST;
 		return;
 	}
 
 	for (q = 0; q < fs->num_request_queues; q++) {
 		for_each_cpu(cpu, &masks[q])
-			fs->mq_map[cpu] = q;
+			fs->mq_map[cpu] = q + VQ_REQUEST;
 	}
 	kfree(masks);
 }
@@ -1496,7 +1496,7 @@ __releases(fiq->lock)
 	spin_unlock(&fiq->lock);
 
 	fs = fiq->priv;
-	queue_id = VQ_REQUEST + fs->mq_map[raw_smp_processor_id()];
+	queue_id = fs->mq_map[raw_smp_processor_id()];
 
 	pr_debug("%s: opcode %u unique %#llx nodeid %#llx in.len %u out.len %u queue_id %u\n",
 		 __func__, req->in.h.opcode, req->in.h.unique,
-- 
2.18.1


