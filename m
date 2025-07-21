Return-Path: <kvm+bounces-52986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C385B0C5F2
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 16:13:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC475189399D
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 14:14:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E81E2DAFA3;
	Mon, 21 Jul 2025 14:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5X/Xmkcw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2081.outbound.protection.outlook.com [40.107.223.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1188A2DA740;
	Mon, 21 Jul 2025 14:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753107191; cv=fail; b=gvoektqdzKtGCs211cjojsiJD3Og+gnrEqVz6CnGq4z+18EVtLR0K39izVAs4yoof2NNxBF7vlPHxyOuXkEO+ruB+IYEO3bGe8sx4kmDDJRwpGatSGWjNQKHROyZkp9WBNiBWG5hKJYnx5fANskOdrH7cuOnXlK6uJdDLPKih5Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753107191; c=relaxed/simple;
	bh=6qWq0iY1vj8BVVAWKLvKpxS6hB4nytt/u11JQdBH2oc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qar5BtivfSYHkXj3dP0EkAsZegA2dEYjY9RHxWxcObdJk9l+afCfcWdoPgk4x8ycEOeRTOosiJsd+tSjvh/6e9w3CWixkCn1BJBcgj8CmbiTjZmD0qbQTExRmvoR3I0YjuPFw5MQk6dlJtGJ9wgT0XPHT/9X6PhG0NV/+sngR4M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5X/Xmkcw; arc=fail smtp.client-ip=40.107.223.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r+p0vogrPoslcnkwEwHewjj++IuR+PgOLJbzplUS/V+HDDFjP2cm6CaSF8LDRtzhEVDxHh+DHkEbej/bnDhkbsPh890GZTXCBflHRGITZrUXCJ/7CTcmrYTJRPZwUsjgsgvmDF/x2eV7JXPJmEzrTiNGApiWNoqEbR8g9y/MrnKGmv7KsnI+wh2WOGUaZ+aKWw2rFyI9QCvqDpn2v0Ixv3e82d2h/7uU3YS+M5r3YsueXsfcu/K+Db4FftJGMZmbb4wgeHpu6Xoc0xySMb5KZMWxVKece1tHbfAkAXrYCtQmnlsiaFSz1L5E7K9If1NrgOl/+m5gQ+H7zkqZ9tnaAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KmVMMcDneRK2iE1QcHklTDa33H/bBW96LFaSTQxc5nA=;
 b=j5fO5d+awdNFxIsxqgS4EYMKtGASP6nNLDbwHpxGFh8vy1RGkWNWVkQxHUXSIruj/b/Ia6pO0TvfFvqOBdLZe8ysii9nEkDuYm2xm3Nq2bTbROmc1HqppCW5sXM1smvfpjDKMiqmdeKMKi0p+qh5nXDNJzMvWS5i8pbKrFVpnVSBjqpbEBWOH8lll5bUTBfmMftZYjyJEwi0Ka3ZxNxAVXB1gMW7xLaU+V/ItS1a3H5X8uiG27VMYCAdouJ0Ak8pVn9dM57lWtOd+Ht0Otl9j7P1IIygJDKxPDzLnfnXo3k/+63jfaRH/VDsE/ptlRMNAHMfZyxwdyvYhg+IDpzo8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KmVMMcDneRK2iE1QcHklTDa33H/bBW96LFaSTQxc5nA=;
 b=5X/XmkcwJ2rDGVM9l4h3lfE4CzZo67E7/hYHkLqT3bEOLCxzZwmOuTD5lgXFdUQCAoAMl76WZoSu1e7J+dew9V95jSW0RREm9X+OCLeE8yg9NZf3n9I4ICia0vfKT9M7nDAwH6ljbKCJk8OI3p3t2Pd0HBx2Qa7wna+PK6lz6/o=
Received: from MW4PR04CA0329.namprd04.prod.outlook.com (2603:10b6:303:82::34)
 by MN2PR12MB4488.namprd12.prod.outlook.com (2603:10b6:208:24e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Mon, 21 Jul
 2025 14:13:07 +0000
Received: from MWH0EPF000A6730.namprd04.prod.outlook.com
 (2603:10b6:303:82:cafe::cc) by MW4PR04CA0329.outlook.office365.com
 (2603:10b6:303:82::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.29 via Frontend Transport; Mon,
 21 Jul 2025 14:13:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6730.mail.protection.outlook.com (10.167.249.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8964.20 via Frontend Transport; Mon, 21 Jul 2025 14:13:05 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Jul
 2025 09:13:02 -0500
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
Subject: [PATCH v7 2/7] crypto: ccp - Cache SEV platform status and platform state
Date: Mon, 21 Jul 2025 14:12:51 +0000
Message-ID: <dc31da612d5735f4765c47b5d9e4ebb704f392ee.1752869333.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6730:EE_|MN2PR12MB4488:EE_
X-MS-Office365-Filtering-Correlation-Id: c79e4e61-5591-476f-9a4d-08ddc860b65a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4X0XVr9RekMzdC7v6t878+1qoc/qjdLOFuV1xWUuRJnildlzNpV4aiZLoW4p?=
 =?us-ascii?Q?2Z57xGKGADlQaN4xzTn6zERtMeQzefEA/fXgDO+oEQJnRIzZyJpuOayZkyZf?=
 =?us-ascii?Q?+A+6C53/fqGq1wJRdyS+r+NYBCq8900PmWRp8DI7246rbP8w4D02D1af1EoT?=
 =?us-ascii?Q?3NxWN39FX8YculpGbUuu1OKAGprgf7EVOQxxaWeAUztbSRpi+l/LTvS8+sFY?=
 =?us-ascii?Q?yckG+bG26zW0ZHh/i3AvtEsAO9YzJGrcWZbKa+7C/iRto2uOEDaA7X7Qe9Gk?=
 =?us-ascii?Q?hYhCjpa1dcoBBf87vB4nfujV/QPNTxvVPw42+V/nWFF2wxgDSoVHqjKXu/Kd?=
 =?us-ascii?Q?8J256subid3sMXuQ3d0QkpwRrn/aFpGSDRWH8Y3wNZMYqTwAXxU7+4BzBn9s?=
 =?us-ascii?Q?6rQD/tW73T80bCPEetEW0IzMaeUCHlYOAhzDqCIj+2FjauxhrPXU3Wis3dYV?=
 =?us-ascii?Q?Ii8ZUPhkVK4AnCe0+nsqeZMOeaygtQ/5MfE4SW6YCNTvlSJ3ycgTdykr6vtz?=
 =?us-ascii?Q?HVnRVrnpwOpIp1Nia5GSNn2IUfr1tfPCUWZECJYqCyWet3s0oRB9+p3YeUBN?=
 =?us-ascii?Q?gPhB0feHKZyKIQfw9JdKvSLirqtUu0YRToCJoSerBWjStd5QdSqZGor87npZ?=
 =?us-ascii?Q?EhkXYgB22s5jOa4S0+Yh+Wx4GzdwzoRzymaqYqO0DCbCy5gaoNTr5evb+kWY?=
 =?us-ascii?Q?LGOj5Z3QiRO5GwPH377r+mC/YKDQ4M1Hf0WOeKhika8x0EtVWn3MbrCPPaEb?=
 =?us-ascii?Q?ToYNl7Ao/yf8J49ZAuuRKjgNwO5zxXke/O4bVFw/UB5OtZMoaTQSZn+bjMuU?=
 =?us-ascii?Q?Mf6gXVqQuzo0mltvu2yaxr/FFvx+kOKYukdIsfGscEdZ3P6HMinK19ZJdEj7?=
 =?us-ascii?Q?BgYZjNNrntYTCdq8d1Q/LV7Ox0EjOVibBEw6PIAeNm1N/iLhF4dGQySUSMu/?=
 =?us-ascii?Q?wBGtpMeSmt023329ee44K1rR1v/HusJtPwSMTvnJUt0lUW6pzhyrLdtBBlA1?=
 =?us-ascii?Q?pEOFeM8wdm4AlBEho5azuUaShmGE9k4z5RKIAnZoZvK7DZL4qIlQ9rKWoJ7o?=
 =?us-ascii?Q?5q/wvhYFOY4gID6fCWJ+edIY87qZLZuLVAmn3alCTTuj76lh7kq5qHbjHjMq?=
 =?us-ascii?Q?OLEpL7XE5JZjjI6RKynXZ44rLSpiMoOXSF1FBo9TucRRS6HDZt2RtZPgWJmF?=
 =?us-ascii?Q?w0LdLqZ31fqJ+w0wYa+DKqeQ/MpSLGxZS4utcHl2PuSDzmS2IAenNl38C93L?=
 =?us-ascii?Q?0G6vL4CyRjbWJxdE27YIAwhcAJENo05X/DjXhgwJ5JXfk0VkMau4rUsuwmtc?=
 =?us-ascii?Q?R0PmA0ufhxJM2pjLWHAymPXKJrgut/9ytrSNdaAZsGJg0qE7Iccee1A/D1yz?=
 =?us-ascii?Q?BqO3r7gwJc53ziscFAeoOzJDBBU1bCxE5+j7abzHDkgY9/irYbGdDHWpqN+M?=
 =?us-ascii?Q?pt4mVHphHqixhvE2dR3jN/TVuMRaDELAp6wl0NCHiXhGlAUHqFJ34zghnKOe?=
 =?us-ascii?Q?4iqRmZbTx5AvVMGxwgvxK1FmbjTR4puApBz43q2lYRal5KawDLYxT6Kqpw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2025 14:13:05.6937
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c79e4e61-5591-476f-9a4d-08ddc860b65a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6730.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4488

From: Ashish Kalra <ashish.kalra@amd.com>

Cache the SEV platform status into sev_device structure and use this
cached SEV platform status for api_major/minor/build.

The platform state is unique between SEV and SNP and hence needs to be
tracked independently.

Remove the state field from sev_device structure and instead track SEV
state from the cached SEV platform status.

Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 22 ++++++++++++----------
 drivers/crypto/ccp/sev-dev.h |  3 ++-
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index e058ba027792..528013be1c0a 100644
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


