Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45A3269D38B
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbjBTS6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbjBTS6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:58:39 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20606.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::606])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419B31B8;
        Mon, 20 Feb 2023 10:58:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cdMyIrtokde7rFpD3655Z/LXYE+bJT2m8GWWXohR3NHQ+tEAstjZ2dyveoadZzLi+NtU0vH07s8T9HzdYSEjZJM6LXAxH8J9DYknGr3Gryc4hr5v0YzsVUou3ntXPHVeQes87fi/OfIq7FdtfcYiTbJnaIT4Zr15QiLrIm/HfI/bZx2NABd13SeArO3Q+iRORIHp+ly1L45tVy8xZBRsAl5V1JDtctED2Lqe6eckw1A2fyeNXVzpIiQNKNq/KEfu+4s2AVaB0CKA0PNNLnUZbO57eOEJRCCmOWxuXZHk1B6tdEO2cSmIOMHv8i8hTM92HF+oLqNpt6LFfBy7yp0Znw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M9Ew5tn5x1C1/p9qsujs1TZPHeenne1rQSYJ332sceQ=;
 b=XnSq6lr/2aKcQ8N5SMIxgW9jf+PWoJ1ZzODYGAwt/GRpfOeA0mH1cpRniPgocPsFG3udsunoS7H8ymQUBmX6b4Y6ICJNJpVLqMYRnw97x8jOHaOFcB1Rlkrth9QxoHjrS9ViRXXgUKtu+hc/QwhjJ9NI0TigIKh62spJyOnsIc1DRDN3sfDdaNP2ogguvI2ffr9NRlGMXpME3ZkKJi8Da7vSQtkdbbd3BW+fm83PXQz8iv5PkYjKeUUllc82OeNjKq4/1P0TLCVaCwKT8LWHyqJcId6DOaXMDN65OouMFCh8dFZH7sTtvmEG6iOobaZoKGrtdJKKylxjZICgIruJpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M9Ew5tn5x1C1/p9qsujs1TZPHeenne1rQSYJ332sceQ=;
 b=MMw+vPhe2vPLkRpE+yqtkkDNGw7KTNF1gjQnEQn1Gu7ZnLgsbL3Yu04IPk9F54rKXW9HfmZ+/D/WdUGJa/wkLCjCKcu5Wpv7S+ikPbdiuAUoMCIYYPdopqjoZv/MMYWTxVdNP24PdMmB0h92gbP3unqCzsYM5UBnASZ8TxoPr8Q=
Received: from MN2PR14CA0013.namprd14.prod.outlook.com (2603:10b6:208:23e::18)
 by CH0PR12MB5170.namprd12.prod.outlook.com (2603:10b6:610:b9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 18:55:26 +0000
Received: from BL02EPF000108EA.namprd05.prod.outlook.com
 (2603:10b6:208:23e:cafe::d1) by MN2PR14CA0013.outlook.office365.com
 (2603:10b6:208:23e::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19 via Frontend
 Transport; Mon, 20 Feb 2023 18:55:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000108EA.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Mon, 20 Feb 2023 18:55:26 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:55:25 -0600
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
Subject: [PATCH RFC v8 03/56] KVM: x86: Add platform hooks for private memory invalidations
Date:   Mon, 20 Feb 2023 12:37:54 -0600
Message-ID: <20230220183847.59159-4-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF000108EA:EE_|CH0PR12MB5170:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fc5272c-1559-4dfb-7e7c-08db13740739
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Qw9KZVx53ga4s5Te7QdTZHnBA6xKPdCOp27MFFqX8P5SVkI24nIq2zsoFpZ5ouqQJ5uNLFncqaLMLWXOGCXdqZ+FsvKINC6T2G3/aCagX+ByKvta3xm1tVPMkmBpCD/3on/KbXzn4uW/sLPTOc/VC4gGBfwI0OO7ogHx9I5J2K9zdjrc5qSEsB5qvwP40I6EfSpWS2Xy/jlLkCfJVUDaH5HEMKy7cWfEGdlhaVmehEKoQNLvQ2KGQE3CXkVbf+dF2PCEbLqulo8qFBaAps/dAeLM5a/ZptDhoMYm3joh31hDP48Fbn+H0uCNmrSUZ27VOgp5GCjhIvOTgVAmyFRyDu7bOb5OOkmLph9N1kGwWjk6M7YzLKfkBfHOw6SsachueF17hqalsxFe9elU7FFUtRLKsPb31zsKchxS1MHnBxKNjwrc4pPG3I2HfNbc8Y7jO2LJiCcCwn3uVjnp/0YkUnFxJwOQtKO92cDpxleoG7ot+o9SSq/hlPgeZX33lXcQW+RpKa25gWjAr4ti+BZtmD53Nx8vUI4ENrpGi7V99TBLroNsdyn9Cl9PofGyA7CpMijIT74ZEb7ROFvvw9GfMWfmcGc92CmG/+/gTV7UClOanyH3R8gzXUTAmRCcr2i9DkFDvdGF6cnauD9moDQruu5fv6KKRaIDo9X/FC6962Em5lAXqC917il3EbbUinP/bM1DkIBUf78Hs4PjNvOapHdxvDANK0PwBull5gvd8A=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(136003)(396003)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(81166007)(40480700001)(356005)(36860700001)(82740400003)(83380400001)(426003)(336012)(40460700003)(2616005)(86362001)(47076005)(316002)(54906003)(7406005)(4326008)(36756003)(8676002)(6916009)(5660300002)(82310400005)(8936002)(7416002)(478600001)(70586007)(44832011)(41300700001)(70206006)(26005)(16526019)(6666004)(2906002)(186003)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:55:26.0462
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fc5272c-1559-4dfb-7e7c-08db13740739
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5170
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In some cases, like with SEV-SNP, guest memory needs to be updated in a
platform-specific manner before it can be safely freed back to the host.
Add hooks to wire up handling of this sort to the invalidation notifiers
for restricted memory.

Also issue invalidations of all allocated pages during notifier/memslot
unbinding so that the pages are not left in an unusable state when
they eventually get freed back to the host upon FD release.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/mmu/mmu.c             |  5 +++++
 include/linux/kvm_host.h           |  3 +++
 mm/restrictedmem.c                 | 12 +++++++++++-
 virt/kvm/kvm_main.c                | 12 +++++++++++-
 6 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index a8aaf532c2ab..6a885f024a00 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -133,6 +133,7 @@ KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL_RET0(fault_is_private);
 KVM_X86_OP_OPTIONAL_RET0(update_mem_attr)
+KVM_X86_OP_OPTIONAL(invalidate_restricted_mem)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2da3fb2d5d1b..37c92412035f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1646,6 +1646,7 @@ struct kvm_x86_ops {
 	bool (*fault_is_private)(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault);
 	int (*update_mem_attr)(struct kvm_memory_slot *slot, unsigned int attr,
 			       gfn_t start, gfn_t end);
+	void (*invalidate_restricted_mem)(struct kvm_memory_slot *slot, gfn_t start, gfn_t end);
 
 	bool (*has_wbinvd_exit)(void);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 053bd77bbf52..360af0c9997e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7264,4 +7264,9 @@ void kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 		pr_warn_ratelimited("Failed to update GFN range 0x%llx-0x%llx with attributes 0x%lx. Ret: %d\n",
 				    start, end, attrs, ret);
 }
+
+void kvm_arch_invalidate_restricted_mem(struct kvm_memory_slot *slot, gfn_t start, gfn_t end)
+{
+	static_call_cond(kvm_x86_invalidate_restricted_mem)(slot, start, end);
+}
 #endif
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d200b8f45583..4d542060cd93 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2341,6 +2341,9 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 	       kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 
 }
+
+void kvm_arch_invalidate_restricted_mem(struct kvm_memory_slot *slot, gfn_t start, gfn_t end);
+
 #else
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
diff --git a/mm/restrictedmem.c b/mm/restrictedmem.c
index fd6f3c66033f..c8353c592cfe 100644
--- a/mm/restrictedmem.c
+++ b/mm/restrictedmem.c
@@ -17,7 +17,7 @@ struct restrictedmem {
 
 static int restrictedmem_release(struct inode *inode, struct file *file)
 {
-	struct restrictedmem *rm = inode->i_mapping->private_data;
+	struct restrictedmem *rm = file->f_mapping->private_data;
 
 	xa_destroy(&rm->bindings);
 	fput(rm->memfd);
@@ -305,10 +305,20 @@ void restrictedmem_unbind(struct file *file, pgoff_t start, pgoff_t end,
 			  struct restrictedmem_notifier *notifier)
 {
 	struct restrictedmem *rm = file->f_mapping->private_data;
+	unsigned long index;
 
+	pr_debug("%s: unregistering notifier, invalidating page offsets 0x%lx-0x%lx\n",
+		 __func__, start, end);
 	down_write(&rm->lock);
+
+	xa_for_each_range(&rm->bindings, index, notifier, start, end)
+		notifier->ops->invalidate_start(notifier, start, end);
+	xa_for_each_range(&rm->bindings, index, notifier, start, end)
+		notifier->ops->invalidate_end(notifier, start, end);
+
 	xa_store_range(&rm->bindings, start, end, NULL, GFP_KERNEL);
 	synchronize_rcu();
+
 	up_write(&rm->lock);
 }
 EXPORT_SYMBOL_GPL(restrictedmem_unbind);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8ec985f1c57d..f7e00593cc5d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -960,8 +960,15 @@ static void kvm_restrictedmem_invalidate_begin(struct restrictedmem_notifier *no
 	struct kvm *kvm = slot->kvm;
 	int idx;
 
-	if (restrictedmem_get_gfn_range(slot, start, end, &gfn_range))
+	if (restrictedmem_get_gfn_range(slot, start, end, &gfn_range)) {
+		pr_debug("%s: Invalidation skipped, slot: %d, start: 0x%lx, end: 0x%lx, restrictedmem.index: 0x%lx\n",
+			 __func__, slot->id, start, end, slot->restrictedmem.index);
 		return;
+	}
+
+	pr_debug("%s: slot: %d, start: 0x%lx, end: 0x%lx, restrictedmem.index: 0x%lx, gfn_start: 0x%llx, gfn_end: 0x%llx\n",
+		 __func__, slot->id, start, end, slot->restrictedmem.index, gfn_range.start,
+		 gfn_range.end);
 
 	idx = srcu_read_lock(&kvm->srcu);
 	KVM_MMU_LOCK(kvm);
@@ -972,7 +979,10 @@ static void kvm_restrictedmem_invalidate_begin(struct restrictedmem_notifier *no
 		kvm_flush_remote_tlbs(kvm);
 
 	KVM_MMU_UNLOCK(kvm);
+
 	srcu_read_unlock(&kvm->srcu, idx);
+
+	kvm_arch_invalidate_restricted_mem(slot, gfn_range.start, gfn_range.end);
 }
 
 static void kvm_restrictedmem_invalidate_end(struct restrictedmem_notifier *notifier,
-- 
2.25.1

