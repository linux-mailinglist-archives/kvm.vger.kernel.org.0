Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B97B2D631A
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392517AbgLJRKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:10:07 -0500
Received: from mail-bn8nam12on2064.outbound.protection.outlook.com ([40.107.237.64]:38097
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392514AbgLJRJl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:09:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOgsSEstEZone0d8gXxbAKPvD0Hee5QhbcRVRUgGzQM1mRZtCyN3fzVN6QV12ska7ZBnjN/5Je14SF/VTdQxNk7qyUHQ6pNdPRrHuA30GipXTheZ2B7yu0UtjO5JCUyr2PG7ZMRXBMJQXgfM8r+Q/5WwGm4qBOfOJkEqYIRLjtWLinwiHOfTjPLXVkVyZTcG09bjOzdW68nBX8R8N6M4oT+kA8YyipJKNjAjHSbS+8Te2Mlru5aCgn5RBZiI3fdPr1Jn+rrWYD6SU6Iudmw5wIY0Pu5DO5H5JTgHBuFcKeXiWlmSFDJJQIeOTwdQXMFNYXYxKTDG6peBEvcSStoZsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PEtoMDOqwoFYvsVfCzs23UbXbVu8BlXHQGB1s/VyK/A=;
 b=LwlyyWhUHRvu61RWn3/FICofKAqGbkHttiM4e6Kk9MnhppZhqLUauLuTmgQulqcuIvyGwzt1jYq//GwPcFJO1G6tHf0BwfwPTY/HVEEopUEkpEuC6pHM4CLEGmpKx2/DmdZJ1xmFejqG0/Ib5XS21fJagC77nK4EAM6bRilg2hpD7BiZ4J8XKs6mTj8EiLc7uNACnAjvjC9kMuglAyDtXgiR50NAhwoBLk1bxkzmg1mBATp4Nae9navXG73ohZiXbEDP0AWUQdyB9E0SzYvVGQUlhG5o+xBmubNyC+r4+lyQe3PL3Kla9/9FFLsbaoZAsBhdNvnQTyDpwbTWC1W1cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PEtoMDOqwoFYvsVfCzs23UbXbVu8BlXHQGB1s/VyK/A=;
 b=2hox1jhKZ5dg0adD0+Ziaq/l4ySeHPQaJInAVkNhSUd1KtzHL6lcXo/4FL6XATmGxVnl1HW9uXitDpV19s3D7NyNy+XlOmi1JaKcTVv8GEx/Euy+VcXdt7368p/YukwHPjR7NXPuBALQ7rsbsBVMoaIBxLceq0Z/KKnUPbLGd9k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1493.namprd12.prod.outlook.com (2603:10b6:910:11::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:08:18 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:08:18 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v5 05/34] KVM: SVM: Add support for the SEV-ES VMSA
Date:   Thu, 10 Dec 2020 11:06:49 -0600
Message-Id: <fde272b17eec804f3b9db18c131262fe074015c5.1607620037.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620037.git.thomas.lendacky@amd.com>
References: <cover.1607620037.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:610:59::21) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR03CA0011.namprd03.prod.outlook.com (2603:10b6:610:59::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:08:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f8f02ee0-0848-477b-8fa9-08d89d2e30b0
X-MS-TrafficTypeDiagnostic: CY4PR12MB1493:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1493477CF28A2D8A1FCA4199ECCB0@CY4PR12MB1493.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0F3tIG/RvrRp/r1240PWGuZ+I9LZulAkBDOab5r01uojTIM3VeYUsnh5TE5l8TJmnwNpSPqyqZUfmM6ApGr5qEjWNSmQaMoxU5h7j3yagvwsYQ0ToVT+NMsCKeGeUwgfafvCy5ZoW/b6Yp3UPDRXt22fz9nlsV5iG5UKwt6bxpwFta05T9BJ8apmSSCemn6ata/X7lQH9MYOoh8bt6hNLA0JPLAY1TvsXa4hjrBKXL1kXL5vyQRJRLTAcRndbxDp9+R3i6s86XIG0Ae7XApoeWfhWPIn56QjskcZsx1Lt9h9FibXFV6BJzou7xdwp5eGWBMKmjYO/XO+Si2DRk6PXar57cmHD6VIZAwWa70MaF4vRunxWhxsRxLr8KCB02Ko
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(346002)(5660300002)(66476007)(186003)(52116002)(8676002)(36756003)(8936002)(4326008)(86362001)(2906002)(66946007)(6666004)(66556008)(26005)(508600001)(34490700003)(7416002)(2616005)(16526019)(54906003)(7696005)(83380400001)(956004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6s5YIdu3rfKkIE9zASFKeb1WEwPJuPjyKrdLkuPxocYvIF/i93tXe22xWq/0?=
 =?us-ascii?Q?tiOr999uR/EwQdb/90YiVeuO5SONE6VDh77/yUG1o+Cwhs+/QGkZuhxqtXo9?=
 =?us-ascii?Q?pnGTmiJlxqkKIfWHMI/DxgxEOzvZoqp/ak+CmJGpusLZ+Y6eBDpUkBhkwnwZ?=
 =?us-ascii?Q?Lyk1f/ypUso+n3wgEDNEE4WJNXl9hZAFnuWghkEvwJAdcCN6NQ4+Zfty9Bxj?=
 =?us-ascii?Q?WinwbgWRBDJs9i6k6mK1knegNnQLcW1K9aNXDcF1OUfeUob8Apgh5jG+644d?=
 =?us-ascii?Q?U82cYAnwQLaWblRJXOE8jNwk5G3nSMwRCkF+IC1Yc9Qd0qJxUZAn8Io7PYml?=
 =?us-ascii?Q?7JM3xP2/tclhXcvPisq7whWMHItlgedRgKZBMaZ3UInFVrybwIMFwnU7PNLv?=
 =?us-ascii?Q?rgYUu5T5MuVJdnaKuSOAHe3MBj1cZIh9WmdcTYSXkgumUintADU2qMdeXB8N?=
 =?us-ascii?Q?lWrkxUDFLfwCJmEDgXX0pXnoZ7x1cS28cK2bB7wGj2DChEvinzsg6YzvqcI/?=
 =?us-ascii?Q?KNauYR+wpFJv84NfElEeI5zbpflR22gmwEcf5RAZE/6VGwYgWgOrFJOXUWR0?=
 =?us-ascii?Q?OgrJC61u22FHlq6ZKoUUEfe269+CHMW5mOMP+ytOx66h/izPlOjY+krw1tOL?=
 =?us-ascii?Q?2wYHuSkfs2nOKt1wKHUxkqwJjMGlnYr+H8LfAR7U0jMCeiknGmJaOUMyD6LO?=
 =?us-ascii?Q?wtCmssF3JLJ6nzq9yczvBPiZBdCea1he9u2W6z9BgNvExDFMXmetnT/6Yaan?=
 =?us-ascii?Q?8sV3Ol05hUQDiF9Eb4Pkau/Ln5ay6910q5JsTBBqyZjkczVG86LzXiaqTVK4?=
 =?us-ascii?Q?LCwbqheny0kkK2+xo0A89gEPis1kYu3aEY6MRBTdamx8kb7prjBClS6vGTxd?=
 =?us-ascii?Q?SMk/s9fzjh2VfoRDRZ8d815SAX5YLsUN/oDAbViAhcTWD+2tJBhxrxZsN53b?=
 =?us-ascii?Q?oBnU65SpJTH8ATx7gT2hOCYF+GBTtcLn3PKii8SU6d9mU0GP3FxgkyQpJBnz?=
 =?us-ascii?Q?Ap7i?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:08:18.2619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: f8f02ee0-0848-477b-8fa9-08d89d2e30b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C3wSEwErFubusLI8qWeatnNrAKLioWnmNPuwV3FvnNofCUwzxsCM223+pdpWAUGhjho5HAcwpWwPOVXyLkJFjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1493
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

