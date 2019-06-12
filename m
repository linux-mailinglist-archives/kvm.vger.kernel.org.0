Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0126242D14
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 19:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438392AbfFLRKp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 13:10:45 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:59897 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438319AbfFLRKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 13:10:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1560359441; x=1591895441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RzVt4uakvvgdusQzsQlIX4JlUcBfNHHcF9nlPs/PUMU=;
  b=NFsnPuRLoz2rQzSUcxDgw4QFiVucTe3Y0rUncLwwFvG2wRJcxSpMleav
   2PQQKpXeaHT8o/maIIwze2tVXVnr8DHXf7HIV/5V3Qecu7IuUdF6wqLjy
   47gD7WE6pQlEYGQVO6bkPC3ftXeSG8A1EVxJv/uv4k+aKVBIg3BX9zs1W
   8=;
X-IronPort-AV: E=Sophos;i="5.62,366,1554768000"; 
   d="scan'208";a="810038903"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 12 Jun 2019 17:10:39 +0000
Received: from ua08cfdeba6fe59dc80a8.ant.amazon.com (pdx2-ws-svc-lb17-vlan3.amazon.com [10.247.140.70])
        by email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com (Postfix) with ESMTPS id E7643A24B9;
        Wed, 12 Jun 2019 17:10:38 +0000 (UTC)
Received: from ua08cfdeba6fe59dc80a8.ant.amazon.com (ua08cfdeba6fe59dc80a8.ant.amazon.com [127.0.0.1])
        by ua08cfdeba6fe59dc80a8.ant.amazon.com (8.15.2/8.15.2/Debian-3) with ESMTP id x5CHAa4e017540;
        Wed, 12 Jun 2019 19:10:36 +0200
Received: (from mhillenb@localhost)
        by ua08cfdeba6fe59dc80a8.ant.amazon.com (8.15.2/8.15.2/Submit) id x5CHAa82017538;
        Wed, 12 Jun 2019 19:10:36 +0200
From:   Marius Hillenbrand <mhillenb@amazon.de>
To:     kvm@vger.kernel.org
Cc:     Marius Hillenbrand <mhillenb@amazon.de>,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        linux-mm@kvack.org, Alexander Graf <graf@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Julian Stecklina <js@alien8.de>
Subject: [RFC 02/10] x86/speculation, mm: add process local virtual memory region
Date:   Wed, 12 Jun 2019 19:08:28 +0200
Message-Id: <20190612170834.14855-3-mhillenb@amazon.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190612170834.14855-1-mhillenb@amazon.de>
References: <20190612170834.14855-1-mhillenb@amazon.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Linux kernel has a global address space that is the same for any
kernel code. This address space becomes a liability in a world with
processor information leak vulnerabilities, such as L1TF. With the right
cache load gadget, an attacker-controlled hyperthread pair can leak
arbitrary data via L1TF. Disabling hyperthreading is one recommended
mitigation, but it comes with a large performance hit for a wide range
of workloads.

An alternative mitigation is to not make certain data in the kernel
globally visible, but only when the kernel executes in the context of
the process where this data belongs to.

This patch introduces a region for process-local memory into the
kernel's virtual address space. It has a length of 64 GiB (to give more
than enough space while leaving enough room for KASLR) and will always
occupy a pgd entry that is exclusive for process-local mappings (other
pgds may point to shared page tables for the kernel space).

Signed-off-by: Marius Hillenbrand <mhillenb@amazon.de>
Inspired-by: Julian Stecklina <js@alien8.de> (while jsteckli@amazon.de)
Cc: Alexander Graf <graf@amazon.de>
Cc: David Woodhouse <dwmw@amazon.co.uk>
---
 Documentation/x86/x86_64/mm.txt         | 11 +++++--
 arch/x86/Kconfig                        |  1 +
 arch/x86/include/asm/page_64.h          |  4 +++
 arch/x86/include/asm/pgtable_64_types.h | 12 ++++++++
 arch/x86/kernel/head64.c                |  8 +++++
 arch/x86/mm/dump_pagetables.c           |  9 ++++++
 arch/x86/mm/fault.c                     | 19 ++++++++++++
 arch/x86/mm/kaslr.c                     | 41 +++++++++++++++++++++++++
 security/Kconfig                        | 18 +++++++++++
 9 files changed, 121 insertions(+), 2 deletions(-)

diff --git a/Documentation/x86/x86_64/mm.txt b/Documentation/x86/x86_64/mm.txt
index 804f9426ed17..476519759cdc 100644
--- a/Documentation/x86/x86_64/mm.txt
+++ b/Documentation/x86/x86_64/mm.txt
@@ -40,7 +40,10 @@ ____________________________________________________________|___________________
  ffffc90000000000 |  -55    TB | ffffe8ffffffffff |   32 TB | vmalloc/ioremap space (vmalloc_base)
  ffffe90000000000 |  -23    TB | ffffe9ffffffffff |    1 TB | ... unused hole
  ffffea0000000000 |  -22    TB | ffffeaffffffffff |    1 TB | virtual memory map (vmemmap_base)
- ffffeb0000000000 |  -21    TB | ffffebffffffffff |    1 TB | ... unused hole
+ ffffeb0000000000 |  -21    TB | ffffeb7fffffffff |  512 GB | ... unused hole
+ ffffeb8000000000 |  -20.5  TB | ffffebffffffffff |  512 GB | process-local kernel memory (layout shared but mappings
+                  |            |                  |         | exclusive to processes, needs an exclusive entry in the
+                  |            |                  |         | top-level page table)
  ffffec0000000000 |  -20    TB | fffffbffffffffff |   16 TB | KASAN shadow memory
 __________________|____________|__________________|_________|____________________________________________________________
                                                             |
@@ -98,7 +101,11 @@ ____________________________________________________________|___________________
  ffa0000000000000 |  -24    PB | ffd1ffffffffffff | 12.5 PB | vmalloc/ioremap space (vmalloc_base)
  ffd2000000000000 |  -11.5  PB | ffd3ffffffffffff |  0.5 PB | ... unused hole
  ffd4000000000000 |  -11    PB | ffd5ffffffffffff |  0.5 PB | virtual memory map (vmemmap_base)
- ffd6000000000000 |  -10.5  PB | ffdeffffffffffff | 2.25 PB | ... unused hole
+ ffd6000000000000 |  -10.5  PB | ffd7ffffffffffff |  0.5 PB | ... unused hole
+ ffd8000000000000 |  -10    PB | ffd8ffffffffffff |  256 TB | process-local kernel memory (layout shared but mappings
+                  |            |                  |         | exclusive to processes, needs an exclusive entry in the
+                  |            |                  |         | top-level page table)
+ ffd9000000000000 |   -9.75 PB | ffdeffffffffffff |  1.5 PB | ... unused hole
  ffdf000000000000 |   -8.25 PB | fffffdffffffffff |   ~8 PB | KASAN shadow memory
 __________________|____________|__________________|_________|____________________________________________________________
                                                             |
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3b8cc39ae52d..9924d542d44a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -32,6 +32,7 @@ config X86_64
 	select SWIOTLB
 	select X86_DEV_DMA_OPS
 	select ARCH_HAS_SYSCALL_WRAPPER
+	select ARCH_SUPPORTS_PROCLOCAL
 
 #
 # Arch settings
diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 939b1cff4a7b..e6f0d76de849 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -15,6 +15,10 @@ extern unsigned long page_offset_base;
 extern unsigned long vmalloc_base;
 extern unsigned long vmemmap_base;
 
+#ifdef CONFIG_PROCLOCAL
+extern unsigned long proclocal_base;
+#endif
+
 static inline unsigned long __phys_addr_nodebug(unsigned long x)
 {
 	unsigned long y = x - __START_KERNEL_map;
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 14cd41b989d6..cb1b789a55c2 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -141,6 +141,18 @@ extern unsigned int ptrs_per_p4d;
 
 #define VMALLOC_END		(VMALLOC_START + (VMALLOC_SIZE_TB << 40) - 1)
 
+#ifdef CONFIG_PROCLOCAL
+# define __PROCLOCAL_BASE_L4	0xffffeb8000000000UL
+# define __PROCLOCAL_BASE_L5	0xffd8000000000000UL
+# define PROCLOCAL_SIZE	(64UL * 1024 * 1024 * 1024)
+
+# ifdef CONFIG_DYNAMIC_MEMORY_LAYOUT
+#  define PROCLOCAL_START	proclocal_base
+# else /* CONFIG_DYNAMIC_MEMORY_LAYOUT */
+#  define PROCLOCAL_START	__PROCLOCAL_BASE_L4
+# endif /* CONFIG_DYNAMIC_MEMORY_LAYOUT */
+#endif /* CONFIG_PROCLOCAL */
+
 #define MODULES_VADDR		(__START_KERNEL_map + KERNEL_IMAGE_SIZE)
 /* The module sections ends with the start of the fixmap */
 #define MODULES_END		_AC(0xfffffffff4000000, UL)
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 509de5a2a122..490b5255aad3 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -59,6 +59,10 @@ unsigned long vmalloc_base __ro_after_init = __VMALLOC_BASE_L4;
 EXPORT_SYMBOL(vmalloc_base);
 unsigned long vmemmap_base __ro_after_init = __VMEMMAP_BASE_L4;
 EXPORT_SYMBOL(vmemmap_base);
+#ifdef CONFIG_PROCLOCAL
+unsigned long proclocal_base __ro_after_init = __PROCLOCAL_BASE_L4;
+EXPORT_SYMBOL(proclocal_base);
+#endif
 #endif
 
 #define __head	__section(.head.text)
@@ -94,6 +98,10 @@ static bool __head check_la57_support(unsigned long physaddr)
 	*fixup_long(&page_offset_base, physaddr) = __PAGE_OFFSET_BASE_L5;
 	*fixup_long(&vmalloc_base, physaddr) = __VMALLOC_BASE_L5;
 	*fixup_long(&vmemmap_base, physaddr) = __VMEMMAP_BASE_L5;
+#ifdef CONFIG_PROCLOCAL
+#warning "Process-local memory with 5-level page tables is compile-tested only."
+	*fixup_long(&proclocal_base, physaddr) = __PROCLOCAL_BASE_L5;
+#endif
 
 	return true;
 }
diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index abcb8d00b014..88fa2da94cfe 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -61,6 +61,9 @@ enum address_markers_idx {
 	LOW_KERNEL_NR,
 	VMALLOC_START_NR,
 	VMEMMAP_START_NR,
+#ifdef CONFIG_PROCLOCAL
+	PROCLOCAL_START_NR,
+#endif
 #ifdef CONFIG_KASAN
 	KASAN_SHADOW_START_NR,
 	KASAN_SHADOW_END_NR,
@@ -85,6 +88,9 @@ static struct addr_marker address_markers[] = {
 	[LOW_KERNEL_NR]		= { 0UL,		"Low Kernel Mapping" },
 	[VMALLOC_START_NR]	= { 0UL,		"vmalloc() Area" },
 	[VMEMMAP_START_NR]	= { 0UL,		"Vmemmap" },
+#ifdef CONFIG_PROCLOCAL
+	[PROCLOCAL_START_NR]    = { 0UL,                "Process local" },
+#endif
 #ifdef CONFIG_KASAN
 	/*
 	 * These fields get initialized with the (dynamic)
@@ -622,6 +628,9 @@ static int __init pt_dump_init(void)
 	address_markers[KASAN_SHADOW_START_NR].start_address = KASAN_SHADOW_START;
 	address_markers[KASAN_SHADOW_END_NR].start_address = KASAN_SHADOW_END;
 #endif
+#ifdef CONFIG_PROCLOCAL
+	address_markers[PROCLOCAL_START_NR].start_address = PROCLOCAL_START;
+#endif
 #endif
 #ifdef CONFIG_X86_32
 	address_markers[VMALLOC_START_NR].start_address = VMALLOC_START;
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index ba51652fbd33..befea89c5d6f 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1171,6 +1171,15 @@ static inline bool smap_violation(int error_code, struct pt_regs *regs)
 	return true;
 }
 
+static int fault_in_process_local(unsigned long address)
+{
+#ifdef CONFIG_PROCLOCAL
+	return address >= PROCLOCAL_START && address < (PROCLOCAL_START + PROCLOCAL_SIZE);
+#else
+	return false;
+#endif
+}
+
 /*
  * Called for all faults where 'address' is part of the kernel address
  * space.  Might get called for faults that originate from *code* that
@@ -1214,6 +1223,16 @@ do_kern_addr_fault(struct pt_regs *regs, unsigned long hw_error_code,
 	if (spurious_kernel_fault(hw_error_code, address))
 		return;
 
+	/*
+	 * Faults in process-local memory may be caused by process-local
+	 * addresses leaking into other contexts.
+	 * tbd: warn and handle gracefully.
+	 */
+	if (unlikely(fault_in_process_local(address))) {
+		pr_err("page fault in PROCLOCAL at %lx", address);
+		force_sig_fault(SIGSEGV, SEGV_MAPERR, (void __user *)address, current);
+	}
+
 	/* kprobes don't want to hook the spurious faults: */
 	if (kprobes_fault(regs))
 		return;
diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
index c455f1ffba29..395d8868aeb8 100644
--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -45,6 +45,9 @@ enum {
 	PHYSMAP,
 	VMALLOC,
 	VMMEMMAP,
+#ifdef CONFIG_PROCLOCAL
+	PROCLOCAL,
+#endif
 };
 
 /*
@@ -59,6 +62,9 @@ static __initdata struct kaslr_memory_region {
 	[PHYSMAP] = { &page_offset_base, 0 },
 	[VMALLOC] = { &vmalloc_base, 0 },
 	[VMMEMMAP] = { &vmemmap_base, 1 },
+#ifdef CONFIG_PROCLOCAL
+	[PROCLOCAL] = { &proclocal_base, 0 },
+#endif
 };
 
 /* Get size in bytes used by the memory region */
@@ -76,6 +82,26 @@ static inline bool kaslr_memory_enabled(void)
 	return kaslr_enabled() && !IS_ENABLED(CONFIG_KASAN);
 }
 
+#ifdef CONFIG_PROCLOCAL
+/*
+ * The process-local memory area must use an exclusive pgd entry. The area is
+ * allocated as 2x PGDIR_SIZE such that it contains at least one exclusive pgd
+ * entry. Shift the base address into that exclusive pgd. Keep the offset from
+ * randomization but make sure the whole actual process-local memory region fits
+ * into the pgd.
+ */
+static void adjust_proclocal_base(void)
+{
+	unsigned long size_tb = kaslr_regions[PROCLOCAL].size_tb;
+	proclocal_base += ((size_tb << TB_SHIFT) / 2);
+	if ((proclocal_base % PGDIR_SIZE) > (PGDIR_SIZE - PROCLOCAL_SIZE))
+		proclocal_base -= PROCLOCAL_SIZE;
+
+	BUILD_BUG_ON(2 * PROCLOCAL_SIZE >= PGDIR_SIZE);
+	BUG_ON(((proclocal_base % PGDIR_SIZE) + PROCLOCAL_SIZE) > PGDIR_SIZE);
+}
+#endif
+
 /* Initialize base and padding for each memory region randomized with KASLR */
 void __init kernel_randomize_memory(void)
 {
@@ -103,6 +129,17 @@ void __init kernel_randomize_memory(void)
 	kaslr_regions[PHYSMAP].size_tb = 1 << (__PHYSICAL_MASK_SHIFT - TB_SHIFT);
 	kaslr_regions[VMALLOC].size_tb = VMALLOC_SIZE_TB;
 
+#ifdef CONFIG_PROCLOCAL
+	/*
+	 * Note that the process-local memory area must use a non-overlapping
+	 * pgd. Thus, round up the size to 2 pgd entries and adjust the base
+	 * address into the dedicated pgd below. With 4-level page tables, that
+	 * keeps the size at the minium of 1 TiB used by the kernel.
+	 */
+	kaslr_regions[PROCLOCAL].size_tb = round_up(round_up(PROCLOCAL_SIZE, 2ULL<<PGDIR_SHIFT),
+						    1ULL<<TB_SHIFT) / (1ULL<<TB_SHIFT);
+#endif
+
 	/*
 	 * Update Physical memory mapping to available and
 	 * add padding if needed (especially for memory hotplug support).
@@ -149,6 +186,10 @@ void __init kernel_randomize_memory(void)
 			vaddr = round_up(vaddr + 1, PUD_SIZE);
 		remain_entropy -= entropy;
 	}
+
+#ifdef CONFIG_PROCLOCAL
+	adjust_proclocal_base();
+#endif
 }
 
 static void __meminit init_trampoline_pud(void)
diff --git a/security/Kconfig b/security/Kconfig
index c7c581bac963..714808cf6604 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -35,6 +35,24 @@ config XPFO_DEBUG
 
 	 If in doubt, say "N".
 
+config ARCH_SUPPORTS_PROCLOCAL
+	bool
+	default n
+
+config PROCLOCAL
+	bool "Support process-local allocations in the kernel"
+	depends on ARCH_SUPPORTS_PROCLOCAL
+	select GENERIC_ALLOCATOR
+	default n
+	help
+	  This feature allows subsystems in the kernel to allocate memory that
+	  is only visible in the context of a specific process. This hardens the
+	  kernel against information leak vulnerabilities.
+
+	  There is a slight performance impact when this option is enabled.
+
+	  If you are unsure how to answer this question, answer N.
+
 config SECURITY_DMESG_RESTRICT
 	bool "Restrict unprivileged access to the kernel syslog"
 	default n
-- 
2.21.0

