Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B762F2030
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 20:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391422AbhAKT6z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 14:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391405AbhAKT6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 14:58:53 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D991EC0617A7
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 11:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=MPnGeTXXSDHQnncDdsvtf1rAofte1AgKCB/siFe7Psk=; b=nxLj2JUfAcGxDLnsgEU2dLCnmJ
        OY/3K5D0Jp6b8hKhHSsg2mtNG2RxWut55D6Dch1LFJC/KobKMwWhGEsFFOtb1Z/9BOqDelMDo8p3u
        tVQ3AVLzlDgyr29djAZZXDx2GuA+DwD0F6rC3rnEDwJy5M+EJ5Tllai+vp/Fk5OaE2IBYzhRRmLmE
        iY1iJbjTWczinEAsb+vAL/x9WaFiuZYSjKDuzURy4B8O9Xdyxixrr9PrkIYKQmn9XPtkozbhKpfSj
        1u9+YA90d9aUCQSSkRxujuKeGMUQBWr9HjjVQp9aLsgwPU/uHgLMy4OZX3OB1A/g/qjfX+Dxz5s1E
        qk8WTvkg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kz3Jf-003kSV-SH; Mon, 11 Jan 2021 19:57:37 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kz3Jf-0001HM-Ca; Mon, 11 Jan 2021 19:57:27 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH v5 00/16] KVM: Add minimal support for Xen HVM guests
Date:   Mon, 11 Jan 2021 19:57:09 +0000
Message-Id: <20210111195725.4601-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch set provides enough kernel support to allow hosting Xen HVM 
guests in KVM. It allows hypercalls to be trapped to userspace for 
handling, uses the existing KVM functions for writing system clock and 
pvclock information to Xen shared pages, and adds Xen runstate info and 
event channel upcall vector delivery.

It's based on the first section of a patch set that Joao posted as 
RFC last year^W^W in 2019:

https://lore.kernel.org/kvm/20190220201609.28290-1-joao.m.martins@oracle.com/

I've updated and reworked the original a bit, including (in my v1):
 • Support for 32-bit guests
 • 64-bit second support in wallclock
 • Time counters for runnable/blocked states in runstate support
 • Self-tests
 • Fixed Viridian coexistence
 • No new KVM_CAP_XEN_xxx, just more bits returned by KVM_CAP_XEN_HVM

v2: 
 • Remember the RCU read-critical sections on using the shared info pages
 • Fix 32-bit build of compat structures (which we use there too)
 • Use RUNSTATE_blocked as initial state not RUNSTATE_runnable
 • Include documentation, add cosmetic KVM_XEN_HVM_CONFIG_HYPERCALL_MSR

v3:
 • Stop mapping the shared pages; use kvm_guest_write_cached() instead.
 • Use kvm_setup_pvclock_page() for Xen pvclock writes too.
 • Fix CPU numbering confusion and update documentation accordingly.
 • Support HVMIRQ_callback_vector delivery based on evtchn_upcall_pending.

v4:
 • Rebase on top of the KVM changes merged into 5.11-rc1.
 • Drop the kvm_{un,}map_gfn() cleanup as it isn't used since v2 anyway.
 • Trivial cosmetic cleanup (superfluous parens, remove declaration of a
   function removed in v3, etc.)

v5:
 • Rebased onto kvm/next as of 2021-01-08 (commit 872f36eb0b0f4).
 • Fix error handling for XEN_HVM_GET_ATTR.
 • Stop moving struct kvm_host_map definition; it's not used any more.
 • Add explicit padding to struct kvm_xen_hvm_attr to make it have
   identical layout on 32-bit vs. 64-bit machines.

With the addition in v3 of the callback vector support, we can now 
successfully boot Linux guests. Other callback types can be handled 
entirely from userspace, but the vector injection needs kernel support 
because it doesn't quite work to inject it as ExtINT.

We will work on a little bit more event channel offload in future patches,
as discussed, but those are purely optimisations. There's a bunch of work
for us to do in userspace before those get to the top of our list, and
this patch set should be functionally complete as it is.

We're working on pushing out rust-vmm support to make use of this, and
Joao's qemu patches from last year should still also work with minor
tweaks where I've "improved" the KVM←→userspace ABI.
David Woodhouse (7):
      KVM: x86/xen: Fix coexistence of Xen and Hyper-V hypercalls
      KVM: x86/xen: latch long_mode when hypercall page is set up
      KVM: x86/xen: add definitions of compat_shared_info, compat_vcpu_info
      xen: add wc_sec_hi to struct shared_info
      KVM: x86: declare Xen HVM shared info capability and add test case
      KVM: Add documentation for Xen hypercall and shared_info updates
      KVM: x86/xen: Add event channel interrupt vector upcall

Joao Martins (9):
      KVM: x86/xen: fix Xen hypercall page msr handling
      KVM: x86/xen: intercept xen hypercalls if enabled
      KVM: x86/xen: add KVM_XEN_HVM_SET_ATTR/KVM_XEN_HVM_GET_ATTR
      KVM: x86/xen: register shared_info page
      KVM: x86/xen: update wallclock region
      KVM: x86/xen: register vcpu info
      KVM: x86/xen: setup pvclock updates
      KVM: x86/xen: register vcpu time info region
      KVM: x86/xen: register runstate info

 Documentation/virt/kvm/api.rst                     | 124 +++++-
 arch/x86/include/asm/kvm_host.h                    |  24 +
 arch/x86/include/asm/xen/interface.h               |   3 +
 arch/x86/kvm/Makefile                              |   2 +-
 arch/x86/kvm/hyperv.c                              |  40 +-
 arch/x86/kvm/irq.c                                 |   7 +
 arch/x86/kvm/trace.h                               |  36 ++
 arch/x86/kvm/x86.c                                 | 134 ++++--
 arch/x86/kvm/x86.h                                 |   1 +
 arch/x86/kvm/xen.c                                 | 495 +++++++++++++++++++++
 arch/x86/kvm/xen.h                                 |  68 +++
 include/uapi/linux/kvm.h                           |  50 +++
 include/xen/interface/xen.h                        |   4 +-
 tools/testing/selftests/kvm/Makefile               |   3 +
 tools/testing/selftests/kvm/lib/kvm_util.c         |   1 +
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c | 194 ++++++++
 .../testing/selftests/kvm/x86_64/xen_vmcall_test.c | 150 +++++++
 17 files changed, 1273 insertions(+), 63 deletions(-)


