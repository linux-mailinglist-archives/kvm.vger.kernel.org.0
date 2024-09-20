Return-Path: <kvm+bounces-27230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF8AB97DA9C
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 00:36:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFD12282946
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 22:36:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F61D18E05A;
	Fri, 20 Sep 2024 22:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iFtSvEun"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2055.outbound.protection.outlook.com [40.107.243.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352EC18CC00;
	Fri, 20 Sep 2024 22:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726871724; cv=fail; b=UfMUwtWJghtsv/QMUB7b63AIYZhn0mCTpgVpUq4HJxZqrzXSGnWFKMcPdEtF8O7cYJI+n6kyjbfWvNLd/17ZMji7q3BVwvI6O8zGUGJWFJZeUYzkv0nvpgeVOqPI0Vp4lu7+rtg6sN41z1EQYWGwpFuflSgeXyytRxCXUt3OobY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726871724; c=relaxed/simple;
	bh=qOIXDRWqrqQFaJlv8C7IjYxLbl/RtTo70JRPoz7AhYw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mu3hKC64RggH2wzlSEvP1cCj1wupLkOxSoaXVzWP/UGUJc+nsvbakEdDSo6tb8B3XzM6BgmaDFqWL+aXyCBReYpOew/je1O+s7zohd3H2ZwYrui8mSqH23gZAyKbMXugJf4oRM2IgP8JPALTIHWxK5kewPAJZLTN3iH8tG/krtY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iFtSvEun; arc=fail smtp.client-ip=40.107.243.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EkY3h31HBIoH/s5Tdt2Rl6QY14jRIdaMzJHdRQhDxFSK7AwOh8mrfYFEUKWhhIFnA3m47wTeD2uHG8AnekL7ncsa94dZwgFzm/eJJhejgSB90gRaO0f5WZEhmSHjelBi3xzldPQH1OxFjy/LZqz/Tome0fi2yCo6H+i02hN7m2UeVE2bekmcHu5+NpEdQiPrLjJEI/g6vdTJ3/ilNEwObfnMS8loCBjE8E1SDQ+dUqrv4J1kvyn9ww2UC0X79KiUFvKyXQmZdFenVZ6CG2/dqAyCbtUuJUotvl6woRE2i/kQGX48MbQGnemkh83f6VmpbbuzxZ4IIqpz79Gdtap1gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AOZg+9wRzHQZcXEu+6gWwHdy1JYiCQwiZ2RQzNPHX8A=;
 b=F04XtLU8TmzmUHWqKLh+yczmRdiYxcSG/ZP/kFjSi2CuEi/QHZrWHoV6d79WHE1/YoDnNwJf71A/IFFxuq9sL9UuhME7moghKtGhkhHwl8VBPo3nS1cGdnGUDvwoCbnvzn8phD39WwuzgZM5v9bfgTbS71c7+l+wA7J22kbmafNDII9A4nllSkn61OQMyjDuXK86u1lnabIKuUON1jhnsiIw62QTxopGyuRE/ZRgrJBMN3EJdtHv9nAknCFjt2VTqt2hR5Jh6/sGhYV14fQlgknoowIPEvvbezk9Pbuo65mFjKuqyo/XC3/Nsq4W1NykgjmDu/D63XRZ9t847oc7tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AOZg+9wRzHQZcXEu+6gWwHdy1JYiCQwiZ2RQzNPHX8A=;
 b=iFtSvEunzPlBUZVo1vRwgDKG2SIutyXm+VMNiI4ONhWvSZp6rBqKunokuAJERWvoygulnSZTtx1PcI5kwTJOAOk7PCGe23QZu5niLTWsOJQlqelE8UPwM2ZDj5iAqxXpDmdRhdizyb1VHZO7n68HRYvQiCHGuvbAuPFuh0mBuny5Cy4Xpl7K45LlAGjpcjecG28CP1oklZVMaEz4KOKCe4NS2YdORa/U6skWmL9rAcPVyaWe45glm/ErhcSF2LKq67nhI+XyeNf0bp4S3ctgTLSNk1gRWfs2XRwh0Sj0L6xYciKOfohsh8lStLpnJ/DgKgxJ52vA1vNnRzbd3NSFxg==
Received: from BN9PR03CA0685.namprd03.prod.outlook.com (2603:10b6:408:10e::30)
 by SJ0PR12MB5635.namprd12.prod.outlook.com (2603:10b6:a03:42a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.24; Fri, 20 Sep
 2024 22:35:20 +0000
Received: from BL02EPF0002992A.namprd02.prod.outlook.com
 (2603:10b6:408:10e:cafe::17) by BN9PR03CA0685.outlook.office365.com
 (2603:10b6:408:10e::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.25 via Frontend
 Transport; Fri, 20 Sep 2024 22:35:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0002992A.mail.protection.outlook.com (10.167.249.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 20 Sep 2024 22:35:19 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:35:04 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:35:03 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 20 Sep 2024 15:35:03 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <linux-cxl@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<alison.schofield@intel.com>, <dan.j.williams@intel.com>,
	<dave.jiang@intel.com>, <dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<ira.weiny@intel.com>, <vishal.l.verma@intel.com>, <alucerop@amd.com>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 10/13] vfio/pci: emulate CXL DVSEC registers in the configuration space
Date: Fri, 20 Sep 2024 15:34:43 -0700
Message-ID: <20240920223446.1908673-11-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240920223446.1908673-1-zhiw@nvidia.com>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992A:EE_|SJ0PR12MB5635:EE_
X-MS-Office365-Filtering-Correlation-Id: 8945d7a3-2ca6-4203-a575-08dcd9c481f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HvPNNXsCRKTJowPcuNjdzej/pg72+JdpeQG+PsaQYifTh4D1FntVrw9I/DG4?=
 =?us-ascii?Q?h3XX/HPv4cYLilcZgj/ZJIXDfVo7KnM9AzWcXnqpfXI8DvJmnW5Skd6VRcNw?=
 =?us-ascii?Q?NG8xeQfjSqyhuUytYAAyTxmLkE0ZIhNLT1AM3F6Gbb4FmPZgjsZobaMyYaXH?=
 =?us-ascii?Q?s6azjJ1KilT//4iGHMQ7fHrWAm5lHbmMWVqgwAwaUvBrDeSg0NyeQt1y9Nr8?=
 =?us-ascii?Q?pFq6aisoT5NIh7hF90BKicVnGoYRgk4Ch0dRY4P/2Kqwnn0vHdur4iuc091O?=
 =?us-ascii?Q?4Ywdtg4TKcqtoIlcltr4zcNNT87kbZa0fQNHkICECDPYiqI0HpUvICTNQrpc?=
 =?us-ascii?Q?W7qwnxtZtSaeG68IC+kg/74qnMeTLu3dS5NasA1/KgMd75GLPolvEabKZpFD?=
 =?us-ascii?Q?wq5EvLUWnHpt7ZQYN8qTLfd0armTgcDZjdS5FtBzj45z8TYG2kkKXZ9v2mun?=
 =?us-ascii?Q?dOtWnWbOXp4vuTU0900qgOGIvib9aLugxORru6zXgEHkA2c8iP0djXitdis6?=
 =?us-ascii?Q?q6164gS+bHALcmKmek6eDWv8HH80VtEPxxn+f9+9tBa7Kdg2NSr4HYsctlOb?=
 =?us-ascii?Q?s1SgoWRshBVg5VNUN3Y2KTaAU4p/Iosd58LhHliv/AIVJQ9dpB/EF+9bV74+?=
 =?us-ascii?Q?dExR+/vronRCFPpqVpkKRQyujpuOOjGxU1pQ+qkdP/jpkmiLXmF4ixqki8RC?=
 =?us-ascii?Q?02tXN9aS0VUiaRJomkMvsvzOhx+cCz2Ny26dfVi8gV3rYVWiL4vN6xrccDZ0?=
 =?us-ascii?Q?UDlYLGQ/druyTo/iUzswBu/seqMrY4iSGpftq/uadjY5t8JWQ1hFSg4pqrjY?=
 =?us-ascii?Q?dL7scAOjZIYGwxjm9lb6xSWjX5wELASabWkOluJOVqZbbglK+G7ENHSlecvn?=
 =?us-ascii?Q?rsH+Tb3uB02R7fvt35SDQSZsaSTp12G1xFIYjX7J+ouDgmZ8Raglr44PF+t5?=
 =?us-ascii?Q?HUANyn6naN5flqrCxiwiAHf/4yw/zSSIIzIBW0W8N1dSYkHgnAm6Cn4oBErt?=
 =?us-ascii?Q?N/huzxoI6DkwEijz9PmSgKU5bqnBI07pjO0m0edlxeJrR4HkKbQtMJNGKTkz?=
 =?us-ascii?Q?qIvpogf0UorOnayufyzMvJzZamRgCwAGlbFEnvJG2dtxCj15zlAn2KYBX33n?=
 =?us-ascii?Q?t9gbd6+yTXhzt9PIZRNMrWlAsmy45kw8gAL3MSusExQH5MRKZ8YSXmVQ33BC?=
 =?us-ascii?Q?1ujKjcIuFWu1/H2P1t/AN8QOrw0wP0anM8jOpG6b3kVkY9KUCbf2gQWn/hy7?=
 =?us-ascii?Q?aKPE7+Wxhf5F8oRBf82Jz31JAv9tRcxiiFD74yAlasYLJbml48rwALSBf5Jj?=
 =?us-ascii?Q?kqDqMb49G2a118Dy+NGYStF0EMLjPAoB+D1sBd63Le5lP4voyUGwP0KEZwb7?=
 =?us-ascii?Q?AprzX110tMbmenPzaTKKOuPi2tya?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2024 22:35:19.5513
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8945d7a3-2ca6-4203-a575-08dcd9c481f7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5635

A CXL device has many DVSEC registers in the configuration space for
device control and enumeration. E.g. enable CXL.mem/CXL.cahce.

However, the kernel CXL core owns those registers to control the device.
Thus, the VM is forbidden to touch the physical device control registers.

Read/write the CXL DVSEC from/to the virt configuration space.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_config.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 98f3ac2d305c..af8c0997c796 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1902,6 +1902,15 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
 
 			perm = &ecap_perms[cap_id];
 			cap_start = vfio_find_cap_start(vdev, *ppos);
+
+			if (cap_id == PCI_EXT_CAP_ID_DVSEC) {
+				u32 dword;
+
+				memcpy(&dword, vdev->vconfig + cap_start + PCI_DVSEC_HEADER1, 4);
+
+				if (PCI_DVSEC_HEADER1_VID(dword) == PCI_VENDOR_ID_CXL)
+					perm = &virt_perms;
+			}
 		} else {
 			WARN_ON(cap_id > PCI_CAP_ID_MAX);
 
-- 
2.34.1


