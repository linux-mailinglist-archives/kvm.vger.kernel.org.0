Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2F92B6B4C
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729282AbgKQRKj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:10:39 -0500
Received: from mail-dm6nam12on2077.outbound.protection.outlook.com ([40.107.243.77]:50048
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727922AbgKQRKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:10:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kN/ceZC7j/ylgygKLlblTkjZ+zq3fKzhAwjupcY4QX059k4X2Gzy7ojEipuIMwH6zSZiG80E47HlRpL8l5Z8xle7O7YA9K2shtZ5uLRe5ezwdBhIsoCnXQtnJ6DON7ouhVKcdlDJsvTg1+Zylb1eBkx7Z9y2qaOWi4pt0vu9A/VTkbh89leazmt4kzrHiHVwufB+ApGfhvVomgKR3PyVvTRYtL6N0dXEXOfH9+bLhhVaXRhJc5XVzfsoctaTJ0n52dmIUNlbIExIYdGTVFAC2hs6BdTSv7z9fQ+u1xpP7uM+1gNOrftYpgFRIjL2EeUNW8hBNGxZSmXuBRFprexw2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4RxZ4prlfsGgcObgXQ6t1PLsXAkp0UgEi4AMr2trksM=;
 b=UanSteT51/acxCJe9RG4XEbzoW8tMvdS4twN1LxNU+9fWXDm17WRY690URyv16fXVepXckO1WfHAQRlbyf95eWJsfJKXNHYAmSK/6xi1VkDFDXRCRpWsyes/9gky77LC7O6PH3cxh76DDpFvNPJzfkVqEzorvXz3EFHqt1X4Hx4cyfgV0te3aQC4tX0YfhCh6cdCG1Szg3Vp+K7MrV59PZXg8kyMuJa5evQIWWyiPnheyD5E5+eWvZfUd59kYpEBt1FfIlchjfuBCbF/G5VKss5kNTNnFGKQD8yB3wyg8oHOoA0VybLfkZSfs/TFAsY9x6tmGP6DRFnSPeQS2aXI5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4RxZ4prlfsGgcObgXQ6t1PLsXAkp0UgEi4AMr2trksM=;
 b=ZqQQ7gQmaPiOiMqV5UStTS+sFtwaQUbRK+iyOGoKA4YJo1cnm4ZUlC8i43ZZrXL2aWpenyMMGcv3d3rXfLGRUXsQ48eKh8QfdKDMgsZjGW0JlTdkX5YbQpWgln4MfvdLgzoQdf+aZ3leWbY3dh9+Nbpa95gCC0IqZDyklDznESk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:10:34 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:10:34 +0000
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
Subject: [PATCH v4 21/34] KVM: SVM: Add support for CR0 write traps for an SEV-ES guest
Date:   Tue, 17 Nov 2020 11:07:24 -0600
Message-Id: <80b9ee59892f0090f52b124f220fdba46e7c0b65.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0149.namprd05.prod.outlook.com
 (2603:10b6:803:2c::27) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0501CA0149.namprd05.prod.outlook.com (2603:10b6:803:2c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.15 via Frontend Transport; Tue, 17 Nov 2020 17:10:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 55a06a38-a5d4-4381-cccd-08d88b1bb23a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1772199CDEDAC2A8DEB978F7ECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wT5Dt/NrV721Oc4MvDe9q1A3xiWduQK/L2vXBr4BD4OJ3fOUCloEJxUetWr5QPJX/n2OW76bJ2zYQNjeGPEkLOMCzIojVVJiXfV8Kvb1OKSjAjPZJC2RUQfSZ1Spf+wdRin4zotlwfF/rQ09wC3LqgM9h1kS2jwld0z5rLAb5jfr+kkocsm4fucUSWG4X+WOxzhFuRTVfbgoSdLkIEcOIYIP+hcOJl1IXUbhzXgLNmIFPRwx9d1OK/0AwimuSRBbNapk7KILRt1KpZy5ByJXbFEGE4e4iyIBnt778BDVvbr8NOZvFxSFcEF01DWPEl+1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ITYvT26FbtPccX3K8OLs5eAL8yU1xNzN9ELOd0vTN95j+EaybrG7FOAnwqjligzt+2sTjaAyqi/kTEFekB68y4OSPSUvimQpib7tLlkSZSGnSuugVMOBVx0QHf2htoh5P2kJV2GAzdnZBf/JyPdOFYDm34QDmkxwZAKJC1e2yKZQzugDoR5U4Lc5RjTBXYPDFBTORunl+UFfDLGg3aoa7htOKwD7p7WCIlRXzIc9Wwps0ucpYaTy0Wyn8LxTz6UylZuWzbZ2eVjuSQIvaFybW0qW5efUgEA/76Z59/wtmXcIhK8cRlAaVOetH9ldfZOjbd6zgsWNc03vofvdEpnfFnVKQUfAXT0FDk5GbViTEaPd0gD3qOfkyVuhrjxcRugcQeCfy9gQyPKQUMDpEdsDPOWuRLAtwP2JvwOYRrLUX22qoDWv7xUYY5/dWKM45Dahgd7UOGgLR2ZK7gU+/UsEgCdFhVav5C4tjhYqB0Q0Dru7dYyUzys/3PRu05y4bYJBA2F9o7LiKDoiA0fkFrNfiP/hF3Lpzv64Lip9o7F0DYnsZGWUY0TMKK/JVuGIfIetvFh1sqRzZW6kSSTndzNf80E3v32IcWHMxv+/Y6kT8+QCAKQ/o+eDxSdEAe+ns79RRQyGDRSHH55BZ/HXY8HKfw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55a06a38-a5d4-4381-cccd-08d88b1bb23a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:10:34.5620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wuXjX3eLxczloxQLGgUBORwTdjVtExKV3J3bAGi8OSpAq//jOCTHgXUn+RZ6KAcyojMMnP23L010oxAiKOGnkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

For SEV-ES guests, the interception of control register write access
is not recommended. Control register interception occurs prior to the
control register being modified and the hypervisor is unable to modify
the control register itself because the register is located in the
encrypted register state.

SEV-ES support introduces new control register write traps. These traps
provide intercept support of a control register write after the control
register has been modified. The new control register value is provided in
the VMCB EXITINFO1 field, allowing the hypervisor to track the setting
of the guest control registers.

Add support to track the value of the guest CR0 register using the control
register write trap so that the hypervisor understands the guest operating
mode.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/include/uapi/asm/svm.h | 17 ++++++++++++++
 arch/x86/kvm/svm/svm.c          | 24 +++++++++++++++++++
 arch/x86/kvm/x86.c              | 41 +++++++++++++++++++--------------
 4 files changed, 66 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4fe718e339c9..068853bcbc74 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1473,6 +1473,7 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 		    int reason, bool has_error_code, u32 error_code);
 
+int __kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0);
 int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
 int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 6e3f92e17655..14b0d97b50e2 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -78,6 +78,22 @@
 #define SVM_EXIT_XSETBV        0x08d
 #define SVM_EXIT_RDPRU         0x08e
 #define SVM_EXIT_EFER_WRITE_TRAP		0x08f
+#define SVM_EXIT_CR0_WRITE_TRAP			0x090
+#define SVM_EXIT_CR1_WRITE_TRAP			0x091
+#define SVM_EXIT_CR2_WRITE_TRAP			0x092
+#define SVM_EXIT_CR3_WRITE_TRAP			0x093
+#define SVM_EXIT_CR4_WRITE_TRAP			0x094
+#define SVM_EXIT_CR5_WRITE_TRAP			0x095
+#define SVM_EXIT_CR6_WRITE_TRAP			0x096
+#define SVM_EXIT_CR7_WRITE_TRAP			0x097
+#define SVM_EXIT_CR8_WRITE_TRAP			0x098
+#define SVM_EXIT_CR9_WRITE_TRAP			0x099
+#define SVM_EXIT_CR10_WRITE_TRAP		0x09a
+#define SVM_EXIT_CR11_WRITE_TRAP		0x09b
+#define SVM_EXIT_CR12_WRITE_TRAP		0x09c
+#define SVM_EXIT_CR13_WRITE_TRAP		0x09d
+#define SVM_EXIT_CR14_WRITE_TRAP		0x09e
+#define SVM_EXIT_CR15_WRITE_TRAP		0x09f
 #define SVM_EXIT_INVPCID       0x0a2
 #define SVM_EXIT_NPF           0x400
 #define SVM_EXIT_AVIC_INCOMPLETE_IPI		0x401
@@ -186,6 +202,7 @@
 	{ SVM_EXIT_MWAIT,       "mwait" }, \
 	{ SVM_EXIT_XSETBV,      "xsetbv" }, \
 	{ SVM_EXIT_EFER_WRITE_TRAP,	"write_efer_trap" }, \
+	{ SVM_EXIT_CR0_WRITE_TRAP,	"write_cr0_trap" }, \
 	{ SVM_EXIT_INVPCID,     "invpcid" }, \
 	{ SVM_EXIT_NPF,         "npf" }, \
 	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"avic_incomplete_ipi" }, \
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f840e3a3ee45..b6b16379ae8d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2466,6 +2466,29 @@ static int cr_interception(struct vcpu_svm *svm)
 	return kvm_complete_insn_gp(&svm->vcpu, err);
 }
 
+static int cr_trap(struct vcpu_svm *svm)
+{
+	unsigned long old_value, new_value;
+	unsigned int cr;
+	int ret;
+
+	new_value = (unsigned long)svm->vmcb->control.exit_info_1;
+
+	cr = svm->vmcb->control.exit_code - SVM_EXIT_CR0_WRITE_TRAP;
+	switch (cr) {
+	case 0:
+		old_value = kvm_read_cr0(&svm->vcpu);
+
+		ret = __kvm_set_cr0(&svm->vcpu, old_value, new_value);
+		break;
+	default:
+		WARN(1, "unhandled CR%d write trap", cr);
+		ret = 1;
+	}
+
+	return kvm_complete_insn_gp(&svm->vcpu, ret);
+}
+
 static int dr_interception(struct vcpu_svm *svm)
 {
 	int reg, dr;
@@ -3047,6 +3070,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_XSETBV]			= xsetbv_interception,
 	[SVM_EXIT_RDPRU]			= rdpru_interception,
 	[SVM_EXIT_EFER_WRITE_TRAP]		= efer_trap,
+	[SVM_EXIT_CR0_WRITE_TRAP]		= cr_trap,
 	[SVM_EXIT_INVPCID]                      = invpcid_interception,
 	[SVM_EXIT_NPF]				= npf_interception,
 	[SVM_EXIT_RSM]                          = rsm_interception,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 46bd83f0dbc3..a25c2bd43de3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -804,11 +804,33 @@ bool pdptrs_changed(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(pdptrs_changed);
 
+int __kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0)
+{
+	unsigned long update_bits = X86_CR0_PG | X86_CR0_WP;
+
+	kvm_x86_ops.set_cr0(vcpu, cr0);
+
+	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
+		kvm_clear_async_pf_completion_queue(vcpu);
+		kvm_async_pf_hash_reset(vcpu);
+	}
+
+	if ((cr0 ^ old_cr0) & update_bits)
+		kvm_mmu_reset_context(vcpu);
+
+	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
+	    kvm_arch_has_noncoherent_dma(vcpu->kvm) &&
+	    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
+		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__kvm_set_cr0);
+
 int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	unsigned long old_cr0 = kvm_read_cr0(vcpu);
 	unsigned long pdptr_bits = X86_CR0_CD | X86_CR0_NW | X86_CR0_PG;
-	unsigned long update_bits = X86_CR0_PG | X86_CR0_WP;
 
 	cr0 |= X86_CR0_ET;
 
@@ -845,22 +867,7 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	if (!(cr0 & X86_CR0_PG) && kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE))
 		return 1;
 
-	kvm_x86_ops.set_cr0(vcpu, cr0);
-
-	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
-		kvm_clear_async_pf_completion_queue(vcpu);
-		kvm_async_pf_hash_reset(vcpu);
-	}
-
-	if ((cr0 ^ old_cr0) & update_bits)
-		kvm_mmu_reset_context(vcpu);
-
-	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
-	    kvm_arch_has_noncoherent_dma(vcpu->kvm) &&
-	    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
-		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
-
-	return 0;
+	return __kvm_set_cr0(vcpu, old_cr0, cr0);
 }
 EXPORT_SYMBOL_GPL(kvm_set_cr0);
 
-- 
2.28.0

