Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3BCA2818C0
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388555AbgJBRGz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:06:55 -0400
Received: from mail-mw2nam10on2053.outbound.protection.outlook.com ([40.107.94.53]:24864
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388176AbgJBRGy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:06:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G+ARChB4UR4r5Dzfcg+Aw/FZQbW4ESQN4//5cXYVUmMkAg4YGcPXlp2uZ9TK5McUITqGu9Re9EetPMFPUkvmcc+6lOhpakLQnmfbUN4HRjWQxEarzWgQ21oesuMvWoaX84OVkgRGbe5TRl9n2tbfT0gQ62BQJwwLa4wWuNTw0t/a+naWnrI8l15HhlIEv/yUH76ziCz7jePZYW0uNAmOpJ+x6z2E7OoTWDfDXHP17UJdmVm9Sy21uEm3nE1JHt6/cE8nGWX1M7m/yPQZvWtLr78xsCHzg4G+VJu18MA9Sfbc2sV05KgS0k7kfn98D9Huh5N9GpX9alyRstAR7Zx0vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2KlgJuLHnq7yAR0m73thWz5SptZu+rjCjMnvahWsNI=;
 b=Ffy4ZdYgguv4Zs2zDEDEswXF0QlzhGWoEkLEDFvFkfY27W81Uj2ifjPCkKoP1b1Hrq79btmxIsRMQxBVkd8zMTN6/1CCq4rQBRlrYPT0awu7aRMRW47zY8wlCgsp6FqdFuhDDrTQr0L96IgmJFGYW40fz7W4anOQCSH5Lw/w9P30nPM1BrGnBgpE8nZ79W9OM4Xu64Z0jD01YuFR0/UZthJNck6MqN1Dg+DQndXQURUOsEjm4IMACUxN9dQxCGR8Akv3cfn8wHoOHZG7iX6XxTwf8StAMqPOVGc2+180A60a3IkbrMNgV00DgrIX/u2q2Z/1K/GBT2VGluJTMsSRJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2KlgJuLHnq7yAR0m73thWz5SptZu+rjCjMnvahWsNI=;
 b=zOYHYgqZjiiwgf3FcdWheIaz7RibzoXQjASi9erKGyAulBAs0rRNWhPck7X9xWx1nxzbIeewFNQ1qTBVvh4xYZ5UQMTRJsBSrTyqKTGO/1MtM+qrZWPucix30Hb1xYDk+KRybDVrSYMHK/GTDYw0kPqKJZ70g4CjE/VTk9cF9bE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Fri, 2 Oct 2020 17:06:51 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:06:51 +0000
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
Subject: [RFC PATCH v2 26/33] KVM: SVM: Add support for booting APs for an SEV-ES guest
Date:   Fri,  2 Oct 2020 12:02:50 -0500
Message-Id: <66d0fe825c2ab5c5077f3754fb5355097ed6c1da.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0062.namprd05.prod.outlook.com
 (2603:10b6:803:41::39) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0501CA0062.namprd05.prod.outlook.com (2603:10b6:803:41::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.14 via Frontend Transport; Fri, 2 Oct 2020 17:06:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3ec2305e-7dff-41ec-efe1-08d866f58e04
X-MS-TrafficTypeDiagnostic: DM6PR12MB4218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB42186096DF00290773E24ACCEC310@DM6PR12MB4218.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fs9iPP3+Ti764B1gV6mTsdltRJWOq6YuAiat/FZshCAFQav+WqICi8Tn1bsfkK3zf4wikuEWSutprNpFDBbSs8B5jatdFsPt/HgQ9TZl7PV6OssPBDtqJGHJbI7s1XwID6XWk16kInfR+kAVTmtxbrQVkUxsAJS9wlDffZI5GxTwKH1uX/REXjmuO2yMwRM6G+Foacn/NNELF5utdJ9WVi5EbmZSqthrUPeI/+0arXkjoM0kx4jiaiZIK4epE58AvTXLK745EIjZFBYRw7P5r+37+J3idYtJwyc59l6Sa8Cc3iNULwC6LYU1iVttyW25Jqa+Ll/QY6gtJ0xaGRyC6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(8676002)(83380400001)(6486002)(2616005)(66556008)(956004)(66476007)(66946007)(52116002)(7696005)(4326008)(36756003)(5660300002)(8936002)(16526019)(186003)(2906002)(54906003)(316002)(26005)(7416002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: DmBFrKqAOtnYn6j+Nya057DvUtNNeQzfFbVkJwAfYLaQoh/Zge88HTLcTQLYpuMhHy1nAHaiIpO0JG4sJ3i/S3o0Y92Cyy6ff3ZmT7T91NPnenVGst80VJdiBbsTSXSyPQMX0Sa9ioDI0V4fkqY5K6Gce9eB38Py+6bCDayJPrWRx84tHFNg6rfhPOXWLqe7dCsygkze6+09mTkTz/QWj4MDmHjKWHUW9m3adwcJJ0oO3IWD47OUqH/9VQhco//1raBKVJp9Iru6sUE1X9zXuPdOlCVlMn3doyI+fhqSrfBIfGQLid1hQzPkNDoBfwsi+8LDpdeWCwhuUDkP2sED4JJ0ePGDP0+FTlqXVspNQ6C4vdU9x4bMVCy8/63yTQQXqVhh860sXgd1kzknqWlEy3kCrhJ5jujThraYkGwZBpGvcSmmqUmRO1AO7IiUMSRwVOMjO1ZKa2bgMEyKRV4G7v1kWFiRIbzVssDIGqZbKf0ZebIXRFGLcjkbm/G70idI+yGE/XpPxw/rqf5Qn4QLi3GvQleWmuD2kif+12QzGi4j+GoCjcWAq35JC2L3Mq5ElF9pJFTAu1x3LtPa3hFrAPZttqIE0kCNk8wpv4JhSxlu90TU0lx6xRBc+JZAp14csXolV1Gc3M38kZIKwC5zpA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ec2305e-7dff-41ec-efe1-08d866f58e04
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:06:51.0553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CP+td19h1pPY5T3oz2zImpNygfPYYdDvJkqIAHIIYgyGTfnjCLFb3lsRqM4KTsZHDfLEJM+EDunJ0d3rw0aJkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218
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
index d5ca8c6b0d5e..9218cb8a180a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1254,6 +1254,8 @@ struct kvm_x86_ops {
 
 	void (*migrate_timers)(struct kvm_vcpu *vcpu);
 	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
+
+	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f6f1bb93f172..f771173021d8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -16,6 +16,8 @@
 #include <linux/swap.h>
 #include <linux/trace_events.h>
 
+#include <asm/trapnr.h>
+
 #include "x86.h"
 #include "svm.h"
 #include "cpuid.h"
@@ -1359,6 +1361,8 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		if (!ghcb_sw_scratch_is_valid(ghcb))
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_AP_HLT_LOOP:
+	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		break;
 	default:
@@ -1674,6 +1678,35 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
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
@@ -1693,3 +1726,20 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
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
index 13560b90b81a..71be48f0113e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4391,6 +4391,11 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
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
@@ -4531,6 +4536,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
 
 	.msr_filter_changed = svm_msr_filter_changed,
+
+	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 084ba4dfd9e2..0d011f68064c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -68,6 +68,7 @@ struct kvm_sev_info {
 	int fd;			/* SEV device fd */
 	unsigned long pages_locked; /* Number of pages locked */
 	struct list_head regions_list;  /* List of registered regions */
+	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
 };
 
 struct kvm_svm {
@@ -171,6 +172,7 @@ struct vcpu_svm {
 	struct vmcb_save_area *vmsa;
 	struct ghcb *ghcb;
 	struct kvm_host_map ghcb_map;
+	bool ap_hlt_loop;
 
 	/* SEV-ES scratch area support */
 	void *ghcb_sa;
@@ -564,5 +566,6 @@ void __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
 int sev_handle_vmgexit(struct vcpu_svm *svm);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
+void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 931a17ba5cbd..c211376a1329 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10023,6 +10023,15 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
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

