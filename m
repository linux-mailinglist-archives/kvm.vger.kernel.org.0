Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716022818A0
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388428AbgJBRFN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:05:13 -0400
Received: from mail-eopbgr760073.outbound.protection.outlook.com ([40.107.76.73]:5358
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388394AbgJBRFJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:05:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TMHvYfMzQ1SY7tK7RhJz+W9BMCTcdb6nFDZFPUdoG3Sk5Dm/6k1XCcyNwRTEbIXPImfrkeFiitgAoBFQ6JS5eWrPm7Buj6ZmGEfrjY8igvgDQKwQCFfGGXG6rG+zHLTfFgBhXQSSyhDRzkVgcU8Fsue0TNUN2vELI7GepootobaxnVIn+z21/i7e36U0ouhhvnkWIjePaC7ao0j7ZPdlHAxwcxr3IoCC5/4Bx1PUUDM7K4784DpjiMyE8gjKqc7MsOEwkly6tkrkkoB4LWHMNhQJRShVGIktV6UWSvPcpKJ0y8b3RFX+ktAkYxa+jL66GKFyJmOKk8SZtK1mb8KvuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0GEf4/mBfpk0dToLi7zmsJx6NNEcW8i4dPH81rJuStU=;
 b=iOfrwf2h5bK0j+ZjR5Xb5n3TqZZfcqsEUJubORJgPcJOIHdCQPJnoSqa2zBE274+dM/hAWNFVxTsUKw3W73VIH8VulwDRE64UHGnTvPI3IK0JrDiymV5ut21RZx9FGVuPBKL3nINyEZJ1o2QmDyeYL563V9vaPg9KUwPbP2DKr61VA0DPSLL8NOpwGDNKn1VEvfHYoH0yWBSeYeYaHGUa+YImNVUbiju5MSgjUAAFSM3gJccuIvMBj5YXuwQ1dvc8itEcRcW8m0mK/vMN3koB5AAc+em5uwn1fR6w0iNc2p4+P83aEhQ8cI4OJcnIo0hPDgmqNtg3gZaT/KIWl4ObQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0GEf4/mBfpk0dToLi7zmsJx6NNEcW8i4dPH81rJuStU=;
 b=igRXJEzPxUdl+LfUFZJfc0+Y/pueuRzZ77jzch5Y79m0uzG8LjkBStstkRQRuKp/3IBHKD7TlVbwln2ix7CX0REZ+wPf1xXdG+IdGnxA/YTE1eVPrbYfZ02pCQasi8prJcl7rwccyTmAXub9m5oa/lViN90Q6iY50zpAaD4l7Es=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1706.namprd12.prod.outlook.com (2603:10b6:3:10f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.38; Fri, 2 Oct 2020 17:04:45 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:04:45 +0000
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
Subject: [RFC PATCH v2 11/33] KVM: SVM: Add initial support for a VMGEXIT VMEXIT
Date:   Fri,  2 Oct 2020 12:02:35 -0500
Message-Id: <4e8c0a09a3b2992fb4cb96124ce817e4e1c8aa21.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0065.namprd11.prod.outlook.com
 (2603:10b6:806:d2::10) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SA0PR11CA0065.namprd11.prod.outlook.com (2603:10b6:806:d2::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.38 via Frontend Transport; Fri, 2 Oct 2020 17:04:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 29b0e444-8abc-4a53-07de-08d866f54356
X-MS-TrafficTypeDiagnostic: DM5PR12MB1706:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB170627EEECEF173A3A1CA27AEC310@DM5PR12MB1706.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qmb3/a3kXPx72kXVCfZMrBj1OiuD3to9Pu2+w8tiQF1ZEk0TL2N8LF7YH5AYW4I8hi/uzhIQzDFlpGEHhpMjT/IknFLWouim+REPpSm0GvpmK0p1EjJcUXZ5t/CiTeKqHGMJhJsk+c75ZNjtE7OZ+3sNB7Sq4Ben7bcwCRdvr2qJUmnz3zqyyhQZB6zLuwf3Y/pwseK4qaSgdlhaVC90NzjVPT4KhVvWf9jF8mXtDViEQwgckB06bLMNEC3IGSzkX+1sFO2M3E93ibpx9kuM48jImrm0z3y6iYNMz56e3b9IjOEhnfCdAlvBm5eIBtPLNMC4jMYUR8HuX7cFqAa3BQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(66556008)(4326008)(36756003)(66946007)(86362001)(2616005)(26005)(8676002)(5660300002)(83380400001)(6666004)(7696005)(8936002)(52116002)(2906002)(6486002)(478600001)(316002)(54906003)(66476007)(186003)(30864003)(956004)(7416002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kgXVgb6XNeaz0eypMgNDh0KecPMbtSdtmfdNanHxgwZrT6n8/eXwf9bjX9lXc7y387wrl7SvtPyAPfeRQu9C8ZBvG6YWLqQZC4auubxsAV5+IVR7lngZN3ctXixhthwJhtFvi4WJxsckB4Dsi5kQLvCbZGjB+dpDdEIDA7HAhhWorFxBCSBOpgnVq6im9y19O3VhkS6SDjyksr94Khrf+XM5sOFkyumk+dT1cXscGfdJcC4k/uO9gtldVzIKL2PxU1Dk6KSvzUccsizifQJczyJ2uRZDYT9K+VRytdxh76LFRbF29Poo79gN1UXkFiKI1JlIv7te0S7eSX88P+5HRuTPFcUtkUwpbrjuxKBL7IL5hQHAkEzBTTkhVjmmpX5QThT0UDrsw+SLvmyd/rrvggM/VyTS4dqBs9q7R2A7JG+rUUXwxXV8ojAwGWDKM3JL7ecpBEuIz1i1Cf/duC+fN37QO9To5a5X5bPUr18POe4WLWkFg4ZHII76A3Hyj6yI/7G5wil+4l54ZEv88+e37r8mnlQSt+/FOMPTOfyWXJpbHKWU++lHjrozRLPqV27tSJUYwE2UgTlnMlr5a1B1CyzXhn2L878tk4YmnKgD3NwSR92X0DHp3RvgSw6gwMmZd9WdxAEFhXJysPEvoXdvkQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29b0e444-8abc-4a53-07de-08d866f54356
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:04:45.8256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DVL4zyjYCeyeDsfBB4Z0mmQbLfEp2ej7DkqQdDgb6GbvQmyIvAM7mzS92SP58PsSIjzYYa3IIZwHl/GyjG9ynw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1706
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
 arch/x86/kvm/svm/sev.c          | 247 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |   8 +-
 arch/x86/kvm/svm/svm.h          |   8 ++
 6 files changed, 270 insertions(+), 3 deletions(-)

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
index f5f826ab4e3f..3a730238a646 100644
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
index 37c3668a774f..e2f303a332c1 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -115,6 +115,7 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 					   MSR_IA32_MISC_ENABLE_MWAIT);
 	}
 }
+EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
 
 static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9af8369450b2..06a7b63641af 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -17,6 +17,7 @@
 
 #include "x86.h"
 #include "svm.h"
+#include "cpuid.h"
 
 static int sev_flush_asids(void);
 static DECLARE_RWSEM(sev_deactivate_lock);
@@ -1189,11 +1190,202 @@ void sev_hardware_teardown(void)
 	sev_flush_asids();
 }
 
+static void dump_ghcb(struct ghcb *ghcb)
+{
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
+	pr_err("GHCB:\n");
+	pr_err("%-20s%08llx\n", "sw_exit_code", ghcb->save.sw_exit_code);
+	pr_err("%-20s%08llx\n", "sw_exit_info_1", ghcb->save.sw_exit_info_1);
+	pr_err("%-20s%08llx\n", "sw_exit_info_2", ghcb->save.sw_exit_info_2);
+	pr_err("%-20s%08llx\n", "sw_scratch", ghcb->save.sw_scratch);
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
+	 * Copy their values to the appropriate location if supplied.
+	 */
+	memset(vcpu->arch.regs, 0, sizeof(vcpu->arch.regs));
+
+	vcpu->arch.regs[VCPU_REGS_RAX] = ghcb_get_rax_if_valid(ghcb);
+	vcpu->arch.regs[VCPU_REGS_RBX] = ghcb_get_rbx_if_valid(ghcb);
+	vcpu->arch.regs[VCPU_REGS_RCX] = ghcb_get_rcx_if_valid(ghcb);
+	vcpu->arch.regs[VCPU_REGS_RDX] = ghcb_get_rdx_if_valid(ghcb);
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
+	u64 exit_code;
+
+	ghcb = svm->ghcb;
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
+	vcpu_unimpl(vcpu, "vmgexit: exit reason %#llx is not valid\n", exit_code);
+	dump_ghcb(ghcb);
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
 
@@ -1211,3 +1403,58 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
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
+		vcpu_unimpl(&svm->vcpu, "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
+			    control->exit_info_1, control->exit_info_2);
+		break;
+	default:
+		ret = svm_invoke_exit_handler(svm, exit_code);
+	}
+
+	return ret;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ccae0f63e784..db821f70e561 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -195,7 +195,7 @@ module_param(sev, int, 0444);
 int sev_es = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
 module_param(sev_es, int, 0444);
 
-static bool __read_mostly dump_invalid_vmcb = 0;
+bool __read_mostly dump_invalid_vmcb = 0;
 module_param(dump_invalid_vmcb, bool, 0644);
 
 static u8 rsm_ins_bytes[] = "\x0f\xaa";
@@ -3036,6 +3036,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_RSM]                          = rsm_interception,
 	[SVM_EXIT_AVIC_INCOMPLETE_IPI]		= avic_incomplete_ipi_interception,
 	[SVM_EXIT_AVIC_UNACCELERATED_ACCESS]	= avic_unaccelerated_access_interception,
+	[SVM_EXIT_VMGEXIT]			= sev_handle_vmgexit,
 };
 
 static void dump_vmcb(struct kvm_vcpu *vcpu)
@@ -3077,6 +3078,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%lld\n", "nested_ctl:", control->nested_ctl);
 	pr_err("%-20s%016llx\n", "nested_cr3:", control->nested_cr3);
 	pr_err("%-20s%016llx\n", "avic_vapic_bar:", control->avic_vapic_bar);
+	pr_err("%-20s%016llx\n", "ghcb:", control->ghcb_gpa);
 	pr_err("%-20s%08x\n", "event_inj:", control->event_inj);
 	pr_err("%-20s%08x\n", "event_inj_err:", control->event_inj_err);
 	pr_err("%-20s%lld\n", "virt_ext:", control->virt_ext);
@@ -3173,7 +3175,7 @@ static int svm_handle_invalid_exit(struct kvm_vcpu *vcpu, u64 exit_code)
 	return -EINVAL;
 }
 
-static int svm_invoke_exit_handler(struct vcpu_svm *svm, u64 exit_code)
+int svm_invoke_exit_handler(struct vcpu_svm *svm, u64 exit_code)
 {
 	if (svm_handle_invalid_exit(&svm->vcpu, exit_code))
 		return 0;
@@ -3189,6 +3191,8 @@ static int svm_invoke_exit_handler(struct vcpu_svm *svm, u64 exit_code)
 		return halt_interception(svm);
 	else if (exit_code == SVM_EXIT_NPF)
 		return npf_interception(svm);
+	else if (exit_code == SVM_EXIT_VMGEXIT)
+		return sev_handle_vmgexit(svm);
 #endif
 	return svm_exit_handlers[exit_code](svm);
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index e6900c62f164..67ea93b284a8 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -17,6 +17,7 @@
 
 #include <linux/kvm_types.h>
 #include <linux/kvm_host.h>
+#include <linux/bits.h>
 
 #include <asm/svm.h>
 
@@ -169,6 +170,7 @@ struct vcpu_svm {
 	/* SEV-ES support */
 	struct vmcb_save_area *vmsa;
 	struct ghcb *ghcb;
+	struct kvm_host_map ghcb_map;
 };
 
 struct svm_cpu_data {
@@ -387,6 +389,7 @@ static inline bool gif_set(struct vcpu_svm *svm)
 
 extern int sev;
 extern int sev_es;
+extern bool dump_invalid_vmcb;
 
 u32 svm_msrpm_offset(u32 msr);
 void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
@@ -398,6 +401,7 @@ bool svm_smi_blocked(struct kvm_vcpu *vcpu);
 bool svm_nmi_blocked(struct kvm_vcpu *vcpu);
 bool svm_interrupt_blocked(struct kvm_vcpu *vcpu);
 void svm_set_gif(struct vcpu_svm *svm, bool value);
+int svm_invoke_exit_handler(struct vcpu_svm *svm, u64 exit_code);
 
 /* nested.c */
 
@@ -501,6 +505,9 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 
 /* sev.c */
 
+#define GHCB_MSR_INFO_POS		0
+#define GHCB_MSR_INFO_MASK		(BIT_ULL(12) - 1)
+
 extern unsigned int max_sev_asid;
 
 static inline bool svm_sev_enabled(void)
@@ -517,5 +524,6 @@ int svm_unregister_enc_region(struct kvm *kvm,
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
 void __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
+int sev_handle_vmgexit(struct vcpu_svm *svm);
 
 #endif
-- 
2.28.0

