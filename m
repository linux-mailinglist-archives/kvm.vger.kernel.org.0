Return-Path: <kvm+bounces-42894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB9DCA7F9DF
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 11:39:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F00973AA020
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 09:35:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97A8F267B71;
	Tue,  8 Apr 2025 09:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4ryjhHtS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DC1265CC8
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 09:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744104767; cv=fail; b=IXfRH4ONMPPNHdAe0n6QXYY6TOBin5Fis1iGoyn/SZ70e2Pb+uZITSAC0111/gVpo2HXCtBbOUa2ZoGs/DzP66O3iBXfbXYGQsjciD59H6ekfJjbdCj7eqTPE0hDLl2NpLr/pO8U+mw9QhKtT76Z+9xfzC6TBXE9EnSiJAA7wbI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744104767; c=relaxed/simple;
	bh=2FomvMLMKs+/WtZnjYoF1gAsFLdtaFLK/XOv/valnvw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lufzbOyW5c+JVyXvRmkQ7N/oWNTeC1xGyDtGQHZZ9hnksYqOAfNZ1Aj3Ocddfp2NuL85lk/iH2+CGdXls6tUsUBclVOupwJv8PtQQ/R/vlTYygmouXbflKtpbblqEHvVdAnd6YNqfytqL3P1IsWHcj/VjqJQVocALAsPj23A4B8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4ryjhHtS; arc=fail smtp.client-ip=40.107.237.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jvTCdkNJooDAW80JxhebWH9edcxBAf7wiYgFlR6o2qrczJbevJ68PMWV2JZqlDQiMBgrBVZKR08Amit8ej2ZW6zDxkRh67IOzhr6YDRxMIhSHPBwkS+G4zNamQz8mKMsvMxs32y7ecMJUJYESQwo2yTAGbfYQDeoied20nUXyH/ysReXW8DmDKLf3BeUUefkZvw2UgQ4WFZFv2IKtuX5O2StHcLmc4i6FPT1j95abg+H047lk8Sg9t7pt0yAKzvACOY5QlVPcsb4z/Gt/ph/tD2eOYvCP6vYdQ2n3zUtQXhGPcirRrlIeFKlwNyIlwsb8IC5LEG/tjDu+uIt3jZQNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+TBApxq1THnEy8OmubMXCMitXGifIv63WPsj0rUnnN0=;
 b=PKwbT8U0v0HoOQu1mz6FoDkunZnvYKW69NtoRCAL9iZCvhOvqhfIQUnDi+v8ssIktSh0jLw6uiaGHeqdd40w6qlCTW4qOFfVdOhlvZbqtggOVfeRO/aiG+8LNHwBHZG/OrnZBhzXPihOZiCjGnryIPb2XaGhmxYV9B9nw4N5S0KvnDmbnSC6wG8RSOeMP5JP3Oo59k4JbF2xBIxJex5muqqRPvcY90mjsBuLtHgdLvOtmVwDs9PPHLWzzon+fhh/0U7ruaMSbDqBOfR78W5YAXGdu/3U5cdg3UJ6VYb4gBO1pxasaCfdmHuNn5xZyl55EW4EHOMCY0NUvWwCYkZw+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+TBApxq1THnEy8OmubMXCMitXGifIv63WPsj0rUnnN0=;
 b=4ryjhHtSUphdLbvST10fILkcRx1nnLQ8fEm+a4p7xc6azx6KrgHf7cMY1hU43vCTJuvi+Q70t+6I7nB4ma3Q9wqjR7M+DB/I1BgsO9+ANNH2rDS1F0PfnI22onnkfVmtwkBj57NU++x93+HSX5diVk5EFCLcvBXgABDiy7ecq14=
Received: from SJ0PR03CA0099.namprd03.prod.outlook.com (2603:10b6:a03:333::14)
 by MN0PR12MB5953.namprd12.prod.outlook.com (2603:10b6:208:37c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 09:32:39 +0000
Received: from MWH0EPF000971E2.namprd02.prod.outlook.com
 (2603:10b6:a03:333:cafe::fb) by SJ0PR03CA0099.outlook.office365.com
 (2603:10b6:a03:333::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8606.35 via Frontend Transport; Tue,
 8 Apr 2025 09:32:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000971E2.mail.protection.outlook.com (10.167.243.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8606.22 via Frontend Transport; Tue, 8 Apr 2025 09:32:38 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Apr
 2025 04:32:34 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>, <vaishali.thakkar@suse.com>
Subject: [PATCH v6 1/4] x86/cpufeatures: Add SNP Secure TSC
Date: Tue, 8 Apr 2025 15:02:10 +0530
Message-ID: <20250408093213.57962-2-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250408093213.57962-1-nikunj@amd.com>
References: <20250408093213.57962-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E2:EE_|MN0PR12MB5953:EE_
X-MS-Office365-Filtering-Correlation-Id: 6532ae70-c80e-4966-25ec-08dd76804d54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KtG3zFt3hHpDbKJP0SeULtY/DD0VNhnkE+RWHHVflLFibg8BeonRocG6J+sH?=
 =?us-ascii?Q?hzU3TcE6ycByQoy1gmq6wjdNLKlnmF9sD4YRkVAb9YtUj+HzB92vgOAGGlGD?=
 =?us-ascii?Q?H9qFnyD3kTLzRFGcqxAl5gKUwjr5i0jbVeDxnC6RecZPPs6tRWNKEb2Sur/z?=
 =?us-ascii?Q?PxiMxkn0TjBOszdJ2ONAZak1JMJkknw58wBy+UdpP2uBlosJj5JFywwIlvnD?=
 =?us-ascii?Q?5gCvbjjW/hsMkyzk9P5QRFVT4YJNF0zIsXrA3Tof0595+6Qsu+nZTuIGy4xT?=
 =?us-ascii?Q?LK5jk1++r3WpwFiK360Nb929oyf3uEKZiW8FOkB2fMDdnkL/MpzxUdk/n1mU?=
 =?us-ascii?Q?rnSDHvfO1Z4tZe7fEVSfjH5P3ySneKfFb2SGP2yX3lHrziu2NGXD7VKH6HKq?=
 =?us-ascii?Q?jyk/HOUw4KEM7SVENp7mYnKiqqxmFya0X2q7M+KOFKQcQylMQspWoSfyN3VM?=
 =?us-ascii?Q?cbLHNWmdjc/dj/W0u9B6PgZl32v96No1Vr/qPsv2ukegdQMh1U7ejIkecxCk?=
 =?us-ascii?Q?jfGZU/vJHC7u3BpZ8cxQek7LUE+GxNufGgMqc1B+5fKujkJa5ueRhUqYoxaK?=
 =?us-ascii?Q?oC4+gflxIakr8gP6wWqpluy15uMRFu35SlJRAbMRqPUsG+L0DWHXNtu4Rokc?=
 =?us-ascii?Q?RWCDRes0iAFSevtYiww7MNodjdxcLkRo3w8sSF3oOZJeZhCdALZ4SxDKGQba?=
 =?us-ascii?Q?UIggkDx6pMAt56d02zB6nCl39MraprVlMsqCUxZtn+O9BUg0M/xB+1hwrPmw?=
 =?us-ascii?Q?Uer+ZhlZ04532RN1+iyNvOm4DQb7ip2Nw9GyT+2phDlcnQn2bDHDGXZqA+EH?=
 =?us-ascii?Q?TgqVEZovCM3iWvpY1fdqa4fdx/iGyeCdhvv7t/ZC3GgDqMudnm1X8Xn7Pd9F?=
 =?us-ascii?Q?KK1jSBSHcOANk+bryMquaaHZ7d7x160B4G0NMmF5xvTjOm4Nv2nnvOa2nAU+?=
 =?us-ascii?Q?zyJIJ12MHfcMFvC5/9VPkZ8kcuCy8mgXzHdD3JGCnM6vomUKpqZR9IABX6Pq?=
 =?us-ascii?Q?+XAyFE9bPpWrsgsdCOgX4yMtVmiPJ0Va3Rao2C2ZONpsYuqVphEaaR27uj1y?=
 =?us-ascii?Q?ZNDCNurd+rzCylXVfVtREWKjzjE2lJ0zLovSnI3FwJ0QtJYWW473cX5MpAZi?=
 =?us-ascii?Q?yNq4TLhTSuXQOjsnU4H12nLFv8O0f9wJsQUn53YMRcwoZ4tKRTyfkUmd6L8j?=
 =?us-ascii?Q?pdVb95vLT/XYEJSgPh4Q7LS3ow+8CpAmVut6hcBRsPYA08QybdFlDg/Uc8gA?=
 =?us-ascii?Q?jW6ycdU5pxNHCCBpLfy3tfKdicZCoO+5fH4XRupnRGGYurMAr7Ln1dUR831m?=
 =?us-ascii?Q?CYVzWYhlgd6NPXaerLzPM30mRZCW9YFGLnT7wT9OHtFnWMYuS7KV2ZzO59Kh?=
 =?us-ascii?Q?KIDDW6IOOPav0RYFQ4XiiQ5XLW2sfydWxUkoWZiq274hPU62BFWW/oYylvAe?=
 =?us-ascii?Q?WB/oOBQ/0ZamKcRqKCzI10xAnHJSCLC7N55yigKNY6lUwMJjQhg9nTA07vzP?=
 =?us-ascii?Q?T1itdYsaqS62oW0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 09:32:38.0324
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6532ae70-c80e-4966-25ec-08dd76804d54
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5953

The Secure TSC feature for SEV-SNP allows guests to securely use the RDTSC
and RDTSCP instructions, ensuring that the parameters used cannot be
altered by the hypervisor once the guest is launched. For more details,
refer to the AMD64 APM Vol 2, Section "Secure TSC".

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Vaishali Thakkar <vaishali.thakkar@suse.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
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


