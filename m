Return-Path: <kvm+bounces-22769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E644943224
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 16:38:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31AFE1C218CC
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 14:38:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32D501BBBF5;
	Wed, 31 Jul 2024 14:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PbKaWnOY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2047.outbound.protection.outlook.com [40.107.223.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C9E1DDC9;
	Wed, 31 Jul 2024 14:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722436661; cv=fail; b=K+W6GmQxVd52Cl25zS0HhVKSVA6wh4DF/YVOUAXFZ4ohSMvPxbAxthBiY5+B/Q4qhMpxOExGs55XeGH87pIa1pj7Q5VHjycGhpzI0yEFRHXSyA0tWqnY5jifpC7ndSXxzGr3j1b4q9kwxBAXsuqPAsF3WZVKXADZJtAFh6ZVqNQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722436661; c=relaxed/simple;
	bh=bxnY19o6pPmTix1flyLltP0l18xq6oyV2uxM4DowdP4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Go/dP0JvVL/dXX8sIgkyZecoR3pz7PjwPK43PkcAngy6QyR7wTaX5kORQ3C64GAg9h5FEDP+N8Vxgo7Fr5FV70ZvdNLDGBvnoMQrpYO8l/80Iy1R0zkgFSFkuOPch1O6RDhnGLEefl0g81ZvaSiL/qqIpnD7LYORYeGdZDyQNSc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PbKaWnOY; arc=fail smtp.client-ip=40.107.223.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oLBQkOUfs0CITdCWhLBLHZ27CQEcpUl2FODKyWRTlH3O2nUpwVkNEvBZaAgwCIKQnII5XEZLNYnaN3oaY1c2Iko13y8Q5tN0tHsx+V0HwKLlh62BzHIWDM++cSUWkWkJ9unz1ioJOMk59yxEOCbAOGN3mLzTvMjVuYv0db/BDzBfstmBu6PhwZyasyia5Wqnuc+6bf9NN18MHX70qVDp5Ebm+DTqAgWFDRnqZnPRrufBChnn+jvJfZd0jI2LORsKds+wrEDc/uoiU7q9fBMnARW+8OcuRo6TIGrxcbB/8iTIy3CX8LOmiv3ZOzJQDwWGiuXvCwdJxdUrbkv9jPGN2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MeDUULQtWm/kyvL5w6tSM/K6BP5RDE1YfylxD87KvYw=;
 b=ZQ1pF+nXAmJ7hk6UPKWPUxeuJW19kGaeFZzR64mMS4EJVslyfepgrE7TXE7t2WRHLdRnBzr/sjy22S4TTeHuk8SipAZH0i0D1djArgKXCNMI7CZk1tM84v25l7BlQGYghlGD9miElI6QhGYU0xS8gTdgbZ1niNWyoCXJtH4QsKrGg7qeN7Y3GFVYTivqyA/VTCCWxBbfwdD1xf6SvePL+AOvD5cAdgcbDJ5NYMznXyZWs/OGYjSfNG6bKA7NoL4qyl4yZLzi7D5FSwHe20P4ibS64H+ZrlkZUYGJUNm9RimtnxD20Cm/2rwQx660wSBD9APnZBiodTfED4oUqJQsgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MeDUULQtWm/kyvL5w6tSM/K6BP5RDE1YfylxD87KvYw=;
 b=PbKaWnOY4Ueb0/S0IyZf0U6oCYpKW54/4DHHfLJmPDzCMGuby49vFtS4yt3XShTJwWq1um7XPxCmEgjqu6pbwJaplJqhSkr9BUXMrUPtrYbUBkJhxa94ADGAdaf86Q1iXNsGG0hq2///TMpvCtPK57V8w53WiRdddYp/G1v0mgg=
Received: from BL1PR13CA0246.namprd13.prod.outlook.com (2603:10b6:208:2ba::11)
 by IA1PR12MB8311.namprd12.prod.outlook.com (2603:10b6:208:3fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.28; Wed, 31 Jul
 2024 14:37:33 +0000
Received: from BL6PEPF00022575.namprd02.prod.outlook.com
 (2603:10b6:208:2ba:cafe::6b) by BL1PR13CA0246.outlook.office365.com
 (2603:10b6:208:2ba::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.29 via Frontend
 Transport; Wed, 31 Jul 2024 14:37:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF00022575.mail.protection.outlook.com (10.167.249.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Wed, 31 Jul 2024 14:37:32 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 31 Jul
 2024 09:37:31 -0500
From: John Allen <john.allen@amd.com>
To: <pbonzini@redhat.com>, <kvm@vger.kernel.org>, <seanjc@google.com>
CC: <thomas.lendacky@amd.com>, <bp@alien8.de>, <mlevitsk@redhat.com>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>, <yazen.ghannam@amd.com>,
	John Allen <john.allen@amd.com>
Subject: [PATCH v2] KVM: x86: Advertise SUCCOR and OVERFLOW_RECOV cpuid bits
Date: Wed, 31 Jul 2024 14:36:49 +0000
Message-ID: <20240731143649.17082-1-john.allen@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00022575:EE_|IA1PR12MB8311:EE_
X-MS-Office365-Filtering-Correlation-Id: 26182e5a-2a5a-4abc-0241-08dcb16e502c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ky91cJXKQElIXRdsaqR3hocQoas+gbtqDge6PaVf5Y9XfRgPBhTugh6HS03J?=
 =?us-ascii?Q?aJDSO1EL9p/NutaMPwPzcdlTwXBzdVaghQcHK5+qHBedvK5UurKHIA75ia1b?=
 =?us-ascii?Q?J9lC9G2IjhDfK34I6hQ39VZICcVGYlLsdyUEaweG52HO9R+KeqL7wfdfy7Y5?=
 =?us-ascii?Q?7Jju2KrpvXVvGxTD99t9fsUCuZJ/OK0La8gvlU8zTqYDSeHLQgy/ukMaFLym?=
 =?us-ascii?Q?38Il5qkQa5hAAskCoZ1b3fV2rmaRPYLeB0DiLDNOAAeB4qZmZFIH7auwBQk/?=
 =?us-ascii?Q?mmsvATrNonVR5u/MZfwWt6gHp0cNgDwkwHDuqsL5xNjIURN6J2qBXUPkH0P4?=
 =?us-ascii?Q?rnUuK/07tGEBqJHCStaS1BNaZpZa03TPwCUgener6fG+aZNxLBePkRAFBS6f?=
 =?us-ascii?Q?uclPj0l27vT7FYM7b0udcGafb12GeLOT1PaE+Tkm6P7uIf7R1YgLXwh+T7r3?=
 =?us-ascii?Q?jXnMSIwo418mBxj7rLjCaaxjjL0v0G4K4VDxEaGGpAFDUYaAvpuf17SYQ/an?=
 =?us-ascii?Q?IPf/tujCDCScrrXsZBeWetWC95GXbTr5onNOHTN2SWX3BWUjgLlDvGaLhrnC?=
 =?us-ascii?Q?4ks3Jw5ME6YoUVdW96QisntWFhb+BGVcU6jIzj30Evau0wtcTM39yXAxcBTH?=
 =?us-ascii?Q?/az9wN3TKmlfPoijuiouS444rFs7ORfRNxhBlBPODuTmqrJ3cV/0m7vFOSad?=
 =?us-ascii?Q?RWVqT9bySVQ4i2gHxHSRhlbYLesbxcZD3GKe3CjiH02P3WamC+YJKOX7FrLZ?=
 =?us-ascii?Q?lao7fIxd2r4FW1ITraxjpW40A3AFbue1l2jpubpQ5phbqOaXb+8m8DwR0TMb?=
 =?us-ascii?Q?EeubuCZTsiMPXlkecm/8i7w5VzdTnZeTSCjFeY42UKxTLvERbtQn02e43hM6?=
 =?us-ascii?Q?Qmv61U8qrohBS80579rlotwQV0Cqi+hfyMTD3zxEa1JZNVHnK+l4I73RI+v4?=
 =?us-ascii?Q?bOt+27rL/nxla8b63c+8vjQ1ORbuY6DqB6HgJf6BFMrO6tq2hfGPNPT/9TAY?=
 =?us-ascii?Q?2Hqfz+8lomnHu/l54hqlQdxmg1/eCUb+NluUCSy+T1ckuksrdpLhQAeSOgte?=
 =?us-ascii?Q?DrTlizPdnriHtsWaRmYfS6r5RoHM0G69kB3YnkDrgdkAKW8/PWb81DEOiVEF?=
 =?us-ascii?Q?7usKPvTjsvtEdiGPkmEH1yAs5iPDrmcc8BmkaLULaWsIWS1ZRrRuTCk/PmVe?=
 =?us-ascii?Q?hVAwS7tuzwhxmBoEXovBnoPRX4xE5HFd7LlB7mO+3VG1MSTdyyi+sZbkEzzo?=
 =?us-ascii?Q?j+TLpRnldLqZdmUhSkMtDUtDHNX4ZC7dqT7WBY2SlfRQmGxqgkU6wypgJA9l?=
 =?us-ascii?Q?CD5PmEgDG8lq7BoWw5JY46yA24EBRMQNRyzwOeKpaS3T9e8qotsD7FB0DZbL?=
 =?us-ascii?Q?Vexgr1jpQT9jgfxVmRfHLsTlnkFU9xTgP7CsfYzXmPRCkB5qV5cRSh+iOVCB?=
 =?us-ascii?Q?b6MhoFsoNCFo7aRRk61tyqelbtdKJ9t8?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 14:37:32.8254
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26182e5a-2a5a-4abc-0241-08dcb16e502c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022575.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8311

Handling deferred, uncorrected MCEs on AMD guests is now possible with
additional support in qemu. Ensure that the SUCCOR and OVERFLOW_RECOV
bits are advertised to the guest in KVM.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: John Allen <john.allen@amd.com>
---
v2:
  - Add cpuid_entry_override for CPUID_8000_0007_EBX.
  - Handle masking bits in arch/x86/kvm/cpuid.c
---
 arch/x86/kvm/cpuid.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2617be544480..f8e1fd409cee 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -743,6 +743,11 @@ void kvm_set_cpu_caps(void)
 	if (!tdp_enabled && IS_ENABLED(CONFIG_X86_64))
 		kvm_cpu_cap_set(X86_FEATURE_GBPAGES);
 
+	kvm_cpu_cap_mask(CPUID_8000_0007_EBX,
+		F(OVERFLOW_RECOV) |
+		F(SUCCOR)
+	);
+
 	kvm_cpu_cap_init_kvm_defined(CPUID_8000_0007_EDX,
 		SF(CONSTANT_TSC)
 	);
@@ -1237,11 +1242,12 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->edx &= ~GENMASK(17, 16);
 		break;
 	case 0x80000007: /* Advanced power management */
+		cpuid_entry_override(entry, CPUID_8000_0007_EBX);
 		cpuid_entry_override(entry, CPUID_8000_0007_EDX);
 
 		/* mask against host */
 		entry->edx &= boot_cpu_data.x86_power;
-		entry->eax = entry->ebx = entry->ecx = 0;
+		entry->eax = entry->ecx = 0;
 		break;
 	case 0x80000008: {
 		/*
-- 
2.34.1


