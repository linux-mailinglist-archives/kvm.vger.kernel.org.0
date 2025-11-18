Return-Path: <kvm+bounces-63505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id C9A4AC68128
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 08:52:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E9023364D7C
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 07:44:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60B13302CC6;
	Tue, 18 Nov 2025 07:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="P7dsRnBU"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012018.outbound.protection.outlook.com [40.93.195.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8C9301499;
	Tue, 18 Nov 2025 07:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763451883; cv=fail; b=aVAR3r00mfvwlZClqX0qvUfZEdbvSImgTxbCo2qMpo8mUiKnrB4tgJzn5komnlr/leGK0RYmaUhEgcUKlMXECtOhuh5Dmxr9gNocqFmXgOxsfoaW+z1MZzykw3k1johPCwKfgGur5z2Wo+IOQuhN7Sl9D3PRQazZcRqYSLIJ3zo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763451883; c=relaxed/simple;
	bh=Ij2X3xsi8NNFKxZkcxwKhHXKrFrr/89hQXpMm1EoFt0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=f3PZa+WYNWWKtxrWG+8DmfnwJLe91Y+p+Tnop3DiqkQZgEqq5mpZW3LDtXF9c9zbj6Vt5l5WYo/881ejzNN9vDuiJPHIAudUHCV7qB2i8iGUpnWAHD9UhmCcl/9dMicvzhPsKhHsQMvyCRFKnEk0figIDmJyzzdSqhPDMF6Y15Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=P7dsRnBU; arc=fail smtp.client-ip=40.93.195.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=py/KTklmkfftaxIWasUVtxwT19NKP0k9BHl4CLFBqiHDZOB0SY6AUVwYHzWlCIAFNQPhFsFeVmWQVxsxWgrDQjDgQnBNzcaH7wwpOLFvU4vwDWqirH/sniPMSX2KmrKMjcq3GhS95JRsGmup1jMIRIttv4SVUHB5JbwU/bDuJaDXaTluf7NwFVJa7shHLf/LSzbbUW3nOjY2/Myi+bUhp2gltM5KziFahuZRqKXL8hORLg1krJBNPRITmfDRaJ/PJXYleppQdubduhg10yCOGnb6V5NqgrW0xn88E34OiSTDwyWK87KMy7yjchUeMVo6YSlSwjta8y2omGnVuUrSWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DdbhmUOYB5aA6bLDh6XwrIkv0lyw6pZmW+yCSHYCkbU=;
 b=vB8NLLfdUNk3uK/42zBTdOBWrieKy1u79JFMM/J5hX2ltXgyi+RFbqK3Fze07UcePXqjbEqHjJ5mA2U/aV58UEZYe0XPvrZjUIXklFpZHmLqEr+eVYam3M4UD3tLZ5t3DiqLzgqJuSAdFuJQ5UDyQKIUG7hA0JVX2q/iwC2potun5ZoOBACjdx6Pz5R2GzA8GozUd1bgnUBnA6TC/7kU7wstremrp47bjPjmxm3nHxI2gsmjR8IQ47EMtos+uRO6TxYAqEyD3GQr6hylyb3DTm2xu6ohCNrdro5G9JNyVSxF83LGcfPEbAo8iDZxpeMxrlPHlvYWUuzr78wEGVnXZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DdbhmUOYB5aA6bLDh6XwrIkv0lyw6pZmW+yCSHYCkbU=;
 b=P7dsRnBU6LpBylLAkF2/FSulVm/YFhgm+HMJ86bsSu35EWGlMWNnRe05B87n7hN+d1mWiZQkk/W/CdykRZNsCqzYdhXrcxIv25YEx/9qW2IcuWssrN/xoe5jHN+X2mEYIsj4vlfgl6RKE4VP9A40oyXAF2GGqkFACyFW+uO+ydrGIDprCENhZiCmKXH6GvpD6XNHQHrI87Gam3aj+ul03drWdUdCoDAEk+jn7KoOwNlE900hjA3Q6Kqmy4EmP2y2FTz7O9rIoQcAu8j0y3Emgc/ayyA6ILC+zaCgLvIn9zVBK/pf2h1UufIyP989KBZoDOmY055ILvY/ptBpJ6VHOQ==
Received: from CH2PR18CA0031.namprd18.prod.outlook.com (2603:10b6:610:55::11)
 by DM6PR12MB4314.namprd12.prod.outlook.com (2603:10b6:5:211::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Tue, 18 Nov
 2025 07:44:36 +0000
Received: from CH1PEPF0000AD7B.namprd04.prod.outlook.com
 (2603:10b6:610:55:cafe::68) by CH2PR18CA0031.outlook.office365.com
 (2603:10b6:610:55::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Tue,
 18 Nov 2025 07:44:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000AD7B.mail.protection.outlook.com (10.167.244.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Tue, 18 Nov 2025 07:44:36 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 23:44:23 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 23:44:22 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Mon, 17 Nov 2025 23:44:22 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<skolothumtho@nvidia.com>, <kevin.tian@intel.com>, <alex@shazbot.org>,
	<aniketa@nvidia.com>, <vsethi@nvidia.com>, <mochs@nvidia.com>
CC: <Yunxiang.Li@amd.com>, <yi.l.liu@intel.com>,
	<zhangdongdong@eswincomputing.com>, <avihaih@nvidia.com>,
	<bhelgaas@google.com>, <peterx@redhat.com>, <pstanner@redhat.com>,
	<apopple@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <danw@nvidia.com>, <dnigam@nvidia.com>, <kjaju@nvidia.com>
Subject: [PATCH v2 0/6] vfio/nvgrace-gpu: Support huge PFNMAP and wait for GPU ready post reset
Date: Tue, 18 Nov 2025 07:44:16 +0000
Message-ID: <20251118074422.58081-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7B:EE_|DM6PR12MB4314:EE_
X-MS-Office365-Filtering-Correlation-Id: 6223a8d7-d150-4b45-4bff-08de2676529a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yVpRjWz58SslEVm19vMnReUas1A4Mj8Ib148IvmuXQ5hP2wbPdCVFyZWKvXY?=
 =?us-ascii?Q?GofNeu2jJev73pagxRZMKCZXw8I2frG2++WJZVjS3f47KnDLsCZMwya+1Hk0?=
 =?us-ascii?Q?GYaOnxHIKOXCxqpK687tAax9r+U1SQ0q+IjPj45YRPPjC5I7qLhNIeohTMvq?=
 =?us-ascii?Q?uaNu7CbtqJIoBs4Xe3svF1zvQvXXb4e9L0O0DtY4VRZvUK7WSpdv2GaAOm17?=
 =?us-ascii?Q?AI6ulrKB5rqbtIxFzEyZQ776qupybqcZrrwVd/ln0TJTMXDq2n3LaLnpZd6+?=
 =?us-ascii?Q?vDvEaVGnaKRs10ouS7LfnLtgg2uBuRKnbFSLEggpjU2mz3f0zn5Rk6HSPbIS?=
 =?us-ascii?Q?8Ab1qOg5SO9viGO/vw+MY3NjKoBPh2CaUBYOSLYQ6YPvUsklwzTCY0ufaiCm?=
 =?us-ascii?Q?8B3yPoPu/S9+Pxm3We6G5vI7C4qcJ6e2qJW8X6pzN8mkhTGcUX9xKLt3J1/3?=
 =?us-ascii?Q?nYbQmcS/zMoNVuM6hHlng7ZieDCnOCjzQrkmL3oKfnCPWTbhawzDMz3jH0Qa?=
 =?us-ascii?Q?yD9MlzeBvrXd0AYm3B/er20C2rW7RU/AcAH1OWUoz4IjPw9+UFWSeQQUCeyI?=
 =?us-ascii?Q?VpANMK4Buvv43UBufna1vQSprmobfMP3QzDpvBUM5GtJMGQjnDg//H5LbGTQ?=
 =?us-ascii?Q?6VrTS6WUs9EImNb9xs0NfA8TQ9cU1fG1Fi8Y8RQqmy8BGbHE6LgTs0oqta0L?=
 =?us-ascii?Q?oNxB1+mDTE01YqNlI9AbqHlBZo6lA4LJdtiG7JrzkPrb3+tFrBTh2vwsn8s2?=
 =?us-ascii?Q?9RPqO/nqZhC9tLTHOam83AjkQaLdF3ldy4sSjUd8ny9dsTSCg5QPOMoI7xqc?=
 =?us-ascii?Q?8BkyTVDnb2sRhd84/LKnIp1GBRKz5J9bJQgHYaTxCdfVIksTUVzI8WF59tyu?=
 =?us-ascii?Q?Xgu7xmQ/d22uUyZuYmCd0UZREGtUF7UCbmAVr85VPPMgzajDRKudSLbnsmAu?=
 =?us-ascii?Q?LvaTM3q5ZKov3CYf5vxIhsjgfhxEsuZk62AW5OgyfbFB0FHISRZ0YY8Wbbw8?=
 =?us-ascii?Q?b8RQTzX5i6FzLmNFS1iYLvQ2cyez2RkHROabWMXa6oFZngosrHLiRHGf2ibT?=
 =?us-ascii?Q?sOixsqOMWbGYX1IqCh0lcblkxNWire2ZlOSpkkVRnoDsGFqBtGTQgc7lxqA7?=
 =?us-ascii?Q?Z1/BgfT3+e0E2+ePWJzW2Qw8KLJEGl0q0piCF6ytQEzFtMHIRAzGjmiJJA2Y?=
 =?us-ascii?Q?UVQ9hfmiYfX3mQDrHJOBOMkgGGc52CqyoykNEy+wsTz98N5YlPHdGGYzfD4e?=
 =?us-ascii?Q?E8yiL+p/JniqqyqNEX2rLCOZb4/oeZ7hnz5RW+Chyvs7WmPE6QXv15dEc2nP?=
 =?us-ascii?Q?PoXL/z1Gqa1rLqOyXYgZuDVZ91NXPQhH6bc1JBcslreyjGu8cLlzlnuYA0pu?=
 =?us-ascii?Q?WHlk4EJn8xpDwce5res5UnRQP+6f1mCkRVSGekaRc1Uw5G1ZA2GTriMFgeP/?=
 =?us-ascii?Q?m5QdeB16SL8UjQ8OGktppqBIG+BjbqlCSNL7OStJBF1MrXddpHz1qK50o9Oc?=
 =?us-ascii?Q?qlphZhwWYH9KjpA2T7p5MhsWsdCbPbaiPSq7X2bU9ycFy4QhVa9Rkd2cNtKb?=
 =?us-ascii?Q?o2k5XxVPobJwwN5aRbaNJcKP8U7hY/B4akS1BRaI?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 07:44:36.5521
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6223a8d7-d150-4b45-4bff-08de2676529a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4314

From: Ankit Agrawal <ankita@nvidia.com>

NVIDIA's Grace based system have large GPU device memory. The device
memory is mapped as VM_PFNMAP in the VMM VMA. The nvgrace-gpu
module could make use of the huge PFNMAP support added in mm [1].

To achieve this, nvgrace-gpu module is updated to implement huge_fault ops.
The implementation establishes mapping according to the order request.
Note that if the PFN or the VMA address is unaligned to the order, the
mapping fallbacks to the PTE level.

Secondly, it is expected that the mapping not be re-established until
the GPU is ready post reset. Presence of the mappings during that time
could potentially leads to harmless corrected RAS events to be logged if
the CPU attempts to do speculative reads on the GPU memory.

Wait for the GPU to be ready on the first fault. The GPU readiness can
be checked through BAR0 registers as is already being done at the device
probe.

Patch 1 updates the mapping mechanism to be done through faults.

Patch 2 splits the code to map at the various levels.

Patch 3 implements support for huge pfnmap.

Path 4-6 intercepts reset request and ensures that the GP is ready
before re-establishing the mapping after reset.

Applied over 6.18-rc6.

Link: https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.com/ [1]

Changelog:
v2:
- Fixed build kernel warning
- subject text changes
- Rebased to 6.18-rc6.
Link: https://lore.kernel.org/all/20251117124159.3560-1-ankita@nvidia.com/ [v1]

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>

Ankit Agrawal (6):
  vfio/nvgrace-gpu: Use faults to map device memory
  vfio: export function to map the VMA
  vfio/nvgrace-gpu: Add support for huge pfnmap
  vfio: export vfio_find_cap_start
  vfio/nvgrace-gpu: split the code to wait for GPU ready
  vfio/nvgrace-gpu: wait for the GPU mem to be ready

 drivers/vfio/pci/nvgrace-gpu/main.c | 171 ++++++++++++++++++++++------
 drivers/vfio/pci/vfio_pci_config.c  |   3 +-
 drivers/vfio/pci/vfio_pci_core.c    |  46 +++++---
 include/linux/vfio_pci_core.h       |   3 +
 4 files changed, 169 insertions(+), 54 deletions(-)

-- 
2.34.1


