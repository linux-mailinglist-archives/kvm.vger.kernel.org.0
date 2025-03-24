Return-Path: <kvm+bounces-41862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 671F5A6E573
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 22:19:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 964C716B977
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 21:15:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AB2C1DF98F;
	Mon, 24 Mar 2025 21:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="I/EVqmXb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7675C1A08A3;
	Mon, 24 Mar 2025 21:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742850893; cv=fail; b=VRzveiytmeX5ofPHyLFG62BU5ISvdJBx/X2HIrgNYj22zDslaZ80KAf+WSzSrcZJvVrCHw8r4xHbnSzXlwY6x0gsZhSJCaNQdjhvPDFCWZA3TIqaJ+ORFj/b2IxW34ACw3Y5koZNc2oOrJmP0BnpqfFm7z7MHhPQVcADRsjIX0I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742850893; c=relaxed/simple;
	bh=r88t7cWlUL/wkN5u0Kyd+udlHlIB5Fh+4lyrX6kdb7Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mP2CzASU9U5nIFbv6/5jq9peHTIdO89wu/ZjlGr885UFxvW2KM+15+7FmW7/TfbKboHthng8Rn5OtGQxd9BSOvfbfh74UGq2dkh7CRfBz+JpYZ9MxYdBVYuwWoIKsoXhyid8BRQrvkCY2EYw67bmjeeNjyHX53IJ51KWlUJzfiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=I/EVqmXb; arc=fail smtp.client-ip=40.107.93.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TxOjNbIpowWk4WjFTWs9ZMVMxhFkWSGBNwJpjaClsarjdHXmsWtSZOKLPOidjWSF57OdjU2+H9d0j3l3dqhdajxDY/ED1MYhfW9iMRdvdxVIazvURyX2E6lCKjyYWJYolMYZZMultemLsmfIIUd7Qw7w1O2BmJDAKIJ4v1D4maXJ054Wm1HSAH2hHd994DSzj45Pi9n65HO1KkESqJVlIBT9wfx0PNaGbj+RpgI5gKE+V79gNStEFIZxKaQDUSC+B83/Ri1t0bHeZqvpY4vjWPSH3njv8xOkwdAtDNH8ugb1gzfnUIJJYqjtHe4mevxqRfbQ2Kh0DYvGDIszSXQriQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OxIrmM4rlTk3cAK4avX/LEw10PN9GAED7Xm2gibrNeg=;
 b=OfwYTF/GJHTlR+HUAo8ggnZiQIMEczRg8gkTdzYAKlzOPJM6BpOtffSLAFKqJJwxMxJWjSHSsPemDt7qk7JNN9Gsn4Xt9zYUj6VvjNnTtfbSfOybpDhKfEhxTbiy5WLKAKtDPKsR0KPuStjsjfLcThKz0cIt0dp0PTiFtCVIrUrSWwX7c8wMRxXHkYDfdgyMWlgWpUWGal7a3EAudvaZAB81oxnv2WqzZRguZY/srcIe3pUgdAw4WLKfwAcI5+AJwn9waWK2TtpZfom/Y867xwG2feiEnMelyGT8pfPCgZn5PIekXJDBnJlBdhQtsfy2GGNxsE5hykbxC6f9Ax66PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OxIrmM4rlTk3cAK4avX/LEw10PN9GAED7Xm2gibrNeg=;
 b=I/EVqmXbaWs5PYMzmM5+0/xFui2+SJ5U4fRVdXVYK4VjIg9OXb1ahxrxl6gKrWMpuOC0+bfrXJ3DYZZOg6jRrRcrrudIjS4HsFe42CnlNUgPta/OEkR5Y5OL+W3kQ+cKS7lhP7Y/LQ65x2MyKJ8F76pyzjw9+JzBwvzWKx5/X4k=
Received: from MW4PR04CA0361.namprd04.prod.outlook.com (2603:10b6:303:81::6)
 by CH3PR12MB8728.namprd12.prod.outlook.com (2603:10b6:610:171::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Mon, 24 Mar
 2025 21:14:46 +0000
Received: from SJ1PEPF00001CDC.namprd05.prod.outlook.com
 (2603:10b6:303:81:cafe::4d) by MW4PR04CA0361.outlook.office365.com
 (2603:10b6:303:81::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.42 via Frontend Transport; Mon,
 24 Mar 2025 21:14:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDC.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Mon, 24 Mar 2025 21:14:45 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 24 Mar
 2025 16:14:41 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v7 3/8] crypto: ccp: Ensure implicit SEV/SNP init and shutdown in ioctls
Date: Mon, 24 Mar 2025 21:14:32 +0000
Message-ID: <5ac18efb6be6e26904c24f6a96cc7080c4c47876.1742850400.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDC:EE_|CH3PR12MB8728:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ce3f839-6e85-4f82-70b3-08dd6b18e72b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|36860700013|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8+kpfcpua++61j+eny1aNeab0MuGkQ2YqRsn24GFL5bfEusZskgBqQzXHNch?=
 =?us-ascii?Q?P9UBt8M8A/K+0pZ+PI7AMvunvjzdBev9rqGh47LKeVM43zLlVXtwPSdfYHdK?=
 =?us-ascii?Q?oPlQYRJYVQMHr8Szsf6uWGrur3QpmmKexaoWZ4Wgr4uo3UV/RBj9svl8XDlO?=
 =?us-ascii?Q?iEsvOkIKhnLMa1IvCd5Tlpp7EzPYN44ESfNsmPPAWOhkIIixEbnLJ0bofM3e?=
 =?us-ascii?Q?gOb91cZsnoVoNgOkcIOsRzcxeG3elHTe7NxDt24L8b7Jwxbxb1BXxDpk4YPI?=
 =?us-ascii?Q?BmYYg+FhyU1+dCGFCXhC9Bd5IIAxiC420pKP78RcixCzZ3xfF7pZUbWwzalt?=
 =?us-ascii?Q?m2AQjseGMRr7KCHNKclivbpGwo5xNSVFQAWkCHNhdhSVShuOq/9uYPET7wad?=
 =?us-ascii?Q?mPb3OVxWlCC9j8dosdcbOHTceSRiHcfe8n9NSzkdOKYZDdFE0CLTwjTY3rKz?=
 =?us-ascii?Q?NZGWZXn8+2FemXDNNbs2u2/OhC7E6kwtGCjL95u0+zfwlNIR7pJdMnuLwTJv?=
 =?us-ascii?Q?vXW2FWh9lsV+1LjzwDtFoNpoUNBkiLw2+LGN1EDtCmjAIqUk3Djho4q2reXo?=
 =?us-ascii?Q?PCOkUrHPW5GbSK5d07CclH6M1m8q+uimhakzAYO28WtCEPGWVfysLg04sSrY?=
 =?us-ascii?Q?Qbb6NR5p2yQaL3XFG5Az4xSVuwLNtV3sNcWu5y1ogJlSBsxijTMLoq+j4eXu?=
 =?us-ascii?Q?OPufijYaVVFDmtJlZo86r9QwAAkXgPaDfwtXGzQdDQcb/4d9PDM+flwGY8PO?=
 =?us-ascii?Q?CVQJJSUliXU19QTukLSm0hX/kFQSMa54IdZ9MLxOWnfedQITEeY3p08DLBjV?=
 =?us-ascii?Q?ndnMalT1BBmq22eC9ucZilujAkQFZR7hzCTglg7V5TmJdPnv2xAHFL5HX7LB?=
 =?us-ascii?Q?8+i2o/DEuVuHWBWYXuTUHogXfqlan4LYExK3I2KDbCVswYvk7goE/s9zvQ88?=
 =?us-ascii?Q?zXBT/8uv4hzW7oE9Qk6/UXRDnYNinohYmZFMvTtFRmWMb/tqo8BnEg5dQyPg?=
 =?us-ascii?Q?xKgxe6UNR8ggWJed0lwXrsUjktVVsQLiyzkQC/iAC7c6bdcX0c0LCCxmG5Q9?=
 =?us-ascii?Q?Q3D2P0/4gDCzOYuFAbQGscbjx0MHmg/iQLcJUrFeiv86XmPknmm0RZM7H8ql?=
 =?us-ascii?Q?g0CcfSNYUOfGZYukzIBbCiQ1ZcBibbouYiN4jbFQXbyWVhIxyEkxdhwU/Gvg?=
 =?us-ascii?Q?MyPg9j1G8/SisluJti9FEr5KpMrTCL9EB+gNmzMGBhrLxjmPt2/LWOJZByDM?=
 =?us-ascii?Q?hunmrak+w4GX7D39YhxStMKI3hP7MnUsWb9pCjwHIR50+jLgslIC3AtZ59Nw?=
 =?us-ascii?Q?dHjVLUReAJIRvCcAzzoxLBNhVRHimAsVgIB/BeEBKxUH8Y4SByhg/eYDvfz4?=
 =?us-ascii?Q?vT5af4u/IsaDbq5jFiOzXGGAjau40ur/09A2LNUNuWm1DOLIT9Jhwmt77l5/?=
 =?us-ascii?Q?QgCcb+kkzX/1dvp+jjzp+is8g23yL2WwsZ4PAr8peC1wsq5Um9MQOWwUQq8c?=
 =?us-ascii?Q?qmVayQ97hegDTpX39+46T2jgsZZYfedockoi?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(36860700013)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2025 21:14:45.6843
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ce3f839-6e85-4f82-70b3-08dd6b18e72b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8728

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
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
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


