Return-Path: <kvm+bounces-28031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C96FD991DCE
	for <lists+kvm@lfdr.de>; Sun,  6 Oct 2024 12:28:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C1E96B21B34
	for <lists+kvm@lfdr.de>; Sun,  6 Oct 2024 10:28:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B486175D38;
	Sun,  6 Oct 2024 10:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eGs6qsFM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2070.outbound.protection.outlook.com [40.107.236.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82A04C8C;
	Sun,  6 Oct 2024 10:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728210469; cv=fail; b=KSH/U4zhIt5JHggvv+5+eC0GVay+V8Pm84OiyGImp7ZUYUvAkZgMzyrDF2fTD8N3lvq6tYaCSCWlOV86LBno+zMNP5VG2OfLiL+3zAwg3LBOCw1n8lJWPrOIKrqMzMo7EH7MYC+HYI447Zf3PqjsYfNPO91TS6XPVT4QaZUovxw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728210469; c=relaxed/simple;
	bh=TPks86/WmekMrUQ8WcQR9ENmzE3mg3Y7zA15Qj6v5nM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TboJFoLif7patgfJsIpX6wqzjrbT5CU15Ns9Ji7igIB5BgXnv4/AHwiE29ww7HK+eDyj9sLAaw8TdTaEMNiF/V0U+W/UvjF7kBAZtpsIy6038ndXAkZ1WylzchqwPYfhe0WyA6Zo6c94cAq76quaX8IKy8evIc5XhZ/5G+19MMw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eGs6qsFM; arc=fail smtp.client-ip=40.107.236.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=thUxz/F80savCbeM1VhpnT8jS0J0H1VnOcbLhYFi9ADFgnXytlQC4cJ0TlAcFVLImWo8Mlh5PiqvvjNRryMHtsya/E/EXe6g/WKmwyOFt4hY7sYWNxxm9TdAvVsaqEzi2ZSJZVxC0jjVG7fcPzerHKpy79RsRurgNIVSIshZ38Jre2AvRJJMT1YFsyStZdFDiaAJMap9BU87XNUHXHt/nBf+kfMicQYGcD/s8Y6hlI4CNj1/suok33pMyjjcQWLqApRe9y6EZGjqL8EBnQsyp4k6DwOgYkRu5KVcLCbJNzy/fsMuRQ6nNrYmIuS/Oon3JjYeIoCdyE2ZcQF8LUUN9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z2R0noY9aMhD2ZWjfVLE1BpwixqGyq201eG1fgnEwYo=;
 b=EjdG19Qfum/zW869p/MARSRe0BGV/2CwoEXEwHNa/JOoVWMsVfLd7YA28tD0A1RDbrWK7ge8kZ4lOAeRTaF61H6CuFfvvkc+hXab9SL8VJO4El/QPEeENg6Q6XgLvEjXrzrhWgQaXoy6zNkX+38o8f+F7PwsKkC2ugpRctSQdY155cTpn0LHiCpjxAg0Y27kvXxggQ9eBUWNwhm1vA/axe2t17C27zJQvoEZ72dK8+7iD8Gq7LPDtHyUOEsusZkMiPjEU/jZe8fbLmeLL3UTKdGFGY4z1a9iYhVrVrJ/y+boEv1F31RAAzWTlyepJYyBBkSV0RS0JT8ZmJcFeciagQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2R0noY9aMhD2ZWjfVLE1BpwixqGyq201eG1fgnEwYo=;
 b=eGs6qsFMvA9JFirCSDYEsQiP1o14sCcR+Bcd2CzscrdR4rCmU2cXx9bH0dt0XygbZh5b9aK5I9pjO3ytrffpu/elnBmuDTJwtVmwAaN3w/WZOJejKE4MoYdZQts00qMW7dHFVjYoX3NN8yHCfO9nNjTbJ7LAnmvP+p3GgzfMBdNxcpqU3t5ZCg0OieRn1Wd89Y+80ZuQ2TELIe06+7nlVa4O4RRXp7hoWhL5qs+HwAL1Bt8QUYVlAipxenEmsWcYtekPbbB4Z3BeyjKTfQBHhwJFE5pmljbYVq/bzLJXhBUmeDSLlLWbNTZnLxvk3//wa71uG4zfzCu53a84pQxSug==
Received: from BYAPR05CA0027.namprd05.prod.outlook.com (2603:10b6:a03:c0::40)
 by DS0PR12MB8245.namprd12.prod.outlook.com (2603:10b6:8:f2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.20; Sun, 6 Oct
 2024 10:27:42 +0000
Received: from SJ1PEPF00001CE3.namprd05.prod.outlook.com
 (2603:10b6:a03:c0:cafe::bd) by BYAPR05CA0027.outlook.office365.com
 (2603:10b6:a03:c0::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.13 via Frontend
 Transport; Sun, 6 Oct 2024 10:27:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF00001CE3.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.13 via Frontend Transport; Sun, 6 Oct 2024 10:27:41 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 6 Oct 2024
 03:27:39 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 6 Oct 2024 03:27:39 -0700
Received: from localhost.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Sun, 6 Oct 2024 03:27:38 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v1 0/3] vfio/nvgrace-gpu: Enable grace blackwell boards
Date: Sun, 6 Oct 2024 10:27:19 +0000
Message-ID: <20241006102722.3991-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE3:EE_|DS0PR12MB8245:EE_
X-MS-Office365-Filtering-Correlation-Id: adc75756-9909-43aa-4894-08dce5f1828f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+3JCc0n5Oj7W6IctL/g3ygpYbUEa5iM9vaouDCNHQ+q5ecMMNq5ei+NyFovw?=
 =?us-ascii?Q?Y+uqyGs9eEdr3MiuJoWDRpug4J4nJyY6VnL8XBSZtIMUtUWYwnQI681zC/PE?=
 =?us-ascii?Q?PZidKKrKfoAYYnXlFvu6FMyglvXfAQmtedpgmlBs4fHTNSRG2L8TCYPFCwHM?=
 =?us-ascii?Q?qA3oVZZiIlwjeESlxweLJB8LgYAqiqm9pfIs1Ysl9quNycBaAkrl8fSQn6gI?=
 =?us-ascii?Q?E71RRMF/9Q6M4tJqVpNEUO0ul80fHVL+5cKRgmUn+Jk7VBEy4n1h+GP6+2Fu?=
 =?us-ascii?Q?NiHm7VWGwrNETx9eoGpjsvYn06L0C3rihiKlO+ylCMpXyvmt1cO61/mDMxJM?=
 =?us-ascii?Q?VSiXZPEtdxMSODzDbbjijUthOv7woxzuYQMnGg7sn25fPZ/hwTkVTDi5pMwf?=
 =?us-ascii?Q?I6K4fXdHWZ4jBwLpcqy/yNAMt17ZT6Pmg7FwLsWQgDKqUlJJY5o/9GLIUxDD?=
 =?us-ascii?Q?gt8xXaZLwjv+UIkY0F8KSpS1TPwHdRnYKvXOXUW/xjMmUAtKVMOqV0hj6dyK?=
 =?us-ascii?Q?iS9dz0zDn98yFmIpbrUjWfXOqVLBliTymaQBRLiRgmUCEedsE1WGJghs/w7m?=
 =?us-ascii?Q?fq8mf/wsJq953RQV70dLRpB6Ny9/JTbkzL8457CmyJc7Dph/ew65yqdzjfaR?=
 =?us-ascii?Q?N5zDKESwBzCmUXWsr/k+sok471JNIhgnxRmhmg4axVVW7NEi8qdBisaXG3zp?=
 =?us-ascii?Q?iJ9b8HR5uKf2vh2E3xv0QlP9A5inluY7T71/7TVQfMZjAwKxn7nbbFLiGz74?=
 =?us-ascii?Q?X/ITsKKJslFrR0sxoxiMOyK7WYS/0eZi+p+MKNo3j2XCoVKbUTpdUG752XoZ?=
 =?us-ascii?Q?gI0szKMebxab51140ZWcQox/avRb3zm/irBhfsh6/m3tBDuU4FIF6xiIWVsB?=
 =?us-ascii?Q?uoXSC4U6aBRXsDe9BhGoHeeDnItG/vor5uogA4/DX9IcvIIVO5WNMhm2stcD?=
 =?us-ascii?Q?xQBgQyQByKK+/ys3TsFy+Lv0o5gwS4MDa4J8xkvLc+DfkIWysz3T6dUn9MbS?=
 =?us-ascii?Q?AsdJeXFFjvkHurY40Ywd8z3A55Blpgf2HNk/DlBH9rYm50/HfpXwbaOGkFTc?=
 =?us-ascii?Q?XrQ76jeN8AExc9aFXa2jwdEGMrdxquD7ol7fnEab/agl/UDZZ0vKiCTVTqRX?=
 =?us-ascii?Q?IQsC8scBlxl0iDavbP6aMgPy6RwhnRW3PDlLAjn0edJb8gpHKQA1qe0KD2Vg?=
 =?us-ascii?Q?yumQ1LAd8cx14WV8itGo2TYZGaIE/1+tkh/1EFDPXTp9eBUk1cJA9MswrQ/m?=
 =?us-ascii?Q?ui5lEz8l3GUS3xcBlDu/rdYuhpV2BRcE+CDbg5zOowue4VjWuSOi4gV3ge0I?=
 =?us-ascii?Q?rgJ1UD3JNBwUqRi/iVuHkk4X14l9WpzvM1c3xPRIAk8ziyYHkKRdE2ZfE9tQ?=
 =?us-ascii?Q?1htRIG1h4TrD0c3/ZF6lobT49oUi?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2024 10:27:41.9450
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: adc75756-9909-43aa-4894-08dce5f1828f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8245

From: Ankit Agrawal <ankita@nvidia.com>

NVIDIA's recently introduced Grace Blackwell (GB) Superchip in
continuation with the Grace Hopper (GH) superchip that provides a
cache coherent access to CPU and GPU to each other's memory with
an internal proprietary chip-to-chip (C2C) cache coherent interconnect.
The in-tree nvgrace-gpu driver manages the GH devices. The intention
is to extend the support to the new Grace Blackwell boards.

There is a HW defect on GH to support the Multi-Instance GPU (MIG)
feature [1] that necessiated the presence of a 1G carved out from
the device memory and mapped uncached. The 1G region is shown as a
fake BAR (comprising region 2 and 3) to workaround the issue.

The GB systems differ from GH systems in the following aspects.
1. The aforementioned HW defect is fixed on GB systems.
2. There is a usable BAR1 (region 2 and 3) on GB systems for the
GPUdirect RDMA feature [2].

This patch series accommodate those GB changes by showing the real
physical device BAR1 (region2 and 3) to the VM instead of the fake
one. This takes care of both the differences.

The presence of the fix for the HW defect is communicated by the
firmware through a DVSEC PCI config register. The module reads
this to take a different codepath on GB vs GH.

To improve system bootup time, HBM training is moved out of UEFI
in GB system. Poll for the register indicating the training state.
Also check the C2C link status if it is ready. Fail the probe if
either fails.

Link: https://www.nvidia.com/en-in/technologies/multi-instance-gpu/ [1]
Link: https://docs.nvidia.com/cuda/gpudirect-rdma/ [2]

Applied over next-20241003.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>

Ankit Agrawal (3):
  vfio/nvgrace-gpu: Read dvsec register to determine need for uncached
    resmem
  vfio/nvgrace-gpu: Expose the blackwell device PF BAR1 to the VM
  vfio/nvgrace-gpu: Check the HBM training and C2C link status

 drivers/vfio/pci/nvgrace-gpu/main.c | 115 ++++++++++++++++++++++++++--
 1 file changed, 107 insertions(+), 8 deletions(-)

-- 
2.34.1


