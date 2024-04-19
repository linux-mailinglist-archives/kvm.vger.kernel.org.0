Return-Path: <kvm+bounces-15279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19F498AAF0C
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 15:02:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D8B51C21F13
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 13:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D830128366;
	Fri, 19 Apr 2024 13:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2QNlKqBX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2076.outbound.protection.outlook.com [40.107.95.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EAC127B72
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 13:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713531652; cv=fail; b=R2f8HuTXrDjOLzg/HTO40iQjB9U7RcKLIJGQZ3fREda2DHWBt8FHWEY95WAdSVjlOhorwO4oOIm0+9ytld6bhVlCp2ftzaFndZb+RTNFFXp7ECXmDwUV2NAs68RGy75b8SZcP3RHshAl/Iy35RyQH6pJjt2Yz/pPeujP/wPI/HU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713531652; c=relaxed/simple;
	bh=qTPaq2w6tJHgF5F2P5b4etvf+15cQ+IRBt4IEfNs7Ng=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K+ff/9XS3IQz1JADgr5c7Y6ezvSO0Ncuu4KYTif03VF1v++Lmfn6mPRGt7YvaOdVf9HEBFaK8MvirUPu1avN1SN11fqV17icgWjqwMqQvYyCXA2/6JJCXOXEbyPVMMDxRZn6Dq8gMBssVy1BvkxI0rdtLYH5MWI3QN+/iIAzObs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2QNlKqBX; arc=fail smtp.client-ip=40.107.95.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mZUe3Z+ZzHqojJLToSdOS595L0fRf568gp8Wul3gVKeuTdUab0Qe38dT4UXFa/qRd+C9MP9hn8W8EKoV5i5PBdmtNFR1Ts8Ok0F5m3QRKGcgVHamH/+180r9Yapkr3Kv6D7VHRniyHa9XlA9nlLos+nv93FARRCUun3zfpde3hgLvh2Am2b1kko/mZcF7TNnJkVePTPOJKSy/5wTV6ZDxIzfZc74rIkJIq5qj1gKItoEbyj1Tl3d57ZfePj2TjHaF/81Jh4+/ZzrU5hdnpdVZMnZcxZo0PmLp7VpaQvkKuEU40tcthNXGMHF/tuzPHWevywXPeM+h7HzSZbNbGme6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Rx6KwqiPujosWWeYieqOjSjnN1S58d9zEmWxddj2to=;
 b=UPD7UA+KbQGnTfAdjJXeoo5WOKqh5g5ug7Zc2cJAhb8FnQA2DIyXOwr6ptfh4+uPdrrEgiTTcnYE9+id9zbkhqMX4TvJKEAyANwx4ce4VZcHoUhA+UnjDSke/pc7DA5MzKDKz8MLmPCo+oA8uY5nEsWGEuMkIrlESYgKMy54b1JVJo4HszyuFQZ3EvWBRRR6Va35HW2YXxsfvjXUpXX8WWcfdoz7lj3T3S9wChLCfo6QMLK5NjkV4rCtAEN5GfYY9IpOrKy/grxKX03vT8Drhnrsd+hYz+SBrXm5cBbvI65EBZiXoSWF0loQEa19lWYOEAWB1CC1d1HZS13+fVDa+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Rx6KwqiPujosWWeYieqOjSjnN1S58d9zEmWxddj2to=;
 b=2QNlKqBXc7aVZWTl5sqpOOKxT6xJ83pSK1RvhHWqwasA6Nrg2DHQxUM0kPUBGptJuU5Jy9LicbLNRFWxhUqC45e1lL6sx2JfXJkL0cqRHxKKHH817jNumRqbGv5F6lkG9zaoRQ83lp33nz+QWm7FN2E75u2P5dOTPwTc7QVEZ7M=
Received: from SN6PR05CA0029.namprd05.prod.outlook.com (2603:10b6:805:de::42)
 by MW5PR12MB5598.namprd12.prod.outlook.com (2603:10b6:303:193::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.42; Fri, 19 Apr
 2024 13:00:46 +0000
Received: from SN1PEPF00036F40.namprd05.prod.outlook.com
 (2603:10b6:805:de:cafe::2a) by SN6PR05CA0029.outlook.office365.com
 (2603:10b6:805:de::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.12 via Frontend
 Transport; Fri, 19 Apr 2024 13:00:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F40.mail.protection.outlook.com (10.167.248.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Fri, 19 Apr 2024 13:00:43 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 19 Apr
 2024 08:00:42 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests RFC PATCH 11/13] x86 AMD SEV-SNP: Change guest pages from Shared->Private using GHCB NAE
Date: Fri, 19 Apr 2024 07:57:57 -0500
Message-ID: <20240419125759.242870-12-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240419125759.242870-1-papaluri@amd.com>
References: <20240419125759.242870-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F40:EE_|MW5PR12MB5598:EE_
X-MS-Office365-Filtering-Correlation-Id: e90d47dd-7faa-4863-5c66-08dc6070b8f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	oDMYq/i4epQWCj+sDw91EHnePPgp4AzeC2JubvgkaMKSDGnWElvvi+IjVPCQCUCl+Cow8JcdQnBSkwvQrpHUHsZuAXLxUzGuepQztbow98BnQMyIA6SX7yThD27Ud2uivqgFz/IyCphvYal6ZkJiHblqnjf6YqNUYC2S8yTD1o+KS+15/b31iQHJlUS2yuNzrjEUPeXFs7pUlz2sjdb6wldaf7j64ycxJgpdnHyvmZqSJ+wYnxV6eJVlfpE+XOcBqUbhm6gGIv+NNeCFwD54F9hoMUcxcJ9ztfcZufRA2ODbEjK4sFvl1BKmSn9Mj05SWSMKXPIihe/zXreAIqAejeS2zimCkAtKyyS6tLgs9R6nh0S5yWIueb0c/nK/ORZTXtbSss9bcbDzh81uDdEz16PDXgRT8HZWtLz0Vy87HTwWuNIdvBQbr2iF05ikwVKeDR2/5+dHk9++sV0SQ9phV2DDu1nUy4J5zZjVw1J0dUXvV4x3JkU+9C0V0TIy1gi2MhSzjCaY7lq/UwOpo1ErKwoVIrMDzf5ZBdAzeOdlhB36vQoFEZi5yoHv9+fve1nkFnctA7BeIw9f9vsqV81JicZcp8VMJXroj/5IAA1YLJmSs21LybQP5WHeLNQF2HguyJzKTw6ykWsh2oI/rhtmc0KCBDXFog3Zq8JzdrC/H42P6/Y9/cJNvazlXI6l8sYzklQvEYo5yVW5H6msvCiS31ZGTNvM7kFRntbi4sXTMWkqM5Seocif47DSbWkq59Gp
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(376005)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 13:00:43.3881
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e90d47dd-7faa-4863-5c66-08dc6070b8f0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F40.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5598

Perform page state conversions to private on a range of pages that are
already in a hypervisor-owned state.

The test introduces support for both 4K pages as well as 2M large pages
depending on the order specified.

Perform a write operation on the pages while they are shared pages. After
conversion, run a re-validation test on one of the converted pages to
ensure the page state is private.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 x86/amd_sev.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/x86/amd_sev.c b/x86/amd_sev.c
index 1723a235166b..6c6fe8e05adb 100644
--- a/x86/amd_sev.c
+++ b/x86/amd_sev.c
@@ -615,6 +615,17 @@ static void test_sev_psc_ghcb_nae(void)
 	       "Write to %d un-encrypted pages after private->shared conversion",
 	       1 << SNP_PSC_ALLOC_ORDER);
 
+	/* Shared->Private operations */
+	report_info("Shared->Private conversion test using GHCB NAE");
+
+	set_pte_encrypted((unsigned long)vm_pages, 1 << SNP_PSC_ALLOC_ORDER);
+
+	sev_set_pages_state((unsigned long)vm_pages, 1 << SNP_PSC_ALLOC_ORDER,
+			    SNP_PAGE_STATE_PRIVATE, ghcb, large_page);
+
+	report(is_validated_private_page((unsigned long)vm_pages, large_page, true),
+	       "Expected page state: Private");
+
 	/* Cleanup */
 	free_pages_by_order(vm_pages, SNP_PSC_ALLOC_ORDER);
 }
-- 
2.34.1


