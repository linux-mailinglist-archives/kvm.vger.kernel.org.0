Return-Path: <kvm+bounces-39179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CB75FA44E3F
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 22:03:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9D8719C703F
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 21:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71CD72139B1;
	Tue, 25 Feb 2025 21:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BjGeK4Pu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D577E1A9B46;
	Tue, 25 Feb 2025 21:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740517230; cv=fail; b=oXitd6pC7pynr4Dz+vBzByLwP7sbt+wZkOFwO/XrUSKyFB0r+79Eqe03/+wlitk5ZcNnubLgfJstrvx7w4CfsckVXhNgHYxNKoRCU4Ogy20XanJkdN2ZDU55RV6PiRfRuj/zV6uyZF2K8aU+abTVQoUz+TI5L9LDyI3KloRZryQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740517230; c=relaxed/simple;
	bh=6CDhjWJYn1EfXkD3bfYs7kB3C5YO7TKwy+jKrYyspOc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n2nM68YBFNE+EfvJX+CIy09KJ/HH4Z1M7DB4C7WeNK0+9AUXHmZUfqiMw/wg/jE7AzQKp3rMORWP7MKXjd+xS+/MCHYKYDx/CiT2MWLE7KI1q1ssWHrioXKogZdMUwiKH0oSgre8FsBnxGrN0rheLeYepxstgj2st6x9CJFzCn8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BjGeK4Pu; arc=fail smtp.client-ip=40.107.94.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tRZpm4h1xDpk8nItz2nj3ZG5x7yWk+Hb/9MRwrK27DpIwwN4NhEu9FJM7anYRVLkZOw8HiBm0SddeZ5MWNJiB8Vak75h5XjFDXfkdSuZYrU/Nl1Zb5acdqVPzujTtg+YcA9x53zaQoMyCZBuZuHQfBu5WGGswmL1dx1CBF224+d6bIQmdVj29utvox2JR0ft8ZM77TBG1q6hYmvmWsi9g/U11/58vCre9ny0sJLu4qN7xnoADOoOL9t4TJ1+CjrawVoL1cD/mDSwkCT5LwsXhaln9cJdOqPDLAfMt8Kp8h8pP7gMWyV8WucrM/On2PH16hk/CIwUipm+KBfYDt4JSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9VkwU7vFimV1arO5EjDIioS83t8NaVrIuA8G83ZSp4s=;
 b=nj7COtQctXAyYIqkDXkYN/9VFEtYHE7JW9epCkTLbWGJw6CTZ+lz4zfE4XXDZr41azlMzyVKGl+j+IcyPkTXh2crl0VWy359aj4N8fEO8dJMX/dfWJDyPEi3uNC5OvHXdOXExnDIvCcVCaLr0X8M59uyZaWvZVSuM0J8FVlyao/RlPryJU/2o/FRp0DPpoFvAiIgbpPZ/rJdYDEvvMGwCU78LMVWEye+REwjz0+jMnIM0kgL1XOM1tOpxIQF93BgrFjSgXPmR4Ww9c1AITuz7tSj3RC9uR412Xe07PYiiGXH7B6TNrIi7uatbIYSp7WD3LS+VilixfJLDzWkFxGotQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9VkwU7vFimV1arO5EjDIioS83t8NaVrIuA8G83ZSp4s=;
 b=BjGeK4PuV/GgdW/Rn7+CKqyYkL5yAFwNIu3UDJ7Tb+9/uQTghCl2ttM0yHwg3qTuxLA7Bzy+A7L+guR18EbFa9AmMlqyDw5kEDUMpGAIcE2zIJ8RLNroi/eQOebABOHDOG3PvyjEMaGAKo34CpuGPyaRJqyzLac38F4GbqaC0W0=
Received: from SJ0PR13CA0055.namprd13.prod.outlook.com (2603:10b6:a03:2c2::30)
 by MW4PR12MB7117.namprd12.prod.outlook.com (2603:10b6:303:221::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Tue, 25 Feb
 2025 21:00:20 +0000
Received: from CO1PEPF000042A7.namprd03.prod.outlook.com
 (2603:10b6:a03:2c2:cafe::62) by SJ0PR13CA0055.outlook.office365.com
 (2603:10b6:a03:2c2::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.15 via Frontend Transport; Tue,
 25 Feb 2025 21:00:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000042A7.mail.protection.outlook.com (10.167.243.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Tue, 25 Feb 2025 21:00:19 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 25 Feb
 2025 15:00:18 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v5 2/7] crypto: ccp: Ensure implicit SEV/SNP init and shutdown in ioctls
Date: Tue, 25 Feb 2025 21:00:09 +0000
Message-ID: <1d7b31af0eb36d860907c1e89e553e642f3882e0.1740512583.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1740512583.git.ashish.kalra@amd.com>
References: <cover.1740512583.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000042A7:EE_|MW4PR12MB7117:EE_
X-MS-Office365-Filtering-Correlation-Id: 87f456f8-1821-4b6d-9152-08dd55df69f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|7416014|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yZhx80rpk7pG9vOdU263IHv6nl3mwvabPPbUQtsXYsV0ALB+/O6Nr4oEgRTS?=
 =?us-ascii?Q?f3kgS4ZPCnoZSFaBQNJpN6iaVu9UVV/n7WunV++jT7SJq25KZhqxOo2g415v?=
 =?us-ascii?Q?JKNDRzMq0mR3o2kV8+tOiDOB7G+6gi8Y9cjibBCEekOX5rb+NOF8C+k9c/8H?=
 =?us-ascii?Q?ZlqVYXHlWhMkUEgRN46EqvA8bkA/6ILIrxApoAQyPZyIZmnji0rQtJdV8G1K?=
 =?us-ascii?Q?mi5K9fN2IhawphoXdPsoZNdQDoc9B6eFCn0uk0mr4eYBG6MZ89KbwQvdFeZz?=
 =?us-ascii?Q?VdBudxxuXGEwHkoKCZH/WNfwyiZleSKzsRiMnNvZQCqAXngRvv8gkkmdSF7m?=
 =?us-ascii?Q?fg7U+DmvDjA+XRwd3qL2jbWunwKSoBj6qmpFrDWnYWyx7+AZFS4SvF2Wl5DG?=
 =?us-ascii?Q?SNz4qcawN1InYSKyM+EgwPQytWNmJxss9N9iHB/iIQGAfMVYDwJJm21Pxd31?=
 =?us-ascii?Q?5zVjb/Q4gFtN8r/KU1k/TwoSjLCfvKSbHcGbieThiQg9b/XOL2VzSBugUI/E?=
 =?us-ascii?Q?UMMN2JNgcg5QsjCKftQebz+dGbwaOwasuYK6x5sPcJaq8dEL/EEAiQkqEFNv?=
 =?us-ascii?Q?r89KOM6F0F0sKF7PHmvjeP+5DYKW85ywi6K8OdN1CqfL4sLVqvdYP0TuyhOf?=
 =?us-ascii?Q?sp08DuNtie7mBRsQxxDe1UgI9hwfpwQonw0GhcL9No1SYRB0HWqrBvy1Cr7K?=
 =?us-ascii?Q?kZgH21dNN2tEOW4QWnB7B/q1mmFXhEYtF5Xl+Y0fL1oFJuHgtMToFA86i+DS?=
 =?us-ascii?Q?mV3QiWmKSqzQ0ErJBHgPscNLYIYBccgnNJ+v/DJnN6vU0Fy6MFqR4xXHC2hY?=
 =?us-ascii?Q?P8ysQE2046kTsjegt1u734SLfbPNKNS8Tw6uN0LjazQGaQv/3DIPWtr11VmP?=
 =?us-ascii?Q?6XpweJKUYL0Aqdl3u/JurZ2u0lqQCW58BoESbcaHl7p9Kpwu/E0kJigSz9+3?=
 =?us-ascii?Q?I4w3Tk9ee6L1eVWw7M1QM7gGqrsy+B3z/MgekvnYD+WLElQgT6zFmzFGkb/2?=
 =?us-ascii?Q?ruZBMMpFWqE3/EGy1cIgg+yj/DdMJfcCJb6kNNpA9qg0mCjFev6mEy8hJ4Mr?=
 =?us-ascii?Q?e4237fsDJdvwWBK+DEnHdzve3R3CHkqdrUGQWax6/mdVCiZdAz3gt2+aJ88E?=
 =?us-ascii?Q?nrA5Uejz6bWmt9R6EuLVK9+tOvqp8cb7ARBRro4+CqaFg01GZw3YiUkwJkaG?=
 =?us-ascii?Q?grC4eRZBnkuRy9yC3FLJXjegfo4HKkd5cae88tjVwNpcEu5R69+CcJbRWrHu?=
 =?us-ascii?Q?nK/8mvqf1QwxfaySqhPM8wleVctW18c61aChynMbjcV1swSu0ervTHfpFc8m?=
 =?us-ascii?Q?dwa9W4Rq1KvtxAB71Qz9UEy3a04lVDz9UzWNQ8CqGiypZ1LC0lpzCB8WggdZ?=
 =?us-ascii?Q?qC9EU2APb6Y+GylS+s6h9MQs9jn1U6yHxqpYv+oUH5zrff7pON0AfmW5pmqq?=
 =?us-ascii?Q?KwdZWHzlyyM9Y/75Q2hyONd+YtVSRgb/zvycjR+UFyfrXO4o18jAyevg3/Nj?=
 =?us-ascii?Q?4VtQfZiywLW8p0allTyDkTe41aMf0+K1lluk?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(7416014)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 21:00:19.8816
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87f456f8-1821-4b6d-9152-08dd55df69f7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042A7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7117

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

Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 145 +++++++++++++++++++++++++++--------
 1 file changed, 115 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 8962a0dbc66f..14847f1c05fc 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1459,28 +1459,38 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
 static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
-	int rc;
+	bool shutdown_required = false;
+	int rc, error;
 
 	if (!writable)
 		return -EPERM;
 
 	if (sev->state == SEV_STATE_UNINIT) {
-		rc = __sev_platform_init_locked(&argp->error);
-		if (rc)
+		rc = __sev_platform_init_locked(&error);
+		if (rc) {
+			argp->error = SEV_RET_INVALID_PLATFORM_STATE;
 			return rc;
+		}
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
@@ -1508,9 +1518,12 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 
 cmd:
 	if (sev->state == SEV_STATE_UNINIT) {
-		ret = __sev_platform_init_locked(&argp->error);
-		if (ret)
+		ret = __sev_platform_init_locked(&error);
+		if (ret) {
+			argp->error = SEV_RET_INVALID_PLATFORM_STATE;
 			goto e_free_blob;
+		}
+		shutdown_required = true;
 	}
 
 	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
@@ -1529,6 +1542,9 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 	}
 
 e_free_blob:
+	if (shutdown_required)
+		__sev_platform_shutdown_locked(&error);
+
 	kfree(blob);
 	return ret;
 }
@@ -1746,8 +1762,9 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_pek_cert_import input;
 	struct sev_data_pek_cert_import data;
+	bool shutdown_required = false;
 	void *pek_blob, *oca_blob;
-	int ret;
+	int ret, error;
 
 	if (!writable)
 		return -EPERM;
@@ -1776,14 +1793,20 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 
 	/* If platform is not in INIT state then transition it to INIT */
 	if (sev->state != SEV_STATE_INIT) {
-		ret = __sev_platform_init_locked(&argp->error);
-		if (ret)
+		ret = __sev_platform_init_locked(&error);
+		if (ret) {
+			argp->error = SEV_RET_INVALID_PLATFORM_STATE;
 			goto e_free_oca;
+		}
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
@@ -1900,17 +1923,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
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
@@ -1951,6 +1965,18 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	data.cert_chain_len = input.cert_chain_len;
 
 cmd:
+	/* If platform is not in INIT state then transition it to INIT. */
+	if (sev->state != SEV_STATE_INIT) {
+		if (!writable)
+			goto e_free_cert;
+		ret = __sev_platform_init_locked(&error);
+		if (ret) {
+			argp->error = SEV_RET_INVALID_PLATFORM_STATE;
+			goto e_free_cert;
+		}
+		shutdown_required = true;
+	}
+
 	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
 
 	/* If we query the length, FW responded with expected data. */
@@ -1977,6 +2003,9 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	}
 
 e_free_cert:
+	if (shutdown_required)
+		__sev_platform_shutdown_locked(&error);
+
 	kfree(cert_blob);
 e_free_pdh:
 	kfree(pdh_blob);
@@ -1986,12 +2015,13 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
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
@@ -2000,6 +2030,15 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 
 	data = page_address(status_page);
 
+	if (!sev->snp_initialized) {
+		ret = __sev_snp_init_locked(&error);
+		if (ret) {
+			argp->error = SEV_RET_INVALID_PLATFORM_STATE;
+			goto cleanup;
+		}
+		shutdown_required = true;
+	}
+
 	/*
 	 * Firmware expects status page to be in firmware-owned state, otherwise
 	 * it will report firmware error code INVALID_PAGE_STATE (0x1A).
@@ -2028,6 +2067,9 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 		ret = -EFAULT;
 
 cleanup:
+	if (shutdown_required)
+		__sev_snp_shutdown_locked(&error, false);
+
 	__free_pages(status_page, 0);
 	return ret;
 }
@@ -2036,21 +2078,36 @@ static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_data_snp_commit buf;
+	bool shutdown_required = false;
+	int ret, error;
 
-	if (!sev->snp_initialized)
-		return -EINVAL;
+	if (!sev->snp_initialized) {
+		ret = __sev_snp_init_locked(&error);
+		if (ret) {
+			argp->error = SEV_RET_INVALID_PLATFORM_STATE;
+			return ret;
+		}
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
@@ -2059,17 +2116,32 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
 	if (copy_from_user(&config, (void __user *)argp->data, sizeof(config)))
 		return -EFAULT;
 
-	return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
+	if (!sev->snp_initialized) {
+		ret = __sev_snp_init_locked(&error);
+		if (ret) {
+			argp->error = SEV_RET_INVALID_PLATFORM_STATE;
+			return ret;
+		}
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
@@ -2088,8 +2160,21 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
 
 	input.vlek_wrapped_address = __psp_pa(blob);
 
+	if (!sev->snp_initialized) {
+		ret = __sev_snp_init_locked(&error);
+		if (ret) {
+			argp->error = SEV_RET_INVALID_PLATFORM_STATE;
+			goto cleanup;
+		}
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


