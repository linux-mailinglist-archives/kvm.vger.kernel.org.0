Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4B72B6B28
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbgKQRIh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:08:37 -0500
Received: from mail-dm6nam12on2079.outbound.protection.outlook.com ([40.107.243.79]:33056
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728757AbgKQRIg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:08:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hlWQsssCb/5goir5Lf22gTNVJXYQSwTuIGnlh6/g5I5NQM6wFRDNAJBUXbez9F2gQj2HuxK7KtqHsOOqKdsvppmQkitwMe6mtOEbYa8T8WPXDdTPZ4Uk5yrwf6+MyD7Y1TDzg5YgoPVBYq2GsAKD4roItgSdgoBouAT7XCDB/7yg1Gyw7LBUeFZ2rkNIEwyPo5CzU+N9aK4gZ9Tj30NLI6CAaRjwdDxcxZEZ91qMyCxaIJjyjDc6v0zP4K522V8TaaR7SJ9ibPx9k5s4iyqqsXYNO1Yq2BXFF1jx9JETeOBKG2S968jr9G9cYXpl8kVDq4xyCha3hGUVEM/lmSx1vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+cVWWZ+Zsb7dFNaDJwSWsv0iGJTAQ9J7NMOzwDEhREc=;
 b=WQzFa43gKcb01ayiNRQfnLl7PxqZvSqVPDzMX9id1UAsJ0B5Ax4A6K929AAYcwMtVMdV+Vx2y4hldNfEJiCRa2qLXvSaITjEOK9H9kWl1GoLRvRjvIkMBXtWw2xqkyqR4LvYXHL5Pv+yMRJ03FxYvMdbAU2VxII6VJLIEZBIulLBi7WpUbT7ICuiFHJxT/SyQVqOkQuNadnbfDYTubUCM94FrCnv+bSJuLL8nldwNgxvd71lB4u/cGJIMdEFAowCTty4WvLaTnyv9+vMMFl5SjSnw++/BOelmbcsRkCySo89ErdeQMMVfRB2xxfKUPovnptcwLYlMIdFm3twRqN0eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+cVWWZ+Zsb7dFNaDJwSWsv0iGJTAQ9J7NMOzwDEhREc=;
 b=HS1xKkbUI2AOXFw1TR9KJmBtkQz64VzcbL9m/hTi/ERuEDaHj/+og5whoUt0MhFyIQMLnhOr4Naks39RCLNA5GcQGBarSZh6cSty1TbP7c+Ikb7euk2HSIkWD/T4tHFgk0kEytJTDwP+213vIjmKyzNqRvDdiClF3qoCQBgY1Q0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:08:28 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:08:28 +0000
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
Subject: [PATCH v4 05/34] KVM: SVM: Add support for the SEV-ES VMSA
Date:   Tue, 17 Nov 2020 11:07:08 -0600
Message-Id: <80990beb49ac45f15153d2278755c1c50ce5ba7f.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR2001CA0022.namprd20.prod.outlook.com
 (2603:10b6:4:16::32) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR2001CA0022.namprd20.prod.outlook.com (2603:10b6:4:16::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28 via Frontend Transport; Tue, 17 Nov 2020 17:08:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4f5ae0f9-4077-4a3d-057a-08d88b1b6717
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB17723D45EAA9BE7CC27D607BECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZRAsOvBr2JCk3EOcYHbfrY0CCfLKmt0k3+EZ+kF5HjKQrboxumgDg/HxKDknGhMQsA+xW7QFV8jNnl3hzRtO+iR8zlKoFEwySuuZyfw4cdR5LdpaYR3nNwMq71B3rrpUYa9ZB8SAlMpDpbVsbCOygM/qTkbLOp3FssHPatQpFKt1EwHZGLXtcgPV4Lo6GbgzAwK/ZY1dwf0GDd4fn/H8EccD9VxUqa8IyR3LyCIuCsA5iH6iHk9wy+DxDoxxOK3uZL3RSNbBLXOm+KVXLNnKMnW17c9N6WsqP1bPfWNWumVcK8bR5U0XHOkB/CP9mbS6IqzilcbXdESQiL18I70TxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 813u53sHo7F3whlsx1090X1HPzKGHHoI4Mus5vIXMiLYpDdzn96P2gXQa3ZZzUzIRqujA3bybvK96Ccrc1vhtG/aOImP5J+j6zaxqX12LpOB4QVcLFvLElc6WHXtduSJ8P0PXWrHA+q16mEJvcEua8zXIIALIV8b443gjWdgkGcWOGXzHiH/fqWtPozM6XSf6w616d8F0fC96gxyb5KvevqAoKYtroUqFIoaWMfonDAF5jq9PhEOUTQ6XoRLNSkR+ZIqtsCgjlVJFaqbv1WxKKQyAiMiF2DwPnpEmmMP4tvNgLAFxVVYZJ+3GvluuyKi/vHDn7LYZuqtRtrRVhjqVuacWomNgYaqmZIDLrrcKTdpXz/uaSMsWqGvt1Tu38W2Wc4dVpSNp4pBumTnoKCtNeKoPSMvMijp4qOuJNvSCIOd41Ku3SqbrhMLb0IT52a1avwPzo8CRVNqZ9XMoVKvdk4uUfHU4sxNl7lyzHTVTfWi5XBhh6BSBrqPIXNl1Rb5FxoFf0Zyal9fR6+AuH+xng1BUElyJjaaZfGEJ2K68kiXSuOYnPJGVboxUF4IYbE9gJZaAgcN41FTlCECKHDeSmY22ydpjuQxZhME7+Dk37vc77j5VsFL8QTkHLmzBkeuNwewf5J8JIFt/1nqTT8Bsg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f5ae0f9-4077-4a3d-057a-08d88b1b6717
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:08:28.4594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9L2rjoOD1cHKlw6Zno5b8Pkc9m+5FkEdtR31CsRaCRAq8XzBsOi8TQvHFuIt7HBpi5A54df6at+1zE7n26XYhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
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
index d44858b69353..7776bb18e29d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -804,6 +804,9 @@ struct kvm_vcpu_arch {
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
index a3198b65f431..d45b2dc5cabe 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1288,6 +1288,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm;
 	struct page *vmcb_page;
+	struct page *vmsa_page = NULL;
 	int err;
 
 	BUILD_BUG_ON(offsetof(struct vcpu_svm, vcpu) != 0);
@@ -1298,9 +1299,19 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
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
@@ -1310,12 +1321,16 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 
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
 
@@ -1324,6 +1339,9 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 
 	return 0;
 
+error_free_vmsa_page:
+	if (vmsa_page)
+		__free_page(vmsa_page);
 error_free_vmcb_page:
 	__free_page(vmcb_page);
 out:
@@ -1351,6 +1369,8 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 
 	svm_free_nested(svm);
 
+	sev_free_vcpu(vcpu);
+
 	__free_page(pfn_to_page(__sme_clr(svm->vmcb_pa) >> PAGE_SHIFT));
 	__free_pages(virt_to_page(svm->msrpm), MSRPM_ALLOC_ORDER);
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index af9e5910817c..8f0a3ed0d790 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -167,6 +167,10 @@ struct vcpu_svm {
 		DECLARE_BITMAP(read, MAX_DIRECT_ACCESS_MSRS);
 		DECLARE_BITMAP(write, MAX_DIRECT_ACCESS_MSRS);
 	} shadow_msr_intercept;
+
+	/* SEV-ES support */
+	struct vmcb_save_area *vmsa;
+	struct ghcb *ghcb;
 };
 
 struct svm_cpu_data {
@@ -512,5 +516,6 @@ int svm_unregister_enc_region(struct kvm *kvm,
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
 void __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
+void sev_free_vcpu(struct kvm_vcpu *vcpu);
 
 #endif
-- 
2.28.0

