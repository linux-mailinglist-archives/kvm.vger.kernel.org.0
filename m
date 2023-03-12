Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A796B647B
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjCLJ6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjCLJ5j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:57:39 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC8A521FF
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615027; x=1710151027;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RA8fIy33RpIDmAXMmuiurXmXddn+qMR4luGDDz2zsmE=;
  b=hJZRlXvanWXyTOH526zCr5bVcKFwwnLEF65xPwPSV53GU5uEX/Blnjbt
   90Sg92dD10s/ijQ99hAK/YvhfzHZH1iwwRdQQ5cdgXptwyL2q9rj7XkNv
   7uyxkwHhudnQh8n3OO7WEBUt4ApfZdVMrnVLGE2yg7lQLlGBAT9kwKZZt
   lz7hPpvFW2okhrwNxT6Ic7EVW/WqCfyuLYFrFDaTUEApyjkzMC/XUN8YS
   M/opK0UNxIInqjZkAdVtm8JmJrgJjnLbagZISw4ml9ZI0X8l+bvDq1X8X
   wp0PshzzzYS381y5bESW5eJmhY2Ah4jLXqU1mmkY8+9RbeIGi0auFywtj
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998073"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998073"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677538"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677538"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:51 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-4 2/4] pkvm: x86: Add pKVM debug support
Date:   Mon, 13 Mar 2023 02:02:42 +0800
Message-Id: <20230312180244.1778422-3-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180244.1778422-1-jason.cj.chen@intel.com>
References: <20230312180244.1778422-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add debug option CONFIG_PKVM_INTEL_DEBUG to allow use printk
in pKVM for debugging purpose.

Enable this option will do:
- keep using host GDT/IDT/segment etc.
- clone host CR3 entries from __page_base_offset
- no __pkvm prefix for pkvm runtime symbols, so to avoid same
  variable name definition for hyp_memory, rename hyp_memory in
  virt/kvm/pkvm/pkvm.c to _hyp_memory

NOTE: this is a tmp solution for debugging before we design a new
solution.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/include/asm/pkvm_image.h         |  2 +-
 arch/x86/include/asm/pkvm_image_vars.h    |  4 +++
 arch/x86/kvm/Kconfig                      |  8 +++++
 arch/x86/kvm/vmx/pkvm/hyp/Makefile        |  8 ++++-
 arch/x86/kvm/vmx/pkvm/hyp/debug.h         |  7 ++++
 arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c | 13 ++++++-
 arch/x86/kvm/vmx/pkvm/hyp/mmu.c           | 21 ++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/mmu.h           |  6 ++++
 arch/x86/kvm/vmx/pkvm/pkvm_host.c         | 42 +++++++++++++++++++++++
 virt/kvm/pkvm/pkvm.c                      |  6 ++--
 10 files changed, 111 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pkvm_image.h b/arch/x86/include/asm/pkvm_image.h
index ed026b740a78..5ae6a53177eb 100644
--- a/arch/x86/include/asm/pkvm_image.h
+++ b/arch/x86/include/asm/pkvm_image.h
@@ -5,7 +5,7 @@
 #ifndef __X86_INTEL_PKVM_IMAGE_H
 #define __X86_INTEL_PKVM_IMAGE_H
 
-#ifdef __PKVM_HYP__
+#if defined(CONFIG_PKVM_INTEL_DEBUG) || defined(__PKVM_HYP__)
 /* No prefix will be added */
 #define PKVM_DECLARE(type, f)	type f
 #define pkvm_sym(sym)		sym
diff --git a/arch/x86/include/asm/pkvm_image_vars.h b/arch/x86/include/asm/pkvm_image_vars.h
index a7823dc9b981..598c60302bac 100644
--- a/arch/x86/include/asm/pkvm_image_vars.h
+++ b/arch/x86/include/asm/pkvm_image_vars.h
@@ -5,6 +5,8 @@
 #ifndef __ASM_x86_PKVM_IMAGE_VARS_H
 #define __ASM_x86_PKVM_IMAGE_VARS_H
 
+#ifndef CONFIG_PKVM_INTEL_DEBUG
+
 #ifdef CONFIG_DYNAMIC_PHYSICAL_MASK
 PKVM_ALIAS(physical_mask);
 #endif
@@ -16,3 +18,5 @@ PKVM_ALIAS(sme_me_mask);
 PKVM_ALIAS(__default_kernel_pte_mask);
 
 #endif
+
+#endif
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 5a8ae5f80849..c2f66d3eef37 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -100,6 +100,14 @@ config PKVM_INTEL
 
 	  If unsure, say N.
 
+config PKVM_INTEL_DEBUG
+        bool "Debug pKVM"
+        depends on PKVM_INTEL
+        help
+          Provides debug support for pKVM.
+
+          If unsure, say N.
+
 config X86_SGX_KVM
 	bool "Software Guard eXtensions (SGX) Virtualization"
 	depends on X86_SGX && KVM_INTEL
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/Makefile b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
index 9a1cb483a55e..a7546e1d0b80 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/Makefile
+++ b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
@@ -9,15 +9,17 @@ ccflags-y += -fno-stack-protector
 ccflags-y += -D__DISABLE_EXPORTS
 ccflags-y += -D__PKVM_HYP__
 
-lib-dir		:= lib
 virt-dir	:= ../../../../../../$(KVM_PKVM)
 
 pkvm-hyp-y	:= vmx_asm.o vmexit.o memory.o early_alloc.o pgtable.o mmu.o pkvm.o \
 		   init_finalise.o ept.o
 
+ifndef CONFIG_PKVM_INTEL_DEBUG
+lib-dir		:= lib
 pkvm-hyp-y	+= $(lib-dir)/memset_64.o
 pkvm-hyp-$(CONFIG_RETPOLINE)	+= $(lib-dir)/retpoline.o
 pkvm-hyp-$(CONFIG_DEBUG_LIST)	+= $(lib-dir)/list_debug.o
+endif
 pkvm-hyp-y	+= $(virt-dir)/page_alloc.o
 
 pkvm-obj 	:= $(patsubst %.o,%.pkvm.o,$(pkvm-hyp-y))
@@ -40,7 +42,11 @@ $(obj)/pkvm.o: $(obj)/pkvm.tmp.o FORCE
 	$(call if_changed,pkvmcopy)
 
 quiet_cmd_pkvmcopy = PKVMPCOPY $@
+ifdef CONFIG_PKVM_INTEL_DEBUG
+      cmd_pkvmcopy = $(OBJCOPY) --prefix-symbols= $< $@
+else
       cmd_pkvmcopy = $(OBJCOPY) --prefix-symbols=__pkvm_ --remove-section=.retpoline_sites --remove-section=.return_sites $< $@
+endif
 
 # Remove ftrace, Shadow Call Stack, and CFI CFLAGS.
 # This is equivalent to the 'notrace', '__noscs', and '__nocfi' annotations.
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/debug.h b/arch/x86/kvm/vmx/pkvm/hyp/debug.h
index 97f633ca0bac..f8f7d00dfb88 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/debug.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/debug.h
@@ -6,8 +6,15 @@
 #ifndef _PKVM_DEBUG_H_
 #define _PKVM_DEBUG_H_
 
+#ifdef CONFIG_PKVM_INTEL_DEBUG
+#include <linux/printk.h>
+#define pkvm_dbg(f, x...) pr_debug(f, ## x)
+#define pkvm_info(f, x...) pr_info(f, ## x)
+#define pkvm_err(f, x...) pr_err(f, ## x)
+#else
 #define pkvm_dbg(x...)
 #define pkvm_info(x...)
 #define pkvm_err(x...)
+#endif
 
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c b/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
index e0c74d5ac2fa..8c585a73237a 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
@@ -100,14 +100,24 @@ static int create_mmu_mapping(const struct pkvm_section sections[],
 				 int section_sz)
 {
 	unsigned long nr_pages = pkvm_mmu_pgtable_pages();
+	int ret;
+#ifndef CONFIG_PKVM_INTEL_DEBUG
 	struct memblock_region *reg;
-	int ret, i;
+	int i;
+#endif
 
 	ret = pkvm_early_mmu_init(&pkvm_hyp->mmu_cap,
 			pkvm_mmu_pgt_base, nr_pages);
 	if (ret)
 		return ret;
 
+#ifdef CONFIG_PKVM_INTEL_DEBUG
+	/*
+	 * clone host CR3 page mapping from __page_base_offset, it covers both
+	 * direct mapping and symbol mapping for pkvm (same mapping as kernel)
+	 */
+	pkvm_mmu_clone_host(pkvm_hyp->mmu_cap.level, __page_base_offset);
+#else
 	/*
 	 * Create mapping for the memory in memblocks.
 	 * This will include all the memory host kernel can see, as well
@@ -135,6 +145,7 @@ static int create_mmu_mapping(const struct pkvm_section sections[],
 		if (ret)
 			return ret;
 	}
+#endif
 
 	ret = pkvm_back_vmemmap(__pkvm_pa(pkvm_vmemmap_base));
 	if (ret)
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/mmu.c b/arch/x86/kvm/vmx/pkvm/hyp/mmu.c
index 7684d16dd2c9..b32ca706fa4b 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/mmu.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/mmu.c
@@ -169,7 +169,15 @@ static int fix_pgtable_refcnt(void)
 	 * Calculate the max address space, then walk the [0, size) address
 	 * range to fixup refcount of every used page.
 	 */
+#ifdef CONFIG_PKVM_INTEL_DEBUG
+	/*
+	 * only fix vmmemap range for debug mode, now for 64T memory,
+	 * could be extended if physical memory is bigger than 64T
+	 */
+	size = (SZ_64T / PAGE_SIZE) * sizeof(struct hyp_page);
+#else
 	size = pgt_ops->pgt_level_to_size(hyp_mmu.level + 1);
+#endif
 
 	return pgtable_walk(&hyp_mmu, 0, size, &walker);
 }
@@ -228,3 +236,16 @@ int pkvm_later_mmu_init(void *mmu_pool_base, unsigned long mmu_pool_pages)
 	 */
 	return fix_pgtable_refcnt();
 }
+
+#ifdef CONFIG_PKVM_INTEL_DEBUG
+void pkvm_mmu_clone_host(int level, unsigned long start_vaddr)
+{
+	int i = mmu_entry_to_index(start_vaddr, level);
+	u64 *ptep = __va(hyp_mmu.root_pa);
+	u64 *host_cr3 = __va(__read_cr3() & PAGE_MASK);
+
+	for (; i < PTRS_PER_PTE; i++)
+		ptep[i] = host_cr3[i];
+
+}
+#endif
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/mmu.h b/arch/x86/kvm/vmx/pkvm/hyp/mmu.h
index 6b678ae94b31..218e3d4ef92c 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/mmu.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/mmu.h
@@ -16,4 +16,10 @@ int pkvm_early_mmu_init(struct pkvm_pgtable_cap *cap,
 
 int pkvm_later_mmu_init(void *mmu_pool_base, unsigned long mmu_pool_pages);
 
+#ifdef CONFIG_PKVM_INTEL_DEBUG
+void pkvm_mmu_clone_host(int level, unsigned long start_vaddr);
+#else
+static inline void pkvm_mmu_clone_host(int level, unsigned long start_vaddr) {}
+#endif
+
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index 4120f9ef2a7e..c7768ee22e57 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -243,11 +243,52 @@ static __init void init_guest_state_area(struct pkvm_host_vcpu *vcpu, int cpu)
 static __init void _init_host_state_area(struct pkvm_pcpu *pcpu)
 {
 	unsigned long a;
+#ifdef CONFIG_PKVM_INTEL_DEBUG
+	u32 high, low;
+	struct desc_ptr dt;
+	u16 selector;
+	int cpu = raw_smp_processor_id();
+#endif
 
 	vmcs_writel(HOST_CR0, read_cr0() & ~X86_CR0_TS);
 	vmcs_writel(HOST_CR3, pcpu->cr3);
 	vmcs_writel(HOST_CR4, native_read_cr4());
 
+#ifdef CONFIG_PKVM_INTEL_DEBUG
+	savesegment(cs, selector);
+	vmcs_write16(HOST_CS_SELECTOR, selector);
+	savesegment(ss, selector);
+	vmcs_write16(HOST_SS_SELECTOR, selector);
+	savesegment(ds, selector);
+	vmcs_write16(HOST_DS_SELECTOR, selector);
+	savesegment(es, selector);
+	vmcs_write16(HOST_ES_SELECTOR, selector);
+	savesegment(fs, selector);
+	vmcs_write16(HOST_FS_SELECTOR, selector);
+	rdmsrl(MSR_FS_BASE, a);
+	vmcs_writel(HOST_FS_BASE, a);
+	savesegment(gs, selector);
+	vmcs_write16(HOST_GS_SELECTOR, selector);
+	rdmsrl(MSR_GS_BASE, a);
+	vmcs_writel(HOST_GS_BASE, a);
+
+	vmcs_write16(HOST_TR_SELECTOR, GDT_ENTRY_TSS*8);
+	vmcs_writel(HOST_TR_BASE, (unsigned long)&get_cpu_entry_area(cpu)->tss.x86_tss);
+
+	native_store_gdt(&dt);
+	vmcs_writel(HOST_GDTR_BASE, dt.address);
+	store_idt(&dt);
+	vmcs_writel(HOST_IDTR_BASE, dt.address);
+
+	rdmsr(MSR_IA32_SYSENTER_CS, low, high);
+	vmcs_write32(HOST_IA32_SYSENTER_CS, low);
+
+	rdmsrl(MSR_IA32_SYSENTER_ESP, a);
+	vmcs_writel(HOST_IA32_SYSENTER_ESP, a);
+
+	rdmsrl(MSR_IA32_SYSENTER_EIP, a);
+	vmcs_writel(HOST_IA32_SYSENTER_EIP, a);
+#else
 	vmcs_write16(HOST_CS_SELECTOR, __KERNEL_CS);
 	vmcs_write16(HOST_SS_SELECTOR, __KERNEL_DS);
 	vmcs_write16(HOST_DS_SELECTOR, __KERNEL_DS);
@@ -261,6 +302,7 @@ static __init void _init_host_state_area(struct pkvm_pcpu *pcpu)
 	vmcs_writel(HOST_TR_BASE, (unsigned long)&pcpu->tss);
 	vmcs_writel(HOST_GDTR_BASE, (unsigned long)(&pcpu->gdt_page));
 	vmcs_writel(HOST_IDTR_BASE, (unsigned long)(&pcpu->idt_page));
+#endif
 
 	/* MSR area */
 	rdmsrl(MSR_EFER, a);
diff --git a/virt/kvm/pkvm/pkvm.c b/virt/kvm/pkvm/pkvm.c
index 8a20a662b917..cdc3a8a2fee9 100644
--- a/virt/kvm/pkvm/pkvm.c
+++ b/virt/kvm/pkvm/pkvm.c
@@ -10,7 +10,7 @@
 
 #include <asm/kvm_pkvm.h>
 
-static struct memblock_region *hyp_memory = pkvm_sym(hyp_memory);
+static struct memblock_region *_hyp_memory = pkvm_sym(hyp_memory);
 static unsigned int *hyp_memblock_nr_ptr = &pkvm_sym(hyp_memblock_nr);
 
 phys_addr_t hyp_mem_base;
@@ -26,7 +26,7 @@ static int cmp_hyp_memblock(const void *p1, const void *p2)
 
 static void __init sort_memblock_regions(void)
 {
-	sort(hyp_memory,
+	sort(_hyp_memory,
 	     *hyp_memblock_nr_ptr,
 	     sizeof(struct memblock_region),
 	     cmp_hyp_memblock,
@@ -41,7 +41,7 @@ static int __init register_memblock_regions(void)
 		if (*hyp_memblock_nr_ptr >= HYP_MEMBLOCK_REGIONS)
 			return -ENOMEM;
 
-		hyp_memory[*hyp_memblock_nr_ptr] = *reg;
+		_hyp_memory[*hyp_memblock_nr_ptr] = *reg;
 		(*hyp_memblock_nr_ptr)++;
 	}
 	sort_memblock_regions();
-- 
2.25.1

