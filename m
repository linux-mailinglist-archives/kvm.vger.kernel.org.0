Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34095356F00
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 16:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348617AbhDGOl6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 10:41:58 -0400
Received: from linux.microsoft.com ([13.77.154.182]:52702 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235837AbhDGOlt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 10:41:49 -0400
Received: from viremana-dev.fwjladdvyuiujdukmejncen4mf.xx.internal.cloudapp.net (unknown [13.66.132.26])
        by linux.microsoft.com (Postfix) with ESMTPSA id C5E4A20B5685;
        Wed,  7 Apr 2021 07:41:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C5E4A20B5685
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617806499;
        bh=Mt7L3oriXlqfzhuqTRvXZ3KHI16YTRJ7T6UbsT9WLfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=soMMC9WumjX5XiLfW6YI6VXTu2T0mqMxObMAnNF+IYt+Iyc25M22NIDYks5dxORh+
         ILeASXYo6MuAmLtEaP7gqrHNp7+r1g0m72UYVnaZeZ/KEI5l1Mv7MQNJt+NGwHcSGA
         Powb5Lj5M3b5QHRy5Rn8QlzLS9Y/rJrR4j2buzhQ=
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
Subject: [PATCH 4/7] KVM: SVM: hyper-v: Nested enlightenments in VMCB
Date:   Wed,  7 Apr 2021 14:41:25 +0000
Message-Id: <e9de12a81ab31613fb55d5c1308ca0ca050ced4c.1617804573.git.viremana@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1617804573.git.viremana@linux.microsoft.com>
References: <cover.1617804573.git.viremana@linux.microsoft.com>
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
 arch/x86/kvm/svm/svm.h     | 30 ++++++++++++++++++++++++++++--
 2 files changed, 51 insertions(+), 3 deletions(-)

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
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 39e071fdab0c..842c8764a68c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -33,6 +33,11 @@ static const u32 host_save_user_msrs[] = {
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
 
+/*
+ * Clean bits in VMCB.
+ * Should update VMCB_ALL_CLEAN_MASK also
+ * if this enum is modified.
+ */
 enum {
 	VMCB_INTERCEPTS, /* Intercept vectors, TSC offset,
 			    pause filter count */
@@ -50,9 +55,25 @@ enum {
 			  * AVIC PHYSICAL_TABLE pointer,
 			  * AVIC LOGICAL_TABLE pointer
 			  */
-	VMCB_DIRTY_MAX,
+#if IS_ENABLED(CONFIG_HYPERV)
+	VMCB_HV_NESTED_ENLIGHTENMENTS = 31,
+#endif
 };
 
+#define __CLEAN_MASK (										\
+	(1U << VMCB_INTERCEPTS) | (1U << VMCB_PERM_MAP) |		\
+	(1U << VMCB_ASID) | (1U << VMCB_INTR) |					\
+	(1U << VMCB_NPT) | (1U << VMCB_CR) | (1U << VMCB_DR) |	\
+	(1U << VMCB_DT) | (1U << VMCB_SEG) | (1U << VMCB_CR2) |	\
+	(1U << VMCB_LBR) | (1U << VMCB_AVIC)					\
+	)
+
+#if IS_ENABLED(CONFIG_HYPERV)
+#define VMCB_ALL_CLEAN_MASK (__CLEAN_MASK | (1U << VMCB_HV_NESTED_ENLIGHTENMENTS))
+#else
+#define VMCB_ALL_CLEAN_MASK __CLEAN_MASK
+#endif
+
 /* TPR and CR2 are always written before VMRUN */
 #define VMCB_ALWAYS_DIRTY_MASK	((1U << VMCB_INTR) | (1U << VMCB_CR2))
 
@@ -230,7 +251,7 @@ static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 
 static inline void vmcb_mark_all_clean(struct vmcb *vmcb)
 {
-	vmcb->control.clean = ((1 << VMCB_DIRTY_MAX) - 1)
+	vmcb->control.clean = VMCB_ALL_CLEAN_MASK
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

