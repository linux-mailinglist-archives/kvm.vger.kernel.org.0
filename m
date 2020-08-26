Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D0C253819
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 21:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgHZTQ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 15:16:29 -0400
Received: from mail-co1nam11on2076.outbound.protection.outlook.com ([40.107.220.76]:57728
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726936AbgHZTPt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 15:15:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQay5lsvAOOcfMXr2w37htCLflt09EieoGw1y7GXnXastzoDsoOkUkbV/zM0quae+Wf65dLpa7NgWENnYFAeVJSc79g5gbTrt2ZANENmHXXnumMa0AMoDxyTU87umwh+yPJvsavmAzE9l2Wl6+bpcx7QaEWfY7v/RSG9uZi+kdaEbGRAHrEe04SH6QRCyMu6AxTqVOrzGa09M5FHdnxw8Go7qyhRJaZSha91j0YsGYLiSjNrqK26Ux3b0H/Yv/b1PLBA+qr9NThiIqtBffKsBHnk6tmgxpiqSfC/TWsCHGAV0/SCsPJM0urXMnXJzj9NFCvhmVU8keYjhbpPtYdQWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OkAXNOlTrAqAiZAxtVv7rpz3P8AgatFSU4lWiD+EO5o=;
 b=JXXWGJ7F5vmuET23QUGhneVZNS8TFUugK9PS/xx2DTVtPnNf6naU94NZvW9W3YY37jY5cAYAIRmwR8ag2hjmvxez7LKHU2CAzByxPqspObU4LNg/gM6oNW9HEyANfjwgWQsy++UsL6fIAlITG46l8nz3+mW5UFFoG9mOXcdQ1FuRG7gPT92Fl4gZSlSoB2Jjm/kY8n9ghvX17kqibRSfGPx234PQAFEK4KJEVEem2nWBV2wv0crCGLwiqXw7pco1sE+/ArMQognQ1WK1jn8QTc9fZD3MYuhDl9oJrf1bpoXivRuWa57a+J5evwj9zcf1C3w0+5Mi6cybC30x0LXkrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OkAXNOlTrAqAiZAxtVv7rpz3P8AgatFSU4lWiD+EO5o=;
 b=FLlue/haI+AwinNSv2pHukpp8HzvOhr8ev28OWVm9tM1JXd0CSc51oWBywHFbMEw8DgtwWGEUR1sIzu5SKg7X7qXpnNEvNqjQgVbBhQEoBBEMkEzabpXQIEJuzSjHviQz4vz/Aneb5cFZZrHPNE6uomuOL4gyibY9YQKq6lS3y4=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2384.namprd12.prod.outlook.com (2603:10b6:802:25::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Wed, 26 Aug
 2020 19:15:19 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3305.026; Wed, 26 Aug 2020
 19:15:19 +0000
Subject: [PATCH v5 12/12] KVM:SVM: Enable INVPCID feature on AMD
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Date:   Wed, 26 Aug 2020 14:15:17 -0500
Message-ID: <159846931719.18873.17261041399321750933.stgit@bmoger-ubuntu>
In-Reply-To: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
References: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR16CA0046.namprd16.prod.outlook.com
 (2603:10b6:4:15::32) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by DM5PR16CA0046.namprd16.prod.outlook.com (2603:10b6:4:15::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Wed, 26 Aug 2020 19:15:18 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 240ce38b-b4c6-47b4-7eb9-08d849f45f34
X-MS-TrafficTypeDiagnostic: SN1PR12MB2384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB238481CD610A33066BFC2FB695540@SN1PR12MB2384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QWdUFG5EbscY2A2qWFiHbnGnw8GJdi1QYIbfT5pob1rcxff4628eY7FWQt6RLY7RifZuQ7lkeqRYlOVAmJ54LHGGcT8Dv6/6z2Fa5IvrfQC6q6ippC8EJ/VS30bzrMn3CsYrIdViF6XeTD8kbFC+pFUox4XXIjuE3WORAsdLz0jkRSyVe0QHcFSCSuNwIOYpIQSGR61nr2Q8UZBsgxsDPkXERGTK9MAz8QSKvwVOFqISA6vwuXIe2TDzR0v4Mwqghg1e4XdTMhBVbAa6PLzsOWQ+2TrHHiDW1KY8zD6+qIvNq8jgffaxHVuCB3b4lNedeLkcngncspivo4Eq2YK03Lxsh1n2dZ52/XwzaTSLJc19ZRUOpwRNHh3G56Wt/f+Unwrl9dtEIwPbXLIfRZYEoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(366004)(136003)(376002)(396003)(39860400002)(103116003)(4326008)(186003)(966005)(66946007)(5660300002)(66476007)(66556008)(44832011)(86362001)(33716001)(9686003)(52116002)(7416002)(83380400001)(6486002)(8936002)(8676002)(16576012)(2906002)(316002)(26005)(478600001)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: M4Xm76KyeYBCR+u4Aud0xIBFf6+LZxcd9bFgXh3hOPHh1DBwkVgWxD/P00L0+wrbywO7zy+KXplXRLDA0U/J+pkSDVkH1ckzL8PIz4LjiVCR/V7WrwcNrvg5b7KZdMpvmperVccXyhAOguzcmTiBQ3XpWFBZxcZ5H9Bpw2y3dv0HDzolBhE5elj5FkmzKS3PFy0hELBLOoKEs1/iMan1nAszWSOwWS010Rzc4mt/OlOYhmiG6pnZYFw8qNfRBIdy7nItbEFW2yBSQZOx9idOZ+il9wLxfvAUHtTJmYn/pXbT0CXUe6fsEwPggaS+uXUfPEN3Lr+CkF6sRp433NCKGUu2vG21cKM5Wg+DrXQM3dU4Nm1FFVYCjBeAOP+aY8aUQP541H/ThnNNlvpiRFfOnQjzSXqUqijjkYScvL1EgISCxWxEJHUe/A/3FyemDru2OphKkYr3KyoKTJ4xhwyjP2NnNdYwEBOK/RrGwKmJg2J47AXUaNSeE+FmCZ1eL+gOy0CejKlp9BCCgW+sJy3fqS3d4QYZkjQ/+QpunSRDFUCMeM1VzNr2gNpgEJKqEPCqBTXN+k5nSRBBMFPl6sc/Wmpzd1vhRHGSmvKS6D/SRXxqKbvmKxGqyquAzJfK9GEp3owuXotdsO95zV/tc4EVUg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 240ce38b-b4c6-47b4-7eb9-08d849f45f34
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2020 19:15:19.2647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZwMkEbIYL7uksKNYLIf3hbk3d0PfonZ5oZ3wlhAO2U2PauXnnS7WkGiS9AHjxbEB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2384
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
 

