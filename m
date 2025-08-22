Return-Path: <kvm+bounces-55536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8335B32457
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 23:29:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A48F13A235F
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 21:27:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE5253469E4;
	Fri, 22 Aug 2025 21:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CCtawQiX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2057.outbound.protection.outlook.com [40.107.93.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EC9343202;
	Fri, 22 Aug 2025 21:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755897982; cv=fail; b=KsRIMkYaSIbP9zPW2vADE5KfK+0656t8ELwgrbUCCvtuRowb7WDdH35Tue2mDBNutDCEIY7WXeF4/7diiIJ57+0CHNWmdv0Jnn3mNh/vaW5EQTWH4ZxL+dgXsP6Mq6g8rRhwNIgawKWBhzufg3Yaj3cxksSEA8OmuOQqTWWGe+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755897982; c=relaxed/simple;
	bh=dVfvncoIZun8RVkNeL3wO6kb1xPOs4VGa0cnxzyfi+I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bDgCzSY2kDVZ/N6GBMuD9X44bgY/rAG/29IJkfiWVnYpbzuax4v0/MX6JVqgI2uED7OnUOXlHhZoyfSho7LvZ5HNiFP2X51dySzNPVCbdtzA6H7n/2FzIHkgW3ofCdr6PebcLuk6keMNm+gw+c+ZPyk9cJZdxEkPtem8+6W/yIo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CCtawQiX; arc=fail smtp.client-ip=40.107.93.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U7Zr0ypfEy8TPcRWvTrq93ao47lTDvH4HQQfPN3xXR2V/5iE0OBEyQJPz31yDCIe6s95r2Rk7amJ8Jts5/9jTsjwzI4ZWWNC9p+xaXK2/oh6W76kG2KHn4txWoEyZWceREBuCL85+rnlzdzrJJD6bR69vOPbeMWHuA/3cvDHqG/pJmk03H8YccwRZ4aUcnB9rm4xJ2+amgdg6SerdgyiQrO3N9btElXvet/eJvFcXkui0tHORuz8PP15fsNJdHMuV0vpwrlU8I6Wo8MalLU+xJeE4IlVN9rr8Z3/VaGp9D4wbG2Rh3vjeQJ1phneE/XiiCuDyc6xpUJsgDA2F4YMMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fZ7RZMXpxrSiy8rfFoPpwW/bgpm9eW8833MgyL8kNoI=;
 b=G8y0pLSTUml7Ik/FVjvfDcm/bV4mO5M+XizpD5RgPJNMJtFuu31oI+V0LibfJXZeT4T8xN7BRVEHlhky3+lFQeTC60Yo/soGE2PwK8nCVRV63ZXiHigXp2tZtn/wdL+dU1t/WkgSCQqDdGtkMPzCgKg+W9wHOqhZUvGsXSkwT6R6iUNhBMtAp9cLn8jClxxbatJA+IPxq0NU/eNam7z4grgmiME5qg+K5Wae7dA0+GuWxP6K3NcxU10cWoxDTeqbbpPSC5cVp28IRU0l674ll16oLH/Qlv3/jR6YJpXEzTbsQra/eI2w9yXzZBgXM9l5z5j1ICvf/SjZI9yxUP8X8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fZ7RZMXpxrSiy8rfFoPpwW/bgpm9eW8833MgyL8kNoI=;
 b=CCtawQiXV2h4p2r4UJbGlNqtqrI0rDrTLF31SjDHruo+Rk1OHDTcVyvKRGpbUGfhJf7UBiBLBL5odBe6mUa6KVIk6SixfSoq8yRms1sxoqe3deWjVZ6k4baUwQI8T0Bqh8mblXXQQOk84j4kbZ+nrD2xUNTBRUj+XJ5tu9Lv1AM=
Received: from BY3PR05CA0060.namprd05.prod.outlook.com (2603:10b6:a03:39b::35)
 by DS0PR12MB9397.namprd12.prod.outlook.com (2603:10b6:8:1bd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Fri, 22 Aug
 2025 21:26:12 +0000
Received: from CY4PEPF0000EE3B.namprd03.prod.outlook.com
 (2603:10b6:a03:39b:cafe::13) by BY3PR05CA0060.outlook.office365.com
 (2603:10b6:a03:39b::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.10 via Frontend Transport; Fri,
 22 Aug 2025 21:26:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3B.mail.protection.outlook.com (10.167.242.14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Fri, 22 Aug 2025 21:26:11 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 22 Aug
 2025 16:26:10 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-crypto@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David Miller" <davem@davemloft.net>
Subject: [RFC PATCH 3/4] crypto: ccp - Add an API to return the supported SEV-SNP policy bits
Date: Fri, 22 Aug 2025 16:25:33 -0500
Message-ID: <e9014e7dfd7f7c040c5d0eefb1f6c20a3c35d9e5.1755897933.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1755897933.git.thomas.lendacky@amd.com>
References: <cover.1755897933.git.thomas.lendacky@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3B:EE_|DS0PR12MB9397:EE_
X-MS-Office365-Filtering-Correlation-Id: 58c1ead1-6b22-444a-78fb-08dde1c28446
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K9cn6DyvMwPAYkRBgLjN3RIflEEanP550h5xGXh4SN24pn/oZLAEwpBEaNyU?=
 =?us-ascii?Q?cx+y9VJ2rdq3ebcaSR/sRYjVVGNAg9sUWTLk8KUQp/BT0eeThTkwnoEkD0PW?=
 =?us-ascii?Q?VPsKbDO91BqfCMaqC8+qRR7Cf1t6Z/dOsWnZGTsPuXgJRHMvME2/LC51T/RO?=
 =?us-ascii?Q?adTFFm+coffsW2t4+aEfILo4ooUfQD+m+FMlZs74Cvp1xXP1QjhzcHAG9yle?=
 =?us-ascii?Q?ybXBhKds4ejvP6jzzY9K6iSXJb44Bi3M2zeUpk6QLP8InO7/GAkBH0ZXImF5?=
 =?us-ascii?Q?H9B2JFqMu+f9ondO7x96MtpznPbL8oBM8dfixW4ye72XVTw2RfzDDHiLT8aI?=
 =?us-ascii?Q?/FjCAWmydIPoxyf1/cTV4OLu+Uuwh59z0POGfp5dxlJjhih3US4wfSs4BbON?=
 =?us-ascii?Q?FaQMUSohmQe5gVDAjrtJPxUaucoNlpufBIArHOSlMSUNH+CKqcB3dvHkt/wZ?=
 =?us-ascii?Q?E/sXT0OXwbjTCcVoA7TCF7V5d5o7rGcwl5O42o84aFWjclzC801jtVNznbca?=
 =?us-ascii?Q?bvP5wO63lYfVZfMVGcl5gLVIQaL3QNqkKREt0lBGqNOXR21xr4cPjQF0gHYa?=
 =?us-ascii?Q?aQ/pXCZMVmqU0Wg2FGeEBGymH674NYXjbpBQ6tM5b/+5ayS3TSrROcOLH1oN?=
 =?us-ascii?Q?Huo6mzrHFUiUoZ02iu55HwZOj9imCz1n8tfEIfeKN/8udT9kQy3zzp4oSw+W?=
 =?us-ascii?Q?9oBgSIZA888gwjloUZYJgojpwGouzRXLRAbySJKkiSDa/RMjGJvP/QN2XM23?=
 =?us-ascii?Q?uSUCNZ+LqQGAbMFV3QqGlBP61Mwq2q8llh8CDLj1uYLr6FMYx8Pw5A3DgT4e?=
 =?us-ascii?Q?veDdMz/cfhaSk/6TQTI/WbbU0KW0gAFyIUlE8pFjvZwN4xNUdF+23rm54H4v?=
 =?us-ascii?Q?SkmlLS2lA+VtTiU7pQlYvFOCZ8RH9tBxnRtC5d+MeDTwPmu4RaSBp1yh15zd?=
 =?us-ascii?Q?Z4VOjYhUjIE8XjpyYfei7TObwq9dFFCrQeFTxzNoRbhRhMNKQRRCuxz0SEzj?=
 =?us-ascii?Q?4cJEKNQ0DzCuxT2avO1OacZ5jyoc1Gsr8TYfNPJ8NRWc4zDcCDY/3obRMtl5?=
 =?us-ascii?Q?B+pgzUW3nz5EEMxPOA3rPaV/scbjeIidaYdTgwogFnjJyBbPHIKhMGgxixgQ?=
 =?us-ascii?Q?fzzYR8FYWJO9Yaw5XBkvHMXRpfVOOwq719loOfMPzNo+GvTHQq4ILxkamdTK?=
 =?us-ascii?Q?niEN+j1s9QNXXrS60DfCrPV2oW0qwNlVzuP1oPeEEbfDq18Lie8neArsou3W?=
 =?us-ascii?Q?GPZxTA0x4vmI+mWVVlnCZbBbhvcrZFfwCpdNj767SPJFu+6PPmovpE1owyxu?=
 =?us-ascii?Q?7oEos0gCxQGRj8sqGtsEqNcx5ll/oWq9LTJlXSoNEo8Bihl7bufstqTSPFGI?=
 =?us-ascii?Q?P3G/IeNWfgImg7kHhAOGGBfmeAFWrQ3+y1OZ47D+GDAthN18b+6tq2AYRxGj?=
 =?us-ascii?Q?gy9L/xzd1FB7z9Gt1QAezJZU4uDLOSBcJxCaK5B1qnm3QrDw7PVOVb7RV1iR?=
 =?us-ascii?Q?Us8W2mcIGEtqD09v9aW5+F6rdPnGStM3Td53?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 21:26:11.4634
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 58c1ead1-6b22-444a-78fb-08dde1c28446
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9397

Supported policy bits are dependent on the level of SEV firmware that is
currently running. Create an API to return the supported policy bits for
a given level of firmware. KVM will AND that value with the KVM supported
policy bits to generate the actual supported policy bits.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c       |  6 ++++--
 drivers/crypto/ccp/sev-dev.c | 37 ++++++++++++++++++++++++++++++++++++
 include/linux/psp-sev.h      | 20 +++++++++++++++++++
 3 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b21376e83ca7..acdea463dd4f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3053,8 +3053,10 @@ void __init sev_hardware_setup(void)
 		else if (sev_snp_supported)
 			sev_snp_supported = is_sev_snp_initialized();
 
-		if (sev_snp_supported)
-			snp_supported_policy_bits = KVM_SNP_POLICY_MASK_VALID;
+		if (sev_snp_supported) {
+			snp_supported_policy_bits = sev_get_snp_policy_bits();
+			snp_supported_policy_bits &= KVM_SNP_POLICY_MASK_VALID;
+		}
 	}
 
 	if (boot_cpu_has(X86_FEATURE_SEV))
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index c3bced655568..b66244d6b10f 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2575,6 +2575,43 @@ void sev_platform_shutdown(void)
 }
 EXPORT_SYMBOL_GPL(sev_platform_shutdown);
 
+u64 sev_get_snp_policy_bits(void)
+{
+	struct psp_device *psp = psp_master;
+	struct sev_device *sev;
+	u64 policy_bits;
+
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
+		return 0;
+
+	if (!psp || !psp->sev_data)
+		return 0;
+
+	sev = psp->sev_data;
+
+	policy_bits = SNP_POLICY_MASK_BASE;
+
+	if (sev->snp_plat_status.feature_info) {
+		if (sev->snp_feat_info_0.ecx & SNP_RAPL_DISABLE_SUPPORTED)
+			policy_bits |= SNP_POLICY_MASK_RAPL_DIS;
+
+		if (sev->snp_feat_info_0.ecx & SNP_CIPHER_TEXT_HIDING_SUPPORTED)
+			policy_bits |= SNP_POLICY_MASK_CIPHERTEXT_HIDING_DRAM;
+
+		if (sev->snp_feat_info_0.ecx & SNP_AES_256_XTS_POLICY_SUPPORTED)
+			policy_bits |= SNP_POLICY_MASK_MEM_AES_256_XTS;
+
+		if (sev->snp_feat_info_0.ecx & SNP_CXL_ALLOW_POLICY_SUPPORTED)
+			policy_bits |= SNP_POLICY_MASK_CXL_ALLOW;
+
+		if (sev_version_greater_or_equal(1, 58))
+			policy_bits |= SNP_POLICY_MASK_PAGE_SWAP_DISABLE;
+	}
+
+	return policy_bits;
+}
+EXPORT_SYMBOL_GPL(sev_get_snp_policy_bits);
+
 void sev_dev_destroy(struct psp_device *psp)
 {
 	struct sev_device *sev = psp->sev_data;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 27c92543bf38..1b4c68ec5c65 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -32,6 +32,20 @@
 #define SNP_POLICY_MASK_MIGRATE_MA		BIT_ULL(18)
 #define SNP_POLICY_MASK_DEBUG			BIT_ULL(19)
 #define SNP_POLICY_MASK_SINGLE_SOCKET		BIT_ULL(20)
+#define SNP_POLICY_MASK_CXL_ALLOW		BIT_ULL(21)
+#define SNP_POLICY_MASK_MEM_AES_256_XTS		BIT_ULL(22)
+#define SNP_POLICY_MASK_RAPL_DIS		BIT_ULL(23)
+#define SNP_POLICY_MASK_CIPHERTEXT_HIDING_DRAM	BIT_ULL(24)
+#define SNP_POLICY_MASK_PAGE_SWAP_DISABLE	BIT_ULL(25)
+
+/* Base SEV-SNP policy bitmask for minimum supported SEV firmware version */
+#define SNP_POLICY_MASK_BASE	(SNP_POLICY_MASK_API_MINOR		| \
+				 SNP_POLICY_MASK_API_MAJOR		| \
+				 SNP_POLICY_MASK_SMT			| \
+				 SNP_POLICY_MASK_RSVD_MBO		| \
+				 SNP_POLICY_MASK_MIGRATE_MA		| \
+				 SNP_POLICY_MASK_DEBUG			| \
+				 SNP_POLICY_MASK_SINGLE_SOCKET)
 
 #define SEV_FW_BLOB_MAX_SIZE	0x4000	/* 16KB */
 
@@ -868,7 +882,10 @@ struct snp_feature_info {
 	u32 edx;
 } __packed;
 
+#define SNP_RAPL_DISABLE_SUPPORTED		BIT(2)
 #define SNP_CIPHER_TEXT_HIDING_SUPPORTED	BIT(3)
+#define SNP_AES_256_XTS_POLICY_SUPPORTED	BIT(4)
+#define SNP_CXL_ALLOW_POLICY_SUPPORTED		BIT(5)
 
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
@@ -1014,6 +1031,7 @@ void *snp_alloc_firmware_page(gfp_t mask);
 void snp_free_firmware_page(void *addr);
 void sev_platform_shutdown(void);
 bool sev_is_snp_ciphertext_hiding_supported(void);
+u64 sev_get_snp_policy_bits(void);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
@@ -1052,6 +1070,8 @@ static inline void sev_platform_shutdown(void) { }
 
 static inline bool sev_is_snp_ciphertext_hiding_supported(void) { return false; }
 
+static inline u64 sev_get_snp_policy_bits(void) { return 0; }
+
 #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
 
 #endif	/* __PSP_SEV_H__ */
-- 
2.46.2


