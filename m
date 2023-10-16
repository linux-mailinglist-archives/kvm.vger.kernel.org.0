Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64BC87CA982
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbjJPNcx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233769AbjJPNcg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:32:36 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46335AC;
        Mon, 16 Oct 2023 06:32:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6l/2zHK4BwlLFLbgiwlR0FazVsnumqmgG2Fln8fp/fvVFAnDWtBoe1Z3WBYf3yhBQ81xwI5BlTviQZc/HnHURUOBNn7sQdmnlF/OCI+iCQXLEfxbWibg26gUtVwqUpUseH8oIH94oPV9k9MFDa1gJMIqa9xEZQM8WL3aKbjGibzfzgnO2VM4W1o7PwVFuqMBoTLbu+LZliFghhPSq0ZztWvZxmkwzWSgU+sfKUVqjzYQB53DBIAsCGvK9xy/NBWE+JMamgFHR2YOPCulDICyR5O4ndVIN4SkKmKCTTJChvvSA6V1F+d+K9Rid9zm0ENXZhBfEXq4PTaPWe5980wzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fSDz8HX83fzrJWcQ6dpqgPzz9CCVnpNKgbpzcgQZtjY=;
 b=Pusi5vCkpCqnIIO8UH41mMy2cF+tSs4v8dfKQXFh3MLm6wRIDI4fRkCseYlThtx835vy8tU0WjDea3mti/yvSHcWKYbh9qxkQv+8OYGZWOVdRGyA8nBE5KfzeRTW/ZobvmN2eQ2ASSCxRVXzi5oOReyGNKMqvtGgtKxS35nZm6jlC53+Hy4xFphlcj0+IHIGoRDL4pP6vzjd4i0zCGzMEr4HoXFEm8HBVRjaSUg5tfahr2WL/RSK4mYrDiy+Q3fyIFC014cw8rVcPcE3fPFx6W9CIxi2IzmxEvH5unbXXOsTz9z46YXaHKMsr0z0MSw8+7porOZUWJvS0h8oQsLB8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSDz8HX83fzrJWcQ6dpqgPzz9CCVnpNKgbpzcgQZtjY=;
 b=l0QBYrYdaXfYiBTwhDO3O3k+o0dPgdSH1fPKt+clsOgsVcxLsm09bAry2SZe5Lg7L7pPQqECR/HnhFeBN97VO62v62qpo3neqlvN6d3xJrL6KHf85S3ZUEqBp5QizPDXcAInYUYzOICcD9p6rlJSyALmccu6e/5SD7VA1wa48BM=
Received: from MW2PR16CA0021.namprd16.prod.outlook.com (2603:10b6:907::34) by
 DM6PR12MB5007.namprd12.prod.outlook.com (2603:10b6:5:20d::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6886.34; Mon, 16 Oct 2023 13:32:17 +0000
Received: from MWH0EPF000989E9.namprd02.prod.outlook.com
 (2603:10b6:907:0:cafe::b) by MW2PR16CA0021.outlook.office365.com
 (2603:10b6:907::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35 via Frontend
 Transport; Mon, 16 Oct 2023 13:32:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989E9.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:32:17 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:32:15 -0500
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
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v10 16/50] x86/sev: Introduce snp leaked pages list
Date:   Mon, 16 Oct 2023 08:27:45 -0500
Message-ID: <20231016132819.1002933-17-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016132819.1002933-1-michael.roth@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E9:EE_|DM6PR12MB5007:EE_
X-MS-Office365-Filtering-Correlation-Id: 77a81225-271a-4813-a9cf-08dbce4c5100
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3NaBGp4rvhpt6y23/ihvigh+xP4Y9+mcIlneZGBLXQK+kl3jiasXj3Hw5IjuLq0JG2z1/eTeILKM/Hv9Q1UZJ8zdzE9KYvRQEoggOz5jeprCVK+/yTWcWlgVyHEa95Ub/DZR0HT59VByNxDfR5S8E0qcvdhLCQ/4qQsaqzuT0W/BZiXtdl8soKTd+E9zmZ8Dygc5F/vT2uf4vlIDc0cs9sl8rcvIqbNkiP7mPP9X1aiBenLb5cvw3JO8B4eXnAFgNl2Ucixp+ixGQvkAwG+IsQGcsh9FX8TC6JXIO4Kx6MIxWKT1ATtoPXCMW9IDN+95igs0gTb08Tx617i4X7TT6OI47shsEHAbCRZ3lqhCjx4dQiFfDTDvOv9aA0JHgn/fNARmZiaNayzkx5LoHx4hidWUbQm3BpLECLyOiDDvMGNYLjfo3QjEbyPynGAkLLyjdhQl6Wi9BCNyVWLW7M2LLbIAOQBFig8UWvSdBl3Qq4EhFpqmk3TB3TTWhjI7gDmbJ2pkkObqb0za1L9nUtz3dCRPq3nQJ5SeUdowCGTVHO6e0uB1bSE+yEqpbDmM1D9zTXOQtRFfTXQZZ0lW87Sp6USoNo9uUq7LlgbxzWe3vrkvPLZnhgC52IU3qVouWUk5TnzhzWS3jNEz7CNWJLJ/EmxCCFVN5C61vaqUu78iandkZYUdwqsd6BKnc/tgxm+ypl5Axh3493hpgoBfBphni6mnhZySCdYL9J2BmcGP3r35nm7W/2UPE9eatWSgFdMk3zR/5yEEW7dQcJSo/iVhpw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(39860400002)(376002)(346002)(230922051799003)(82310400011)(64100799003)(451199024)(1800799009)(186009)(36840700001)(40470700004)(46966006)(6666004)(40460700003)(36860700001)(70206006)(8936002)(54906003)(6916009)(356005)(316002)(70586007)(478600001)(81166007)(82740400003)(2616005)(1076003)(26005)(16526019)(8676002)(47076005)(426003)(83380400001)(336012)(4326008)(7406005)(7416002)(40480700001)(5660300002)(2906002)(36756003)(86362001)(41300700001)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:32:17.3485
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 77a81225-271a-4813-a9cf-08dbce4c5100
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MWH0EPF000989E9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5007
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Pages are unsafe to be released back to the page-allocator, if they
have been transitioned to firmware/guest state and can't be reclaimed
or transitioned back to hypervisor/shared state. In this case add
them to an internal leaked pages list to ensure that they are not freed
or touched/accessed to cause fatal page faults.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: relocate to arch/x86/coco/sev/host.c]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev-host.h |  3 +++
 arch/x86/virt/svm/sev.c         | 28 ++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/arch/x86/include/asm/sev-host.h b/arch/x86/include/asm/sev-host.h
index 1df989411334..7490a665e78f 100644
--- a/arch/x86/include/asm/sev-host.h
+++ b/arch/x86/include/asm/sev-host.h
@@ -19,6 +19,8 @@ void sev_dump_hva_rmpentry(unsigned long address);
 int psmash(u64 pfn);
 int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable);
 int rmp_make_shared(u64 pfn, enum pg_level level);
+void snp_leak_pages(u64 pfn, unsigned int npages);
+
 #else
 static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return -ENXIO; }
 static inline void sev_dump_hva_rmpentry(unsigned long address) {}
@@ -29,6 +31,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int as
 	return -ENXIO;
 }
 static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENXIO; }
+static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 #endif
 
 #endif
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index bf9b97046e05..29a69f4b8cfb 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -59,6 +59,12 @@ struct rmpentry {
 static struct rmpentry *rmptable_start __ro_after_init;
 static u64 rmptable_max_pfn __ro_after_init;
 
+/* list of pages which are leaked and cannot be reclaimed */
+static LIST_HEAD(snp_leaked_pages_list);
+static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
+
+static atomic_long_t snp_nr_leaked_pages = ATOMIC_LONG_INIT(0);
+
 #undef pr_fmt
 #define pr_fmt(fmt)	"SEV-SNP: " fmt
 
@@ -518,3 +524,25 @@ int rmp_make_shared(u64 pfn, enum pg_level level)
 	return rmpupdate(pfn, &val);
 }
 EXPORT_SYMBOL_GPL(rmp_make_shared);
+
+void snp_leak_pages(u64 pfn, unsigned int npages)
+{
+	struct page *page = pfn_to_page(pfn);
+
+	pr_debug("%s: leaking PFN range 0x%llx-0x%llx\n", __func__, pfn, pfn + npages);
+
+	spin_lock(&snp_leaked_pages_list_lock);
+	while (npages--) {
+		/*
+		 * Reuse the page's buddy list for chaining into the leaked
+		 * pages list. This page should not be on a free list currently
+		 * and is also unsafe to be added to a free list.
+		 */
+		list_add_tail(&page->buddy_list, &snp_leaked_pages_list);
+		sev_dump_rmpentry(pfn);
+		pfn++;
+	}
+	spin_unlock(&snp_leaked_pages_list_lock);
+	atomic_long_inc(&snp_nr_leaked_pages);
+}
+EXPORT_SYMBOL_GPL(snp_leak_pages);
-- 
2.25.1

