Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACD9228A7B
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731205AbgGUVP4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:15:56 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37774 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731185AbgGUVPz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:15:55 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id E2DEA305D4FC;
        Wed, 22 Jul 2020 00:09:29 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id C2118304FA14;
        Wed, 22 Jul 2020 00:09:29 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 68/84] KVM: introspection: add KVMI_EVENT_XSETBV
Date:   Wed, 22 Jul 2020 00:09:06 +0300
Message-Id: <20200721210922.7646-69-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This event is sent when an extended control register XCR is going to
be changed.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 33 ++++++++
 arch/x86/include/asm/kvmi_host.h              |  4 +
 arch/x86/include/uapi/asm/kvmi.h              |  7 ++
 arch/x86/kvm/kvmi.c                           | 48 +++++++++++
 arch/x86/kvm/x86.c                            |  6 ++
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 84 +++++++++++++++++++
 virt/kvm/introspection/kvmi.c                 |  1 +
 8 files changed, 184 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 7da8efd18b89..283e9a2dfda1 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -552,6 +552,7 @@ the following events::
 	KVMI_EVENT_BREAKPOINT
 	KVMI_EVENT_CR
 	KVMI_EVENT_HYPERCALL
+	KVMI_EVENT_XSETBV
 
 When an event is enabled, the introspection tool is notified and
 must reply with: continue, retry, crash, etc. (see **Events** below).
@@ -1053,3 +1054,35 @@ other vCPU introspection event.
 ``kvmi_event``, exception/interrupt number, exception code
 (``error_code``) and address are sent to the introspection tool,
 which should check if its exception has been injected or overridden.
+
+7. KVMI_EVENT_XSETBV
+--------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Actions: CONTINUE, CRASH
+:Parameters:
+
+::
+
+	struct kvmi_event;
+	struct kvmi_event_xsetbv {
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
+	struct kvmi_event_reply;
+
+This event is sent when the extended control register XCR is going
+to be changed and the introspection has been enabled for this event
+(see *KVMI_VCPU_CONTROL_EVENTS*).
+
+``kvmi_event``, the extended control register number, the old value and
+the new value are sent to the introspection tool.
diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 44580f77e34e..aed8a4b88a68 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -33,6 +33,8 @@ bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 		   unsigned long old_value, unsigned long *new_value);
 bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu);
 bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu, bool enable);
+void kvmi_xsetbv_event(struct kvm_vcpu *vcpu, u8 xcr,
+		       u64 old_value, u64 new_value);
 
 #else /* CONFIG_KVM_INTROSPECTION */
 
@@ -45,6 +47,8 @@ static inline bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 static inline bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu) { return false; }
 static inline bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu,
 						bool enable) { return false; }
+static inline void kvmi_xsetbv_event(struct kvm_vcpu *vcpu, u8 xcr,
+					u64 old_value, u64 new_value) { }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 4c59c9fe6b00..2f69a4f5d2e0 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -83,4 +83,11 @@ struct kvmi_event_cr_reply {
 	__u64 new_val;
 };
 
+struct kvmi_event_xsetbv {
+	__u8 xcr;
+	__u8 padding[7];
+	__u64 old_value;
+	__u64 new_value;
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 0c6ab136084f..55c5e290730c 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -672,3 +672,51 @@ void kvmi_arch_send_trap_event(struct kvm_vcpu *vcpu)
 		kvmi_handle_common_event_actions(vcpu->kvm, action);
 	}
 }
+
+static u32 kvmi_send_xsetbv(struct kvm_vcpu *vcpu, u8 xcr, u64 old_value,
+			    u64 new_value)
+{
+	struct kvmi_event_xsetbv e;
+	int err, action;
+
+	memset(&e, 0, sizeof(e));
+	e.xcr = xcr;
+	e.old_value = old_value;
+	e.new_value = new_value;
+
+	err = kvmi_send_event(vcpu, KVMI_EVENT_XSETBV, &e, sizeof(e),
+			      NULL, 0, &action);
+	if (err)
+		return KVMI_EVENT_ACTION_CONTINUE;
+
+	return action;
+}
+
+static void __kvmi_xsetbv_event(struct kvm_vcpu *vcpu, u8 xcr,
+				u64 old_value, u64 new_value)
+{
+	u32 action;
+
+	action = kvmi_send_xsetbv(vcpu, xcr, old_value, new_value);
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu->kvm, action);
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
+	if (is_event_enabled(vcpu, KVMI_EVENT_XSETBV))
+		__kvmi_xsetbv_event(vcpu, xcr, old_value, new_value);
+
+	kvmi_put(vcpu->kvm);
+}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index af987ad1a174..c3557a11817f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -919,6 +919,12 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 	}
 	vcpu->arch.xcr0 = xcr0;
 
+#ifdef CONFIG_KVM_INTROSPECTION
+	if (index == 0 && xcr0 != old_xcr0)
+		kvmi_xsetbv_event(vcpu, 0, old_xcr0, xcr0);
+#endif /* CONFIG_KVM_INTROSPECTION */
+
+
 	if ((xcr0 ^ old_xcr0) & XFEATURE_MASK_EXTEND)
 		kvm_update_cpuid(vcpu);
 	return 0;
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 2a4cc8c41465..348a9a551091 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -49,6 +49,7 @@ enum {
 	KVMI_EVENT_BREAKPOINT = 3,
 	KVMI_EVENT_CR         = 4,
 	KVMI_EVENT_TRAP       = 5,
+	KVMI_EVENT_XSETBV     = 6,
 
 	KVMI_NUM_EVENTS
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 105adf75a68d..0569185a7064 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -22,6 +22,8 @@
 
 #define VCPU_ID         5
 
+#define X86_FEATURE_XSAVE	(1<<26)
+
 static int socket_pair[2];
 #define Kvm_socket       socket_pair[0]
 #define Userspace_socket socket_pair[1]
@@ -54,6 +56,7 @@ enum {
 	GUEST_TEST_BP,
 	GUEST_TEST_CR,
 	GUEST_TEST_HYPERCALL,
+	GUEST_TEST_XSETBV,
 };
 
 #define GUEST_REQUEST_TEST()     GUEST_SYNC(0)
@@ -89,6 +92,45 @@ static void guest_hypercall_test(void)
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
@@ -104,6 +146,9 @@ static void guest_code(void)
 		case GUEST_TEST_HYPERCALL:
 			guest_hypercall_test();
 			break;
+		case GUEST_TEST_XSETBV:
+			guest_xsetbv_test();
+			break;
 		}
 		GUEST_SIGNAL_TEST_DONE();
 	}
@@ -1431,6 +1476,44 @@ static void test_cmd_vm_get_max_gfn(void)
 	pr_info("max_gfn: 0x%llx\n", rpl.gfn);
 }
 
+static void test_event_xsetbv(struct kvm_vm *vm)
+{
+	struct vcpu_worker_data data = {
+		.vm = vm,
+		.vcpu_id = VCPU_ID,
+		.test_id = GUEST_TEST_XSETBV,
+	};
+	__u16 event_id = KVMI_EVENT_XSETBV;
+	struct kvm_cpuid_entry2 *entry;
+	struct vcpu_reply rpl = {};
+	struct kvmi_msg_hdr hdr;
+	pthread_t vcpu_thread;
+	struct {
+		struct kvmi_event common;
+		struct kvmi_event_xsetbv xsetbv;
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
+	receive_event(&hdr, &ev.common, sizeof(ev), event_id);
+
+	pr_debug("XSETBV event, XCR%u, old 0x%llx, new 0x%llx\n",
+		 ev.xsetbv.xcr, ev.xsetbv.old_value, ev.xsetbv.new_value);
+
+	reply_to_event(&hdr, &ev.common, KVMI_EVENT_ACTION_CONTINUE,
+			&rpl, sizeof(rpl));
+
+	stop_vcpu_worker(vcpu_thread, &data);
+	disable_vcpu_event(vm, event_id);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1457,6 +1540,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_control_cr(vm);
 	test_cmd_vcpu_inject_exception(vm);
 	test_cmd_vm_get_max_gfn();
+	test_event_xsetbv(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index d4b39d0800ee..761d3fccddce 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -102,6 +102,7 @@ static void setup_known_events(void)
 	set_bit(KVMI_EVENT_HYPERCALL, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_PAUSE_VCPU, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_TRAP, Kvmi_known_vcpu_events);
+	set_bit(KVMI_EVENT_XSETBV, Kvmi_known_vcpu_events);
 
 	bitmap_or(Kvmi_known_events, Kvmi_known_vm_events,
 		  Kvmi_known_vcpu_events, KVMI_NUM_EVENTS);
