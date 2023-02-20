Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2AC469D319
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbjBTSsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbjBTSsX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:48:23 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061a.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::61a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70AB212A6;
        Mon, 20 Feb 2023 10:47:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T+JJla0olOxnhbHBPL9D0pNGBGWu1/JtPM5ULIJvnxosIgI+PsaY0sBfAECsQlOItmjckcQj/4J/RvLxcteje2yIRkm8ji51iCINmNDnvBrvTFstw5EmmthEhlF50z3LikmJj5fheDds56ktxFNfwffliO635E+EC6utPy7vvjOS4tnDOammBEdy3boVa0JKwXKqT99Lgr7EBnx2G3qbc0eXKlzfb3rI449bYrEdusa0hChjhbEGuI8PehWUyzLmK6XdLjpM9qLvoFnejypIKmOI2RtppazTBZgOY8b4bTq8qS7U+9hos4hqM3RvinOu4LMna/6uzVdRC1r798CJJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8hQgEt4zfuohLaU4xMAC3aVGdlY7+WMaFzYsllKiGIY=;
 b=iiILRzl3Ym+bS05JBKW/wnLSDUav0w5nogKzyyUdsbgvGyU8ZX48NOwBRBfo4PuUSPHjls6LkV3hdNr+tyTq7EnfyJp0AYSDut776EyfxymKyCfhMYsTdK2ARYZsBcF2X0IkYeDQ8haUNPa/sx4XbwzQx2pQhPiQxIS2/s7HS9e39L++l+6k/jFuclLgeqHm9P4MqwluH6r4HikaRppF8p/a8onSma48XSyHbWSXPEzLs1Pbnq7ZwMc0R8J8JBX1c7PcjwfaV1cg2BjNsQBu3nNyUBv4tyRrU0JXsxdSB12BlXJZAxu7CZzKB02xwcHBlKZJhtRfpeOhcuPYsHj4Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8hQgEt4zfuohLaU4xMAC3aVGdlY7+WMaFzYsllKiGIY=;
 b=gp6doT3dHJYY8E9gGKjumXpv5LdwdRcCoDckGMKReqljFOVTP3JiwfebMQX3jO2NMN5BiDt3al+TESvoYWnNjDsOIaAlp1Fd8HH7zSL/oq+ORf20SGMSOpQD8b2V0KCd7dzQToUWz5ablhXhuCxKaD6JGTUSARyoDAqkGInk/ho=
Received: from CY5P221CA0113.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:1f::6) by
 MN6PR12MB8513.namprd12.prod.outlook.com (2603:10b6:208:472::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 18:47:02 +0000
Received: from CY4PEPF0000C96A.namprd02.prod.outlook.com
 (2603:10b6:930:1f:cafe::20) by CY5P221CA0113.outlook.office365.com
 (2603:10b6:930:1f::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:47:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C96A.mail.protection.outlook.com (10.167.241.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Mon, 20 Feb 2023 18:47:02 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:47:01 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>
Subject: [PATCH RFC v8 19/56] x86/fault: Return pfn from dump_pagetable() for SEV-specific fault handling.
Date:   Mon, 20 Feb 2023 12:38:10 -0600
Message-ID: <20230220183847.59159-20-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C96A:EE_|MN6PR12MB8513:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b2c1e85-2006-460b-f2d6-08db1372db01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sfiaFB4QrkAGuUpc9aYDo8hy7b2Tra5UUhwn+OhNIo53ij4AQLAHfrvoMTux2P8/TEa8mMsfxRPpaMAdDbhsmA2oY3zmSWPe7hoRDNc01R170JClPW8A9Vpueas1m5YaiIw4CLbIQ3TW8Gte5awLrk45nEoifCkvnB5kagH75Mufqoc282vTTg+B/co7YwTC1ndv/BYlMrqeH+ljhxR3/o1kvqfV4AiT3Ec+MDZleuIIEeACB7i/dN045+g3Y2FFkTNK89akTy17AiapDBaeh9D0e+6tcwe9B0MnDJQHM4ROMgBZt+nA5bNU/38u6mEd7uj6Jd/4LtdgSpE4LzwNUGQIQJsQ/W1S1o3m5wyxkfj6ddDT0eUyHjjK+TZ4S6pJ3xyP/7hoPmJwZjlYtFqLbl0fvylazK7KFMcY2cSHUES/9Zd3lu+Tq6lnKohZ3GNsekdMKH7Xzwl/7/Tr/FyLSp8IGD0lqfgOkHNp4NRlk5p5ZME/pn3eoTaKi5GZHWBO6oP/8tptiTd0Ai1c/Pe5ZCV/6ftdrUCPc7/QOwCWo3djpvf32B215zUnroMc3AV4Ym7e/0AZkUgf6fMeAryU3VGAiXQkbDIygQtQK1V9PPcS24nnXjwpyI9kfW++ZUlucZSFDzOevOrrB+bpa7+3iXkk5/Opds9GtI1cURI+V63FwX/YZdg7NXh1WlaSQahLWajjE1NSAOIlfH9dDh7KKC3JcoXYCsd6efT9Bd8c1LA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(6666004)(47076005)(478600001)(426003)(4326008)(6916009)(83380400001)(2616005)(336012)(70206006)(1076003)(16526019)(70586007)(8676002)(41300700001)(7416002)(5660300002)(7406005)(8936002)(36860700001)(44832011)(2906002)(82740400003)(81166007)(40480700001)(356005)(26005)(54906003)(316002)(186003)(36756003)(82310400005)(86362001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:47:02.3500
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b2c1e85-2006-460b-f2d6-08db1372db01
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C96A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8513
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Return pfn from dump_pagetable() to do SEV-specific
fault handling. Used for handling SNP RMP page fault.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/mm/fault.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index afd4cde17001..f2b16dcfbd9a 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -311,7 +311,7 @@ static bool low_pfn(unsigned long pfn)
 	return pfn < max_low_pfn;
 }
 
-static void dump_pagetable(unsigned long address)
+static unsigned long dump_pagetable(unsigned long address)
 {
 	pgd_t *base = __va(read_cr3_pa());
 	pgd_t *pgd = &base[pgd_index(address)];
@@ -345,8 +345,10 @@ static void dump_pagetable(unsigned long address)
 
 	pte = pte_offset_kernel(pmd, address);
 	pr_cont("*pte = %0*Lx ", sizeof(*pte) * 2, (u64)pte_val(*pte));
+	return 0;
 out:
 	pr_cont("\n");
+	return 0;
 }
 
 #else /* CONFIG_X86_64: */
@@ -367,10 +369,11 @@ static int bad_address(void *p)
 	return get_kernel_nofault(dummy, (unsigned long *)p);
 }
 
-static void dump_pagetable(unsigned long address)
+static unsigned long dump_pagetable(unsigned long address)
 {
 	pgd_t *base = __va(read_cr3_pa());
 	pgd_t *pgd = base + pgd_index(address);
+	unsigned long pfn;
 	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
@@ -388,6 +391,7 @@ static void dump_pagetable(unsigned long address)
 	if (bad_address(p4d))
 		goto bad;
 
+	pfn = p4d_pfn(*p4d);
 	pr_cont("P4D %lx ", p4d_val(*p4d));
 	if (!p4d_present(*p4d) || p4d_large(*p4d))
 		goto out;
@@ -396,6 +400,7 @@ static void dump_pagetable(unsigned long address)
 	if (bad_address(pud))
 		goto bad;
 
+	pfn = pud_pfn(*pud);
 	pr_cont("PUD %lx ", pud_val(*pud));
 	if (!pud_present(*pud) || pud_large(*pud))
 		goto out;
@@ -404,6 +409,7 @@ static void dump_pagetable(unsigned long address)
 	if (bad_address(pmd))
 		goto bad;
 
+	pfn = pmd_pfn(*pmd);
 	pr_cont("PMD %lx ", pmd_val(*pmd));
 	if (!pmd_present(*pmd) || pmd_large(*pmd))
 		goto out;
@@ -412,13 +418,14 @@ static void dump_pagetable(unsigned long address)
 	if (bad_address(pte))
 		goto bad;
 
+	pfn = pte_pfn(*pte);
 	pr_cont("PTE %lx", pte_val(*pte));
 out:
 	pr_cont("\n");
-
-	return;
+	return pfn;
 bad:
 	pr_info("BAD\n");
+	return -1;
 }
 
 #endif /* CONFIG_X86_64 */
-- 
2.25.1

