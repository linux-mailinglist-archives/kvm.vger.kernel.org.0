Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE5369D2D3
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbjBTSj1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:39:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbjBTSjZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:39:25 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2087.outbound.protection.outlook.com [40.107.100.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319A31D93F;
        Mon, 20 Feb 2023 10:39:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iElN+USAgO3JjSOrkjCCg/fCVBJtcrFDAmWOYxo03XXvv72go15Sp/0Xuh4aWuF/TXNLFldoMkYwmZEb07vMpzqKJvG8Q35YRzF8EIm+9JWdL91NLGq68CWe9mryTgd4EZlXd3EnKZE66/iDghF1yHbJUa75JmQcx2pDwa/JAQcX7YZjag2yy2jjgXQdmQBr7+4QIrKbuFKIyvj4VxwH57HND4zgQIqMkxZg3HC1kjBqJ9n5EaIpTYutT3Jg1q0uagfTdwgg2F65BnuUAfG8Xo1lxRxPKNDGbqx1SI8JC9WKUWeGI/UtKEsEDbw6MsupfxEZbdwyMR1sy6NgkdpWnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lbDYvgnjibN6bbVX25Ges497pkvaF/I6r86gcyyzOcs=;
 b=dLI9ZdHulMotsFmhYPTwRpqRmYfObhMlAc8b5e42b9jAOFhmsYXv3v23W+Nv3rHxoF8KJ+g/q5OmbvdExEc2mmR/6qsW2rqT6RONc2Kyi1JIN2lrTEuejmBLtEsvsu7tisGIkGJjObHw4uhHOmaQBvEamggZCC8J8ApqP9TXSSPraULqdXZjA7XUleL9U7N4OFkNxP+Zt3XB5AmpYedkP37I95253UrfrnaMmoGQqKF+dl3eBqYosTPbxShnLL9pXFolP+GEq6hSfSx0V726/VrJQbD2a7sziK501wNOtccIs7D0dTBxzoidRdSRc6kKFwQ9w1Rfpm3aHb//blintQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lbDYvgnjibN6bbVX25Ges497pkvaF/I6r86gcyyzOcs=;
 b=zUJcm6NkCzRG5KKPRLozHXH0OJjKonvNo20u96nx96YDDChKBJMBX26iG9csuXrIARW3wKDnv34WSZBnzU8blZVXClvYEtbOXugcJQ4d/2+sDNQUx8i+facscmSuGQQ6loRAFMbCE6Y/bdfIIDX6ln7xvWIobbw5QBPjAx5Gwz8=
Received: from DM6PR07CA0099.namprd07.prod.outlook.com (2603:10b6:5:337::32)
 by PH7PR12MB8040.namprd12.prod.outlook.com (2603:10b6:510:26b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 18:39:19 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:337:cafe::49) by DM6PR07CA0099.outlook.office365.com
 (2603:10b6:5:337::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:39:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.18 via Frontend Transport; Mon, 20 Feb 2023 18:39:19 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:39:18 -0600
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
        Nikunj A Dadhania <nikunj@amd.com>
Subject: [PATCH RFC v8 09/56] KVM: SEV: Handle memory backed by restricted memfd
Date:   Mon, 20 Feb 2023 12:38:00 -0600
Message-ID: <20230220183847.59159-10-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT048:EE_|PH7PR12MB8040:EE_
X-MS-Office365-Filtering-Correlation-Id: 64aba1fb-d7d5-4a20-7235-08db1371c71c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p1HFcRzjC8UsCHxJH/eHZjH9l7RPw1YuAzuH0HhTQp47HKk08alhnJsK3ViHtpDVuy+gA2AyYvfDF7cRzEfVuMRm5CCRv5H1JuqyIKi6DkkkVYlkzsdP/XhUkbj9AMv+uOwxc7603QkiokutWeTecEaPR8I3gc7LAKeucIQ77/TNKw9FrCHhJaRB83BBV5poUVMkHEDAFQwJ5rIg9kRzDgWyhGv4fV5wwKz5aXGTB30pQp6E5C8aLeISepvo+dcjs8Bt00zHl/M61Vl5pna3rg1IDkp98SQt0DKGvm17F1MNBjIbvo4QkfyIMNK6E2GmxJw5XRjPKo9hQ4YC9T8wmDuaqxI+854BaFplMD765EPDFw+jRPFvahL4ViHDMJaCks4dOk/MPNi4T44l/miAtVlLCogYFe/o49RYbnV69Xlp4/f30/eStCWfUjR4VuO/aZp6dh4Zx44DX8Fcao+JmlOjNhdt5j+ImNsotVaPnRTAxTpB89Q3Lqv6wwFQkvKhfrJFFGeV6zZqduuHbHFCOOcCOdsRTc+cAiQwbMBzBk/E7VJeye4R+dt2FGejhjDdmCklGKef7zVacxjOwlaHqAO6EQB+8UWX9EJ9pITBI6zGFC7QLXRs2wzemvOGCK56HKUogv9FTKwTbhnmf84C8W7ycdNAX/Iz3FV7m93lJ/jhKH8mOUthL2bany1/uh0Oqus5dPzvRIFhdbJ7lW6/h/eZqkJBFSzINXmia4s9Sm8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(39860400002)(376002)(346002)(451199018)(46966006)(36840700001)(40470700004)(356005)(336012)(40460700003)(6916009)(83380400001)(54906003)(316002)(70586007)(70206006)(6666004)(8676002)(1076003)(2616005)(4326008)(41300700001)(8936002)(186003)(47076005)(26005)(16526019)(426003)(478600001)(36756003)(40480700001)(82310400005)(86362001)(82740400003)(2906002)(7416002)(7406005)(5660300002)(36860700001)(44832011)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:39:19.5038
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64aba1fb-d7d5-4a20-7235-08db1371c71c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8040
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nikunj A Dadhania <nikunj@amd.com>

Do not pin the guest memory backed by a restrictedmem backend, as
pages in the restrictedmem are already pinned. Instead, populate the
pages array for these guests using the already-pinned pages provided by
restrictedmem backend.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 68 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 58 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 523c78bbff3f..ad9b29ff4590 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -383,9 +383,46 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_private_mem_get_pages_handler(struct kvm *kvm, struct kvm_gfn_range *range,
+					     void *data)
+{
+	struct kvm_memory_slot *memslot = range->slot;
+	struct page **pages = data;
+	int ret = 0, i = 0;
+	kvm_pfn_t pfn;
+	gfn_t gfn;
+
+	for (gfn = range->start; gfn < range->end; gfn++) {
+		int order;
+
+		ret = kvm_restrictedmem_get_pfn(memslot, gfn, &pfn, &order);
+		if (ret)
+			return ret;
+
+		if (is_error_noslot_pfn(pfn))
+			return -EFAULT;
+
+		pages[i++] = pfn_to_page(pfn);
+	}
+
+	return ret;
+}
+
+static int sev_private_mem_get_pages(struct kvm *kvm, unsigned long addr,
+				     unsigned long size, unsigned long npages,
+				     struct page **pages)
+{
+	return kvm_vm_do_hva_range_op(kvm, addr, addr + size,
+				      sev_private_mem_get_pages_handler, pages);
+}
+
 /*
  * Legacy SEV guest pin the pages and return the array populated with pinned
  * pages.
+ *
+ * SEV guests using restricted memfd backend, pages are already marked as
+ * unmovable and unevictable. Populate the pages array for these guests using
+ * restrictedmem get_pfn.
  */
 static struct page **sev_memory_get_pages(struct kvm *kvm, unsigned long uaddr,
 					  unsigned long ulen, unsigned long *n,
@@ -393,7 +430,7 @@ static struct page **sev_memory_get_pages(struct kvm *kvm, unsigned long uaddr,
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	unsigned long npages, size;
-	int npinned;
+	int npinned = 0;
 	unsigned long locked, lock_limit;
 	struct page **pages;
 	unsigned long first, last;
@@ -429,16 +466,25 @@ static struct page **sev_memory_get_pages(struct kvm *kvm, unsigned long uaddr,
 	if (!pages)
 		return ERR_PTR(-ENOMEM);
 
-	/* Pin the user virtual address. */
-	npinned = pin_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pages);
-	if (npinned != npages) {
-		pr_err("SEV: Failure locking %lu pages.\n", npages);
-		ret = -ENOMEM;
-		goto err;
+	if (kvm_arch_has_private_mem(kvm)) {
+		/* Get the PFN from memfile */
+		if (sev_private_mem_get_pages(kvm, uaddr, ulen, npages, pages)) {
+			pr_err("%s: ERROR: unable to find slot for uaddr %lx", __func__, uaddr);
+			ret = -ENOMEM;
+			goto err;
+		}
+	} else {
+		/* Pin the user virtual address. */
+		npinned = pin_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pages);
+		if (npinned != npages) {
+			pr_err("SEV: Failure locking %lu pages.\n", npages);
+			ret = -ENOMEM;
+			goto err;
+		}
+		sev->pages_locked = locked;
 	}
 
 	*n = npages;
-	sev->pages_locked = locked;
 
 	return pages;
 
@@ -455,9 +501,11 @@ static void sev_memory_put_pages(struct kvm *kvm, struct page **pages,
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 
-	unpin_user_pages(pages, npages);
+	if (!kvm_arch_has_private_mem(kvm)) {
+		unpin_user_pages(pages, npages);
+		sev->pages_locked -= npages;
+	}
 	kvfree(pages);
-	sev->pages_locked -= npages;
 }
 
 static void sev_clflush_pages(struct page *pages[], unsigned long npages)
-- 
2.25.1

