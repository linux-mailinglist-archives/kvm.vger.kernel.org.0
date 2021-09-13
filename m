Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71822409801
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 17:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343704AbhIMP5l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 11:57:41 -0400
Received: from 8bytes.org ([81.169.241.247]:56874 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229627AbhIMP5k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 11:57:40 -0400
Received: from cap.home.8bytes.org (p549ad441.dip0.t-ipconnect.de [84.154.212.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 00051108E;
        Mon, 13 Sep 2021 17:56:20 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org,
        Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Joerg Roedel <joro@8bytes.org>, linux-coco@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v2 07/12] x86/sev: Setup code to park APs in the AP Jump Table
Date:   Mon, 13 Sep 2021 17:55:58 +0200
Message-Id: <20210913155603.28383-8-joro@8bytes.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913155603.28383-1-joro@8bytes.org>
References: <20210913155603.28383-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The AP Jump Table under SEV-ES contains the reset vector where non-boot
CPUs start executing when coming out of reset. This means that a CPU
coming out of the AP-reset-hold VMGEXIT also needs to start executing at
the reset vector stored in the AP Jump Table.

The problem is to find a safe place to put the real-mode code which
executes the VMGEXIT and jumps to the reset vector. The code can not be
in kernel memory, because after kexec that memory is owned by the new
kernel and the code might have been overwritten.

Fortunately the AP Jump Table itself is a safe place, because the
memory is not owned by the OS and will not be overwritten by a new
kernel started through kexec. The table is 4k in size and only the
first 4 bytes are used for the reset vector. This leaves enough space
for some 16-bit code to do the job and even a small stack.

Install 16-bit code into the AP Jump Table under SEV-ES after the APs
have been brought up. The code will do an AP-reset-hold VMGEXIT and jump
to the reset vector after being woken up.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/realmode.h         |   2 +
 arch/x86/include/asm/sev-ap-jumptable.h |  25 +++++
 arch/x86/kernel/sev.c                   | 105 +++++++++++++++++++
 arch/x86/realmode/Makefile              |   9 +-
 arch/x86/realmode/rmpiggy.S             |   6 ++
 arch/x86/realmode/sev/Makefile          |  41 ++++++++
 arch/x86/realmode/sev/ap_jump_table.S   | 130 ++++++++++++++++++++++++
 arch/x86/realmode/sev/ap_jump_table.lds |  24 +++++
 8 files changed, 341 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/sev-ap-jumptable.h
 create mode 100644 arch/x86/realmode/sev/Makefile
 create mode 100644 arch/x86/realmode/sev/ap_jump_table.S
 create mode 100644 arch/x86/realmode/sev/ap_jump_table.lds

diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
index 5db5d083c873..29590a4ddf24 100644
--- a/arch/x86/include/asm/realmode.h
+++ b/arch/x86/include/asm/realmode.h
@@ -62,6 +62,8 @@ extern unsigned long initial_gs;
 extern unsigned long initial_stack;
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 extern unsigned long initial_vc_handler;
+extern unsigned char rm_ap_jump_table_blob[];
+extern unsigned char rm_ap_jump_table_blob_end[];
 #endif
 
 extern unsigned char real_mode_blob[];
diff --git a/arch/x86/include/asm/sev-ap-jumptable.h b/arch/x86/include/asm/sev-ap-jumptable.h
new file mode 100644
index 000000000000..1c8b2ce779e2
--- /dev/null
+++ b/arch/x86/include/asm/sev-ap-jumptable.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * AMD Encrypted Register State Support
+ *
+ * Author: Joerg Roedel <jroedel@suse.de>
+ */
+#ifndef __ASM_SEV_AP_JUMPTABLE_H
+#define __ASM_SEV_AP_JUMPTABLE_H
+
+#define	SEV_APJT_CS16	0x8
+#define	SEV_APJT_DS16	0x10
+
+#define SEV_APJT_ENTRY	0x10
+
+#ifndef __ASSEMBLY__
+
+struct sev_ap_jump_table_header {
+	u16	reset_ip;
+	u16	reset_cs;
+	u16	gdt_offset;
+};
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* __ASM_SEV_AP_JUMPTABLE_H */
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index eedba56b6bac..a98eab926682 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 
+#include <asm/sev-ap-jumptable.h>
 #include <asm/cpu_entry_area.h>
 #include <asm/stacktrace.h>
 #include <asm/sev.h>
@@ -45,6 +46,9 @@ static struct ghcb __initdata *boot_ghcb;
 /* Cached AP Jump Table Address */
 static phys_addr_t sev_es_jump_table_pa;
 
+/* Whether the AP Jump Table blob was successfully installed */
+static bool sev_ap_jumptable_blob_installed __ro_after_init;
+
 /* #VC handler runtime per-CPU data */
 struct sev_es_runtime_data {
 	struct ghcb ghcb_page;
@@ -749,6 +753,107 @@ static void __init sev_es_setup_play_dead(void)
 static inline void sev_es_setup_play_dead(void) { }
 #endif
 
+/*
+ * This function make the necessary runtime changes to the AP Jump Table blob.
+ * For now this only sets up the GDT used while the code executes. The GDT needs
+ * to contain 16-bit code and data segments with a base that points to AP Jump
+ * Table page.
+ */
+void __init sev_es_setup_ap_jump_table_data(void *base, u32 pa)
+{
+	struct sev_ap_jump_table_header *header;
+	struct desc_ptr *gdt_descr;
+	u64 *ap_jumptable_gdt;
+
+	header = base;
+
+	/*
+	 * Setup 16-bit protected mode code and data segments for AP Jumptable.
+	 * Set the segment limits to 0xffff to already be compatible with
+	 * real-mode.
+	 */
+	ap_jumptable_gdt = (u64 *)(base + header->gdt_offset);
+	ap_jumptable_gdt[SEV_APJT_CS16 / 8] = GDT_ENTRY(0x9b, pa, 0xffff);
+	ap_jumptable_gdt[SEV_APJT_DS16 / 8] = GDT_ENTRY(0x93, pa, 0xffff);
+
+	/* Write correct GDT base address into GDT descriptor */
+	gdt_descr = (struct desc_ptr *)(base + header->gdt_offset);
+	gdt_descr->address += pa;
+}
+
+/*
+ * This function sets up the AP Jump Table blob which contains code which runs
+ * in 16-bit protected mode to park an AP. After the AP is woken up again the
+ * code will disable protected mode and jump to the reset vector which is also
+ * stored in the AP Jump Table.
+ *
+ * The Jump Table is a safe place to park an AP, because it is owned by the
+ * BIOS and writable by the OS. Putting the code in kernel memory would break
+ * with kexec, because by the time th APs wake up the memory is owned by
+ * the new kernel, and possibly already overwritten.
+ *
+ * Kexec is also the reason this function is called as an init-call after SMP
+ * bringup. Only after all CPUs are up there is a guarantee that no AP is still
+ * parked in AP jump-table code.
+ */
+static int __init sev_es_setup_ap_jump_table_blob(void)
+{
+	size_t blob_size = rm_ap_jump_table_blob_end - rm_ap_jump_table_blob;
+	u16 startup_cs, startup_ip;
+	u16 __iomem *jump_table;
+	phys_addr_t pa;
+
+	if (!sev_es_active())
+		return 0;
+
+	if (sev_get_ghcb_proto_ver() < 2) {
+		pr_info("AP Jump Table parking requires at least GHCB protocol version 2\n");
+		return 0;
+	}
+
+	pa = get_jump_table_addr();
+
+	/* Overflow and size checks for untrusted Jump Table address */
+	if (pa + PAGE_SIZE < pa || pa + PAGE_SIZE > SZ_4G) {
+		pr_info("AP Jump Table is above 4GB - not enabling AP Jump Table parking\n");
+		return 0;
+	}
+
+	/* On UP guests there is no jump table so this is not a failure */
+	if (!pa)
+		return 0;
+
+	jump_table = ioremap_encrypted(pa, PAGE_SIZE);
+	if (WARN_ON(!jump_table))
+		return -EINVAL;
+
+	/*
+	 * Safe reset vector to restore it later because the blob will
+	 * overwrite it.
+	 */
+	startup_ip = jump_table[0];
+	startup_cs = jump_table[1];
+
+	/* Install AP Jump Table Blob with real mode AP parking code */
+	memcpy_toio(jump_table, rm_ap_jump_table_blob, blob_size);
+
+	/* Setup AP Jumptable GDT */
+	sev_es_setup_ap_jump_table_data(jump_table, (u32)pa);
+
+	writew(startup_ip, &jump_table[0]);
+	writew(startup_cs, &jump_table[1]);
+
+	iounmap(jump_table);
+
+	pr_info("AP Jump Table Blob successfully set up\n");
+
+	/* Mark AP Jump Table blob as available */
+	sev_ap_jumptable_blob_installed = true;
+
+	return 0;
+}
+core_initcall(sev_es_setup_ap_jump_table_blob);
+
 static void __init alloc_runtime_data(int cpu)
 {
 	struct sev_es_runtime_data *data;
diff --git a/arch/x86/realmode/Makefile b/arch/x86/realmode/Makefile
index a0b491ae2de8..00f3cceb9580 100644
--- a/arch/x86/realmode/Makefile
+++ b/arch/x86/realmode/Makefile
@@ -11,12 +11,19 @@
 KASAN_SANITIZE			:= n
 KCSAN_SANITIZE			:= n
 
+RMPIGGY-y				 = $(obj)/rm/realmode.bin
+RMPIGGY-$(CONFIG_AMD_MEM_ENCRYPT)	+= $(obj)/sev/ap_jump_table.bin
+
 subdir- := rm
+subdir- := sev
 
 obj-y += init.o
 obj-y += rmpiggy.o
 
-$(obj)/rmpiggy.o: $(obj)/rm/realmode.bin
+$(obj)/rmpiggy.o: $(RMPIGGY-y)
 
 $(obj)/rm/realmode.bin: FORCE
 	$(Q)$(MAKE) $(build)=$(obj)/rm $@
+
+$(obj)/sev/ap_jump_table.bin: FORCE
+	$(Q)$(MAKE) $(build)=$(obj)/sev $@
diff --git a/arch/x86/realmode/rmpiggy.S b/arch/x86/realmode/rmpiggy.S
index c8fef76743f6..a659f98617ff 100644
--- a/arch/x86/realmode/rmpiggy.S
+++ b/arch/x86/realmode/rmpiggy.S
@@ -17,3 +17,9 @@ SYM_DATA_END_LABEL(real_mode_blob, SYM_L_GLOBAL, real_mode_blob_end)
 SYM_DATA_START(real_mode_relocs)
 	.incbin	"arch/x86/realmode/rm/realmode.relocs"
 SYM_DATA_END(real_mode_relocs)
+
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+SYM_DATA_START(rm_ap_jump_table_blob)
+	.incbin "arch/x86/realmode/sev/ap_jump_table.bin"
+SYM_DATA_END_LABEL(rm_ap_jump_table_blob, SYM_L_GLOBAL, rm_ap_jump_table_blob_end)
+#endif
diff --git a/arch/x86/realmode/sev/Makefile b/arch/x86/realmode/sev/Makefile
new file mode 100644
index 000000000000..5a96a518ccb3
--- /dev/null
+++ b/arch/x86/realmode/sev/Makefile
@@ -0,0 +1,41 @@
+#
+# arch/x86/sev/Makefile
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+
+# Sanitizer runtimes are unavailable and cannot be linked here.
+KASAN_SANITIZE			:= n
+KCSAN_SANITIZE			:= n
+OBJECT_FILES_NON_STANDARD	:= y
+
+# Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
+KCOV_INSTRUMENT		:= n
+
+always-y := ap_jump_table.bin
+
+ap_jump_table-y				+= ap_jump_table.o
+
+targets	+= $(ap_jump_table-y)
+
+APJUMPTABLE_OBJS = $(addprefix $(obj)/,$(ap_jump_table-y))
+
+LDFLAGS_ap_jump_table.elf := -m elf_i386 -T
+
+targets += ap_jump_table.elf
+$(obj)/ap_jump_table.elf: $(obj)/ap_jump_table.lds $(APJUMPTABLE_OBJS) FORCE
+	$(call if_changed,ld)
+
+OBJCOPYFLAGS_ap_jump_table.bin := -O binary
+
+targets += ap_jump_table.bin
+$(obj)/ap_jump_table.bin: $(obj)/ap_jump_table.elf FORCE
+	$(call if_changed,objcopy)
+
+# ---------------------------------------------------------------------------
+
+KBUILD_AFLAGS	:= $(REALMODE_CFLAGS) -D__ASSEMBLY__
+GCOV_PROFILE := n
+UBSAN_SANITIZE := n
diff --git a/arch/x86/realmode/sev/ap_jump_table.S b/arch/x86/realmode/sev/ap_jump_table.S
new file mode 100644
index 000000000000..547cb363bb94
--- /dev/null
+++ b/arch/x86/realmode/sev/ap_jump_table.S
@@ -0,0 +1,130 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <linux/linkage.h>
+#include <asm/sev-ap-jumptable.h>
+
+/*
+ * This file contains the source code for the binary blob which gets copied to
+ * the SEV-ES AP Jumptable to park APs while offlining CPUs or booting a new
+ * kernel via KEXEC.
+ *
+ * The AP Jumptable is the only safe place to put this code, as any memory the
+ * kernel allocates will be owned (and possibly overwritten) by the new kernel
+ * once the APs are woken up.
+ *
+ * This code runs in 16-bit protected mode, the CS, DS, and SS segment bases are
+ * set to the beginning of the AP Jumptable page.
+ *
+ * Since the GDT will also be gone when the AP wakes up, this blob contains its
+ * own GDT, which is set up by the AP Jumptable setup code with the correct
+ * offsets.
+ *
+ * Author: Joerg Roedel <jroedel@suse.de>
+ */
+
+	.text
+	.org 0x0
+	.code16
+SYM_DATA_START(ap_jumptable_header)
+	.word	0			/* reset IP */
+	.word	0			/* reset CS */
+	.word	ap_jumptable_gdt	/* GDT Offset   */
+SYM_DATA_END(ap_jumptable_header)
+
+	.org	SEV_APJT_ENTRY
+SYM_CODE_START(ap_park_asm)
+
+	/* Switch to AP Jumptable GDT first */
+	lgdtl	ap_jumptable_gdt
+
+	/* Reload CS */
+	ljmpw	$SEV_APJT_CS16, $1f
+1:
+
+	/* Reload DS and SS */
+	movl	$SEV_APJT_DS16, %ecx
+	movl	%ecx, %ds
+	movl	%ecx, %ss
+
+	/*
+	 * Setup a stack pointing to the end of the AP Jumptable page.
+	 * The stack is needed ot reset EFLAGS after wakeup.
+	 */
+	movl	$0x1000, %esp
+
+	/* Execute AP reset hold VMGEXIT */
+2:	xorl	%edx, %edx
+	movl	$0x6, %eax
+	movl	$0xc0010130, %ecx
+	wrmsr
+	rep; vmmcall
+	rdmsr
+	movl	%eax, %ecx
+	andl	$0xfff, %ecx
+	cmpl	$0x7, %ecx
+	jne	2b
+	shrl	$12, %eax
+	jnz	3f
+	testl	%edx, %edx
+	jnz	3f
+	jmp	2b
+3:
+	/*
+	 * Successfully woken up - Patch the correct target into the far jump at
+	 * the end. An indirect far jump does not work here, because at the time
+	 * the jump is executed DS is already loaded with real-mode values.
+	 */
+
+	/* Jump target is at address 0x0 - copy it to the far jump instruction */
+	movl	$0, %ecx
+	movl	(%ecx), %eax
+	movl	%eax, jump_target
+
+	/* Reset EFLAGS */
+	pushl	$2
+	popfl
+
+	/* Setup DS and SS for real-mode */
+	movl	$0x18, %ecx
+	movl	%ecx, %ds
+	movl	%ecx, %ss
+
+	/* Reset remaining registers */
+	movl	$0, %esp
+	movl	$0, %eax
+	movl	$0, %ebx
+	movl	$0, %edx
+
+	/* Reset CR0 to get out of protected mode */
+	movl	$0x60000010, %ecx
+	movl	%ecx, %cr0
+
+	/*
+	 * The below sums up to a far-jump instruction which jumps to the reset
+	 * vector configured in the AP Jumptable and to real-mode. An indirect
+	 * jump would be cleaner, but requires a working DS base/limit. DS is
+	 * already loaded with real-mode values, therefore a direct far jump is
+	 * used which got the correct target patched in.
+	 */
+	.byte	0xea
+SYM_DATA_LOCAL(jump_target, .long 0)
+
+SYM_CODE_END(ap_park_asm)
+	/* Here comes the GDT */
+	.balign	16
+SYM_DATA_START_LOCAL(ap_jumptable_gdt)
+	/* Offset zero used for GDT descriptor */
+	.word	ap_jumptable_gdt_end - ap_jumptable_gdt - 1
+	.long	ap_jumptable_gdt
+	.word	0
+
+	/* 16 bit code segment - setup at boot */
+	.quad 0
+
+	/* 16 bit data segment - setup at boot */
+	.quad 0
+
+	/* Offset 0x8 - real-mode data segment */
+	.long	0xffff0180
+	.long	0x00009300
+SYM_DATA_END_LABEL(ap_jumptable_gdt, SYM_L_LOCAL, ap_jumptable_gdt_end)
diff --git a/arch/x86/realmode/sev/ap_jump_table.lds b/arch/x86/realmode/sev/ap_jump_table.lds
new file mode 100644
index 000000000000..e3a1220f36db
--- /dev/null
+++ b/arch/x86/realmode/sev/ap_jump_table.lds
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * ap_jump_table.lds
+ *
+ * Linker script for the SEV-ES AP Jump Table Code
+ */
+
+OUTPUT_FORMAT("elf32-i386")
+OUTPUT_ARCH(i386)
+ENTRY(ap_park_asm)
+
+SECTIONS
+{
+	. = 0;
+	.text : {
+		*(.text)
+		*(.text.*)
+	}
+
+	/DISCARD/ : {
+		*(.note*)
+		*(.debug*)
+	}
+}
-- 
2.33.0

