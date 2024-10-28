Return-Path: <kvm+bounces-29809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 083389B2472
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 06:40:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BD401C21286
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 05:40:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62AB3192D70;
	Mon, 28 Oct 2024 05:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="khe6fsla"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D4D1BDAA2;
	Mon, 28 Oct 2024 05:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730093743; cv=fail; b=lNDkQHJCKImB5nQr1vHvrifrVRRVH1Gn8tTfuMmYVbK+62UL+LeVbtV1MONiJuQT/0Rv0GvzQMoWHmBZ60cCc6YYA3KvdAJSz36e8em6JLiUblSo3jGhbdGF5RYqVO7XcNoe9uYk1IiIWtNguzuxHt7U7524mD8E3t9pUR5mQok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730093743; c=relaxed/simple;
	bh=OB/6ASxdYsnfcl4J0jmZ0yh5aIWCHB0Fx5bvb3/XE7g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gKJ1F7uvHYVp6mulVJeV6InJat4rabOkdDYrvdoP1l12ANmbJMbxf+AkYO0kLMBGExpEUQoMVPvj9vOCohNR65+c/h0qZacU5+QfjezGKIh0olNcCoJAhx2nj1+Gy5WKnUxGD4IWfiZBxgV7DzoufV7ieLYYS0nXt7q99F7Uw7I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=khe6fsla; arc=fail smtp.client-ip=40.107.94.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wmAJcAXo1TEVVR9q7ZKMKxky6fU1R8pXx0dBDNcsJ1xldkZXbmJpahrxTT7cKXfiQxAhft+h+CW7opEPA6eG3dPrtIqC1vScdC/amTfc07xT0jY2rbKMxtnRloRKjHcE0a3vVoIUQQKHkeZPU5av56nDQu6WskBGirmLVZhoYZUIEyZUTZJGiIHI98Yj7FC1xP9khSkCoYCb2pNdrxOo0BNITgMJydUOFpG8ykF4oohiVDDRh9EbJUQOIu6Cj7hBJFHyMFcEnM0rkBDFbN2ZYDbhO/ibCo4YW49WG0BMIH3FF3STFlcUSP7qovZe03VSPJeuZWnsJDKCFbUdLNH0XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sYYQW7AgR12vwgxAo6ihnztYZVBXhW9FEUsl9seDdjA=;
 b=GFuEeF+fmXvKiSe2YqwyuTqnzlxd2GCJx4b/DiBBVLNHFRHQ9eJpuL36PxtaO8NGxP0TdRalgTduArzOn291Zo3F72fDa+TyqUP5C63zPCgQBChDEYjj/T1y5sRL+0YK1Nwx7s1Xs4VItAXAF2ZjqYlFJ0pef4kVSlaTShiNea9+leUyuj+La5fA80Z9T0NPZNRsqzEIGKaYHbDHo2IDxS4/VJmGyHiNciNz949AX7dxP9OgZj+76JoWXUm4qgFJTXXw6iG+aA0oqlyiACwmwfVsCi2uIfsPAKQezmd6kliJ8E73nIor4j3FYq4RsjTZPQgmk0PppGS38GrSoq9oVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sYYQW7AgR12vwgxAo6ihnztYZVBXhW9FEUsl9seDdjA=;
 b=khe6fsla37nlgYCZ/v7n12rfB9RBLnySUxZIvgT/pqwbt2H402VLwUYCO2HN1cWhCHJ6f+Qyx1i0GpCfJkSFGht4FAKAh6R+5IoAQi2bOXxElleOnhbQobls8SO8Qo8jxUaiSYOm1080zWZGrD4mo09ZArjDXktvxeXvge6vkNA=
Received: from BN9PR03CA0952.namprd03.prod.outlook.com (2603:10b6:408:108::27)
 by DM3PR12MB9286.namprd12.prod.outlook.com (2603:10b6:8:1ae::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24; Mon, 28 Oct
 2024 05:35:38 +0000
Received: from BL6PEPF0001AB53.namprd02.prod.outlook.com
 (2603:10b6:408:108:cafe::84) by BN9PR03CA0952.outlook.office365.com
 (2603:10b6:408:108::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.23 via Frontend
 Transport; Mon, 28 Oct 2024 05:35:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB53.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8114.16 via Frontend Transport; Mon, 28 Oct 2024 05:35:38 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 28 Oct
 2024 00:35:34 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v14 08/13] x86/cpu/amd: Do not print FW_BUG for Secure TSC
Date: Mon, 28 Oct 2024 11:04:26 +0530
Message-ID: <20241028053431.3439593-9-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241028053431.3439593-1-nikunj@amd.com>
References: <20241028053431.3439593-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB53:EE_|DM3PR12MB9286:EE_
X-MS-Office365-Filtering-Correlation-Id: d92c094a-c9ef-4313-bf40-08dcf7125a95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HkjypUuIHZeaiu0ouLUADoOH69fm5x+HDwVJkQmaf64g/2cceFuiC3x+fXLO?=
 =?us-ascii?Q?h6AgCa5sFyYfXAGYHEjArA1vNMp15WdOasSru+FU0WZKapWYCWSivQIsXNQI?=
 =?us-ascii?Q?tBTNS2AF5v8qmNuoxhlqiOwyJaBbmG0IAEx+vsMgc990hzjUDM11xFpWdyQq?=
 =?us-ascii?Q?yEyH74RIAmc5SIXzprNk4zmMHVyhCcvz3cCL1gF9YytLMN1mANBuL1kTTN7y?=
 =?us-ascii?Q?0LSfd9B/j1Pa/UUXihuQOr1fHoQCaONxW0FS69gB0a7K+ORb4Cpn5kDEM35w?=
 =?us-ascii?Q?pH6WEfuSmsEfriVoPpGzMaq7l2221GeYvuYWcoECdLM9HiAdJIamWkJuqmir?=
 =?us-ascii?Q?/LSPG8kLOrO82amNS8cVfIH6QFrOlrSfPjM6FTCRM5s5neSWzchrzlRLlYMZ?=
 =?us-ascii?Q?77iymLdoIsecQhyUrde9QvwWLqjICI205JjfpQyRA+Pc+WVfURANT7QNhjdz?=
 =?us-ascii?Q?HMR+AWs9oXxmijRDXEsjnhzAy0mAd8odTiAjmQz+/Bj792T2z9cU9OyibtYk?=
 =?us-ascii?Q?G1LGaXmHt83ENplgfU4TO8Z85jScz6FAXynB2frzCNmsV5arMS4oV2VWh021?=
 =?us-ascii?Q?ZiK605pjA6EPy5YsKeU13Qysj26EGL6CFKURlWjAPWSSgvxM3cP3xNKIf8ev?=
 =?us-ascii?Q?0N5g3Fy+4cTTUSAsh6JecOFFXC321r8UFlp7+5jTMdY3kS5/fE8ruKKsDL9w?=
 =?us-ascii?Q?a6z9TVTan+V6VuVKPUhEEfAMTrjGC/ryHQ+yRSG02sviJDk/MhbGVw75ugDU?=
 =?us-ascii?Q?TJ1zCoQ3L09jLBN7vgwpjq9We2p7a/NhD96jZL5gMAJAZ9v8/oqBZf7g72Qf?=
 =?us-ascii?Q?oNzUP7e+M13iqoLgzR6nhyqUdwxXu59mUNh15r82mFaWssPWoidOYTYYKmXI?=
 =?us-ascii?Q?Kl1i5cszGfFipPzzh2lHyg0PApkVCgHFxf5GNLpgJiGGHr8DsCQi7tZObmSY?=
 =?us-ascii?Q?I/2dU3mQiGaaF+FTT58mQReSBEewH9eU3psIv3e0J7uetUMXDlGxRGjhMSNc?=
 =?us-ascii?Q?LLFuBreZfS0ZTAn6fVT9gLBWGqlrlsGJed+xKa4fFQCYT/CCGD6HxEyYrW/B?=
 =?us-ascii?Q?nNfHTbTYPUPfhL0aRcFwcxdz7JgtdHrJAoj9tVKsumwP7EMe1VEDbMSn4htk?=
 =?us-ascii?Q?AFGJuNwQyKNK1QpHnJTmZCrtt5rGkGxnSAYaTj54goJrnf41aPe8iude4lQk?=
 =?us-ascii?Q?VQGiB6H+BCgYnxNz54igMn7TUU/D9v1HnptwjwuDaAtl7HneQOI29SiBYBK5?=
 =?us-ascii?Q?0BbcdPOt62GTRWLyepAB9i6NTMGP+7M4/il0SekcSSvExMWHWle1IIKmljsf?=
 =?us-ascii?Q?S/4C6B3+53eU3uUn6uD3nLulDUZ12GvxVmKbG0gRUC+tlPjUK2+yTFOzdWue?=
 =?us-ascii?Q?PhT3n5wdIeS5EU+gmj0RjgHULVCmKBiRoIYM59OKO7+au9Ja9g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 05:35:38.0378
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d92c094a-c9ef-4313-bf40-08dcf7125a95
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB53.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9286

When Secure TSC is enabled and TscInvariant (bit 8) in CPUID_8000_0007_edx
is set, the kernel complains with the below firmware bug:

[Firmware Bug]: TSC doesn't count with P0 frequency!

Secure TSC does not need to run at P0 frequency; the TSC frequency is set
by the VMM as part of the SNP_LAUNCH_START command. Skip this check when
Secure TSC is enabled

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kernel/cpu/amd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 015971adadfc..4769c10cba04 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -370,7 +370,8 @@ static void bsp_determine_snp(struct cpuinfo_x86 *c)
 
 static void bsp_init_amd(struct cpuinfo_x86 *c)
 {
-	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
+	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC) &&
+	    !cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)) {
 
 		if (c->x86 > 0x10 ||
 		    (c->x86 == 0x10 && c->x86_model >= 0x2)) {
-- 
2.34.1


