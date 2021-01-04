Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9E92E9EC3
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 21:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbhADUVJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 15:21:09 -0500
Received: from mail-bn8nam12on2081.outbound.protection.outlook.com ([40.107.237.81]:39169
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727814AbhADUVI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jan 2021 15:21:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jMIuqcQpFNEHiQie9VkHM3ldtzxuHXQTodsmvCvbfLKgKa0c/nx1CRgOVdmiPeEtSW2TfQzutPI/a27qTu3dE7AwrQtpW4lkLWwhDC1WCZZkwbeOe6ZrlWBgIBZBykIChjQ1rY99a4qAEIzEuZJa/M/8unsNXNrYjpqdzB1XEEaN4sREr4TtQ3GXa9bdrdgfRd8OomJbFIBCIEGnE9IFm0zO1lNqaHY6YfJPxN6gQ5QYyTuimYkOMtx0Lspu5tooW1s5Fgk0+YB1/pD/SH3ejCvV7sATf6HBegtnD3AmLFvthK9PPIk9W/AcjLpRGaXiROoURAQAItc2Ujmz5wslRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yn13YlU2z6nyPHkkTK3qxGAAfKBZrfs5leeI/s8x5O8=;
 b=E3DPnmVfndKTu1ImtGyP4uxQQoIfctlGmThizSuH6jIQI2gzJ872MvMkDyruvqCxvWGwxg/opRZvmfRuapf+6L/fuUi4xhNbj9idraeapI1/4D/uGNibcFR/APQy+oKtdEyFci7rZIm77iGmBplE19rwf1P9XFCozIx4kVCIxASePRQ35N2LQyHhvp4I7JBGJ3+Ma+DwNoL2xT/LcV9Zat+BvvlD4GTKGpvx5+LQII0rklRihQOuJOOVkkAMZ21hJPTm6WdosBozuMs+XrKlBgJ9bFj9lJArtoARLhAP9XtIanTW5PXxstHufD8FJXSrCEYpvifU3zIJ4KxB0eykrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yn13YlU2z6nyPHkkTK3qxGAAfKBZrfs5leeI/s8x5O8=;
 b=E4o+O1Sf5L0Hu8sfXlN7FI3+KsyI/Ww2RzsRLLxzfRFTRbZpXVejbvpCxJe6Uy8FyS5sC3Q8yWiLR55rAJpzoc7cCYVIbK7SVat0mVLUWJyRKWjWf8jHTpc5jx4NBs50DRPkXYmjkKI7pthiTNrnEC7ho5MFb6FNc4Jm8lBPVCU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB4679.namprd12.prod.outlook.com (2603:10b6:4:a2::37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3700.27; Mon, 4 Jan 2021 20:20:13 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3721.024; Mon, 4 Jan 2021
 20:20:13 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v5.1 27/34] KVM: SVM: Add support for booting APs in an SEV-ES guest
Date:   Mon,  4 Jan 2021 14:20:01 -0600
Message-Id: <e8fbebe8eb161ceaabdad7c01a5859a78b424d5e.1609791600.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <47d11ed1c1a48ab71858fc3cde766bf67a4612d1.1607620209.git.thomas.lendacky@amd.com>
References: <47d11ed1c1a48ab71858fc3cde766bf67a4612d1.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0801CA0007.namprd08.prod.outlook.com
 (2603:10b6:803:29::17) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0801CA0007.namprd08.prod.outlook.com (2603:10b6:803:29::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20 via Frontend Transport; Mon, 4 Jan 2021 20:20:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 73b582f5-f2e0-4826-f017-08d8b0ee2457
X-MS-TrafficTypeDiagnostic: DM5PR12MB4679:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB4679C55083E912D6BEEF5BBBECD20@DM5PR12MB4679.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BMaks64dcmlVFeP/Jl2TNqLMnzu3p9dS+fSRQfIiLiOP4NpXyVmatPFPIaNJ02ITmjaMqp5NWTPCs3L9NB1DHLY7PWFuOIoR4z344g2E8qse+sV7CBk9oKqzJRyB6PTeAV6t3ABNEcGRpuiz+62U240aTmRk2yMQ+kWH59xSwZ8jgBoKAy5mGxoHI8zGLjDlB943uC5ZGGf7OKR7epjGFouoTIW0vcD3jOqEDVl86bZDbGj/cUG8cn5E+Nio49+6+cH5KwLFFwBSePkQlrAzlw8M3PMsS7+3Ak70RLDA9kNpEcaiL5Ea38P9oaLfFpNnUck+h8RnvlXHRl44bgD12A0+YKfKNAMI+HO1tAK70QmKgedq2imkJrrAujG+osSFXTVTrPYrDEIuToGAwx+2wQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(8676002)(54906003)(36756003)(5660300002)(4326008)(16526019)(8936002)(316002)(956004)(2616005)(2906002)(6486002)(86362001)(26005)(7416002)(83380400001)(186003)(52116002)(6666004)(66476007)(7696005)(66556008)(66946007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?MuMCxmjxQ4OoJ2aO2Kvb9lt7cJ7bL5DrmsVcSu3Zhnm/LDU8eGVuli3iD6r9?=
 =?us-ascii?Q?yXqg1vd6AQl4Rjpv6f7vP1buN60qI27ER5G3T5GvhldP7hQgetQujEv73qsf?=
 =?us-ascii?Q?b1XmIUWe7zL6wl0vK3SReqwQEm+2sgj3VVEmZ8lF895KtiaXEi6h2xQ1COP1?=
 =?us-ascii?Q?aUcIZb9s4vkUS6QfOehKDYiTx1ICRBk/lJBLHUWz/01qY49PJUTb59z6nD08?=
 =?us-ascii?Q?JakwSPWujp/8YxrVKjekr+iW9xM/24sQMpAF2nPRZFpRjqL6H+/TKUF1oSIp?=
 =?us-ascii?Q?MVNfEevNlV0MokHj/DSYLnmoWaKsEWRyEnemnnz89jP9JTPdz6hkPI15zLVn?=
 =?us-ascii?Q?+HuPvk4xj/ncorB+POX6psDMVboqc1A6TXYM9KUsGUYMxjywBW4/2gZEAo4Y?=
 =?us-ascii?Q?K8m1YUE9f72NLybea3MsKUDkXYMigdZXhFrkernLD0wdBzcw3GN11PxPPObQ?=
 =?us-ascii?Q?v9r9CW6P7o7DikDE9wKtyTFffZ8REwF6DduRpo6F8P508VHX1UV1U/PaoyQB?=
 =?us-ascii?Q?7SGLiDjSTnlCAKb9WdibJ02DANOnEdvQZ2Z9t7eDPfHb9R8mDcjavj4KOtfP?=
 =?us-ascii?Q?RHTNR4uw3zzQ28pAdhRdM9c/Elazf73gFC7PDLVsj0Ikd48D25SzFuK0rJMQ?=
 =?us-ascii?Q?OEz7JuNjRTz19izJKJfm55nsISgoYD+CSLuMZurtvm8HkSbgzb5vIy/mOzHd?=
 =?us-ascii?Q?4vfzs5F5UIN79fqs/F7lPgTk1u3ja22fAboR1oXYaEgqaknL7Xw0qMAzSM0Q?=
 =?us-ascii?Q?wakv2/vsH3cMZVaK5Mdkwin971jqgNTw4QA75M1K8ngbO6Jhb8f9iYy5q8oN?=
 =?us-ascii?Q?SjHDzpjxIFIWR9wrZudrj1mm1kky7cNrC2GdnIMEaIGvIwf3+P5bmAuOTPs4?=
 =?us-ascii?Q?XhZ85r4sALBjffc9t/SKREYQ92KK2IRgUBoO9dNyhsGr55SlLeUFYcopodou?=
 =?us-ascii?Q?QO3iM6RAwtrvU1bpMcSumCnHG8CCr2jLqsCY5LAknAJDs08QW8MIbOjI6s2T?=
 =?us-ascii?Q?OviM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2021 20:20:12.9373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 73b582f5-f2e0-4826-f017-08d8b0ee2457
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BkKmV+njnjUHvHf2f1AxYoOeR2e+slf7etRUhxq31kAxgd/SAg6BKkN8BCYDG9JG9zL3eZCukC1ISpr7xd1R1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB4679
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

  To differentiate between an actual HLT and an AP Reset Hold, a new MP
  state is introduced, KVM_MP_STATE_AP_RESET_HOLD, which the vCPU is
  placed in upon receiving the AP Reset Hold exit event. Additionally, to
  communicate the AP Reset Hold exit event up to userspace (if needed), a
  new exit reason is introduced, KVM_EXIT_AP_RESET_HOLD.

A new x86 ops function is introduced, vcpu_deliver_sipi_vector, in order
to accomplish AP booting. For VMX, vcpu_deliver_sipi_vector is set to the
original SIPI delivery function, kvm_vcpu_deliver_sipi_vector(). SVM adds
a new function that, for non SEV-ES guests, invokes the original SIPI
delivery function, kvm_vcpu_deliver_sipi_vector(), but for SEV-ES guests,
implements the logic above.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/lapic.c            |  2 +-
 arch/x86/kvm/svm/sev.c          | 22 ++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          | 10 ++++++++++
 arch/x86/kvm/svm/svm.h          |  2 ++
 arch/x86/kvm/vmx/vmx.c          |  2 ++
 arch/x86/kvm/x86.c              | 26 +++++++++++++++++++++-----
 include/uapi/linux/kvm.h        |  2 ++
 8 files changed, 63 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 39707e72b062..23d7b203c060 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1287,6 +1287,8 @@ struct kvm_x86_ops {
 	void (*migrate_timers)(struct kvm_vcpu *vcpu);
 	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
 	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
+
+	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
 };
 
 struct kvm_x86_nested_ops {
@@ -1468,6 +1470,7 @@ int kvm_fast_pio(struct kvm_vcpu *vcpu, int size, unsigned short port, int in);
 int kvm_emulate_cpuid(struct kvm_vcpu *vcpu);
 int kvm_emulate_halt(struct kvm_vcpu *vcpu);
 int kvm_vcpu_halt(struct kvm_vcpu *vcpu);
+int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu);
 int kvm_emulate_wbinvd(struct kvm_vcpu *vcpu);
 
 void kvm_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 6a87623aa578..a2f08ed777d8 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2898,7 +2898,7 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 			/* evaluate pending_events before reading the vector */
 			smp_rmb();
 			sipi_vector = apic->sipi_vector;
-			kvm_vcpu_deliver_sipi_vector(vcpu, sipi_vector);
+			kvm_x86_ops.vcpu_deliver_sipi_vector(vcpu, sipi_vector);
 			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 		}
 	}
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e57847ff8bd2..a08cbc04cb4d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1563,6 +1563,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 			goto vmgexit_err;
 		break;
 	case SVM_VMGEXIT_NMI_COMPLETE:
+	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		break;
@@ -1888,6 +1889,9 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_NMI_COMPLETE:
 		ret = svm_invoke_exit_handler(svm, SVM_EXIT_IRET);
 		break;
+	case SVM_VMGEXIT_AP_HLT_LOOP:
+		ret = kvm_emulate_ap_reset_hold(&svm->vcpu);
+		break;
 	case SVM_VMGEXIT_AP_JUMP_TABLE: {
 		struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
 
@@ -2040,3 +2044,21 @@ void sev_es_vcpu_put(struct vcpu_svm *svm)
 		wrmsrl(host_save_user_msrs[i].index, svm->host_user_msrs[i]);
 	}
 }
+
+void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	/* First SIPI: Use the values as initially set by the VMM */
+	if (!svm->received_first_sipi) {
+		svm->received_first_sipi = true;
+		return;
+	}
+
+	/*
+	 * Subsequent SIPI: Return from an AP Reset Hold VMGEXIT, where
+	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
+	 * non-zero value.
+	 */
+	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 941e5251e13f..5c37fa68ee56 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4382,6 +4382,14 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 		   (vmcb_is_intercept(&svm->vmcb->control, INTERCEPT_INIT));
 }
 
+static void svm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
+{
+	if (!sev_es_guest(vcpu->kvm))
+		return kvm_vcpu_deliver_sipi_vector(vcpu, vector);
+
+	sev_vcpu_deliver_sipi_vector(vcpu, vector);
+}
+
 static void svm_vm_destroy(struct kvm *kvm)
 {
 	avic_vm_destroy(kvm);
@@ -4524,6 +4532,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.msr_filter_changed = svm_msr_filter_changed,
 	.complete_emulated_msr = svm_complete_emulated_msr,
+
+	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5431e6335e2e..0fe874ae5498 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -185,6 +185,7 @@ struct vcpu_svm {
 	struct vmcb_save_area *vmsa;
 	struct ghcb *ghcb;
 	struct kvm_host_map ghcb_map;
+	bool received_first_sipi;
 
 	/* SEV-ES scratch area support */
 	void *ghcb_sa;
@@ -591,6 +592,7 @@ void sev_es_init_vmcb(struct vcpu_svm *svm);
 void sev_es_create_vcpu(struct vcpu_svm *svm);
 void sev_es_vcpu_load(struct vcpu_svm *svm, int cpu);
 void sev_es_vcpu_put(struct vcpu_svm *svm);
+void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 
 /* vmenter.S */
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 75c9c6a0a3a4..2af05d3b0590 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7707,6 +7707,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.msr_filter_changed = vmx_msr_filter_changed,
 	.complete_emulated_msr = kvm_complete_insn_gp,
 	.cpu_dirty_log_size = vmx_cpu_dirty_log_size,
+
+	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
 };
 
 static __init int hardware_setup(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 648c677b12e9..660683a70b79 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7974,17 +7974,22 @@ void kvm_arch_exit(void)
 	kmem_cache_destroy(x86_fpu_cache);
 }
 
-int kvm_vcpu_halt(struct kvm_vcpu *vcpu)
+int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
 {
 	++vcpu->stat.halt_exits;
 	if (lapic_in_kernel(vcpu)) {
-		vcpu->arch.mp_state = KVM_MP_STATE_HALTED;
+		vcpu->arch.mp_state = state;
 		return 1;
 	} else {
-		vcpu->run->exit_reason = KVM_EXIT_HLT;
+		vcpu->run->exit_reason = reason;
 		return 0;
 	}
 }
+
+int kvm_vcpu_halt(struct kvm_vcpu *vcpu)
+{
+	return __kvm_vcpu_halt(vcpu, KVM_MP_STATE_HALTED, KVM_EXIT_HLT);
+}
 EXPORT_SYMBOL_GPL(kvm_vcpu_halt);
 
 int kvm_emulate_halt(struct kvm_vcpu *vcpu)
@@ -7998,6 +8003,14 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_halt);
 
+int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu)
+{
+	int ret = kvm_skip_emulated_instruction(vcpu);
+
+	return __kvm_vcpu_halt(vcpu, KVM_MP_STATE_AP_RESET_HOLD, KVM_EXIT_AP_RESET_HOLD) && ret;
+}
+EXPORT_SYMBOL_GPL(kvm_emulate_ap_reset_hold);
+
 #ifdef CONFIG_X86_64
 static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
 			        unsigned long clock_type)
@@ -9092,6 +9105,7 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 	kvm_apic_accept_events(vcpu);
 	switch(vcpu->arch.mp_state) {
 	case KVM_MP_STATE_HALTED:
+	case KVM_MP_STATE_AP_RESET_HOLD:
 		vcpu->arch.pv.pv_unhalted = false;
 		vcpu->arch.mp_state =
 			KVM_MP_STATE_RUNNABLE;
@@ -9518,8 +9532,9 @@ int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 		kvm_load_guest_fpu(vcpu);
 
 	kvm_apic_accept_events(vcpu);
-	if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED &&
-					vcpu->arch.pv.pv_unhalted)
+	if ((vcpu->arch.mp_state == KVM_MP_STATE_HALTED ||
+	     vcpu->arch.mp_state == KVM_MP_STATE_AP_RESET_HOLD) &&
+	    vcpu->arch.pv.pv_unhalted)
 		mp_state->mp_state = KVM_MP_STATE_RUNNABLE;
 	else
 		mp_state->mp_state = vcpu->arch.mp_state;
@@ -10150,6 +10165,7 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	kvm_set_segment(vcpu, &cs, VCPU_SREG_CS);
 	kvm_rip_write(vcpu, 0);
 }
+EXPORT_SYMBOL_GPL(kvm_vcpu_deliver_sipi_vector);
 
 int kvm_arch_hardware_enable(void)
 {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 886802b8ffba..374c67875cdb 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -251,6 +251,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_X86_RDMSR        29
 #define KVM_EXIT_X86_WRMSR        30
 #define KVM_EXIT_DIRTY_RING_FULL  31
+#define KVM_EXIT_AP_RESET_HOLD    32
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -573,6 +574,7 @@ struct kvm_vapic_addr {
 #define KVM_MP_STATE_CHECK_STOP        6
 #define KVM_MP_STATE_OPERATING         7
 #define KVM_MP_STATE_LOAD              8
+#define KVM_MP_STATE_AP_RESET_HOLD     9
 
 struct kvm_mp_state {
 	__u32 mp_state;
-- 
2.29.2

