Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08EF421F0E3
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 14:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgGNMKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 08:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgGNMKg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 08:10:36 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFE6C061755;
        Tue, 14 Jul 2020 05:10:36 -0700 (PDT)
Received: from cap.home.8bytes.org (p5b006776.dip0.t-ipconnect.de [91.0.103.118])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 4D5321E6;
        Tue, 14 Jul 2020 14:10:33 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
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
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v4 00/75] x86: SEV-ES Guest Support
Date:   Tue, 14 Jul 2020 14:08:02 +0200
Message-Id: <20200714120917.11253-1-joro@8bytes.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Hi,

here is the fourth version of the SEV-ES Guest Support patches. I
addressed the review comments sent to me for the previous version and
rebased the code v5.8-rc5.

The biggest change in this version is the IST handling code for the
#VC handler. I adapted the entry code for the #VC handler to the big
pile of entry code changes merged into v5.8-rc1, which means it no
longer uses IST shifting (with one exception in the NMI handler, but
that is not ist-shifting as implemented previously).

The #VC entry code now tries to pretend that the #VC handler does not
use an IST stack by switching to the task stack if entered from
user-mode or the SYSCALL entry path. When it is entered from
kernel-mode it is doing its best to switch back to the interrupted
stack. This is only possible if it is entered from a known and safe
kernel stack (e.g. not the entry stack). If the previous stack is not
safe to use the #VC handler switches to a fall-back stack and calls a
special handler function which, as of now, just panics the system. For
now this is safe as #VC exceptions only happen at know places which
use a safe stack.

The use of the fall-back stack is necessary so that the special
handler function can safely raise nested #VC exceptions, for
example to print a panic message.

This implementation has survived overnight stress testing (>14h) with
'perf top' running for NMI-load and three instances of the x86-selftests
in a loop.

A git-tree with these patches applied can be found at:

	https://git.kernel.org/pub/scm/linux/kernel/git/joro/linux.git/log/?h=sev-es-client-v5.8-rc5

Changes to the previous version:

	* Addressed review comments

	* Rebased to v5.8-rc5

	* Addressed kbuild-bot reports

	* Removed CPUID caching for now

	* Re-implemented IST handling so that the #VC handler supports
	  nesting

The previous post of the patch-set can be found here:

	v3: https://lore.kernel.org/lkml/20200428151725.31091-1-joro@8bytes.org/

	v2: https://lore.kernel.org/lkml/20200319091407.1481-1-joro@8bytes.org/

	v1: https://lore.kernel.org/lkml/20200211135256.24617-1-joro@8bytes.org/

Please review.

Thanks,

	Joerg

Borislav Petkov (1):
  KVM: SVM: Use __packed shorthand

Doug Covelli (1):
  x86/vmware: Add VMware specific handling for VMMCALL under SEV-ES

Joerg Roedel (53):
  KVM: SVM: Add GHCB Accessor functions
  x86/traps: Move pf error codes to <asm/trap_pf.h>
  x86/insn: Make inat-tables.c suitable for pre-decompression code
  x86/umip: Factor out instruction fetch
  x86/umip: Factor out instruction decoding
  x86/insn: Add insn_get_modrm_reg_off()
  x86/insn: Add insn_has_rep_prefix() helper
  x86/boot/compressed/64: Disable red-zone usage
  x86/boot/compressed/64: Add IDT Infrastructure
  x86/boot/compressed/64: Rename kaslr_64.c to ident_map_64.c
  x86/boot/compressed/64: Add page-fault handler
  x86/boot/compressed/64: Always switch to own page-table
  x86/boot/compressed/64: Don't pre-map memory in KASLR code
  x86/boot/compressed/64: Change add_identity_map() to take start and
    end
  x86/boot/compressed/64: Add stage1 #VC handler
  x86/boot/compressed/64: Call set_sev_encryption_mask earlier
  x86/boot/compressed/64: Check return value of
    kernel_ident_mapping_init()
  x86/boot/compressed/64: Add set_page_en/decrypted() helpers
  x86/boot/compressed/64: Setup GHCB Based VC Exception handler
  x86/boot/compressed/64: Unmap GHCB page before booting the kernel
  x86/fpu: Move xgetbv()/xsetbv() into separate header
  x86/idt: Move IDT to data segment
  x86/idt: Split idt_data setup out of set_intr_gate()
  x86/idt: Move two function from k/idt.c to i/a/desc.h
  x86/head/64: Install boot GDT
  x86/head/64: Reload GDT after switch to virtual addresses
  x86/head/64: Load segment registers earlier
  x86/head/64: Switch to initial stack earlier
  x86/head/64: Build k/head64.c with -fno-stack-protector
  x86/head/64: Load IDT earlier
  x86/head/64: Move early exception dispatch to C code
  x86/sev-es: Add SEV-ES Feature Detection
  x86/sev-es: Print SEV-ES info into kernel log
  x86/sev-es: Compile early handler code into kernel image
  x86/sev-es: Setup early #VC handler
  x86/sev-es: Setup GHCB based boot #VC handler
  x86/sev-es: Allocate and Map stacks for #VC handler
  x86/sev-es: Allocate and setup IST entry for #VC
  x86/sev-es: Adjust #VC IST Stack on entering NMI handler
  x86/dumpstack/64: Add noinstr version of get_stack_info()
  x86/entry/64: Add entry code for #VC handler
  x86/sev-es: Wire up existing #VC exit-code handlers
  x86/sev-es: Handle instruction fetches from user-space
  x86/sev-es: Handle MMIO String Instructions
  x86/sev-es: Handle #AC Events
  x86/sev-es: Handle #DB Events
  x86/paravirt: Allow hypervisor specific VMMCALL handling under SEV-ES
  x86/realmode: Add SEV-ES specific trampoline entry point
  x86/head/64: Setup TSS early for secondary CPUs
  x86/head/64: Don't call verify_cpu() on starting APs
  x86/head/64: Rename start_cpu0
  x86/sev-es: Support CPU offline/online
  x86/sev-es: Handle NMI State

Martin Radev (1):
  x86/sev-es: Check required CPU features for SEV-ES

Tom Lendacky (19):
  KVM: SVM: Add GHCB definitions
  x86/cpufeatures: Add SEV-ES CPU feature
  x86/sev-es: Add support for handling IOIO exceptions
  x86/sev-es: Add CPUID handling to #VC handler
  x86/sev-es: Setup per-cpu GHCBs for the runtime handler
  x86/sev-es: Add Runtime #VC Exception Handler
  x86/sev-es: Handle MMIO events
  x86/sev-es: Handle MSR events
  x86/sev-es: Handle DR7 read/write events
  x86/sev-es: Handle WBINVD Events
  x86/sev-es: Handle RDTSC(P) Events
  x86/sev-es: Handle RDPMC Events
  x86/sev-es: Handle INVD Events
  x86/sev-es: Handle MONITOR/MONITORX Events
  x86/sev-es: Handle MWAIT/MWAITX Events
  x86/sev-es: Handle VMMCALL Events
  x86/kvm: Add KVM specific VMMCALL handling under SEV-ES
  x86/realmode: Setup AP jump table
  x86/efi: Add GHCB mappings when SEV-ES is active

 arch/x86/Kconfig                           |    1 +
 arch/x86/boot/Makefile                     |    2 +-
 arch/x86/boot/compressed/Makefile          |    9 +-
 arch/x86/boot/compressed/head_64.S         |   32 +-
 arch/x86/boot/compressed/ident_map_64.c    |  349 +++++
 arch/x86/boot/compressed/idt_64.c          |   54 +
 arch/x86/boot/compressed/idt_handlers_64.S |   77 ++
 arch/x86/boot/compressed/kaslr.c           |   36 +-
 arch/x86/boot/compressed/kaslr_64.c        |  153 ---
 arch/x86/boot/compressed/misc.c            |    7 +
 arch/x86/boot/compressed/misc.h            |   45 +-
 arch/x86/boot/compressed/sev-es.c          |  214 +++
 arch/x86/entry/entry_64.S                  |   78 ++
 arch/x86/include/asm/cpu.h                 |    2 +-
 arch/x86/include/asm/cpu_entry_area.h      |   33 +-
 arch/x86/include/asm/cpufeatures.h         |    1 +
 arch/x86/include/asm/desc.h                |   27 +
 arch/x86/include/asm/desc_defs.h           |   10 +
 arch/x86/include/asm/fpu/internal.h        |   33 +-
 arch/x86/include/asm/fpu/xcr.h             |   37 +
 arch/x86/include/asm/idtentry.h            |   49 +
 arch/x86/include/asm/insn-eval.h           |    6 +
 arch/x86/include/asm/mem_encrypt.h         |    5 +
 arch/x86/include/asm/msr-index.h           |    3 +
 arch/x86/include/asm/page_64_types.h       |    1 +
 arch/x86/include/asm/pgtable.h             |    2 +-
 arch/x86/include/asm/processor.h           |    1 +
 arch/x86/include/asm/proto.h               |    1 +
 arch/x86/include/asm/realmode.h            |    4 +
 arch/x86/include/asm/segment.h             |    2 +-
 arch/x86/include/asm/setup.h               |    3 +-
 arch/x86/include/asm/sev-es.h              |   97 ++
 arch/x86/include/asm/stacktrace.h          |    2 +
 arch/x86/include/asm/svm.h                 |  118 +-
 arch/x86/include/asm/trap_pf.h             |   24 +
 arch/x86/include/asm/trapnr.h              |    1 +
 arch/x86/include/asm/traps.h               |   20 +-
 arch/x86/include/asm/x86_init.h            |   16 +-
 arch/x86/include/uapi/asm/svm.h            |   11 +
 arch/x86/kernel/Makefile                   |    5 +
 arch/x86/kernel/cpu/amd.c                  |    3 +-
 arch/x86/kernel/cpu/scattered.c            |    1 +
 arch/x86/kernel/cpu/vmware.c               |   50 +-
 arch/x86/kernel/dumpstack.c                |    7 +-
 arch/x86/kernel/dumpstack_64.c             |   47 +-
 arch/x86/kernel/head64.c                   |  106 +-
 arch/x86/kernel/head_32.S                  |    4 +-
 arch/x86/kernel/head_64.S                  |  176 ++-
 arch/x86/kernel/idt.c                      |   43 +-
 arch/x86/kernel/kvm.c                      |   35 +-
 arch/x86/kernel/nmi.c                      |   12 +
 arch/x86/kernel/sev-es-shared.c            |  507 +++++++
 arch/x86/kernel/sev-es.c                   | 1403 ++++++++++++++++++++
 arch/x86/kernel/smpboot.c                  |    4 +-
 arch/x86/kernel/traps.c                    |   56 +
 arch/x86/kernel/umip.c                     |   49 +-
 arch/x86/kvm/svm/svm.c                     |    2 +
 arch/x86/lib/insn-eval.c                   |  130 ++
 arch/x86/mm/cpu_entry_area.c               |    3 +-
 arch/x86/mm/extable.c                      |    1 +
 arch/x86/mm/mem_encrypt.c                  |   38 +-
 arch/x86/mm/mem_encrypt_identity.c         |    3 +
 arch/x86/platform/efi/efi_64.c             |   10 +
 arch/x86/realmode/init.c                   |   24 +-
 arch/x86/realmode/rm/header.S              |    3 +
 arch/x86/realmode/rm/trampoline_64.S       |   20 +
 arch/x86/tools/gen-insn-attr-x86.awk       |   50 +-
 tools/arch/x86/tools/gen-insn-attr-x86.awk |   50 +-
 68 files changed, 3964 insertions(+), 444 deletions(-)
 create mode 100644 arch/x86/boot/compressed/ident_map_64.c
 create mode 100644 arch/x86/boot/compressed/idt_64.c
 create mode 100644 arch/x86/boot/compressed/idt_handlers_64.S
 delete mode 100644 arch/x86/boot/compressed/kaslr_64.c
 create mode 100644 arch/x86/boot/compressed/sev-es.c
 create mode 100644 arch/x86/include/asm/fpu/xcr.h
 create mode 100644 arch/x86/include/asm/sev-es.h
 create mode 100644 arch/x86/include/asm/trap_pf.h
 create mode 100644 arch/x86/kernel/sev-es-shared.c
 create mode 100644 arch/x86/kernel/sev-es.c

-- 
2.27.0

