Return-Path: <kvm+bounces-5401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE661820801
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:36:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0C7A2B22BDC
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBAA1156C5;
	Sat, 30 Dec 2023 17:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="usQ8O1eG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417FF14F61;
	Sat, 30 Dec 2023 17:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kkVuCws3+2iceE13LFy+O/DyByxZyK/QQIzzdZ235MGYlTzd24vq1bj31LxdAKsZgPlGdeoX+JR72gFEyIRxrNAke6gcKsqawcjWinxQjH1fuXSVi1iA6CoE1gjYfvyJc5s+9OWKnyDtLkp/bjv4SZOWStH3ll+MhdjPTLinIG7o+tWVGnspr1OUW2bVge5RfYmiZxwcM2oVhVpocsJgt5WupAcpUClUF4Yyi1/DZ62skNZr9jsePV/R31KFUW6NKBhqS2gPXi8Bms7jlGWUVKUqadNJFXoKRJhAoZUMDdeseyXx1Comv4wQOe7WMfiKcUWSgsxtD6lgeV+kxY+n/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R8lihcmQrM/UI73XzKuzn+TAXLqcU9fGptU1OVvSc+4=;
 b=d67jVW2p+eoAxl9bsDs+hHncZQZV5lM7mGpqzS8+D31ee3mJOaF6mZk1MDEhHiGGfGUvj9j6hFs1FkN/ENnqNro/XCOuPChh9kE2soqhqle8NX7J5Mssd0Aj8m55IQGytkfoBc/TIiuuh5hN7L3sKOSbubYILyacBgYkYE3m4j/isT8rUjy17vgpzO+ATpXN7VwdY8wzXySqZBxM84sN3DMPw/3EoJ9v2HRm6RDwIiInB1KXKNgUeXnTb3yrZmctBGmaaln4fVnAYvKZs33BmcwnKdIIR3YzN6lS1Erivgvb4pmtwmkCf9I+PDH0hmokiBIf2lTOyeC+g4QlVZJsOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R8lihcmQrM/UI73XzKuzn+TAXLqcU9fGptU1OVvSc+4=;
 b=usQ8O1eGw8jBXKyjB3I9ND5VTZKVJaOjbtslvm3Pj9tLibvz5Av5Rx0a8f+Xi1EibRg0IryymV5+p/AhPqwjQD2i/rNSiHo2sqoqG7ERFCB4cUHEesciEHqXGveXINQKx6V7ZB49oxwNAXBdD1JqFAGCBPcrYPPjbzTYs01xv1U=
Received: from DS7PR05CA0059.namprd05.prod.outlook.com (2603:10b6:8:2f::32) by
 SA1PR12MB7344.namprd12.prod.outlook.com (2603:10b6:806:2b7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 17:35:09 +0000
Received: from CY4PEPF0000FCC4.namprd03.prod.outlook.com
 (2603:10b6:8:2f:cafe::61) by DS7PR05CA0059.outlook.office365.com
 (2603:10b6:8:2f::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.9 via Frontend
 Transport; Sat, 30 Dec 2023 17:35:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC4.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:35:09 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:35:06 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v11 04/35] KVM: x86: Add gmem hook for initializing memory
Date: Sat, 30 Dec 2023 11:23:20 -0600
Message-ID: <20231230172351.574091-5-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230172351.574091-1-michael.roth@amd.com>
References: <20231230172351.574091-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC4:EE_|SA1PR12MB7344:EE_
X-MS-Office365-Filtering-Correlation-Id: 6aba1332-afa5-4a50-82d7-08dc095dab7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mdMONeaG0imaoRSPxtDXxo7NNfK5v6aBvti9W1dpCPSaR8hKqJmfu6qVE5ta/Lt3WpjHrBN+rNT6AAUl+KvOZIlfK5zUFb3p5u5LayhPYOxAFGuOuWSbVT4l9lJXthYDU504NUoEAuvgKI3WrFlEpsP/ghFHD25fUh/ZUw8AmvvE9EhfFtyJVHZ1QU8O1hjip2P+bpJx+hlB5oFW3ZD2HtRiVDpRkbd/8Mmi/cnBjL4yE/pnrn3VZIVosKpBZseoX3NA5CsLvzHF4V2E/1e0liMKuLcFom6yJxLEFRfyEsLOLkY0oEQot1+hMoEoftSiHv4R5ldkm5aDmwZib4U6FnIaA4FOhmI43oOhzrjXZfw8ldCQ3Ch9sw5rwz1161SDKsKxvTtbq6Y20ZOxSXVPfhgR81Ad7RDqGpm+9m9a42DPzDzCoT5zCEZFu+fwm5i0h18kPBB9MbH7kTlO5fSqvSdWlU3CXYMwzklDSFOaodTmfc/TRNK2F5Npl5TYGk4M+jqTFIj08rOoKxfJyitMupqcUEP9GbLOq54t7HlMqdobCgatCoPpnmAy/sjlhYN/KMkpupEPn07IyzwsDjuYZm4wFcVN21S4Kp27hVro8ttjpxpXym5iBgkTQg6od4QnRseKLXTtIG0K8cGLCtGW9Ekdbbi1Vx46BdEBLPjQmp5iF41O3LcMyq2bnZm8Ynn1MAPLvrqn1TtJ7O0Xs0ra4zpwNLVOCGNh/bypiDUmberOndj0vSGNAxPNhB7k8WBCXmoN4lD8knWgN8c9dVgP2A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(136003)(346002)(396003)(230922051799003)(186009)(82310400011)(451199024)(64100799003)(1800799012)(36840700001)(40470700004)(46966006)(2906002)(7406005)(7416002)(5660300002)(41300700001)(16526019)(40480700001)(83380400001)(426003)(40460700003)(2616005)(336012)(1076003)(26005)(966005)(478600001)(6666004)(47076005)(86362001)(81166007)(82740400003)(36860700001)(356005)(70586007)(70206006)(6916009)(54906003)(316002)(4326008)(44832011)(8936002)(8676002)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:35:09.2280
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aba1332-afa5-4a50-82d7-08dc095dab7b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7344

guest_memfd pages are generally expected to be in some arch-defined
initial state prior to using them for guest memory. For SEV-SNP this
initial state is 'private', or 'guest-owned', and requires additional
operations to move these pages into a 'private' state by updating the
corresponding entries the RMP table.

Allow for an arch-defined hook to handle updates of this sort, and go
ahead and implement one for x86 so KVM implementations like AMD SVM can
register a kvm_x86_ops callback to handle these updates for SEV-SNP
guests.

The preparation callback is always called when allocating/grabbing
folios via gmem, and it is up to the architecture to keep track of
whether or not the pages are already in the expected state (e.g. the RMP
table in the case of SEV-SNP).

In some cases, it is necessary to defer the preparation of the pages to
handle things like in-place encryption of initial guest memory payloads
before marking these pages as 'private'/'guest-owned', so also add a
helper that performs the same function as kvm_gmem_get_pfn(), but allows
for the preparation callback to be bypassed to allow for pages to be
accessed beforehand.

Link: https://lore.kernel.org/lkml/ZLqVdvsF11Ddo7Dq@google.com/
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/x86.c                 |  6 ++++
 include/linux/kvm_host.h           | 14 ++++++++
 virt/kvm/Kconfig                   |  4 +++
 virt/kvm/guest_memfd.c             | 56 +++++++++++++++++++++++++++---
 6 files changed, 77 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index ab24ce207988..5e6b58439100 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -139,6 +139,7 @@ KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL(get_untagged_addr)
 KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
+KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9b0f18d096ed..1fc14aa58913 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1795,6 +1795,7 @@ struct kvm_x86_ops {
 
 	gva_t (*get_untagged_addr)(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
+	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 27e23714e960..67d7c9e1331c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13512,6 +13512,12 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
 
+#ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
+int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order)
+{
+	return static_call(kvm_x86_gmem_prepare)(kvm, pfn, gfn, max_order);
+}
+#endif
 
 int kvm_spec_ctrl_test_value(u64 value)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7e7fd25b09b3..22feb4910854 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2375,9 +2375,19 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
 
 #ifdef CONFIG_KVM_PRIVATE_MEM
+int __kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
+		       gfn_t gfn, kvm_pfn_t *pfn, int *max_order, bool prep);
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
 #else
+static inline int __kvm_gmem_get_pfn(struct kvm *kvm,
+				     struct kvm_memory_slot *slot, gfn_t gfn,
+				     kvm_pfn_t *pfn, int *max_order, bool prep)
+{
+	KVM_BUG_ON(1, kvm);
+	return -EIO;
+}
+
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
 				   kvm_pfn_t *pfn, int *max_order)
@@ -2387,4 +2397,8 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_PRIVATE_MEM */
 
+#ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
+int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order);
+#endif
+
 #endif
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 6793211a0b64..f5d6256607d2 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -103,3 +103,7 @@ config KVM_GENERIC_PRIVATE_MEM
        select KVM_GENERIC_MEMORY_ATTRIBUTES
        select KVM_PRIVATE_MEM
        bool
+
+config HAVE_KVM_GMEM_PREPARE
+       bool
+       depends on KVM_PRIVATE_MEM
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 4aaa82227978..5e88e525cf75 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -43,7 +43,40 @@ static struct folio *kvm_gmem_get_huge_folio(struct inode *inode, pgoff_t index,
 	return folio;
 }
 
-static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
+static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct folio *folio)
+{
+#ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
+	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
+	struct kvm_gmem *gmem;
+
+	list_for_each_entry(gmem, gmem_list, entry) {
+		struct kvm_memory_slot *slot;
+		struct kvm *kvm = gmem->kvm;
+		struct page *page;
+		kvm_pfn_t pfn;
+		gfn_t gfn;
+		int rc;
+
+		slot = xa_load(&gmem->bindings, index);
+		if (!slot)
+			continue;
+
+		page = folio_file_page(folio, index);
+		pfn = page_to_pfn(page);
+		gfn = slot->base_gfn + index - slot->gmem.pgoff;
+		rc = kvm_arch_gmem_prepare(kvm, gfn, pfn, compound_order(compound_head(page)));
+		if (rc) {
+			pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx, error %d.\n",
+					    index, rc);
+			return rc;
+		}
+	}
+
+#endif
+	return 0;
+}
+
+static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool prep)
 {
 	struct folio *folio;
 
@@ -73,6 +106,12 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 		folio_mark_uptodate(folio);
 	}
 
+	if (prep && kvm_gmem_prepare_folio(inode, index, folio)) {
+		folio_unlock(folio);
+		folio_put(folio);
+		return NULL;
+	}
+
 	/*
 	 * Ignore accessed, referenced, and dirty flags.  The memory is
 	 * unevictable and there is no storage to write back to.
@@ -177,7 +216,7 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 			break;
 		}
 
-		folio = kvm_gmem_get_folio(inode, index);
+		folio = kvm_gmem_get_folio(inode, index, true);
 		if (!folio) {
 			r = -ENOMEM;
 			break;
@@ -517,8 +556,8 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	fput(file);
 }
 
-int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
+int __kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
+		       gfn_t gfn, kvm_pfn_t *pfn, int *max_order, bool prep)
 {
 	pgoff_t index, huge_index;
 	struct kvm_gmem *gmem;
@@ -539,7 +578,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		goto out_fput;
 	}
 
-	folio = kvm_gmem_get_folio(file_inode(file), index);
+	folio = kvm_gmem_get_folio(file_inode(file), index, prep);
 	if (!folio) {
 		r = -ENOMEM;
 		goto out_fput;
@@ -580,4 +619,11 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	return r;
 }
+EXPORT_SYMBOL_GPL(__kvm_gmem_get_pfn);
+
+int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
+		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
+{
+	return __kvm_gmem_get_pfn(kvm, slot, gfn, pfn, max_order, true);
+}
 EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
-- 
2.25.1


