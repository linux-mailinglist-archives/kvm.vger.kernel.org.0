Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF5464D066
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 20:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiLNTzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239194AbiLNTxp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:53:45 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2308D2C104;
        Wed, 14 Dec 2022 11:52:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LSoX6i0K+8TvDyeDCIU+eauBLa3w5W7GITVE+MH1cOcG8TQkVT1G/sTjyFxHkvn+7DQKbfZjQVmo39kiIBZV8Kw2KowIN2DmT2DKGOt9aCf7vMJsU4mAf0i4Y18lsbcoyQzs3ce7ZJ2sBcZTT5j3/KhqyPBsCY/Ofd0v19SirzyjXYbaS1YFBuSUoojFK6VGrmn/xY+p5SYL9geikWiVIuuPz2ymEmemXyX+HZVkJhiNGgvLMyMyDCT6nWcXmY5d+Pc39uKGERnIrgVOCun9VhtAk5rod/PqBBSEQDBdnEdoyiCQNEggQI6PFIkdWyYl5qqKRkEC217FDTFeJ5CZuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ehh3zB8AkT3HR+8GiQG3Qs2aejsevicxPUxFJxZv7mk=;
 b=WxTUCK05snWn5ISW+9YqecRp/3xoMJQrZMSrxlZNmbSkne4eSYDDEsOvmDyrbl2PeI+spy5vpTpIXKbjKwV5DCH/bo+faFwGJw6SFMZywEhhfXLrg7XKQcVKyLYjTm3EFY+R42gi4F0Kaj0OX3TlZy6AS37zUEdqj+IyT1XqRDfo9sgkeV38V8KND6FEZ6ZChcTEJjZtm0udqlugzy6tyava2mUCcC6lWJw3P/N+uNGdawWGsNDOMsT2+jhHuCUNIONndFqdtPS6hU3L7T4EcBB+eRtGX1wVhysd61miNsmUjJkDZEV06fXPyd+wQVYpAes5TGitB/4Ndw8Kg+t1RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ehh3zB8AkT3HR+8GiQG3Qs2aejsevicxPUxFJxZv7mk=;
 b=bfc2JPN9gP3mSTzNqzMYj4ip9rOxntwTL+pmj+X9MFLIn6DFx7HvGP4wJ1LWclh1h5fjg002rxdIyXqwHVPVrBW9n8UocRGIJdKsSWDwxQ0vYjOeQIDHWi/CtlEfTIIy0IlwY2purrm/UeWCJTbQt+ub3mpWetTdSc3W2wyl5Ng=
Received: from CY5PR18CA0041.namprd18.prod.outlook.com (2603:10b6:930:13::19)
 by PH0PR12MB7864.namprd12.prod.outlook.com (2603:10b6:510:26c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Wed, 14 Dec
 2022 19:52:00 +0000
Received: from CY4PEPF0000C979.namprd02.prod.outlook.com
 (2603:10b6:930:13:cafe::85) by CY5PR18CA0041.outlook.office365.com
 (2603:10b6:930:13::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 19:51:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C979.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.10 via Frontend Transport; Wed, 14 Dec 2022 19:51:59 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:51:58 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>
Subject: [PATCH RFC v7 22/64] x86/fault: Return pfn from dump_pagetable() for SEV-specific fault handling.
Date:   Wed, 14 Dec 2022 13:40:14 -0600
Message-ID: <20221214194056.161492-23-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C979:EE_|PH0PR12MB7864:EE_
X-MS-Office365-Filtering-Correlation-Id: c4c126d3-a80a-4373-8dde-08dade0ca9db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KVjYk4w/HnfWbVhfEPsdQS8zDAZhPUCkgVLygV6jjgjm22Qb1ZMH4LPC03cNp0YMQ8acCe+1vrZ6K/QOgFAWsDLWO3G1V7mDV+Ais7OoiJt2urNLPJrHNMVafJllpcDHVoimWqEduOO9DAb1dJ1ksziCRFG3l86KEydDBnv9PCDt8a3uhpC0iKvqva8mSgEhaXL8zzaGnRg41iHa7JqNrSuBAaHY9FZW3yQrhnBoT191UCFxXyXiJ2bt6OahQEl2arCj3aYFIw/sUj4RLOOe10pXSBviNwK13MhhakDQWDBRpu8OHDkOYtQQpdZt/I44mv+ReI1Ftlie85A1S0plJ24ly2QxZpI/uLxoSJJ8Lz6EHOZBSlvN4dG+2gbcXySTfhQeMCBbzKwmwZ9ZfiJ8kgksLVknuXXCo4cojqcoGPQHQ5KOOwW74kYk0YK1PSzscGg3pgw1xL8OXtDBH5lkSyTDjXVX5UlJ6PxN2dx6N3MyAKMMiKxT+fMdoYMBW/B1UXdUqqqQ4SyvEhIVETQ/xJm+y0uodq9wvn7rQhtbZw/qkKV01DEa+j1RZlywAoY4YyzqYWsPQvE+dhBfXYqolmrKnepkc0s32fkR5YNAHDRinSJAVJvpUzV/YJqPe7O13eRZnqdGtM49CiNauw4ynGjH18kMtnjDYuvUdQlYnILfEWzmVkAAb/fS387b605DYwcWFHe7SQi/GmsXgX6/IrxW/8s1dUR6PN+N/HDSRg0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(136003)(346002)(451199015)(40470700004)(36840700001)(46966006)(82310400005)(478600001)(6666004)(86362001)(16526019)(356005)(81166007)(82740400003)(26005)(186003)(8936002)(1076003)(336012)(41300700001)(2906002)(54906003)(6916009)(83380400001)(36756003)(44832011)(40460700003)(426003)(47076005)(316002)(7416002)(7406005)(2616005)(70206006)(8676002)(70586007)(4326008)(40480700001)(5660300002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:51:59.6120
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c4c126d3-a80a-4373-8dde-08dade0ca9db
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C979.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7864
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index d611051dcf1e..ded53879f98d 100644
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

