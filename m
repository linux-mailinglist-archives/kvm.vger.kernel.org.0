Return-Path: <kvm+bounces-47055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FBDCABCBD1
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 01:58:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 500A18C5AA4
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 23:57:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB29023C397;
	Mon, 19 May 2025 23:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pIEMzLc5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2084.outbound.protection.outlook.com [40.107.102.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D67023BCFF;
	Mon, 19 May 2025 23:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747699039; cv=fail; b=ZZjJEqD/CbVy4iz6y3nxvnJiy0kMp10ZwXPRJ1ZQn7uOd1ceXrN2Un9hdqknE0CBcyOVO8P4wWirOO/Exwo+Qf0PUvZV0WHCQ/3220boevNiW62LNuwT8psq6p3WZIMguj4FLLM1Wcg9vmTVBERoEenJvnxayR9wAgx0gZuaeyk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747699039; c=relaxed/simple;
	bh=XwIJVAvkdGi+5qSqFvEpVYYGaUCzLZyDbzzimVbXsgo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KyV2NH+jbvfziVbzvD3kYye7kcCRb2lWan9i81l176GBcuu8u7Pu+IMhl+o5btVkwGjIf2RAapgVTjTfQmUhCWP92TTa83Mn3sMlSQQLLOTNa9/aupGXq9v7MHIErBCuy22SzesE9V8XlQPpP2HzXacwhCt65dWLXjGjCpthAQk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pIEMzLc5; arc=fail smtp.client-ip=40.107.102.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QiIYuaNah5Q3/0xF6kP+dGAsuO6gzfJ0Kxj8wu90j6WgSqeFrITsFXYLZ2nh+3LGorVz/3JRzIWI4yn1WTwLmxfquXDo2Z3UdTM916uGkvYeXppWD2543oaFPSSCYMR0MyeK1QkhUOBcSM/hKtbIka6mtNPeEHUB5XSUwyDGlYN3RNU/o3tfllXhXnISZFnDNlUNHpUQzXlYy9hbJ8MjVYffUIYWEBMfUHgb7Bsup92NIGGET+X8FGATe0y9Usta2sHOBE8iyrkjGiV/360N5TY7T62Nm3/Nbr39xTo9FazLUNBIR/RK8K/Oov8X10CwQa0MV9l5C8ww5d/KPM9wwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vNkjPS6nn7fxafRRCVEVr+xBTMw0ai5qm0iRQjKl8jo=;
 b=poZstmKnhZodlCqiUHIBq6k+Tk0T54IAw9BFpotqla2gmC2qf46XAfKUjqqrFittHAI8VZFE/1OwX9yIPiMOELf9lKCS1dwJBJhLcHBJdAP5qHfe3fTXiOxY/bWo5uGqg8BtHq5RiEPnEJ39KF7YEf8Q7ok592sW1QlPrORDbKakwJ/3E6nCbhp1cYzmEUg0f86aePccHUtz8ScSEnhQ/sFEiWx4zDTjBGvTy1/6ICRU0VrEbMp41Tib408lYZk+0cWvSKVnz7vEGPMHvoh3GDFarWROx4LMFh/UBSWNcjr0HDt9f51V/OUQD+Zwa/oEhxRGxz9CUAYPmLxPbb0t+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vNkjPS6nn7fxafRRCVEVr+xBTMw0ai5qm0iRQjKl8jo=;
 b=pIEMzLc52Mv8EnANBFclkkFizday1uF3kInNJEjW/Ujt5umTXBOdxdvEE8dPbqKPF2BrBm+R3a4I6rJ7e+kG4b625YShMZupBnS71Hf+1sHybYDRrdg/HOssmlGJo5djvfoMLJAdjZINS9VZe1VoNbXThFHnD5G/YG81mnqBJRg=
Received: from BYAPR06CA0029.namprd06.prod.outlook.com (2603:10b6:a03:d4::42)
 by DM4PR12MB8498.namprd12.prod.outlook.com (2603:10b6:8:183::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Mon, 19 May
 2025 23:57:13 +0000
Received: from SJ5PEPF000001F1.namprd05.prod.outlook.com
 (2603:10b6:a03:d4:cafe::7f) by BYAPR06CA0029.outlook.office365.com
 (2603:10b6:a03:d4::42) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.25 via Frontend Transport; Mon,
 19 May 2025 23:57:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F1.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8769.18 via Frontend Transport; Mon, 19 May 2025 23:57:13 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 19 May
 2025 18:57:11 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <herbert@gondor.apana.org.au>
CC: <x86@kernel.org>, <john.allen@amd.com>, <davem@davemloft.net>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
Subject: [PATCH v4 3/5] crypto: ccp: Add support to enable CipherTextHiding on SNP_INIT_EX
Date: Mon, 19 May 2025 23:57:02 +0000
Message-ID: <0952165821cbf2d8fb69c85f2ccbf7f4290518e5.1747696092.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1747696092.git.ashish.kalra@amd.com>
References: <cover.1747696092.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F1:EE_|DM4PR12MB8498:EE_
X-MS-Office365-Filtering-Correlation-Id: bb5ec418-ed13-4727-ab2a-08dd9730e070
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gY68x1yJIqlkefc7Ltfd4As0r/4wYKjHyxTPjRgc4k4wRSHfU68aWKoOHmIp?=
 =?us-ascii?Q?Kal2xTavnmwwgl2qhR5Of9zaMA4d17f2oSIX0hhd6ZhFt8i1yd7tHj+3V13I?=
 =?us-ascii?Q?Gv8GbhhvyqTnyjFnq42VB0Ue3rXMqkfBE9gQldvsfbOifOTeg0HsjDgVIld2?=
 =?us-ascii?Q?/MJIscsej/Ug18klzpMqXr57CbvT/hIbe0SKLRHYNte18jGayDyrbDNfDS9e?=
 =?us-ascii?Q?RIU59jflGEQ2GFahqGMCvhQFeACL1FAOIQFqvFpCGgjvhnuc8KuGZY0+BSp/?=
 =?us-ascii?Q?4R2idWRJJ0nVIFW3w+GXl43wRQiEHdPbeGJP+9tz5clP9dgd2N90G0Xa1zlg?=
 =?us-ascii?Q?JUuqHOr14eEjzn7bX64t09LyVUR62w/kF+dJSo5F2juK8VP65qBI7nrmsm1E?=
 =?us-ascii?Q?VllRpY/cRfQbJcNqw64oG40XPmAWLbwuAt5UMOio0rd7CfMRwxXD4Jpbocjw?=
 =?us-ascii?Q?BNIp1M9D09SbckosN4SerP/4HPgPJeLVAPi2sEvM7hmORy+dHggxqxrWLEI5?=
 =?us-ascii?Q?BsGDl6LpzLUp7Ug5nAD24qgLu/ZFBmqs/Rphzzq55/jm9opeLYejugNd14xz?=
 =?us-ascii?Q?eb51AcBrtxv6zgKyvCoEGIavW4L3Rp2mxWmvhR8zZySw/LW8uh/BjMQCkmLy?=
 =?us-ascii?Q?RHNZbfu89NhnhjLpl5MxxCuC91/2toQIT2I1zSYczA81WqwiY6h5PFgNiDE4?=
 =?us-ascii?Q?NRktwXuS8etO9FN1c7Pxi3zazvGO+3srM2F7e6ru3KJncfouPhBO94Y8jT/4?=
 =?us-ascii?Q?IbgLsUs8gZked4NgIxdbNgRFWnmTEfbI8+OQ3c0Jh1f/q/5tH+shWG0yxLoD?=
 =?us-ascii?Q?hanM3q6N8BeNoplEM6T+eczVEPHnbDjAE71Nfpo+Luh+zi3rpirDZ8rFQmtB?=
 =?us-ascii?Q?cEfOW7hedYjjDLngVtq1SNxxdJ7qxwnjj4uTA0kO6eAYtpob7kiaD0sUQ0U7?=
 =?us-ascii?Q?qVEHRlK0veJ0qE0XjbgpGzbLG42H8rgQh9afTytATxJiknRmSHWcJBswHqUQ?=
 =?us-ascii?Q?n5i7Ybsxwt8q2Yn1BVj1H4NCjUjCOb08kcRns7U/vhnZ/oNWLkChqSFcgU8Q?=
 =?us-ascii?Q?Omwkuo2QC7Xe/DjFnkZvVdQJRdMh5sLRW5i+yGyJutMWRg8+fIQsk9asidUQ?=
 =?us-ascii?Q?7efm+tVAaZ2TGs8+qXDLTtFRm1RnU2CCJafHKvE2BXqBso12/83do9Kf+Sqm?=
 =?us-ascii?Q?AXq20hzqvU5VzLcUtOyrlCW98w+vKnc86C3C6DpO7C0LZ2UwEaOLoJSmRO46?=
 =?us-ascii?Q?3aqFTBKsDN4KE3VYdgqN7midfBxcjmUYxmYx5CWxcTGopF420eS9dRQBJkjz?=
 =?us-ascii?Q?fBY8vHf2CTvH4ULNiAYXBKsXSK8laZIYYZAy8odTvXdHKNq9HwA88ruFRjhp?=
 =?us-ascii?Q?SviKwBGgzQwSvh5MVry36srLw3tCkrqCCZKrTDncXmOIfn9VmCNZq6S2e3/v?=
 =?us-ascii?Q?wU6OKst0zI6rE19wm0HmYg+OPR11hH9WoW/jN0U10PzEFOcCrCSZMnXg6+gb?=
 =?us-ascii?Q?DwFbLwBgKANaS3Uj7TD+dIoDetdSI6OlNMUF?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2025 23:57:13.4916
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb5ec418-ed13-4727-ab2a-08dd9730e070
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8498

From: Ashish Kalra <ashish.kalra@amd.com>

Ciphertext hiding needs to be enabled on SNP_INIT_EX.

Add new argument to sev_platform_init_args to allow KVM module to
specify during SNP initialization if CipherTextHiding feature is
to be enabled and the maximum ASID usable for an SEV-SNP guest
when CipherTextHiding feature is enabled.

Add new API interface to indicate if SEV-SNP CipherTextHiding
feature is supported by SEV firmware and additionally if
CipherTextHiding feature is enabled in the Platform BIOS.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 30 +++++++++++++++++++++++++++---
 include/linux/psp-sev.h      | 15 +++++++++++++--
 2 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index b642f1183b8b..185668477182 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1074,6 +1074,24 @@ static void snp_set_hsave_pa(void *arg)
 	wrmsrq(MSR_VM_HSAVE_PA, 0);
 }
 
+bool sev_is_snp_ciphertext_hiding_supported(void)
+{
+	struct psp_device *psp = psp_master;
+	struct sev_device *sev;
+
+	sev = psp->sev_data;
+
+	/*
+	 * Feature information indicates if CipherTextHiding feature is
+	 * supported by the SEV firmware and additionally platform status
+	 * indicates if CipherTextHiding feature is enabled in the
+	 * Platform BIOS.
+	 */
+	return ((sev->feat_info.ecx & SNP_CIPHER_TEXT_HIDING_SUPPORTED) &&
+	    sev->snp_plat_status.ciphertext_hiding_cap);
+}
+EXPORT_SYMBOL_GPL(sev_is_snp_ciphertext_hiding_supported);
+
 static int snp_get_platform_data(struct sev_user_data_status *status, int *error)
 {
 	struct sev_data_snp_feature_info snp_feat_info;
@@ -1167,7 +1185,7 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 	return 0;
 }
 
-static int __sev_snp_init_locked(int *error)
+static int __sev_snp_init_locked(int *error, unsigned int snp_max_snp_asid)
 {
 	struct psp_device *psp = psp_master;
 	struct sev_data_snp_init_ex data;
@@ -1228,6 +1246,12 @@ static int __sev_snp_init_locked(int *error)
 		}
 
 		memset(&data, 0, sizeof(data));
+
+		if (snp_max_snp_asid) {
+			data.ciphertext_hiding_en = 1;
+			data.max_snp_asid = snp_max_snp_asid;
+		}
+
 		data.init_rmp = 1;
 		data.list_paddr_en = 1;
 		data.list_paddr = __psp_pa(snp_range_list);
@@ -1412,7 +1436,7 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 	if (sev->state == SEV_STATE_INIT)
 		return 0;
 
-	rc = __sev_snp_init_locked(&args->error);
+	rc = __sev_snp_init_locked(&args->error, args->snp_max_snp_asid);
 	if (rc && rc != -ENODEV)
 		return rc;
 
@@ -1495,7 +1519,7 @@ static int snp_move_to_init_state(struct sev_issue_cmd *argp, bool *shutdown_req
 {
 	int error, rc;
 
-	rc = __sev_snp_init_locked(&error);
+	rc = __sev_snp_init_locked(&error, 0);
 	if (rc) {
 		argp->error = SEV_RET_INVALID_PLATFORM_STATE;
 		return rc;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 0149d4a6aceb..66fecd0c0f88 100644
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
@@ -798,10 +801,13 @@ struct sev_data_snp_shutdown_ex {
  * @probe: True if this is being called as part of CCP module probe, which
  *  will defer SEV_INIT/SEV_INIT_EX firmware initialization until needed
  *  unless psp_init_on_probe module param is set
+ *  @snp_max_snp_asid: maximum ASID usable for SEV-SNP guest if
+ *  CipherTextHiding feature is to be enabled
  */
 struct sev_platform_init_args {
 	int error;
 	bool probe;
+	unsigned int snp_max_snp_asid;
 };
 
 /**
@@ -841,6 +847,8 @@ struct snp_feature_info {
 	u32 edx;
 } __packed;
 
+#define SNP_CIPHER_TEXT_HIDING_SUPPORTED	BIT(3)
+
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
 /**
@@ -984,6 +992,7 @@ void *psp_copy_user_blob(u64 uaddr, u32 len);
 void *snp_alloc_firmware_page(gfp_t mask);
 void snp_free_firmware_page(void *addr);
 void sev_platform_shutdown(void);
+bool sev_is_snp_ciphertext_hiding_supported(void);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
@@ -1020,6 +1029,8 @@ static inline void snp_free_firmware_page(void *addr) { }
 
 static inline void sev_platform_shutdown(void) { }
 
+static inline bool sev_is_snp_ciphertext_hiding_supported(void) { return false; }
+
 #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
 
 #endif	/* __PSP_SEV_H__ */
-- 
2.34.1


