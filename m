Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B30987F00
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437063AbfHIQJ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:09:59 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52682 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436964AbfHIQJ4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:09:56 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 5A61E305D3CD;
        Fri,  9 Aug 2019 19:00:50 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 15181305B7A0;
        Fri,  9 Aug 2019 19:00:50 +0300 (EEST)
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
Subject: [RFC PATCH v6 01/92] kvm: introduce KVMI (VM introspection subsystem)
Date:   Fri,  9 Aug 2019 18:59:16 +0300
Message-Id: <20190809160047.8319-2-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

Besides the pointer to the new structure, the patch adds to the kvm
structure a reference counter (the new object will be used by the thread
receiving introspection commands/events) and a completion variable
(to signal that the VM can be hooked by the introspection tool).

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Signed-off-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst | 75 ++++++++++++++++++++++++++++++
 arch/x86/kvm/Kconfig               |  7 +++
 arch/x86/kvm/Makefile              |  1 +
 include/linux/kvm_host.h           |  4 ++
 include/linux/kvmi.h               | 23 +++++++++
 include/uapi/linux/kvmi.h          | 68 +++++++++++++++++++++++++++
 virt/kvm/kvm_main.c                | 10 +++-
 virt/kvm/kvmi.c                    | 64 +++++++++++++++++++++++++
 virt/kvm/kvmi_int.h                | 12 +++++
 9 files changed, 263 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/virtual/kvm/kvmi.rst
 create mode 100644 include/linux/kvmi.h
 create mode 100644 include/uapi/linux/kvmi.h
 create mode 100644 virt/kvm/kvmi.c
 create mode 100644 virt/kvm/kvmi_int.h

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
new file mode 100644
index 000000000000..d54caf8d974f
--- /dev/null
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -0,0 +1,75 @@
+=========================================================
+KVMI - The kernel virtual machine introspection subsystem
+=========================================================
+
+The KVM introspection subsystem provides a facility for applications running
+on the host or in a separate VM, to control the execution of other VM-s
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
+(eg. QEMU) that connects to the introspection tool and after a handshake the
+socket is passed to the host kernel making all further communication take
+place between it and the introspection tool. The initiating party (QEMU) can
+close its end so that any potential exploits cannot take a hold of it.
+
+The socket protocol allows for commands and events to be multiplexed over
+the same connection. As such, it is possible for the introspection tool to
+receive an event while waiting for the result of a command. Also, it can
+send a command while the host kernel is waiting for a reply to an event.
+
+The kernel side of the socket communication is blocking and will wait for
+an answer from its peer indefinitely or until the guest is powered off
+(killed), restarted or the peer goes away, at which point it will wake
+up and properly cleanup as if the introspection subsystem has never been
+used on that guest. Obviously, whether the guest can really continue
+normal execution depends on whether the introspection tool has made any
+modifications that require an active KVMI channel.
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
index 72fa955f4a15..f70a6a1b6814 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -96,6 +96,13 @@ config KVM_MMU_AUDIT
 	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
 	 auditing of KVM MMU events at runtime.
 
+config KVM_INTROSPECTION
+	bool "VM Introspection"
+	depends on KVM && (KVM_INTEL || KVM_AMD)
+	help
+	 This option enables functions to control the execution of VM-s, query
+	 the state of the vCPU-s (GPR-s, MSR-s etc.).
+
 # OK, it's a little counter-intuitive to do this, but it puts it neatly under
 # the virtualization menu.
 source "drivers/vhost/Kconfig"
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 31ecf7a76d5a..312597bd47c7 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -7,6 +7,7 @@ KVM := ../../../virt/kvm
 kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
 				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
 kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
+kvm-$(CONFIG_KVM_INTROSPECTION) += $(KVM)/kvmi.o
 
 kvm-y			+= x86.o mmu.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c38cc5eb7e73..582b0187f5a4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -455,6 +455,10 @@ struct kvm {
 	struct srcu_struct srcu;
 	struct srcu_struct irq_srcu;
 	pid_t userspace_pid;
+
+	struct completion kvmi_completed;
+	refcount_t kvmi_ref;
+	void *kvmi;
 };
 
 #define kvm_err(fmt, ...) \
diff --git a/include/linux/kvmi.h b/include/linux/kvmi.h
new file mode 100644
index 000000000000..e36de3f9f3de
--- /dev/null
+++ b/include/linux/kvmi.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVMI_H__
+#define __KVMI_H__
+
+#define kvmi_is_present() IS_ENABLED(CONFIG_KVM_INTROSPECTION)
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
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
new file mode 100644
index 000000000000..dbf63ad0862f
--- /dev/null
+++ b/include/uapi/linux/kvmi.h
@@ -0,0 +1,68 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI__LINUX_KVMI_H
+#define _UAPI__LINUX_KVMI_H
+
+/*
+ * KVMI structures and definitions
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+
+#define KVMI_VERSION 0x00000001
+
+enum {
+	KVMI_EVENT_REPLY           = 0,
+	KVMI_EVENT                 = 1,
+
+	KVMI_FIRST_COMMAND         = 2,
+
+	KVMI_GET_VERSION           = 2,
+	KVMI_CHECK_COMMAND         = 3,
+	KVMI_CHECK_EVENT           = 4,
+	KVMI_GET_GUEST_INFO        = 5,
+	KVMI_GET_VCPU_INFO         = 6,
+	KVMI_PAUSE_VCPU            = 7,
+	KVMI_CONTROL_VM_EVENTS     = 8,
+	KVMI_CONTROL_EVENTS        = 9,
+	KVMI_CONTROL_CR            = 10,
+	KVMI_CONTROL_MSR           = 11,
+	KVMI_CONTROL_VE            = 12,
+	KVMI_GET_REGISTERS         = 13,
+	KVMI_SET_REGISTERS         = 14,
+	KVMI_GET_CPUID             = 15,
+	KVMI_GET_XSAVE             = 16,
+	KVMI_READ_PHYSICAL         = 17,
+	KVMI_WRITE_PHYSICAL        = 18,
+	KVMI_INJECT_EXCEPTION      = 19,
+	KVMI_GET_PAGE_ACCESS       = 20,
+	KVMI_SET_PAGE_ACCESS       = 21,
+	KVMI_GET_MAP_TOKEN         = 22,
+	KVMI_GET_MTRR_TYPE         = 23,
+	KVMI_CONTROL_SPP           = 24,
+	KVMI_GET_PAGE_WRITE_BITMAP = 25,
+	KVMI_SET_PAGE_WRITE_BITMAP = 26,
+	KVMI_CONTROL_CMD_RESPONSE  = 27,
+
+	KVMI_NEXT_AVAILABLE_COMMAND,
+
+};
+
+enum {
+	KVMI_EVENT_UNHOOK      = 0,
+	KVMI_EVENT_CR	       = 1,
+	KVMI_EVENT_MSR	       = 2,
+	KVMI_EVENT_XSETBV      = 3,
+	KVMI_EVENT_BREAKPOINT  = 4,
+	KVMI_EVENT_HYPERCALL   = 5,
+	KVMI_EVENT_PF	       = 6,
+	KVMI_EVENT_TRAP	       = 7,
+	KVMI_EVENT_DESCRIPTOR  = 8,
+	KVMI_EVENT_CREATE_VCPU = 9,
+	KVMI_EVENT_PAUSE_VCPU  = 10,
+	KVMI_EVENT_SINGLESTEP  = 11,
+
+	KVMI_NUM_EVENTS
+};
+
+#endif /* _UAPI__LINUX_KVMI_H */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 585845203db8..90e432d225ab 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -51,6 +51,7 @@
 #include <linux/slab.h>
 #include <linux/sort.h>
 #include <linux/bsearch.h>
+#include <linux/kvmi.h>
 
 #include <asm/processor.h>
 #include <asm/io.h>
@@ -680,6 +681,8 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	if (r)
 		goto out_err;
 
+	kvmi_create_vm(kvm);
+
 	spin_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
 	spin_unlock(&kvm_lock);
@@ -725,6 +728,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	int i;
 	struct mm_struct *mm = kvm->mm;
 
+	kvmi_destroy_vm(kvm);
 	kvm_uevent_notify_change(KVM_EVENT_DESTROY_VM, kvm);
 	kvm_destroy_vm_debugfs(kvm);
 	kvm_arch_sync_events(kvm);
@@ -1556,7 +1560,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 	 * Whoever called remap_pfn_range is also going to call e.g.
 	 * unmap_mapping_range before the underlying pages are freed,
 	 * causing a call to our MMU notifier.
-	 */ 
+	 */
 	kvm_get_pfn(pfn);
 
 	*p_pfn = pfn;
@@ -4204,6 +4208,9 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	r = kvm_vfio_ops_init();
 	WARN_ON(r);
 
+	r = kvmi_init();
+	WARN_ON(r);
+
 	return 0;
 
 out_unreg:
@@ -4229,6 +4236,7 @@ EXPORT_SYMBOL_GPL(kvm_init);
 
 void kvm_exit(void)
 {
+	kvmi_uninit();
 	debugfs_remove_recursive(kvm_debugfs_dir);
 	misc_deregister(&kvm_dev);
 	kmem_cache_destroy(kvm_vcpu_cache);
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
new file mode 100644
index 000000000000..20638743bd03
--- /dev/null
+++ b/virt/kvm/kvmi.c
@@ -0,0 +1,64 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KVM introspection
+ *
+ * Copyright (C) 2017-2019 Bitdefender S.R.L.
+ *
+ */
+#include <uapi/linux/kvmi.h>
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
+struct kvmi * __must_check kvmi_get(struct kvm *kvm)
+{
+	if (refcount_inc_not_zero(&kvm->kvmi_ref))
+		return kvm->kvmi;
+
+	return NULL;
+}
+
+static void kvmi_destroy(struct kvm *kvm)
+{
+}
+
+static void kvmi_release(struct kvm *kvm)
+{
+	kvmi_destroy(kvm);
+
+	complete(&kvm->kvmi_completed);
+}
+
+/* This function may be called from atomic context and must not sleep */
+void kvmi_put(struct kvm *kvm)
+{
+	if (refcount_dec_and_test(&kvm->kvmi_ref))
+		kvmi_release(kvm);
+}
+
+void kvmi_create_vm(struct kvm *kvm)
+{
+	init_completion(&kvm->kvmi_completed);
+	complete(&kvm->kvmi_completed);
+}
+
+void kvmi_destroy_vm(struct kvm *kvm)
+{
+	struct kvmi *ikvm;
+
+	ikvm = kvmi_get(kvm);
+	if (!ikvm)
+		return;
+
+	kvmi_put(kvm);
+
+	/* wait for introspection resources to be released */
+	wait_for_completion_killable(&kvm->kvmi_completed);
+}
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
new file mode 100644
index 000000000000..ac23ad6fc4df
--- /dev/null
+++ b/virt/kvm/kvmi_int.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVMI_INT_H__
+#define __KVMI_INT_H__
+
+#include <linux/kvm_host.h>
+
+#define IKVM(kvm) ((struct kvmi *)((kvm)->kvmi))
+
+struct kvmi {
+};
+
+#endif
