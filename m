Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1232F18AFEE
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 10:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgCSJOT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 05:14:19 -0400
Received: from 8bytes.org ([81.169.241.247]:51840 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727060AbgCSJOS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 05:14:18 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id C980311D; Thu, 19 Mar 2020 10:14:15 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>
Subject: [RFC PATCH 00/70 v2] x86: SEV-ES Guest Support
Date:   Thu, 19 Mar 2020 10:12:57 +0100
Message-Id: <20200319091407.1481-1-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

here is an updated version of the patch-set to enable Linux to run as a
guest in an SEV-ES enabled Hypervisor. The first version can be found
here:

	https://lore.kernel.org/lkml/20200211135256.24617-1-joro@8bytes.org/

The first post also includes a more elaborate description of the
implementation requirements and details.  A branch containing these
patches is here:

	https://git.kernel.org/pub/scm/linux/kernel/git/joro/linux.git/log/?h=sev-es-client-v5.6-rc6

There are lots of small changes since the first version, here is a list
of the major ones, which address most of the valuable review comments I
received, thanks for that!

Changes since v1:

	- Rebased to v5.6-rc6

	- Factored out instruction decoding part of the UMIP handler and
	  re-used it in the SEV-ES code.

	- Several enhancements of the instruction decoder as needed by
	  SEV-ES

	- The instruction fetch and memory access code for instruction
	  emulation now handles different user execution modes as well
	  as segment bases.

	- Added emulation of (REP) MOVS instructions

	- Added handling for nesting #VC handlers - which fixed the NMI
	  issues.

	- Pass error_code as a parameter to the #VC exception handlers

	- Reworked early exception dispatch function

	- Moved the GHCB pages out of the per-cpu areas and only
	  allocate them when they are actually needed. The per-cpu areas
	  only store a pointer now.

	- Removed emulation for INVD, now it will just cause an error if
	  used.

	- Added prefixes to the function names.

	- Fixed a bug which broke bare-metal boot with mem_encrypt=on

The last missing change I have on my list is to rework the NMI handling
patch. I decided to postpone this until Thomas' Gleixners rework of the
x86 entry code is ready and merged, because the NMI handling will
conflict with these changes.

Please review.

Thanks,

	Joerg

Doug Covelli (1):
  x86/vmware: Add VMware specific handling for VMMCALL under SEV-ES

Joerg Roedel (51):
  KVM: SVM: Add GHCB Accessor functions
  x86/traps: Move some definitions to <asm/trap_defs.h>
  x86/insn: Make inat-tables.c suitable for pre-decompression code
  x86/umip: Factor out instruction fetch
  x86/umip: Factor out instruction decoding
  x86/insn: Add insn_get_modrm_reg_off()
  x86/insn: Add insn_rep_prefix() helper
  x86/boot/compressed: Fix debug_puthex() parameter type
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
  x86/boot/compressed/64: Add function to map a page unencrypted
  x86/boot/compressed/64: Setup GHCB Based VC Exception handler
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
  x86/sev-es: Compile early handler code into kernel image
  x86/sev-es: Setup early #VC handler
  x86/sev-es: Setup GHCB based boot #VC handler
  x86/sev-es: Support nested #VC exceptions
  x86/sev-es: Wire up existing #VC exit-code handlers
  x86/sev-es: Handle instruction fetches from user-space
  x86/sev-es: Harden runtime #VC handler for exceptions from user-space
  x86/sev-es: Filter exceptions not supported from user-space
  x86/sev-es: Handle MMIO String Instructions
  x86/sev-es: Handle RDTSCP Events
  x86/sev-es: Handle #AC Events
  x86/sev-es: Handle #DB Events
  x86/paravirt: Allow hypervisor specific VMMCALL handling under SEV-ES
  x86/realmode: Add SEV-ES specific trampoline entry point
  x86/head/64: Don't call verify_cpu() on starting APs
  x86/head/64: Rename start_cpu0
  x86/sev-es: Support CPU offline/online
  x86/cpufeature: Add SEV_ES_GUEST CPU Feature
  x86/sev-es: Add NMI state tracking

Tom Lendacky (18):
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
  x86/sev-es: Handle RDTSC Events
  x86/sev-es: Handle RDPMC Events
  x86/sev-es: Handle INVD Events
  x86/sev-es: Handle MONITOR/MONITORX Events
  x86/sev-es: Handle MWAIT/MWAITX Events
  x86/sev-es: Handle VMMCALL Events
  x86/kvm: Add KVM specific VMMCALL handling under SEV-ES
  x86/realmode: Setup AP jump table

 arch/x86/Kconfig                           |    1 +
 arch/x86/boot/Makefile                     |    2 +-
 arch/x86/boot/compressed/Makefile          |    8 +-
 arch/x86/boot/compressed/head_64.S         |   41 +
 arch/x86/boot/compressed/ident_map_64.c    |  320 ++++++
 arch/x86/boot/compressed/idt_64.c          |   53 +
 arch/x86/boot/compressed/idt_handlers_64.S |   82 ++
 arch/x86/boot/compressed/kaslr.c           |   36 +-
 arch/x86/boot/compressed/kaslr_64.c        |  153 ---
 arch/x86/boot/compressed/misc.h            |   34 +-
 arch/x86/boot/compressed/sev-es.c          |  177 +++
 arch/x86/entry/entry_64.S                  |   52 +
 arch/x86/include/asm/cpu.h                 |    2 +-
 arch/x86/include/asm/cpufeatures.h         |    2 +
 arch/x86/include/asm/desc.h                |   28 +
 arch/x86/include/asm/desc_defs.h           |   10 +
 arch/x86/include/asm/fpu/internal.h        |   29 +-
 arch/x86/include/asm/fpu/xcr.h             |   32 +
 arch/x86/include/asm/insn-eval.h           |    6 +
 arch/x86/include/asm/mem_encrypt.h         |    5 +
 arch/x86/include/asm/msr-index.h           |    3 +
 arch/x86/include/asm/pgtable.h             |    2 +-
 arch/x86/include/asm/processor.h           |    1 +
 arch/x86/include/asm/realmode.h            |    4 +
 arch/x86/include/asm/segment.h             |    2 +-
 arch/x86/include/asm/setup.h               |    1 -
 arch/x86/include/asm/sev-es.h              |  119 ++
 arch/x86/include/asm/svm.h                 |  103 ++
 arch/x86/include/asm/trap_defs.h           |   50 +
 arch/x86/include/asm/traps.h               |   51 +-
 arch/x86/include/asm/x86_init.h            |   16 +-
 arch/x86/include/uapi/asm/svm.h            |   11 +
 arch/x86/kernel/Makefile                   |    5 +
 arch/x86/kernel/cpu/amd.c                  |    9 +-
 arch/x86/kernel/cpu/scattered.c            |    1 +
 arch/x86/kernel/cpu/vmware.c               |   50 +-
 arch/x86/kernel/head64.c                   |   57 +-
 arch/x86/kernel/head_32.S                  |    4 +-
 arch/x86/kernel/head_64.S                  |  169 ++-
 arch/x86/kernel/idt.c                      |   52 +-
 arch/x86/kernel/kvm.c                      |   35 +-
 arch/x86/kernel/nmi.c                      |    8 +
 arch/x86/kernel/sev-es-shared.c            |  444 ++++++++
 arch/x86/kernel/sev-es.c                   | 1165 ++++++++++++++++++++
 arch/x86/kernel/smpboot.c                  |    4 +-
 arch/x86/kernel/traps.c                    |    3 +
 arch/x86/kernel/umip.c                     |   49 +-
 arch/x86/lib/insn-eval.c                   |  130 +++
 arch/x86/mm/extable.c                      |    1 +
 arch/x86/mm/mem_encrypt.c                  |   11 +-
 arch/x86/mm/mem_encrypt_identity.c         |    3 +
 arch/x86/realmode/init.c                   |   12 +
 arch/x86/realmode/rm/header.S              |    3 +
 arch/x86/realmode/rm/trampoline_64.S       |   20 +
 arch/x86/tools/gen-insn-attr-x86.awk       |   50 +-
 tools/arch/x86/tools/gen-insn-attr-x86.awk |   50 +-
 56 files changed, 3352 insertions(+), 419 deletions(-)
 create mode 100644 arch/x86/boot/compressed/ident_map_64.c
 create mode 100644 arch/x86/boot/compressed/idt_64.c
 create mode 100644 arch/x86/boot/compressed/idt_handlers_64.S
 delete mode 100644 arch/x86/boot/compressed/kaslr_64.c
 create mode 100644 arch/x86/boot/compressed/sev-es.c
 create mode 100644 arch/x86/include/asm/fpu/xcr.h
 create mode 100644 arch/x86/include/asm/sev-es.h
 create mode 100644 arch/x86/include/asm/trap_defs.h
 create mode 100644 arch/x86/kernel/sev-es-shared.c
 create mode 100644 arch/x86/kernel/sev-es.c

-- 
2.17.1

