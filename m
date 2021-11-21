Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C445458388
	for <lists+kvm@lfdr.de>; Sun, 21 Nov 2021 13:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238248AbhKUM6U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Nov 2021 07:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238161AbhKUM6R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Nov 2021 07:58:17 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7514EC061714;
        Sun, 21 Nov 2021 04:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=IgNSXNY2TpIuc5DjPBel8XiPwVYxmuy/OdeenPYbteI=; b=Vu9vRhXy7bRTzRn551qpp2Sl2x
        zCtr/gMJ4DW8RwOHmzxJxzo7vDlzWes4Hqvf8OhYVQvu8TgUnPYAkp+B7dwWJGxd4qa98SoZOYuWV
        5bhHnd4moc54T+xIGj//+Ct1psMVjPk+Pdg32UPn83uTEm30Y2xWCWDUWG7zzQA8A9jiya3kArabf
        lHB8fd0S9GhuLNI6EX6C0akf58/mnAKpVwdY1c0zqvxOiNqI8W9eVWQtmP2IMzGzdVo5+UUmKjlgh
        pghg+NjWVpziG/dkvqPqodD+6axkmt7LKPKsHXKEoxT0UziAnHuI2HqKcy6sNMq8iwkWYu+xYx/tX
        kWDa6thg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1momMv-00C3xt-Mo; Sun, 21 Nov 2021 12:54:54 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1momMv-0002Vv-R2; Sun, 21 Nov 2021 12:54:53 +0000
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
        kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
Subject: [PATCH v5 00/12] KVM: x86/xen: Add in-kernel Xen event channel delivery
Date:   Sun, 21 Nov 2021 12:54:39 +0000
Message-Id: <20211121125451.9489-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce the basic concept of 2 level event channels for kernel delivery,
which is just a simple matter of a few test_and_set_bit calls on a mapped
shared info page.

This can be used for routing MSI of passthrough devices to PIRQ event
channels in a Xen guest, and we can build on it for delivering IPIs and
timers directly from the kernel too.

v1: Use kvm_map_gfn() although I didn't quite see how it works.

v2: Avoid kvm_map_gfn() and implement a safe mapping with invalidation
    support for myself.

v3: Reinvent gfn_to_pfn_cache with sane invalidation semantics, for my
    use case as well as nesting.

v4: Rework dirty handling, as it became apparently that we need an active
    vCPU context to mark pages dirty so it can't be done from the MMU
    notifier duing the invalidation; it has to happen on unmap.

v5: Fix sparse warnings reported by kernel test robot <lkp@intel.com>.

    Fix revalidation when memslots change but the resulting HVA stays
    the same. We can use the same kernel mapping in that case, if the
    HVA → PFN translation was valid before. So that probably means we
    shouldn't unmap the "old_hva". Augment the test case to exercise
    that one too.

    Include the fix for the dirty ring vs. Xen shinfo oops reported
    by butt3rflyh4ck <butterflyhuangxx@gmail.com>.


As in the previous two rounds, the last patch (this time patch 12) is
included as illustration of how we *might* use this for fixing the UAF
bugs in nesting, but isn't intended to be applied as-is. Patches 1-11 are.



David Woodhouse (12):
      KVM: Introduce CONFIG_HAVE_KVM_DIRTY_RING
      KVM: Add Makefile.kvm for common files, use it for x86
      KVM: s390: Use Makefile.kvm for common files
      KVM: mips: Use Makefile.kvm for common files
      KVM: RISC-V: Use Makefile.kvm for common files
      KVM: powerpc: Use Makefile.kvm for common files
      KVM: arm64: Use Makefile.kvm for common files
      KVM: Reinstate gfn_to_pfn_cache with invalidation support
      KVM: x86/xen: Maintain valid mapping of Xen shared_info page
      KVM: x86/xen: Add KVM_IRQ_ROUTING_XEN_EVTCHN and event channel delivery
      KVM: x86: Fix wall clock writes in Xen shared_info not to mark page dirty
      KVM: x86: First attempt at converting nested virtual APIC page to gpc

 Documentation/virt/kvm/api.rst                     |  33 ++
 arch/arm64/kvm/Makefile                            |   6 +-
 arch/mips/kvm/Makefile                             |   3 +-
 arch/powerpc/kvm/Makefile                          |   6 +-
 arch/riscv/kvm/Makefile                            |   6 +-
 arch/s390/kvm/Makefile                             |   6 +-
 arch/x86/include/asm/kvm_host.h                    |   4 +-
 arch/x86/kvm/Kconfig                               |   2 +
 arch/x86/kvm/Makefile                              |   7 +-
 arch/x86/kvm/irq_comm.c                            |  12 +
 arch/x86/kvm/vmx/nested.c                          |  50 ++-
 arch/x86/kvm/vmx/vmx.c                             |  12 +-
 arch/x86/kvm/vmx/vmx.h                             |   2 +-
 arch/x86/kvm/x86.c                                 |  15 +-
 arch/x86/kvm/x86.h                                 |   1 -
 arch/x86/kvm/xen.c                                 | 341 +++++++++++++++++++--
 arch/x86/kvm/xen.h                                 |   9 +
 include/linux/kvm_dirty_ring.h                     |   8 +-
 include/linux/kvm_host.h                           | 110 +++++++
 include/linux/kvm_types.h                          |  18 ++
 include/uapi/linux/kvm.h                           |  11 +
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c | 184 ++++++++++-
 virt/kvm/Kconfig                                   |   6 +
 virt/kvm/Makefile.kvm                              |  14 +
 virt/kvm/dirty_ring.c                              |   2 +-
 virt/kvm/kvm_main.c                                |  16 +-
 virt/kvm/kvm_mm.h                                  |  44 +++
 virt/kvm/mmu_lock.h                                |  23 --
 virt/kvm/pfncache.c                                | 323 +++++++++++++++++++
 29 files changed, 1173 insertions(+), 101 deletions(-)


