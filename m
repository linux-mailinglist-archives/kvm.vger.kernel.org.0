Return-Path: <kvm+bounces-28038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3672C992073
	for <lists+kvm@lfdr.de>; Sun,  6 Oct 2024 20:43:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A96291F21963
	for <lists+kvm@lfdr.de>; Sun,  6 Oct 2024 18:43:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A222618A6A8;
	Sun,  6 Oct 2024 18:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RBQBQdwP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2083.outbound.protection.outlook.com [40.107.95.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221AD2C853
	for <kvm@vger.kernel.org>; Sun,  6 Oct 2024 18:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728240218; cv=fail; b=pczPcLNSrQrb4aL4OCJHGLSarcQOBoygAIjb/gfStt+aTAl55zVAam4YcTgfRreVQNchRKHi+9Tv2h7aolBhobEchUEPw7AFpy7jR13b4yBJ4GRJ2xe+HV7PhatzCXW9x+k2V/TGQ1tVIHBswBIK1xdfQDg3JiksTYx0zpvM6oE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728240218; c=relaxed/simple;
	bh=5Tm9yDk2u3Tc/59BCiv819NpDm+4+ip/BNwTPZWrq3M=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FtEVBfD1zIQAU9WlnGagYy54WzHpZtUZVeb2ML58Uvob5VW9RdyWRX8qM2m1tHQrJd/fJVjM93p+CtN1oMFsNObKBL18fVtS/jlO0CZQZkrnZ+8rjaBfAl2T8zYJlfUESgP3U1qzrrAW6NVESC4I2c1NFPBqIswtRgCVplOnd0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RBQBQdwP; arc=fail smtp.client-ip=40.107.95.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C816oqcYuElYoRRR9NVVrUxVWzhZyGWSRaQ06DY/a5PhwkmKM+RETaWb8F7nf4t+2oanagWIaiQOm/45rbC14tvZ1BxRBb55ceg3DF3+QvC4nlqO6PEY371Gf6MX7sDb441oYbVQTh7TNOPG8klz06CzG31OsIv5T3dtmQtZnu7/pLzPi/r5lR7UK3ZLgUB/BEh0VP6Zbon/uM70bZJfcQbwYUMR7bKdUXKWG2c4UMWbOAAmX+TrmRe2aSILa+vJY44nes1RP5x9QkMNHNfvQ+tbt5rUzv6oEpOwHOK5PgqJJI7PLZxnMTfgJU9CFaM5fVdDRDQUTN+lbw9i55/dfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QJMlM69dnuq5XM1hRa++btzeXy7hX01Way5WLX8M6S8=;
 b=dgkeSg/pFzgtTM8JWLeIpZifiDd1I4DW1+sqXIe+Krgk82wFPpSXoodgeIqORf+vCAVAg2+lKxYYUy7FvI2oB9rqlz/cM/XAsOlAOPkymQrrvhcW+ABiLe1FKQdfDl+pjWnBCClqdDRuzQW7Rv/Iw8gK5w1tK7REIafKesd7OZ6Q0f/HdXYWonUohuHhogCqKs/ZhGEM7pMwIrCtVz1en1tHNpYpr0587PNxXwK8QkPvPNxwQqLtR9UwlS7A8etDYsmWh2wwrlE3YywMorTL4jbbTIViM4BUyJht3WgMKTd4xt4LHjNeoKNh0Rz45/VfslSbqJTmLVqCAafUca56lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QJMlM69dnuq5XM1hRa++btzeXy7hX01Way5WLX8M6S8=;
 b=RBQBQdwPZFsQcFHBnWT5uc80gUWoK/PoB1sGgUT4pcYHhYu9iR271OSY88Q++ffaWop/u0XiV3RCWLWJNxiTLkMz+fOvgTd0j1UAdTRuGq1QyPbP9GegqcaXYhvQAjSFvE7jNh2Z5WtL8rZMWjR0fGWvTNLSRPxuZewE1ohVIXDJIe4/Y2nu0M6fNyPECyvbzF8yOw4ozeLsBobPfJwyyMhGvj7DpqyGG3c5H6TO29Vm2vHYr/cx5+6IcWlHMcC4LOPK8MoT1X0LLLIJhjxuX7DPF0OhrGgbZ0l0S09+227Prlti978BbXodOkmrpASvcjwe0xVM8Vjmy7G/wGzbMA==
Received: from MN0PR04CA0020.namprd04.prod.outlook.com (2603:10b6:208:52d::19)
 by DS0PR12MB8366.namprd12.prod.outlook.com (2603:10b6:8:f9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.20; Sun, 6 Oct
 2024 18:43:32 +0000
Received: from BN3PEPF0000B069.namprd21.prod.outlook.com
 (2603:10b6:208:52d:cafe::60) by MN0PR04CA0020.outlook.office365.com
 (2603:10b6:208:52d::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.20 via Frontend
 Transport; Sun, 6 Oct 2024 18:43:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF0000B069.mail.protection.outlook.com (10.167.243.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.0 via Frontend Transport; Sun, 6 Oct 2024 18:43:31 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 6 Oct 2024
 11:43:27 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 6 Oct 2024
 11:43:27 -0700
Received: from r-arch-stor03.mtr.labs.mlnx (10.127.8.14) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sun, 6 Oct 2024 11:43:24 -0700
From: Max Gurtovoy <mgurtovoy@nvidia.com>
To: <stefanha@redhat.com>, <virtualization@lists.linux.dev>, <mst@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>
CC: <kvm@vger.kernel.org>, <pgootzen@nvidia.com>, <larora@nvidia.com>,
	<oren@nvidia.com>, Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 1/1] virtio_fs: add informative log for new tag discovery
Date: Sun, 6 Oct 2024 21:43:24 +0300
Message-ID: <20241006184324.8497-1-mgurtovoy@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B069:EE_|DS0PR12MB8366:EE_
X-MS-Office365-Filtering-Correlation-Id: 651f1058-63ef-41d1-3701-08dce636c6f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N1WVU6L8o57PztIjrdHtdWl7ytA9QVtxd26vNEPLgHJWL+GeUXxID8XK0b4M?=
 =?us-ascii?Q?kBj/EmTjxnDip18IsGZxEwROKur+HZIg4x+/Y8UUc6MPbT0q2kkvmiJBBieG?=
 =?us-ascii?Q?JRcrWzqZuFGjOoMsl+rYRehqNpuFEG2aQX5jSRVyfhKm57uz3vc4eh+Dzlf4?=
 =?us-ascii?Q?JJpzDaUBKyDu2svvoVMlJIng22rqEcwP5xyTdwW0F4GlrfsZHUYoOD909iF2?=
 =?us-ascii?Q?kizUTIT1byYPBs+t759BHXQ4iHlS0bGYBymh03GH+cO8vlDFrBtFHszh9GKJ?=
 =?us-ascii?Q?07yhaCz364Hsbp0qolIhOovFNNzP3osRL5SxYxzfpqoKmV/dUJeYYKDynUe7?=
 =?us-ascii?Q?fht/DY2UDjmTfJYudD3mlWE4rGc/Y6EzftICwbIYewIgbH1K5vLxKbdgg16e?=
 =?us-ascii?Q?b5muoPcvILpqi/Vr3J2yem+2+SBhAB34jgjlFmwAEWs+3mERZtcTPrwbuQZY?=
 =?us-ascii?Q?FjQ73WtApBgeokUNUeerN+YyYlsK5VhenpHJHw/YGSvcMYsRGS8DdmGwlGhV?=
 =?us-ascii?Q?QXQGfxnvel1cxg6aEXbov4Iewe+L5KaKnrTk/vye2Zcn0Sh8kJEmwk+EsKI7?=
 =?us-ascii?Q?/8LPhM16N3T9DCV1P3AXXPoWkNNtkzBR4wPwTKUfCo5J6KGIQMRp5kEaf66J?=
 =?us-ascii?Q?0kaKKy0bYN99wDhOAi2Na0ZAu5Cj/Tt7NfwHxCY+5SKS1xBXqg7cyIDbtscJ?=
 =?us-ascii?Q?I5aDLQLGOe3lYXm3R7m+poHNpDKcX2L+anp330sBlnA+NomGAFjl6yDgFSln?=
 =?us-ascii?Q?NgtPm4KisrWcOakrfQyxoi6YIFvvNKQAzYQXYgLft3kHyO2SwPM5xPbakD2T?=
 =?us-ascii?Q?6uONb9uxNbffm5SVXzM0c0jACtPtJGFi2Zqn1YHWjn+sCPILhwCXDaOySAKn?=
 =?us-ascii?Q?zjCkkDZPku0L+km+76rCINoPz7UQt2t/lFyUqnpKbXLmE7jaWldk81lNdoY6?=
 =?us-ascii?Q?ENSxFpKgK9RX0VrqUtS1Dio9g0ptPn7XWgAH3zL/4qAE+U9Cv2ShGFxQK15o?=
 =?us-ascii?Q?mMNmkcbQ9KiM38EnlcgSOC1Z7WZG2TFs+nGV4M2SEymq0FeNZtPWLmErSrKz?=
 =?us-ascii?Q?L+LU1GaWGDeeUOsBgpAJb7pB9CcqDMzJSzw/o0c2EMb1ECRl/vcQUbmjcgnQ?=
 =?us-ascii?Q?eAH1t8YTddLL/3q0u7/2CETC0qRkJsbTDRYOGjvTY3sRfbxpOF6+NzbNQ8Fe?=
 =?us-ascii?Q?+fYb0lG9NFwZPq/u6a9E0tXDXw9IgFI5Yw/ey1B91QKn/5bLKDurjPrA0iGq?=
 =?us-ascii?Q?CVozJnCOIO2AYOpvYk27A1JjZsBh8wPlRnyvEWFkLvO6I7p+9NBD8plL1i5A?=
 =?us-ascii?Q?xFkQ/iWIjOTvFvFzpQTdf0baE//begX+jI7MderhGOySxQo74icyLUdWCJUR?=
 =?us-ascii?Q?GeXuQ+Z8peZm6Dkw2+xwDjPb+1/r?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2024 18:43:31.8252
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 651f1058-63ef-41d1-3701-08dce636c6f4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B069.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8366

Enhance the device probing process by adding a log message when a new
virtio-fs tag is successfully discovered. This improvement provides
better visibility into the initialization of virtio-fs devices.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 fs/fuse/virtio_fs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 44f2580db4c2..e2f48a1c57ee 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -521,6 +521,7 @@ static int virtio_fs_read_tag(struct virtio_device *vdev, struct virtio_fs *fs)
 		return -EINVAL;
 	}
 
+	dev_info(&vdev->dev, "discovered new tag: %s\n", fs->tag);
 	return 0;
 }
 
-- 
2.18.1


