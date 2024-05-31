Return-Path: <kvm+bounces-18479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD2858D5972
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:34:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA98C1C23859
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36F3280045;
	Fri, 31 May 2024 04:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RPEb3HO4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2076.outbound.protection.outlook.com [40.107.95.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4007E0F4;
	Fri, 31 May 2024 04:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717129998; cv=fail; b=RHuXOjckWI9u9O/4ftmzwyAYEE9/KKiPKkUKdd2XVElspkMRNE/LJIZPPVCdZM1nanLHTi71XIorQrUSx3QohQ8wNMXwKSDvHBKn0DkesA9iJLFfYd9QYf9KLUoowrq3vvtZyavnOqk4OTiqpHxfVq52CKn1ZVQVqVTTo03tExQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717129998; c=relaxed/simple;
	bh=OAZsYKVLJyhESfuvF8bUC/4sP3dAE6f67jHjEXBJ9sw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pZEL5bvipCnsWMD96Zmh35dKjEp3siqxaGUoVa0JAYYi/YvfXPFJIpdkRGZ1lyMZEIUZKjOFGUvALZNR4xr1Pqj0pCdT7k7dMI6qFVZIP19Vdxz+M0ezf9Za2Mfv+Kjl3zCeHCSa9Gd7pfCEQTCTfA8tMStjgnLXHMTc5rn/uyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RPEb3HO4; arc=fail smtp.client-ip=40.107.95.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A9zAyEoAZssjwxcnFIalwCYn4+nWqrbwmfNN/ipHFqQHtV0qM9vUarxPslsS4A4u8ayD1L8pTRh1nFqeqFXXyRlkId0GgZKN1NMb9HgBVHzZQlBEz/zqHRzhzk4UsotFgAMWfcmv1OCHPgjBLshpyLCUQXJfK3U9YcthSRFGqX0dQZPsM0jn99COgeOi82Hx9ptpAHHMy2M4FaqzA7GcFHxKO/f2y8VUeQiSRtAI50e5C5GBcNgv0AoUsMXySlm2LP5cBNoT/QMB1kPJe+H1Bk+MGh8v7+BljUWE1khoZmGeAMm8oR4G1loPc93LfUfRbbrQNM61yQlcEKpC5K8cRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jrWrAvvGDMCEgVNFIxyCbpBpZUIKNSAjMrWbRMFXB8U=;
 b=k1HtCSv04t0YL4HWudwvkQDK2uZNt3/Sy4gnvYeYBAlfmKpBYObaMFKM4RV3WOGxOMwElcVd65eo9V8sMewty6KEW0rzTtFbRylbMPMBm7/wHmkpLHE/hiWlSl3ooiOMQUDw3X9pYHYzi9FtxlIDnmOiAnrFNrwu+7fKl1VM15w3QkHstFkKbYBQ8XcRmXakEyQpCZhIdii7yvFc4WvZgulZNXk4/7Ai86xIAgSuNkn/Mk7ENczHSdmHtMmUZQfkec71KIYlazi144PLTPw27HHitiscCLjLRW3VuEl0r4XV1gmTjYlvgzylQGqxnCV66bUB86vYY0YB7FdQR3CwPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jrWrAvvGDMCEgVNFIxyCbpBpZUIKNSAjMrWbRMFXB8U=;
 b=RPEb3HO4Nsv+nDPNf+k5x1CS8aF6jECmEeYc446pJdPqUKWSuS7b2woYgKQmI3vR+HGxiJ/xsYf5JAVNIzf2r97KURt40AwiF/hQrRnRpyjfQqDerxlFujIHMAO1/K4kRXOUiARSBHP/5MKbUe8yCrXN1SVY9pIgRuKGTFpAYhg=
Received: from DM6PR07CA0130.namprd07.prod.outlook.com (2603:10b6:5:330::22)
 by DM6PR12MB4219.namprd12.prod.outlook.com (2603:10b6:5:217::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Fri, 31 May
 2024 04:33:14 +0000
Received: from DS3PEPF000099DA.namprd04.prod.outlook.com
 (2603:10b6:5:330:cafe::52) by DM6PR07CA0130.outlook.office365.com
 (2603:10b6:5:330::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24 via Frontend
 Transport; Fri, 31 May 2024 04:33:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099DA.mail.protection.outlook.com (10.167.17.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:33:14 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:33:10 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v9 11/24] x86/sev: Replace dev_[err,alert] with pr_[err,alert]
Date: Fri, 31 May 2024 10:00:25 +0530
Message-ID: <20240531043038.3370793-12-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240531043038.3370793-1-nikunj@amd.com>
References: <20240531043038.3370793-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DA:EE_|DM6PR12MB4219:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f078f8d-6056-4d21-93e0-08dc812ac976
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|1800799015|376005|36860700004|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?05QY1tqWEYb3TYRND8QoyWIFz+CKBCbL9+F7nBoBe5gXm+GB2xZRqc4N9x+G?=
 =?us-ascii?Q?NHnq16VWe4SaiJrYTL8hIiIMyyO1Z1ZKjeO66/3UZX1DKiqf3xCFU4NwI4gu?=
 =?us-ascii?Q?fwY9wGqsRQRDrEOIMMC8Md7twyaYGCi+wdzL6FCFCaUr4NhfJgTqPRA6lOxs?=
 =?us-ascii?Q?HGIPp4fF4Nl0MbE1Gghpzg4Pnncx9Aov/9V2/oKgF4jBMGPBQDOvp3xyMmnK?=
 =?us-ascii?Q?ymopdJXFaiUAEe3lljsf1OUuBf4gvIEK0aFqsLaWob13nN1hwLWtfl9B9g0E?=
 =?us-ascii?Q?7rq1b4fPMOcnIT55FbjdbIBBw8j0CitdW2ZzJdnKyTvbFuPx3RjzmX7CLhio?=
 =?us-ascii?Q?Ik5gfRLVPsi5wlXhkI0egpnnrbH3tC7QITCfSQyR/r9y/Pk1x3nwxxQtQ51K?=
 =?us-ascii?Q?CdL06/B51GC+tHkajc8QOrZnkK8QmvEkYMz4j/TxrVGpMLBEYm8TLDj65q5t?=
 =?us-ascii?Q?XLwK4JCDNE0DDzLR+XC8JDOHzm3rRAkaoFmh4HCDkkWejv2sD+u146PFL4Mr?=
 =?us-ascii?Q?dmHeiGRKdNwn8ebnEV8MT/P3MvEOdwUgx9O6Dq57ONf0sXAWy6oaptqtaNDX?=
 =?us-ascii?Q?3vrol0hA4DGpgMQEMVfYZGI5lwV/56C733b6pq6zhEBZoE4FxrGmBhNxjaZL?=
 =?us-ascii?Q?LKWAzRjUlVthvWzzn60+JKtqtKSAW/3/P5ITp4EqB2yicvkJYHGOUxF255IT?=
 =?us-ascii?Q?8IkM3f0pi3+uxRWReCPWbB+1mIZZr2ywk8Mtlul9ROD0CAj/Xme3FPDtIpSO?=
 =?us-ascii?Q?AGD852azc+VW7IsZEsIuWJMTbysvHjguYggGVd9ecO3lsgaTh80yyxvhd8WE?=
 =?us-ascii?Q?Wm+BllsweH/Sj6SmZjgAQTFAbmSan0jmG9Yh+Dx48kuNuTrY6E5O9enEZOkD?=
 =?us-ascii?Q?oh6FNKFDytBezHSrjhPLYKPzKOst/2X55gbc3actUcmpjIq50vCBec05LKNC?=
 =?us-ascii?Q?AFNgaxUkLfsCVCPQxSUFbxo9FX22OGmMIF99XxfGzBljysmfkGEuOh26xZPd?=
 =?us-ascii?Q?zvLTf+Bp+V6rDkG4LvfD8g08BVDvcmUJ/b8WHwygeO2i7zqRtSryMoVRKAyb?=
 =?us-ascii?Q?8SZhcU5zrftM4WJIG2LDJyAU1fMkb/sUt+JljD6SZmUTaIxtORtSfb8ORcEA?=
 =?us-ascii?Q?0VlVgm1ezN8zvgqJQrIoWM4i3YTVm6QxUiydrdw37aMBocpbKzzFSRBMq2ub?=
 =?us-ascii?Q?iVvNC6IOEwpxIj0bH1MXOTsXH1wdYpNrmWM9U6LuTca+pUY18sReIjQtJBj+?=
 =?us-ascii?Q?tMC8WI81wfi2CUDxA+0CADuzIyMCkm7Dsa6SIEfOZPad8iAZd/3H4zEvmkGJ?=
 =?us-ascii?Q?LPZSM5IaFpkaUU9saxHk7MG0fGc2iN0fkELHZ+hy2LhfOI7IE0MPvw0TKZiY?=
 =?us-ascii?Q?/TKnIH4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(36860700004)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:33:14.7587
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f078f8d-6056-4d21-93e0-08dc812ac976
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4219

Replace the dev_err/alert with pr_err/alert after the sev-guest driver
movement.

No functional change.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kernel/sev.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 329ae107da4a..c48fbc3ba186 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2352,7 +2352,7 @@ static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
 	if (is_vmpck_empty(snp_dev))
 		return;
 
-	dev_alert(snp_dev->dev, "Disabling VMPCK%u to prevent IV reuse.\n", snp_dev->vmpck_id);
+	pr_alert("Disabling VMPCK%u to prevent IV reuse.\n", snp_dev->vmpck_id);
 	memzero_explicit(key, VMPCK_KEY_LEN);
 }
 
@@ -2372,7 +2372,7 @@ static u64 snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
 	 * invalid number and will fail the  message request.
 	 */
 	if (count >= UINT_MAX) {
-		dev_err(snp_dev->dev, "request message sequence counter overflow\n");
+		pr_err("request message sequence counter overflow\n");
 		return 0;
 	}
 
@@ -2608,8 +2608,7 @@ static int __maybe_unused snp_send_guest_request(struct snp_guest_dev *snp_dev,
 		    rio->exitinfo2 == SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN))
 			return rc;
 
-		dev_alert(snp_dev->dev,
-			  "Detected error from ASP request. rc: %d, exitinfo2: 0x%llx\n",
+		pr_alert("Detected error from ASP request. rc: %d, exitinfo2: 0x%llx\n",
 			  rc, rio->exitinfo2);
 		snp_disable_vmpck(snp_dev);
 		return rc;
@@ -2617,8 +2616,7 @@ static int __maybe_unused snp_send_guest_request(struct snp_guest_dev *snp_dev,
 
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


