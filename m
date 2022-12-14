Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 315B064D03E
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 20:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239079AbiLNTsU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:48:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239074AbiLNTru (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:47:50 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2043.outbound.protection.outlook.com [40.107.220.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870BE186DE;
        Wed, 14 Dec 2022 11:47:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7YSf7N09G1GFr+wEm8XDMZSXq1SJmIOlIzoDXh2iBV3hZp3JzuaIcy2A+NrvOo8ve53iTxqHMAlAerG+H0oPEytv0LaxNBq2SUCJX9yIGZDxt6Frv9u+JaicWCXmx2gRvurWQ5BsuDrt/0y1KW7etdy5qmrMCA4lr1shKZd+qGlgsZh6cOVg/BJLO+q3+9kElV2sRJGimCRq3cer8dY/mokpES/IfC8mH+HD3/5w3EMhbScTlfrNkPaVDQbWMz0N/FapYoj59IIWYW9ftGOD8Z7N1grnyxzuwnDzUu1s7v9xjU7l+I1EvJpr82rW4N5OuTYayOvXmV/dgINFp0U/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JUgAP9c6+ee2LMTX4sIVCW+FM9ZjLBQ77Cw5MM6nbMc=;
 b=UEFjwtdANyx+JLRGs9zA0QOrU5eLpAU2/Vg7FL43qSaQ0NYxsny79662fhdgDjpusa4YYLSJCbZwZlVvhTJtSsPGyZl8gF84CzQRW7omHQ6najr1VQIf/SAmy5Rq4Ivh7Y52pj7GXtE9cK0iWxrR7kn67LjneCv3c1kjApygb8lGGorJTfXyIY4dIcBnsW1zCJYFxVkgnEh169QKWZyvYQXNJ0Npbvtzu4nnqUIul2x1SH40CfdiBuPH42N7+C2cTc8oAK1JBBagkKDeK2vm9B5zoS51x1mq3sijPfLBbfOhsC20WbR/nF5iiyyaxTE2uYu2FB43cW3kWjwMMOuH6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JUgAP9c6+ee2LMTX4sIVCW+FM9ZjLBQ77Cw5MM6nbMc=;
 b=koQk3jhMsrh919UaeAilJRpNP/IwnhEOykqsru/bH1o6yFsVW1PIA01XY6anes17LzqiilP/tWOanMU/uS3e9iCvsOUZUjQhNvaNTfbia2SmkcPyqbBhRiEAQbKGm5TsOaLbA5PeunmEuZe9sP+NMebCY3cAUCC/ULxCpdgGbfI=
Received: from BL1PR13CA0117.namprd13.prod.outlook.com (2603:10b6:208:2b9::32)
 by SJ2PR12MB7894.namprd12.prod.outlook.com (2603:10b6:a03:4c6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 19:47:47 +0000
Received: from BL02EPF0000EE3D.namprd05.prod.outlook.com
 (2603:10b6:208:2b9:cafe::52) by BL1PR13CA0117.outlook.office365.com
 (2603:10b6:208:2b9::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 19:47:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0000EE3D.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Wed, 14 Dec 2022 19:47:47 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:47:46 -0600
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
        Nikunj A Dadhania <nikunj@amd.com>
Subject: [PATCH RFC v7 11/64] KVM: SEV: Support private pages in LAUNCH_UPDATE_DATA
Date:   Wed, 14 Dec 2022 13:40:03 -0600
Message-ID: <20221214194056.161492-12-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0000EE3D:EE_|SJ2PR12MB7894:EE_
X-MS-Office365-Filtering-Correlation-Id: ebbfc3ad-dfe7-455f-9697-08dade0c136f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PLaeAO7TYsE9o2XaoIiKwk8zTmAl/zzqIh0eqH2LwPJoY++2mS/RAk8Q+Bx48m76okg5+ZS2B36u7fgp06Oqa6toOXDMODFXGLKhdNibUKSZfDJb3i4h+zT7vFV69eXeBUTQZfpDtZAAxFWS8LMJ2B8ZmTv+PQfUPNEY0WafPXmoDC7AwZMXP7Q0xMmgngHoLzo8vSOoFU3uSQvvLtBHIH+tSmJzbijkGSvBhHELxglTSwVcWR0t8gSLUhWORKnfLdSEdX92g5boVydYyCNvDIS8t4egMmC4lRZo6T+w79pL+Dm/T/31k9asqcnsa2UZrM+Oi19dJ9dLS564JeUjb3Y9k7p9+y8RRUE0nRjWtY1OYhSogAZL1u/FRxzv30j6Rhx6eQuyimjNODiRpFRIsUp/IDDoT7c3P3hW5Q5jlLdKNIVjGc985Ag9ewFTIcnFciItGrhCvrj3RWK6JlDl8FhGzZqmWvNRuzCWMkxAPlKHLyqLGDVNNoxSOMrMSkOHlwEwhpXES2j1aClhhGwB/fJn/eC9QwBGHguvL0q7J3LtlgMLC+QXOcLUU7aoChrRtmMjla9VARnpyBBb4M6Ha9hD7cYpSXWa2pKxanxbxjw7LSwjUk39AbdhSeZJqpp/a4/pxvENJTUQUOtkKdNkC+ZchpGroK7gDFAr+TA82GhdjDsyOmfcI7KxV3gxEmg6jccdvG4tZvdsTn+IPLKS45ooTAf7ZJzucDuoUwbbDNdvfhzdxUebPZfR2AngehlOe29DUfzPly9ZWenlfepTXA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(396003)(346002)(451199015)(40470700004)(46966006)(36840700001)(7406005)(7416002)(6916009)(54906003)(336012)(4326008)(70586007)(8676002)(5660300002)(41300700001)(6666004)(316002)(8936002)(86362001)(82310400005)(70206006)(26005)(83380400001)(426003)(47076005)(186003)(1076003)(16526019)(40460700003)(2616005)(36860700001)(478600001)(36756003)(2906002)(40480700001)(81166007)(44832011)(356005)(82740400003)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:47:47.2775
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ebbfc3ad-dfe7-455f-9697-08dade0c136f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000EE3D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7894
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nikunj A Dadhania <nikunj@amd.com>

Pre-boot guest payload needs to be encrypted and VMM has copied it
over to the private-fd. Add support to get the pfn from the memfile fd
for encrypting the payload in-place.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 79 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 64 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a7e4e3005786..ae4920aeb281 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -107,6 +107,11 @@ static inline bool is_mirroring_enc_context(struct kvm *kvm)
 	return !!to_kvm_svm(kvm)->sev_info.enc_context_owner;
 }
 
+static bool kvm_is_upm_enabled(struct kvm *kvm)
+{
+	return kvm->arch.upm_mode;
+}
+
 /* Must be called with the sev_bitmap_lock held */
 static bool __sev_recycle_asids(int min_asid, int max_asid)
 {
@@ -382,6 +387,38 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_get_memfile_pfn_handler(struct kvm *kvm, struct kvm_gfn_range *range, void *data)
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
+		ret = kvm_restricted_mem_get_pfn(memslot, gfn, &pfn, &order);
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
+static int sev_get_memfile_pfn(struct kvm *kvm, unsigned long addr,
+			       unsigned long size, unsigned long npages,
+			       struct page **pages)
+{
+	return kvm_vm_do_hva_range_op(kvm, addr, size,
+				      sev_get_memfile_pfn_handler, pages);
+}
+
 static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 				    unsigned long ulen, unsigned long *n,
 				    int write)
@@ -424,16 +461,25 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 	if (!pages)
 		return ERR_PTR(-ENOMEM);
 
-	/* Pin the user virtual address. */
-	npinned = pin_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pages);
-	if (npinned != npages) {
-		pr_err("SEV: Failure locking %lu pages.\n", npages);
-		ret = -ENOMEM;
-		goto err;
+	if (kvm_is_upm_enabled(kvm)) {
+		/* Get the PFN from memfile */
+		if (sev_get_memfile_pfn(kvm, uaddr, ulen, npages, pages)) {
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
 
@@ -514,6 +560,7 @@ static int sev_launch_update_shared_gfn_handler(struct kvm *kvm,
 
 	size = (range->end - range->start) << PAGE_SHIFT;
 	vaddr_end = vaddr + size;
+	WARN_ON(size < PAGE_SIZE);
 
 	/* Lock the user memory. */
 	inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1);
@@ -554,13 +601,16 @@ static int sev_launch_update_shared_gfn_handler(struct kvm *kvm,
 	}
 
 e_unpin:
-	/* content of memory is updated, mark pages dirty */
-	for (i = 0; i < npages; i++) {
-		set_page_dirty_lock(inpages[i]);
-		mark_page_accessed(inpages[i]);
+	if (!kvm_is_upm_enabled(kvm)) {
+		/* content of memory is updated, mark pages dirty */
+		for (i = 0; i < npages; i++) {
+			set_page_dirty_lock(inpages[i]);
+			mark_page_accessed(inpages[i]);
+		}
+		/* unlock the user pages */
+		sev_unpin_memory(kvm, inpages, npages);
 	}
-	/* unlock the user pages */
-	sev_unpin_memory(kvm, inpages, npages);
+
 	return ret;
 }
 
@@ -609,9 +659,8 @@ static int sev_launch_update_priv_gfn_handler(struct kvm *kvm,
 			goto e_ret;
 		kvm_release_pfn_clean(pfn);
 	}
-	kvm_vm_set_region_attr(kvm, range->start, range->end,
-		true /* priv_attr */);
 
+	kvm_vm_set_region_attr(kvm, range->start, range->end, KVM_MEMORY_ATTRIBUTE_PRIVATE);
 e_ret:
 	return ret;
 }
-- 
2.25.1

