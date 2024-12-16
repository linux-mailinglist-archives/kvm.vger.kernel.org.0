Return-Path: <kvm+bounces-33885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 359C49F3E8B
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 00:58:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 208057A5BFB
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 23:58:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBAD31DB34B;
	Mon, 16 Dec 2024 23:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YWZZ5EG/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699C842A9B;
	Mon, 16 Dec 2024 23:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734393493; cv=fail; b=Jj6+5iSlUIPJV7JtsiR5FtY1IQ1IwvL6y+X6+vragCX+4X3nvATN8CcgYAe+HBV6d9bqGhCCGLttK+cmTdZuybfomGOle9UUyTbndMuT8Y9PUTvouBQGzJDz65PnyQCB0KxuksQm+IzknV2ymzS9nXIUjEL6MDT1vGujXLp2djY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734393493; c=relaxed/simple;
	bh=wAjzagrjnQYlNz4RahDlYC60WiOzIIh8vYOQE4YSCvA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gbNbN1Y6LqwPq2SCQoEIJG1+8aYpqXqI6Z1Dxaq4oPpak3nU6OGzNCXDQUNuW/jBo9+nRcaAgwTDUMq4aex10wM3b4PfS+OpVbYmQ7fMvAMRy6+g5su0Yez0pQKmXxt1n5pKIu8ZpKFx4ZTtfV3hZ/YSYsRYVunhtUjbkj5f8rM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YWZZ5EG/; arc=fail smtp.client-ip=40.107.244.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E6yToDZFfsLrvHfGyL3btM9E8IVkJ7TCcmlifZ7gg2eEz5TYVIyik/36S7oojb0uSSZtldnu0ySL/lI7j7YP71/wrOxveIy/A+N6/rc2LSUTPr1Xp5uAOjqAj2sFujpP2K6hl9/qlN39tz0YcrngJWMuVhvf1MQerJFxPRR0KpUL8Rs0eqC+8QUhBl5os9zeF8aN7Cxpj4ZFkjksoCNTxzWu3vApIT3nZuYcGYLj1nEqSgwRPXnSvI55aZRn01pCbzBt5BCBmXNGbyfw/bcYJJiwoFfayuOqzCNROCtmTV/9r3C7+N7Nf9mz4mvg8fuZ8IvGknxtLLd1Az0I6cqGkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Ul4UykFP1ClnSkG/fx9CZiwqIzhD67N/nKgrRojTP4=;
 b=LZn7tpos73OiHpsjmXiK/nxvNPdXvRzI0TPGUwmRAbVCacZRS8Mx1QeB8L6ktDMI/QyKP2wrEgYEhKTIpS9X0u2oQ+0unokJoQ50EiH5pax01u6xKxalSN0IGtF6DvChJ7koHIWFt105GJHcIwaSdRlzMZjYNCZ4161LRXcjxRYOo5E/fSEo9Z339SbZjP5PgVfPRO/eM2Kc5OhBprENQVOLCGsdcKcfHV/4F/QDRoFYDvLiAFpgxOROkDWfDthlsIEyWi8qLEFH4fvFUA6fokG71znIN7sZmSh7x5id6Ky6N8s8SVCWKVaW796PU40vwP2Kdq6JvJCKSLnQt+7xpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Ul4UykFP1ClnSkG/fx9CZiwqIzhD67N/nKgrRojTP4=;
 b=YWZZ5EG/XGC0Zg/+VyibK0QqQO0BO37WcFS8/kWGP6O+RLPqzdJ3ILtjdHY+PMDqkx8neGa03FmaprrPvlAvmlN2kNStoSeCUGFNp6Gge4pYsqaT0JpChDAvZrefOU6knIN4BsQy7TX9kmlGwW+VFgOo3tHJOYOPAuHHFcRliU0=
Received: from SJ0PR13CA0044.namprd13.prod.outlook.com (2603:10b6:a03:2c2::19)
 by MW4PR12MB7430.namprd12.prod.outlook.com (2603:10b6:303:224::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.20; Mon, 16 Dec
 2024 23:58:07 +0000
Received: from SJ5PEPF00000206.namprd05.prod.outlook.com
 (2603:10b6:a03:2c2:cafe::de) by SJ0PR13CA0044.outlook.office365.com
 (2603:10b6:a03:2c2::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8272.7 via Frontend Transport; Mon,
 16 Dec 2024 23:58:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF00000206.mail.protection.outlook.com (10.167.244.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8251.15 via Frontend Transport; Mon, 16 Dec 2024 23:58:07 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 16 Dec
 2024 17:58:05 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v2 2/9] crypto: ccp: Fix implicit SEV/SNP init and shutdown in ioctls
Date: Mon, 16 Dec 2024 23:57:56 +0000
Message-ID: <1e96d3b18245577cb0c2ae510092701901bbe81b.1734392473.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1734392473.git.ashish.kalra@amd.com>
References: <cover.1734392473.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000206:EE_|MW4PR12MB7430:EE_
X-MS-Office365-Filtering-Correlation-Id: efcfdabd-2654-415b-1281-08dd1e2d7cc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eZiyxToR51OtoYMNO/HXYuIKGuQGNOc5Guw6fcJ8LfvtbzLRW1zEiurvcj8Z?=
 =?us-ascii?Q?Ve4h0zEaxlYF5QMAb2/agQyTAptQ0eFNO7jcVnof/ZdZ8zSumFWMVRmloQUm?=
 =?us-ascii?Q?irgCaNAIazgSGCf7YYIqIhqKAZSGWQbhAb+7eB/MG1qUGdATA52F+Q0JiuF4?=
 =?us-ascii?Q?Zn2Rq6eWRw1FiZ4c9orJGxaTZSYKBQgs7AP3WP8BqukVZHNC+vJnrxI0v2ci?=
 =?us-ascii?Q?DBQJdQUeLUWSufjrnacH5Cdp7yaDeMahLwgOkJXDjYBDxxYpcgLEhX13b5Jw?=
 =?us-ascii?Q?k4GJP3h47kEMgjhEAU2PR5VtY/yOVVpMYzY8DSzWMEo36HOhdFmIq3qLCpSY?=
 =?us-ascii?Q?URDN2P7PVWQ+yO50uaED2lWO3xT2ASWko05HcLbJ/WcEa9n6Hij+BYtkUtSH?=
 =?us-ascii?Q?+iyZV4LvRonQ7IUUYkh1kdFP8C2ungY74O0EyeCWyBq/yQklotNZWmoj2TVi?=
 =?us-ascii?Q?ZhkBoUjubc9agsetEPKcxH34+20uYxXMy9iSPH5SBrGJW0GzyJ7hOp3siYXP?=
 =?us-ascii?Q?g6TppcxKaTEvFjpGA0Qlx1xJk8xrlz4ObRUrgtv0jkikpwETQ895ERUjEpSq?=
 =?us-ascii?Q?5fukJO4XgrJLDl39GWiwup4L902IdDup/MS8zLHPD6t28H2maDwDxEK5AUEh?=
 =?us-ascii?Q?t3EsZ/lPVBrV0R+K4MLHobfJgMH9wyh3wFIrEfAIPeggj9To3cBMr4aQsLkS?=
 =?us-ascii?Q?mjtrZo4kTwZhZIRJmWzeSdO9jbTcPe0nn4n40lNEjuUTw2NqaJEKHPbjXEY1?=
 =?us-ascii?Q?St3nFdD+BKkFqIGDt0j8Yb6StImU5lcuyQ0OTZknVz2I86VRLSnhPDU7Y11Y?=
 =?us-ascii?Q?Xxq0QvOdQWX/Nwq2zG7PHRY3f0NSett4KphsA3FxNMkIwzuE+uhtIycJn2kQ?=
 =?us-ascii?Q?2z622aVh1hcWL4flzdLgv8TTC8gQgcKnwyw5L/uXh2ILHxPpin3Dyrcf1E66?=
 =?us-ascii?Q?D/Oi1vyxaECOTZedmi6GUbcml8ltGycsIYLaBo3x7GJFBWzp2ANPlPmU8KBO?=
 =?us-ascii?Q?yxmDe9TsdcO65hmn9rnGLoP6vwEugU23FLZdgPjnVo/FFl+JshiRo45H3wX0?=
 =?us-ascii?Q?FTwfwO4nFgjLkjtF/zCdFN130Rr9GhkdZ1sxx6kXQHd8jzoF+IUVmF4kdeQb?=
 =?us-ascii?Q?qGR5nuWzDYZzT/mRVeI/ugW3XX0TcmQfMj1/E3QCh0zSfgYCJ7EjOQN2+NhE?=
 =?us-ascii?Q?BkRzy+7ak1L62ku5iUVDBEYChjyfWmyobPsPyv5+uQztfw2vgpi1z3sN1PHj?=
 =?us-ascii?Q?y2eeHGVuIfLzzGuep/yHu330BNxYnrYjUChhsj0bXVhTRGOvIJ9LrB1KXUIt?=
 =?us-ascii?Q?e8kHw1EIu5IkIFAyPX18H0y4v2NvuM5W9EpmyNcL5WrtFUTQQyWXLII5IQVq?=
 =?us-ascii?Q?bJd8qngQdnEEjh6JiYdhqdJMbprxNnkVMLrspYMo3BYDuMhcj4a0soMIEyyd?=
 =?us-ascii?Q?fwDMUixVtQUR413J1Th7hYX4gg/+qNPFltDtnEHjGk5o/UJg5P37C1VHxCDz?=
 =?us-ascii?Q?dO1Q6e0koalybtksrbkgpXXWQ1eYw/8YqXgj?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2024 23:58:07.0698
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: efcfdabd-2654-415b-1281-08dd1e2d7cc7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000206.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7430

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


