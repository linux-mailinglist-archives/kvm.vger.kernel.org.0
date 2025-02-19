Return-Path: <kvm+bounces-38597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 66311A3CA70
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 21:55:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 560BF1779F8
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 20:53:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 419E824F599;
	Wed, 19 Feb 2025 20:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wSTxUCPK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2074.outbound.protection.outlook.com [40.107.101.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D096924E4A9;
	Wed, 19 Feb 2025 20:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739998382; cv=fail; b=mAQwC/o8vdOcASECqzKg9DzFAiytUffZpvDPC4BEr7msfww+9jKaW1aR0RJmqfG3tw9/RrP4TWUghnYcYJ5J23x6BZD6rdaQxhqC0slUUsUKnw8imEr18TogsrBvyjXU22FFI42xbPe1weIK5q2CXF9Z/LIX3eSp6wMKMxYRjQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739998382; c=relaxed/simple;
	bh=BZvOrQJ+p5meUoHw7nyJSop/ykr7RF8M79/J1HoAzcw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l+hZ+vr72eOFtSgBSffuiL7oB8tZD7p3lSwzC5jAK73mWs4Zmkhkbz+C5ZoEUOgZQOjv6X9RdmEMZ6vwuAMgXyG6mUnB09G1gmUsOAFfw5/WLATwwUtqQV/d2dAA/+8WIi+7VjjcG6MF1XEyed0CxJB+ceY+67ighsNRI0xxtOo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wSTxUCPK; arc=fail smtp.client-ip=40.107.101.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cYDCim+G442Be/olPgWGV3BtXuoDkx0sOIk7KrpGs16588MFomI5l/+e7/ZsLjtjjTWkg6f7UHN5eriF0uuwqZEqyctWjmVmfekYOX6Ob3c5eoKVx9I4cNhBDPzny/Yq9P86RP/6u4eA5HGly8o1U4vqhmJ7UCc6RecOI7mJBzd4scf1q3DfZrDBCbQmNkPibrNlNvccTR9COsLHThQHDGpTuIZ+Wq41/eeuOkTP/UgdiBH/PYHewNjutOk2F+xIIYnzHD8xv+gbZE1B7gLFM2RCXxKcEXli+o6c6tsiTRnWzGEAjhUrKgeRvjfeW+qPWdt+lgaNr1olZcvYLpYoOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CyUBinyGvr/+nkXZUn9bohRCyqfJeEPSA0fa2wsfugY=;
 b=hzVXPuAEypVxllbdMMl1tjRokGvoCzgV+q7HH6FEN2QyZJ+P9zGEn9TNdpix3r/OufT4WbciauPFyMlklmVWvJO1hmwwrgEoSM6+aw5Fe9vMMS4Y4FLB/qowTkPTx/iVMzlLX91TiViSGQwYGWgOrp/EDGMlMqk/F5cDoOnhXAWoowAxLfsyKQEvoRWb/hEw5AtCbHAoQB4T1a5uy2hP1qAKpt0dM9O+op9LjgCroZNt5Iv1a1baLVE3HCdWszQCSMqV89JHvmuDYr7/lt972Ii1BmHWqx82st1yrRbh+gOrzS7+ftLP2kIAh3HIrCKBt5ddLc0hzKG/J25jbo7bgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CyUBinyGvr/+nkXZUn9bohRCyqfJeEPSA0fa2wsfugY=;
 b=wSTxUCPK6+vuiFjktX0kqJVSZbJgnH8DbMUk2G3M7lgkOiu2q55HoP2hHRPSC0oiTtkVGj80+dlDRwepHjdng1iiyFkBTb7FTkkcJgJrLeZkMy0ojwkrpvKhShmT73zPoLeod61Daivf66gnBQgzv9x86oF2UcacMQ9ELKbQUYY=
Received: from SN6PR2101CA0003.namprd21.prod.outlook.com
 (2603:10b6:805:106::13) by MW4PR12MB6729.namprd12.prod.outlook.com
 (2603:10b6:303:1ed::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Wed, 19 Feb
 2025 20:52:57 +0000
Received: from SA2PEPF00003F67.namprd04.prod.outlook.com
 (2603:10b6:805:106:cafe::49) by SN6PR2101CA0003.outlook.office365.com
 (2603:10b6:805:106::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.3 via Frontend Transport; Wed,
 19 Feb 2025 20:52:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00003F67.mail.protection.outlook.com (10.167.248.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8466.11 via Frontend Transport; Wed, 19 Feb 2025 20:52:56 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 19 Feb
 2025 14:52:55 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v4 1/7] crypto: ccp: Move dev_info/err messages for SEV/SNP init and shutdown
Date: Wed, 19 Feb 2025 20:52:46 +0000
Message-ID: <5fe0faa1070d5225c19e3df207825d0e337ee3b9.1739997129.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F67:EE_|MW4PR12MB6729:EE_
X-MS-Office365-Filtering-Correlation-Id: 09450bd4-950d-4e11-1b9f-08dd51276355
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|36860700013|376014|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CrD0OfFNxDbdBKc1kRJNCvuJ/eStBhZ1s8a/2g0JW5acLOaQi40ZYEMWZGUO?=
 =?us-ascii?Q?Nd0WP8qj48DRleX3n1Htby1TNwNTyh8k5+8waCxjUlNHhRjSbOKnHkRtNP/x?=
 =?us-ascii?Q?RUHnsUkqs7ivz626kWMiI+o1PE2zRu+7uIWQz9yvRIlftI8SIGvsQvYwkdoW?=
 =?us-ascii?Q?eEUCkuGkFcZW/NWVfTzUBLVgRE04RYfvihjOYFu6UvD7ZUXO8ZUZSASY2z8b?=
 =?us-ascii?Q?mSbb4+ksIZyDcKgYv8nfnYbmpCch1/0A/+DbwR/f3K0o4H4duLaHCdv629eH?=
 =?us-ascii?Q?NpZZee7qbpn+X/HZSLNyGBLJY/JSfPWFHlW8I9QUIxFXWVEp7GpA0Em6DrlU?=
 =?us-ascii?Q?GZ3c39d5qNxNRGplSqWPsD2xAGk9rKgkiL+lqXqcP/e9+KmaffT3g5qFF9O+?=
 =?us-ascii?Q?rMZ7ZerAcrCepKky04C7Zp5ZVyb3DcacdjWnMtVEL+Go69gq4WI67VwBoBeB?=
 =?us-ascii?Q?c3Hcm81mLtOTDx/9YHleRFuohu6Lwtnw8OW/057XrROWL6uRd6HbDu9zy/wr?=
 =?us-ascii?Q?Z0ye6rCHQcqApTfrBb8ewZzYhZmkY9MZyZworVnNEIyEHb2N/fbUvEJrTNy6?=
 =?us-ascii?Q?T0PDYQpVBJH8Ez95YmyTiper1yuKUO15xzJyrRUZqWr5LhHCLAqYtgi++3iH?=
 =?us-ascii?Q?0qU4GPTN6otoHmqZ4AYcjdQU1RvRsLpM5OF9b5OR/Mkm5kUy74Nio/BuCCOW?=
 =?us-ascii?Q?kROkhAXFkgoCAdDRhUZ1z3d1QxYEOC4hEkVQJq5z+s2UCurhX9VhYuXat3fW?=
 =?us-ascii?Q?jxoKHd1DYsUMi9QwA8lIkE7rI0EJ+hE7qmcRzZjM07W6RQq0UiylVh+zEM4L?=
 =?us-ascii?Q?dxTyHEdSHsDDpo/gWsZ9bj6huu06FyA1cd1V8vvV4S/plKrWxXJUdy+EGJFJ?=
 =?us-ascii?Q?AlyzS0sxkn+UDVcCKXHzMYJ8zJfz5WetWhwD3pHG52i3+Nzzq3EvgyikcMJw?=
 =?us-ascii?Q?Wc8nP7pvO5zg6V4UO/V4VJc7cjPDiB2JfDSutQL1vf5IqdWVADR43jG3b45A?=
 =?us-ascii?Q?oPg8h+ryFN28tLvQl9UdtD5Yoo6THs1hNbXcGX8QFzzZW7uTMpRGdWX1sMBw?=
 =?us-ascii?Q?O9t+LUUySowyX7MasasDIzdnwrYuDaIy4+0cKv+AAzJhZfRC04tqn89YogTH?=
 =?us-ascii?Q?PMBdhQ6Gd17FhC9w5BG6gcac6JnxFxXQZ35FPWrkb2UgemCHG/XucqtSldwO?=
 =?us-ascii?Q?4TKBRzpTMpI9QWFN/MCrQ2ClXpLJCB40z7x+V6IlsyiEF/Q05a1uTykyQ06S?=
 =?us-ascii?Q?PN9WSBiEf/LXLLNPmDm9yW8JcSs9n0QRht07vPrqrc4WOpE8d4EfTQK3DrQS?=
 =?us-ascii?Q?GrrX8zrpq47/pkKVg/oItojn69lHhApyDVtg/tPEYQROjlpaBLA5nVZQhtda?=
 =?us-ascii?Q?Tmqbq1wFzI7HYHhuXzZ6muvUt3tpnzRvCmEk0mygNSKwgijiiQw8TtLHaAbD?=
 =?us-ascii?Q?ECsYAqwbMLjTW4UlDok4bJXCsqP8GjP6445vd6YREVSJwgHViWm7mP9sI6Fw?=
 =?us-ascii?Q?p52BDR4WJN+afgUp/v8vHIG/CuHRLXxe2eWK?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(36860700013)(376014)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 20:52:56.7637
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09450bd4-950d-4e11-1b9f-08dd51276355
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F67.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6729

From: Ashish Kalra <ashish.kalra@amd.com>

Move dev_info and dev_err messages related to SEV/SNP initialization
and shutdown into __sev_platform_init_locked(), __sev_snp_init_locked()
and __sev_platform_shutdown_locked(), __sev_snp_shutdown_locked() so
that they don't need to be issued from callers.

This allows both _sev_platform_init_locked() and various SEV/SNP ioctls
to call __sev_platform_init_locked(), __sev_snp_init_locked() and
__sev_platform_shutdown_locked(), __sev_snp_shutdown_locked() for
implicit SEV/SNP initialization and shutdown without additionally
printing any errors/success messages.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 39 +++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 2e87ca0e292a..8f5c474b9d1c 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1176,21 +1176,30 @@ static int __sev_snp_init_locked(int *error)
 	wbinvd_on_all_cpus();
 
 	rc = __sev_do_cmd_locked(cmd, arg, error);
-	if (rc)
+	if (rc) {
+		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
+			rc, *error);
 		return rc;
+	}
 
 	/* Prepare for first SNP guest launch after INIT. */
 	wbinvd_on_all_cpus();
 	rc = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, error);
-	if (rc)
+	if (rc) {
+		dev_err(sev->dev, "SEV-SNP: SNP_DF_FLUSH failed rc %d, error %#x\n",
+			rc, *error);
 		return rc;
+	}
 
 	sev->snp_initialized = true;
 	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
 
+	dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major,
+		 sev->api_minor, sev->build);
+
 	sev_es_tmr_size = SNP_TMR_SIZE;
 
-	return rc;
+	return 0;
 }
 
 static void __sev_platform_init_handle_tmr(struct sev_device *sev)
@@ -1267,8 +1276,10 @@ static int __sev_platform_init_locked(int *error)
 	__sev_platform_init_handle_tmr(sev);
 
 	rc = __sev_platform_init_handle_init_ex_path(sev);
-	if (rc)
+	if (rc) {
+		dev_err(sev->dev, "SEV: handle_init_ex_path failed, rc %d\n", rc);
 		return rc;
+	}
 
 	rc = __sev_do_init_locked(&psp_ret);
 	if (rc && psp_ret == SEV_RET_SECURE_DATA_INVALID) {
@@ -1287,16 +1298,22 @@ static int __sev_platform_init_locked(int *error)
 	if (error)
 		*error = psp_ret;
 
-	if (rc)
+	if (rc) {
+		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
+			psp_ret, rc);
 		return rc;
+	}
 
 	sev->state = SEV_STATE_INIT;
 
 	/* Prepare for first SEV guest launch after INIT */
 	wbinvd_on_all_cpus();
 	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, error);
-	if (rc)
+	if (rc) {
+		dev_err(sev->dev, "SEV: DF_FLUSH failed %#x, rc %d\n",
+			*error, rc);
 		return rc;
+	}
 
 	dev_dbg(sev->dev, "SEV firmware initialized\n");
 
@@ -1367,8 +1384,11 @@ static int __sev_platform_shutdown_locked(int *error)
 		return 0;
 
 	ret = __sev_do_cmd_locked(SEV_CMD_SHUTDOWN, NULL, error);
-	if (ret)
+	if (ret) {
+		dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
+			*error, ret);
 		return ret;
+	}
 
 	sev->state = SEV_STATE_UNINIT;
 	dev_dbg(sev->dev, "SEV firmware shutdown\n");
@@ -1684,7 +1704,7 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	if (*error == SEV_RET_DFFLUSH_REQUIRED) {
 		ret = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, NULL);
 		if (ret) {
-			dev_err(sev->dev, "SEV-SNP DF_FLUSH failed\n");
+			dev_err(sev->dev, "SEV-SNP DF_FLUSH failed, ret = %d\n", ret);
 			return ret;
 		}
 		/* reissue the shutdown command */
@@ -1692,7 +1712,8 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 					  error);
 	}
 	if (ret) {
-		dev_err(sev->dev, "SEV-SNP firmware shutdown failed\n");
+		dev_err(sev->dev, "SEV-SNP firmware shutdown failed, rc %d, error %#x\n",
+			ret, *error);
 		return ret;
 	}
 
-- 
2.34.1


