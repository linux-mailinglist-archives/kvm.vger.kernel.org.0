Return-Path: <kvm+bounces-22775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E72E49432BF
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 17:10:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2B4E284F9A
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:10:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D2091BD03C;
	Wed, 31 Jul 2024 15:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3NzVs+8e"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B503F1BD01E;
	Wed, 31 Jul 2024 15:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722438526; cv=fail; b=TL0813cFnXJfprsdERO+IbvM+s2b1fK4rgeqF8ypFac9rDvKttm9py9q/Nzhol7M4aQtWmWsx1t6JzwRPEgUQ4TtdCTeP7Tx64zAwrEvE4nljwhywWOZDHUlAFSd8JjGqJmkqmpFISwgWtRzM9UpCWxJwxtBSlNnPa2oVZPdlQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722438526; c=relaxed/simple;
	bh=RJrrpH7n82L3nqgu4KAK9RvKxu/5yEN1FvsgCaBTYKg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UXAzKf5dxox9eObaiM8Kzz8kMbLBV55bu3a7n351kJX+I3JEkx0cymYClm5xwCIaSETy/OoO4eqAwsExSWNBZ0KYnLpMcdDXoomQBsa0zXCuP4FeNMNl80ltcFQPhjBNUI8npOHIBKxYJPNlCpJopQtG4J66QRC/DzyrFPwyEbA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3NzVs+8e; arc=fail smtp.client-ip=40.107.237.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yhkoy0H/9nM68JnuzfpXxAsTVsjYnaFPoLCM4bbm9pAkvw5eadCuLePYvkcnvlOxG8Uu1yeWMtXA7HRHfkQdueim1xr6SXAF9aGdfGJHqz3ZuSzbbglk2xIHwSnl/9msYEyyNj+gDqpy6FiX9GAUR2kqFNfxnzYrBIPivjVMey0E1HDaNNOgULpz5NRrMkwgDnu3yaci+bmjsie+ijlAoU5xfOEKq97cyLdY9vmPS+6PbS2cgPDDLnoaowjaaGmMoAGngCKYW0Cbg5zBtcZXNX31fCWXocLIaFYCYJLGvxHN6W4s+MatuOZ13OZ0YdQzU/ohI0ITsM2U1YZImtlAvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WkZGq3bai46ckmEgSN33AjEVuSTC3teGhxVXz8ILwHA=;
 b=UUp78RtVe7b/d1+Q64pK4u+E5RrNRJTSfQOCQrLfPbYf2tpw66QFCGQDvY/r896iTfgzTzYjxdkQLC3RJvidSaHy0Z94K8Qe889OyvTrmmdFNRkTpgXfy9oem9Fu9jnWT9I58qLORaoZvTrWiO7Fd6e9QpwyBNi7vTgw/N24K2QQbF17s0gl5CPUfg8y5CDjLb2urJAt/TnkdTgahhSQzmXqbz22rmevP6Vozu5qZibtLX9AJsYadUF137fYZ8VyIxqXjtHZHdnUjAXpHbWNS67mOKeHg6r+3M6b2wieFQKvT7lfs7ttU+pRnh+aNjdPdefDefF8BOEy+fPc/WceKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WkZGq3bai46ckmEgSN33AjEVuSTC3teGhxVXz8ILwHA=;
 b=3NzVs+8euH9ydtD1j2a61ZZ1FJOlQorcsh3rAWQbFkCZwFtr4d4H20sbJ9WEWAldduUQ28N+O7nAQVPamLScNeoSS3yWm2FJrN3TpljGJSflsJihqIBbiExNU4Hpzrj69G9eIeeCqU6+bYj5RL4rgGkjo3V4+sfAg5tnhAijELc=
Received: from DM6PR07CA0080.namprd07.prod.outlook.com (2603:10b6:5:337::13)
 by DS0PR12MB7876.namprd12.prod.outlook.com (2603:10b6:8:148::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Wed, 31 Jul
 2024 15:08:40 +0000
Received: from DS3PEPF0000C37E.namprd04.prod.outlook.com
 (2603:10b6:5:337:cafe::ee) by DM6PR07CA0080.outlook.office365.com
 (2603:10b6:5:337::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.34 via Frontend
 Transport; Wed, 31 Jul 2024 15:08:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37E.mail.protection.outlook.com (10.167.23.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Wed, 31 Jul 2024 15:08:40 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 31 Jul
 2024 10:08:36 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v11 03/20] virt: sev-guest: Fix user-visible strings
Date: Wed, 31 Jul 2024 20:37:54 +0530
Message-ID: <20240731150811.156771-4-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240731150811.156771-1-nikunj@amd.com>
References: <20240731150811.156771-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37E:EE_|DS0PR12MB7876:EE_
X-MS-Office365-Filtering-Correlation-Id: a553b994-5b4e-404f-53f1-08dcb172a97e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GRzzbUBm/hmY4J5jz1XKeiFMqfTUV4GFD43MNopT1LI5q1tpdF2sQdFlzObi?=
 =?us-ascii?Q?myc208EBoYPKvRFsNqeqTjUdbanyQNnkcT78KL/WKrHum1DnL648bBkzomCh?=
 =?us-ascii?Q?ti0y5mRwAZKKmK2VDai1mGsh1zagSamnKyXPGtIeGC6Fr084dPveBXJTyx7I?=
 =?us-ascii?Q?Z5z1rbNcu2QDMUhvsuUPT+MqbMGOqsSFr0HWr42BaMb1oHHx2Zyu/FKgZuqK?=
 =?us-ascii?Q?zbQH8J/FPyoFAe7Ru5x7V8SrVkaztRJr1DwcRn6P7oszLulhYsJgVqjaM4yJ?=
 =?us-ascii?Q?aNsi1mSXG5wCKMoX0R7Z2OjLleh9fn8wEJB0dXiy9zgon7wBqU/A2rDGXk+S?=
 =?us-ascii?Q?eoi2RzOJBu3VwBEjIPX/RyjsiS4wiG038nPgYesJ4s5EuswtXymMWbsXbpxR?=
 =?us-ascii?Q?C+y0CWDrArO3EeoG/QI8pwK/GJZ3e0rlf1J544w1UqJ6ERe858qZWRvdRscG?=
 =?us-ascii?Q?9Mjc7As92WkJd8UzJPf0TegBFNx8BnTRIGn8fr/vHwvJ3gaAjCNE72eQLaMm?=
 =?us-ascii?Q?9w0lMSL+qvFsfsQXJFtEiVXAy5lbgGoZpmXcEz0COOo9YisT1JyYmu/Pjmgt?=
 =?us-ascii?Q?Y/m5QC/7NkQpBsdrCH8ODcJJwoPkP6bP3wUHuhx9r45uNsb7jNOPhG+rqjSv?=
 =?us-ascii?Q?5zLmBmEjz057zlNx7+z/8H80bmoWQDM+03BQ7FkaD6ZYWwUyV4hUveouS6S2?=
 =?us-ascii?Q?2Z6cbpPt4sLaBUULRsie4dP2lJwgpdZ3EXEHpRROc8lrv5Q+3BvqheRXF8QI?=
 =?us-ascii?Q?XY0OHxnzLMxNjekMq9BMNQw+5tjLOx/yGOa9KoVibBp5wgdcY0M9ResrC5w5?=
 =?us-ascii?Q?6cEhC9p2KKzyE+OVpf8Zr7tkOB60T6vSaM8QqHwk7oBh8FR7WiDn130utLmr?=
 =?us-ascii?Q?2Td7H7BfczuW9g1r83wN6M4L9zunmBKBCslGg+vaTafcyd+sRJJ0k3WXHRFP?=
 =?us-ascii?Q?B6DE+WUgM60IKwz+9xaTOgnh1JDj8UsLT4tCqOmb3+EMbgc5PL3svQDXWriM?=
 =?us-ascii?Q?Q4WPkFFAWuOk0K7Z+XxegdknKcmxnyXiD4HN/VQVD3gC3XXvx/CEeZBJWdFQ?=
 =?us-ascii?Q?o34ANAeoHuLcM7Q6dKwZRGfpO0xRs0VDBH0pxuT7LnABeXKW2eUDcHk1eCkF?=
 =?us-ascii?Q?KBPiI+PLWTRe7FwwCsECy56fHidro4PZDjo2wSebBalK+rmCvsrpeSV/WpuL?=
 =?us-ascii?Q?7oNxEsX6XVg4YsABnnIkwAx+rHkbgDHcbMaTzYBWtlqy+/ID9qN484/QsO26?=
 =?us-ascii?Q?z/7laiKJ+7eexc2rpKhLKFa8aFs42hlVjUzHp4JTi+XY/LcrYbfI1hPYoUw4?=
 =?us-ascii?Q?8Yc/hMtS2CCSsg3mjjtdX5UpwoG47WktxUH/CCIb417E2EXdfkrO2+fGBgs+?=
 =?us-ascii?Q?J4uDu3LCyaKYbf3MeEd+cN0e5gOZmLtMbDdAQJoLGPm89CDVEiFfAgJBLeVo?=
 =?us-ascii?Q?Y6h5EoSReCQ1fmMW89DMWl/CwXPWpSdX?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 15:08:40.6690
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a553b994-5b4e-404f-53f1-08dcb172a97e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7876

User-visible abbreviations should be in capitals, ensure messages are
readable and clear.

No functional change.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index a72fe1e959c2..3b76cbf78f41 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -114,7 +114,7 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
  */
 static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
 {
-	dev_alert(snp_dev->dev, "Disabling vmpck_id %d to prevent IV reuse.\n",
+	dev_alert(snp_dev->dev, "Disabling VMPCK%d communication key to prevent IV reuse.\n",
 		  vmpck_id);
 	memzero_explicit(snp_dev->vmpck, VMPCK_KEY_LEN);
 	snp_dev->vmpck = NULL;
@@ -1117,13 +1117,13 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	ret = -EINVAL;
 	snp_dev->vmpck = get_vmpck(vmpck_id, secrets, &snp_dev->os_area_msg_seqno);
 	if (!snp_dev->vmpck) {
-		dev_err(dev, "invalid vmpck id %d\n", vmpck_id);
+		dev_err(dev, "Invalid VMPCK%d communication key\n", vmpck_id);
 		goto e_unmap;
 	}
 
 	/* Verify that VMPCK is not zero. */
 	if (is_vmpck_empty(snp_dev)) {
-		dev_err(dev, "vmpck id %d is null\n", vmpck_id);
+		dev_err(dev, "Empty VMPCK%d communication key\n", vmpck_id);
 		goto e_unmap;
 	}
 
@@ -1174,7 +1174,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	if (ret)
 		goto e_free_cert_data;
 
-	dev_info(dev, "Initialized SEV guest driver (using vmpck_id %d)\n", vmpck_id);
+	dev_info(dev, "Initialized SEV guest driver (using VMPCK%d communication key)\n", vmpck_id);
 	return 0;
 
 e_free_cert_data:
-- 
2.34.1


