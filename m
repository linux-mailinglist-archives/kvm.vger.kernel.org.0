Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 973911098A7
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 06:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbfKZFZJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 00:25:09 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:56447 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbfKZFZJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 00:25:09 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 47MXR43wDqz9sPZ; Tue, 26 Nov 2019 16:25:04 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1574745904; bh=wPLhJcunPY8dkJ+oWckDI2juIpu0G8ZeGW0AcJ2jvJI=;
        h=Date:From:To:Cc:Subject:From;
        b=OrrjmxLzDliZAKH/FxojbSzirNUahnWtylp+5b9FlRKDxK9CaXMPRu1XavOD7DUVV
         x3B0nporBsgbWMTqcniJvYz4mssTpADGe/3pHGbZCxrFdhuSCb2Qp2FiVP7J9TB4DN
         2Ppc9p3E3126V1IijWTK6HAaBi/X4KkF+a+iml2VQyqmvKrXWYTIHbxwFAPhsa/++M
         IXpI8f0ZUdUjwfvHAoh7qgTSkSvYQvMV2GCsZRm+dvFVZmElnc7EWud5d9PTmqfsja
         lPgbeCQY75u9umHINWzDpPWF/TRFRUIfrCq3jdRbpuXtSw+6cLykHak7MEb2e7cblb
         odDqolf4nagew==
Date:   Tue, 26 Nov 2019 16:24:55 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [GIT PULL] Please pull my kvm-ppc-uvmem-5.5 tag
Message-ID: <20191126052455.GA2922@oak.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

If you are intending to send a second pull request for Linus for this
merge window, and you are OK with taking a new feature in PPC KVM code
at this stage, then please do a pull from my kvm-ppc-uvmem-5.5 tag.
This adds code to manage the movement of pages for a secure KVM guest
between normal memory managed by the host kernel and secure memory
managed by the ultravisor on Power systems with Protected Execution
Facility hardware and firmware.  Secure memory is not accessible to
the host kernel and is represented as device memory using the
ZONE_DEVICE facility.

The patch set has been around for a while and has been reasonably well
reviewed -- this branch contains v11 of the patch set.  The code
changes are confined to PPC KVM code with the exception of a one-line
change to mm/ksm.c to export the ksm_madvise function, the addition of
a new ioctl number in include/uapi/linux/kvm.h, and the addition of a
Kconfig option in arch/powerpc/Kconfig (which Michael Ellerman is OK
with).

If you prefer not to pull this for 5.5 then we'll submit it for 5.6.

Thanks,
Paul.

The following changes since commit 96710247298df52a4b8150a62a6fe87083093ff3:

  Merge tag 'kvm-ppc-next-5.5-2' of git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc into HEAD (2019-11-25 11:29:05 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-uvmem-5.5

for you to fetch changes up to 177707824f27d258cf5e20f1a122570e3df011b4:

  powerpc: Ultravisor: Add PPC_UV config option (2019-11-26 14:33:27 +1100)

----------------------------------------------------------------
KVM: Add support for secure guests under the Protected Execution
Framework (PEF) Ultravisor on POWER.

This enables secure memory to be represented as device memory,
which provides a way for the host to keep track of which pages of a
secure guest have been moved into secure memory managed by the
ultravisor and are no longer accessible by the host, and manage
movement of pages between secure and normal memory.

----------------------------------------------------------------
Anshuman Khandual (1):
      powerpc: Ultravisor: Add PPC_UV config option

Bharata B Rao (6):
      mm: ksm: Export ksm_madvise()
      KVM: PPC: Book3S HV: Support for running secure guests
      KVM: PPC: Book3S HV: Shared pages support for secure guests
      KVM: PPC: Book3S HV: Radix changes for secure guest
      KVM: PPC: Book3S HV: Handle memory plug/unplug to secure VM
      KVM: PPC: Book3S HV: Support reset of secure guest

 Documentation/virt/kvm/api.txt              |  18 +
 arch/powerpc/Kconfig                        |  17 +
 arch/powerpc/include/asm/hvcall.h           |   9 +
 arch/powerpc/include/asm/kvm_book3s_uvmem.h |  74 +++
 arch/powerpc/include/asm/kvm_host.h         |   6 +
 arch/powerpc/include/asm/kvm_ppc.h          |   1 +
 arch/powerpc/include/asm/ultravisor-api.h   |   6 +
 arch/powerpc/include/asm/ultravisor.h       |  36 ++
 arch/powerpc/kvm/Makefile                   |   3 +
 arch/powerpc/kvm/book3s_64_mmu_radix.c      |  25 +
 arch/powerpc/kvm/book3s_hv.c                | 143 +++++
 arch/powerpc/kvm/book3s_hv_uvmem.c          | 774 ++++++++++++++++++++++++++++
 arch/powerpc/kvm/powerpc.c                  |  12 +
 include/uapi/linux/kvm.h                    |   1 +
 mm/ksm.c                                    |   1 +
 15 files changed, 1126 insertions(+)
 create mode 100644 arch/powerpc/include/asm/kvm_book3s_uvmem.h
 create mode 100644 arch/powerpc/kvm/book3s_hv_uvmem.c


