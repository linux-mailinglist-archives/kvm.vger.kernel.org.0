Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A33B360ADE
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 15:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbhDONod (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 09:44:33 -0400
Received: from linux.microsoft.com ([13.77.154.182]:41582 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233393AbhDONoV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 09:44:21 -0400
Received: from viremana-dev.fwjladdvyuiujdukmejncen4mf.xx.internal.cloudapp.net (unknown [13.66.132.26])
        by linux.microsoft.com (Postfix) with ESMTPSA id EF7F920B83D9;
        Thu, 15 Apr 2021 06:43:57 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EF7F920B83D9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1618494238;
        bh=Q/BuGqSBDUgHYxP3HOkFRxa2PA/cmiJ6Hf2RNAuMZe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DrCWZ+JNfFE1x9okPW354omKiJkMLWfMiSyeXBI/s4cItlfcj/d1QDV4Rs+SObEvh
         Mx5wCoJRVNtClVti1QE2HItcnn8cO2VvG3YGU3y6g+zNu/2ndZfVIklzRAYMelispu
         j65siIODLniUJeYHPvy4Q9+tMZigjImqJAme4u4A=
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
Subject: [PATCH v2 4/7] KVM: SVM: hyper-v: Nested enlightenments in VMCB
Date:   Thu, 15 Apr 2021 13:43:39 +0000
Message-Id: <ffe0e81164e5577a43f7499e40922b6abb663430.1618492553.git.viremana@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1618492553.git.viremana@linux.microsoft.com>
References: <cover.1618492553.git.viremana@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add Hyper-V specific fields in VMCB to support SVM enlightenments.
Also a small refactoring of VMCB clean bits handling.

Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
---
 arch/x86/include/asm/svm.h | 24 +++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c     |  8 ++++++++
 arch/x86/kvm/svm/svm.h     | 30 ++++++++++++++++++++++++++++--
 3 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 1c561945b426..3586d7523ce8 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -322,9 +322,31 @@ static inline void __unused_size_checks(void)
 	BUILD_BUG_ON(sizeof(struct ghcb)		!= EXPECTED_GHCB_SIZE);
 }
 
+
+#if IS_ENABLED(CONFIG_HYPERV)
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
+#define VMCB_CONTROL_END	992	// 32 bytes for Hyper-V
+#else
+#define VMCB_CONTROL_END	1024
+#endif
+
 struct vmcb {
 	struct vmcb_control_area control;
-	u8 reserved_control[1024 - sizeof(struct vmcb_control_area)];
+	u8 reserved_control[VMCB_CONTROL_END - sizeof(struct vmcb_control_area)];
+#if IS_ENABLED(CONFIG_HYPERV)
+	struct hv_enlightenments hv_enlightenments;
+#endif
 	struct vmcb_save_area save;
 } __packed;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index baee91c1e936..2ad1f55c88d0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -31,6 +31,7 @@
 #include <asm/tlbflush.h>
 #include <asm/desc.h>
 #include <asm/debugreg.h>
+#include <asm/hypervisor.h>
 #include <asm/kvm_para.h>
 #include <asm/irq_remapping.h>
 #include <asm/spec-ctrl.h>
@@ -122,6 +123,8 @@ bool npt_enabled = true;
 bool npt_enabled;
 #endif
 
+u32 __read_mostly vmcb_all_clean_mask = VMCB_ALL_CLEAN_MASK;
+
 /*
  * These 2 parameters are used to config the controls for Pause-Loop Exiting:
  * pause_filter_count: On processors that support Pause filtering(indicated
@@ -1051,6 +1054,11 @@ static __init int svm_hardware_setup(void)
 	 */
 	allow_smaller_maxphyaddr = !npt_enabled;
 
+#if IS_ENABLED(CONFIG_HYPERV)
+	if (hypervisor_is_type(X86_HYPER_MS_HYPERV))
+		vmcb_all_clean_mask |= VMCB_HYPERV_CLEAN_MASK;
+#endif
+
 	return 0;
 
 err:
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 39e071fdab0c..63ed05c8027b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -33,6 +33,11 @@ static const u32 host_save_user_msrs[] = {
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
 
+/*
+ * Clean bits in VMCB.
+ * VMCB_ALL_CLEAN_MASK and VMCB_HYPERV_CLEAN_MASK might
+ * also need to be updated if this enum is modified.
+ */
 enum {
 	VMCB_INTERCEPTS, /* Intercept vectors, TSC offset,
 			    pause filter count */
@@ -50,12 +55,28 @@ enum {
 			  * AVIC PHYSICAL_TABLE pointer,
 			  * AVIC LOGICAL_TABLE pointer
 			  */
-	VMCB_DIRTY_MAX,
+#if IS_ENABLED(CONFIG_HYPERV)
+	VMCB_HV_NESTED_ENLIGHTENMENTS = 31,
+#endif
 };
 
+#define VMCB_ALL_CLEAN_MASK (					\
+	(1U << VMCB_INTERCEPTS) | (1U << VMCB_PERM_MAP) |	\
+	(1U << VMCB_ASID) | (1U << VMCB_INTR) |			\
+	(1U << VMCB_NPT) | (1U << VMCB_CR) | (1U << VMCB_DR) |	\
+	(1U << VMCB_DT) | (1U << VMCB_SEG) | (1U << VMCB_CR2) |	\
+	(1U << VMCB_LBR) | (1U << VMCB_AVIC)			\
+	)
+
+#if IS_ENABLED(CONFIG_HYPERV)
+#define VMCB_HYPERV_CLEAN_MASK (1U << VMCB_HV_NESTED_ENLIGHTENMENTS)
+#endif
+
 /* TPR and CR2 are always written before VMRUN */
 #define VMCB_ALWAYS_DIRTY_MASK	((1U << VMCB_INTR) | (1U << VMCB_CR2))
 
+extern u32 vmcb_all_clean_mask __read_mostly;
+
 struct kvm_sev_info {
 	bool active;		/* SEV enabled guest */
 	bool es_active;		/* SEV-ES enabled guest */
@@ -230,7 +251,7 @@ static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 
 static inline void vmcb_mark_all_clean(struct vmcb *vmcb)
 {
-	vmcb->control.clean = ((1 << VMCB_DIRTY_MAX) - 1)
+	vmcb->control.clean = vmcb_all_clean_mask
 			       & ~VMCB_ALWAYS_DIRTY_MASK;
 }
 
@@ -239,6 +260,11 @@ static inline void vmcb_mark_dirty(struct vmcb *vmcb, int bit)
 	vmcb->control.clean &= ~(1 << bit);
 }
 
+static inline bool vmcb_is_clean(struct vmcb *vmcb, int bit)
+{
+	return (vmcb->control.clean & (1 << bit));
+}
+
 static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
 {
 	return container_of(vcpu, struct vcpu_svm, vcpu);
-- 
2.25.1

