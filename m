Return-Path: <kvm+bounces-41449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EBD88A67E75
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 22:07:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44193421891
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 21:07:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46A8721147C;
	Tue, 18 Mar 2025 21:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bqzd4uNw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E587E1;
	Tue, 18 Mar 2025 21:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742332026; cv=fail; b=kgrtYCGh9q38KmvXyzLnlIKwcIapD3Y8TYVF4LFAyBjnM7j6/7SBWhd8glzOfTt4YMYAVTKa394o6UHtsImMjTnpE7uHH3FP+VVFL942i7HQ0PfNZ3ih9PJdOtR3wCvNi1gS0Q/VXx1vT7uN7qMKnkymPz03tM0g0VEl/PT5D9Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742332026; c=relaxed/simple;
	bh=FQpQQ6I4VsfsIcFLVMtkUmuaPud5yEayGryojZOiLt4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GW0czOve166ugEvPXIf2uk6WfyGaXGNdw+Cyj7gFhnu875Aan7g4Gg//BuA6A886dPY3OkuUoNVXQo7sE3a2fR3BDYRQ8+3vlfhvggZQXBGD94Wd7XDMpSCK/SIqeCb1knKei2hc//orXCSFL2OVo46ptXG2OLCJ5zdcKpjXNKQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bqzd4uNw; arc=fail smtp.client-ip=40.107.94.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RNgx+khniULtWisH1J+pMttivbZAyIEZV0oWIFX4prstqKohs8b0E66pcSD4gF38o8yaN2b2l46V8NfkJ5R0+gwDALTRHbr55stZdnow0SOhUtWscOULTXVHc+mIusAarEv1s4nMeXwDhsxovmMkWtgu0HvZn+/4R3KKZkh+CAmJgGMczV3uLlHdlPiO3oBG3TL3tVEcukPrgFAFxqOQkcBpp0apm0iwwyOZXkloDUEcX43FPTZexs05Pb67blTm2UDhDRjn4YNj0HDO4Bs6NUYnCOVCOM91cwtmo7tjo0LsNpCkVe82EOljJU1UJQAJK75IhofO6E7E1l3rCadEQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9wg0n2ZePJj6izIcsYed3dF/Fy2yJaWmPdMlOR/lZ1g=;
 b=wfOJdrx8EQDtiSZ3Z7BSXewcPQInJ/yonJtWOC+P/idTeN1KVEkah58HnZHhL7EZECYH1SzCXQPsu0BaH3C2m09reaS19fflIiQ7Ophew4oCnBnEaLWwXzux46RpyKG3mfG2L4ZhQUqxhcAm6YrNR0B7PwAhmC8DNvBS1hibZErUydNL8RoROYfme1OO5eH6hvt/mXEnNH7FfcBHlVfmFo6VHAQBg8KS+F2DrBvjBthYMBaG7OIHyFvRBnZrGZ/VfhlgA0JCnPTGpr/SqPe1SrJCikV7zut6JzKxBsdyNJlSir3rK+Xe6zT25Jmb1AJbA3tVooBT2OPiuwb/3k6VpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9wg0n2ZePJj6izIcsYed3dF/Fy2yJaWmPdMlOR/lZ1g=;
 b=bqzd4uNwpbc4NX4Ryv0SEpvRXZexVoYjxwXgTw8kyQaCU7NLD+6+8+F7yblx+H8zKTaj7SPuAQBf96U3hfamAjMPw+S9FNU3x2z28rEMJgTC+XTep4MbMC7s+6fmZct9Lhr13Uyd7nawDxjGA0wioV2QQIOVmPLUy2j9hZ9z5lE=
Received: from CH0PR03CA0240.namprd03.prod.outlook.com (2603:10b6:610:e7::35)
 by MN6PR12MB8592.namprd12.prod.outlook.com (2603:10b6:208:478::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 21:07:01 +0000
Received: from CH1PEPF0000A345.namprd04.prod.outlook.com
 (2603:10b6:610:e7:cafe::40) by CH0PR03CA0240.outlook.office365.com
 (2603:10b6:610:e7::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.34 via Frontend Transport; Tue,
 18 Mar 2025 21:07:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A345.mail.protection.outlook.com (10.167.244.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Tue, 18 Mar 2025 21:07:01 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 18 Mar
 2025 16:07:00 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <bp@alien8.de>,
	<thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v3] crypto: ccp: Abort doing SEV INIT if SNP INIT fails
Date: Tue, 18 Mar 2025 21:06:51 +0000
Message-ID: <20250318210651.7616-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A345:EE_|MN6PR12MB8592:EE_
X-MS-Office365-Filtering-Correlation-Id: c09d8b29-2f71-42d9-3bec-08dd6660d3e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?28Ob6/S3VYd9uGGhedfc8OU2C+0wk5kJGggxtBiHiiiwqBI0nPPkDNdmx04p?=
 =?us-ascii?Q?yCcwcpuJsuP2ySuvxHMNU8LOkkWPHgcnjY94ywL7HPtXNtF54YhvVFGVKICX?=
 =?us-ascii?Q?pGjByfOskwOEXgjtA22HRuHJzW4SdGwOeNvPQo6p/TKOqUagQfAi0uZXmcZD?=
 =?us-ascii?Q?1plRSddU2LdEmucRoiWCq/+wFs1fF1GA0rjBKXPalw0/FzspWc7RZpYMuMrz?=
 =?us-ascii?Q?dG7zBEezXlXX37l3Asaj2EPEoaO9ZOcy9b5qA6tqfhv+I+QUW7j6hyUn+L5m?=
 =?us-ascii?Q?Cn92wDJG8UtoJpEYkyXppPbn03Z6dEwz44HZ+Uh1MFEObG+5kh22XLghjNog?=
 =?us-ascii?Q?FT9eCGeOO63b1wPKZa/gXGTbYv4E2R0GdpamWQYNZmo0PrgiKDkLWOGLaWZH?=
 =?us-ascii?Q?rped9Z3+La57uj6ev7kf4q3Y55K50QC+4HoDKJoQX0Wgc0gkfC+3RCo0Uvo6?=
 =?us-ascii?Q?31B6on5k8qh9vNuNEOWACXfXlBUC17hSJU8+9LCR3fwwVt9CqtnkUQz17dS9?=
 =?us-ascii?Q?892Fy2Lfh6GP5Lg4SZfrHgjHwkOWmzRCGnA6KRdobel2clxwF5sWp0Dpfrwp?=
 =?us-ascii?Q?0d+UWgC7xywFqNvcefLhMpjSi90EsjSIcS1nSR+OfoAnZYYN+6k/ODs+1G8e?=
 =?us-ascii?Q?dlk4XmKmD412d0uxUXjJvzh7jOa22AsCR5+FCrH5bv0dVU/2zf/A2sGisnsS?=
 =?us-ascii?Q?44vEqsFOflQ7gXGKqxaODIFYU+0gfrwknvuep+PAQcPNyGrCCUt/DoYK6Cor?=
 =?us-ascii?Q?11SMXh2tm7x/3MNLyAawZQVz2eTyOclPnyXl0i4PZikqNtswyMD50rse3s1g?=
 =?us-ascii?Q?CpcGPJuFZL7UpkNfsGkPTApnrR67UwrdOV8v05y/OQDPfW0CG6vLZRAsbcBh?=
 =?us-ascii?Q?OQd2SXvBtQmuMmWvNtpUMSdvsOFCnOllg3Qlb0lPz4rkD4M63ovkeBOZ08HK?=
 =?us-ascii?Q?asTJi0gTd/xNvrDC7hIR+bow6im+gK2zFXqkFF7hEylNk3Y2yp2t0MsNu7L6?=
 =?us-ascii?Q?qyY/FTz6cO+FEPqySac34sD06pP86xu9yJryOKQw8AYiKDD6WMiglZ4Gr1fz?=
 =?us-ascii?Q?CeUTMVowfXiFw5JzSyNv/Fd04Mp5PRzvnuUQpQmFps2CtdPuBXA8O+ojmyv8?=
 =?us-ascii?Q?/KHPoeB2ZDBDMTA9ItcedwUaNNPD+JYlvzVpw3tKAOxHVRk/7bTTexYcTvHM?=
 =?us-ascii?Q?OnY8+hUaF4G9OYXLPox/M8mmGhl/fLawEdymPzhtaazLMlsevOc30V0ogiM4?=
 =?us-ascii?Q?FBzi4XCW8+AAECf5lQwSLK189FpHnjsc+U/if9gKvQ8hFUCfPjYQkrIaim2L?=
 =?us-ascii?Q?mIhqhu/Slop8gLid4IkFFZfaFyM+qI+giSSBE68J5O+04AOsFqnORZULIFyH?=
 =?us-ascii?Q?4MEB2qe3b/btVuqNwPQ6PYdYk9bly76pW6mL6UlS5zuzlaKcPBGJd1BU+tno?=
 =?us-ascii?Q?iPD+1kv59ExZJ1M1uImytBGpBq+WVReowTbl6jsegRfInnNTKfNYa0XllvxK?=
 =?us-ascii?Q?7XocK5Xbnyk2GMU=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2025 21:07:01.3631
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c09d8b29-2f71-42d9-3bec-08dd6660d3e3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A345.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8592

From: Ashish Kalra <ashish.kalra@amd.com>

If SNP host support (SYSCFG.SNPEn) is set, then the RMP table must
be initialized before calling SEV INIT.

In other words, if SNP_INIT(_EX) is not issued or fails then
SEV INIT will fail if SNP host support (SYSCFG.SNPEn) is enabled.

v3:
- Drop the Fixes: tag as continuing with SEV INIT after SNP INIT(_EX)
failure will still cause SEV INIT to fail, we are simply aborting
here after SNP INIT(_EX) failure.

v2:
- Fix commit logs.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 2e87ca0e292a..a0e3de94704e 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1112,7 +1112,7 @@ static int __sev_snp_init_locked(int *error)
 	if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
 		dev_dbg(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
 			SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
-		return 0;
+		return -EOPNOTSUPP;
 	}
 
 	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
@@ -1325,12 +1325,9 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 	 */
 	rc = __sev_snp_init_locked(&args->error);
 	if (rc && rc != -ENODEV) {
-		/*
-		 * Don't abort the probe if SNP INIT failed,
-		 * continue to initialize the legacy SEV firmware.
-		 */
 		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
 			rc, args->error);
+		return rc;
 	}
 
 	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */
-- 
2.34.1


