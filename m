Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95831FC154
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 00:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgFPWD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 18:03:59 -0400
Received: from mail-mw2nam12on2053.outbound.protection.outlook.com ([40.107.244.53]:32786
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726486AbgFPWD5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 18:03:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bF2Z2SmEU0iWiyIhr9+RYQqoQVWlnX5i8r4OUFOl7/ssQl9k3LhTgJ/p34Ij36dP/QzM56HgbhDbPlfxgCCGerroVONvXGkNJy5DzugYKy/zFWp3KJC511zv6dRaddcafKk91lMjOJuCDRwr4hkypV/DkY8rZNLn6gJnrMghsme2kPp0M6dlqb70hDg5Mb/yQ1Ti57qEV0FY9amw0sfeykgq0J01rG9WDbJMnLMxa340v9Enq4LKBa9SJ2zV0elg6dGd8NJDq5ImzJ320t7Zvn8awc+wZ3PWMd6O7/cGkidkugawtINLRAwE+mUr4MdIZ555UOPh8LHryg584J+icw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cBcsGm0vC7Z2IO3DTw8IOPKKrr9TX7ShDPyM1NY1mTA=;
 b=Qud/jcrCxjnlQ7P3X6+NlWPZSmHPM7zJnQtjl9KThiVPR4U/fIYYDmBzbrNmbbDslXraunZg2T/Ax2oNjK47rvx8UqCmcXsb35uagkO/1Qe8DETFDyW16EzArJCKmzXFRPBAwYUn95sf7RdhQTzoqDhHUoXcjZhUaoNGCtO4B5mzK711dOs3CIGe5GyCJPS02pkvyKSSRF997hdYniOVQn+f31EeqXPzs5oxvlCpDL5v2qiVrPbvnuqm8rWHq3XRpjGB4GfHfXRxIv2hPOH7Yc57Hb61/d31+Pwgy3D8kQZDFgaOf2/MGkwh3mrh2YF0WD/xLNu1wfxofw0+9jd7nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cBcsGm0vC7Z2IO3DTw8IOPKKrr9TX7ShDPyM1NY1mTA=;
 b=wpuXIEV+NGTDv5sT5oA854gmRGIziWTNLNbxt1AKTI1pNgBEArk1c6jMnXfukpd1zJ9YFmWwJWB6+Lcsj2oSOLnbZz8PqzxmMPAFcLaS+ok6JsCzJICC4orTtDA801pJ+eOloCM11LW8pBXdqUg9wA/z9kSenY+4ISs6r+CVtWY=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN6PR12MB2622.namprd12.prod.outlook.com (2603:10b6:805:72::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Tue, 16 Jun
 2020 22:03:53 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2%3]) with mapi id 15.20.3088.029; Tue, 16 Jun 2020
 22:03:53 +0000
Subject: [PATCH v2 3/3] KVM:SVM: Enable INVPCID feature on AMD
From:   Babu Moger <babu.moger@amd.com>
To:     wanpengli@tencent.com, joro@8bytes.org, x86@kernel.org,
        sean.j.christopherson@intel.com, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com, vkuznets@redhat.com,
        tglx@linutronix.de, jmattson@google.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 16 Jun 2020 17:03:51 -0500
Message-ID: <159234503110.6230.9885185856732531454.stgit@bmoger-ubuntu>
In-Reply-To: <159234483706.6230.13753828995249423191.stgit@bmoger-ubuntu>
References: <159234483706.6230.13753828995249423191.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR15CA0048.namprd15.prod.outlook.com
 (2603:10b6:4:4b::34) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by DM5PR15CA0048.namprd15.prod.outlook.com (2603:10b6:4:4b::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.21 via Frontend Transport; Tue, 16 Jun 2020 22:03:52 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1ed9f680-b485-45f2-103a-08d812412835
X-MS-TrafficTypeDiagnostic: SN6PR12MB2622:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26227DC98EA23D41ABFD2097959D0@SN6PR12MB2622.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 04362AC73B
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yo7Xy1jQbcEXm/AqObZ01Fg2z8KAV0s1YP1da9XYpCsRoVq27y4HporIWOAl1Us94XKKAtJJcgwDtlPGa/hBxLm0Nnck0K7kVc5Q52gP+cVFvoFBLqLITfN4SA8HHoe+dQUL4J4bseNHruHus/QnrY8d4tkRKlO6yAi84kFD8eozxbhg+O8BQjqkB1uy/Lmq8UL+8GcGlpORMQrGCqzPQLxUskSekuhQWyK3JQ7Qc/Ol0PzWtsoyoyJlc0RbA76idKCgiAgMxH7hukzqPx6iChkUGDZ9e3TMQw5pqgWgI3IQg/REvzgWQKs131Jvc4WTyoF0Jw/CAgw19T3UwCfosjRZmDpx5H+6aE4WbWaQ9MvISEJwdoM5WiTBBO9Njg8hTW5lQEeDLnzuPSC3UjKyh4oLiIL5ob0pPnq8U+juvlPDhH6JOPCo0N0ZZv4tEuMN5wMkUduh2hcPPKSa1d1/LQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(366004)(39860400002)(136003)(396003)(376002)(346002)(7416002)(8676002)(83380400001)(478600001)(5660300002)(16576012)(966005)(8936002)(186003)(4326008)(103116003)(16526019)(2906002)(316002)(26005)(66476007)(66946007)(66556008)(956004)(33716001)(6486002)(9686003)(44832011)(52116002)(86362001)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: MAaSjSo6OjmDsejwNLqMr+ouEbaRUT2DsXA/DfX9o6Cw2CPmeBpxuSHQD81K1RLKbd01KxndCIZhoWTTwe6rq1WwaFVQReJUVJ6mNX47BOn3w/RA2q/V2tv0YscswLKSbktWmizbbzksjQ1YIFo8EERs15+p3nz8hR5I3j+4aAJsd/llnt8kXVCnNtIDyOt8CfvjQ42+hyTI5wcXqz6hc8rFkwk84n9ITf8pxVTCAPeUN3ePO+vM1jVyWnx0eFBWxrss4p8EzuIG1kTvHNTGdJogBb53XlCvPoaKlc433bbfbq5tLPyS6WrgfvLzRAXjB+orHH7dbHgD0xZqcZipKX6IcKet80U8lHOEmkBdemr7W/LXeGxhraXMWn9R2wgKxnT98YypnKZ0xRbP/OL2sBSDOkQST1dcO8fhGF8FcsBPtlp818Fa7f2DESBqVV29kM0yFFawfzxR92B5ka4viOKYEO/pGT/nBYtzyqssQJ8=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ed9f680-b485-45f2-103a-08d812412835
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2020 22:03:53.0674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TOR5FTm3CF7r0LkYPFc5HB00w021s3uxFueMzxMaLp85iXQTAsw2fGuTzuqAq2yQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2622
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

Enable the interceptions when the the guest is running with shadow
page table enabled and handle the tlbflush based on the type of
invpcid instruction type.

AMD documentation for INVPCID feature is available at "AMD64
Architecture Programmer’s Manual Volume 2: System Programming,
Pub. 24593 Rev. 3.34(or later)"

The documentation can be obtained at the links below:
Link: https://www.amd.com/system/files/TechDocs/24593.pdf
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/include/asm/svm.h      |    4 +++
 arch/x86/include/uapi/asm/svm.h |    2 +
 arch/x86/kvm/svm/svm.c          |   54 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 60 insertions(+)

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
index 285e5e1ff518..5d598a7a0289 100644
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
@@ -1099,6 +1104,18 @@ static void init_vmcb(struct vcpu_svm *svm)
 		clr_intercept(svm, INTERCEPT_PAUSE);
 	}
 
+	/*
+	 * Intercept INVPCID instruction only if shadow page table is
+	 * enabled. Interception is not required with nested page table
+	 * enabled.
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
 
@@ -2715,6 +2732,33 @@ static int mwait_interception(struct vcpu_svm *svm)
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
+	return kvm_handle_invpcid_types(vcpu,  gva, type);
+}
+
 static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_READ_CR0]			= cr_interception,
 	[SVM_EXIT_READ_CR3]			= cr_interception,
@@ -2777,6 +2821,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_MWAIT]			= mwait_interception,
 	[SVM_EXIT_XSETBV]			= xsetbv_interception,
 	[SVM_EXIT_RDPRU]			= rdpru_interception,
+	[SVM_EXIT_INVPCID]                      = invpcid_interception,
 	[SVM_EXIT_NPF]				= npf_interception,
 	[SVM_EXIT_RSM]                          = rsm_interception,
 	[SVM_EXIT_AVIC_INCOMPLETE_IPI]		= avic_incomplete_ipi_interception,
@@ -3562,6 +3607,15 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 	svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
 			     guest_cpuid_has(&svm->vcpu, X86_FEATURE_NRIPS);
 
+	/* Check again if INVPCID interception if required */
+	if (boot_cpu_has(X86_FEATURE_INVPCID) &&
+	    guest_cpuid_has(vcpu, X86_FEATURE_INVPCID)) {
+		if (!npt_enabled)
+			set_extended_intercept(svm, INTERCEPT_INVPCID);
+		else
+			clr_extended_intercept(svm, INTERCEPT_INVPCID);
+	}
+
 	if (!kvm_vcpu_apicv_active(vcpu))
 		return;
 

