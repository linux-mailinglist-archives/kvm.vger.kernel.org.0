Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493C9356F02
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 16:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353082AbhDGOl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 10:41:59 -0400
Received: from linux.microsoft.com ([13.77.154.182]:52754 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235851AbhDGOlv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 10:41:51 -0400
Received: from viremana-dev.fwjladdvyuiujdukmejncen4mf.xx.internal.cloudapp.net (unknown [13.66.132.26])
        by linux.microsoft.com (Postfix) with ESMTPSA id DE60220B5686;
        Wed,  7 Apr 2021 07:41:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DE60220B5686
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617806499;
        bh=A+8gaBiKpG65qtSBpyN/qekrPAQmUyWDwaf6XY0a/wI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4KbVTMBXUqELAnFicbFqIArVOAHDDf1JE40QlQYMuaBV7QGrFSj435LysUrovp5s
         jGjzxco4lWgK7m/OPXodDx1WpLs20c9+fptUCTuT3gzXQwghmtthWgNIZiekJXSG/U
         +O7APLbwZJEGxlohzCZbOkrL9zqMpuwrTS+YhC7o=
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
Subject: [PATCH 5/7] KVM: SVM: hyper-v: Remote TLB flush for SVM
Date:   Wed,  7 Apr 2021 14:41:26 +0000
Message-Id: <1c754fe1ad8ae797b4045903dab51ab45dd37755.1617804573.git.viremana@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1617804573.git.viremana@linux.microsoft.com>
References: <cover.1617804573.git.viremana@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable remote TLB flush for SVM.

Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
---
 arch/x86/kvm/svm/svm.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index baee91c1e936..6287cab61f15 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -36,6 +36,7 @@
 #include <asm/spec-ctrl.h>
 #include <asm/cpu_device_id.h>
 #include <asm/traps.h>
+#include <asm/mshyperv.h>
 
 #include <asm/virtext.h>
 #include "trace.h"
@@ -43,6 +44,8 @@
 #include "svm.h"
 #include "svm_ops.h"
 
+#include "hyperv.h"
+
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
 MODULE_AUTHOR("Qumranet");
@@ -928,6 +931,8 @@ static __init void svm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
 }
 
+static struct kvm_x86_ops svm_x86_ops;
+
 static __init int svm_hardware_setup(void)
 {
 	int cpu;
@@ -997,6 +1002,16 @@ static __init int svm_hardware_setup(void)
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
@@ -1112,6 +1127,21 @@ static void svm_check_invpcid(struct vcpu_svm *svm)
 	}
 }
 
+#if IS_ENABLED(CONFIG_HYPERV)
+static void hv_init_vmcb(struct vmcb *vmcb)
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
@@ -1274,6 +1304,8 @@ static void init_vmcb(struct vcpu_svm *svm)
 		}
 	}
 
+	hv_init_vmcb(svm->vmcb);
+
 	vmcb_mark_all_dirty(svm->vmcb);
 
 	enable_gif(svm);
@@ -3967,6 +3999,9 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root,
 		svm->vmcb->control.nested_cr3 = cr3;
 		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
 
+		if (kvm_x86_ops.tlb_remote_flush)
+			kvm_update_arch_tdp_pointer(vcpu->kvm, vcpu, cr3);
+
 		/* Loading L2's CR3 is handled by enter_svm_guest_mode.  */
 		if (!test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
 			return;
-- 
2.25.1

