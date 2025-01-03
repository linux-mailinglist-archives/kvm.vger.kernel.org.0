Return-Path: <kvm+bounces-34543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E6E57A00EB2
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 21:00:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17D821884A51
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 20:00:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3BE11BD9DC;
	Fri,  3 Jan 2025 20:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Kpb6Qgfy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06431BC073;
	Fri,  3 Jan 2025 20:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735934442; cv=fail; b=u03INa81rqs570ny5ht3/L+hC5Sbv6KKxGga8poaY9AyL43LAiAq4Exr9cRbdfGQ0v42n6I82v47UZP4OIMVuEhJlenFPLwVWNeN7dzP61u/xhup2lmoNY1fzNfVNtKKTT87nMZ8C+TndXJgL4NGUvOXq0phLCbL286YltWxiec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735934442; c=relaxed/simple;
	bh=wAjzagrjnQYlNz4RahDlYC60WiOzIIh8vYOQE4YSCvA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ETEXILRK+++7xJqfeqpbEZkRiGGAMoYcP6DdbkTzUbFzAImtk6EW6Ie0ekE6QwxDJyhRq9cLL3Q3okk5JDpRDNTkdsAHZE22VAjomNp4rZFJG+2sKvCUUjjtWqK9mzDawzDuOk+AKP1obyRiwGBUZmYP1I8o4eERFZzsjUBWA+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Kpb6Qgfy; arc=fail smtp.client-ip=40.107.223.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gp6wET3ZVd/T7m+a5GphMCSZlcCe0zW0rLf9lKCSRXn06n4dbDB4ZYARyAHiTVrRinZXmx0hUD8/3+9wO7iBwjGmTH6NXfV4N8C8Ll4pEdSu7x5tg5TXGJ1EWWibtRWBifQpLFoTqLqwo7H1tVXqgrcUtVRyRsSqnngO8h3UjGPYzh4affwAXDLHgYC8ROVlNz/kBvDrvjYjpD4RBWa6LkAroBeEvRmtzmweEjceRyENNZGgdWR/RXjqOFmMaMQo6wKukBb4h6iDMBdOkmY7UoihdC0MuMoLllytWmbE7Kqw/CfX2TUe/z7zXiPmncWPrtMsdW50aA2Q8GgNwzLBpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Ul4UykFP1ClnSkG/fx9CZiwqIzhD67N/nKgrRojTP4=;
 b=goI/C5w5fJSGHNEj3Vv1ltpv+1wy2ehuML8NBlRnJxH4aBuiOnQ5LNN3UDJByJrP7Jf9cptKhxyydRCdCxcQtXInoGpCWZ8d7EbwuHfE+PyS5X5lATUWO2Fa1+ov8zUV6p6RnCquR7KCK1nQ2R2t2m2L8X4YbpHVh3XLh68kB01rrBz3PDsgoU5CAd7c4LOenkEEeUnNf3NqnQZBLC8cEtrQ7+IaUDkSfEs97pDyZqgr12hmGIpGuPvTVsQyZCXr09WYrkSr/IZIrIkBuSfQJ7MEGo4WZx7R20heKMvw7UKm7ZjHuapMsUzjl/lkoLpjzhsytEeFRWhWG4MoihGDPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Ul4UykFP1ClnSkG/fx9CZiwqIzhD67N/nKgrRojTP4=;
 b=Kpb6QgfycGX4ZbXA/1HcKJRI0LrN31mhmNEH4SSuH/tcIRIikH8F46aAPWgZymWxtIEtwyAVgTUxcLKke39MtdEicLriQFnOkYiCsgmO4Ecv0iuA3F+cm/hwHn3t43l7rK5u7wXMEwSNvtj4KdK5LWlKB14n1PmbCysnoqKKC00=
Received: from SJ0PR13CA0037.namprd13.prod.outlook.com (2603:10b6:a03:2c2::12)
 by DS0PR12MB7560.namprd12.prod.outlook.com (2603:10b6:8:133::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.13; Fri, 3 Jan
 2025 20:00:33 +0000
Received: from SJ1PEPF000023D2.namprd02.prod.outlook.com
 (2603:10b6:a03:2c2:cafe::5d) by SJ0PR13CA0037.outlook.office365.com
 (2603:10b6:a03:2c2::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8335.5 via Frontend Transport; Fri, 3
 Jan 2025 20:00:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023D2.mail.protection.outlook.com (10.167.244.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8335.7 via Frontend Transport; Fri, 3 Jan 2025 20:00:32 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 3 Jan
 2025 14:00:31 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v3 2/7] crypto: ccp: Fix implicit SEV/SNP init and shutdown in ioctls
Date: Fri, 3 Jan 2025 20:00:22 +0000
Message-ID: <be4d4068477c374ca6aa5b173dc1ee46ca5af44d.1735931639.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1735931639.git.ashish.kalra@amd.com>
References: <cover.1735931639.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D2:EE_|DS0PR12MB7560:EE_
X-MS-Office365-Filtering-Correlation-Id: 32b18807-91b1-4d6b-c39f-08dd2c31480e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gtTIzIm/MkHFnBEtha+nvEO42JFYQS8CR5+RKuWN+p/f6joRym7QdigYFn2S?=
 =?us-ascii?Q?OsZHMZUuFSoG3QMYluwUra9OeZUyUFavj7/ZHHgvxYnTCNCTykYYM/xOYduX?=
 =?us-ascii?Q?PY9eB6y/2mksHocAevrgP/rfXXUnKt65mM2vfaaoORDAa6nSUF/B7JrX7lJ2?=
 =?us-ascii?Q?iLJhdcpsWjm6muqCCep/S0XEBniCMv0YiKyseGZ3+/n36dEOvb4mGk1uLnlZ?=
 =?us-ascii?Q?8SAuKgDC5IrkWkwreO2bM6GTSGdyJIy91lfQ3OU4hUgxoy//wnmZpCaNOgGt?=
 =?us-ascii?Q?KPirltuogyd2mle7E+XbAIcBZ457iSN4TBQxhcYWgc+9c69/F9kwZIY/ICbp?=
 =?us-ascii?Q?81U4TEl4g01UNp0gvo4SULlb3FOM1dO3+1FzIeyLxpwAjXzzCtjGozHc9Lcm?=
 =?us-ascii?Q?vJ39Qckd+Nw8D1aNUmFwnu4wiPCTOrEFmlCIFCU5cYr2IwxSgmNVyLo5o/sg?=
 =?us-ascii?Q?UwGOSzfW6Pl/pRId/8uf9KlQBG6K1J3VQfmE2gGIaCvOzPbuq+rlZQ6oEUlE?=
 =?us-ascii?Q?3WcGGL/22oDXFm0vIXj+VEKG+nLOLirLjb/3qRP8E5e55bn6SfzyNCBD5pQJ?=
 =?us-ascii?Q?GRAuEdPOUhgG9wpVXkn8aOKW7aELt/vmnvNiY1HwbRfopPfD/zX5lzISVgLw?=
 =?us-ascii?Q?S9KzkLggkrNV+tbgNPL9x6GEN7gcU5D7Y1R10vPms4ASWEnABMKbZbt0XrVp?=
 =?us-ascii?Q?/z8Iy3i3wWf25Ythqplc31gYbjZXth/2Io0iXd3c/feI6m0d+9kO8mYVKN+e?=
 =?us-ascii?Q?RGcpORxdyOPannqft9xTKdx0gtblYS7a3PLwo+Qr9Ur5EPL05EA225FP9K6Z?=
 =?us-ascii?Q?W5g9h8Nb+yjojt0JzutjinB++7Q6eWIZgctYWnyY1EGlBFB6OdJZ70Wb2ssl?=
 =?us-ascii?Q?bSwM6GADlgePChVVhCHFWwcdWg6kmQ+KzVjoqoOwvZJC8x4+ccEXaeALsflc?=
 =?us-ascii?Q?r2SPVXVHaN4QKdI7br/HAQI8X7KFGeG30qhEU4pddQpk7b+xc/EYIulDQJFl?=
 =?us-ascii?Q?BFrhcJrCAc5J2tuPTwEpVXKSdvhxT3wnlfMUikJ3RROWd0nGeDYXn/51eGMC?=
 =?us-ascii?Q?YToRAnZqdU2NWECfHrbYw9OEI0JyLorLkyJtUDERI8UDHyfiheTYAUEL2NgL?=
 =?us-ascii?Q?u4KDuq4AXaTtyl2QaxWUI/yba8ebJHM5KOqu3B0dc/nLza1Ii41kCsc9cGa/?=
 =?us-ascii?Q?ZJ6NXcE25maRuqsbnFZ251FdJv6n/hJS77Gec8OQGYQK+SQ0D7xKB5uGzqvI?=
 =?us-ascii?Q?KF4zrLKBL7bdd/3qRsxnLPaulY9ljylKZumVrpbDmfNNYYwZVsx1Nh/XIMYN?=
 =?us-ascii?Q?i9xemvh7Ib7Ra5qJ9V/RB8QTXVhKcnD6g3yZCpr7+e0sKT2k1h3eUKQwJA2e?=
 =?us-ascii?Q?AO/KiOn5KuYsdJj5tw0uWg//1jiCCaiWD7Kw1C1HO2XKGHRj/O2sSz+pNzPU?=
 =?us-ascii?Q?b58DV433CbRrZRZLZG2WGQF9m2YOeD4DYyGFiw2TuftitWcqvjEj7JZ2Tkce?=
 =?us-ascii?Q?Qp57oONxd5eoQVdqYD3kT9A98VpWf7psy2WO?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2025 20:00:32.8862
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32b18807-91b1-4d6b-c39f-08dd2c31480e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7560

From: Ashish Kalra <ashish.kalra@amd.com>

Modify the behavior of implicit SEV initialization in some of the
SEV ioctls to do both SEV initialization and shutdown and adds
implicit SNP initialization and shutdown to some of the SNP ioctls
so that the change of SEV/SNP platform initialization not being
done during PSP driver probe time does not break userspace tools
such as sevtool, etc.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 149 +++++++++++++++++++++++++++++------
 1 file changed, 125 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 1c1c33d3ed9a..0ec2e8191583 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1454,7 +1454,8 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
 static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
-	int rc;
+	bool shutdown_required = false;
+	int rc, ret, error;
 
 	if (!writable)
 		return -EPERM;
@@ -1463,19 +1464,30 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool wr
 		rc = __sev_platform_init_locked(&argp->error);
 		if (rc)
 			return rc;
+		shutdown_required = true;
+	}
+
+	rc = __sev_do_cmd_locked(cmd, NULL, &argp->error);
+
+	if (shutdown_required) {
+		ret = __sev_platform_shutdown_locked(&error);
+		if (ret)
+			dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
+				error, ret);
 	}
 
-	return __sev_do_cmd_locked(cmd, NULL, &argp->error);
+	return rc;
 }
 
 static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_pek_csr input;
+	bool shutdown_required = false;
 	struct sev_data_pek_csr data;
 	void __user *input_address;
+	int ret, rc, error;
 	void *blob = NULL;
-	int ret;
 
 	if (!writable)
 		return -EPERM;
@@ -1506,6 +1518,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 		ret = __sev_platform_init_locked(&argp->error);
 		if (ret)
 			goto e_free_blob;
+		shutdown_required = true;
 	}
 
 	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
@@ -1524,6 +1537,13 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 	}
 
 e_free_blob:
+	if (shutdown_required) {
+		rc = __sev_platform_shutdown_locked(&error);
+		if (rc)
+			dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
+				error, rc);
+	}
+
 	kfree(blob);
 	return ret;
 }
@@ -1739,8 +1759,9 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_pek_cert_import input;
 	struct sev_data_pek_cert_import data;
+	bool shutdown_required = false;
 	void *pek_blob, *oca_blob;
-	int ret;
+	int ret, rc, error;
 
 	if (!writable)
 		return -EPERM;
@@ -1772,11 +1793,19 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 		ret = __sev_platform_init_locked(&argp->error);
 		if (ret)
 			goto e_free_oca;
+		shutdown_required = true;
 	}
 
 	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
 
 e_free_oca:
+	if (shutdown_required) {
+		rc = __sev_platform_shutdown_locked(&error);
+		if (rc)
+			dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
+				error, rc);
+	}
+
 	kfree(oca_blob);
 e_free_pek:
 	kfree(pek_blob);
@@ -1893,17 +1922,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	struct sev_data_pdh_cert_export data;
 	void __user *input_cert_chain_address;
 	void __user *input_pdh_cert_address;
-	int ret;
-
-	/* If platform is not in INIT state then transition it to INIT. */
-	if (sev->state != SEV_STATE_INIT) {
-		if (!writable)
-			return -EPERM;
-
-		ret = __sev_platform_init_locked(&argp->error);
-		if (ret)
-			return ret;
-	}
+	bool shutdown_required = false;
+	int ret, rc, error;
 
 	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
 		return -EFAULT;
@@ -1944,6 +1964,16 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	data.cert_chain_len = input.cert_chain_len;
 
 cmd:
+	/* If platform is not in INIT state then transition it to INIT. */
+	if (sev->state != SEV_STATE_INIT) {
+		if (!writable)
+			return -EPERM;
+		ret = __sev_platform_init_locked(&argp->error);
+		if (ret)
+			goto e_free_cert;
+		shutdown_required = true;
+	}
+
 	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
 
 	/* If we query the length, FW responded with expected data. */
@@ -1970,6 +2000,13 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	}
 
 e_free_cert:
+	if (shutdown_required) {
+		rc = __sev_platform_shutdown_locked(&error);
+		if (rc)
+			dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
+				error, rc);
+	}
+
 	kfree(cert_blob);
 e_free_pdh:
 	kfree(pdh_blob);
@@ -1979,12 +2016,13 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 {
 	struct sev_device *sev = psp_master->sev_data;
+	bool shutdown_required = false;
 	struct sev_data_snp_addr buf;
 	struct page *status_page;
+	int ret, rc, error;
 	void *data;
-	int ret;
 
-	if (!sev->snp_initialized || !argp->data)
+	if (!argp->data)
 		return -EINVAL;
 
 	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
@@ -1993,6 +2031,13 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 
 	data = page_address(status_page);
 
+	if (!sev->snp_initialized) {
+		ret = __sev_snp_init_locked(&argp->error);
+		if (ret)
+			goto cleanup;
+		shutdown_required = true;
+	}
+
 	/*
 	 * Firmware expects status page to be in firmware-owned state, otherwise
 	 * it will report firmware error code INVALID_PAGE_STATE (0x1A).
@@ -2021,6 +2066,13 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 		ret = -EFAULT;
 
 cleanup:
+	if (shutdown_required) {
+		rc = __sev_snp_shutdown_locked(&error, false);
+		if (rc)
+			dev_err(sev->dev, "SEV-SNP: failed to SHUTDOWN error %#x, rc %d\n",
+				error, rc);
+	}
+
 	__free_pages(status_page, 0);
 	return ret;
 }
@@ -2029,21 +2081,38 @@ static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_data_snp_commit buf;
+	bool shutdown_required = false;
+	int ret, rc, error;
 
-	if (!sev->snp_initialized)
-		return -EINVAL;
+	if (!sev->snp_initialized) {
+		ret = __sev_snp_init_locked(&argp->error);
+		if (ret)
+			return ret;
+		shutdown_required = true;
+	}
 
 	buf.len = sizeof(buf);
 
-	return __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
+
+	if (shutdown_required) {
+		rc = __sev_snp_shutdown_locked(&error, false);
+		if (rc)
+			dev_err(sev->dev, "SEV-SNP: failed to SHUTDOWN error %#x, rc %d\n",
+				error, rc);
+	}
+
+	return ret;
 }
 
 static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_snp_config config;
+	bool shutdown_required = false;
+	int ret, rc, error;
 
-	if (!sev->snp_initialized || !argp->data)
+	if (!argp->data)
 		return -EINVAL;
 
 	if (!writable)
@@ -2052,17 +2121,34 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
 	if (copy_from_user(&config, (void __user *)argp->data, sizeof(config)))
 		return -EFAULT;
 
-	return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
+	if (!sev->snp_initialized) {
+		ret = __sev_snp_init_locked(&argp->error);
+		if (ret)
+			return ret;
+		shutdown_required = true;
+	}
+
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
+
+	if (shutdown_required) {
+		rc = __sev_snp_shutdown_locked(&error, false);
+		if (rc)
+			dev_err(sev->dev, "SEV-SNP: failed to SHUTDOWN error %#x, rc %d\n",
+				error, rc);
+	}
+
+	return ret;
 }
 
 static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_snp_vlek_load input;
+	bool shutdown_required = false;
+	int ret, rc, error;
 	void *blob;
-	int ret;
 
-	if (!sev->snp_initialized || !argp->data)
+	if (!argp->data)
 		return -EINVAL;
 
 	if (!writable)
@@ -2081,8 +2167,23 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
 
 	input.vlek_wrapped_address = __psp_pa(blob);
 
+	if (!sev->snp_initialized) {
+		ret = __sev_snp_init_locked(&argp->error);
+		if (ret)
+			goto cleanup;
+		shutdown_required = true;
+	}
+
 	ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
 
+	if (shutdown_required) {
+		rc = __sev_snp_shutdown_locked(&error, false);
+		if (rc)
+			dev_err(sev->dev, "SEV-SNP: failed to SHUTDOWN error %#x, rc %d\n",
+				error, rc);
+	}
+
+cleanup:
 	kfree(blob);
 
 	return ret;
-- 
2.34.1


