Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBDF32FB4D
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 14:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfE3L77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 May 2019 07:59:59 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:41551 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbfE3L77 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 07:59:59 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45F5jm3gm5z9s5c; Thu, 30 May 2019 21:59:56 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1559217596; bh=DEccgpzpDGHzVjTlyndHNeVJrmmoGpiDRPg30y+OHt0=;
        h=Date:From:To:Cc:Subject:From;
        b=uqELnt9erlHUk2hvN4XAPIU89ppi3pH0spJu1LyOvZd0d7E3O+6FS8SFdIUeYwXXL
         wECpQN74a9DFRAHtqQx4RN34j6ZGdO2EMZ+EMpVXGXir61iWjEA1KGJYJSsvhNnyQA
         3RFdOsnCZDgsufl9LR34QbCw4t2WXdjPR+h7bsgEvCfye3iUv1GyH57JwQr0wGeuRr
         zBXqWlVnm5vDU+ohLCNzeFX7wZu0uaoeKegqw5zolHhRpkWLBjV+NLImE6w81cQXNg
         acdr6hhU/r/DhF0K7+lZAuloKpHZQ8fw4t5Hoh/iQK/f44PXocE0fcOyJDrzBNjwon
         ZJJ5gYTDekB4w==
Date:   Thu, 30 May 2019 21:59:44 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org
Subject: [GIT PULL] Please pull my kvm-ppc-fixes-5.2-1 tag
Message-ID: <20190530115944.GA6675@blackberry>
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

Please do a pull from my kvm-ppc-fixes-5.2-1 tag to get a series of
commits which should go into 5.2 (i.e. via the master branch of the
kvm tree).  They are mostly fixes for the new code which allows guests
to access the XIVE interrupt controller on POWER9 machines directly,
and locking fixes to solve host deadlock issues.

It turns out that the PPC KVM code had been using the kvm->lock mutex
in several places where the vcpu mutex was already held.  Although
this is contrary to what Documentation/virtual/kvm/locking.txt says,
lockdep didn't complain about it in the past because we (apparently)
had no places where a vcpu mutex was taken with kvm->lock held.  Now
there is such a place, in the recently-added XIVE code.  Thus we now
need to fix those other places that take the locks in the wrong order.

Thanks,
Paul.

The following changes since commit cd6c84d8f0cdc911df435bb075ba22ce3c605b07:

  Linux 5.2-rc2 (2019-05-26 16:49:19 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-fixes-5.2-1

for you to fetch changes up to d724c9e54939a597592de3659541da11fc7aa112:

  KVM: PPC: Book3S HV: Restore SPRG3 in kvmhv_p9_guest_entry() (2019-05-30 14:00:54 +1000)

----------------------------------------------------------------
PPC KVM fixes for 5.2

- Several bug fixes for the new XIVE-native code.
- Replace kvm->lock by other mutexes in several places where we hold a
  vcpu mutex, to avoid lock order inversions.
- Fix a lockdep warning on guest entry for radix-mode guests.
- Fix a bug causing user-visible corruption of SPRG3 on the host.

----------------------------------------------------------------
C�dric Le Goater (7):
      KVM: PPC: Book3S HV: XIVE: Clear file mapping when device is released
      KVM: PPC: Book3S HV: XIVE: Do not test the EQ flag validity when resetting
      KVM: PPC: Book3S HV: XIVE: Fix the enforced limit on the vCPU identifier
      KVM: PPC: Book3S HV: XIVE: Introduce a new mutex for the XIVE device
      KVM: PPC: Book3S HV: XIVE: Do not clear IRQ data of passthrough interrupts
      KVM: PPC: Book3S HV: XIVE: Take the srcu read lock when accessing memslots
      KVM: PPC: Book3S HV: XIVE: Fix page offset when clearing ESB pages

Paul Mackerras (5):
      KVM: PPC: Book3S HV: Avoid touching arch.mmu_ready in XIVE release functions
      KVM: PPC: Book3S HV: Use new mutex to synchronize MMU setup
      KVM: PPC: Book3S: Use new mutex to synchronize access to rtas token list
      KVM: PPC: Book3S HV: Don't take kvm->lock around kvm_for_each_vcpu
      KVM: PPC: Book3S HV: Fix lockdep warning when entering guest on POWER9

Suraj Jitindar Singh (1):
      KVM: PPC: Book3S HV: Restore SPRG3 in kvmhv_p9_guest_entry()

 arch/powerpc/include/asm/kvm_host.h   |   2 +
 arch/powerpc/kvm/book3s.c             |   1 +
 arch/powerpc/kvm/book3s_64_mmu_hv.c   |  36 ++++++------
 arch/powerpc/kvm/book3s_hv.c          |  48 ++++++++++------
 arch/powerpc/kvm/book3s_rtas.c        |  14 ++---
 arch/powerpc/kvm/book3s_xive.c        |  55 +++++++++----------
 arch/powerpc/kvm/book3s_xive.h        |   1 +
 arch/powerpc/kvm/book3s_xive_native.c | 100 +++++++++++++++++++---------------
 8 files changed, 142 insertions(+), 115 deletions(-)
