Return-Path: <kvm+bounces-27234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58E5D97DBF1
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 09:15:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B7781C20F0E
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 07:15:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48D0714F9F7;
	Sat, 21 Sep 2024 07:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Fy4onrKX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B851238F9C;
	Sat, 21 Sep 2024 07:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726902893; cv=fail; b=mzCCkY3rtvljtWJoFHsiIKtbrWLS8LHw7znkAxM5+VlYhMLkbxwAawWdR45LbELqmZCdwSKAIpTcvLbIQhLi6Z+i5tu4vLZ33DEQ0JK+UHkzP26IG86Kw/dFKxcVdfUPOBMSziQeM9oPtgi4anfr1IYv3QRmsqVJgot5WOVM5wE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726902893; c=relaxed/simple;
	bh=4RbXD9hHsRcsFVEikqardya2+gAqsY+kKbi2KJjYJyY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AEJ6zkrAYyzmrgS7aZ1zuADz1mCu3zHokUz0BsP/51k+hg0cuwcZIvgb50MExdXgZebXto0yqxGIpQ6iCh86MM6EqQr8t3gXIPK8p+1mS28G7ORyPePAwdeeqCSeM+x+Xgg+I3et7Syf4kwl4POVmdpGeRZMLGDy948eQlEMh3Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Fy4onrKX; arc=fail smtp.client-ip=40.107.243.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tMPhbPoWZpyr0wrDIGtwI9EzrVrrPTuSlU8qp/W1B/gQfdbkpflUF+TwlrtjudfJmFLh1rlmP2xt6FltncnSenqoS3M+nhYfD/fN5kqfO53+Pe0DgZfFhgMsBzerPw5w6KG6MOAcDW4VFgDhFgyvqHDg1GDFAIU7fuqNyj7fNdRSYfkWj8vkQQRTE5GgW+EPGJgxu4u3lR/x4D+C/42n6y2oWs9KWjETzAFdBfiYOIJVq6tq3Zq3Fe7ZbLBRpFUwJozrAfZNYCLb4gqNfrp0NLJHjHpOm5vPEY9HWzOobL/ff3KRP6ZQ4rbXYafRIwdTeEda+N0fEozlNUiQWSr8MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XBDwVbLm6vfmJFsa/Q0ax92YXqeWMa5oxkcvuAdppBs=;
 b=gQcIpXWKGy8Pj/0O2ET1EuiAOFtlW5GfhjZsXDKzH7j9VyjE6q8MbLBefxRNvTr8aCVf79yFcjh5nkqOTmJ79UCezASRZOnV+9dimlDNVQ+mnzwV/zUlMuXsGe9iL9bjBaY9bj5GcuzIJen3HYKGZFALC0ucRrgKrnY4j1QBeJabTxGPDIsNH2Xk43nrQwej9ddGhVJ1iu7erV2xof2FBVnxmyBus/2SzBMp5zluuFtUrWSc4M78TwtgZYuazJVMBjEDCZIuPk1kZR2oUEl64ijSRL0OsQinXrFDZJQCjf4eDdB5VFX197pEInsZvXVtzl51mb0lCvZzAayn9mdXig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XBDwVbLm6vfmJFsa/Q0ax92YXqeWMa5oxkcvuAdppBs=;
 b=Fy4onrKX83K3EpxpMaONYgu9K4QfB+BP2D3UHwvHsCC99OFrVKL2uKPBI1hwYgNBS05kygdosi5EB7mL2HRpBuWFy6y97KKo+WQuts+jjVycWPcHiWr4apWBPIPKbC0+Katb7uxkXgjIC3jFFUBZPccIhJBoJmqycSG5BeVwNCwco+vr7NMPANK7b2zeB9mqNIB6nGQtXHLR7A2pSE3/Knp2F7SZ09INy0dnRIrlLIBrvq+LkIqYIuKcGz9x5QJ9sVzo2ki+WBYUrQh8+YFcxUSv1zbGng/hi8LQPKwlKG5YVz9LlAJwTVMiDLClERBTJCF7VVpbMilReGGBDiBV1w==
Received: from CH0PR03CA0362.namprd03.prod.outlook.com (2603:10b6:610:119::9)
 by CY8PR12MB7099.namprd12.prod.outlook.com (2603:10b6:930:61::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.17; Sat, 21 Sep
 2024 07:14:48 +0000
Received: from CH2PEPF0000013E.namprd02.prod.outlook.com
 (2603:10b6:610:119:cafe::3c) by CH0PR03CA0362.outlook.office365.com
 (2603:10b6:610:119::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.29 via Frontend
 Transport; Sat, 21 Sep 2024 07:14:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF0000013E.mail.protection.outlook.com (10.167.244.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sat, 21 Sep 2024 07:14:47 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sat, 21 Sep
 2024 00:14:44 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sat, 21 Sep
 2024 00:14:43 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sat, 21 Sep 2024 00:14:42 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <linux-cxl@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<alison.schofield@intel.com>, <dan.j.williams@intel.com>,
	<dave.jiang@intel.com>, <dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<ira.weiny@intel.com>, <vishal.l.verma@intel.com>, <alucerop@amd.com>,
	<clg@redhat.com>, <qemu-devel@nongnu.org>, <acurrid@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 0/1] Introduce vfio-cxl to support CXL type-2 device passthrough
Date: Sat, 21 Sep 2024 00:14:39 -0700
Message-ID: <20240921071440.1915876-1-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013E:EE_|CY8PR12MB7099:EE_
X-MS-Office365-Filtering-Correlation-Id: 57cae869-804a-4a0b-c45a-08dcda0d13c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2m2zj3KceAhytFwKNfodHFQ1sffwZ9NEYW6d8zVZfny28b4xUv/Mvl91HnhT?=
 =?us-ascii?Q?wNXDv+CgTIQfRhNFAmaOlXlCH/s72aDjUr51Fv6N56AIa2TdyNeD+L5QmtAg?=
 =?us-ascii?Q?WBU+si2c703+z/wHwZr56eoAd3dGZ6dNFZ/modIinaE8XUAXngCSXfm56GlG?=
 =?us-ascii?Q?MD5ylivNpRWL9I49yMevi3nO6L1mrPo1SgC1+iCWaIpK4eXPn1Y0x2IJ4qlQ?=
 =?us-ascii?Q?uTDp/C/CWGNTQZmvGyhLpz8yIjc8N7DhJbPdF3uKzwyatgtioVHjA1mhE/fz?=
 =?us-ascii?Q?Y/SNjDydrDaUntJHhsYlBBDY1HPtLFi8oFMYamOw1YY9bTGPXRh3ES0owDoP?=
 =?us-ascii?Q?2Nsvlc9SNa79YjHypfCQ8wtJZaNqO0pRwjTNwrh2kYzztSj/+kTetnNcgcvP?=
 =?us-ascii?Q?NEuxy/jDgHxEry0Yznggv+LT+dDV6KZ/sbfxRtoz2z2MSQxSK4zElbcYscZw?=
 =?us-ascii?Q?hYvVIJrl8sc9I5PyXuZT7ubSomnvKIXkENMs7/1vc1v0qIzPHNFcVZOYGYWe?=
 =?us-ascii?Q?xhBF0HHrLkEaGy7kshJe1CDvfBD1IKihCYwltzjBdAlVJW/5vWaHAmI+cYze?=
 =?us-ascii?Q?ikGIzv/TNMuNW9o8k5DPGRVkPsSgMjzBjIAUTkBh9YQTSJZjph2Dcx1ZD+2N?=
 =?us-ascii?Q?GOMQ0h4zP5OOeamPdORl1r2VQjSchyTjiCyccz++CqDZF4IW+tE/w3o4dNOY?=
 =?us-ascii?Q?X5Gd+SYl8a6oA6BKSP3KdggOp1Y4p+CwFVs23NToCpTOZRjfkUMPwLTPFzFw?=
 =?us-ascii?Q?dA24um8LRP61+VoZozD5yBVOhDSdpVKqS5boLuR22lNdLCHt8c4sHrhwbrCK?=
 =?us-ascii?Q?RWiifbm15XYCH3V8b5OHr9MCPhqiG4IYcYizTG8cfbJ9GaddnnH7YmWBYPU+?=
 =?us-ascii?Q?K9YwOQVSunfakLvCu2KjD3V3dEq4KP/PaD94WF0GRG36//USppEwFIgYyH3l?=
 =?us-ascii?Q?vp1DvUNwqeRf1xYIjT8reKclZJihFASVeFnDSO3DQYL/w7ggdZyw7s8bOky4?=
 =?us-ascii?Q?nEWfpidP5pU+0f3ecQKHOZ4hbAaTgqhD276NartHIu36aLvjEs1FyusQg3Ne?=
 =?us-ascii?Q?VpjxM3lcFJFFuZFzXM3ILez7V2lxxfNV8eLg4SfD9tOH5xE2mF6JvsvL2/Ib?=
 =?us-ascii?Q?dfzyPLFlLMA8JI8wDJ4IgNrEL+8ZpPSrC5pxu9ZmItAQbSGBPKVIUPC5PJIu?=
 =?us-ascii?Q?059AzwAAVlmpvBY1kUrVamuLO4E4H0AnbSUejz+olwo85LjzdjkyWzIxx8EC?=
 =?us-ascii?Q?I4MOnVWUeCAqsEYyk0Bz+Q62tDVlhopg6gPnmrvbS+CnSnVG2ujimztc9KA5?=
 =?us-ascii?Q?K0mwvLFGxuOAQ8t6/r1JQbHdAxwx5KGjvrID23Aga92sIZKhgb7ZIZQL1mvh?=
 =?us-ascii?Q?fVTD81ujERap+WHbR8rJ9XWoVj2Q?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2024 07:14:47.9559
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57cae869-804a-4a0b-c45a-08dcda0d13c8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7099

Compute Express Link (CXL) is an open standard interconnect built upon
industrial PCI layers to enhance the performance and efficiency of data
centers by enabling high-speed, low-latency communication between CPUs
and various types of devices such as accelerators, memory.

Although CXL is built upon the PCI layers, passing a CXL type-2 device can
be different than PCI devices according to CXL specification. Thus,
addtional changes on are required.

vfio-cxl is introduced to support the CXL type-2 device passthrough.
This is the QEMU VFIOStub draft changes to support it.

More details (patches, repos, kernel config) all what you need to test
and hack around, plus a demo video shows the kernel/QEMU command line
can be found at:
https://lore.kernel.org/kvm/20240920223446.1908673-7-zhiw@nvidia.com/T/

Zhi Wang (1):
  vfio: support CXL device in VFIO stub

 hw/vfio/common.c              |   3 +
 hw/vfio/pci.c                 | 134 ++++++++++++++++++++++++++++++++++
 hw/vfio/pci.h                 |  10 +++
 include/hw/pci/pci.h          |   2 +
 include/hw/vfio/vfio-common.h |   1 +
 linux-headers/linux/vfio.h    |  14 ++++
 6 files changed, 164 insertions(+)

-- 
2.34.1


