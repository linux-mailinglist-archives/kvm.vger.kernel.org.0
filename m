Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C6D228ADA
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731321AbgGUVRd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:17:33 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:38060 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731255AbgGUVQH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:07 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 83A1E30412EB;
        Wed, 22 Jul 2020 00:09:24 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 5CFDA304FA15;
        Wed, 22 Jul 2020 00:09:24 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 37/84] KVM: introduce VM introspection
Date:   Wed, 22 Jul 2020 00:08:35 +0300
Message-Id: <20200721210922.7646-38-alazar@bitdefender.com>
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

The KVM introspection subsystem provides a facility for applications
to control the execution of any running VMs (pause, resume, shutdown),
query the state of the vCPUs (GPRs, MSRs etc.), alter the page access bits
in the shadow page tables and receive notifications when events of interest
have taken place (shadow page table level faults, key MSR writes,
hypercalls etc.). Some notifications can be responded to with an action
(like preventing an MSR from being written), others are mere informative
(like breakpoint events which can be used for execution tracing).

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Marian Rotariu <marian.c.rotariu@gmail.com>
Signed-off-by: Marian Rotariu <marian.c.rotariu@gmail.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst   | 140 ++++++++++++++++++++++++++++++
 arch/x86/kvm/Kconfig              |  13 +++
 arch/x86/kvm/Makefile             |   2 +
 include/linux/kvmi_host.h         |  21 +++++
 virt/kvm/introspection/kvmi.c     |  25 ++++++
 virt/kvm/introspection/kvmi_int.h |   7 ++
 virt/kvm/kvm_main.c               |  15 ++++
 7 files changed, 223 insertions(+)
 create mode 100644 Documentation/virt/kvm/kvmi.rst
 create mode 100644 include/linux/kvmi_host.h
 create mode 100644 virt/kvm/introspection/kvmi.c
 create mode 100644 virt/kvm/introspection/kvmi_int.h

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
new file mode 100644
index 000000000000..3a1b6c655de7
--- /dev/null
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -0,0 +1,140 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================================================
+KVMI - The kernel virtual machine introspection subsystem
+=========================================================
+
+The KVM introspection subsystem provides a facility for applications running
+on the host or in a separate VM, to control the execution of any running VMs
+(pause, resume, shutdown), query the state of the vCPUs (GPRs, MSRs etc.),
+alter the page access bits in the shadow page tables (only for the hardware
+backed ones, eg. Intel's EPT) and receive notifications when events of
+interest have taken place (shadow page table level faults, key MSR writes,
+hypercalls etc.). Some notifications can be responded to with an action
+(like preventing an MSR from being written), others are mere informative
+(like breakpoint events which can be used for execution tracing).
+With few exceptions, all events are optional. An application using this
+subsystem will explicitly register for them.
+
+The use case that gave way for the creation of this subsystem is to monitor
+the guest OS and as such the ABI/API is highly influenced by how the guest
+software (kernel, applications) sees the world. For example, some events
+provide information specific for the host CPU architecture
+(eg. MSR_IA32_SYSENTER_EIP) merely because its leveraged by guest software
+to implement a critical feature (fast system calls).
+
+At the moment, the target audience for KVMI are security software authors
+that wish to perform forensics on newly discovered threats (exploits) or
+to implement another layer of security like preventing a large set of
+kernel rootkits simply by "locking" the kernel image in the shadow page
+tables (ie. enforce .text r-x, .rodata rw- etc.). It's the latter case that
+made KVMI a separate subsystem, even though many of these features are
+available in the device manager (eg. QEMU). The ability to build a security
+application that does not interfere (in terms of performance) with the
+guest software asks for a specialized interface that is designed for minimum
+overhead.
+
+API/ABI
+=======
+
+This chapter describes the VMI interface used to monitor and control local
+guests from a user application.
+
+Overview
+--------
+
+The interface is socket based, one connection for every VM. One end is in the
+host kernel while the other is held by the user application (introspection
+tool).
+
+The initial connection is established by an application running on the host
+(eg. QEMU) that connects to the introspection tool and after a handshake
+the socket is passed to the host kernel making all further communication
+take place between it and the introspection tool.
+
+The socket protocol allows for commands and events to be multiplexed over
+the same connection. As such, it is possible for the introspection tool to
+receive an event while waiting for the result of a command. Also, it can
+send a command while the host kernel is waiting for a reply to an event.
+
+The kernel side of the socket communication is blocking and will wait
+for an answer from its peer indefinitely or until the guest is powered
+off (killed), restarted or the peer goes away, at which point it will
+wake up and properly cleanup as if the introspection subsystem has never
+been used on that guest (if requested). Obviously, whether the guest can
+really continue normal execution depends on whether the introspection
+tool has made any modifications that require an active KVMI channel.
+
+Handshake
+---------
+
+Although this falls out of the scope of the introspection subsystem, below
+is a proposal of a handshake that can be used by implementors.
+
+Based on the system administration policies, the management tool
+(eg. libvirt) starts device managers (eg. QEMU) with some extra arguments:
+what introspection tool could monitor/control that specific guest (and
+how to connect to) and what introspection commands/events are allowed.
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
+commands/events) to KVM. It will detect when the socket is shutdown
+and it will reinitiate the handshake.
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
+of QEMU, it will use another ioctl to notify the introspection tool and
+wait for a limited amount of time (a few seconds) for a confirmation that
+is OK to proceed (it is enough for the introspection tool to close
+the connection).
+
+Live migrations
+---------------
+
+Before the live migration takes place, the introspection tool has to be
+notified and have a chance to unhook (see **Unhooking**).
+
+The QEMU instance on the receiving end, if configured for KVMI, will need
+to establish a connection to the introspection tool after the migration
+has been completed.
+
+Obviously, this creates a window in which the guest is not introspected.
+The user has to be aware of this detail. Future introspection technologies
+can choose not to disconnect and instead transfer the necessary context
+to the introspection tool at the migration destination via a separate
+channel.
+
+Memory access safety
+--------------------
+
+The KVMI API gives access to the entire guest physical address space but
+provides no information on which parts of it are system RAM and which are
+device-specific memory (DMA, emulated MMIO, reserved by a passthrough
+device etc.). It is up to the user to determine, using the guest operating
+system data structures, the areas that are safe to access (code, stack, heap
+etc.).
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index b277a2db6267..34d0b1bbab95 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -107,4 +107,17 @@ config KVM_MMU_AUDIT
 	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
 	 auditing of KVM MMU events at runtime.
 
+config KVM_INTROSPECTION
+	bool "KVM Introspection"
+	depends on KVM && (KVM_INTEL || KVM_AMD)
+	default n
+	help
+	  Provides the introspection interface, which allows the control
+	  of any running VM. It must be explicitly enabled by setting
+	  the module parameter 'kvm.introspection'.
+
+# OK, it's a little counter-intuitive to do this, but it puts it neatly under
+# the virtualization menu.
+source "drivers/vhost/Kconfig"
+
 endif # VIRTUALIZATION
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 4a3081e9f4b5..880b028c7f86 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -8,10 +8,12 @@ OBJECT_FILES_NON_STANDARD_vmenter.o := y
 endif
 
 KVM := ../../../virt/kvm
+KVMI := $(KVM)/introspection
 
 kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
 				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
 kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
+kvm-$(CONFIG_KVM_INTROSPECTION) += $(KVMI)/kvmi.o
 
 kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
new file mode 100644
index 000000000000..1e0a73c2a190
--- /dev/null
+++ b/include/linux/kvmi_host.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __KVMI_HOST_H
+#define __KVMI_HOST_H
+
+#ifdef CONFIG_KVM_INTROSPECTION
+
+int kvmi_init(void);
+void kvmi_uninit(void);
+void kvmi_create_vm(struct kvm *kvm);
+void kvmi_destroy_vm(struct kvm *kvm);
+
+#else
+
+static inline int kvmi_init(void) { return 0; }
+static inline void kvmi_uninit(void) { }
+static inline void kvmi_create_vm(struct kvm *kvm) { }
+static inline void kvmi_destroy_vm(struct kvm *kvm) { }
+
+#endif /* CONFIG_KVM_INTROSPECTION */
+
+#endif
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
new file mode 100644
index 000000000000..af53bdcb7ec8
--- /dev/null
+++ b/virt/kvm/introspection/kvmi.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KVM Introspection
+ *
+ * Copyright (C) 2017-2020 Bitdefender S.R.L.
+ *
+ */
+#include "kvmi_int.h"
+
+int kvmi_init(void)
+{
+	return 0;
+}
+
+void kvmi_uninit(void)
+{
+}
+
+void kvmi_create_vm(struct kvm *kvm)
+{
+}
+
+void kvmi_destroy_vm(struct kvm *kvm)
+{
+}
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
new file mode 100644
index 000000000000..34af926f9838
--- /dev/null
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVMI_INT_H__
+#define __KVMI_INT_H__
+
+#include <linux/kvm_host.h>
+
+#endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8c4bccf33c8c..a2b424fd2efd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -51,6 +51,7 @@
 #include <linux/io.h>
 #include <linux/lockdep.h>
 #include <linux/kthread.h>
+#include <linux/kvmi_host.h>
 
 #include <asm/processor.h>
 #include <asm/ioctl.h>
@@ -89,6 +90,9 @@ unsigned int halt_poll_ns_shrink;
 module_param(halt_poll_ns_shrink, uint, 0644);
 EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
 
+static bool enable_introspection;
+module_param_named(introspection, enable_introspection, bool, 0644);
+
 /*
  * Ordering of locks:
  *
@@ -745,6 +749,9 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	if (r)
 		goto out_err;
 
+	if (enable_introspection)
+		kvmi_create_vm(kvm);
+
 	mutex_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
 	mutex_unlock(&kvm_lock);
@@ -797,6 +804,8 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	int i;
 	struct mm_struct *mm = kvm->mm;
 
+	if (enable_introspection)
+		kvmi_destroy_vm(kvm);
 	kvm_uevent_notify_change(KVM_EVENT_DESTROY_VM, kvm);
 	kvm_destroy_vm_debugfs(kvm);
 	kvm_arch_sync_events(kvm);
@@ -4811,6 +4820,11 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	r = kvm_vfio_ops_init();
 	WARN_ON(r);
 
+	if (enable_introspection) {
+		r = kvmi_init();
+		WARN_ON(r);
+	}
+
 	return 0;
 
 out_unreg:
@@ -4835,6 +4849,7 @@ EXPORT_SYMBOL_GPL(kvm_init);
 
 void kvm_exit(void)
 {
+	kvmi_uninit();
 	debugfs_remove_recursive(kvm_debugfs_dir);
 	misc_deregister(&kvm_dev);
 	kmem_cache_destroy(kvm_vcpu_cache);
