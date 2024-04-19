Return-Path: <kvm+bounces-15281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 77AE18AAF12
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 15:03:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B1541C21DA3
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 13:03:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8BA512BEA0;
	Fri, 19 Apr 2024 13:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="n/4Jy7vJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2050.outbound.protection.outlook.com [40.107.100.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF2D1292F2
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 13:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713531697; cv=fail; b=mFtOIZQAqeVkfih01GjjU1ijnGO7f0ccmEh1d/IC50kHAga15m8x08SxngpWG0p2VheKuci7PO9IOpOj47uAFRKql5NtS9L/zOWvz5M2YbaQe7jXGivlkrfnOOdCkfm9cwRSKoCr9VDPYyTMsrtR2lqELT+KiowWoO5bE8NqJxQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713531697; c=relaxed/simple;
	bh=cmdEIbEGRDAZW9ZtHlM3DJnerPFCVq0BzWj1SEqJLMQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fa5aA4wNAM7gFAbHMWtK+SNOhbBjMP1FnlNE8GKvkWC9KI0spnXg9umAIUtDaFn4eIJ5OoTRwxs/dwSpAwb0F3qukTstE0rj7GmGK3vPbGjXhvZzpUOQwengZxXFcBvopd8GIHl2YnX/YJUvHMTFwYvmyklSId5GuddkEPfaABA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=n/4Jy7vJ; arc=fail smtp.client-ip=40.107.100.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PXQcUpASetya4fYsdXbsIdizaadSMC71B5TDxvgDUb8IeDOqMYmJstSTYCt//YECdLkFUYj9+jAtox0cNNFSL7Lp1IfdZ2iWo2ttuYZwFmfN2lr5rjoLGkP+A6Kj/5/qhky6w+HFAn4YGvQUut53/D84P8H/2z81zsGqxG/4lvp2AwNsnke3adxhzO4hhIEHwPvxPXPcMRGAvY6g59JrkBA34Tmo+6oR689lInvPzGlw5YnazeRmSztVEUGxJpKYjPyS2ciZ6350V86nD2kL6yPM2KeWntwrDaN/2bt7ngEhF2ijw7iXnE2GejDLq0JZr88VoW0yjcoXRi1mHcuvEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lfbahi6+95dnkBaFIA+C7oizvqWDLkrqrVnVEgG+U2w=;
 b=lEd9l2pYlLdOHyTNQJV4gwfRQdsp3Wuucqr5qD49kJ/dWJMIf/pQigpGGxaVDMCFKT6TOqVTdldgi51puPo1gV2ea96qVGkk+ZaQDfDQLH51ahPq4zACgkeLE2eDSDsEsMcRDK1KG9egSe3QBv2L0CadSu2xDxI0VaHIN3uIp6Yc7hccpmg4138zJElrxoobQKzj3stj0gWQ1NfSN1YI7LWzK8eraSv3uHT9NgITim6bYQLbssSUsY2YEqo8rKHAdDrkyV0OcFYGmJ7ndHiSF1nmuCEGkYEkHHDy/uxGmwj+Wd5WuAYMlR/MzKo+BjJt41+OevOAb/i9xarSviPVEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lfbahi6+95dnkBaFIA+C7oizvqWDLkrqrVnVEgG+U2w=;
 b=n/4Jy7vJZ0x8d54lzUx1vKfZScjb01378GoXbpHNMyDW1wPuee+K5pO72ht9zXxqLUycHCx54OT725K4Rw1zm2F59nmUM79GX+usrmuhFjtexxE2BpW54Aq+wZoO9i8XvFAcUrN4/zed0GhlebBRqKSjyhpAz7UOWpTzZuyN9Xk=
Received: from PH0PR07CA0001.namprd07.prod.outlook.com (2603:10b6:510:5::6) by
 DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7472.37; Fri, 19 Apr 2024 13:01:01 +0000
Received: from SN1PEPF00036F3C.namprd05.prod.outlook.com
 (2603:10b6:510:5:cafe::fc) by PH0PR07CA0001.outlook.office365.com
 (2603:10b6:510:5::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.31 via Frontend
 Transport; Fri, 19 Apr 2024 13:01:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F3C.mail.protection.outlook.com (10.167.248.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Fri, 19 Apr 2024 13:01:00 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 19 Apr
 2024 08:00:58 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests RFC PATCH 12/13] x86 AMD SEV-SNP: Test-1: Perform Intermix to 2M Private PSCs
Date: Fri, 19 Apr 2024 07:57:58 -0500
Message-ID: <20240419125759.242870-13-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3C:EE_|DS0PR12MB6583:EE_
X-MS-Office365-Filtering-Correlation-Id: 7312e099-5ef2-4b86-12f9-08dc6070c357
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vtbMCZEANUkkZqgvLrlOyeT2LXHjHS6OmaTPLL6AWkrZZI4fRkqblgDH+nFImQ/z35SeuzHE6uyUK/r8Y48xmQhIrbZbVSMIFcx18kkyW8ieIIvBB5zU6pegpswsbm8npJf1AN1hokYrcj7HmBegWQmQA4C5bqaJriF08ig/PSgY4/wLcoBS2+DiTRtJQhMpJraFDDXXqaA5H3YKo8n9CKe1MEIaUli3cAFoR3tY7HzTtOeZ6HQNGG8nOixuXcOLIL4XUf74tWkNy8+8c7rcLrdhoHVaAzl3mkMPzRAsAERseGLhSu9tUSaoVPvUrCR23m27eGBrv1UIrbBnKdCfHx0poCqWwAHld3K9IfoxunFq2SU3JI8NQsj47Ajraa4p8Q4ONbjiR5S1L31SPDrzwZHBkyEpobdrdk/9FoibJ0fjEX2P8tNbSrFp7D+BiiNIc1UXcZ4yhCnZCuxHabaGdeIV03BLeArBhU3IzLTKrIGPpFVWNJM4p6qoSSR9QDXWkTEv5n2Ok04pnb3ZQ+CGLh6PPeqfabJUkX2583aoDK5RNq/tYBEMYDOqW5DryQ60F3T1nD2s1/CRMj9korjhB2eVtFEmpYyRs8BG1aVbQ8OS6WYQGunr74SSUYwgcST3kWCJbq91xlmiPO7FrDbLttZhe/Q6+6PhUYiX/eJP41S1uFJc4gHnjuJzbS9h7kllwLJYhkhJX4Y4z8mi6N6wAsTAGZ0Gi47DNrxID0/aibjW3WSQV55FtC/Xn2caw03a
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(36860700004)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 13:01:00.7447
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7312e099-5ef2-4b86-12f9-08dc6070c357
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6583

The test performs the following actions:
1. Allocates a 2M private page (512 4K entries) and converts the entire
   range to shared.
2. Performs a write operation on these un-encrypted pages.
3. Performs partial page state change conversions on first 256 4K
   entries and conducts a re-validation test on one of these now-private
   entries to determine whether the current page state is private or
   not.
4. Also conducts a write test on the 256 4K shared entries (with C-bit
   unset on PMD) to ensure these are in shared state.
5. Converts the whole 2M range from an intermixed state to private and
   runs a re-validation check on the now-private 2M page.

Since the test performs partial page state changes within 2M range,
pvalidate would result in a failure in the form of
PVALIDATE_FAIL_NOUPDATE since the test would perform same page state
change operation on the entries that are already in the same state. Do
not treat RMP entry validated bit unchanged as an error for this test.

The primary goal of this test is to determine whether a shared->private
conversion on a 2M range containing a mix of shared and private entries
is handled properly by the hypervisor or not. Such a PSC from an
intermixed state may never take place in a conventional SEV-SNP guest.

Suggested-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 x86/amd_sev.c | 101 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 98 insertions(+), 3 deletions(-)

diff --git a/x86/amd_sev.c b/x86/amd_sev.c
index 6c6fe8e05adb..7b53ef9c44d0 100644
--- a/x86/amd_sev.c
+++ b/x86/amd_sev.c
@@ -22,8 +22,10 @@
 
 #define TESTDEV_IO_PORT 0xe0
 #define SNP_PSC_ALLOC_ORDER 10
+#define INTERMIX_PSC_ORDER 9
 
 static char st1[] = "abcdefghijklmnop";
+static bool allow_noupdate;
 
 static int test_sev_activation(void)
 {
@@ -136,15 +138,22 @@ static void pvalidate_pages(struct snp_psc_desc *desc)
 			for (; vaddr < vaddr_end; vaddr += PAGE_SIZE) {
 				pvalidate_result = pvalidate(vaddr, RMP_PG_SIZE_4K,
 							     validate);
-				if (pvalidate_result)
+				if (!allow_noupdate && pvalidate_result)
+					break;
+				else if (allow_noupdate &&
+					 (pvalidate_result &&
+					  pvalidate_result != PVALIDATE_FAIL_NOUPDATE))
 					break;
 			}
 		}
 
-		if (pvalidate_result) {
+		if (!allow_noupdate && pvalidate_result)
+			assert_msg(!pvalidate_result, "Failed to validate address: 0x%lx, ret: %d\n",
+				   vaddr, pvalidate_result);
+		else if (allow_noupdate &&
+			 (pvalidate_result && pvalidate_result != PVALIDATE_FAIL_NOUPDATE))
 			assert_msg(!pvalidate_result, "Failed to validate address: 0x%lx, ret: %d\n",
 				   vaddr, pvalidate_result);
-		}
 	}
 }
 
@@ -630,6 +639,91 @@ static void test_sev_psc_ghcb_nae(void)
 	free_pages_by_order(vm_pages, SNP_PSC_ALLOC_ORDER);
 }
 
+static void __test_sev_psc_private(unsigned long vaddr, struct ghcb *ghcb,
+				   bool large_page, pteval_t *pte)
+{
+	allow_noupdate = true;
+
+	set_pte_encrypted((unsigned long)vaddr, 1 << INTERMIX_PSC_ORDER);
+
+	/* Convert whole 2M range back to private */
+	sev_set_pages_state(vaddr, 512, SNP_PAGE_STATE_PRIVATE, ghcb,
+			    large_page);
+
+	allow_noupdate = false;
+
+	/* Test re-validation on the now-private 2M page */
+	report(is_validated_private_page(vaddr, large_page, 1),
+	       "Expected 2M page state: Private");
+}
+
+static void test_sev_psc_intermix(bool is_private)
+{
+	unsigned long *vm_page;
+	bool large_page = false;
+	pteval_t *pte;
+	struct ghcb *ghcb = (struct ghcb *)(rdmsr(SEV_ES_GHCB_MSR_INDEX));
+
+	vm_page = alloc_pages(INTERMIX_PSC_ORDER);
+	assert_msg(vm_page, "Page allocation failure");
+
+	pte = get_pte((pgd_t *)read_cr3(), (void *)vm_page);
+	assert_msg(pte, "Invalid PTE");
+
+	if (!pte && IS_ALIGNED((unsigned long)vm_page, LARGE_PAGE_SIZE)) {
+		install_large_page((pgd_t *)read_cr3(), (phys_addr_t)vm_page,
+				   (void *)(ulong)vm_page);
+		large_page = true;
+	}
+
+	pte = get_pte_level((pgd_t *)read_cr3(), (void *)vm_page, 1);
+	if (!pte)
+		report_info("Intermix test will have 2M mapping");
+
+	/* Convert the 2M range into shared */
+	sev_set_pages_state((unsigned long)vm_page, 512,
+			    SNP_PAGE_STATE_SHARED, ghcb,
+			    large_page);
+	set_pte_decrypted((unsigned long)vm_page, 1 << INTERMIX_PSC_ORDER);
+
+	report(!test_write((unsigned long)vm_page, 512),
+	       "Write to a 2M un-encrypted range");
+
+	set_pte_encrypted((unsigned long)vm_page, 1 << INTERMIX_PSC_ORDER);
+
+	/*
+	 * Convert half sub-pages into private and leave other
+	 * half in shared state.
+	 */
+	sev_set_pages_state((unsigned long)vm_page, 256,
+			    SNP_PAGE_STATE_PRIVATE, ghcb, false);
+
+	/* Test re-validation on a now-private 4k page */
+	report(is_validated_private_page((unsigned long)vm_page, false, 1),
+	       "Expected 4K page state: Private");
+
+	/*
+	 * Unset C-bit on 2M PMD before issuing read/write to these
+	 * 256 4K shared entries.
+	 */
+	set_pte_decrypted((unsigned long)vm_page, 1 << INTERMIX_PSC_ORDER);
+
+	report(!test_write((unsigned long)vm_page + 256 * PAGE_SIZE, 256),
+	       "Write to 256 4K shared pages within 2M un-encrypted page");
+
+	if (is_private)
+		__test_sev_psc_private((unsigned long)vm_page, ghcb,
+				       large_page, pte);
+
+	/* Cleanup */
+	free_pages_by_order(vm_page, INTERMIX_PSC_ORDER);
+}
+
+static void test_sev_psc_intermix_to_private(void)
+{
+	test_sev_psc_intermix(true);
+}
+
 int main(void)
 {
 	int rtn;
@@ -643,6 +737,7 @@ int main(void)
 	if (amd_sev_snp_enabled()) {
 		test_sev_psc_ghcb_msr();
 		test_sev_psc_ghcb_nae();
+		test_sev_psc_intermix_to_private();
 	}
 
 	return report_summary();
-- 
2.34.1


