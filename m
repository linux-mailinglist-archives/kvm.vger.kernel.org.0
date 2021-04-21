Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B747E366DB2
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 16:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243396AbhDUOHt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 10:07:49 -0400
Received: from linux.microsoft.com ([13.77.154.182]:37076 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243335AbhDUOHi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 10:07:38 -0400
Received: from viremana-dev.fwjladdvyuiujdukmejncen4mf.xx.internal.cloudapp.net (unknown [13.66.132.26])
        by linux.microsoft.com (Postfix) with ESMTPSA id 2C23A20B83DA;
        Wed, 21 Apr 2021 07:07:05 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2C23A20B83DA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1619014025;
        bh=9VZ4y1AWsZLKKiH5mP19ELq26qF0u/SuC/USEFqtiFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q2xXHYHxwjt4N0SegDTsaI3+JdXnJCNpemQ7XI2sfHmKFFtoWAW5KtHFux4Gpw+1S
         Gg5DB/Y03YvS76WDHru31QnQuRoOotIlQPhIr4EIAmARNhl8IvC47uFDLAbmFYskiF
         JRiEFG82xwqpSZe45xuNjgw8hsShj5P9wJogAZ3w=
From:   Vineeth Pillai <viremana@linux.microsoft.com>
To:     Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Cc:     Vineeth Pillai <viremana@linux.microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: [PATCH v3 5/7] KVM: SVM: hyper-v: Remote TLB flush for SVM
Date:   Wed, 21 Apr 2021 14:06:52 +0000
Message-Id: <784f9a121078d7ed0793ec2e8f4a0732266213ff.1619013347.git.viremana@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1619013347.git.viremana@linux.microsoft.com>
References: <cover.1619013347.git.viremana@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable remote TLB flush for SVM.

Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
---
 arch/x86/kvm/svm/svm.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9a241a0806cd..79d27a9f4b7c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -37,6 +37,7 @@
 #include <asm/spec-ctrl.h>
 #include <asm/cpu_device_id.h>
 #include <asm/traps.h>
+#include <asm/mshyperv.h>
 
 #include <asm/virtext.h>
 #include "trace.h"
@@ -44,6 +45,9 @@
 #include "svm.h"
 #include "svm_ops.h"
 
+#include "hyperv.h"
+#include "kvm_onhyperv.h"
+
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
 MODULE_AUTHOR("Qumranet");
@@ -931,6 +935,8 @@ static __init void svm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
 }
 
+static struct kvm_x86_ops svm_x86_ops;
+
 static __init int svm_hardware_setup(void)
 {
 	int cpu;
@@ -1000,6 +1006,16 @@ static __init int svm_hardware_setup(void)
 	kvm_configure_mmu(npt_enabled, get_max_npt_level(), PG_LEVEL_1G);
 	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
 
+#if IS_ENABLED(CONFIG_HYPERV)
+	if (ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB
+	    && npt_enabled) {
+		pr_info("kvm: Hyper-V enlightened NPT TLB flush enabled\n");
+		svm_x86_ops.tlb_remote_flush = kvm_hv_remote_flush_tlb;
+		svm_x86_ops.tlb_remote_flush_with_range =
+				kvm_hv_remote_flush_tlb_with_range;
+	}
+#endif
+
 	if (nrips) {
 		if (!boot_cpu_has(X86_FEATURE_NRIPS))
 			nrips = false;
@@ -1120,6 +1136,21 @@ static void svm_check_invpcid(struct vcpu_svm *svm)
 	}
 }
 
+#if IS_ENABLED(CONFIG_HYPERV)
+static inline void hv_init_vmcb(struct vmcb *vmcb)
+{
+	struct hv_enlightenments *hve = &vmcb->hv_enlightenments;
+
+	if (npt_enabled &&
+	    ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB)
+		hve->hv_enlightenments_control.enlightened_npt_tlb = 1;
+}
+#else
+static inline void hv_init_vmcb(struct vmcb *vmcb)
+{
+}
+#endif
+
 static void init_vmcb(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -1282,6 +1313,8 @@ static void init_vmcb(struct vcpu_svm *svm)
 		}
 	}
 
+	hv_init_vmcb(svm->vmcb);
+
 	vmcb_mark_all_dirty(svm->vmcb);
 
 	enable_gif(svm);
@@ -3975,6 +4008,11 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root,
 		svm->vmcb->control.nested_cr3 = cr3;
 		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
 
+#if IS_ENABLED(CONFIG_HYPERV)
+		if (kvm_x86_ops.tlb_remote_flush)
+			kvm_update_arch_tdp_pointer(vcpu->kvm, vcpu, cr3);
+#endif
+
 		/* Loading L2's CR3 is handled by enter_svm_guest_mode.  */
 		if (!test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
 			return;
-- 
2.25.1

