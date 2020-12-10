Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC092D63CF
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391737AbgLJRke (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:40:34 -0500
Received: from mail-bn7nam10on2082.outbound.protection.outlook.com ([40.107.92.82]:61760
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392684AbgLJRPU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:15:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mSvGHQdXf11mzhSFu9eOwZHFurJ+TbTuoLIc6ymo6DJsxbvpU+QH9g/wEKFVI3wcCBX1AeQ6dwl7B6yH9x4ThTAVGoG541TMrNuo26rzvaR5tNekgNiU1bXqHoM+MhSP9bU1NTVDPN3xkClQY4ocWesDnW+yiNM0Yok+wgg4XMTS/t9Yvw4/FpOxJH/tt08EMvVvYY1zWWzlggbYwEzyY6xKAgqlJzjbVS6/26zVqeg9F4D2XnCwiJiRrkmqPZpalrnBMQ3TDj3z27s8Rfk2pY6FAoqs5FyEfbSXGAmoyY7in6kUhMf+YYkGbI0T1Y5AQiAqvlZ6vlyEmM11Th9Qng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=br5gfulTOY3qEg58chI1Fq0V2tXF6FBvIRk4dbr0uWs=;
 b=j1dwePftNFb9ra9qAmOOM0eAwgE5NAGowOot3RwE50Rr5qXHhfVIb/q2/iMcvllAwSWWFBFSh079WJ7s8lCPc3HGLIXiM4KKhkPjJNvhL2ah09vhOpclyZG1cctm1zoGzByASbsHYknH3Kelab+0OqgCuvegL527Um8WD6ux72hRUgWbmnbv5hwvNRXY2oM2wg8xXtpwpesVsVLQ1rYFsCHT4FsX7pYgzF8BvvqiqYYZ6Y/xeJ2n6+UbqOLrIm2gQEzj07WMvvrKoj7bEUmktu9CMO11iZU1G8sNe5sC7tXrhyQH/PQz45u/cSs9dzeZFhn+UATegR1MJfBzbkkJKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=br5gfulTOY3qEg58chI1Fq0V2tXF6FBvIRk4dbr0uWs=;
 b=QpzQNoB/toIoQnzLE1PSU2L1JSvduj4UmpNon8T8bf3Fv+pCBJO2PAwj3QYZsZBOUOnxNXPpJqlOZB7KO04HROFWmHVPp+59C+THHDX+gNVpE7NHaWZ6O/RYxvQYE4rOcBbvHymVuY6JPfe3tcLMyARs6Vfe1IV2GmrLuRkPazs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1350.namprd12.prod.outlook.com (2603:10b6:903:41::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.20; Thu, 10 Dec
 2020 17:14:22 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:14:22 +0000
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
Subject: [PATCH v5 27/34] KVM: SVM: Add support for booting APs for an SEV-ES guest
Date:   Thu, 10 Dec 2020 11:10:02 -0600
Message-Id: <47d11ed1c1a48ab71858fc3cde766bf67a4612d1.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR07CA0020.namprd07.prod.outlook.com
 (2603:10b6:610:20::33) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR07CA0020.namprd07.prod.outlook.com (2603:10b6:610:20::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:14:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7ba0c636-eabb-48a4-e43b-08d89d2f09bb
X-MS-TrafficTypeDiagnostic: CY4PR12MB1350:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1350A0017FFC3EDA6B188CE3ECCB0@CY4PR12MB1350.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: htcJcJsaZPG8R3d3tHmF3+MEXDy6xIjZONxvlmHBmzfh8FaAmEXA9Mr+UiusGAzLXmDLQMcQkdJJw5pxIpj8sNI2sg0NOnoMyJumb/CMoJUFVS07NXmSOsy4r+DcBXE51EsBPviENLZl+W+dq8OUJUnKmyu47NRRr9Itc5ppM+oFMCv6xk/kvGYX2GmaufOoqdiPUU1JY+ZNJgvNmh6SRXvVPAkrh1SP1a8huyFDwWT8kOrpgeanp+NsfvT2cDx09CqZe7bLArFAbMUtquIwXkH6LVEir9zMdWcjnZIEY7mquSMecF5R8As0X5ZFVfCfWHRn2Y6YZ4PFz7oBDvPkbR/s758gu5vXVn5iHOEf6LzOx/xHN12J/TPBk3YQSQz2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(136003)(6486002)(8936002)(16526019)(2906002)(2616005)(54906003)(508600001)(86362001)(52116002)(66946007)(36756003)(6666004)(8676002)(7696005)(83380400001)(4326008)(34490700003)(956004)(26005)(66556008)(66476007)(7416002)(5660300002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pnY4zq4l46aeNVIom8tX2uMufVfapS1PjPL9V1nWRs74R1YtW11AbnvFuMn9?=
 =?us-ascii?Q?x/wUBnaReVqtPMaXGIgeDIVaye4xUq7pWgaTXIxi5Be/OxFjCwhMi4DF/bSv?=
 =?us-ascii?Q?rxKXYq7YeDgogjL7A4aHKH5WDg7rEv6Nu1JUSdRIoRTcaB+2iYG2hY2AXtoY?=
 =?us-ascii?Q?9RaYjaAhWU7iwfqBvsQgMsEbGAV0GXSbxZQdunudLaeK/LxyQNUo3k44qhEg?=
 =?us-ascii?Q?u00aAmkh3jIWNTWkqchwAZJesEi/7tRHgGY8SpraTiO0DF2eG5A02J6/aoU4?=
 =?us-ascii?Q?naAmHu5Npx+s1Q42XjKQptQ2xjXirthfN44DA7MwFUK6h/Yv9vTCyOMJyQtZ?=
 =?us-ascii?Q?G5EV6HjOckydGXrBK4xaPfxdeKmfvGYsU8od2upMxMph0jtapk5YZ+GEBdBC?=
 =?us-ascii?Q?QOtQeJV2xQNPIfqf3GcSwFJwiwbj5zWjPXdYYoR5awcDTEW4xoNh+Ry1J/4y?=
 =?us-ascii?Q?Jdbm8G4pym2P3p4OOtTiL/Behrc9KBpTpqVXPKG4o4nJciBa8mX9hVfv6Rq9?=
 =?us-ascii?Q?lORr8AfJUnZbSFTIFRH/bzH6d4DN3lsjFtar5e2sEE82H/vV3btufZQ3Ry3o?=
 =?us-ascii?Q?qjlS0lliJmiGdB3FUflNbx//0IcZQejBOoFm+TXH2DwMuTdd2G4MtkrmQ4ne?=
 =?us-ascii?Q?Z3HX0DT/UCYxr3gkwLzEbCYoS5zyv3Fe4sorczCMz6e6YzqJlO6RAHRT/BZp?=
 =?us-ascii?Q?EihO/fFPvi0rWAiNx1hlTgYtEnN3rfzxmWRcUgmhDgJpTqUwO5f5jd8WYr4M?=
 =?us-ascii?Q?XoJnziZzuAqAl6TlD7sf/vus7C7KZOvxBlgmR5JJh8dxchiQr7CuqkMJ6qEx?=
 =?us-ascii?Q?NYo8R3F9Fz9fLiegnB1GIEUtkM3K1uNpzVmEXibgFyFc5gQgSECCWj9Woyw+?=
 =?us-ascii?Q?aPqzMEfYkgDvlY6jUA3hK6PyyG6aJ2yY/CAEeiUWHTwkbp2WnQ8HnRrR7mhY?=
 =?us-ascii?Q?xLjBbyOP1XoEugsO4dFE68cS4vFkEaw0H6or4LMypz+hR6GSNDcXHxDZkqqD?=
 =?us-ascii?Q?EyH7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:14:22.3568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ba0c636-eabb-48a4-e43b-08d89d2f09bb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MO+H5fu0xcK4Pm7Q4cwhbfcjf+lHyCoSrdjRLS2UlnsxdTu8uEq4v/XlLYpnXMXWNdcedG1SeHHKffZEWxAN8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1350
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
index 048b08437c33..60a3b9d33407 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1286,6 +1286,8 @@ struct kvm_x86_ops {
 
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
index 8d22ae25a0f8..2dbc20701ef5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4400,6 +4400,11 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
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
@@ -4541,6 +4546,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
 
 	.msr_filter_changed = svm_msr_filter_changed,
+
+	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index b3f03dede6ac..5d570d5a6a2c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -68,6 +68,7 @@ struct kvm_sev_info {
 	int fd;			/* SEV device fd */
 	unsigned long pages_locked; /* Number of pages locked */
 	struct list_head regions_list;  /* List of registered regions */
+	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
 };
 
 struct kvm_svm {
@@ -174,6 +175,7 @@ struct vcpu_svm {
 	struct vmcb_save_area *vmsa;
 	struct ghcb *ghcb;
 	struct kvm_host_map ghcb_map;
+	bool ap_hlt_loop;
 
 	/* SEV-ES scratch area support */
 	void *ghcb_sa;
@@ -574,5 +576,6 @@ void sev_hardware_teardown(void);
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
 int sev_handle_vmgexit(struct vcpu_svm *svm);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
+void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ddd614a76744..4fd216b61a89 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10144,6 +10144,15 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
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

