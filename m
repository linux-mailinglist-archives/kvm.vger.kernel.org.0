Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 924561120F
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 06:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725681AbfEBEGw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 00:06:52 -0400
Received: from ozlabs.org ([203.11.71.1]:60797 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbfEBEGw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 00:06:52 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 44vhXn3dR6z9s9N; Thu,  2 May 2019 14:06:49 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1556770009; bh=KBz8JufENYoc55MOsz8Y5biZIZifiCFA8c/hJJKeMWA=;
        h=Date:From:To:Cc:Subject:From;
        b=uB7aA3QcRi4IoeFwrhJxMKAZQaDUm24MxfCYtpgB1JyTIpKtonu2DwEciU+abK3la
         eljWnVTBeBpOyHnnx5HLS12Z5MOiFdwUr0iMDOMdzuUbfOmSr6Dlku5KHZNYA96VU2
         L4WIllboqyzlp1HbrF+NSfUR39V68w+ncs3D9p8pMmmPldnKJW6UjzYI94py96h4XS
         8qWQ+/N1Bqijph2rFPnzzfiNO+XdvWtb2hcqamKzwjlBrdoDCDOrJNKlodKEy+7g33
         ux3KJRrKO2uc2ZCkmtEs8yMI8/owBdedK4/FFKI+Yunmb95+gZBXl1LSD4/tA42t4m
         BTN8jIFt25mTg==
Date:   Thu, 2 May 2019 14:06:46 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org
Subject: [GIT PULL] Please pull my kvm-ppc-next-5.2-1 tag
Message-ID: <20190502040646.GA3661@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo or Radim,

Please do a pull from my kvm-ppc-next-5.2-1 tag to get a PPC update
for 5.2.  The main new feature here is that we can now let guests
access the POWER9 XIVE interrupt controller directly for things like
acknowledge, EOI, enable and disable on interrupts, rather than
requiring guests to do hypercalls for these operations.

I have merged in the topic/ppc-kvm branch from the powerpc tree
because one of the patches there is a prerequisite for the XIVE patch
series.  That's why there are changes to arch/powerpc/kernel in the
diffstat.

Stephen Rothwell noted a conflict between my tree and the kvm-arm tree
because we have both allocated new capability numbers.

The XIVE patch series also modifies generic KVM code to add mmap and
release methods on KVM devices.

Thanks,
Paul.

The following changes since commit 345077c8e172c255ea0707214303ccd099e5656b:

  KVM: PPC: Book3S: Protect memslots while validating user address (2019-04-05 14:37:24 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-next-5.2-1

for you to fetch changes up to 0caecf5b00199636eb2d32201199ecd6be52558d:

  KVM: PPC: Book3S HV: XIVE: Clear escalation interrupt pointers on device close (2019-04-30 19:41:01 +1000)

----------------------------------------------------------------
PPC KVM update for 5.2

* Support for guests to access the new POWER9 XIVE interrupt controller
  hardware directly, reducing interrupt latency and overhead for guests.

* In-kernel implementation of the H_PAGE_INIT hypercall.

* Reduce memory usage of sparsely-populated IOMMU tables.

* Several bug fixes.

----------------------------------------------------------------
Alexey Kardashevskiy (3):
      KVM: PPC: Book3S HV: Fix lockdep warning when entering the guest
      KVM: PPC: Book3S HV: Avoid lockdep debugging in TCE realmode handlers
      KVM: PPC: Book3S: Allocate guest TCEs on demand too

C�dric Le Goater (17):
      powerpc/xive: add OPAL extensions for the XIVE native exploitation support
      KVM: PPC: Book3S HV: Add a new KVM device for the XIVE native exploitation mode
      KVM: PPC: Book3S HV: XIVE: Introduce a new capability KVM_CAP_PPC_IRQ_XIVE
      KVM: PPC: Book3S HV: XIVE: add a control to initialize a source
      KVM: PPC: Book3S HV: XIVE: Add a control to configure a source
      KVM: PPC: Book3S HV: XIVE: Add controls for the EQ configuration
      KVM: PPC: Book3S HV: XIVE: Add a global reset control
      KVM: PPC: Book3S HV: XIVE: Add a control to sync the sources
      KVM: PPC: Book3S HV: XIVE: Add a control to dirty the XIVE EQ pages
      KVM: PPC: Book3S HV: XIVE: Add get/set accessors for the VP XIVE state
      KVM: Introduce a 'mmap' method for KVM devices
      KVM: PPC: Book3S HV: XIVE: Add a TIMA mapping
      KVM: PPC: Book3S HV: XIVE: Add a mapping for the source ESB pages
      KVM: PPC: Book3S HV: XIVE: Add passthrough support
      KVM: PPC: Book3S HV: XIVE: Activate XIVE exploitation mode
      KVM: Introduce a 'release' method for KVM devices
      KVM: PPC: Book3S HV: XIVE: Replace the 'destroy' method by a 'release' method

Michael Neuling (1):
      powerpc: Add force enable of DAWR on P9 option

Palmer Dabbelt (1):
      KVM: PPC: Book3S HV: smb->smp comment fixup

Paul Mackerras (6):
      KVM: PPC: Book3S HV: Fix XICS-on-XIVE H_IPI when priority = 0
      KVM: PPC: Book3S HV: Move HPT guest TLB flushing to C code
      KVM: PPC: Book3S HV: Flush TLB on secondary radix threads
      Merge remote-tracking branch 'remotes/powerpc/topic/ppc-kvm' into kvm-ppc-next
      KVM: PPC: Book3S HV: XIVE: Prevent races when releasing device
      KVM: PPC: Book3S HV: XIVE: Clear escalation interrupt pointers on device close

Suraj Jitindar Singh (4):
      KVM: PPC: Book3S HV: Implement virtual mode H_PAGE_INIT handler
      KVM: PPC: Book3S HV: Implement real mode H_PAGE_INIT handler
      KVM: PPC: Book3S HV: Handle virtual mode in XIVE VCPU push code
      KVM: PPC: Book3S HV: Save/restore vrsave register in kvmhv_p9_guest_entry()

 Documentation/powerpc/DAWR-POWER9.txt      |   32 +
 Documentation/virtual/kvm/api.txt          |   10 +
 Documentation/virtual/kvm/devices/xive.txt |  197 +++++
 arch/powerpc/include/asm/hw_breakpoint.h   |    8 +
 arch/powerpc/include/asm/kvm_host.h        |   11 +-
 arch/powerpc/include/asm/kvm_ppc.h         |   41 +-
 arch/powerpc/include/asm/opal-api.h        |    7 +-
 arch/powerpc/include/asm/opal.h            |    7 +
 arch/powerpc/include/asm/xive.h            |   17 +
 arch/powerpc/include/uapi/asm/kvm.h        |   46 +
 arch/powerpc/kernel/hw_breakpoint.c        |   62 +-
 arch/powerpc/kernel/process.c              |    9 +-
 arch/powerpc/kernel/ptrace.c               |    3 +-
 arch/powerpc/kvm/Makefile                  |    2 +-
 arch/powerpc/kvm/book3s.c                  |   42 +-
 arch/powerpc/kvm/book3s_64_vio.c           |   96 ++-
 arch/powerpc/kvm/book3s_64_vio_hv.c        |  105 ++-
 arch/powerpc/kvm/book3s_hv.c               |  155 ++--
 arch/powerpc/kvm/book3s_hv_builtin.c       |   57 ++
 arch/powerpc/kvm/book3s_hv_rm_mmu.c        |  144 ++++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S    |  103 +--
 arch/powerpc/kvm/book3s_xive.c             |  250 ++++--
 arch/powerpc/kvm/book3s_xive.h             |   37 +
 arch/powerpc/kvm/book3s_xive_native.c      | 1249 ++++++++++++++++++++++++++++
 arch/powerpc/kvm/book3s_xive_template.c    |   78 +-
 arch/powerpc/kvm/powerpc.c                 |   37 +
 arch/powerpc/platforms/powernv/opal-call.c |    3 +
 arch/powerpc/sysdev/xive/native.c          |  110 +++
 include/linux/kvm_host.h                   |   10 +
 include/uapi/linux/kvm.h                   |    3 +
 virt/kvm/kvm_main.c                        |   24 +
 31 files changed, 2670 insertions(+), 285 deletions(-)
 create mode 100644 Documentation/virtual/kvm/devices/xive.txt
 create mode 100644 arch/powerpc/kvm/book3s_xive_native.c
