Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D89F155DA1
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbgBGSR3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:17:29 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40614 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727635AbgBGSQx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:53 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 90790305D35E;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 7B3833052074;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 64/78] KVM: introspection: add KVMI_EVENT_XSETBV
Date:   Fri,  7 Feb 2020 20:16:22 +0200
Message-Id: <20200207181636.1065-65-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This event is sent when the extended control register XCR0 is going to
be changed.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 26 ++++++
 arch/x86/include/asm/kvmi_host.h              |  2 +
 arch/x86/kvm/x86.c                            |  6 ++
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 83 +++++++++++++++++++
 virt/kvm/introspection/kvmi_int.h             |  1 +
 virt/kvm/introspection/kvmi_msg.c             | 39 +++++++++
 7 files changed, 158 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index c1badcde1662..8b43e0f80f77 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -534,6 +534,7 @@ the following events::
 	KVMI_EVENT_CR
 	KVMI_EVENT_HYPERCALL
 	KVMI_EVENT_TRAP
+	KVMI_EVENT_XSETBV
 
 When an event is enabled, the introspection tool is notified and it
 must reply with: continue, retry, crash, etc. (see **Events** below).
@@ -999,3 +1000,28 @@ took place and the introspection has been enabled for this event
 ``kvmi_event``, exception/interrupt number (vector), exception code
 (``error_code``) and CR2 are sent to the introspection tool,
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
+
+:Returns:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_event_reply;
+
+This event is sent when the extended control register XCR0 is going
+to be changed and the introspection has been enabled for this event
+(see *KVMI_VCPU_CONTROL_EVENTS*).
+
+``kvmi_event`` is sent to the introspection tool.
diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 24f3f8fdee62..b3fa950362db 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -30,6 +30,7 @@ bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 		   unsigned long old_value, unsigned long *new_value);
 bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu);
 bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu, bool enable);
+void kvmi_xsetbv_event(struct kvm_vcpu *vcpu);
 
 #else /* CONFIG_KVM_INTROSPECTION */
 
@@ -41,6 +42,7 @@ static inline bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 static inline bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu) { return false; }
 static inline bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu,
 						bool enable) { return false; }
+static inline void kvmi_xsetbv_event(struct kvm_vcpu *vcpu) { }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ff61123ce4bd..fa583f82298e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -866,6 +866,12 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 	}
 	vcpu->arch.xcr0 = xcr0;
 
+#ifdef CONFIG_KVM_INTROSPECTION
+	if (index == 0 && xcr0 != old_xcr0)
+		kvmi_xsetbv_event(vcpu);
+#endif /* CONFIG_KVM_INTROSPECTION */
+
+
 	if ((xcr0 ^ old_xcr0) & XFEATURE_MASK_EXTEND)
 		kvm_update_cpuid(vcpu);
 	return 0;
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 70d5a67badef..3ea4882ac469 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -47,6 +47,7 @@ enum {
 	KVMI_EVENT_BREAKPOINT = 3,
 	KVMI_EVENT_CR         = 4,
 	KVMI_EVENT_TRAP       = 5,
+	KVMI_EVENT_XSETBV     = 6,
 
 	KVMI_NUM_EVENTS
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 2852e6894e81..299f4d29d0d6 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -21,6 +21,8 @@
 
 #define VCPU_ID         5
 
+#define X86_FEATURE_XSAVE	(1<<26)
+
 static int socket_pair[2];
 #define Kvm_socket       socket_pair[0]
 #define Userspace_socket socket_pair[1]
@@ -53,6 +55,7 @@ enum {
 	GUEST_TEST_BP,
 	GUEST_TEST_CR,
 	GUEST_TEST_HYPERCALL,
+	GUEST_TEST_XSETBV,
 };
 
 #define GUEST_REQUEST_TEST()     GUEST_SYNC(0)
@@ -84,6 +87,45 @@ static void guest_hypercall_test(void)
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
@@ -99,6 +141,9 @@ static void guest_code(void)
 		case GUEST_TEST_HYPERCALL:
 			guest_hypercall_test();
 			break;
+		case GUEST_TEST_XSETBV:
+			guest_xsetbv_test();
+			break;
 		}
 		GUEST_SIGNAL_TEST_DONE();
 	}
@@ -1240,6 +1285,43 @@ static void test_cmd_vm_get_max_gfn(void)
 	DEBUG("max_gfn: 0x%llx\n", rpl.gfn);
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
+	struct kvmi_event ev;
+
+	entry = kvm_get_supported_cpuid_entry(1);
+	if (!(entry->ecx & X86_FEATURE_XSAVE)) {
+		DEBUG("XSAVE is not supported, ecx 0x%x, skipping xsetbv test\n",
+			entry->ecx);
+		return;
+	}
+
+	enable_vcpu_event(vm, event_id);
+
+	vcpu_thread = start_vcpu_worker(&data);
+
+	receive_event(&hdr, &ev, sizeof(ev), event_id);
+
+	DEBUG("XSETBV event, rip 0x%llx\n", ev.arch.regs.rip);
+
+	reply_to_event(&hdr, &ev, KVMI_EVENT_ACTION_CONTINUE,
+			&rpl, sizeof(rpl));
+
+	stop_vcpu_worker(vcpu_thread, &data);
+
+	disable_vcpu_event(vm, event_id);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	setup_socket();
@@ -1264,6 +1346,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_control_cr(vm);
 	test_cmd_vcpu_inject_exception(vm);
 	test_cmd_vm_get_max_gfn();
+	test_event_xsetbv(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 65a5801f143c..5a00e38c88cc 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -27,6 +27,7 @@
 			  | BIT(KVMI_EVENT_HYPERCALL) \
 			  | BIT(KVMI_EVENT_TRAP) \
 			  | BIT(KVMI_EVENT_PAUSE_VCPU) \
+			  | BIT(KVMI_EVENT_XSETBV) \
 		)
 
 #define KVMI_KNOWN_EVENTS (KVMI_KNOWN_VM_EVENTS | KVMI_KNOWN_VCPU_EVENTS)
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 94fab70b56fa..ba2d7c6acb22 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -956,3 +956,42 @@ u32 kvmi_msg_send_bp(struct kvm_vcpu *vcpu, u64 gpa, u8 insn_len)
 
 	return action;
 }
+
+static u32 kvmi_send_xsetbv(struct kvm_vcpu *vcpu)
+{
+	int err, action;
+
+	err = kvmi_send_event(vcpu, KVMI_EVENT_XSETBV, NULL, 0,
+			      NULL, 0, &action);
+	if (err)
+		return KVMI_EVENT_ACTION_CONTINUE;
+
+	return action;
+}
+
+static void __kvmi_xsetbv_event(struct kvm_vcpu *vcpu)
+{
+	u32 action;
+
+	action = kvmi_send_xsetbv(vcpu);
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu->kvm, action, "XSETBV");
+	}
+}
+
+void kvmi_xsetbv_event(struct kvm_vcpu *vcpu)
+{
+	struct kvm_introspection *kvmi;
+
+	kvmi = kvmi_get(vcpu->kvm);
+	if (!kvmi)
+		return;
+
+	if (is_event_enabled(vcpu, KVMI_EVENT_XSETBV))
+		__kvmi_xsetbv_event(vcpu);
+
+	kvmi_put(vcpu->kvm);
+}
