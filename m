Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D592AC85C
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731705AbgKIW1A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:27:00 -0500
Received: from mail-bn8nam12on2083.outbound.protection.outlook.com ([40.107.237.83]:39853
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731704AbgKIW1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:27:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cke1Go2AfM9+uQ61qO/5Rz8mVHDDclpuXhMw/tOwp/ACK+UqH+bepHw5d5LNbQy00/dYc2lbfS0fuDbUYl2q3azuTBAnE9azbeP7kQcJGXJugEYRDZgfyNh8FcLbv3XZZrXxoCMyvTdXUYwaR7lOQymkFzbXqWFabeRCiCNtp3bNRlJ1XgDXCXoFrdTdOQ4/JZjUYlIETQgEavYN+12Gxxfrk8qqi5S5DE6DI0jdRmCxUbTWPDJiSnHK/R2ilrjuZ2G3Tj7bYU1/k9rkKhlibRR2tdAj1C7Aqcnjd/zDNtvL5G2dC27JgY5HsePkTuHDh1WTLKY6GuWMCT959lWJ9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PJiBGjZbVgKiHRDj60q14DxSTl/maC2fjFJSUyLwlk8=;
 b=Ip1d7EBjJSJeviPn/A0vypk08nqmVZ67HvvR6aaucGcKWV9pwC/x5AzRfArrt4DjT2M/OonyuAT66TEBUgCwxr8MT6M4+18beF0JPSvTe734/Kd/PPuah6EPctZW8rJxpnSUyvS8t5gqTYRTbCPOnJnCZsk4dclrhru+Gx/YILFedEyTHkuctlc104O7fGyF7miziLpIMomVQ3yurt//ayCpcvmtVU+oK2XGe+75W3kTvoDqJVN0Dofizjp63G7yIZ11+CE0Hh4glyRcRYPj9KCkothL+F6oQlDoiWPb2euVu4oWEK1i0WsrhLtXtNxm+0QI58ZknzVcSzCw4nx1Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PJiBGjZbVgKiHRDj60q14DxSTl/maC2fjFJSUyLwlk8=;
 b=iiRPKI9w0266qa02CS4GsIfhxZZdqUQhTe0PC5VtABK9jtgQCi3OShEawvvS2rfqoUBHdM5jX0hEyXKIZL+c3tAArg3lS3szOgqv3hUu20NtW02D78SdOujb4NjL6rREWTktkMkwbCGqD4N+UTirKU5ntrrRdqS/wUvaRcFFxnw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:26:56 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:26:56 +0000
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
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v3 05/34] KVM: SVM: Add support for the SEV-ES VMSA
Date:   Mon,  9 Nov 2020 16:25:31 -0600
Message-Id: <316f09c279628b972730664250903936b8a7b372.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR16CA0065.namprd16.prod.outlook.com
 (2603:10b6:805:ca::42) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN6PR16CA0065.namprd16.prod.outlook.com (2603:10b6:805:ca::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:26:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5c6aaeca-0915-49d6-20c8-08d884fe90f3
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB405866C79E772445CD586215ECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9TWIl2m5VsAE4UUq9ItKVVDUxmcO6hULZNlo74xWUqKtbNFygMl7XwXeA4fw7NLpoz+tm4dPCHh/20VZysfD/kwSd5IxIud27O4xcOQGDTAihBGg0MhIYCt5lZoZs+R9OU+RVcR4CLIWl/XS8kLFPWPzp/Nt3AqqMfQE7m17Ggn9Zx5Z2RAB4c6/MnZYjmDaCnZPb28kRT39WhV09dNujgXxsOSomy79muns/mCsXT8eRadmhiYedS72iiQHiuiRJwGYzCAymuqV4CY1zYz3kHcInzuWost5KAXAl1sYRemrXPMjARwkF6VjY/neqjIfxkFvTeqZPtefAJwVuI4KMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: MmC8nBhaKx3jCUoxZhhOk0mAMM1x8nXKTKFeqyvGrcc+x6ISLj09dBOELE5ZmxTIi6lrv4VQRfe/k+guLEsh5abF+qHqgkUiqvj7yrPgQsvbbGyFfTUbbLouDATvd02wm+EBhgF8Tj8EKZHqWk65YFBLzBDFgrRI/RUOD3jQk7MGubEiMpiOUVpwyGmq+efx1ZrN9crDN+AUweaVo8/ezj3obRHW7Csadx2HjH5a9m/pdX3D6X32tslmdwwGjJFEGcr7T805T/6wHflzFABYHbNout0nmQocOxYs9hVmPPqWD4+r6lUhrc1gfUJPgTFILSpVqcMMpgGfJ/wcHLVj1wopV7IWRjor6xikHhqYBo6PQ28qpyzK2gJguHiHspyYPzpI80SbR2L6kl8phaLC0/4Q9cDW2kMNmU53iThpdnT9pJtY4G2naivpcdieQLPSaZsI6NHWGI5xebjwhHmKr/iCG5Tfpjxynt1lSUhvsXizQ8iKpN598LdJfB9CJbvoq/287hngXmGCNQMPLxCGQy3096GVa480bSDzL6sZ2RCRu/CUvH9azeiLoUOf5iZ2vv6t/BRp0OV1rs5tHXc5fMjZoDuDPHe9saP63hr/UbAYd6f/eLnbU5ZlEzC2u+nxcCjh93nra63DAfNacxiIaw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c6aaeca-0915-49d6-20c8-08d884fe90f3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:26:56.2776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YdorTaDhDtX4fQ7/lShsecprSc/1Ge/h5LCzWkVvOAxxWCy71YGQrrPjpDZxwnoPLJcUmAp2FdC5z0A1B0J1WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Allocate a page during vCPU creation to be used as the encrypted VM save
area (VMSA) for the SEV-ES guest. Provide a flag in the kvm_vcpu_arch
structure that indicates whether the guest state is protected.

When freeing a VMSA page that has been encrypted, the cache contents must
be flushed using the MSR_AMD64_VM_PAGE_FLUSH before freeing the page.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++
 arch/x86/kvm/svm/sev.c          | 64 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          | 24 +++++++++++--
 arch/x86/kvm/svm/svm.h          |  5 +++
 4 files changed, 94 insertions(+), 2 deletions(-)

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
index 9bf5e9dadff5..151e9eab85a9 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -14,6 +14,7 @@
 #include <linux/psp-sev.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
+#include <asm/processor.h>
 
 #include "x86.h"
 #include "svm.h"
@@ -1190,6 +1191,69 @@ void sev_hardware_teardown(void)
 	sev_flush_asids();
 }
 
+/*
+ * Pages used by hardware to hold guest encrypted state must be flushed before
+ * returning them to the system.
+ */
+void sev_flush_guest_memory(struct vcpu_svm *svm, void *va, unsigned long len)
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
+		u64 start, stop;
+
+		/* Align start and stop to page boundaries. */
+		start = (u64)va & PAGE_MASK;
+		stop = PAGE_ALIGN((u64)va + len);
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
+		} else {
+			WARN(1, "Address overflow, using WBINVD\n");
+		}
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

