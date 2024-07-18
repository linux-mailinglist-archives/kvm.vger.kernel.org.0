Return-Path: <kvm+bounces-21844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E9B78934D7D
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 14:52:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 775891F23B13
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 12:52:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67D4913C80F;
	Thu, 18 Jul 2024 12:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bNkjlnxz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2069.outbound.protection.outlook.com [40.107.95.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA6213BC30
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 12:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721307142; cv=fail; b=jwrA6ONOGyoyFyjMma+mP72ZjvhcjvgtBIrc0X89RYCdR4FnuSKoKtPBNwz3tEPnJRBz6+/J/yd8xeZnvQ3zyEkwtnaWyif2uizWwzs44CM/x2y563de7iDzWnKOWG0DVnTC0T2W1S096hufWRbeQpZQeXcf09fM80Wmh2sx7yk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721307142; c=relaxed/simple;
	bh=AW/3ZT400K66JaMB4IpKyRjQpVy/r0TJFUIYnQQKS1I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=irnKNv0UJvf9GdvqrCyuCVDK9JXkE6oqZO8xLkycw3qO99r9AAG4qOavPjESNE1Fem9akZh8DD+0KEIrpd4/gPOHmPOtSxWd0R3aEkk8xHZ+xp1L0AJUnDs4WidgIhffFU+IZkhSJyC/MIoCcKj1egEt61xYW/Y5sWMfAxb4auk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bNkjlnxz; arc=fail smtp.client-ip=40.107.95.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B+vTbil+iHaPTq8L4Rogpxv3P5RwDFgIGO8F71Xc8ZWlS66PRy6w4jUrNb5yiLDAj/3OIwFaJWqsVoN6UuaSF84C/Pcy7rm9jn4CroqPyW7deHx1qLUU62ti1A424dIfMLKsZSNJ5WRn8ByKTKtWS3JxAPIBS1UD0sYLZW+ZodCHg4kaLvVdTy3IEX/4ldGySTwJjGHOwRrkum+H6xC3IpjqVVbrwFu+Lf4fbRo+SgEy/ahq1B+9uC67sg5JiEVDEeYoGP7Y0qWzdNJiJEgumYZu/TWUi8AxkElxlmh3ZeYQYYWYgb6y1gpJ6e436RtIFXSKQntGHKxli+SkwcCf4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CCqB4wHkjK/5hqTbTwp/RnPyF0UhjgQa2pNWJQ81RpU=;
 b=sYOIGpAOTyekciHxBZBkVzXAamMqI5FNzJE5phUnm4LHWWrbfOURVEs4gwj0ebywmOhMA1z/2eESUD0AhI74MWB2v0tVQrk3+XLccyzohXTUdo1O6uxySkiGZej4NUP6l/KEBhofXc8UTmtoS4u1iHgzIlx/dPSMmWGN956j8eu2HqGPganND+KJB9snZTpLRBvgf2XE34GZyk8ifn6EUgTvr1Y49pE2aC3jL73EMsSFgge7a7YTws3VbMt+00/t855eVwVlBVObkWNq00LFamysPDwB/aTAZZivCDqskNfKb/8YnGsK5Codq8TeKxEX1qeAHdo25u5T0SzWejqxcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CCqB4wHkjK/5hqTbTwp/RnPyF0UhjgQa2pNWJQ81RpU=;
 b=bNkjlnxzVulXVfh9BWfiXbZzZb+UPsaOOdVtnepVoU0vFdMEDSR7GqCTbK2Ty46XAilFVXp0pWUPqrh1AuE7K4EuND4yJUCrBnAKUmwM0tMc9TWpZfRFyMabJwCe/DsMyQiKotpNwK4Hw+DEcQhVA9fZ0jL4ytiZDe5Sgt4wJIo=
Received: from DM6PR03CA0066.namprd03.prod.outlook.com (2603:10b6:5:100::43)
 by SN7PR12MB7156.namprd12.prod.outlook.com (2603:10b6:806:2a7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.17; Thu, 18 Jul
 2024 12:52:17 +0000
Received: from CH3PEPF00000016.namprd21.prod.outlook.com
 (2603:10b6:5:100:cafe::92) by DM6PR03CA0066.outlook.office365.com
 (2603:10b6:5:100::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28 via Frontend
 Transport; Thu, 18 Jul 2024 12:52:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000016.mail.protection.outlook.com (10.167.244.121) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.5 via Frontend Transport; Thu, 18 Jul 2024 12:52:16 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 18 Jul
 2024 07:52:15 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests PATCH v2 13/16] x86 AMD SEV-SNP: Change guest pages from Intermix->Private using GHCB NAE
Date: Thu, 18 Jul 2024 07:49:29 -0500
Message-ID: <20240718124932.114121-14-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240718124932.114121-1-papaluri@amd.com>
References: <20240718124932.114121-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000016:EE_|SN7PR12MB7156:EE_
X-MS-Office365-Filtering-Correlation-Id: 95b775f7-9cf3-4cb4-e846-08dca728740c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RdpxXtD0uNBdcARqzLTcOzERoxt11rlUvF+zF8jsOpqPcunvkFrJ4ysOa7PV?=
 =?us-ascii?Q?peORImZ534zq6cV0QB4DgKc37pO0gsDbBjVfi8o3W/JlU5qvWbchdJYk7GWa?=
 =?us-ascii?Q?IGFXd10KfweNuU+iEHoZSdIJAwLslf0YLX59+S1tQ6f9LYay4xzTCjU+eRhg?=
 =?us-ascii?Q?uMBWTvz06DPnWacK0nGLJK3/B5tJ/Qtj49v/SvSS5AFMqIYQkmlwUGY9pNyM?=
 =?us-ascii?Q?fSSm4HYwLl0CeNub3uVIq5Q1hBr0GSSjPKSZtdBl5OGGnppXZOwGxpWtiZTC?=
 =?us-ascii?Q?NkoB5LboQuN396RBFG0+G0/eikuHJK3ZbbxezYBU1m0Zmm9upkmbRgHI2tIE?=
 =?us-ascii?Q?inLMjghcg4Ed3K8w4Kqtj/+a+19hX64iEpglKPQethHObAgcOMtlZntV+KET?=
 =?us-ascii?Q?NhJVycIASrWhnEvoacTEiru947Z6Uqi+BEC18DsZ1R7xgWfr8ge6lJ630QUl?=
 =?us-ascii?Q?pEUPU0tLPOCUhsZzawtY62QaxrXGDSsS68Iw1PHdNWRkK5qGg/91M5e5NV/O?=
 =?us-ascii?Q?fMgg7YblNfPVkGhkn8NKTL3DaH+mbg+cHkkRJrEZNgOOzplfhyujygBtYski?=
 =?us-ascii?Q?ODjQv+hegJBw4yMqUHfvwzJX1ra4lGQjzu5RvQr7GPnxJyGM68MVi8r5rCG6?=
 =?us-ascii?Q?M8Fxk4egEdBrcK3LTSmKJAY+duHKC6CW8lHNdTy5/ivFaAK8Z9fo1akQVAG7?=
 =?us-ascii?Q?QoCd1BxqCxH1vBMuFFdwcU6OjdnnB47/3HM81tucHUl2sprVlY2VNzrK/WGA?=
 =?us-ascii?Q?Qjl9GZOd9lbYwwcvY6Ag4EAMlafjOHrAhNzA+ugycV+rN1GH2qZZfzIgj0/k?=
 =?us-ascii?Q?KB5Hs4bmPOLNzm2683e3gKfBL5xVTzIlnPurXszueBKgjfFRpTXHqld2glH2?=
 =?us-ascii?Q?H7s4HZxX0490h8TGxB7P/BBQ6Y7WTPz6p/GVT8hENB2mF94BGO+Brme4uMSx?=
 =?us-ascii?Q?ioEDNJRQhKabUsVJmV+KmiJUGKR3HcMGynPWFleAW36EpOyoHTBD+Bun3Ss6?=
 =?us-ascii?Q?eq8rcrbJus7GGWEes5rnKBgOrAsRG5pZwKuyc/StvGf0ltZD70arQmM57jTG?=
 =?us-ascii?Q?5Fxw4poMlR1UYP+mPaMy4cVuA17h7sQHLuHAi6YzoJ2SR42Y7in3n3IuzK3m?=
 =?us-ascii?Q?fB6PDjM7iR4GlX4DHfQX7X+F2dXC26SYObfIDtS0e40z3LIvtRKal3IIO2oE?=
 =?us-ascii?Q?ja13wx7Yxa0uloLsUNWl8a5wj+RCXNWDWSyjyRaVngE8q4300dVUfOQBkbQN?=
 =?us-ascii?Q?4FKY4BQjIiQevJ6ayCOYk/hqsiM7nqNQQVMXq/pk+w/9o9P4zlMNbTF+ZdIa?=
 =?us-ascii?Q?rMN4esZ656OUMGmfZuKgpklld7x1Ay5TJZDfUO+xnMS0Q6k5zpCwI7T1llSe?=
 =?us-ascii?Q?BK+mTCuOsFwhgI4fuw3DuQwFJCpfSUL3P+zrXW1E3CcrfA94IIIsR6+9dSZz?=
 =?us-ascii?Q?NTGdCLprNLc0zhkGb1PFvSkPFM+2QzaA?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 12:52:16.6520
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95b775f7-9cf3-4cb4-e846-08dca728740c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000016.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7156

The tests perform the following actions:
1. Allocates a 2M private page (512 4K entries) and converts the entire
range to shared.
2. Performs a write operation on these un-encrypted pages.
3. Performs partial page state change conversions on the first 256 4K
entries and conducts a re-validation test on one of these now-private
entries to determine whether the current page state is private or not.
4. Converts the whole 2M range from an intermixed state to private and
perform a re-validation check on the now-private 2M page.

The goal of this test is to ensure 2M page state changes are handled
properly even if 2M range contains a mix of private/shared pages.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 x86/amd_sev.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/x86/amd_sev.c b/x86/amd_sev.c
index 12fe25dcdd0a..fc385613b993 100644
--- a/x86/amd_sev.c
+++ b/x86/amd_sev.c
@@ -290,6 +290,59 @@ static void test_sev_psc_ghcb_nae(void)
 	snp_free_pages(SEV_ALLOC_ORDER, SEV_ALLOC_PAGE_COUNT, vaddr, ghcb, true);
 }
 
+static void __test_sev_psc_private(unsigned long vaddr, struct ghcb *ghcb,
+				   int npages, bool allow_noupdate)
+{
+	set_pte_encrypted(vaddr, npages);
+
+	/* Convert the whole 2M range back to private */
+	sev_set_pages_state(vaddr, npages, SNP_PAGE_STATE_PRIVATE, ghcb,
+			    allow_noupdate);
+
+	report(is_validated_private_page(vaddr, RMP_PG_SIZE_2M),
+	       "Expected page state: Private");
+}
+
+static void test_sev_psc_intermix(bool to_private)
+{
+	unsigned long vaddr;
+	struct ghcb *ghcb = (struct ghcb *)(rdmsr(SEV_ES_GHCB_MSR_INDEX));
+
+	/* Allocate a 2M private page */
+	vaddr = (unsigned long)vmalloc_pages((SEV_ALLOC_PAGE_COUNT) / 2,
+					     SEV_ALLOC_ORDER - 1, RMP_PG_SIZE_2M);
+
+	/* Ensure pages are in private state by checking the page is private */
+	report(is_validated_private_page(vaddr, RMP_PG_SIZE_2M),
+	       "Expected page state: Private");
+
+	sev_set_pages_state(vaddr, (SEV_ALLOC_PAGE_COUNT) / 2,
+			    SNP_PAGE_STATE_SHARED, ghcb, false);
+
+	set_pte_decrypted(vaddr, (SEV_ALLOC_PAGE_COUNT) / 2);
+
+	set_pte_encrypted(vaddr, (SEV_ALLOC_PAGE_COUNT) / 2);
+	/* Convert a bunch of sub-pages (256) to private and leave the rest shared */
+	sev_set_pages_state(vaddr, 256, SNP_PAGE_STATE_PRIVATE, ghcb, false);
+
+	report(is_validated_private_page(vaddr, RMP_PG_SIZE_4K),
+	       "Expected page state: Private");
+
+	/* Now convert all the pages back to private */
+	if (to_private)
+		__test_sev_psc_private(vaddr, ghcb, (SEV_ALLOC_PAGE_COUNT) / 2, true);
+
+	/* Free up all the used pages */
+	snp_free_pages(SEV_ALLOC_ORDER - 1, (SEV_ALLOC_PAGE_COUNT) / 2,
+		       vaddr, ghcb, true);
+}
+
+static void test_sev_psc_intermix_to_private(void)
+{
+	report_info("TEST: 2M Intermixed to Private PSC test");
+	test_sev_psc_intermix(true);
+}
+
 int main(void)
 {
 	int rtn;
@@ -309,6 +362,7 @@ int main(void)
 		init_vpages();
 		test_sev_psc_ghcb_msr();
 		test_sev_psc_ghcb_nae();
+		test_sev_psc_intermix_to_private();
 	}
 
 	return report_summary();
-- 
2.34.1


