Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780692F2860
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 07:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733100AbhALGiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 01:38:07 -0500
Received: from mail-bn8nam11on2050.outbound.protection.outlook.com ([40.107.236.50]:12071
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728761AbhALGiH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 01:38:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gtwyt3WxZv6DkbBP7eE6vHy8RFu2v/cjtTo2l0fzP5fm44ZOQeRvl//TeOpEAIq5ZKDXcUNumDC63LHetoI/mqE/YysQ0sDyiuj4a6cLqbqpr4lUmS2f/RlSeaHNuNoEoERAfzU5FRAjy+yT/K8DK0fr03IYQYy/dJ7Q8hj0tVGwLRbXtE4sG/f0TJeWarAEcUra46BUCiJbPkxcyA3coB8NZeRcdJeg08IdLOLtmSDlrldk5ULcodeLLw2Cp9mYa3YpKM7jHsF9RFlmsGN5InZFKDbro2zSvCR46ZII859nxSzVV5Hz2Vd8aSbYOo4gAeIx0/vUIaTWaiDG9REdhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YjM7bSN4PJGzswNu/kwmMEOxGXsI+pfEm/aZqFjgsXw=;
 b=KB2ipRP6/YOq02rkhoEXpnRXW0txT8V8Ru+IHEYy5ezDR2EsJWQoBecXcKrjvwb4YQjpznU+WPTV6W4CK9kyV9wUze4OLxY5FlJ2Vj/MyWh0k2HaW+kY2OpqPH8LiO59YPwuTSClbezyO4QZBqowzjBeJBW6TWmxD0ehtZzP97HPnoMfwt4ckxwVagcu4BkEqb7CYi3JmUEEZZT4cNZSCa22xJ/ylrtb/cczkHnJjgJUfdKWhRz+XPyj6OCs8q2IO2wD70e/lJ47oYMmPWhzTlQJi+Woj6RysgcV85axCZMwEaCDYtH0gITib1046H8VjZhQXn8x8M9nSYXuQUum7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YjM7bSN4PJGzswNu/kwmMEOxGXsI+pfEm/aZqFjgsXw=;
 b=zS3u6+Ud/07OKSRZO0PJw1/F1W6Y8BjFJ1oo8NqhkUNONN2LRgAFiSkcsoq4BMR4goyc5nl1GVvYmkAN888v4Strwbc4+OZwQGsE2rVkk4zH1pt6HbTGCAhZQv0LkzxwmVsbhjXMb8bM0UhBcVKxW2hluT+8bzJgloZ4jOC3ojY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1502.namprd12.prod.outlook.com (2603:10b6:301:10::20)
 by MW2PR12MB2409.namprd12.prod.outlook.com (2603:10b6:907:9::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 06:37:13 +0000
Received: from MWHPR12MB1502.namprd12.prod.outlook.com
 ([fe80::4d9d:16b8:3399:ce90]) by MWHPR12MB1502.namprd12.prod.outlook.com
 ([fe80::4d9d:16b8:3399:ce90%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 06:37:13 +0000
From:   Wei Huang <wei.huang2@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, seanjc@google.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, wei.huang2@amd.com, mlevitsk@redhat.com
Subject: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered by VM instructions
Date:   Tue, 12 Jan 2021 00:37:02 -0600
Message-Id: <20210112063703.539893-1-wei.huang2@amd.com>
X-Mailer: git-send-email 2.29.2
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [70.113.46.183]
X-ClientProxiedBy: SN6PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:805:de::20) To MWHPR12MB1502.namprd12.prod.outlook.com
 (2603:10b6:301:10::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from weilaptop.redhat.com (70.113.46.183) by SN6PR05CA0007.namprd05.prod.outlook.com (2603:10b6:805:de::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.2 via Frontend Transport; Tue, 12 Jan 2021 06:37:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3b7ecfb6-90e7-4e52-22a4-08d8b6c47f06
X-MS-TrafficTypeDiagnostic: MW2PR12MB2409:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW2PR12MB2409E0E41C5FB8126A35620BCFAA0@MW2PR12MB2409.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SKjhv7EqMhSRAA2mEC8IjxSoSkcZaLUZh+DT7jfTI2Pk1S1P1eJ5naAuoGg0eXEjswbutYPn2uBm1BQxJPLAvggYptkmKsblxjdIOeQBAG1VANtwy6B7q/J4zI4qTgLUKvFtzxmZxZk/lhzNupQGXrXWfU0Pu5jZapCk/RCZ9U47wWjFFMDxiyFySTKLsJ6vMGseWmrXY9+RC3la33oNQX/TVd5Atp7c5FquLJcPsEL1M0p+azRaKAd+c9qBiLT39taxtejfmyu+jZzH0kN8yqHfEyehkZ+wi/MiolBDT9E2bZkbCX0z1CoBJ1EQTyjtZjQrbElpkitibC0T2AwercISGmNF0PT6h739bSECLcJxLKphQ6XY92Q7WGLx4IELgxa1SVfphMYdhgJ0nOlX0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1502.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(366004)(396003)(39860400002)(86362001)(30864003)(6486002)(1076003)(16526019)(478600001)(6666004)(6512007)(52116002)(2906002)(956004)(2616005)(7416002)(316002)(83380400001)(8676002)(66476007)(66556008)(6506007)(4326008)(6916009)(8936002)(36756003)(186003)(26005)(5660300002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?n4HOSI/J/mCBQyWY/8BT4lDUwoAzgNnF4py6R+vw1UowglDyx9ajZHm+ZkQC?=
 =?us-ascii?Q?dJNftkCR0GDxP1dA1B7CUXRC41HEhrEXJJgv1TKkMa0FzhMU7mGHCsaQ54tM?=
 =?us-ascii?Q?BEfuw4JS2U9+uqqYWcLwr2eBLkGuE3hnslRt6JEq1YfVMJrbRtomPSIAhvBS?=
 =?us-ascii?Q?0mg5XpeB/eFQvg0/E1z3wUdfzFUNkE2ZL/CT7U4/Kn+5HDmmkHtgOJ9OBWNd?=
 =?us-ascii?Q?usUxZ26ikxP6+Un/xm8/hhaMwUultfQ7z6Vioe+/GBUiv5u+yOxKq7E/IeFh?=
 =?us-ascii?Q?F+yUpEVRKEGUIT+tJNYy6zJNrdlnBfbX6waptXoFvlz38iOk4PL8QI2IgKuF?=
 =?us-ascii?Q?Yn68/oIF0YGRMGcXZ/PNBsJe7NXlMN/yfWb7G96ZTYNk55qHggQrRiRP9NoO?=
 =?us-ascii?Q?8c6/fXt4F/hwCCitYWKIh8OYrt8/xMugdk3rEg9/uBx/B6tbLFFVZ2aIPlsa?=
 =?us-ascii?Q?BXG12FC2fk5IahgG04RFgXCc6ToSttKZbDd9eC1kSMQg0UdcwO5yD/E1yZes?=
 =?us-ascii?Q?W1tV2xnyoxDpsdy2WyYKOX0LdcvWebKiiU4TJ9fz3pETeKltqL4R7BMEGg2o?=
 =?us-ascii?Q?hNUVmINu9CAwlkiMxEAAk6MaM1anlx8Aq+QiDi7W81yifhMVMClGBBgbimSE?=
 =?us-ascii?Q?ysUcU6CFJQV0Fo53K54EwF/HsnprPpuXgMHQhUoA2pi5bNrVEognN7yd9YMD?=
 =?us-ascii?Q?TrxfBPj8OQWn0bElOCkEOF2s1U0nJKA6R2mfJl2vBcTctaMOHJzkm4KTtDYb?=
 =?us-ascii?Q?rss0XbVjNefXp4oAaGBGW1oPINGG6IwgGHU5SHDgZkU7Gl1URybYms/VgSZs?=
 =?us-ascii?Q?EfKNfjuyx7EimuXRQ7IIcUa6UlwjLs8XScedNLf9KsiIh5X0/p4gUfeCAd/T?=
 =?us-ascii?Q?jTJRtgamFbGkCVZW5fv09k851gSCPoRqLB1WdXfAngpsGr+PF+MT7z92PIqH?=
 =?us-ascii?Q?eAlerjNGugaKaBUrX8MO0CYoHOqJxZQ3OqlP4jnnf8n5qo85mgmnPcVAH7Uq?=
 =?us-ascii?Q?wC/h?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1502.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 06:37:13.2579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b7ecfb6-90e7-4e52-22a4-08d8b6c47f06
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jWYJLpuM+V72CXeRI9/v9P65sbx26HpRos8ALDOR8v/NywNatU2DFSVYc3k/nvNu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2409
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bandan Das <bsd@redhat.com>

While running VM related instructions (VMRUN/VMSAVE/VMLOAD), some AMD
CPUs check EAX against reserved memory regions (e.g. SMM memory on host)
before checking VMCB's instruction intercept. If EAX falls into such
memory areas, #GP is triggered before VMEXIT. This causes problem under
nested virtualization. To solve this problem, KVM needs to trap #GP and
check the instructions triggering #GP. For VM execution instructions,
KVM emulates these instructions; otherwise it re-injects #GP back to
guest VMs.

Signed-off-by: Bandan Das <bsd@redhat.com>
Co-developed-by: Wei Huang <wei.huang2@amd.com>
Signed-off-by: Wei Huang <wei.huang2@amd.com>
---
 arch/x86/include/asm/kvm_host.h |   8 +-
 arch/x86/kvm/mmu.h              |   1 +
 arch/x86/kvm/mmu/mmu.c          |   7 ++
 arch/x86/kvm/svm/svm.c          | 157 +++++++++++++++++++-------------
 arch/x86/kvm/svm/svm.h          |   8 ++
 arch/x86/kvm/vmx/vmx.c          |   2 +-
 arch/x86/kvm/x86.c              |  37 +++++++-
 7 files changed, 146 insertions(+), 74 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3d6616f6f6ef..0ddc309f5a14 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1450,10 +1450,12 @@ extern u64 kvm_mce_cap_supported;
  *			     due to an intercepted #UD (see EMULTYPE_TRAP_UD).
  *			     Used to test the full emulator from userspace.
  *
- * EMULTYPE_VMWARE_GP - Set when emulating an intercepted #GP for VMware
+ * EMULTYPE_PARAVIRT_GP - Set when emulating an intercepted #GP for VMware
  *			backdoor emulation, which is opt in via module param.
  *			VMware backoor emulation handles select instructions
- *			and reinjects the #GP for all other cases.
+ *			and reinjects #GP for all other cases. This also
+ *			handles other cases where #GP condition needs to be
+ *			handled and emulated appropriately
  *
  * EMULTYPE_PF - Set when emulating MMIO by way of an intercepted #PF, in which
  *		 case the CR2/GPA value pass on the stack is valid.
@@ -1463,7 +1465,7 @@ extern u64 kvm_mce_cap_supported;
 #define EMULTYPE_SKIP		    (1 << 2)
 #define EMULTYPE_ALLOW_RETRY_PF	    (1 << 3)
 #define EMULTYPE_TRAP_UD_FORCED	    (1 << 4)
-#define EMULTYPE_VMWARE_GP	    (1 << 5)
+#define EMULTYPE_PARAVIRT_GP	    (1 << 5)
 #define EMULTYPE_PF		    (1 << 6)
 
 int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 581925e476d6..1a2fff4e7140 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -219,5 +219,6 @@ int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_post_init_vm(struct kvm *kvm);
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
+bool kvm_is_host_reserved_region(u64 gpa);
 
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6d16481aa29d..c5c4aaf01a1a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -50,6 +50,7 @@
 #include <asm/io.h>
 #include <asm/vmx.h>
 #include <asm/kvm_page_track.h>
+#include <asm/e820/api.h>
 #include "trace.h"
 
 extern bool itlb_multihit_kvm_mitigation;
@@ -5675,6 +5676,12 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_slot_set_dirty);
 
+bool kvm_is_host_reserved_region(u64 gpa)
+{
+	return e820__mapped_raw_any(gpa-1, gpa+1, E820_TYPE_RESERVED);
+}
+EXPORT_SYMBOL_GPL(kvm_is_host_reserved_region);
+
 void kvm_mmu_zap_all(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7ef171790d02..74620d32aa82 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -288,6 +288,7 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 		if (!(efer & EFER_SVME)) {
 			svm_leave_nested(svm);
 			svm_set_gif(svm, true);
+			clr_exception_intercept(svm, GP_VECTOR);
 
 			/*
 			 * Free the nested guest state, unless we are in SMM.
@@ -309,6 +310,10 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 
 	svm->vmcb->save.efer = efer | EFER_SVME;
 	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
+	/* Enable GP interception for SVM instructions if needed */
+	if (efer & EFER_SVME)
+		set_exception_intercept(svm, GP_VECTOR);
+
 	return 0;
 }
 
@@ -1957,22 +1962,104 @@ static int ac_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
+static int vmload_interception(struct vcpu_svm *svm)
+{
+	struct vmcb *nested_vmcb;
+	struct kvm_host_map map;
+	int ret;
+
+	if (nested_svm_check_permissions(svm))
+		return 1;
+
+	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
+	if (ret) {
+		if (ret == -EINVAL)
+			kvm_inject_gp(&svm->vcpu, 0);
+		return 1;
+	}
+
+	nested_vmcb = map.hva;
+
+	ret = kvm_skip_emulated_instruction(&svm->vcpu);
+
+	nested_svm_vmloadsave(nested_vmcb, svm->vmcb);
+	kvm_vcpu_unmap(&svm->vcpu, &map, true);
+
+	return ret;
+}
+
+static int vmsave_interception(struct vcpu_svm *svm)
+{
+	struct vmcb *nested_vmcb;
+	struct kvm_host_map map;
+	int ret;
+
+	if (nested_svm_check_permissions(svm))
+		return 1;
+
+	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
+	if (ret) {
+		if (ret == -EINVAL)
+			kvm_inject_gp(&svm->vcpu, 0);
+		return 1;
+	}
+
+	nested_vmcb = map.hva;
+
+	ret = kvm_skip_emulated_instruction(&svm->vcpu);
+
+	nested_svm_vmloadsave(svm->vmcb, nested_vmcb);
+	kvm_vcpu_unmap(&svm->vcpu, &map, true);
+
+	return ret;
+}
+
+static int vmrun_interception(struct vcpu_svm *svm)
+{
+	if (nested_svm_check_permissions(svm))
+		return 1;
+
+	return nested_svm_vmrun(svm);
+}
+
+/* Emulate SVM VM execution instructions */
+static int svm_emulate_vm_instr(struct kvm_vcpu *vcpu, u8 modrm)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	switch (modrm) {
+	case 0xd8: /* VMRUN */
+		return vmrun_interception(svm);
+	case 0xda: /* VMLOAD */
+		return vmload_interception(svm);
+	case 0xdb: /* VMSAVE */
+		return vmsave_interception(svm);
+	default:
+		/* inject a #GP for all other cases */
+		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
+		return 1;
+	}
+}
+
 static int gp_interception(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	u32 error_code = svm->vmcb->control.exit_info_1;
-
-	WARN_ON_ONCE(!enable_vmware_backdoor);
+	int rc;
 
 	/*
-	 * VMware backdoor emulation on #GP interception only handles IN{S},
-	 * OUT{S}, and RDPMC, none of which generate a non-zero error code.
+	 * Only VMware backdoor and SVM VME errata are handled. Neither of
+	 * them has non-zero error codes.
 	 */
 	if (error_code) {
 		kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
 		return 1;
 	}
-	return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP);
+
+	rc = kvm_emulate_instruction(vcpu, EMULTYPE_PARAVIRT_GP);
+	if (rc > 1)
+		rc = svm_emulate_vm_instr(vcpu, rc);
+	return rc;
 }
 
 static bool is_erratum_383(void)
@@ -2113,66 +2200,6 @@ static int vmmcall_interception(struct vcpu_svm *svm)
 	return kvm_emulate_hypercall(&svm->vcpu);
 }
 
-static int vmload_interception(struct vcpu_svm *svm)
-{
-	struct vmcb *nested_vmcb;
-	struct kvm_host_map map;
-	int ret;
-
-	if (nested_svm_check_permissions(svm))
-		return 1;
-
-	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
-	if (ret) {
-		if (ret == -EINVAL)
-			kvm_inject_gp(&svm->vcpu, 0);
-		return 1;
-	}
-
-	nested_vmcb = map.hva;
-
-	ret = kvm_skip_emulated_instruction(&svm->vcpu);
-
-	nested_svm_vmloadsave(nested_vmcb, svm->vmcb);
-	kvm_vcpu_unmap(&svm->vcpu, &map, true);
-
-	return ret;
-}
-
-static int vmsave_interception(struct vcpu_svm *svm)
-{
-	struct vmcb *nested_vmcb;
-	struct kvm_host_map map;
-	int ret;
-
-	if (nested_svm_check_permissions(svm))
-		return 1;
-
-	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
-	if (ret) {
-		if (ret == -EINVAL)
-			kvm_inject_gp(&svm->vcpu, 0);
-		return 1;
-	}
-
-	nested_vmcb = map.hva;
-
-	ret = kvm_skip_emulated_instruction(&svm->vcpu);
-
-	nested_svm_vmloadsave(svm->vmcb, nested_vmcb);
-	kvm_vcpu_unmap(&svm->vcpu, &map, true);
-
-	return ret;
-}
-
-static int vmrun_interception(struct vcpu_svm *svm)
-{
-	if (nested_svm_check_permissions(svm))
-		return 1;
-
-	return nested_svm_vmrun(svm);
-}
-
 void svm_set_gif(struct vcpu_svm *svm, bool value)
 {
 	if (value) {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0fe874ae5498..d5dffcf59afa 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -350,6 +350,14 @@ static inline void clr_exception_intercept(struct vcpu_svm *svm, u32 bit)
 	recalc_intercepts(svm);
 }
 
+static inline bool is_exception_intercept(struct vcpu_svm *svm, u32 bit)
+{
+	struct vmcb *vmcb = get_host_vmcb(svm);
+
+	WARN_ON_ONCE(bit >= 32);
+	return vmcb_is_intercept(&vmcb->control, INTERCEPT_EXCEPTION_OFFSET + bit);
+}
+
 static inline void svm_set_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2af05d3b0590..5fac2f7cba24 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4774,7 +4774,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 			kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
 			return 1;
 		}
-		return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP);
+		return kvm_emulate_instruction(vcpu, EMULTYPE_PARAVIRT_GP);
 	}
 
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9a8969a6dd06..c3662fc3b1bc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7014,7 +7014,7 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 	++vcpu->stat.insn_emulation_fail;
 	trace_kvm_emulate_insn_failed(vcpu);
 
-	if (emulation_type & EMULTYPE_VMWARE_GP) {
+	if (emulation_type & EMULTYPE_PARAVIRT_GP) {
 		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
 		return 1;
 	}
@@ -7267,6 +7267,28 @@ static bool kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu, int *r)
 	return false;
 }
 
+static int is_vm_instr_opcode(struct x86_emulate_ctxt *ctxt)
+{
+	unsigned long rax;
+
+	if (ctxt->b != 0x1)
+		return 0;
+
+	switch (ctxt->modrm) {
+	case 0xd8: /* VMRUN */
+	case 0xda: /* VMLOAD */
+	case 0xdb: /* VMSAVE */
+		rax = kvm_register_read(emul_to_vcpu(ctxt), VCPU_REGS_RAX);
+		if (!kvm_is_host_reserved_region(rax))
+			return 0;
+		break;
+	default:
+		return 0;
+	}
+
+	return ctxt->modrm;
+}
+
 static bool is_vmware_backdoor_opcode(struct x86_emulate_ctxt *ctxt)
 {
 	switch (ctxt->opcode_len) {
@@ -7305,6 +7327,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
 	bool writeback = true;
 	bool write_fault_to_spt;
+	int vminstr;
 
 	if (unlikely(!kvm_x86_ops.can_emulate_instruction(vcpu, insn, insn_len)))
 		return 1;
@@ -7367,10 +7390,14 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		}
 	}
 
-	if ((emulation_type & EMULTYPE_VMWARE_GP) &&
-	    !is_vmware_backdoor_opcode(ctxt)) {
-		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
-		return 1;
+	if (emulation_type & EMULTYPE_PARAVIRT_GP) {
+		vminstr = is_vm_instr_opcode(ctxt);
+		if (!vminstr && !is_vmware_backdoor_opcode(ctxt)) {
+			kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
+			return 1;
+		}
+		if (vminstr)
+			return vminstr;
 	}
 
 	/*
-- 
2.27.0

