Return-Path: <kvm+bounces-1547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2962D7E94DF
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 03:32:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5BEECB209BB
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 02:32:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6309156DF;
	Mon, 13 Nov 2023 02:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="oy65yEMw"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3AFC144
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 02:31:58 +0000 (UTC)
Received: from smtp-8fa9.mail.infomaniak.ch (smtp-8fa9.mail.infomaniak.ch [IPv6:2001:1600:3:17::8fa9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EB818C
	for <kvm@vger.kernel.org>; Sun, 12 Nov 2023 18:31:52 -0800 (PST)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
	by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4STCtR28lmzMq1pb;
	Mon, 13 Nov 2023 02:24:31 +0000 (UTC)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4STCtP6n2FzMpnPd;
	Mon, 13 Nov 2023 03:24:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1699842271;
	bh=HO3RcULwQ802eeIPFZkXgFQnmnXm7kA4hgpvD90H0yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oy65yEMwFBZXkzY8/GbCSCY015c7FsKYAOxiyiLLg876EDse7qPjjQ2TawXHbDdpo
	 RqYXUhhMZo8wrcdUoNJcKni3rzSjF0HzYO1MLe/71b+NvJhrkaU1fgwZGfleYIbVsx
	 7CZiYxZUd35oWxWwZ9c+J67orF3hA2vwNYlS1LAw=
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Alexander Graf <graf@amazon.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Forrest Yuan Yu <yuanyu@google.com>,
	James Gowans <jgowans@amazon.com>,
	James Morris <jamorris@linux.microsoft.com>,
	John Andersen <john.s.andersen@intel.com>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Marian Rotariu <marian.c.rotariu@gmail.com>,
	=?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
	=?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
	Thara Gopinath <tgopinath@microsoft.com>,
	Trilok Soni <quic_tsoni@quicinc.com>,
	Wei Liu <wei.liu@kernel.org>,
	Will Deacon <will@kernel.org>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Zahra Tarkhani <ztarkhani@microsoft.com>,
	=?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
	dev@lists.cloudhypervisor.org,
	kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	qemu-devel@nongnu.org,
	virtualization@lists.linux-foundation.org,
	x86@kernel.org,
	xen-devel@lists.xenproject.org
Subject: [RFC PATCH v2 10/19] KVM: x86: Implement per-guest-page permissions
Date: Sun, 12 Nov 2023 21:23:17 -0500
Message-ID: <20231113022326.24388-11-mic@digikod.net>
In-Reply-To: <20231113022326.24388-1-mic@digikod.net>
References: <20231113022326.24388-1-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

Define memory attributes that can be associated with guest physical
pages in KVM. To begin with, define permissions as memory attributes
(READ, WRITE and EXECUTE), and the IMMUTABLE property. In the future,
other attributes could be defined.

Use the memory attribute feature to implement the following functions in
KVM:

- kvm_permissions_set(): Set the permissions for a guest page in the
  memory attribute XArray.

- kvm_permissions_get(): Retrieve the permissions associated with a
  guest page in same XArray.

These functions will be called in a following commit to associate proper
permissions with guest pages instead of RWX for all the pages.

Add 4 new memory attributes, private to the KVM implementation:
- KVM_MEMORY_ATTRIBUTE_HEKI_READ
- KVM_MEMORY_ATTRIBUTE_HEKI_WRITE
- KVM_MEMORY_ATTRIBUTE_HEKI_EXEC
- KVM_MEMORY_ATTRIBUTE_HEKI_IMMUTABLE

Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Cc: Mickaël Salaün <mic@digikod.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Co-developed-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
---

Changes since v1:
* New patch replacing the deprecated page tracking mechanism.
* Add new files: virt/lib/kvm_permissions.c and
  include/linux/kvm_mem_attr.h
* Add new kvm_permissions_get() and kvm_permissions_set() leveraging
  the to-be-upstream memory attributes for KVM.
* Introduce the KVM_MEMORY_ATTRIBUTE_HEKI_* values.
---
 arch/x86/kvm/Kconfig         |   1 +
 arch/x86/kvm/Makefile        |   4 +-
 include/linux/kvm_mem_attr.h |  32 +++++++++++
 include/uapi/linux/kvm.h     |   5 ++
 virt/heki/Kconfig            |   1 +
 virt/lib/kvm_permissions.c   | 104 +++++++++++++++++++++++++++++++++++
 6 files changed, 146 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/kvm_mem_attr.h
 create mode 100644 virt/lib/kvm_permissions.c

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 7a3b52b7e456..ea6d73241632 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -50,6 +50,7 @@ config KVM
 	select HAVE_KVM_PM_NOTIFIER if PM
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select HYPERVISOR_SUPPORTS_HEKI
+	select SPARSEMEM
 	help
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 80e3fe184d17..aac51a5d2cae 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -9,10 +9,12 @@ endif
 
 include $(srctree)/virt/kvm/Makefile.kvm
 
+VIRT_LIB = ../../../virt/lib
+
 kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
 			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o \
-			   mmu/spte.o
+			   mmu/spte.o $(VIRT_LIB)/kvm_permissions.o
 
 ifdef CONFIG_HYPERV
 kvm-y			+= kvm_onhyperv.o
diff --git a/include/linux/kvm_mem_attr.h b/include/linux/kvm_mem_attr.h
new file mode 100644
index 000000000000..0a755025e553
--- /dev/null
+++ b/include/linux/kvm_mem_attr.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * KVM guest page permissions - Definitions.
+ *
+ * Copyright © 2023 Microsoft Corporation.
+ */
+#ifndef __KVM_MEM_ATTR_H__
+#define __KVM_MEM_ATTR_H__
+
+#include <linux/kvm_host.h>
+#include <linux/kvm_types.h>
+
+/* clang-format off */
+
+#define MEM_ATTR_READ			BIT(0)
+#define MEM_ATTR_WRITE			BIT(1)
+#define MEM_ATTR_EXEC			BIT(2)
+#define MEM_ATTR_IMMUTABLE		BIT(3)
+
+#define MEM_ATTR_PROT ( \
+	MEM_ATTR_READ | \
+	MEM_ATTR_WRITE | \
+	MEM_ATTR_EXEC | \
+	MEM_ATTR_IMMUTABLE)
+
+/* clang-format on */
+
+int kvm_permissions_set(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end,
+			unsigned long heki_attr);
+unsigned long kvm_permissions_get(struct kvm *kvm, gfn_t gfn);
+
+#endif /* __KVM_MEM_ATTR_H__ */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2477b4a16126..2b5b90216565 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -2319,6 +2319,11 @@ struct kvm_memory_attributes {
 
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
 
+#define KVM_MEMORY_ATTRIBUTE_HEKI_READ         (1ULL << 4)
+#define KVM_MEMORY_ATTRIBUTE_HEKI_WRITE        (1ULL << 5)
+#define KVM_MEMORY_ATTRIBUTE_HEKI_EXEC         (1ULL << 6)
+#define KVM_MEMORY_ATTRIBUTE_HEKI_IMMUTABLE    (1ULL << 7)
+
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
 
 struct kvm_create_guest_memfd {
diff --git a/virt/heki/Kconfig b/virt/heki/Kconfig
index 5ea75b595667..75a784653e31 100644
--- a/virt/heki/Kconfig
+++ b/virt/heki/Kconfig
@@ -5,6 +5,7 @@
 config HEKI
 	bool "Hypervisor Enforced Kernel Integrity (Heki)"
 	depends on ARCH_SUPPORTS_HEKI && HYPERVISOR_SUPPORTS_HEKI
+	select KVM_GENERIC_MEMORY_ATTRIBUTES
 	help
 	  This feature enhances guest virtual machine security by taking
 	  advantage of security features provided by the hypervisor for guests.
diff --git a/virt/lib/kvm_permissions.c b/virt/lib/kvm_permissions.c
new file mode 100644
index 000000000000..9f4e8027d21c
--- /dev/null
+++ b/virt/lib/kvm_permissions.c
@@ -0,0 +1,104 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KVM guest page permissions - functions.
+ *
+ * Copyright © 2023 Microsoft Corporation.
+ */
+#include <linux/kvm_host.h>
+#include <linux/kvm_mem_attr.h>
+
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) "kvm: heki: " fmt
+
+/* clang-format off */
+
+static unsigned long kvm_default_permissions =
+	MEM_ATTR_READ |
+	MEM_ATTR_WRITE |
+	MEM_ATTR_EXEC;
+
+static unsigned long kvm_memory_attributes_heki =
+	KVM_MEMORY_ATTRIBUTE_HEKI_READ |
+	KVM_MEMORY_ATTRIBUTE_HEKI_WRITE |
+	KVM_MEMORY_ATTRIBUTE_HEKI_EXEC |
+	KVM_MEMORY_ATTRIBUTE_HEKI_IMMUTABLE;
+
+/* clang-format on */
+
+static unsigned long heki_attr_to_kvm_attr(unsigned long heki_attr)
+{
+	unsigned long kvm_attr = 0;
+
+	if (WARN_ON_ONCE((heki_attr | MEM_ATTR_PROT) != MEM_ATTR_PROT))
+		return 0;
+
+	if (heki_attr & MEM_ATTR_READ)
+		kvm_attr |= KVM_MEMORY_ATTRIBUTE_HEKI_READ;
+	if (heki_attr & MEM_ATTR_WRITE)
+		kvm_attr |= KVM_MEMORY_ATTRIBUTE_HEKI_WRITE;
+	if (heki_attr & MEM_ATTR_EXEC)
+		kvm_attr |= KVM_MEMORY_ATTRIBUTE_HEKI_EXEC;
+	if (heki_attr & MEM_ATTR_IMMUTABLE)
+		kvm_attr |= KVM_MEMORY_ATTRIBUTE_HEKI_IMMUTABLE;
+	return kvm_attr;
+}
+
+static unsigned long kvm_attr_to_heki_attr(unsigned long kvm_attr)
+{
+	unsigned long heki_attr = 0;
+
+	if (kvm_attr & KVM_MEMORY_ATTRIBUTE_HEKI_READ)
+		heki_attr |= MEM_ATTR_READ;
+	if (kvm_attr & KVM_MEMORY_ATTRIBUTE_HEKI_WRITE)
+		heki_attr |= MEM_ATTR_WRITE;
+	if (kvm_attr & KVM_MEMORY_ATTRIBUTE_HEKI_EXEC)
+		heki_attr |= MEM_ATTR_EXEC;
+	if (kvm_attr & KVM_MEMORY_ATTRIBUTE_HEKI_IMMUTABLE)
+		heki_attr |= MEM_ATTR_IMMUTABLE;
+	return heki_attr;
+}
+
+unsigned long kvm_permissions_get(struct kvm *kvm, gfn_t gfn)
+{
+	unsigned long kvm_attr = 0;
+
+	/*
+	 * Retrieve the permissions for a guest page. If not present (i.e., no
+	 * attribute), then return default permissions (RWX).  This means
+	 * setting permissions to 0 resets them to RWX. We might want to
+	 * revisit that in a future version.
+	 */
+	kvm_attr = kvm_get_memory_attributes(kvm, gfn);
+	if (kvm_attr)
+		return kvm_attr_to_heki_attr(kvm_attr);
+	else
+		return kvm_default_permissions;
+}
+EXPORT_SYMBOL_GPL(kvm_permissions_get);
+
+int kvm_permissions_set(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end,
+			unsigned long heki_attr)
+{
+	if ((heki_attr | MEM_ATTR_PROT) != MEM_ATTR_PROT)
+		return -EINVAL;
+
+	if (gfn_end <= gfn_start)
+		return -EINVAL;
+
+	if (kvm_range_has_memory_attributes(kvm, gfn_start, gfn_end,
+					    KVM_MEMORY_ATTRIBUTE_HEKI_IMMUTABLE,
+					    false)) {
+		pr_warn_ratelimited(
+			"Guest tried to change immutable permission for GFNs %llx-%llx\n",
+			gfn_start, gfn_end);
+		return -EPERM;
+	}
+
+	return kvm_vm_set_mem_attributes(kvm, gfn_start, gfn_end,
+					 heki_attr_to_kvm_attr(heki_attr),
+					 kvm_memory_attributes_heki);
+}
+EXPORT_SYMBOL_GPL(kvm_permissions_set);
-- 
2.42.1


