Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC06F36CD51
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 22:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239202AbhD0U4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 16:56:03 -0400
Received: from linux.microsoft.com ([13.77.154.182]:35674 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239053AbhD0Uzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 16:55:50 -0400
Received: from viremana-dev.fwjladdvyuiujdukmejncen4mf.xx.internal.cloudapp.net (unknown [13.66.132.26])
        by linux.microsoft.com (Postfix) with ESMTPSA id 4832820B83D9;
        Tue, 27 Apr 2021 13:55:06 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4832820B83D9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1619556906;
        bh=O3T5Uq3VanVL6Z4IcCvAp3ZZ1LEKoKpw20U34QWIBWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PHt1IDNrtHt5IfX/taw7CdYoO+pCzKB18BEDRoAdNYzpfPyAaAgCqWKQ9VG59vImy
         n2wFZeNF97N2wbp6vNW0gYvfJDVbV9QJexf7NJJzfPd8jCv20bZNsHx6F4Pq3hstiH
         rorzZQhvTJI3+qohZ4Qxx53s8V4GqatBa/ka9ef8=
From:   Vineeth Pillai <viremana@linux.microsoft.com>
To:     Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
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
Subject: [PATCH v4 5/7] KVM: SVM: hyper-v: Remote TLB flush for SVM
Date:   Tue, 27 Apr 2021 20:54:54 +0000
Message-Id: <db29ee404f2799707b6e319e5087bb2f454cba39.1619556430.git.viremana@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1619556430.git.viremana@linux.microsoft.com>
References: <cover.1619556430.git.viremana@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable remote TLB flush for SVM.

Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
---
 arch/x86/kvm/svm/svm.c          |  8 ++++
 arch/x86/kvm/svm/svm_onhyperv.h | 77 +++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+)
 create mode 100644 arch/x86/kvm/svm/svm_onhyperv.h

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index baee91c1e936..62b618ebcb25 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -43,6 +43,8 @@
 #include "svm.h"
 #include "svm_ops.h"
 
+#include "svm_onhyperv.h"
+
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
 MODULE_AUTHOR("Qumranet");
@@ -997,6 +999,8 @@ static __init int svm_hardware_setup(void)
 	kvm_configure_mmu(npt_enabled, get_max_npt_level(), PG_LEVEL_1G);
 	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
 
+	svm_hv_hardware_setup();
+
 	if (nrips) {
 		if (!boot_cpu_has(X86_FEATURE_NRIPS))
 			nrips = false;
@@ -1274,6 +1278,8 @@ static void init_vmcb(struct vcpu_svm *svm)
 		}
 	}
 
+	svm_hv_init_vmcb(svm->vmcb);
+
 	vmcb_mark_all_dirty(svm->vmcb);
 
 	enable_gif(svm);
@@ -3967,6 +3973,8 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root,
 		svm->vmcb->control.nested_cr3 = cr3;
 		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
 
+		svm_hv_update_tdp_pointer(vcpu, cr3);
+
 		/* Loading L2's CR3 is handled by enter_svm_guest_mode.  */
 		if (!test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
 			return;
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
new file mode 100644
index 000000000000..35b4bbbc539a
--- /dev/null
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * KVM L1 hypervisor optimizations on Hyper-V for SVM.
+ */
+
+#ifndef __ARCH_X86_KVM_SVM_ONHYPERV_H__
+#define __ARCH_X86_KVM_SVM_ONHYPERV_H__
+
+#if IS_ENABLED(CONFIG_HYPERV)
+#include <asm/mshyperv.h>
+
+#include "hyperv.h"
+#include "kvm_onhyperv.h"
+
+static struct kvm_x86_ops svm_x86_ops;
+
+/*
+ * Hyper-V uses the software reserved 32 bytes in VMCB
+ * control area to expose SVM enlightenments to guests.
+ */
+struct __packed hv_enlightenments {
+	struct __packed hv_enlightenments_control {
+		u32 nested_flush_hypercall:1;
+		u32 msr_bitmap:1;
+		u32 enlightened_npt_tlb: 1;
+		u32 reserved:29;
+	} hv_enlightenments_control;
+	u32 hv_vp_id;
+	u64 hv_vm_id;
+	u64 partition_assist_page;
+	u64 reserved;
+};
+
+static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
+{
+	struct hv_enlightenments *hve =
+		(struct hv_enlightenments *)vmcb->control.reserved_sw;
+
+	if (npt_enabled &&
+	    ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB)
+		hve->hv_enlightenments_control.enlightened_npt_tlb = 1;
+}
+
+static inline void svm_hv_hardware_setup(void)
+{
+	if (npt_enabled &&
+	    ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB) {
+		pr_info("kvm: Hyper-V enlightened NPT TLB flush enabled\n");
+		svm_x86_ops.tlb_remote_flush = kvm_hv_remote_flush_tlb;
+		svm_x86_ops.tlb_remote_flush_with_range =
+				kvm_hv_remote_flush_tlb_with_range;
+	}
+}
+
+static inline void svm_hv_update_tdp_pointer(struct kvm_vcpu *vcpu,
+		unsigned long cr3)
+{
+	if (kvm_x86_ops.tlb_remote_flush)
+		kvm_update_arch_tdp_pointer(vcpu, cr3);
+}
+#else
+
+static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
+{
+}
+
+static inline void svm_hv_hardware_setup(void)
+{
+}
+
+static inline void svm_hv_update_tdp_pointer(struct kvm_vcpu *vcpu,
+		unsigned long cr3)
+{
+}
+#endif /* CONFIG_HYPERV */
+
+#endif /* __ARCH_X86_KVM_SVM_ONHYPERV_H__ */
-- 
2.25.1

