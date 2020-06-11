Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594E21F6F93
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 23:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgFKVs5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 17:48:57 -0400
Received: from mail-eopbgr690069.outbound.protection.outlook.com ([40.107.69.69]:41733
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726435AbgFKVs4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 17:48:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G2t5Cp8BJpkFRDt+G0+uMO6P7ocFPe4iuHdN+9ouNqAaB6uWDGhjVeOA2ilTiq4rSVaGnlAW+cX+ggnIqNCNNSDJf84R0VCOSH9gqZi3FMFjECCB3rA+RqCyvIpcd7WS3rDl7oU4xRR9GZCrCM4Le4TN5sIHB53wKNC46ZZkkE0M2awLNYRD9lhhtZ18LxwkeO5HUNu5PvzWftFNGWtgQNLw/H16xd8OBqMlsjNHm8jpWNScCMDg26dyDphr4GN1aBAf7SR/gNcwuJ06yOmriBn1yAvft5MBU40ldbKKoedwf7wtuB3w2B+2Yby8m3SLwSKH0VjKzqi+dLUuc/Lbtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sudX1fnRIC411gbqP/ihvfYVgigz3PM8gtUgr7wv7Xs=;
 b=mj0O8n843kS+H7cZN9ZrdKMUvxjfYRLwA1QFyqQnXfincUdYM0sri+z15rlWU8inUw6J4VVi/zveX9WYgyh6jhjEmJFZRDPzIG3XpwO97am/jidv50F9T9EJ6KSuSmCRLBN6F/PIam+XNQLfrIMTZ6kl1jah3cFDmTxfaLsgD6OAHQ/4MBLUhRu4nSowJcdMQII1cf2/ov47JGehJnEVqeDWmwLPPmpICh29iSy92Lt2FJIFcsfGDUvhlQ+LpOyXbU/BEh0uEenVlj4th8m3WyypjlMF1AZDqL9Mh0Ns1o80VVUkdU7nxJjW48Byxp44sURSkTLPnlKeUtX5Mi0cdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sudX1fnRIC411gbqP/ihvfYVgigz3PM8gtUgr7wv7Xs=;
 b=L+fzSy20QFcWpgfjIhSzk6xfIkq8Wq0ES2hNZlix8SqiHLcMh8L6p6/hzKGVEV7I6k9MEATN5p4gnHjKhjyxYQuvSSdvpRD/I4DxQidQXsLtqhL1pfvTz4mIqZWPGlacxsZWj/0/6DByX9nKbj0wjiU/HKx8+KXZUYJVhnBT45A=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4589.namprd12.prod.outlook.com (2603:10b6:806:92::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Thu, 11 Jun
 2020 21:48:52 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2%3]) with mapi id 15.20.3088.021; Thu, 11 Jun 2020
 21:48:52 +0000
Subject: [PATCH 3/3] KVM:SVM: Enable INVPCID feature on AMD
From:   Babu Moger <babu.moger@amd.com>
To:     wanpengli@tencent.com, joro@8bytes.org, x86@kernel.org,
        sean.j.christopherson@intel.com, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com, vkuznets@redhat.com,
        tglx@linutronix.de, jmattson@google.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Thu, 11 Jun 2020 16:48:50 -0500
Message-ID: <159191213022.31436.11150808867377936241.stgit@bmoger-ubuntu>
In-Reply-To: <159191202523.31436.11959784252237488867.stgit@bmoger-ubuntu>
References: <159191202523.31436.11959784252237488867.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR2001CA0002.namprd20.prod.outlook.com
 (2603:10b6:4:16::12) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by DM5PR2001CA0002.namprd20.prod.outlook.com (2603:10b6:4:16::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18 via Frontend Transport; Thu, 11 Jun 2020 21:48:51 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0a2ceafe-c592-4952-347f-08d80e513b40
X-MS-TrafficTypeDiagnostic: SA0PR12MB4589:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45898B9C65532F896E54958D95800@SA0PR12MB4589.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0431F981D8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PUv27XDlXbtZK/0I5Mv5PfgeAfnci+ZjySqsmM9wpDQUCzGxl2uNnh4Qe8CVufH0kukHTODqXj0fNEBm/E79YFak7NHk7MLMTxmP9AsHWhVILEeAEG+yqQN+6cZWq3HU6nA9TacCYyVJs0d58CzD14GSMu/nCWiLUwpxINzd8NPBSBqBaHdsHv3qgW7EUApXw+52NVxwdNEX3+A62HO4PzqtcnfJBTToCqR26EbmRBMPS+iuT2UDXjVUZJ9v/5UGnH8GadMjiq2mF9xCan3Qj+Q2wNp73MCQ8w2JMtF9oyfF41wgRa3Ltqps+epRWrQ0a2FEqjWwQiT866kU1pDy4VDEhBS6h7EhXO2sOquKLWnxI8EPHjZiGoJwycojcqpLXFm5bB9ls7jansrVL+/4br+d2dCdWF/2QJ6nrz9az80A/+9J9WKUKyr2FDGakKUSqUTX8TyZKN6UPr+hzmQvGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(7916004)(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(52116002)(33716001)(6486002)(16576012)(8936002)(2906002)(8676002)(16526019)(9686003)(7416002)(186003)(4326008)(316002)(478600001)(966005)(103116003)(44832011)(956004)(5660300002)(83380400001)(26005)(66476007)(66556008)(66946007)(86362001)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: gcWGThW8fSBBNhPdruklzgpSa29ZU2qt0l5UCLJwz82jyNA48ViVMo0OrghuQSrgnQmLTtaQ5y9GpfwI/p4218zLcv99yrI1i30stIDh3MhvlBTeRSsylboomtL4f+ZHEF62lXqCiV1jy80pH0rqyfQ+9Jcv4kUTnbit4kRCuY/k0h7CfSnndy+rK9uHm3wzAjRpWYpMtgugeTwtHrO+1UYzINPqBIpvF2gUbS58MfHfADs1NUHv8XbodD2kUugGH2fWND7JnWDpGd4usd1NfQxmtKiLUldCEGUdQjXlqCQNfyKGcx2CNu/WGnP9Whbo3CNSFSERp2z39/YqNvtn7OdR0z9Fyty2zVwwpEBiXIELo+3K9BX8AGWMPuyaoiSN6qkqB/mjnSq28O9JoLko/oDedj/1AiqkbS++ZFutiNvROE5hDxRM9LhrakqkdlzSp9KIws5XfuvVQnu/Lq41/f9tWQaEiEvfiBxzMlL/D2k=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a2ceafe-c592-4952-347f-08d80e513b40
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2020 21:48:52.3147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S/9W6IlG6EgSkFbJ2fQttZgsep7rw5OF7m+jqVw5825b+8n2N718QyHQ5ZMPsElg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4589
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following intercept is added for INVPCID instruction:
Code    Name            Cause
A2h     VMEXIT_INVPCID  INVPCID instruction

The following bit is added to the VMCB layout control area
to control intercept of INVPCID:
Byte Offset     Bit(s)    Function
14h             2         intercept INVPCID

For the guests with nested page table (NPT) support, the INVPCID
feature works as running it natively. KVM does not need to do any
special handling in this case.

Interceptions are required in the following cases.
1. If the guest tries to disable the feature when the underlying
hardware supports it. In this case hypervisor needs to report #UD.
2. When the guest is running with shadow page table enabled, in
this case the hypervisor needs to handle the tlbflush based on the
type of invpcid instruction type.

AMD documentation for INVPCID feature is available at "AMD64
Architecture Programmer’s Manual Volume 2: System Programming,
Pub. 24593 Rev. 3.34(or later)"

The documentation can be obtained at the links below:
Link: https://www.amd.com/system/files/TechDocs/24593.pdf
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/include/asm/svm.h      |    4 ++++
 arch/x86/include/uapi/asm/svm.h |    2 ++
 arch/x86/kvm/svm/svm.c          |   42 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 62649fba8908..6488094f67fa 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -55,6 +55,10 @@ enum {
 	INTERCEPT_RDPRU,
 };
 
+/* Extended Intercept bits */
+enum {
+	INTERCEPT_INVPCID = 2,
+};
 
 struct __attribute__ ((__packed__)) vmcb_control_area {
 	u32 intercept_cr;
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
index 285e5e1ff518..82d974338f68 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -813,6 +813,11 @@ static __init void svm_set_cpu_caps(void)
 	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
 	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
+
+	/* Enable INVPCID if both PCID and INVPCID enabled */
+	if (boot_cpu_has(X86_FEATURE_PCID) &&
+	    boot_cpu_has(X86_FEATURE_INVPCID))
+		kvm_cpu_cap_set(X86_FEATURE_INVPCID);
 }
 
 static __init int svm_hardware_setup(void)
@@ -1099,6 +1104,17 @@ static void init_vmcb(struct vcpu_svm *svm)
 		clr_intercept(svm, INTERCEPT_PAUSE);
 	}
 
+	/*
+	 * Intercept INVPCID instruction only if shadow page table is
+	 * enabled. Interception is not required with nested page table.
+	 */
+	if (boot_cpu_has(X86_FEATURE_INVPCID)) {
+		if (!npt_enabled)
+			set_extended_intercept(svm, INTERCEPT_INVPCID);
+		else
+			clr_extended_intercept(svm, INTERCEPT_INVPCID);
+	}
+
 	if (kvm_vcpu_apicv_active(&svm->vcpu))
 		avic_init_vmcb(svm);
 
@@ -2715,6 +2731,23 @@ static int mwait_interception(struct vcpu_svm *svm)
 	return nop_interception(svm);
 }
 
+static int invpcid_interception(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	unsigned long type;
+	gva_t gva;
+
+	/*
+	 * For an INVPCID intercept:
+	 * EXITINFO1 provides the linear address of the memory operand.
+	 * EXITINFO2 provides the contents of the register operand.
+	 */
+	type = svm->vmcb->control.exit_info_2;
+	gva = svm->vmcb->control.exit_info_1;
+
+	return kvm_handle_invpcid_types(vcpu,  gva, type);
+}
+
 static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_READ_CR0]			= cr_interception,
 	[SVM_EXIT_READ_CR3]			= cr_interception,
@@ -2777,6 +2810,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_MWAIT]			= mwait_interception,
 	[SVM_EXIT_XSETBV]			= xsetbv_interception,
 	[SVM_EXIT_RDPRU]			= rdpru_interception,
+	[SVM_EXIT_INVPCID]                      = invpcid_interception,
 	[SVM_EXIT_NPF]				= npf_interception,
 	[SVM_EXIT_RSM]                          = rsm_interception,
 	[SVM_EXIT_AVIC_INCOMPLETE_IPI]		= avic_incomplete_ipi_interception,
@@ -3562,6 +3596,14 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 	svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
 			     guest_cpuid_has(&svm->vcpu, X86_FEATURE_NRIPS);
 
+	/*
+	 * Intercept INVPCID instruction if the baremetal has the support
+	 * but the guest doesn't claim the feature.
+	 */
+	if (boot_cpu_has(X86_FEATURE_INVPCID) &&
+	    !guest_cpuid_has(vcpu, X86_FEATURE_INVPCID))
+		set_extended_intercept(svm, INTERCEPT_INVPCID);
+
 	if (!kvm_vcpu_apicv_active(vcpu))
 		return;
 

