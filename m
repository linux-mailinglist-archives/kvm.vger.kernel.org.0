Return-Path: <kvm+bounces-39059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AB5FA430EE
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 00:32:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5601E3BA37A
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 23:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15640201001;
	Mon, 24 Feb 2025 23:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="D4IMgbnU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2042.outbound.protection.outlook.com [40.107.223.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963F32AF11;
	Mon, 24 Feb 2025 23:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740439904; cv=fail; b=El5BqJc4/r8XbKJ9S4/wPJyhd9EHkONtUQx3Hjmp05hXFl4OcNAn5EplZMnwTHGYZ+BwBTHYccaqsgS8MpdAxMAK5kMBML8Jw57V84AJTa2ZuahaIUp+B3CryO1XOKgGDdC9tFL2tDuKGOyOstq6drpG8rA40pTFjmin0JODFBQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740439904; c=relaxed/simple;
	bh=qo53dlbI2mpVxT6tAWyLu/w444dNaR5mjh+tDTVrCFg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M4D7Op4LaCX+HhGmFkBNnk0q7pQOXeqNm7GdWApgdgy2LnWkgzxd3k0Pg05rbgMDoonM1uPjGO/JX8eZgZGEETObfEO0wNb2orUrDwFcmhCM/hyN6x0jj1JNnTN25TKke8Iyz+vjaDEkO5q1ALW5B8S6rIVMbb9K6/Qk/VKTCs0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=D4IMgbnU; arc=fail smtp.client-ip=40.107.223.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xwrBH3mQJyVe2AfvA0Tyve94bKxhEqrwzvK0rdql23uH93K+YRt6oS2FPZL3h8/kG0JHbJyAIUrjAgh3d3HgJcDk+7x/a15+xQUKjgylfMnGug1SCnf1jAHzcenRomEjigD2y7hMNbjgdNmb7cVdh7STBzd3hO63+D/Gfpxyk796mDWJ7nUoAko9bKyyuUU+hymTnNN2tjoONBJiRyaA3ucFOzA42xVzYHIkrKTiHsVQPPlv4iQklkvZpKMYEoSY2JsCwrGCNQYD8gJXvVXGzeCM8C09HDinNc5tSvswMSNYkxyiCEygbz1AEGeXZ4q2zgnyQ+WIE/rPI6A4bphxUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j3RIzFdKQNFYVEcaRMQRzutkh7WzA76YfaFEgkPto9w=;
 b=rzoDWFk2syU+nu3pyLZeb7gwC4QXAuRMTm0Ly88aKXNBGZhJ9ugo7QxjbW/JLrUjHDOJxKb+Uf382v0OjQgoY8fTVrBfkfE+31XWtZVP0ViIf1BGMKKBCC3o+sArZQw0uXlI884g5Y2GMvZ13qdRxWgPBZFWGxndSupIhVPfiQ1z4CqdJPEVO7YwAbc51rzbSRTulLWzodcibTbMOH1/SI15mY6zIIiSWCDWRJw5XLa47ma3T0FM/IMSYWvqKOaOsg9zoBKFQnsuKHS52ktr2vyousxDPEwGoL/1P0O1P19NYRGqxGch2wN9B3JXTjuHV1fOlakEGIcVrz/yQ4fmJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j3RIzFdKQNFYVEcaRMQRzutkh7WzA76YfaFEgkPto9w=;
 b=D4IMgbnUF9OvhR6TUa2Y345tsrPnjPjtRClO3Q+ts3gMyRRWQcnjXbYqUBW+bX3H/LNI5cISI8W0JbKhG5Gwt9Md7Cd48ZiDeHgE0Bt42e4yK0X9hOpNoiIMKWWAV9KOVz/HsHjIRzcGBj7wVzsOgDtO46O4GU3Gpz7Y9JoLWqU3InaB4B1od0BkDwXT2aQZzhiMUewagJF1D5oBmlR4mfXJI+HhKdq9+dH7iYrWlBJjI9Bur9Cg8l1U9CWSfLfSvnnSHcKjrz8Qz6fBqfmNqolhuDkJjM5Uk3usjHtEso9AvWVBS2Xq6Qw7J4GKl5N5yF2pJ1Ey9QNbN22RvVrKoA==
Received: from CH0PR03CA0433.namprd03.prod.outlook.com (2603:10b6:610:10e::18)
 by SN7PR12MB6691.namprd12.prod.outlook.com (2603:10b6:806:271::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Mon, 24 Feb
 2025 23:31:34 +0000
Received: from DS3PEPF000099D8.namprd04.prod.outlook.com
 (2603:10b6:610:10e::4) by CH0PR03CA0433.outlook.office365.com
 (2603:10b6:610:10e::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.21 via Frontend Transport; Mon,
 24 Feb 2025 23:31:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS3PEPF000099D8.mail.protection.outlook.com (10.167.17.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.16 via Frontend Transport; Mon, 24 Feb 2025 23:31:33 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 24 Feb
 2025 15:31:18 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 24 Feb
 2025 15:31:17 -0800
Received: from r-arch-stor03.mtr.labs.mlnx (10.127.8.14) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 24 Feb 2025 15:31:14 -0800
From: Max Gurtovoy <mgurtovoy@nvidia.com>
To: <israelr@nvidia.com>, <stefanha@redhat.com>,
	<virtualization@lists.linux.dev>, <mst@redhat.com>,
	<linux-block@vger.kernel.org>
CC: <oren@nvidia.com>, <nitzanc@nvidia.com>, <dbenbasat@nvidia.com>,
	<smalin@nvidia.com>, <larora@nvidia.com>, <izach@nvidia.com>,
	<aaptel@nvidia.com>, <parav@nvidia.com>, <kvm@vger.kernel.org>, Max Gurtovoy
	<mgurtovoy@nvidia.com>
Subject: [PATCH 2/2] virtio_fs: add length check for device writable portion
Date: Tue, 25 Feb 2025 01:31:06 +0200
Message-ID: <20250224233106.8519-3-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20250224233106.8519-1-mgurtovoy@nvidia.com>
References: <20250224233106.8519-1-mgurtovoy@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D8:EE_|SN7PR12MB6691:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a1e2d6b-5767-464a-a66c-08dd552b6013
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TnN3qwjLSgO5e6bi6V4CN0cYqRhJvKw4CJHu5UInUySy+CAJ4gczgDhE9yZD?=
 =?us-ascii?Q?XPRRQEswYDV/e6NQJMmqlqvaiWBUkSmdLnk78nBUGOrSWSbCuckc3xDk5tY9?=
 =?us-ascii?Q?X/RYZFToAu7ayYzwAfowFekc2hDJMP9Axk+E+clUBXrOxmDieS/H7zgxC+MM?=
 =?us-ascii?Q?04QAigJ6AAnvyNJakVREB66CgFGMq0/x7IR90wd+AQS7eSnM2G5ScmbHVGTU?=
 =?us-ascii?Q?YYO0Jw0Mfv3962ndVbWHcHY17dNQZc7AjRyFYDNsYPbxONZNmAdz16x3qySp?=
 =?us-ascii?Q?/IH6i57dEQqlnVUJZ2Tte8O3Eu1Wy0TUrgw/uUnJvUwr3fREfDcMBaEGdcuM?=
 =?us-ascii?Q?f2irox7ik4FIoBC2FH8IKUBus2aB4Trx6rZ/O7YMT/CbgSLX/cSVB67TMkI6?=
 =?us-ascii?Q?8Mq9hvW0wqTnH4ZX1umx2/VdjwTN9M+Nl9lqZiSrOBpTZNsuzg/S9s26kHtL?=
 =?us-ascii?Q?bvtRyYcj8ovvj1lx3OU8HMnvb9w039mpVueovGZolpKV2HJ/w0f59k4g0GQb?=
 =?us-ascii?Q?cUemkB3XilOH3n47BTiQbVqqtrdv2q908hLhn2dJPFQdcN7pnxUFCzj6cWw6?=
 =?us-ascii?Q?gtGYae6kEV21KfKN+JdSE/1Uw2AhER6Ypz+mee2gL839E2N231SbcAVwKicS?=
 =?us-ascii?Q?MVuz6S5uDzR+0nYrvESJbP1z4LFJVYDDHXhKWyEwCzTTOASNtr3b9K6rMlGe?=
 =?us-ascii?Q?cahKdevep8nI6CEeklylozud/9oNk/vhgooaYRHcJnSOki4UfdPJGwKseKd7?=
 =?us-ascii?Q?2KDrNxz+y7lF1Pv/kpg6/1hwKccW85xsfXxCtqq/rgZWIOPGivupcNwca1mE?=
 =?us-ascii?Q?m3ghAYh+mEq0llV58egpEVOpx+ZYNkEDLfrwk+AeGW4HOZbmxIBku8eWzT2K?=
 =?us-ascii?Q?hbxOsrNPBUkgtNgwTj4xCVA8BVqI0Qn19xSxRV6CpbgJ8kJ9vuw/B9sN7aXh?=
 =?us-ascii?Q?+i0VqyHQpPaV2Xke9tyHEzcLBFmoNwMmGF8nBQ9r0P2lmtyMDVJIctxdfJX+?=
 =?us-ascii?Q?SXo0NkEL8XfLpXOfwDEP+5z6fjR3GZDIYcXuEpRmqrVUbfHsmhl778oOM15O?=
 =?us-ascii?Q?7BxwHW5DkL9l1iqRqx4DXiHNrNmqXiNV/7v1XH/f/Oz8u9f2IkqhU3AFYh5S?=
 =?us-ascii?Q?pNWCZN09a4nGxIqWIc8pdOBxBWo80vpLYgw4pENlhSx5QXHowc0PC9bt7KWq?=
 =?us-ascii?Q?0grupkruZ1YqKiZMIVrPy2SJEti5G+s8EP9KR/LJAbXV/7EzbadbfdFYqj1k?=
 =?us-ascii?Q?q9dAibuMY98b5HP0Vpo7myKN0vKKkamwhXVLPUp8FMwNe0oeL91KBC7dACgO?=
 =?us-ascii?Q?/QU34a4z2Zae3dKOxVPiYgvTrKlzm+Px5JAZL5CqnMESzkqSF3HjjjHbaimr?=
 =?us-ascii?Q?sj85VZ/uIIrfnY9y9+5FwCrVJKlojk/YRVz5svz3V0Viws5V1PPT6NP65G6n?=
 =?us-ascii?Q?ThnD7A7jhQjdJtoUu/+rhlPUQ17v+UMbf3HR5K51aKkGLXYzgSIIRenu47+d?=
 =?us-ascii?Q?xQN+4ooQFVgc/rQ=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 23:31:33.8927
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a1e2d6b-5767-464a-a66c-08dd552b6013
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D8.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6691

Add a safety check to ensure that the length of data written by the
device is at least as large the expected length. If this condition is
not met, it indicates a potential error in the device's response.

This change aligns with the virtio specification, which states:
"The driver MUST NOT make assumptions about data in device-writable
buffers beyond the first len bytes, and SHOULD ignore this data."

By setting an error status when len is insufficient, we ensure that
the driver does not process potentially invalid or incomplete data from
the device.

Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Signed-off-by: Lokesh Arora <larora@nvidia.com>
Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 fs/fuse/virtio_fs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 82afe78ec542..658e51e41292 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -827,6 +827,15 @@ static void virtio_fs_requests_done_work(struct work_struct *work)
 		virtqueue_disable_cb(vq);
 
 		while ((req = virtqueue_get_buf(vq, &len)) != NULL) {
+
+			/*
+			 * Check device writable portion length, and fail upon
+			 * error.
+			 */
+			if (unlikely(len < sizeof(req->out.h) ||
+			    len < req->out.h.len))
+				req->out.h.error = -EIO;
+
 			spin_lock(&fpq->lock);
 			list_move_tail(&req->list, &reqs);
 			spin_unlock(&fpq->lock);
-- 
2.18.1


