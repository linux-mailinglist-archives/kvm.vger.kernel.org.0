Return-Path: <kvm+bounces-36201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D836CA1893D
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 02:00:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 407EC188B880
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 01:00:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9E8E3A1B6;
	Wed, 22 Jan 2025 01:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KuDvedzl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2064.outbound.protection.outlook.com [40.107.96.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB2817BA2;
	Wed, 22 Jan 2025 01:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737507622; cv=fail; b=PGafJWxVIYbmF4gNQsvv89RdR1RZH+7fFjjE306oNayGGTJT1G9j2SCgpPKK8c0jLpnZR4yVtyA3qasou6x+sJE1e7VJQ7rvCWqR/MDmcGdDp+lD5ICJprp23qEA/seaZ+JFvibvN6eozF7JwiA/c/6OrIlq9QelPc7BWqpAYHA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737507622; c=relaxed/simple;
	bh=N7YRDrdKyc5kObh91/QO93XFYEZWrAbuBkg/INmgvxg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f67hVScIvSKE3TmvZR8ibL8UVGW/IKt1loYmlum1AMHmM2QX2QAdDVx5GQtkRPRjV+nt+nKBdwW8C7MJBa8GUlPOMDXFX6nmGEO0NIzLXipUO7o0wu36xTPTJOWM3fGDZ2h3Qf0jvfDN6pFj1nTt+lJ54JB+tzvQSmimtjw5IOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KuDvedzl; arc=fail smtp.client-ip=40.107.96.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Oe8c7KDAmyfwj1wtXMw/EGoM645Ol/Z5cpdQfTy3M9nyFV3nyL4J3C00kkBblydne9OpDDUliWqlhiXlEolg4EVsWN0SR3K6HjgNihG5bmTeB/yxx1fdbj3OelMjQfag9tPlQ8690rZiK4cLTxeCWpRutK/sh4ETr6X9BL8hde3iU1OugPjQHsIEqKhWZbRPimt5OjjKC/zooz9hpXyihhRGHhBpa65hiIB2sPCDvir94KEGbuOi7n4ws6UVxKYRGMJU7WXs11ROtMqWnRbQ2RM7FZhukNEW78ietJ9yCxN+/7sFRaUWP0fvJFkxAyu88FW4ucYf0jVi1bGEF3PPDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/jhh2VcBAzSni/KkjX3/gDbqaadpWAxhAuyZq3Ha/tg=;
 b=v1yCLfHQa7UMZnM+afOWepp65dao4JqHxoUhW7iuSkQTQ73hgWLaRqus5oLFcrMYd0yZjKTH2ls1arIq7L/BYfQ5WskDq7gKJ/GKVVxmMbPhIklr6bqeY844b45EDhZfZ8vBJh8uz8Pf2AHizr24N51gKqu7+z/TClY3fbhrNU5wCYW6kZxXD1EI4uRlw/BnO3i1CeeMw6fXtySrHpJ+JnzVY6teXePI1KM1e2nTaLD+LBGjbrgfRnMR1UmwVXWacfsAIut/DJ55FM+ULSpogAvQUZr0YK6vpVhgFLhPcg7eRUsVfhWpBwgh9aUveKgvwph3YMcEMxlBCiOMJNGmPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/jhh2VcBAzSni/KkjX3/gDbqaadpWAxhAuyZq3Ha/tg=;
 b=KuDvedzl23rE6jVRIjC3mfBqZzO2j45OmSSFvH1d9NJhaUPjSLMD0xXzMwIMMTvjFo6Ml4DfYMvwOecMWaXphoFdGPX27q9rn4HYIYZwsCp77Xtpn3hf6+h0L00B0yeg4H9sumcZq3of7xXNemcdROLcBllOkyDaOr94W9TPgv8=
Received: from BYAPR21CA0029.namprd21.prod.outlook.com (2603:10b6:a03:114::39)
 by SA0PR12MB4352.namprd12.prod.outlook.com (2603:10b6:806:9c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.17; Wed, 22 Jan
 2025 01:00:16 +0000
Received: from SJ5PEPF000001F1.namprd05.prod.outlook.com
 (2603:10b6:a03:114:cafe::f5) by BYAPR21CA0029.outlook.office365.com
 (2603:10b6:a03:114::39) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.8 via Frontend Transport; Wed,
 22 Jan 2025 01:00:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F1.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8377.8 via Frontend Transport; Wed, 22 Jan 2025 01:00:16 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 21 Jan
 2025 19:00:15 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<joro@8bytes.org>, <suravee.suthikulpanit@amd.com>, <will@kernel.org>,
	<robin.murphy@arm.com>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <vasant.hegde@amd.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<iommu@lists.linux.dev>
Subject: [PATCH 1/4] iommu/amd: Check SNP support before enabling IOMMU
Date: Wed, 22 Jan 2025 01:00:04 +0000
Message-ID: <0b74c3fce90ea464621c0be1dbf681bf46f1aadd.1737505394.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1737505394.git.ashish.kalra@amd.com>
References: <cover.1737505394.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F1:EE_|SA0PR12MB4352:EE_
X-MS-Office365-Filtering-Correlation-Id: d6a81ead-eb34-4d7a-5358-08dd3a80228a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?f3lfEEmoYgp/BPSFSHFLWDbjKt61xBaD3Zo3w8SOa93esPPu3x8kEHsns+eF?=
 =?us-ascii?Q?4o9Iy2MN9s+J102XKrVRtACKDfdukxkTeosu2+69Sab0nrSdihjM1WXYoPtX?=
 =?us-ascii?Q?5DLEmiEL+oYgTzJji+BDfx4Jit0+BE059bUSz1JeY8TjP/vDj2XEvx442QyR?=
 =?us-ascii?Q?9SKluTpAze4G0d4qd2jVRo46FgVB7xyKu2Z9ympZXHnbG/KL9JmI1hLBByRK?=
 =?us-ascii?Q?w7UZNyuTHDaR3FtUMd3p9epA7v3SaJ3nF5/ZE1NCS9N4zMMu3RTF1Vt5FC33?=
 =?us-ascii?Q?2JJvWz1TY6grCBAel1oSVHnPKj2abWA8XBS8E0a5ERHjL3TwZNnBbsCJdMSW?=
 =?us-ascii?Q?s7ohYRcC5G6oTaSIvta4BMYMPqw9uYlQXxlSUKW3eMITzXXsLm69zyY+xqKL?=
 =?us-ascii?Q?wmMEl3nAYJHVGTtUnUKrjIZuC6sXQeRhiUk4x8igwAFzg4CFsJ2jOHDGXvV7?=
 =?us-ascii?Q?NSuVSWzfVit4d87lnIUQlGyCZ8XU/QZ/LvMdypWrEN8oATbex12s3oX8H3ZW?=
 =?us-ascii?Q?8xD483A7/kra0rlEXPuFD7LTYB4+Mt3AeA/W9UMt1q93TIi9KKR9wyz85aiF?=
 =?us-ascii?Q?H7rdECnk36dBShqrG83zunrTw0Yx5X0uVXo57wcmblsXb4mCE56rbSQUgfut?=
 =?us-ascii?Q?Jk8zRM1maShdTFjE4TOjwTq8SAvvxa5K4ZS/BL1+zLE0Iwzq/JIkLiqWAyec?=
 =?us-ascii?Q?rN+P8FEwXJubH3JUJp3q0tVkIzCk5PXte8gvWitnEHqonCTCB7YRkpZ8GBpX?=
 =?us-ascii?Q?6RLx65X8mgLN0Qlv86r+cGuWSeJ+vaVXjT5UwIl79IkAYugftzP1FdS2BsF4?=
 =?us-ascii?Q?wWTJx3fkUc3e8v73Z5V1FtCv3Ysya+TTT+MnzrRyII15o9o/jQtl6OkZ3r+V?=
 =?us-ascii?Q?iDwoCSV9Tpe0LYqGNj1DLMM9vcJr1gfg1PlpJPIGNEc1qAEh73MqaNsNcFy5?=
 =?us-ascii?Q?H6B9jjjDzZKpQj4kdbyZY+njQ7d2QqsXovbSA4Yzyf+cFPx9pWQQhFhAwoKx?=
 =?us-ascii?Q?ppagJ3IxA15J2+cDNjcut1AA9BO+z9T1Y1nFz/N9zGZEW8LybMM47VDEbkH7?=
 =?us-ascii?Q?7S3OMNxE/cFx1pf3GKqkPtrM1gqHK2XrMhJpSfNLAGCuD0F9FqiXiRqg+vTf?=
 =?us-ascii?Q?J0+mX62aKzwg/Kq4xS1+PD1Ga6zlGUDc5hK7DmitL0zNG7llaDFoF+Rodio0?=
 =?us-ascii?Q?WpObtM/362KOvczDyCDCmc8dG5WhxYO8zPzU5KGijm/QObMnUCe8JTCwONf5?=
 =?us-ascii?Q?srzvRgu2UU9WyYSxbIWSBmATW2R0/IUakmbwIjbYo1a2bnoBKvDP9Sl953k0?=
 =?us-ascii?Q?Q6UdjfGxMqUGsFML7rX/lGGis+FsPhBL/RkTEC5bu9v9r05R1tYyzALJbeiP?=
 =?us-ascii?Q?dvCbKGW6Wvw+NDSImDTy8qtDN58Wv7+MIWlta/QvTig7bZSccHzcfOIJ9Iz9?=
 =?us-ascii?Q?UW622zSLTGbDIFuOxQnn7tV8oK3cDweSEa3I5iv1wdlN/QsAOwO6jayozh2n?=
 =?us-ascii?Q?To1dl7cZCbfJesQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 01:00:16.4631
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6a81ead-eb34-4d7a-5358-08dd3a80228a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4352

From: Vasant Hegde <vasant.hegde@amd.com>

iommu_snp_enable() checks for IOMMU feature support and page table
compatibility. Ideally this check should be done before enabling
IOMMUs. Currently its done after enabling IOMMUs. Also its causes
issue if kvm_amd is builtin.

Hence move SNP enable check before enabling IOMMUs.

Fixes: 04d65a9dbb33 ("iommu/amd: Don't rely on external callers to enable IOMMU SNP support")
Cc: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
---
 drivers/iommu/amd/init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index c5cd92edada0..419a0bc8eeea 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3256,13 +3256,14 @@ static int __init state_next(void)
 		}
 		break;
 	case IOMMU_ACPI_FINISHED:
+		/* SNP enable has to be called after early_amd_iommu_init() */
+		iommu_snp_enable();
 		early_enable_iommus();
 		x86_platform.iommu_shutdown = disable_iommus;
 		init_state = IOMMU_ENABLED;
 		break;
 	case IOMMU_ENABLED:
 		register_syscore_ops(&amd_iommu_syscore_ops);
-		iommu_snp_enable();
 		ret = amd_iommu_init_pci();
 		init_state = ret ? IOMMU_INIT_ERROR : IOMMU_PCI_INIT;
 		break;
-- 
2.34.1


