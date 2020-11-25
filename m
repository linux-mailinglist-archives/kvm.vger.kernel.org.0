Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC582C3C9B
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbgKYJmR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:17 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57188 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728590AbgKYJmK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:42:10 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 4645A305D461;
        Wed, 25 Nov 2020 11:35:49 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 278B63072784;
        Wed, 25 Nov 2020 11:35:49 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 40/81] KVM: introspection: add KVMI_VM_EVENT_UNHOOK
Date:   Wed, 25 Nov 2020 11:35:19 +0200
Message-Id: <20201125093600.2766-41-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This event is sent when the guest is about to be
paused/suspended/migrated. The introspection tool has the chance to
remove its hooks (e.g. breakpoints) while the guest is still running.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 31 +++++++++
 arch/x86/kvm/Makefile                         |  2 +-
 arch/x86/kvm/kvmi.c                           | 10 +++
 include/linux/kvmi_host.h                     |  2 +
 include/uapi/linux/kvmi.h                     |  9 +++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 68 ++++++++++++++++++-
 virt/kvm/introspection/kvmi.c                 | 13 +++-
 virt/kvm/introspection/kvmi_int.h             |  3 +
 virt/kvm/introspection/kvmi_msg.c             | 42 +++++++++++-
 9 files changed, 173 insertions(+), 7 deletions(-)
 create mode 100644 arch/x86/kvm/kvmi.c

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 33490bc9d1c1..e9c40c7ae154 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -331,3 +331,34 @@ This command is always allowed.
 	};
 
 Returns the number of online vCPUs.
+
+Events
+======
+
+The VM introspection events are sent using the KVMI_VM_EVENT message id.
+The message data begins with a common structure having the event id::
+
+	struct kvmi_event_hdr {
+		__u16 event;
+		__u16 padding[3];
+	};
+
+Specific event data can follow this common structure.
+
+1. KVMI_VM_EVENT_UNHOOK
+-----------------------
+
+:Architectures: all
+:Versions: >= 1
+:Actions: none
+:Parameters:
+
+::
+
+	struct kvmi_event_hdr;
+
+:Returns: none
+
+This event is sent when the device manager has to pause/stop/migrate the
+guest (see **Unhooking**).  The introspection tool has a chance to unhook
+and close the KVMI channel (signaling that the operation can proceed).
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index db4121b4112d..8fad40649bcf 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -14,7 +14,7 @@ kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
 				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o \
 				$(KVM)/dirty_ring.o
 kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
-kvm-$(CONFIG_KVM_INTROSPECTION) += $(KVMI)/kvmi.o $(KVMI)/kvmi_msg.o
+kvm-$(CONFIG_KVM_INTROSPECTION) += $(KVMI)/kvmi.o $(KVMI)/kvmi_msg.o kvmi.o
 
 kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
new file mode 100644
index 000000000000..35742d927be5
--- /dev/null
+++ b/arch/x86/kvm/kvmi.c
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KVM introspection - x86
+ *
+ * Copyright (C) 2019-2020 Bitdefender S.R.L.
+ */
+
+void kvmi_arch_init_vcpu_events_mask(unsigned long *supported)
+{
+}
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 81eac9f53a3f..6476c7d6a4d3 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -17,6 +17,8 @@ struct kvm_introspection {
 
 	unsigned long *cmd_allow_mask;
 	unsigned long *event_allow_mask;
+
+	atomic_t ev_seq;
 };
 
 int kvmi_version(void);
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index e06a7b80d4d9..18fb51078d48 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -17,6 +17,8 @@ enum {
 #define KVMI_VCPU_MESSAGE_ID(id) (((id) << 1) | 1)
 
 enum {
+	KVMI_VM_EVENT = KVMI_VM_MESSAGE_ID(0),
+
 	KVMI_GET_VERSION      = KVMI_VM_MESSAGE_ID(1),
 	KVMI_VM_CHECK_COMMAND = KVMI_VM_MESSAGE_ID(2),
 	KVMI_VM_CHECK_EVENT   = KVMI_VM_MESSAGE_ID(3),
@@ -33,6 +35,8 @@ enum {
 #define KVMI_VCPU_EVENT_ID(id) (((id) << 1) | 1)
 
 enum {
+	KVMI_VM_EVENT_UNHOOK = KVMI_VM_EVENT_ID(0),
+
 	KVMI_NEXT_VM_EVENT
 };
 
@@ -73,4 +77,9 @@ struct kvmi_vm_get_info_reply {
 	__u32 padding[3];
 };
 
+struct kvmi_event_hdr {
+	__u16 event;
+	__u16 padding[3];
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index d60ee23fa833..01b260379c2a 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -68,6 +68,11 @@ static void set_event_perm(struct kvm_vm *vm, __s32 id, __u32 allow,
 		 "KVM_INTROSPECTION_EVENT");
 }
 
+static void disallow_event(struct kvm_vm *vm, __s32 event_id)
+{
+	set_event_perm(vm, event_id, 0, 0);
+}
+
 static void allow_event(struct kvm_vm *vm, __s32 event_id)
 {
 	set_event_perm(vm, event_id, 1, 0);
@@ -291,11 +296,16 @@ static void cmd_vm_check_event(__u16 id, int expected_err)
 			expected_err);
 }
 
-static void test_cmd_vm_check_event(void)
+static void test_cmd_vm_check_event(struct kvm_vm *vm)
 {
-	__u16 invalid_id = 0xffff;
+	__u16 valid_id = KVMI_VM_EVENT_UNHOOK, invalid_id = 0xffff;
 
 	cmd_vm_check_event(invalid_id, -KVM_ENOENT);
+	cmd_vm_check_event(valid_id, 0);
+
+	disallow_event(vm, valid_id);
+	cmd_vm_check_event(valid_id, -KVM_EPERM);
+	allow_event(vm, valid_id);
 }
 
 static void test_cmd_vm_get_info(void)
@@ -312,6 +322,57 @@ static void test_cmd_vm_get_info(void)
 	pr_debug("vcpu count: %u\n", rpl.vcpu_count);
 }
 
+static void trigger_event_unhook_notification(struct kvm_vm *vm)
+{
+	int r;
+
+	r = ioctl(vm->fd, KVM_INTROSPECTION_PREUNHOOK, NULL);
+	TEST_ASSERT(r == 0,
+		"KVM_INTROSPECTION_PREUNHOOK failed, errno %d (%s)\n",
+		errno, strerror(errno));
+}
+
+static void receive_event(struct kvmi_msg_hdr *msg_hdr, u16 msg_id,
+			  struct kvmi_event_hdr *ev_hdr, u16 event_id,
+			  size_t ev_size)
+{
+	size_t to_read = ev_size;
+
+	receive_data(msg_hdr, sizeof(*msg_hdr));
+
+	TEST_ASSERT(msg_hdr->id == msg_id,
+		"Unexpected messages id %d, expected %d\n",
+		msg_hdr->id, msg_id);
+
+	if (to_read > msg_hdr->size)
+		to_read = msg_hdr->size;
+
+	receive_data(ev_hdr, to_read);
+	TEST_ASSERT(ev_hdr->event == event_id,
+		"Unexpected event %d, expected %d\n",
+		ev_hdr->event, event_id);
+
+	TEST_ASSERT(msg_hdr->size == ev_size,
+		"Invalid event size %d, expected %zd bytes\n",
+		msg_hdr->size, ev_size);
+}
+
+static void receive_vm_event_unhook(void)
+{
+	struct kvmi_msg_hdr msg_hdr;
+	struct kvmi_event_hdr ev_hdr;
+
+	receive_event(&msg_hdr, KVMI_VM_EVENT,
+		      &ev_hdr, KVMI_VM_EVENT_UNHOOK, sizeof(ev_hdr));
+}
+
+static void test_event_unhook(struct kvm_vm *vm)
+{
+	trigger_event_unhook_notification(vm);
+
+	receive_vm_event_unhook();
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	setup_socket();
@@ -320,8 +381,9 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_invalid();
 	test_cmd_get_version();
 	test_cmd_vm_check_command(vm);
-	test_cmd_vm_check_event();
+	test_cmd_vm_check_event(vm);
 	test_cmd_vm_get_info();
+	test_event_unhook(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 72dd41915048..3746fd243bd8 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -17,6 +17,8 @@
 
 static DECLARE_BITMAP(Kvmi_always_allowed_commands, KVMI_NUM_COMMANDS);
 static DECLARE_BITMAP(Kvmi_known_events, KVMI_NUM_EVENTS);
+static DECLARE_BITMAP(Kvmi_known_vm_events, KVMI_NUM_EVENTS);
+static DECLARE_BITMAP(Kvmi_known_vcpu_events, KVMI_NUM_EVENTS);
 
 static struct kmem_cache *msg_cache;
 
@@ -76,7 +78,14 @@ static void kvmi_init_always_allowed_commands(void)
 
 static void kvmi_init_known_events(void)
 {
-	bitmap_zero(Kvmi_known_events, KVMI_NUM_EVENTS);
+	bitmap_zero(Kvmi_known_vm_events, KVMI_NUM_EVENTS);
+	set_bit(KVMI_VM_EVENT_UNHOOK, Kvmi_known_vm_events);
+
+	bitmap_zero(Kvmi_known_vcpu_events, KVMI_NUM_EVENTS);
+	kvmi_arch_init_vcpu_events_mask(Kvmi_known_vcpu_events);
+
+	bitmap_or(Kvmi_known_events, Kvmi_known_vm_events,
+		  Kvmi_known_vcpu_events, KVMI_NUM_EVENTS);
 }
 
 int kvmi_init(void)
@@ -130,6 +139,8 @@ kvmi_alloc(struct kvm *kvm, const struct kvm_introspection_hook *hook)
 	bitmap_copy(kvmi->cmd_allow_mask, Kvmi_always_allowed_commands,
 		    KVMI_NUM_COMMANDS);
 
+	atomic_set(&kvmi->ev_seq, 0);
+
 	kvmi->kvm = kvm;
 
 	return kvmi;
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index ef4850e8bfae..57c22f20e74f 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -27,4 +27,7 @@ bool kvmi_is_command_allowed(struct kvm_introspection *kvmi, u16 id);
 bool kvmi_is_event_allowed(struct kvm_introspection *kvmi, u16 id);
 bool kvmi_is_known_event(u16 id);
 
+/* arch */
+void kvmi_arch_init_vcpu_events_mask(unsigned long *supported);
+
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 513681290305..4acdb595301d 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -186,7 +186,7 @@ static bool is_vm_message(u16 id)
 
 static bool is_vm_command(u16 id)
 {
-	return is_vm_message(id);
+	return is_vm_message(id) && id != KVMI_VM_EVENT;
 }
 
 static struct kvmi_msg_hdr *kvmi_msg_recv(struct kvm_introspection *kvmi)
@@ -261,7 +261,45 @@ bool kvmi_msg_process(struct kvm_introspection *kvmi)
 	return err == 0;
 }
 
+static void kvmi_fill_ev_msg_hdr(struct kvm_introspection *kvmi,
+				 struct kvmi_msg_hdr *msg_hdr,
+				 struct kvmi_event_hdr *ev_hdr,
+				 u16 msg_id, u32 msg_seq,
+				 size_t msg_size, u16 ev_id)
+{
+	memset(msg_hdr, 0, sizeof(*msg_hdr));
+	msg_hdr->id = msg_id;
+	msg_hdr->seq = msg_seq;
+	msg_hdr->size = msg_size - sizeof(*msg_hdr);
+
+	memset(ev_hdr, 0, sizeof(*ev_hdr));
+	ev_hdr->event = ev_id;
+}
+
+static void kvmi_fill_vm_event(struct kvm_introspection *kvmi,
+			       struct kvmi_msg_hdr *msg_hdr,
+			       struct kvmi_event_hdr *ev_hdr,
+			       u16 ev_id, size_t msg_size)
+{
+	u32 msg_seq = atomic_inc_return(&kvmi->ev_seq);
+
+	kvmi_fill_ev_msg_hdr(kvmi, msg_hdr, ev_hdr, KVMI_VM_EVENT,
+			     msg_seq, msg_size, ev_id);
+}
+
 int kvmi_msg_send_unhook(struct kvm_introspection *kvmi)
 {
-	return -1;
+	struct kvmi_msg_hdr msg_hdr;
+	struct kvmi_event_hdr ev_hdr;
+	struct kvec vec[] = {
+		{.iov_base = &msg_hdr, .iov_len = sizeof(msg_hdr)},
+		{.iov_base = &ev_hdr,  .iov_len = sizeof(ev_hdr) },
+	};
+	size_t msg_size = sizeof(msg_hdr) + sizeof(ev_hdr);
+	size_t n = ARRAY_SIZE(vec);
+
+	kvmi_fill_vm_event(kvmi, &msg_hdr, &ev_hdr,
+			   KVMI_VM_EVENT_UNHOOK, msg_size);
+
+	return kvmi_sock_write(kvmi, vec, n, msg_size);
 }
