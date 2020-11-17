Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695D42B6B59
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729501AbgKQRLp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:11:45 -0500
Received: from mail-dm6nam11on2064.outbound.protection.outlook.com ([40.107.223.64]:13792
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728724AbgKQRLo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:11:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KQaseQxkbOsMf46Hg2NaKt4esWEiHNQM8pgz7HmoBeP5Swnjhu13uf5nALFOMYftyFQ12fbXxWi3UGv5poMjGvBQcRo5k9W3EkG4kyxxJo/cZzCD6KmQr+LOaqlrU7cabBEDr7fG0Pfo9xjytuzVBAVdZNsUaNDrrnQR1f7mJrSxbm7smy7EU/xs94cpe7MNOgElBdVFpnH9agPppsjPP8UYnk33F1AZlmj6pdXsAu4CVp4ltThZjJpWVCwyfv2iFEb5vDdxpp+4npHxHb3WkEjL/LTnokFP3NtylG4zxKBp52y8mea11JOe9mWga65fwVc/EbFr7eBOXljA6Y2bnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GnnVXjC2/dvrAuLfnDzNHdYHQWKR4HYj51b3d7TBub4=;
 b=R6JmkvzzSDzs8tIsVkUj3xueOwK6A55kTFog/EqeeaacYu4qh/TkOb+lMe4TJx6A/57AvfN8hV63YL8JkxXJf3a8zwL4sDSLoa0ucJa8p6vednWHZEJdaM565HA4bOXHZnQSX5UyrQvIgWVrJxpwI8AiLneJcjgLIk2bvPGXC3LO36833+WA7Cr0wLQakLlhxVMUOXBYPiLCWCLXJMdZCspw7vrojsZhpEXtjiaoW5tzSB8oYik0F3TDIXMKhqFodXgIZhmqffmY234FQSWFOo1sqodGYGeInia3FwiGx1TwM4lNhHfan4Vt6Ei+47/a2ygBjSfz7r5PNYwkAhWu5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GnnVXjC2/dvrAuLfnDzNHdYHQWKR4HYj51b3d7TBub4=;
 b=sLwzdVcWA+STdZKUXg5o6XzhJNmlsXE6l3ZFsd3tdl3Tk4Q6JtZJRgqAj3e/x0klStzqAV5NQReq/cOGfwoTpOcNKNASzs9dojetX5rkLSgSViGvMRgYE8ph3XW/8rGFz8864+4Cy8dhqa6vPCc2VPq2uxR1f8eJVM0sTXqYXBk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:11:39 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:11:38 +0000
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
Subject: [PATCH v4 27/34] KVM: SVM: Add support for booting APs for an SEV-ES guest
Date:   Tue, 17 Nov 2020 11:07:30 -0600
Message-Id: <9fb517abf40eb4eb16f0799922d6fcb6a4855c9f.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0153.namprd05.prod.outlook.com
 (2603:10b6:803:2c::31) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0501CA0153.namprd05.prod.outlook.com (2603:10b6:803:2c::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.15 via Frontend Transport; Tue, 17 Nov 2020 17:11:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 60d5bd33-feaf-4fcd-fbbd-08d88b1bd889
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB177229AE21ECEE2D87ACAFC3ECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oa0nUIRFl/d5Zn2AX5AZGJhU4DcYcbJgz4E/xlmNtUBJ1ECMCvq4A8l91g9zi4bgW3+OKXwo6rgDDEaJPoLNAcNIPkjkmn6+ugb67xkIyWaB48ofn8VM7/Mq0ZED8RUva9KUaXt3qnWzL8ZfTkH4vG6oANs2WNuJYtTg6c3FgDSwSHK66Wbg/z2Rl9nLzbStx7lfjv4e9NllyNVdFVCPU/idNZzPWFcLyF5BKisllxuqaXH9eNC52xbGvohdeXLqS9/p6cf60Te2cP+KHnCqeE+HxZRau01Xb0vFOtzCk/GKgKvwPWfPSVA52DSUnfsWsgNbjteTpunu0YlhiJoO5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(498600001)(26005)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(8676002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ixCQ4ne+6lboTLGhBXVY70aeoozAkEcWMKBqL20umwGtSd0jcCpQWQYRpElpkxIkwz9nWd845a+7ynPDHyHpC6vjikDowbUOE97UWLq/qyW1nz/aD/BZ/BJoJQItE7v2pdx4HSvoNsi8wb7pMIaqZkEpUTWQdzjyUPnNYgSNufw9D5Ec+Wrw413q+ShUoYJU2GrDWVtC/BVBrvhIfPY6x0EZYNZZYrV2yjU66QA6YXOvUkr7umK4Pt0INwkCFlOYzngSIRFymaOcqJKjCv/pTOccaZsWvOFOMiT8kXPMigttWfYYwHoi71vJSqMnRf/ZNsoSBMy6xVRwVcDGv+8kSWy+/h1rf14Sbz7t8eWlj71IJm8YrXEmQuCSO54P5jMu9IIixMVTgCoAk2LqK70igde2i3nKV5CK0oN2iSCOq33j6SnqQwlTGVVkKMwsCQ/pWgP8SIuR3nPmbgIOqBVR1tsUc9+OaHcFdabhQkgTEaf/nX+4RAPK/vB/mR7CvbL71mYeD9ReFdL/2d+6M8IyH4o1UUPdXCctYYV7S6/CfnAf1KJarAqB/SUclQJcbsJl1phsPKpf2gTJklX9v197I749qTtotYQKz0BQ4KQNCyCBBc0uLD8AkJg8YA/DFg2HeoYqrlrsZ+Ro1YOaCr/+LQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60d5bd33-feaf-4fcd-fbbd-08d88b1bd889
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:11:38.8013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ISSYXK8CRrEN7CFgdynz5ZY6fbCgZcydVgPL1p/7BoamfN96xSP879CwsK57F9AQhbBkT530SQITufNLmJGfgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Typically under KVM, an AP is booted using the INIT-SIPI-SIPI sequence,
where the guest vCPU register state is updated and then the vCPU is VMRUN
to begin execution of the AP. For an SEV-ES guest, this won't work because
the guest register state is encrypted.

Following the GHCB specification, the hypervisor must not alter the guest
register state, so KVM must track an AP/vCPU boot. Should the guest want
to park the AP, it must use the AP Reset Hold exit event in place of, for
example, a HLT loop.

First AP boot (first INIT-SIPI-SIPI sequence):
  Execute the AP (vCPU) as it was initialized and measured by the SEV-ES
  support. It is up to the guest to transfer control of the AP to the
  proper location.

Subsequent AP boot:
  KVM will expect to receive an AP Reset Hold exit event indicating that
  the vCPU is being parked and will require an INIT-SIPI-SIPI sequence to
  awaken it. When the AP Reset Hold exit event is received, KVM will place
  the vCPU into a simulated HLT mode. Upon receiving the INIT-SIPI-SIPI
  sequence, KVM will make the vCPU runnable. It is again up to the guest
  to then transfer control of the AP to the proper location.

The GHCB specification also requires the hypervisor to save the address of
an AP Jump Table so that, for example, vCPUs that have been parked by UEFI
can be started by the OS. Provide support for the AP Jump Table set/get
exit code.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/svm/sev.c          | 50 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |  7 +++++
 arch/x86/kvm/svm/svm.h          |  3 ++
 arch/x86/kvm/x86.c              |  9 ++++++
 5 files changed, 71 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3ef63ab71701..78b97071e1c2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1283,6 +1283,8 @@ struct kvm_x86_ops {
 
 	void (*migrate_timers)(struct kvm_vcpu *vcpu);
 	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
+
+	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a7531de760b5..b47285384b1f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -17,6 +17,8 @@
 #include <linux/processor.h>
 #include <linux/trace_events.h>
 
+#include <asm/trapnr.h>
+
 #include "x86.h"
 #include "svm.h"
 #include "cpuid.h"
@@ -1449,6 +1451,8 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		if (!ghcb_sw_scratch_is_valid(ghcb))
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_AP_HLT_LOOP:
+	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		break;
 	default:
@@ -1770,6 +1774,35 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
 					    control->exit_info_2,
 					    svm->ghcb_sa);
 		break;
+	case SVM_VMGEXIT_AP_HLT_LOOP:
+		svm->ap_hlt_loop = true;
+		ret = kvm_emulate_halt(&svm->vcpu);
+		break;
+	case SVM_VMGEXIT_AP_JUMP_TABLE: {
+		struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
+
+		switch (control->exit_info_1) {
+		case 0:
+			/* Set AP jump table address */
+			sev->ap_jump_table = control->exit_info_2;
+			break;
+		case 1:
+			/* Get AP jump table address */
+			ghcb_set_sw_exit_info_2(ghcb, sev->ap_jump_table);
+			break;
+		default:
+			pr_err("svm: vmgexit: unsupported AP jump table request - exit_info_1=%#llx\n",
+			       control->exit_info_1);
+			ghcb_set_sw_exit_info_1(ghcb, 1);
+			ghcb_set_sw_exit_info_2(ghcb,
+						X86_TRAP_UD |
+						SVM_EVTINJ_TYPE_EXEPT |
+						SVM_EVTINJ_VALID);
+		}
+
+		ret = 1;
+		break;
+	}
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(&svm->vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
@@ -1790,3 +1823,20 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 	return kvm_sev_es_string_io(&svm->vcpu, size, port,
 				    svm->ghcb_sa, svm->ghcb_sa_len, in);
 }
+
+void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	/* First SIPI: Use the values as initially set by the VMM */
+	if (!svm->ap_hlt_loop)
+		return;
+
+	/*
+	 * Subsequent SIPI: Return from an AP Reset Hold VMGEXIT, where
+	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
+	 * non-zero value.
+	 */
+	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
+	svm->ap_hlt_loop = false;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 63a609a8abf6..f4b9501fe0ea 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4380,6 +4380,11 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 		   (vmcb_is_intercept(&svm->vmcb->control, INTERCEPT_INIT));
 }
 
+static void svm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
+{
+	sev_vcpu_deliver_sipi_vector(vcpu, vector);
+}
+
 static void svm_vm_destroy(struct kvm *kvm)
 {
 	avic_vm_destroy(kvm);
@@ -4520,6 +4525,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
 
 	.msr_filter_changed = svm_msr_filter_changed,
+
+	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1c1399b9516a..4529c9487c4a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -68,6 +68,7 @@ struct kvm_sev_info {
 	int fd;			/* SEV device fd */
 	unsigned long pages_locked; /* Number of pages locked */
 	struct list_head regions_list;  /* List of registered regions */
+	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
 };
 
 struct kvm_svm {
@@ -173,6 +174,7 @@ struct vcpu_svm {
 	struct vmcb_save_area *vmsa;
 	struct ghcb *ghcb;
 	struct kvm_host_map ghcb_map;
+	bool ap_hlt_loop;
 
 	/* SEV-ES scratch area support */
 	void *ghcb_sa;
@@ -573,5 +575,6 @@ void sev_hardware_teardown(void);
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
 int sev_handle_vmgexit(struct vcpu_svm *svm);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
+void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 27b9243f2f68..a0eca41eaa33 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10136,6 +10136,15 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 {
 	struct kvm_segment cs;
 
+	/*
+	 * Guests with protected state can't have their state altered by KVM,
+	 * call the vcpu_deliver_sipi_vector() x86 op for processing.
+	 */
+	if (vcpu->arch.guest_state_protected) {
+		kvm_x86_ops.vcpu_deliver_sipi_vector(vcpu, vector);
+		return;
+	}
+
 	kvm_get_segment(vcpu, &cs, VCPU_SREG_CS);
 	cs.selector = vector << 8;
 	cs.base = vector << 12;
-- 
2.28.0

