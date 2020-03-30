Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB1C819790D
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbgC3KVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:21:11 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43880 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729533AbgC3KUC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:20:02 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 220F530644BC;
        Mon, 30 Mar 2020 13:12:56 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id DDFB8305B7A1;
        Mon, 30 Mar 2020 13:12:55 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 45/81] KVM: introspection: add KVMI_EVENT_UNHOOK
Date:   Mon, 30 Mar 2020 13:12:32 +0300
Message-Id: <20200330101308.21702-46-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In certain situations (when the guest has to be paused, suspended,
migrated, etc.), userspace will use the KVM_INTROSPECTION_PREUNHOOK ioctl
in order to trigger the KVMI_EVENT_UNHOOK event. If the event is sent
successfully (the VM has an active introspection channel), userspace
should delay the action (pause/suspend/...) to give the introspection
tool the chance to remove its hooks (eg. breakpoints) while the guest
is still running. Once a timeout is reached or the introspection tool
has closed the socket, userspace should resume the action.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/api.rst                | 28 ++++++++
 Documentation/virt/kvm/kvmi.rst               | 69 ++++++++++++++++++-
 arch/x86/include/uapi/asm/kvmi.h              | 29 ++++++++
 include/linux/kvmi_host.h                     |  3 +
 include/uapi/linux/kvm.h                      |  2 +
 include/uapi/linux/kvmi.h                     | 13 ++++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 42 +++++++++++
 virt/kvm/introspection/kvmi.c                 | 42 ++++++++++-
 virt/kvm/introspection/kvmi_int.h             |  1 +
 virt/kvm/introspection/kvmi_msg.c             | 38 ++++++++++
 virt/kvm/kvm_main.c                           |  3 +
 11 files changed, 266 insertions(+), 4 deletions(-)
 create mode 100644 arch/x86/include/uapi/asm/kvmi.h

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 4d81a2f2f8f7..4178e1317647 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4771,6 +4771,34 @@ the event is disallowed.
 Unless set to -1 (meaning all event), id must be a event ID
 (e.g. KVMI_EVENT_UNHOOK, KVMI_EVENT_CR, etc.)
 
+4.129 KVM_INTROSPECTION_PREUNHOOK
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
+  EFAULT     the introspection is not enabled
+  EFAULT     the socket (passed with KVM_INTROSPECTION_HOOK) had an error
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
index 36b34e09d2c2..e652bdd65052 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -194,9 +194,10 @@ becomes necessary to remove them before the guest is suspended, moved
 (migrated) or a snapshot with memory is created.
 
 The actions are normally performed by the device manager. In the case
-of QEMU, it will use another ioctl to notify the introspection tool and
-wait for a limited amount of time (a few seconds) for a confirmation that
-is OK to proceed.
+of QEMU, it will use the *KVM_INTROSPECTION_PREUNHOOK* ioctl to trigger
+the *KVMI_EVENT_UNHOOK* event and wait for a limited amount of time
+(a few seconds) for a confirmation from the introspection tool
+that is OK to proceed.
 
 Live migrations
 ---------------
@@ -338,3 +339,65 @@ This command is always allowed.
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
+Specific data can follow these common structures.
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
index 4e77a0227c08..180e26335a8f 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -21,6 +21,8 @@ struct kvm_introspection {
 
 	DECLARE_BITMAP(cmd_allow_mask, KVMI_NUM_COMMANDS);
 	DECLARE_BITMAP(event_allow_mask, KVMI_NUM_EVENTS);
+
+	atomic_t ev_seq;
 };
 
 #ifdef CONFIG_KVM_INTROSPECTION
@@ -34,6 +36,7 @@ int kvmi_ioctl_hook(struct kvm *kvm, void __user *argp);
 int kvmi_ioctl_unhook(struct kvm *kvm);
 int kvmi_ioctl_command(struct kvm *kvm, void __user *argp);
 int kvmi_ioctl_event(struct kvm *kvm, void __user *argp);
+int kvmi_ioctl_preunhook(struct kvm *kvm);
 
 #else
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index dd4ab88f0012..b8448cd797ec 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1576,6 +1576,8 @@ struct kvm_introspection_feature {
 #define KVM_INTROSPECTION_COMMAND _IOW(KVMIO, 0xc5, struct kvm_introspection_feature)
 #define KVM_INTROSPECTION_EVENT   _IOW(KVMIO, 0xc6, struct kvm_introspection_feature)
 
+#define KVM_INTROSPECTION_PREUNHOOK  _IO(KVMIO, 0xc7)
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index bfa1526798e6..689eba32c031 100644
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
+	KVMI_EVENT            = 1,
+
 	KVMI_GET_VERSION      = 2,
 	KVMI_VM_CHECK_COMMAND = 3,
 	KVMI_VM_CHECK_EVENT   = 4,
@@ -23,6 +26,8 @@ enum {
 };
 
 enum {
+	KVMI_EVENT_UNHOOK = 0,
+
 	KVMI_NUM_EVENTS
 };
 
@@ -70,4 +75,12 @@ struct kvmi_vm_get_info_reply {
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
index ba58081bfec4..9cb65f8c946f 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -268,6 +268,47 @@ static void test_cmd_get_vm_info(void)
 	DEBUG("vcpu count: %u\n", rpl.vcpu_count);
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
+			 size_t ev_size, int event_id)
+{
+	receive_data(hdr, sizeof(*hdr));
+
+	TEST_ASSERT(hdr->id == KVMI_EVENT,
+		"Unexpected messages id %d, expected %d\n",
+		hdr->id, KVMI_EVENT);
+
+	TEST_ASSERT(hdr->size == ev_size,
+		"Invalid event size %d, expected %d bytes\n",
+		hdr->size, ev_size);
+
+	receive_data(ev, ev_size);
+
+	TEST_ASSERT(ev->event == event_id,
+		"Unexpected event %d, expected %d\n",
+		ev->event, event_id);
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
@@ -278,6 +319,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_check_command();
 	test_cmd_check_event();
 	test_cmd_get_vm_info();
+	test_event_unhook(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 5c17f548b457..bf6d5ec951c8 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -12,6 +12,8 @@
 
 static DECLARE_BITMAP(Kvmi_always_allowed_commands, KVMI_NUM_COMMANDS);
 DECLARE_BITMAP(Kvmi_known_events, KVMI_NUM_EVENTS);
+static DECLARE_BITMAP(Kvmi_known_vm_events, KVMI_NUM_EVENTS);
+static DECLARE_BITMAP(Kvmi_known_vcpu_events, KVMI_NUM_EVENTS);
 
 static struct kmem_cache *msg_cache;
 
@@ -56,7 +58,13 @@ static void setup_always_allowed_commands(void)
 
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
@@ -93,6 +101,8 @@ alloc_kvmi(struct kvm *kvm, const struct kvm_introspection_hook *hook)
 	bitmap_copy(kvmi->cmd_allow_mask, Kvmi_always_allowed_commands,
 		    KVMI_NUM_COMMANDS);
 
+	atomic_set(&kvmi->ev_seq, 0);
+
 	kvmi->kvm = kvm;
 
 	return kvmi;
@@ -349,3 +359,33 @@ int kvmi_ioctl_command(struct kvm *kvm, void __user *argp)
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
index f755c66ceecc..ecd0625e0c9e 100644
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
index ceec31ae4581..b381273b7355 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -256,3 +256,41 @@ bool kvmi_msg_process(struct kvm_introspection *kvmi)
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
index 4ca8625575bb..86bc2ed680ce 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3596,6 +3596,9 @@ static long kvm_vm_ioctl(struct file *filp,
 	case KVM_INTROSPECTION_EVENT:
 		r = kvmi_ioctl_event(kvm, argp);
 		break;
+	case KVM_INTROSPECTION_PREUNHOOK:
+		r = kvmi_ioctl_preunhook(kvm);
+		break;
 #endif /* CONFIG_KVM_INTROSPECTION */
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
