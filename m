Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2ADB155D8F
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgBGSQ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:16:58 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40710 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727738AbgBGSQ4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:56 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id CB156305D364;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id BC7D83052068;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 70/78] KVM: introspection: restore the state of MSR interception on unhook
Date:   Fri,  7 Feb 2020 20:16:28 +0200
Message-Id: <20200207181636.1065-71-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <ncitu@bitdefender.com>

This commit also ensures that the introspection tool and the userspace
do not disable each other the MSR access VM-exit.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvmi_host.h |  12 ++++
 arch/x86/kvm/kvmi.c              | 119 +++++++++++++++++++++++++++----
 arch/x86/kvm/svm.c               |  11 +++
 arch/x86/kvm/vmx/vmx.c           |  11 +++
 4 files changed, 139 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index f9aaff45d082..875778d80176 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -23,6 +23,12 @@ struct kvmi_interception {
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
 
@@ -44,6 +50,8 @@ void kvmi_xsetbv_event(struct kvm_vcpu *vcpu);
 bool kvmi_monitor_desc_intercept(struct kvm_vcpu *vcpu, bool enable);
 bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, u8 write);
 bool kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr);
+bool kvmi_monitor_msrw_intercept(struct kvm_vcpu *vcpu, u32 msr, bool enable);
+bool kvmi_msrw_intercept_originator(struct kvm_vcpu *vcpu);
 
 #else /* CONFIG_KVM_INTROSPECTION */
 
@@ -62,6 +70,10 @@ static inline bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor,
 					 u8 write) { return true; }
 static inline bool kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr)
 				{ return true; }
+static inline bool kvmi_monitor_msrw_intercept(struct kvm_vcpu *vcpu, u32 msr,
+					       bool enable) { return false; }
+static inline bool kvmi_msrw_intercept_originator(struct kvm_vcpu *vcpu)
+				{ return false; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 7705ac155c84..bed6e02697ca 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -369,22 +369,25 @@ static void kvmi_arch_disable_desc_intercept(struct kvm_vcpu *vcpu)
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
@@ -392,9 +395,27 @@ static bool test_msr_mask(struct kvm_vcpu *vcpu, unsigned int msr)
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
+		       bool kvmi)
 {
-	unsigned long *mask = msr_mask(vcpu, &msr);
+	unsigned long *mask = msr_mask(vcpu, &msr, kvmi);
 
 	if (!mask)
 		return false;
@@ -407,6 +428,63 @@ static bool msr_control(struct kvm_vcpu *vcpu, unsigned int msr, bool enable)
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
+		if (kvm_x86_ops->msr_write_intercepted(vcpu, msr))
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
@@ -415,6 +493,14 @@ static unsigned int msr_mask_to_base(struct kvm_vcpu *vcpu, unsigned long *mask)
 	return 0;
 }
 
+static void kvmi_control_msrw_intercept(struct kvm_vcpu *vcpu, u32 msr,
+					bool enable)
+{
+	vcpu->arch.kvmi->msrw.monitor_fct = monitor_msrw_fct_kvmi;
+	kvm_x86_ops->control_msr_intercept(vcpu, msr, MSR_TYPE_W, enable);
+	vcpu->arch.kvmi->msrw.monitor_fct = monitor_msrw_fct_kvm;
+}
+
 static void kvmi_arch_disable_msr_intercept(struct kvm_vcpu *vcpu,
 					    unsigned long *mask)
 {
@@ -427,9 +513,7 @@ static void kvmi_arch_disable_msr_intercept(struct kvm_vcpu *vcpu,
 		if (offset >= KVMI_NUM_MSR)
 			break;
 
-		kvm_x86_ops->control_msr_intercept(vcpu, msr_base + offset,
-						   MSR_TYPE_W, false);
-		msr_control(vcpu, msr_base + offset, false);
+		kvmi_control_msrw_intercept(vcpu, msr_base + offset, false);
 	}
 
 	bitmap_zero(mask, KVMI_NUM_MSR);
@@ -501,12 +585,14 @@ bool kvmi_arch_vcpu_alloc(struct kvm_vcpu *vcpu)
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
@@ -823,6 +909,13 @@ static bool kvmi_msr_valid(unsigned int msr)
 	return false;
 }
 
+bool kvmi_msrw_intercept_originator(struct kvm_vcpu *vcpu)
+{
+	struct kvmi_interception *arch = vcpu->arch.kvmi;
+
+	return (arch && arch->msrw.monitor_fct == monitor_msrw_fct_kvmi);
+}
+EXPORT_SYMBOL(kvmi_msrw_intercept_originator);
 
 int kvmi_arch_cmd_vcpu_control_msr(struct kvm_vcpu *vcpu,
 				   const struct kvmi_vcpu_control_msr *req)
@@ -833,9 +926,7 @@ int kvmi_arch_cmd_vcpu_control_msr(struct kvm_vcpu *vcpu,
 	if (!kvmi_msr_valid(req->msr))
 		return -KVM_EINVAL;
 
-	kvm_x86_ops->control_msr_intercept(vcpu, req->msr, MSR_TYPE_W,
-					   req->enable);
-	msr_control(vcpu, req->msr, req->enable);
+	kvmi_control_msrw_intercept(vcpu, req->msr, req->enable);
 
 	return 0;
 }
@@ -872,7 +963,7 @@ static bool __kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	u64 ret_value;
 	u32 action;
 
-	if (!test_msr_mask(vcpu, msr->index))
+	if (!test_msr_mask(vcpu, msr->index, true))
 		return true;
 	if (kvm_x86_ops->get_msr(vcpu, &old_msr))
 		return true;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 7cd48ef25f59..309a7e5e8b62 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1085,6 +1085,17 @@ static void set_msr_interception(struct kvm_vcpu *vcpu,
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
+
 	/*
 	 * If this warning triggers extend the direct_access_msrs list at the
 	 * beginning of the file
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e423dbbf3cf5..2aaa74caefff 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3630,6 +3630,12 @@ static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
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
 
@@ -3669,6 +3675,11 @@ static __always_inline void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
+#ifdef CONFIG_KVM_INTROSPECTION
+	if (type & MSR_TYPE_W)
+		kvmi_monitor_msrw_intercept(vcpu, msr, true);
+#endif /* CONFIG_KVM_INTROSPECTION */
+
 	if (static_branch_unlikely(&enable_evmcs))
 		evmcs_touch_msr_bitmap();
 
