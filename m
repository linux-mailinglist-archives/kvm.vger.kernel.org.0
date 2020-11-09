Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254132AC883
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732411AbgKIW3F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:29:05 -0500
Received: from mail-bn8nam12on2083.outbound.protection.outlook.com ([40.107.237.83]:43489
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730802AbgKIW3D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:29:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VOg/qzkjgrVbQnWTyCGo2xQWep7/N3PzIv9e8MEOcuJZ0rFOTgEDEcPv5hT+QHdNTkZT7saUlGPKDH++Umn/vGD6yeFF/TrijdplUf3W384T/jG6s5cN2M9LKk7j9BvuEwklrXPdd/sdSggPZh1VRXCpKwCcEg2MI6MBG70v7wIa/Od0D9dYHYo44plo0dskvMVC7BDpU/FgjZ78b7avb8n8SToG4sdnJxkqNUXfj2hc0S2N9NNQCLMG6QseKLwyx06xO0RJnV2unxfMEV/yRFmUiupQWviaff6zJsfNht4hV/cI9ZoqI6Eb4fRWxWOltGfLdjLoVLJ2EUyFfzHeOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KcQe5jaHadszUMoZL1mfv1+hY7ErgQzl2bzoa33ZXwM=;
 b=GTIC1YkNv9LmSsy7LjGNPvNe2c3RJtmGv8pJuzRFDbO8eHGuis7vsCXGBdGuefbRS+l0SBolqEd3JvsN4PdhF960Dm9aVtzxoJ5f7X7rJ50XFq71XTnIhh6iqXDfvZ+qTWCG+eRP8EcXdnkZsrtdU6EcmeoHXHYTV8pXNH1pjvysuttju7vAHXUoPQOIK9hALvtU8vYRc1kDX3zOlKYCsJf/Y14LdhC1bATdGTnRWvz0sIzqFD/NNzUXJlPAS5C8u53chOB1slUxxLOUY92xi3aGolgtrhAllJ645z+k8JlEWmjKNWLeZ4jSZ0hpcVNUcLwuQiKVBAN7i9TZLZphGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KcQe5jaHadszUMoZL1mfv1+hY7ErgQzl2bzoa33ZXwM=;
 b=WZTEAjiWn+7Miv/LVRlH6+wjZi0R8ozgRdLIWwgK7OXCL4I4o/tK6igIDI3VBnRjGxyFia1v1PgVDqn7/4mKsKjrwtr8eSGjhlHYMzS8s4w9FMSnZhVv3QV6L+SbobZftcexLAxJl1cKKKArGFLbjYtcy3cZriPViTOXdkBzAns=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:28:59 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:28:59 +0000
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
Subject: [PATCH v3 21/34] KVM: SVM: Add support for CR0 write traps for an SEV-ES guest
Date:   Mon,  9 Nov 2020 16:25:47 -0600
Message-Id: <d41526884a7e059d514c97fe45b8c0605299bc96.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR21CA0033.namprd21.prod.outlook.com
 (2603:10b6:3:ed::19) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR21CA0033.namprd21.prod.outlook.com (2603:10b6:3:ed::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.6 via Frontend Transport; Mon, 9 Nov 2020 22:28:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cbb7d0bc-7af8-4d2c-d020-08d884feda45
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB405858AACDBDBBC17E0C5FFDECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XJo1QMCBUyl2mqWSeqqB1Nf5cr1B78gGlTm44/k1p0eSwQ0hfIJs+Tu5B2t8Wr5RIKItkOGBmOLFjncKu9x7gjkuoOku+fPmO0PRRg0tsopVhynn1n4ZYitVjtmaXIm8ZkEaYytXpJgZhWp3LrWrzh/cIMSxrD6r2vYfGvv2vz/iMXNjV9M/EvIaekTImxN4hecYDCl7BX+dqWEOAKP6vFKAGSIiKySpa0vWlluhj7IWgp6IGia5gn3MaCggxCLV8AmbEujsu30Tde+rPiXA9Bsxe9xK0OQQ1oaFL9aQsQOSFV+YnlZEK6b98kEy1o+Y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Z5m4OXzWE7IK+eon/8Ak3jKYHK5ctr6dWWU16G7bVf9slPd8qU8hHBTtIwUokEOKT+ErnAhNCEO61Iu5kCcSdnZrkfuJcIpftMf8lyOVAEZfrJfwYZ2hsZ9lZJE1SgRIGLzVz6koYBEQLXWtt4PUBXv7x5+tkCw8qZ6daiPZvkrpPNRqyHAt3iP8KellvKwjOPGOjo2CF9cph0/gUQsg/hZhatpxVCrZkJfOn5R46UTKmfkIWLYEhJZP97TUxJHBVm2+fQs3k/dysZr1IU9hTHiFxY2Mzc/2CoqVFjWKxXGM2Si8PxFC+4YMCeFx2dCzqvM0gIicNq73520yTE5DK16RWljM1nAAvaKA/A7gZUTqrY4wR0l9oeI+yg3aNSkXu+6BMCWHRHDkvcodie1dF08te0ASnIYXhEV8Y7ZYiqoQXxm9EghwPKf99aYYIhPIA/hcBSowo08hT+pkOdxNzreJxpJHnrNj+ABLJZdtkopRWK+QxGs483SpeFzZE686OrfF45ay0iIIvKj5EekG9M+5kTbL+BEDHzm9TupenBFauUWP02oZKmq71/GWVbm/DJQKwNfFpi/fuhhWD7lBqxclK8swlurr2+koTEzN75NniTsAhbcF3lgMXWyaPGYDe9XXbStc8Cb50lFyxqumcA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbb7d0bc-7af8-4d2c-d020-08d884feda45
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:28:59.3132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PnME/155L1GQ/nrmqW+rabf7W1mImiypHzg72YGGj7xnwydlTYYuTT1Vz1RsIl5RRAMQ9qj+sVEnoBEJ/g69iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
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
index e16c1b49b34f..7a5adc2326fe 100644
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
index 5f1835cca28d..bc9beb1c4c8c 100644
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

