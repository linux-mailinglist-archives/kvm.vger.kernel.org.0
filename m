Return-Path: <kvm+bounces-30450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 68D629BAD86
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 08:59:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E39821F223C2
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 07:59:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1234D19D086;
	Mon,  4 Nov 2024 07:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ebR08Cey"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2051.outbound.protection.outlook.com [40.107.101.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FE718E363;
	Mon,  4 Nov 2024 07:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730707153; cv=fail; b=obGOV1SAgt/hlhxVGWlpacIf3CqhAizjtlF3zTVXoDTd9T7FqM0aGoanbpLQKxPRb1FPbvpWAhZhuXXC75uBoicne4mwMSDHOCpIawOYLCEsDVsKQ/i+R4eQjQLSpF+38asVnGZzzTzKSG+hxuf5ueL8RuUa85aWa1lsTpuXaYw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730707153; c=relaxed/simple;
	bh=OLn3cfqtXAnNKXZQG1jaKzwcliGNyQur4Kr0VHK3AjQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hV5xEC/hEjLLUnJyuJfQKCX4b8nAhEUxhdWVUhkU6qGFpnvf3nLMMprNz8ykEG5TgWj3wXhuJ6CGQG+qU5KmOWnGDAwdqSOY/AOQCG/7ETwwrj387uq3BNZDeliGTuy9/LY0UkDm1fOtwyTY9V58U5JcSH0c7khYhEyPUlNfnms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ebR08Cey; arc=fail smtp.client-ip=40.107.101.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jzwowWi8QuttBBSRZN9WJGFAxXJK/Ttfw3XnxHb8nTti648wdn+g2zct1XT+XPoHfXbA87KDm5se06PgARxFfjTZ0DqmNwpSxRZsgkvBz3z6ZAmqPq0vdjYxNkDsMB4er80Pyzwq8o9hdmcW14iqRI6EBaus959UER7gMl1t5xVUzHOsFb+JBD8M5c/1e/0/rnuTjiWkUrh/Mubmr6QhhKDL7lDMEd3LhlZDrOsWUcQN4GEBZdbsMW1xXVQ9Nci0uO4MHmdnt9isIwRPm/ohQ28/WH/lhoJH8dOEGeXNo7Yk8HsqMHFoGIkYT/bFCGrl2bk+PX505ZU99nr9N/3yjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d9FlH64IdPN1Y+ZED1rz2MDJNIw3mhjQ7X4i97A3AkY=;
 b=WUD/GPYfmRgdhqyZ+FVA3VwLmQmS3wlKjEOKb/gFd68R5Nhjisa1KHD16AYfOI6wuWjxaJnpByAvkhQrwQLy3QAC4x56R8nTzf4pG6XgaHu/TpBTYDZq4X3gRMevbdB1jHmUlGaMdVtH352TZP2UjcalL9sOwIfH6SqQAA/q/udsgTva+AvO5fHZrVMKvLEsbz1InMFthtyg0IxnGHm4RRpO0sbkXmxKHlZN4dcodOSe16LddhzbaM1DIFL/qf2nVSXTHSbGzko1XK9LjD86FVSw13ZG1rVEm06r7tyw35ISqqTnZE8qXEUvP4bBP3LMSdjr9SEFiVEcEkBs1lJs2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d9FlH64IdPN1Y+ZED1rz2MDJNIw3mhjQ7X4i97A3AkY=;
 b=ebR08CeyIGTC0+SoMGVLPzXOWw8G2++t0qcGGuWfLITQwUofQvopKLHl0H9PXHLHaYZwdl9JjmL/o5KDeskScnPfSyeOv+J+zPVpMz5bAzPhSTdvb8upcikzNzopSYdOTrD8AnhJidnleI/jio+o5lXlYY78Y/BhUCRe67oWQCE=
Received: from SA9P221CA0014.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::19)
 by CY5PR12MB6274.namprd12.prod.outlook.com (2603:10b6:930:21::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24; Mon, 4 Nov
 2024 07:59:08 +0000
Received: from SA2PEPF00001509.namprd04.prod.outlook.com
 (2603:10b6:806:25:cafe::95) by SA9P221CA0014.outlook.office365.com
 (2603:10b6:806:25::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31 via Frontend
 Transport; Mon, 4 Nov 2024 07:59:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00001509.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8137.17 via Frontend Transport; Mon, 4 Nov 2024 07:59:07 +0000
Received: from volcano-62e7host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 4 Nov
 2024 01:59:04 -0600
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <joao.m.martins@oracle.com>,
	<alejandro.j.jimenez@oracle.com>, <david.kaplan@amd.com>,
	<jon.grimm@amd.com>, <santosh.shukla@amd.com>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>
Subject: [PATCH v3] KVM: SVM: Disable AVIC on SNP-enabled system without HvInUseWrAllowed feature
Date: Mon, 4 Nov 2024 07:58:45 +0000
Message-ID: <20241104075845.7583-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001509:EE_|CY5PR12MB6274:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dbde476-9290-4674-1d9d-08dcfca68f6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ME0yb1NVUk9vMkZOWC9aN2QxZzEwZnJaTjVmZkJtbC9TckZvdHFBaGFvbno0?=
 =?utf-8?B?MTNYbUFxSk5LVnhtck9WN1Vvekp3WGVKanFmdjVyUU5hbGFKcnAvV3F6OFRi?=
 =?utf-8?B?ZCsra1JCMzY3Y0R1TEFjWTZ6N0RkbVFIN3k4WjNIMlk2MFJ6ejhNUXBPaWVp?=
 =?utf-8?B?VnZqc3VUanVadnF2aXM0VWs4RkFWY09WcVFlM1JBWmFiSDFpeVdjZnd3U2VZ?=
 =?utf-8?B?Q1A5NGx1OVBEU0lCSDlkNks3enI1LzQwdkRvbFBRQjJRSFB4UW0yeE5nNm9W?=
 =?utf-8?B?djNNbjdiUjMzZEJ0WGxCQUN0ckhHakdzVndvRk52b2FndXFCZ2dHVlkwcEg0?=
 =?utf-8?B?MmZvT1VKcTZLY1dnSDBwYTNUMmFESHlZVUJML0d0SXpEMHFSNmxoYzd4Tyto?=
 =?utf-8?B?MWk2RFRPd2FMMEc3Z0JDdzR0YTB5am51OGdaRndMRWRzQzkrS3RoQXA2dGZG?=
 =?utf-8?B?WlVPd1hzM0haTlZjT0FtOTJMZjNqT3FNWmhDUDJPZVpmZ1YvWjZEcTBmVC94?=
 =?utf-8?B?WVoyZHg4SXdSZklOQ0pSYU1iVnA1Qm8rdXJ4WllYMzA4WVB2RUg4MjFyWks1?=
 =?utf-8?B?SitkaVRyMFR0bFNEbld1OFJXRTZUVVJ0a09sTUpLTU1IbjUxcHBKRWYyWGVG?=
 =?utf-8?B?azZ1aHJjeUNoR241WXB2Y2RyOE4xVTA5OGJFdUdmbFplMDJUcGtYZ0Q3Umh3?=
 =?utf-8?B?TEVWR3pUZmpJOFpGYnhYN2xtb3BRZXhrT0RwOTl2dDVjWFFhdDNnanZQclNG?=
 =?utf-8?B?bit3V2htWG5ZMmlpR1U1VUVrNng2Y29kMzhXOUxpVFYvV1RPdXVvSC9KZFd1?=
 =?utf-8?B?YitrdkpRN2Z0MkF6SHRjR0xuaklvbmR4SzVBdW5DWE1ncUlja2ova2RoWXNV?=
 =?utf-8?B?UHhEUmwyeXRXZUVDa1M2Q1pFaFVWb2w4TDM2dkFlNEJUcTZObm9YNkxxQ09j?=
 =?utf-8?B?UklPM2RYbHVoVDlnZ1UrSURqRmJidzRWSGdKZnZOclB6K2VVb2JOaHByaDB1?=
 =?utf-8?B?WDQrSlBzOUtXSWxqZlQxT3lVSTBuKzJwWFEyaTBUb2Q4bG8yd3praXlDSDlj?=
 =?utf-8?B?dmhrVXVveXc5MlJJYXMrRWI2TXNmSTZrQzQyNWYwd3ZjUE5EWUFnOTFkbHdZ?=
 =?utf-8?B?NW1kL0RiNUdndkd3dmdLVTN2Y0xqTTRXcDU2UEpGNWpTaUNkZkFhdmNONHlT?=
 =?utf-8?B?NjdtUnB5b2diWitqOVp4bU5zMVJuZjExWVhIUUV6UzZ1MXJGdTU2a1dnSU0y?=
 =?utf-8?B?UFBXSkdXWWN3YWtPSFpkVGtFZ0JjanRmdDk3cWxTc3dSb0RkNTh5M0QwcjdC?=
 =?utf-8?B?djR6OGxqZUd1bGVJc3U3Q0ZRVUpSYnBwcWxUaEFMZUxUYktPSmFOV0creVJQ?=
 =?utf-8?B?UHFGem5QWGtPMUgrRGpCV2IyZ1Y2ZU5abkE2RmgwSk9XeUdsUVFLZmhxN3lB?=
 =?utf-8?B?NnhLbjhqZ2tubi9rYUhuLzM1NXpqV05KTTlDcnNRVHcxUUsxNU1weFhGZEow?=
 =?utf-8?B?dkNMdlo0ZitJaWZOVXVaSnVRK1BmTUppeVZuZDU3dDR5REMxUVRSbVdMcGxX?=
 =?utf-8?B?OFllU3JMUzExUWh2SFdBL2N4RS9mSVB1NUptYURlWGNUM3Bvd1ljWG9xd0FT?=
 =?utf-8?B?VnpIaXVTZU9DSVFMZWdGUG1yT1JMREo4YUlMakxXRTd0MFM2dittd21OVGts?=
 =?utf-8?B?TVFBc1Jsem5YaDM0K0RiWmZtK3Y4ZmJvZ2VqdHVDdDBpd1gxV0lPNk9GSHdv?=
 =?utf-8?B?eXB4b1hBeGhjUzhrNWZIb1hjVHl5MUxhUnpCQ3F3WU8zQ1pZOUg2Y0Fvbnkz?=
 =?utf-8?B?OGsybzV5S1FyOWI1QXJNMGg0bm13dm0rZmZYa2pJN0NrcmJqcm4xaVNySzZj?=
 =?utf-8?B?NzZrT2tXVTB5QVlaUUUydXo5ZEpoYnh3aXdycjd2RGxtTE1kYVZyOS9uR3Yy?=
 =?utf-8?Q?SByxZQ3rrYY=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2024 07:59:07.9959
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dbde476-9290-4674-1d9d-08dcfca68f6e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001509.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6274

On SNP-enabled system, VMRUN marks AVIC Backing Page as in-use while
the guest is running for both secure and non-secure guest. Any hypervisor
write to the in-use vCPU's AVIC backing page (e.g. to inject an interrupt)
will generate unexpected #PF in the host.

Currently, attempt to run AVIC guest would result in the following error:

    BUG: unable to handle page fault for address: ff3a442e549cc270
    #PF: supervisor write access in kernel mode
    #PF: error_code(0x80000003) - RMP violation
    PGD b6ee01067 P4D b6ee02067 PUD 10096d063 PMD 11c540063 PTE 80000001149cc163
    SEV-SNP: PFN 0x1149cc unassigned, dumping non-zero entries in 2M PFN region: [0x114800 - 0x114a00]
    ...

Newer AMD system is enhanced to allow hypervisor to modify the backing page
for non-secure guest on SNP-enabled system. This enhancement is available
when the CPUID Fn8000_001F_EAX bit 30 is set (HvInUseWrAllowed).

This table describes AVIC support matrix w.r.t. SNP enablement:

               | Non-SNP system |     SNP system
-----------------------------------------------------
 Non-SNP guest |  AVIC Activate | AVIC Activate iff
               |                | HvInuseWrAllowed=1
-----------------------------------------------------
     SNP guest |      N/A       |    Secure AVIC

Therefore, check and disable AVIC in kvm_amd driver when the feature is not
available on SNP-enabled system.

See the AMD64 Architecture Programmer’s Manual (APM) Volume 2 for detail.
(https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/
programmer-references/40332.pdf)

Fixes: 216d106c7ff7 ("x86/sev: Add SEV-SNP host initialization support")
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
Change log v3:
 * Switch back to the original design where AVIC is disabled when
   the feature is not available.

v2: https://lore.kernel.org/kvm/20241018085037.14131-1-suravee.suthikulpanit@amd.com/
v1: https://lore.kernel.org/lkml/20240930055035.31412-1-suravee.suthikulpanit@amd.com/

 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/svm/avic.c            | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 913fd3a7bac6..64fa42175a15 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -449,6 +449,7 @@
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* AMD hardware-enforced cache coherency */
 #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" AMD SEV-ES full debug state swap support */
 #define X86_FEATURE_SVSM		(19*32+28) /* "svsm" SVSM present */
+#define X86_FEATURE_HV_INUSE_WR_ALLOWED	(19*32+30) /* Allow Write to in-use hypervisor-owned pages */
 
 /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
 #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* No Nested Data Breakpoints */
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 4b74ea91f4e6..65fd245a9953 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1199,6 +1199,12 @@ bool avic_hardware_setup(void)
 		return false;
 	}
 
+	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP) &&
+	    !boot_cpu_has(X86_FEATURE_HV_INUSE_WR_ALLOWED)) {
+		pr_warn("AVIC disabled: missing HvInUseWrAllowed on SNP-enabled system\n");
+		return false;
+	}
+
 	if (boot_cpu_has(X86_FEATURE_AVIC)) {
 		pr_info("AVIC enabled\n");
 	} else if (force_avic) {
-- 
2.34.1


