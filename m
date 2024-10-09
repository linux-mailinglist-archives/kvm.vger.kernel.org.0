Return-Path: <kvm+bounces-28210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D9B7996571
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 11:32:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DB4F283E52
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 09:32:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFECA18D65E;
	Wed,  9 Oct 2024 09:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="q5GYggx6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2042.outbound.protection.outlook.com [40.107.236.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EABE1917FA;
	Wed,  9 Oct 2024 09:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728466193; cv=fail; b=Qdje14GWU1lPq0PHUMK3wS5b1ZWd+D/JHLI/LsnQA/KJ8MF4rb5wWNfg7cf4cjF/3ylVi6YLjKOsQfIZE1Q4QUc5f2gJ/iUjM0TVDaY6BaQ5k7kOLI0JKvnwZFbKaIVIqYcn91BW4g+QyZIug9OsHfp27b23Rk6J4LQ2yn+M+rM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728466193; c=relaxed/simple;
	bh=hD83E1aehsp11VqCvM0vzqfuin9p9sY2/4eGUpOGtrQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U5Lf4ZEhg6hnnNWEo2043pIHUJQsBTyiZEi1ZU1GfdwdN+hx4M0CvdWYKRBCh65DBXnAcueY0iPPRb0Gru5zpLQyJijNT8X2R3GPmy3BFMJPAlpcyvJcqp4CzqZD+c7BwBBt/c2Iw3Tt0dSiTAcfxlhUj0bXjVy0kg6S0WGegKE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=q5GYggx6; arc=fail smtp.client-ip=40.107.236.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s2FhXFimGllt0B/UlTW8EStNgs5leTN7Ilm/WhmFAQtyLZRS2G8LNYIU4RNU1qpOsaky7qnUw3zrbk0MnQoQ7dSeU86cDxICJO3NwWXwBQLlIzaWj2G/d1Uw++IC/ilgVrkgu2t/vEYhhPkZq0V44se/utbtJKIpZkY2i8akPhn5+lL4OTOgLJigoD/e+8M3LlpTNKzZQtHAKce9OwinxX2JXySPS3RYWJo3aCVCFdFqsJ/6Oeu6WNlU2EtE3J9zJX5O+b2zDKUwYcn6CueKT28ruTaMJn4Rzxc0OKdxakVGX4yLXS3jZk1ZnHKuOucqvJC8Dh3rVjxgrfsQS5JF3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5A3zp5wIJcnN7HLBQZG98u/tCcRpuyAUHM79cVOraSY=;
 b=k1XU04nAVgaLApwBBTod7pQs+bNWZY9K7btrMjyQyaZ39dbRD2brz5/jAcbXI6MgFxGsRAN6ajGVlNa3P0bUM3yvzp+gVC0EMUr3r5vtF3hOq5HQPPFz5QQxn6866QAn09z2aISc+ZpDoRfJlDwfDKVqd6a4AC9Q5LJLa1QpxaLLRZeFrpiUXGncuMyDNu/NuKlziGpn7HeGwqOADBuzUq9bNPjAuPCkmMlobL7gnBb0Qa7D0jAbvL1XKLAPixrf5InIWOTxuLcm3lFpfpDIUVJfI84dkD44CmyGxJODVZs7jcAjGT4a9OYS5vsOveBJYKFwaiMldB4+7waAibUOCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5A3zp5wIJcnN7HLBQZG98u/tCcRpuyAUHM79cVOraSY=;
 b=q5GYggx6cSMSS5blMmksDlB3yrkRiSMwFDsrvWG7f9l/Ef7lyhPK43omJnHwoygbN7jPkOFCvqtSsn6rFApCmUoTl0oveOJknsMsB2E1ii9ZoDN05J3sEArE1NUIV4WC2ZB3+7/2soQYKT7vV2WgfEXvjUIvpBwRNK6LqfGWUv4=
Received: from MN2PR17CA0020.namprd17.prod.outlook.com (2603:10b6:208:15e::33)
 by DM4PR12MB7648.namprd12.prod.outlook.com (2603:10b6:8:104::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.23; Wed, 9 Oct
 2024 09:29:44 +0000
Received: from BL02EPF00021F69.namprd02.prod.outlook.com
 (2603:10b6:208:15e:cafe::af) by MN2PR17CA0020.outlook.office365.com
 (2603:10b6:208:15e::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.17 via Frontend
 Transport; Wed, 9 Oct 2024 09:29:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F69.mail.protection.outlook.com (10.167.249.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8048.13 via Frontend Transport; Wed, 9 Oct 2024 09:29:44 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 9 Oct
 2024 04:29:40 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v12 09/19] x86/cc: Add CC_ATTR_GUEST_SNP_SECURE_TSC
Date: Wed, 9 Oct 2024 14:58:40 +0530
Message-ID: <20241009092850.197575-10-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241009092850.197575-1-nikunj@amd.com>
References: <20241009092850.197575-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F69:EE_|DM4PR12MB7648:EE_
X-MS-Office365-Filtering-Correlation-Id: 99bc1bfb-b5fa-4a1b-7a33-08dce844e8ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0KJ9Pk3Hs2MA6XH88xjw4F7MpM1SKNYIt3+B+93wbPxyVZ6CruxUIjkSummM?=
 =?us-ascii?Q?bW2ogHhmEH8F42PfOiRgNxO571GhqYd+T+Q656pUFiDCGUX/D2GTQGTD8im4?=
 =?us-ascii?Q?Pm/u5wE/z+FI12Tqg1XVYZTM0H7DN8mnK88nJuKuvxrVv/qypLMzHcXkVnEq?=
 =?us-ascii?Q?SXSXThq9ajnqENmscFl/GVrnNJHOHI2nt71zez1uVowldmz3ZVecNEXTZFTK?=
 =?us-ascii?Q?DTGsvOlFGy1RLbjHDtM3P/i8K7VOQ9fESupDuD/zhSnOCp/RASmNWrEmpYMT?=
 =?us-ascii?Q?1TGPeSqa9EHNMoOGo0iukGL7U17VmbIrDRggwqpnO52DWsvCICHITE0oAt/f?=
 =?us-ascii?Q?wWABPGbzt3KE3ahwKnbfdaKDGAhUzbRkae7JrS1ios/srgCo+P9vHy2evXYF?=
 =?us-ascii?Q?NE32uMazcLVc8lE+T+Ur2xH4Eja+Po4qlfrXfXb+d1ATwqmYD6StxOcCAPeA?=
 =?us-ascii?Q?EDnrdKF5D7dnR9VRFUOd6SafSKYzWLBc88EM5lRSkrkz55qeflTxfomVlae4?=
 =?us-ascii?Q?EPXGTrM5K1ObUqnkSG9pQ57h1A50MbO43AbpxPBl0dp0+RWpUA98jK9wBAak?=
 =?us-ascii?Q?wZzq9riKNVko4Dbmc8+QDw6shVOJHy/cWBm14A+hqrl3JUGguLcTHpj+WEvm?=
 =?us-ascii?Q?ReJFDlDqalQD0HKeBF+eHhbChMmyDDzNVw4dErduttp/7ofMdOAv1VbJBUtA?=
 =?us-ascii?Q?qq/5VV++VfkowEZBSQknQYeK+oMTprhmwVVVoI2BlVYntsmJrqgmp2WTLK3t?=
 =?us-ascii?Q?RcuGoeiFpYYDqFnv60G5hTrNg05elRDvOqZpUEh8wu6R0j/YMzJTXZ/Crjls?=
 =?us-ascii?Q?UeP2Ls4gnTJgxoc6sGQH5C+r4IFIiLpA/Y0A6tZzBukGt31T/+eAKnVGR6mW?=
 =?us-ascii?Q?WFlRqToeeo58trZvszupvsymWN8eyCrLMFF+83l1a/SUiH4+cTg6Z4ico/Lt?=
 =?us-ascii?Q?ZxanMF0iMP72ToMsL5Og4oFHwX6k7Tjh87hSXCFMaTrdr7qK0FcA+L8S2+Nz?=
 =?us-ascii?Q?6zdIzfVB+L8iWY3efiPA55UJxqRhaLzW1k1oHo2RhA0BkyZzv2TFxjpdOiwj?=
 =?us-ascii?Q?imWiXN6hQnNzNF8MtYJC+n1iGkKrM1S7iILYMqgNQNzEV/AijRGHD8kLJaoO?=
 =?us-ascii?Q?kG1h91w906+686qupNbPfNP83zGl4VkCvHkWaq3f64hmZ0Aaa3bu742DblmB?=
 =?us-ascii?Q?qd6zGJ9C6YmAF7tUSEcSYf8HBU27c2/tY7wmvHrG9R5XcLnCPoAQM0BO0WyS?=
 =?us-ascii?Q?Am1lC5cMbV7hEMNCFwAltDida/rvOu+Sg+TX5BmUJg2hu1B0c/I3rcACPmPw?=
 =?us-ascii?Q?U7fN0oi4R4i/TS6PFW5ONk8KI9OSGINdUSVk4bbk+/a7iif7uUZFpyn14v+L?=
 =?us-ascii?Q?NVNFZ2/6UDvk611v5jNskh1Syzca?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 09:29:44.2087
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99bc1bfb-b5fa-4a1b-7a33-08dce844e8ea
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F69.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7648

Add confidential compute platform attribute CC_ATTR_GUEST_SNP_SECURE_TSC
that can be used by the guest to query whether the Secure TSC feature is
active.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 include/linux/cc_platform.h | 8 ++++++++
 arch/x86/coco/core.c        | 3 +++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
index caa4b4430634..cb7103dc124f 100644
--- a/include/linux/cc_platform.h
+++ b/include/linux/cc_platform.h
@@ -88,6 +88,14 @@ enum cc_attr {
 	 * enabled to run SEV-SNP guests.
 	 */
 	CC_ATTR_HOST_SEV_SNP,
+
+	/**
+	 * @CC_ATTR_GUEST_SNP_SECURE_TSC: SNP Secure TSC is active.
+	 *
+	 * The platform/OS is running as a guest/virtual machine and actively
+	 * using AMD SEV-SNP Secure TSC feature.
+	 */
+	CC_ATTR_GUEST_SNP_SECURE_TSC,
 };
 
 #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index 0f81f70aca82..5b9a358a3254 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -100,6 +100,9 @@ static bool noinstr amd_cc_platform_has(enum cc_attr attr)
 	case CC_ATTR_HOST_SEV_SNP:
 		return cc_flags.host_sev_snp;
 
+	case CC_ATTR_GUEST_SNP_SECURE_TSC:
+		return sev_status & MSR_AMD64_SNP_SECURE_TSC;
+
 	default:
 		return false;
 	}
-- 
2.34.1


