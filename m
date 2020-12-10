Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9562D6463
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 19:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392586AbgLJRME (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:12:04 -0500
Received: from mail-bn8nam11on2055.outbound.protection.outlook.com ([40.107.236.55]:12128
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404045AbgLJRL7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:11:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LEqTtt/aKGMQrqtgtdFWZ5e6m/zAFpv0fLyl9j2wei797ZUOuqIFV5a+8Y7mOsQQwptUz+9t+lMYys0JsRJeZRkUYpjDYOMfK41b5XMP4z3XSATfrZVL3Woy9UGq1X4SbQzA+lTvki1PM4z6ox1GaRNFBuiIsVnPCow4UZtO5X9FdiuDfoxt8ShdlNMzKyy9bW3B98D4XYUCYvFUsmnsfcZpZmc9LOLl8EJdyUGvfkPraa617i4ZkZFlBH8+pjMOCvc5xFfRCulCPiVCN7jJJSeCRXJbfUTgABIPTILmqgEKlkD1sNpUfCA36zN4NnP8yKwhx3EWV138k9xKkbfpkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PEtoMDOqwoFYvsVfCzs23UbXbVu8BlXHQGB1s/VyK/A=;
 b=lwPYgyfvXxzbdB/Pym3kaUZj1cLd0Lvv4KajVPzYzr1kfAXAgXSrB2VQs2BFAFyD6hBxOWbQvaIrJxBBuhxcCNtJzatbjHMinBg9m+lcGy+hPWcRBFy+wC5981ibCOKgRt+H5FQIG/8gfue+lMBsoaJpK93dEIY5tA4t/WkpFopsLHJ2M/Yb3/ynHCgGQkNp6lC2gjEMCsHl24pCKfE9jilfs1Wn9+ojLrMKWPH5zQnKqog55eXxV77qY9P9dGJ2pxMD4XD3GGqUHAmHznk0HTlK9ZJhUyJGO/cnoRwnf3FmThp3Szp4v72Nyj4fj2jL9byBehOv0DWYMM/fJaNlwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PEtoMDOqwoFYvsVfCzs23UbXbVu8BlXHQGB1s/VyK/A=;
 b=rpE89F520pnRwzfpEjGaDfex+BrInNqY0UptzW2vjNyy9e2xd9/OXuGoyQQdhXEfr5mQzms1TpUneMU+azIN96hQjj8kE1IkWr/GU3qK9FJjxykecN53r309fHnBmN9NGwbyfWrBacqKMvjW46t7ENSRmtQT1iKpYzpcW+z/dK0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0149.namprd12.prod.outlook.com (2603:10b6:910:1c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:11:02 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:11:02 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v5 05/34] KVM: SVM: Add support for the SEV-ES VMSA
Date:   Thu, 10 Dec 2020 11:09:40 -0600
Message-Id: <fde272b17eec804f3b9db18c131262fe074015c5.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR10CA0005.namprd10.prod.outlook.com
 (2603:10b6:610:4c::15) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR10CA0005.namprd10.prod.outlook.com (2603:10b6:610:4c::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:11:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2f337d77-b50b-4dd1-3207-08d89d2e9248
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0149:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB014951F944A87B4D64DCE75EECCB0@CY4PR1201MB0149.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YszIKkF1XMFN7Xbmd5KeJwpETzawnQPV4KleW7apWMyFZbaLv7OG0NJfzytX5kgjczPtWydyTGV3skCL/HOEaLsappRxaJoyoRSQawx716kF8gJAwE5mr7vZdLja3tW2M52+VoAUzhUN6vx4Ua2XzrJNn296RUIlOHdwgjxIsIM9TTKa3M+/781ejDgpg8ej5f9xSWYY7+Z5eNHWyF3o3W6UURkdSFSEtQ/zYHMsmO8PFCmaMM6QNeiJfVlnNxbu+kTZarwaQUhjOCjkylFHKbiGEy5esqdimkrun0KixQuCuok+tDWhR57lKjm0ElF/Yl5L8HpavT+JsstT82dxm12REI85rF25AcQ6f8WjXaqXP7ZW+DIwKWiRWp0DoZ0J
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(2906002)(5660300002)(6666004)(26005)(52116002)(186003)(83380400001)(16526019)(54906003)(6486002)(956004)(2616005)(8936002)(7696005)(508600001)(66946007)(66476007)(36756003)(8676002)(86362001)(34490700003)(4326008)(7416002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?P2rTGfTqrpBmtiSc7FQ440T3exNgbCVCal9VkifnB6uzEet2lt4gZ716V273?=
 =?us-ascii?Q?+/nhFMtG4jTjyqZrDFMBl9zm9ZMQ27vU/LSum6OMWTxfDR0qhztv3ysKQpiv?=
 =?us-ascii?Q?ED8ugGqu5zuHVJwY9zOQksQ5DhHGWpRth8NqD2zLZzdOGDxsuL22qD7qSUQi?=
 =?us-ascii?Q?TnGgjxA56GWLSX0F+8zjB01cplTHzk/y4HUSX1w/J8xcKJFmgIiglBhY2qNn?=
 =?us-ascii?Q?u8wOqq76gad2h4nys20sffqV1oh+uuOUaf5OzKUCmk3UgwmeIaUw4FX0LSmG?=
 =?us-ascii?Q?hvoWkzp9VBbJnfnCX5cNQrHIwWA279kiyaRFFe6x+j+BuyfRapkBCnBPdF4Z?=
 =?us-ascii?Q?PU5dAbEioCojAzfF6dLk7azkpA6F7xJ2gRdrCpUT0/o8tpBc7euMAgCWqy1F?=
 =?us-ascii?Q?1aLngwZfwZHWwmsbCa4FBEQ+7ASE6DkUPItod2tuUks/fYk3/axq7h0Dl2aA?=
 =?us-ascii?Q?+5YWZhS3MwsnnhlnPlLMGFjcjX27klcQxxp6H3jwDXmzlRiq/DtZz7kR56oc?=
 =?us-ascii?Q?4hhFJ7f2wUPWv4NxvNE+VqaRShfl2MAqg3jJgQLFsnYF7mNxe1UFtWn/MC0/?=
 =?us-ascii?Q?Qp0/u5aaFfBC/Y9hB7URtmw/yvjieeoS2Bp9FSeHjkRI8hIZ5tWWEs1Qx89u?=
 =?us-ascii?Q?jqZycmGAh0TzwjknQqqgAaNV8yQaSLqm18gUZWyh6+7CRHsZdsvj04Jh6Rno?=
 =?us-ascii?Q?ol0fUOGpv6078ZkFU+L7kqLRiQd/SUQEivjsgIGhbaMr4D5tcaohWpwvnItN?=
 =?us-ascii?Q?xPh+2IVeWxvD5p838nKHbeVXiMwdjVvcJoEcjArONdO4mAdHsizx9Qg4+wsj?=
 =?us-ascii?Q?NFlEUmfpRpgmRXE5aXkYIybm9IFy8zFGg6ZARFwUE0JHbUR/BOGuBYxpTagI?=
 =?us-ascii?Q?m+lylAJZitxXW9tEJEH3SIN+v4azKyEzNkRLwrqWtReuvkY2IQFZJCLBbaJC?=
 =?us-ascii?Q?CWdj+pjw4fsJtLuWCPzRIWqb2vHZGfbl2o4Nzh8onlX/tx3WrQ4s0titKM3e?=
 =?us-ascii?Q?Gqb6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:11:02.0057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f337d77-b50b-4dd1-3207-08d89d2e9248
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ci4B11NVpSv52yxG4nvzw/xH1Ap5Fd+1l6iQP9QQGdPX02F+nTQ+kbkhyBV7I5En4AfptLGKY2HhOw31WGAwZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0149
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Allocate a page during vCPU creation to be used as the encrypted VM save
area (VMSA) for the SEV-ES guest. Provide a flag in the kvm_vcpu_arch
structure that indicates whether the guest state is protected.

When freeing a VMSA page that has been encrypted, the cache contents must
be flushed using the MSR_AMD64_VM_PAGE_FLUSH before freeing the page.

[ i386 build warnings ]
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++
 arch/x86/kvm/svm/sev.c          | 67 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          | 24 +++++++++++-
 arch/x86/kvm/svm/svm.h          |  5 +++
 4 files changed, 97 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f002cdb13a0b..8cf6b0493d49 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -805,6 +805,9 @@ struct kvm_vcpu_arch {
 		 */
 		bool enforce;
 	} pv_cpuid;
+
+	/* Protected Guests */
+	bool guest_state_protected;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9bf5e9dadff5..fb4a411f7550 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -14,6 +14,7 @@
 #include <linux/psp-sev.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
+#include <linux/processor.h>
 
 #include "x86.h"
 #include "svm.h"
@@ -1190,6 +1191,72 @@ void sev_hardware_teardown(void)
 	sev_flush_asids();
 }
 
+/*
+ * Pages used by hardware to hold guest encrypted state must be flushed before
+ * returning them to the system.
+ */
+static void sev_flush_guest_memory(struct vcpu_svm *svm, void *va,
+				   unsigned long len)
+{
+	/*
+	 * If hardware enforced cache coherency for encrypted mappings of the
+	 * same physical page is supported, nothing to do.
+	 */
+	if (boot_cpu_has(X86_FEATURE_SME_COHERENT))
+		return;
+
+	/*
+	 * If the VM Page Flush MSR is supported, use it to flush the page
+	 * (using the page virtual address and the guest ASID).
+	 */
+	if (boot_cpu_has(X86_FEATURE_VM_PAGE_FLUSH)) {
+		struct kvm_sev_info *sev;
+		unsigned long va_start;
+		u64 start, stop;
+
+		/* Align start and stop to page boundaries. */
+		va_start = (unsigned long)va;
+		start = (u64)va_start & PAGE_MASK;
+		stop = PAGE_ALIGN((u64)va_start + len);
+
+		if (start < stop) {
+			sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
+
+			while (start < stop) {
+				wrmsrl(MSR_AMD64_VM_PAGE_FLUSH,
+				       start | sev->asid);
+
+				start += PAGE_SIZE;
+			}
+
+			return;
+		}
+
+		WARN(1, "Address overflow, using WBINVD\n");
+	}
+
+	/*
+	 * Hardware should always have one of the above features,
+	 * but if not, use WBINVD and issue a warning.
+	 */
+	WARN_ONCE(1, "Using WBINVD to flush guest memory\n");
+	wbinvd_on_all_cpus();
+}
+
+void sev_free_vcpu(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm;
+
+	if (!sev_es_guest(vcpu->kvm))
+		return;
+
+	svm = to_svm(vcpu);
+
+	if (vcpu->arch.guest_state_protected)
+		sev_flush_guest_memory(svm, svm->vmsa, PAGE_SIZE);
+	__free_page(virt_to_page(svm->vmsa));
+}
+
 void pre_sev_run(struct vcpu_svm *svm, int cpu)
 {
 	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a1ea30c98629..cd4c9884e5a8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1289,6 +1289,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm;
 	struct page *vmcb_page;
+	struct page *vmsa_page = NULL;
 	int err;
 
 	BUILD_BUG_ON(offsetof(struct vcpu_svm, vcpu) != 0);
@@ -1299,9 +1300,19 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	if (!vmcb_page)
 		goto out;
 
+	if (sev_es_guest(svm->vcpu.kvm)) {
+		/*
+		 * SEV-ES guests require a separate VMSA page used to contain
+		 * the encrypted register state of the guest.
+		 */
+		vmsa_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		if (!vmsa_page)
+			goto error_free_vmcb_page;
+	}
+
 	err = avic_init_vcpu(svm);
 	if (err)
-		goto error_free_vmcb_page;
+		goto error_free_vmsa_page;
 
 	/* We initialize this flag to true to make sure that the is_running
 	 * bit would be set the first time the vcpu is loaded.
@@ -1311,12 +1322,16 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 
 	svm->msrpm = svm_vcpu_alloc_msrpm();
 	if (!svm->msrpm)
-		goto error_free_vmcb_page;
+		goto error_free_vmsa_page;
 
 	svm_vcpu_init_msrpm(vcpu, svm->msrpm);
 
 	svm->vmcb = page_address(vmcb_page);
 	svm->vmcb_pa = __sme_set(page_to_pfn(vmcb_page) << PAGE_SHIFT);
+
+	if (vmsa_page)
+		svm->vmsa = page_address(vmsa_page);
+
 	svm->asid_generation = 0;
 	init_vmcb(svm);
 
@@ -1325,6 +1340,9 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 
 	return 0;
 
+error_free_vmsa_page:
+	if (vmsa_page)
+		__free_page(vmsa_page);
 error_free_vmcb_page:
 	__free_page(vmcb_page);
 out:
@@ -1352,6 +1370,8 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 
 	svm_free_nested(svm);
 
+	sev_free_vcpu(vcpu);
+
 	__free_page(pfn_to_page(__sme_clr(svm->vmcb_pa) >> PAGE_SHIFT));
 	__free_pages(virt_to_page(svm->msrpm), MSRPM_ALLOC_ORDER);
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 56d950df82e5..80a359f3cf20 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -168,6 +168,10 @@ struct vcpu_svm {
 		DECLARE_BITMAP(read, MAX_DIRECT_ACCESS_MSRS);
 		DECLARE_BITMAP(write, MAX_DIRECT_ACCESS_MSRS);
 	} shadow_msr_intercept;
+
+	/* SEV-ES support */
+	struct vmcb_save_area *vmsa;
+	struct ghcb *ghcb;
 };
 
 struct svm_cpu_data {
@@ -513,5 +517,6 @@ int svm_unregister_enc_region(struct kvm *kvm,
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
 void __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
+void sev_free_vcpu(struct kvm_vcpu *vcpu);
 
 #endif
-- 
2.28.0

