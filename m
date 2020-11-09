Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8555B2AC891
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731653AbgKIW3s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:29:48 -0500
Received: from mail-bn8nam12on2051.outbound.protection.outlook.com ([40.107.237.51]:25280
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730324AbgKIW3s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:29:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dW5FA5zX/m6V+SU1DItTbLhYsD115SJIueeGOrGoF5Lqy2zCdvPH/CnoGsa00LAwbg3n/p8x3SOHUkNiEiFgfNmQaRciQ3PsZBW80sk/e4uVostQ8vFISbS6GUkIP13uwmyAwJN8tWcm1m4vtrKQerVZAzSq5ddzULLM86Tb7aAINOqKIYrdQOYEZNnKwKdomrwL/I5sxZZdTBkpilQw3c8X34A2IQoWVupvnqo2Tbf/vzJnxWPMZuYer8ZUZC3eyjyPNlA51w+0jkvPPkxyKnqGh2yuwAaVS3rIYSn5gfXvrVzl2l+zLp8WKp6TFORpH70wQs/VbpueU5cloCsdkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4whUDIkGDoc3YFPN3xOV7rvGk4hqC/8lVErlNJc6f2g=;
 b=U4mGgDLgERdIiExBLuU5ql9jNfB6YNeVc7J05HDx7SPRGzYjVgTnNJPy0qJzda8l4mSW1FrqhPXfZvhMNW4S7ICrfAwY2mtzIYmyUCg+oxGHprTlYnQb9Ms08fbQbLBTSRRDcjgzd+jCFMAA6Qh4IJ65TQnmeAiVVc92GkB1BRsX7TfUI8e6UcEuceJ2Zqng9IrEqQi9gwP8RG1IcWoUM/I5rjSRy7VuWufYBLgOjwbdec/14tRJyU3CE78hT63tv4MRaZtwyfONDhizcfvoXYaFGCID+lubdF78wYPMmENIEmEN42KEqRPCwzykc/U50pDu3tcgK+sQ7mBlyNGaqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4whUDIkGDoc3YFPN3xOV7rvGk4hqC/8lVErlNJc6f2g=;
 b=d7nvh0vOHvoBtuZw3OD9Gc641e0Q9gZAmuIW8gXeh2Mu7EKX/mvg/Lv5jJSZ+JkJ16Y1RFvqpCpmacHo/Bhpe+q4fm2En82O1CrYCK9YTeOzX4V+tBnM1AlnGjgNeucJhbNjyD7PbkYbWU4SwBUam1WhDFepdnXFXJuk+BPDD8o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:29:44 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:29:44 +0000
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
Subject: [PATCH v3 27/34] KVM: SVM: Add support for booting APs for an SEV-ES guest
Date:   Mon,  9 Nov 2020 16:25:53 -0600
Message-Id: <c4e26cb53cd6ebec95c9519f29c5cbf8b9dcf51c.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR07CA0131.namprd07.prod.outlook.com
 (2603:10b6:3:13e::21) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR07CA0131.namprd07.prod.outlook.com (2603:10b6:3:13e::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:29:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3327c07a-ce04-4d4e-e82a-08d884fef520
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB40588AE7E4BD58B579E90351ECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kCs3jkXDR7B4+ogeBL0Bk6P3D2KV0XGRNPzAKz9kaVPZAo4T3NwjKqtFSP6mu74cJnOvUqELdTZEiquU9c6lCVmDFSlzmTm7wrbBs2V6rB0wub/LEP14p4qmaTuVQYbcDMn/uRmMTQk4ctBPFOOLyS0R9pUhj2oDTVMIxpTIyC4qcSG4aouP/m+/si+ru0ALcsErviXoP6YoDlf6uJZE7zLK3i9uDcsQR7lq8975cB3uOlu+MELKmxQ6qQrSp+L2pZJSCHZX4x1Bpa2XhRDo2SrPhpgisOUFI4PlHj6czzwEsT8YUyUSsMxaQz/RQ/hBuDzLdV5eyCVobXfFvUEhaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UJ395TFVFvldRMLIsjvxvLSVtqJWTIOcz1kyaiwh6c+2EVbu704COFQXBcnLHSc1QeHDcv9DfVmjeZzwths4BhDc6EMvabe4JUSGwwdFfEBtp01FsbmGQzbQac4/W8upVwGH18/FplfTxEZ50PsnCx9fksFMd27ufh4zILLH+FJloCLer1fgAz1TQ/rWBWVwamvNxg4IWaE8difTOlR+fKZ4Erq8LhpHFEy6jabEghEaTCCFoMSQFM2/q5qQCfTb76XGKhQBs0fPfQfEbB9Z1nrR8vvV6WCfU88reOyqnKC/JtCqfSnDI9BjrOUmG7Arf7tBndjntxrrskNUVUGC5eSa3UZdpQOfLp4oamDEwV7AgFG9terAC/wroCB8Uos8xvsL/rSZELZIz/hwbkIIsNGyrvgbYb4iHbD9TQaaiNtXCJAZW8zwKOd/5Tm6p+DDcyNBHUB5QZtOFqpHOSlcm2lQ0k/nLhgPnpIZdUdov4JGie2oVlIULqaD6V5LmEmYKTom7dTdeVAHGwY9YDZQFjP+f1WmVYT2yRPdx5z8O/LnBmT3/4mQUyuCsHSByfj4JCcl+8tb+KBSnBcksCr1/2w8Z7NCgkce3UgxPJMwCCWDUXVUcqqHCM/zwNi+zCskckVHRw/uQKF3JPkfcppEhQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3327c07a-ce04-4d4e-e82a-08d884fef520
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:29:44.3788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c8d8soAjkL/FUMkZGxykwyUZIPEpAMk1fFnDTSZqUepPqC6SDioroFa2MNl4Bb5F5UpTnOSn/GxwOnnb7lgOiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
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
index 75a38dbebe79..53897564fe48 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -17,6 +17,8 @@
 #include <linux/trace_events.h>
 #include <asm/processor.h>
 
+#include <asm/trapnr.h>
+
 #include "x86.h"
 #include "svm.h"
 #include "cpuid.h"
@@ -1446,6 +1448,8 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		if (!ghcb_sw_scratch_is_valid(ghcb))
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_AP_HLT_LOOP:
+	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		break;
 	default:
@@ -1767,6 +1771,35 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
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
 		vcpu_unimpl(&svm->vcpu, "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
 			    control->exit_info_1, control->exit_info_2);
@@ -1786,3 +1819,20 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 	return kvm_sev_es_string_io(&svm->vcpu, size, port,
 				    svm->ghcb_sa, svm->ghcb_sa_len, in);
 }
+
+void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	/* First SIPI: Use the the values as initially set by the VMM */
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
index ecec3d872922..4dd33eea4a68 100644
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
index c0a33d5cdc00..1078cc89dc80 100644
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

