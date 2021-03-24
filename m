Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90401347EBB
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237247AbhCXRF4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:05:56 -0400
Received: from mail-dm6nam11on2071.outbound.protection.outlook.com ([40.107.223.71]:41848
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237059AbhCXRFL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:05:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GkK4+GHpsGpSDv+KiHr6i/8gsscT/hwsowvOQqxMB0TcMDXWYFeynyl0MDX2YSxB1yhgwaxQeJJD5mABJ1se8alqPafremk7hJ9O9cEyusgPi5KJkaP1AwhTq4qNtDwgBXUsTnZ4RqnOvSHOtXxgQtVKI0U3a/uuiSGly65hxTQ4BpN4m0+FIFMdx4t0h2fz4pi78UQkkwzkLXeKhNTXOJzpr4ws2NpscPCZOj97HxYaieLHBWndk6Vs69/aET3bGON/+QMAklOnE9eVo+nWcQkQSzKHPSl19YG+1nQuopX7Y7GSMNkoDl7SoqI+oKnv20bV7tjNnqdV+eZeqK96XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s3wJJvnEJeQlSpr5Sp2HUBdeSopoZrJJ6wWWbsSJSnI=;
 b=Q8RPCUC6kGvr3WwzaNW3T718vm86dpD3olYPPxZn23RJ4k3khbTvj3wUs6h9WENN549jij+bacgiS5razsLwI7PvnLkZM3j4fI9WXXW59srVLlLtRGg1I0AcmdUMWa+2Zglo8iZl1whOUNFN3aEMxtBPcfxa2dFkyWRl0vpgZw0g5E0vSA43DrV0vIJfU6AEUvqciqNxIBHM/OAlWbRRPtGnjq0+vF2fAbdyCxGuyzyVgAM4ZLrsgX2/hPzN85dG6Q6lXWo4kaI1jqJu0H7E9ZVX44cnxV6/o7FwJrnmQdEOiDB6OAWz359//MQELnWBdwGr4yg10qPvHmbELkoS3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s3wJJvnEJeQlSpr5Sp2HUBdeSopoZrJJ6wWWbsSJSnI=;
 b=Fr87ZSDkVoWe0YFXxX4tZrsfpWxPtZjo3TJHEkw3xYYkH0ym39WVpmfVyoA3svGv5xKBKtOiiBMLfZKAxyQYX+5dq7yhgdvNwfFdMoZJV81VeLmd0qbap6rzglhq1XrWrY7MlD64C08UqlMFzNDzKK0hOFgPtT/YVEjGDvtQw1I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4382.namprd12.prod.outlook.com (2603:10b6:806:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 17:05:08 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:05:08 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     ak@linux.intel.com, herbert@gondor.apana.org.au,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [RFC Part2 PATCH 21/30] KVM: X86: Add kvm_x86_ops to get the max page level for the TDP
Date:   Wed, 24 Mar 2021 12:04:27 -0500
Message-Id: <20210324170436.31843-22-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324170436.31843-1-brijesh.singh@amd.com>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0210.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:05:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8457ae41-7df8-470b-49aa-08d8eee6fa42
X-MS-TrafficTypeDiagnostic: SA0PR12MB4382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB43822B49B4AA197781BA5B71E5639@SA0PR12MB4382.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iCN5KTEsCVbOA3rsJ6xevgAecAgiHjHI2UW3lNoSguzA2Q18v5z9wkh9wcOrTSZn9IT/gsWaCJjg5lKIT1hHxwbL7Tgpf5wwa1TNvKh6Yor+zZrPId4DkQHOKPz7pEocqHRwZMniK79C0fFTfj5Dw2eNJJduxg/bRmhvAK3H8Af2sM58MwDm2dt4GHEJV9pyHu5APCT2d5WAcLjB7RfIWGpLbtL3nL+lpzsmAc8pjzdq1NSJDIBzd64sJYUshF+q4sFAHZSG9dyNOp8dsUCtR+JvqRiVfq3LFzvGcvLighM0HRc+YQf2+7UqmB8o+27IQC6j+BV5OyDcMIXA3OLxn1b5B2PnscPiBfivLRfCz+iqR1IMGPoWWn1TZHItSSr9Vbs+88F3/jJYFyp86LlS6fr3CvYfRuOfZ49l/7yTTI/OeIJZOeoagL69YFtEycvR1e8LFaWjWeW6QGWVy0XztfP1jaI4OT/OBRxYJA2DORI0w17oPbOBq5slTWZoOgH0UuVOsWZGXTraiRlc0zToq7Ichwzn/MfQkKqF6g0pA/ArZPA/QBWT/fEd54Sc9PZYAxnyS/RKVfC1/JDfObBLREG84NmUN4m21MxwcjlF9d1O6pytl8VKVIBkEV7AJm/l8z8H/i4Di+y9hgFbAiu3m7DV7jqjeWtstIZzd0aF8xo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(6666004)(44832011)(66946007)(1076003)(66556008)(66476007)(956004)(36756003)(478600001)(2616005)(83380400001)(8676002)(2906002)(8936002)(26005)(86362001)(5660300002)(52116002)(7696005)(38100700001)(4326008)(54906003)(7416002)(16526019)(6486002)(316002)(186003)(15583001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8gL3BW6+BIc7Lt4KTmDeT625VyERiyYuURTOwC0h1bKlMCPEnsFfNyAvJphh?=
 =?us-ascii?Q?/dV48D4n7M6inc7oml131wxNdC/ux/RJ6VFROBDgHrSTi9MeXgOM5m5AvVky?=
 =?us-ascii?Q?5bnVS1/L3S7Cutu1RfRyl9mSYSBwaOtdfBfcfTo/5UULo1zVP4BVqy/6pLsh?=
 =?us-ascii?Q?lOgoXrPeM5yyChbUHpgiIeqnOzSAsf/X8FIC4Sty5b9Zd91lKM4Nf1/504g1?=
 =?us-ascii?Q?U9kBvAOUEg5+bPW33XPsempQEtjxZj/RkXs21wiVnJREPfR+y5vmtuCUdWW6?=
 =?us-ascii?Q?s5hYEaq6D8YOI5NYF7+TE7Zo+UisAZAev/fnYmY/IXqH5Nxl/dhf7lHYmylM?=
 =?us-ascii?Q?Ees6wRmDLGYPbawO4g+xnLTDR3W0+3W6mMvWGLUir41XErd6KatplbY0oezl?=
 =?us-ascii?Q?aVnw0VEVBD5qfDMNI+lEc1fAhmcXGyZ3EBq/3mj0quV7RG/D6PE1I+JrCtsV?=
 =?us-ascii?Q?Om/KAiBrTSkdD8iOYlN5l5sQjGSUZ1HeSivdbASykO+0tRs07wD+CnavqdYl?=
 =?us-ascii?Q?P/riZ/EGCjsxVsm8kGJz01TwIh6zzJf+y3CA3aklPYJL2ADs4n0zAIu5TKYA?=
 =?us-ascii?Q?xEcEKgwUVhsPkAOAPYXeqAO9hhzqsIdDR1Pue3LVyQjBB6pjnEzhPN+clfkA?=
 =?us-ascii?Q?52ITuWMVlouA+7pTWBlotql56Jm4WgmdgCV7/RJSI0q7vjjVJjtaqsaWM10E?=
 =?us-ascii?Q?6pYLLWs1po8fZTrxaHm+kk93ANryD4rFDEJR21kEJ3sD7jz/jREdYpbxHaAj?=
 =?us-ascii?Q?0xU25de7qO6nnu/hZokqcygZsi0xf1sC61Mgj6av7HNUqhOXR7BD65+lhXwQ?=
 =?us-ascii?Q?Pbk+LZ93K0cWFKmQ5WQW97aVeRGkfkQ1IwaOiHNSGMXl77DQlCFJ6kixtbhf?=
 =?us-ascii?Q?8FfSNy7onFC6cyUU/r6dUWY6f8sKoKKK6FyGISpxfCeCckb/gR7ceJ3lODgF?=
 =?us-ascii?Q?m9nfLX1IkKSGY7/ORxBmMbJTRwg+v4/YN3guVSHImCBdB2JjSvAwCtm+KpLE?=
 =?us-ascii?Q?8Xp/+UhXaNxqLnQvYcHvuv0rqxqGlK+WkgiOSfx9eDNTsz3IaIoI4tvZW3It?=
 =?us-ascii?Q?yIdVt7UXpgIJvuFX8Tze1ejFso2P90jxw4QbpiAyyVxRZdcNId12s2IXGHBb?=
 =?us-ascii?Q?5piO5+rqmuYNXl/IhZAdwA/CgBzilNEDl8OYH4nR6qpZApYFIhb9SeKSHXgJ?=
 =?us-ascii?Q?ysPtdvmYmbxnKFGjpaBYmFEy8wCrbLeBJGJXoWmHICBi9oD72rJDLrpUxRpv?=
 =?us-ascii?Q?KMRXisTfFnFaFWB5z3Ah+Q0rMPxi7pfcllNc+vHirAGj9vZ3yGab2SApthhA?=
 =?us-ascii?Q?uBeCPyTBpoQPgR4Vd0erBMvl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8457ae41-7df8-470b-49aa-08d8eee6fa42
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:05:08.3291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9+Q3ukwSFat1he0MkMpMXesJcxH2HUYRsO4e+Q6zok3yZ5mKgvFP9nNm/4S/RsaRiFBNgFrYz6WwPrKDYWp3yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4382
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running an SEV-SNP VM, the sPA used to index the RMP entry is
obtained through the TDP translation (gva->gpa->spa). The TDP page
level is checked against the page level programmed in the RMP entry.
If the page level does not match, then it will cause a nested page
fault with the RMP bit set to indicate the RMP violation.

To resolve the fault, we must match the page levels between the TDP
and RMP entry. Add a new kvm_x86_op (get_tdp_max_page_level) that
can be used to query the current the RMP page size. The page fault
handler will call the architecture code to get the maximum allowed
page level for the GPA and limit the TDP page level.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu/mmu.c          |  6 ++++--
 arch/x86/kvm/svm/sev.c          | 20 ++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |  1 +
 arch/x86/kvm/svm/svm.h          |  1 +
 arch/x86/kvm/vmx/vmx.c          |  8 ++++++++
 6 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ccd5f8090ff6..93dc4f232964 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1302,6 +1302,7 @@ struct kvm_x86_ops {
 
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
+	int (*get_tdp_max_page_level)(struct kvm_vcpu *vcpu, gpa_t gpa, int max_level);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6d16481aa29d..e55df7b4e297 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3747,11 +3747,13 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa,
 				u32 error_code, bool prefault)
 {
+	int max_level = kvm_x86_ops.get_tdp_max_page_level(vcpu, gpa, PG_LEVEL_2M);
+
 	pgprintk("%s: gva %lx error %x\n", __func__, gpa, error_code);
 
 	/* This path builds a PAE pagetable, we can map 2mb pages at maximum. */
 	return direct_page_fault(vcpu, gpa & PAGE_MASK, error_code, prefault,
-				 PG_LEVEL_2M, false);
+				 max_level, false);
 }
 
 int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
@@ -3792,7 +3794,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 {
 	int max_level;
 
-	for (max_level = KVM_MAX_HUGEPAGE_LEVEL;
+	for (max_level = kvm_x86_ops.get_tdp_max_page_level(vcpu, gpa, KVM_MAX_HUGEPAGE_LEVEL);
 	     max_level > PG_LEVEL_4K;
 	     max_level--) {
 		int page_num = KVM_PAGES_PER_HPAGE(max_level);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 810fd2b8a9ff..e66be4d305b9 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2670,3 +2670,23 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
 
 	return pfn_to_page(pfn);
 }
+
+int sev_get_tdp_max_page_level(struct kvm_vcpu *vcpu, gpa_t gpa, int max_level)
+{
+	rmpentry_t *e;
+	kvm_pfn_t pfn;
+	int level;
+
+	if (!sev_snp_guest(vcpu->kvm))
+		return max_level;
+
+	pfn = gfn_to_pfn(vcpu->kvm, gpa_to_gfn(gpa));
+	if (is_error_noslot_pfn(pfn))
+		return max_level;
+
+	e = lookup_page_in_rmptable(pfn_to_page(pfn), &level);
+	if (unlikely(!e))
+		return max_level;
+
+	return min_t(uint32_t, level, max_level);
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 72fc1bd8737c..73259a3564eb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4563,6 +4563,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
+	.get_tdp_max_page_level = sev_get_tdp_max_page_level,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 97efdca498ed..9b095f8fc0cf 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -606,6 +606,7 @@ void sev_es_vcpu_put(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 void sev_snp_init_vmcb(struct vcpu_svm *svm);
+int sev_get_tdp_max_page_level(struct kvm_vcpu *vcpu, gpa_t gpa, int max_level);
 
 /* vmenter.S */
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index eb69fef57485..ca0c1c1fbf92 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7587,6 +7587,12 @@ static int vmx_cpu_dirty_log_size(void)
 	return enable_pml ? PML_ENTITY_NUM : 0;
 }
 
+
+static int vmx_get_tdp_max_page_level(struct kvm_vcpu *vcpu, gpa_t gpa, int max_level)
+{
+	return max_level;
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.hardware_unsetup = hardware_unsetup,
 
@@ -7720,6 +7726,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.cpu_dirty_log_size = vmx_cpu_dirty_log_size,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+
+	.get_tdp_max_page_level = vmx_get_tdp_max_page_level,
 };
 
 static __init int hardware_setup(void)
-- 
2.17.1

