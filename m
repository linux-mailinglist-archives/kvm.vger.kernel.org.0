Return-Path: <kvm+bounces-56410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F121B3D8B9
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 07:25:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4846F7A569C
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 05:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 429F4239E67;
	Mon,  1 Sep 2025 05:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MHLznRqs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072.outbound.protection.outlook.com [40.107.237.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A3921D3E6;
	Mon,  1 Sep 2025 05:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756704317; cv=fail; b=mHN3mTBR0ss37AvazgRfBDRBTn6WWdri9TDke8rb4xIUPt0G+CEf6Edg3KrzbuoODGITY8Io0zQbV55LnObA0dXns3yJghiJsOFMPhD6GWkjnqcXjcMBJyQJsFxNZ2xH6VqFWJVmD2UtuU+OKXb89rKiuRfmYufCS0J9Ohn4Jds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756704317; c=relaxed/simple;
	bh=GxVoq84KyqgunVrm4KVkoRgmFQa0mDsQylukVo9YtF4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=amo815hdN61EIbcfnoljVzd5Kqk45VlIJtovkjBVxGHpAePm5rdVCjhjsNb6ck5be9PsMhve8kq6A6wFkL2GfYjKJs/dtgV+KkI9O1GX9Tt3fae5+Jo4Pa/43mctLCyQudKEvLj5D4Dxjbz/IizujNuqFQ8AcM7swNc/PnPbWws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MHLznRqs; arc=fail smtp.client-ip=40.107.237.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hol6qrvESIqnr2XRhoFNJf6ZJLe5Dji45Hez7BSi+GoG5h2+hgeQA0PVeosdkca7+H7lhIs17o6/M2emRu5epW4Sdc+/WnKLGkakR7h1OtxL6O1zYikUawFp8uYyMUEGIcQl9XeIpc2f4EeFjI11NATmLCOzcFajHKwO5u9IjvDw2qqQaF7ebMX+xcbZ7CUxk9QrpKLal041e7RdrVuDNDobRx2b3dtUf/DEOxp7FcUKMdPCzY9eBEIjdwDYbosyeTLZvYTo4VbUsJyPc52Gxu4R81PqkcoWnAN8nw98Qni2FW8YLLI710UPgGZstNIlTw/HYE82UgEo4w8dyFGfSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=igybqSb2JjBcT13ywd9xnJL3at33H6+A7nPChKTB59c=;
 b=iPiWfm9VHnrX3NpolzGqrRd+WgzsJ0mrdabyocVmZThjl7fulluliqu8JUfoU6jNMy0u8ZCVS0/dUfbrNlkxVB76nPJ8jGdZF1JwIUBqCq7SUmYDwHbffcRKhJfEdpaIPs3er8an/nNNJVuaCuQNYNwgm+L8KMSvN0NO9guq37Du3XrcdketVqeoJZbnBmIgQjAmCg+gKNRKxcrUKMse4mqmEFeKknrAY293l4uHOSL5EntTwLRv57cOrcG30NKj4FblwLejm49wvjso+EbL8sqYVRkajKUV2v3U12CHCkL7TErYsfF+ZpqT3OBEc8Kuae+UDHPILObD/gMPLSLoJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=igybqSb2JjBcT13ywd9xnJL3at33H6+A7nPChKTB59c=;
 b=MHLznRqsiSNdQljeL2Vq66RixdQAJC/lUcguVVHqeAD1K0RDeFMbMhCud4H2r8dAKJCz+qHsA+8c1o5zwur+ZgQSrSOWqYOoz4Aw+3YhZ+q5S+zdXVMX2LA21Zl6Zmj3/+fTFSEWUxcPdqwmvSILWUO9Wz6iAimg5v+3FUa4dA8=
Received: from SJ0PR03CA0051.namprd03.prod.outlook.com (2603:10b6:a03:33e::26)
 by MN2PR12MB4424.namprd12.prod.outlook.com (2603:10b6:208:26a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.25; Mon, 1 Sep
 2025 05:25:11 +0000
Received: from CY4PEPF0000E9D4.namprd03.prod.outlook.com
 (2603:10b6:a03:33e:cafe::a8) by SJ0PR03CA0051.outlook.office365.com
 (2603:10b6:a03:33e::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.26 via Frontend Transport; Mon,
 1 Sep 2025 05:25:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CY4PEPF0000E9D4.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Mon, 1 Sep 2025 05:25:10 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 1 Sep
 2025 00:25:06 -0500
Received: from BLR-L-MASHUKLA.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Sun, 31 Aug
 2025 22:25:02 -0700
From: Manali Shukla <manali.shukla@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<manali.shukla@amd.com>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <mizhang@google.com>, <thomas.lendacky@amd.com>,
	<ravi.bangoria@amd.com>, <Sandipan.Das@amd.com>
Subject: [PATCH v2 09/12] KVM: SVM: Extend VMCB area for virtualized IBS registers
Date: Mon, 1 Sep 2025 10:54:45 +0530
Message-ID: <20250901052445.209238-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250901051656.209083-1-manali.shukla@amd.com>
References: <20250901051656.209083-1-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D4:EE_|MN2PR12MB4424:EE_
X-MS-Office365-Filtering-Correlation-Id: c69b1813-f591-42be-f45e-08dde917ebec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?g3v75nUgEGxiIlXfuDU7jgMSRHLe86Jg0vjiyG8ynVxe7tnKKxMlcSLqeVUq?=
 =?us-ascii?Q?FNIymmCXza3TWNgLGc4dCnK4XrEWyEsu5cbOggE/V6GL1Cnb9lSaCDQEA3QR?=
 =?us-ascii?Q?gxJ2QhK5cEFC2GOYiD78YdwqsrfHW5mRl3ltm7s1AF85S3o+3T6csQg5g4qb?=
 =?us-ascii?Q?etZF6ufm9x01esD23Z5P8wzTKFfv+Rm5i+B5S9I92Kta4ecexLqhjaIO1XZN?=
 =?us-ascii?Q?SeQ5qGa+6T6Qdjw3IFUwzaoQ6rWdbc4ZyY3qOfAcHm+kWZYfS0jfO2q5KK59?=
 =?us-ascii?Q?I3aquH3V9JJvcIQDqph/sQxJKy+83RImpL2gAIDf+nJasLycjSkUiUnnBdr9?=
 =?us-ascii?Q?q/SG/ppvAbDDtAgphxDjQhrw4Dd995vG7jkkwN5P+x7x4z6DgNfATBAZIJ//?=
 =?us-ascii?Q?8aFBdzmnaCPrKxuteqj+eXwmUJ/NTlwbgy2HQsuPP/CdJLy0G6ubRnbEq5Tv?=
 =?us-ascii?Q?vmgLhK3sFtEwLsiJmue1/9/OEXA0A2mY6/O+YWguSdN6l01QEad+LDLs1CbH?=
 =?us-ascii?Q?wMV6PbI6pjszqHC1lx8ffUNoU3hdGHCUgEZEiPteOp9gJHz3oPSRSuAU7Ugf?=
 =?us-ascii?Q?m0o32Ic0wwOEwJexYa8+nV33ZRirT8ynz79RJuOYzDpXRpXd46vad2597zae?=
 =?us-ascii?Q?X2Eb+Bt4iFDPuAHd5WHhaIlxtZ+IFIqcZhsOfveOBdSN7aEUbQqXzjDgT3xf?=
 =?us-ascii?Q?aJA6+dMFOEBHF8zY9CNFRMlZO6pN6oLC4aazvAejKqag6Ktxw9IRpQBk1S5R?=
 =?us-ascii?Q?hkWin0NSd/exXnZC3MJ4xtu0FNgmE5R60TtsrWQlu0wuy8MbEk3mJsMRRtPU?=
 =?us-ascii?Q?N7eo4q0RY2G7vgyCAQX2P2dD+r3x6bvhVCLgsy9iis/joi+gi0e2vdxDLL8s?=
 =?us-ascii?Q?hv+R+1B6trRWa2UIlPB4ZD6MYDuzZxQW67weShKjl+k3HRCwLBSRwFA6wAYS?=
 =?us-ascii?Q?5lIumXbc+MOpqpQLvVGg3OUTEBFPdcBtoJeLcdHqiua6rd3DVWjiN3pzQ1mW?=
 =?us-ascii?Q?npyXcqsMbstGhgdSuNi9u8V0QnQpxmWBswPQIPUuBuYONHlFYxuxEJAoz9Df?=
 =?us-ascii?Q?P45wOQgox0xMnw/v8NMqpNr0D6lrb2B5rgA13Ifqp02rDb6DXIjuInq+uOnG?=
 =?us-ascii?Q?ZPWpotyMJXhx7fMyRCQ2N+hu9NBzuCclVwigRM+LR78QbrsXtXL09RRLy1/i?=
 =?us-ascii?Q?3Qbe0qjG+lDlkzIOUkdVfiIwNYRf47SRf7km8R3lPmKV3yFvm6lHRTozPyRN?=
 =?us-ascii?Q?j2SBOsmsFM2eoxyLno3xef4b/7VK1DllHPCWsa/2cVbhkIrWy+hc9+v1YV7k?=
 =?us-ascii?Q?DGy9i8vIGDDNMoSlh5rywzwVXqHlQs6AGvZ7kgJm6xtOMLjwwTWZa+ALeDEV?=
 =?us-ascii?Q?dB3BxPYhAcjB+1xX/6GlltpBg4e+AM1Rg2/kiD4jW+XlwXVj0GfXyn5lj1aj?=
 =?us-ascii?Q?1sIPJJ1H1dcmDYnXKRIqRos+Ca0IdzX7wKnkVqNCIRT/nADEJj8KwIHx86yF?=
 =?us-ascii?Q?S15y3+/XyCZZLjRRAMI4jZnaPsf8BEE+VWh3?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 05:25:10.6149
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c69b1813-f591-42be-f45e-08dde917ebec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4424

From: Santosh Shukla <santosh.shukla@amd.com>

Define the new VMCB fields that will be used to save and restore the
satate of the following fetch and op IBS related MSRs.

  * MSRC001_1030 [IBS Fetch Control]
  * MSRC001_1031 [IBS Fetch Linear Address]
  * MSRC001_1033 [IBS Execution Control]
  * MSRC001_1034 [IBS Op Logical Address]
  * MSRC001_1035 [IBS Op Data]
  * MSRC001_1036 [IBS Op Data 2]
  * MSRC001_1037 [IBS Op Data 3]
  * MSRC001_1038 [IBS DC Linear Address]
  * MSRC001_103B [IBS Branch Target Address]
  * MSRC001_103C [IBS Fetch Control Extended]

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/include/asm/svm.h | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index ffc27f676243..269a8327ab2a 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -359,6 +359,17 @@ struct vmcb_save_area {
 	u64 last_excp_to;
 	u8 reserved_0x298[72];
 	u64 spec_ctrl;		/* Guest version of SPEC_CTRL at 0x2E0 */
+	u8 reserved_0x2e8[1168];
+	u64 ibs_fetch_ctl;
+	u64 ibs_fetch_linear_addr;
+	u64 ibs_op_ctl;
+	u64 ibs_op_rip;
+	u64 ibs_op_data;
+	u64 ibs_op_data2;
+	u64 ibs_op_data3;
+	u64 ibs_dc_linear_addr;
+	u64 ibs_br_target;
+	u64 ibs_fetch_extd_ctl;
 } __packed;
 
 /* Save area definition for SEV-ES and SEV-SNP guests */
@@ -541,7 +552,7 @@ struct vmcb {
 	};
 } __packed;
 
-#define EXPECTED_VMCB_SAVE_AREA_SIZE		744
+#define EXPECTED_VMCB_SAVE_AREA_SIZE		1992
 #define EXPECTED_GHCB_SAVE_AREA_SIZE		1032
 #define EXPECTED_SEV_ES_SAVE_AREA_SIZE		1648
 #define EXPECTED_VMCB_CONTROL_AREA_SIZE		1024
@@ -567,6 +578,7 @@ static inline void __unused_size_checks(void)
 	BUILD_BUG_RESERVED_OFFSET(vmcb_save_area, 0x180);
 	BUILD_BUG_RESERVED_OFFSET(vmcb_save_area, 0x248);
 	BUILD_BUG_RESERVED_OFFSET(vmcb_save_area, 0x298);
+	BUILD_BUG_RESERVED_OFFSET(vmcb_save_area, 0x2e8);
 
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0xc8);
 	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0xcc);
-- 
2.43.0


