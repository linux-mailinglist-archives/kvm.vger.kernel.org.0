Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0547E228AD9
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731495AbgGUVRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:17:34 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37982 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731231AbgGUVQH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:07 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id C5265305D619;
        Wed, 22 Jul 2020 00:09:25 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 93369304FA14;
        Wed, 22 Jul 2020 00:09:25 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 44/84] KVM: introspection: add KVMI_EVENT_UNHOOK
Date:   Wed, 22 Jul 2020 00:08:42 +0300
Message-Id: <20200721210922.7646-45-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In certain situations (when the guest has to be paused,
suspended, migrated, etc.), the device manager will use
the KVM_INTROSPECTION_PREUNHOOK ioctl in order to trigger the
KVMI_EVENT_UNHOOK event. If the event is sent successfully (the VM has an
active introspection channel), the device manager should delay the action
(pause/suspend/...) to give the introspection tool the chance to remove
its hooks (eg. breakpoints) while the guest is still running. Once a
timeout is reached or the introspection tool has closed the socket,
the device manager should resume the action.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/api.rst                | 28 ++++++++
 Documentation/virt/kvm/kvmi.rst               | 70 +++++++++++++++++--
 arch/x86/include/asm/kvmi_host.h              |  2 +
 arch/x86/include/uapi/asm/kvmi.h              | 29 ++++++++
 include/linux/kvmi_host.h                     |  3 +
 include/uapi/linux/kvm.h                      |  2 +
 include/uapi/linux/kvmi.h                     | 13 ++++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 65 ++++++++++++++++-
 virt/kvm/introspection/kvmi.c                 | 42 ++++++++++-
 virt/kvm/introspection/kvmi_int.h             |  1 +
 virt/kvm/introspection/kvmi_msg.c             | 38 ++++++++++
 virt/kvm/kvm_main.c                           |  6 ++
 12 files changed, 291 insertions(+), 8 deletions(-)
 create mode 100644 arch/x86/include/uapi/asm/kvmi.h

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 174f13f2389d..fb3ccafac90d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4819,6 +4819,34 @@ the event is disallowed.
 Unless set to -1 (meaning all events), id must be a event ID
 (e.g. KVMI_EVENT_UNHOOK, KVMI_EVENT_CR, etc.)
 
+4.130 KVM_INTROSPECTION_PREUNHOOK
+---------------------------------
+
+:Capability: KVM_CAP_INTROSPECTION
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: none
+:Returns: 0 on success, a negative value on error
+
+Errors:
+
+  ======     ============================================================
+  EFAULT     the VM is not introspected yet (use KVM_INTROSPECTION_HOOK)
+  ENOENT     the socket (passed with KVM_INTROSPECTION_HOOK) had an error
+  ENOENT     the introspection tool didn't subscribed
+             to this type of introspection event (unhook)
+  ======     ============================================================
+
+This ioctl is used to inform that the current VM is
+paused/suspended/migrated/etc.
+
+KVM should send an 'unhook' introspection event to the introspection tool.
+
+If this ioctl is successful, the userspace should give the
+introspection tool a chance to unhook the VM and then it should use
+KVM_INTROSPECTION_UNHOOK to make sure all the introspection structures
+are freed.
+
 5. The kvm_run structure
 ========================
 
diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index a81f22cb8c18..4174c969cb47 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -194,10 +194,10 @@ becomes necessary to remove them before the guest is suspended, moved
 (migrated) or a snapshot with memory is created.
 
 The actions are normally performed by the device manager. In the case
-of QEMU, it will use another ioctl to notify the introspection tool and
-wait for a limited amount of time (a few seconds) for a confirmation that
-is OK to proceed (it is enough for the introspection tool to close
-the connection).
+of QEMU, it will use the *KVM_INTROSPECTION_PREUNHOOK* ioctl to trigger
+the *KVMI_EVENT_UNHOOK* event and wait for a limited amount of time
+(a few seconds) for a confirmation that is OK to proceed (it is enough
+for the introspection tool to close the connection).
 
 Live migrations
 ---------------
@@ -341,3 +341,65 @@ This command is always allowed.
 	};
 
 Returns the number of online vCPUs.
+
+Events
+======
+
+All introspection events (VM or vCPU related) are sent
+using the *KVMI_EVENT* message id.
+
+The *KVMI_EVENT_UNHOOK* event doesn't have a reply and share the kvmi_event
+structure, for consistency with the vCPU events.
+
+The message data begins with a common structure, having the size of the
+structure, the vCPU index and the event id::
+
+	struct kvmi_event {
+		__u16 size;
+		__u16 vcpu;
+		__u8 event;
+		__u8 padding[3];
+		struct kvmi_event_arch arch;
+	}
+
+On x86 the structure looks like this::
+
+	struct kvmi_event_arch {
+		__u8 mode;
+		__u8 padding[7];
+		struct kvm_regs regs;
+		struct kvm_sregs sregs;
+		struct {
+			__u64 sysenter_cs;
+			__u64 sysenter_esp;
+			__u64 sysenter_eip;
+			__u64 efer;
+			__u64 star;
+			__u64 lstar;
+			__u64 cstar;
+			__u64 pat;
+			__u64 shadow_gs;
+		} msrs;
+	};
+
+It contains information about the vCPU state at the time of the event.
+
+Specific event data can follow these common structures.
+
+1. KVMI_EVENT_UNHOOK
+--------------------
+
+:Architecture: all
+:Versions: >= 1
+:Actions: none
+:Parameters:
+
+::
+
+	struct kvmi_event;
+
+:Returns: none
+
+This event is sent when the device manager has to pause/stop/migrate the
+guest (see **Unhooking**).  The introspection tool has a chance to unhook
+and close the KVMI channel (signaling that the operation can proceed).
diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 38c398262913..747f3d779e15 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -2,6 +2,8 @@
 #ifndef _ASM_X86_KVMI_HOST_H
 #define _ASM_X86_KVMI_HOST_H
 
+#include <asm/kvmi.h>
+
 struct kvm_arch_introspection {
 };
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
new file mode 100644
index 000000000000..551f9ed1ed9c
--- /dev/null
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_ASM_X86_KVMI_H
+#define _UAPI_ASM_X86_KVMI_H
+
+/*
+ * KVM introspection - x86 specific structures and definitions
+ */
+
+#include <asm/kvm.h>
+
+struct kvmi_event_arch {
+	__u8 mode;		/* 2, 4 or 8 */
+	__u8 padding[7];
+	struct kvm_regs regs;
+	struct kvm_sregs sregs;
+	struct {
+		__u64 sysenter_cs;
+		__u64 sysenter_esp;
+		__u64 sysenter_eip;
+		__u64 efer;
+		__u64 star;
+		__u64 lstar;
+		__u64 cstar;
+		__u64 pat;
+		__u64 shadow_gs;
+	} msrs;
+};
+
+#endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 7efd071e398d..8d21e031788e 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -17,6 +17,8 @@ struct kvm_introspection {
 
 	unsigned long *cmd_allow_mask;
 	unsigned long *event_allow_mask;
+
+	atomic_t ev_seq;
 };
 
 int kvmi_version(void);
@@ -32,6 +34,7 @@ int kvmi_ioctl_command(struct kvm *kvm,
 		       const struct kvm_introspection_feature *feat);
 int kvmi_ioctl_event(struct kvm *kvm,
 		     const struct kvm_introspection_feature *feat);
+int kvmi_ioctl_preunhook(struct kvm *kvm);
 
 #else
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 17df03ceb483..06d88157de20 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1630,6 +1630,8 @@ struct kvm_introspection_feature {
 #define KVM_INTROSPECTION_COMMAND _IOW(KVMIO, 0xc5, struct kvm_introspection_feature)
 #define KVM_INTROSPECTION_EVENT   _IOW(KVMIO, 0xc6, struct kvm_introspection_feature)
 
+#define KVM_INTROSPECTION_PREUNHOOK  _IO(KVMIO, 0xc7)
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index eabaf7cea1df..9fbe52caf96c 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -8,12 +8,15 @@
 
 #include <linux/kernel.h>
 #include <linux/types.h>
+#include <asm/kvmi.h>
 
 enum {
 	KVMI_VERSION = 0x00000001
 };
 
 enum {
+	KVMI_EVENT            = 0,
+
 	KVMI_GET_VERSION      = 1,
 	KVMI_VM_CHECK_COMMAND = 2,
 	KVMI_VM_CHECK_EVENT   = 3,
@@ -23,6 +26,8 @@ enum {
 };
 
 enum {
+	KVMI_EVENT_UNHOOK = 0,
+
 	KVMI_NUM_EVENTS
 };
 
@@ -69,4 +74,12 @@ struct kvmi_vm_get_info_reply {
 	__u32 padding[3];
 };
 
+struct kvmi_event {
+	__u16 size;
+	__u16 vcpu;
+	__u8 event;
+	__u8 padding[3];
+	struct kvmi_event_arch arch;
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 1f4a165ab640..3d46d6e6b38c 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -72,6 +72,11 @@ static void set_event_perm(struct kvm_vm *vm, __s32 id, __u32 allow,
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
@@ -300,13 +305,20 @@ static void cmd_vm_check_event(__u16 id, __u16 padding, int expected_err)
 		-r, kvm_strerror(-r), expected_err);
 }
 
-static void test_cmd_vm_check_event(void)
+static void test_cmd_vm_check_event(struct kvm_vm *vm)
 {
-	__u16 invalid_id = 0xffff;
+	__u16 valid_id = KVMI_EVENT_UNHOOK, invalid_id = 0xffff;
 	__u16 padding = 1, no_padding = 0;
 
 	cmd_vm_check_event(invalid_id, padding, -KVM_EINVAL);
 	cmd_vm_check_event(invalid_id, no_padding, -KVM_ENOENT);
+
+	cmd_vm_check_event(valid_id, no_padding, 0);
+	cmd_vm_check_event(valid_id, padding, -KVM_EINVAL);
+
+	disallow_event(vm, valid_id);
+	cmd_vm_check_event(valid_id, 0, -KVM_EPERM);
+	allow_event(vm, valid_id);
 }
 
 static void test_cmd_vm_get_info(void)
@@ -323,6 +335,52 @@ static void test_cmd_vm_get_info(void)
 	pr_info("vcpu count: %u\n", rpl.vcpu_count);
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
+static void receive_event(struct kvmi_msg_hdr *hdr, struct kvmi_event *ev,
+			  size_t ev_size, int event_id)
+{
+	size_t to_read = ev_size;
+
+	receive_data(hdr, sizeof(*hdr));
+
+	TEST_ASSERT(hdr->id == KVMI_EVENT,
+		"Unexpected messages id %d, expected %d\n",
+		hdr->id, KVMI_EVENT);
+
+	if (to_read > hdr->size)
+		to_read = hdr->size;
+
+	receive_data(ev, to_read);
+
+	TEST_ASSERT(ev->event == event_id,
+		"Unexpected event %d, expected %d\n",
+		ev->event, event_id);
+
+	TEST_ASSERT(hdr->size == ev_size,
+		"Invalid event size %d, expected %zd bytes\n",
+		hdr->size, ev_size);
+}
+
+static void test_event_unhook(struct kvm_vm *vm)
+{
+	__u16 id = KVMI_EVENT_UNHOOK;
+	struct kvmi_msg_hdr hdr;
+	struct kvmi_event ev;
+
+	trigger_event_unhook_notification(vm);
+
+	receive_event(&hdr, &ev, sizeof(ev), id);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	setup_socket();
@@ -331,8 +389,9 @@ static void test_introspection(struct kvm_vm *vm)
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
index f5ca49167f70..f128b1407c84 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -13,6 +13,8 @@
 
 static DECLARE_BITMAP(Kvmi_always_allowed_commands, KVMI_NUM_COMMANDS);
 static DECLARE_BITMAP(Kvmi_known_events, KVMI_NUM_EVENTS);
+static DECLARE_BITMAP(Kvmi_known_vm_events, KVMI_NUM_EVENTS);
+static DECLARE_BITMAP(Kvmi_known_vcpu_events, KVMI_NUM_EVENTS);
 
 static struct kmem_cache *msg_cache;
 
@@ -67,7 +69,13 @@ static void setup_always_allowed_commands(void)
 
 static void setup_known_events(void)
 {
-	bitmap_zero(Kvmi_known_events, KVMI_NUM_EVENTS);
+	bitmap_zero(Kvmi_known_vm_events, KVMI_NUM_EVENTS);
+	set_bit(KVMI_EVENT_UNHOOK, Kvmi_known_vm_events);
+
+	bitmap_zero(Kvmi_known_vcpu_events, KVMI_NUM_EVENTS);
+
+	bitmap_or(Kvmi_known_events, Kvmi_known_vm_events,
+		  Kvmi_known_vcpu_events, KVMI_NUM_EVENTS);
 }
 
 int kvmi_init(void)
@@ -121,6 +129,8 @@ alloc_kvmi(struct kvm *kvm, const struct kvm_introspection_hook *hook)
 	bitmap_copy(kvmi->cmd_allow_mask, Kvmi_always_allowed_commands,
 		    KVMI_NUM_COMMANDS);
 
+	atomic_set(&kvmi->ev_seq, 0);
+
 	kvmi->kvm = kvm;
 
 	return kvmi;
@@ -377,3 +387,33 @@ int kvmi_ioctl_command(struct kvm *kvm,
 	mutex_unlock(&kvm->kvmi_lock);
 	return err;
 }
+
+static bool kvmi_unhook_event(struct kvm_introspection *kvmi)
+{
+	int err;
+
+	err = kvmi_msg_send_unhook(kvmi);
+
+	return !err;
+}
+
+int kvmi_ioctl_preunhook(struct kvm *kvm)
+{
+	struct kvm_introspection *kvmi;
+	int err = 0;
+
+	mutex_lock(&kvm->kvmi_lock);
+
+	kvmi = KVMI(kvm);
+	if (!kvmi) {
+		err = -EFAULT;
+		goto out;
+	}
+
+	if (!kvmi_unhook_event(kvmi))
+		err = -ENOENT;
+
+out:
+	mutex_unlock(&kvm->kvmi_lock);
+	return err;
+}
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 0bca4bd0a415..c385dc0eb708 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -25,6 +25,7 @@ bool kvmi_sock_get(struct kvm_introspection *kvmi, int fd);
 void kvmi_sock_shutdown(struct kvm_introspection *kvmi);
 void kvmi_sock_put(struct kvm_introspection *kvmi);
 bool kvmi_msg_process(struct kvm_introspection *kvmi);
+int kvmi_msg_send_unhook(struct kvm_introspection *kvmi);
 
 /* kvmi.c */
 void *kvmi_msg_alloc(void);
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 3df18f7965c0..596f5c02bb8c 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -252,3 +252,41 @@ bool kvmi_msg_process(struct kvm_introspection *kvmi)
 out:
 	return err == 0;
 }
+
+static void kvmi_setup_event_msg_hdr(struct kvm_introspection *kvmi,
+				     struct kvmi_msg_hdr *hdr,
+				     size_t msg_size)
+{
+	memset(hdr, 0, sizeof(*hdr));
+
+	hdr->id = KVMI_EVENT;
+	hdr->seq = atomic_inc_return(&kvmi->ev_seq);
+	hdr->size = msg_size - sizeof(*hdr);
+}
+
+static void kvmi_setup_event_common(struct kvmi_event *ev, u32 ev_id,
+				    u16 vcpu_idx)
+{
+	memset(ev, 0, sizeof(*ev));
+
+	ev->vcpu = vcpu_idx;
+	ev->event = ev_id;
+	ev->size = sizeof(*ev);
+}
+
+int kvmi_msg_send_unhook(struct kvm_introspection *kvmi)
+{
+	struct kvmi_msg_hdr hdr;
+	struct kvmi_event common;
+	struct kvec vec[] = {
+		{.iov_base = &hdr,	.iov_len = sizeof(hdr)	 },
+		{.iov_base = &common,	.iov_len = sizeof(common)},
+	};
+	size_t msg_size = sizeof(hdr) + sizeof(common);
+	size_t n = ARRAY_SIZE(vec);
+
+	kvmi_setup_event_msg_hdr(kvmi, &hdr, msg_size);
+	kvmi_setup_event_common(&common, KVMI_EVENT_UNHOOK, 0);
+
+	return kvmi_sock_write(kvmi, vec, n, msg_size);
+}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9aeb57e93165..86910e6c8d93 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3861,6 +3861,12 @@ static long kvm_vm_ioctl(struct file *filp,
 				r = kvmi_ioctl_command(kvm, &feat);
 		}
 		break;
+	case KVM_INTROSPECTION_PREUNHOOK:
+		if (enable_introspection)
+			r = kvmi_ioctl_preunhook(kvm);
+		else
+			r = -EPERM;
+		break;
 #endif /* CONFIG_KVM_INTROSPECTION */
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
