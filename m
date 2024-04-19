Return-Path: <kvm+bounces-15280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F17498AAF11
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 15:03:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 690F21F21BCA
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 13:03:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AC3812B141;
	Fri, 19 Apr 2024 13:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nUhywHFx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2085.outbound.protection.outlook.com [40.107.244.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC5F129A68
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 13:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713531677; cv=fail; b=W/M4h0+fyfXmgpt8A8RqFUoauihuVv1w6yOuUCJfpYqfb5OaHRS8HhaqF98O+UHyfdCoZpJ97P9+pBdpTXJiEPqHYgMIsDEpBbyWmDvnkW079H0aaLPI6S82VPX473zSjYC+B3mzkyvYMvacS5o7WgKSemNDG7TCUe96WDUs+zw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713531677; c=relaxed/simple;
	bh=eAPyrMINYzkq/OYx/DeUeSYhtx2mDzCe51P1bAUqMK4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hAMFqwO4xf+r9IY9T2gKaCznXKdgxzHpmkDDM34KW4lFb9IRP1zaSY0J0KyRECTjKC83ec4ATcllC1M1o/nlkfY8yJx6JD4sxH4hJnOogpscZC+6NR+bUtSBsE170X27RZNT7mwexIRYfLTuDlEhXDCRGy1ront8/MaieHMIPpI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nUhywHFx; arc=fail smtp.client-ip=40.107.244.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cm8K5Hncy80hNNZsl5v56DQo7HuDNh9DhVEOWESJlcptubwhTOwA8QEHzlzn1m9dKJ595lIPA/p/rQUGce8q1X1tAqrz9vev4PIrYJ/FHoGEJjiHGAKlxGF2o3LKkO3Sp7JqSSy2q+q6ldFaJfk7FtWaqXbIhhkS/qJdjH3zYoq6sYSCD6wJJF+D4fE6Na3ai9kJ+U33T0R3HMv3Y5c6KHgMabu09kWGxHOfK1fS9mjQwyJlXRqVQG1aQ5cdtUiTmyqdY7bXRSsGaAEbXrtPW5JY1fmi/helOUSDiO/QtJmHAYdvAXyqONI6Nigw+FMEU6NoGoksrVoqFv3iRtPwYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TgKIntb4lfdYDdnoxcM6dD3Z1x+9xugo6c/wWHwFBSE=;
 b=Zu46SI0Ymk/LIitr4hHr0prj35zJKtE5nkkLd5q8/pzUUO0hXFIB5fSNuD8NXQKXy2sHL+GUDdf6JsXbPaw3anYzyfyat8ld9STp0mR6N3AFgViAZ67ah4MD3NZ0F/z9sCSr5b/M0gbo3s64YnOKdb1Ce+KY3aSW6jyJBZbdX53XjjbDiZHJFcrC/ei7MV4EhrRmuCPlkX9bv+4TUzTY5Ts5ji52tiiSxP/L3vsmMFlsgqt3gltVpjC7v78QyCEsrfRbxjYORq2NJE1Ox7OMVuguq6C2Z/abGWxcnkOtFKb8aA0Xngl5PrxPf1A6QrSDr1k4mZXI9Tfdg7tETKCEBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TgKIntb4lfdYDdnoxcM6dD3Z1x+9xugo6c/wWHwFBSE=;
 b=nUhywHFxJLpzqi7e7MPcPoNKAoA2jiGi1WNkZpH2PSmz+76aQruYsFm6ERA39t/k46ENRFOLzPZtvbTveKdZP2sCZJutV5BybX423Pr0J8w+ArLqCf0ftrcqk6KAYkoYtRGZjQ7t7WQrh8R0J2EFtNt7645d1/Z7yasEfoFErcQ=
Received: from SA9PR13CA0088.namprd13.prod.outlook.com (2603:10b6:806:23::33)
 by SA1PR12MB8641.namprd12.prod.outlook.com (2603:10b6:806:388::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Fri, 19 Apr
 2024 13:01:10 +0000
Received: from SN1PEPF00036F3F.namprd05.prod.outlook.com
 (2603:10b6:806:23:cafe::ac) by SA9PR13CA0088.outlook.office365.com
 (2603:10b6:806:23::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.14 via Frontend
 Transport; Fri, 19 Apr 2024 13:01:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F3F.mail.protection.outlook.com (10.167.248.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Fri, 19 Apr 2024 13:01:09 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 19 Apr
 2024 08:01:08 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests RFC PATCH 13/13] x86 AMD SEV-SNP: Test-2: Perform Intermix to 2M private to 2M shared PSCs
Date: Fri, 19 Apr 2024 07:57:59 -0500
Message-ID: <20240419125759.242870-14-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3F:EE_|SA1PR12MB8641:EE_
X-MS-Office365-Filtering-Correlation-Id: 3877aa23-388c-4026-f678-08dc6070c8cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	J8nJeJhTNfVETym77ZKf3bg9YSS15Y8PQz42id1UHrGH5Yn9CFZ1BTGS/UEWxROQcxa/xhAhFQXmlUPqBip1CyGbehYMxp9klRTCvOqwDq5pX6bIi9rYZ1VR21OlfhAp+mpdMiJoguXKvaHyILjp/YRirBzS2FG0hkdOetKn1jVDYFe2kGZ3zroB1R+M1+oUyw4xMzL6W0XRK52O6G5ExQ4J+ZxERlmtyUM/n/j2GTTaYuozXa/WJGth+4AQCLOwJjpYr6Lw081EM2hEc4r58KQgEyggJKyg59kwQoAQJWLIv9S0A7EzREmo76inBRbDZM9q+dG8GiByjQ2NMV0lYOPZ66HFppyeEjaN9ib9Y3LxLr+S/3cn8rCvHpQlbW6HvPCf5wQj9phAEzXiK9w3LjaSn7WsjYhkzoGptPpi8PlpbJ7e0VQwe2AzTz8vWRBRMWH3ePCSkliJaL+sVf43C9Q3HyizY/D6kQ6zn5vWW9fcGK1A4hkh4Ar6G8dpja7+pwZbKscTStFKW+F4quke0mYcOV9YzQa0azIyZ8k7+Jv4uLy6iMcKmE8giIXuU1EeJ+7H04XwqEinlfNuQ76NDrumqZSMnW31yQ8GzgNBOGp5SPzdgDyffDENgiaCiHTnSto7i9ECdLZZmYnxpk6M5fZ8txpbE1COOclFuM14mEvp1wH2lUpbisxQ3NZdc6Nr+5PzALR1FjtcMuHZHXPuTT9utSRlfcbjH2PLmcng/KjKfaTL0NJL5YnXVQaNOMaV
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(1800799015)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 13:01:09.9906
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3877aa23-388c-4026-f678-08dc6070c8cd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8641

The test performs the following actions:
1. Allocates a 2M private page (512 4K entries) and performs 2M private
   to shared conversion.
2. Performs a write operation on these un-encrypted pages.
3. Performs partial page state changes (shared->private) on first 256
   sub-pages and conducts a re-validation ('pvalidate') check on one of
   these entries to ensure its state has been changed to private.
4. Performs write test on the other set of sub-pages whose state is shared.
5. Performs PSC from 2M intermixed state to private, backed up with a
   re-validation check on the 2M range to ensure successfull conversion.
6. Performs PSC from 2M private to 2M shared followed by a write
   operation to ensure the 2M page is successfully changed to shared.

The main goal of this test is to ensure 2MB page state changes are
handled properly even if the 2MB range is a mix of private/shared pages.

Suggested-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 x86/amd_sev.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/x86/amd_sev.c b/x86/amd_sev.c
index 7b53ef9c44d0..94944fb80a70 100644
--- a/x86/amd_sev.c
+++ b/x86/amd_sev.c
@@ -657,6 +657,32 @@ static void __test_sev_psc_private(unsigned long vaddr, struct ghcb *ghcb,
 	       "Expected 2M page state: Private");
 }
 
+static void __test_sev_psc_shared(unsigned long vaddr, struct ghcb *ghcb,
+				  bool large_page, pteval_t *pte)
+{
+	allow_noupdate = true;
+
+	set_pte_encrypted((unsigned long)vaddr, 1 << INTERMIX_PSC_ORDER);
+
+	/* Convert the intermixed 2M range to 2M private */
+	sev_set_pages_state(vaddr, 512, SNP_PAGE_STATE_PRIVATE, ghcb,
+			    large_page);
+
+	allow_noupdate = false;
+
+	report(is_validated_private_page(vaddr, large_page, 1),
+	       "Expected 2M page state: Private");
+
+	/* 2M private->shared conversion */
+	sev_set_pages_state(vaddr, 512, SNP_PAGE_STATE_SHARED, ghcb,
+			    large_page);
+
+	set_pte_decrypted((unsigned long)vaddr, 1 << INTERMIX_PSC_ORDER);
+
+	report(!test_write((unsigned long)vaddr, 512),
+	       "Write to a 2M un-encrypted range");
+}
+
 static void test_sev_psc_intermix(bool is_private)
 {
 	unsigned long *vm_page;
@@ -714,6 +740,9 @@ static void test_sev_psc_intermix(bool is_private)
 	if (is_private)
 		__test_sev_psc_private((unsigned long)vm_page, ghcb,
 				       large_page, pte);
+	else
+		__test_sev_psc_shared((unsigned long)vm_page, ghcb,
+				      large_page, pte);
 
 	/* Cleanup */
 	free_pages_by_order(vm_page, INTERMIX_PSC_ORDER);
@@ -724,6 +753,11 @@ static void test_sev_psc_intermix_to_private(void)
 	test_sev_psc_intermix(true);
 }
 
+static void test_sev_psc_intermix_to_shared(void)
+{
+	test_sev_psc_intermix(false);
+}
+
 int main(void)
 {
 	int rtn;
@@ -738,6 +772,7 @@ int main(void)
 		test_sev_psc_ghcb_msr();
 		test_sev_psc_ghcb_nae();
 		test_sev_psc_intermix_to_private();
+		test_sev_psc_intermix_to_shared();
 	}
 
 	return report_summary();
-- 
2.34.1


