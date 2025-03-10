Return-Path: <kvm+bounces-40570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C77B3A58C3C
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 07:44:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5C5FC7A383D
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 06:43:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 524FF1CC89D;
	Mon, 10 Mar 2025 06:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fT/BzMMR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012FE13A3ED
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 06:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741589053; cv=fail; b=CrSd5sA0ppdOthdWjAPuumlQYyJHm+UGQz8K0Pg0O5t+jysQoOtpZpL2rPBcwQZY1KzccraSBauDy6qxyhDaElI/7tE1WZxw5m35wIT8ar1pw7BkTncgS1SjQ+ATsQPUTVMgbXzKbACCgWry2aLL/S5/sG7PxuSeOSXzGP+o+I0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741589053; c=relaxed/simple;
	bh=FxucCd6D/D/SrCVdpmvabJ2BYuE9w9loDgYd5jM+D88=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OmcTQfvODpvQ8LxwLMiNvD4ax8jiDHTp606bF79myy7mLbHxz/2BG3n4hFHdPVHj/AVhK/MpVZskfYX8qKhgAbqfyLoPQI0IZgBzzGOG1Hp+yrYBVT2pLttBRhOB78xK/G1YpOT1aurpc8cYU+NnxTuKfbGhbym2sVAhR3RIArM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fT/BzMMR; arc=fail smtp.client-ip=40.107.94.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JFU1RN9EKU3nS+H0kIb4mFHD8NhHQwjG/onwX8tvvS9e1qMJzwbVpUsm+6iabGPiE8VKEOySvEuJx7F8eZlUUsOgKAH7R2ljWIwf11/V5tPlPg9wP9eJWdfG3++0++2LEib2dGHNp6GJ0Z/kKJ5QTAbCJMVg+M/ekNYDzlER6mFNWuoBnpXTbHlNY1zO3Ldf/XQTpTlF+u4b1XgWs9Ltb2iF8ZKHjVcErLAOfSkCyUBVFz8r16rb77r9cuWnfzaMQPE7qxkmZzM9I6MYsCOCzLfDANkK9jCay91ugGTtNYMRJH5Vd0Cddc7kYed3n3g5w6cYne7iDh/iMU+tvWBoMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rI4speJcl2fP4AKM3hJBsQsZcZxC4vb+Ho0l2dvzN2Y=;
 b=dFjQ1ilhDs8q1H0ZpqjPEO2+zZNrmqUAmXE3lo2RgA0J1RMyQPOCJYVuvlH1smb706xsSta0frWO6RWIyRZ2xAFFZ5s4dZ28bfqZGNmZLoUlPQ54arXPlgH16MGKGFsGEcsQ3AmKKRxZTWViNwuELUSfFewm2G1hNwzWGFPq3n8P74Bks+s407Qy2H5ICjErBhNFd4JwSaS7e6tKjsLAAaJxg8iNan3UBZo9Ne8BTdGk8nKEYbo2TLOyeZtwGb/J6Tv0lbr64NnrP9Dmm+Wf6Bq8zOr8o2UbNtiwNJMNuiVFF3uCqk4zMcBW7xCprBgwBgvjYtVDk147DI+/RHxbUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rI4speJcl2fP4AKM3hJBsQsZcZxC4vb+Ho0l2dvzN2Y=;
 b=fT/BzMMRNTO6lzRORraHeGzcDcIrZlj3RF7YfccD+tbIMtq+doSJhyzWElTSfLStgKJxU7avjI29drOk5YrJvHwSe8xpGHpwaa7x49Du9pgDmQ9IKmssspLhVTpst6iIR/d5ENTaFiDA9pZEL0mGcOfSGbuuVcn/kP4NmdhwQX0=
Received: from BL6PEPF00013E08.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:5) by CH3PR12MB9196.namprd12.prod.outlook.com
 (2603:10b6:610:197::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.26; Mon, 10 Mar
 2025 06:44:07 +0000
Received: from BN2PEPF00004FBE.namprd04.prod.outlook.com
 (2a01:111:f403:f909::) by BL6PEPF00013E08.outlook.office365.com
 (2603:1036:903:4::4) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.26 via Frontend Transport; Mon,
 10 Mar 2025 06:44:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF00004FBE.mail.protection.outlook.com (10.167.243.184) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Mon, 10 Mar 2025 06:44:06 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 10 Mar
 2025 01:44:00 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>
Subject: [PATCH v4 1/5] x86/cpufeatures: Add SNP Secure TSC
Date: Mon, 10 Mar 2025 12:13:47 +0530
Message-ID: <20250310064347.13986-1-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250310063938.13790-1-nikunj@amd.com>
References: <20250310063938.13790-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBE:EE_|CH3PR12MB9196:EE_
X-MS-Office365-Filtering-Correlation-Id: 735c46d9-31a0-4b90-cce0-08dd5f9ef488
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LG+8mLYZLZfYjji9NE0VaIXvVq0eVDudqzyj669xzxsT9pMqtsPOfgc2Uqi0?=
 =?us-ascii?Q?WtPUYcFRrKgIANCQVIcC2juUxVwZYWw4udDB7oWHGJqyLmhheB9xMOQnUp2Q?=
 =?us-ascii?Q?CedtewSSHA09Nz+CYiBpfn+c1SmxC0tBxRffB5aET0kpaJchfms5J11TJlh0?=
 =?us-ascii?Q?r3x1STDux+F5dDv9XJ/b9QQVGIoHHJGlmkxQTILpZtU7yYOvAXgXSbLXZlXj?=
 =?us-ascii?Q?0Ja/sbdBsRV+9QxuiC3u3LHXkEqHyd9RAxdRGqL48RKRH5Ak+YHEVSJCajKU?=
 =?us-ascii?Q?J8V5u0qvSk3emy7MhUkZ2L4Hdu5c/VrruEelU2jr3PqAK0b8lD+xmVhUjWlA?=
 =?us-ascii?Q?iuoL4GO3lDl3ebdvma52Y6koUaV+83u20UKsaSytnJjhdvIvCXIFqNNZ4yK2?=
 =?us-ascii?Q?fmzMgNtfUDCa4nNTuP2cIRAOR3zMSrDDDQpqGwq4n5Nb7LjtrCVtK3qpIfWl?=
 =?us-ascii?Q?Dudy993SlbALiTXsN5ViXYKj/3+rBCNIesBJEW3gMzsPedl40RMzHpTUWy7N?=
 =?us-ascii?Q?cZgjDyvSw05iWkfd/bNtwBCOtItL+SC7hUwEeDXS//4OoD/5Rgl40KfkBZvA?=
 =?us-ascii?Q?1VhtSP5gbd7VlERmwOeRdeFolJ0Q/GmpsSUL980ycx7BazQWtKiT3aGLXAkG?=
 =?us-ascii?Q?FGto/LxbQHx3ArMAV0rJcQKYU5fzwkbyXfWgxzYxF0uOF1xbkRqMCtkwnici?=
 =?us-ascii?Q?e5qbtZrZ01E2nBn3r0BluTmnXf+bnSFbUZxxrCZRAx9ALNznoTda6QlNtLpp?=
 =?us-ascii?Q?UIJsAbk8pVXk57RSef5QTKEvHaYvS9ZWrgNdX/KNTvrl01y9Vyitaiabyo3s?=
 =?us-ascii?Q?d95J1z4W1TDoil4qC3b28aTAnGJUb8VoV7d8xhkOCBBMwmgwg0MyIsraZLIp?=
 =?us-ascii?Q?pfonJyeYuGDDmj1GXqxgnLW6NSA7Yg4BcZ55gP9uC5v91xthf8ml3keu8Xj+?=
 =?us-ascii?Q?+sp5T4z9B4HYwsoiBiXc+Xr4hc4lZb9aTRzCxq2JNOFuSnOKcoK5FmV0RQ8h?=
 =?us-ascii?Q?H8uuGG/NGwaXeZsi0aFcx+kEGMNB9vQOw4OzFA7MlYF8pPa0Q3JBe/urXkdr?=
 =?us-ascii?Q?JOtzXl1pyyfvY3GVPoBDfrQi0OrGc6fwMYkr8O1NjAspfWOgcGmHiPFmr2H6?=
 =?us-ascii?Q?5DCEZEk91FqKUmgAwzma0bmKGUspXalM87fNfyzFEi/BI8/bDbovnovvbpJ3?=
 =?us-ascii?Q?p1x1M2ESAVlSCdSuHRXCInhnBRXv+3T98rqLB7sFP2DvKnbUGARV5Assys8D?=
 =?us-ascii?Q?pBEf03Ih0VYUWGONzzqC7KNMCDcXyGF9RHHUMkc9h21o6UL8c89c5UdXPAys?=
 =?us-ascii?Q?UuzxckDV0WXKuufxzfvRN6IcAIpDZCbRpAQQnzdnHpOdtGPaXAHqvDILI0NA?=
 =?us-ascii?Q?c4qMLyD8MZL8+40alyutcyWPhUshpZVyUwSPVE8k/Qmvdyiuiy6uTrkXNV+J?=
 =?us-ascii?Q?BgsE122RRfMWWzKvsaepPRclCc1ZxHACxItSrfnodtSJVSsd1r+ZSZwB686c?=
 =?us-ascii?Q?oZE+i/dBppe9Dd4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 06:44:06.8087
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 735c46d9-31a0-4b90-cce0-08dd5f9ef488
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9196

The Secure TSC feature for SEV-SNP allows guests to securely use the RDTSC
and RDTSCP instructions, ensuring that the parameters used cannot be
altered by the hypervisor once the guest is launched. For more details,
refer to the AMD64 APM Vol 2, Section "Secure TSC".

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 8f8aaf94dc00..68a4d6b4cc11 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -449,6 +449,7 @@
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* "sev_es" Secure Encrypted Virtualization - Encrypted State */
 #define X86_FEATURE_SEV_SNP		(19*32+ 4) /* "sev_snp" Secure Encrypted Virtualization - Secure Nested Paging */
+#define X86_FEATURE_SNP_SECURE_TSC	(19*32+ 8) /* SEV-SNP Secure TSC */
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* hardware-enforced cache coherency */
 #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" SEV-ES full debug state swap support */
-- 
2.43.0


