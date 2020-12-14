Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E584E2D9437
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 09:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439340AbgLNIkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 03:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439091AbgLNIjx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 03:39:53 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26E3C0613D3
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 00:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=wx/ghlTnyKIamax6lLM5rHnGR9Aiyh/EKRTrwJDR6A4=; b=rKR4diG6ipHmAjh1ZIYTvw6xDj
        kVubC2piqgoSu81jJYrkPp3HhWtbioM9Inw/wXR2owTYK2nJYXxY9e3dBw0er0FmasFJefLIJo9Ww
        6Z2DE7hqGbzDOvETU9QkeTf1sXeZKoA4iVtpUmfLmkTdsmV/MIvntrwo6MoUeyFa7qFISHXdYZ9gY
        6RpOX0TlBNv8VoqjMgtBG2Kaa1OmTemEBGYgoYlu3aSXNt8aZLmM3CGm4OiDxc6of6pNdZeqwqrtL
        jaRFYPHY3Ury0p6MYfQAIELlO70aLED9hEi7zdWcthnBxOWj6mm6KXiUlvcCx2QJY7gEVdi7D8DbP
        Fyyj2xmg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kojNs-00028a-07; Mon, 14 Dec 2020 08:39:08 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kojNr-008SxU-IJ; Mon, 14 Dec 2020 08:39:07 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com
Subject: [PATCH v3 00/17] KVM: Add minimal support for Xen HVM guests
Date:   Mon, 14 Dec 2020 08:38:48 +0000
Message-Id: <20201214083905.2017260-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviving the first section (so far) of a patch set that Joao posted as 
RFC last year:

https://lore.kernel.org/kvm/20190220201609.28290-1-joao.m.martins@oracle.com/

This is just enough to support Xen HVM guests. It allows hypercalls to
be trapped to userspace for handling, uses the existing KVM functions for
writing system clock and pvclock information to Xen shared pages, and
adds Xen runstate info and event channel upcall vector delivery.

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

 Documentation/virt/kvm/api.rst                       | 123 ++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h                      |  24 ++++
 arch/x86/include/asm/xen/interface.h                 |   3 +
 arch/x86/kvm/Makefile                                |   2 +-
 arch/x86/kvm/hyperv.c                                |  40 +++++--
 arch/x86/kvm/irq.c                                   |   7 ++
 arch/x86/kvm/trace.h                                 |  36 ++++++
 arch/x86/kvm/x86.c                                   | 142 ++++++++++++++---------
 arch/x86/kvm/x86.h                                   |   1 +
 arch/x86/kvm/xen.c                                   | 495 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/xen.h                                   |  68 +++++++++++
 include/linux/kvm_host.h                             |  34 +++---
 include/uapi/linux/kvm.h                             |  50 ++++++++
 include/xen/interface/xen.h                          |   4 +-
 tools/testing/selftests/kvm/Makefile                 |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c           |   1 +
 tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c | 194 +++++++++++++++++++++++++++++++
 tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c | 150 ++++++++++++++++++++++++
 virt/kvm/kvm_main.c                                  |   8 +-
 19 files changed, 1297 insertions(+), 87 deletions(-)

David Woodhouse (8):
      KVM: Fix arguments to kvm_{un,}map_gfn()
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



