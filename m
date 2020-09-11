Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99CB02668D6
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 21:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgIKTcy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 15:32:54 -0400
Received: from mail-dm6nam12on2080.outbound.protection.outlook.com ([40.107.243.80]:23168
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725946AbgIKTa1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 15:30:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l/ygOT/nfeocDkE7V5nETQ+DE/+DtQgt1BrQNdS5ItsK9Yf3dlveoxhI4KdhUqmHR0239enxe7yVii786325VLgNXnH6zYxyb3dZs6b8e0ETb2ANG3sjNvb2J/lNt5eAtxVb9zaXnu/CgZ49hqUpDzWZjo2/2y5fN38ISyOToVSmeUCjnF8PrFtNHGTo96NQ4XcmTEUb/MJQd31fwjjASXHZfp+rXkHJkxQweRYH4Z0u7kpzxLcbtXtejIuBq+ZJz6dzfb9Un9la67cwfIPvuJjivt/E1XX8w+dazU1uPn7iS9Z039aXu2G9T7ur9Dp3dOQlRZLufCBmYDO+yhO3uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OkAXNOlTrAqAiZAxtVv7rpz3P8AgatFSU4lWiD+EO5o=;
 b=FHFxkqscIu6vih5chvqyqM9P/+/DM3lfFhmRILMuLZtGlN34xSlRcxeu8pso5MLmjDw529AEzVEcjK7BIHtcSa3dE0DB/6lu2lpn/BCE8LqFvkI9KSKMxQb6T66NCWzTv716NGlq64R7CpQeK8XV4jAeYDTTUg/6oAP1Xpom2SmB6a+WzCCR/Prh5GXkv71cqlCN5Az9Nv4a9VzxERJgrkfU35WwNAD65wUhsoPZAX8L9j4w9XZLJuKMlRsmd004iHLMxI8weBDptBeBoj79lMSrGnofthQgCmFq0q6k/HbYxw9otR58oHpejH7HiP7idqzJtCyPGPQnDVHmHt/Izg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OkAXNOlTrAqAiZAxtVv7rpz3P8AgatFSU4lWiD+EO5o=;
 b=URM/CrWGegNNWYTOnoTnliBmIQ5/38rt5wy5XZfrMhNql8SH5977xiBn1lPYZhKdyKelAAmsRNndNvWCUTd+7+Qq59K96Upw/MDZnHDifgBovMISzzWypeFrqEVKp70k1IQ1z4o2MPao+I13QqoMsjtIuYmrI+AwjeYWdWI5yeM=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4543.namprd12.prod.outlook.com (2603:10b6:806:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Fri, 11 Sep
 2020 19:29:21 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3370.017; Fri, 11 Sep 2020
 19:29:21 +0000
Subject: [PATCH v6 12/12] KVM:SVM: Enable INVPCID feature on AMD
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Date:   Fri, 11 Sep 2020 14:29:19 -0500
Message-ID: <159985255929.11252.17346684135277453258.stgit@bmoger-ubuntu>
In-Reply-To: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR11CA0015.namprd11.prod.outlook.com
 (2603:10b6:3:115::25) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by DM5PR11CA0015.namprd11.prod.outlook.com (2603:10b6:3:115::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Fri, 11 Sep 2020 19:29:20 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 09d7cd9f-eb82-4c84-a658-08d85688fbbc
X-MS-TrafficTypeDiagnostic: SA0PR12MB4543:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB454305C98A29BAEE0B54E44995240@SA0PR12MB4543.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3acOUmEatGSTHR51j9KsduzN0bk8ttazp3uk1mlM/xL8ld7Av5FNjaQD5iEu/ipiuZoq7NlxG9VnDwKlssglnOOi3IWJ58rN9lCdHtEKnVDVd83QLb+IIRXQgFACcgW6IiDdIvjEd9gpS34FgvrIgauCjj+37GVAFSVWpx1ZHzhhSBZKV2E6YIjz0+lap9cUNu55oEA89FxX3JQEWXqWQm3/vHUS0ao0zp1mQFAmRl8EXHI6UEIz+CTWFvKu2rLHqUGtc9uzFsVOi30GqEK5Z+R1PuuIYG3iWUFaBs51DiSVbjBRSFxP6Uc2Ax/HKveXbFjv4B2VG0IifPcasQvaWR/rZtLLbBwZu6MSw4+OEAgh6bElmUgNr/YukkJ7CCFqoKPsQXPwiMqOjQF4pxofMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(2906002)(956004)(66946007)(66476007)(103116003)(8676002)(66556008)(52116002)(5660300002)(7416002)(9686003)(4326008)(966005)(8936002)(44832011)(186003)(16526019)(86362001)(33716001)(16576012)(6486002)(316002)(478600001)(26005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ftcRtVNGPKezWI4cLqPQq3NBB8sj6GkOuuUCVYOxln8baZlHCx02xDNQYgxUtR28pG/G4eLvaxZHJvIlbokY1xXpfjG8x5GXJAbl5wJWv/XowoFZSw+X2QyODMX37QnMKs0MsA/b5QM0kln09I2ew4qbJe5IFZswQrbr28FG8uqGTa8Pa+6KttvFniI+5GpJb5HyGK00f03/6+AxRfJ4uTCe7apSLe8e+NI6Y7o3d8AIIpuMcOPgrzx5Ne7p9rRk50noj3hQ8ePPV6395mnUCoKF6E9L6vRePsiAkTJYUPFAi2It/4n+a2sjEzyW9ta0PmIf+HQhs6BIofYHBwIYuVcbz1sS8AzR6pIhisXefWzUhWpCUGMpEkxLSRmiEpx/vk0IzoSyPEf1RB3+RWchtf10xkkhyz0YTWXH3WkNXNrtgMiKSaLaidQ23WQy4MNvpp+WAknV9gpTeJn3u1iNSAl/RNYH8RgUNUPCJl0xa/jUt1L06hjqfzvWihz9v/j5RO7698VktOs/K1XHr4RF74/l9c+muDqZxgD//JryE0jmuNJMObabQKUr01+cFg5w7OkmzBGbHwLRsyEpKAd6kgHMDMEOPoORHx94wNeE7dbFL4cDFFOetEY1lS4w13X+/WLC3NjvGK/bEIqGuX3xLw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09d7cd9f-eb82-4c84-a658-08d85688fbbc
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2020 19:29:21.7407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KUGa6/K+8lw4oRujfMvwPndjhN6H4foF+C4SnwYCiTXRJRUqZT+vARLIL7BuIgo/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4543
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following intercept bit has been added to support VMEXIT
for INVPCID instruction:
Code    Name            Cause
A2h     VMEXIT_INVPCID  INVPCID instruction

The following bit has been added to the VMCB layout control area
to control intercept of INVPCID:
Byte Offset     Bit(s)    Function
14h             2         intercept INVPCID

Enable the interceptions when the the guest is running with shadow
page table enabled and handle the tlbflush based on the invpcid
instruction type.

For the guests with nested page table (NPT) support, the INVPCID
feature works as running it natively. KVM does not need to do any
special handling in this case.

AMD documentation for INVPCID feature is available at "AMD64
Architecture Programmer’s Manual Volume 2: System Programming,
Pub. 24593 Rev. 3.34(or later)"

The documentation can be obtained at the links below:
Link: https://www.amd.com/system/files/TechDocs/24593.pdf
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/uapi/asm/svm.h |    2 ++
 arch/x86/kvm/svm/svm.c          |   51 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 2e8a30f06c74..522d42dfc28c 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -76,6 +76,7 @@
 #define SVM_EXIT_MWAIT_COND    0x08c
 #define SVM_EXIT_XSETBV        0x08d
 #define SVM_EXIT_RDPRU         0x08e
+#define SVM_EXIT_INVPCID       0x0a2
 #define SVM_EXIT_NPF           0x400
 #define SVM_EXIT_AVIC_INCOMPLETE_IPI		0x401
 #define SVM_EXIT_AVIC_UNACCELERATED_ACCESS	0x402
@@ -171,6 +172,7 @@
 	{ SVM_EXIT_MONITOR,     "monitor" }, \
 	{ SVM_EXIT_MWAIT,       "mwait" }, \
 	{ SVM_EXIT_XSETBV,      "xsetbv" }, \
+	{ SVM_EXIT_INVPCID,     "invpcid" }, \
 	{ SVM_EXIT_NPF,         "npf" }, \
 	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"avic_incomplete_ipi" }, \
 	{ SVM_EXIT_AVIC_UNACCELERATED_ACCESS,   "avic_unaccelerated_access" }, \
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 96617b61e531..5c6b8d0f7628 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -813,6 +813,9 @@ static __init void svm_set_cpu_caps(void)
 	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
 	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
+
+	/* Enable INVPCID feature */
+	kvm_cpu_cap_check_and_set(X86_FEATURE_INVPCID);
 }
 
 static __init int svm_hardware_setup(void)
@@ -985,6 +988,21 @@ static u64 svm_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 	return svm->vmcb->control.tsc_offset;
 }
 
+static void svm_check_invpcid(struct vcpu_svm *svm)
+{
+	/*
+	 * Intercept INVPCID instruction only if shadow page table is
+	 * enabled. Interception is not required with nested page table
+	 * enabled.
+	 */
+	if (kvm_cpu_cap_has(X86_FEATURE_INVPCID)) {
+		if (!npt_enabled)
+			svm_set_intercept(svm, INTERCEPT_INVPCID);
+		else
+			svm_clr_intercept(svm, INTERCEPT_INVPCID);
+	}
+}
+
 static void init_vmcb(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -1114,6 +1132,8 @@ static void init_vmcb(struct vcpu_svm *svm)
 		svm_clr_intercept(svm, INTERCEPT_PAUSE);
 	}
 
+	svm_check_invpcid(svm);
+
 	if (kvm_vcpu_apicv_active(&svm->vcpu))
 		avic_init_vmcb(svm);
 
@@ -2730,6 +2750,33 @@ static int mwait_interception(struct vcpu_svm *svm)
 	return nop_interception(svm);
 }
 
+static int invpcid_interception(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	unsigned long type;
+	gva_t gva;
+
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_INVPCID)) {
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return 1;
+	}
+
+	/*
+	 * For an INVPCID intercept:
+	 * EXITINFO1 provides the linear address of the memory operand.
+	 * EXITINFO2 provides the contents of the register operand.
+	 */
+	type = svm->vmcb->control.exit_info_2;
+	gva = svm->vmcb->control.exit_info_1;
+
+	if (type > 3) {
+		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
+
+	return kvm_handle_invpcid(vcpu, type, gva);
+}
+
 static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_READ_CR0]			= cr_interception,
 	[SVM_EXIT_READ_CR3]			= cr_interception,
@@ -2792,6 +2839,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_MWAIT]			= mwait_interception,
 	[SVM_EXIT_XSETBV]			= xsetbv_interception,
 	[SVM_EXIT_RDPRU]			= rdpru_interception,
+	[SVM_EXIT_INVPCID]                      = invpcid_interception,
 	[SVM_EXIT_NPF]				= npf_interception,
 	[SVM_EXIT_RSM]                          = rsm_interception,
 	[SVM_EXIT_AVIC_INCOMPLETE_IPI]		= avic_incomplete_ipi_interception,
@@ -3622,6 +3670,9 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
 			     guest_cpuid_has(&svm->vcpu, X86_FEATURE_NRIPS);
 
+	/* Check again if INVPCID interception if required */
+	svm_check_invpcid(svm);
+
 	if (!kvm_vcpu_apicv_active(vcpu))
 		return;
 

