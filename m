Return-Path: <kvm+bounces-38598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 29832A3CA67
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 21:54:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E24091892F20
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 20:54:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 570F124E4BE;
	Wed, 19 Feb 2025 20:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BJGXvmg2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2042.outbound.protection.outlook.com [40.107.95.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D4324E4DF;
	Wed, 19 Feb 2025 20:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739998404; cv=fail; b=Cd24r87L+N6rzn3NaRGbp1+/3Mg6IiZX0uJgR8KlwEe3wjqezeB/FHhqiBDEGO1bbIb1cPTNVtrFqCvDVCw8nC/BFgBHi5yiuMFd3y4k/7zD1/6q7bnb0XflirWg7G3Ki0dzV167SdAxuPvNMVeYw4u55DEdkESg9Bl+oV6cpqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739998404; c=relaxed/simple;
	bh=lVTZpvyoSUkrzmOCJIEqpuj0D2xl84NArtg0EuDc5zo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZibRPYx6QAjLjcfKrP3FhE8loSq4FuKj0BE9EuqRDWt9/8wdvWCrwHG78v2Rfqq07L6W6mZrk+aXZedrAU4bDwb05q1kCSd3fNGLwAJwVP4qlENnRLXDwrg8rB/LbJ3ftd6gH3U7xf42jtQ1WpYwLEwBLymswC7hvnjgFVPqfu0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BJGXvmg2; arc=fail smtp.client-ip=40.107.95.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dIhl5+vOPUedeCEJVvn+ploJuhNbBSZEy5/vXeLOec2FYUDBvSedF3ZqRMSazKc7LhLTLEEcyH4CGhy0KqcLZQfqMYwqc+zA9kCYmiXm2V89rY0Uvonx/083dDVuQYwNLbpvRRfw0J4kMH4+HT8F+neAOcRapNBhaKI2a1mEzYAueuHCpVhuG/SgNgyxSkO4rnMv0amHI/y2DRp2HFL4XkKAej3RJFwbc9AuXUMQWcsx6B47SXUy8IYtWdc/G6sV3Qm/W9t5anpS0AInsi3SYcsvwtCHMJeRltfBfENCzt84yglwCHRLJGke+AaViXbr0LYZNzi1dW/gpcHR1Ooy4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HJWPtt5PbtmZfn7LOlE8UFgnhPVCPyJ4vf7z3j6R5Go=;
 b=DpCDvhkjNDl98t/IMV7WOpz+p7sV++kvGNL8VLTHRLh4F6ypaVIG6v4j56BlZbf1R8RDMkmTfPBROBz96xFW/76XjGJOw/g2eT0q8gPq6ygXBU9lYDVa2XW9qo721oDRz0LH4Lckq33/2VVJd0Fu0R4odL7MVXsmYa2z7SNCq8gV95vMpux/wgFjBdtRzQwsIuacpysNaDI/YAR6FE7RV5wl6FviJtXaRbk+w2+O9ogWmQEjQThyW4NaEz5rmCeyocAnVRZyRtodGhupTYHZ6SIa4coP1lZS3NfOaooxR6uyDY1Zm3xMMBDmfTJ/4kJLBrgo6vP+BPMxS94Lt1t9cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HJWPtt5PbtmZfn7LOlE8UFgnhPVCPyJ4vf7z3j6R5Go=;
 b=BJGXvmg2w7tL016J9SNKVUSu4EOLbapILSxZmAdcz6ohmm6kvImnd5oGPG5lxOo1OU0c0RxxECGh5Pcv6koigAtJDGhIit1V6dCApu+a+r5Z43DSkIbuoLs3+qRQ01ZOcN4ZLHUIkQFJxI9rmLFTqV1nwTJtqiBSAGEOA6MOONo=
Received: from SN6PR2101CA0005.namprd21.prod.outlook.com
 (2603:10b6:805:106::15) by MN0PR12MB6152.namprd12.prod.outlook.com
 (2603:10b6:208:3c4::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.14; Wed, 19 Feb
 2025 20:53:16 +0000
Received: from SA2PEPF00003F67.namprd04.prod.outlook.com
 (2603:10b6:805:106:cafe::4) by SN6PR2101CA0005.outlook.office365.com
 (2603:10b6:805:106::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.3 via Frontend Transport; Wed,
 19 Feb 2025 20:53:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00003F67.mail.protection.outlook.com (10.167.248.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8466.11 via Frontend Transport; Wed, 19 Feb 2025 20:53:16 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 19 Feb
 2025 14:53:15 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v4 2/7] crypto: ccp: Ensure implicit SEV/SNP init and shutdown in ioctls
Date: Wed, 19 Feb 2025 20:53:05 +0000
Message-ID: <f1caff4423a46c50564e625fd98932fde2a9a3fc.1739997129.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F67:EE_|MN0PR12MB6152:EE_
X-MS-Office365-Filtering-Correlation-Id: f7b37efe-b56f-4cab-340f-08dd51276ef2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|82310400026|36860700013|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+jNFduSN0yZSbPINO9Fe/T19l529YAU5OrsATGFpnnI72aa68ExwVwfY49LM?=
 =?us-ascii?Q?Do5ypcESSeNvm8R6+mXNDY/cTAGbFkP7A2XgtKOYgX1JpbSO3aVADtVyw+Q0?=
 =?us-ascii?Q?Ga/mxoQfVac1Vl4E12JnxnxSm6eJ4wbOEJtPBTQBs9cMdSswy0m4rc6Hpo8L?=
 =?us-ascii?Q?GFGdDuoYbHVweJZf+yWZd/WGw/ph7opz8qZ7Q6XES1kE2UxoY3GkL98uw9I6?=
 =?us-ascii?Q?l+uiRjTWFeQoYyx8zhQIkFY0hbECDHuGtsxemakIkV1OhYDN46O/B3B0rzYj?=
 =?us-ascii?Q?sA1G8x6yRlgXoxbQNiHZmpt+KKM9W/wVmgWDw7HyBQWt3CGWTTXu7GLzEaco?=
 =?us-ascii?Q?J1D7lz61OdZ9woTUw/KzDsNIhp2KwsdQ7UXAS3zSlgh06RJ5UMLK9RCgblfJ?=
 =?us-ascii?Q?msncAO2kK2jzj8ygaWtiDFdUWV48Bc0n55yESk0SHdTibtUu4qOWUwDOSIGR?=
 =?us-ascii?Q?BbRBnO/xzm54MR0r51lEy2pHw9U7NUawE03j1ZyfMZGvZCh2YlqLwk10oaKx?=
 =?us-ascii?Q?uop7SzuSfSIT5W5B8bbDQzU4UyWkr4AavL7RdrhzTHuWJ8w1ruQ7EQpUUAIz?=
 =?us-ascii?Q?LHlWEMV3B7xuBYGyUc1IdhjQSzFJnLW91d8Io/I8fevQh7ULdiPPAIiBu/ck?=
 =?us-ascii?Q?YsVTqu2MeoNTrG3ckZcPrAuX0uBUAc830No3y5GFOzmOzjp63QYyExmeHEF7?=
 =?us-ascii?Q?Em5u+ztNi/7HBnOggeHkAB26mhdm/6/NnFJ5pXs0FkhSTdSbQo6JatSvx3Ix?=
 =?us-ascii?Q?olo8T2P0aqMex+MiS1YI6j0GTYOodaooRNAZUl1fIcn+nYRMxyQS5YYgikcn?=
 =?us-ascii?Q?qmBuE7abXKwIKoygVopIUa0kxKRuTOzCC0EMYauKIpx7vURN1KAZpYuZv4Hi?=
 =?us-ascii?Q?Y8bNuhD0oWKGcib1454VFT9LvOHzGPgQQdOa9z8+ciXtiQ6XjXpuECFyO3ic?=
 =?us-ascii?Q?bRJdqS3WLgzrOZqVpaXldD9pF/KbNaPNIkOLQMIHYjzla9gEl/0WqbDCfCje?=
 =?us-ascii?Q?Rng/dbfSZ9SjO+P8yoVCOsyjgP9jBAdQbu7OHDkOQ30jLI3EaqmT5+LOOwZR?=
 =?us-ascii?Q?cW0txlDGKicBwtIZ3YlqpxmknZesU/Ot5bVVhNS/jkFhz62tSx1I0UfsUj/v?=
 =?us-ascii?Q?STq8sGef+tuom/YVN3OrH+TSVVBunM9eGvui7tE3vj73P+PGwly6N4na/Guf?=
 =?us-ascii?Q?ulO7CZOZLbV8Xk7klOrQC9CKkE6mdg4Sz4Gq9B9+mojTywKxXagvcU0Gqucu?=
 =?us-ascii?Q?bDrraayIjdbj0ZWuGPx0cK8aSwStEBIvea2134w5x08v1XqU+XVUEdytZlwr?=
 =?us-ascii?Q?hkgClB4VfmBiQT86cKr97mtxdCo3O3blCvfP8aRfY/NziaOTSp41I6+5e3ep?=
 =?us-ascii?Q?MRxeRogjzYukBC4zTQaDKogaop8YcesO7TaJ22NPHFpNGrrvdQhSqFTUpR/Y?=
 =?us-ascii?Q?TO0rOtFi1pEufcvS2vpL5Y/cx8h7xdezFT0eLQ5Er+aufZ3z2PldcZuCdmNt?=
 =?us-ascii?Q?SsvewAm44vexeUaqtXG4+gU+MzAfCc4uAo+p?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(82310400026)(36860700013)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 20:53:16.2482
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7b37efe-b56f-4cab-340f-08dd51276ef2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F67.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6152

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

Similarly, prior to this patch, SNP has always been initialized before
these ioctls as SNP initialization is done as part of PSP module probe,
therefore, to keep a consistent behavior, SNP init needs to be done
here implicitly as part of these ioctls followed with SNP shutdown
before returning from the ioctl to maintain the consistent platform
state before and after the ioctl.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 117 ++++++++++++++++++++++++++++-------
 1 file changed, 93 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 8f5c474b9d1c..b06f43eb18f7 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1461,7 +1461,8 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
 static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
-	int rc;
+	bool shutdown_required = false;
+	int rc, error;
 
 	if (!writable)
 		return -EPERM;
@@ -1470,19 +1471,26 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool wr
 		rc = __sev_platform_init_locked(&argp->error);
 		if (rc)
 			return rc;
+		shutdown_required = true;
 	}
 
-	return __sev_do_cmd_locked(cmd, NULL, &argp->error);
+	rc = __sev_do_cmd_locked(cmd, NULL, &argp->error);
+
+	if (shutdown_required)
+		__sev_platform_shutdown_locked(&error);
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
-	int ret;
+	int ret, error;
 
 	if (!writable)
 		return -EPERM;
@@ -1513,6 +1521,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 		ret = __sev_platform_init_locked(&argp->error);
 		if (ret)
 			goto e_free_blob;
+		shutdown_required = true;
 	}
 
 	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
@@ -1531,6 +1540,9 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 	}
 
 e_free_blob:
+	if (shutdown_required)
+		__sev_platform_shutdown_locked(&error);
+
 	kfree(blob);
 	return ret;
 }
@@ -1747,8 +1759,9 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_pek_cert_import input;
 	struct sev_data_pek_cert_import data;
+	bool shutdown_required = false;
 	void *pek_blob, *oca_blob;
-	int ret;
+	int ret, error;
 
 	if (!writable)
 		return -EPERM;
@@ -1780,11 +1793,15 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 		ret = __sev_platform_init_locked(&argp->error);
 		if (ret)
 			goto e_free_oca;
+		shutdown_required = true;
 	}
 
 	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
 
 e_free_oca:
+	if (shutdown_required)
+		__sev_platform_shutdown_locked(&error);
+
 	kfree(oca_blob);
 e_free_pek:
 	kfree(pek_blob);
@@ -1901,17 +1918,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
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
+	int ret, error;
 
 	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
 		return -EFAULT;
@@ -1952,6 +1960,16 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	data.cert_chain_len = input.cert_chain_len;
 
 cmd:
+	/* If platform is not in INIT state then transition it to INIT. */
+	if (sev->state != SEV_STATE_INIT) {
+		if (!writable)
+			goto e_free_cert;
+		ret = __sev_platform_init_locked(&argp->error);
+		if (ret)
+			goto e_free_cert;
+		shutdown_required = true;
+	}
+
 	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
 
 	/* If we query the length, FW responded with expected data. */
@@ -1978,6 +1996,9 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	}
 
 e_free_cert:
+	if (shutdown_required)
+		__sev_platform_shutdown_locked(&error);
+
 	kfree(cert_blob);
 e_free_pdh:
 	kfree(pdh_blob);
@@ -1987,12 +2008,13 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
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
@@ -2001,6 +2023,13 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 
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
@@ -2029,6 +2058,9 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 		ret = -EFAULT;
 
 cleanup:
+	if (shutdown_required)
+		__sev_snp_shutdown_locked(&error, false);
+
 	__free_pages(status_page, 0);
 	return ret;
 }
@@ -2037,21 +2069,34 @@ static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_data_snp_commit buf;
+	bool shutdown_required = false;
+	int ret, error;
 
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
@@ -2060,17 +2105,30 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
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
@@ -2089,8 +2147,19 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
 
 	input.vlek_wrapped_address = __psp_pa(blob);
 
+	if (!sev->snp_initialized) {
+		ret = __sev_snp_init_locked(&argp->error);
+		if (ret)
+			goto cleanup;
+		shutdown_required = true;
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


