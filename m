Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9D9228A9D
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731438AbgGUVQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:16:21 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37984 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731374AbgGUVQT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:19 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id B6CBB3041305;
        Wed, 22 Jul 2020 00:09:24 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 85511304FA12;
        Wed, 22 Jul 2020 00:09:24 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        =?UTF-8?q?Mircea=20C=C3=AErjaliu?= <mcirjaliu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>
Subject: [PATCH v9 38/84] KVM: introspection: add hook/unhook ioctls
Date:   Wed, 22 Jul 2020 00:08:36 +0300
Message-Id: <20200721210922.7646-39-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On hook, a new thread is created to handle the messages coming from the
introspection tool (commands or event replies). The VM related commands
are handled by this thread, while the vCPU commands and events replies
are dispatched to the vCPU threads.

On unhook, the socket is shut down, which will signal: the receiving
thread to quit (because it might be blocked in recvmsg()) and the
introspection tool to clean up.

The mutex is used to protect the 'kvm->kvmi' pointer when accessed through
ioctls.

The reference counter is used by the receiving thread (for its entire
life time) and by the vCPU threads while sending introspection events
or handling introspection commands.

The completion objects is set when the reference counter reaches zero and
the unhook process is waiting for it in order to free the introspection
structures.

Co-developed-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Signed-off-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/api.rst                |  55 ++++++
 arch/x86/include/asm/kvmi_host.h              |   8 +
 arch/x86/kvm/Makefile                         |   2 +-
 arch/x86/kvm/x86.c                            |   6 +
 include/linux/kvm_host.h                      |   5 +
 include/linux/kvmi_host.h                     |  17 ++
 include/uapi/linux/kvm.h                      |  10 ++
 include/uapi/linux/kvmi.h                     |  13 ++
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  |  94 ++++++++++
 virt/kvm/introspection/kvmi.c                 | 162 ++++++++++++++++++
 virt/kvm/introspection/kvmi_int.h             |  22 +++
 virt/kvm/introspection/kvmi_msg.c             |  39 +++++
 virt/kvm/kvm_main.c                           |  19 ++
 14 files changed, 452 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/kvmi_host.h
 create mode 100644 include/uapi/linux/kvmi.h
 create mode 100644 tools/testing/selftests/kvm/x86_64/kvmi_test.c
 create mode 100644 virt/kvm/introspection/kvmi_msg.c

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 320788f81a05..e34f20430eb1 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4697,6 +4697,61 @@ KVM_PV_VM_VERIFY
   Verify the integrity of the unpacked image. Only if this succeeds,
   KVM is allowed to start protected VCPUs.
 
+4.126 KVM_INTROSPECTION_HOOK
+----------------------------
+
+:Capability: KVM_CAP_INTROSPECTION
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: struct kvm_introspection (in)
+:Returns: 0 on success, a negative value on error
+
+Errors:
+
+  ======     ==========================================================
+  ENOMEM     the memory allocation failed
+  EEXIST     the VM is already introspected
+  EINVAL     the file descriptor doesn't correspond to an active socket
+  EINVAL     the padding is not zero
+  EPERM      the introspection is disabled (kvm.introspection=0)
+  ======     ==========================================================
+
+This ioctl is used to enable the introspection of the current VM.
+
+::
+
+  struct kvm_introspection {
+	__s32 fd;
+	__u32 padding;
+	__u8 uuid[16];
+  };
+
+fd is the file descriptor of a socket connected to the introspection tool,
+
+padding must be zero (it might be used in the future),
+
+uuid is used for debug and error messages.
+
+The KVMI version can be retrieved using the KVM_CAP_INTROSPECTION of
+the KVM_CHECK_EXTENSION ioctl() at run-time.
+
+4.127 KVM_INTROSPECTION_UNHOOK
+------------------------------
+
+:Capability: KVM_CAP_INTROSPECTION
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: none
+:Returns: 0 on success, a negative value on error
+
+Errors:
+
+  ======     ==========================================================
+  EPERM      the introspection is disabled (kvm.introspection=0)
+  ======     ==========================================================
+
+This ioctl is used to free all introspection structures
+related to this VM.
 
 5. The kvm_run structure
 ========================
diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
new file mode 100644
index 000000000000..38c398262913
--- /dev/null
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_KVMI_HOST_H
+#define _ASM_X86_KVMI_HOST_H
+
+struct kvm_arch_introspection {
+};
+
+#endif /* _ASM_X86_KVMI_HOST_H */
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 880b028c7f86..fb0242032cd1 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -13,7 +13,7 @@ KVMI := $(KVM)/introspection
 kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
 				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
 kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
-kvm-$(CONFIG_KVM_INTROSPECTION) += $(KVMI)/kvmi.o
+kvm-$(CONFIG_KVM_INTROSPECTION) += $(KVMI)/kvmi.o $(KVMI)/kvmi_msg.o
 
 kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ffcf09e9bf78..ff0d3c82de64 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -56,6 +56,7 @@
 #include <linux/sched/stat.h>
 #include <linux/sched/isolation.h>
 #include <linux/mem_encrypt.h>
+#include <linux/kvmi_host.h>
 
 #include <trace/events/kvm.h>
 
@@ -3538,6 +3539,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
 		r = kvm_x86_ops.nested_ops->enable_evmcs != NULL;
 		break;
+#ifdef CONFIG_KVM_INTROSPECTION
+	case KVM_CAP_INTROSPECTION:
+		r = kvmi_version();
+		break;
+#endif
 	default:
 		break;
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5b6f1338de74..c82c55085604 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -504,6 +504,11 @@ struct kvm {
 	struct srcu_struct irq_srcu;
 	pid_t userspace_pid;
 	unsigned int max_halt_poll_ns;
+
+	struct mutex kvmi_lock;
+	refcount_t kvmi_ref;
+	struct completion kvmi_complete;
+	struct kvm_introspection *kvmi;
 };
 
 #define kvm_err(fmt, ...) \
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 1e0a73c2a190..55ff571db40d 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -4,11 +4,28 @@
 
 #ifdef CONFIG_KVM_INTROSPECTION
 
+#include <asm/kvmi_host.h>
+
+struct kvm_introspection {
+	struct kvm_arch_introspection arch;
+	struct kvm *kvm;
+
+	uuid_t uuid;
+
+	struct socket *sock;
+	struct task_struct *recv;
+};
+
+int kvmi_version(void);
 int kvmi_init(void);
 void kvmi_uninit(void);
 void kvmi_create_vm(struct kvm *kvm);
 void kvmi_destroy_vm(struct kvm *kvm);
 
+int kvmi_ioctl_hook(struct kvm *kvm,
+		    const struct kvm_introspection_hook *hook);
+int kvmi_ioctl_unhook(struct kvm *kvm);
+
 #else
 
 static inline int kvmi_init(void) { return 0; }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 4fdf30316582..dd84ebdfcd6d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1031,6 +1031,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_SECURE_GUEST 181
 #define KVM_CAP_HALT_POLL 182
 #define KVM_CAP_ASYNC_PF_INT 183
+#define KVM_CAP_INTROSPECTION 184
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1612,6 +1613,15 @@ struct kvm_sev_dbg {
 	__u32 len;
 };
 
+struct kvm_introspection_hook {
+	__s32 fd;
+	__u32 padding;
+	__u8 uuid[16];
+};
+
+#define KVM_INTROSPECTION_HOOK    _IOW(KVMIO, 0xc3, struct kvm_introspection_hook)
+#define KVM_INTROSPECTION_UNHOOK  _IO(KVMIO, 0xc4)
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
new file mode 100644
index 000000000000..34dda91016db
--- /dev/null
+++ b/include/uapi/linux/kvmi.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI__LINUX_KVMI_H
+#define _UAPI__LINUX_KVMI_H
+
+/*
+ * KVMI structures and definitions
+ */
+
+enum {
+	KVMI_VERSION = 0x00000001
+};
+
+#endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 4a166588d99f..ea8a6b08e87e 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -41,6 +41,7 @@ LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c
 TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
 TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
+TEST_GEN_PROGS_x86_64 += x86_64/kvmi_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
new file mode 100644
index 000000000000..08ca4701c440
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KVM introspection tests
+ *
+ * Copyright (C) 2020, Bitdefender S.R.L.
+ */
+
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <sys/types.h>
+#include <sys/socket.h>
+
+#include "test_util.h"
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "../lib/kvm_util_internal.h"
+
+#include "linux/kvmi.h"
+
+#define VCPU_ID         5
+
+static int socket_pair[2];
+#define Kvm_socket       socket_pair[0]
+#define Userspace_socket socket_pair[1]
+
+void setup_socket(void)
+{
+	int r;
+
+	r = socketpair(AF_UNIX, SOCK_STREAM, 0, socket_pair);
+	TEST_ASSERT(r == 0,
+		"socketpair() failed, errno %d (%s)\n",
+		errno, strerror(errno));
+}
+
+static void do_hook_ioctl(struct kvm_vm *vm, __s32 fd, __u32 padding,
+			  int expected_err)
+{
+	struct kvm_introspection_hook hook = {
+		.fd = fd,
+		.padding = padding
+	};
+	int r;
+
+	r = ioctl(vm->fd, KVM_INTROSPECTION_HOOK, &hook);
+	TEST_ASSERT(r == 0 || errno == expected_err,
+		"KVM_INTROSPECTION_HOOK failed, errno %d (%s), expected %d, fd %d, padding %d\n",
+		errno, strerror(errno), expected_err, fd, padding);
+}
+
+static void hook_introspection(struct kvm_vm *vm)
+{
+	__u32 padding = 1, no_padding = 0;
+
+	do_hook_ioctl(vm, Kvm_socket, padding, EINVAL);
+	do_hook_ioctl(vm, -1, no_padding, EINVAL);
+	do_hook_ioctl(vm, Kvm_socket, no_padding, 0);
+	do_hook_ioctl(vm, Kvm_socket, no_padding, EEXIST);
+}
+
+static void unhook_introspection(struct kvm_vm *vm)
+{
+	int r;
+
+	r = ioctl(vm->fd, KVM_INTROSPECTION_UNHOOK, NULL);
+	TEST_ASSERT(r == 0,
+		"KVM_INTROSPECTION_UNHOOK failed, errno %d (%s)\n",
+		errno, strerror(errno));
+}
+
+static void test_introspection(struct kvm_vm *vm)
+{
+	setup_socket();
+	hook_introspection(vm);
+	unhook_introspection(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vm *vm;
+
+	if (!kvm_check_cap(KVM_CAP_INTROSPECTION)) {
+		print_skip("KVM_CAP_INTROSPECTION not available");
+		exit(KSFT_SKIP);
+	}
+
+	vm = vm_create_default(VCPU_ID, 0, NULL);
+	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+
+	test_introspection(vm);
+
+	kvm_vm_free(vm);
+	return 0;
+}
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index af53bdcb7ec8..5d9bc4ed5060 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2017-2020 Bitdefender S.R.L.
  *
  */
+#include <linux/kthread.h>
 #include "kvmi_int.h"
 
 int kvmi_init(void)
@@ -12,14 +13,175 @@ int kvmi_init(void)
 	return 0;
 }
 
+int kvmi_version(void)
+{
+	return KVMI_VERSION;
+}
+
 void kvmi_uninit(void)
 {
 }
 
+static void free_kvmi(struct kvm *kvm)
+{
+	kfree(kvm->kvmi);
+	kvm->kvmi = NULL;
+}
+
+static struct kvm_introspection *
+alloc_kvmi(struct kvm *kvm, const struct kvm_introspection_hook *hook)
+{
+	struct kvm_introspection *kvmi;
+
+	kvmi = kzalloc(sizeof(*kvmi), GFP_KERNEL);
+	if (!kvmi)
+		return NULL;
+
+	BUILD_BUG_ON(sizeof(hook->uuid) != sizeof(kvmi->uuid));
+	memcpy(&kvmi->uuid, &hook->uuid, sizeof(kvmi->uuid));
+
+	kvmi->kvm = kvm;
+
+	return kvmi;
+}
+
+static void kvmi_destroy(struct kvm_introspection *kvmi)
+{
+	struct kvm *kvm = kvmi->kvm;
+
+	free_kvmi(kvm);
+}
+
+static void kvmi_stop_recv_thread(struct kvm_introspection *kvmi)
+{
+	kvmi_sock_shutdown(kvmi);
+}
+
+static void __kvmi_unhook(struct kvm *kvm)
+{
+	struct kvm_introspection *kvmi = KVMI(kvm);
+
+	wait_for_completion_killable(&kvm->kvmi_complete);
+	kvmi_sock_put(kvmi);
+}
+
+static void kvmi_unhook(struct kvm *kvm)
+{
+	struct kvm_introspection *kvmi;
+
+	mutex_lock(&kvm->kvmi_lock);
+
+	kvmi = KVMI(kvm);
+	if (kvmi) {
+		kvmi_stop_recv_thread(kvmi);
+		__kvmi_unhook(kvm);
+		kvmi_destroy(kvmi);
+	}
+
+	mutex_unlock(&kvm->kvmi_lock);
+}
+
+int kvmi_ioctl_unhook(struct kvm *kvm)
+{
+	kvmi_unhook(kvm);
+	return 0;
+}
+
+void kvmi_put(struct kvm *kvm)
+{
+	if (refcount_dec_and_test(&kvm->kvmi_ref))
+		complete(&kvm->kvmi_complete);
+}
+
+static int __kvmi_hook(struct kvm *kvm,
+		       const struct kvm_introspection_hook *hook)
+{
+	struct kvm_introspection *kvmi = KVMI(kvm);
+
+	if (!kvmi_sock_get(kvmi, hook->fd))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int kvmi_recv_thread(void *arg)
+{
+	struct kvm_introspection *kvmi = arg;
+
+	while (kvmi_msg_process(kvmi))
+		;
+
+	/*
+	 * Signal userspace (which might wait for POLLHUP only)
+	 * and prevent the vCPUs from sending other events.
+	 */
+	kvmi_sock_shutdown(kvmi);
+
+	kvmi_put(kvmi->kvm);
+	return 0;
+}
+
+int kvmi_hook(struct kvm *kvm, const struct kvm_introspection_hook *hook)
+{
+	struct kvm_introspection *kvmi;
+	int err = 0;
+
+	mutex_lock(&kvm->kvmi_lock);
+
+	if (kvm->kvmi) {
+		err = -EEXIST;
+		goto out;
+	}
+
+	kvmi = alloc_kvmi(kvm, hook);
+	if (!kvmi) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	kvm->kvmi = kvmi;
+
+	err = __kvmi_hook(kvm, hook);
+	if (err)
+		goto destroy;
+
+	init_completion(&kvm->kvmi_complete);
+
+	refcount_set(&kvm->kvmi_ref, 1);
+
+	kvmi->recv = kthread_run(kvmi_recv_thread, kvmi, "kvmi-recv");
+	if (IS_ERR(kvmi->recv)) {
+		err = -ENOMEM;
+		kvmi_put(kvm);
+		goto unhook;
+	}
+
+	goto out;
+
+unhook:
+	__kvmi_unhook(kvm);
+destroy:
+	kvmi_destroy(kvmi);
+out:
+	mutex_unlock(&kvm->kvmi_lock);
+	return err;
+}
+
+int kvmi_ioctl_hook(struct kvm *kvm,
+		    const struct kvm_introspection_hook *hook)
+{
+	if (hook->padding)
+		return -EINVAL;
+
+	return kvmi_hook(kvm, hook);
+}
+
 void kvmi_create_vm(struct kvm *kvm)
 {
+	mutex_init(&kvm->kvmi_lock);
 }
 
 void kvmi_destroy_vm(struct kvm *kvm)
 {
+	kvmi_unhook(kvm);
 }
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 34af926f9838..f0a8d653d79b 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -3,5 +3,27 @@
 #define __KVMI_INT_H__
 
 #include <linux/kvm_host.h>
+#include <linux/kvmi_host.h>
+#include <uapi/linux/kvmi.h>
+
+#define kvmi_warn(kvmi, fmt, ...) \
+	kvm_info("%pU WARNING: " fmt, &kvmi->uuid, ## __VA_ARGS__)
+#define kvmi_warn_once(kvmi, fmt, ...) ({                     \
+		static bool __section(.data.once) __warned;   \
+		if (!__warned) {                              \
+			__warned = true;                      \
+			kvmi_warn(kvmi, fmt, ## __VA_ARGS__); \
+		}                                             \
+	})
+#define kvmi_err(kvmi, fmt, ...) \
+	kvm_info("%pU ERROR: " fmt, &kvmi->uuid, ## __VA_ARGS__)
+
+#define KVMI(kvm) ((kvm)->kvmi)
+
+/* kvmi_msg.c */
+bool kvmi_sock_get(struct kvm_introspection *kvmi, int fd);
+void kvmi_sock_shutdown(struct kvm_introspection *kvmi);
+void kvmi_sock_put(struct kvm_introspection *kvmi);
+bool kvmi_msg_process(struct kvm_introspection *kvmi);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
new file mode 100644
index 000000000000..3ae52c61f861
--- /dev/null
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KVM introspection (message handling)
+ *
+ * Copyright (C) 2017-2020 Bitdefender S.R.L.
+ *
+ */
+#include <linux/net.h>
+#include "kvmi_int.h"
+
+bool kvmi_sock_get(struct kvm_introspection *kvmi, int fd)
+{
+	struct socket *sock;
+	int err;
+
+	sock = sockfd_lookup(fd, &err);
+	if (!sock)
+		return false;
+
+	kvmi->sock = sock;
+
+	return true;
+}
+
+void kvmi_sock_put(struct kvm_introspection *kvmi)
+{
+	if (kvmi->sock)
+		sockfd_put(kvmi->sock);
+}
+
+void kvmi_sock_shutdown(struct kvm_introspection *kvmi)
+{
+	kernel_sock_shutdown(kvmi->sock, SHUT_RDWR);
+}
+
+bool kvmi_msg_process(struct kvm_introspection *kvmi)
+{
+	return false;
+}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a2b424fd2efd..0d2da77ccb12 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3829,6 +3829,25 @@ static long kvm_vm_ioctl(struct file *filp,
 	case KVM_CHECK_EXTENSION:
 		r = kvm_vm_ioctl_check_extension_generic(kvm, arg);
 		break;
+#ifdef CONFIG_KVM_INTROSPECTION
+	case KVM_INTROSPECTION_HOOK:
+		r = -EPERM;
+		if (enable_introspection) {
+			struct kvm_introspection_hook hook;
+
+			if (copy_from_user(&hook, argp, sizeof(hook)))
+				r = -EFAULT;
+			else
+				r = kvmi_ioctl_hook(kvm, &hook);
+		}
+		break;
+	case KVM_INTROSPECTION_UNHOOK:
+		if (enable_introspection)
+			r = kvmi_ioctl_unhook(kvm);
+		else
+			r = -EPERM;
+		break;
+#endif /* CONFIG_KVM_INTROSPECTION */
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
 	}
