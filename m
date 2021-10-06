Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD804244DD
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239767AbhJFRnV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:43:21 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53572 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239311AbhJFRml (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:41 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id A4DE530827AD;
        Wed,  6 Oct 2021 20:31:19 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 89C603064495;
        Wed,  6 Oct 2021 20:31:19 +0300 (EEST)
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
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v12 61/77] KVM: introspection: add KVMI_VCPU_EVENT_XSETBV
Date:   Wed,  6 Oct 2021 20:30:57 +0300
Message-Id: <20211006173113.26445-62-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This event is sent when an extended control register XCR is going to
be changed.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 34 ++++++++
 arch/x86/include/asm/kvmi_host.h              |  4 +
 arch/x86/include/uapi/asm/kvmi.h              |  7 ++
 arch/x86/kvm/kvmi.c                           | 30 +++++++
 arch/x86/kvm/kvmi.h                           |  2 +
 arch/x86/kvm/kvmi_msg.c                       | 20 +++++
 arch/x86/kvm/x86.c                            |  6 ++
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 84 +++++++++++++++++++
 9 files changed, 188 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 1fbc2a03f5bd..d3a0bea64e02 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -541,6 +541,7 @@ the following events::
 	KVMI_VCPU_EVENT_BREAKPOINT
 	KVMI_VCPU_EVENT_CR
 	KVMI_VCPU_EVENT_HYPERCALL
+	KVMI_VCPU_EVENT_XSETBV
 
 When an event is enabled, the introspection tool is notified and
 must reply with: continue, retry, crash, etc. (see **Events** below).
@@ -1042,3 +1043,36 @@ other vCPU introspection event.
 (``nr``), exception code (``error_code``) and ``address`` are sent to
 the introspection tool, which should check if its exception has been
 injected or overridden.
+
+7. KVMI_VCPU_EVENT_XSETBV
+-------------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Actions: CONTINUE, CRASH
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_event;
+	struct kvmi_vcpu_event_xsetbv {
+		__u8 xcr;
+		__u8 padding[7];
+		__u64 old_value;
+		__u64 new_value;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_vcpu_event_reply;
+
+This event is sent when an extended control register XCR is going
+to be changed and the introspection has been enabled for this event
+(see *KVMI_VCPU_CONTROL_EVENTS*).
+
+``kvmi_vcpu_event`` (with the vCPU state), the extended control register
+number (``xcr``), the old value (``old_value``) and the new value
+(``new_value``) are sent to the introspection tool.
diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 97f5b1a01c9e..d66349208a6b 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -46,6 +46,8 @@ bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu);
 bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu, bool enable);
 void kvmi_enter_guest(struct kvm_vcpu *vcpu);
+void kvmi_xsetbv_event(struct kvm_vcpu *vcpu, u8 xcr,
+		       u64 old_value, u64 new_value);
 
 #else /* CONFIG_KVM_INTROSPECTION */
 
@@ -59,6 +61,8 @@ static inline bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu) { return false; }
 static inline bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu,
 						bool enable) { return false; }
 static inline void kvmi_enter_guest(struct kvm_vcpu *vcpu) { }
+static inline void kvmi_xsetbv_event(struct kvm_vcpu *vcpu, u8 xcr,
+					u64 old_value, u64 new_value) { }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index aa991fbab473..604a8b3d4ac2 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -95,4 +95,11 @@ struct kvmi_vcpu_inject_exception {
 	__u64 address;
 };
 
+struct kvmi_vcpu_event_xsetbv {
+	__u8 xcr;
+	__u8 padding[7];
+	__u64 old_value;
+	__u64 new_value;
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 93123d47752c..d34f5f03a56f 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -16,6 +16,7 @@ void kvmi_arch_init_vcpu_events_mask(unsigned long *supported)
 	set_bit(KVMI_VCPU_EVENT_CR, supported);
 	set_bit(KVMI_VCPU_EVENT_HYPERCALL, supported);
 	set_bit(KVMI_VCPU_EVENT_TRAP, supported);
+	set_bit(KVMI_VCPU_EVENT_XSETBV, supported);
 }
 
 static unsigned int kvmi_vcpu_mode(const struct kvm_vcpu *vcpu,
@@ -567,3 +568,32 @@ void kvmi_arch_send_pending_event(struct kvm_vcpu *vcpu)
 		kvmi_send_trap_event(vcpu);
 	}
 }
+
+static void __kvmi_xsetbv_event(struct kvm_vcpu *vcpu, u8 xcr,
+				u64 old_value, u64 new_value)
+{
+	u32 action;
+
+	action = kvmi_msg_send_vcpu_xsetbv(vcpu, xcr, old_value, new_value);
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu, action);
+	}
+}
+
+void kvmi_xsetbv_event(struct kvm_vcpu *vcpu, u8 xcr,
+		       u64 old_value, u64 new_value)
+{
+	struct kvm_introspection *kvmi;
+
+	kvmi = kvmi_get(vcpu->kvm);
+	if (!kvmi)
+		return;
+
+	if (is_vcpu_event_enabled(vcpu, KVMI_VCPU_EVENT_XSETBV))
+		__kvmi_xsetbv_event(vcpu, xcr, old_value, new_value);
+
+	kvmi_put(vcpu->kvm);
+}
diff --git a/arch/x86/kvm/kvmi.h b/arch/x86/kvm/kvmi.h
index 265fece148d2..43bc956d740c 100644
--- a/arch/x86/kvm/kvmi.h
+++ b/arch/x86/kvm/kvmi.h
@@ -14,5 +14,7 @@ int kvmi_arch_cmd_vcpu_inject_exception(struct kvm_vcpu *vcpu,
 u32 kvmi_msg_send_vcpu_cr(struct kvm_vcpu *vcpu, u32 cr, u64 old_value,
 			  u64 new_value, u64 *ret_value);
 u32 kvmi_msg_send_vcpu_trap(struct kvm_vcpu *vcpu);
+u32 kvmi_msg_send_vcpu_xsetbv(struct kvm_vcpu *vcpu, u8 xcr,
+			      u64 old_value, u64 new_value);
 
 #endif
diff --git a/arch/x86/kvm/kvmi_msg.c b/arch/x86/kvm/kvmi_msg.c
index 39cbab9f293a..c767b969df53 100644
--- a/arch/x86/kvm/kvmi_msg.c
+++ b/arch/x86/kvm/kvmi_msg.c
@@ -232,3 +232,23 @@ u32 kvmi_msg_send_vcpu_trap(struct kvm_vcpu *vcpu)
 
 	return action;
 }
+
+u32 kvmi_msg_send_vcpu_xsetbv(struct kvm_vcpu *vcpu, u8 xcr,
+			      u64 old_value, u64 new_value)
+{
+	struct kvmi_vcpu_event_xsetbv e;
+	u32 action;
+	int err;
+
+	memset(&e, 0, sizeof(e));
+	e.xcr = xcr;
+	e.old_value = old_value;
+	e.new_value = new_value;
+
+	err = kvmi_send_vcpu_event(vcpu, KVMI_VCPU_EVENT_XSETBV,
+				   &e, sizeof(e), NULL, 0, &action);
+	if (err)
+		action = KVMI_EVENT_ACTION_CONTINUE;
+
+	return action;
+}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bc017c2bf7bb..99b35e69029a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -995,6 +995,12 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 	}
 	vcpu->arch.xcr0 = xcr0;
 
+#ifdef CONFIG_KVM_INTROSPECTION
+	if (index == 0 && xcr0 != old_xcr0)
+		kvmi_xsetbv_event(vcpu, 0, old_xcr0, xcr0);
+#endif /* CONFIG_KVM_INTROSPECTION */
+
+
 	if ((xcr0 ^ old_xcr0) & XFEATURE_MASK_EXTEND)
 		kvm_update_cpuid_runtime(vcpu);
 	return 0;
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 263d98a5903e..4b71c6b0b16c 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -62,6 +62,7 @@ enum {
 	KVMI_VCPU_EVENT_BREAKPOINT = KVMI_VCPU_EVENT_ID(2),
 	KVMI_VCPU_EVENT_CR         = KVMI_VCPU_EVENT_ID(3),
 	KVMI_VCPU_EVENT_TRAP       = KVMI_VCPU_EVENT_ID(4),
+	KVMI_VCPU_EVENT_XSETBV     = KVMI_VCPU_EVENT_ID(5),
 
 	KVMI_NEXT_VCPU_EVENT
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 7814626cba77..380aa3d2d8f3 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -23,6 +23,8 @@
 
 #define VCPU_ID 1
 
+#define X86_FEATURE_XSAVE	(1<<26)
+
 static int socket_pair[2];
 #define Kvm_socket       socket_pair[0]
 #define Userspace_socket socket_pair[1]
@@ -57,6 +59,7 @@ enum {
 	GUEST_TEST_BP,
 	GUEST_TEST_CR,
 	GUEST_TEST_HYPERCALL,
+	GUEST_TEST_XSETBV,
 };
 
 #define GUEST_REQUEST_TEST()     GUEST_SYNC(0)
@@ -92,6 +95,45 @@ static void guest_hypercall_test(void)
 	asm volatile(".byte 0x0f,0x01,0xc1");
 }
 
+/* from fpu/internal.h */
+static u64 xgetbv(u32 index)
+{
+	u32 eax, edx;
+
+	asm volatile(".byte 0x0f,0x01,0xd0" /* xgetbv */
+		     : "=a" (eax), "=d" (edx)
+		     : "c" (index));
+	return eax + ((u64)edx << 32);
+}
+
+/* from fpu/internal.h */
+static void xsetbv(u32 index, u64 value)
+{
+	u32 eax = value;
+	u32 edx = value >> 32;
+
+	asm volatile(".byte 0x0f,0x01,0xd1" /* xsetbv */
+		     : : "a" (eax), "d" (edx), "c" (index));
+}
+
+static void guest_xsetbv_test(void)
+{
+	const int SSE_BIT = 1 << 1;
+	const int AVX_BIT = 1 << 2;
+	u64 xcr0;
+
+	/* avoid #UD */
+	set_cr4(get_cr4() | X86_CR4_OSXSAVE);
+
+	xcr0 = xgetbv(0);
+	if (xcr0 & AVX_BIT)
+		xcr0 &= ~AVX_BIT;
+	else
+		xcr0 |= (AVX_BIT | SSE_BIT);
+
+	xsetbv(0, xcr0);
+}
+
 static void guest_code(void)
 {
 	while (true) {
@@ -107,6 +149,9 @@ static void guest_code(void)
 		case GUEST_TEST_HYPERCALL:
 			guest_hypercall_test();
 			break;
+		case GUEST_TEST_XSETBV:
+			guest_xsetbv_test();
+			break;
 		}
 		GUEST_SIGNAL_TEST_DONE();
 	}
@@ -1322,6 +1367,44 @@ static void test_cmd_vcpu_inject_exception(struct kvm_vm *vm)
 	disable_vcpu_event(vm, KVMI_VCPU_EVENT_BREAKPOINT);
 }
 
+static void test_event_xsetbv(struct kvm_vm *vm)
+{
+	struct vcpu_worker_data data = {
+		.vm = vm,
+		.vcpu_id = VCPU_ID,
+		.test_id = GUEST_TEST_XSETBV,
+	};
+	__u16 event_id = KVMI_VCPU_EVENT_XSETBV;
+	struct kvm_cpuid_entry2 *entry;
+	struct vcpu_reply rpl = {};
+	struct kvmi_msg_hdr hdr;
+	pthread_t vcpu_thread;
+	struct {
+		struct vcpu_event vcpu_ev;
+		struct kvmi_vcpu_event_xsetbv xsetbv;
+	} ev;
+
+	entry = kvm_get_supported_cpuid_entry(1);
+	if (!(entry->ecx & X86_FEATURE_XSAVE)) {
+		print_skip("XSAVE not supported, ecx 0x%x", entry->ecx);
+		return;
+	}
+
+	enable_vcpu_event(vm, event_id);
+	vcpu_thread = start_vcpu_worker(&data);
+
+	receive_vcpu_event(&hdr, &ev.vcpu_ev, sizeof(ev), event_id);
+
+	pr_debug("XSETBV event, XCR%u, old 0x%llx, new 0x%llx\n",
+		 ev.xsetbv.xcr, ev.xsetbv.old_value, ev.xsetbv.new_value);
+
+	reply_to_event(&hdr, &ev.vcpu_ev, KVMI_EVENT_ACTION_CONTINUE,
+			&rpl, sizeof(rpl));
+
+	wait_vcpu_worker(vcpu_thread);
+	disable_vcpu_event(vm, event_id);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1347,6 +1430,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vm_control_cleanup(vm);
 	test_cmd_vcpu_control_cr(vm);
 	test_cmd_vcpu_inject_exception(vm);
+	test_event_xsetbv(vm);
 
 	unhook_introspection(vm);
 }
