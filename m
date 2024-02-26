Return-Path: <kvm+bounces-9863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D65D8678A5
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:35:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 915B7B283C4
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:35:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4BAE12B175;
	Mon, 26 Feb 2024 14:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lJUD8cfG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30E560DCB;
	Mon, 26 Feb 2024 14:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958053; cv=none; b=R+2Eh6WYx2w4jtqcm/JkxEoWxAvQrSFpoDm92cOD4kvYxP6gP7MvfSQgT1eUhLnI2lRDyhhZPgwjtJg7YlsbZhhnCTPriYMWdjLclhC/+OFK8ZXTj2R5Uwa5+g9dRQ5YqLeXvcCiS8toAQUUHoyUyLxkXRWMtkxgh1Ll72OWyXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958053; c=relaxed/simple;
	bh=vcbUHufROzppyQjoIxkULiv+lfFzN4BwPJoVWA6nuIM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=itxagsGQZ70aH87RKVwdlzAmgpO/YPPrhkWRu0mkCDPsTIYCcogVLchRLCR3aeqEwaTDxn/y5fRB2CqJpYkmhqhJhny6SMo/ZEDK8fJbIcqKEW3YMZmgoQy+/cTm9CvPoq49kpy3J10qtVA8aX1Ifpwrl7qwdj1P3wmm3D8s6g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lJUD8cfG; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-5dc949f998fso2108658a12.3;
        Mon, 26 Feb 2024 06:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958051; x=1709562851; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=t25uH2puf/UzSgQbWO6SwGj41zbXZ2MTmXL6cUJyp1k=;
        b=lJUD8cfGVPoH2a++tbktb/l/HRYfEy3t3UW1S90X8FnmUgQDl0SersgEYNsXPrwvzA
         9wzigtK6vrM1Lg/vVxfkFfaYhu1/FfMtbW/EOn6Pwbb99h3yP6QrKm4vmZgLvDSQ6zOq
         ocGp5NsngQwOAIZFTsZih1RMLzXCj0uiL9XGXUa41fGy1uDLUDs3PAmBh6RQjUs94Itx
         hg7/sEHsr8nKvmxtdf8vNZ4h9T5Q986sWW+kmIyV7cJ5lvWa3l+VG6Yya2gaymyCC5CT
         cXLrokr477ZnVWC1Tzf5VtCKUhMJGJVK2xYU3MsENXsWeMVFLsvYCLfd8h7qR2Ai6f23
         GT1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958051; x=1709562851;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t25uH2puf/UzSgQbWO6SwGj41zbXZ2MTmXL6cUJyp1k=;
        b=LEFWpiAiRTRqTqtIn0PY5Q54wEe11KusN1SkmN0FLDrYXOyTBF36CV6g1f4lJM4JbQ
         uJyXE5/yZFPQgcxmRN1++T5rGN2xXLrhIZLtXM5ufoCnkq4yxBlfhyN3gcHJJhf0tKaj
         egd9puhl3nRThqrvuEWzKDOANSYt06Ot3eRVDdp778qNe162v/bz+8fpJf8eR3fu6ECB
         p8SgO9+PCH2m7387lLhSdumALcRfzXgomstq/zzDmc7oOGE50Ch3QANBn3R5/PmjrsJt
         fJGaOe9Pao3zZUejUI6DxFWImFQxFBEAXIyMmLSisviJ+f/R9IShjojKsdhA7RVXceNu
         P+Cw==
X-Forwarded-Encrypted: i=1; AJvYcCU/px7m878akM/7X02n7Qy0IaMhH+4BDY4WK1cSGFF7KcUFI+RVAspzqmaR7l7kDQY1nhTVnkMo6Mw653+eWHAEmHuk
X-Gm-Message-State: AOJu0YyeoK0jizqSVRex10mcR0AWC3tLPWySb0BxxwPv1YJjjt9c1+Xi
	PIcxzNwgiYWv0kDfHaP/OlRRtrNOl1s4E7VOJt8m1NCSsIw5nklmqzdvYDC7
X-Google-Smtp-Source: AGHT+IFJBoGVieLf5XevT8WAWg2NJBGQw0jOm3JyNK4IJH6jr8hwlDT/wc93iYbWqC54cwInbnJ1Tg==
X-Received: by 2002:a17:90a:4094:b0:299:3354:feff with SMTP id l20-20020a17090a409400b002993354feffmr4131301pjg.30.1708958050550;
        Mon, 26 Feb 2024 06:34:10 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id r13-20020a17090ad40d00b0029a7df64720sm6308092pju.53.2024.02.26.06.34.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:34:10 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
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
	Hou Wenlong <houwenlong.hwl@antgroup.com>
Subject: [RFC PATCH 00/73] KVM: x86/PVM: Introduce a new hypervisor
Date: Mon, 26 Feb 2024 22:35:17 +0800
Message-Id: <20240226143630.33643-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

This RFC series proposes a new virtualization framework built upon the
KVM hypervisor that does not require hardware-assisted virtualization
techniques. PVM (Pagetable-based virtual machine) is implemented as a
new vendor for KVM x86, which is compatible with the KVM virtualization
software stack, such as Kata Containers, a secure container technique in
a cloud-native environment.

The work also led to a paper being accepted at SOSP 2023 [sosp-2023-acm]
[sosp-2023-pdf], and Lai delivered a presentation at the symposium in
Germany in October 2023 [sosp-2023-slides]:

	PVM: Efficient Shadow Paging for Deploying Secure Containers in
	Cloud-native Environment

PVM has been adopted by Alibaba Cloud and Ant Group in production to
host tens of thousands of secure containers daily, and it has also been
adopted by the Openanolis community.

Motivation
==========
A team in Ant Group, co-creator of Kata Containers along with Intel,
deploy the VM-based containers in our public cloud VM to satisfy dynamic
resource requests and various needs to isolate workloads. However, for
safety, nested virtualization is disabled in the L0 hypervisor, so we
cannot use KVM directly. Additionally, the current nested architecture
involves complex and expensive transitions between the L0 hypervisor and
L1 hypervisor.

So the over-arching goals of PVM are to completely decouple secure
container hosting from the host hypervisor and hardware virtualization
support to:
  1) enable nested virtualization within any IaaS clouds without affecting
  the security, flexibility, and complexity of the cloud platform;
  2) avoid costly exits to the host hypervisor and devise efficient world
  switching mechanisms.

Why PVM
=======
The PVM hypervisor has the following features:

- Compatible with KVM ecosystems.

- No requiremment for hardware assistance.  Many cloud provider doesn't
  enable nested virtualization.  And it can also enable KVM in TDX/SEV
  guests.

- Flexible. Businesses with secure containers can easily expand in the
  cloud when demand surges, instead of waiting to accquire bare metal.
  Cloud vendors often offer lower pricing for spot instances or
  preemptible VMs.

- Help for kernel CI with fast [re-]booting PVM guest kernels nested in
  cheeper VMs.

- Enable light-weight container kernels.

Design
======
The design detail can be found in our paper posted in SOSP2023.

The framework contains 3 main objects:

"Switcher" - The code and data that handling the VM enter and VM exit.

"PVM hypervisor" - A new vendor implementation for KVM x86, it uses
                   existed software emulation in KVM for virtualization,
                   e.g., shadow paging, APIC emulation, x86 instruction
                   emulator.

"PVM paravirtual guest" - A PIE linux kernel runs in hardware CPL3, and
                          use existed PVOPS to implement optimization.


                shadowed-user-pagetable shadowed-kernel-pagetable
                            +----------|-----------+
                            |   user   |  kernel   |
    h_ring3                 |  (umod)  |  (smod)   |
                            +---+------|--------+--+
                        syscall |    ^      ^   | hypercall/
            interrupt/exception |    |      |   | interrupt/exception
--------------------------------|----|------|---|------------------------------------
                                |    |sysret|   |
    h_ring0                     v    | /iret|   v
                              +------+------+----+
                              |     switcher     |
                              +---------+--------+
                            vm entry ^  | vm exit
                      (function call)|  v (function return)
      +..............................+..........................................+
      .                                                                         .
      .     +---------------+                      +--------------+             .
      .     |    kvm.ko     |                      |  kvm-pvm.ko  |             .
      .     +---------------+                      +--------------+             .
      .                         Virtualization                                  .
      .   memory virtualization                  CPU Virtualization             .
      +.........................................................................+
                                 PVM hypervisor


1. Switcher: To simplify, we reuse host entries to handle VM enter and
             VM exit, A flag is introduced to mark that the guest world
             is switched or during the switch in the entries. Therefore,
             the guest almost looks like a normal userspace process in
             the host.

2. Host MMU: The switcher needs to be accessed by the guest, which is
             similar to the CPU entry area for userspace in KPTI.
             Therefore, for simplification, we reserved a range of PGDs
             for the guest, and the guest kernel can only be allowed to
             run in this range. During the root SP allocation, the
             host PGDs of the switcher will be cloned into the guest
             SPT.

3. Event delivery: A new event delivery is used instead of the IDT-based
                   event delivery. The event delivery in PVM is similar
                   to FRED.

Design Decisions
================
In designing PVM, many decisions have been made and explained in the
patches. "Integral entry", "Exclusive address space separation and PIE
guest", and "Simple spec design" are among important decisions besides
for "KVM ecosystems" and "Ring3+Pagetable for privilege seperation".

Integral entry
--------------
The PVM switcher is integrated into the host kernel's entry code,
providing the following advantages:

- Full control: In XENPV/Lguest, the host Linux (dom0) entry code is
  subordinate to the hypervisor/switcher, and the host Linux kernel
  loses control over the entry code. This can cause inconvenience if
  there is a need to update something when there is a bug in the
  switcher or hardware.  Integral entry gives the control back to the
  host kernel.

- Zero overhead incurred: The integrated entry code doesn't cause any
  overhead in host Linux entry path, thanks to the discreet design with
  PVM code in the switcher, where the PVM path is bypassed on host events.
  While in XENPV/Lguest, host events must be handled by the
  hypervisor/switcher before being processed.

- Integral design allows all aspects of the entry and switcher to be
  considered together.

This RFC patchset doesn't include the complete design for integral
entry. It requires fixing the issue with IST [atomic-ist-entry].
And it would be better with the conversion of some ASM code to C code
[asm-to-c] (The link provided is not the final version, and some partial
patchset had sent separately later on). The new version of the patches
for converting ASM code and fixing the IST problem will be updated
and sent separately later.

Without the complete integral entry code, this patchset still has
unresolved issues related to IST, KPTI, and so on.

Exclusive address space separation and PIE guest
------------------------------------------------
In the higher half of the address spaces (where the most significant
bits in the addresses are 1s), the address ranges that a PVM guest is
allowed are exclusive from the host kernel.

- The exclusivity of the address makes it possible to design the
  integral entry because the switcher needs to be mapped for all
  guests.

- The exclusivity of the address allows the host kernel to still utilize
  global pages and save TLB entries. (XENPV doesn't allow it)

- With exclusivity, the existing shadow page table code can be reused
  with very few changes. The shadow page table contains both the guest
  portions and the host portions.

- Exclusivity necessitates the use of a Position-Independent Executable
  (PIE) guest since the host kernel occupies the top 2GB of the address
  space.

- With PIE kernel, the PVM guest kernel in hardware ring3 can be located
  in the lower half of the address spaces in the future when Linear
  Address Space Separation (LASS) is enabled.

This RFC patchset doesn't contain PIE patches which are not specific to
PVM and our effort to make linux kernel PIE continues.

Simple spec design
------------------
Designing a new paravirtualized guest is not an ideal opportunity to
redesign the specification. However, in order to avoid the known flaws
of x86_64 and enable the paravirtualized ABI on hardware ring3, the x86
PVM specification has some moderate differences from the x86
specification.

- Remove/Ignore most indirect tables and 32-bit supervisor mode.

- Simplified event delivery and the removal of IST.

- Add some software synthetic instructions.

See more details in the patch1 which contains the whole x86 PVM
specification.

Status
======
Current some features are not supported or disabled in PVM.

- SMAP/SMEP can't be enabled directly, however, we can use PKU to
  emulate SMAP and use NX to emulate SMEP.

- 5-level paging is not fully implemented.

- Speculative control for guest is disabled.

- LDT is not supported.

- PMU virtualization is not implemented. Actually, we have reused
  the current code in pmu_intel.c and pmu_amd.c to implement it.

PVM has been adopted in Alibaba Cloud and Ant Group for hosting secure
containers, providing a more performant and cost-effective option for
cloud users.

Performance drawback
====================
The most significant drawback of PVM is shadowpaging. Shadowpaging
results in very bad performance when guest applications frequently
modify pagetable, including excessive processes forking.

However, many long-running cloud services, such as Java, modify
pagetables less frequently and can perform very well with shadowpaging.
In some cases, they can even outperform EPT since they can avoid EPT TLB
entries. Furthermore, PVM can utilize host PCIDs for guest processes,
providing a finer-grained approach compared to VPID/ASID.

To mitigate the performance problem, we designed several optimizations
for the shadow MMU (not included in the patchset) and also planning to
build a shadow EPT in L0 for L2 PVM guests.

See the paper for more optimizations and the performance details.

Future plans
============
Some optimizations are not covered in this series now.

- Parallel Page fault for SPT and Paravirtualized MMU Optimization.

- Post interrupt emulation.

- Relocate guest kernel into userspace address range.

- More flexible container solutions based on it.

Patches layout
==============
[01-02]: PVM ABI documentation and header
[03-04]: Switcher implementation
[05-49]: PVM hypervisor implementation
       - 05-13: KVM module involved changes
       - 14-49: PVM module implementation
                patch 15: Add a vmalloc helper to reserve a kernel
                          address range for guest.
                patch 19: Export 32-bit ignore syscall for PVM.

[50-73]: PVM guest implementation
       - 50-52: Pack relocation information into vmlinux and allow
                it to do relocation.
       - 53: Introduce Kconfig and cpu features.
       - 54-59: Relocate guest kernel to the allowed range.
       - 60-65: Event handling and hypercall.
       - 66-69: PVOPS implementation.
       - 70-73: Disable some features and syscalls.

Code base
=========
The code base is at branch [linux-pie] which is commit ceb6a6f023fd
("Linu 6.7-rc6") + PIE series [pie-patchset].

Complete code can be found at [linux-pvm].

Testing
=======
Testing with Kata Containers can be found at [pvm-get-started].

We also provide a VM image based on the `Official Ubuntu Cloud Image`,
which has containerd, kata, pvm hypervisor/guest, and configurations
prepared and you can use to test Kata Containers with PVM directly.
[pvm-get-started-nested-in-vm]



[sosp-2023-acm]: https://dl.acm.org/doi/10.1145/3600006.3613158
[sosp-2023-pdf]: https://github.com/virt-pvm/misc/blob/main/sosp2023-pvm-paper.pdf
[sosp-2023-slides]: https://github.com/virt-pvm/misc/blob/main/sosp2023-pvm-slides.pptx
[asm-to-c]: https://lore.kernel.org/lkml/20211126101209.8613-1-jiangshanlai@gmail.com/
[atomic-ist-entry]: https://lore.kernel.org/lkml/20230403140605.540512-1-jiangshanlai@gmail.com/
[pie-patchset]: https://lore.kernel.org/lkml/cover.1682673542.git.houwenlong.hwl@antgroup.com
[linux-pie]: https://github.com/virt-pvm/linux/tree/pie
[linux-pvm]: https://github.com/virt-pvm/linux/tree/pvm
[pvm-get-started]: https://github.com/virt-pvm/misc/blob/main/pvm-get-started-with-kata.md
[pvm-get-started-nested-in-vm]: https://github.com/virt-pvm/misc/blob/main/pvm-get-started-with-kata.md#verify-kata-containers-with-pvm-using-vm-image



Hou Wenlong (22):
  KVM: x86: Allow hypercall handling to not skip the instruction
  KVM: x86: Implement gpc refresh for guest usage
  KVM: x86/emulator: Reinject #GP if instruction emulation failed for
    PVM
  mm/vmalloc: Add a helper to reserve a contiguous and aligned kernel
    virtual area
  x86/entry: Export 32-bit ignore syscall entry and __ia32_enabled
    variable
  KVM: x86/PVM: Support for kvm_exit() tracepoint
  KVM: x86/PVM: Support for CPUID faulting
  x86/tools/relocs: Cleanup cmdline options
  x86/tools/relocs: Append relocations into input file
  x86/boot: Allow to do relocation for uncompressed kernel
  x86/pvm: Relocate kernel image to specific virtual address range
  x86/pvm: Relocate kernel image early in PVH entry
  x86/pvm: Make cpu entry area and vmalloc area variable
  x86/pvm: Relocate kernel address space layout
  x86/pvm: Allow to install a system interrupt handler
  x86/pvm: Add early kernel event entry and dispatch code
  x86/pvm: Enable PVM event delivery
  x86/pvm: Use new cpu feature to describe XENPV and PVM
  x86/pvm: Don't use SWAPGS for gsbase read/write
  x86/pvm: Adapt pushf/popf in this_cpu_cmpxchg16b_emu()
  x86/pvm: Use RDTSCP as default in vdso_read_cpunode()
  x86/pvm: Disable some unsupported syscalls and features

Lai Jiangshan (51):
  KVM: Documentation: Add the specification for PVM
  x86/ABI/PVM: Add PVM-specific ABI header file
  x86/entry: Implement switcher for PVM VM enter/exit
  x86/entry: Implement direct switching for the switcher
  KVM: x86: Set 'vcpu->arch.exception.injected' as true before vendor
    callback
  KVM: x86: Move VMX interrupt/nmi handling into kvm.ko
  KVM: x86/mmu: Adapt shadow MMU for PVM
  KVM: x86: Add PVM virtual MSRs into emulated_msrs_all[]
  KVM: x86: Introduce vendor feature to expose vendor-specific CPUID
  KVM: x86: Add NR_VCPU_SREG in SREG enum
  KVM: x86: Create stubs for PVM module as a new vendor
  KVM: x86/PVM: Implement host mmu initialization
  KVM: x86/PVM: Implement module initialization related callbacks
  KVM: x86/PVM: Implement VM/VCPU initialization related callbacks
  KVM: x86/PVM: Implement vcpu_load()/vcpu_put() related callbacks
  KVM: x86/PVM: Implement vcpu_run() callbacks
  KVM: x86/PVM: Handle some VM exits before enable interrupts
  KVM: x86/PVM: Handle event handling related MSR read/write operation
  KVM: x86/PVM: Introduce PVM mode switching
  KVM: x86/PVM: Implement APIC emulation related callbacks
  KVM: x86/PVM: Implement event delivery flags related callbacks
  KVM: x86/PVM: Implement event injection related callbacks
  KVM: x86/PVM: Handle syscall from user mode
  KVM: x86/PVM: Implement allowed range checking for #PF
  KVM: x86/PVM: Implement segment related callbacks
  KVM: x86/PVM: Implement instruction emulation for #UD and #GP
  KVM: x86/PVM: Enable guest debugging functions
  KVM: x86/PVM: Handle VM-exit due to hardware exceptions
  KVM: x86/PVM: Handle ERETU/ERETS synthetic instruction
  KVM: x86/PVM: Handle PVM_SYNTHETIC_CPUID synthetic instruction
  KVM: x86/PVM: Handle KVM hypercall
  KVM: x86/PVM: Use host PCID to reduce guest TLB flushing
  KVM: x86/PVM: Handle hypercalls for privilege instruction emulation
  KVM: x86/PVM: Handle hypercall for CR3 switching
  KVM: x86/PVM: Handle hypercall for loading GS selector
  KVM: x86/PVM: Allow to load guest TLS in host GDT
  KVM: x86/PVM: Enable direct switching
  KVM: x86/PVM: Implement TSC related callbacks
  KVM: x86/PVM: Add dummy PMU related callbacks
  KVM: x86/PVM: Handle the left supported MSRs in msrs_to_save_base[]
  KVM: x86/PVM: Implement system registers setting callbacks
  KVM: x86/PVM: Implement emulation for non-PVM mode
  x86/pvm: Add Kconfig option and the CPU feature bit for PVM guest
  x86/pvm: Detect PVM hypervisor support
  x86/pti: Force enabling KPTI for PVM guest
  x86/pvm: Add event entry/exit and dispatch code
  x86/pvm: Add hypercall support
  x86/kvm: Patch KVM hypercall as PVM hypercall
  x86/pvm: Implement cpu related PVOPS
  x86/pvm: Implement irq related PVOPS
  x86/pvm: Implement mmu related PVOPS

 Documentation/virt/kvm/x86/pvm-spec.rst  |  989 +++++++
 arch/x86/Kconfig                         |   32 +
 arch/x86/Makefile.postlink               |    9 +-
 arch/x86/entry/Makefile                  |    4 +
 arch/x86/entry/calling.h                 |   47 +-
 arch/x86/entry/common.c                  |    1 +
 arch/x86/entry/entry_64.S                |   75 +-
 arch/x86/entry/entry_64_pvm.S            |  189 ++
 arch/x86/entry/entry_64_switcher.S       |  270 ++
 arch/x86/entry/vsyscall/vsyscall_64.c    |    4 +
 arch/x86/include/asm/alternative.h       |   14 +
 arch/x86/include/asm/cpufeatures.h       |    2 +
 arch/x86/include/asm/disabled-features.h |    8 +-
 arch/x86/include/asm/idtentry.h          |   12 +-
 arch/x86/include/asm/init.h              |    5 +
 arch/x86/include/asm/kvm-x86-ops.h       |    2 +
 arch/x86/include/asm/kvm_host.h          |   30 +-
 arch/x86/include/asm/kvm_para.h          |    7 +
 arch/x86/include/asm/page_64.h           |    3 +
 arch/x86/include/asm/paravirt.h          |   14 +-
 arch/x86/include/asm/pgtable_64_types.h  |   14 +-
 arch/x86/include/asm/processor.h         |    5 +
 arch/x86/include/asm/ptrace.h            |    5 +
 arch/x86/include/asm/pvm_para.h          |  103 +
 arch/x86/include/asm/segment.h           |   14 +-
 arch/x86/include/asm/switcher.h          |  119 +
 arch/x86/include/uapi/asm/kvm_para.h     |    8 +-
 arch/x86/include/uapi/asm/pvm_para.h     |  131 +
 arch/x86/kernel/Makefile                 |    1 +
 arch/x86/kernel/asm-offsets_64.c         |   31 +
 arch/x86/kernel/cpu/common.c             |   11 +
 arch/x86/kernel/head64.c                 |   10 +
 arch/x86/kernel/head64_identity.c        |  108 +-
 arch/x86/kernel/head_64.S                |   34 +
 arch/x86/kernel/idt.c                    |    2 +
 arch/x86/kernel/kvm.c                    |    2 +
 arch/x86/kernel/ldt.c                    |    3 +
 arch/x86/kernel/nmi.c                    |    8 +-
 arch/x86/kernel/process_64.c             |   10 +-
 arch/x86/kernel/pvm.c                    |  579 ++++
 arch/x86/kernel/traps.c                  |    3 +
 arch/x86/kernel/vmlinux.lds.S            |   18 +
 arch/x86/kvm/Kconfig                     |    9 +
 arch/x86/kvm/Makefile                    |    5 +-
 arch/x86/kvm/cpuid.c                     |   26 +-
 arch/x86/kvm/cpuid.h                     |    3 +
 arch/x86/kvm/host_entry.S                |   50 +
 arch/x86/kvm/mmu/mmu.c                   |   36 +-
 arch/x86/kvm/mmu/paging_tmpl.h           |    3 +
 arch/x86/kvm/mmu/spte.c                  |    4 +
 arch/x86/kvm/pvm/host_mmu.c              |  119 +
 arch/x86/kvm/pvm/pvm.c                   | 3257 ++++++++++++++++++++++
 arch/x86/kvm/pvm/pvm.h                   |  169 ++
 arch/x86/kvm/svm/svm.c                   |    4 +
 arch/x86/kvm/trace.h                     |    7 +-
 arch/x86/kvm/vmx/vmenter.S               |   43 -
 arch/x86/kvm/vmx/vmx.c                   |   18 +-
 arch/x86/kvm/x86.c                       |   33 +-
 arch/x86/kvm/x86.h                       |   18 +
 arch/x86/mm/dump_pagetables.c            |    3 +-
 arch/x86/mm/kaslr.c                      |    8 +-
 arch/x86/mm/pti.c                        |    7 +
 arch/x86/platform/pvh/enlighten.c        |   22 +
 arch/x86/platform/pvh/head.S             |    4 +
 arch/x86/tools/relocs.c                  |   88 +-
 arch/x86/tools/relocs.h                  |   20 +-
 arch/x86/tools/relocs_common.c           |   38 +-
 arch/x86/xen/enlighten_pv.c              |    1 +
 include/linux/kvm_host.h                 |   10 +
 include/linux/vmalloc.h                  |    2 +
 include/uapi/Kbuild                      |    4 +
 mm/vmalloc.c                             |   10 +
 virt/kvm/pfncache.c                      |    2 +-
 73 files changed, 6793 insertions(+), 166 deletions(-)
 create mode 100644 Documentation/virt/kvm/x86/pvm-spec.rst
 create mode 100644 arch/x86/entry/entry_64_pvm.S
 create mode 100644 arch/x86/entry/entry_64_switcher.S
 create mode 100644 arch/x86/include/asm/pvm_para.h
 create mode 100644 arch/x86/include/asm/switcher.h
 create mode 100644 arch/x86/include/uapi/asm/pvm_para.h
 create mode 100644 arch/x86/kernel/pvm.c
 create mode 100644 arch/x86/kvm/host_entry.S
 create mode 100644 arch/x86/kvm/pvm/host_mmu.c
 create mode 100644 arch/x86/kvm/pvm/pvm.c
 create mode 100644 arch/x86/kvm/pvm/pvm.h

-- 
2.19.1.6.gb485710b


