Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C22826031D
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 19:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731444AbgIGRoP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 13:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729439AbgIGNRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 09:17:46 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59ABC061574;
        Mon,  7 Sep 2020 06:16:44 -0700 (PDT)
Received: from cap.home.8bytes.org (p549add56.dip0.t-ipconnect.de [84.154.221.86])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 12A591CA;
        Mon,  7 Sep 2020 15:16:39 +0200 (CEST)
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
Subject: [PATCH v7 00/72] x86: SEV-ES Guest Support
Date:   Mon,  7 Sep 2020 15:15:01 +0200
Message-Id: <20200907131613.12703-1-joro@8bytes.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Hi,

here is a new version of the SEV-ES Guest Support patches for x86. The
previous versions can be found as a linked list starting here:

	https://lore.kernel.org/lkml/20200824085511.7553-1-joro@8bytes.org/

I updated the patch-set based on ther review comments I got and the
discussions around it.

Another important change is that the early IDT setup code is now
completly moved to arch/x86/kernel/head64.c. This makes the whole
early exception handling setup code more robust for kernels that have
KASAN and/or Tracing enabled.

A side effect of this change is that secondary CPU now don't use the
idt_table at early boot, which means that on the secondary CPUs the
early handler does not use IST or paranoid_entry() anymore. This
allowed to remove a couple of patches from this series which were only
needed to setup relevant processor starte early enough for IST
exceptions. In particular this means that the early FSGSBASE and TSS
setup is gone now. Also the patch which moved the idt_table to the
data segement is now removed.

A related change was necessary in the boot path of secondary CPUs,
because those loaded the runtime IDT before setting up the TSS and the
getcpu GDT entry. This is now in proper order so that IST exceptions
will work when the runtime IDT is loaded for the first time. This
setup is added in patch 67.

The cpu_init() function is untouched so that it still act as the
intended cpu-state barrier, regardless of what happens before.

The code survived the usual load test of running one x86-selftest loop
on each core of the guest in parallel with perf (for NMI load). This
runs for several (4+) hours now without any issues.

Please review.

Thanks,

	Joerg

Borislav Petkov (1):
  KVM: SVM: Use __packed shorthand

Doug Covelli (1):
  x86/vmware: Add VMware specific handling for VMMCALL under SEV-ES

Joerg Roedel (50):
  KVM: SVM: nested: Don't allocate VMCB structures on stack
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
  x86/boot/compressed/64: Call set_sev_encryption_mask() earlier
  x86/boot/compressed/64: Check return value of
    kernel_ident_mapping_init()
  x86/boot/compressed/64: Add set_page_en/decrypted() helpers
  x86/boot/compressed/64: Setup GHCB Based VC Exception handler
  x86/boot/compressed/64: Unmap GHCB page before booting the kernel
  x86/fpu: Move xgetbv()/xsetbv() into separate header
  x86/idt: Split idt_data setup out of set_intr_gate()
  x86/head/64: Install startup GDT
  x86/head/64: Load GDT after switch to virtual addresses
  x86/head/64: Load segment registers earlier
  x86/head/64: Switch to initial stack earlier
  x86/head/64: Install a CPU bringup IDT
  x86/idt: Move two function from k/idt.c to i/a/desc.h
  x86/head/64: Move early exception dispatch to C code
  x86/sev-es: Add SEV-ES Feature Detection
  x86/sev-es: Print SEV-ES info into kernel log
  x86/sev-es: Compile early handler code into kernel image
  x86/sev-es: Setup early #VC handler
  x86/sev-es: Setup GHCB based boot #VC handler
  x86/sev-es: Allocate and Map IST stack for #VC handler
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
  x86/smpboot: Load TSS and getcpu GDT entry before loading IDT
  x86/head/64: Don't call verify_cpu() on starting APs
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
 arch/x86/boot/compressed/Makefile          |   11 +-
 arch/x86/boot/compressed/cpuflags.c        |    4 -
 arch/x86/boot/compressed/head_64.S         |   33 +-
 arch/x86/boot/compressed/ident_map_64.c    |  349 +++++
 arch/x86/boot/compressed/idt_64.c          |   54 +
 arch/x86/boot/compressed/idt_handlers_64.S |   77 ++
 arch/x86/boot/compressed/kaslr.c           |   36 +-
 arch/x86/boot/compressed/kaslr_64.c        |  153 ---
 arch/x86/boot/compressed/misc.c            |    7 +
 arch/x86/boot/compressed/misc.h            |   50 +-
 arch/x86/boot/compressed/sev-es.c          |  214 +++
 arch/x86/entry/entry_64.S                  |   80 ++
 arch/x86/include/asm/cpu_entry_area.h      |   33 +-
 arch/x86/include/asm/cpufeatures.h         |    1 +
 arch/x86/include/asm/desc.h                |   27 +
 arch/x86/include/asm/desc_defs.h           |   10 +
 arch/x86/include/asm/fpu/internal.h        |   30 +-
 arch/x86/include/asm/fpu/xcr.h             |   34 +
 arch/x86/include/asm/idtentry.h            |   50 +
 arch/x86/include/asm/insn-eval.h           |    6 +
 arch/x86/include/asm/mem_encrypt.h         |    5 +
 arch/x86/include/asm/msr-index.h           |    3 +
 arch/x86/include/asm/page_64_types.h       |    1 +
 arch/x86/include/asm/pgtable.h             |    2 +-
 arch/x86/include/asm/processor.h           |    1 +
 arch/x86/include/asm/proto.h               |    1 +
 arch/x86/include/asm/realmode.h            |    7 +
 arch/x86/include/asm/segment.h             |    2 +-
 arch/x86/include/asm/setup.h               |    6 +-
 arch/x86/include/asm/sev-es.h              |  114 ++
 arch/x86/include/asm/stacktrace.h          |    2 +
 arch/x86/include/asm/svm.h                 |  106 +-
 arch/x86/include/asm/trap_pf.h             |   24 +
 arch/x86/include/asm/trapnr.h              |    1 +
 arch/x86/include/asm/traps.h               |   20 +-
 arch/x86/include/asm/x86_init.h            |   16 +-
 arch/x86/include/uapi/asm/svm.h            |   11 +
 arch/x86/kernel/Makefile                   |    3 +
 arch/x86/kernel/cpu/amd.c                  |    3 +-
 arch/x86/kernel/cpu/common.c               |   25 +
 arch/x86/kernel/cpu/scattered.c            |    1 +
 arch/x86/kernel/cpu/vmware.c               |   50 +-
 arch/x86/kernel/dumpstack.c                |    7 +-
 arch/x86/kernel/dumpstack_64.c             |   46 +-
 arch/x86/kernel/head64.c                   |  122 +-
 arch/x86/kernel/head_64.S                  |  160 ++-
 arch/x86/kernel/idt.c                      |   41 +-
 arch/x86/kernel/kvm.c                      |   35 +-
 arch/x86/kernel/nmi.c                      |   15 +
 arch/x86/kernel/sev-es-shared.c            |  507 +++++++
 arch/x86/kernel/sev-es.c                   | 1404 ++++++++++++++++++++
 arch/x86/kernel/smpboot.c                  |    2 +-
 arch/x86/kernel/traps.c                    |   48 +
 arch/x86/kernel/umip.c                     |   49 +-
 arch/x86/kvm/svm/nested.c                  |   47 +-
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
 68 files changed, 4030 insertions(+), 451 deletions(-)
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
2.28.0

