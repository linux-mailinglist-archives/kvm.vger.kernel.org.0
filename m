Return-Path: <kvm+bounces-36959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42208A2388C
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 02:12:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4AFE51888E01
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 01:12:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E6BB70807;
	Fri, 31 Jan 2025 01:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0dF19iJY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8460F1DFE1;
	Fri, 31 Jan 2025 01:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738285917; cv=fail; b=Mc3sZ7nyHZAmY128mnc9A1wuDdRRxK9frCB2407iVDjumMB9RJnAbc7lE5Eu1Xy5zPbpxiavFHo+Ku/XD6/0xp0PDFolNAqP/Zmnr101Msvd5KKy0+81YDz60g7mGqUm6b/0duLXqJMZFTjXRKDq9ExAKkueOg3IyXV9pZ/F0T4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738285917; c=relaxed/simple;
	bh=H/nBg4Zc1nh3nPUAIQXGEA7kS5QyrvbPY8pOE0UvBLI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fFeLMi9IXarkdKuLpns3MbUYthLPSJnmprnXtR/L8B8g5Sq1lccCnFR3K0dmqhr3hS+2EYsrxx/B44WZmkIcFn3cCVIEAKvxd368hhKCATLKn73VusAHiE9bwE4QK4u0uW8UQkZaXHCihdmQZ7XUwP4pOrLpUQNExSzGeXTcgWw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0dF19iJY; arc=fail smtp.client-ip=40.107.243.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n8wC1FVg4kteBeO8ciaUbF7EeV28aND8tFhFxesXs+egEPtbPuOZ6Y7JvBse81b+dbjuh5cb77iCZNsKgzUFdbcLXpZeAPBdMGz36QDjx37JOMpcb3DMYfDf/ASyVEzMxTvxBus60nSHhoYCmE7SPv+r1QcxYb8RdpYkAu8SPT+1HNlWp+3SfvUVbq8QcaY+333ATf4qy7EDBi/B/TEDvBVDZCWzINYqkxFrbc2CwIu88hc5vg5vsXJJ1OQSrjxn5ma/+/AlYszWDoRd6L7RH4Onb8XMxPimIx6w73fjPYOxP+eRzEyUCHd557ROSf/fXDMCTvPcz9xfqP022KCygg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=imxMxzQd+WdWw2I5byQVY4Qx0TKjDCCfijUXYFK5VnA=;
 b=O2oCarTBgyxveR6qrISYNnpMDoWqNjbO5Qx/oUY3YQqDHIQ3E1UIzOijMP0/hXKrfVsiwIbeC9B1RD98l84U2Vd6jRBd+DznLTbM/GosbB9ElwapM91Zmd0DZ+869Acj/V5oQl5vMiDfr+2nqnU6U7cZTs0078AqZM7BgSQe6Wkve+3HNmjH/7p5bdQUaHOSa6JCUCAlGt8QaLA0+8jF5SQGoD4VO2LyFOJZp/+D8bexMtsvCwgm+9z6bdTJWAIk0LngnmnTpr4etmsu+7R1MYOySmXPLxR+/11QXc6kMC6ca0CvhbfAHrbD8wFhSOEc9BYBiZfA5Q0x6ry/5gVaAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=imxMxzQd+WdWw2I5byQVY4Qx0TKjDCCfijUXYFK5VnA=;
 b=0dF19iJY+upZ2EuRBIlJIq5psJVUNnZLVVlynNvZ7YHGTNBfx+nq8GmjIB1HlYZLqSOZ5oQCXPR1lbDhlgulZWGPxQQRDARsglxWyNLfP0mvHkJ47p7niaZW64H+19jl05tjz++jRlZQwhTJ7kdxs7EAruaksx6IwF5d1ln8Caw=
Received: from BY3PR05CA0002.namprd05.prod.outlook.com (2603:10b6:a03:254::7)
 by CYYPR12MB8964.namprd12.prod.outlook.com (2603:10b6:930:bc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.20; Fri, 31 Jan
 2025 01:11:52 +0000
Received: from SJ5PEPF000001C9.namprd05.prod.outlook.com
 (2603:10b6:a03:254:cafe::43) by BY3PR05CA0002.outlook.office365.com
 (2603:10b6:a03:254::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.16 via Frontend Transport; Fri,
 31 Jan 2025 01:11:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001C9.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8398.14 via Frontend Transport; Fri, 31 Jan 2025 01:11:51 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 30 Jan
 2025 19:11:50 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<joro@8bytes.org>, <suravee.suthikulpanit@amd.com>, <will@kernel.org>,
	<robin.murphy@arm.com>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<iommu@lists.linux.dev>
Subject: [PATCH v2 4/4] iommu/amd: Enable Host SNP support after enabling IOMMU SNP support
Date: Fri, 31 Jan 2025 01:11:41 +0000
Message-ID: <afc1fb55dfcb1bccd8ee6730282b78a7e2f77a46.1738274758.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1738274758.git.ashish.kalra@amd.com>
References: <cover.1738274758.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C9:EE_|CYYPR12MB8964:EE_
X-MS-Office365-Filtering-Correlation-Id: c358e58c-580f-49cb-9ac7-08dd41943e8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0MgtX+qq6sr/OB/suRpT1eytIDHv7rUtu/NU9c9rSTIjk/wIsX4+/FlF0uJA?=
 =?us-ascii?Q?Zf54F7NyQA19tDpgtPca7oNC7fBKvVsbIvRZHvC6tGTtKjLgZGXp2AnzQft1?=
 =?us-ascii?Q?ICBw1UFu5sa7/aWBOweVX7XKODMuOL+WhYrSs3tg+vVmRJj/22o9MOOtNJdO?=
 =?us-ascii?Q?Kbs4RbcNaPrH+7nlaj2H3pxCy1JwzqWxZvFG3lZPkDbnl2qaWBzg25E96HFC?=
 =?us-ascii?Q?ftlGI7srBygTfpLQ8Xp6Z2AZAFQpGkF7uE3uNOlX2LA6aCug9h29uyPhlUBk?=
 =?us-ascii?Q?knagCUA0U9+1Q4PfsFN+rg5rxbSyBJiGNWOUlP8cvzzzl+vdXJRsFlsP+Pu7?=
 =?us-ascii?Q?kPawg3a5VSyCjxaZjVZxWR/qyBTELw8ozpt1lMi+8YphUk0VE6vup+jyMi6E?=
 =?us-ascii?Q?R0SpGzmdqU8YJblBNQCRRjdHXXaZVs/IoVJhCbdGpchYlH0O2olS99K4l7Z0?=
 =?us-ascii?Q?gPDaDnLUOSPgd6fQEcKv7HrkzVSvkhpSon3C2f3tawDWHB0Q9yTtyGscCNcn?=
 =?us-ascii?Q?aIrdwLuLtzSlHwaTDs+AuUPNDTc8Vlf7lyQ1/Rv9FxY0uxDDEYN1JvRGcSBN?=
 =?us-ascii?Q?Q9nCyLIrdvOSw9DawJjJ2K8b1Qti6qy8QucKIUHxJXGbI6uv3fYt4+3SyTyk?=
 =?us-ascii?Q?rg5AcGJ8hWBEnxs+R2/+XjmtSgyhEAgv1TM4sNC8VIFqMNTM3288/aMdmdqM?=
 =?us-ascii?Q?UVdudyDrjNklhp3KT99bMp6Z4pUWGsNvdlKDSrLyKpcdxD9+zMCCCZma/P1N?=
 =?us-ascii?Q?MEqBmT1jlOcx8zNOlfxnL316nTFdkw+Ij0LszQ8tIFgE3AZZAR4KIcBZ/If2?=
 =?us-ascii?Q?O15EEO+nhYtCm+xjk1VSO5sdBEz823/jKMPcpmN+7cNbTRSNMd5ECHeUeff9?=
 =?us-ascii?Q?Cm4q3SoAVL1Ov0DMynwqIl6Fc94QzBUT+xiDtEolbEtSM7FfZSDEwxuEtagF?=
 =?us-ascii?Q?jKsqdiWEBPF3lVxzS63ztEkozY8CIkmI97zNMkq3GA4ywZ31z/HgKf6nR4xj?=
 =?us-ascii?Q?2JsXlYtk65b8EdX6CHIhibFURRIq5SNWjaa/lD+Dl2GwVVDthDCkWThsxJOW?=
 =?us-ascii?Q?1MQmKtacxNv6SnFoBkbgcbioBFu4MUaMrLj1okgu2c5PS98FoFL+enob0u14?=
 =?us-ascii?Q?5ddjymYzzUJLGSxFBfW0Om2nQewVYjL3tKSpH+kM8BHUoi3yTHuW6hZNbDOP?=
 =?us-ascii?Q?HTDCOsqeQK3kC0QSDIdfIH2b5YrWepDYb9EuszdsbzDE1y9ujbNIJgIfIYHi?=
 =?us-ascii?Q?gTH0kmiOMYZ8cIFtGjXXpor1rYMICP1n20J//qZ/p7Qd7BG0q8ZGQ9umeMHK?=
 =?us-ascii?Q?L0wrmZ61WTnyGiqJ3Ptyr67oRRUUsESponRT47JeziD6rFdeuWreXyFG2ZE0?=
 =?us-ascii?Q?KF0gogNgoMV6q37jlHbcVZjkPcuqRt+DhA8SQw3yGvRL0EUnKPDcP2k80caK?=
 =?us-ascii?Q?6pv3uowZ831jLJobgRTZbwWOLK9b1353+3JKBmDSpkMFJSNj8JJt9bLiUT2F?=
 =?us-ascii?Q?E9G548+hhzGVmAY2kgFZuUKWkvnnpChgXd/q?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026)(7053199007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2025 01:11:51.5152
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c358e58c-580f-49cb-9ac7-08dd41943e8a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8964

From: Sean Christopherson <seanjc@google.com>

This patch fixes the current SNP host enabling code and effectively SNP
which is broken with respect to the KVM module being built-in.

SNP check on IOMMU is done during IOMMU PCI init (IOMMU_PCI_INIT stage).
And for that reason snp_rmptable_init() is currently invoked via
device_initcall() and cannot be invoked via subsys_initcall() as core
IOMMU subsystem gets initialized via subsys_initcall().

Essentially SNP host enabling code should be invoked before KVM
initialization, which is currently not the case when KVM is built-in
as SNP host support is enabled via device_initcall() which is
required as SNP check on IOMMU is done during IOMMU PCI init.

Hence, call snp_rmptable_init() early and directly from
iommu_snp_enable() (after checking and enabling IOMMU SNP support)
which enables SNP host support before KVM initialization with
kvm_amd module built-in.

Add additional handling for `iommu=off` or `amd_iommu=off` options.

If IOMMU initialization fails and iommu_snp_enable() is never reached,
CC_ATTR_HOST_SEV_SNP will be left set but that will cause PSP driver's
SNP_INIT to fail as IOMMU SNP sanity checks in SNP firmware will fail
as below:

[    9.723114] ccp 0000:23:00.1: sev enabled
[    9.727602] ccp 0000:23:00.1: psp enabled
[    9.732527] ccp 0000:a2:00.1: enabling device (0000 -> 0002)
[    9.739098] ccp 0000:a2:00.1: no command queues available
[    9.745167] ccp 0000:a2:00.1: psp enabled
[    9.805337] ccp 0000:23:00.1: SEV-SNP: failed to INIT rc -5, error 0x3
[    9.866426] ccp 0000:23:00.1: SEV API:1.53 build:5
...
and that will cause CC_ATTR_HOST_SEV_SNP flag to be cleared.

Fixes: 04d65a9dbb33 ("iommu/amd: Don't rely on external callers to enable IOMMU SNP support")
Co-developed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/iommu/amd/init.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index c5cd92edada0..ee887aa4442f 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3194,7 +3194,7 @@ static bool __init detect_ivrs(void)
 	return true;
 }
 
-static void iommu_snp_enable(void)
+static __init void iommu_snp_enable(void)
 {
 #ifdef CONFIG_KVM_AMD_SEV
 	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
@@ -3219,6 +3219,11 @@ static void iommu_snp_enable(void)
 		goto disable_snp;
 	}
 
+	if (snp_rmptable_init()) {
+		pr_warn("SNP: RMP initialization failed, SNP cannot be supported.\n");
+		goto disable_snp;
+	}
+
 	pr_info("IOMMU SNP support enabled.\n");
 	return;
 
@@ -3426,18 +3431,23 @@ void __init amd_iommu_detect(void)
 	int ret;
 
 	if (no_iommu || (iommu_detected && !gart_iommu_aperture))
-		return;
+		goto disable_snp;
 
 	if (!amd_iommu_sme_check())
-		return;
+		goto disable_snp;
 
 	ret = iommu_go_to_state(IOMMU_IVRS_DETECTED);
 	if (ret)
-		return;
+		goto disable_snp;
 
 	amd_iommu_detected = true;
 	iommu_detected = 1;
 	x86_init.iommu.iommu_init = amd_iommu_init;
+	return;
+
+disable_snp:
+	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP))
+		cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
 }
 
 /****************************************************************************
-- 
2.34.1


