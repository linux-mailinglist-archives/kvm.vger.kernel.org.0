Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11DA511EA28
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 19:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbfLMS1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 13:27:52 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:34659 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726404AbfLMS1w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Dec 2019 13:27:52 -0500
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1ifpdD-0001O7-Ur; Fri, 13 Dec 2019 19:25:40 +0100
From:   Marc Zyngier <maz@kernel.org>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 0/7] KVM: arm/arm64: Help VMs dying quicker
Date:   Fri, 13 Dec 2019 18:24:56 +0000
Message-Id: <20191213182503.14460-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, jhogan@kernel.org, paulus@ozlabs.org, pbonzini@redhat.com, rkrcmar@redhat.com, sean.j.christopherson@intel.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Yes, the subject is deliberately provocative!]

Having recently played with large, memory intensive, and very short lived
VMs, I have realised that we spend a substantial amount of time cleaning up
when a VM has terminated.

It turns out that 99% of the overhead is due to the unnecessary cache
cleaning that we perform when pages get unmapped from Stage-2, which
only serves a single purpose: to make the page visible to a non-coherent
IO subsystem when the page is being swapped out.

It would make sense to drop these cache maintenance operations when
userspace is either unmapping a VMA or simply exiting. Detecting the
latter is easy, as KVM calls kvm_arch_flush_shadow_all(). The unmap
case is harder, or at least it was until 5.2 gained the MMU notifier
event, which allows subsystems to find out about the reason of an
change in the page tables.

And it turns out we can do even better: We can also avoid invalidating
individual page mappings if we're tearing down the VM altogether, and
replace it with a single TLBI VMALL, which will be much lighter on the
whole system (specially if your interconnect is a bit flimsy).

With the above, terminating a 64GB VM that has most of its memory
mapped at S2 goes from several seconds (I've seen up to 12s) to less
than a second on my D05. In general, multi-socket systems seem to
benefit from this more than single socket machines (based on a
non-representative sample of 4 random machines I have access to).

The first patch affects most architectures, as it changes one of the
core architecture hooks (in a fairly mechanical way). The rest is
definitely ARM-specific.

Marc Zyngier (7):
  KVM: Pass mmu_notifier_range down to kvm_unmap_hva_range()
  KVM: arm/arm64: Pass flags along Stage-2 unmapping functions
  KVM: arm/arm64: Condition cache maintenance on unmap with a flag
  KVM: arm/arm64: Condition TLB maintenance on unmap with a flag
  KVM: arm/arm64: Elide both CMOs and TBLIs on freeing the whole Stage-2
  KVM: arm/arm64: Elide CMOs when retrying a block mapping
  KVM: arm/arm64: Elide CMOs when unmapping a range

 arch/arm/include/asm/kvm_host.h     |  2 +-
 arch/arm64/include/asm/kvm_host.h   |  2 +-
 arch/mips/include/asm/kvm_host.h    |  2 +-
 arch/mips/kvm/mmu.c                 |  6 +-
 arch/powerpc/include/asm/kvm_host.h |  2 +-
 arch/powerpc/kvm/book3s.c           |  5 +-
 arch/powerpc/kvm/e500_mmu_host.c    |  4 +-
 arch/x86/include/asm/kvm_host.h     |  3 +-
 arch/x86/kvm/mmu/mmu.c              |  5 +-
 arch/x86/kvm/x86.c                  |  4 +-
 include/linux/kvm_host.h            |  2 +-
 virt/kvm/arm/mmu.c                  | 97 +++++++++++++++++++----------
 virt/kvm/kvm_main.c                 |  7 +--
 13 files changed, 88 insertions(+), 53 deletions(-)

-- 
2.20.1

