Return-Path: <kvm+bounces-58181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 574BCB8B062
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 21:01:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 587731CC5583
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 19:02:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61ECC2848B5;
	Fri, 19 Sep 2025 19:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VFWOqE40"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010038.outbound.protection.outlook.com [52.101.193.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42A7283FE9;
	Fri, 19 Sep 2025 19:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758308463; cv=fail; b=qA0HoL1KbC6WNcFIdEkDicD9XHPdRhrE2nyTwZ6cL7b+XjuZuREMCcxAjsHDvP6Se0hot7ZcM9RDsc7Nh/yisVOz+coNjtKCYoaGagafvZncrUpNwxULjyUM0FJZhG6g2ktBj7vQsTwetyjy4G4lOsOWol0XytG8yHioir5fGns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758308463; c=relaxed/simple;
	bh=C0XBK7AVJKhrvSJl6QonGhjyqtcotUEsYK0LC71xgjU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gpmi/SEDyarPyO75QVoo5qMMAxu9ipVgEsxISrociKMHVIlvEw5tOH9hkRqNcR+opBqXUvu3Wl+TCI6nJdE3HocuTxec+2v+kMBXfsFkM7dsuF6dQBEAPaKu1AfGB90PksAkeLbG0h2e1ngX83iw2Dz21sfzmgg0k8/dUgYymTE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VFWOqE40; arc=fail smtp.client-ip=52.101.193.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ETCDFUi6xINCD81vKFKqc+ocC3RIAV3Xlukn4w7P8TwHZJBCYnKzsn0BZEKrCciG1JZGBaPSZS+EC215s65utEah3sF8aPZwSeEG6m4Z6ELeZIgiG7CScKctJRoxP7gIZE/uMqVHecLQXHmeBoHCGnWLva2vAFyChRx0HHdgqeWd/M4aAhyJQZdxgUuS3e0IHD5Djhz2btH41eamrGD5iuEa4KwZQLLlmnSs8WO2QWCq3O1wHu5OeKZX+2LecZIVQYvB/ZHr1nGuYx+5VD1JQ8SHBtVQDaOBR8z2xK/gVL3fNUulqbxaCPQr3ym7A7V8SwuHKGWWiAeUGV990DWs7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LT+O+5QyjAgJSX4ZevwtHEOXe+5G+ornM/tCjy8O5qc=;
 b=oyr0SG7b15kEB6iWQQDqKh6aIiX37TxEFDNxFxYL9al2SsuXn5WTDN+UwmZ7ZY9rnN5UjajlYYw/3x9CVLWbGbtSSnF6Q4XEWkZLCaOpacK1vM7ns6oazXxswSapzbGIbez8ms9DN0Y6awTU/D5Hff5wOkJRcKNaTWgOxS8Kj/5vPh3zPe9SakERuZvkrh7UMwmhX8pFZhKQXHpXIUOS7++8j0BMFyPUrotEsDMre0ARqSoulOyXEMtQwf41fv3LRCoRd+Vrbw8TbCsqDYP49SwAjEkl/nJZQeufnc6AQwKiS66c0W1g+Tgv6JeDmUFbUheSc6nr9tSENAReNtoJ7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LT+O+5QyjAgJSX4ZevwtHEOXe+5G+ornM/tCjy8O5qc=;
 b=VFWOqE40dHfV469RCW3dB4P7HMQFGGuYriFHfgu6XS8ogZSb3S85wp5BCumlVrlVlIAIvUInSiQHFAvD4Z6tMry59EpsflKyO+yqdqyYwlqwGB1e1bLJIAqfK0QKoYFkURPSNjIt4/ixQj1nZwvmjpyhkWBV+7Cnvt7O3KwglvE=
Received: from BY1P220CA0022.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5c3::14)
 by DM4PR12MB6472.namprd12.prod.outlook.com (2603:10b6:8:bc::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.19; Fri, 19 Sep 2025 19:00:58 +0000
Received: from CO1PEPF000044FD.namprd21.prod.outlook.com
 (2603:10b6:a03:5c3:cafe::67) by BY1P220CA0022.outlook.office365.com
 (2603:10b6:a03:5c3::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.17 via Frontend Transport; Fri,
 19 Sep 2025 19:01:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000044FD.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.0 via Frontend Transport; Fri, 19 Sep 2025 19:00:57 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 19 Sep
 2025 12:00:55 -0700
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-crypto@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David Miller" <davem@davemloft.net>
Subject: [RFC PATCH v2 3/4] crypto: ccp - Add an API to return the supported SEV-SNP policy bits
Date: Fri, 19 Sep 2025 14:00:07 -0500
Message-ID: <27988b066cdf271711c4e7a99dff0f07cb745090.1758308408.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1758308408.git.thomas.lendacky@amd.com>
References: <cover.1758308408.git.thomas.lendacky@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FD:EE_|DM4PR12MB6472:EE_
X-MS-Office365-Filtering-Correlation-Id: ec1e389c-f151-4997-c8be-08ddf7aeddd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/oPL/i1bVk+W/H3GLEdu213v1KiJiRamSHRMf/e+RPcJEFpsSz5Wiae0/8Go?=
 =?us-ascii?Q?JbUmVu2WcXXxXP81QFVyTrX/6/N3NAUMaimDKrdirVNidy6xNaQf8Hfng5PP?=
 =?us-ascii?Q?4/kXyKgaXjdqn3gj9C5uTulw8N7DYE4uCbqIHeqWEvO75+F4dKMF6LJRPw+R?=
 =?us-ascii?Q?+Q9pJlfTWWfqzvxhRI5qKJ4E7Ahd5VUNU9xzlPj+uIM6N/h9LFqUj+60cUmI?=
 =?us-ascii?Q?nIvTjeGB7M5+El3VyFVQb10y+Ecbszg7s1WYxh7EyjhvK3kk+wDDJg9sIaD4?=
 =?us-ascii?Q?2hxlClx/vnKqkrEBiEh5tZH4AjZ6CUmkY1gwE3Ni0olHPdSnnTwmuiPhSQZR?=
 =?us-ascii?Q?hm4/t40e1miUjnjAZYMY7MMA/0QExZS/JAu1qK/YxNIlfkXebrgH1UOwQM3M?=
 =?us-ascii?Q?OBFpaGo2oXQcTkKwfS0EST37WNT6UsAePUksFgkGisLNGEJ74IK8pIHzEvHz?=
 =?us-ascii?Q?QfCYMU5ub91Tr6XQTGx/sEOlQYP48FY8k+OuPNS0Z5yrqwPaK2xLFmUfX5z3?=
 =?us-ascii?Q?9MG4GPjrUWD2FSKHuLIm7pmj04RfvsOCPd0Ne5IL0Zpvi6BQfxq3N8w3RF/s?=
 =?us-ascii?Q?+usdiPWVgzdsqoa9LFs1uFpEAdjFNFZ59KIcYO/cdOU/i2B/4ymKCn4TWmP6?=
 =?us-ascii?Q?p+KenKLa9SkDOYfT8wWyrYrVzeu4uUpFxTelMkqAPwjGArbGt1C1cBDwXwPy?=
 =?us-ascii?Q?pcRwsa1ixnJ9pT63Dh1E9zFo1hoNcSGWif3neffhGVjr12GQbbyLg1IndmMm?=
 =?us-ascii?Q?e0n2EYR9nwJi0yeYCOx1kaepW3KNd6+L1fNBCjge9cnzyLEp6WxKpvjUd10h?=
 =?us-ascii?Q?Pkox10oe3ZYB2jh9gVlGuz8WHnjNtAVFtfvWy+RxXjPsl3RCPbaP9Z8ij2xT?=
 =?us-ascii?Q?iSshPLUY+yP+yAFY/B++PPpoG7phv+H1GXKTQQPXKWvlG4izWFp64YTsKIWg?=
 =?us-ascii?Q?cbHETuRS7jQupRVBcqltfYROAjARuaxyWthr2SW8RGUOXNjgRtZ/S9HNeqKg?=
 =?us-ascii?Q?2c77qLdogZKrZR3wBFmIi+vcBwqt1pVXU5jlYc3CChc/3v7q8ido4QPBCZAF?=
 =?us-ascii?Q?C+gSZuPqPpXVHtF1FLjkKePtU/fL8PHNdyvSLxu8z6/+XUQbSbbbkzjoLpJN?=
 =?us-ascii?Q?tH5VS8D67OPsNLWDc+6q3b8j+rPJWISkzqcn6gq7GlmSVRFnO26qQvkPWODK?=
 =?us-ascii?Q?leMUpIv6cOnaT63sJs9QaPr1WgdmsXA/ym6x0p0Vzi6tE0aR3qnVSQ9x7UwV?=
 =?us-ascii?Q?PClgIL8LGZ9itK8ulzQkUQcPca5MdliRrpP0IUbuP/YmEsmXcJ6L496r4rPX?=
 =?us-ascii?Q?22FJHSb3FjOdQ1rm9XdOnAYBh/78O+USg5gNG2YgheshPDnLn6i6cvmWMF+6?=
 =?us-ascii?Q?jxUBuTtuoaAZad1yLWZ9K33LrZES1RHXJ8pidYv04sfcQXVFKmZPSrUwu8v+?=
 =?us-ascii?Q?PZN2KLMcq6N602kNF9zSfoFdk1mAKQHf9Vt3DiPlGq9SvGYdZIzHUA+Pt4Ka?=
 =?us-ascii?Q?+pFRGBarnW5+dw1HCQSZVYepxViwjj2JBhey?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 19:00:57.2200
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec1e389c-f151-4997-c8be-08ddf7aeddd3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FD.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6472

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
index e63f2ee57204..f77da22200fb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3083,7 +3083,8 @@ void __init sev_hardware_setup(void)
 			sev_snp_supported = is_sev_snp_initialized();
 
 		if (sev_snp_supported) {
-			snp_supported_policy_bits = KVM_SNP_POLICY_MASK_VALID;
+			snp_supported_policy_bits = sev_get_snp_policy_bits();
+			snp_supported_policy_bits &= KVM_SNP_POLICY_MASK_VALID;
 			nr_ciphertext_hiding_asids = init_args.max_snp_asid;
 		}
 
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 334405461657..d4159cec12a0 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2583,6 +2583,43 @@ void sev_platform_shutdown(void)
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


