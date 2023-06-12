Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E1872B672
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbjFLEbe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbjFLEan (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:30:43 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2043.outbound.protection.outlook.com [40.107.95.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D82D1710;
        Sun, 11 Jun 2023 21:30:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UXD41z/c3O0mYE3WzOZNFDq7WyLwQv+14HXxsr02H0yiqvvDdRTUB1Mi/8sqzcZ8ju30iyGb4sDrGLm2tQ3X/lF6Z/r8vuyIYWhXMnNQHyUDdNQogWhIrKYxOT5hDwmnG3JQh9IfKr5Cy4IGUtMiutMnbvrKRJlPlOSlqcHRmAMVrVzDiNja4RJ8yLLUN4KpesAAGYCclxySXYxgbFDKOpdXT2kxaOzCATqZOGY6zTsjJ+1QeRdCxu6wyG9Y2BqSK4pAPlZ1vrCfzFKnkDUT9kdbkCRA2F9t2e8106ayZZiIYEf6YHhCj33gCwR3eOkPhRkSE7LpOZYSXSNWJY8ZKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7D8NSAImjaylny2njAump970VGru0JZBPQv/dh1rn8E=;
 b=ZX1hh/fhboNKRs5TqYY1dGwwusAdYsdWX5WovPrONiKJ13sS5GVEPxCzDaO2n+3x1PQ84+3A6f/1WbqHCVgIBk7v67qIB32ivv2LwuXtpb9g4cVrCIAVjwJkHipK+O2tX2YnIx9P3rM5YLdrALD/691INo+Z3fBVjNEtpSSizv2o1rVD49X3xczquSj/KO1CKlzbrhr4Jku0RL5NdD0g2iO2Hvj4oDpbA9ra+P8A3sezIrwcO+5Erp8UROThR+secv5MIe8NzyJw7JV8RDOiYVctlichb8lo9/A0pgdQSTQHOS8gTViC4R0FOu22YBOAGdycY+e2bkVXZu0kj9ZIgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7D8NSAImjaylny2njAump970VGru0JZBPQv/dh1rn8E=;
 b=JoK9PkOVJ0xdPfgjKlQfz78T3IuWWYDntxT7O46V8Vvy3xsgJjFtlJ+07miyFT2nu7QDKTxBnS4k52DfxQghDowl1siPHzGu9/FckngwkZ+DYNFozEJuMVfDviuN1bmloX7jwp9+QDiVdRtKbFEnB50QQTXlGyKT2POxh4AByRU=
Received: from DS7PR05CA0057.namprd05.prod.outlook.com (2603:10b6:8:2f::21) by
 BL1PR12MB5111.namprd12.prod.outlook.com (2603:10b6:208:31b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Mon, 12 Jun
 2023 04:30:37 +0000
Received: from CY4PEPF0000E9D4.namprd03.prod.outlook.com
 (2603:10b6:8:2f:cafe::6e) by DS7PR05CA0057.outlook.office365.com
 (2603:10b6:8:2f::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.21 via Frontend
 Transport; Mon, 12 Jun 2023 04:30:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D4.mail.protection.outlook.com (10.167.241.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.21 via Frontend Transport; Mon, 12 Jun 2023 04:30:36 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:30:33 -0500
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
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v9 15/51] x86/sev: Invalidate pages from the direct map when adding them to the RMP table
Date:   Sun, 11 Jun 2023 23:25:23 -0500
Message-ID: <20230612042559.375660-16-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230612042559.375660-1-michael.roth@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D4:EE_|BL1PR12MB5111:EE_
X-MS-Office365-Filtering-Correlation-Id: 37be58db-3847-4dd0-0f9b-08db6afdc4cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YVIwqOiaBzXW7N8vmS8g4n7UbapTkP9kys5RWUQR8eX2eA1zFtJ2DUr2Z0JEWW2GpI/4BtsHGyDxcunMADsodtx3ScrOtRiZxyHA4T1jzfgCptWlbuiLHhu30vfy0qdFbUCylMI808UkJ7sF5KFfNqqHJ0JS/bLpTGLIC2RgArSAI2Ozwk1mtmGgeIwya/VysDVSzgUGz8vvShV5WYEZ4PDSpJG9iux9Sh50eLX0deIe7qsJVNcth8FpHErD58gGExlMHO3VqJ1KhNLq4ahgBmYzYBPUVaHSBW3k1/0lwocYU/sYAtSbHxMdY8fu3GTf3Ri3Dq5j+CpcmTajO8jvQUduZj7D2k+DfZ2Yl3CN+UhkLHNpTQO49Gkw7vQcvsRmTZqadcgGxptFsrwBG9ZIIqpUsPe6I12x3THqVZCx9tDO3YC1JC22jTWZDZBcIW7OB1tOyz2iUiV3zOJ4N3qnZfiy+9NXKu4+VJ/f5ClEwnWc+t7dOba8ygs0xHF8CCApS9Z6xg0sMg+QJrBdEMJbcBb+r/4Bo0NuiGjRp0odrEXxrSe+9MGbmlMIMb32V/wXz5SNKlgW2nwILz++PJ2O8t5LQlkIE8Ow2M+DDjF026kR+3ZWWSQuxBllkmea55o9VdOd/a2DU0v8G3+T7/ZDm2OU1TopHnRe8A3F+iRtTF/+qlKsUdlmVLyQou5oWAfdz3j7A+1/A66afcjymifskBT29HnXBeyiLodoPAo/3i74d4QoHaadWrjCt+2LplDA7cnc9n9UgQZN4Dv5EjZlGw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39860400002)(346002)(136003)(451199021)(40470700004)(36840700001)(46966006)(5660300002)(7416002)(8936002)(8676002)(2906002)(70206006)(70586007)(7406005)(54906003)(44832011)(6666004)(4326008)(1076003)(26005)(316002)(6916009)(41300700001)(186003)(16526019)(36860700001)(356005)(82740400003)(336012)(426003)(47076005)(83380400001)(2616005)(40460700003)(478600001)(40480700001)(36756003)(86362001)(82310400005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:30:36.2668
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37be58db-3847-4dd0-0f9b-08db6afdc4cf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5111
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
 arch/x86/coco/sev/host.c | 62 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/arch/x86/coco/sev/host.c b/arch/x86/coco/sev/host.c
index 9df690b0b263..cd3b4c6a25bc 100644
--- a/arch/x86/coco/sev/host.c
+++ b/arch/x86/coco/sev/host.c
@@ -366,6 +366,42 @@ int psmash(u64 pfn)
 }
 EXPORT_SYMBOL_GPL(psmash);
 
+static int restore_direct_map(u64 pfn, int npages)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < npages; i++) {
+		ret = set_direct_map_default_noflush(pfn_to_page(pfn + i));
+		if (ret)
+			break;
+	}
+
+	if (ret)
+		pr_warn("Failed to restore direct map for pfn 0x%llx, ret: %d\n",
+			pfn + i, ret);
+
+	return ret;
+}
+
+static int invalidate_direct_map(u64 pfn, int npages)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < npages; i++) {
+		ret = set_direct_map_invalid_noflush(pfn_to_page(pfn + i));
+		if (ret)
+			break;
+	}
+
+	if (ret) {
+		pr_warn("Failed to invalidate direct map for pfn 0x%llx, ret: %d\n",
+			pfn + i, ret);
+		restore_direct_map(pfn, i);
+	}
+
+	return ret;
+}
+
 static int rmpupdate(u64 pfn, struct rmp_state *val)
 {
 	unsigned long paddr = pfn << PAGE_SHIFT;
@@ -375,6 +411,21 @@ static int rmpupdate(u64 pfn, struct rmp_state *val)
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
 	do {
 		/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
 		asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
@@ -393,6 +444,17 @@ static int rmpupdate(u64 pfn, struct rmp_state *val)
 		return -EFAULT;
 	}
 
+	/*
+	 * Restore the direct map after the page is removed from the RMP table.
+	 */
+	if (!val->assigned) {
+		if (restore_direct_map(pfn, npages)) {
+			pr_err("Failed to map %d pages at pfn 0x%llx into the direct_map\n",
+			       npages, pfn);
+			return -EFAULT;
+		}
+	}
+
 	return 0;
 }
 
-- 
2.25.1

