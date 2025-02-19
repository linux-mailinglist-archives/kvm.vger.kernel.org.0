Return-Path: <kvm+bounces-38601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CA52A3CA8D
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 21:58:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA4383BB008
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 20:55:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C08AE24E4AD;
	Wed, 19 Feb 2025 20:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="i7Nx6z1L"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2083.outbound.protection.outlook.com [40.107.212.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6183724E4C1;
	Wed, 19 Feb 2025 20:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739998464; cv=fail; b=fFd7oJLETlDUwYF6dUMG06Rbh5s0+MhE07pSIuY5ifERfHTccUvhrEiE6PsEmKfTjukxlNds3KHFBz9G08n6k3Yy1ixleHRDMYWwOcY82YM3BQ9yS/JUSMo6anKTihpOijlu8LNZRAipab0VEzMQ1gIhfYrIoKj7Oscy0NTLCsA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739998464; c=relaxed/simple;
	bh=WYbT+AmiVMWm+AA52NaWjchjIiFHSzSWd2SfK/Gm3XE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B7fD6WX1b68dKLUnLoRkape2hjmZZRwZyCD90m1rdn4H5HlhhYvi1UnYrwe64T1MG39beyXRC2MM6KsgHmb4R+A1TAewChsbtGNkC/5SHx+dZLWMXrgrSRxeR4u6rTlNpPfVWBZXewidU7t5Tf39GkHftFS9PMuK74fMKf0gqRc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=i7Nx6z1L; arc=fail smtp.client-ip=40.107.212.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W8+IGlVNy7Bn7z5WW960VUcLnoRGI/QvYt+Rk42AwVUodIAArQAdByLti/Q3v3IrEw+bNryXmcyEtFWwZiNg4LDU93AEetZw82Kl+J2jchJSzfcWruy8yBMNEwsR4Gk+bfopBzi03EB2/Q7x5Y5StkpQ1HkPX7WH4KnF9XamkLsOa4V4JEXbm7RvGKW3pvURVDF0x0csAXaIn1FYmlekc1fS5bfa7OdFnqO+Z2hW6pauaty+YPQXy0Z8u06W60CrJLFHfHowu8qTFGG5XIhvRpLzaFa6KmmJkXgApAGklwJEaBdDrUJ3IgRtrxJurUhQ1I13K6fVoI77ibs+crc1kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IMUIw1S6UVR5OnjgPGqc9W4MN21GsmtC7CkLMVx5oNM=;
 b=BG8vuS7tfFZEU/XMOaM2BaGNLXlp8OVUJnzvOCK2w/niq+gEs/jg+vd0olJFT8zfnj0OaFoCTw7qNKmBUNdP8AYSICkHI80S1kA1X2TRbAgq2sk1r8A4T/eu7vh2SaVpJDU5GV5DvCEc7NAkJgAGxHWDS7x1dcUNqHMb90NhlF+OVD1qvWHy7+lNWAErQZ2cCFYwW7QG+MVZNeBKDf9fRSf/r81W013NjwLhJmfTD7+BhCYTd37jErxaM2m/viIeto53IC1jnxsbIZQD1Ma+n6zLuHHw0fdqCsdOo+oVrhZosw6i3oR5EmUUaI7DUbNezlfhBPzpYYCNtdaWkXe8Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IMUIw1S6UVR5OnjgPGqc9W4MN21GsmtC7CkLMVx5oNM=;
 b=i7Nx6z1Lm78cHqiGdDhqsRJAP+Ox7XlMtilwAYpk7aXSWCJYFz0ACAenrwLRreC7rbwkRdUS5pFmeIVcVUy8xc1fmCsLoWTv+8VHUzmDcHzR/ILMVLgXShT03igmPNn9NRKMdNc4yH8ywuKvcME/sMVY/Wd099pQIdXzrcF6Hiw=
Received: from SA1PR04CA0013.namprd04.prod.outlook.com (2603:10b6:806:2ce::19)
 by SA1PR12MB7272.namprd12.prod.outlook.com (2603:10b6:806:2b6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Wed, 19 Feb
 2025 20:54:18 +0000
Received: from SA2PEPF00003F61.namprd04.prod.outlook.com
 (2603:10b6:806:2ce:cafe::16) by SA1PR04CA0013.outlook.office365.com
 (2603:10b6:806:2ce::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.15 via Frontend Transport; Wed,
 19 Feb 2025 20:54:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00003F61.mail.protection.outlook.com (10.167.248.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8466.11 via Frontend Transport; Wed, 19 Feb 2025 20:54:18 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 19 Feb
 2025 14:54:17 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v4 5/7] crypto: ccp: Add new SEV/SNP platform shutdown API
Date: Wed, 19 Feb 2025 20:54:08 +0000
Message-ID: <3751510d09c0811811e46e857942bf238aa52d05.1739997129.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1739997129.git.ashish.kalra@amd.com>
References: <cover.1739997129.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F61:EE_|SA1PR12MB7272:EE_
X-MS-Office365-Filtering-Correlation-Id: 67c8e487-482b-41ce-5753-08dd51279400
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eg5695M4nrQPlKk2vN5Jqxk9fSU2d778Yfo4s2wGcYTQsTPk+Rql7elcBpfS?=
 =?us-ascii?Q?+d7DhXvmw3AviRZScoCPLIN9FOg2uLNz+wPrrtvzVa/xZCoykGr4WpRTC9X2?=
 =?us-ascii?Q?trK53aHdpAm9XfOtUG3fue5jnS8mhMs175SZJmDSXnz9eVyNEwcrg8sQQDDA?=
 =?us-ascii?Q?Ns+tl1vPRdPl9AqO9jjA+w071oPLJcp3nDxZXSW0DaMlHH8DePJ43RbqUUnj?=
 =?us-ascii?Q?CNhcGiPN6oIQj0TRsQMCC5Y4TGSPVYseIu3GRuzL7bX6aqTUzLhN4hMuTTLv?=
 =?us-ascii?Q?GFwaEGfYDS18JrJqI/fhAUJlmqLqhaRU4gaioeE2kjuptf9hHN1nzmc4OqF1?=
 =?us-ascii?Q?PXaOkvUi7zWEVAPD6VG7/xfhwscr/7q2V0oQXkJSR0wwasSrKi0KkqRq0ZUZ?=
 =?us-ascii?Q?XPqjwYAT4D9wbR1031P699ufKLSDgdS/6OdSf5bWAFdI0kvH4gNyNKRj+Bpx?=
 =?us-ascii?Q?yROQ/lRVk4vWcnxwaymGB1rb4A0mT5+Z/23MnQgZN9n/h5c3z1ffJxsMdJ9v?=
 =?us-ascii?Q?k1J1nhaW9aDy+xeiPadhcKdnagZZjShSitk0UNNKmqpO6/zeCGKCfcJR8Sek?=
 =?us-ascii?Q?x28YjryhlF3sUYDQEDcTRZe3qbRhhd6M/vWzQyqFPVyYwvnJYs9iaE6zvRen?=
 =?us-ascii?Q?BcNUyLYW0WUx/xJKfbP6EQTChG9kjBI9oXzoqcNGPNGVFMWnRQrTSPC2TPef?=
 =?us-ascii?Q?wQOXoaQ1d7v6WHkAdOwPh10W0XdgH69cqDdNCGZJBYGhomiPGZH31LVfSsKV?=
 =?us-ascii?Q?IRl1hZXj3zTHrOEPR3O431jRIdWDcDKM+ZZb9HOqoqNDFJD3Ib0EUzMvxazG?=
 =?us-ascii?Q?1qCbfXk/C38my9pEIC3/9AopOjT75HCvlkcgldbBQTdUlqPYM+EgLtraMTjj?=
 =?us-ascii?Q?6DcwiN7MIf1pN2WyO2h7QG1GLk75LBFF5Jpt8HNB69yMyftxVhrTlioPyejj?=
 =?us-ascii?Q?J7h/k2dX8scFM5rYvbWzSy8Afk2v9UyHWefWsGq91wRLH3qe/qj3CkWHNyw1?=
 =?us-ascii?Q?VxDyLkyLah3XJFGJWAlUs+LF7q1jXFMFq0dSk7Tgc0v0xiR+Msx77O+4y9I6?=
 =?us-ascii?Q?ay7ObqtJAWcoLPw3aQiRyg9CWK5SBWqWuV5cR3CNH7E59HW5StAXXZZiCMtG?=
 =?us-ascii?Q?UU0x5dLBlgG9pMc8NkgmMJszRtqZib7S+Bzr/5WbHFtf9+3lOidCLhcGxd7j?=
 =?us-ascii?Q?u3zXwi1FJXDEniaey0KoiguafTubNd+EFVazLyl55UuOo2ll4QIqQK51T32C?=
 =?us-ascii?Q?x3Ck5ka6QvGE150oGBRu+I5T3ZCJM9IF9yWB4sV52zfN9vnHn8qU57i22ORC?=
 =?us-ascii?Q?3xh530V/ES4vw7LeFGZo1EQcFWH64cesCnzS/YiHnlw61qcp5onVRJUKelR4?=
 =?us-ascii?Q?PRzMDag8l8EMVLYWtCjrkmGdI9Lbko+p2mL+3rYChSgNJbk8ONT6pwKrzj+L?=
 =?us-ascii?Q?wHqovVAZcc7R1/XsLrNY/+KLMVeXJ7RPguRkEURcvVxf2olARkON3QN1CaRO?=
 =?us-ascii?Q?AbiszpGKvm1VVeZCQ/ms9cf1XYrgOj9pm21G?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 20:54:18.4321
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67c8e487-482b-41ce-5753-08dd51279400
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F61.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7272

From: Ashish Kalra <ashish.kalra@amd.com>

Add new API interface to do SEV/SNP platform shutdown when KVM module
is unloaded.

Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 13 +++++++++++++
 include/linux/psp-sev.h      |  3 +++
 2 files changed, 16 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 582304638319..f0f3e6d29200 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2445,6 +2445,19 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 	mutex_unlock(&sev_cmd_mutex);
 }
 
+void sev_platform_shutdown(void)
+{
+	struct sev_device *sev;
+
+	if (!psp_master || !psp_master->sev_data)
+		return;
+
+	sev = psp_master->sev_data;
+
+	sev_firmware_shutdown(sev);
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


