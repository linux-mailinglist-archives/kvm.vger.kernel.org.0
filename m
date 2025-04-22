Return-Path: <kvm+bounces-43738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DF68CA95A2D
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 02:25:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE4631896D44
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 00:26:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2485556B81;
	Tue, 22 Apr 2025 00:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2oeaI34n"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2078.outbound.protection.outlook.com [40.107.94.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D6378C91;
	Tue, 22 Apr 2025 00:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745281519; cv=fail; b=mVNzUSJV1fC99+1paTk/cNWui1gJljgbDdJTB/3RIXyDU7RgWF2x4JpxyPjHM6q4GkL7701QNpwg40S5blaFYgZlsF3NEueVnCLampPSTO3FEmbiCwyH2XI17d6eaeYJdf8GDvYj76jQ8uVLPyDioJI3g8alBAcS3RtJPppfH4g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745281519; c=relaxed/simple;
	bh=Pxd7oieyZzcutl1SmkqtLfmm4aDRFfvCSTVgCABXEpA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XwT4/irvjF0vuXFuoUDPDez+BhCptwzxBARmX15OhgLf5A3RpjCseNv4OUzEC6I45p8r9x4nHZFOsTjLHNzf1gxCGLJ/YhTbRtKMl2/AcGjZZqj2iSM91f6GFS/qTxHDaBmzYZ+OPaBCMQ20rvd04UOXnFFR/ZZMbXTIqT5fmTY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2oeaI34n; arc=fail smtp.client-ip=40.107.94.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HbAqYSlEiH0dq33zSZj3iNwfkvOtYfv/ZLFCSPxIN08okiu1YwpSBke2Rqpnx1CTK1abpsiHIBLuP0FuVd3Bs68vMgsKJzGXE/MKAYMvgT9pq4Fe8ror78wZLOF0Oe1racIQ07JBxK1el921jYOgrcDAXZtHlhjwYUJlQQWJE7JFPhYAX2Kg3Ckd9Up480bTLqPhIgy/NvT6hxmdYM29i80IJbzbRGRAnhsRIznSZ44zFEaOuE7p6vyMiNKft4RcJGD1L2v83da9AcGrX2qySRsAQwrd44HdUDZKtTrnf8iTTMuNULn+68yzB2BgYSFDOrjh4qMqsk+yaEtmDkHqEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hEpTmj/MMhtiYoaekyNIEgDDO1u3tZjhDvLwRjmYlIc=;
 b=gZpKVrkbtf3u2oGCuZAcO+E3NOl0sRUNCKyWi7wGRDvzlG9wYc8fjaiI8jsfDlMltBxAbeF5ZT4ea2n9QmTRVXVpw18vodviZ21sM35JxBsvfH697F8PVAQ9pK7z05rM5qN7hIxQ+KL6UM1gptzmdCewKB4eS1E0DycFvpsHs10kHf3FogRHXc775QNqZWkjbz2znk+wLHlSgWILetfeAT1urXzXZ4AVhHAn80WUR5+IpikA+nUaQIBmLSh42Jk1XWgK7clXw3GBjI/9Q5WA8FCFfkq+K/bqCIBxV6GNH7u4FZvOw0MhFJHOuY6hmvNRP+8o40Nh6i0Fv4trq1oLqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hEpTmj/MMhtiYoaekyNIEgDDO1u3tZjhDvLwRjmYlIc=;
 b=2oeaI34nHqNrS/HlTpG0s00win2K+ggbPxicoHirXbRV3aANrnLQXelUkcLY37OltjDkjh5zlGR7ngYteSj1vQxBQUChtzEGSOHjfcw6z10QoNpuAJB+9rC6QAK6Bdo72ZNSGWh3ZNsmLgoeVhv3Vfns+Jx7g4KnY5W4O4vSUf4=
Received: from BN9PR03CA0396.namprd03.prod.outlook.com (2603:10b6:408:111::11)
 by CH1PPF68E8581EB.namprd12.prod.outlook.com (2603:10b6:61f:fc00::611) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.34; Tue, 22 Apr
 2025 00:25:13 +0000
Received: from BN3PEPF0000B06C.namprd21.prod.outlook.com
 (2603:10b6:408:111:cafe::70) by BN9PR03CA0396.outlook.office365.com
 (2603:10b6:408:111::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.35 via Frontend Transport; Tue,
 22 Apr 2025 00:25:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B06C.mail.protection.outlook.com (10.167.243.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8699.1 via Frontend Transport; Tue, 22 Apr 2025 00:25:12 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Apr
 2025 19:25:10 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <herbert@gondor.apana.org.au>
CC: <x86@kernel.org>, <john.allen@amd.com>, <davem@davemloft.net>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
Subject: [PATCH v3 3/4] crypto: ccp: Add support to enable CipherTextHiding on SNP_INIT_EX
Date: Tue, 22 Apr 2025 00:25:00 +0000
Message-ID: <94ffa7595fca67cfdcd2352354791bdb6ac00499.1745279916.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1745279916.git.ashish.kalra@amd.com>
References: <cover.1745279916.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06C:EE_|CH1PPF68E8581EB:EE_
X-MS-Office365-Filtering-Correlation-Id: 5814acad-fa13-408d-00f5-08dd813425b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XzCwb789kLA7sl/qao3GVypeaCrSi+SYF5EVDc/u9DlaBNqMfR9yGCB7Cm/3?=
 =?us-ascii?Q?UZulAy/PpeEmXd4CzZ/1mYNNpxJ39DdkVISywL4EIds5/Zv36wwETBlfrF4j?=
 =?us-ascii?Q?kQfpVCmgt+LrIoTESahgPalVcCwMFODTBjcsM1mEWQe3jwpzh7JUdbn6MIPi?=
 =?us-ascii?Q?ORMo7h87vvAdmM+jh/Zx0yvVxCCYIqBnTman0k98IcidX5BGc62piLO1UvB3?=
 =?us-ascii?Q?7OeTJQJuSyrQXvUGUNuuUHBOPrxbCaLByYChh19UY/BtY7Dj7X7Bp93KGPtz?=
 =?us-ascii?Q?m1jupXqkbP+QMvlA12gik02F7KGY06v0fjFCnf6BFhKqcwzZyfVzrPxi8v7r?=
 =?us-ascii?Q?gxOwWpx5J1UgGHpu8O5yh9MFWBCQ/Qjio1vbsbIDSXGwEoPIV2fFJdSoJME4?=
 =?us-ascii?Q?eFR+8O32lo7mekEmaMF8+6LNzXtMUPHcQi1svMnrW3BtaIm6NgNSM9nx3/sf?=
 =?us-ascii?Q?AD+KkbDGQCuLPjrWrLOOc3ApPaaxasO4v7ypMpdWLwP6ae4RYp9lS73xK8qn?=
 =?us-ascii?Q?4Mtl7p+FkPhMUD9txmWt8RcwZ0DbUgMeD+MLiG1Q0JqADPqKNVxPkJh8V5iZ?=
 =?us-ascii?Q?rZPG6aaQRP1bQ3xadNy/sxC7EU0boGWz5+UIusoPPuINnRNWrLvCzxBMqta6?=
 =?us-ascii?Q?WH5vvtrP3B36hB0JOZwFgw88QRyLs5F0m9Y12i7Prb14LseD126ILub41yR9?=
 =?us-ascii?Q?BOBAg7BmQG6ovoEDudgYdNzgvMXABVzvoWYRlHxZnDcqBwCvZ5A6zdjI7TOE?=
 =?us-ascii?Q?1/OBad8Qr3vCLONgoqKWoVhtyYJcn5GQgn0xuT3wt4kIWTy+m9/bNv7CvW4S?=
 =?us-ascii?Q?lanmucqDhPvRF0QU2mNQPHRxcahg0Elqi1eo8eqs5Ttlremek5meuE0tCDB1?=
 =?us-ascii?Q?jLxOYLeckrfSTPjQ5SzDWVXjfHht5wW54rXUJwbVX1SJbL6CtaMAruBWH64Z?=
 =?us-ascii?Q?K/uT5mgSdkm5TraSUmOdwkiIPfC3SUWevE7ITCXheeGvyXV7Gg222RoAbIwY?=
 =?us-ascii?Q?tAge6BpwCPgmgF/0JONwSnivtjtI44/7WpLivhQUX1MktnLZsBU7hZBnY5oe?=
 =?us-ascii?Q?p/5KoC7kjIzhiSD0rPIKU+1K63Fc2zZUvQPTLVe11C0t/1ULMjK/rOmS1sZ+?=
 =?us-ascii?Q?VGT9BRcEQTn55V1FdwG4H1pLjwwKMPV4prxM5cicl3cqj4osm5unzurfsiYY?=
 =?us-ascii?Q?6zdFIFEPoyMru7VPVlY8GPTu+57MP9DZlJKRGd8g2sP3xzpX7WWJZJ8gFJ4C?=
 =?us-ascii?Q?e2jStKc6qbbdPDNjni63klFGA7CnBfz9vKjaAEC/be6LLlK/xM2L4Z17rkg2?=
 =?us-ascii?Q?6biB9cjdedBn8e3b96gLuNJJyHF+TZmcsi+xkjPpguQ9hmAXkuhmiMFfxhVX?=
 =?us-ascii?Q?Q9X3U2+9QbPZEzBRqmac5WSepBePYalbKmacNoWB4Ql14gfUI1zZkv2zo6eA?=
 =?us-ascii?Q?UmF2hKBT22cM42sDU0ZRIvMUtdYDr8lo0KrPNgAqLyNjDl2wgI7iedCWLOmp?=
 =?us-ascii?Q?t0laZjVKoksl7zxJEsa6zcv5RWIgNz9d6MnL?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 00:25:12.6992
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5814acad-fa13-408d-00f5-08dd813425b8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06C.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF68E8581EB

From: Ashish Kalra <ashish.kalra@amd.com>

Ciphertext hiding needs to be enabled on SNP_INIT_EX.

Add two new arguments to sev_platform_init_args to allow KVM
module to specify during SNP initialization if CipherTextHiding
feature is to be enabled and the maximum ASID usable for an
SEV-SNP guest when CipherTextHiding feature is enabled.

Add new API interface to indicate if SEV-SNP CipherTextHiding
feature is supported and enabled in the Platform/BIOS.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 31 ++++++++++++++++++++++++++++---
 include/linux/psp-sev.h      | 18 ++++++++++++++++--
 2 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index f4f8a8905115..ca4b156598de 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1073,6 +1073,25 @@ static void snp_set_hsave_pa(void *arg)
 	wrmsrq(MSR_VM_HSAVE_PA, 0);
 }
 
+bool is_sev_snp_ciphertext_hiding_supported(void)
+{
+	struct psp_device *psp = psp_master;
+	struct sev_device *sev;
+
+	sev = psp->sev_data;
+
+	/*
+	 * Check if CipherTextHiding feature is supported and enabled
+	 * in the Platform/BIOS.
+	 */
+	if ((sev->feat_info.ecx & SNP_CIPHER_TEXT_HIDING_SUPPORTED) &&
+	    sev->snp_plat_status.ciphertext_hiding_cap)
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(is_sev_snp_ciphertext_hiding_supported);
+
 static void snp_get_platform_data(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -1147,7 +1166,7 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 	return 0;
 }
 
-static int __sev_snp_init_locked(int *error)
+static int __sev_snp_init_locked(int *error, bool cipher_text_hiding_en, unsigned int snp_max_snp_asid)
 {
 	struct psp_device *psp = psp_master;
 	struct sev_data_snp_init_ex data;
@@ -1208,6 +1227,12 @@ static int __sev_snp_init_locked(int *error)
 		}
 
 		memset(&data, 0, sizeof(data));
+
+		if (cipher_text_hiding_en) {
+			data.ciphertext_hiding_en = 1;
+			data.max_snp_asid = snp_max_snp_asid;
+		}
+
 		data.init_rmp = 1;
 		data.list_paddr_en = 1;
 		data.list_paddr = __psp_pa(snp_range_list);
@@ -1392,7 +1417,7 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 	if (sev->state == SEV_STATE_INIT)
 		return 0;
 
-	rc = __sev_snp_init_locked(&args->error);
+	rc = __sev_snp_init_locked(&args->error, args->cipher_text_hiding_en, args->snp_max_snp_asid);
 	if (rc && rc != -ENODEV)
 		return rc;
 
@@ -1475,7 +1500,7 @@ static int snp_move_to_init_state(struct sev_issue_cmd *argp, bool *shutdown_req
 {
 	int error, rc;
 
-	rc = __sev_snp_init_locked(&error);
+	rc = __sev_snp_init_locked(&error, false, 0);
 	if (rc) {
 		argp->error = SEV_RET_INVALID_PLATFORM_STATE;
 		return rc;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 0149d4a6aceb..af45e3e372f5 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -746,10 +746,13 @@ struct sev_data_snp_guest_request {
 struct sev_data_snp_init_ex {
 	u32 init_rmp:1;
 	u32 list_paddr_en:1;
-	u32 rsvd:30;
+	u32 rapl_dis:1;
+	u32 ciphertext_hiding_en:1;
+	u32 rsvd:28;
 	u32 rsvd1;
 	u64 list_paddr;
-	u8  rsvd2[48];
+	u16 max_snp_asid;
+	u8  rsvd2[46];
 } __packed;
 
 /**
@@ -798,10 +801,16 @@ struct sev_data_snp_shutdown_ex {
  * @probe: True if this is being called as part of CCP module probe, which
  *  will defer SEV_INIT/SEV_INIT_EX firmware initialization until needed
  *  unless psp_init_on_probe module param is set
+ *  @cipher_text_hiding_en: True if SEV-SNP CipherTextHiding support is
+ *  enabled
+ *  @snp_max_snp_asid: maximum ASID usable for SEV-SNP guest if
+ *  CipherTextHiding is enabled
  */
 struct sev_platform_init_args {
 	int error;
 	bool probe;
+	bool cipher_text_hiding_en;
+	unsigned int snp_max_snp_asid;
 };
 
 /**
@@ -841,6 +850,8 @@ struct snp_feature_info {
 	u32 edx;
 } __packed;
 
+#define SNP_CIPHER_TEXT_HIDING_SUPPORTED	BIT(3)
+
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
 /**
@@ -984,6 +995,7 @@ void *psp_copy_user_blob(u64 uaddr, u32 len);
 void *snp_alloc_firmware_page(gfp_t mask);
 void snp_free_firmware_page(void *addr);
 void sev_platform_shutdown(void);
+bool is_sev_snp_ciphertext_hiding_supported(void);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
@@ -1020,6 +1032,8 @@ static inline void snp_free_firmware_page(void *addr) { }
 
 static inline void sev_platform_shutdown(void) { }
 
+static inline bool is_sev_snp_ciphertext_hiding_supported(void) { return FALSE; }
+
 #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
 
 #endif	/* __PSP_SEV_H__ */
-- 
2.34.1


