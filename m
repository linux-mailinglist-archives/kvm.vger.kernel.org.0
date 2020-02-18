Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90AB6163599
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 22:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbgBRV63 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 16:58:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:52969 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbgBRV63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 16:58:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 13:58:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="436004632"
Received: from gza.jf.intel.com ([10.54.75.28])
  by fmsmga006.fm.intel.com with ESMTP; 18 Feb 2020 13:58:27 -0800
From:   John Andersen <john.s.andersen@intel.com>
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        pbonzini@redhat.com
Cc:     hpa@zytor.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        liran.alon@oracle.com, luto@kernel.org, joro@8bytes.org,
        rick.p.edgecombe@intel.com, kristen@linux.intel.com,
        arjan@linux.intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, John Andersen <john.s.andersen@intel.com>
Subject: [RFC v2 0/4] Paravirtualized Control Register pinning
Date:   Tue, 18 Feb 2020 13:58:58 -0800
Message-Id: <20200218215902.5655-1-john.s.andersen@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Many thanks to everyone who reviewed v1. Here are some notes on the
delta and feedback that was given. Thank you all for taking the time to
review and provide suggestions. I attempted to capture everything I
heard, please let me know if anything was missed. kexec support is
still pending, due to what follows about command line parameters, opt
in, and being that those changes wouldn't be localized to KVM (and this
patchset is on top of kvm/next).

- Hibernation and suspend-to-RAM are supported.

- As Paolo requested, a patch will be sent immediately following this
  patchset to kvm-unit-tests with the unit tests for general
  functionality. selftests are included for SMM specific functionality.

- Liran's catch of ensuring bits stay pinned after returning from SMM
  is now present. As a side note, CR values per AMD and Intel SDMs
  should be read-only within SMRAM. I attempted a patch to keep a copy
  of smstate in vcpu->arch which would later be used as the source of
  the read-only values. However, I ran into issues with VM/save load
  within the selftests. If someone has a better solution or knows where
  might be a good place to persist that across save/load please let me
  know.

- Andy's suggestion of a boot option has been incorporated as the
  pv_cr_pin command line option. Boris mentioned that short-term
  solutions become immutable. However, for the reasons outlined below
  we need a way for the user to opt-in to pinning over kexec if both
  are compiled in, and the command line parameter seems to be a good
  way to do that. Liran's proposed solution of a flag within the ELF
  would allow us to identify which kernels have support is assumed to
  be implemented in the following scenarios.

  We then have the following cases (without the addition of pv_cr_pin):


  - Kernel running without pinning enabled kexecs kernel with pinning.

    - Loaded kernel has kexec

      - Do not enable pinning

    - Loaded kernel lacks kexec

      - Enable pinning

  - Kernel running with pinning enabled kexecs kernel with pinning (as
    identified by ELF addition).

    - Okay

  - Kernel running with pinning enabled kexecs kernel without pinning
    (as identified by lack of ELF addition).

    - User is presented with an error saying that they may not kexec
      a kernel without pinning support.


  With the addition of pv_cr_pin we have the following situations:


  - Kernel running without pinning enabled kexecs kernel with pinning.

    - Loaded kernel has kexec

      - pv_cr_pin command line parameter present

        - Enable pinning

      - pv_cr_pin command line parameter not present

        - Do not enable pinning

    - Loaded kernel lacks kexec

      - Enable pinning

  - Kernel running with pinning enabled kexecs kernel with pinning (as
    identified by ELF addition).

    - Okay

  - Kernel running with pinning enabled kexecs kernel without pinning
    (as identified by lack of ELF addition).

    - pv_cr_pin command line parameter present

      - User is presented with an error saying that they have opted
	into pinning support and may not kexec a kernel without pinning
        support.

    - pv_cr_pin command line parameter not present

      - Pinning not enabled (not opted into), kexec succeeds


  Without the command line parameter I'm not sure how we could preserve
  users workflows which might rely on kexecing older kernels (ones
  which wouldn't have support). I see the benefit here being that users
  have to opt-in to the possibility of breaking their workflow, via
  their addition of the pv_cr_pin command line flag. Which could of
  course also be called nokexec. A deprecation period could then be
  chosen where eventually pinning takes preference over kexec and users
  are presented with the error if they try to kexec an older kernel.
  Input on this would be much appreciated, as well as if this is the
  best way to handle things or if there's another way that would be
  preferred. This is just what we were able to come up with to ensure
  users didn't get anything broken they didn't agree to have broken.



Paravirtualized Control Register pinning is a strengthened version of
existing protections on the Write Protect, Supervisor Mode Execution /
Access Protection, and User-Mode Instruction Prevention bits. The
existing protections prevent native_write_cr*() functions from writing
values which disable those bits. This patchset prevents any guest
writes to control registers from disabling pinned bits, not just writes
from native_write_cr*(). This stops attackers within the guest from
using ROP to disable protection bits.

https://web.archive.org/web/20171029060939/http://www.blackbunny.io/linux-kernel-x86-64-bypass-smep-kaslr-kptr_restric/

The protection is implemented by adding MSRs to KVM which contain the
bits that are allowed to be pinned, and the bits which are pinned. The
guest or userspace can enable bit pinning by reading MSRs to check
which bits are allowed to be pinned, and then writing MSRs to set which
bits they want pinned.

Other hypervisors such as HyperV have implemented similar protections
for Control Registers and MSRs; which security researchers have found
effective.

https://www.abatchy.com/2018/01/kernel-exploitation-4

We add a CR pin feature bit to the KVM cpuid, read only MSRs which
guests use to identify which bits they may request be pinned, and CR
pinned MSRs which contain the pinned bits. Guests can request that KVM
pin bits within control register 0 or 4 via the CR pinned MSRs.  Writes
to the MSRs fail if they include bits that aren't allowed to be pinned.
Host userspace may clear or modify pinned bits at any time.  Once
pinned bits are set, the guest may pin more allowed bits, but may never
clear pinned bits.

In the event that the guest vCPU attempts to disable any of the pinned
bits, the vCPU that issued the write is sent a general protection
fault, and the register is left unchanged.

When running with KVM guest support and paravirtualized CR pinning
enabled, paravirtualized and existing pinning are setup at the same
point on the boot CPU. Non-boot CPUs setup pinning upon identification.

Pinning is not active when running in SMM. Entering SMM disables pinned
bits. Writes to control registers within SMM would therefore trigger
general protection faults if pinning was enforced. Upon exit from SMM,
SMRAM is modified to ensure the values of CR0/4 that will be restored
contain the correct values for pinned bits. CR0/4 values are then
restored from SMRAM as usual.

Should userspace expose the CR pining CPUID feature bit, it must zero
CR pinned MSRs on reboot. If it does not, it runs the risk of having
the guest enable pinning and subsequently cause general protection
faults on next boot due to early boot code setting control registers to
values which do not contain the pinned bits.

Hibernation to disk and suspend-to-RAM are supported. identify_cpu was
updated to ensure SMEP/SMAP/UMIP are present in mmu_cr4_features. This
is necessary to ensure protections stay active during hibernation image
restoration.

Guests using the kexec system call currently do not support
paravirtualized control register pinning. This is due to early boot
code writing known good values to control registers, these values do
not contain the protected bits. This is due to CPU feature
identification being done at a later time, when the kernel properly
checks if it can enable protections. As such, the pv_cr_pin command
line option has been added which instructs the kernel to disable kexec
in favor of enabling paravirtualized control register pinning.
crashkernel is also disabled when the pv_cr_pin parameter is specified
due to its reliance on kexec.

When we make kexec compatible, we will still need a way for a kernel
with support to know if the kernel it is attempting to load has
support. If a kernel with this enabled attempts to kexec a kernel where
this is not supported, it would trigger a fault almost immediately.

Liran suggested adding a section to the built image acting as a flag to
signify support for being kexec'd by a kernel with pinning enabled.
Should that approach be implemented, it is likely that the command line
flag (pv_cr_pin) would still be desired for some deprecation period. We
wouldn't want the default behavior to change from being able to kexec
older kernels to not being able to, as this might break some users
workflows. Since we require that the user opt-in to break kexec we've
held off on attempting to fix kexec in this patchset. This way no one
sees any behavior they are not explicitly opting in to.

Security conscious kernel configurations disable kexec already, per
KSPP guidelines. Projects such as Kata Containers, AWS Lambda, ChromeOS
Termina, and others using KVM to virtualize Linux will benefit from
this protection without the need to specify pv_cr_pin on the command
line.

Pinning of sensitive CR bits has already been implemented to protect
against exploits directly calling native_write_cr*(). The current
protection cannot stop ROP attacks which jump directly to a MOV CR
instruction. Guests running with paravirtualized CR pinning are now
protected against the use of ROP to disable CR bits. The same bits that
are being pinned natively may be pinned via the CR pinned MSRs. These
bits are WP in CR0, and SMEP, SMAP, and UMIP in CR4.

Future patches could implement similar MSRs to protect bits in MSRs.
The NXE bit of the EFER MSR is a prime candidate.

John Andersen (4):
  X86: Update mmu_cr4_features during feature identification
  KVM: X86: Add CR pin MSRs
  selftests: kvm: add test for CR pinning with SMM
  X86: Use KVM CR pin MSRs

 .../admin-guide/kernel-parameters.txt         |  11 ++
 Documentation/virt/kvm/msr.rst                |  38 ++++
 arch/x86/Kconfig                              |  10 +
 arch/x86/include/asm/kvm_host.h               |   2 +
 arch/x86/include/asm/kvm_para.h               |  17 ++
 arch/x86/include/uapi/asm/kvm_para.h          |   5 +
 arch/x86/kernel/cpu/common.c                  |  11 +-
 arch/x86/kernel/kvm.c                         |  39 ++++
 arch/x86/kernel/setup.c                       |  12 +-
 arch/x86/kvm/cpuid.c                          |   3 +-
 arch/x86/kvm/x86.c                            | 130 ++++++++++++-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |   9 +
 .../selftests/kvm/x86_64/smm_cr_pin_test.c    | 180 ++++++++++++++++++
 15 files changed, 462 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/smm_cr_pin_test.c

-- 
2.21.0

