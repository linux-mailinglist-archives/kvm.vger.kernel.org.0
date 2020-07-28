Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD868231659
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 01:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730831AbgG1XjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 19:39:05 -0400
Received: from mail-bn8nam11on2053.outbound.protection.outlook.com ([40.107.236.53]:31872
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730759AbgG1XjE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 19:39:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qu2dEgh4UJP3HDb7ibhkEQsVt9Zl5Sy8LL5x+nL1d5jez/zfxhR9o6GWHvRO7ezN+F7aCuwx0rP8aBmzmMaGb06BW2MLrLSRIH8IZx02ydxyDhb5sTlJN4KK25m0WPjU0gOn/EqKF1SMIJpWNLWoW5emaTxyYGdlG/2cqIviJWou76zb85X9iYlo9DI9TTJdcIVkRGvVT+nRUF/0m1UkU7KNxbJE2sseuwau7yx2ykRrYKKahqJY9n4pOEFNbjvJTR7kWiapaADwnCpP1x55RIKn5bmtw8jbIzNG3DoPEstRjDlmxoM0ilinh7O8bNERs53ZFfmYaXzruV0iO1R4GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GmBBolenuje70gOPSEiYzIm70gc4Qr2U95hL8K1E4wc=;
 b=Ua+7cyQvuvdLFamzCkfuclDM00W8K+KTQeCPCoznMlLFU61Pqtm/nGLzXJqzAflLgEohjPB28V9xCE9BonS/yRyQE6En1PqnKfictpl0ZYmANGgpZbChXeUuLMLYW+7jsntte16wViavYqLUX+LIv9KLVFTa4VOFan9X6Jefr2B7Ov25jC9mkMACZHqETndSBWo6HAcmwVqfwIDNycalLNi0zm31kPIRgsJNNFkbg3GkvIxfeD6Q8U5yCFkEpV1/47iSzCQ31DSqbrNVNFP3aumcsxNvkN5yCW+s0GPjMqubC4gT+oVmgVweMCCTa2V+octoXuP7FxhUjlrlwGwKwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GmBBolenuje70gOPSEiYzIm70gc4Qr2U95hL8K1E4wc=;
 b=LcCoJfjaoa6lmgeL7rmbW2vmQoCrOMn0FqFwBO4BBIN0HxffJ/txaM3ZMzuTqNtw9oBZ/SvkB6dKo14hknIc44n6SMu5UUuyf4a7J5LOnm6xCk4AQvmWzG58oMwm3fTtWp6QUmwpdRNquDbEilYMzc3m2uRKAdxOI0KQs+l2cAg=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2559.namprd12.prod.outlook.com (2603:10b6:802:29::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Tue, 28 Jul
 2020 23:39:00 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 23:39:00 +0000
Subject: [PATCH v3 11/11] KVM:SVM: Enable INVPCID feature on AMD
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de
Date:   Tue, 28 Jul 2020 18:38:59 -0500
Message-ID: <159597953941.12744.13644431147694358715.stgit@bmoger-ubuntu>
In-Reply-To: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR11CA0029.namprd11.prod.outlook.com
 (2603:10b6:806:6e::34) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SA9PR11CA0029.namprd11.prod.outlook.com (2603:10b6:806:6e::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Tue, 28 Jul 2020 23:38:59 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6f19c04f-f863-4ffb-995a-08d8334f6763
X-MS-TrafficTypeDiagnostic: SN1PR12MB2559:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB25592FBC8E50D5BA9187786795730@SN1PR12MB2559.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oy6J/77Ijw9lMfkWHfjkP/RLHxyvlajUL/81IL7YdJq5rahkkHXtBKeQL+Z7CW25VxNg6j0yLxSD1dAon3Kfifk7xd9PCokxjBxv7RlSul4VhBj4P931K16Zkf+Kxi+l/dLMVS856Y6RK5WVJEIV0nM6WHprGKnMIPJl9PU7wJphaAKAnkCsKHUXLNQXdrQHkZQCkSeybNcivBEa7P+i3I/RF1TmpqMyAyMGC+qhmFGZrj3OwvyPBrfPsf3042nZ2TQusEQ7vaRkCfcWPhiaVzOzSYTSo24N7IkFvKIDxkbMOd20Zto/UUxbBDb0ZNGG8gwIVmOClSshamlpdpBeJxJCN5C5ZPn3IT9E4GEmleFfkLggyMh340mmP4Om0tcB6Yh40SxJv2QPG5SL/6QjlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(7916004)(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(66946007)(66476007)(5660300002)(7416002)(316002)(478600001)(6486002)(16576012)(66556008)(2906002)(966005)(103116003)(83380400001)(86362001)(9686003)(8936002)(16526019)(8676002)(26005)(186003)(956004)(52116002)(44832011)(33716001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OJ0GuR6bzZ5o6FP42qp8++iFrNaMVt3RnGkf6EW7/daRy4dQ8fCc7DbSwAW7LPhXqOQ61/EaYX28Ibn99oRKv2TdlsUsVuMg+xwBEGELKiSzayKNEeReyYodNwhyAtl2DteJK8FlQgahDCsgNBGG9xQFWRglnFJX8BUZiXQPm0O/MD5vmtCYn5HcHQuCdABGfjY08BG36+6YqGuj0soMcLRiBZc6xPtN9bUH3G+439Clu3FjfZ4IKiKVmOq6aa0fGZFikblNhyRT0yVxvWjuYrxxApsNo2ONZ4Zrx+NrfVAqViIZasLUHmSY0K531/2g/ByDvReY3ukqUHVLokYHBErxsuyFOyf0FszVKJh/ExmtE/xBH2LBlVSwoopWukcinfXc3T/MAyav9o0mak9A3obuTHWjwM442dXPrbK+mE5jv2g2JZu4JnQmozsSPt+mw75B9u90b5IcJrmQgerG9Ejd14LsEGdpZOBXpAkWcoOC9i0OeEsNEmZ2KE3vn9vEzMfenz5Abao1/WpYs5rjJBIFG5ty1KihQLEmvPV1ROOdhOk1OGlA3LQZC0pmwaWMhfrflhAHv9KTM1H8/sgJzG0hGpCrn92EruD7BPV1Cl8kjl7mRYKouav+h0Tpovm1927W/S7lx3mfdvrmDEByjw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f19c04f-f863-4ffb-995a-08d8334f6763
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 23:39:00.5457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IAVesXP+/gulItCb3E4GawjwXC4O9FUMVqlmmhMdCwIlURF7TO8U4cP/1zL9c84h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2559
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
---
 arch/x86/include/uapi/asm/svm.h |    2 +
 arch/x86/kvm/svm/svm.c          |   64 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

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
index 99cc9c285fe6..6b099e0b28c0 100644
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
+			set_intercept(svm, INTERCEPT_INVPCID);
+		else
+			clr_intercept(svm, INTERCEPT_INVPCID);
+	}
+
 	if (kvm_vcpu_apicv_active(&svm->vcpu))
 		avic_init_vmcb(svm);
 
@@ -2715,6 +2732,43 @@ static int mwait_interception(struct vcpu_svm *svm)
 	return nop_interception(svm);
 }
 
+static int invpcid_interception(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct x86_exception e;
+	unsigned long type;
+	gva_t gva;
+	struct {
+		u64 pcid;
+		u64 gla;
+	} operand;
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
+	if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
+		kvm_inject_emulated_page_fault(vcpu, &e);
+		return 1;
+	}
+
+	return kvm_handle_invpcid(vcpu, type, operand.pcid, operand.gla);
+}
+
 static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_READ_CR0]			= cr_interception,
 	[SVM_EXIT_READ_CR3]			= cr_interception,
@@ -2777,6 +2831,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_MWAIT]			= mwait_interception,
 	[SVM_EXIT_XSETBV]			= xsetbv_interception,
 	[SVM_EXIT_RDPRU]			= rdpru_interception,
+	[SVM_EXIT_INVPCID]                      = invpcid_interception,
 	[SVM_EXIT_NPF]				= npf_interception,
 	[SVM_EXIT_RSM]                          = rsm_interception,
 	[SVM_EXIT_AVIC_INCOMPLETE_IPI]		= avic_incomplete_ipi_interception,
@@ -3562,6 +3617,15 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 	svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
 			     guest_cpuid_has(&svm->vcpu, X86_FEATURE_NRIPS);
 
+	/* Check again if INVPCID interception if required */
+	if (boot_cpu_has(X86_FEATURE_INVPCID) &&
+	    guest_cpuid_has(vcpu, X86_FEATURE_INVPCID)) {
+		if (!npt_enabled)
+			set_intercept(svm, INTERCEPT_INVPCID);
+		else
+			clr_intercept(svm, INTERCEPT_INVPCID);
+	}
+
 	if (!kvm_vcpu_apicv_active(vcpu))
 		return;
 

