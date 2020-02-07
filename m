Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18870155DBA
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbgBGSSH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:18:07 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40684 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727573AbgBGSQu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:50 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 4D232305D343;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 3E2A73052073;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        =?UTF-8?q?Mircea=20C=C3=AErjaliu?= <mcirjaliu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>
Subject: [RFC PATCH v7 37/78] KVM: introspection: add hook/unhook ioctls
Date:   Fri,  7 Feb 2020 20:15:55 +0200
Message-Id: <20200207181636.1065-38-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On hook, a new thread is created to handle the messages coming from the
introspection tool (commands or event replies).

Co-developed-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Signed-off-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/api.txt                |  42 +++++
 arch/x86/include/asm/kvmi_host.h              |   8 +
 arch/x86/kvm/Makefile                         |   2 +-
 arch/x86/kvm/x86.c                            |   5 +
 include/linux/kvm_host.h                      |   2 +
 include/linux/kvmi_host.h                     |  17 ++
 include/uapi/linux/kvm.h                      |  10 ++
 include/uapi/linux/kvmi.h                     |  13 ++
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  |  78 +++++++++
 virt/kvm/introspection/kvmi.c                 | 148 ++++++++++++++++++
 virt/kvm/introspection/kvmi_int.h             |  20 +++
 virt/kvm/introspection/kvmi_msg.c             |  39 +++++
 virt/kvm/kvm_main.c                           |  11 ++
 14 files changed, 395 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/kvmi_host.h
 create mode 100644 include/uapi/linux/kvmi.h
 create mode 100644 tools/testing/selftests/kvm/x86_64/kvmi_test.c
 create mode 100644 virt/kvm/introspection/kvmi_msg.c

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index ebb37b34dcfc..540d9015d726 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -4168,6 +4168,48 @@ This ioctl issues an ultravisor call to terminate the secure guest,
 unpins the VPA pages and releases all the device pages that are used to
 track the secure pages by hypervisor.
 
+4.122 KVM_INTROSPECTION_HOOK
+
+Capability: KVM_CAP_INTROSPECTION
+Architectures: x86
+Type: vm ioctl
+Parameters: struct kvm_introspection (in)
+Returns: 0 on success, a negative value on error
+Errors:
+  ENOMEM: memory allocation failed
+  EEXIST: the VM is already introspected
+  EINVAL: the file descriptor doesn't correspond to an active socket
+          padding is not zero
+  EPERM: the introspection is disabled (kvm.introspection=0)
+
+This ioctl is used to enable the introspection of the current VM.
+
+struct kvm_introspection {
+	__s32 fd;
+	__u32 padding;
+	__u8 uuid[16];
+};
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
+4.123 KVM_INTROSPECTION_UNHOOK
+
+Capability: KVM_CAP_INTROSPECTION
+Architectures: x86
+Type: vm ioctl
+Parameters: none
+Returns: 0 on success, a negative value on error
+
+This ioctl is used to free all introspection structures
+related to this VM.
+
 5. The kvm_run structure
 ------------------------
 
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
index 53b3579c2900..c46ec49dfeb9 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -8,7 +8,7 @@ KVMI := $(KVM)/introspection
 kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
 				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
 kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
-kvm-$(CONFIG_KVM_INTROSPECTION) += $(KVMI)/kvmi.o
+kvm-$(CONFIG_KVM_INTROSPECTION) += $(KVMI)/kvmi.o $(KVMI)/kvmi_msg.o
 
 kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6e665341cc80..46aeb32cb07f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3335,6 +3335,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
 		r = kvm_x86_ops->nested_enable_evmcs != NULL;
 		break;
+#ifdef CONFIG_KVM_INTROSPECTION
+	case KVM_CAP_INTROSPECTION:
+		r = KVMI_VERSION;
+		break;
+#endif
 	default:
 		break;
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 862dc45f971f..0104cb2c8ee0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -503,6 +503,8 @@ struct kvm {
 	struct srcu_struct srcu;
 	struct srcu_struct irq_srcu;
 	pid_t userspace_pid;
+	struct mutex kvmi_lock;
+	struct kvm_introspection *kvmi;
 };
 
 #define kvm_err(fmt, ...) \
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 8cd613fdd4f2..c8b9c87ecff2 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -2,8 +2,22 @@
 #ifndef __KVMI_HOST_H
 #define __KVMI_HOST_H
 
+#include <uapi/linux/kvmi.h>
+
 struct kvm;
 
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
 #ifdef CONFIG_KVM_INTROSPECTION
 
 int kvmi_init(void);
@@ -11,6 +25,9 @@ void kvmi_uninit(void);
 void kvmi_create_vm(struct kvm *kvm);
 void kvmi_destroy_vm(struct kvm *kvm);
 
+int kvmi_ioctl_hook(struct kvm *kvm, void __user *argp);
+int kvmi_ioctl_unhook(struct kvm *kvm);
+
 #else
 
 static inline int kvmi_init(void) { return 0; }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f0a16b4adbbd..09132d8dd3e5 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1009,6 +1009,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_GUEST_DEBUG_SSTEP 176
 #define KVM_CAP_ARM_NISV_TO_USER 177
 #define KVM_CAP_ARM_INJECT_EXT_DABT 178
+#define KVM_CAP_INTROSPECTION 179
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1553,6 +1554,15 @@ struct kvm_sev_dbg {
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
index 3138a916574a..c3b7c1217a6e 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -15,6 +15,7 @@ LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c
 TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
 TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
+TEST_GEN_PROGS_x86_64 += x86_64/kvmi_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
new file mode 100644
index 000000000000..cd8744ec6939
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -0,0 +1,78 @@
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
+static void hook_introspection(struct kvm_vm *vm)
+{
+	struct kvm_introspection_hook hook = {.fd = Kvm_socket};
+	int r;
+
+	r = ioctl(vm->fd, KVM_INTROSPECTION_HOOK, &hook);
+	TEST_ASSERT(r == 0,
+		"KVM_INTROSPECTION_HOOK failed, errno %d (%s)\n",
+		errno, strerror(errno));
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
+		fprintf(stderr,
+			"KVM_CAP_INTROSPECTION not available, skipping tests\n");
+		exit(KSFT_SKIP);
+	}
+
+	vm = vm_create_default(VCPU_ID, 0, NULL);
+	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+
+	test_introspection(vm);
+
+	return 0;
+}
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index c74ddb8075cd..7a009480517a 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -6,6 +6,7 @@
  *
  */
 #include "kvmi_int.h"
+#include <linux/kthread.h>
 
 int kvmi_init(void)
 {
@@ -16,10 +17,157 @@ void kvmi_uninit(void)
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
+	kvmi->recv = kthread_run(kvmi_recv_thread, kvmi, "kvmi-recv");
+	if (IS_ERR(kvmi->recv)) {
+		err = -ENOMEM;
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
+int kvmi_ioctl_hook(struct kvm *kvm, void __user *argp)
+{
+	struct kvm_introspection_hook i;
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
+	mutex_init(&kvm->kvmi_lock);
 }
 
 void kvmi_destroy_vm(struct kvm *kvm)
 {
+	kvmi_unhook(kvm);
 }
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 34af926f9838..01451d573788 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -4,4 +4,24 @@
 
 #include <linux/kvm_host.h>
 
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
+#define KVMI(kvm) ((struct kvm_introspection *)((kvm)->kvmi))
+
+/* kvmi_msg.c */
+bool kvmi_sock_get(struct kvm_introspection *kvmi, int fd);
+void kvmi_sock_shutdown(struct kvm_introspection *kvmi);
+void kvmi_sock_put(struct kvm_introspection *kvmi);
+bool kvmi_msg_process(struct kvm_introspection *kvmi);
+
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
new file mode 100644
index 000000000000..f9e66274fb43
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
+	int r;
+
+	sock = sockfd_lookup(fd, &r);
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
index d33065665e22..77bab9ba918b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3495,6 +3495,17 @@ static long kvm_vm_ioctl(struct file *filp,
 	case KVM_CHECK_EXTENSION:
 		r = kvm_vm_ioctl_check_extension_generic(kvm, arg);
 		break;
+#ifdef CONFIG_KVM_INTROSPECTION
+	case KVM_INTROSPECTION_HOOK:
+		if (enable_introspection)
+			r = kvmi_ioctl_hook(kvm, argp);
+		else
+			r = -EPERM;
+		break;
+	case KVM_INTROSPECTION_UNHOOK:
+		r = kvmi_ioctl_unhook(kvm);
+		break;
+#endif /* CONFIG_KVM_INTROSPECTION */
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
 	}
