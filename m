Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0032787F96
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437231AbfHIQUF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:20:05 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53318 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437184AbfHIQUE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:20:04 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id F4021305D3CE;
        Fri,  9 Aug 2019 19:00:52 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id A7894305B7A0;
        Fri,  9 Aug 2019 19:00:52 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        =?UTF-8?q?Mircea=20C=C3=AErjaliu?= <mcirjaliu@bitdefender.com>
Subject: [RFC PATCH v6 02/92] kvm: introspection: add basic ioctls (hook/unhook)
Date:   Fri,  9 Aug 2019 18:59:17 +0300
Message-Id: <20190809160047.8319-3-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The connection of the introspection socket with the introspection tool
is initialized by userspace/QEMU. Once the handshake is done, the file
descriptor is passed to KVMi using the KVM_INTROSPECTION_HOOK ioctl. A
new thread will be created to handle/dispatch all introspection commands
or replies to introspection events. This thread will finish when the
socket is closed by userspace (eg. when the guest is restarted) or by
the introspection tool. The uuid member of struct kvm_introspection is
used to show the guest id with the error messages.

On certain actions from userspace (pause, suspend, migrate, etc.) the
KVM_INTROSPECTION_UNHOOK ioctl is used to notify the introspection tool
to remove its hooks (eg. breakpoints).

Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Co-developed-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Signed-off-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/api.txt  |  50 ++++++++++
 Documentation/virtual/kvm/kvmi.rst |  65 +++++++++++++
 arch/x86/kvm/Makefile              |   2 +-
 arch/x86/kvm/x86.c                 |   7 ++
 include/linux/kvmi.h               |   4 +
 include/uapi/linux/kvm.h           |  11 +++
 virt/kvm/kvm_main.c                |   8 ++
 virt/kvm/kvmi.c                    | 145 +++++++++++++++++++++++++++++
 virt/kvm/kvmi_int.h                |  31 ++++++
 virt/kvm/kvmi_msg.c                |  42 +++++++++
 10 files changed, 364 insertions(+), 1 deletion(-)
 create mode 100644 virt/kvm/kvmi_msg.c

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 356156f5c52d..28d4429f9ae9 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -3857,6 +3857,56 @@ number of valid entries in the 'entries' array, which is then filled.
 'index' and 'flags' fields in 'struct kvm_cpuid_entry2' are currently reserved,
 userspace should not expect to get any particular value there.
 
+4.996 KVM_INTROSPECTION_HOOK
+
+Capability: KVM_CAP_INTROSPECTION
+Architectures: x86
+Type: vm ioctl
+Parameters: struct kvm_introspection (in)
+Returns: 0 on success, a negative value on error
+
+This ioctl is used to enable the introspection of the current VM.
+
+struct kvm_introspection {
+	__s32 fd;
+	__u32 padding;
+	__u8 uuid[16];
+};
+
+fd is the file handle of a socket connected to the introspection tool,
+
+padding must be zero (it might be used in the future),
+
+uuid is used for debug and error messages.
+
+It can fail with -EFAULT if:
+ - memory allocation failed
+ - this VM is already introspected
+ - the file handle doesn't correspond to an active socket
+
+It will fail with -EINVAL if padding is not zero.
+
+The KVMI version can be retrieved using the KVM_CAP_INTROSPECTION of
+the KVM_CHECK_EXTENSION ioctl() at run-time.
+
+4.997 KVM_INTROSPECTION_UNHOOK
+
+Capability: KVM_CAP_INTROSPECTION
+Architectures: x86
+Type: vm ioctl
+Parameters: none
+Returns: 0 on success, a negative value on error
+
+This ioctl is used to disable the introspection of the current VM.
+It is useful when the VM is paused/suspended/migrated.
+
+It can fail with -EFAULT if:
+  - the introspection is not enabled
+  - the socket (passed with KVM_INTROSPECTION_HOOK) had an error
+
+If the ioctl is successful, the userspace should give the introspection
+tool a chance to unhook the VM.
+
 5. The kvm_run structure
 ------------------------
 
diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index d54caf8d974f..47b7c36d334a 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -64,6 +64,71 @@ used on that guest. Obviously, whether the guest can really continue
 normal execution depends on whether the introspection tool has made any
 modifications that require an active KVMI channel.
 
+Handshake
+---------
+
+Although this falls out of the scope of the introspection subsystem, below
+is a proposal of a handshake that can be used by implementors.
+
+Based on the system administration policies, the management tool
+(eg. libvirt) starts device managers (eg. QEMU) with some extra arguments:
+what introspector could monitor/control that specific guest (and how to
+connect to) and what introspection commands/events are allowed.
+
+The device manager will connect to the introspection tool and wait for a
+cryptographic hash of a cookie that should be known by both peers. If the
+hash is correct (the destination has been "authenticated"), the device
+manager will send another cryptographic hash and random salt. The peer
+recomputes the hash of the cookie bytes including the salt and if they match,
+the device manager has been "authenticated" too. This is a rather crude
+system that makes it difficult for device manager exploits to trick the
+introspection tool into believing its working OK.
+
+The cookie would normally be generated by a management tool (eg. libvirt)
+and make it available to the device manager and to a properly authenticated
+client. It is the job of a third party to retrieve the cookie from the
+management application and pass it over a secure channel to the introspection
+tool.
+
+Once the basic "authentication" has taken place, the introspection tool
+can receive information on the guest (its UUID) and other flags (endianness
+or features supported by the host kernel).
+
+In the end, the device manager will pass the file handle (plus the allowed
+commands/events) to KVM, and forget about it. It will be notified by
+KVM when the introspection tool closes the file handle (in case of
+errors), and should reinitiate the handshake.
+
+Unhooking
+---------
+
+During a VMI session it is possible for the guest to be patched and for
+some of these patches to "talk" with the introspection tool. It thus
+becomes necessary to remove them before the guest is suspended, moved
+(migrated) or a snapshot with memory is created.
+
+The actions are normally performed by the device manager. In the case
+of QEMU, it will use the *KVM_INTROSPECTION_UNHOOK* ioctl to trigger
+the *KVMI_EVENT_UNHOOK* event and wait for a limited amount of time (a
+few seconds) for a confirmation from the introspection tool
+that is OK to proceed.
+
+Live migrations
+---------------
+
+Before the live migration takes place, the introspection tool has to be
+notified and have a chance to unhook (see **Unhooking**).
+
+The QEMU instance on the receiving end, if configured for KVMI, will need to
+establish a connection to the introspection tool after the migration has
+completed.
+
+Obviously, this creates a window in which the guest is not introspected. The
+user will need to be aware of this detail. Future introspection
+technologies can choose not to disconnect and instead transfer the necessary
+context to the introspection tool at the migration destination via a separate
+channel.
+
 Memory access safety
 --------------------
 
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 312597bd47c7..0963e475dbe9 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -7,7 +7,7 @@ KVM := ../../../virt/kvm
 kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
 				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
 kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
-kvm-$(CONFIG_KVM_INTROSPECTION) += $(KVM)/kvmi.o
+kvm-$(CONFIG_KVM_INTROSPECTION) += $(KVM)/kvmi.o $(KVM)/kvmi_msg.o
 
 kvm-y			+= x86.o mmu.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 941f932373d0..0163e1ad1aaa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -20,6 +20,8 @@
  */
 
 #include <linux/kvm_host.h>
+#include <uapi/linux/kvmi.h>
+#include <linux/kvmi.h>
 #include "irq.h"
 #include "mmu.h"
 #include "i8254.h"
@@ -3083,6 +3085,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = kvm_x86_ops->get_nested_state ?
 			kvm_x86_ops->get_nested_state(NULL, 0, 0) : 0;
 		break;
+#ifdef CONFIG_KVM_INTROSPECTION
+	case KVM_CAP_INTROSPECTION:
+		r = KVMI_VERSION;
+		break;
+#endif
 	default:
 		break;
 	}
diff --git a/include/linux/kvmi.h b/include/linux/kvmi.h
index e36de3f9f3de..4ca9280e4419 100644
--- a/include/linux/kvmi.h
+++ b/include/linux/kvmi.h
@@ -10,6 +10,10 @@ int kvmi_init(void);
 void kvmi_uninit(void);
 void kvmi_create_vm(struct kvm *kvm);
 void kvmi_destroy_vm(struct kvm *kvm);
+int kvmi_ioctl_hook(struct kvm *kvm, void __user *argp);
+int kvmi_ioctl_command(struct kvm *kvm, void __user *argp);
+int kvmi_ioctl_event(struct kvm *kvm, void __user *argp);
+int kvmi_ioctl_unhook(struct kvm *kvm, bool force_reset);
 
 #else
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6d4ea4b6c922..bae37bf37338 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -989,6 +989,8 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_MANUAL_DIRTY_LOG_PROTECT 166
 #define KVM_CAP_HYPERV_CPUID 167
 
+#define KVM_CAP_INTROSPECTION 999
+
 #ifdef KVM_CAP_IRQ_ROUTING
 
 struct kvm_irq_routing_irqchip {
@@ -1520,6 +1522,15 @@ struct kvm_sev_dbg {
 	__u32 len;
 };
 
+struct kvm_introspection {
+	__s32 fd;
+	__u32 padding;
+	__u8 uuid[16];
+};
+#define KVM_INTROSPECTION_HOOK    _IOW(KVMIO, 0xff, struct kvm_introspection)
+#define KVM_INTROSPECTION_UNHOOK  _IO(KVMIO, 0xfe)
+/* write true on force-reset, false otherwise */
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 90e432d225ab..09a930ac007d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3266,6 +3266,14 @@ static long kvm_vm_ioctl(struct file *filp,
 	case KVM_CHECK_EXTENSION:
 		r = kvm_vm_ioctl_check_extension_generic(kvm, arg);
 		break;
+#ifdef CONFIG_KVM_INTROSPECTION
+	case KVM_INTROSPECTION_HOOK:
+		r = kvmi_ioctl_hook(kvm, argp);
+		break;
+	case KVM_INTROSPECTION_UNHOOK:
+		r = kvmi_ioctl_unhook(kvm, arg);
+		break;
+#endif /* CONFIG_KVM_INTROSPECTION */
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
 	}
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index 20638743bd03..591f6ee22135 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -7,6 +7,8 @@
  */
 #include <uapi/linux/kvmi.h>
 #include "kvmi_int.h"
+#include <linux/kthread.h>
+#include <linux/bitmap.h>
 
 int kvmi_init(void)
 {
@@ -17,6 +19,22 @@ void kvmi_uninit(void)
 {
 }
 
+static bool alloc_kvmi(struct kvm *kvm, const struct kvm_introspection *qemu)
+{
+	struct kvmi *ikvm;
+
+	ikvm = kzalloc(sizeof(*ikvm), GFP_KERNEL);
+	if (!ikvm)
+		return false;
+
+	memcpy(&ikvm->uuid, &qemu->uuid, sizeof(ikvm->uuid));
+
+	ikvm->kvm = kvm;
+	kvm->kvmi = ikvm;
+
+	return true;
+}
+
 struct kvmi * __must_check kvmi_get(struct kvm *kvm)
 {
 	if (refcount_inc_not_zero(&kvm->kvmi_ref))
@@ -27,10 +45,13 @@ struct kvmi * __must_check kvmi_get(struct kvm *kvm)
 
 static void kvmi_destroy(struct kvm *kvm)
 {
+	kfree(kvm->kvmi);
+	kvm->kvmi = NULL;
 }
 
 static void kvmi_release(struct kvm *kvm)
 {
+	kvmi_sock_put(IKVM(kvm));
 	kvmi_destroy(kvm);
 
 	complete(&kvm->kvmi_completed);
@@ -43,6 +64,111 @@ void kvmi_put(struct kvm *kvm)
 		kvmi_release(kvm);
 }
 
+static void kvmi_end_introspection(struct kvmi *ikvm)
+{
+	struct kvm *kvm = ikvm->kvm;
+
+	/* Signal QEMU which is waiting for POLLHUP. */
+	kvmi_sock_shutdown(ikvm);
+
+	/*
+	 * At this moment the socket is shut down, no more commands will come
+	 * from the introspector, and the only way into the introspection is
+	 * thru the event handlers. Make sure the introspection ends.
+	 */
+	kvmi_put(kvm);
+}
+
+static int kvmi_recv(void *arg)
+{
+	struct kvmi *ikvm = arg;
+
+	kvmi_info(ikvm, "Hooking VM\n");
+
+	while (kvmi_msg_process(ikvm))
+		;
+
+	kvmi_info(ikvm, "Unhooking VM\n");
+
+	kvmi_end_introspection(ikvm);
+
+	return 0;
+}
+
+int kvmi_hook(struct kvm *kvm, const struct kvm_introspection *qemu)
+{
+	struct kvmi *ikvm;
+	int err = 0;
+
+	/* wait for the previous introspection to finish */
+	err = wait_for_completion_killable(&kvm->kvmi_completed);
+	if (err)
+		return err;
+
+	/* ensure no VCPU hotplug happens until we set the reference */
+	mutex_lock(&kvm->lock);
+
+	if (!alloc_kvmi(kvm, qemu)) {
+		mutex_unlock(&kvm->lock);
+		return -ENOMEM;
+	}
+	ikvm = IKVM(kvm);
+
+	/* interact with other kernel components after structure allocation */
+	if (!kvmi_sock_get(ikvm, qemu->fd)) {
+		err = -EINVAL;
+		goto err_alloc;
+	}
+
+	/*
+	 * Make sure all the KVM/KVMI structures are linked and no pointer
+	 * is read as NULL after the reference count has been set.
+	 */
+	smp_mb__before_atomic();
+	refcount_set(&kvm->kvmi_ref, 1);
+
+	mutex_unlock(&kvm->lock);
+
+	ikvm->recv = kthread_run(kvmi_recv, ikvm, "kvmi-recv");
+	if (IS_ERR(ikvm->recv)) {
+		kvmi_err(ikvm, "Unable to create receiver thread!\n");
+		err = PTR_ERR(ikvm->recv);
+		goto err_recv;
+	}
+
+	return 0;
+
+err_recv:
+	/*
+	 * introspection has oficially started since reference count has been
+	 * set (and some event handlers may have already acquired it), but
+	 * without the receiver thread; we must emulate its shutdown behavior
+	 */
+	kvmi_end_introspection(ikvm);
+
+	return err;
+
+err_alloc:
+	kvmi_release(kvm);
+
+	mutex_unlock(&kvm->lock);
+
+	return err;
+}
+
+int kvmi_ioctl_hook(struct kvm *kvm, void __user *argp)
+{
+	struct kvm_introspection i;
+
+	if (copy_from_user(&i, argp, sizeof(i)))
+		return -EFAULT;
+
+	if (i.padding)
+		return -EINVAL;
+
+	return kvmi_hook(kvm, &i);
+}
+
 void kvmi_create_vm(struct kvm *kvm)
 {
 	init_completion(&kvm->kvmi_completed);
@@ -57,8 +183,27 @@ void kvmi_destroy_vm(struct kvm *kvm)
 	if (!ikvm)
 		return;
 
+	/* trigger socket shutdown - kvmi_recv() will start shutdown process */
+	kvmi_sock_shutdown(ikvm);
+
 	kvmi_put(kvm);
 
 	/* wait for introspection resources to be released */
 	wait_for_completion_killable(&kvm->kvmi_completed);
 }
+
+int kvmi_ioctl_unhook(struct kvm *kvm, bool force_reset)
+{
+	struct kvmi *ikvm;
+	int err = 0;
+
+	ikvm = kvmi_get(kvm);
+	if (!ikvm)
+		return -EFAULT;
+
+	kvm_info("TODO: %s force_reset %d", __func__, force_reset);
+
+	kvmi_put(kvm);
+
+	return err;
+}
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index ac23ad6fc4df..9bc5205c8714 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -2,11 +2,42 @@
 #ifndef __KVMI_INT_H__
 #define __KVMI_INT_H__
 
+#include <linux/types.h>
 #include <linux/kvm_host.h>
 
+#include <uapi/linux/kvmi.h>
+
+#define kvmi_debug(ikvm, fmt, ...) \
+	kvm_debug("%pU " fmt, &ikvm->uuid, ## __VA_ARGS__)
+#define kvmi_info(ikvm, fmt, ...) \
+	kvm_info("%pU " fmt, &ikvm->uuid, ## __VA_ARGS__)
+#define kvmi_warn(ikvm, fmt, ...) \
+	kvm_info("%pU WARNING: " fmt, &ikvm->uuid, ## __VA_ARGS__)
+#define kvmi_warn_once(ikvm, fmt, ...) ({                     \
+		static bool __section(.data.once) __warned;   \
+		if (!__warned) {                              \
+			__warned = true;                      \
+			kvmi_warn(ikvm, fmt, ## __VA_ARGS__); \
+		}                                             \
+	})
+#define kvmi_err(ikvm, fmt, ...) \
+	kvm_info("%pU ERROR: " fmt, &ikvm->uuid, ## __VA_ARGS__)
+
 #define IKVM(kvm) ((struct kvmi *)((kvm)->kvmi))
 
 struct kvmi {
+	struct kvm *kvm;
+
+	struct socket *sock;
+	struct task_struct *recv;
+
+	uuid_t uuid;
 };
 
+/* kvmi_msg.c */
+bool kvmi_sock_get(struct kvmi *ikvm, int fd);
+void kvmi_sock_shutdown(struct kvmi *ikvm);
+void kvmi_sock_put(struct kvmi *ikvm);
+bool kvmi_msg_process(struct kvmi *ikvm);
+
 #endif
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
new file mode 100644
index 000000000000..4de012eafb6d
--- /dev/null
+++ b/virt/kvm/kvmi_msg.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KVM introspection
+ *
+ * Copyright (C) 2017-2019 Bitdefender S.R.L.
+ *
+ */
+#include <linux/net.h>
+#include "kvmi_int.h"
+
+bool kvmi_sock_get(struct kvmi *ikvm, int fd)
+{
+	struct socket *sock;
+	int r;
+
+	sock = sockfd_lookup(fd, &r);
+	if (!sock) {
+		kvmi_err(ikvm, "Invalid file handle: %d\n", fd);
+		return false;
+	}
+
+	ikvm->sock = sock;
+
+	return true;
+}
+
+void kvmi_sock_put(struct kvmi *ikvm)
+{
+	if (ikvm->sock)
+		sockfd_put(ikvm->sock);
+}
+
+void kvmi_sock_shutdown(struct kvmi *ikvm)
+{
+	kernel_sock_shutdown(ikvm->sock, SHUT_RDWR);
+}
+
+bool kvmi_msg_process(struct kvmi *ikvm)
+{
+	kvmi_info(ikvm, "TODO: %s", __func__);
+	return false;
+}
