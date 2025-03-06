Return-Path: <kvm+bounces-40291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A4A6FA55AB6
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 00:10:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A015A3A781B
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 23:09:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EE7A278107;
	Thu,  6 Mar 2025 23:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PmFOlujr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF231311AC;
	Thu,  6 Mar 2025 23:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741302588; cv=fail; b=mqDa+5TQwbBIwW/NhnDsuObDr1F6V9/vXkvp7pt3sRwbUbaqIa2Fdpl2qD9dHPp5l38LH1dSHR5R4SRlE6FwzLuUx9JMOftVI1QBhKgCONLbqkgrYRVIm2ZYjRbq9gdu2QGFt//3i9M4KkFD5z6rDKqBBGGjiV29fVPlPMt+8bg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741302588; c=relaxed/simple;
	bh=dm61mEE+B5kJfT4XEi2fsMDw9XpWDjWXysZC80W4+3c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E5WqNpUrFreNGP2OtHXKbTbsls+TOG0i0Z8UpiXCEvdcpWrnOlnlvMHQ79shJgzG2fzSTb+ahB9Cb4UR7iYGy7my/YPk1KoI1n1neTIUiL5PZSAjAU2s9Je+bdpwoUM5IfsOyYYGqbf3dZaYp24AY4IzL39mzzuHKik60EeDFXo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PmFOlujr; arc=fail smtp.client-ip=40.107.244.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BC0+Mz1Z+8XAkn+N7zSLhUuNiD9dOKhqd4M6riSHtZAJnHH0H/n1+K+uM/KYrKz2KmhvBjOCY+kk9aulOq4payUo9byMIf6F+BpSwka55QPJUsxB5mvXY8coWhayZlfQdSFxPlvbRQWhvHhmBpougzpn4g46V2WKma4AIuUVYBezlthwo8HsQiOAGil3cQM2R7X9+0o25ft7VBgxLMlDoc+buiXwNWSg901+/5qIXUvrJrmry/L0MYmQW7KGODU3Qk2EQn8KY6p71k2EiDO7dRzUixAHW7rBvk4+a8dNgP9QmH315CbyhMhxBshgsu4wed1SSQx/fpQ9H+QHQbpxgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8NqFREYQPYF99Pjehh3ZnLZIzayqfjC4lmTC2BENyj4=;
 b=eVMKfPVdq98/F77pB++pFpBI22t68DdP21K2T2Vt0Ymhrr6Et16I49/qfiJAi9uJKri5CzyJ7fk+VtNx0j+7cMv1HYp2j9ELG/rGrw2Ma09eyEbT4XsKuNdP2tS/TWUDwaRV5fvMTvyQOHOx9shAoxMiPjTuaezQiMtj8xD7kJfHrl5TgislT+qZa4ftezlQNhVXYcZGSWBe4V7mRwk3Jg/3ErDzXyHB9prP7atlCNBh1o9Q51QJ209Jh95oco+f7yHfKXP3id0gq7CuUGgOJatjidHlICU2jnN0VZ+OXYIgEDwuTIYbt8Jkq40YjV9H77nlhNPnrfG3bgeTZdIx5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8NqFREYQPYF99Pjehh3ZnLZIzayqfjC4lmTC2BENyj4=;
 b=PmFOlujrpwE9nDbuy87RuJTb7WbHcK66DT7JRCo7hY70Ft5TLkGJfYhsQ8g8PjDGHM2lOjFLTacqx5E0SKMHG7Lu1TaA/erdjEYCWXSF1pzOVK1YOV0VzVIQmAcFEw70SS/TyT1UC+g4wyjXQIuhq5UcMAeIPRFldEWZ929yOoM=
Received: from PH7P221CA0056.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:33c::30)
 by IA0PR12MB8715.namprd12.prod.outlook.com (2603:10b6:208:487::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.16; Thu, 6 Mar
 2025 23:09:41 +0000
Received: from SN1PEPF000397B1.namprd05.prod.outlook.com
 (2603:10b6:510:33c:cafe::1c) by PH7P221CA0056.outlook.office365.com
 (2603:10b6:510:33c::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.18 via Frontend Transport; Thu,
 6 Mar 2025 23:09:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000397B1.mail.protection.outlook.com (10.167.248.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8511.15 via Frontend Transport; Thu, 6 Mar 2025 23:09:40 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 6 Mar
 2025 17:09:38 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v6 1/8] crypto: ccp: Abort doing SEV INIT if SNP INIT fails
Date: Thu, 6 Mar 2025 23:09:29 +0000
Message-ID: <9d8cae623934489b46dc5abdf65a3034800351d9.1741300901.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1741300901.git.ashish.kalra@amd.com>
References: <cover.1741300901.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B1:EE_|IA0PR12MB8715:EE_
X-MS-Office365-Filtering-Correlation-Id: d740717c-2a4b-4fba-b833-08dd5d03f91b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2XHpgtAhk4B95NTwFO3evxazklU8Pxywziatt6eaEU4loXeyDE+FjKulNeNg?=
 =?us-ascii?Q?weIDOh0ST+eaLvePEvC420+5/+hlNZ9vLh0vWdK/ffaNWXSK06VQnZCbCBH1?=
 =?us-ascii?Q?PbYmU0pfK5DDK55uYUVyiSMzl0C8hr2C6j1CcC5KJsv9pKphwNuKF3BM/8G3?=
 =?us-ascii?Q?QuNkvdc8YhCBn1XlD7nmmkCR6l8RzfjQvXrHNLNA39L51bOHIaZJ7D2qMCSV?=
 =?us-ascii?Q?+TBoinXFwXj+hbnBLePJrr6QZh86H4Lo345lS+Zb5AWcMdltAea3060801cn?=
 =?us-ascii?Q?nSdcolr8m+aZnZjayvqoe6ibl2BBIpR8yQ1NTcuXwjqrJkgSFhGFNQosgCgE?=
 =?us-ascii?Q?3mNnIef0risU1E6Q+6MNBDFRE1bHlPV8h/5gGHet2tCX4MGFXB+8OISDeT7W?=
 =?us-ascii?Q?fIaiSJbFiJKEt8tBX/J2q9Tutlzuj555EU6Bhxnit3Vgf61dGW1Bm3+eI6De?=
 =?us-ascii?Q?4TRtZxSs2DOhu0RRE2oMV5uxKCw4a1nPlo1IWWZOTnkT4CD1/yQgBTWF3i67?=
 =?us-ascii?Q?nZjBIJ/iC3LjYJr+KRTAruIuAs63RFoeiZH76cv3gn7/5B7RiKgGce0zWvOi?=
 =?us-ascii?Q?DgOqz+P8Ax1mxwY25PKFz+o16JKw0eLa9BPobUFgus/O5HIJr1brIopiag1u?=
 =?us-ascii?Q?UWsKHwChzMT2xBIQ26fhDjn5cUkUeQWP6VFRNAvpYflltlMuV/LUz4oXE51m?=
 =?us-ascii?Q?S25T/rrz//HRl92vIEcAHVuH+pem2NPKIecv7+mX2UqHMp4hP1ILMJWigyOz?=
 =?us-ascii?Q?nUfnVIcTU2Z+hAyTrx6z0QwZsO6Psp67CeMb50vMtC29dJmFK420/SSbT/On?=
 =?us-ascii?Q?706azNMeaVTljO4eRBsRyYqNGa7Pv8M9yLrgs04hytK1wuhzmzbkyzmFgaVM?=
 =?us-ascii?Q?p5pNsXykjuz5JCgjFuRidf3pC1/JC4xnSNJpEfpXyUltNNDbz+BA0YQ+S/at?=
 =?us-ascii?Q?a3RzF3hgNYo5PJUYP8N/JtmkojIOUoOYA0eC+5IYdhl8O0IZS2zem/HrQSAY?=
 =?us-ascii?Q?ZrpzpfZna0isCBcTFodrhotw1Hi6njrwgQeNuv+0/Um8Vnh01evVdIF/UhPU?=
 =?us-ascii?Q?m3rtP20XEsK9vAZJjuOEl13TwsSZEcV50tWulR4mkfA0LQn8SeVq/1XCBANO?=
 =?us-ascii?Q?J00Dv+i6Bap8YOjUEJ1Fjg+NZDCszpHSaTJNs5EvhWFOIzqMJxTwlJxxzmoF?=
 =?us-ascii?Q?yL8yDqvTGeU1ThAKfQqALmHqAnPbBJB5rkz3vNsGmxbORkBIgXWFYY7h/cId?=
 =?us-ascii?Q?NVdI4WHaCFbAiTkX6LeToDhsvS2uGC9Sm1xPCJ8maSws76wS6V1b4Qmudh3P?=
 =?us-ascii?Q?PbmNx/Ws5v7XGn5lUgUMqaksEPf0mvg/MFrpo5GUykKVfNyUs9GTULtEi4Ai?=
 =?us-ascii?Q?B9BdkvHKHlyllAWzhlPdZ5XGzAsWEvqvV+bOMVPy36DQMupWvBQzjVJbiG1d?=
 =?us-ascii?Q?vTe9gbt8itxP/yh/npIbOkw0UAL+WtbfKSsxNAvYB2LWh3lr+JwHHTUH5mYf?=
 =?us-ascii?Q?uBiREzkOLMUhqoNa6b35zuJGn98vLY6M9Nxk?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2025 23:09:40.1325
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d740717c-2a4b-4fba-b833-08dd5d03f91b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8715

From: Ashish Kalra <ashish.kalra@amd.com>

If SNP host support (SYSCFG.SNPEn) is set, then RMP table must be
initialized up before calling SEV INIT.

In other words, if SNP_INIT(_EX) is not issued or fails then
SEV INIT will fail once SNP host support (SYSCFG.SNPEn) is enabled.

Fixes: 1ca5614b84eed ("crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP")
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


