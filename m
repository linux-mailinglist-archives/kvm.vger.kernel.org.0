Return-Path: <kvm+bounces-52988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0BE7B0C600
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 16:15:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50BF2542B70
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 14:14:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BE522DE6EF;
	Mon, 21 Jul 2025 14:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Kvbmge+u"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2085.outbound.protection.outlook.com [40.107.244.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6B32D978C;
	Mon, 21 Jul 2025 14:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753107227; cv=fail; b=Ed1kjdzYRyn5aA3ofYOiW2dhZDcEa4RllYkcVVK+dCoD7/i1wfFjEUCexOgA40Jn70D28/zIQhELXW+2kiojSkgYtEKg/ZrLvUEYuJBE6p+5oVdNKCaJT01aVF5esCC030Q6qZ1vBDIk+NAzL7d2Tk4DDRXwx3Xx2jo1dW1YteA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753107227; c=relaxed/simple;
	bh=6qKC5XRosvDla47roso0rg0vJzPhxvy5UXStsubDMOw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jt9YRkVRy/VELHQfs+pXXGAsqTr86wDWv+ICHnFpmPpVhylrKcyuSVUWfsIBxJiZrn674s+hhf5q7e///lUJRb/4uS4ZLGzRNdbtjW18gbHqb2fEYFEc1FCzOzUq3R6byuLlEXdSOc05raWhgEwiL2dv9l1b2HICopQ392alPnc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Kvbmge+u; arc=fail smtp.client-ip=40.107.244.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jUs9BJqaeMg3lA/qjE5piJ4TEVclTsqxQcSm18mT8UpFjF8KM/3MeHUk2+HbpMx+lIu1tOasfxMvZv1i1pqcKEzRMM9k6QSBDCDlWI3Ui8x6Nn/HVeuvP9fl+zwuPvfMwsmMXRvgNRFirbwws8aeVhe9bhKyik5Qb32Syf2midbrKyb/ajSE89/6R9fI4CUQSkXpisXgGy4CvZpaHwoJuWfflNiPgls3sj7HbUhTivC1/YwApiRadREhlb14Hr807IBZ2fvkPrvM8T0jWFnVCK3+aC68PK9JzbVm8UBQAqryEAV4G9T9h0zCo9ZSILmvp+AfZ8gwko1DAhI6J3GgHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ULdVy4Kkb7zAYDklVN0MTzXTgxHnJxSLPnEezxOS248=;
 b=D+SpwvpXqnLBvd6LFVXKhZi0/VQ+fo/lJWSRBdHuesNJZ13e2K4JEtCVefO3RC6pgcWZ0EzLDt7TPXYL08zpHPQNEXwjhsNkLOK4uGDENk1tjbLWfBA6P9MA8a9qj83ep8+8W3PdUxA8YItMWY9apJPpiAowqjaM4kxDoOpK73891COFO8ij9wX4CYBtR/Z4T53J2d+S4wRJJOXqb4+j7DCvfdgwBSvRYswkoPGzRz9zDxIrL3+TnirqE3fyUFiXl9Bp1SQ2EgOmehEhiEmnnwyqOS+T23OSMBwTcyQ2sen7jjtzI9zjud7AE9YtzcZYb63FRFCpwuIr5XDE1KHPYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ULdVy4Kkb7zAYDklVN0MTzXTgxHnJxSLPnEezxOS248=;
 b=Kvbmge+u6RLwL/s+8/ChqIh97NQQb7mwRsmkr7o3ypDcr+11x6NUl7LSLKHbOJyIXupNGcFFc5IFHqk8IFA9K7pkh3YE/Ac65L068bor+6KhBVfdLmD3uE1O+K3eR2FCIeWqn63XLLzSBN4WlNgF9EthE1IaybRyAOH1uLuIqhs=
Received: from SJ0PR05CA0167.namprd05.prod.outlook.com (2603:10b6:a03:339::22)
 by MW4PR12MB6753.namprd12.prod.outlook.com (2603:10b6:303:1ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.28; Mon, 21 Jul
 2025 14:13:41 +0000
Received: from MWH0EPF000A6732.namprd04.prod.outlook.com
 (2603:10b6:a03:339:cafe::d4) by SJ0PR05CA0167.outlook.office365.com
 (2603:10b6:a03:339::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.21 via Frontend Transport; Mon,
 21 Jul 2025 14:13:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6732.mail.protection.outlook.com (10.167.249.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8964.20 via Frontend Transport; Mon, 21 Jul 2025 14:13:41 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Jul
 2025 09:13:38 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <corbet@lwn.net>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<akpm@linux-foundation.org>, <rostedt@goodmis.org>, <paulmck@kernel.org>
CC: <nikunj@amd.com>, <Neeraj.Upadhyay@amd.com>, <aik@amd.com>,
	<ardb@kernel.org>, <michael.roth@amd.com>, <arnd@arndb.de>,
	<linux-doc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH v7 4/7] crypto: ccp - Introduce new API interface to indicate SEV-SNP Ciphertext hiding feature
Date: Mon, 21 Jul 2025 14:13:27 +0000
Message-ID: <1a05e1d67b0f4e94f89da200b709b9c2ca321806.1752869333.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1752869333.git.ashish.kalra@amd.com>
References: <cover.1752869333.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6732:EE_|MW4PR12MB6753:EE_
X-MS-Office365-Filtering-Correlation-Id: c78c2737-6bb0-43be-ebf2-08ddc860cb76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/mCNFiQsznaLvgq9kOkuaQNX2iVEgsC8fjfBDamACS9rER0jsTu6GU/FbA1R?=
 =?us-ascii?Q?pldu4devYETzIWXGZbpW1jGvRewneR+cyxvzOYEKEMsGLCKo9XxJ+EyS7tB1?=
 =?us-ascii?Q?APZWERC9oDMi6vYyOoAVvdN/diSKBVZBvlf0MeXFMZFPNltEDnsoobfGqmS+?=
 =?us-ascii?Q?o79o+zaeECKC2sYuaJYefFbVwOIfW1oD7vGn+JQREoJJLhjPPboUKfrg3Tzv?=
 =?us-ascii?Q?aaZbjKqqkGGcwj/wD5RuYZTuKtQ5FDKMB/E8P37MLUjmXghACiDaX+mRUn12?=
 =?us-ascii?Q?0FqLpGsFvZNJK9l2VxgPo2oJdSzHRq3yYlXKYR+sb3hkHjyeMrLxwmid0Y8C?=
 =?us-ascii?Q?XEGBEJCizXSsWZENH1uSsu0/cTMlrX4IH+DlPpHpN4RrbzX79Pu5FV99QiZb?=
 =?us-ascii?Q?Aw+2BDtSCKi5eTlHiep2EJVKIIrOconZps81qEjdDdGbGrRYGK19hjzULH6B?=
 =?us-ascii?Q?T9o3FBgsQxE571Z650W0L5sNqznhXecXKAg9NqQ1lJLctVnjza0PPeyiPjsd?=
 =?us-ascii?Q?o0VopoEqyyB705U0yIFBvaqH6Xul7SGUxrQ9t4jsKcCPixcMiQwuVYKRbIiY?=
 =?us-ascii?Q?6OnciqXe5jwbMNMUp9g5bwT8HRxF5TrrmlAjQgXYpeDPvWRtmJ1rzh0NWBtX?=
 =?us-ascii?Q?Xme9EDQ84LlRED3XfKLjeMVSatyw0qxdLdUJvjf04QIk1DUUzx+9jebELcjZ?=
 =?us-ascii?Q?mEIUIydZrThVvTJSSi6dE8IPKsMFgLNNPCLG5mx30YBHfdeQdNP7GwYJfOFv?=
 =?us-ascii?Q?cMZQ8DBTX46kvhFAKvNTvK8rk4MY+jq5HiPc63a6Q+57JycGKxAjEUDUlF2i?=
 =?us-ascii?Q?VpLcQr64je5A3CMGES/XIsXfL2C7zJBRoNCzpXLk/HrpzOKnEwNpcPXqxZoT?=
 =?us-ascii?Q?xMCGiaGsO8xXX/aauvY5c3ofLiVYBfkCuS6hSZX7wrYfjnUeuggHk1xX8oQd?=
 =?us-ascii?Q?0BEqjsVfO8oO1j3CocuorxnsIq2g1wP4r4MLydcr1r1uMpGA1FXzuKlZqU19?=
 =?us-ascii?Q?0ZNp9N4jU9Gxr/pOK2RfZpXh+8Qk6j0b5VELi3fqUCkr0NUGvIj9yQeg9C7K?=
 =?us-ascii?Q?6USVJYvK5IKmYbCAfddHJXBieKOblKNyFhlXoF4FCWg/hh60khJXXpmyLbSu?=
 =?us-ascii?Q?NK5w8pZelLhZg5qh42g249GZSJi1+irCqmsqUHSYHIeATW7MaH7QrrVdgIeE?=
 =?us-ascii?Q?3nw7hxddMm7XdF4g0fpIltwX24wcVc05o/GzEXwPsAdDfX8BWGEAT2P825AJ?=
 =?us-ascii?Q?Jrt45spiR3jf/3kqr4W1ikDwswCbMSqCRCr3LXFoM7PVQHNgAzyOToVf82xs?=
 =?us-ascii?Q?uzwM1962GusjcGl0q0RgQfzk1QkZsfjugg3UNyVxwBkhnxUWmROiiCBVsvkT?=
 =?us-ascii?Q?38rqLG17vCGh2YyfRzmSN8Les+lbNMorK/5iwlgmnCVe0FzdbVf4b/UI8T7q?=
 =?us-ascii?Q?b0U6I4mAh93106dR+FTyPfgQwENQWQn9XJNSyz4uQJW/uudDRYwKtx/s1H87?=
 =?us-ascii?Q?cG8YHvVkpUhjfBOTheFMw/RvWVFhEFfdsyLDcE0zhNib9Syt/V7z3ua9+Q?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2025 14:13:41.1016
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c78c2737-6bb0-43be-ebf2-08ddc860cb76
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6732.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6753

From: Ashish Kalra <ashish.kalra@amd.com>

Implement an API that checks the overall feature support for SEV-SNP
ciphertext hiding.

This API verifies both the support of the SEV firmware for the feature
and its enablement in the platform's BIOS.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 21 +++++++++++++++++++++
 include/linux/psp-sev.h      |  5 +++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index a3941254d61f..58c9e040e9ac 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1074,6 +1074,27 @@ static void snp_set_hsave_pa(void *arg)
 	wrmsrq(MSR_VM_HSAVE_PA, 0);
 }
 
+bool sev_is_snp_ciphertext_hiding_supported(void)
+{
+	struct psp_device *psp = psp_master;
+	struct sev_device *sev;
+
+	if (!psp || !psp->sev_data)
+		return false;
+
+	sev = psp->sev_data;
+
+	/*
+	 * Feature information indicates if CipherTextHiding feature is
+	 * supported by the SEV firmware and additionally platform status
+	 * indicates if CipherTextHiding feature is enabled in the
+	 * Platform BIOS.
+	 */
+	return ((sev->snp_feat_info_0.ecx & SNP_CIPHER_TEXT_HIDING_SUPPORTED) &&
+		 sev->snp_plat_status.ciphertext_hiding_cap);
+}
+EXPORT_SYMBOL_GPL(sev_is_snp_ciphertext_hiding_supported);
+
 static int snp_get_platform_data(struct sev_device *sev, int *error)
 {
 	struct sev_data_snp_feature_info snp_feat_info;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 5fb6ae0f51cc..d83185b4268b 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -843,6 +843,8 @@ struct snp_feature_info {
 	u32 edx;
 } __packed;
 
+#define SNP_CIPHER_TEXT_HIDING_SUPPORTED	BIT(3)
+
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
 /**
@@ -986,6 +988,7 @@ void *psp_copy_user_blob(u64 uaddr, u32 len);
 void *snp_alloc_firmware_page(gfp_t mask);
 void snp_free_firmware_page(void *addr);
 void sev_platform_shutdown(void);
+bool sev_is_snp_ciphertext_hiding_supported(void);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
@@ -1022,6 +1025,8 @@ static inline void snp_free_firmware_page(void *addr) { }
 
 static inline void sev_platform_shutdown(void) { }
 
+static inline bool sev_is_snp_ciphertext_hiding_supported(void) { return false; }
+
 #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
 
 #endif	/* __PSP_SEV_H__ */
-- 
2.34.1


