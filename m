Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2040E4AB40A
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 07:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237289AbiBGFxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 00:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbiBGFMr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 00:12:47 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E30C043181
        for <kvm@vger.kernel.org>; Sun,  6 Feb 2022 21:12:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SYVO5Fe6+lUBNYTXjUKIfAJxyP8lhJtyGb8w1CQvSexpulPRNDwyvePZcsJllkRHGIDvefFjnsclVaP4+YItmhLMfO1abN+DuIF2bVGrQL/cSJyIsubszNaGoX2prdmM8v0C8LvwYnr6EiGIcUXRpeBUSS2tsytVT1xN8fIdN9InO+yjYbqYtrBQbSdrcC7f6HlsLjaEOFGTrRyN//TL/v1Fq6kSmZpB538HXyhoKTOGLLEeRz8RrNagzipAyQdgs+DU+cGJRrl8JuZGckcPtKSJjMosYcV482GJJQ6aZTP8YwoOfRh5qUYQYB++ospLArGsGREJHp/fnXsm8JmWYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1dM2qx/Wt++LaX6aIq81fkoLa3UoTuBpjqWDMXexaVA=;
 b=hAeUFKI/w6+PP8f0UvlEebVDItYsQL3R/eMxGj38vJ5gw1SVxYIPwQU6UgHmmWHE3K5D6Rg9sem/tjvELMd4tPvV3ZweTOqTShzcDj9d+DRaTZyg3f9dbl7KPsrQeXsrv4EQCUIOvoyI6UrBI8Db79lB7KkHHWdh0mVbvJVAgIDbOvFMG5PMlE8smiATgrt0LfsgwXcxNIknASzlNHIL6zW+QX7BKHWo6HlheDBGJt1kJ3DLBbADKdDejjhXA+jNqhWEgTizt4qbrUWB14ziGXhMOwgWwgXGdR4TOOv404G7nDNUekjmH9ZqK4pyofB9oiuzhwRfAznXSJ24OjJFQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1dM2qx/Wt++LaX6aIq81fkoLa3UoTuBpjqWDMXexaVA=;
 b=Q35+dT17rlJ/79hc861eFIEXOvFZxfH79DjsrAE+m3BiWU9xFxEgNOmuspO0jAltt3Bzi0PnSHWdmFeEgKblE2a2VaMFXcUiQCOaA0a27iIQM8huCHFr8FMRbJYSoOFAMFb8pIMR3Z+ARZNdDScETbfCtaCyRC0ckka6cckvP1M=
Received: from DM5PR2001CA0012.namprd20.prod.outlook.com (2603:10b6:4:16::22)
 by MN2PR12MB4270.namprd12.prod.outlook.com (2603:10b6:208:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Mon, 7 Feb
 2022 05:12:43 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:16:cafe::b) by DM5PR2001CA0012.outlook.office365.com
 (2603:10b6:4:16::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18 via Frontend
 Transport; Mon, 7 Feb 2022 05:12:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4951.12 via Frontend Transport; Mon, 7 Feb 2022 05:12:43 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Sun, 6 Feb
 2022 23:12:40 -0600
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>, <aaronlewis@google.com>
Subject: [kvm-unit-tests PATCH 1/3] x86: Add routines to set/clear PT_USER_MASK for all pages
Date:   Mon, 7 Feb 2022 05:12:00 +0000
Message-ID: <20220207051202.577951-2-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220207051202.577951-1-manali.shukla@amd.com>
References: <20220207051202.577951-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 622f34d8-1ef8-40d7-1730-08d9e9f878a4
X-MS-TrafficTypeDiagnostic: MN2PR12MB4270:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4270FAFFBD959F7A7A877798FD2C9@MN2PR12MB4270.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RunpfShjlFxUv7318ODejwlWKT2tbInubu+jQn91cFwY6aCLSdbcVfowNYoo1VsJ1zCKotP8BhBHpaNObnL+3Mq9qyKvd/bvbxrwtP7asglq2S8mxVffL4gLbK5Ze9dFe7UtVx7i+HGuOfvg0W2FMfSe28zlGOWlR5+TjtQ6bWk0KnDq2jZZJe6jjIyxbnvht6oWH+FSFOyjniSoFuO51RDAWKAYM6G0qbRbu+KZ0DfJ2dXn1e6hxw6GKZSL6CIrpy50zzmcWWm4lr4LhxkWlbipZzskzeJlD3iAFkdtS2XTFiQkX0Ck+3vV5aPN0DCHi1vBNZVjw9DKsnLjoo2Lb2Q62DhYCWYz+vEuQp33NsiEr1a3Wdi3cNAB40OUvR9z6xSVNK99psbZDYPgbR0Zi+FxJ+jG9gVqOp3yF9x9cDShY8qk9k9LDEClmvGAN4/2dtp4yCDhudQADmjFowfXMHJqiDE7tzaLWsKUzx3VF6VoUV/IKBXNb1e+jcpYPP3e57Ep7Aa1jnidviuJxml5mImwy7rUZFhztu8A9VdnJrn4nkOWjBRSyX8PcEf2gwMyV7GuG9RYQLNrcpArHAroI/bDEsBCQueEjxrV6hg0J8zl99YOQ3MEiczuzyJYbJ+Q1C2CAxrQHuoSUNn1AroJzLPU4ixr2ntQf7ir2BDh4gIcMjqU8eXfGxOQv1Ckoibjp1ZXEDWWXbDuOUOMBpcOqg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(316002)(6916009)(54906003)(2906002)(336012)(36756003)(426003)(47076005)(44832011)(6666004)(40460700003)(186003)(7696005)(508600001)(26005)(16526019)(1076003)(2616005)(83380400001)(4326008)(8676002)(82310400004)(86362001)(36860700001)(8936002)(5660300002)(356005)(70586007)(81166007)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 05:12:43.3723
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 622f34d8-1ef8-40d7-1730-08d9e9f878a4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4270
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add following 2 routines :
1) set_user_mask_all() - set PT_USER_MASK for all the levels of page tables
2) clear_user_mask_all - clear PT_USER_MASK for all the levels of page tables

commit 916635a813e975600335c6c47250881b7a328971
(nSVM: Add test for NPT reserved bit and #NPF error code behavior)
clears PT_USER_MASK for all svm testcases. Any tests that requires
usermode access will fail after this commit.

Usermode function needs to be called from L2 guest to generate
AC exception and calling usermode function with supervisor pages
generates #PF exception with error code 0004

Add solution to above mentioned problem which is to set
PT_USER_MASK for all pages in the initialization of #AC exception
test and clear them in uninitialization of #AC exception at last.
AC exception test works fine without hampering other test cases with
this solution.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 lib/x86/vm.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/x86/vm.h |  3 +++
 2 files changed, 57 insertions(+)

diff --git a/lib/x86/vm.c b/lib/x86/vm.c
index 56be57b..f3a7ae8 100644
--- a/lib/x86/vm.c
+++ b/lib/x86/vm.c
@@ -37,6 +37,60 @@ pteval_t *install_pte(pgd_t *cr3,
     return &pt[offset];
 }
 
+/*
+ * set PT_USER_MASK bit for all levels of page tables
+ */
+
+void set_user_mask_all(pteval_t *pt, int level)
+{
+    pteval_t pte, *ptep;
+    int i;
+
+    if (level == PAGE_LEVEL)
+        pte_opt_mask |= PT_USER_MASK;
+
+    for (i = 0; i < 512; i++) {
+        ptep = &pt[i];
+        pte = *ptep;
+
+        if ((pte & PT_PRESENT_MASK) && !(pte & PT_USER_MASK)) {
+            *ptep |= PT_USER_MASK;
+
+            if (level == 1 || pte & PT_PAGE_SIZE_MASK)
+                continue;
+
+            set_user_mask_all(phys_to_virt(pte & 0xffffffffff000ull), level - 1);
+        }
+    }
+}
+
+
+/*
+ * clear PT_USER_MASK bit for all levels of page tables
+ */
+
+void clear_user_mask_all(pteval_t *pt, int level)
+{
+    pteval_t pte, *ptep;
+    int i;
+
+    for (i = 0; i < 512; i++) {
+        ptep = &pt[i];
+        pte = *ptep;
+
+        if ((pte & PT_PRESENT_MASK) && (pte & PT_USER_MASK)) {
+            *ptep &= ~PT_USER_MASK;
+
+            if (level == 1 || pte & PT_PAGE_SIZE_MASK)
+                continue;
+
+            clear_user_mask_all(phys_to_virt(pte & 0xffffffffff000ull), level - 1);
+        }
+    }
+    if (level == PAGE_LEVEL)
+        pte_opt_mask &= ~PT_USER_MASK;
+}
+
 /*
  * Finds last PTE in the mapping of @virt that's at or above @lowest_level. The
  * returned PTE isn't necessarily present, but its parent is.
diff --git a/lib/x86/vm.h b/lib/x86/vm.h
index 4c6dff9..75715e5 100644
--- a/lib/x86/vm.h
+++ b/lib/x86/vm.h
@@ -38,6 +38,9 @@ pteval_t *install_large_page(pgd_t *cr3, phys_addr_t phys, void *virt);
 void install_pages(pgd_t *cr3, phys_addr_t phys, size_t len, void *virt);
 bool any_present_pages(pgd_t *cr3, void *virt, size_t len);
 
+void set_user_mask_all(pteval_t *pt, int level);
+void clear_user_mask_all(pteval_t *pt, int level);
+
 static inline void *current_page_table(void)
 {
 	return phys_to_virt(read_cr3());
-- 
2.30.2

