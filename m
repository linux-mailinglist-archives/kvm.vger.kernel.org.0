Return-Path: <kvm+bounces-61219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 778A7C112E8
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 20:39:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D7A31A27837
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 19:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71AA52D5A14;
	Mon, 27 Oct 2025 19:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yzXlS9t/"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010032.outbound.protection.outlook.com [52.101.61.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C47326D57;
	Mon, 27 Oct 2025 19:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593668; cv=fail; b=eIF7suwY7PJNXMMuK9kE7KsNWltFRZtac22VtAeZkoT/KAqOP1roFPHkM/kakJ6F8O3RwWBMpyEYTGyVW70UsuMigalJBRI9YgSiXjjO5ETTX9ocOdL0dWAd5jF84g2o7ZpxgUEd8FAq5teFp4tsNOcNxbQ807IyjA168KpXcO0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593668; c=relaxed/simple;
	bh=LS6P4SoKoJN5So7mmy5nGuHUhINNyHavmcAiOUce93Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fkGkSMfBmWdKscKBaY51dV436lMCL6E7pABhCNHhjbp3F2iwm1EJnmO2VoOrsTv95Ip2Le03UP9625oN2VEkGVrJT/+Ntt3fVeDgNKC7KqJB0u9ehiFXVDqcdAXFr1XH49Is3umKxOwSZAyuwoaHpu/DGjyxHOrkR7Cc/33W2bc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yzXlS9t/; arc=fail smtp.client-ip=52.101.61.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xagGyfh0L1/ptGlit/BcslQ6eR9MwIhr65KCPO77bhzE8PR8Tp5GhxHDLPqrwQEwXEy3TSBiB1xO/BfVxJPhVp8A8GQ44p2i5iBgUC++jnn5S+bAnYIKf/+WqIXEixNKdra22WizX6zPGdBnLXS6ZXEgrLpnBAGew8oZu986pY4IoLATpMzHuki0kgyeoAyAXvUbX2xy2RKX6m/PUDPL1RrzzSuHnPBxqFNW2KS7f0u2IeB7m/tdyOU4elfnYMz5urqYRZ7E/xF4sU1KFq3d86W4nTY80DCb5YpbzAJkTJnGUDLWGbaH9amAF6ynHKuR4KViS9bC0mi/C9t7hOmggA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bzdgmrITUr8WXWhjqkqp0Iyh6372DS1Jb0UMPkRSGzE=;
 b=opH5fhw+y8KO/gFzzQFCDMmgwv64QqwFOnFRXReVJQOaATbam07Bm7sEulX4d+RdgkR0Ag0R2HL38/RXs19cTXDMSqYpq0asHChtXP5Oz+TLRnw94zOa+XxgHjUtv4uEIVojo+UUsiMRxc5VnpiszcsVOUglBC+RkqMbZ9uUjN/QIXyzDgtRKT060Q9Fpmds0vE5CYyOpthub4+/uPPv/OQXz92hDgi0jsl8cM2ivqSNpWjB2aQ528N3BZ6LG7edpIQ+QiVxLnenY2N6AZHdtxNCsULzFC596aHX2Tq8e9kTc7D0FAMRb37U0vJT/3ur7/itDldkYc4+LrLRFm2S+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bzdgmrITUr8WXWhjqkqp0Iyh6372DS1Jb0UMPkRSGzE=;
 b=yzXlS9t/stuctRqxQBg1vYCZWW4TVl/+Y7KXnSN/hcokgVqh8rmJjWTVc8xIZ3PgwEzoO5mDXtAoh8CLQD2zL7B6vOKYnQOvblwJJ19cebs2JEkFpWphtVxZLXItIZCIPGwqKGjdl7DiDUl9BRsk9s9RBeiMEi99dTxltwxGjZA=
Received: from BL1PR13CA0159.namprd13.prod.outlook.com (2603:10b6:208:2bd::14)
 by DS7PR12MB6334.namprd12.prod.outlook.com (2603:10b6:8:95::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Mon, 27 Oct
 2025 19:34:20 +0000
Received: from BL6PEPF0001AB54.namprd02.prod.outlook.com
 (2603:10b6:208:2bd:cafe::75) by BL1PR13CA0159.outlook.office365.com
 (2603:10b6:208:2bd::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.12 via Frontend Transport; Mon,
 27 Oct 2025 19:34:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB54.mail.protection.outlook.com (10.167.241.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Mon, 27 Oct 2025 19:34:20 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 27 Oct
 2025 12:34:19 -0700
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-crypto@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David Miller" <davem@davemloft.net>
Subject: [PATCH v4 2/4] crypto: ccp - Add an API to return the supported SEV-SNP policy bits
Date: Mon, 27 Oct 2025 14:33:50 -0500
Message-ID: <e3f711366ddc22e3dd215c987fd2e28dc1c07f54.1761593632.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <cover.1761593631.git.thomas.lendacky@amd.com>
References: <cover.1761593631.git.thomas.lendacky@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB54:EE_|DS7PR12MB6334:EE_
X-MS-Office365-Filtering-Correlation-Id: 398d587f-17ed-4b9e-a073-08de158fd384
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9mMBOERtaFU2nYDGh2hpvSXt2vsvMcX02a1ogjoa88cuV9wbUgn2bclVAfsB?=
 =?us-ascii?Q?VwFupqHAm+MNqniM13DNn1dw/sYV0/tuorc/llZO41e0j+A79m/BHoQPPYqe?=
 =?us-ascii?Q?RzD6ly3LOC2mjdOtALzMvA7HoRBGsAZ8Ss6o7aZ0OgUyMN8liBhN85WneT3J?=
 =?us-ascii?Q?VL5rhZC0CVTSnqmKzUNjvZZQu0aCAN/JaNp91s8AGLlYvn0p4XjBFU5YdsUz?=
 =?us-ascii?Q?EWRnx6gWpgJ8tMSW9LHCUwyDAqiGG42/lBXvZLi3OB1erSnX7NeqYXVbTIw2?=
 =?us-ascii?Q?fx/SliaANaAyXG4QDCN4lAzpc/GheRgSBuKWK2L0x9Bqu+aKeUivfJWmfW0Z?=
 =?us-ascii?Q?0dvmntIBxWq4EryQCRbvUIMnWT347GQzJAxxacQafpjhb5Cd1223VmwhRqDd?=
 =?us-ascii?Q?MvdxOkMOW4butmAlt+CeCfMhTDLzp6GzWqszFl2FFao4Leb/YjrQJjW1udDf?=
 =?us-ascii?Q?G5XRBj99QKCmIikwgRfMWwkNNMx4ub9jp3vF8H1ASP59mvZ4+CXWjaohMmJr?=
 =?us-ascii?Q?f0tVc7uUU1FkGv1AVMtcSuS4H6eIuuBiToyiwT3SPgaZMAOUKEsVwrnGwb+G?=
 =?us-ascii?Q?MzJkFzelU4lcvGqgUpFkhyJn71wCf3RIzIbUmVFLnQUO1Wb41WvxtVtBhKot?=
 =?us-ascii?Q?8aIfMXasCNcbXFVgJuLkv2aW1PiZyB7aupefsJTCG4kq60rWwWtn8Ch1jww6?=
 =?us-ascii?Q?A2ZytgK2wFeNkjm/9jjEQ3xOXc3gvEIG45Bo81DLmdFaQa/6hKmJhfmWagxT?=
 =?us-ascii?Q?fgDV0ImQ8m+ylTPJZJLiA9WOU6RIQ2ntxL+983tM4z+o/iWC0s318oRgN7fy?=
 =?us-ascii?Q?v5dPWxX8Qab2dtKN2A5t3Q0ZazvD47eS0txAxpVM70WxMUMWfmlPBHWCJ6c5?=
 =?us-ascii?Q?cmn7XxYoRZg85doJWY/jUDhDCIffn+HNpIaJbPlnc1gHWdoF+1o7lAf90bol?=
 =?us-ascii?Q?+fV8QHG1/gRaSacmySGLk2zpUGgcCeNpus/DnOwSTZ7SNarTPnFu+quedPUP?=
 =?us-ascii?Q?Ky/YNUw7d5WhFh/DZ3z7VilGRF1sSr8H3aBQLsQirj79BJ1DEPrB/8/Q492u?=
 =?us-ascii?Q?cBh7mbNVQAti5hNFEfpYDPSFVyH5amMkES6A7yTu0CaW7KIfkygLfE659ohc?=
 =?us-ascii?Q?1oXyja3SVDUrf58xgeKvPehMn7utFSnBpNGFfgdH5xXGZlc1U7IIkEUvLIIu?=
 =?us-ascii?Q?s03BLLpvXgG/IElvxmeVOlRSSVl0QTFw7lmyargpQNF0BeeFnjO/SCy2urAq?=
 =?us-ascii?Q?ftjsooXROEWJbCM5FVRWQzreV94Jd3UXS1yjpuXrgnZS85S14aPeCSR1U4+w?=
 =?us-ascii?Q?15b13go9XoxFlBFeLJbL451wPpXOUFDLvS2O2YyWHBVo+ia1+oH2IBuQ+/IW?=
 =?us-ascii?Q?3NIkm2PWmBMMECncjGz2jkxT7a9/fjSOhf5T8fALvYx6NOO2vNgJzezRcw+6?=
 =?us-ascii?Q?nOStTNUnHi/Xcn2k5vPsia6oxmf8RbVWe3ksTL5l5j2Hyfc8RhhS5FuEOgXY?=
 =?us-ascii?Q?3sencBNNIWl1boZsWxyB0HZaRC8fAOJrKKgRRdbMgpjfgRyLjPaI9QAaoqjM?=
 =?us-ascii?Q?L2HGysoNwig/dC/AWD4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 19:34:20.5949
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 398d587f-17ed-4b9e-a073-08de158fd384
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB54.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6334

Supported policy bits are dependent on the level of SEV firmware that is
currently running. Create an API to return the supported policy bits for
the current level of firmware.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 37 ++++++++++++++++++++++++++++++++++++
 include/linux/psp-sev.h      | 20 +++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 0d13d47c164b..db7c7c50cebc 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2777,6 +2777,43 @@ void sev_platform_shutdown(void)
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
2.51.1


