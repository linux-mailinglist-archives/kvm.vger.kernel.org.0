Return-Path: <kvm+bounces-41865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EAACA6E57F
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 22:20:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 844581778F5
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 21:16:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7AC51EDA1E;
	Mon, 24 Mar 2025 21:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jWSIRkKz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517F61E7C0B;
	Mon, 24 Mar 2025 21:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742850933; cv=fail; b=IBvnqGOQp8KM2FPzbPM0G8gQ71lh6VSaM++ybJD0nRnLmuFjYsN12esSXPUvXFRLpb78Ecv9m4uGDMUJDZeZHh+rSYNHeF62CKjP8hDK+Y8ldxHxMc5dsb1mP4qCR5Qd1V5h5AWvb7LnfF93rMK3SgWZxCB8GqG5bbrwwDkhyGE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742850933; c=relaxed/simple;
	bh=D1h0iXoB6QY3u4U8OTYe6FPW+XQ8kRSQmpYXbv/yAfE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E5MU8eUfD6GzSEPMK0+qwLVWvQezTDCMELPhEP9+8ZYYGOejCjzKZ9TrYecHtnB1VHPafGbKa5jAhkyJIjfIVcrr5yYygOSNyEq2J+sTgipeEnT+jKQeTMHBg/clkNlNFEi9YYg9si7898tSNxOSXUoShfHi0HWO8HpkrgIX1FM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jWSIRkKz; arc=fail smtp.client-ip=40.107.244.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TIaOOocUG5VaQrHJ/O3i+7RNas59pvjcJbgzUYljdSSn3U9oL0NdZialR/db6N6wudUJp6MzjfdgjIhQ2WUZGFRfD60rKSrWmttM/vXvgJ4X+GQ47N+HbDTpB5PKJyGMfdIkdgSYpa54ZH613NvCFZau1JcoIhsaSlNjNzOHs0MyftvnwPC+Z3e9ICWWRUPPQus6yGaCGXkXEl8O68P3hlJ+MbPZ7aFWGN0ZV6zZg3uEs1Inf5vTIJRKn4mHQ/fnU9KShciN3L17EQ5epzW06pJogQWOL070SB9wvTVTK5OxjNuPMFRCWtY9BsOoavQ3EoQLuTaux/c5WDtiuwi3BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VK/ic4GADChmHiP2vA3I1ncWU2HoC068SbraXg09fPM=;
 b=Rr78EZu8OBl52VtmgTvDE5NSqAcQ33J/dZ0U3j979Lc8mhIdv/U0QT7ZkTl/EH4v79ZzYKguzobd6L/eSlT5koZLLtRfDgAWPvOsWuzyt22SJs+ZlHmJG0KqpGQZafstLSnKGgrFau7PR6pgvLo1DcmcYorq48pNxC9ELnWzay3C6OaneQxExacsw9bKovXhu6kzuB0bCrl0KplEORyUwoEtPRYD7Mwk2jY0EarUKUb38cE9p5UkhxmHkXk17lhGgTYNsw1RePea9nQPphFhDxFC8ZYwoLPNgV4nJBsiV0nPe1Bxb0Iaf1R+89IBna0aCamI/6o/RFp0TiqdCgmNKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VK/ic4GADChmHiP2vA3I1ncWU2HoC068SbraXg09fPM=;
 b=jWSIRkKzoJdRTeFc8LzmjC7bjtmhL9i6XRfLBDB+iowXK8PyGZx2YLjrhyZajT3cn17JVHa4XJuTNvimvIN4Lq6LeiMkNsctVP7HAEmC6/mFz+xvGmWUXW+EDhyjG3zIvhMxYfUbeWXy/hjIa7fNUzTS92h3uQitlscp3SZ/fT0=
Received: from BYAPR07CA0023.namprd07.prod.outlook.com (2603:10b6:a02:bc::36)
 by SJ2PR12MB8011.namprd12.prod.outlook.com (2603:10b6:a03:4c8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Mon, 24 Mar
 2025 21:15:27 +0000
Received: from SJ1PEPF00001CE3.namprd05.prod.outlook.com
 (2603:10b6:a02:bc:cafe::1d) by BYAPR07CA0023.outlook.office365.com
 (2603:10b6:a02:bc::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.42 via Frontend Transport; Mon,
 24 Mar 2025 21:15:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE3.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Mon, 24 Mar 2025 21:15:27 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 24 Mar
 2025 16:15:25 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v7 6/8] crypto: ccp: Add new SEV/SNP platform shutdown API
Date: Mon, 24 Mar 2025 21:15:17 +0000
Message-ID: <cb2c5dd490b3736a58058124d73b0ff53b94ee47.1742850400.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1742850400.git.ashish.kalra@amd.com>
References: <cover.1742850400.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE3:EE_|SJ2PR12MB8011:EE_
X-MS-Office365-Filtering-Correlation-Id: a160c21f-6ac4-411a-be4b-08dd6b18ffde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+UFyK8U5xyrASMyO/8yT7mxCj+EmptKaIxfk2GXfNGp+jb/FUnKclOEq3yrU?=
 =?us-ascii?Q?xgSqdk3udTAAsVHcNYvSnsPWRs1ATjyx135pZdPjB92pmhBWJmBaLGNlghn3?=
 =?us-ascii?Q?1GuAoz1QxmZeDG09eI31aPJ3DMt7l+fJjl5s48zgNzB0f6xOwcqdWM1DG7+s?=
 =?us-ascii?Q?dzyVsgPc3jscLCW29xGuHMCBXVCGa0tSA005TY1aJGjCjxHwTirvSp8j8h3S?=
 =?us-ascii?Q?M8SQFeVd9/12L8KG7oi1cM+FzAZI7fp/Ec5JNgjvtb4FV7XwsWrg9SOa5aqY?=
 =?us-ascii?Q?MhBwjfTp6NPQTtmoZobgwKS1KDPJa2AOUD71nWB7FuGN+0/AXokqZVFin4+t?=
 =?us-ascii?Q?pNVZUQSz5vhF9r92NQWVN2p/7LmDfbpfZfV0zKPRFjLL7u6jJbUuqH5KU6kg?=
 =?us-ascii?Q?3z+On0gmWpRHOrqnv5kqRus6V9g/5CwygB1dadOYDjo1zjtgTKwDwh1/Kljv?=
 =?us-ascii?Q?pCExJ0jOKkMj7ZCv9tQhBWAFCMS4yEWxVnPPgwrcH/bnFjDeMVT9fSkCQere?=
 =?us-ascii?Q?cDEF6qfgcLtACSgEy05NPHXvb7kbz+xv1+OvQnOoLfeLlNi4Vr3xDicjs43W?=
 =?us-ascii?Q?jyR0ZQSaYN6XLvvnVYcfyzBtsXR4xwsCzTk2JB8R408e0P2kpe4MKf7ywBrD?=
 =?us-ascii?Q?BTdjxG0p/5W776UJ07nufW6/885Iv6yqX7jcYxZP5J0bN/B1lxqeTk5sQcnO?=
 =?us-ascii?Q?Ml3cT4jGjU4+kG8PiMBETDuFTGm5q8NxFdJ9XqprIteh87Pcim5NDt/WHTY8?=
 =?us-ascii?Q?uFxI2M4q8Gr8Q3Fa1nDJb8/F6dpmAujSRqY1+xxxu6oFBAs21zcFr5oS3TcS?=
 =?us-ascii?Q?VWBMpbDUIZNL1d9Dq5wFehXHZZpgXGhvG2lukapRyvmyh0ekxTYWvYjptPH9?=
 =?us-ascii?Q?X2Uc0IOuiG+OjhYSK4hKp7iUCMjeNAloMlnHZ+yGr36a8JsBxPbdyEBQWDIV?=
 =?us-ascii?Q?Uq/TEjw88tro9mG7ErSuAQYLwXQ6OCnpC8Mh9wBvUEvSqjTluuj5CMt6FQ1s?=
 =?us-ascii?Q?9DnXiSeg270uCCPiZW9vIaEeK8YxezX1pWzyeV0TaePE7R1+AOvgSfuWkwlP?=
 =?us-ascii?Q?e6mBu3gd515DGonQFaIHszXyChCaBLAkmYxQesdzVQ1S4vo14pnsNeeTno1J?=
 =?us-ascii?Q?w1SzcT6gGeyKOlHUO6bQYIaPpiaUkiRMInxiUVoO/k3jmYlpwjumrZiI/CBW?=
 =?us-ascii?Q?zsOzLRUJD9u/F0DSMSEfNiWZ7s5ADx+VmChcg0pWsWici56oIx7nPHWU7RgU?=
 =?us-ascii?Q?U9Jx7L7Ttd9xv4wHiyzq3QccOCTkMCMSzOlPTkdN8lewIT9GQJBqjSRqvNmn?=
 =?us-ascii?Q?rKQAn4hoY8x7gu83A+uTZPR3mbQBk/fa0c9ASb1sv4EQStQMoSAdwfoWHS6h?=
 =?us-ascii?Q?aQCUkGQqhhawf+BkpQpXJdQ6kL0pjw7SXmXs7XnZAuzBDH8z7FCZxtZ9X0Mp?=
 =?us-ascii?Q?NBqVbPNff46sWtfj3Wb970xqVfS3/SgS50K29+cQkjBLF4ZdDyQZY7P058/x?=
 =?us-ascii?Q?enfFxA0ljJAjDDPNtQMycJo7kNp/Xlpo9e/r?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2025 21:15:27.1403
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a160c21f-6ac4-411a-be4b-08dd6b18ffde
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8011

From: Ashish Kalra <ashish.kalra@amd.com>

Add new API interface to do SEV/SNP platform shutdown when KVM module
is unloaded.

Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 9 +++++++++
 include/linux/psp-sev.h      | 3 +++
 2 files changed, 12 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 6fdbb3bf44b5..671347702ae7 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2468,6 +2468,15 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 	mutex_unlock(&sev_cmd_mutex);
 }
 
+void sev_platform_shutdown(void)
+{
+	if (!psp_master || !psp_master->sev_data)
+		return;
+
+	sev_firmware_shutdown(psp_master->sev_data);
+}
+EXPORT_SYMBOL_GPL(sev_platform_shutdown);
+
 void sev_dev_destroy(struct psp_device *psp)
 {
 	struct sev_device *sev = psp->sev_data;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index f3cad182d4ef..0b3a36bdaa90 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -954,6 +954,7 @@ int sev_do_cmd(int cmd, void *data, int *psp_ret);
 void *psp_copy_user_blob(u64 uaddr, u32 len);
 void *snp_alloc_firmware_page(gfp_t mask);
 void snp_free_firmware_page(void *addr);
+void sev_platform_shutdown(void);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
@@ -988,6 +989,8 @@ static inline void *snp_alloc_firmware_page(gfp_t mask)
 
 static inline void snp_free_firmware_page(void *addr) { }
 
+static inline void sev_platform_shutdown(void) { }
+
 #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
 
 #endif	/* __PSP_SEV_H__ */
-- 
2.34.1


