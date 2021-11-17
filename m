Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1089E454C41
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 18:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239553AbhKQRny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 12:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239506AbhKQRn2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 12:43:28 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A77CC061208;
        Wed, 17 Nov 2021 09:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=1uTmVWceFyeFzFF12Kb1AEwgWDvyhf/Bhrlut32WigU=; b=FA7jlDlOgsISqwIPXDH2Ot6bQj
        wU8RQi496K1TElvPccyBBkKObng9I/ztfWUm9if2d0ZlgxdzXERI2F2w16p/G1N+LGJK5gQ55Imt3
        2LYwOYo2ej6ez/YUwJUICBTPIlDyM00AjzcfyJECnVvr8A3VHa5mfauKjfLPgQ8XmaOqXVST4VkC9
        r7vEjmROPKF5D0aOb28MqmMJbqbNCReEZmjntJIXE3Y/yclHKPpzWp0maRBd4xwuDjPqeRN3G0j8j
        ua317PE4jft5Ek/d1EkWWz/6UQpufMevbcHTjYgB9ErEGup9Yv1zpvhbF1t4S1ODBCKh/vuqTwoAr
        Apx47PCA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnOum-00GXWZ-Cq; Wed, 17 Nov 2021 17:40:08 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnOum-001GxB-2V; Wed, 17 Nov 2021 17:40:08 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anup Patel <anup.patel@wdc.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: [PATCH v3 00/12] KVM: x86/xen: Add in-kernel Xen event channel delivery
Date:   Wed, 17 Nov 2021 17:39:51 +0000
Message-Id: <20211117174003.297096-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Event channels, yeah. That really is where I started.

It was all so simple in Joao and Ankur's original version at 
https://www.spinics.net/lists/kvm/msg182556.html — just a handful
of simple test_and_set_bit() calls on the mapped page.

When I posted v1 I didn't quite understand how steal time and nesting
were safely using the kvm_map_gfn() function, and I posted the Xen
part declaring that I had "reduced it to a previously solved problem".

Then I frowned at kvm_map_gfn() for a bit longer, concluded it was
basically impossible to use it safely on its own because the page it
maps might belong to another guest by the time it even returns to its
caller, and posted a v2 in which I did something safer for myself by
hooking into the MMU notifiers.

I then fixed the steal time reporting, and killed gfn_to_pfn_cache,
under separate cover.

In v3 of this series I re-introduce a saner gfn_to_pfn_cache with MMU 
notifier support to give it proper invalidation semantics. This can now 
be used for the Xen event channel support and should also be usable for 
fixing the various use-after-free races in the nesting code too — the 
last patch in this series being an untested proof of concept attempt at 
fixing one such.

Since adding a C file in virt/kvm/ was somewhat more painful than it
really should have been, there is a small detour into all the arch
specific Makefiles to make them include a common one.

Intended for merging up to patch 11. Patch 12 is for illustration.

David Woodhouse (12):
      KVM: Introduce CONFIG_HAVE_KVM_DIRTY_RING
      KVM: Add Makefile.kvm for common files, use it for x86
      KVM: s390: Use Makefile.kvm for common files
      KVM: mips: Use Makefile.kvm for common files
      KVM: RISC-V: Use Makefile.kvm for common files
      KVM: powerpc: Use Makefile.kvm for common files
      KVM: arm64: Use Makefile.kvm for common files
      KVM: Propagate vcpu explicitly to mark_page_dirty_in_slot()
      KVM: Reinstate gfn_to_pfn_cache with invalidation support
      KVM: x86/xen: Maintain valid mapping of Xen shared_info page
      KVM: x86/xen: Add KVM_IRQ_ROUTING_XEN_EVTCHN and event channel delivery
      KVM: x86: First attempt at converting nested virtual APIC page to gpc

 Documentation/virt/kvm/api.rst                     |  21 ++
 arch/arm64/kvm/Makefile                            |   6 +-
 arch/arm64/kvm/mmu.c                               |   2 +-
 arch/mips/kvm/Makefile                             |   3 +-
 arch/powerpc/kvm/Makefile                          |   6 +-
 arch/riscv/kvm/Makefile                            |   6 +-
 arch/s390/kvm/Makefile                             |   6 +-
 arch/x86/include/asm/kvm_host.h                    |   4 +-
 arch/x86/kvm/Kconfig                               |   2 +
 arch/x86/kvm/Makefile                              |   7 +-
 arch/x86/kvm/irq_comm.c                            |  12 +
 arch/x86/kvm/mmu/mmu.c                             |   2 +-
 arch/x86/kvm/mmu/spte.c                            |   2 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |   2 +-
 arch/x86/kvm/vmx/nested.c                          |  50 +++-
 arch/x86/kvm/vmx/vmx.c                             |  12 +-
 arch/x86/kvm/vmx/vmx.h                             |   2 +-
 arch/x86/kvm/x86.c                                 |  17 +-
 arch/x86/kvm/xen.c                                 | 287 +++++++++++++++++++--
 arch/x86/kvm/xen.h                                 |   9 +
 include/linux/kvm_dirty_ring.h                     |  14 +-
 include/linux/kvm_host.h                           | 100 ++++++-
 include/linux/kvm_types.h                          |  18 ++
 include/uapi/linux/kvm.h                           |  11 +
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c | 112 +++++++-
 virt/kvm/Kconfig                                   |   6 +
 virt/kvm/Makefile.kvm                              |  14 +
 virt/kvm/dirty_ring.c                              |  10 +-
 virt/kvm/kvm_main.c                                |  34 ++-
 virt/kvm/{mmu_lock.h => kvm_mm.h}                  |  23 +-
 virt/kvm/pfncache.c                                | 281 ++++++++++++++++++++
 31 files changed, 992 insertions(+), 89 deletions(-)



