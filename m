Return-Path: <kvm+bounces-55885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEFA7B38512
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 16:35:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 580CE362719
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 14:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BB0B1FDE31;
	Wed, 27 Aug 2025 14:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BTll5K0h"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F0C1B4F09;
	Wed, 27 Aug 2025 14:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756305296; cv=fail; b=OVOMKZL8jARRXArkxmjN8W8xx/VcRAWzCzeWl7r5WL9C9g97Zv8J/r8Kc9lX3ktWto/t1CTYfEI059rftTWnf5jSwRFW6+uAjLfgwjmpED9yGv8YyFqxVkssw85qvXB6JKhc1wxfhIyi1yrvXYruEx4d//x3d6nWkMZs6LHdj5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756305296; c=relaxed/simple;
	bh=accLb6bSj+jE9Ip3l25x1+5517ZdR7eVNGP046kxa+U=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bV8RiDV8O3/fOHNZg63Fo+pQr9frAwaJlCIVw3WTQre1z9m6u253HPi36cfZVmNgrp1bQMmiFwKt7DkPwHerjCO6wWIhgHfr6vj13Jsd24G/vmnbVWMp1r9R4asCHtaH+r8I7+CCpW8csPJSgp/RoiM1F3F7CknyuxspMQ4JQ5Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BTll5K0h; arc=fail smtp.client-ip=40.107.93.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JBVTuFBgdr4XJgm7c2trlT9HuF8vyYIvK7bJFEvQc5G8vWbtyEfhJe142KbveLwmqoeqxS6ebkDfubWrGzup6EWcEHtr4shI09Tmvk60L678U8KLglE3fo+e92OFGZ5AYF5NsyEg2unCkFb60mIWm1KahalqTtKFJDlF0zCKiPT9iP2Asx+TkUegnM8CdTU7iYkMwxortDv9SOPTFfsQ92ejHpD0DWaE5tGqtIHDbZjBr62ru0OJu6vT1xe3Odh8lnG2/2vhttcnIbduVXV2gwltXXr1i9p0+tJv/zHnxnQz5GwB7ChXUNPnEhW79tTgVLwpCLRznVV6b/ybKEqieg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zaW1MnGp24buxR0bxkYgTIR9ORRLquub1QwbQ8W/tB0=;
 b=tCs4+CQsaPsdPVvQItdonnN8qfQyvD+zba98zt709bG5f/l+AKDkJ9XtkAoYRldDm//fLq9V/9ZY13vap7Svi3m+wt2eyjcX+wP8Rax64xdBq4vvY7k+rP8NzGAyKbDP+CG7a4DGGvCEBi1VYco2PWh1W+JwyeEO+sbjejVcJzxIyxVrfr3XF8RN8FPnIVDj62YLVf3Gh7fnQpUgdCQKkXJ9fQkaR4BnZKIzKzgbn+3H++0i7s9H8mW7vWpgfw8GrWg0IMjcJDwdpuGmdZPdCjFgUtudlSrnjc+BdoZh38gWueJLvnYCOiZjyBYg7xLChKLykBTc1A1DcNu4admw4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zaW1MnGp24buxR0bxkYgTIR9ORRLquub1QwbQ8W/tB0=;
 b=BTll5K0h0pRawoDhSKUJoGCXgqrMpxeQqti3KchHG9E9589FESY7IW+vmJ8o3IZXF3OGQpeokUyNk69Q8n2d+3Vnx7a39fRsIE31p/ZLhXnwWmn1p4L+Dc/AUXQXzC13nrbUY9Mq2XEqFldoWZGoRTPgqeMklSRTUDBqSaIuvNJbxe3NkvMiyEC9ZhOSTRIvvpwfe/R1iQbU+6UFywiZrpzrsDTTIkmKJMLFUnlhobuakjQnjDlI7hzlUlCKxnu/3OoydtgviOtmE8UmK9eSf4yQybfWJK6jp3r+9iyD7bDEX0m2a+sWS0yl/qnbv0TXLavvmh3yp5ePOuIijScdlA==
Received: from SJ0PR03CA0124.namprd03.prod.outlook.com (2603:10b6:a03:33c::9)
 by DS0PR12MB8043.namprd12.prod.outlook.com (2603:10b6:8:14d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.19; Wed, 27 Aug
 2025 14:34:48 +0000
Received: from SJ1PEPF00001CE9.namprd03.prod.outlook.com
 (2603:10b6:a03:33c:cafe::10) by SJ0PR03CA0124.outlook.office365.com
 (2603:10b6:a03:33c::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.14 via Frontend Transport; Wed,
 27 Aug 2025 14:34:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00001CE9.mail.protection.outlook.com (10.167.242.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.11 via Frontend Transport; Wed, 27 Aug 2025 14:34:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 27 Aug
 2025 07:34:34 -0700
Received: from NV-2Y5XW94.nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 27 Aug
 2025 07:34:32 -0700
From: Shameer Kolothum <skolothumtho@nvidia.com>
To: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <wangzhou1@hisilicon.com>,
	<liulongfang@huawei.com>, <jonathan.cameron@huawei.com>,
	<shameerkolothum@gmail.com>
Subject: [PATCH v2] MAINTAINERS: Update Shameer Kolothum's email address
Date: Wed, 27 Aug 2025 15:32:15 +0100
Message-ID: <20250827143215.2311-1-skolothumtho@nvidia.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE9:EE_|DS0PR12MB8043:EE_
X-MS-Office365-Filtering-Correlation-Id: 50ed8757-a5da-45e6-1d56-08dde576e003
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uXf5E/OhZUqqzVzMPsal11zB5AkeRRPnIWD4oHgBcgjCFJaTIOPQONs0laTX?=
 =?us-ascii?Q?6SqHM6BEw8PLW5zZXMbAcYfT2w0TLCdelWMIjIHk+aFJFzcJKtsbvBtcI5kP?=
 =?us-ascii?Q?RofQjtILq/fLtuKY2z8ZXvdpRSV40XDQeJMPdCJ3FP6cAFVO2MEyt+uPZX+L?=
 =?us-ascii?Q?SBqQfgjYmRi98PMu7hWzX2xNjQiMBB+4/1pAlTl+wBdF/EUNgAwrTfI6L2X3?=
 =?us-ascii?Q?7deE2/lWHl8svXiNhBAAAZ6YGTrrFJKcFQsTuVHCz4eRX/qGO2uoKmayqDG5?=
 =?us-ascii?Q?q6pqEVRO8XesMYLOq+11+TM076gAUVJ60vBUfNMcXbO+Y3rQOpKK1nPYrUot?=
 =?us-ascii?Q?pot+J1q8uVsiUgVuglwPdUXHGQaCcm7EhTEC0PWG1YSx/V1IlApNjhbehUED?=
 =?us-ascii?Q?bjCPQJQM4Me3BqVTA2tO14p6PdyM2QEKXtzwVCSmpVXSMobAJSX1k6fyB55m?=
 =?us-ascii?Q?NTty4Pun3jcTBOzDIrBh8o0OnxcaTVw6ZZBiRUBxnn/9EPEq6Od9noHicMY6?=
 =?us-ascii?Q?+4wAq2aHHXrxZ5VTYyT7yn/oH3f+n/k3IDZhIBmEuPOTtog6cejRP08tCuv0?=
 =?us-ascii?Q?dQXooS5mgNRoPOPOwfDVDllTfsS/PSKlZ+XOfDtr2dOYvjSpBrd/SOQOciZH?=
 =?us-ascii?Q?UrfjA9rUZdYVonm6hwOiuvBA4YZomJrVIq6mxNKlFj/qydaAJo+XdckO72qb?=
 =?us-ascii?Q?I156o8qRciQegSw2Z0gW85YqAfhDf/UOMog8/KhGBvIIkoBVkaCdO4e2YpzH?=
 =?us-ascii?Q?3upyQNhxaWdsX8Gy73u8gNqbZVxt2Vc4LqzcPjEdTwyplJAwzoUKXE6W/8eJ?=
 =?us-ascii?Q?JNQ2gq/wa9ozooub/3GPiiwlsGZ4yEk1ZJLOVT0Zs/yQ9vcQg/3xQNdBtnig?=
 =?us-ascii?Q?AUqyjiLuWU1+YW6kQZd9m4uv0O8tMo4AoclSTkyDF2gcQiHXSvKq+NfycexV?=
 =?us-ascii?Q?zU+5yahOFdMcwh2RmKwdCWrZXXMEJRIOkkhNrAMGwfrrh2+pe7uQmoeKIk9x?=
 =?us-ascii?Q?ttICtpkXtZY/eeoQtvwavGsl7eBSzfb8z/0bH+Mnul1UmEoF6xkUnLehHCkp?=
 =?us-ascii?Q?p97yylpMk378Xe7C1wYMvmW4Bp7V+amqhgWtT/OfxbCHT/J2+ynp1tTN1JQV?=
 =?us-ascii?Q?rzPWv0zdp46XwIFzb+8uj9Nmf1tg0SwYHPyecsvk2ZHQDqTpN55ENBI43lvY?=
 =?us-ascii?Q?Ps/pr5LJmdFfl9x8WUMlblJoJB9GYT1JwSRQOpuOqS3xS2AkGG7UGvYu4Cwa?=
 =?us-ascii?Q?BJcYiITc/M0PsOTGb8WL9trEA1ihQupiPAyGDJkOSvdA0G1AoyqOwHa/dbPT?=
 =?us-ascii?Q?3d+LU1PZneOvPhoXGYJ1OLlnOZNIoyxaumKs9ADMvLbrM3ncESxPXghcPkEP?=
 =?us-ascii?Q?73K+/bqz/eXQeK7WjSIFPG4XzKO5dqSHE1hwXCBuPWh4fM3Tru5S+ZbpVSm3?=
 =?us-ascii?Q?B4Ow5U2D8UnbHVED21WfyzPxeVce+8SsFZT80z0mDuWhy/UeEFoemeFCE2Ol?=
 =?us-ascii?Q?p0llVgIx17i+zrBjk2E/dW6QCb3Tmu9PO8Pl?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 14:34:48.2871
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50ed8757-a5da-45e6-1d56-08dde576e003
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8043

Changed jobs and Huawei email is no longer valid.

Also, since I no longer have access to HiSilicon hardware,
remove myself from HISILICON PCI DRIVER maintainer entry.

Acked-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Shameer Kolothum <skolothumtho@nvidia.com>
---
v1 --> v2:
 -Change from personal email to new emp. email.
---
 .mailmap    | 1 +
 MAINTAINERS | 3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/.mailmap b/.mailmap
index a124aeed52a2..12caec550f9e 100644
--- a/.mailmap
+++ b/.mailmap
@@ -705,6 +705,7 @@ Sergey Senozhatsky <senozhatsky@chromium.org> <sergey.senozhatsky@mail.by>
 Sergey Senozhatsky <senozhatsky@chromium.org> <senozhatsky@google.com>
 Seth Forshee <sforshee@kernel.org> <seth.forshee@canonical.com>
 Shakeel Butt <shakeel.butt@linux.dev> <shakeelb@google.com>
+Shameer Kolothum <skolothumtho@nvidia.com> <shameerali.kolothum.thodi@huawei.com>
 Shannon Nelson <sln@onemain.com> <shannon.nelson@amd.com>
 Shannon Nelson <sln@onemain.com> <snelson@pensando.io>
 Shannon Nelson <sln@onemain.com> <shannon.nelson@intel.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index fed6cd812d79..ad64ff35a1b2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26448,7 +26448,6 @@ F:	drivers/vfio/fsl-mc/
 
 VFIO HISILICON PCI DRIVER
 M:	Longfang Liu <liulongfang@huawei.com>
-M:	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
 L:	kvm@vger.kernel.org
 S:	Maintained
 F:	drivers/vfio/pci/hisilicon/
@@ -26477,7 +26476,7 @@ F:	drivers/vfio/pci/nvgrace-gpu/
 VFIO PCI DEVICE SPECIFIC DRIVERS
 R:	Jason Gunthorpe <jgg@nvidia.com>
 R:	Yishai Hadas <yishaih@nvidia.com>
-R:	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
+R:	Shameer Kolothum <skolothumtho@nvidia.com>
 R:	Kevin Tian <kevin.tian@intel.com>
 L:	kvm@vger.kernel.org
 S:	Maintained
-- 
2.43.0


