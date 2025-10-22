Return-Path: <kvm+bounces-60844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F9B2BFD9FB
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 19:38:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4B85F4E6706
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 17:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BDB82D47E1;
	Wed, 22 Oct 2025 17:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HjoSTqAU"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012024.outbound.protection.outlook.com [52.101.48.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B0E2D29B7;
	Wed, 22 Oct 2025 17:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761154706; cv=fail; b=J70hekpTPfeeaemBwz/Nwylo/Y/2ifMfa7/h8qYxRCfFxWv/7bnCHCsq5xZR16beOvVRNegoATnHswLcLpYP5ZUx8Fn7w/ALZrJ9pus0UkQ5z9Au1FuVdvt26J2JB6Scr/j9as2UzjLlZfJ2Gn3OV0xhCt7eWnxR6oMxMNNnOTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761154706; c=relaxed/simple;
	bh=vc/I7K30t008SnvmNyF02++PrO3hPXQ8NLnRyXTFFJ0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K9zwswIJjIEN5K2SGbtZsb8AALAwynXAWCMP5WqOnmptGxLVbzHp8IsSDyvO2gLU43hm0Z6rk6M1Yo8+DKq9tU2+AD8lB83qbYb7M56ZireHH9bHhYfJ36su2ONAJzVwyn6qkjVcA+tE5HgKuZDMUkmQbNp4/f/LLFBEIK/D8L4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HjoSTqAU; arc=fail smtp.client-ip=52.101.48.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GsrCU/fLdW+YDKAMRC5mpOsz8r+7+bZUdf6grpheOmYxzaRQHybTezkgP6/G3gO3lrQvvS7hfOO3gXiYaC8GpdquKkM5fE+BU0z85GLW4yPJxwzvb3SG1sO0R5kFTNbDHERcWRZpNtn3euKbVphXxE+nF+P2k6jzlKfxgCjQ1sROEn3vjNpwaCJkTyALf/4C+MB9rroGaTGP2mSW1M9NHP0X4ZjdZFYiXYS6isR2mayifOPKkDuiSt3CQcvbp12GBteG+s/V4R4Ipb3VbELdY8/mVB/ZaGPwWRsXrrrgNy0+4/X2tlG1dtKsntg5VR2bCZJaABTYTvJ/Nas3DcgDcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gzgtGNZX0C3COPXskZoEwnjPN5MfB2avtbyLQ+7MQTI=;
 b=MxEcQM3kr5Fip0vROaB9XMQ2rwumOiMSR+f2Rz0UpUGtl7mDXf+WcvGq+rtlor6D07ZN3SbIkNA2vdS32jAbuoQk4Z/uDam65+rT1sjYbZ5clgrSfktFpKVVxsZA4d65rJMiIt/8NxfPaBw24LIW8mUkXX0zQVbi5J/xTr5qU6Uxh2BrOEPzq5Va7DHJDM8jfjM2JmVHZXX1NA0h/mZr6siypiYHO8w5v1NH9x68BN6o7XOy1S+TbYLuk7lRZ6dVF4JrFa8B5693olMROVkJxMG282OUg1pgFfYWyXZQox6sbNV8NZ5aHciDqr6iPJV1d0/x1JYtwTfRkMnu9YoCKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gzgtGNZX0C3COPXskZoEwnjPN5MfB2avtbyLQ+7MQTI=;
 b=HjoSTqAUeI+VtXGWtQ/4aXuFSvdCFdD2+yFsOYwYCD+6eh4RA8m1wQlDAgKBre5jIbGbIXDMtTEeooVPhQlH4hD75QhPEOKRkP2+vEgPPZGfGKONht7IfIiJIYNanDImQZ1Cl9Iv0PDvpkxpciS8mUl1EBs/SqsPF+sTyHB04C0=
Received: from BY1P220CA0018.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5c3::8)
 by DS4PR12MB9609.namprd12.prod.outlook.com (2603:10b6:8:278::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 17:38:21 +0000
Received: from SJ5PEPF000001F1.namprd05.prod.outlook.com
 (2603:10b6:a03:5c3:cafe::2a) by BY1P220CA0018.outlook.office365.com
 (2603:10b6:a03:5c3::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.13 via Frontend Transport; Wed,
 22 Oct 2025 17:38:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001F1.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Wed, 22 Oct 2025 17:38:20 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 22 Oct
 2025 10:38:19 -0700
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-crypto@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David Miller" <davem@davemloft.net>
Subject: [PATCH v3 3/4] crypto: ccp - Add an API to return the supported SEV-SNP policy bits
Date: Wed, 22 Oct 2025 12:37:23 -0500
Message-ID: <3a86b3678a78a8b720d3818f4121972f67e2d0a8.1761154644.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <cover.1761154644.git.thomas.lendacky@amd.com>
References: <cover.1761154644.git.thomas.lendacky@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F1:EE_|DS4PR12MB9609:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d628f41-1303-4e53-58f1-08de1191cb05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wmJE67DvBoBGY3/L71vXDD+gjWiRkjrYRCj4nzgYQzkjocwGZICxeOo1aWlk?=
 =?us-ascii?Q?QkuJbgWh8uCEN2/Rpx9GbeO5Ezfz9y8KK9OAJNxaa9zQfVZwD6DY9WfMEaYu?=
 =?us-ascii?Q?ggG/ZlbRvocMHiva2zxT62isK1CYWJQHw5J6Zp+oWZ5UwPNXX2Dpu0eQ5GlI?=
 =?us-ascii?Q?VNkv4UqyfFJpTD5QtamnACx2kMiaesdac3SazUy/JaM1an0LnDoLvZJ13ONq?=
 =?us-ascii?Q?ThnuzCPXR81/IjaoVRxsulQD811N/zqoMKqQgojnvRg+QM2ElCizlwBhyT1X?=
 =?us-ascii?Q?/60qmxyWjv7Ou2SUZpfafH4yf+5VNTfkfaVBCNaNkckg65zlf1sHdPzy8EUx?=
 =?us-ascii?Q?xyVrrqY6DLMWE5B9HoGMKb0CGzb21CQo8kd16z08a3Gjb82gKKlWjUFB/4oX?=
 =?us-ascii?Q?YBo5G+3XzJ9zjipf9lCK3bTo2U9FV5itGvvzQUnFu6KafAk37DBZTSbh6tRb?=
 =?us-ascii?Q?48HVmagTXaNtQo+uQ8dV4VBeDciPODntLxH3cbbRMg4hj/dcs8hdxXde+9pS?=
 =?us-ascii?Q?mJrUaOlCxIorDcbevxTD0fG+5HnqEb+fvabSF80XsKsIQmb4j/bP8iWFWD06?=
 =?us-ascii?Q?MJOj0CjSBpd6TRT7r8iQTtW+tpV0dq6xJyWrZXjS2UoS8kfy+O57E2DQNj34?=
 =?us-ascii?Q?mhmRjD5IQHBvY4MDw8lrwygFBuxAXYw4MuJO+elRqAUkL+alJdGvP2N6GS2Q?=
 =?us-ascii?Q?28Qkcs+KJbRfI/UBj/4cMoizaVlUzuyLYUJgZCQ1P77PYjlCHgGx8s1wYg2P?=
 =?us-ascii?Q?hlQ03nzxlrvKEqVMFrZisEQEm1rX+PbIwUfehSW7klaOQ+97IgEKMsCwsoon?=
 =?us-ascii?Q?BZBlq3B7mYNRBafeFJZ9+xSSa2WWYR9i06K+6/PMCi1M4JyCFSy/w0BOyw54?=
 =?us-ascii?Q?bBijZBCw5s9GdCJmZ3kDuuRVmsWdMe/PG9C9dlvIrwhnedvxl7viiAzpgfJs?=
 =?us-ascii?Q?FqPXfSBqvUCvWtft6ASN0+Ry9DXZw8ubPuwnJidhZFP9FYe5jrDg3BwizgsZ?=
 =?us-ascii?Q?uBnq7ze3nzwRQTjnFKi1zQYohZLWHlnIoIuXAFwG6jn+z0PGcFuZrq+8YKlr?=
 =?us-ascii?Q?X9O9k7rHxljFIERuuIWbghu71djF6VrHXNOb/1ILcuAAIXtDLlF2ZKa+DAII?=
 =?us-ascii?Q?U1kDMCR2Z6df+FhJf6T2lbTtOFvvEn+BQ9LXxPbtu8ACmmWVZc7GVZR7HHyq?=
 =?us-ascii?Q?7AKv7vL45fDLC2U9ZGlwkd3d2TD2jXvj9U4xS/wrapYZgglSGA0we84YAtv2?=
 =?us-ascii?Q?6vDhV0ebwq2I473MBh1JcWs/riB42x2u6BpQyRHXtQoYI49neTHzVfqY2g27?=
 =?us-ascii?Q?D1pGW5u8O0LvUWhnEjR6iq57y0Bn4voTPoJnRV0S0tIVtVIiQ7K3fXfC/okO?=
 =?us-ascii?Q?Fb95Yq8voSi6Q0/ngJ5pKeAQVlVilro/C76VHZeq9+bqDLQqeJ10W871Hy2S?=
 =?us-ascii?Q?RP1EryFRG79G2nNFggvkOPyGySr/wKJWHFqBbJAhHLNU5+DX4abProl2uKLI?=
 =?us-ascii?Q?qh0drAkfz8hnHQXzEPjU2c4i9GybC1hdV/1xsHdFG7nrv03f/WXMUu1DF3wd?=
 =?us-ascii?Q?L2dwgS5WYUc+8ihF2yg=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 17:38:20.5913
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d628f41-1303-4e53-58f1-08de1191cb05
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9609

Supported policy bits are dependent on the level of SEV firmware that is
currently running. Create an API to return the supported policy bits for
a given level of firmware. KVM will AND that value with the KVM supported
policy bits to generate the actual supported policy bits.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c       |  3 ++-
 drivers/crypto/ccp/sev-dev.c | 37 ++++++++++++++++++++++++++++++++++++
 include/linux/psp-sev.h      | 20 +++++++++++++++++++
 3 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 45e87d756e15..24167178bf05 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3099,7 +3099,8 @@ void __init sev_hardware_setup(void)
 			sev_snp_supported = is_sev_snp_initialized();
 
 		if (sev_snp_supported) {
-			snp_supported_policy_bits = KVM_SNP_POLICY_MASK_VALID;
+			snp_supported_policy_bits = sev_get_snp_policy_bits();
+			snp_supported_policy_bits &= KVM_SNP_POLICY_MASK_VALID;
 			nr_ciphertext_hiding_asids = init_args.max_snp_asid;
 		}
 
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


