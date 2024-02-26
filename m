Return-Path: <kvm+bounces-9921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B642486793D
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:58:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D64391C290F7
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:58:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B610A12F382;
	Mon, 26 Feb 2024 14:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C2Jo9S4P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752C712AAC8;
	Mon, 26 Feb 2024 14:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958313; cv=none; b=GrRW3lwLVW2lk/lcCeqsZCFUS/g3TunBjlJCNp/70ZwNbZ4ukK23DndQua6HK86O5fOseFtO6+PcD0wDc6S1ECyCLQ+Dotc2AleDv8OL18PPHpXAsRJoRhFF+14vfFaA+82n8a4v15TxpxBINxEQrBzH0+X1LEsekZ19d1CNODo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958313; c=relaxed/simple;
	bh=RuI+mIXFCnHTy2O7ADohtxpMA+EmOljcf64cLsOTZSQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=We+evRHZIgnzuDUm0vuV6wLp8qjHW5tZJyOPJN8q1giKWYXQuonhhVsvc+fGVC3oxLDpjvZdnUyX61D+GkiIZXH4NeEgKhklhsRj/XPRfZQVufTvJlIBy50/gmF7qQM+jtxyxjse+QDBbZKNdhGzUwLiEStziwwXCkYi59cIdn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C2Jo9S4P; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-5d4d15ec7c5so2457731a12.1;
        Mon, 26 Feb 2024 06:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958310; x=1709563110; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4nV4uIyJE1TrPKasp5oCdCMedKEyqDIAzttVGmNtNdU=;
        b=C2Jo9S4PWO0hcbh3EZ6O88rV5fPrwLWx5dMjRmwlmEbGg4YJrH4Ywr7O557B1nkg+v
         QRuZQMLQFKmIQ4Nnm0SzTjRSiBoPBd2YupctGLn8UXXZvSWZ9i4sdQwU3rcfVv3pRtU0
         FFOVcUI0TWhLIX7ip57vxpGr4oo6aLG2oLYCDkQN6roz2YyEsePSq3Ov/AYfV0weZxLg
         t61wI55LieyTWd15boX8W18X/VCxLGA6ulFl76T4H+FyBUoC6zz5+KL8N5l/WIhHRgiK
         zhhRfXAfAJwsLrgGUNbqCRulJyc54oodRiVOUCT2cqr0dAYbVSV9RzpGXJxBTlGobubh
         t+CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958310; x=1709563110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4nV4uIyJE1TrPKasp5oCdCMedKEyqDIAzttVGmNtNdU=;
        b=rp2HFagYjPJDkP4dYfbsqGx1vMPqxhbHLjzlHoZOp1ovRW7Ej358CWrB4W5iaAkQcm
         kLTpBb9gdA1ZuUJhJ7sAqRszxWP8HRkIG04S6xpKvOgX1AkGqCzalwvCj/U+qHQVC4uc
         veK4LH/BJk59/GpbyK2hKAGMILGPlIkgpVa683lefq/0MTymLUmZ4nzuyECPdi2CiN1g
         GU/7ecKpGkd2d0/NYcLZqYOGde0lRuz1umxVA8pApUs9K6YdDWNuQAvX0GZbGqrm8M6a
         jiBZ+LZhoNH0i/YnIhD2JVuoWttx7SjBAu2uWEjw1PQKcXI0MyNaRawUzXMLLBqoVmMZ
         iDnA==
X-Forwarded-Encrypted: i=1; AJvYcCXnV60xfyPX9Y1aJFp+qtib5CP1xgXxmvkfAGk8oJ01EcQfK0vCCC/w2wK5hOIg2+jBB6BYTxSpcVEEkoHGedaxSeBv
X-Gm-Message-State: AOJu0YyLgIfk9K3jrQuDgqlNprny21sQ98xriW/aQ/hFgb5VmUWLmga9
	iNAMISpJ5Lh9e5BZYbXH2DfnUExOE4zsZ8WJSNMb771uEZz3LKaQr4SvOg6/
X-Google-Smtp-Source: AGHT+IHFApyYJLTpQNsPa0O7HI/vb7qEUTPGVhU45NHrc+zPxscyqHazTshcu7JFv6FdR+LjDyPZrw==
X-Received: by 2002:a05:6a20:d486:b0:1a0:ee99:5d07 with SMTP id im6-20020a056a20d48600b001a0ee995d07mr7764444pzb.62.1708958309874;
        Mon, 26 Feb 2024 06:38:29 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id e6-20020a63ee06000000b005dc491ccdcesm4053747pgi.14.2024.02.26.06.38.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:38:29 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>
Subject: [RFC PATCH 58/73] x86/pvm: Relocate kernel address space layout
Date: Mon, 26 Feb 2024 22:36:15 +0800
Message-Id: <20240226143630.33643-59-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

Relocate the kernel address space layout to a specific range, which is
similar to KASLR. Since there is not enough room for KASAN, KASAN is not
supported for PVM guest.

Suggested-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/Kconfig                  |  3 +-
 arch/x86/include/asm/pvm_para.h   |  6 +++
 arch/x86/kernel/head64_identity.c |  6 +++
 arch/x86/kernel/pvm.c             | 64 +++++++++++++++++++++++++++++++
 arch/x86/mm/kaslr.c               |  4 ++
 5 files changed, 82 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1b4bea3db53d..ded687cc23ad 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -853,7 +853,8 @@ config KVM_GUEST
 
 config PVM_GUEST
 	bool "PVM Guest support"
-	depends on X86_64 && KVM_GUEST && X86_PIE
+	depends on X86_64 && KVM_GUEST && X86_PIE && !KASAN
+	select RANDOMIZE_MEMORY
 	select RELOCATABLE_UNCOMPRESSED_KERNEL
 	default n
 	help
diff --git a/arch/x86/include/asm/pvm_para.h b/arch/x86/include/asm/pvm_para.h
index efd7afdf9be9..ff0bf0fe7dc4 100644
--- a/arch/x86/include/asm/pvm_para.h
+++ b/arch/x86/include/asm/pvm_para.h
@@ -10,6 +10,7 @@
 #include <uapi/asm/kvm_para.h>
 
 void __init pvm_early_setup(void);
+bool __init pvm_kernel_layout_relocate(void);
 
 static inline void pvm_cpuid(unsigned int *eax, unsigned int *ebx,
 			     unsigned int *ecx, unsigned int *edx)
@@ -64,6 +65,11 @@ static inline bool pvm_detect(void)
 static inline void pvm_early_setup(void)
 {
 }
+
+static inline bool pvm_kernel_layout_relocate(void)
+{
+	return false;
+}
 #endif /* CONFIG_PVM_GUEST */
 
 #endif /* _ASM_X86_PVM_PARA_H */
diff --git a/arch/x86/kernel/head64_identity.c b/arch/x86/kernel/head64_identity.c
index f69f9904003c..467fe493c9ba 100644
--- a/arch/x86/kernel/head64_identity.c
+++ b/arch/x86/kernel/head64_identity.c
@@ -396,6 +396,12 @@ static void __head detect_pvm_range(void)
 	pml4_index_end = (msr_val >> 16) & 0x1ff;
 	pvm_range_start = (0x1fffe00 | pml4_index_start) * P4D_SIZE;
 	pvm_range_end = (0x1fffe00 | pml4_index_end) * P4D_SIZE;
+
+	/*
+	 * early page fault would map page into directing mapping area,
+	 * so we should modify 'page_offset_base' here early.
+	 */
+	page_offset_base = pvm_range_start;
 }
 
 void __head pvm_relocate_kernel(unsigned long physbase)
diff --git a/arch/x86/kernel/pvm.c b/arch/x86/kernel/pvm.c
index fc82c71b305b..9cdfbaa15dbb 100644
--- a/arch/x86/kernel/pvm.c
+++ b/arch/x86/kernel/pvm.c
@@ -10,7 +10,10 @@
  */
 #define pr_fmt(fmt) "pvm-guest: " fmt
 
+#include <linux/mm_types.h>
+
 #include <asm/cpufeature.h>
+#include <asm/cpu_entry_area.h>
 #include <asm/pvm_para.h>
 
 unsigned long pvm_range_start __initdata;
@@ -23,3 +26,64 @@ void __init pvm_early_setup(void)
 
 	setup_force_cpu_cap(X86_FEATURE_KVM_PVM_GUEST);
 }
+
+#define TB_SHIFT	40
+#define HOLE_SIZE	(1UL << 39)
+
+#define PVM_DIRECT_MAPPING_SIZE		(8UL << TB_SHIFT)
+#define PVM_VMALLOC_SIZE		(5UL << TB_SHIFT)
+#define PVM_VMEM_MAPPING_SIZE		(1UL << TB_SHIFT)
+
+/*
+ * For a PVM guest, the hypervisor would provide one valid virtual address
+ * range for the guest kernel. The guest kernel needs to adjust its layout,
+ * including the direct mapping area, vmalloc area, vmemmap area, and CPU entry
+ * area, to be within this range. If the range start is 0xffffd90000000000, the
+ * PVM guest kernel with 4-level page tables could arrange its layout as
+ * follows:
+ *
+ * ffff800000000000 - ffff87ffffffffff (=43 bits) guard hole, reserved for hypervisor
+ * ... host kernel used ...  guest kernel range start
+ * ffffd90000000000 - ffffe0ffffffffff (=8 TB) directing mapping of all physical memory
+ * ffffe10000000000 - ffffe17fffffffff (=39 bit) hole
+ * ffffe18000000000 - ffffe67fffffffff (=5 TB) vmalloc/ioremap space
+ * ffffe68000000000 - ffffe6ffffffffff (=39 bit) hole
+ * ffffe70000000000 - ffffe7ffffffffff (=40 bit) virtual memory map (1TB)
+ * ffffe80000000000 - ffffe87fffffffff (=39 bit) cpu_entry_area mapping
+ * ffffe88000000000 - ffffe8ff7fffffff (=510 G) hole
+ * ffffe8ff80000000 - ffffe8ffffffffff (=2 G) kernel image
+ * ... host kernel used ... guest kernel range end
+ *
+ */
+bool __init pvm_kernel_layout_relocate(void)
+{
+	unsigned long area_size;
+
+	if (!boot_cpu_has(X86_FEATURE_KVM_PVM_GUEST)) {
+		vmemory_end = VMALLOC_START + (VMALLOC_SIZE_TB << 40) - 1;
+		return false;
+	}
+
+	if (!IS_ALIGNED(pvm_range_start, PGDIR_SIZE))
+		panic("The start of the allowed range is not aligned");
+
+	area_size = max_pfn << PAGE_SHIFT;
+	if (area_size > PVM_DIRECT_MAPPING_SIZE)
+		panic("The memory size is too large for directing mapping area");
+
+	vmalloc_base = page_offset_base + PVM_DIRECT_MAPPING_SIZE + HOLE_SIZE;
+	vmemory_end = vmalloc_base + PVM_VMALLOC_SIZE;
+
+	vmemmap_base = vmemory_end + HOLE_SIZE;
+	area_size = max_pfn * sizeof(struct page);
+	if (area_size > PVM_VMEM_MAPPING_SIZE)
+		panic("The memory size is too large for virtual memory mapping area");
+
+	cpu_entry_area_base = vmemmap_base + PVM_VMEM_MAPPING_SIZE;
+	BUILD_BUG_ON(CPU_ENTRY_AREA_MAP_SIZE > (1UL << 39));
+
+	if (cpu_entry_area_base + (2UL << 39) > pvm_range_end)
+		panic("The size of the allowed range is too small");
+
+	return true;
+}
diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
index e3825c7542a3..f6f332abf515 100644
--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -28,6 +28,7 @@
 
 #include <asm/setup.h>
 #include <asm/kaslr.h>
+#include <asm/pvm_para.h>
 
 #include "mm_internal.h"
 
@@ -82,6 +83,9 @@ void __init kernel_randomize_memory(void)
 	BUILD_BUG_ON(vaddr_end != RAW_CPU_ENTRY_AREA_BASE);
 	BUILD_BUG_ON(vaddr_end > __START_KERNEL_map);
 
+	if (pvm_kernel_layout_relocate())
+		return;
+
 	if (!kaslr_memory_enabled())
 		return;
 
-- 
2.19.1.6.gb485710b


