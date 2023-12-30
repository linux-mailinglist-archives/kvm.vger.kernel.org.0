Return-Path: <kvm+bounces-5402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AEFD820804
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:37:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40CDB281014
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:37:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38CD5C153;
	Sat, 30 Dec 2023 17:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CtMlr6Wb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09351BA45;
	Sat, 30 Dec 2023 17:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=USabXbvSHRaGLoM7BQ0nzyaAJYGswb8nwrdv3Cnw1faxKTHB/iciVZ3M/gRYd8e3UvDC7NCwSfypgvi08Y9cQ97w3V4HjCXkuzzE02rn6oelJHfH5xdT9B930v3/mfnrA8ceb1zjq8YXqz0Khpes0jsAlYUJ9TSck6/uHQa9p7juAwggPccqx4vOgZKNoG3ASV559mDWeRJMDV/sEIfwz/nt6XEYCmx9RNG/klttXdYAwUk+28VjyJnrIUey03WeUBqyPn1pjFXtiuwGlugt3kvNENZjj1lQctr6QF6PNmcu2Acx39iBcsus8OgivNLO8rSZrRTWnxptq67RegUjHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nvE6vlHZU2iqAHpXOpQt2sXO9N2lNTkC26FEAwCIcKQ=;
 b=deVV9XPK+KKqNMQ22UHZoLm8byZGts2xIJEc59sca2Z4TO/Uu90T+BxYRjl6jvr1gpczMCVHvoysi6Ozzl14Cng7wixQ0zrxGrhtB402M4hC2OVp4w4HO8kQXbmkLkPkeZQKRn7Mu9Ww24k0MOlgDEuBUJO5EXjbyAN/IXbj4XJm5vT6NSlFQFEmwUyrl5eKfpt8KsTmBYuUidBnoN3Nd4gGGej38p6o4IeO6kFkG9rHKgrprwgVaRDl3vKhSK9wlNEQJ6qFM2YnFYk64GS+Xm/0puOqQulLo04PdV28vf6MqwwEhV3NLiVUiUnjUZWKEeU4eSPD+8wsL6cvTaxQuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nvE6vlHZU2iqAHpXOpQt2sXO9N2lNTkC26FEAwCIcKQ=;
 b=CtMlr6Wbl7U6wZufHZXH2l6r3pXJl23eU9E7oGj1sCJIUeXwJ8wrPmUGCP+2YnJ3wtlZVRnwqmRJfFb1bohA5gcEBaoU2Woop4TR46sYjuL4Y8Vx30HhYgNJQGidfddRM3pcth2UMqF2XizMhiZwMuRnX8R/ewHmiht5MbSlXr0=
Received: from CY5PR19CA0103.namprd19.prod.outlook.com (2603:10b6:930:83::17)
 by SA0PR12MB4558.namprd12.prod.outlook.com (2603:10b6:806:72::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 17:35:28 +0000
Received: from CY4PEPF0000FCBE.namprd03.prod.outlook.com
 (2603:10b6:930:83:cafe::e6) by CY5PR19CA0103.outlook.office365.com
 (2603:10b6:930:83::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22 via Frontend
 Transport; Sat, 30 Dec 2023 17:35:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCBE.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:35:28 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:35:27 -0600
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
Subject: [PATCH v11 05/35] KVM: x86: Add gmem hook for invalidating memory
Date: Sat, 30 Dec 2023 11:23:21 -0600
Message-ID: <20231230172351.574091-6-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCBE:EE_|SA0PR12MB4558:EE_
X-MS-Office365-Filtering-Correlation-Id: 79606b0e-ff3b-4646-4041-08dc095db6c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	iPBNL9XQLbWL5WlTz+AcUbM8w9LgD+TrePUnr6luMH06peeflQY2wLrvyUWTSUbLdweSKuM080gVOmDThVQ8UwTsuf9aI5sZjR1roMJJrFzByCcBZ344EHd2CIhPs+JttDoes0fqeCzAx6R8hKOrqa0zZuQpWb2Yqoa7zNcW76CBmM9Y8GSld5ZTu3kOhSF3iUY4tZOaZ5A35J4+feXjWQj2iwDFoDzltYS6/4OTWOd2fFJ9WZhbufXZT2oWMUA+ofDoG41FcJ8vHJRfhktVtTakZzmNWarHuyZjl2nd+pbyk+c0T8whBCBETxBk+WFwOhfhAi/HPf1Ecz7oDjK6vj45bd0Jv4+Z2/CifU2//+7RsMpb77lUib8706T9xzakx9zcNRTo65zGbb/d8Cbe9ZYtPFus8hb5iG9iFj/NoP4QpzVAxR9Mzh8hazWNsFfJ1ga2Bnim7tbOPkoqxPzU49EwXiuZ2un80lkHA2DC6oNLNWuhJpVO/JfT0i1dr+b1QDmko+e69BFwhdSEBvTOYMcnVuWMVES1oSNGOwpK27aeWPOU1OONs+GpIsFqMoCsTE+GAcUDI42yL5cgPRzNIqbb2dgLrGGhbWPp8FVwQJXo7foNMyoWlsffzaLIR4oQ7Uxr5hmCrP6mfRCYMR16wEKTs2ssFHGUn6o1VNTN6JLF3p8lWHwOhWFSbQ0APRD8AAJMsgrEGVFiHdWVt6kzT5vxvC9lq/xrF1apkihQ4QEo/R24+j956XijvnarbFthR7BoOE2/LVL8L8gpkKDM4w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(396003)(39860400002)(376002)(230922051799003)(186009)(82310400011)(1800799012)(451199024)(64100799003)(40470700004)(46966006)(36840700001)(2906002)(5660300002)(7406005)(7416002)(4326008)(8676002)(8936002)(44832011)(316002)(36756003)(54906003)(6916009)(86362001)(478600001)(40460700003)(40480700001)(6666004)(41300700001)(16526019)(1076003)(26005)(426003)(2616005)(336012)(356005)(83380400001)(81166007)(47076005)(70206006)(70586007)(82740400003)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:35:28.1400
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 79606b0e-ff3b-4646-4041-08dc095db6c1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCBE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4558

In some cases, like with SEV-SNP, guest memory needs to be updated in a
platform-specific manner before it can be safely freed back to the host.
Wire up arch-defined hooks to the .free_folio kvm_gmem_aops callback to
allow for special handling of this sort when freeing memory in response
to FALLOC_FL_PUNCH_HOLE operations and when releasing the inode, and go
ahead and define an arch-specific hook for x86 since it will be needed
for handling memory used for SEV-SNP guests.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/x86.c                 |  7 +++++++
 include/linux/kvm_host.h           |  4 ++++
 virt/kvm/Kconfig                   |  4 ++++
 virt/kvm/guest_memfd.c             | 14 ++++++++++++++
 6 files changed, 31 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 5e6b58439100..c4b7b0db7be3 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -140,6 +140,7 @@ KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL(get_untagged_addr)
 KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
+KVM_X86_OP_OPTIONAL(gmem_invalidate)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1fc14aa58913..63596fe45013 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1796,6 +1796,7 @@ struct kvm_x86_ops {
 	gva_t (*get_untagged_addr)(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
+	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 67d7c9e1331c..aaf71e5c1d18 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13519,6 +13519,13 @@ int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_ord
 }
 #endif
 
+#ifdef CONFIG_HAVE_KVM_GMEM_INVALIDATE
+void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
+{
+	static_call_cond(kvm_x86_gmem_invalidate)(start, end);
+}
+#endif
+
 int kvm_spec_ctrl_test_value(u64 value)
 {
 	/*
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 22feb4910854..a2a8331fbb94 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2401,4 +2401,8 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order);
 #endif
 
+#ifdef CONFIG_HAVE_KVM_GMEM_INVALIDATE
+void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
+#endif
+
 #endif
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index f5d6256607d2..734b7d467380 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -107,3 +107,7 @@ config KVM_GENERIC_PRIVATE_MEM
 config HAVE_KVM_GMEM_PREPARE
        bool
        depends on KVM_PRIVATE_MEM
+
+config HAVE_KVM_GMEM_INVALIDATE
+       bool
+       depends on KVM_PRIVATE_MEM
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 5e88e525cf75..feec0da93d98 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -370,10 +370,24 @@ static int kvm_gmem_error_folio(struct address_space *mapping,
 	return MF_DELAYED;
 }
 
+#ifdef CONFIG_HAVE_KVM_GMEM_INVALIDATE
+static void kvm_gmem_free_folio(struct folio *folio)
+{
+	struct page *page = folio_page(folio, 0);
+	kvm_pfn_t pfn = page_to_pfn(page);
+	int order = folio_order(folio);
+
+	kvm_arch_gmem_invalidate(pfn, pfn + (1ul << order));
+}
+#endif
+
 static const struct address_space_operations kvm_gmem_aops = {
 	.dirty_folio = noop_dirty_folio,
 	.migrate_folio	= kvm_gmem_migrate_folio,
 	.error_remove_folio = kvm_gmem_error_folio,
+#ifdef CONFIG_HAVE_KVM_GMEM_INVALIDATE
+	.free_folio = kvm_gmem_free_folio,
+#endif
 };
 
 static int kvm_gmem_getattr(struct mnt_idmap *idmap, const struct path *path,
-- 
2.25.1


