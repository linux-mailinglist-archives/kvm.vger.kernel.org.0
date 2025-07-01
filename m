Return-Path: <kvm+bounces-51217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B6DAAF0475
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 22:15:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 453DE7B2220
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 20:14:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18320261581;
	Tue,  1 Jul 2025 20:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kIG0sElI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2088.outbound.protection.outlook.com [40.107.95.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFC72441A6;
	Tue,  1 Jul 2025 20:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751400922; cv=fail; b=VwXX/hvlS/aXeefRhpVwX7/OAh1A7SPTnKMH1miaCLH6UML+Nvb2ocWU8QEX5Pprag64/Pzt83uzUxVXzmVmCGAaQUGi/jrEki8U4H1k0fmkpBqtk1X5HydDrUn6oZkHfSBCkEsziOMFBlRyiXC3Cz8DpYl+7iwryp1Ta5F3ejU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751400922; c=relaxed/simple;
	bh=PCSWw3bmU7pvydph+mpvwfkpbqNAPXS6X5MSxiIZiHs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gtnjN152S+fCdIsxPZgJZaH+WTavqbiyiqGjECw2bzeAmceHGEFzQ3H1jfg3SuoZ01a70qPtpMqO4hlrCmdartNpKQ6GO3kP0P1zUJjB/turWr6rIaKmEdfdnAQ1sqKYAER9dd690wLmj64fGuvZ2W/jM/vqm5cxxI5n2WePM9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kIG0sElI; arc=fail smtp.client-ip=40.107.95.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VsJpYwo6zm6jqTkofP+EQmmT1mKdY9s02A7LrxSbF2zCq4yQEZ3FP6e2fU8eeD3p3uuzmb/Yf9lXw5CwgQBP5Nb0NZsQ2TV8bO7bs1ogNiQmAr8/6ijkMTlmvfinlq/sfPNV2+mV8Fgxlbf5NyQvTJi6vSt3vHC+p8M2T23TvEKEnT1BQP1WIHzQnuNBDd0xsLtTGNnT2IOp3BNj7lH3saY6uiPUikWTLIVkfWM/VJpi5xJ5eEJ0qqJ/VzDi7eKyiu1IQvMy3rGBTXnhTmCIG82YglHKXZlYDV+jRg9/RlBJ79BnrsDzsnQWaDLpYeSbmbEj9/jAXhKTBf+9FFNY6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W1aYCuvLvbn4gi9xjSJ0qUrfIQG+6/ESmXgAdmILFtM=;
 b=WWRbYMdLa6edvM2oeOyQdI04A1dka4mMaHU2oRKVkoYYJsroSLa+c7CKtpufoMoGn1QsasPXKepu46RmUP5RQeqL3siFtV1YOApTBfgtq29ii+ETijK/ib//ubSlQt/y9EXSA0PQK2FLLWlvyKR9HGL4lSoElYTxc0NrU9GenvEvKIvU35Wuj8cd3gtRIHHMR2OgXuqOPi1eWpUelhOXV+ZmGiMpIfTjirPPQ4t/qelw00xIHwADf56epeZfQE2Jle7hK2gWrIa/i9fWHr7wAx7csLj27plPiVGMYFkjt4+aEVEaJo1HsQFeyzM0aURaRdYECbDE08FcyUxVbbLG1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W1aYCuvLvbn4gi9xjSJ0qUrfIQG+6/ESmXgAdmILFtM=;
 b=kIG0sElIP2vjKTForH6MF1RZDjvcSeBpZhuyV6kXmb6kuABfzzo+WEukzjPKPMmncgGZLGPm89pq7ghRiGjTYYqPInAL4G4N4LXKllBMjtR63sS671ZyC0KwZncHRaCOVoxG8meQxhJYCbVviJ5+vLg/CToTTLJUleNwe+QhOAo=
Received: from CH0PR03CA0345.namprd03.prod.outlook.com (2603:10b6:610:11a::29)
 by DS7PR12MB6047.namprd12.prod.outlook.com (2603:10b6:8:84::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.33; Tue, 1 Jul
 2025 20:15:17 +0000
Received: from DS2PEPF0000343F.namprd02.prod.outlook.com
 (2603:10b6:610:11a:cafe::b0) by CH0PR03CA0345.outlook.office365.com
 (2603:10b6:610:11a::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.32 via Frontend Transport; Tue,
 1 Jul 2025 20:15:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343F.mail.protection.outlook.com (10.167.18.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Tue, 1 Jul 2025 20:15:16 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 1 Jul
 2025 15:15:13 -0500
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
Subject: [PATCH v5 2/7] crypto: ccp - Cache SEV platform status and platform state
Date: Tue, 1 Jul 2025 20:15:03 +0000
Message-ID: <69f95a382a6b5a6fb568aeba39b7c937fe552ed4.1751397223.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1751397223.git.ashish.kalra@amd.com>
References: <cover.1751397223.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343F:EE_|DS7PR12MB6047:EE_
X-MS-Office365-Filtering-Correlation-Id: d950817c-bd0f-453c-0190-08ddb8dbfe5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4NyP5VdmFC+EjWmMkKwSO7ivUtxlA8PQ7bDvpblkGAokUgju/6TAH/WpTR2C?=
 =?us-ascii?Q?oB1D5LbJZ5HYV9yqFoTu+qWfZ97sGURDH7l5Ms2k5XYL0MHorWYqez9hXCye?=
 =?us-ascii?Q?rrtOIVQ2jnXN0dMuOSm1m2GyADJxRUczYHG/2PQwjq8fko4nauXCzjWVMuuF?=
 =?us-ascii?Q?Hbs/ZARI5VHAERhKdtIL4ea9t6aevkP+/RG/EZ6yxyNvWG4EXrQ/l0ZhhANo?=
 =?us-ascii?Q?bAQ44xRZYIEmNN+/7ZtbiSFnXxQQr5A6MxFmPR+aCtqIacJvscbQj110xfjz?=
 =?us-ascii?Q?iNJYNHV4sSVTTf9HHc85ZX8OIhWtE3tfRU5z+kMPxEPUtbcgn7PALNZ2bDOW?=
 =?us-ascii?Q?Ful+a11wqFwKaBUb9ogwTJx+ZjE+av6LaO9M0EsqsDn2Ffjny5daJDgZ2bs/?=
 =?us-ascii?Q?Ld0E3KsBzraUpYx3P7RlvqdtIkj2Ycf3XqWWmy2i0VsZh5QmI9p6HWHJAi1V?=
 =?us-ascii?Q?2JH4iPdUX7of+Wgm4uAU3RaoUjtphUj7UhXoZnV/RpXIF96AKmx0ek9wo7Wb?=
 =?us-ascii?Q?cVU6nP9m0U8vu6dPgh8N9Sp7MlxbMZhBHh/JJPqMuwxB/ILuRz7eFJQEkJRh?=
 =?us-ascii?Q?tDDHwBunfovsKCVOiGWuS39ik9OUCx+j7jtNtVxSYajwUD2he/DsxV44Y3AD?=
 =?us-ascii?Q?uGbHJqEUx9QdURlcSQgynJTN8sdAsckABHYeqMJ4IfuyxDMN5n4ZSUHi9Pu6?=
 =?us-ascii?Q?N8E7mR9w15qIQ8m2CzdKNtheypKs0tU6ouAaArv3KeoJ9Wk335d+AYRnb4iQ?=
 =?us-ascii?Q?YJkbtEEgVlnsbTdHPoo73eqAKIquJx34++Y5qpER3PZOacuBGrJweAvx3N7E?=
 =?us-ascii?Q?/SntBxFXP8I1Ll1N57uDzcxVZqGOAaOCPRfCFryE9O+8Wr5ufasPTpvx5lZ0?=
 =?us-ascii?Q?Qsnn+QyA71amY9bETDl8EJ3rhctQ4sm1F6mED5APQlsqTUDxhdH9CKbExVQV?=
 =?us-ascii?Q?FVVlU2VFBebBX+jNmb3TvARSE1JOcXf11TrL5Ry0SOwJrjqTIwDqgkJeMFB1?=
 =?us-ascii?Q?PGulmwY/hYm+bd9FBfBdHYbtwxaF0V+/r2BXUckmL03dDS+rRFFVTBpY4od+?=
 =?us-ascii?Q?bpXGSENtxAsjUyGpWKNrCfDuhzNNthy7+uZrg0gQIyxqfxAOozWlPPjn68zB?=
 =?us-ascii?Q?zB3URfHDHDlugE+f6NnuyIMPG8LUCu3UajvQbe1AlxucJo6We3dBAQeaQ7uc?=
 =?us-ascii?Q?ZSqSnOzTYcq/Jaw3uSFKL2mYdklPuWdCH4hKRkt3zEEI4pAigQhd1zRk/8EB?=
 =?us-ascii?Q?9vG9lvWdb+FGSv1fMBDKSFx0BPE4rDBQ9lY52KYQ2BvGy+mtHG1UEEv0kCrG?=
 =?us-ascii?Q?XtgJAwzkZCAzu1HDtGsLCGRDSUKAhsWfeP3dZ+oMRT++EXESeHzTnxP9Dkdp?=
 =?us-ascii?Q?ycAbJaoMmm0dWHU+JJvFXMfucoAqSOqc/DMf1C0Xkw5OWGIcFir3flRLQZjL?=
 =?us-ascii?Q?kkcvS6FXhXC+WH0Lzf/76fAVOv8/nqeqgPp4nqf9m9mQUOuXgU/gLObhIj+D?=
 =?us-ascii?Q?dTFDzJnAwSZnyRxQSRIjKiF5EyGC6oVoPh9XlVJXDndfr14YpEFOg8fv+g?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 20:15:16.0342
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d950817c-bd0f-453c-0190-08ddb8dbfe5a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6047

From: Ashish Kalra <ashish.kalra@amd.com>

Cache the SEV platform status into sev_device structure and use this
cached SEV platform status for api_major/minor/build.

The platform state is unique between SEV and SNP and hence needs to be
tracked independently.

Remove the state field from sev_device structure and instead track SEV
state from the cached SEV platform status.

Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 22 ++++++++++++----------
 drivers/crypto/ccp/sev-dev.h |  3 ++-
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 17edc6bf5622..5a2e1651d171 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1286,7 +1286,7 @@ static int __sev_platform_init_locked(int *error)
 
 	sev = psp_master->sev_data;
 
-	if (sev->state == SEV_STATE_INIT)
+	if (sev->sev_plat_status.state == SEV_STATE_INIT)
 		return 0;
 
 	__sev_platform_init_handle_tmr(sev);
@@ -1318,7 +1318,7 @@ static int __sev_platform_init_locked(int *error)
 		return rc;
 	}
 
-	sev->state = SEV_STATE_INIT;
+	sev->sev_plat_status.state = SEV_STATE_INIT;
 
 	/* Prepare for first SEV guest launch after INIT */
 	wbinvd_on_all_cpus();
@@ -1347,7 +1347,7 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 
 	sev = psp_master->sev_data;
 
-	if (sev->state == SEV_STATE_INIT)
+	if (sev->sev_plat_status.state == SEV_STATE_INIT)
 		return 0;
 
 	rc = __sev_snp_init_locked(&args->error);
@@ -1384,7 +1384,7 @@ static int __sev_platform_shutdown_locked(int *error)
 
 	sev = psp->sev_data;
 
-	if (sev->state == SEV_STATE_UNINIT)
+	if (sev->sev_plat_status.state == SEV_STATE_UNINIT)
 		return 0;
 
 	ret = __sev_do_cmd_locked(SEV_CMD_SHUTDOWN, NULL, error);
@@ -1394,7 +1394,7 @@ static int __sev_platform_shutdown_locked(int *error)
 		return ret;
 	}
 
-	sev->state = SEV_STATE_UNINIT;
+	sev->sev_plat_status.state = SEV_STATE_UNINIT;
 	dev_dbg(sev->dev, "SEV firmware shutdown\n");
 
 	return ret;
@@ -1502,7 +1502,7 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool wr
 	if (!writable)
 		return -EPERM;
 
-	if (sev->state == SEV_STATE_UNINIT) {
+	if (sev->sev_plat_status.state == SEV_STATE_UNINIT) {
 		rc = sev_move_to_init_state(argp, &shutdown_required);
 		if (rc)
 			return rc;
@@ -1551,7 +1551,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 	data.len = input.length;
 
 cmd:
-	if (sev->state == SEV_STATE_UNINIT) {
+	if (sev->sev_plat_status.state == SEV_STATE_UNINIT) {
 		ret = sev_move_to_init_state(argp, &shutdown_required);
 		if (ret)
 			goto e_free_blob;
@@ -1606,10 +1606,12 @@ static int sev_get_api_version(void)
 		return 1;
 	}
 
+	/* Cache SEV platform status */
+	sev->sev_plat_status = status;
+
 	sev->api_major = status.api_major;
 	sev->api_minor = status.api_minor;
 	sev->build = status.build;
-	sev->state = status.state;
 
 	return 0;
 }
@@ -1837,7 +1839,7 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 	data.oca_cert_len = input.oca_cert_len;
 
 	/* If platform is not in INIT state then transition it to INIT */
-	if (sev->state != SEV_STATE_INIT) {
+	if (sev->sev_plat_status.state != SEV_STATE_INIT) {
 		ret = sev_move_to_init_state(argp, &shutdown_required);
 		if (ret)
 			goto e_free_oca;
@@ -2008,7 +2010,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 
 cmd:
 	/* If platform is not in INIT state then transition it to INIT. */
-	if (sev->state != SEV_STATE_INIT) {
+	if (sev->sev_plat_status.state != SEV_STATE_INIT) {
 		if (!writable) {
 			ret = -EPERM;
 			goto e_free_cert;
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 3e4e5574e88a..24dd8ff8afaa 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -42,7 +42,6 @@ struct sev_device {
 
 	struct sev_vdata *vdata;
 
-	int state;
 	unsigned int int_rcvd;
 	wait_queue_head_t int_queue;
 	struct sev_misc_dev *misc;
@@ -57,6 +56,8 @@ struct sev_device {
 	bool cmd_buf_backup_active;
 
 	bool snp_initialized;
+
+	struct sev_user_data_status sev_plat_status;
 };
 
 int sev_dev_init(struct psp_device *psp);
-- 
2.34.1


