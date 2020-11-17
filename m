Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA8322B6B37
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbgKQRJl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:09:41 -0500
Received: from mail-dm6nam11on2086.outbound.protection.outlook.com ([40.107.223.86]:3169
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728923AbgKQRJk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:09:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmHUEQumjnuB3rIgX10RtmYLVQtlmYYwTc+ExZ8rDQ8PJdJ0QQgaqya+Uf3ge3ZofAAXCwoBptl8GxjTjWenyZN4CLwHGsv4cHY06gN60Zm+gS6VSDVpLJnfmuyhWE3e/qCW0y5vh5F8Dnetfm4jwxv6SeKfy3/pa39GHFzATvqE5kBIf+R/JNt6VlWBdsopSZIccWR7TTINYqkmBTxynO+kzrkQMHs3Wgkp8JJBZFQavr90kmrqXz3OQC3KYKUScFH7Su5UhuIWsk/U8pX1IzwNaHSSw6x4/qfG8Rxo+JnLYhVjOXm+N2jZxYcVu1NrzCTQv/E3PwYqUYvtf2YgQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3uWK4GLo0hoYfTJ4tWodWWtsuHwczfuWSLYrj//v5fc=;
 b=mtjJ4O4jG5j/Nk0kwu9w/aKqRjAKLTxdQlhNsgjSUg/hedYK8odOJzbP5cGT97ZLYww9wt/6cZGqWfqDet5d+1c4RPmpz7V3Pea2wSk2JrdG1Yl9SoahiWEzR0kJOqI6/K657XIRJ7T/feRrpLDoSUjBaYbrJPSwwtGf9VExSIIdDcC8eR7lyBhJxfjYcx0XsBY4RaT+krTgEDgwCMO0Fe7QneSU+a1BU9lWcBELTSQSJ5o8WLQ0nLfyiaT7d6qR4Dg72ZcebJ8S6kZC5qFaQLqzF+kkAPAt5LJaxJJNr+tHKmP0+Qt55JszBkXFoRjZdZ4nqb/5jbw0Fk758sI8Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3uWK4GLo0hoYfTJ4tWodWWtsuHwczfuWSLYrj//v5fc=;
 b=G7NwwlOqcIYmoEtJQ4kQAVomVlHVX+t19emkOcy+mfPLmgwLCarEiUotZcUSUhPqn2LM++nSEsIScM1fSq9i76n9NUhIMfZnawFp8aeDFoJJ4VUzbO90EWsKWty8q3ZrFyKrPuS0dwMRX7WQh4Ky9uJccQQS6RDGppK7RBGLN3o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:09:22 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:09:22 +0000
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
Subject: [PATCH v4 12/34] KVM: SVM: Add initial support for a VMGEXIT VMEXIT
Date:   Tue, 17 Nov 2020 11:07:15 -0600
Message-Id: <5cccfae30020886bc36d859ece88999a2e65d061.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR08CA0058.namprd08.prod.outlook.com
 (2603:10b6:4:60::47) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR08CA0058.namprd08.prod.outlook.com (2603:10b6:4:60::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Tue, 17 Nov 2020 17:09:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e5fa3638-2153-4ab9-e2f9-08d88b1b8758
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1772D963FB7FE5724383A48DECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Wv5ljXAvDehfMkK6BivVBFZHvauE8Nf6uHOjPjsfhzsTznTpitjC5pgmy0L7/UXU4S4YRN6Uyaf5Mwxt5myoK0xEe6cGyd2UkgUWDCRIMRQsFuLNUmtlK2mj5iDGkxFnp9jjUCx9kO6EtaC/vzr1HfzhrA85sfLfO4nfpGzbgLma2pK0n4GjwWfk35i/5GScY8P05uz1J9eURcxT3uJfXqh5GYtUKrxKNKPJE8LilWN5Ww6YuWonq9iTodek+3Z/Mm6BlS75XlQ/jv0UIEbgRUIqMqibxHBk1upUo/g2FT+QdKPmrvKp1/ev9zQEe37wN2eIvZrRJT8N+Qqnb9l+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(30864003)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: KwLlOvkBLnYbYsaXij5LPB3z0NIH24DBR++erI2mxTgGBjVYgmzj9Nd893dv4L9D93UpGJY7XqA6CDcPa1OeAiVBY/kfZqqRKRTxgmPgu35C8sUtR8XC+QLJwZZ4tOaVubTiom35qPwwcTwBApQus/eXnn3r6nTOvLpUVzgOtw40fBYQZZR9UX8gD+m6GT5YYyjArsD06zBuxEhWRL7kAFNcyOTgWtVbePYCATPPgfID4HIBGr0MYpucfm3ZmZo19lZAdXi7RrWe3EmUi6oScQgN+VTQPU9vf5RmEiS9UnehM77kWSGzIJ+uDl6awPf8DYNifEztbngQTPPQa2tqZOaGv+KJu/JhgZISLZhn/m3wDPtaeeoVCsn1SbiScE/BDYxyWyXauHhL0WZ+I2zdP2YqBaJ197BL1bnyfSCNn9VVYW5SPNQwR3VCARKcNPxvFlJHbd7Oa+s+idcXRlNS+HFAvdEl4e/x7SLuJfCyizKwQAXn6dFG/Hn6pVP2Y2W/nTR5V9EV+sCXThJUK9fpZDu9WJounBtfzdKMtPSoIWYOyvkFhpCz5lpXQ4ijoOvr6v6ZPQyD2TKhiUEkhkOcFoeFO/eloQRAVBZy4FWjH2tyQx4cTwFL8NUKiHFjB/WhDU+HYbr9izYEvjgGQyXLrg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5fa3638-2153-4ab9-e2f9-08d88b1b8758
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:09:22.7790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dsEjt4IVOjaSp267Ga+oWTe2oJFH9OBr0ZrdDQg5uRAheanMDotSLdrsYjd9j7knGSaSGHVLdhMIKQdtUlDO4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

SEV-ES adds a new VMEXIT reason code, VMGEXIT. Initial support for a
VMGEXIT includes mapping the GHCB based on the guest GPA, which is
obtained from a new VMCB field, and then validating the required inputs
for the VMGEXIT exit reason.

Since many of the VMGEXIT exit reasons correspond to existing VMEXIT
reasons, the information from the GHCB is copied into the VMCB control
exit code areas and KVM register areas. The standard exit handlers are
invoked, similar to standard VMEXIT processing. Before restarting the
vCPU, the GHCB is updated with any registers that have been updated by
the hypervisor.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/svm.h      |   2 +-
 arch/x86/include/uapi/asm/svm.h |   7 +
 arch/x86/kvm/cpuid.c            |   1 +
 arch/x86/kvm/svm/sev.c          | 272 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |   8 +-
 arch/x86/kvm/svm/svm.h          |   8 +
 6 files changed, 295 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index bce28482d63d..caa8628f5fba 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -130,7 +130,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u32 exit_int_info_err;
 	u64 nested_ctl;
 	u64 avic_vapic_bar;
-	u8 reserved_4[8];
+	u64 ghcb_gpa;
 	u32 event_inj;
 	u32 event_inj_err;
 	u64 nested_cr3;
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index f1d8307454e0..09f723945425 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -81,6 +81,7 @@
 #define SVM_EXIT_NPF           0x400
 #define SVM_EXIT_AVIC_INCOMPLETE_IPI		0x401
 #define SVM_EXIT_AVIC_UNACCELERATED_ACCESS	0x402
+#define SVM_EXIT_VMGEXIT       0x403
 
 /* SEV-ES software-defined VMGEXIT events */
 #define SVM_VMGEXIT_MMIO_READ			0x80000001
@@ -187,6 +188,12 @@
 	{ SVM_EXIT_NPF,         "npf" }, \
 	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"avic_incomplete_ipi" }, \
 	{ SVM_EXIT_AVIC_UNACCELERATED_ACCESS,   "avic_unaccelerated_access" }, \
+	{ SVM_EXIT_VMGEXIT,		"vmgexit" }, \
+	{ SVM_VMGEXIT_MMIO_READ,	"vmgexit_mmio_read" }, \
+	{ SVM_VMGEXIT_MMIO_WRITE,	"vmgexit_mmio_write" }, \
+	{ SVM_VMGEXIT_NMI_COMPLETE,	"vmgexit_nmi_complete" }, \
+	{ SVM_VMGEXIT_AP_HLT_LOOP,	"vmgexit_ap_hlt_loop" }, \
+	{ SVM_VMGEXIT_AP_JUMP_TABLE,	"vmgexit_ap_jump_table" }, \
 	{ SVM_EXIT_ERR,         "invalid_guest_state" }
 
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index d50041f570e8..0f6ecbb5e5b0 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -146,6 +146,7 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 					   MSR_IA32_MISC_ENABLE_MWAIT);
 	}
 }
+EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
 
 static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index fb4a411f7550..54e6894b26d2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -18,6 +18,7 @@
 
 #include "x86.h"
 #include "svm.h"
+#include "cpuid.h"
 
 static int sev_flush_asids(void);
 static DECLARE_RWSEM(sev_deactivate_lock);
@@ -1257,11 +1258,226 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 	__free_page(virt_to_page(svm->vmsa));
 }
 
+static void dump_ghcb(struct vcpu_svm *svm)
+{
+	struct ghcb *ghcb = svm->ghcb;
+	unsigned int nbits;
+
+	/* Re-use the dump_invalid_vmcb module parameter */
+	if (!dump_invalid_vmcb) {
+		pr_warn_ratelimited("set kvm_amd.dump_invalid_vmcb=1 to dump internal KVM state.\n");
+		return;
+	}
+
+	nbits = sizeof(ghcb->save.valid_bitmap) * 8;
+
+	pr_err("GHCB (GPA=%016llx):\n", svm->vmcb->control.ghcb_gpa);
+	pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_code",
+	       ghcb->save.sw_exit_code, ghcb_sw_exit_code_is_valid(ghcb));
+	pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_info_1",
+	       ghcb->save.sw_exit_info_1, ghcb_sw_exit_info_1_is_valid(ghcb));
+	pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_info_2",
+	       ghcb->save.sw_exit_info_2, ghcb_sw_exit_info_2_is_valid(ghcb));
+	pr_err("%-20s%016llx is_valid: %u\n", "sw_scratch",
+	       ghcb->save.sw_scratch, ghcb_sw_scratch_is_valid(ghcb));
+	pr_err("%-20s%*pb\n", "valid_bitmap", nbits, ghcb->save.valid_bitmap);
+}
+
+static void sev_es_sync_to_ghcb(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct ghcb *ghcb = svm->ghcb;
+
+	/*
+	 * The GHCB protocol so far allows for the following data
+	 * to be returned:
+	 *   GPRs RAX, RBX, RCX, RDX
+	 *
+	 * Copy their values to the GHCB if they are dirty.
+	 */
+	if (kvm_register_is_dirty(vcpu, VCPU_REGS_RAX))
+		ghcb_set_rax(ghcb, vcpu->arch.regs[VCPU_REGS_RAX]);
+	if (kvm_register_is_dirty(vcpu, VCPU_REGS_RBX))
+		ghcb_set_rbx(ghcb, vcpu->arch.regs[VCPU_REGS_RBX]);
+	if (kvm_register_is_dirty(vcpu, VCPU_REGS_RCX))
+		ghcb_set_rcx(ghcb, vcpu->arch.regs[VCPU_REGS_RCX]);
+	if (kvm_register_is_dirty(vcpu, VCPU_REGS_RDX))
+		ghcb_set_rdx(ghcb, vcpu->arch.regs[VCPU_REGS_RDX]);
+}
+
+static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
+{
+	struct vmcb_control_area *control = &svm->vmcb->control;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct ghcb *ghcb = svm->ghcb;
+	u64 exit_code;
+
+	/*
+	 * The GHCB protocol so far allows for the following data
+	 * to be supplied:
+	 *   GPRs RAX, RBX, RCX, RDX
+	 *   XCR0
+	 *   CPL
+	 *
+	 * VMMCALL allows the guest to provide extra registers. KVM also
+	 * expects RSI for hypercalls, so include that, too.
+	 *
+	 * Copy their values to the appropriate location if supplied.
+	 */
+	memset(vcpu->arch.regs, 0, sizeof(vcpu->arch.regs));
+
+	vcpu->arch.regs[VCPU_REGS_RAX] = ghcb_get_rax_if_valid(ghcb);
+	vcpu->arch.regs[VCPU_REGS_RBX] = ghcb_get_rbx_if_valid(ghcb);
+	vcpu->arch.regs[VCPU_REGS_RCX] = ghcb_get_rcx_if_valid(ghcb);
+	vcpu->arch.regs[VCPU_REGS_RDX] = ghcb_get_rdx_if_valid(ghcb);
+	vcpu->arch.regs[VCPU_REGS_RSI] = ghcb_get_rsi_if_valid(ghcb);
+
+	svm->vmcb->save.cpl = ghcb_get_cpl_if_valid(ghcb);
+
+	if (ghcb_xcr0_is_valid(ghcb)) {
+		vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
+		kvm_update_cpuid_runtime(vcpu);
+	}
+
+	/* Copy the GHCB exit information into the VMCB fields */
+	exit_code = ghcb_get_sw_exit_code(ghcb);
+	control->exit_code = lower_32_bits(exit_code);
+	control->exit_code_hi = upper_32_bits(exit_code);
+	control->exit_info_1 = ghcb_get_sw_exit_info_1(ghcb);
+	control->exit_info_2 = ghcb_get_sw_exit_info_2(ghcb);
+
+	/* Clear the valid entries fields */
+	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
+}
+
+static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu;
+	struct ghcb *ghcb;
+	u64 exit_code = 0;
+
+	ghcb = svm->ghcb;
+
+	/* Only GHCB Usage code 0 is supported */
+	if (ghcb->ghcb_usage)
+		goto vmgexit_err;
+
+	/*
+	 * Retrieve the exit code now even though is may not be marked valid
+	 * as it could help with debugging.
+	 */
+	exit_code = ghcb_get_sw_exit_code(ghcb);
+
+	if (!ghcb_sw_exit_code_is_valid(ghcb) ||
+	    !ghcb_sw_exit_info_1_is_valid(ghcb) ||
+	    !ghcb_sw_exit_info_2_is_valid(ghcb))
+		goto vmgexit_err;
+
+	switch (ghcb_get_sw_exit_code(ghcb)) {
+	case SVM_EXIT_READ_DR7:
+		break;
+	case SVM_EXIT_WRITE_DR7:
+		if (!ghcb_rax_is_valid(ghcb))
+			goto vmgexit_err;
+		break;
+	case SVM_EXIT_RDTSC:
+		break;
+	case SVM_EXIT_RDPMC:
+		if (!ghcb_rcx_is_valid(ghcb))
+			goto vmgexit_err;
+		break;
+	case SVM_EXIT_CPUID:
+		if (!ghcb_rax_is_valid(ghcb) ||
+		    !ghcb_rcx_is_valid(ghcb))
+			goto vmgexit_err;
+		if (ghcb_get_rax(ghcb) == 0xd)
+			if (!ghcb_xcr0_is_valid(ghcb))
+				goto vmgexit_err;
+		break;
+	case SVM_EXIT_INVD:
+		break;
+	case SVM_EXIT_IOIO:
+		if (!(ghcb_get_sw_exit_info_1(ghcb) & SVM_IOIO_TYPE_MASK))
+			if (!ghcb_rax_is_valid(ghcb))
+				goto vmgexit_err;
+		break;
+	case SVM_EXIT_MSR:
+		if (!ghcb_rcx_is_valid(ghcb))
+			goto vmgexit_err;
+		if (ghcb_get_sw_exit_info_1(ghcb)) {
+			if (!ghcb_rax_is_valid(ghcb) ||
+			    !ghcb_rdx_is_valid(ghcb))
+				goto vmgexit_err;
+		}
+		break;
+	case SVM_EXIT_VMMCALL:
+		if (!ghcb_rax_is_valid(ghcb) ||
+		    !ghcb_cpl_is_valid(ghcb))
+			goto vmgexit_err;
+		break;
+	case SVM_EXIT_RDTSCP:
+		break;
+	case SVM_EXIT_WBINVD:
+		break;
+	case SVM_EXIT_MONITOR:
+		if (!ghcb_rax_is_valid(ghcb) ||
+		    !ghcb_rcx_is_valid(ghcb) ||
+		    !ghcb_rdx_is_valid(ghcb))
+			goto vmgexit_err;
+		break;
+	case SVM_EXIT_MWAIT:
+		if (!ghcb_rax_is_valid(ghcb) ||
+		    !ghcb_rcx_is_valid(ghcb))
+			goto vmgexit_err;
+		break;
+	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
+		break;
+	default:
+		goto vmgexit_err;
+	}
+
+	return 0;
+
+vmgexit_err:
+	vcpu = &svm->vcpu;
+
+	if (ghcb->ghcb_usage) {
+		vcpu_unimpl(vcpu, "vmgexit: ghcb usage %#x is not valid\n",
+			    ghcb->ghcb_usage);
+	} else {
+		vcpu_unimpl(vcpu, "vmgexit: exit reason %#llx is not valid\n",
+			    exit_code);
+		dump_ghcb(svm);
+	}
+
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
+	vcpu->run->internal.ndata = 2;
+	vcpu->run->internal.data[0] = exit_code;
+	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
+
+	return -EINVAL;
+}
+
+static void pre_sev_es_run(struct vcpu_svm *svm)
+{
+	if (!svm->ghcb)
+		return;
+
+	sev_es_sync_to_ghcb(svm);
+
+	kvm_vcpu_unmap(&svm->vcpu, &svm->ghcb_map, true);
+	svm->ghcb = NULL;
+}
+
 void pre_sev_run(struct vcpu_svm *svm, int cpu)
 {
 	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
 	int asid = sev_get_asid(svm->vcpu.kvm);
 
+	/* Perform any SEV-ES pre-run actions */
+	pre_sev_es_run(svm);
+
 	/* Assign the asid allocated with this SEV guest */
 	svm->vmcb->control.asid = asid;
 
@@ -1279,3 +1495,59 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 	svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
 	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
 }
+
+static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
+{
+	return -EINVAL;
+}
+
+int sev_handle_vmgexit(struct vcpu_svm *svm)
+{
+	struct vmcb_control_area *control = &svm->vmcb->control;
+	u64 ghcb_gpa, exit_code;
+	struct ghcb *ghcb;
+	int ret;
+
+	/* Validate the GHCB */
+	ghcb_gpa = control->ghcb_gpa;
+	if (ghcb_gpa & GHCB_MSR_INFO_MASK)
+		return sev_handle_vmgexit_msr_protocol(svm);
+
+	if (!ghcb_gpa) {
+		vcpu_unimpl(&svm->vcpu, "vmgexit: GHCB gpa is not set\n");
+		return -EINVAL;
+	}
+
+	if (kvm_vcpu_map(&svm->vcpu, ghcb_gpa >> PAGE_SHIFT, &svm->ghcb_map)) {
+		/* Unable to map GHCB from guest */
+		vcpu_unimpl(&svm->vcpu, "vmgexit: error mapping GHCB [%#llx] from guest\n",
+			    ghcb_gpa);
+		return -EINVAL;
+	}
+
+	svm->ghcb = svm->ghcb_map.hva;
+	ghcb = svm->ghcb_map.hva;
+
+	exit_code = ghcb_get_sw_exit_code(ghcb);
+
+	ret = sev_es_validate_vmgexit(svm);
+	if (ret)
+		return ret;
+
+	sev_es_sync_from_ghcb(svm);
+	ghcb_set_sw_exit_info_1(ghcb, 0);
+	ghcb_set_sw_exit_info_2(ghcb, 0);
+
+	ret = -EINVAL;
+	switch (exit_code) {
+	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
+		vcpu_unimpl(&svm->vcpu,
+			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
+			    control->exit_info_1, control->exit_info_2);
+		break;
+	default:
+		ret = svm_invoke_exit_handler(svm, exit_code);
+	}
+
+	return ret;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 602e20f38bdc..6fa36afbbad1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -195,7 +195,7 @@ module_param(sev, int, 0444);
 int sev_es = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
 module_param(sev_es, int, 0444);
 
-static bool __read_mostly dump_invalid_vmcb = 0;
+bool __read_mostly dump_invalid_vmcb;
 module_param(dump_invalid_vmcb, bool, 0644);
 
 static u8 rsm_ins_bytes[] = "\x0f\xaa";
@@ -3027,6 +3027,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_RSM]                          = rsm_interception,
 	[SVM_EXIT_AVIC_INCOMPLETE_IPI]		= avic_incomplete_ipi_interception,
 	[SVM_EXIT_AVIC_UNACCELERATED_ACCESS]	= avic_unaccelerated_access_interception,
+	[SVM_EXIT_VMGEXIT]			= sev_handle_vmgexit,
 };
 
 static void dump_vmcb(struct kvm_vcpu *vcpu)
@@ -3068,6 +3069,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%lld\n", "nested_ctl:", control->nested_ctl);
 	pr_err("%-20s%016llx\n", "nested_cr3:", control->nested_cr3);
 	pr_err("%-20s%016llx\n", "avic_vapic_bar:", control->avic_vapic_bar);
+	pr_err("%-20s%016llx\n", "ghcb:", control->ghcb_gpa);
 	pr_err("%-20s%08x\n", "event_inj:", control->event_inj);
 	pr_err("%-20s%08x\n", "event_inj_err:", control->event_inj_err);
 	pr_err("%-20s%lld\n", "virt_ext:", control->virt_ext);
@@ -3164,7 +3166,7 @@ static int svm_handle_invalid_exit(struct kvm_vcpu *vcpu, u64 exit_code)
 	return -EINVAL;
 }
 
-static int svm_invoke_exit_handler(struct vcpu_svm *svm, u64 exit_code)
+int svm_invoke_exit_handler(struct vcpu_svm *svm, u64 exit_code)
 {
 	if (svm_handle_invalid_exit(&svm->vcpu, exit_code))
 		return 0;
@@ -3180,6 +3182,8 @@ static int svm_invoke_exit_handler(struct vcpu_svm *svm, u64 exit_code)
 		return halt_interception(svm);
 	else if (exit_code == SVM_EXIT_NPF)
 		return npf_interception(svm);
+	else if (exit_code == SVM_EXIT_VMGEXIT)
+		return sev_handle_vmgexit(svm);
 #endif
 	return svm_exit_handlers[exit_code](svm);
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 66ea889f71ed..4ee217338d0b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -17,6 +17,7 @@
 
 #include <linux/kvm_types.h>
 #include <linux/kvm_host.h>
+#include <linux/bits.h>
 
 #include <asm/svm.h>
 
@@ -171,6 +172,7 @@ struct vcpu_svm {
 	/* SEV-ES support */
 	struct vmcb_save_area *vmsa;
 	struct ghcb *ghcb;
+	struct kvm_host_map ghcb_map;
 };
 
 struct svm_cpu_data {
@@ -389,6 +391,7 @@ static inline bool gif_set(struct vcpu_svm *svm)
 
 extern int sev;
 extern int sev_es;
+extern bool dump_invalid_vmcb;
 
 u32 svm_msrpm_offset(u32 msr);
 u32 *svm_vcpu_alloc_msrpm(void);
@@ -404,6 +407,7 @@ bool svm_smi_blocked(struct kvm_vcpu *vcpu);
 bool svm_nmi_blocked(struct kvm_vcpu *vcpu);
 bool svm_interrupt_blocked(struct kvm_vcpu *vcpu);
 void svm_set_gif(struct vcpu_svm *svm, bool value);
+int svm_invoke_exit_handler(struct vcpu_svm *svm, u64 exit_code);
 
 /* nested.c */
 
@@ -509,6 +513,9 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 
 /* sev.c */
 
+#define GHCB_MSR_INFO_POS		0
+#define GHCB_MSR_INFO_MASK		(BIT_ULL(12) - 1)
+
 extern unsigned int max_sev_asid;
 
 static inline bool svm_sev_enabled(void)
@@ -526,5 +533,6 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu);
 void __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
+int sev_handle_vmgexit(struct vcpu_svm *svm);
 
 #endif
-- 
2.28.0

