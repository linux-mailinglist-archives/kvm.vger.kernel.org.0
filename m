Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A82172B6D5
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234976AbjFLElv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234986AbjFLEl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:41:26 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20602.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::602])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9AF10A;
        Sun, 11 Jun 2023 21:40:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aLqXvpUSK+wHgVafC6iDd01N9ykBb+irdQY0N5faGQhqA3i2Js4B2bWqfYDRBNYFzywdWfRgoGCGPLxjsafajsvvvqaA4xdiPRSgEw0Wp5U02ME/kgVoD+YQw3BPDimqYpHghKuDostZdjZo4TqsZWB4SPLjjEh8rXnMe7o/ayNH9AiO1gj2C3NgYTH/tbWeN1baQ1OI796SXtpdLITzS5WMVzSKwlvnh6JcqNPbevSVwf3TR+2tOO5h0EIMuuj7dIOSTa34FYNKd411mPZqksNKaFgS6yYgL8rSIL64vrRhG70hdLBPpnDCHxT4PjT3vo6gpJCLcwvqlQXJ8eq7LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cJNMBNV5gRu6D6upRq1tHyg7V/pfpJqpC1rXwTN2h3M=;
 b=VbSriC1Hem0AQllHzl/tyFQZElaho6qIyYkM/nJRPL8EhB4tW/0o4Fe5PGmgVU/Y2uLp/MtzC4E3n+yDIzMP95uwPrnZlrrcC7peZktmIzl1XPunIYoJ3rlkqCZPgheE5qkD7zrFOE8HwT2V7Pt1KgdGfLwT8w/rop0qKqt61pMw4I+TxCMi71tEAm6pvWalUGeFkkKsWHkpgdL9//fkl7FB4bxp5cncG28zj5xyjb/6IqCKgMODcB8sWPQG3BtJHzc96gOBaLPF1V1JMzP5c+JpmHGtkT1rz3bt6R47wNje948Xs7Z3QpiBKnBiuLvgSVfLZ9rL7M9AtCPvGj+F9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cJNMBNV5gRu6D6upRq1tHyg7V/pfpJqpC1rXwTN2h3M=;
 b=wyqwRw3j1oIcohVGFf0reuiQzOaTg9uw6OJpTY0eRrGlLyRa/MG/Y1acjkp0kZAsy7m2qkAUB8eUUbMqf0rDavHW+ohmRFGSxGKhl6HuAg9t2jKGCH+6tK4ae4DVfln5yPYLnPPYvXZYA1xHPknBseb7U9DM+kFXDBunDX1F9Rc=
Received: from MW4PR03CA0092.namprd03.prod.outlook.com (2603:10b6:303:b7::7)
 by SA3PR12MB9228.namprd12.prod.outlook.com (2603:10b6:806:39c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.41; Mon, 12 Jun
 2023 04:40:26 +0000
Received: from CO1PEPF000042AD.namprd03.prod.outlook.com
 (2603:10b6:303:b7:cafe::40) by MW4PR03CA0092.outlook.office365.com
 (2603:10b6:303:b7::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:40:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000042AD.mail.protection.outlook.com (10.167.243.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 04:40:26 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:40:25 -0500
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
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH RFC v9 02/51] KVM: x86: Add gmem hook for invalidating private memory
Date:   Sun, 11 Jun 2023 23:25:10 -0500
Message-ID: <20230612042559.375660-3-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AD:EE_|SA3PR12MB9228:EE_
X-MS-Office365-Filtering-Correlation-Id: 88d0529d-0589-404a-394b-08db6aff247f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: INa9uhXEUXDUpe7tt2xwI8GF5TLwtw9xLCawQrR/qMMiUwmpoDn90FC775HebqMSW6yPN5nu+wWsCTY/czUsidaJr0/np8VVWk3+0p1Efoc49G5tR9UE3SZdycz6ky0p8u+NiQvzEs4M0pktIZ/Kx67Abrk+R46T4LK+tC1UkfjCoYAOQ8IFKhPnZTg+ngPL8gKOvENrHdrWa2MTk8ojHlqxCbAN+/ZSbATg/QjxBGVkvVrz6tT4Ch+vmSJhGZ/G32safyAtR3AEu/pqgcCZq7GLxzK9QlcWKNk/1aBwoblvM6WQUe9VqjGcM570FGlGQj0QVBDSsm8myuAO0e/sCoe8xlswQ2DY39YcKGuhDgQ+w68lPgc0PBB4PXwEtTI5UzxdwYJHtDOWYqhfJA+zMTISf6mih1hph8ugbjv1Ik6EsttsuLGL7DNlYTe96/SM1d6iORoXo8K3waXuu08enBwbjt5OPoM8m18ynetxO/OhMRFKgNb163HJRH56/T/fDsuAs0UKM8ZbKe+lnRlnN3U4K0i7WpkjCLFE2rZps6FcoUEWXcp8r/PzN0vKU6GDKBWgQf3wsquWje6R7S+ztaguvoPv0hH8SZaIVtRc6bTKk1PmDewIZNtIxaSO/iyLQJONpOdFc2mtsVHHNxTecary+rCfpZbID1doaiYul0G0PMGjyvmlnPSOQDcv74QwV0ThT7zHqU64C9HlINW8kMSO1MTcXhihoexDsKcqSgsYDyRYM/M+ou1H/9mT1xmQJH6UAUjgmBtIQvAENOJc3A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199021)(46966006)(36840700001)(40470700004)(82310400005)(36860700001)(40480700001)(47076005)(83380400001)(426003)(336012)(356005)(81166007)(4326008)(82740400003)(36756003)(41300700001)(316002)(6666004)(1076003)(26005)(6916009)(70206006)(70586007)(2906002)(86362001)(44832011)(7406005)(7416002)(5660300002)(40460700003)(8936002)(8676002)(2616005)(54906003)(478600001)(16526019)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:40:26.3016
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 88d0529d-0589-404a-394b-08db6aff247f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF000042AD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9228
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TODO: add a CONFIG option that can be to completely skip arch
invalidation loop and avoid __weak references for arch/platforms that
don't need an additional invalidation hook.

In some cases, like with SEV-SNP, guest memory needs to be updated in a
platform-specific manner before it can be safely freed back to the host.
Add hooks to wire up handling of this sort when freeing memory in
response to FALLOC_FL_PUNCH_HOLE operations.

Also issue invalidations of all allocated pages when releasing the gmem
file so that the pages are not left in an unusable state when they get
freed back to the host.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/x86.c                 |  6 ++++
 include/linux/kvm_host.h           |  3 ++
 virt/kvm/guest_mem.c               | 48 ++++++++++++++++++++++++++++--
 5 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 439ba4beb5af..48f043de2ec0 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -134,6 +134,7 @@ KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
+KVM_X86_OP_OPTIONAL(gmem_invalidate)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bd03b6cf40fb..b3bd24f2a390 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1735,6 +1735,7 @@ struct kvm_x86_ops {
 
 	int (*gmem_prepare)(struct kvm *kvm, struct kvm_memory_slot *slot,
 			    kvm_pfn_t pfn, gfn_t gfn, u8 *max_level);
+	void (*gmem_invalidate)(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c9e1c9369be2..10d76afa23d9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13252,6 +13252,12 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
 
+#ifdef CONFIG_KVM_PRIVATE_MEM
+void kvm_arch_gmem_invalidate(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end)
+{
+	static_call_cond(kvm_x86_gmem_invalidate)(kvm, start, end);
+}
+#endif
 
 int kvm_spec_ctrl_test_value(u64 value)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1a47cedae8a1..7de06add2235 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2343,6 +2343,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #ifdef CONFIG_KVM_PRIVATE_MEM
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 			      gfn_t gfn, kvm_pfn_t *pfn, int *order);
+void kvm_arch_gmem_invalidate(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end);
 #else
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
@@ -2351,6 +2352,8 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
 }
+
+void kvm_arch_gmem_invalidate(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end) { }
 #endif /* CONFIG_KVM_PRIVATE_MEM */
 
 #endif
diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
index cdf2d84683c8..a7e926af4255 100644
--- a/virt/kvm/guest_mem.c
+++ b/virt/kvm/guest_mem.c
@@ -140,16 +140,58 @@ static void kvm_gmem_invalidate_end(struct kvm *kvm, struct kvm_gmem *gmem,
 	KVM_MMU_UNLOCK(kvm);
 }
 
+void __weak kvm_arch_gmem_invalidate(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end)
+{
+}
+
+/* Handle arch-specific hooks needed before releasing guarded pages. */
+static void kvm_gmem_issue_arch_invalidate(struct kvm *kvm, struct file *file,
+					   pgoff_t start, pgoff_t end)
+{
+	pgoff_t file_end = i_size_read(file_inode(file)) >> PAGE_SHIFT;
+	pgoff_t index = start;
+
+	end = min(end, file_end);
+
+	while (index < end) {
+		struct folio *folio;
+		unsigned int order;
+		struct page *page;
+		kvm_pfn_t pfn;
+
+		folio = __filemap_get_folio(file->f_mapping, index,
+					    FGP_LOCK, 0);
+		if (!folio) {
+			index++;
+			continue;
+		}
+
+		page = folio_file_page(folio, index);
+		pfn = page_to_pfn(page);
+		order = folio_order(folio);
+
+		kvm_arch_gmem_invalidate(kvm, pfn, pfn + min((1ul << order), end - index));
+
+		index = folio_next_index(folio);
+		folio_unlock(folio);
+		folio_put(folio);
+
+		cond_resched();
+	}
+}
+
 static long kvm_gmem_punch_hole(struct file *file, loff_t offset, loff_t len)
 {
 	struct kvm_gmem *gmem = file->private_data;
-	pgoff_t start = offset >> PAGE_SHIFT;
-	pgoff_t end = (offset + len) >> PAGE_SHIFT;
 	struct kvm *kvm = gmem->kvm;
+	pgoff_t start, end;
 
 	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len))
 		return 0;
 
+	start = offset >> PAGE_SHIFT;
+	end = (offset + len) >> PAGE_SHIFT;
+
 	/*
 	 * Bindings must stable across invalidation to ensure the start+end
 	 * are balanced.
@@ -158,6 +200,7 @@ static long kvm_gmem_punch_hole(struct file *file, loff_t offset, loff_t len)
 
 	kvm_gmem_invalidate_begin(kvm, gmem, start, end);
 
+	kvm_gmem_issue_arch_invalidate(kvm, file, start, end);
 	truncate_inode_pages_range(file->f_mapping, offset, offset + len - 1);
 
 	kvm_gmem_invalidate_end(kvm, gmem, start, end);
@@ -264,6 +307,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * pointed at this file.
 	 */
 	kvm_gmem_invalidate_begin(kvm, gmem, 0, -1ul);
+	kvm_gmem_issue_arch_invalidate(gmem->kvm, file, 0, -1ul);
 	truncate_inode_pages_final(file->f_mapping);
 	kvm_gmem_invalidate_end(kvm, gmem, 0, -1ul);
 
-- 
2.25.1

