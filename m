Return-Path: <kvm+bounces-1896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 90BFB7EEA2E
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 01:12:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFEEA1C20A90
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 00:12:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90A14A52;
	Fri, 17 Nov 2023 00:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LXy+TaHk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2086.outbound.protection.outlook.com [40.107.244.86])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F350111D;
	Thu, 16 Nov 2023 16:12:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mRPxYR/wJ9Qc4+VAxQVWrm9KCVfKcJU83cQuuejl97hNY7ZoGS7FPSJVRE0pO3Z1asXMhLiUuQ/LEqEjPYV5/IjDYFvcTawGpDKYCc1g6yCH42Izpao5YVqVkfpSnWrK4FnsEEL7NC7aFjNXRBsvKNKHHWIGayg5bkidH493pL3v4jr4sB6i856Oc266IM9HJ+p8GrKJkUNLRQl8Bj5uZ21WneFbdC0e4XxxEfo0MoRy3f6MKqb9Os808xeVjy89Xt/caqnQyxWh4UbD3YTcVpG76iYNkt6ES5ey0e1XT1frmhVU9oRkG+iZ4IAr9l4JI5iFkfGdYe5eGiSaFLqpjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZG5x/hIUd9NDl1C1mlFY0mM1DS4OwWKnZ+a89UgDOKE=;
 b=NcqExjOedLV4z0pRVchFxOTZXY4SW6qB7JDjrAqp4R/XpoO0vbpUDB0zwZ1sgzGYiqHWGTvoG33YsLymNdE3AAkfOKZt7x2qTF06L9iD4qwezNnZ0NLA1dpkfmv+ZLRy/DYlUqh8YPlYeaOzSR+qyGxLpKI4uGtmW1g4hebjiEOeJIsM1RWQaY89OYKtgOt1tJgJ5KyNq73fcxid5/9XkwHaJWpJcTzqj4ory4cABQbVov1pZW4w/CkoUo+CmjBZCpIgXojASoAe3UF+zhBz4NcxTN4JDmi24H3nIpXOjmiKr8mZvCrUb3TOxDYzFQHG5rBSC8snqocvpMQZptaLVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZG5x/hIUd9NDl1C1mlFY0mM1DS4OwWKnZ+a89UgDOKE=;
 b=LXy+TaHkPwQympHEnFAoqFLCed/XYZ3kRRMYyYei5Cl5zI4qlNbFZypH+m1izcJRJLAAsSyIewYXcKHIZ2E861dNHDasyA9P7qAMkt/vXiUe+Az2LkJgzw1dp6Yzg+TihwafyelXqXMcj97QDU09KEnNd1pZJEE2fGLpBTVAT24=
Received: from PA7P264CA0050.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:34a::16)
 by PH0PR12MB8797.namprd12.prod.outlook.com (2603:10b6:510:28d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Fri, 17 Nov
 2023 00:12:23 +0000
Received: from SN1PEPF0002BA4D.namprd03.prod.outlook.com
 (2603:10a6:102:34a:cafe::bd) by PA7P264CA0050.outlook.office365.com
 (2603:10a6:102:34a::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.20 via Frontend
 Transport; Fri, 17 Nov 2023 00:12:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4D.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7002.20 via Frontend Transport; Fri, 17 Nov 2023 00:12:22 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Thu, 16 Nov
 2023 18:12:20 -0600
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <shannon.nelson@amd.com>, <brett.creeley@amd.com>
Subject: [PATCH v2 vfio 1/6] vfio/pds: Fix calculations in pds_vfio_dirty_sync
Date: Thu, 16 Nov 2023 16:12:02 -0800
Message-ID: <20231117001207.2793-2-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231117001207.2793-1-brett.creeley@amd.com>
References: <20231117001207.2793-1-brett.creeley@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4D:EE_|PH0PR12MB8797:EE_
X-MS-Office365-Filtering-Correlation-Id: c4caa863-ba94-4ee8-e5e8-08dbe701dee3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	PsBkkkdx/+t5/kEXtyu9JPiV6FUeL/YPLgG1R5u1VSzOqlWGUnj3hmcCCLagLsmIAawc5DSueXObpfITNPgVDcSPhxTdoFefIZ9k3MRp/SmthfTU6vLIttgABbvEJY0Q+NWly7+oGllgcWCQlNG2AhgJzTwNIemmderzbZ32yszoNhe4eJ5i6ccsQQ8X8hLOUZteZzOFuP6IxNn/yfX9VF0uhIb4X37uUy2+4zFMKnXx60BLJqR7X7HhEttjXP04pLKuXpU5mZp+ivW+QuONV5boW1I5QcGKM2RiVr5aRkpWiW2n56VUPQoBkHijZ/8daqg72KQxHww0VtsIkjfYbyRud4ypcNUfy3ZwR2JsycsJkTNziUpTmb7EcAAHlFUV0ifGFIrtt1HaLGboGlY6Q3jXZdrksvLNvocowiIZU/tzCdRQ9EWZZQswGSStbgyMYW2xwjnbkMT12ZEoWTOGScUBaJCmzeBzRz3V2CPUKFk8XSZ2UlOPnXOC5DMES77wd3UVxUz4i4Tyc1xAI/OfV3EBMac+znuWZon4oBGdBY2E3Aw5whBb5kb3ZEIgOVOmzUQA7OJs5xRC6HnPRQquops5Mi6bRchthzmPkpeRme85tB9zne2t7Qv/1XXfqEWbOxr5E2aY5jWIRGPadhQoLD6J0XMrTaJA6HQ/BsKOw7KlvUy9HlIKJf7v4Z24qxJYH/kIE5rCC8FGqKcLQkyvcXI8fxKUS9uSAV2HA1S3uoeKDHCxVFnLPPyhEfSSH0qD7IGmHz315171v1LJ76n1kjr1BXxE0awp8xnk6yDsc6E=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(396003)(136003)(39860400002)(230922051799003)(64100799003)(186009)(1800799009)(82310400011)(451199024)(36840700001)(46966006)(40470700004)(47076005)(83380400001)(2906002)(1076003)(478600001)(426003)(2616005)(5660300002)(44832011)(6666004)(26005)(16526019)(336012)(8936002)(8676002)(4326008)(40480700001)(36860700001)(41300700001)(40460700003)(81166007)(356005)(82740400003)(54906003)(70206006)(70586007)(316002)(36756003)(110136005)(86362001)(14143004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2023 00:12:22.2893
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c4caa863-ba94-4ee8-e5e8-08dbe701dee3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8797

The incorrect check is being done for comparing the
iova/length being requested to sync. This can cause
the dirty sync operation to fail. Fix this by making
sure the iova offset added to the requested sync
length doesn't exceed the region_size.

Also, the region_start is assumed to always be at 0.
This can cause dirty tracking to fail because the
device/driver bitmap offset always starts at 0,
however, the region_start/iova may not. Fix this by
determining the iova offset from region_start to
determine the bitmap offset.

Fixes: f232836a9152 ("vfio/pds: Add support for dirty page tracking")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/dirty.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/pds/dirty.c b/drivers/vfio/pci/pds/dirty.c
index c937aa6f3954..27607d7b9030 100644
--- a/drivers/vfio/pci/pds/dirty.c
+++ b/drivers/vfio/pci/pds/dirty.c
@@ -478,8 +478,7 @@ static int pds_vfio_dirty_sync(struct pds_vfio_pci_device *pds_vfio,
 		pds_vfio->vf_id, iova, length, pds_vfio->dirty.region_page_size,
 		pages, bitmap_size);
 
-	if (!length || ((dirty->region_start + iova + length) >
-			(dirty->region_start + dirty->region_size))) {
+	if (!length || ((iova - dirty->region_start + length) > dirty->region_size)) {
 		dev_err(dev, "Invalid iova 0x%lx and/or length 0x%lx to sync\n",
 			iova, length);
 		return -EINVAL;
@@ -496,7 +495,8 @@ static int pds_vfio_dirty_sync(struct pds_vfio_pci_device *pds_vfio,
 		return -EINVAL;
 	}
 
-	bmp_offset = DIV_ROUND_UP(iova / dirty->region_page_size, sizeof(u64));
+	bmp_offset = DIV_ROUND_UP((iova - dirty->region_start) /
+				  dirty->region_page_size, sizeof(u64));
 
 	dev_dbg(dev,
 		"Syncing dirty bitmap, iova 0x%lx length 0x%lx, bmp_offset %llu bmp_bytes %llu\n",
-- 
2.17.1


