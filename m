Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C84E519792F
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729330AbgC3KTy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:19:54 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43778 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729199AbgC3KTx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:19:53 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 0E0F4304C0C4;
        Mon, 30 Mar 2020 13:13:00 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id D99EC305B7A1;
        Mon, 30 Mar 2020 13:12:59 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 67/81] KVM: introspection: add KVMI_EVENT_XSETBV
Date:   Mon, 30 Mar 2020 13:12:54 +0300
Message-Id: <20200330101308.21702-68-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
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
 Documentation/virt/kvm/kvmi.rst               | 25 ++++++
 arch/x86/include/asm/kvmi_host.h              |  2 +
 arch/x86/kvm/kvmi.c                           | 39 +++++++++
 arch/x86/kvm/x86.c                            |  6 ++
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 83 +++++++++++++++++++
 virt/kvm/introspection/kvmi.c                 |  1 +
 7 files changed, 157 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 1c5e256975fe..06ed05f4791b 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -549,6 +549,7 @@ the following events::
 	KVMI_EVENT_BREAKPOINT
 	KVMI_EVENT_CR
 	KVMI_EVENT_HYPERCALL
+	KVMI_EVENT_XSETBV
 
 When an event is enabled, the introspection tool is notified and
 must reply with: continue, retry, crash, etc. (see **Events** below).
@@ -1019,3 +1020,27 @@ other vCPU introspection event.
 (``error_code``) and CR2 are sent to the introspection tool,
 which should check if its exception has been injected or overridden.
 
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
 
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 9f8ef8a1a306..f947f18e9d72 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -662,3 +662,42 @@ void kvmi_arch_trap_event(struct kvm_vcpu *vcpu)
 		kvmi_handle_common_event_actions(vcpu->kvm, action, "TRAP");
 	}
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
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0e3704bed6c4..ab0ad3b6ebc2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -865,6 +865,12 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
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
index d33e8dae0084..ecf140ba3cab 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -46,6 +46,7 @@ enum {
 	KVMI_EVENT_BREAKPOINT = 3,
 	KVMI_EVENT_CR         = 4,
 	KVMI_EVENT_TRAP       = 5,
+	KVMI_EVENT_XSETBV     = 6,
 
 	KVMI_NUM_EVENTS
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 66766d112006..3a45834e9235 100644
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
@@ -85,6 +88,45 @@ static void guest_hypercall_test(void)
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
@@ -100,6 +142,9 @@ static void guest_code(void)
 		case GUEST_TEST_HYPERCALL:
 			guest_hypercall_test();
 			break;
+		case GUEST_TEST_XSETBV:
+			guest_xsetbv_test();
+			break;
 		}
 		GUEST_SIGNAL_TEST_DONE();
 	}
@@ -1243,6 +1288,43 @@ static void test_cmd_vm_get_max_gfn(void)
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
 	srandom(time(0));
@@ -1268,6 +1350,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_control_cr(vm);
 	test_cmd_vcpu_inject_exception(vm);
 	test_cmd_vm_get_max_gfn();
+	test_event_xsetbv(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 0f2cec7e9c90..d358686fce76 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -83,6 +83,7 @@ static void setup_known_events(void)
 	set_bit(KVMI_EVENT_HYPERCALL, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_PAUSE_VCPU, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_TRAP, Kvmi_known_vcpu_events);
+	set_bit(KVMI_EVENT_XSETBV, Kvmi_known_vcpu_events);
 
 	bitmap_or(Kvmi_known_events, Kvmi_known_vm_events,
 		  Kvmi_known_vcpu_events, KVMI_NUM_EVENTS);
