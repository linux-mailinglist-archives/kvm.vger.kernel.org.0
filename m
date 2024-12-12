Return-Path: <kvm+bounces-33575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A76A9EE729
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 13:56:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CECC282753
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 12:56:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2A8D213E65;
	Thu, 12 Dec 2024 12:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n+7Fj8Of"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEC21714D7;
	Thu, 12 Dec 2024 12:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734008169; cv=none; b=VYiLQG5UKJDnN7GJT3T0/B1Sk0ymuJHvhGzBvX0+vj5aT/jorEe+6Os18YsT5zgVYrjYMAo+ceyh/IjwxwM8mCKl4W7d8nZicmrVzytwt7YjzjuSBu+L1lEPuxwe71n8j9Jpvs/vg/i9+ReDYP/O8/9m0K0xCISWa+iivdhVUtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734008169; c=relaxed/simple;
	bh=xxZqH/jWseGtawnTC3Mff0BVdlHl78xupLUOsVLvfIc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=h97m2qr0YuxSTISiKvKnOoTDtM+ImDeCaMGv+kfvlMHzvKbOGsFLv6MuYiUi4/0C/noLndfAUhkTP1eBM4coXDZH+MLMNWTUcuknlXgTlxMT9ZqzGRxzftggvvjkWgWokGoseOGh8w/hRYwVHWvBN/KPudfE1fjdmCeSvwHPNwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n+7Fj8Of; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1FDC4CECE;
	Thu, 12 Dec 2024 12:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734008168;
	bh=xxZqH/jWseGtawnTC3Mff0BVdlHl78xupLUOsVLvfIc=;
	h=From:To:Cc:Subject:Date:From;
	b=n+7Fj8Of8e5sts5EpMo7IcbPPQefDcygJTvJiXwpSImEu/euclZ6Bx4GqaPgB9BAS
	 FC4B8FUtqKk2cwlm+G4MDUFBJxlGjy+Xyf+UGEHoh7ODAHRe5iul8cwad7BmocUNUO
	 yQgv1x7MmFDwvvnAQtr0sJwLl7qC/O0URI3UfnyVQ9MTFZyjCr5vlk55V1qwVpYdi1
	 QZKderZ8s7FSi4AC3RP01v7I+mr84s09Or5FW2yiFQ/NnidTgm0la/5eUMXMidG1uo
	 huHO0dznecqL990+dZlovhbBYo/EoQ4Kvug0p3zf2r057/Y1qQayr/EDXOK4i4ZnQk
	 B8d9Wq66KI53A==
From: Arnd Bergmann <arnd@kernel.org>
To: kvm@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Alexander Graf <graf@amazon.com>,
	Crystal Wood <crwood@redhat.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Paul Durrant <paul@xen.org>,
	Marc Zyngier <maz@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org
Subject: [RFC 0/5] KVM: drop 32-bit host support on all architectures
Date: Thu, 12 Dec 2024 13:55:11 +0100
Message-Id: <20241212125516.467123-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

I submitted a patch to remove KVM support for x86-32 hosts earlier
this month, but there were still concerns that this might be useful for
testing 32-bit host in general, as that remains supported on three other
architectures. I have gone through those three now and prepared similar
patches, as all of them seem to be equally obsolete.

Support for 32-bit KVM host on Arm hardware was dropped back in 2020
because of lack of users, despite Cortex-A7/A15/A17 based SoCs being
much more widely deployed than the other virtualization capable 32-bit
CPUs (Intel Core Duo/Silverthorne, PowerPC e300/e500/e600, MIPS P5600)
combined.

It probably makes sense to drop all of these at the same time, provided
there are no actual users remaining (not counting regression testing
that developers might be doing). Please let me know if you are still
using any of these machines, or think there needs to be deprecation
phase first.

      Arnd

Link: https://lore.kernel.org/lkml/Z1B1phcpbiYWLgCD@google.com/
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Crystal Wood <crwood@redhat.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Atish Patra <atishp@atishpatra.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Paul Durrant <paul@xen.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mips@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: kvm-riscv@lists.infradead.org
Cc: linux-riscv@lists.infradead.org

Arnd Bergmann (5):
  mips: kvm: drop support for 32-bit hosts
  powerpc: kvm: drop 32-bit booke
  powerpc: kvm: drop 32-bit book3s
  riscv: kvm: drop 32-bit host support
  x86: kvm drop 32-bit host support

 MAINTAINERS                                 |   2 +-
 arch/mips/Kconfig                           |   3 -
 arch/mips/include/asm/kvm_host.h            |   4 -
 arch/mips/kvm/Kconfig                       |   1 +
 arch/mips/kvm/emulate.c                     |   8 -
 arch/mips/kvm/msa.S                         |  12 -
 arch/mips/kvm/vz.c                          |  22 -
 arch/powerpc/include/asm/kvm_book3s.h       |  19 -
 arch/powerpc/include/asm/kvm_book3s_32.h    |  36 --
 arch/powerpc/include/asm/kvm_book3s_asm.h   |  10 -
 arch/powerpc/include/asm/kvm_booke.h        |   4 -
 arch/powerpc/include/asm/kvm_booke_hv_asm.h |   2 -
 arch/powerpc/kvm/Kconfig                    |  44 +-
 arch/powerpc/kvm/Makefile                   |  30 --
 arch/powerpc/kvm/book3s.c                   |  18 -
 arch/powerpc/kvm/book3s_32_mmu_host.c       | 396 --------------
 arch/powerpc/kvm/book3s_emulate.c           |  37 --
 arch/powerpc/kvm/book3s_interrupts.S        |  11 -
 arch/powerpc/kvm/book3s_mmu_hpte.c          |  12 -
 arch/powerpc/kvm/book3s_pr.c                | 122 +----
 arch/powerpc/kvm/book3s_rmhandlers.S        | 110 ----
 arch/powerpc/kvm/book3s_segment.S           |  30 +-
 arch/powerpc/kvm/booke.c                    | 264 ----------
 arch/powerpc/kvm/booke.h                    |   8 -
 arch/powerpc/kvm/booke_emulate.c            |  44 --
 arch/powerpc/kvm/booke_interrupts.S         | 535 -------------------
 arch/powerpc/kvm/bookehv_interrupts.S       |  10 -
 arch/powerpc/kvm/e500.c                     | 553 --------------------
 arch/powerpc/kvm/e500.h                     |  40 --
 arch/powerpc/kvm/e500_emulate.c             | 100 ----
 arch/powerpc/kvm/e500_mmu_host.c            |  54 --
 arch/powerpc/kvm/e500mc.c                   |   5 +-
 arch/powerpc/kvm/emulate.c                  |   2 -
 arch/powerpc/kvm/powerpc.c                  |   2 -
 arch/powerpc/kvm/trace_booke.h              |  14 -
 arch/riscv/kvm/Kconfig                      |   2 +-
 arch/riscv/kvm/aia.c                        | 105 ----
 arch/riscv/kvm/aia_imsic.c                  |  34 --
 arch/riscv/kvm/mmu.c                        |   8 -
 arch/riscv/kvm/vcpu_exit.c                  |   4 -
 arch/riscv/kvm/vcpu_insn.c                  |  12 -
 arch/riscv/kvm/vcpu_sbi_pmu.c               |   8 -
 arch/riscv/kvm/vcpu_sbi_replace.c           |   4 -
 arch/riscv/kvm/vcpu_sbi_v01.c               |   4 -
 arch/riscv/kvm/vcpu_timer.c                 |  20 -
 arch/x86/kvm/Kconfig                        |   6 +-
 arch/x86/kvm/Makefile                       |   4 +-
 arch/x86/kvm/cpuid.c                        |   9 +-
 arch/x86/kvm/emulate.c                      |  34 +-
 arch/x86/kvm/fpu.h                          |   4 -
 arch/x86/kvm/hyperv.c                       |   5 +-
 arch/x86/kvm/i8254.c                        |   4 -
 arch/x86/kvm/kvm_cache_regs.h               |   2 -
 arch/x86/kvm/kvm_emulate.h                  |   8 -
 arch/x86/kvm/lapic.c                        |   4 -
 arch/x86/kvm/mmu.h                          |   4 -
 arch/x86/kvm/mmu/mmu.c                      | 134 -----
 arch/x86/kvm/mmu/mmu_internal.h             |   9 -
 arch/x86/kvm/mmu/paging_tmpl.h              |   9 -
 arch/x86/kvm/mmu/spte.h                     |   5 -
 arch/x86/kvm/mmu/tdp_mmu.h                  |   4 -
 arch/x86/kvm/smm.c                          |  19 -
 arch/x86/kvm/svm/sev.c                      |   2 -
 arch/x86/kvm/svm/svm.c                      |  23 +-
 arch/x86/kvm/svm/vmenter.S                  |  20 -
 arch/x86/kvm/trace.h                        |   4 -
 arch/x86/kvm/vmx/main.c                     |   2 -
 arch/x86/kvm/vmx/nested.c                   |  24 +-
 arch/x86/kvm/vmx/vmcs.h                     |   2 -
 arch/x86/kvm/vmx/vmenter.S                  |  25 +-
 arch/x86/kvm/vmx/vmx.c                      | 117 +----
 arch/x86/kvm/vmx/vmx.h                      |  23 +-
 arch/x86/kvm/vmx/vmx_ops.h                  |   7 -
 arch/x86/kvm/vmx/x86_ops.h                  |   2 -
 arch/x86/kvm/x86.c                          |  74 +--
 arch/x86/kvm/x86.h                          |   4 -
 arch/x86/kvm/xen.c                          |  61 +--
 77 files changed, 63 insertions(+), 3356 deletions(-)
 delete mode 100644 arch/powerpc/include/asm/kvm_book3s_32.h
 delete mode 100644 arch/powerpc/kvm/book3s_32_mmu_host.c
 delete mode 100644 arch/powerpc/kvm/booke_interrupts.S
 delete mode 100644 arch/powerpc/kvm/e500.c

-- 
2.39.5


