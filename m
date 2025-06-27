Return-Path: <kvm+bounces-51016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DFBAAEBD3C
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 18:27:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B37B642F33
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 16:27:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 430332EA48D;
	Fri, 27 Jun 2025 16:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iL4BrwsO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2065.outbound.protection.outlook.com [40.107.100.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9544B2EA47F;
	Fri, 27 Jun 2025 16:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751041600; cv=fail; b=Cg5EjnFrxqzq0UFD7UYHDNP4LV7s7ykIx26Q0dbU/iN+IeiIyxBRZ9tH7dOxmbw7HsJXYzi3U77L+S3OJsxWjaNvmZZm4Dk2GBAu7DmrbzhvFiwRiCMrcyJRqP35+OCCMYw77YKflllZC1Jp2FXhkggzSzCCxqmgebOUiLgecHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751041600; c=relaxed/simple;
	bh=ymzGSHUx62XOW9y3OfBwrTEfjthz+0cZcAVnbKSciJo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AUYAvP+71FreZbb2JCZBTVS1Tb22YR6ad+e96wXQ1uCKobAav9y/CXkd5rv9X9FlCWu26A1XXbDuJa/g7EPHSTjgJxuo6uo2DCBBXXquWzN/2cgntatIaZri52nZN2CJPLt0UxJdBT4GSmuSgaOzv64BSBgLsvQqBRxxELmHffY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iL4BrwsO; arc=fail smtp.client-ip=40.107.100.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ieUpu7gz7lx0tdcoonQnKo16zK/WoCfTFMO3oHS5Y6CiljDpYzGKu0Avxb9iKgsyL8T8eGQV3KeoPrYQEtyyhchSTIOD9U7YsOtV/LHSEYAWUCpera8ncwMd+p1VAaLHuAEekCPSVvKYbLapXpeu+ztnmbhWn6Tw5DoMUKoux5XB4yZ0fHhNpY1GgDmpk9s3uySYdouwhMGi89uH4q2PUTJPvNpkTfJZYnuLKxxQYp0sr/Ap1dvYc1/zrj8FNzVF0Fx5ANEjq2ny0YAJ8YEyVqyKDIyWxH3JwDPJwqzyDkGMui0+HDEZvmBoVceJApq+5RrCQh3AoNrQdWxCV/Bn2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6wAdRlXeInjK8QcKa7PB2+dLMKEbxloTMo5/VdrzLwA=;
 b=lj+nsQtc3JQ4J0L7yWelpyaGmYjNEAa8bKq/ku56vl1j3xA4iuC3rL2p33HkSlgviiCY62nfeX+fOoNA44roGRdLqkHbjj+EghX4Nj94OpE53/SR9B6itWIwrU98HGyk+tdOOhtwtM3+TIC3lPi1PWesch1zJnAcocQVGRph+t7BBkVRetWD6bv58wewIQAPLpDcsH9ThnZakVygvnp4vRLex0pR6l5U6ym9shhHRnNqLP8U9FdPKoBPEn8CXztDw0WyketPjZ3AsC0rBI54D5mqHx416+gXDISWjyFoBYvEz4oXjIDQG6hgmIlxNBHQh/itx/c9yi2tdQ6vtP3P/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6wAdRlXeInjK8QcKa7PB2+dLMKEbxloTMo5/VdrzLwA=;
 b=iL4BrwsOPaPgbXzgAGJG4gaiHLKqKWgxdICN36M9MVsKSVxbPZvdqPdc1olGju+OiSsyeBrGZRjh2MGPfhOGyflTyqC/lZaD7LjK7oDlx7hVl5M/BnCPlCOC5ys3nCptyZELJuXKyzXZ9JPWw7+NslEzNRZ1z1SFbAIa+gqoB5U=
Received: from PH5P222CA0012.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:34b::8)
 by CYYPR12MB8751.namprd12.prod.outlook.com (2603:10b6:930:ba::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.23; Fri, 27 Jun
 2025 16:26:32 +0000
Received: from SN1PEPF000397B0.namprd05.prod.outlook.com
 (2603:10b6:510:34b:cafe::13) by PH5P222CA0012.outlook.office365.com
 (2603:10b6:510:34b::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.23 via Frontend Transport; Fri,
 27 Jun 2025 16:26:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000397B0.mail.protection.outlook.com (10.167.248.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8880.14 via Frontend Transport; Fri, 27 Jun 2025 16:26:32 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 27 Jun
 2025 11:26:26 -0500
From: Manali Shukla <manali.shukla@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<manali.shukla@amd.com>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <mizhang@google.com>, <thomas.lendacky@amd.com>,
	<ravi.bangoria@amd.com>, <Sandipan.Das@amd.com>
Subject: [PATCH v1 04/11] KVM: x86: Add emulation support for Extented LVT registers
Date: Fri, 27 Jun 2025 16:25:32 +0000
Message-ID: <20250627162550.14197-5-manali.shukla@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250627162550.14197-1-manali.shukla@amd.com>
References: <20250627162550.14197-1-manali.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B0:EE_|CYYPR12MB8751:EE_
X-MS-Office365-Filtering-Correlation-Id: fdfc1a10-f172-4bb1-26a2-08ddb59760a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MzFSNTVpaG9RNVlOVU9ka0tpNHprQnRZVS9zRWNRTDRXWUN1WEcvUVhhMFFw?=
 =?utf-8?B?WVQ4WnhRMjFJb2wyY3hZaUh3bW9tdHMxYVlRSzcxNENyZnFGbHkvMXY4YmdQ?=
 =?utf-8?B?WnVPQjFqTlRYY3BNNTQ5WDVuNC9BcnNQY05sVkZQdlJPcDZrTm1BWGtDTGFw?=
 =?utf-8?B?N0xLVGZsd0puNUs4OHBPV0FLNWs2RmNvaW1PMFN5b3Qxa21TYmltMEdxK2h6?=
 =?utf-8?B?OXpSUG5GVkV4aTJuTndJQ2Y5Q0pDYzl1NHVSdko0cmxaOGZXWFdDREZxL1hT?=
 =?utf-8?B?NS9iSTBkSmRKaUlVVkJvN0JtZkVGYm1TbW9iSTErcXBKZmJWN1kvWGRpZ0Z0?=
 =?utf-8?B?KzRFZ3pEQm9EbjVDTUFNd2VUQlhPamQzZXdGbm5rZU9iekYxM3lvYkZWWXJv?=
 =?utf-8?B?MmxNMXhaNEJrRFJjZm12T1c5cmNWS2dEODFicVhaZ0U5cUpEWUpvUEhCdVN1?=
 =?utf-8?B?N0ZjNnVrb3BWOFV3dTdZUFhKYlhPR0l3ZEpOY2dIL25HdEFkcmU3RVcrOGRT?=
 =?utf-8?B?Z2VETUFPRS9zWG9taHRQcS9Kckxad2RGbVl5RksrSXl1ajhaOEt2eHZCNGFL?=
 =?utf-8?B?VWZEQnBuQlZsZkZxTzdYZVlrc2NrM0c0dWx5SGFGSnhxcUFUT3VXOGNpam5n?=
 =?utf-8?B?OTYwcWpjTXl0MlFxM1VRYU5wMlVNYi8rdGdXRVE2TWFXZHN3OVdlVFVJOGVa?=
 =?utf-8?B?SS81ZXVMSUNDM2FGWTlWWVFOLzN1c0pwY0JVSFFNR2dhUVJsenVmNlFUYkdL?=
 =?utf-8?B?RzEwWFpCVFZoQU8xcnZFN0NrRDVGMXV6Z3VKNFJWRTJCS1NHNFh2K2NXbkh0?=
 =?utf-8?B?TVhkNERMSzR4Njk0MmxKMVFUT1kxVzBSUjIrTkNnWStzUWhYN3lWbTJoMzgz?=
 =?utf-8?B?UEVvN2FUMmp3bGdvSVRUQjgvTEkyM2NPTjN6VjZ1KzNHWmZqUzFJV0wwRjBo?=
 =?utf-8?B?M052Q0VUZnVoRGNBejAydEdKcTMzZG9xR0NsZkE3NDI3alFnL3VTTEhBVGV2?=
 =?utf-8?B?SXRrL002OG1GMXkvdTJDOXVZeHN2NFpVaGduT3orSVA3VjcvM3hLVlJHaVMw?=
 =?utf-8?B?T05CcmNUWlRoMU9FVzhuYXlQOXdtNDdTeFlGQ1VYeDFUdHd3cXNkTmMva1Bk?=
 =?utf-8?B?a241bFg2VWx5RWpvSm1LM1B1T1RCZEZrVDNRVU1pY1g2TDFOL0RCRVY3aDc4?=
 =?utf-8?B?L28vdEpoaTJ4UmpaRXlQT3hGNHd4VnB4MzlPQVk4M09qN3FhOEtGMSt3K21Y?=
 =?utf-8?B?Yk1Zd1lDSnlpMVIybUpINW5NRG0vUTlIcDU2bi81SHFRY2VCRHJhRXV3M3h2?=
 =?utf-8?B?VFlaS2VvdXpCL2Q1ZDdBd041S2ZNd216WGt4OGVIeW1DM2RxOG1OcXI0UnpC?=
 =?utf-8?B?dmUwd3ZWRjY2OHduTVpNQU4vUUp6bitraFJGRW9xTVRGUk9ERGpzT1NUZFg5?=
 =?utf-8?B?aTZoZVJndFkxYVFzL0dQVlBHcnRzS3p4cGNubk1vTGd1S2hSbE5NOHIyT2Qr?=
 =?utf-8?B?b3hSdDFUa214TFBXZDI1eFV5c04yMWJwZmlaaC9rcnRjTkpIaU02b2QybEw5?=
 =?utf-8?B?U2hBRWlRVXMwcXhEUXJKZ0pTdFhuazQxY3kvRTI0VFd0dWNYZ1BtaE42bEI3?=
 =?utf-8?B?VHFObG5sUGphVng3dzhpL2RpY0FtWmJoOHRKdzI5d2I4R3JzRElObk9KTmph?=
 =?utf-8?B?TkowTXpXSmRXcjJvWXJjUnBERFEyZ1NtemNOZnpTeTUvOXpwWWZIYm9ScVpU?=
 =?utf-8?B?Tys0U3pDN3RZakRGQUJJYk5mS2R3T2xzcU9IOFhYb3hMQU1RbEJBU2ZuV21n?=
 =?utf-8?B?OHR0ZjFzM0ZHMWx0U2tXRnBESDc5aytsUEtCWjduRHdPeDdMRnlJekZRN0Jt?=
 =?utf-8?B?WGxYK1hENDZDQXQ1OXZYdElWSm5JUGNuNzNyWlZobElsNDZxTEJiOVJnK2pB?=
 =?utf-8?B?VXBTMkpkcUNBQlVFdjVhbDFubDlGdC84WjVXR05ubG5mQWxWa0lqSy9GM2x0?=
 =?utf-8?B?am9laUFYS29zVGptUDJhcjQwcmtrL3VnbGN2RjRwTVc5cisxcFVTS2hiSnJu?=
 =?utf-8?B?ejc5M2tNMlJYS00xOW1xdWlNQ1hvcXlheUw3Zz09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 16:26:32.2002
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fdfc1a10-f172-4bb1-26a2-08ddb59760a6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8751

From: Santosh Shukla <santosh.shukla@amd.com>

The local interrupts are extended to include more LVT registers in
order to allow additional interrupt sources, like Instruction Based
Sampling (IBS) and many more.

Currently there are four additional LVT registers defined and they are
located at APIC offsets 400h-530h.

AMD IBS driver is designed to use EXTLVT (Extended interrupt local
vector table) by default for driver initialization.

Extended LVT registers are required to be emulated to initialize the
guest IBS driver successfully.

Please refer to Section 16.4.5 in AMD Programmer's Manual Volume 2 at
https://bugzilla.kernel.org/attachment.cgi?id=306250 for more details
on Extended LVT.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
Co-developed-by: Manali Shukla <manali.shukla@amd.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/include/asm/apicdef.h | 17 +++++++++
 arch/x86/kvm/cpuid.c           |  6 +++
 arch/x86/kvm/lapic.c           | 69 +++++++++++++++++++++++++++++++++-
 arch/x86/kvm/lapic.h           |  1 +
 arch/x86/kvm/svm/avic.c        |  4 ++
 arch/x86/kvm/svm/svm.c         |  4 ++
 6 files changed, 99 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 094106b6a538..4c0f580578aa 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -146,6 +146,23 @@
 #define		APIC_EILVT_MSG_EXT	0x7
 #define		APIC_EILVT_MASKED	(1 << 16)
 
+/*
+ * Initialize extended APIC registers to the default value when guest
+ * is started and EXTAPIC feature is enabled on the guest.
+ *
+ * APIC_EFEAT is a read only Extended APIC feature register, whose
+ * default value is 0x00040007. However, bits 0, 1, and 2 represent
+ * features that are not currently emulated by KVM. Therefore, these
+ * bits must be cleared during initialization. As a result, the
+ * default value used for APIC_EFEAT in KVM is 0x00040000.
+ *
+ * APIC_ECTRL is a read-write Extended APIC control register, whose
+ * default value is 0x0.
+ */
+
+#define		APIC_EFEAT_DEFAULT	0x00040000
+#define		APIC_ECTRL_DEFAULT	0x0
+
 #define APIC_BASE (fix_to_virt(FIX_APIC_BASE))
 #define APIC_BASE_MSR		0x800
 #define APIC_X2APIC_ID_MSR	0x802
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index eb7be340138b..7270d22fbf31 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -458,6 +458,12 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	/* Invoke the vendor callback only after the above state is updated. */
 	kvm_x86_call(vcpu_after_set_cpuid)(vcpu);
 
+	/*
+	 * Initialize extended LVT registers at guest startup to support delivery
+	 * of interrupts via the extended APIC space (offsets 0x400–0x530).
+	 */
+	kvm_apic_init_eilvt_regs(vcpu);
+
 	/*
 	 * Except for the MMU, which needs to do its thing any vendor specific
 	 * adjustments to the reserved GPA bits.
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 00ca2b0faa45..cffe44eb3f2b 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1624,9 +1624,13 @@ static inline struct kvm_lapic *to_lapic(struct kvm_io_device *dev)
 }
 
 #define APIC_REG_MASK(reg)	(1ull << ((reg) >> 4))
+#define APIC_REG_EXT_MASK(reg)	(1ull << (((reg) >> 4) - 0x40))
 #define APIC_REGS_MASK(first, count) \
 	(APIC_REG_MASK(first) * ((1ull << (count)) - 1))
 
+#define APIC_LAST_REG_OFFSET		0x3f0
+#define APIC_EXT_LAST_REG_OFFSET	0x530
+
 u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic)
 {
 	/* Leave bits '0' for reserved and write-only registers. */
@@ -1668,6 +1672,8 @@ EXPORT_SYMBOL_GPL(kvm_lapic_readable_reg_mask);
 static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 			      void *data)
 {
+	u64 valid_reg_ext_mask = 0;
+	unsigned int last_reg = APIC_LAST_REG_OFFSET;
 	unsigned char alignment = offset & 0xf;
 	u32 result;
 
@@ -1677,13 +1683,44 @@ static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 	 */
 	WARN_ON_ONCE(apic_x2apic_mode(apic) && offset == APIC_ICR);
 
+	/*
+	 * The local interrupts are extended to include LVT registers to allow
+	 * additional interrupt sources when the EXTAPIC feature bit is enabled.
+	 * The Extended Interrupt LVT registers are located at APIC offsets 400-530h.
+	 */
+	if (guest_cpu_cap_has(apic->vcpu, X86_FEATURE_EXTAPIC)) {
+		valid_reg_ext_mask =
+			APIC_REG_EXT_MASK(APIC_EFEAT) |
+			APIC_REG_EXT_MASK(APIC_ECTRL) |
+			APIC_REG_EXT_MASK(APIC_EILVTn(0)) |
+			APIC_REG_EXT_MASK(APIC_EILVTn(1)) |
+			APIC_REG_EXT_MASK(APIC_EILVTn(2)) |
+			APIC_REG_EXT_MASK(APIC_EILVTn(3));
+		last_reg = APIC_EXT_LAST_REG_OFFSET;
+	}
+
 	if (alignment + len > 4)
 		return 1;
 
-	if (offset > 0x3f0 ||
-	    !(kvm_lapic_readable_reg_mask(apic) & APIC_REG_MASK(offset)))
+	if (offset > last_reg)
 		return 1;
 
+	switch (offset) {
+	/*
+	 * Section 16.3.2 in the AMD Programmer's Manual Volume 2 states:
+	 * "APIC registers are aligned to 16-byte offsets and must be accessed
+	 * using naturally-aligned DWORD size read and writes."
+	 */
+	case KVM_APIC_REG_SIZE ... KVM_APIC_EXT_REG_SIZE - 16:
+		if (!(valid_reg_ext_mask & APIC_REG_EXT_MASK(offset)))
+			return 1;
+		break;
+	default:
+		if (!(kvm_lapic_readable_reg_mask(apic) & APIC_REG_MASK(offset)))
+			return 1;
+
+	}
+
 	result = __apic_read(apic, offset & ~0xf);
 
 	trace_kvm_apic_read(offset, result);
@@ -2419,6 +2456,14 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		else
 			kvm_apic_send_ipi(apic, APIC_DEST_SELF | val, 0);
 		break;
+
+	case APIC_ECTRL:
+	case APIC_EILVTn(0):
+	case APIC_EILVTn(1):
+	case APIC_EILVTn(2):
+	case APIC_EILVTn(3):
+		kvm_lapic_set_reg(apic, reg, val);
+		break;
 	default:
 		ret = 1;
 		break;
@@ -2757,6 +2802,24 @@ void kvm_inhibit_apic_access_page(struct kvm_vcpu *vcpu)
 	kvm_vcpu_srcu_read_lock(vcpu);
 }
 
+/*
+ * Initialize extended APIC registers to the default value when guest is
+ * started. The extended APIC registers should only be initialized when the
+ * EXTAPIC feature is enabled on the guest.
+ */
+void kvm_apic_init_eilvt_regs(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+	int i;
+
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_EXTAPIC)) {
+		kvm_lapic_set_reg(apic, APIC_EFEAT, APIC_EFEAT_DEFAULT);
+		kvm_lapic_set_reg(apic, APIC_ECTRL, APIC_ECTRL_DEFAULT);
+		for (i = 0; i < APIC_EILVT_NR_MAX; i++)
+			kvm_lapic_set_reg(apic, APIC_EILVTn(i), APIC_EILVT_MASKED);
+	}
+}
+
 void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
@@ -2818,6 +2881,8 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 		kvm_lapic_set_reg(apic, APIC_ISR + 0x10 * i, 0);
 		kvm_lapic_set_reg(apic, APIC_TMR + 0x10 * i, 0);
 	}
+	kvm_apic_init_eilvt_regs(vcpu);
+
 	kvm_apic_update_apicv(vcpu);
 	update_divide_count(apic);
 	atomic_set(&apic->lapic_timer.pending, 0);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 7ad946b3738d..ff0f9eb3417b 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -96,6 +96,7 @@ void kvm_apic_ack_interrupt(struct kvm_vcpu *vcpu, int vector);
 int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu);
 int kvm_apic_accept_events(struct kvm_vcpu *vcpu);
 void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event);
+void kvm_apic_init_eilvt_regs(struct kvm_vcpu *vcpu);
 u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
 void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 7338879d1c0c..323927fb6f57 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -682,6 +682,10 @@ static bool is_avic_unaccelerated_access_trap(u32 offset)
 	case APIC_LVTERR:
 	case APIC_TMICT:
 	case APIC_TDCR:
+	case APIC_EILVTn(0):
+	case APIC_EILVTn(1):
+	case APIC_EILVTn(2):
+	case APIC_EILVTn(3):
 		ret = true;
 		break;
 	default:
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fffc3320ea00..f9a7ff37ea10 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -791,6 +791,10 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
 		X2APIC_MSR(APIC_TMICT),
 		X2APIC_MSR(APIC_TMCCT),
 		X2APIC_MSR(APIC_TDCR),
+		X2APIC_MSR(APIC_EILVTn(0)),
+		X2APIC_MSR(APIC_EILVTn(1)),
+		X2APIC_MSR(APIC_EILVTn(2)),
+		X2APIC_MSR(APIC_EILVTn(3)),
 	};
 	int i;
 
-- 
2.43.0


