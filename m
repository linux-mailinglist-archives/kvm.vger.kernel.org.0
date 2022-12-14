Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E74264D057
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 20:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239264AbiLNTwS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:52:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239231AbiLNTvn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:51:43 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4FB2B255;
        Wed, 14 Dec 2022 11:50:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YdB1eR9TpCnHdFMks1CqIbzwKpBbSNN2pvdJbkOWQi74ZJxSFo+urEzBJUf+/4KdG/bdYO6D+Pc3pEPgaW3eH2YOFldVUqObQnkdGRRwtkt+hG97dEO/4oMYHUZC1VQ6V+rts1oqjupWjpBURF6peecw7ggIoeiaZxwAyH3E5HS0S7hXcHj6ac3TSnPFVweS9PsxVk81P++xwBzvuw3PWPvo+7GNOTqy8uWSV1q2ZRznjLxkO0nRFVTYbZH0iDBoErr94zV1PwfNGWl5ZWxHV49ylsTZfNWH99J6ad0b6XQEVZgzQAGI8tJ/W0Chj5DGh1mLri2mqkGvBq9kCQjCXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xr9WbvJ0VYPoXlLW+mpQJnYb1YLVqrmHGPL/cfLSrWI=;
 b=JvvUiGuWyRCV/d6m/zLVPdSP2MoRgYoWFhCXWbDuGu/KCE/2coh2q2a4EieAarP5yFX9hrJ2an8PEVQfLDIHyjEFdBj/VfsktZzAEvTPGDD7puYVWgAN+1BI3O1YN03bSHPOT9DSWXvM7qEit6wlEBSF7YXItLrMsuaXwq1Cb+ZH/LlYaKgdZg+lvcesYbu1l+6K95X0Vrnyjbp4N8RCmPnBahbh1vxHl+NrbLb1PxJBwF73/7DxbDCbyFFkA5V+SkmuAi3STbj0dMGaVqsQewnKIkptCvMcQY2rf6tpNYyozkg18Eht/pfHDiAAkq+X/GoSj9RJisBoZbkhhO+V8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xr9WbvJ0VYPoXlLW+mpQJnYb1YLVqrmHGPL/cfLSrWI=;
 b=Jw+D4WFv9XAcV3ddRB16D1lc1TmfOuFIkyjAXIjGegAZrEigZhEdv18Q1TiiRG0z8lIjuGtt4saxUfx7cU27AcwUtu+71ma2BMEYa77OzwNWfEqeCcwpoDlj60DCpqTxVudyJ+4M5O/I4ymWby/FIdbS/V4Az6NvsCLAgYotckc=
Received: from CY5P221CA0022.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:b::23) by
 CO6PR12MB5475.namprd12.prod.outlook.com (2603:10b6:5:354::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5924.11; Wed, 14 Dec 2022 19:50:14 +0000
Received: from CY4PEPF0000C978.namprd02.prod.outlook.com
 (2603:10b6:930:b:cafe::79) by CY5P221CA0022.outlook.office365.com
 (2603:10b6:930:b::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 19:50:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C978.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.10 via Frontend Transport; Wed, 14 Dec 2022 19:50:14 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:50:13 -0600
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
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v7 18/64] x86/sev: Invalidate pages from the direct map when adding them to the RMP table
Date:   Wed, 14 Dec 2022 13:40:10 -0600
Message-ID: <20221214194056.161492-19-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C978:EE_|CO6PR12MB5475:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d79f132-52b7-4d84-b876-08dade0c6b04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CINFwuHUrf+qXKJFcBtDD1EA7g1DtHRzzXorcqC7/ltyMhn3JjCaJqWXuX4dMCaIPLWeJmtAITv/C26Tft1pokla+mfexCY5IZyiEf1An20JTmpjRwWvwRjCKfhd+ydA35YePOU03kzU9LltPrGDGzjrW3GXPDbC6UbVUjoo45yiO3z93GC4sVpMWqbkyRBvCNctv95D0jp0x8LUNe+qlJ0CV5ee2lk/cvdlTpbzfplm0isRsePWIGLavjJP/qJOBB12sEhiKvFYCJGeDpvwhO8eVdkOEiyxYKULT3+BCK5YmeFrDHSKk8N3cq0VwOL9YSKww6SVz4KtCqoqusLEb0ikEqKgYON1HXq5o2Xae0aJKdhFkX+6eUUxPrmaPp05D3QHyxIcN0l6mFtfb+j5nCtBXTPhqVT5XxHoDwvL4fAH+kwEJgZaQXpKe+5aMP3lO84F32ydsR59hu7UsTeYpuvNPyPYD62l6GUVTx852Z05Cpf4dkd1uF4WxHYfIz5IjXx7y2i4QK+D/eSQoggjb0EGhSoswffYFRB11nZfmY6wQ9Lx24y8mXUGUNrzod7dFgmBICXxxUgMuFdGFSwsUaxzkZXjmVLeX0AlBBKrV1MpamOICjoiMa2hVLZau3xaQXn7P9m5wog+QvPsYfHrkAiv4n9y6qMQjSVuy1K8rTtTYz2ESik1sIZg5LEuy6avL9iK9kQyFkcCBRh95ZnQVTiLWTYOGx4bm0eBGtZ3Gqs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(346002)(376002)(451199015)(46966006)(40470700004)(36840700001)(36756003)(2906002)(7416002)(7406005)(40480700001)(36860700001)(40460700003)(5660300002)(336012)(8936002)(44832011)(86362001)(1076003)(2616005)(81166007)(356005)(426003)(47076005)(82740400003)(83380400001)(6916009)(54906003)(186003)(316002)(16526019)(82310400005)(4326008)(41300700001)(26005)(8676002)(478600001)(70206006)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:50:14.1855
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d79f132-52b7-4d84-b876-08dade0c6b04
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C978.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5475
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The integrity guarantee of SEV-SNP is enforced through the RMP table.
The RMP is used with standard x86 and IOMMU page tables to enforce
memory restrictions and page access rights. The RMP check is enforced as
soon as SEV-SNP is enabled globally in the system. When hardware
encounters an RMP-check failure, it raises a page-fault exception.

The rmp_make_private() and rmp_make_shared() helpers are used to add
or remove the pages from the RMP table. Improve the rmp_make_private()
to invalidate state so that pages cannot be used in the direct-map after
they are added the RMP table, and restored to their default valid
permission after the pages are removed from the RMP table.

Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kernel/sev.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 67035d34adad..e2b38c3551be 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2549,15 +2549,40 @@ int psmash(u64 pfn)
 }
 EXPORT_SYMBOL_GPL(psmash);
 
+static int restore_direct_map(u64 pfn, int npages)
+{
+	return set_memory_p((unsigned long)pfn_to_kaddr(pfn), npages);
+}
+
+static int invalidate_direct_map(unsigned long pfn, int npages)
+{
+	return set_memory_np((unsigned long)pfn_to_kaddr(pfn), npages);
+}
+
 static int rmpupdate(u64 pfn, struct rmp_state *val)
 {
 	unsigned long paddr = pfn << PAGE_SHIFT;
+	int ret, level, npages;
 	int retries = 0;
-	int ret;
 
 	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
 		return -ENXIO;
 
+	level = RMP_TO_X86_PG_LEVEL(val->pagesize);
+	npages = page_level_size(level) / PAGE_SIZE;
+
+	/*
+	 * If page is getting assigned in the RMP table then unmap it from the
+	 * direct map.
+	 */
+	if (val->assigned) {
+		if (invalidate_direct_map(pfn, npages)) {
+			pr_err("Failed to unmap %d pages at pfn 0x%llx from the direct_map\n",
+			       npages, pfn);
+			return -EFAULT;
+		}
+	}
+
 retry:
 	/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
 	asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
@@ -2578,6 +2603,17 @@ static int rmpupdate(u64 pfn, struct rmp_state *val)
 		pr_err("RMPUPDATE for pfn %llx succeeded after %d retries\n", pfn, retries);
 	}
 
+	/*
+	 * Restore the direct map after the page is removed from the RMP table.
+	 */
+	if (!ret && !val->assigned) {
+		if (restore_direct_map(pfn, npages)) {
+			pr_err("Failed to map %d pages at pfn 0x%llx into the direct_map\n",
+			       npages, pfn);
+			return -EFAULT;
+		}
+	}
+
 	return ret;
 }
 
-- 
2.25.1

