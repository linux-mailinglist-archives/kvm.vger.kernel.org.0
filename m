Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9038815913B
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729397AbgBKNxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:53:10 -0500
Received: from 8bytes.org ([81.169.241.247]:51752 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729383AbgBKNxJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 08:53:09 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 4F93F303; Tue, 11 Feb 2020 14:53:07 +0100 (CET)
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
Subject: [RFC PATCH 00/62] Linux as SEV-ES Guest Support
Date:   Tue, 11 Feb 2020 14:51:54 +0100
Message-Id: <20200211135256.24617-1-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

here is the first public post of the patch-set to enable Linux to run
under SEV-ES enabled hypervisors. The code is mostly feature-complete,
but there are still a couple of bugs to fix. Nevertheless, given the
size of the patch-set, I think it is about time to ask for initial
feedback of the changes that come with it. To better understand the code
here is a quick explanation of SEV-ES first.

This patch-set does not contain the hypervisor changes necessary to run
SEV-ES enabled KVM guests. These patches will be sent separatly when
they are ready to be sent out.

What is SEV-ES
==============

SEV-ES is an acronym for 'Secure Encrypted Virtualization - Encrypted
State' and means a hardware feature of AMD processors which hides the
register state of VCPUs to the hypervisor by encrypting it. The
hypervisor can't read or make changes to the guests register state.

Most intercepts set by the hypervisor do not cause a #VMEXIT of the
guest anymore, but turn into a VMM Communication Exception (#VC
exception, vector 29) inside the guest. The error-code of this exception
is the intercept exit-code that caused the exception. The guest handles
the #VC exception by communicating with the hypervisor through a shared
data structure, the 'Guest-Hypervisor-Communication-Block' (GHCB). The
layout of that data-structure and the protocol is specified in [1].

A description of the SEV-ES hardware interface can be found in the AMD64
Architecture Programmer's Manual Volume 2, Section 15.35 [2].

Implementation Details
======================

SEV-ES guests will always boot via UEFI firmware and use the 64-bit EFI
entry point into the kernel. This implies that only 64-bit Linux x86
guests are supported.

Pre-Decompression Boot Code and Early Exception Support
-------------------------------------------------------

Intercepts that cause exceptions in the guest include instructions like
CPUID, RDMSR/WRMSR, IOIO instructions and a couple more. Some of them
are executed very early during boot, which means that exceptions need to
work that early. That is the reason big parts of this patch-set enable
support for early exceptions, first in the pre-decompression boot-code
and later also in the early boot-code of the kernel image.

As these patches add exception support to the pre-decompression boot
code, it also implements a page-fault handler to create the
identity-mapped page-table on-demand. One reason for this change is to
make use of the exception handling code in non SEV-ES guests too, so
that it is less likely to break in the future. The other reason is that
for SEV-ES guests the code needs to setup its own page-table to map the
GHCB unencrypted. Without these patches the pre-decompression code only
uses its own page-table when KASLR is enabled and used.

SIPI and INIT Handling
----------------------

The hypervisor also can't make changes to the guest register state,
which implies that it can't emulate SIPI and INIT messages. This means
that any CPU register state reset needs to be done inside the guest.
Most of this is handled in the firmware, but the Linux kernel has to
setup an AP Jump Table to boot secondary processors. CPU online/offline
handling also needs special handling, where this patch-set implements a
shortcut. An offlined CPU will not go back to real-mode when it is woken
up again, but stays in long-mode an just jumps back to the trampoline
code.

NMI Special Handling
--------------------

The last thing that needs special handling with SEV-ES are NMIs.
Hypervisors usually start to intercept IRET instructions when an NMI got
injected to find out when the NMI window is re-opened. But handling IRET
intercepts requires the hypervisor to access guest register state and is
not possible with SEV-ES. The specification under [1] solves this
problem with an NMI_COMPLETE message sent my the guest to the
hypervisor, upon which the hypervisor re-opens the NMI window for the
guest.

This patch-set sends the NMI_COMPLETE message before the actual IRET,
while the kernel is still on a valid stack and kernel cr3. This opens
the NMI-window a few instructions early, but this is fine as under
x86-64 Linux NMI-nesting is safe. The alternative would be to
single-step over the IRET, but that requires more intrusive changes to
the entry code because it does not handle entries from kernel-mode while
on the entry stack.

Besides the special handling above the patch-set contains the handlers
for the #VC exception and all the exit-codes specified in [1].

Current State of the Patches
============================

The patch-set posted here can boot an SMP Linux guest under
SEV-ES-enabled KVM and the guest survives some load-testing
(kernel-compiles).  The guest boots to the graphical desktop and is
usable. But there are still know bugs and issues:

	* Putting some NMI-load on the guest will make it crash usually
	  within a minute
	* The handler for MMIO events needs more security checks when
	  walking the page-table
	* The MMIO handler also lacks emulation for MOVS and REP MOVS
	  instructions like used by memcpy_toio() and memcpy_fromio().

More testing will likely uncover more bugs, but I think the patch-set is
ready for initial feedback. It grew pretty big already and handling it
becomes more and more painful.

So please review the parts of the patch-set that you find interesting
and let me know your feedback.

Thanks a lot,

       Joerg

[1] https://developer.amd.com/wp-content/resources/56421.pdf
[2] https://www.amd.com/system/files/TechDocs/24593.pdf

Doug Covelli (1):
  x86/vmware: Add VMware specific handling for VMMCALL under SEV-ES

Joerg Roedel (43):
  KVM: SVM: Add GHCB Accessor functions
  x86/traps: Move some definitions to <asm/trap_defs.h>
  x86/insn-decoder: Make inat-tables.c suitable for pre-decompression
    code
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
  x86/head/64: Install boot GDT
  x86/head/64: Reload GDT after switch to virtual addresses
  x86/head/64: Load segment registers earlier
  x86/head/64: Switch to initial stack earlier
  x86/head/64: Load IDT earlier
  x86/head/64: Move early exception dispatch to C code
  x86/sev-es: Add SEV-ES Feature Detection
  x86/sev-es: Compile early handler code into kernel image
  x86/sev-es: Setup early #VC handler
  x86/sev-es: Setup GHCB based boot #VC handler
  x86/sev-es: Wire up existing #VC exit-code handlers
  x86/sev-es: Handle instruction fetches from user-space
  x86/sev-es: Harden runtime #VC handler for exceptions from user-space
  x86/sev-es: Filter exceptions not supported from user-space
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
  x86/sev-es: Add handler for MMIO events
  x86/sev-es: Setup per-cpu GHCBs for the runtime handler
  x86/sev-es: Add Runtime #VC Exception Handler
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

 arch/x86/Kconfig                           |   1 +
 arch/x86/boot/Makefile                     |   2 +-
 arch/x86/boot/compressed/Makefile          |   8 +-
 arch/x86/boot/compressed/head_64.S         |  41 ++
 arch/x86/boot/compressed/ident_map_64.c    | 320 +++++++++
 arch/x86/boot/compressed/idt_64.c          |  53 ++
 arch/x86/boot/compressed/idt_handlers_64.S |  78 +++
 arch/x86/boot/compressed/kaslr.c           |  36 +-
 arch/x86/boot/compressed/kaslr_64.c        | 156 -----
 arch/x86/boot/compressed/misc.h            |  34 +-
 arch/x86/boot/compressed/sev-es.c          | 148 ++++
 arch/x86/entry/entry_64.S                  |  52 ++
 arch/x86/include/asm/cpu.h                 |   2 +-
 arch/x86/include/asm/cpufeatures.h         |   2 +
 arch/x86/include/asm/desc.h                |   2 +
 arch/x86/include/asm/desc_defs.h           |   3 +
 arch/x86/include/asm/fpu/internal.h        |  29 +-
 arch/x86/include/asm/fpu/xcr.h             |  32 +
 arch/x86/include/asm/mem_encrypt.h         |   5 +
 arch/x86/include/asm/msr-index.h           |   3 +
 arch/x86/include/asm/processor.h           |   1 +
 arch/x86/include/asm/realmode.h            |   4 +
 arch/x86/include/asm/segment.h             |   2 +-
 arch/x86/include/asm/sev-es.h              | 119 ++++
 arch/x86/include/asm/svm.h                 | 103 +++
 arch/x86/include/asm/trap_defs.h           |  50 ++
 arch/x86/include/asm/traps.h               |  51 +-
 arch/x86/include/asm/x86_init.h            |  16 +-
 arch/x86/include/uapi/asm/svm.h            |  11 +
 arch/x86/kernel/Makefile                   |   1 +
 arch/x86/kernel/cpu/amd.c                  |  10 +-
 arch/x86/kernel/cpu/scattered.c            |   1 +
 arch/x86/kernel/cpu/vmware.c               |  48 +-
 arch/x86/kernel/head64.c                   |  49 ++
 arch/x86/kernel/head_32.S                  |   4 +-
 arch/x86/kernel/head_64.S                  | 162 +++--
 arch/x86/kernel/idt.c                      |  60 +-
 arch/x86/kernel/kvm.c                      |  35 +-
 arch/x86/kernel/nmi.c                      |   8 +
 arch/x86/kernel/sev-es-shared.c            | 721 ++++++++++++++++++++
 arch/x86/kernel/sev-es.c                   | 748 +++++++++++++++++++++
 arch/x86/kernel/smpboot.c                  |   4 +-
 arch/x86/kernel/traps.c                    |   3 +
 arch/x86/mm/extable.c                      |   1 +
 arch/x86/mm/mem_encrypt.c                  |  11 +-
 arch/x86/mm/mem_encrypt_identity.c         |   3 +
 arch/x86/realmode/init.c                   |  12 +
 arch/x86/realmode/rm/header.S              |   3 +
 arch/x86/realmode/rm/trampoline_64.S       |  20 +
 arch/x86/tools/gen-insn-attr-x86.awk       |  50 +-
 tools/arch/x86/tools/gen-insn-attr-x86.awk |  50 +-
 51 files changed, 3016 insertions(+), 352 deletions(-)
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

