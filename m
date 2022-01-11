Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA9E48B0EC
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 16:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343630AbiAKPfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 10:35:50 -0500
Received: from foss.arm.com ([217.140.110.172]:48172 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240480AbiAKPfu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 10:35:50 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 648871FB;
        Tue, 11 Jan 2022 07:35:49 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DB9C83F774;
        Tue, 11 Jan 2022 07:35:44 -0800 (PST)
From:   Mark Rutland <mark.rutland@arm.com>
To:     linux-kernel@vger.kernel.org
Cc:     aleksandar.qemu.devel@gmail.com, alexandru.elisei@arm.com,
        anup.patel@wdc.com, aou@eecs.berkeley.edu, atish.patra@wdc.com,
        benh@kernel.crashing.org, borntraeger@linux.ibm.com, bp@alien8.de,
        catalin.marinas@arm.com, chenhuacai@kernel.org,
        dave.hansen@linux.intel.com, david@redhat.com,
        frankja@linux.ibm.com, frederic@kernel.org, gor@linux.ibm.com,
        hca@linux.ibm.com, imbrenda@linux.ibm.com, james.morse@arm.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        mark.rutland@arm.com, maz@kernel.org, mingo@redhat.com,
        mpe@ellerman.id.au, nsaenzju@redhat.com, palmer@dabbelt.com,
        paulmck@kernel.org, paulus@samba.org, paul.walmsley@sifive.com,
        pbonzini@redhat.com, seanjc@google.com, suzuki.poulose@arm.com,
        tglx@linutronix.de, tsbogend@alpha.franken.de, vkuznets@redhat.com,
        wanpengli@tencent.com, will@kernel.org
Subject: [PATCH 0/5] kvm: fix latent guest entry/exit bugs
Date:   Tue, 11 Jan 2022 15:35:34 +0000
Message-Id: <20220111153539.2532246-1-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Several architectures have latent bugs around guest entry/exit, most
notably:

1) Several architectures enable interrupts between guest_enter() and
   guest_exit(). As this period is an RCU extended quiescent state (EQS) this
   is unsound unless the irq entry code explicitly wakes RCU, which most
   architectures only do for entry from usersapce or idle.

   I believe this affects: arm64, riscv, s390

   I am not sure about powerpc.

2) Several architectures permit instrumentation of code between
   guest_enter() and guest_exit(), e.g. KASAN, KCOV, KCSAN, etc. As
   instrumentation may directly o indirectly use RCU, this has the same
   problems as with interrupts.

   I believe this affects: arm64, mips, powerpc, riscv, s390

3) Several architectures do not inform lockdep and tracing that
   interrupts are enabled during the execution of the guest, or do so in
   an incorrect order. Generally
   this means that logs will report IRQs being masked for much longer
   than is actually the case, which is not ideal for debugging. I don't
   know whether this affects the correctness of lockdep.

   I believe this affects: arm64, mips, powerpc, riscv, s390

This was previously fixed for x86 specifically in a series of commits:

  87fa7f3e98a1310e ("x86/kvm: Move context tracking where it belongs")
  0642391e2139a2c1 ("x86/kvm/vmx: Add hardirq tracing to guest enter/exit")
  9fc975e9efd03e57 ("x86/kvm/svm: Add hardirq tracing on guest enter/exit")
  3ebccdf373c21d86 ("x86/kvm/vmx: Move guest enter/exit into .noinstr.text")
  135961e0a7d555fc ("x86/kvm/svm: Move guest enter/exit into .noinstr.text")
  160457140187c5fb ("KVM: x86: Defer vtime accounting 'til after IRQ handling")
  bc908e091b326467 ("KVM: x86: Consolidate guest enter/exit logic to common helpers")

But other architectures were left broken, and the infrastructure for
handling this correctly is x86-specific.

This series introduces generic helper functions which can be used to
handle the problems above, and migrates architectures over to these,
fixing the latent issues.

I wasn't able to figure my way around powerpc and s390, so I have not
altered these. I'd appreciate if anyone could take a look at those
cases, and either have a go at patches or provide some feedback as to
any alternative approaches which work work better there.

I have build-tested the arm64, mips, riscv, and x86 cases, but I don't
have a suitable HW setup to test these, so any review and/or testing
would be much appreciated.

I've pushed the series (based on v5.16) to my kvm/entry-rework branch:

  https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=kvm/entry-rework
  git://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git kvm/entry-rework

... also tagged as kvm-entry-rework-20210111

Thanks,
Mark.

Mark Rutland (5):
  kvm: add exit_to_guest_mode() and enter_from_guest_mode()
  kvm/arm64: rework guest entry logic
  kvm/mips: rework guest entry logic
  kvm/riscv: rework guest entry logic
  kvm/x86: rework guest entry logic

 arch/arm64/kvm/arm.c     |  51 +++++++++++-------
 arch/mips/kvm/mips.c     |  37 ++++++++++++--
 arch/riscv/kvm/vcpu.c    |  44 ++++++++++------
 arch/x86/kvm/svm/svm.c   |   4 +-
 arch/x86/kvm/vmx/vmx.c   |   4 +-
 arch/x86/kvm/x86.c       |   4 +-
 arch/x86/kvm/x86.h       |  45 ----------------
 include/linux/kvm_host.h | 108 +++++++++++++++++++++++++++++++++++++--
 8 files changed, 206 insertions(+), 91 deletions(-)

-- 
2.30.2

