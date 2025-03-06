Return-Path: <kvm+bounces-40293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B61B0A55ABB
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 00:10:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E81D2189789F
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 23:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6743A27E1BA;
	Thu,  6 Mar 2025 23:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="45+Um7Dm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2041.outbound.protection.outlook.com [40.107.237.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9531B259C9F;
	Thu,  6 Mar 2025 23:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741302619; cv=fail; b=AvYud1wsMYxekbSQG2KpCdQZiAWgWzADK7VTeuDsK5A1j7vwmDOy3/rCOIanxfrH3V/IIk3OhXqHQbKulF1EQaq3ZrokcKVxLYGTj83x9TEzAl0CRmu8OYk17VOKSY349YSvDYWX3hLjeiUsEf5Wsj/foVCc0A3FFoeWEmQEmRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741302619; c=relaxed/simple;
	bh=rrt7J0UIuKOCzgrPDDoHqeTRZI+iMcAiHRa089pBTVI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iEfhe47nCJIrPHWt4QqlbYw/aOZrfgJtupSlbN21SvRHC5S2oa+S8QEuF13BQ/zvNtKxLujMzrcDtq2Gwf+5Df5Rk96Vpq8fkJWr5orkilqhmlJ9sdyIdKjaWFdRJUhUR35zllcgW2NkxOW17OmnZw6YcakXf9yy/qFnaj9FPDc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=45+Um7Dm; arc=fail smtp.client-ip=40.107.237.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R2QI2sS/xfFwjYD8+EmkCrbgD7dlQxJCYpoRFDv5DAUC7FJkXYYr4BexW8HGhZKmq5Gnw1qkZi4k2Km1HCNR4G23JZ63ZONe2psVqzZRKP7Uy/oImQDxVLZHuJIRYPXu0/cGGNu9AhIQppDAQfm0ZCGk94t9eCG/92PXipyHBHQmuUXK91xXAWdcqW2WUlw8F1wiTpixUmPIbK68Nhs3x36mCAbBGRjtFBap9cP/sr0ZEMINMv7tlQnV7/craILMefzzcSWBMg/6YH/dpWoiiBT0b34y4mzBtNlPeneQ72sT4jDNUoMWsO0H0KR/cWwGsGnp/W4OzPlwhrEh290xNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eiasAtEsNs6FRSSueAJgQ5Q3wcL/ypznsB8K2N6JcA0=;
 b=LKTlpCA6j7NlyxZERVBoXP8y67Mk4LIVYx6pBo9G1kOOF21Nt1XoPOKeOnTDgn4mcnWY0761ha/URoLU1Ea+tquBkugdfJG4SS8/Vm29JB1M7Gwll+BvYg8r1YoEGAN6kV1ZiHa7aY67/IH7HehiH5qjfqNr480Ht9WOimx3d0BSaIpem9y9UsQYLo81rdEe7/6tGuSM63WaykpFboCQodhcfOWh70nghi5PMltnUvoJYIckoqO3/d1H1twJyFfS3+6gQahMhZl+uTKbxGjKqc27OBul0OZL2df6V7+qecp1lootBUJRDevOKiuU0of6Izr/Rs/o9+ipbbjovem5sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eiasAtEsNs6FRSSueAJgQ5Q3wcL/ypznsB8K2N6JcA0=;
 b=45+Um7Dmt3I/pHDXspVtm280BPAoDKKoRdRYoHBdXYdyra7zqn427As3S8nswp5fi3MLGVIwhegQ1JCeB40wTnbxwmA4E7E/dBS+NO67WaaQbHXnT9STppeUt/1AeZ7OJtHnxvqo0cg0S2HSKocwXEzLjNhPXkZGmdbqqr2YdvU=
Received: from MW3PR06CA0004.namprd06.prod.outlook.com (2603:10b6:303:2a::9)
 by PH7PR12MB5998.namprd12.prod.outlook.com (2603:10b6:510:1da::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.17; Thu, 6 Mar
 2025 23:10:12 +0000
Received: from SJ5PEPF000001F6.namprd05.prod.outlook.com
 (2603:10b6:303:2a:cafe::5c) by MW3PR06CA0004.outlook.office365.com
 (2603:10b6:303:2a::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.17 via Frontend Transport; Thu,
 6 Mar 2025 23:10:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F6.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8511.15 via Frontend Transport; Thu, 6 Mar 2025 23:10:11 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 6 Mar
 2025 17:10:09 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v6 3/8] crypto: ccp: Ensure implicit SEV/SNP init and shutdown in ioctls
Date: Thu, 6 Mar 2025 23:10:00 +0000
Message-ID: <4a94e1d47b5ac270d47b87d7b38be0aca11779a6.1741300901.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F6:EE_|PH7PR12MB5998:EE_
X-MS-Office365-Filtering-Correlation-Id: 1737b6b9-1f28-478f-ff3a-08dd5d040bd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CAaklUqowEBA89+GfO+utJFbsyHsteWYu2gtzdAqsYbWy45G+RmseVpex9lH?=
 =?us-ascii?Q?eMldQBFNYPZk1aaz6T6zqxGqYcT4GvZXp0l3df/NxdsEnNQZpEroBxSEQCLT?=
 =?us-ascii?Q?2JD6UHyeARpUbTellUWUzjNCDglu0sqTsq0VkKqoknk/m7oCkv/cEbqyFn5R?=
 =?us-ascii?Q?kriKXlWXx3zyVn/obEzdMwdPb0bzejSvFJWzYc6Md5QUCmLdm78TZ3cgkcKN?=
 =?us-ascii?Q?w7NlrEX79OkbPdsBCbqJgt436XpLVMq275AJxsYHkKLEAHqsYYLRxvFaE/6o?=
 =?us-ascii?Q?5SChMO0hzczR+pwmh4TWe/tGJvkPQN3bhvNVQLxHvGFHBQpzvOq57fegjxVS?=
 =?us-ascii?Q?a6OfL0IZUCGhdkaz4BdLbuwSj3KMDCXfAsaYX8el0Hx8IyxzTUI0rpA7ZJ8v?=
 =?us-ascii?Q?cIclDLS6aL6rvNnKRYF6kE+0MCZxMoCiuapEM5PgKeXEy++h6DaWnJShBqdw?=
 =?us-ascii?Q?CnM+6uhTHAaYZ2Pm4gD2h/wWrSc1lvBvk6+8W4AZHIV8jTmvTfLh/25Ioa50?=
 =?us-ascii?Q?y4K7MhQLkkQRQsxohlolk2RVl1jkONxt3wgIWg7c41+zoiSbRHWNWjROhgIq?=
 =?us-ascii?Q?3Z2cpqpWrOojUlETVyitm0MtPAs0IisMTLMXPWFTWcY1pKZoXlsbnSEie7Ey?=
 =?us-ascii?Q?37vP+sTqjareCCDHkOT6oWCkLGGrKAVMzPKpWkcM4tpJHlpn531/XYKQcMLz?=
 =?us-ascii?Q?5la47yvEpQ83ZZjkOTMOBqjR+WrZcvz1Mwy2zILmO5xAh4V/fIPBkW25X5wh?=
 =?us-ascii?Q?V87CBMLkBnVkvyU+QsSGDySc6tIZohXFm7wSqSxrZUy2zgCkTsZs6Vk3C7X8?=
 =?us-ascii?Q?l7JUiLH5dlOLslScZziO3vQZCF5WFLKPh0MG1y/tqdMT6EDqwVCecFRtH0cZ?=
 =?us-ascii?Q?6vClngZQOfO4f7ziptXfDq56stOwJrLkBNIYXOco/FMiAbxefuHvCPi999Xr?=
 =?us-ascii?Q?m/kvaKpof/9IPHX3SKim6AjAofRT1+XqSRQLkMSr6s63RChCIZY/0/4aRgic?=
 =?us-ascii?Q?d1uWt+oZ0Vjiz8YcyTmOw3kOGRiWSNmjcFfUj8BuZO4v5ahqiPSfmlwXzDYB?=
 =?us-ascii?Q?2cgD/qiK0GCSVxd/UrkszMArLY8Kmr3oVFHw0BeImEkstMpqZgLvbGAwRkt/?=
 =?us-ascii?Q?xZfdDeT6/NfVE4ec6RN5ms1Tl0s4XQvrK1HIjavBvtfwVwXG+1/9pC9v3Ngq?=
 =?us-ascii?Q?sb05kPYzrInvATypyv2882PTA9N4auDC4qkGLSEuncv2vBQYxaVndGaMav13?=
 =?us-ascii?Q?M/uHpMS2qOqa5j2mMCR2n2GzkLV2dR5b2m/Nsc73AsuxF/5Wws4BwTIeS7NE?=
 =?us-ascii?Q?AtqT2RBNLEQh2o4sdcAOgirR0Yam/hwIfmsUI4SnC+yUH4wTG6YgxIXiPQPX?=
 =?us-ascii?Q?fSkdEcVsNBjra0xEHyn4wRZ6sx2y/BwJehdiG3kl5vlzSA4SQ7uOkSs9KiKP?=
 =?us-ascii?Q?kqWy9YvPT7coC71Pl+2oxBM+6w62pA7ykAIQ2/PeYPVhT2EGIdsNF8GKK3Qo?=
 =?us-ascii?Q?UJd/m5UDhM/sFH6Ykr7bpRSkqAi3uaK3bi4O?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2025 23:10:11.5105
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1737b6b9-1f28-478f-ff3a-08dd5d040bd1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5998

From: Ashish Kalra <ashish.kalra@amd.com>

Modify the behavior of implicit SEV initialization in some of the
SEV ioctls to do both SEV initialization and shutdown and add
implicit SNP initialization and shutdown to some of the SNP ioctls
so that the change of SEV/SNP platform initialization not being
done during PSP driver probe time does not break userspace tools
such as sevtool, etc.

Prior to this patch, SEV has always been initialized before these
ioctls as SEV initialization is done as part of PSP module probe,
but now with SEV initialization being moved to KVM module load instead
of PSP driver probe, the implied SEV INIT actually makes sense and gets
used and additionally to maintain SEV platform state consistency
before and after the ioctl SEV shutdown needs to be done after the
firmware call.

It is important to do SEV Shutdown here with the SEV/SNP initialization
moving to KVM, an implicit SEV INIT here as part of the SEV ioctls not
followed with SEV Shutdown will cause SEV to remain in INIT state and
then a future SNP INIT in KVM module load will fail.

Also ensure that for these SEV ioctls both implicit SNP and SEV INIT is
done followed by both SEV and SNP shutdown as RMP table must be
initialized before calling SEV INIT if SNP host support is enabled.

Similarly, prior to this patch, SNP has always been initialized before
these ioctls as SNP initialization is done as part of PSP module probe,
therefore, to keep a consistent behavior, SNP init needs to be done
here implicitly as part of these ioctls followed with SNP shutdown
before returning from the ioctl to maintain the consistent platform
state before and after the ioctl.

Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 142 +++++++++++++++++++++++++++++------
 1 file changed, 119 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index ccd7cc4b36d1..5bd3df377370 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -109,6 +109,8 @@ static void *sev_init_ex_buffer;
  */
 static struct sev_data_range_list *snp_range_list;
 
+static void __sev_firmware_shutdown(struct sev_device *sev, bool panic);
+
 static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -1402,6 +1404,37 @@ static int sev_get_platform_state(int *state, int *error)
 	return rc;
 }
 
+static int sev_move_to_init_state(struct sev_issue_cmd *argp, bool *shutdown_required)
+{
+	struct sev_platform_init_args init_args = {0};
+	int rc;
+
+	rc = _sev_platform_init_locked(&init_args);
+	if (rc) {
+		argp->error = SEV_RET_INVALID_PLATFORM_STATE;
+		return rc;
+	}
+
+	*shutdown_required = true;
+
+	return 0;
+}
+
+static int snp_move_to_init_state(struct sev_issue_cmd *argp, bool *shutdown_required)
+{
+	int error, rc;
+
+	rc = __sev_snp_init_locked(&error);
+	if (rc) {
+		argp->error = SEV_RET_INVALID_PLATFORM_STATE;
+		return rc;
+	}
+
+	*shutdown_required = true;
+
+	return 0;
+}
+
 static int sev_ioctl_do_reset(struct sev_issue_cmd *argp, bool writable)
 {
 	int state, rc;
@@ -1454,24 +1487,31 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
 static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
+	bool shutdown_required = false;
 	int rc;
 
 	if (!writable)
 		return -EPERM;
 
 	if (sev->state == SEV_STATE_UNINIT) {
-		rc = __sev_platform_init_locked(&argp->error);
+		rc = sev_move_to_init_state(argp, &shutdown_required);
 		if (rc)
 			return rc;
 	}
 
-	return __sev_do_cmd_locked(cmd, NULL, &argp->error);
+	rc = __sev_do_cmd_locked(cmd, NULL, &argp->error);
+
+	if (shutdown_required)
+		__sev_firmware_shutdown(sev, false);
+
+	return rc;
 }
 
 static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_pek_csr input;
+	bool shutdown_required = false;
 	struct sev_data_pek_csr data;
 	void __user *input_address;
 	void *blob = NULL;
@@ -1503,7 +1543,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 
 cmd:
 	if (sev->state == SEV_STATE_UNINIT) {
-		ret = __sev_platform_init_locked(&argp->error);
+		ret = sev_move_to_init_state(argp, &shutdown_required);
 		if (ret)
 			goto e_free_blob;
 	}
@@ -1524,6 +1564,9 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 	}
 
 e_free_blob:
+	if (shutdown_required)
+		__sev_firmware_shutdown(sev, false);
+
 	kfree(blob);
 	return ret;
 }
@@ -1743,6 +1786,7 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_pek_cert_import input;
 	struct sev_data_pek_cert_import data;
+	bool shutdown_required = false;
 	void *pek_blob, *oca_blob;
 	int ret;
 
@@ -1773,7 +1817,7 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 
 	/* If platform is not in INIT state then transition it to INIT */
 	if (sev->state != SEV_STATE_INIT) {
-		ret = __sev_platform_init_locked(&argp->error);
+		ret = sev_move_to_init_state(argp, &shutdown_required);
 		if (ret)
 			goto e_free_oca;
 	}
@@ -1781,6 +1825,9 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
 
 e_free_oca:
+	if (shutdown_required)
+		__sev_firmware_shutdown(sev, false);
+
 	kfree(oca_blob);
 e_free_pek:
 	kfree(pek_blob);
@@ -1897,18 +1944,9 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	struct sev_data_pdh_cert_export data;
 	void __user *input_cert_chain_address;
 	void __user *input_pdh_cert_address;
+	bool shutdown_required = false;
 	int ret;
 
-	/* If platform is not in INIT state then transition it to INIT. */
-	if (sev->state != SEV_STATE_INIT) {
-		if (!writable)
-			return -EPERM;
-
-		ret = __sev_platform_init_locked(&argp->error);
-		if (ret)
-			return ret;
-	}
-
 	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
 		return -EFAULT;
 
@@ -1948,6 +1986,17 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	data.cert_chain_len = input.cert_chain_len;
 
 cmd:
+	/* If platform is not in INIT state then transition it to INIT. */
+	if (sev->state != SEV_STATE_INIT) {
+		if (!writable) {
+			ret = -EPERM;
+			goto e_free_cert;
+		}
+		ret = sev_move_to_init_state(argp, &shutdown_required);
+		if (ret)
+			goto e_free_cert;
+	}
+
 	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
 
 	/* If we query the length, FW responded with expected data. */
@@ -1974,6 +2023,9 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	}
 
 e_free_cert:
+	if (shutdown_required)
+		__sev_firmware_shutdown(sev, false);
+
 	kfree(cert_blob);
 e_free_pdh:
 	kfree(pdh_blob);
@@ -1983,12 +2035,13 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 {
 	struct sev_device *sev = psp_master->sev_data;
+	bool shutdown_required = false;
 	struct sev_data_snp_addr buf;
 	struct page *status_page;
+	int ret, error;
 	void *data;
-	int ret;
 
-	if (!sev->snp_initialized || !argp->data)
+	if (!argp->data)
 		return -EINVAL;
 
 	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
@@ -1997,6 +2050,12 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 
 	data = page_address(status_page);
 
+	if (!sev->snp_initialized) {
+		ret = snp_move_to_init_state(argp, &shutdown_required);
+		if (ret)
+			goto cleanup;
+	}
+
 	/*
 	 * Firmware expects status page to be in firmware-owned state, otherwise
 	 * it will report firmware error code INVALID_PAGE_STATE (0x1A).
@@ -2025,6 +2084,9 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 		ret = -EFAULT;
 
 cleanup:
+	if (shutdown_required)
+		__sev_snp_shutdown_locked(&error, false);
+
 	__free_pages(status_page, 0);
 	return ret;
 }
@@ -2033,21 +2095,33 @@ static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_data_snp_commit buf;
+	bool shutdown_required = false;
+	int ret, error;
 
-	if (!sev->snp_initialized)
-		return -EINVAL;
+	if (!sev->snp_initialized) {
+		ret = snp_move_to_init_state(argp, &shutdown_required);
+		if (ret)
+			return ret;
+	}
 
 	buf.len = sizeof(buf);
 
-	return __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
+
+	if (shutdown_required)
+		__sev_snp_shutdown_locked(&error, false);
+
+	return ret;
 }
 
 static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_snp_config config;
+	bool shutdown_required = false;
+	int ret, error;
 
-	if (!sev->snp_initialized || !argp->data)
+	if (!argp->data)
 		return -EINVAL;
 
 	if (!writable)
@@ -2056,17 +2130,29 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
 	if (copy_from_user(&config, (void __user *)argp->data, sizeof(config)))
 		return -EFAULT;
 
-	return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
+	if (!sev->snp_initialized) {
+		ret = snp_move_to_init_state(argp, &shutdown_required);
+		if (ret)
+			return ret;
+	}
+
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
+
+	if (shutdown_required)
+		__sev_snp_shutdown_locked(&error, false);
+
+	return ret;
 }
 
 static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_snp_vlek_load input;
+	bool shutdown_required = false;
+	int ret, error;
 	void *blob;
-	int ret;
 
-	if (!sev->snp_initialized || !argp->data)
+	if (!argp->data)
 		return -EINVAL;
 
 	if (!writable)
@@ -2085,8 +2171,18 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
 
 	input.vlek_wrapped_address = __psp_pa(blob);
 
+	if (!sev->snp_initialized) {
+		ret = snp_move_to_init_state(argp, &shutdown_required);
+		if (ret)
+			goto cleanup;
+	}
+
 	ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
 
+	if (shutdown_required)
+		__sev_snp_shutdown_locked(&error, false);
+
+cleanup:
 	kfree(blob);
 
 	return ret;
-- 
2.34.1


