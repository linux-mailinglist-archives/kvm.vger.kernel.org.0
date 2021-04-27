Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52C3836CD52
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 22:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239218AbhD0U4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 16:56:04 -0400
Received: from linux.microsoft.com ([13.77.154.182]:35676 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239060AbhD0Uzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 16:55:50 -0400
Received: from viremana-dev.fwjladdvyuiujdukmejncen4mf.xx.internal.cloudapp.net (unknown [13.66.132.26])
        by linux.microsoft.com (Postfix) with ESMTPSA id 799E720B83DB;
        Tue, 27 Apr 2021 13:55:06 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 799E720B83DB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1619556906;
        bh=3Zv4Xqr8Eksa9/jeeDkwCeLgta1SmQD9uErOqXc5Hbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N/u1K83bYDJSTkFl9Nu6ryeU+sspg/QgW1bKkL30TivnAi+xovUdKRQi3aHNJlfOm
         EZz1P2OoWPs+Zf+E2L1KPpWQw9LEHEQ5q15xri7RCyKV8+mBUlvc8VX6BkYoVKavVV
         fsMKRhTBMtUa/9eW6uudB1MpZFpD5qm3U5XsUfXI=
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
Subject: [PATCH v4 7/7] KVM: SVM: hyper-v: Direct Virtual Flush support
Date:   Tue, 27 Apr 2021 20:54:56 +0000
Message-Id: <33e41aa7c6a79bd76f0b912e39b4e2ea007bcbb6.1619556430.git.viremana@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1619556430.git.viremana@linux.microsoft.com>
References: <cover.1619556430.git.viremana@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From Hyper-V TLFS:
 "The hypervisor exposes hypercalls (HvFlushVirtualAddressSpace,
  HvFlushVirtualAddressSpaceEx, HvFlushVirtualAddressList, and
  HvFlushVirtualAddressListEx) that allow operating systems to more
  efficiently manage the virtual TLB. The L1 hypervisor can choose to
  allow its guest to use those hypercalls and delegate the responsibility
  to handle them to the L0 hypervisor. This requires the use of a
  partition assist page."

Add the Direct Virtual Flush support for SVM.

Related VMX changes:
commit 6f6a657c9998 ("KVM/Hyper-V/VMX: Add direct tlb flush support")

Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
---
 arch/x86/kvm/Makefile           |  4 ++++
 arch/x86/kvm/svm/svm.c          |  2 ++
 arch/x86/kvm/svm/svm_onhyperv.c | 41 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm_onhyperv.h | 36 +++++++++++++++++++++++++++++
 4 files changed, 83 insertions(+)
 create mode 100644 arch/x86/kvm/svm/svm_onhyperv.c

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 694f44c8192b..de1ff99a7095 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -30,6 +30,10 @@ kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
 
+ifdef CONFIG_HYPERV
+kvm-amd-y		+= svm/svm_onhyperv.o
+endif
+
 obj-$(CONFIG_KVM)	+= kvm.o
 obj-$(CONFIG_KVM_INTEL)	+= kvm-intel.o
 obj-$(CONFIG_KVM_AMD)	+= kvm-amd.o
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a042f6c4ecb6..f80b805db256 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3863,6 +3863,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	}
 	svm->vmcb->save.cr2 = vcpu->arch.cr2;
 
+	svm_hv_update_vp_id(svm->vmcb, vcpu);
+
 	/*
 	 * Run with all-zero DR6 unless needed, so that we can get the exact cause
 	 * of a #DB.
diff --git a/arch/x86/kvm/svm/svm_onhyperv.c b/arch/x86/kvm/svm/svm_onhyperv.c
new file mode 100644
index 000000000000..3281856ebd94
--- /dev/null
+++ b/arch/x86/kvm/svm/svm_onhyperv.c
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KVM L1 hypervisor optimizations on Hyper-V for SVM.
+ */
+
+#include <linux/kvm_host.h>
+#include "kvm_cache_regs.h"
+
+#include <asm/mshyperv.h>
+
+#include "svm.h"
+#include "svm_ops.h"
+
+#include "hyperv.h"
+#include "kvm_onhyperv.h"
+#include "svm_onhyperv.h"
+
+int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
+{
+	struct hv_enlightenments *hve;
+	struct hv_partition_assist_pg **p_hv_pa_pg =
+			&to_kvm_hv(vcpu->kvm)->hv_pa_pg;
+
+	if (!*p_hv_pa_pg)
+		*p_hv_pa_pg = kzalloc(PAGE_SIZE, GFP_KERNEL);
+
+	if (!*p_hv_pa_pg)
+		return -ENOMEM;
+
+	hve = (struct hv_enlightenments *)to_svm(vcpu)->vmcb->control.reserved_sw;
+
+	hve->partition_assist_page = __pa(*p_hv_pa_pg);
+	hve->hv_vm_id = (unsigned long)vcpu->kvm;
+	if (!hve->hv_enlightenments_control.nested_flush_hypercall) {
+		hve->hv_enlightenments_control.nested_flush_hypercall = 1;
+		vmcb_mark_dirty(to_svm(vcpu)->vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
+	}
+
+	return 0;
+}
+
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index da6c6a0a70e0..d9279d93ea69 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -36,6 +36,8 @@ struct __packed hv_enlightenments {
  */
 #define VMCB_HV_NESTED_ENLIGHTENMENTS VMCB_SW
 
+int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu);
+
 static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
 {
 	struct hv_enlightenments *hve =
@@ -55,6 +57,23 @@ static inline void svm_hv_hardware_setup(void)
 		svm_x86_ops.tlb_remote_flush_with_range =
 				kvm_hv_remote_flush_tlb_with_range;
 	}
+
+	if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH) {
+		int cpu;
+
+		pr_info("kvm: Hyper-V Direct TLB Flush enabled\n");
+		for_each_online_cpu(cpu) {
+			struct hv_vp_assist_page *vp_ap =
+				hv_get_vp_assist_page(cpu);
+
+			if (!vp_ap)
+				continue;
+
+			vp_ap->nested_control.features.directhypercall = 1;
+		}
+		svm_x86_ops.enable_direct_tlbflush =
+				hv_enable_direct_tlbflush;
+	}
 }
 
 static inline void svm_hv_update_tdp_pointer(struct kvm_vcpu *vcpu,
@@ -81,6 +100,18 @@ static inline void svm_hv_vmcb_dirty_nested_enlightenments(
 	    hve->hv_enlightenments_control.msr_bitmap)
 		vmcb_mark_dirty(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
 }
+
+static inline void svm_hv_update_vp_id(struct vmcb *vmcb,
+		struct kvm_vcpu *vcpu)
+{
+	struct hv_enlightenments *hve =
+		(struct hv_enlightenments *)vmcb->control.reserved_sw;
+
+	if (hve->hv_vp_id != to_hv_vcpu(vcpu)->vp_index) {
+		hve->hv_vp_id = to_hv_vcpu(vcpu)->vp_index;
+		vmcb_mark_dirty(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
+	}
+}
 #else
 
 static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
@@ -100,6 +131,11 @@ static inline void svm_hv_vmcb_dirty_nested_enlightenments(
 		struct kvm_vcpu *vcpu)
 {
 }
+
+static inline void svm_hv_update_vp_id(struct vmcb *vmcb,
+		struct kvm_vcpu *vcpu)
+{
+}
 #endif /* CONFIG_HYPERV */
 
 #endif /* __ARCH_X86_KVM_SVM_ONHYPERV_H__ */
-- 
2.25.1

