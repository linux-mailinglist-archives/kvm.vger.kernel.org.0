Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406054244F0
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239740AbhJFRnl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:43:41 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53568 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239419AbhJFRmo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:44 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id D18CB30828B9;
        Wed,  6 Oct 2021 20:31:22 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id B5D463064495;
        Wed,  6 Oct 2021 20:31:22 +0300 (EEST)
X-Is-Junk-Enabled: fGZTSsP0qEJE2AIKtlSuFiRRwg9xyHmJ
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v12 69/77] KVM: introspection: restore the state of MSR interception on unhook
Date:   Wed,  6 Oct 2021 20:31:05 +0300
Message-Id: <20211006173113.26445-70-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <nicu.citu@icloud.com>

This commit also ensures that the introspection tool and the userspace
do not disable each other the MSR access VM-exit.

Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvmi_host.h |  12 +++
 arch/x86/kvm/kvmi.c              | 124 +++++++++++++++++++++++++++----
 arch/x86/kvm/svm/svm.c           |  10 +++
 arch/x86/kvm/vmx/vmx.c           |  11 +++
 4 files changed, 142 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 5a4fc5b80907..8822f0310156 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -26,6 +26,12 @@ struct kvmi_interception {
 			DECLARE_BITMAP(low, KVMI_NUM_MSR);
 			DECLARE_BITMAP(high, KVMI_NUM_MSR);
 		} kvmi_mask;
+		struct {
+			DECLARE_BITMAP(low, KVMI_NUM_MSR);
+			DECLARE_BITMAP(high, KVMI_NUM_MSR);
+		} kvm_mask;
+		bool (*monitor_fct)(struct kvm_vcpu *vcpu, u32 msr,
+				    bool enable);
 	} msrw;
 };
 
@@ -61,6 +67,8 @@ void kvmi_xsetbv_event(struct kvm_vcpu *vcpu, u8 xcr,
 bool kvmi_monitor_desc_intercept(struct kvm_vcpu *vcpu, bool enable);
 bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, bool write);
 bool kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr);
+bool kvmi_monitor_msrw_intercept(struct kvm_vcpu *vcpu, u32 msr, bool enable);
+bool kvmi_msrw_intercept_originator(struct kvm_vcpu *vcpu);
 
 #else /* CONFIG_KVM_INTROSPECTION */
 
@@ -82,6 +90,10 @@ static inline bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor,
 					 bool write) { return true; }
 static inline bool kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr)
 				{ return true; }
+static inline bool kvmi_monitor_msrw_intercept(struct kvm_vcpu *vcpu, u32 msr,
+					       bool enable) { return false; }
+static inline bool kvmi_msrw_intercept_originator(struct kvm_vcpu *vcpu)
+				{ return false; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index c84a140db451..4e25ffc3d131 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -345,22 +345,25 @@ static void kvmi_arch_disable_desc_intercept(struct kvm_vcpu *vcpu)
 	vcpu->arch.kvmi->descriptor.kvm_intercepted = false;
 }
 
-static unsigned long *msr_mask(struct kvm_vcpu *vcpu, unsigned int *msr)
+static unsigned long *msr_mask(struct kvm_vcpu *vcpu, unsigned int *msr,
+			       bool kvmi)
 {
 	switch (*msr) {
 	case 0 ... 0x1fff:
-		return vcpu->arch.kvmi->msrw.kvmi_mask.low;
+		return kvmi ? vcpu->arch.kvmi->msrw.kvmi_mask.low :
+			      vcpu->arch.kvmi->msrw.kvm_mask.low;
 	case 0xc0000000 ... 0xc0001fff:
 		*msr &= 0x1fff;
-		return vcpu->arch.kvmi->msrw.kvmi_mask.high;
+		return kvmi ? vcpu->arch.kvmi->msrw.kvmi_mask.high :
+			      vcpu->arch.kvmi->msrw.kvm_mask.high;
 	}
 
 	return NULL;
 }
 
-static bool test_msr_mask(struct kvm_vcpu *vcpu, unsigned int msr)
+static bool test_msr_mask(struct kvm_vcpu *vcpu, unsigned int msr, bool kvmi)
 {
-	unsigned long *mask = msr_mask(vcpu, &msr);
+	unsigned long *mask = msr_mask(vcpu, &msr, kvmi);
 
 	if (!mask)
 		return false;
@@ -368,9 +371,27 @@ static bool test_msr_mask(struct kvm_vcpu *vcpu, unsigned int msr)
 	return !!test_bit(msr, mask);
 }
 
-static bool msr_control(struct kvm_vcpu *vcpu, unsigned int msr, bool enable)
+/*
+ * Returns true if one side (kvm or kvmi) tries to disable the MSR write
+ * interception while the other side is still tracking it.
+ */
+bool kvmi_monitor_msrw_intercept(struct kvm_vcpu *vcpu, u32 msr, bool enable)
+{
+	struct kvmi_interception *arch_vcpui;
+
+	if (!vcpu)
+		return false;
+
+	arch_vcpui = READ_ONCE(vcpu->arch.kvmi);
+
+	return (arch_vcpui && arch_vcpui->msrw.monitor_fct(vcpu, msr, enable));
+}
+EXPORT_SYMBOL(kvmi_monitor_msrw_intercept);
+
+static bool msr_control(struct kvm_vcpu *vcpu, unsigned int msr, bool enable,
+			bool kvmi)
 {
-	unsigned long *mask = msr_mask(vcpu, &msr);
+	unsigned long *mask = msr_mask(vcpu, &msr, kvmi);
 
 	if (!mask)
 		return false;
@@ -383,6 +404,63 @@ static bool msr_control(struct kvm_vcpu *vcpu, unsigned int msr, bool enable)
 	return true;
 }
 
+static bool msr_intercepted_by_kvmi(struct kvm_vcpu *vcpu, u32 msr)
+{
+	return test_msr_mask(vcpu, msr, true);
+}
+
+static bool msr_intercepted_by_kvm(struct kvm_vcpu *vcpu, u32 msr)
+{
+	return test_msr_mask(vcpu, msr, false);
+}
+
+static void record_msr_intercept_status_for_kvmi(struct kvm_vcpu *vcpu, u32 msr,
+						 bool enable)
+{
+	msr_control(vcpu, msr, enable, true);
+}
+
+static void record_msr_intercept_status_for_kvm(struct kvm_vcpu *vcpu, u32 msr,
+						bool enable)
+{
+	msr_control(vcpu, msr, enable, false);
+}
+
+static bool monitor_msrw_fct_kvmi(struct kvm_vcpu *vcpu, u32 msr, bool enable)
+{
+	bool ret = false;
+
+	if (enable) {
+		if (static_call(kvm_x86_msr_write_intercepted)(vcpu, msr))
+			record_msr_intercept_status_for_kvm(vcpu, msr, true);
+	} else {
+		if (unlikely(!msr_intercepted_by_kvmi(vcpu, msr)))
+			ret = true;
+
+		if (msr_intercepted_by_kvm(vcpu, msr))
+			ret = true;
+	}
+
+	record_msr_intercept_status_for_kvmi(vcpu, msr, enable);
+
+	return ret;
+}
+
+static bool monitor_msrw_fct_kvm(struct kvm_vcpu *vcpu, u32 msr, bool enable)
+{
+	bool ret = false;
+
+	if (!(msr_intercepted_by_kvmi(vcpu, msr)))
+		return false;
+
+	if (!enable)
+		ret = true;
+
+	record_msr_intercept_status_for_kvm(vcpu, msr, enable);
+
+	return ret;
+}
+
 static unsigned int msr_mask_to_base(struct kvm_vcpu *vcpu, unsigned long *mask)
 {
 	if (mask == vcpu->arch.kvmi->msrw.kvmi_mask.high)
@@ -393,13 +471,14 @@ static unsigned int msr_mask_to_base(struct kvm_vcpu *vcpu, unsigned long *mask)
 
 void kvmi_control_msrw_intercept(struct kvm_vcpu *vcpu, u32 msr, bool enable)
 {
+	vcpu->arch.kvmi->msrw.monitor_fct = monitor_msrw_fct_kvmi;
 	static_call(kvm_x86_control_msr_intercept)(vcpu, msr, MSR_TYPE_W,
 						   enable);
-	msr_control(vcpu, msr, enable);
+	vcpu->arch.kvmi->msrw.monitor_fct = monitor_msrw_fct_kvm;
 }
 
-static void kvmi_arch_disable_msr_intercept(struct kvm_vcpu *vcpu,
-					    unsigned long *mask)
+static void kvmi_arch_disable_msrw_intercept(struct kvm_vcpu *vcpu,
+					     unsigned long *mask)
 {
 	unsigned int msr_base = msr_mask_to_base(vcpu, mask);
 	int offset = -1;
@@ -410,8 +489,7 @@ static void kvmi_arch_disable_msr_intercept(struct kvm_vcpu *vcpu,
 		if (offset >= KVMI_NUM_MSR)
 			break;
 
-		static_call(kvm_x86_control_msr_intercept)(vcpu,
-				msr_base + offset, MSR_TYPE_W, false);
+		kvmi_control_msrw_intercept(vcpu, msr_base + offset, false);
 	}
 
 	bitmap_zero(mask, KVMI_NUM_MSR);
@@ -463,8 +541,8 @@ static void kvmi_arch_restore_interception(struct kvm_vcpu *vcpu)
 	kvmi_arch_disable_bp_intercept(vcpu);
 	kvmi_arch_disable_cr3w_intercept(vcpu);
 	kvmi_arch_disable_desc_intercept(vcpu);
-	kvmi_arch_disable_msr_intercept(vcpu, arch_vcpui->msrw.kvmi_mask.low);
-	kvmi_arch_disable_msr_intercept(vcpu, arch_vcpui->msrw.kvmi_mask.high);
+	kvmi_arch_disable_msrw_intercept(vcpu, arch_vcpui->msrw.kvmi_mask.low);
+	kvmi_arch_disable_msrw_intercept(vcpu, arch_vcpui->msrw.kvmi_mask.high);
 }
 
 bool kvmi_arch_clean_up_interception(struct kvm_vcpu *vcpu)
@@ -491,12 +569,14 @@ bool kvmi_arch_vcpu_alloc_interception(struct kvm_vcpu *vcpu)
 	arch_vcpui->breakpoint.monitor_fct = monitor_bp_fct_kvm;
 	arch_vcpui->cr3w.monitor_fct = monitor_cr3w_fct_kvm;
 	arch_vcpui->descriptor.monitor_fct = monitor_desc_fct_kvm;
+	arch_vcpui->msrw.monitor_fct = monitor_msrw_fct_kvm;
 
 	/*
 	 * paired with:
 	 *  - kvmi_monitor_bp_intercept()
 	 *  - kvmi_monitor_cr3w_intercept()
 	 *  - kvmi_monitor_desc_intercept()
+	 *  - kvmi_monitor_msrw_intercept()
 	 */
 	smp_wmb();
 	WRITE_ONCE(vcpu->arch.kvmi, arch_vcpui);
@@ -778,6 +858,20 @@ bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, bool write)
 }
 EXPORT_SYMBOL(kvmi_descriptor_event);
 
+bool kvmi_msrw_intercept_originator(struct kvm_vcpu *vcpu)
+{
+	struct kvmi_interception *arch_vcpui;
+
+	if (!vcpu)
+		return false;
+
+	arch_vcpui = READ_ONCE(vcpu->arch.kvmi);
+
+	return (arch_vcpui &&
+		arch_vcpui->msrw.monitor_fct == monitor_msrw_fct_kvmi);
+}
+EXPORT_SYMBOL(kvmi_msrw_intercept_originator);
+
 static bool __kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr)
 {
 	struct msr_data old_msr = {
@@ -788,7 +882,7 @@ static bool __kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	u32 action;
 	bool ret;
 
-	if (!test_msr_mask(vcpu, msr->index))
+	if (!test_msr_mask(vcpu, msr->index, true))
 		return true;
 	if (static_call(kvm_x86_get_msr)(vcpu, &old_msr))
 		return true;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d3d061615536..ea2843027671 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -673,6 +673,16 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
 	unsigned long tmp;
 	u32 offset;
 
+#ifdef CONFIG_KVM_INTROSPECTION
+	if ((type & MSR_TYPE_W) &&
+	    kvmi_monitor_msrw_intercept(vcpu, msr, !value))
+		type &= ~MSR_TYPE_W;
+
+	/*
+	 * Avoid the below warning for kvmi intercepted msrs.
+	 */
+	if (!kvmi_msrw_intercept_originator(vcpu))
+#endif /* CONFIG_KVM_INTROSPECTION */
 	/*
 	 * If this warning triggers extend the direct_access_msrs list at the
 	 * beginning of the file
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 964840430537..1df0a29d1d8d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3798,6 +3798,12 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
+#ifdef CONFIG_KVM_INTROSPECTION
+	if ((type & MSR_TYPE_W) &&
+	    kvmi_monitor_msrw_intercept(vcpu, msr, false))
+		type &= ~MSR_TYPE_W;
+#endif /* CONFIG_KVM_INTROSPECTION */
+
 	if (static_branch_unlikely(&enable_evmcs))
 		evmcs_touch_msr_bitmap();
 
@@ -3843,6 +3849,11 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
+#ifdef CONFIG_KVM_INTROSPECTION
+	if (type & MSR_TYPE_W)
+		kvmi_monitor_msrw_intercept(vcpu, msr, true);
+#endif /* CONFIG_KVM_INTROSPECTION */
+
 	if (static_branch_unlikely(&enable_evmcs))
 		evmcs_touch_msr_bitmap();
 
