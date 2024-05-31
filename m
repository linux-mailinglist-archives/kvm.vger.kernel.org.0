Return-Path: <kvm+bounces-18486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D546B8D5981
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:37:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 49BD01F25F0E
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F126982481;
	Fri, 31 May 2024 04:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QI/Y1fLa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2089.outbound.protection.outlook.com [40.107.244.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D301480028;
	Fri, 31 May 2024 04:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717130083; cv=fail; b=Q8M2i/Njuum4iCaEOo/Jmetdo7tKsZ5KeptXQiPnMvqtvlk3QEefop8pDS2ewwK1wGdJYl0ol41oSwkvXiHq1RNYAq+LntYT/9wcpS3lHzl9gE2Ublta1INnEfPSluEWGmBIRfHu6RGG9vNj8hc9317tAGvXA09Q4vRHpBJeU/c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717130083; c=relaxed/simple;
	bh=vLrKq49G5EtzXifK3qXve/+xABeDSStTWEiwGb0yu/0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UDzV3IJ2uXrq2DvIOOThTVtiPIcf9Doa4OD6BOltWjlsU8XtJjCOx36JBCPQupPCSJxPLfq4PZ7scQBrmB26wTcPIvv1W1HdMamgPkBUhOeQhTBoc1IqkJcKtNlhepuXVaTOd5r4jZcehIG4fw0aaGrm9q5C5P5uVGNvQwnbXTA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QI/Y1fLa; arc=fail smtp.client-ip=40.107.244.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I1wnKJ5XnMxsdGuvARsuYAAs4OKn/KmL9PDxItQX75O67KeykH2E9+LtQsDydEqXJD1jJzl2aGERwN9I0NIfF5zkRK3lG9Tt7zqiF7p5Bh0BnSqj+09+3CHhY5LuurGA+RonjyKnFnqEvoeEBRCtC6u+dAItaNJV9mI8lmZdb1owN7XZrIs5IpkTEj0kaOk/9rud5TnfKFr+riAAs4gvg7fb29EENc2zP5uSXMK3vn7ZKyfmT3U07ayg1MpGglmN1fXEHD7o/F1/YO4n2ff9laHqNWCeT2mWjW8mTjXtasJhVBFTL1EvBwX5wuqXzSsFC5PI0ccZtH6/ri6Y1RrMdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VI9Q6jL4aJyvI91x+hBzrKswrSdPdeIgmfBHMt4oUSY=;
 b=DZchoarwx+DA6lejeX/ayIlDfDp9tMZ5Y1czrL15rFUfQLwEEe4P23XJsR48dcogaRKlijQEAqRFKEsgXW4kgyyFOCXv6C0chXtGXHU8yEX8b4Gf926+s+Q5gMq8muAtC0VqOOol4ZMEgV1LxLU9OXwZzfF7Nf+C+ZVjziNXWaDZx9IwrfIBe3Lv2/h8Xh5lflXnmrvq+wi2WNSKKlwqX4iydEB8KZp3bQXkcc2Qyx82kVRRJeKyulzdnM8wulCIh1nkge3LSaQxei7KJhRRsyxwnobSNEuQ+oFAH5ltlvtdGCLBsD8xULoQWIniS7EnC897h27EUGX8eYR14u4Swg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VI9Q6jL4aJyvI91x+hBzrKswrSdPdeIgmfBHMt4oUSY=;
 b=QI/Y1fLaDrhw6CigwmaVm2uy3Jh+LGvfjhOQVNGWN/n1Hxi0xjATUwJRvEAjUcMqIp2NsjT4frTeHOlF+75s3pwhpwDscXWKPFmmar0SYk66ajJTHaCa8KkW7l0Ohj6dAd3n7aMnrm4sW30q1Eyyf+5kiMctn7yP86yvBewr0uQ=
Received: from DM6PR08CA0051.namprd08.prod.outlook.com (2603:10b6:5:1e0::25)
 by DS0PR12MB8295.namprd12.prod.outlook.com (2603:10b6:8:f6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.34; Fri, 31 May
 2024 04:34:39 +0000
Received: from DS3PEPF000099D9.namprd04.prod.outlook.com
 (2603:10b6:5:1e0:cafe::70) by DM6PR08CA0051.outlook.office365.com
 (2603:10b6:5:1e0::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22 via Frontend
 Transport; Fri, 31 May 2024 04:34:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D9.mail.protection.outlook.com (10.167.17.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:34:39 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:34:32 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v9 17/24] x86/cc: Add CC_ATTR_GUEST_SECURE_TSC
Date: Fri, 31 May 2024 10:00:31 +0530
Message-ID: <20240531043038.3370793-18-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240531043038.3370793-1-nikunj@amd.com>
References: <20240531043038.3370793-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D9:EE_|DS0PR12MB8295:EE_
X-MS-Office365-Filtering-Correlation-Id: 9feed928-dbb8-4b23-493d-08dc812afc07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|36860700004|7416005|82310400017|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kNHObO0beHzohndf9cJn/kh9NufRkWkR2MkxKLWLJghrko2Os3c1bgRViybE?=
 =?us-ascii?Q?3MkBGvStiX4+lMHY5jdqkyUfF+dEOZf3qd+c7/ZJGx9azQQEWNTNaWhMJSEr?=
 =?us-ascii?Q?9n7CCpERRwEZrSz+vTQzszfQAFyccPOwsKdTnIval2tcXHD4lTCAvycwdgkO?=
 =?us-ascii?Q?LENf/H1S9L5Pd1AmLjBUxgGjxpQP/hys2VQO5bEQA+HIccM+6S1wwGiXVaVS?=
 =?us-ascii?Q?W6CTbpgvxt2/FDlYxA8jXW0B2yBicNY2KnUAH4g2qhw8h6cczlnuH9HAZJ6k?=
 =?us-ascii?Q?OTOOumFqNbXsB45FHcMFo9idAlp5BNTK7lTFhPOsl+p/vsXGq41Uwgbo1bdP?=
 =?us-ascii?Q?FOfmxPYN+uAxf+yhU9GRn2QABKCmV/Y01Pi7sZv0A7YuEQl0Ybq0qZpbcJgG?=
 =?us-ascii?Q?HBA7mmenGyOfzI1fyUtD/Yw7/rXqjXS/2OZlBPo2xDS2iQherBp9xd2zSuDh?=
 =?us-ascii?Q?0i+4YGb/frsqYf0lLutQk5c+AK9bt/tBmvV5CmMfOSFTxBYSoRoHykLqy6Bq?=
 =?us-ascii?Q?Yq6M4I3+I383dS5wxIMFikbi97QP1tSswkG4OpicAjTVlGptSP3sHAVA3IVM?=
 =?us-ascii?Q?3Hm6MQesO0XWvDZpkzlJPL/sHlqyXf+wm1baQ53jbn2QYha5RSPU61C7+b8D?=
 =?us-ascii?Q?/Mnnygttvcbl6ZkGdAjM4Gd71Bk8QYkRKQJZL7AbgayI6pa+3rYz2E/a6iUp?=
 =?us-ascii?Q?fmsRKJ1zlwws9IM6Cj6CIIiEirN7ZAjQkkR65sr6T53DcBuTqQAL+yF/HQ34?=
 =?us-ascii?Q?L02MDr7wwdEF1kQ42lDO+YmQkXJU+UVxNc/IXMAX7xKfezUJcG/NRtaJzq2i?=
 =?us-ascii?Q?4I1aiFhcHh2z2rwC8e8t7NMuMZ3ZNqeOxeE9facpBYdie/YDkycuqkaV5t3r?=
 =?us-ascii?Q?DE7Uc1AIlHhVYsrsamsw7WbUUDORHzx3kqUMDN1nUYZ001ZH6aTdr9/P5zu1?=
 =?us-ascii?Q?3qu1xnacJQALPJ+fe+Y9d+UjFlq/JgGqqUytdnQim5Py1Y5ZojESqT6NNypV?=
 =?us-ascii?Q?ntk4ocar6ZcwPy0SNpFT7VSDWEbSeQVAsE4xhHNNSqXes26Ewwt6sz8SYJgu?=
 =?us-ascii?Q?UptypYNj6y045hoQmYgfPOudWWBDeThU3j7jBPd70nZ9QvMH1r3o3n4Pye98?=
 =?us-ascii?Q?5nU0VB+kb7mOBSkbmwBH2mDJunycfzmt5B4opp4sXuc4b++Oye2ZsXfpKwyj?=
 =?us-ascii?Q?dIhYeYS18I6DPlT7cz8TUEA5hIuDHKzPc8hhGEehn71xvl74W5eaf2NXJ694?=
 =?us-ascii?Q?2I0XgVe1xGikTSxaE6r+E8KTwTlG69D6aX03gOuuHcWj1VGhjc+RPAVgqDc9?=
 =?us-ascii?Q?InwuC7zSWVQH68H5ZOcOGvdf/o/GtFkTUglDcVozvvJLcPyxSk2M/yOYdTCB?=
 =?us-ascii?Q?8vqFfnkmQEee7WMzZEz7l3Zdfit/?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(36860700004)(7416005)(82310400017)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:34:39.5775
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9feed928-dbb8-4b23-493d-08dc812afc07
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D9.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8295

Add confidential compute platform attribute CC_ATTR_GUEST_SECURE_TSC that
can be used by the guest to query whether the Secure TSC feature is
active.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 include/linux/cc_platform.h | 8 ++++++++
 arch/x86/coco/core.c        | 3 +++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
index 60693a145894..57ec5c63277e 100644
--- a/include/linux/cc_platform.h
+++ b/include/linux/cc_platform.h
@@ -98,6 +98,14 @@ enum cc_attr {
 	 * enabled to run SEV-SNP guests.
 	 */
 	CC_ATTR_HOST_SEV_SNP,
+
+	/**
+	 * @CC_ATTR_GUEST_SECURE_TSC: Secure TSC is active.
+	 *
+	 * The platform/OS is running as a guest/virtual machine and actively
+	 * using AMD SEV-SNP Secure TSC feature.
+	 */
+	CC_ATTR_GUEST_SECURE_TSC,
 };
 
 #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index b31ef2424d19..df981e3ba80c 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -101,6 +101,9 @@ static bool noinstr amd_cc_platform_has(enum cc_attr attr)
 	case CC_ATTR_HOST_SEV_SNP:
 		return cc_flags.host_sev_snp;
 
+	case CC_ATTR_GUEST_SECURE_TSC:
+		return sev_status & MSR_AMD64_SNP_SECURE_TSC;
+
 	default:
 		return false;
 	}
-- 
2.34.1


