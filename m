Return-Path: <kvm+bounces-12622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BEC5C88B3E3
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 23:21:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0D6ABB3C2C4
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 21:37:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCE616EB50;
	Mon, 25 Mar 2024 21:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0H13UgUY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2087.outbound.protection.outlook.com [40.107.92.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5356DCE8
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 21:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711402628; cv=fail; b=O8Ybt32al1hlHYNO/Wb75BURrPOTQiTL8dEKWNiWO84eXahn//LOS8Q+/Z/rn3+NG6aNY6L5aEM8NBOZCKCMGY6aWeheUZdgi86Vy5LFL/EwaM3eWA60lVH0cz1Q7iOgdCzNCOwUsTzPS3T/Z+tKQSPzR+CqUpdGMSphsAgvJM0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711402628; c=relaxed/simple;
	bh=lf8ZYn/AZJiK2o3gy0Y7oxKF+3Wxz36+FD3a1BnVApU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ze+E1wCucOpLvEczL9+mdO0EElzBH6efWlh2GTVk6yR6LklQIM7xDarlxCWGRbpyB6ZAuPBt9X2m/G71ocQKhVON3eF3hFS3MxsqPDyImDDBWuewcxkKQOiwUc7pEqeUHgNDOyqmjH/hmFerW2oaNiEzb2SnozjOrWFS/DV+3ls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0H13UgUY; arc=fail smtp.client-ip=40.107.92.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DqeWjYh7nvIPGKU7KctNpeAKLecx4aOJwH0k/cZEiIqa5+t9J8+p9OEyd2S4rdonyitRUvaRBlyjF6Bjs5dE4bXIxEEA8CPQYDOCOBUVei2PxBH9bpfHVO7CvVOQV3IAqZvK2V1G9h4ND/iKpLr44V4PWvyQM2Yfs8VjvmM2YcksSW4FMggj/QMB4ZAYW0zFVeFQf2k12YcZa3r4VeKGJrS1IUkZ081L2PqOdJChettOgSapid63521KBmo8SSyFLzIvo54R+Q/e6aXmBOzqcLILRdn76Fyv+pDqaNU8GUHI9SofjL6lYpasPgmWixDCJg8Vse8+F2w3Bg09zKOI/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M5FczzBDbmWe+HfjX/xe4wC9zBtoUHwH+MAAw0MP/hE=;
 b=PtKIm3iBm12sMDzGdJgiHDOgiNIKxDisNNEWtVNwr6MzOMub3T962POxX6eAnwk86pYJNOKgY34hZUcjsLMvPh9FKeQ2HcTdDcsGYlzwga1AoKzmUKUWnLXEa6Fib+ProXUKqzFS6Zf8XTmaaLbEhIsASkwFIpY2jUsIFpTTmwyd7ENJSSNrfdeZG8Db3gLAja2AfnZ5VDhZ9xbvNFYlnsZKd5UvGT2vKjNfpCd6fyJ3GfqX6WKQQy9giFdMH88+rJr4tnVs8noxsrgITe7TWzHwT+C+eRqR7DnvtWaJdcl5BZDcU5bwzcNA1ErEbD4JZdaE+NCqXeNgaAeUJfpSYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5FczzBDbmWe+HfjX/xe4wC9zBtoUHwH+MAAw0MP/hE=;
 b=0H13UgUYBS9Jzu0DRJdCV6frpM5OnUrOlnbwYBj2eOOMHXrPYJjByfgyHZhaYIAMhARQAdoyVzZp6FymZ3Ou0RqYuvpRQI7q2Tg34A05jYlPPSQ22+paQE+mMh/C4PJqLnbAuXMJqbcuRzBw5fGIi8WiKAQjJN2wze6N2KAzscs=
Received: from SJ0PR03CA0211.namprd03.prod.outlook.com (2603:10b6:a03:39f::6)
 by SN7PR12MB6792.namprd12.prod.outlook.com (2603:10b6:806:267::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 21:36:59 +0000
Received: from CO1PEPF000066ED.namprd05.prod.outlook.com
 (2603:10b6:a03:39f:cafe::b6) by SJ0PR03CA0211.outlook.office365.com
 (2603:10b6:a03:39f::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.28 via Frontend
 Transport; Mon, 25 Mar 2024 21:36:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000066ED.mail.protection.outlook.com (10.167.249.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Mon, 25 Mar 2024 21:36:58 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 25 Mar
 2024 16:36:57 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: <pbonzini@redhat.com>, <andrew.jones@linux.dev>,
	<nikos.nikoleris@arm.com>, <thomas.lendacky@amd.com>, <michael.roth@amd.com>,
	<amit.shah@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>
Subject: [kvm-unit-tests RFC PATCH 3/3] x86 AMD SEV-ES: Setup a new page table and install level 1 PTEs
Date: Mon, 25 Mar 2024 16:36:23 -0500
Message-ID: <20240325213623.747590-3-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240325213623.747590-1-papaluri@amd.com>
References: <20240325213623.747590-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000066ED:EE_|SN7PR12MB6792:EE_
X-MS-Office365-Filtering-Correlation-Id: c32ff007-aef5-4f7c-441a-08dc4d13b36f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	z10K2+uOEu77jfvRM3IVLRPFrF2b3BpH63eBkrxUx5pOz292eOLMIr3WDUsRb+hBb/7n6zMFdrDe/u6O5/3dGzTWMJwGUPk6/i6VL9C6dhZAQC8lhyYRIrQimI8a2L64mC8uxFMMLP/yF9qfUEDyb52roj2gwV4tdWv6Cr7XX2g+qyKL9qxUXR4rXHJfmv9I1eL21D37MUi7f1BAZujaMNUbWtaElFbwGJnKUEHkRQDCfmWon0qK3IWOzto1ZgtxWlf4u+aFaf8tUC8yUgtqgKaFqRGkR20C9d2wSI/R7W9Ym4tU+7+45ytiFb+4yXi7NfBZ7kY0+VG1NxfyhkpD0Xseh8WStYpOLYujgOfxxrlOT2eJD0LA1Bu5zHfHP9isb6aWaUHof0k1TZw3kZzH9pvSjp0bCzKA3Ty5K/dgImIhNwmgmBTrZFieR+Sj1nUBdItF9iWWbsm2X1iyvwydhQSVnD4fhjHvbzIlikUVsdGj+Iq7FjewlnKVdc560Sk+R8EnoAnfXlk+nnG9dbHsYmwSDEdfkS2JLJDgqSKDz8hYWI04y07N6RcrQVk72OxoQFIMBVwGvPJNauF9NtYN0CyTSc1ipRSq0XTe41kCYDmIfmyxp5o4wgnviLCe8Ywe/Uh/f2vt3e5y/4x5U7CtcTMpF8P4fzrN+TUwE77itbd4YvZwpbpZOSIlvXYtAafZtxNM008VkIY6aRPNpoRwgufknsG5EHc+jkJ1rFgy9mqNHxGp434BLrnu2ds9/78p
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(36860700004)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 21:36:58.8492
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c32ff007-aef5-4f7c-441a-08dc4d13b36f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066ED.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6792

KUT's UEFI tests don't currently have support for page allocation.
SEV-ES/SNP tests will need this later, so the support for page
allocation is provided via setup_vm().

SEV-ES/SNP guest uses GHCB page to communicate with the host. Such a
page should remain unencrypted (its c-bit should be unset). Therefore,
call setup_ghcb_pte() in the path of setup_vm() to make sure c-bit of
GHCB's pte is unset.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 lib/x86/vm.c  | 6 ++++++
 x86/amd_sev.c | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/lib/x86/vm.c b/lib/x86/vm.c
index 90f73fbb2dfd..ce2063aee75d 100644
--- a/lib/x86/vm.c
+++ b/lib/x86/vm.c
@@ -3,6 +3,7 @@
 #include "vmalloc.h"
 #include "alloc_page.h"
 #include "smp.h"
+#include "amd_sev.h"
 
 static pteval_t pte_opt_mask;
 
@@ -197,6 +198,11 @@ void *setup_mmu(phys_addr_t end_of_memory, void *opt_mask)
     init_alloc_vpage((void*)(3ul << 30));
 #endif
 
+#ifdef CONFIG_EFI
+	if (amd_sev_es_enabled())
+		setup_ghcb_pte(cr3);
+#endif
+
     write_cr3(virt_to_phys(cr3));
 #ifndef __x86_64__
     write_cr4(X86_CR4_PSE);
diff --git a/x86/amd_sev.c b/x86/amd_sev.c
index 7757d4f85b7a..03636e581dfe 100644
--- a/x86/amd_sev.c
+++ b/x86/amd_sev.c
@@ -14,6 +14,8 @@
 #include "x86/processor.h"
 #include "x86/amd_sev.h"
 #include "msr.h"
+#include "x86/vm.h"
+#include "alloc_page.h"
 
 #define EXIT_SUCCESS 0
 #define EXIT_FAILURE 1
@@ -89,9 +91,14 @@ static void test_stringio(void)
 int main(void)
 {
 	int rtn;
+	unsigned long *vaddr;
 	rtn = test_sev_activation();
 	report(rtn == EXIT_SUCCESS, "SEV activation test.");
 	test_sev_es_activation();
 	test_stringio();
+	setup_vm();
+	vaddr = alloc_page();
+	if (!vaddr)
+		assert_msg(vaddr, "Page allocation Failure");
 	return report_summary();
 }
-- 
2.34.1


