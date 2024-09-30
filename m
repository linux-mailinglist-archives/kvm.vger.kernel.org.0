Return-Path: <kvm+bounces-27664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C12C989A4C
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 07:51:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D33181F21BA3
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 05:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EC4A3C466;
	Mon, 30 Sep 2024 05:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hSyeDSvd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B245F2D7B8;
	Mon, 30 Sep 2024 05:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727675505; cv=fail; b=FPw9AtCtS+GBvKBLXEgDUGevyPyzd5WoRuG+LQIw+6hsm8PNrsXGZEzJbqHABysDzPLhR3+hmcyWIYkpLHXyAlhRHjcT66Q1EwpwubCO4e5DpkXww5UmZfvtoe3F9RsaVhP5QKyeew1K+heyoqkzxZmRBDqCSiF/EWuyh0oh0Gk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727675505; c=relaxed/simple;
	bh=ebRI2CfcmGvxA+kJ9GNE3pUNIIMBn0WXkNGX95zgXlA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sL7eeQNhdRludYSajLYLSmB/trl5OZD8b6rkDEIykQRgwA5DBisLbwTXt03/xrfEGPA74PidD+6oHnDDOSaDTUDD+GpYqIfLegvmTUi0vg7MK4upv6Ixtw4UNWf1iKnKWlcdjQNHy3gL2Tmn70bRrryF/J5nFRGQ/23tgJcMbho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hSyeDSvd; arc=fail smtp.client-ip=40.107.244.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qjcm/2bJB1bSGaZKbk7rcYgdU3BvOKjQtYoFBBQVXVtZEiCH3Y7gjVDNHrVMC/BlBRWtduCFi7yNeHYpY8RnuZMjTNhcgUXLHoblwrSX3pQtxgz0r3TxhzDEpYKoYR8flify9Wmq3C100lkF2nTDAVCm4QmKkCyZMkguGBa06Jd4FO9wkZ+RTJl8Z9hrqURHU5+i2Wdyj4RIElgm9XSNih+pHWgDGxB6iMYovyx+hKxkzFuertS3Vm417+h5eO42EiucLH9kWyqyzQWRuJFWo96Oz4UJ9J2vfMjCRjCESOhTK3FN0kJxULIe2PvHg8WczllF6UmQxOPNPm66bBHd2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qs46or+RWY0H641ytAqfmyEdFPGIr/umifWyuHQT/Tk=;
 b=H9C8TOI5G8YhmfeprGZQmaP7ldrSdIPGWTsjOJpZHJxOnBvkSxYz46JiykvYFjGN9g5ptxImWJw8XoXG1TI1p7FaTCV05VpYujIEN3vkXIpy+rteBCrLyVBYMWGF/a9HqTCuRtDSrHGkCFtuBCty+aRjRnOtnBCBkC6Y4sYeoj7rFYMQ4xOxbyCDAmgC8rbCYGvtjrWbNICIlOxajhN58Q38/tYd0xxBO//X0G4rFTbYVrn3JOSpnjRU3mbvhn7Ri3nmRNDzdxnyuzXaxbJ+5VVxAkvZEjoUSPMngtvpFxY49X3KdHUFay8E/CgoeT71QdvYTn2rXshHsspCuP8PPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qs46or+RWY0H641ytAqfmyEdFPGIr/umifWyuHQT/Tk=;
 b=hSyeDSvdiHcPp5zK/gwHfb+ab8Q9Kye5C66+P61wMUs+mEMwVk8kn+X0CF89s8LQZI4atALX0uEyjfYjRqKTAo7ID0XPWQlytqBLP3eIhNs5cw2/RGzFRLOxCWeo01nITQmAIDUnrMF93JISIY9WGOJmLZ20EeVZ5HM52eheCqM=
Received: from SN6PR04CA0105.namprd04.prod.outlook.com (2603:10b6:805:f2::46)
 by SJ0PR12MB8116.namprd12.prod.outlook.com (2603:10b6:a03:4ec::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.26; Mon, 30 Sep
 2024 05:51:40 +0000
Received: from SA2PEPF00003AE4.namprd02.prod.outlook.com
 (2603:10b6:805:f2:cafe::9e) by SN6PR04CA0105.outlook.office365.com
 (2603:10b6:805:f2::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.26 via Frontend
 Transport; Mon, 30 Sep 2024 05:51:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00003AE4.mail.protection.outlook.com (10.167.248.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8026.11 via Frontend Transport; Mon, 30 Sep 2024 05:51:39 +0000
Received: from volcano-62e7host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 30 Sep
 2024 00:51:11 -0500
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <david.kaplan@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH] KVM: SVM: Disable AVIC on SNP-enabled system without HvInUseWrAllowed feature
Date: Mon, 30 Sep 2024 05:50:35 +0000
Message-ID: <20240930055035.31412-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AE4:EE_|SJ0PR12MB8116:EE_
X-MS-Office365-Filtering-Correlation-Id: ae88b105-5f4a-4941-0773-08dce113f3e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VEQvWTNqTCtPUEF1N0FzY05ZL244VzdNVmhsTVA4R0pYcm9xQ2doM0lneG9S?=
 =?utf-8?B?VHNzQUh6MHhlanJyeFBQRDUwVjlreXZVZElIMjdXTXhwcmhRZnB0N09sTFA0?=
 =?utf-8?B?eWpaeGNwYmRva09LamxISFk2cDdUczRETjZWTVpJcGRjZkdQNnlpWk01Snp5?=
 =?utf-8?B?MmxuSnhTeURQWXg1Ri93Q0tiTjdjM1U4dlBNMi9RanBOWExpNTBrY1E2emh6?=
 =?utf-8?B?ZDNmSmR6b2xzWmVLR09aWUVzUzdka3RwMmJLWWFFN21BZWFnNHFlaUswUzBw?=
 =?utf-8?B?Q0RWUTlJZE13WUZYb2N5TEtGeHhkYWdPVlNGS2N2dndrSHlLNllPTkZOUWgz?=
 =?utf-8?B?MTdDRHBGK1o1N2czdnhCN1pSeUMveTlmMiswdWpHRlVGR0laaGxMckJadVhJ?=
 =?utf-8?B?TU1Tc2lsZlY0Vjhicnp0L0d4cXFLbVFlZkszS2xLZE9vN1dEdnhGcVJYYXdL?=
 =?utf-8?B?cU42bEIwYlhWSW9MTVd6OTZESjFlMFRXSjU2dHMwY0p4VFg1U1lFbWZ0WU9T?=
 =?utf-8?B?ZkxLbGo4dll1VXRhek51cW0xcXpLUlVxTWE0Y21NcnRGWTBleWU2REw5eDNU?=
 =?utf-8?B?V2h0OWNSSmJSdkZXUnJCZEhId2xMMXdEV3IzMEtkUG5UQ28ya2J3Q09OUUE2?=
 =?utf-8?B?djFXSWYwQS9yaVF5ekEwTVFoQ2QvS3lMbVNTOVpaTmpnM0M4VjJoanNzN1Nm?=
 =?utf-8?B?M2FIeEdlcWhMNXJBQ09xUEZPa3VUQW9YUC9lcW91bWlDRW9RWUJLMURwaDda?=
 =?utf-8?B?NGNMamFiWHlFV0ZZZXdObVArY2xobWI4RWFlZjEvUEpiSGNJMlBjZlc4c28x?=
 =?utf-8?B?blBmQXl5S0lTNWlxODJYM2orN1ZFTE9JZ1piKy8xeEhPWVhQQ2pUa2NBWU9I?=
 =?utf-8?B?ZVFWWUVhWVRtWkVORGcxeUhFM3Erc0xmKzkydFNEUHRrMThrb2RqOGNFNWJZ?=
 =?utf-8?B?aXEyVVVnUGVpT1hrd1I3SkVTSERuSXZodmtycjRhMmk0akxUaXZncjRYdHV4?=
 =?utf-8?B?NlljQnBhc3ZFSEFZSUNFQzRYSDlsbUhONE54NnRYWHVpdHBwMmlFRWFWUDBN?=
 =?utf-8?B?cGt3ZGQza0RpdGtMa292dE1NZUFOZkQ4bDBXUjMwMjZUckxOb24yY2NIYnE1?=
 =?utf-8?B?bjl5aFA2d202bE1wTWY4RVBUNjNORTVraGY3TUpaTXp3Q09OMU5uRS9wZUty?=
 =?utf-8?B?bmltT2ZZSXlBTHlKRU9hRmFwQkFWUVNoWEp6U2lQWnEybzB6UEh5K2xKQ0xm?=
 =?utf-8?B?WUpoaENDYmQ1eWxlY3E3alJZZGRBMVRPSTIyZjYvWXJ0MmNPRDNHSUtJOXpV?=
 =?utf-8?B?czJ5SER1eC9sSHdCMnpjdU5zaGNjVkhMdDVKOG5JUEV6eE5GZklHdVQ5bXlH?=
 =?utf-8?B?bkJxWjNHcnZlYm81WEtjRDV4UTJzZnB5bHlIY1VWYVMzNHJoWFJjWjlFMFNX?=
 =?utf-8?B?MkxpeDNnMzNxMXZ1Rm92cHZiQndiNUViZk5aVnVkc3JiS3JEK0NNaWVWS1lx?=
 =?utf-8?B?eFdKQTROYVQ0ZURWbHFNNFZSSDVoaFYvZXBBZWFBcXp3NFZrdkd2Qm9CRTAz?=
 =?utf-8?B?R21MV2ZiZzlZZ0c1VW5XR2E3Z2ZTeXI5cjJsdFNWS2xtNmJ2L0VoS25xVHZ5?=
 =?utf-8?B?V3ZTM3I0Nis2dENSYmlMRWkrU0lsTDU4YnhNWkFXV3V1ZXJOOVJ3RnRiVk9k?=
 =?utf-8?B?T0N4NW1JUm9hT25Qa3FxYmFCdHZtVE9xbW16V015RTF4VXI1aTdSTElrcVQ4?=
 =?utf-8?B?T1d2ZWRwdEt2MmZsaW1FQWRkWm9jU083UzRCVDJqV1N4ZFFlMGlXV294SFJP?=
 =?utf-8?B?OTBWOGFLakJReEhqS2tLVy9lVDhRUFl6L3o4ZFBBVU9zYW1oMDdZVHVxNnlG?=
 =?utf-8?B?RVlJSzd0MFhFMm1MQ1V6a0ZlMEF1YXFyam5YUXREWUNZV1RLbTNDNTZZaHp1?=
 =?utf-8?Q?lqjRHP3YYdsfqvjiP8hp4cLqRra3wL8e?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2024 05:51:39.1160
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae88b105-5f4a-4941-0773-08dce113f3e0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AE4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8116

On SNP-enabled system, VMRUN marks AVIC Backing Page as in-use while
the guest is running for both secure and non-secure guest. This causes
any attempts to modify the RMP entries for the backing page to result in
FAIL_INUSE response. This is to ensure that the AVIC backing page is not
maliciously assigned to an SNP guest while the unencrypted guest is active.

Currently, an attempt to run AVIC guest would result in the following error:

    BUG: unable to handle page fault for address: ff3a442e549cc270
    #PF: supervisor write access in kernel mode
    #PF: error_code(0x80000003) - RMP violation
    PGD b6ee01067 P4D b6ee02067 PUD 10096d063 PMD 11c540063 PTE 80000001149cc163
    SEV-SNP: PFN 0x1149cc unassigned, dumping non-zero entries in 2M PFN region: [0x114800 - 0x114a00]
    ...

Newer AMD system is enhanced to allow hypervisor to modify RMP entries of
the backing page for non-secure guest on SNP-enabled system. This
enhancement is available when the CPUID Fn8000_001F_EAX bit 30 is set
(HvInUseWrAllowed) See the AMD64 Architecture Programmer’s Manual (APM)
Volume 2 for detail. (https://www.amd.com/content/dam/amd/en/documents/
processor-tech-docs/programmer-references/40332.pdf)

Therefore, add logic to check the new CPUID bit before enabling AVIC
on SNP-enabled system.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/svm/avic.c            | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index dd4682857c12..921b6de80e24 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -448,6 +448,7 @@
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* AMD hardware-enforced cache coherency */
 #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" AMD SEV-ES full debug state swap support */
 #define X86_FEATURE_SVSM		(19*32+28) /* "svsm" SVSM present */
+#define X86_FEATURE_HV_INUSE_WR_ALLOWED	(19*32+30) /* Write to in-use hypervisor-owned pages allowed */
 
 /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
 #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* No Nested Data Breakpoints */
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 4b74ea91f4e6..42f2caf17d6a 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1199,6 +1199,12 @@ bool avic_hardware_setup(void)
 		return false;
 	}
 
+	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP) &&
+	    !boot_cpu_has(X86_FEATURE_HV_INUSE_WR_ALLOWED)) {
+		pr_warn("AVIC disabled: missing HvInUseWrAllowed on SNP-enabled system");
+		return false;
+	}
+
 	if (boot_cpu_has(X86_FEATURE_AVIC)) {
 		pr_info("AVIC enabled\n");
 	} else if (force_avic) {
-- 
2.34.1


