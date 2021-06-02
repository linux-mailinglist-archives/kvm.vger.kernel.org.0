Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32C0398C5B
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbhFBORy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:17:54 -0400
Received: from mail-bn8nam11on2066.outbound.protection.outlook.com ([40.107.236.66]:15585
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231713AbhFBOPv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:15:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kq2cpsQolvTBKrwRP0PhrwYCfMFwJIjRNao0OrODSJZ4MIHk3l6QiNTpymoyaWPk9b8C/xw0RUXcbWlxzOLo14qjQE2KD6syN9x1z/X/5UeRWcthYXFfRCB1YOaQUkpsD9lvBUTicY8uU/OgU7hmi+xsX7zRQreRFz17ONeXoHg3Eo/xTf1D2c34erfPtcGwduC5UrLRq8jJqHs16+mxovzbvPQyDwoPgXh7V1qqEIWIKFiq+R/l9nyY5979XyxrJwtz9tzV3YBv4hTAM+st0Ycsj9GPGTCrj55GF6tfX3OHNAgxF20UMzQ92LYDXIfxoxjX4Y4r7C4eNLn70BSf5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZXWvmF41owDiMt6To+AsmIAEf1i35/5Hhllt7y5Df9I=;
 b=l4TzTCLL8KqLrHnWe/IGiwihbES5WD5+qJWkmoYg6zvE2st7J4uTvVS7nHM/PmD6kSlJusjJ8ROq3InFWebtDBn+czeatKtQS8Xk8Oy0bp/4cdeYFbtyptQwC2o1yYTeyfbuqApwoT+/8+TQz6tCVfCKxgChIgvLItotopaKR1VkoJiv5zo4YgSnlSSmD77Ch52Ct/Hhoxqr5FqajGojpyFY4NfnihUZJ/gOrqKm+lwJw9cmvwtjuYWWmyUS+iY91r9JlHgnUgiHsuTuM8jYuPxuSCwHghYDxGf9vdtJ3pUKE2DEXwZz+hBzftxwCTABWaGIj22XUEJWQx+WbrA0EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZXWvmF41owDiMt6To+AsmIAEf1i35/5Hhllt7y5Df9I=;
 b=KXF2d5E0S+ilm5h2Vi7U6kNMVm2zrwq8m+835/2Rv+AvxORCPz7YGsQQR5isukbL68+pdlQAkPDBSiXzrjvP3XbwkxYtHUvNO8KOaRc+6NJqajITlIa1a7WrI589lVubb2fq+h4klQtv2UUb8647R43Jk2J3FlvZGQBvu3dvDlE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2368.namprd12.prod.outlook.com (2603:10b6:802:32::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 14:11:50 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:11:49 +0000
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
        David Rientjes <rientjes@google.com>, tony.luck@intel.com,
        npmccallum@redhat.com, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v3 17/37] KVM: SVM: make AVIC backing, VMSA and VMCB memory allocation SNP safe
Date:   Wed,  2 Jun 2021 09:10:37 -0500
Message-Id: <20210602141057.27107-18-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210602141057.27107-1-brijesh.singh@amd.com>
References: <20210602141057.27107-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:806:d0::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:11:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0feb9bc1-80db-456f-b5fe-08d925d05d1f
X-MS-TrafficTypeDiagnostic: SN1PR12MB2368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2368BE1E2368A605E6FA42DAE53D9@SN1PR12MB2368.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7DITOTE3nnQdwdszN0TNWkm6M6g0AUbJ4T6K5oU9wWzlPBwf+uMrNy2Wr6Rg7ujr58uR9b0YK8cNQLchxjQYi7LBE99pz7kOnzGJ1hJj/MxFJBJrWoPP9uUa+6RQ15y6Qz35kY4VzBJMpo+WMyPrpGG8fbqFpr+zXQpHvJhxXfY1UXcsRnxWw7/BwySy9M2Cka0H/X5kUSua1S4uTiOU+qDJDvz2f+lWCxa8hYv7vDhZVt8lG+TcnGy3wle8M1ybPHpbsYxtoiMX62rM1cggzmf9pwzMCCyTOv3k5ja3T7UEaG+P/NsRBZqRJx+vUOA/C7T9LRnPeIYx0YX94jh8WxLvZCkR2oVipFB6+8UnLkCgYabTXE145evR52K/otJThOjYBXyxru/li1agU1dzbPP3kcQE5jovVEDvYRT6o27xWbhNmT8xYLuubSWO/ILwpthCRArGd8gfopFCKJDx0VBxYVCx2e3yTtu0snSqjlc/v1lJcy/DRo4KLr2FBwjwOiLRknmLDqSL+HwqTMyxCJ94g3nAaDawEgBZipzFZezbazp7luF4DlNSLa9JdewkySE0CwbUfZK2ydu7B9VjYbaeU08ermlVDnDn1C1QcNhaz7fOAMxDSzJIGK+PYO0w1IX4Qt0vB7jPvG90WVYgKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(5660300002)(86362001)(6486002)(52116002)(7696005)(44832011)(38350700002)(38100700002)(956004)(2616005)(1076003)(8676002)(7416002)(8936002)(478600001)(186003)(316002)(4326008)(16526019)(26005)(66556008)(66476007)(2906002)(36756003)(54906003)(83380400001)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?0RMpvbeFhrIseM8VC391Z/WRdeZkeNWxvQIZhI36Dr4TK6QuV4NbUn5NLgpD?=
 =?us-ascii?Q?805UqBoQLtMOIE9A7/uFOZL/rUyEVmt6/XFfpIOKUFvJYo6p1ZUiX9BOMeZz?=
 =?us-ascii?Q?LSD3u/QAfJQZV3nJ9nospUUzKQGy0/lZ7Jgf9G81zZYbyiKIY5rdNxbduu6x?=
 =?us-ascii?Q?HArCB/PXz33gQObeI/IxIGdkKmsn8U21IUUKZFlV0APbgD2s+o6LJHRMix0Z?=
 =?us-ascii?Q?bLsPIO8EZhRUba4LD8xeDsr8xdt5H1njpMcDD49I11naV2uywDmv3mBV0UAn?=
 =?us-ascii?Q?UcMB5aePIM8rNRJ6PAMmmF2LpAyw1zep4eee1AZbCZvtEcgTQVtZdrYKMpyx?=
 =?us-ascii?Q?e0ZIrMJVdpqDT5UmsET3H+4B4tG0JVCPmi28UGfGGurZ+CpH4L0mfXFao84a?=
 =?us-ascii?Q?w4zTFi1U1AM3fo/xCoPluQ5fU0/2JWbTRV89s0hJ3j1S+WCJBYAVcGngQRiR?=
 =?us-ascii?Q?Tbu0T0jiLNNcqdrbo6WRhMgdzzHjdDa6F4n25/D5sU72E5TfMURMPR5M+UvY?=
 =?us-ascii?Q?cKsxFJ9Fy9uWJlx7N+aZT54sFB/vkYbi49jWkC2j0NfVWdgz7QppM3weM3M3?=
 =?us-ascii?Q?Op/lBIdaT70rrbJvpOKoy4yoy6ARS2WuvRfJXOWtyDid+6UBiDy+Vv4xxKBC?=
 =?us-ascii?Q?jfM7tPbT5/OSrjEMFreR067OUrpIRJCI0G2QssMXyddLM5aMUEbTi/fcMqoL?=
 =?us-ascii?Q?tRsHxBJV/Rfa8+HuKUQ615RAJQoXN3KZpfIHz7pdwxmu/YV0ke5bRYmPeKgD?=
 =?us-ascii?Q?CL1VSjEFUQr262cYlcKhwYyNn0B5qPMXxWij7JM0Iv9jlJltKpe3lXY6rTGZ?=
 =?us-ascii?Q?ri2bc//hqkY/J3ksDVR9Aqcn8EWN/KFe3mjf0+spsuEiXuD32rHRd2128Edq?=
 =?us-ascii?Q?S/+y3Yso5FyfdBWTmhK/8x7w4aC1GWN5W6CsOM2qnFc6rttx5JHmoW8UY90e?=
 =?us-ascii?Q?bME8G9/Tf60FWouzpToZ4Hq1w4lNF94mY7UEGly6rPKX0qRfjkN5IdagH/H+?=
 =?us-ascii?Q?xR7Nr1A7rE1ALSOZlhiR+5xopx72TIe23OqgQR1L80Yqcho9F+YmWQXYIGHg?=
 =?us-ascii?Q?TJmCBY4Kdfz9xfmgF2ZYZ03EsgHXv3INDIMNH2sr1Et7Z+1JqNiZsWMSZHN4?=
 =?us-ascii?Q?DmtTMQYyEohoH50lKj708h5O/jtLHOmplCXPuhliFCyu0z+HW1BCxuQ/pSuU?=
 =?us-ascii?Q?+qri9/P/iGOBwFNF8DHiyVbAQ/uor5RnLNTFB4zyGC9pqfBH+K7caFpADNny?=
 =?us-ascii?Q?VMirMoCs9zLdvjSYumDYgngsMdBxVxk32sL646gbmvPJ7fVtfrzDP5PHg7Aa?=
 =?us-ascii?Q?bYwQgo35+/v1n6oDLubSiTth?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0feb9bc1-80db-456f-b5fe-08d925d05d1f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:11:49.7499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: suaUDRvA7At25DUzPln6YYamWfk6dVpesAALGE0cn7k/t5D8erwWrybZqio0K339d7i0Sqv1SDkLwkw3Jjxxkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2368
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When SEV-SNP is globally enabled on a system, the VMRUN instruction
performs additional security checks on AVIC backing, VMSA, and VMCB page.
On a successful VMRUN, these pages are marked "in-use" by the
hardware in the RMP entry, and any attempt to modify the RMP entry for
these pages will result in page-fault (RMP violation check).

While performing the RMP check, hardware will try to create a 2MB TLB
entry for the large page accesses. When it does this, it first reads
the RMP for the base of 2MB region and verifies that all this memory is
safe. If AVIC backing, VMSA, and VMCB memory happen to be the base of
2MB region, then RMP check will fail because of the "in-use" marking for
the base entry of this 2MB region.

e.g.

1. A VMCB was allocated on 2MB-aligned address.
2. The VMRUN instruction marks this RMP entry as "in-use".
3. Another process allocated some other page of memory that happened to be
   within the same 2MB region.
4. That process tried to write its page using physmap.

If the physmap entry in step #4 uses a large (1G/2M) page, then the
hardware will attempt to create a 2M TLB entry. The hardware will find
that the "in-use" bit is set in the RMP entry (because it was a
VMCB page) and will cause an RMP violation check.

See APM2 section 15.36.12 for more information on VMRUN checks when
SEV-SNP is globally active.

A generic allocator can return a page which are 2M aligned and will not
be safe to be used when SEV-SNP is globally enabled. Add a
snp_safe_alloc_page() helper that can be used for allocating the
SNP safe memory. The helper allocated 2 pages and splits them into order-1
allocation. It frees one page and keeps one of the page which is not
2M aligned.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/lapic.c            |  5 ++++-
 arch/x86/kvm/svm/sev.c          | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          | 16 ++++++++++++++--
 arch/x86/kvm/svm/svm.h          |  1 +
 5 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 55efbacfc244..188110ab2c02 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1383,6 +1383,7 @@ struct kvm_x86_ops {
 	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
 
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
+	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index c0ebef560bd1..d4c77f66d7d5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2441,7 +2441,10 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 
 	vcpu->arch.apic = apic;
 
-	apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	if (kvm_x86_ops.alloc_apic_backing_page)
+		apic->regs = kvm_x86_ops.alloc_apic_backing_page(vcpu);
+	else
+		apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!apic->regs) {
 		printk(KERN_ERR "malloc apic regs error for vcpu %x\n",
 		       vcpu->vcpu_id);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b8505710c36b..411ed72f63af 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2692,3 +2692,30 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
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
+	p = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO, 1);
+	if (!p)
+		return NULL;
+
+	/* split the page order */
+	split_page(p, 1);
+
+	/* Find a non-2M aligned page */
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
index 2acf187a3100..a7adf6ca1713 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1336,7 +1336,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	svm = to_svm(vcpu);
 
 	err = -ENOMEM;
-	vmcb01_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	vmcb01_page = snp_safe_alloc_page(vcpu);
 	if (!vmcb01_page)
 		goto out;
 
@@ -1345,7 +1345,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 		 * SEV-ES guests require a separate VMSA page used to contain
 		 * the encrypted register state of the guest.
 		 */
-		vmsa_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		vmsa_page = snp_safe_alloc_page(vcpu);
 		if (!vmsa_page)
 			goto error_free_vmcb_page;
 
@@ -4439,6 +4439,16 @@ static int svm_vm_init(struct kvm *kvm)
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
@@ -4564,6 +4574,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.complete_emulated_msr = svm_complete_emulated_msr,
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
+
+	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5f874168551b..1175edb02d33 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -554,6 +554,7 @@ void sev_es_create_vcpu(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
+struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 
 /* vmenter.S */
 
-- 
2.17.1

