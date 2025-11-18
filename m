Return-Path: <kvm+bounces-63532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 79B68C68C33
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 11:18:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sto.lore.kernel.org (Postfix) with ESMTPS id E9ADB28AC7
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 10:17:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DEBE33C52A;
	Tue, 18 Nov 2025 10:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="b3P/e5dQ"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013010.outbound.protection.outlook.com [40.107.201.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5B023F429
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 10:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763460996; cv=fail; b=UbhGKCIfQtVAkgr3J4QVHiw8/mYvO71dPx7tyLRbr4bEzo5i4QY8AfCgp0eUe4hZBhRBXUfeNOJc8lV37YZrKs0TfZhnZqTEAXSJbfHVzHLxWK9FYRFz9Zg16tK7K6H0fFdampj57EByrygAY61cyHnkePqUx/IImvhFtMjnYWk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763460996; c=relaxed/simple;
	bh=h/CQaHuiQH6xYXozYUSv0H6eNEsbD0Eu+CqIaBC9D+g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TDzM7r2BfB5EsxSuQYs73X8lV2X5UmppZNAoZRGxWi5mAik4lL+JMHRBLRZRHSMGXECKDRZJcVd7Qq0Y1vS9ZqQslf44tCpOEnwonO+0vQCLgxuBMUxpDn+CNXcgcJqwnHEgr7KmoHJMmxUswXGo43rocUz29b21FjnM90xnHnE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=b3P/e5dQ; arc=fail smtp.client-ip=40.107.201.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gy3kizyaIbEVdlZ1ei3l6YezbgQt5B9ons5XkQP477BMuZmZdRPlRHSTh8T3r8LRiKhppj3FMDPTc/DRuya4Opw+r/DTxQYaeUdFSkCqVdJjQBgERnjeKZnl3LLCC9RXm83CceSK8EGKaEOL7LZ59ogQCy0BgokACCPfheSGPM7aIX0ua9bwrbv8rTZV/MIWI90VmBfejArNnX1jCt/f4vEKdIUZ3WhpLgnv3K+F2lB05Hh2ynrET3iLohtyVig1yCfeTNqAg+oPlb47fgdcLZfXsJQ6r0aBTkSXiAaiWsg5Sh5XdFYtPuXIrNKedeqwAwHQQc+TlO1KcHfa21j+bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=daNL5hgxamLuGLTlEXEONUIm6GASpOYvVR48Zji7D8Q=;
 b=Ma70UX9ZsKVh9YaTjo0GDVD2loYnnW26YBUvaV5H1+kaASD/yqbp7Lx1D1tdh3752JXf7Hxdt8+5gwGkFWV6Ve4hrbX6Zr3wVwAZJm/33IUmLOwFC8wPesDOpSN7i3xSclzoNTmPJ95ygYm8bJv8MY5J1bo/LdSv6teTZMTZrE7ZvhFupiMua1UBXkU4vFaccDaJ8uStBUCo5GTF6pjxQawxTdFqbuBjy154QvsvKb/3a75rYALjbsyPkNmIMfi4kQIEw921OJH74p0f2B+HhiTnaGgpwSAUijzviJubimC1wW5wsK3zODi4jWGm0eNQZ1GR13Chz+LYrJuK+qq1yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=daNL5hgxamLuGLTlEXEONUIm6GASpOYvVR48Zji7D8Q=;
 b=b3P/e5dQyaPZUd3wHX4Efdyg9eOF2ccrlkUgg2NetiC28tGBuUa0rKYTdAE4CIJz8LlXBxU60y5tufFrUyrjkpb8WNrOBbB4h6b8lx01bqOQ7nJzunWVH7f5nHBIf2m0ifPTbcnLNRcbvkJUdwplG0DRFeIxEMvtuoiHa2GkFY4=
Received: from MW4PR04CA0356.namprd04.prod.outlook.com (2603:10b6:303:8a::31)
 by LV3PR12MB9117.namprd12.prod.outlook.com (2603:10b6:408:195::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Tue, 18 Nov
 2025 10:16:28 +0000
Received: from SJ1PEPF00002312.namprd03.prod.outlook.com
 (2603:10b6:303:8a:cafe::58) by MW4PR04CA0356.outlook.office365.com
 (2603:10b6:303:8a::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Tue,
 18 Nov 2025 10:16:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002312.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Tue, 18 Nov 2025 10:16:28 +0000
Received: from BLR-L1-SARUNKOD.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 18 Nov
 2025 02:16:22 -0800
From: Sairaj Kodilkar <sarunkod@amd.com>
To: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	<alejandro.j.jimenez@oracle.com>, <vasant.hegde@amd.com>,
	<suravee.suthikulpanit@amd.com>
CC: <mst@redhat.com>, <imammedo@redhat.com>, <anisinha@redhat.com>,
	<marcel.apfelbaum@gmail.com>, <pbonzini@redhat.com>,
	<richard.henderson@linaro.org>, <eduardo@habkost.net>, <yi.l.liu@intel.com>,
	<eric.auger@redhat.com>, <zhenzhong.duan@intel.com>, <cohuck@redhat.com>,
	<seanjc@google.com>, <iommu@lists.linux.dev>, <kevin.tian@intel.com>,
	<joro@8bytes.org>, Sairaj Kodilkar <sarunkod@amd.com>
Subject: [RFC PATCH RESEND 2/5] vfio/iommufd: Add amd specific hardware info struct to vendor capability
Date: Tue, 18 Nov 2025 15:45:29 +0530
Message-ID: <20251118101532.4315-3-sarunkod@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251118101532.4315-1-sarunkod@amd.com>
References: <20251118101532.4315-1-sarunkod@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002312:EE_|LV3PR12MB9117:EE_
X-MS-Office365-Filtering-Correlation-Id: e436cf3c-8e5b-4eec-fe12-08de268b897f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mZNSxAECLm9HiRD1T+ZSkdI5nyvWLyPR6g2oepCXBehjC4splEnTn5EHu5mi?=
 =?us-ascii?Q?CiP/y6OZ1b8lJ+1ez8GJTsrHbbCLQq9zRpz0AYyD5Gb7g8JEG7OgTGnBFB5H?=
 =?us-ascii?Q?bo7MbwLSLJKceeo+lPTXX3VWv2isb0OCCCNkids78rEfvv5jw++B+O70FYAh?=
 =?us-ascii?Q?rN/lHAtQmLKaZY59o9vryhpgdZCqeh02D8w30g37ncthH+kgIoP8OubVZGba?=
 =?us-ascii?Q?BmWrAkSyRJl5Rco1Y73BwpCaK2fQY5lmJTfL1zikwd59KjgFs5//9HnOTafU?=
 =?us-ascii?Q?GnjXM32NUO/LE6DkGi6hplS/MOCxxa3by5OCW3AIvWGJmiyz6pvh36CVKur6?=
 =?us-ascii?Q?9NTOi2QLUtSeNLWuaKA1C9Cd9vLKHjNaOdI82g4UAuG0a9PxViD5a3+Y8wTN?=
 =?us-ascii?Q?hjnZbmkWiZIUOSr+uRz6pkpoFoM7FZ5qvMibRJOk/cLEIh0CJpDACFQYZSOv?=
 =?us-ascii?Q?RcLxtMG4YRsqIF46Yeq7jUNRbzNKRGyxirU3eNpDSICEY5j/Bu+InWDDMAMs?=
 =?us-ascii?Q?sN0W+ResPjpW9+haZ/MAzvhFPcqjcnGqwQyfT8LJY+7g0gBquOkaANJ8YGFg?=
 =?us-ascii?Q?HI/nyeRsPWZkjTyY7HW4ZB+a2KOVww4W5EBCkFYv/UaM5ZrYxdZtAZZMxZGJ?=
 =?us-ascii?Q?YQzZNBCMMdSZbs3nHaXdeFlvRACoGOlym+Khjq/KTOtR1L79uBN/kxxjoAl7?=
 =?us-ascii?Q?HFZIKvkeVzRlY4f/Ss7b/+AWB7QUoJPXuJT2xcV0iw9ePjlhFusI0L9Rqtuk?=
 =?us-ascii?Q?pPCYRtmVsx2ds6RfZzys17JIx4VEmJqRTTxQRguXOny8H9P51gY1jxHhI5be?=
 =?us-ascii?Q?iTjlP/1P3sOk7bEcxfeAo7c8wwjY4ftjxsz+mGXswLCNog2eAi+gDuK+6FFx?=
 =?us-ascii?Q?b2zRFtJ4XXD+ISSaHQn9Haw8uWH/EgJeH69VarrWWN2bIocXpQ0PvZzsXqq0?=
 =?us-ascii?Q?Y5aIXXvZo1oZELbQKiot9mDtznG24sYdGYWlr2aQMRHvUju3z9DCNYJnopsQ?=
 =?us-ascii?Q?1mOWsT9ly59ow5RGH8pGLX9S5U94QuL7lIIrR83/NwVdPJqtY/w2cGcHrqvm?=
 =?us-ascii?Q?Aj7BA6OOlJX22aB6k9Eq9DOEF8snvFUAr77h3uXn63BhNKaI3Z8++u93CCE7?=
 =?us-ascii?Q?kztRBzp0V2Uh1skw3Z53ckIRRQ++GPFdIscUeLSCjNvJUI5vHhIFlxyvj+sM?=
 =?us-ascii?Q?cBEleATlUnCmOdWryjcfpBPP6Buu326WwJKiV8v8qmyzkL14WcVZh6icls3E?=
 =?us-ascii?Q?dp2VzRv7M/IlwOEdiePUVPq8MWk4ApED8+MHILXqJ5ArxN8JFQCfXAypAfUG?=
 =?us-ascii?Q?bNvtYy9q0G0/V+yvUS1w3hh6DiI+eSEfdWpFaWpq64Zz5tkpoqh0Ih3scHw2?=
 =?us-ascii?Q?dswrDDs3Y1XQDYPNe/IdZu3dwONWULFNNBxvP9g344e8/otgdHQ5ZNjLSKc/?=
 =?us-ascii?Q?q134goi5CpWIxNJ0fPbpTU4hhvOKpdZRzpFzhm10PPt3X4wxvnyOkrG+KR7w?=
 =?us-ascii?Q?UpU2jx+hAJVQWO4BR4S9nv9WkDlgfqtZmniWSHPWOGhjxsj9BuHmtCaYOQP9?=
 =?us-ascii?Q?xlwTi1Zwg3hYeiWZT0Y=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 10:16:28.1496
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e436cf3c-8e5b-4eec-fe12-08de268b897f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002312.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9117

Update the vendor capability structure to have `struct iommu_hw_info_amd`.
AMD vIOMMU can use this to determine hardware features supported by the
host IOMMU.

Signed-off-by: Sairaj Kodilkar <sarunkod@amd.com>
---
 include/system/host_iommu_device.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/system/host_iommu_device.h b/include/system/host_iommu_device.h
index ab849a4a82d5..cb1745b97a09 100644
--- a/include/system/host_iommu_device.h
+++ b/include/system/host_iommu_device.h
@@ -20,6 +20,7 @@
 typedef union VendorCaps {
     struct iommu_hw_info_vtd vtd;
     struct iommu_hw_info_arm_smmuv3 smmuv3;
+    struct iommu_hw_info_amd amd;
 } VendorCaps;
 
 /**
-- 
2.34.1


