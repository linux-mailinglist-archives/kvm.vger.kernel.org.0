Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF9E4705D8
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 17:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243684AbhLJQkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 11:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243668AbhLJQkT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 11:40:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7A4C0617A1
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 08:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=r1j018hgw00sLtBIRlyEnhb8788LpsPWVLewujKBlDQ=; b=bRlJBoFbChAqSqF+Bt6vVo696i
        Gpq/ud+Yxt/vmMcYV7zE/5TtZTB/4R+HkrSuExDNjHeYMKCRN6vw203HzVwNCfSlM3r037qI8I+1z
        QEYKCWM8hwJ5SLZLaGmyQ4XoKooYqZM20cRfxjrth+4dPPFavIWewSz6WtVaMnnJdGQq8ELuBDpY2
        PB9yKdBj3NUNFsABpU0JmT8nwulycoQtn7VzAU7/4j77NKG0eFXMTy87yJRu4FPggewz6hTsuJeOw
        EtKd+BY0cddAGBRCXDVt1XExiziizjTl42TEmgT6nHZqGq3kE2eUhLhlj2kO2f2QfoywqzebYV0Bz
        kN89zggQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvisk-00AUQv-Na; Fri, 10 Dec 2021 16:36:27 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvisk-0000lT-UR; Fri, 10 Dec 2021 16:36:26 +0000
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
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
Subject: [PATCH v6 0/6] x86/xen: Add in-kernel Xen event channel delivery
Date:   Fri, 10 Dec 2021 16:36:19 +0000
Message-Id: <20211210163625.2886-1-dwmw2@infradead.org>
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

v6: Paolo's review feedback, rebase onto kvm/next dropping the patches
    which are already merged.

Again, the *last* patch in the series (this time #6) is for illustration
and is not intended to be merged as-is.

David Woodhouse (6):
      KVM: Warn if mark_page_dirty() is called without an active vCPU
      KVM: Reinstate gfn_to_pfn_cache with invalidation support
      KVM: x86/xen: Maintain valid mapping of Xen shared_info page
      KVM: x86/xen: Add KVM_IRQ_ROUTING_XEN_EVTCHN and event channel delivery
      KVM: x86: Fix wall clock writes in Xen shared_info not to mark page dirty
      KVM: x86: First attempt at converting nested virtual APIC page to gpc

 Documentation/virt/kvm/api.rst                     |  33 ++
 arch/x86/include/asm/kvm_host.h                    |   4 +-
 arch/x86/kvm/Kconfig                               |   1 +
 arch/x86/kvm/irq_comm.c                            |  12 +
 arch/x86/kvm/vmx/nested.c                          |  50 ++-
 arch/x86/kvm/vmx/vmx.c                             |  12 +-
 arch/x86/kvm/vmx/vmx.h                             |   2 +-
 arch/x86/kvm/x86.c                                 |  15 +-
 arch/x86/kvm/x86.h                                 |   1 -
 arch/x86/kvm/xen.c                                 | 341 +++++++++++++++++++--
 arch/x86/kvm/xen.h                                 |   9 +
 include/linux/kvm_dirty_ring.h                     |   6 -
 include/linux/kvm_host.h                           | 110 +++++++
 include/linux/kvm_types.h                          |  18 ++
 include/uapi/linux/kvm.h                           |  11 +
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c | 184 ++++++++++-
 virt/kvm/Kconfig                                   |   3 +
 virt/kvm/Makefile.kvm                              |   1 +
 virt/kvm/dirty_ring.c                              |  11 +-
 virt/kvm/kvm_main.c                                |  19 +-
 virt/kvm/kvm_mm.h                                  |  44 +++
 virt/kvm/mmu_lock.h                                |  23 --
 virt/kvm/pfncache.c                                | 337 ++++++++++++++++++++
 23 files changed, 1161 insertions(+), 86 deletions(-)



