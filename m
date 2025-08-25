Return-Path: <kvm+bounces-55688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C5F18B34E55
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 23:47:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6E5C170456
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 21:47:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52BE429D280;
	Mon, 25 Aug 2025 21:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Sx6ZK1eq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA0D1DAC95;
	Mon, 25 Aug 2025 21:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756158414; cv=fail; b=C1Lb7/JzNu2UMZErnKJeDQBWBrTao4E9ZN99WqRVxYojCgpKaDNuSyq6uruSstN3Jq77jROVAwB8BhyNj6I357/C2lahABaI44OvUx37q+3wZMEF9g9gUB0wZkIVgx5PUyjHXGidRXo+zNPCBlunpGNcWXW4/zdGkHdcyTmAbrk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756158414; c=relaxed/simple;
	bh=8A4L812pb/EmEjCm44+m0u7xyCLdIKh9FpCBLqm/unw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gg93fDr61CDspPD/lBKh/uEtuKQjQLIIPAbzxUiyk60tKl8W/YIFEN8SfM65Cy4kWBhT3FEQOG2GmorrIHsv++Ibl9jiSQhH2A5lZb28VqFT+tqFy4seQCnZvpBf38iwMvTkyweY5fg6DnwRYvA228j6W2/pu00KEF18H1EE6P0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Sx6ZK1eq; arc=fail smtp.client-ip=40.107.93.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u1sXKDBOOMAlHeLRdGv8I6/0ln9tTTHqy858jVb5e2ArHHIHtbNAnGABSMjVfLMNRcq6dvbYe9cH2/3RrX+yL64Mv0c6d5bRtlB0Zu8A5wVZ2SpvjSq3qcCBuQ3EGjaO9kU5GSIiFsTMjl3wCpXtc11VpsyQ4D5idGXnMRskfx6v7UGX/HQw3fXch4aQv8iApA5kRxqW8jGaVE7OJDmhTVzeAFzILiKrTfuk+wp5jlvBl75ypDdWJqWQEUXokxBOBOQwpqHT0FMadgwfQZXdP2eEIe/1EIU4S8hYDN9EgvD11sjqHqU+X9zb12/2irzlosC5Ru0Gv1d9+Ay0axKXGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dcZDwzPV73otx+bzr1nzP5Uw+ggwojKnqbIvyuC1EAQ=;
 b=lwXqw0yRDiAKDrHEa0BpFBXA+vPTXgzWIIdyWHG01aEKYxK+CRsbzUCoqDplWcU9UW3WdliQc9FV7qxcBDSwYazGQaruZ6g/jjL6w3+/2EZj3Bnli4VZMEFP/H2/aSpRV++LkuSZKONDjCuPGJSvdeomAvpmIiLtR6dMKAUxC1aKL5QlJ1qy36KTfIKdQVTHKnpSocydLHxVMKc10Isb5MzNsXhRbyv+uzSFsZRbCb0ZzJQvhgn+npKnHnRgMTRAgCnSWspfSz1U0M4QAfrjxdvtCcZlUNqmx1YDNglduetOVJ7GuvQ+HC0Ah+sMlLJY4xXp6u8Q9OXus9Agn47g2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=8bytes.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dcZDwzPV73otx+bzr1nzP5Uw+ggwojKnqbIvyuC1EAQ=;
 b=Sx6ZK1eqUNxCQQJ9DXHz3WYvvllbPE3w4Qt4N5ye10kfOvO1yYB2oD/mAchy//QMCjnlJOwh1YgvKdxCbu0p3bFHU2EZz8catr+QZPB8/yEfU/68TlBLbSHjjx1tbK9ZrVp34tg0kwpUPhTpmZvAn0m1Tbh2bHq2q9xdCEnZY4Q=
Received: from BN9P221CA0024.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::23)
 by SJ0PR12MB8090.namprd12.prod.outlook.com (2603:10b6:a03:4ea::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Mon, 25 Aug
 2025 21:46:49 +0000
Received: from BN3PEPF0000B374.namprd21.prod.outlook.com
 (2603:10b6:408:10a:cafe::a0) by BN9P221CA0024.outlook.office365.com
 (2603:10b6:408:10a::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.20 via Frontend Transport; Mon,
 25 Aug 2025 21:46:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B374.mail.protection.outlook.com (10.167.243.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.0 via Frontend Transport; Mon, 25 Aug 2025 21:46:48 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 16:46:48 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <joro@8bytes.org>, <suravee.suthikulpanit@amd.com>,
	<thomas.lendacky@amd.com>, <Sairaj.ArunKodilkar@amd.com>,
	<Vasant.Hegde@amd.com>, <herbert@gondor.apana.org.au>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <john.allen@amd.com>, <davem@davemloft.net>,
	<michael.roth@amd.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v6 3/4] crypto: ccp: Skip SEV and SNP INIT for kdump boot
Date: Mon, 25 Aug 2025 21:46:38 +0000
Message-ID: <d884eff5f6180d8b8c6698a6168988118cf9cba1.1756157913.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1756157913.git.ashish.kalra@amd.com>
References: <cover.1756157913.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B374:EE_|SJ0PR12MB8090:EE_
X-MS-Office365-Filtering-Correlation-Id: 44d3819d-c6e1-4049-1b8b-08dde420e509
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rOsCsmo37upy+dM6QM4RdtqQxcnoqXTNWe4h5hFGnlWAGmEmqufgMDBGPhGF?=
 =?us-ascii?Q?H8hE8rdbYy7HW5/sJT7yWAS0QjP+ZVWQIEFraBUnfOyh1jmmT/P98E2FqzvS?=
 =?us-ascii?Q?9WPDX0RnmFWAZQ16KNXQltMg/bJFX4vlrMZQFfmTKY9aUY7B0jdpD2+iDSaQ?=
 =?us-ascii?Q?Rxf1p5VCDvql4kRKrOEDop6jjUKqJO5f0dyPGremlaUgs6/F4vcZtGb/Hiw8?=
 =?us-ascii?Q?3qKeuXQxc4H8fignqTZI3eq3xnJgrWwX1gDxobuPxwDUXcLgcTwqDshpYI1q?=
 =?us-ascii?Q?t8R2CsIv26jPofV5a8Goos4zLfrFVGO3Z2MM8LtZTuyuCv9IRKKhV64fPViW?=
 =?us-ascii?Q?XRORtjSBZIB7Xk2AXRKdkzHJlr4lyWail/irWA0GtHF/k9Y4KO4BKAMVEAlj?=
 =?us-ascii?Q?Q2AI/EOQAJ3rz1poabDmp8qQcE2PIjgrUnDkZK+3/YGbN6L1YFuA4shQUmoE?=
 =?us-ascii?Q?WC+XeeJQ3KYfHX7rpzukpOLriZ3YQxJLBn3vdbWgMvlgnpRe4ew5Rz6A6tcn?=
 =?us-ascii?Q?a6RPlfANvXN1VWCmL/9F+CEChm8hMjrUlfMnfPLem4492xnD9QykKz/3ZR3k?=
 =?us-ascii?Q?aOOnG8DugcYfjM8orzsIz1hsgS8bdMSUQEu8uYF7RgvosM42jEdJB7GOoxTa?=
 =?us-ascii?Q?whAJrVIlyss6f+2AfP4a8F9xnNEoXb/EKM2cDteZfyhNOjGtDuVISP2DaatW?=
 =?us-ascii?Q?UF8u2yt4mkI+qMlVNikw9HxcqgCzckashpK1x/vb1J8T9oVW1k7Mdmt/hDBf?=
 =?us-ascii?Q?/eTsnP1OOyZFGfslNS0h8rVfR4tafS/GaycmdpRR3cIPaV27PBPxCcuYW/yW?=
 =?us-ascii?Q?FIy04dBoblOLXaVNIN5x8PvEM89C0pRL/NJ7rd9RXBKYsXiJMwkA1Ed2CWnm?=
 =?us-ascii?Q?fmePK++d3FpGwbgyUtiKUimkyXnsljmLWCkfPTXoi25J0zFSNzvgyGCUijXI?=
 =?us-ascii?Q?VEUhKpTRG3ccDtMoEEEYksvsDJd9N84bMx1D3KD0ezKbnS8Hd9hDBXKbe5xi?=
 =?us-ascii?Q?XI2p8+8kKhA7HM12ueirt8el6+oTGdzPqi8bZQNLUCoFM1auehXK1VfjUbWi?=
 =?us-ascii?Q?h7iPObaUoMFSRhliivOLIXhpw5S1pa+VKiN710c4NPDXBM+tw2OZj1vdVmro?=
 =?us-ascii?Q?y+WEthsbuEZM4W/NBgJP+0wUc36PhFnA/EzrRipm2j0PPtVy1i0JMJ9jQmnk?=
 =?us-ascii?Q?oPOIJFhuN5Q3WIWsLdM1Q8CzinJX+8O/gYoXPU4GQXj4nCz/Rt/A+FaQ+WPY?=
 =?us-ascii?Q?LTIfG0OP4yx3DEK3KHvsMM3g1VD59sDSt51tvqc5VKw5peOmxqHNUPNOb60z?=
 =?us-ascii?Q?9MxMWEi3iyJWvnUG53m1Rjcx7Rp0ir8enfVni8o4XhG/7gOYcFfDa9dhHcxJ?=
 =?us-ascii?Q?fkQQ4GhcSkXogH5l1r+IGAgvGOQjUJRqkIqOOptAAhcqyBYccq6dTXDlmOjp?=
 =?us-ascii?Q?bjf21D0AsBfBKdzLjABGBNx87G/PMnf45FMFWjiUvQPJZQ0ChyHU2obLHGQB?=
 =?us-ascii?Q?0pu6THUkAtxjf1xFWvFnIPeaPYYRqImejrbe?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 21:46:48.8710
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44d3819d-c6e1-4049-1b8b-08dde420e509
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B374.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8090

From: Ashish Kalra <ashish.kalra@amd.com>

Since SEV or SNP may already be initialized in the previous kernel,
attempting to initialize them again in the kdump kernel can result
in SNP initialization failures, which in turn lead to IOMMU
initialization failures. Moreover, SNP/SEV guests are not run under a
kdump kernel, so there is no need to initialize SEV or SNP during
kdump boot.

Skip SNP and SEV INIT if doing kdump boot.

Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 4f000dc2e639..b701908c0bdc 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -28,6 +28,7 @@
 #include <linux/fs_struct.h>
 #include <linux/psp.h>
 #include <linux/amd-iommu.h>
+#include <linux/crash_dump.h>
 
 #include <asm/smp.h>
 #include <asm/cacheflush.h>
@@ -1374,6 +1375,15 @@ static int __sev_platform_init_locked(int *error)
 	if (!psp_master || !psp_master->sev_data)
 		return -ENODEV;
 
+	/*
+	 * Skip SNP/SEV initialization under a kdump kernel as SEV/SNP
+	 * may already be initialized in the previous kernel. Since no
+	 * SNP/SEV guests are run under a kdump kernel, there is no
+	 * need to initialize SNP or SEV during kdump boot.
+	 */
+	if (is_kdump_kernel())
+		return 0;
+
 	sev = psp_master->sev_data;
 
 	if (sev->sev_plat_status.state == SEV_STATE_INIT)
-- 
2.34.1


