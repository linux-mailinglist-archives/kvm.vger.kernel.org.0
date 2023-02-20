Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59FEC69D3DB
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 20:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbjBTTJm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 14:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233116AbjBTTJl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 14:09:41 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on20608.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8c::608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87F419F0D;
        Mon, 20 Feb 2023 11:09:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HUETiSK42d5gUhv1x4apCytrxOfnTFmbPFjWCjBRcrROksGqyjBFh1OXwpQtCnHJXhbLWKRHe4q9VFyHVxKIBpOLucSYfMSLDtEZCnnPt0BGGj5RZm1i74nkKZlmhpKdxZX42brQj2dktfivKGEfKJJVE4BkLl7mDN13M0cXQAC3SrueU+oPYa6jGX27z0EWi2F3lGXI1MEq5H1wbMp+zPFqISLjhfTnsS50IY+FsVdjyIuTJhL/X/AjSkyJBRiM74bwZfh7ZGng4oZQpQjaWKxrnqjzx32HYq8FoCYHQLSuFUjS7pDClZzlP4m0WYMch/BTFP2hnwucMJ6wTD26IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=21G95oFZzHWgiSnbQKm59oJ3QLRud3+Mni9EVFmud3w=;
 b=PUX54sXYzUagm42NfcR8f7cmELGg5ruCRSY1dSKL/UCNsgWgbF5D7b/bbSl55QFWUGXhEjDNZ4Ns//U1Crfwbp010ROBR1aenVaWLxIjRSWivp1Zq1Guw47QTPgWATPnu+fh1SUERGf/w2D51VQCFa0upJ2sa7UqhdeRFpqImnyCAypVGfM1HxnGbbJ0fY/68cLrmsZIrSFbzz/F3JL5X3aN37P80+F7wbEuTTfdIiPQHYCALAU1xQwdokcWBVL9ae9EVuTEtxbbO2f1eipGam4fzwYGlcFWid5pBNufMW+jvqY7+/yUpjSJ1ka8EgKiDL/SoWgH++7FYYIrqFgM1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=21G95oFZzHWgiSnbQKm59oJ3QLRud3+Mni9EVFmud3w=;
 b=rplaPNrE2ZI6utZeW8e8B3qeLI7B/6ZKj5M7aN/vh3NjfJILvzyzynfeTKdqO1qzpQdR6sfPndhEJ0YWLpUxBzAqQLKlka5LEArBq6gguG3e8zVV3vMiIybm7Kqsfn5s7F/FtaWFNzI+KaCLooAU8YRniO4XaR/fFEGfYG32PFU=
Received: from MW4PR03CA0035.namprd03.prod.outlook.com (2603:10b6:303:8e::10)
 by DS0PR12MB8561.namprd12.prod.outlook.com (2603:10b6:8:166::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 19:02:26 +0000
Received: from CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::ab) by MW4PR03CA0035.outlook.office365.com
 (2603:10b6:303:8e::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 19:02:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT035.mail.protection.outlook.com (10.13.175.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.21 via Frontend Transport; Mon, 20 Feb 2023 19:02:26 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 13:02:25 -0600
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
        Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH RFC v8 07/56] KVM: SEV: Populate private memory fd during LAUNCH_UPDATE_DATA
Date:   Mon, 20 Feb 2023 12:37:58 -0600
Message-ID: <20230220183847.59159-8-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT035:EE_|DS0PR12MB8561:EE_
X-MS-Office365-Filtering-Correlation-Id: 607fe171-2f6f-4e08-2f07-08db137501ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JWmjgonN+G9HW7svEnDa+LBz4VSTz+Ske3mLX5GhlexJf5QsJNP1+6oR6nWqAN9PTz1fPYocoD8X8mkfeUDcz51lN5xoFM2XUXQA5o4clVN6QbyNjlkx2Kibx/of6UYXpoiNFaRcizQ+LoHpJKP1ObH+RzqYG4DTMj1JBxFjamZ0J5d4fajXHOMKNOrokXq0+21Sy1UVgaj66VK5Mo0s7T/MqyOKH3xgwT6EvFBui/dLteroIu/LRMco1uFGcJrUz4xCxkCPW2mhatRzr64WeAkLLZYh7wzNTQ+m2rWpmxP1ZmN2tTx5T8xmypA+ZrsmN+RK3NvY/jGGMpsnFLelx97HxgUALE9J8a0IEGhtnbWhLZWhf9RRy1UXnp7GS2xIToXfrwmkJP3J61NlZ06KStdkNzDwP59dUpNMK4pq81/p8xuz/BfVW0HGHOxyLdowZ5jQlfXCSkOoQq3D3rhaGMTOAcpB4quKD8Beue9c8xKYNwxQ4AvnFJyIG/yW/1GHp6CNMxC6mO+/AXBf6toSjIrz+kcAk8Iw7fHSZzpXOcdvG8DWug9ijSGZyL55ZNj6umxtiKhs01UnvQ+64thTrc8PqKvt4wuTW+mxz2Y+JyvvXgypTzSWitcmVVtZT1na7PGI9kl9Ac/s8QrAfDPWbtkw1vMvSk8RpoDINqGaGAkkIoZUXMGxc+sDaip6eJrhT2R1ItyN2dsTZQOppRlll5HI6jZNT+J23OshgT4zCdE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(376002)(451199018)(36840700001)(46966006)(40470700004)(356005)(36756003)(40480700001)(40460700003)(86362001)(82310400005)(47076005)(426003)(336012)(83380400001)(316002)(478600001)(54906003)(1076003)(6666004)(16526019)(26005)(186003)(2616005)(7416002)(44832011)(36860700001)(7406005)(5660300002)(82740400003)(81166007)(66899018)(4326008)(2906002)(8676002)(41300700001)(6916009)(8936002)(70586007)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 19:02:26.2418
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 607fe171-2f6f-4e08-2f07-08db137501ba
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8561
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vishal Annapurve <vannapurve@google.com>

This change adds handling of HVA ranges to copy contents
to private memory while doing sev launch update data.

mem_attr array is updated during LAUNCH_UPDATE_DATA to ensure
that encrypted memory is marked as private.

Signed-off-by: Vishal Annapurve <vannapurve@google.com>
[mdr: Use gfn_to_hva_memslot_prot() for shared GFN handler to deal with
 read-only slots for ROMs. Split kvm_vm_set_region_attr into separate
 patch.]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 103 +++++++++++++++++++++++++++++++++++++----
 virt/kvm/kvm_main.c    |   2 +
 2 files changed, 96 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 273cba809328..fad7fb34ef9e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -494,23 +494,26 @@ static unsigned long get_num_contig_pages(unsigned long idx,
 	return pages;
 }
 
-static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
+static int sev_launch_update_shared_gfn_handler(struct kvm *kvm,
+						struct kvm_gfn_range *range,
+						struct kvm_sev_cmd *argp)
 {
 	unsigned long vaddr, vaddr_end, next_vaddr, npages, pages, size, i;
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	struct kvm_sev_launch_update_data params;
 	struct sev_data_launch_update_data data;
 	struct page **inpages;
 	int ret;
 
-	if (!sev_guest(kvm))
-		return -ENOTTY;
-
-	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
-		return -EFAULT;
+	vaddr = gfn_to_hva_memslot_prot(range->slot, range->start, NULL);
+	pr_debug("%s: shared GFN: %llx, slot.id: %d, slot.base_gfn: %llx, slot.userspace_addr: %lx, slot.flags: %x, vaddr: %lx\n",
+		 __func__, range->start, range->slot->id, range->slot->base_gfn,
+		 range->slot->userspace_addr, range->slot->flags, vaddr);
+	if (kvm_is_error_hva(vaddr)) {
+		pr_err("vaddr is erroneous 0x%lx\n", vaddr);
+		return -EINVAL;
+	}
 
-	vaddr = params.uaddr;
-	size = params.len;
+	size = (range->end - range->start) << PAGE_SHIFT;
 	vaddr_end = vaddr + size;
 
 	/* Lock the user memory. */
@@ -562,6 +565,88 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_launch_update_priv_gfn_handler(struct kvm *kvm,
+					      struct kvm_gfn_range *range,
+					      struct kvm_sev_cmd *argp)
+{
+	struct sev_data_launch_update_data data;
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	gfn_t gfn;
+	kvm_pfn_t pfn;
+	struct kvm_memory_slot *memslot = range->slot;
+	int ret = 0;
+
+	data.reserved = 0;
+	data.handle = sev->handle;
+
+	for (gfn = range->start; gfn < range->end; gfn++) {
+		int order;
+		void *kvaddr;
+
+		ret = kvm_restrictedmem_get_pfn(memslot, gfn, &pfn, &order);
+		if (ret)
+			goto e_ret;
+
+		kvaddr = pfn_to_kaddr(pfn);
+		if (!virt_addr_valid(kvaddr)) {
+			pr_debug("%s: Invalid kvaddr 0x%llx\n", __func__, (uint64_t)kvaddr);
+			ret = -EINVAL;
+			goto e_ret;
+		}
+
+		ret = kvm_read_guest_page(kvm, gfn, kvaddr, 0, PAGE_SIZE);
+		if (ret) {
+			pr_debug("%s: Guest read failed 0x%x\n", __func__, ret);
+			goto e_ret;
+		}
+
+		if (!cpu_feature_enabled(X86_FEATURE_SME_COHERENT))
+			clflush_cache_range(kvaddr, PAGE_SIZE);
+
+		data.len = PAGE_SIZE;
+		data.address = __sme_set(pfn << PAGE_SHIFT);
+		ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_DATA, &data, &argp->error);
+		if (ret)
+			goto e_ret;
+		kvm_release_pfn_clean(pfn);
+	}
+
+	/*
+	 * Memory attribute updates via KVM_SET_MEMORY_ATTRIBUTES are serialized
+	 * via kvm->slots_lock, so use the same protocol for updating them here.
+	 */
+	mutex_lock(&kvm->slots_lock);
+	kvm_vm_set_region_attr(kvm, range->start, range->end, KVM_MEMORY_ATTRIBUTE_PRIVATE);
+	mutex_unlock(&kvm->slots_lock);
+e_ret:
+	return ret;
+}
+
+static int sev_launch_update_gfn_handler(struct kvm *kvm, struct kvm_gfn_range *range,
+					 void *data)
+{
+	struct kvm_sev_cmd *argp = (struct kvm_sev_cmd *)data;
+
+	if (kvm_slot_can_be_private(range->slot))
+		return sev_launch_update_priv_gfn_handler(kvm, range, argp);
+
+	return sev_launch_update_shared_gfn_handler(kvm, range, argp);
+}
+
+static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_launch_update_data params;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
+		return -EFAULT;
+
+	return kvm_vm_do_hva_range_op(kvm, params.uaddr, params.uaddr + params.len,
+		sev_launch_update_gfn_handler, argp);
+}
+
 static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 {
 	struct sev_es_save_area *save = svm->sev_es.vmsa;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c740b56d6ba4..003cb199ba4b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -689,6 +689,7 @@ int kvm_vm_do_hva_range_op(struct kvm *kvm, unsigned long hva_start,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(kvm_vm_do_hva_range_op);
 
 static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 						unsigned long start,
@@ -2850,6 +2851,7 @@ unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot,
 
 	return hva;
 }
+EXPORT_SYMBOL_GPL(gfn_to_hva_memslot_prot);
 
 unsigned long gfn_to_hva_prot(struct kvm *kvm, gfn_t gfn, bool *writable)
 {
-- 
2.25.1

