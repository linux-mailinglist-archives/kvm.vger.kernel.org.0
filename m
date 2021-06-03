Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4B339A42F
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 17:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbhFCPQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 11:16:43 -0400
Received: from linux.microsoft.com ([13.77.154.182]:45714 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbhFCPQg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 11:16:36 -0400
Received: from viremana-dev.fwjladdvyuiujdukmejncen4mf.xx.internal.cloudapp.net (unknown [13.66.132.26])
        by linux.microsoft.com (Postfix) with ESMTPSA id 4089220B800D;
        Thu,  3 Jun 2021 08:14:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4089220B800D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1622733291;
        bh=m88SPusS66QEKDy6ebkhU/c6WvDP5/rom/acisdUES0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I/Qkg6dsFVxt7mBZFtL9QFVVx025JBxcPJtE40MJ+0XP4eZrCbNyHM9TAJYfDZjHg
         A0w/3vqbr3ezhac03aeLmfyhh/Sq25nIj37eoD06tpDNc1TEHgqi0oTOmAjBRCLvcw
         P6H5mgXMNfWRby3ofWR5P+90N9j2jQ3npXMyRtkw=
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
Subject: [PATCH v5 5/7] KVM: SVM: hyper-v: Remote TLB flush for SVM
Date:   Thu,  3 Jun 2021 15:14:38 +0000
Message-Id: <1ee364e397e142aed662d2920d198cd03772f1a5.1622730232.git.viremana@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1622730232.git.viremana@linux.microsoft.com>
References: <cover.1622730232.git.viremana@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable remote TLB flush for SVM.

Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
---
 arch/x86/kvm/svm/svm.c          |  9 +++++
 arch/x86/kvm/svm/svm_onhyperv.h | 66 +++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)
 create mode 100644 arch/x86/kvm/svm/svm_onhyperv.h

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b649f92287a2..a39865dbc200 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -43,6 +43,9 @@
 #include "svm.h"
 #include "svm_ops.h"
 
+#include "kvm_onhyperv.h"
+#include "svm_onhyperv.h"
+
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
 MODULE_AUTHOR("Qumranet");
@@ -992,6 +995,8 @@ static __init int svm_hardware_setup(void)
 	/* Note, SEV setup consumes npt_enabled. */
 	sev_hardware_setup();
 
+	svm_hv_hardware_setup();
+
 	svm_adjust_mmio_mask();
 
 	for_each_possible_cpu(cpu) {
@@ -1276,6 +1281,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	svm_hv_init_vmcb(svm->vmcb);
+
 	vmcb_mark_all_dirty(svm->vmcb);
 
 	enable_gif(svm);
@@ -3884,6 +3891,8 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 		svm->vmcb->control.nested_cr3 = __sme_set(root_hpa);
 		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
 
+		hv_track_root_tdp(vcpu, root_hpa);
+
 		/* Loading L2's CR3 is handled by enter_svm_guest_mode.  */
 		if (!test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
 			return;
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
new file mode 100644
index 000000000000..57291e222395
--- /dev/null
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -0,0 +1,66 @@
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
+struct hv_enlightenments {
+	struct __packed hv_enlightenments_control {
+		u32 nested_flush_hypercall:1;
+		u32 msr_bitmap:1;
+		u32 enlightened_npt_tlb: 1;
+		u32 reserved:29;
+	} __packed hv_enlightenments_control;
+	u32 hv_vp_id;
+	u64 hv_vm_id;
+	u64 partition_assist_page;
+	u64 reserved;
+} __packed;
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
+		svm_x86_ops.tlb_remote_flush = hv_remote_flush_tlb;
+		svm_x86_ops.tlb_remote_flush_with_range =
+				hv_remote_flush_tlb_with_range;
+	}
+}
+
+#else
+
+static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
+{
+}
+
+static inline void svm_hv_hardware_setup(void)
+{
+}
+#endif /* CONFIG_HYPERV */
+
+#endif /* __ARCH_X86_KVM_SVM_ONHYPERV_H__ */
-- 
2.25.1

