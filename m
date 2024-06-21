Return-Path: <kvm+bounces-20258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EC239125BD
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:44:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DEE82846E1
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:44:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B587153838;
	Fri, 21 Jun 2024 12:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4Shrpomx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF7016086C;
	Fri, 21 Jun 2024 12:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973609; cv=fail; b=ld+cagl8xn3E5oJwzKoGtJSmMxHtPWKQPhMOrCuGcS60i75Xdb2pa5dk2+gPGC0J8oyRWPNGSYrbD6QeNnrZMJnBVDb3GZ5/+7UcxYiUQn6+SIva50NmHfAg/l4UU3eA+zEImeQEkOvy1xiMN1o30t960U0U1uuvwtkjoys+gyo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973609; c=relaxed/simple;
	bh=+S1ZRh037uKA3kIyz4UW4kWlUwtxdTvSsPRw6RUq8kY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KdaFAf4Kh8ggGLdTXungHrkSVxCfu94AvrCW7uIKfum8i1zjTbxzDfn0QZLWVDQO62IqcNx404qfVrO20SJpLG1w37Q3tD1C/TM5+gDty94rcwXIvJwOlOcCirfKBLQw0/YaQoYvdy8B8+uuNKtI8SrK2Ed1pWKrsFEoGwAI2Jw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4Shrpomx; arc=fail smtp.client-ip=40.107.93.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BA9tTnrYXcyQOUiajgXfucR+j8MMHEO2xTNgQ2MddIBj7/1BhyIjnIQfsM1ffERoc+TS3Srwb+u2LiZ0BUzhlDo1z6a1hJkBzTMtFIxrtW0XE4kt1ZflzopAeoUf8C3dqeWEgYlLCznMwXhC9jGvmSkCsEplmIIgPVaE6pnctxzA/13lpI52G05R60481QUximNA8M+YNnfGJH9MEXVVsYMZJ7aFgkJGIY4f7p6txcjakjPThkLmqzO6AqN02VWYVzblGU4xBm9FrTixEx4UF2XNcQoeM1JqGCRelsEjmYxJjvP/Dl6Zxw/PJoABMYv7iaq2d90ZZlD1HQEf6wcrNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fBDcZ24P51HzcY53IOfwHgXuQ8Ah0mBb3qVBMTEudAI=;
 b=UoNYqGkms0nlSTu9acas95GPOz/izu0NUGLIykQI8r7NBnwJwRkgvTOSDpARvUtS3SRQrcfIYRAu6duPJLGUlvXeiYpiCE1MBlnrwxHVuGuBXEesAUYY0YsSN2lHJBpFFvRj9V+WSIja5iGCx3umssM5JnBxbaMIwvZR8gg7+0ro2j8RGpECGsJd9vkDwTqJY/gvtOY0xrNIxpL5D2Zwj8fOMsaDKetgJcbnS0klBACfXlWaQHgkqLqzQmVzbDZ3nakm+tJU+IqwwyR2cPIQ5vVERroQbTVSdhYu+gvNZN5xMoBhCZ7Od8LozBqBO4M3szM70i1lWfX7tK2wcpbcUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fBDcZ24P51HzcY53IOfwHgXuQ8Ah0mBb3qVBMTEudAI=;
 b=4ShrpomxwysQSjd9Ce0a9jcUqgkcjRAfGtDdlSWZ4UfVI+lIkGg9hoeN6m+XRbidz2xZfp1QE9bKKsAKloBvZUtX94UifmQWettaq9yhIeCtt7LkahIk2GKXOqGx0sEdMe0dlDNanRl5aoWsjvHjVU08JVrUyKK0lmt6hNFS3/c=
Received: from SN6PR05CA0034.namprd05.prod.outlook.com (2603:10b6:805:de::47)
 by SA1PR12MB8945.namprd12.prod.outlook.com (2603:10b6:806:375::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Fri, 21 Jun
 2024 12:40:06 +0000
Received: from SN1PEPF00036F3E.namprd05.prod.outlook.com
 (2603:10b6:805:de:cafe::dd) by SN6PR05CA0034.outlook.office365.com
 (2603:10b6:805:de::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.36 via Frontend
 Transport; Fri, 21 Jun 2024 12:40:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F3E.mail.protection.outlook.com (10.167.248.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 12:40:05 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 07:40:02 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v10 11/24] x86/sev: Replace dev_[err,alert] with pr_[err,alert]
Date: Fri, 21 Jun 2024 18:08:50 +0530
Message-ID: <20240621123903.2411843-12-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240621123903.2411843-1-nikunj@amd.com>
References: <20240621123903.2411843-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3E:EE_|SA1PR12MB8945:EE_
X-MS-Office365-Filtering-Correlation-Id: d17d9344-2494-408f-ce9e-08dc91ef475f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|36860700010|7416011|376011|1800799021|82310400023;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?q903J1AnVMpcP308T4laATxp5dXg4qKQZdUaXtZKjdYPBy0zQ92+35WCaGpO?=
 =?us-ascii?Q?gS9jiQkDkMu/2q5fBj59vuIOuSXS0dtQoq5NDs8moK8f3iBQZxTPoKpt5uqa?=
 =?us-ascii?Q?v6DdfPdBk2QiTL4K4mhTJUxffPnyOeIetZ7IFsS2TWRVfzApuoi/tn2JkrO7?=
 =?us-ascii?Q?8BVF5fieQwAL2h58XKqNbUzismbzVoYqvBCDnEDNdThK1gVv3mAsvkGGAgrx?=
 =?us-ascii?Q?qKctc0DExBiuMhAXKgUOQRLM7zvYDoToYKOHqivOkspMGSTk+D8RUu2mPmHw?=
 =?us-ascii?Q?42MHCU+ryQ+N+FP1q/pybJD2474GIarH+hu+sPNjDnzprxqr5BM3bSEeRhLE?=
 =?us-ascii?Q?DbxPL82xOvRCeXPZfKawXXdVRjY4TDuRmj5jcS1ApK1AILrfaqfykq7ddSGQ?=
 =?us-ascii?Q?5Iqbgl1G9SHNIVoJeIc91RsEw5W3H0+RWiY4w9VcCO3tvwJeWw15+SQD8v1N?=
 =?us-ascii?Q?r39QguykseU+qQeE3wJ7lV1zYeN7MdmDjrzut8yFuyZMZBG070YZ0fKuOClW?=
 =?us-ascii?Q?ZZMfnynsIB1WtSjjLpPhUr+rjOm3x1oZ/L+z+DuGCjtJYw8lRmcr1Vc/IV5C?=
 =?us-ascii?Q?aod/1atYQwvcC9x3tDHUBKeE8bvooEj1npW4/LK8j34/y8iynQzplxwkBKsK?=
 =?us-ascii?Q?MhC/IvTYola/+Vie0jbgsMlvMZxaPCx7JJGT329ZpfzcW9P5fWFRZFBA1Abf?=
 =?us-ascii?Q?N6x82adIh6UIXznmxSomzirhMqog11SfLW1Iyqy7L+rZsgLsZYZAhNGzK+Wt?=
 =?us-ascii?Q?vZx1XXwA13/hmwZjTFLZXSCb/W+NxkMG0U+FuWjkuIcucS76rHHxXDPYY+aP?=
 =?us-ascii?Q?hT0UxY2SoyCSuQhL2D0q5SFvtKcG+Br14cjN+MOlgQK+t7sWvjYCgdICw8Ct?=
 =?us-ascii?Q?YlZZsTCjLpU0nb56A7glDy/yzXoN0IKVJ6knUR2J5UB82ogGn1+UKnhtk1wh?=
 =?us-ascii?Q?NsWwTFUHVn07Da3Z21uw3sXIim/X6XQOPQ6ZQwBPcfqxgDM/7C6aIPd1EelR?=
 =?us-ascii?Q?O8QRs5yLfaxXEI7j9YdepRY5VJiE2sdieRwmIqtKxCDb050SOW60I0XvqMHQ?=
 =?us-ascii?Q?3/w7KLbjEQG0kIIvCCHxY4HDw/sjCccySOLZvyNW2UPTlcIKFYpaOC32N/Bg?=
 =?us-ascii?Q?g7GnyGXSZPsWZMGZaSoVekfVRLXb1VSEeBk6NALUNYTblCzAMThXYSOi+ZAz?=
 =?us-ascii?Q?nwS/TWLI3Zr0HXEgZAlidDFLfNXPZY+LUQDaFiVdS+QaRb0RhNSg+XAnkqoF?=
 =?us-ascii?Q?SX1/7hVb98h8e1cfGfgFKPymxt6LB9IAroycw+XQUek87Wk+5PztOJDkFpqF?=
 =?us-ascii?Q?ahlKnWZM1Wv0WFB5/p6oFf5Flv7c0iwEKTV3b/LKzQTNE9DehawycID7lqjF?=
 =?us-ascii?Q?4YDp05pnon9nqTna/pgKimf0C8GkpZ/GHBecttI5H+aAOEkSbQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(36860700010)(7416011)(376011)(1800799021)(82310400023);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 12:40:05.9502
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d17d9344-2494-408f-ce9e-08dc91ef475f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8945

Replace the dev_err/alert with pr_err/alert after the sev-guest driver
movement.

No functional change.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/coco/sev/core.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 7cb7a7c41a3b..0112e4c5dbcd 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -2657,8 +2657,7 @@ static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
 	if (is_vmpck_empty(snp_dev))
 		return;
 
-	dev_alert(snp_dev->dev, "Disabling VMPCK%u communication key to prevent IV reuse.\n",
-		  snp_dev->vmpck_id);
+	pr_alert("Disabling VMPCK%u communication key to prevent IV reuse.\n", snp_dev->vmpck_id);
 	memzero_explicit(key, VMPCK_KEY_LEN);
 }
 
@@ -2678,7 +2677,7 @@ static u64 snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
 	 * invalid number and will fail the  message request.
 	 */
 	if (count >= UINT_MAX) {
-		dev_err(snp_dev->dev, "request message sequence counter overflow\n");
+		pr_err("request message sequence counter overflow\n");
 		return 0;
 	}
 
@@ -2914,8 +2913,7 @@ static int __maybe_unused snp_send_guest_request(struct snp_guest_dev *snp_dev,
 		    rio->exitinfo2 == SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN))
 			return rc;
 
-		dev_alert(snp_dev->dev,
-			  "Detected error from ASP request. rc: %d, exitinfo2: 0x%llx\n",
+		pr_alert("Detected error from ASP request. rc: %d, exitinfo2: 0x%llx\n",
 			  rc, rio->exitinfo2);
 		snp_disable_vmpck(snp_dev);
 		return rc;
@@ -2923,8 +2921,7 @@ static int __maybe_unused snp_send_guest_request(struct snp_guest_dev *snp_dev,
 
 	rc = verify_and_dec_payload(snp_dev, req);
 	if (rc) {
-		dev_alert(snp_dev->dev, "Detected unexpected decode failure from ASP. rc: %d\n",
-			  rc);
+		pr_alert("Detected unexpected decode failure from ASP. rc: %d\n", rc);
 		snp_disable_vmpck(snp_dev);
 		return rc;
 	}
-- 
2.34.1


