Return-Path: <kvm+bounces-3517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 277108051F7
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 12:21:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A73E1C20BEE
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:21:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7067558120;
	Tue,  5 Dec 2023 11:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TcEj5h9N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8259E;
	Tue,  5 Dec 2023 03:21:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701775279; x=1733311279;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CTJMCsqO4pq6z+5Iad0prB2mBV/JKDBtPQe8pvTOcU8=;
  b=TcEj5h9NPBHuM5SPQyJEsvMvrlG7ZA04bWectTWECyEOcwZRGHJAyJYm
   WhUTopJuiVcPunHESEj5KlNADnl9E/KAP78tMiKs4Z+KRkgivsxQVMwfl
   /VzxErDO/Yy8ODvfvqzu+jvPAHmDoVv8uXcyV/qLQ4u3HkHl7UxhBBrC8
   lbPofMJUMf8njoYxzW1OfMtx1oXzMu+dnKv/8BvKz6VJ84J2eY8d2o41d
   qIxhha63h+oKrPVB5wAjhwjH/ZroNpjUawnSP1impdvFHN75+tQLlydIJ
   zTFxpdvwVc95Rd6kpxCF96vLtAARuydfSEZqLONVbo3WN6nQd1Rk2EPg1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="942307"
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="942307"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 03:21:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="1018192891"
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="1018192891"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga006.fm.intel.com with ESMTP; 05 Dec 2023 03:21:15 -0800
From: Xin Li <xin3.li@intel.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	peterz@infradead.org,
	jgross@suse.com,
	ravi.v.shankar@intel.com,
	mhiramat@kernel.org,
	andrew.cooper3@citrix.com,
	jiangshanlai@gmail.com,
	nik.borisov@suse.com,
	shan.kang@intel.com
Subject: [PATCH v13 00/35] x86: enable FRED for x86-64
Date: Tue,  5 Dec 2023 02:49:49 -0800
Message-ID: <20231205105030.8698-1-xin3.li@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch set enables the Intel flexible return and event delivery
(FRED) architecture for x86-64.

The FRED architecture defines simple new transitions that change
privilege level (ring transitions). The FRED architecture was
designed with the following goals:

1) Improve overall performance and response time by replacing event
   delivery through the interrupt descriptor table (IDT event
   delivery) and event return by the IRET instruction with lower
   latency transitions.

2) Improve software robustness by ensuring that event delivery
   establishes the full supervisor context and that event return
   establishes the full user context.

The new transitions defined by the FRED architecture are FRED event
delivery and, for returning from events, two FRED return instructions.
FRED event delivery can effect a transition from ring 3 to ring 0, but
it is used also to deliver events incident to ring 0. One FRED
instruction (ERETU) effects a return from ring 0 to ring 3, while the
other (ERETS) returns while remaining in ring 0. Collectively, FRED
event delivery and the FRED return instructions are FRED transitions.

Search for the latest FRED spec in most search engines with this search pattern:

  site:intel.com FRED (flexible return and event delivery) specification

As of now there is no publicly avaiable CPU supporting FRED, thus the Intel
Simics® Simulator is used as software development and testing vehicles. And
it can be downloaded from:
  https://www.intel.com/content/www/us/en/developer/articles/tool/simics-simulator.html

To enable FRED, the Simics package 8112 QSP-CPU needs to be installed with
CPU model configured as:
	$cpu_comp_class = "x86-experimental-fred"


Changes since v12:
* Merge the 3 WRMSRNS patches into one (Borislav Petkov).
* s/cpu/CPU/g (Borislav Petkov).
* Shorten the WRMSRNS description (Borislav Petkov).
* Put comments ontop, not on the side (Borislav Petkov).
* Use the ASCII char ' (char number 0x27), instead of its unicode char
  (Borislav Petkov).
* No "we" in a commit message, use passive voice (Borislav Petkov).
* Fix confusing Signed-off-by chains (Borislav Petkov).

Changes since v11:
* Add a new structure fred_cs to denote the FRED flags above CS
  selector as what is done for SS (H. Peter Anvin).

Changes since v10:
* No need to invalidate SYSCALL and SYSENTER MSRs (Thomas Gleixner).
* Better explain the reason why no need to check current stack level
  (Paolo Bonzini).
* Replace "IS_ENABLED(CONFIG_IA32_EMULATION)" with the new ia32_enabled()
  API (Nikolay Borisov).
* FRED feature is defined in cpuid word 12, not 13 (Nikolay Borisov).
* Reword a sentence in the new FRED documentation to improve readability
  (Nikolay Borisov).
* A few comment fixes and improvements to event type definitions
  (Andrew Cooper).

Changes since v9:
* Set unused sysvec table entries to fred_handle_spurious_interrupt()
  in fred_complete_exception_setup() (Thomas Gleixner).
* Shove the whole thing into arch/x86/entry/entry_64_fred.S for invoking
  external_interrupt() and fred_exc_nmi() (Sean Christopherson).
* Correct and improve a few comments (Sean Christopherson).
* Merge the two IRQ/NMI asm entries into one as it's fine to invoke
  noinstr code from regular code (Thomas Gleixner).
* Setup the long mode and NMI flags in the augmented SS field of FRED
  stack frame in C instead of asm (Thomas Gleixner).
* Don't use jump tables, indirect jumps are expensive (Thomas Gleixner).
* Except #NMI/#DB/#MCE, FRED really can share the exception handlers
  with IDT (Thomas Gleixner).
* Avoid the sysvec_* idt_entry muck, do it at a central place, reuse code
  instead of blindly copying it, which breaks the performance optimized
  sysvec entries like reschedule_ipi (Thomas Gleixner).
* Add asm_ prefix to FRED asm entry points (Thomas Gleixner).
* Disable #DB to avoid endless recursion and stack overflow when a
  watchpoint/breakpoint is set in the code path which is executed by
  #DB handler (Thomas Gleixner).
* Introduce a new structure fred_ss to denote the FRED flags above SS
  selector, which avoids FRED_SSX_ macros and makes the code simpler
  and easier to read (Thomas Gleixner).
* Use type u64 to define FRED bit fields instead of type unsigned int
  (Thomas Gleixner).
* Avoid a type cast by defining X86_CR4_FRED as 0 on 32-bit (Thomas
  Gleixner).
* Add the WRMSRNS instruction support (Thomas Gleixner).

Changes since v8:
* Move the FRED initialization patch after all required changes are in
  place (Thomas Gleixner).
* Don't do syscall early out in fred_entry_from_user() before there are
  proper performance numbers and justifications (Thomas Gleixner).
* Add the control exception handler to the FRED exception handler table
  (Thomas Gleixner).
* Introduce a macro sysvec_install() to derive the asm handler name from
  a C handler, which simplifies the code and avoids an ugly typecast
  (Thomas Gleixner).
* Remove junk code that assumes no local APIC on x86_64 (Thomas Gleixner).
* Put IDTENTRY changes in a separate patch (Thomas Gleixner).
* Use high-order 48 bits above the lowest 16 bit SS only when FRED is
  enabled (Thomas Gleixner).
* Explain why writing directly to the IA32_KERNEL_GS_BASE MSR is
  doing the right thing (Thomas Gleixner).
* Reword some patch descriptions (Thomas Gleixner).
* Add a new macro VMX_DO_FRED_EVENT_IRQOFF for FRED instead of
  refactoring VMX_DO_EVENT_IRQOFF (Sean Christopherson).
* Do NOT use a trampoline, just LEA+PUSH the return RIP, PUSH the error
  code, and jump to the FRED kernel entry point for NMI or call
  external_interrupt() for IRQs (Sean Christopherson).
* Call external_interrupt() only when FRED is enabled, and convert the
  non-FRED handling to external_interrupt() after FRED lands (Sean
  Christopherson).
* Use __packed instead of __attribute__((__packed__)) (Borislav Petkov).
* Put all comments above the members, like the rest of the file does
  (Borislav Petkov).
* Reflect the FRED spec 5.0 change that ERETS and ERETU add 8 to %rsp
  before popping the return context from the stack.
* Reflect stack frame definition changes from FRED spec 3.0 to 5.0.
* Add ENDBR to the FRED_ENTER asm macro after kernel IBT is added to
  FRED base line in FRED spec 5.0.
* Add a document which briefly introduces FRED features.
* Remove 2 patches, "allow FRED systems to use interrupt vectors
  0x10-0x1f" and "allow dynamic stack frame size", from this patch set,
  as they are "optimizations" only.
* Send 2 patches, "header file for event types" and "do not modify the
  DPL bits for a null selector", as pre-FRED patches.

Changes since v7:
* Always call external_interrupt() for VMX IRQ handling on x86_64, thus avoid
  re-entering the noinstr code.
* Create a FRED stack frame when FRED is compiled-in but not enabled, which
  uses some extra stack space but simplifies the code.
* Add a log message when FRED is enabled.

Changes since v6:
* Add a comment to explain why it is safe to write to a previous FRED stack
  frame. (Lai Jiangshan).
* Export fred_entrypoint_kernel(), required when kvm-intel built as a module.
* Reserve a REDZONE for CALL emulation and Align RSP to a 64-byte boundary
  before pushing a new FRED stack frame.
* Replace pt_regs csx flags prefix FRED_CSL_ with FRED_CSX_.

Changes since v5:
* Initialize system_interrupt_handlers with dispatch_table_spurious_interrupt()
  instead of NULL to get rid of a branch (Peter Zijlstra).
* Disallow #DB inside #MCE for robustness sake (Peter Zijlstra).
* Add a comment for FRED stack level settings (Lai Jiangshan).
* Move the NMI bit from an invalid stack frame, which caused ERETU to fault,
  to the fault handler's stack frame, thus to unblock NMI ASAP if NMI is blocked
  (Lai Jiangshan).
* Refactor VMX_DO_EVENT_IRQOFF to handle IRQ/NMI in IRQ/NMI induced VM exits
  when FRED is enabled (Sean Christopherson).

Changes since v4:
* Do NOT use the term "injection", which in the KVM context means to
  reinject an event into the guest (Sean Christopherson).
* Add the explanation of why to execute "int $2" to invoke the NMI handler
  in NMI caused VM exits (Sean Christopherson).
* Use cs/ss instead of csx/ssx when initializing the pt_regs structure
  for calling external_interrupt(), otherwise it breaks i386 build.

Changes since v3:
* Call external_interrupt() to handle IRQ in IRQ caused VM exits.
* Execute "int $2" to handle NMI in NMI caused VM exits.
* Rename csl/ssl of the pt_regs structure to csx/ssx (x for extended)
  (Andrew Cooper).

Changes since v2:
* Improve comments for changes in arch/x86/include/asm/idtentry.h.

Changes since v1:
* call irqentry_nmi_{enter,exit}() in both IDT and FRED debug fault kernel
  handler (Peter Zijlstra).
* Initialize a FRED exception handler to fred_bad_event() instead of NULL
  if no FRED handler defined for an exception vector (Peter Zijlstra).
* Push calling irqentry_{enter,exit}() and instrumentation_{begin,end}()
  down into individual FRED exception handlers, instead of in the dispatch
  framework (Peter Zijlstra).


H. Peter Anvin (Intel) (20):
  x86/fred: Add Kconfig option for FRED (CONFIG_X86_FRED)
  x86/cpufeatures: Add the CPU feature bit for FRED
  x86/fred: Disable FRED support if CONFIG_X86_FRED is disabled
  x86/opcode: Add ERET[US] instructions to the x86 opcode map
  x86/objtool: Teach objtool about ERET[US]
  x86/cpu: Add X86_CR4_FRED macro
  x86/cpu: Add MSR numbers for FRED configuration
  x86/fred: Add a new header file for FRED definitions
  x86/fred: Reserve space for the FRED stack frame
  x86/fred: Update MSR_IA32_FRED_RSP0 during task switch
  x86/fred: Disallow the swapgs instruction when FRED is enabled
  x86/fred: No ESPFIX needed when FRED is enabled
  x86/fred: Allow single-step trap and NMI when starting a new task
  x86/fred: Make exc_page_fault() work for FRED
  x86/fred: Add a debug fault entry stub for FRED
  x86/fred: Add a NMI entry stub for FRED
  x86/fred: FRED entry/exit and dispatch code
  x86/fred: Let ret_from_fork_asm() jmp to asm_fred_exit_user when FRED
    is enabled
  x86/fred: Add FRED initialization functions
  x86/fred: Invoke FRED initialization code to enable FRED

Peter Zijlstra (Intel) (1):
  x86/entry/calling: Allow PUSH_AND_CLEAR_REGS being used beyond actual
    entry code

Xin Li (14):
  x86/cpufeatures,opcode,msr: Add the WRMSRNS instruction support
  x86/entry: Remove idtentry_sysvec from entry_{32,64}.S
  x86/trapnr: Add event type macros to <asm/trapnr.h>
  Documentation/x86/64: Add a documentation for FRED
  x86/fred: Disable FRED by default in its early stage
  x86/ptrace: Cleanup the definition of the pt_regs structure
  x86/ptrace: Add FRED additional information to the pt_regs structure
  x86/idtentry: Incorporate definitions/declarations of the FRED entries
  x86/fred: Add a machine check entry stub for FRED
  x86/traps: Add sysvec_install() to install a system interrupt handler
  x86/fred: Fixup fault on ERETU by jumping to fred_entrypoint_user
  x86/entry: Add fred_entry_from_kvm() for VMX to handle IRQ/NMI
  KVM: VMX: Call fred_entry_from_kvm() for IRQ/NMI handling
  x86/syscall: Split IDT syscall setup code into idt_syscall_init()

 .../admin-guide/kernel-parameters.txt         |   3 +
 Documentation/arch/x86/x86_64/fred.rst        |  96 ++++++
 Documentation/arch/x86/x86_64/index.rst       |   1 +
 arch/x86/Kconfig                              |   9 +
 arch/x86/entry/Makefile                       |   5 +-
 arch/x86/entry/calling.h                      |  15 +-
 arch/x86/entry/entry_32.S                     |   4 -
 arch/x86/entry/entry_64.S                     |  14 +-
 arch/x86/entry/entry_64_fred.S                | 133 +++++++++
 arch/x86/entry/entry_fred.c                   | 279 ++++++++++++++++++
 arch/x86/entry/vsyscall/vsyscall_64.c         |   2 +-
 arch/x86/include/asm/asm-prototypes.h         |   1 +
 arch/x86/include/asm/cpufeatures.h            |   2 +
 arch/x86/include/asm/desc.h                   |   2 -
 arch/x86/include/asm/disabled-features.h      |   8 +-
 arch/x86/include/asm/extable_fixup_types.h    |   4 +-
 arch/x86/include/asm/fred.h                   |  97 ++++++
 arch/x86/include/asm/idtentry.h               |  88 +++++-
 arch/x86/include/asm/msr-index.h              |  13 +-
 arch/x86/include/asm/msr.h                    |  18 ++
 arch/x86/include/asm/ptrace.h                 | 104 ++++++-
 arch/x86/include/asm/switch_to.h              |   8 +-
 arch/x86/include/asm/thread_info.h            |  12 +-
 arch/x86/include/asm/trapnr.h                 |  12 +
 arch/x86/include/asm/vmx.h                    |  17 +-
 arch/x86/include/uapi/asm/processor-flags.h   |   7 +
 arch/x86/kernel/Makefile                      |   1 +
 arch/x86/kernel/cpu/acrn.c                    |   4 +-
 arch/x86/kernel/cpu/common.c                  |  41 ++-
 arch/x86/kernel/cpu/cpuid-deps.c              |   2 +
 arch/x86/kernel/cpu/mce/core.c                |  26 ++
 arch/x86/kernel/cpu/mshyperv.c                |  15 +-
 arch/x86/kernel/espfix_64.c                   |   8 +
 arch/x86/kernel/fred.c                        |  59 ++++
 arch/x86/kernel/idt.c                         |   4 +-
 arch/x86/kernel/irqinit.c                     |   7 +-
 arch/x86/kernel/kvm.c                         |   2 +-
 arch/x86/kernel/nmi.c                         |  28 ++
 arch/x86/kernel/process_64.c                  |  67 ++++-
 arch/x86/kernel/traps.c                       |  48 ++-
 arch/x86/kvm/vmx/vmx.c                        |  12 +-
 arch/x86/lib/x86-opcode-map.txt               |   4 +-
 arch/x86/mm/extable.c                         |  79 +++++
 arch/x86/mm/fault.c                           |   5 +-
 drivers/xen/events/events_base.c              |   2 +-
 tools/arch/x86/include/asm/cpufeatures.h      |   2 +
 .../arch/x86/include/asm/disabled-features.h  |   8 +-
 tools/arch/x86/include/asm/msr-index.h        |  13 +-
 tools/arch/x86/lib/x86-opcode-map.txt         |   4 +-
 tools/objtool/arch/x86/decode.c               |  19 +-
 50 files changed, 1300 insertions(+), 114 deletions(-)
 create mode 100644 Documentation/arch/x86/x86_64/fred.rst
 create mode 100644 arch/x86/entry/entry_64_fred.S
 create mode 100644 arch/x86/entry/entry_fred.c
 create mode 100644 arch/x86/include/asm/fred.h
 create mode 100644 arch/x86/kernel/fred.c


base-commit: 5d868f6ec314aaee65ec5d12c03f18d79e632043
-- 
2.43.0


