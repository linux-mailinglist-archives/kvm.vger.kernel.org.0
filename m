Return-Path: <kvm+bounces-51862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EE2DAFDE6B
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:43:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 415F1189392E
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B792C2192E5;
	Wed,  9 Jul 2025 03:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KCQDlqbK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6FF194A44;
	Wed,  9 Jul 2025 03:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032507; cv=fail; b=siC3OxY8lK7gCoCotD7SmL2QgE/g1fuuyd1eNLT2Fc83yabgc8XSChvkmPnNuKvWICTmnh/WxMuMFXixDiADzOfs/XVCWlsk60t9nB278jEDmaVRq2gZPrm31zO66945ULtclkyNFYFUpELRzwAAzSoSRutXKmXM5yGpCt5o4uo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032507; c=relaxed/simple;
	bh=zM/RepVVgowohCMmx1cFKA0C7IqSYdHX/fZ4H3/RDOA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qfTPZUo8g9Ie83rJh3sERXzToUBO6gu8J/bjh0Q6wfU/iW3Iw7gIpka/MYO5KBFf8aaJsete3s8x1E1lcX7FlZBqp9CXtUsDijcZ9T10WCDMdIAs5GjBobJyAlxJiKjJK5CmuJhBV8WsauTmoKIaiG8b/8Ya+lAuWkhGUbu6R1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KCQDlqbK; arc=fail smtp.client-ip=40.107.244.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mnfgDY+hA/8r1/JZndXw8fktMYQX8gx69W8ZnlPR+Of+a3CYUFYwWaiDE0TzOx9HyrLnO0a9ebr/E/tO2b2Lp1SETxIckGTVAJ1qWJrP+nMX7Rk50cdNZi4BfstxfX2SxjNAz16DQJdn/GyO/uB7AQoGcyU6ihy2ORQ2y+6wF9JaltyhvtfrRXh/Vd7cwbdgq5z1bDBihmovrBeb2O3JlaxLMRJ+Wbj2wA9SPfEooudLSohY8A69UZYw4j3LrIZjB40A5rZZjqBowdsh8qXHCPninzNF3Eb0zcCUrMUW1nzPNuWX0eQXiBIlz2V3OrJMrTzXJN//qTxUYoM7ituwgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Vq78tREABFPzJbhWgftSbTqeLa5GNF8KoZlv7TQvgU=;
 b=iXSxOq5F1S0iXNlRMiCdcXJrNp3jFmxBcccqtojENb4ul7R5U3n4p+A8JOOwLDX+YDkY+1aQORTBuXMO1gvw8drqHZ754OPRJzKCzc8htQLHf28gMtRqg59rEaCe4igGD3MS1nEz+ID0GFIlz28+U5E0SPRjAwhf9Qw/2S/y9jzssmd39wdFVu0FUKPMQ/XFDA7iMY9PZWapxeXM17hF+rg93pUnYdzz+FHIRpKVCtIdKt13V3aqpWTBsUflA+JuCeKiho14wRzsqUuHAHMoIfPDH2ypW6W731HbOaVDxfMJ5QTR7t4ioEBtDG36+1uSTua4NDkL/NtXpJD046ff/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Vq78tREABFPzJbhWgftSbTqeLa5GNF8KoZlv7TQvgU=;
 b=KCQDlqbKByVcSL6/vbbiasvTSukA13GVbyVKr7WxE388SA4blPC9yTUsQkelqHynGX97JNPqXSgKmjTgbyKE4kc4ZZmMgtcWSnbQgI+5+hTVe7UEUvxYDgC3uuBJjnEQk5TjMjwrcfGl8Vh56LK7LmRbj5BQ7S0h1qgWWhdTn6g=
Received: from BL1PR13CA0071.namprd13.prod.outlook.com (2603:10b6:208:2b8::16)
 by DS7PR12MB5743.namprd12.prod.outlook.com (2603:10b6:8:72::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Wed, 9 Jul
 2025 03:41:41 +0000
Received: from BL6PEPF0001AB4A.namprd04.prod.outlook.com
 (2603:10b6:208:2b8:cafe::a6) by BL1PR13CA0071.outlook.office365.com
 (2603:10b6:208:2b8::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.21 via Frontend Transport; Wed,
 9 Jul 2025 03:41:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB4A.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Wed, 9 Jul 2025 03:41:41 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:41:35 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <kai.huang@intel.com>
Subject: [RFC PATCH v8 28/35] x86/apic: Allow NMI to be injected from hypervisor for Secure AVIC
Date: Wed, 9 Jul 2025 09:02:35 +0530
Message-ID: <20250709033242.267892-29-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4A:EE_|DS7PR12MB5743:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dbd54bb-a617-42bf-a80d-08ddbe9a849a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VIH5fIIeXdzDxdiTGFBA78mU5D2uL4iap+VPqpRcySWVH2dz9bvbg1Mbs9ST?=
 =?us-ascii?Q?0x1RDiy/Jzb9i12yP3F/ME9iHFB1JKuNNGawJ4L8lqz5Iu202UJSHVBdvrY2?=
 =?us-ascii?Q?+lH6wkyDA7BU/JU3YL+/pHu6JzYfgqdtHjaFhgdSU0k9Ctz6o5uIJyFniLDe?=
 =?us-ascii?Q?bW2KS91h0zQVvoQnWtghlmP+BDNQxYsO4gLPMCTwdtBe++FTj8aC5XDAspNg?=
 =?us-ascii?Q?0qMC01IVhEIyU6B4gFVMf53W3kOqZLkwkp11diE1evnMLTmw/6CLrR2afhBe?=
 =?us-ascii?Q?HfpbZnD7DWq1Pl2km8fE9uAjiWEIr0rt9JxSlni4VquNwh3uX1XFbOIOC0I3?=
 =?us-ascii?Q?VZV/bKhUChhPpZ+RsRPB9y2xwSNzaPloRkL9R5DEBozA+P8kakxc71rGQOwU?=
 =?us-ascii?Q?G2Z5ZO7YAK8zucrWV9bQkZ2GzcfqhOyEyH3GQkumWQtp+QEeRBah6yHqSfXx?=
 =?us-ascii?Q?HrrFIdcaf4DLYsXI3UmQOYCtjEXX/9io2VOSwOfn6xfCWXNqlIoUCnz1o2NX?=
 =?us-ascii?Q?iDfMOMiQJ5xYfqmzF9EY1y66lUmq5fx6kFEbYbg0F5nGi96PRClMPV/tBDuc?=
 =?us-ascii?Q?vcuvmcV0jTJmrY5EZFTVm+zJeYf1Die931Ti/ntkf1YuO43F78ovt7PHEwOh?=
 =?us-ascii?Q?D0CPbgV7bxIfNG3n3f7LZhZNDZ1ZPICCXrnPsweNLA+vj1XUUmb6DuU5HKaV?=
 =?us-ascii?Q?4puXe4XftxZ/c7xpkowB0b/njFaoymfMUy13YcUiiZ10yH4Tz92kb5VCLuxA?=
 =?us-ascii?Q?I9l/NyrckS5xEqzcPLnPq7XpI29OqJvemATc+qbQ1CEfRlpGxw+McSQoDL4U?=
 =?us-ascii?Q?O6VZyDMBEr5dTVdNwnMmnJo4Jz9gYPP1NsW3GwAvW3/4925+HIqWBm2Y94Lp?=
 =?us-ascii?Q?9+k+jOwOymuS0Lsx/QsiO4yWmUDvFjfQ51lx7QyC5jO/cyl/2s6+YUK4AjCj?=
 =?us-ascii?Q?ybff6zaw0SuEB+QBHk/ONTGSbdwfP+d73E9RY3tnlPPjdsX16H8t6Zq4/S2p?=
 =?us-ascii?Q?oz6xLPw7b01QGoXe0NvfJN15915kyoVj4r64cX1cIsX2ECGjtwFLndSYmSFG?=
 =?us-ascii?Q?J8XVBDwiJ1351YaywHmf8/2PlV8fSfLVuREkV4igLBZXG/JoBnMgFsGs8Sq5?=
 =?us-ascii?Q?SJ7ePTpZNKWBhkPNo9G12QwEZ57ILVs0I6HJhy6SI9Rd4AQrRU0ERDg4Ok2J?=
 =?us-ascii?Q?9ARCF/3XWtskHeIVgdsgzo39YYFpKC8M6JKBZmQNAtcxR1nXWAB6nBNe8+Cz?=
 =?us-ascii?Q?QnqU50MunQTrddL1tj5ZVv8bT3/ppcr2T3NdRQfDpbYZPq0SBCXfeWqNUKW4?=
 =?us-ascii?Q?tRUvwwnqlybUgZ67fNXlIZR4K8MXLzRTn82hrHqfCe0LkNFNavVEgN1bMAyG?=
 =?us-ascii?Q?zLa5f3L1Tzs6SZFddJZWKjgugr7nhQm+QVXQeUh6wCgdgprpUdO187PQCJw8?=
 =?us-ascii?Q?RLVPmU0xDyuDiLKuaWWFu+IFFaW1gT7Tw0G9D+zNajkCKr2esxL7IsfK7R2N?=
 =?us-ascii?Q?NJBNiYS3vPk6R3ncabMZEjRHrXJDvBcJRh3P?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:41:41.5014
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dbd54bb-a617-42bf-a80d-08ddbe9a849a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5743

Secure AVIC requires "AllowedNmi" bit in the Secure AVIC Control MSR
to be set for NMI to be injected from hypervisor. Set "AllowedNmi"
bit in Secure AVIC Control MSR to allow NMI interrupts to be injected
from hypervisor.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - No change.

 arch/x86/include/asm/msr-index.h    | 3 +++
 arch/x86/kernel/apic/x2apic_savic.c | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 045c0d7e160b..a3a2b99d5745 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -702,6 +702,9 @@
 #define MSR_AMD64_SNP_SECURE_AVIC	BIT_ULL(MSR_AMD64_SNP_SECURE_AVIC_BIT)
 #define MSR_AMD64_SNP_RESV_BIT		19
 #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
+#define MSR_AMD64_SECURE_AVIC_CONTROL	0xc0010138
+#define MSR_AMD64_SECURE_AVIC_ALLOWEDNMI_BIT 1
+#define MSR_AMD64_SECURE_AVIC_ALLOWEDNMI BIT_ULL(MSR_AMD64_SECURE_AVIC_ALLOWEDNMI_BIT)
 #define MSR_AMD64_RMP_BASE		0xc0010132
 #define MSR_AMD64_RMP_END		0xc0010133
 #define MSR_AMD64_RMP_CFG		0xc0010136
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 66fa4b8d76ef..583b57636f21 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -19,6 +19,11 @@
 
 static struct apic_page __percpu *apic_page __ro_after_init;
 
+static inline void savic_wr_control_msr(u64 val)
+{
+	native_wrmsr(MSR_AMD64_SECURE_AVIC_CONTROL, lower_32_bits(val), upper_32_bits(val));
+}
+
 static int savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
@@ -330,6 +335,7 @@ static void savic_setup(void)
 	res = savic_register_gpa(gpa);
 	if (res != ES_OK)
 		snp_abort();
+	savic_wr_control_msr(gpa | MSR_AMD64_SECURE_AVIC_ALLOWEDNMI);
 }
 
 static int savic_probe(void)
-- 
2.34.1


