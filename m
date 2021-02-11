Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24603185A9
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 08:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhBKH0p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 02:26:45 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:41973 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhBKH0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Feb 2021 02:26:43 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4Dbp881PbXz9sB4; Thu, 11 Feb 2021 18:25:59 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1613028360; bh=qu6nEoHZwmR4++I5Abr6z1RTfdyjVVJh3qE95Ap47aM=;
        h=Date:From:To:Cc:Subject:From;
        b=trt6YQD90kPke0B9zfpErNFjIIXhro2YWGjuYHgUXMof6m/hWBMC3zh98FS0podHT
         h+EvZUd7g/lAsuOPSQzsDRLybQlrDga8eDhLp6EvSfbkmV57Sb47HlSNJivs+ac+A3
         YeW1gqdSZExk/AgyVhmLMoHNKcBiVzolsqXkCgPT/gysf4srXOkfwNzIVBhCeQeB8J
         ZGNFr5etZCGkt4pmkh79262BL+yGYT7+mHDFdimbZPMRchy4EICHSlcL1luumOL3Qt
         rpOXwOo//Kohs1GaMcxebOqg61O9R9anjGg9myHkkWlqBBUxSNhSF/lk5uUds4vcRA
         x40/8rH6Kbv9A==
Date:   Thu, 11 Feb 2021 18:25:53 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org
Subject: [GIT PULL] Please pull my kvm-ppc-next-5.12-1 tag
Message-ID: <20210211072553.GA2877131@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Please do a pull from my kvm-ppc-next-5.12-1 tag to get a PPC KVM
update for 5.12.  This one is quite small, with just one new feature,
support for the second data watchpoint in POWER10.

Thanks,
Paul.

The following changes since commit 9294b8a12585f8b4ccb9c060b54bab0bd13f24b9:

  Documentation: kvm: fix warning (2021-02-09 08:42:10 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-next-5.12-1

for you to fetch changes up to 72476aaa469179222b92c380de60c76b4cb9a318:

  KVM: PPC: Book3S HV: Fix host radix SLB optimisation with hash guests (2021-02-11 17:28:15 +1100)

----------------------------------------------------------------
PPC KVM update for 5.12

- Support for second data watchpoint on POWER10, from Ravi Bangoria
- Remove some complex workarounds for buggy early versions of POWER9
- Guest entry/exit fixes from Nick Piggin and Fabiano Rosas

----------------------------------------------------------------
Fabiano Rosas (2):
      KVM: PPC: Book3S HV: Save and restore FSCR in the P9 path
      KVM: PPC: Don't always report hash MMU capability for P9 < DD2.2

Nicholas Piggin (5):
      KVM: PPC: Book3S HV: Remove support for running HPT guest on RPT host without mixed mode support
      KVM: PPC: Book3S HV: Fix radix guest SLB side channel
      KVM: PPC: Book3S HV: No need to clear radix host SLB before loading HPT guest
      KVM: PPC: Book3S HV: Use POWER9 SLBIA IH=6 variant to clear SLB
      KVM: PPC: Book3S HV: Fix host radix SLB optimisation with hash guests

Paul Mackerras (1):
      KVM: PPC: Book3S HV: Ensure radix guest has no SLB entries

Ravi Bangoria (4):
      KVM: PPC: Book3S HV: Allow nested guest creation when L0 hv_guest_state > L1
      KVM: PPC: Book3S HV: Rename current DAWR macros and variables
      KVM: PPC: Book3S HV: Add infrastructure to support 2nd DAWR
      KVM: PPC: Book3S HV: Introduce new capability for 2nd DAWR

Yang Li (1):
      KVM: PPC: remove unneeded semicolon

 Documentation/virt/kvm/api.rst            |  12 ++
 arch/powerpc/include/asm/hvcall.h         |  25 ++++-
 arch/powerpc/include/asm/kvm_book3s_asm.h |  11 --
 arch/powerpc/include/asm/kvm_host.h       |   7 +-
 arch/powerpc/include/asm/kvm_ppc.h        |   2 +
 arch/powerpc/include/uapi/asm/kvm.h       |   2 +
 arch/powerpc/kernel/asm-offsets.c         |   9 +-
 arch/powerpc/kvm/book3s_hv.c              | 149 +++++++++++++++----------
 arch/powerpc/kvm/book3s_hv_builtin.c      | 108 +-----------------
 arch/powerpc/kvm/book3s_hv_nested.c       |  70 +++++++++---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S   | 175 ++++++++++++++++--------------
 arch/powerpc/kvm/booke.c                  |   2 +-
 arch/powerpc/kvm/powerpc.c                |  14 ++-
 include/uapi/linux/kvm.h                  |   1 +
 tools/arch/powerpc/include/uapi/asm/kvm.h |   2 +
 tools/include/uapi/linux/kvm.h            |   1 +
 16 files changed, 309 insertions(+), 281 deletions(-)
