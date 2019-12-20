Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8989D127210
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 01:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfLTANb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Dec 2019 19:13:31 -0500
Received: from mga06.intel.com ([134.134.136.31]:64772 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726964AbfLTANb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Dec 2019 19:13:31 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2019 16:13:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,333,1571727600"; 
   d="scan'208";a="241340277"
Received: from gza.jf.intel.com ([10.54.75.28])
  by fmsmga004.fm.intel.com with ESMTP; 19 Dec 2019 16:13:29 -0800
From:   John Andersen <john.s.andersen@intel.com>
To:     kvm@vger.kernel.org
Cc:     John Andersen <john.s.andersen@intel.com>
Subject: [RFC 0/2] Paravirtualized Control Register pinning
Date:   Thu, 19 Dec 2019 16:13:20 -0800
Message-Id: <20191220001322.22317-1-john.s.andersen@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
guests use to identify which bits they may request be pinned, and
CR pinned MSRs which contain the pinned bits. Guests can request that
KVM pin bits within control register 0 or 4 via the CR pinned MSRs.
Writes to the MSRs fail if they include bits that aren't allowed to be
pinned. Host userspace may clear or modify pinned bits at any time.
Once pinned bits are set, the guest may pin more allowed bits, but may
never clear pinned bits.

In the event that the guest vcpu attempts to disable any of the pinned
bits, the vcpu that issued the write is sent a general protection
fault, and the register is left unchanged.

Pinning is not active when running in SMM. Entering SMM disables pinned
bits, writes to control registers within SMM would therefore trigger
general protection faults if pinning was enforced.

The guest may never read pinned bits. If an attacker were to read the
CR pinned MSRs, they might decide to preform another attack which would
not cause a general protection fault.

Should userspace expose the CR pining CPUID feature bit, it must zero CR
pinned MSRs on reboot. If it does not, it runs the risk of having the
guest enable pinning and subsequently cause general protection faults on
next boot due to early boot code setting control registers to values
which do not contain the pinned bits.

When running with KVM guest support and paravirtualized CR pinning
enabled, paravirtualized and existing pinning are setup at the same
point on the boot CPU. Non-boot CPUs setup pinning upon identification.

Guests using the kexec system call currently do not support
paravirtualized control register pinning. This is due to early boot
code writing known good values to control registers, these values do
not contain the protected bits. This is due to CPU feature
identification being done at a later time, when the kernel properly
checks if it can enable protections.

Most distributions enable kexec. However, kexec could be made boot time
disableable. In this case if a user has disabled kexec at boot time
the guest will request that paravirtualized control register pinning
be enabled. This would expand the userbase to users of major
distributions.

Paravirtualized CR pinning will likely be incompatible with kexec for
the foreseeable future. Early boot code could possibly be changed to
not clear protected bits. However, a kernel that requests CR bits be
pinned can't know if the kernel it's kexecing has been updated to not
clear protected bits. This would result in the kernel being kexec'd
almost immediately receiving a general protection fault.

Security conscious kernel configurations disable kexec already, per KSPP
guidelines. Projects such as Kata Containers, AWS Lambda, ChromeOS
Termina, and others using KVM to virtualize Linux will benefit from
this protection.

The usage of SMM in SeaBIOS was explored as a way to communicate to KVM
that a reboot has occurred and it should zero the pinned bits. When
using QEMU and SeaBIOS, SMM initialization occurs on reboot. However,
prior to SMM initialization, BIOS writes zero values to CR0, causing a
general protection fault to be sent to the guest before SMM can signal
that the machine has booted.

Pinning of sensitive CR bits has already been implemented to protect
against exploits directly calling native_write_cr*(). The current
protection cannot stop ROP attacks which jump directly to a MOV CR
instruction. Guests running with paravirtualized CR pinning are now
protected against the use of ROP to disable CR bits. The same bits that
are being pinned natively may be pinned via the CR pinned MSRs. These
bits are WP in CR0, and SMEP, SMAP, and UMIP in CR4.

Future patches could implement similar MSR and hypercall combinations
to protect bits in MSRs. The NXE bit of the EFER MSR is a prime
candidate.

John Andersen (2):
  KVM: X86: Add CR pin MSRs
  X86: Use KVM CR pin MSRs

 Documentation/virt/kvm/msr.txt       | 38 +++++++++++++++++++++++
 arch/x86/Kconfig                     |  9 ++++++
 arch/x86/include/asm/kvm_host.h      |  2 ++
 arch/x86/include/asm/kvm_para.h      | 10 +++++++
 arch/x86/include/uapi/asm/kvm_para.h |  5 ++++
 arch/x86/kernel/cpu/common.c         |  5 ++++
 arch/x86/kernel/kvm.c                | 17 +++++++++++
 arch/x86/kvm/cpuid.c                 |  3 +-
 arch/x86/kvm/x86.c                   | 45 ++++++++++++++++++++++++++++
 9 files changed, 133 insertions(+), 1 deletion(-)

-- 
2.21.0

