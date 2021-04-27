Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A14D36CD50
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 22:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239179AbhD0U4B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 16:56:01 -0400
Received: from linux.microsoft.com ([13.77.154.182]:35678 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239055AbhD0Uzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 16:55:50 -0400
Received: from viremana-dev.fwjladdvyuiujdukmejncen4mf.xx.internal.cloudapp.net (unknown [13.66.132.26])
        by linux.microsoft.com (Postfix) with ESMTPSA id 60DA220B83DA;
        Tue, 27 Apr 2021 13:55:06 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 60DA220B83DA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1619556906;
        bh=B+Ot5SZDvlzPBhejdU+IOJieft4Jhr1LDAbSyC+J0HE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WQTWGuGv5tXqyLrzDBoGIoUE4UEuOuM5LnquIYqGxT+ywAJqYMy5waK/oS6/nJ4S/
         muwfzBDSOriNGbD1QlTOmhFZwAgRwQTn9OWyShuF9FHt3Xfuo09q12pYPXOd/fiS8d
         437Mi6hu7/8dmVn94pyKndCQiyD/bgPfbozeGJfk=
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
Subject: [PATCH v4 6/7] KVM: SVM: hyper-v: Enlightened MSR-Bitmap support
Date:   Tue, 27 Apr 2021 20:54:55 +0000
Message-Id: <a9b844d0bc5aaa55456ff511c958ebd65a6fd069.1619556430.git.viremana@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1619556430.git.viremana@linux.microsoft.com>
References: <cover.1619556430.git.viremana@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enlightened MSR-Bitmap as per TLFS:

 "The L1 hypervisor may collaborate with the L0 hypervisor to make MSR
  accesses more efficient. It can enable enlightened MSR bitmaps by setting
  the corresponding field in the enlightened VMCS to 1. When enabled, L0
  hypervisor does not monitor the MSR bitmaps for changes. Instead, the L1
  hypervisor must invalidate the corresponding clean field after making
  changes to one of the MSR bitmaps."

Enable this for SVM.

Related VMX changes:
commit ceef7d10dfb6 ("KVM: x86: VMX: hyper-v: Enlightened MSR-Bitmap support")

Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
---
 arch/x86/kvm/svm/svm.c          |  3 +++
 arch/x86/kvm/svm/svm.h          |  5 +++++
 arch/x86/kvm/svm/svm_onhyperv.h | 28 ++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 62b618ebcb25..a042f6c4ecb6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -676,6 +676,9 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
 	write ? clear_bit(bit_write, &tmp) : set_bit(bit_write, &tmp);
 
 	msrpm[offset] = tmp;
+
+	svm_hv_vmcb_dirty_nested_enlightenments(vcpu);
+
 }
 
 void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 4e073b88c8cb..33c1a77eed58 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -247,6 +247,11 @@ static inline void vmcb_mark_all_clean(struct vmcb *vmcb)
 			       & ~VMCB_ALWAYS_DIRTY_MASK;
 }
 
+static inline bool vmcb_is_clean(struct vmcb *vmcb, int bit)
+{
+	return (vmcb->control.clean & (1 << bit));
+}
+
 static inline void vmcb_mark_dirty(struct vmcb *vmcb, int bit)
 {
 	vmcb->control.clean &= ~(1 << bit);
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index 35b4bbbc539a..da6c6a0a70e0 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -31,6 +31,11 @@ struct __packed hv_enlightenments {
 	u64 reserved;
 };
 
+/*
+ * Hyper-V uses the software reserved clean bit in VMCB
+ */
+#define VMCB_HV_NESTED_ENLIGHTENMENTS VMCB_SW
+
 static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
 {
 	struct hv_enlightenments *hve =
@@ -58,6 +63,24 @@ static inline void svm_hv_update_tdp_pointer(struct kvm_vcpu *vcpu,
 	if (kvm_x86_ops.tlb_remote_flush)
 		kvm_update_arch_tdp_pointer(vcpu, cr3);
 }
+
+static inline void svm_hv_vmcb_dirty_nested_enlightenments(
+		struct kvm_vcpu *vcpu)
+{
+	struct vmcb *vmcb = to_svm(vcpu)->vmcb;
+	struct hv_enlightenments *hve =
+		(struct hv_enlightenments *)vmcb->control.reserved_sw;
+
+	/*
+	 * vmcb can be NULL if called during early vcpu init.
+	 * And its okay not to mark vmcb dirty during vcpu init
+	 * as we mark it dirty unconditionally towards end of vcpu
+	 * init phase.
+	 */
+	if (vmcb && vmcb_is_clean(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS) &&
+	    hve->hv_enlightenments_control.msr_bitmap)
+		vmcb_mark_dirty(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
+}
 #else
 
 static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
@@ -72,6 +95,11 @@ static inline void svm_hv_update_tdp_pointer(struct kvm_vcpu *vcpu,
 		unsigned long cr3)
 {
 }
+
+static inline void svm_hv_vmcb_dirty_nested_enlightenments(
+		struct kvm_vcpu *vcpu)
+{
+}
 #endif /* CONFIG_HYPERV */
 
 #endif /* __ARCH_X86_KVM_SVM_ONHYPERV_H__ */
-- 
2.25.1

