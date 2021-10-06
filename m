Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E58D4244C4
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239618AbhJFRnA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:43:00 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53576 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239158AbhJFRmi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:38 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 69B35305D36A;
        Wed,  6 Oct 2021 20:31:17 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 521793064495;
        Wed,  6 Oct 2021 20:31:17 +0300 (EEST)
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
Subject: [PATCH v12 56/77] KVM: introspection: restore the state of #BP interception on unhook
Date:   Wed,  6 Oct 2021 20:30:52 +0300
Message-Id: <20211006173113.26445-57-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <nicu.citu@icloud.com>

This commit also ensures that only the userspace or the introspection
tool can control the #BP interception exclusively at one time.

Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvmi_host.h | 18 ++++++++++
 arch/x86/kvm/kvmi.c              | 60 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c               |  5 +++
 3 files changed, 83 insertions(+)

diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index b776be4bb49f..e008662f91a5 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -4,8 +4,15 @@
 
 #include <asm/kvmi.h>
 
+struct kvmi_monitor_interception {
+	bool kvmi_intercepted;
+	bool kvm_intercepted;
+	bool (*monitor_fct)(struct kvm_vcpu *vcpu, bool enable);
+};
+
 struct kvmi_interception {
 	bool restore_interception;
+	struct kvmi_monitor_interception breakpoint;
 };
 
 struct kvm_vcpu_arch_introspection {
@@ -16,4 +23,15 @@ struct kvm_vcpu_arch_introspection {
 struct kvm_arch_introspection {
 };
 
+#ifdef CONFIG_KVM_INTROSPECTION
+
+bool kvmi_monitor_bp_intercept(struct kvm_vcpu *vcpu, u32 dbg);
+
+#else /* CONFIG_KVM_INTROSPECTION */
+
+static inline bool kvmi_monitor_bp_intercept(struct kvm_vcpu *vcpu, u32 dbg)
+	{ return false; }
+
+#endif /* CONFIG_KVM_INTROSPECTION */
+
 #endif /* _ASM_X86_KVMI_HOST_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 6a7fc8059f23..2bbeadb9daba 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -162,19 +162,72 @@ bool kvmi_arch_is_agent_hypercall(struct kvm_vcpu *vcpu)
 		&& subfunc2 == 0);
 }
 
+/*
+ * Returns true if one side (kvm or kvmi) tries to enable/disable the breakpoint
+ * interception while the other side is still tracking it.
+ */
+bool kvmi_monitor_bp_intercept(struct kvm_vcpu *vcpu, u32 dbg)
+{
+	struct kvmi_interception *arch_vcpui = READ_ONCE(vcpu->arch.kvmi);
+	u32 bp_mask = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP;
+	bool enable = false;
+
+	if ((dbg & bp_mask) == bp_mask)
+		enable = true;
+
+	return (arch_vcpui && arch_vcpui->breakpoint.monitor_fct(vcpu, enable));
+}
+EXPORT_SYMBOL(kvmi_monitor_bp_intercept);
+
+static bool monitor_bp_fct_kvmi(struct kvm_vcpu *vcpu, bool enable)
+{
+	if (enable) {
+		if (static_call(kvm_x86_bp_intercepted)(vcpu))
+			return true;
+	} else if (!vcpu->arch.kvmi->breakpoint.kvmi_intercepted)
+		return true;
+
+	vcpu->arch.kvmi->breakpoint.kvmi_intercepted = enable;
+
+	return false;
+}
+
+static bool monitor_bp_fct_kvm(struct kvm_vcpu *vcpu, bool enable)
+{
+	if (enable) {
+		if (static_call(kvm_x86_bp_intercepted)(vcpu))
+			return true;
+	} else if (!vcpu->arch.kvmi->breakpoint.kvm_intercepted)
+		return true;
+
+	vcpu->arch.kvmi->breakpoint.kvm_intercepted = enable;
+
+	return false;
+}
+
 static int kvmi_control_bp_intercept(struct kvm_vcpu *vcpu, bool enable)
 {
 	struct kvm_guest_debug dbg = {};
 	int err = 0;
 
+	vcpu->arch.kvmi->breakpoint.monitor_fct = monitor_bp_fct_kvmi;
 	if (enable)
 		dbg.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP;
 
 	err = kvm_arch_vcpu_set_guest_debug(vcpu, &dbg);
+	vcpu->arch.kvmi->breakpoint.monitor_fct = monitor_bp_fct_kvm;
 
 	return err;
 }
 
+static void kvmi_arch_disable_bp_intercept(struct kvm_vcpu *vcpu)
+{
+	kvmi_control_bp_intercept(vcpu, false);
+
+	vcpu->arch.kvmi->breakpoint.kvmi_intercepted = false;
+	vcpu->arch.kvmi->breakpoint.kvm_intercepted = false;
+}
+
 int kvmi_arch_cmd_control_intercept(struct kvm_vcpu *vcpu,
 				    unsigned int event_id, bool enable)
 {
@@ -213,6 +266,7 @@ void kvmi_arch_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len)
 
 static void kvmi_arch_restore_interception(struct kvm_vcpu *vcpu)
 {
+	kvmi_arch_disable_bp_intercept(vcpu);
 }
 
 bool kvmi_arch_clean_up_interception(struct kvm_vcpu *vcpu)
@@ -238,6 +292,12 @@ bool kvmi_arch_vcpu_alloc_interception(struct kvm_vcpu *vcpu)
 	if (!arch_vcpui)
 		return false;
 
+	arch_vcpui->breakpoint.monitor_fct = monitor_bp_fct_kvm;
+
+	/* pair with kvmi_monitor_bp_intercept() */
+	smp_wmb();
+	WRITE_ONCE(vcpu->arch.kvmi, arch_vcpui);
+
 	return true;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 415934624afb..f192c713b740 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10533,6 +10533,11 @@ int kvm_arch_vcpu_set_guest_debug(struct kvm_vcpu *vcpu,
 			kvm_queue_exception(vcpu, BP_VECTOR);
 	}
 
+	if (kvmi_monitor_bp_intercept(vcpu, dbg->control)) {
+		r = -EBUSY;
+		goto out;
+	}
+
 	/*
 	 * Read rflags as long as potentially injected trace flags are still
 	 * filtered out.
