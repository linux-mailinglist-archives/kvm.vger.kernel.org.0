Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039072C3CAC
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbgKYJmi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:38 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57094 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728295AbgKYJmE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:42:04 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 26ADF305D513;
        Wed, 25 Nov 2020 11:35:48 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id EE9EE3072785;
        Wed, 25 Nov 2020 11:35:47 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        =?UTF-8?q?Mircea=20C=C3=AErjaliu?= <mcirjaliu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>
Subject: [PATCH v10 33/81] KVM: introspection: add hook/unhook ioctls
Date:   Wed, 25 Nov 2020 11:35:12 +0200
Message-Id: <20201125093600.2766-34-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

The mutex is used to protect the 'kvm->kvmi' pointer when accessed
through ioctls.

The reference counter is incremented by the receiving thread (for
its entire life time) and by the vCPU threads while sending events or
handling commands.

The completion objects is set when the reference counter reaches zero,
allowing the unhook process to continue and free the introspection
structures.

Co-developed-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Signed-off-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/api.rst                |  63 +++++++
 arch/x86/include/asm/kvmi_host.h              |   8 +
 arch/x86/kvm/Makefile                         |   2 +-
 arch/x86/kvm/x86.c                            |   5 +
 include/linux/kvm_host.h                      |   5 +
 include/linux/kvmi_host.h                     |  18 ++
 include/uapi/linux/kvm.h                      |  10 ++
 include/uapi/linux/kvmi.h                     |  13 ++
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  |  87 ++++++++++
 virt/kvm/introspection/kvmi.c                 | 159 ++++++++++++++++++
 virt/kvm/introspection/kvmi_int.h             |  10 ++
 virt/kvm/introspection/kvmi_msg.c             |  39 +++++
 virt/kvm/kvm_main.c                           |  21 +++
 14 files changed, 440 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/kvmi_host.h
 create mode 100644 include/uapi/linux/kvmi.h
 create mode 100644 tools/testing/selftests/kvm/x86_64/kvmi_test.c
 create mode 100644 virt/kvm/introspection/kvmi_msg.c

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 70254eaa5229..9b48be90ae7b 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4825,6 +4825,58 @@ into user space.
 If a vCPU is in running state while this ioctl is invoked, the vCPU may
 experience inconsistent filtering behavior on MSR accesses.
 
+4.127 KVM_INTROSPECTION_HOOK
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
+4.128 KVM_INTROSPECTION_UNHOOK
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
@@ -6496,3 +6548,14 @@ KVM_GET_DIRTY_LOG and KVM_CLEAR_DIRTY_LOG.  After enabling
 KVM_CAP_DIRTY_LOG_RING with an acceptable dirty ring size, the virtual
 machine will switch to ring-buffer dirty page tracking and further
 KVM_GET_DIRTY_LOG or KVM_CLEAR_DIRTY_LOG ioctls will fail.
+
+8.30 KVM_CAP_INTROSPECTION
+--------------------------
+
+:Architectures: x86
+
+This capability indicates that KVM supports VM introspection
+and it is enabled.
+
+The KVM_CHECK_EXTENSION ioctl returns the introspection API version
+(a number larger than 0).
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
index e9784df055d4..db4121b4112d 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -14,7 +14,7 @@ kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
 				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o \
 				$(KVM)/dirty_ring.o
 kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
-kvm-$(CONFIG_KVM_INTROSPECTION) += $(KVMI)/kvmi.o
+kvm-$(CONFIG_KVM_INTROSPECTION) += $(KVMI)/kvmi.o $(KVMI)/kvmi_msg.o
 
 kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 45221caeb84d..fcf7e68cb6c8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -57,6 +57,7 @@
 #include <linux/sched/isolation.h>
 #include <linux/mem_encrypt.h>
 #include <linux/entry-kvm.h>
+#include <linux/kvmi_host.h>
 
 #include <trace/events/kvm.h>
 
@@ -3828,6 +3829,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_STEAL_TIME:
 		r = sched_info_on();
 		break;
+	case KVM_CAP_INTROSPECTION:
+		if (enable_introspection)
+			r = kvmi_version();
+		break;
 	default:
 		break;
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index db04dab23013..51e6a4d7e5c9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -513,6 +513,11 @@ struct kvm {
 	pid_t userspace_pid;
 	unsigned int max_halt_poll_ns;
 	u32 dirty_ring_size;
+
+	struct mutex kvmi_lock;
+	refcount_t kvmi_ref;
+	struct completion kvmi_complete;
+	struct kvm_introspection *kvmi;
 };
 
 #define kvm_err(fmt, ...) \
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 1e0a73c2a190..8574b9688736 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -4,13 +4,31 @@
 
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
 
+static inline int kvmi_version(void) { return 0; }
 static inline int kvmi_init(void) { return 0; }
 static inline void kvmi_uninit(void) { }
 static inline void kvmi_create_vm(struct kvm *kvm) { }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 886802b8ffba..a0be0ea5b13f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1056,6 +1056,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
 #define KVM_CAP_SYS_HYPERV_CPUID 191
 #define KVM_CAP_DIRTY_LOG_RING 192
+#define KVM_CAP_INTROSPECTION 193
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1643,6 +1644,15 @@ struct kvm_sev_dbg {
 	__u32 len;
 };
 
+struct kvm_introspection_hook {
+	__s32 fd;
+	__u32 padding;
+	__u8 uuid[16];
+};
+
+#define KVM_INTROSPECTION_HOOK    _IOW(KVMIO, 0xc8, struct kvm_introspection_hook)
+#define KVM_INTROSPECTION_UNHOOK  _IO(KVMIO, 0xc9)
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
index 4febf4d5ead9..f6e9a442a0a0 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -42,6 +42,7 @@ TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
 TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
+TEST_GEN_PROGS_x86_64 += x86_64/kvmi_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
new file mode 100644
index 000000000000..13d3e0a3af9d
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -0,0 +1,87 @@
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
+#define VCPU_ID 1
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
+static void do_hook_ioctl(struct kvm_vm *vm, __s32 fd, int expected_err)
+{
+	struct kvm_introspection_hook hook = { .fd = fd, };
+	int r;
+
+	r = ioctl(vm->fd, KVM_INTROSPECTION_HOOK, &hook);
+	TEST_ASSERT(r == 0 || errno == expected_err,
+		"KVM_INTROSPECTION_HOOK failed, errno %d (%s), expected %d, fd %d\n",
+		errno, strerror(errno), expected_err, fd);
+}
+
+static void hook_introspection(struct kvm_vm *vm)
+{
+	do_hook_ioctl(vm, -1, EINVAL);
+	do_hook_ioctl(vm, Kvm_socket, 0);
+	do_hook_ioctl(vm, Kvm_socket, EEXIST);
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
index af53bdcb7ec8..3367023219b7 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2017-2020 Bitdefender S.R.L.
  *
  */
+#include <linux/kthread.h>
 #include "kvmi_int.h"
 
 int kvmi_init(void)
@@ -12,14 +13,172 @@ int kvmi_init(void)
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
 
+static void kvmi_free(struct kvm *kvm)
+{
+	kfree(kvm->kvmi);
+	kvm->kvmi = NULL;
+}
+
+static struct kvm_introspection *
+kvmi_alloc(struct kvm *kvm, const struct kvm_introspection_hook *hook)
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
+	kvmi_free(kvm);
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
+	/* Signal userspace and prevent the vCPUs from sending events. */
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
+	kvmi = kvmi_alloc(kvm, hook);
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
index bdb4228fda5b..c89875bd2bac 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -3,5 +3,15 @@
 #define __KVMI_INT_H
 
 #include <linux/kvm_host.h>
+#include <linux/kvmi_host.h>
+#include <uapi/linux/kvmi.h>
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
index d995be2421eb..66fa749a2c6e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4015,6 +4015,27 @@ static long kvm_vm_ioctl(struct file *filp,
 	case KVM_RESET_DIRTY_RINGS:
 		r = kvm_vm_ioctl_reset_dirty_pages(kvm);
 		break;
+#ifdef CONFIG_KVM_INTROSPECTION
+	case KVM_INTROSPECTION_HOOK: {
+		struct kvm_introspection_hook hook;
+
+		r = -EPERM;
+		if (!enable_introspection)
+			goto out;
+
+		r = -EFAULT;
+		if (copy_from_user(&hook, argp, sizeof(hook)))
+			goto out;
+
+		r = kvmi_ioctl_hook(kvm, &hook);
+		break;
+	}
+	case KVM_INTROSPECTION_UNHOOK:
+		r = -EPERM;
+		if (enable_introspection)
+			r = kvmi_ioctl_unhook(kvm);
+		break;
+#endif /* CONFIG_KVM_INTROSPECTION */
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
 	}
