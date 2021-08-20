Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3B73F30D2
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238840AbhHTQEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:04:38 -0400
Received: from mail-co1nam11on2064.outbound.protection.outlook.com ([40.107.220.64]:53792
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234853AbhHTQCd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:02:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YDoty7w2zn73USSy1wH1YoREHasVASB5kov1YzD2deqM0QJd0VSXASLPBjRSmZ0NGmE7yiW2NqP9cWOSLGTDoC6VUrXTU0E3qj+qrtWYu2qwi85vjPfgI8FhFQNeHofL88AoH7p+IPxCaQZmCQm96IYrEjZQ9ETdy1ch9a0EWb0FSe1NEKOKcN6jvYnnIQCCoGj3GbPydyS6Ctv0fCMJOmv9Mah8l543DCzLCPWP+eTOxJpYqLqbblOlfc0PcftRotpx6AyHjO7HbGl7xF91KYt/6OJD4bq7qnO6A6MPB3SwCjzZFpjDbY8OduTGjdZB85zqCGhg48Fo13Lt/opMgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=74NFmsxSTXe6Sl6AIr89lhYMjfTp3eeb5C0yLTnVHYA=;
 b=JgkIKd5w/VpA54LlVfegyC1mcjdzkIG2GjEUMZ68PGK1XRjgUkYXmQnp11ZMT+pbG7H9E+Tr5da45klQDp+7HHarzEzOQXBW3Q0W98/06TsgrDwHfVk1bArC9UwrYUC6WRLdBQDnzm1+nUzA0xmyxGoW5R19JjDceYLZjpRGiH8NiTOabGMvGsYIKJUfyS/kKVXijv9zdr1ebQdygyLQQj18hDwfVBY40JzPS9N+AGKbfTAEhDFK8FQuLL140RtsNja9HKCZOJ9kM/v73mQj6+GHlx3HKG1H68t+x6RxStYDqp3cSkKKmMQK8hqZPDlD09gOG2ks7DUNuQ3G3bPdYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=74NFmsxSTXe6Sl6AIr89lhYMjfTp3eeb5C0yLTnVHYA=;
 b=xmwH0mIZDY43YuwkFo3R3ZWTv+UEduMaSaKMrI8VWPGzV3Y9YpQpmz19/SHsXeyOmm7zMGaW6D3sn13azw7dI553aH7IgfdJFLpdhCCpEMgwWvcHG1QpKflH+4tM0JrgxlNfPt8OJ/DVdgBZRHJxnZNDKSsUgNnFRTxB46dPfE0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2685.namprd12.prod.outlook.com (2603:10b6:805:67::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Fri, 20 Aug
 2021 16:00:21 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:21 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 v5 21/45] KVM: SVM: Make AVIC backing, VMSA and VMCB memory allocation SNP safe
Date:   Fri, 20 Aug 2021 10:58:54 -0500
Message-Id: <20210820155918.7518-22-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca41755b-49e8-48d5-bd23-08d963f39cd8
X-MS-TrafficTypeDiagnostic: SN6PR12MB2685:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2685DA9BD5F6B23D17AD9BEEE5C19@SN6PR12MB2685.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DXYMjrVd8P2lHAYu4R6pWa+IZ1Q7ncmqWwYEBu1Weg83/yITAJW0DcsPA29W5HJeXOEJMmViiikKW323RHVLv5WupwWSMyfSJnsxsf5EUyv7ntp5L/6lw/rJxxEP0WrfhmFpEl9V2hhRtSZXLweeIfeyqgPhg5Rs3JtqZU2TPZSaQOnVEmFEkhC4OQsJmrWEqWw/u8+Dqh0HoOjwOlZhsEeFREXJ1g9/JDD3mNuo+ZIgYzsG/9bqlW6vfycA9gp+qID8M/QLCUW9xdH2iKmAdK7Pk48E4G4uNLqotbFj8qu3knEI/Wg2EYDEdj0JREEz+1NrnE0h1Djy0pipJNlGjeXIAEF6co34sz3q4BkwLjiEuRY/DwskPgTkSjefqgxLnceCxsZi0KzfcjbkbKVlIWfKrMBnvCvdV8sV5n0HFmW4gWd0rNDNV2gn+WIH63rugdQntr/qqDdN+Yk1EVT+8H1GgDUVwgVUz2jKbo0hboNydFOz6d6KoFgP0tpY7HpWdRq4ZJDEwq1l1bBY4/s4wqgTXW0A6Q1JPDrL5smGmWEllOkeWT8CnK5QHIddhvyr0lUYmsAxWtYp6DpMwy36QSeFrlumXIUZlMgYE78WI1N28Af8/hO3TqOgiXtmEz7n6Ao0hO0lxHZIW84z6zPkTQHAVYxbjle+3ODqSKDjg/6LPO/SWFWNmtFV7dkLa0Nh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(956004)(186003)(44832011)(2616005)(26005)(83380400001)(66946007)(52116002)(66556008)(66476007)(7696005)(7406005)(6666004)(7416002)(1076003)(2906002)(478600001)(36756003)(316002)(54906003)(8676002)(8936002)(5660300002)(6486002)(38350700002)(4326008)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jG4cjGcDeQpvHJeQkAjvc6h1ijve2Wn3reFIGiy62EbCzsP9ZgnLJBJYekYZ?=
 =?us-ascii?Q?9/pnHF40kA65HY6wlLxB+RTzrHQwmN7nogXjfY1qalNKwamtFIyhd25RAs1o?=
 =?us-ascii?Q?C5+B0Jun24DtHLT5jlCThfU0Qa88kwfkJSNENLgAtE1YNmusSU7lA+Uza4p4?=
 =?us-ascii?Q?wKQ8VFeXAm3vKYX+jswubqtXS16n8COyfQhQIVR+fKzAd61GnosbZgUcMBrQ?=
 =?us-ascii?Q?HZKW9dE3zIU1fKlOnuPs+azS37cBbnwlTKOSox3DH0jzkGNY4RShI0wXwdnE?=
 =?us-ascii?Q?FzWsfx3pa7pJOTfAEO9+5IcC6DZV59yFriGEuQ/ne5XdaQaRTPdnFn2YF7uK?=
 =?us-ascii?Q?2l0sdiQPWed6Hv96PKZQ/09QuEoq5iEwAEuBG8TKnaIC27O22X/oR8fgzN5E?=
 =?us-ascii?Q?jB/99HA+k0vRBCKqX/ccRd4v7zOBq9tzIhK+lic9xMXUdcJ5jTvEdoc33HsD?=
 =?us-ascii?Q?vi5LmydYAjIZ2QQPCCLR7dzzpvRm1lrzGoujm+kGU3xDS2sLAlvrIgsjz+Ad?=
 =?us-ascii?Q?ssxftFfLsv/L7jQAuf7RT/O+lOOIHedyEneCiBpZpFZ6YeXQz3e4qq5ee8XD?=
 =?us-ascii?Q?2SH1cVpbLuRsgVwHnQdAc26Meg1fSUwMZUcIybOjkaSk/PUqskaR550KYMGF?=
 =?us-ascii?Q?nNBhaQkTdmlDytfvYQzxCcRPUqKnbN4NcWvdrOTupcGfysHM/4WkCKP4gDhA?=
 =?us-ascii?Q?iQITtNCKZ/mLGcPDgaA+qhrlBD0aVsuXSH4FYP0qnrxvXhVq3MZ7TIMJC1TL?=
 =?us-ascii?Q?WCjwmc7aXFnzTWgrZZeclHxQhlencNorHW3IORHuvGZW5IgeLygAVYq8THQM?=
 =?us-ascii?Q?jAyv5nYBS7mxAMBY2H3SEiBNXL5DVNZkAEltvpCNFGfw0r+kRBa3ZGtbfRVT?=
 =?us-ascii?Q?OKwozdNLPC53I7Ov1EoM4bKkL4vMIwuCCXeGyt/XGZoJgayqL/mNIiSgNleT?=
 =?us-ascii?Q?xd1j/OiRF+9f+6zC1k/NO3ydw7wtM8D5KFx1Y/I+dI4hUsik7sbL35QLUC8/?=
 =?us-ascii?Q?27sHG5/d4nUmqYvtaoAcXNI89zZSxtdaOXRfVpmvs8f+rywUEgDtO/EtQDNK?=
 =?us-ascii?Q?i1eJz1y6dgtp2LJmizUZgNIdnxOOtu49mwYKp1ANlo0nb2OJvMyC0jtZgo7L?=
 =?us-ascii?Q?Y9AbtrlKWJbIBvCr+BkE92bc3xIoz5XisdpjctQCrmiViq2f9Yml6g115X+Z?=
 =?us-ascii?Q?YG25M3OUENPTJ7ttWKokrf88CwWq5hWB1aMu46KoXpo1iyedtOE3Ok93spEd?=
 =?us-ascii?Q?GI/U4xTin1MSjKbotKVL9xnBCEd3YwXZBCsFF/IuLpZBqh7NAhHV/2PuQ8wW?=
 =?us-ascii?Q?CFFM3MI37WZkKdpGdmaOHCYl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca41755b-49e8-48d5-bd23-08d963f39cd8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:21.1227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VZWehYxMbM+craAQdxSqx0sEj/TKAxaoOeU6eVQVkXQ7GYRe/amTflM2FN8FyuRg06psaecHOS5tHGi1WMuXzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2685
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement a workaround for an SNP erratum where the CPU will incorrectly
signal an RMP violation #PF if a hugepage (2mb or 1gb) collides with the
RMP entry of a VMCB, VMSA or AVIC backing page.

When SEV-SNP is globally enabled, the CPU marks the VMCB, VMSA, and AVIC
backing   pages as "in-use" in the RMP after a successful VMRUN.  This is
done for _all_ VMs, not just SNP-Active VMs.

If the hypervisor accesses an in-use page through a writable translation,
the CPU will throw an RMP violation #PF.  On early SNP hardware, if an
in-use page is 2mb aligned and software accesses any part of the associated
2mb region with a hupage, the CPU will incorrectly treat the entire 2mb
region as in-use and signal a spurious RMP violation #PF.

The recommended is to not use the hugepage for the VMCB, VMSA or
AVIC backing page. Add a generic allocator that will ensure that the page
returns is not hugepage (2mb or 1gb) and is safe to be used when SEV-SNP
is enabled.

Co-developed-by: Marc Orr <marcorr@google.com>
Signed-off-by: Marc Orr <marcorr@google.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/lapic.c               |  5 ++++-
 arch/x86/kvm/svm/sev.c             | 35 ++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c             | 16 ++++++++++++--
 arch/x86/kvm/svm/svm.h             |  1 +
 6 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index a12a4987154e..36a9c23a4b27 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -122,6 +122,7 @@ KVM_X86_OP_NULL(enable_direct_tlbflush)
 KVM_X86_OP_NULL(migrate_timers)
 KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP_NULL(complete_emulated_msr)
+KVM_X86_OP(alloc_apic_backing_page)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_NULL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 974cbfb1eefe..5ad6255ff5d5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1453,6 +1453,7 @@ struct kvm_x86_ops {
 	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
 
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
+	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index ba5a27879f1d..05b45747b20b 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2457,7 +2457,10 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 
 	vcpu->arch.apic = apic;
 
-	apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	if (kvm_x86_ops.alloc_apic_backing_page)
+		apic->regs = static_call(kvm_x86_alloc_apic_backing_page)(vcpu);
+	else
+		apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!apic->regs) {
 		printk(KERN_ERR "malloc apic regs error for vcpu %x\n",
 		       vcpu->vcpu_id);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1644da5fc93f..8771b878193f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2703,3 +2703,38 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 		break;
 	}
 }
+
+struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
+{
+	unsigned long pfn;
+	struct page *p;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+
+	/*
+	 * Allocate an SNP safe page to workaround the SNP erratum where
+	 * the CPU will incorrectly signal an RMP violation  #PF if a
+	 * hugepage (2mb or 1gb) collides with the RMP entry of VMCB, VMSA
+	 * or AVIC backing page. The recommeded workaround is to not use the
+	 * hugepage.
+	 *
+	 * Allocate one extra page, use a page which is not 2mb aligned
+	 * and free the other.
+	 */
+	p = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO, 1);
+	if (!p)
+		return NULL;
+
+	split_page(p, 1);
+
+	pfn = page_to_pfn(p);
+	if (IS_ALIGNED(__pfn_to_phys(pfn), PMD_SIZE)) {
+		pfn++;
+		__free_page(p);
+	} else {
+		__free_page(pfn_to_page(pfn + 1));
+	}
+
+	return pfn_to_page(pfn);
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 25773bf72158..058eea8353c9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1368,7 +1368,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	svm = to_svm(vcpu);
 
 	err = -ENOMEM;
-	vmcb01_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	vmcb01_page = snp_safe_alloc_page(vcpu);
 	if (!vmcb01_page)
 		goto out;
 
@@ -1377,7 +1377,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 		 * SEV-ES guests require a separate VMSA page used to contain
 		 * the encrypted register state of the guest.
 		 */
-		vmsa_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		vmsa_page = snp_safe_alloc_page(vcpu);
 		if (!vmsa_page)
 			goto error_free_vmcb_page;
 
@@ -4539,6 +4539,16 @@ static int svm_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+static void *svm_alloc_apic_backing_page(struct kvm_vcpu *vcpu)
+{
+	struct page *page = snp_safe_alloc_page(vcpu);
+
+	if (!page)
+		return NULL;
+
+	return page_address(page);
+}
+
 static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.hardware_unsetup = svm_hardware_teardown,
 	.hardware_enable = svm_hardware_enable,
@@ -4667,6 +4677,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.complete_emulated_msr = svm_complete_emulated_msr,
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
+
+	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d1f1512a4b47..e40800e9c998 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -575,6 +575,7 @@ void sev_es_create_vcpu(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
+struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 
 /* vmenter.S */
 
-- 
2.17.1

