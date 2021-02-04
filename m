Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F066E30DD82
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 16:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbhBCPC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 10:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233500AbhBCPCy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 10:02:54 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFF1C0612F2
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 07:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=x2sGKJUCkXfDUUSgDmA+bexsh4nUDvs8zRJ9h3uMecA=; b=Vyi4joLXS8RkyM4J+VgZbA3G7V
        8udkg8hTGWChC8ygLn0fgBBrrdn1deOPEKnV5JUxYyEoNC2uuKBtOChtIbYgR9erfTiE4OXspZmlJ
        n7H217zepui9j7cDAoB8mhestVjGQTecUQ0sJ+lFQ1rFzDVos3PaKL1Nu/Xw4FKA8ZwRJ/G/FTuVV
        2ZdD6BTJJz01tNbjgyBae0csK/ThA3KiF4OMEyPysoonC8kwInVqk8ZNKG79PIpmzQzFm3jixXskO
        c86CEYOJfEM6cSVoZ892lwl0sPPEseRmBgBAIAyEOfAM5DzYWm9FfAp7b6i4j8suMJGulSSo17A5C
        YvyH3H4g==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Jef-00H3zF-Ef; Wed, 03 Feb 2021 15:01:20 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Jef-003re8-0g; Wed, 03 Feb 2021 15:01:17 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH v6 00/19] KVM: Add minimal support for Xen HVM guests
Date:   Wed,  3 Feb 2021 15:00:55 +0000
Message-Id: <20210203150114.920335-1-dwmw2@infradead.org>
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
pvclock information to Xen shared pages, and event channel upcall vector 
delivery.

It's based on the first section of a patch set that Joao posted as 
RFC last year^W^W in 2019:

https://lore.kernel.org/kvm/20190220201609.28290-1-joao.m.martins@oracle.com/

In v6 I've dropped the runstate support temporarily. It can come in the 
next round of patches, and I want to give it more thought. In particular 
Paul pointed out that we need to support VCPUOP_get_runstate_info — the 
runstate times aren't *only* exposed to a guest by putting them directly 
into the guest memory. So we'll need an ioctl to fetch them to userspace 
as well as to set them on live migration. I've expanded the padding in 
the newly added KVM_XEN_VCPU_[SG]ET_ATTR ioctls to make sure there's 
room.

I also want to double-check we're setting the runstates faithfully as 
Xen guests will expect in all circumstances. I think we may want a way 
for userspace to tell the kernel to set RUNSTATE_blocked and offline, 
and that can be set as a vCPU attr too.

Will work on that and post it along with the oft-promised second round,
but this part stands alone and should be ready to merge.

The rust-vmm support for this is starting to take shape at
https://github.com/alexandruag/vmm-reference/commits/xen

Change log for my postings:
v1:
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

v6:
 • Move per-vCPU attributes to KVM_XEN_VCPU_[SG]ET_ATTR ioctl.
 • Drop runstate support for now; that needs more work/thought.
 • Add static key for kvm_xen_enabled to eliminate overhead.
 • Fix pre-existing lack of __user tag in hypercall page setup.
 • Expand padding in attribute ioctl structs to 8 64-bit words.

 Documentation/virt/kvm/api.rst                     | 170 ++++++++-
 arch/x86/include/asm/kvm_host.h                    |  19 +
 arch/x86/include/asm/xen/interface.h               |   3 +
 arch/x86/kvm/Makefile                              |   2 +-
 arch/x86/kvm/hyperv.c                              |  40 +-
 arch/x86/kvm/irq.c                                 |   7 +
 arch/x86/kvm/trace.h                               |  36 ++
 arch/x86/kvm/x86.c                                 | 140 ++++---
 arch/x86/kvm/x86.h                                 |   1 +
 arch/x86/kvm/xen.c                                 | 411 +++++++++++++++++++++
 arch/x86/kvm/xen.h                                 |  77 ++++
 include/uapi/linux/kvm.h                           |  60 +++
 include/xen/interface/xen.h                        |   4 +-
 tools/testing/selftests/kvm/Makefile               |   3 +
 tools/testing/selftests/kvm/lib/kvm_util.c         |   1 +
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c | 197 ++++++++++
 .../testing/selftests/kvm/x86_64/xen_vmcall_test.c | 150 ++++++++
 17 files changed, 1251 insertions(+), 70 deletions(-)

David Woodhouse (10):
      KVM: x86/xen: Fix __user pointer handling for hypercall page installation
      KVM: x86/xen: Move KVM_XEN_HVM_CONFIG handling to xen.c
      KVM: x86/xen: Add kvm_xen_enabled static key
      KVM: x86/xen: latch long_mode when hypercall page is set up
      KVM: x86/xen: add definitions of compat_shared_info, compat_vcpu_info
      xen: add wc_sec_hi to struct shared_info
      KVM: x86/xen: Add KVM_XEN_VCPU_SET_ATTR/KVM_XEN_VCPU_GET_ATTR
      KVM: x86/xen: Add event channel interrupt vector upcall
      KVM: x86: declare Xen HVM shared info capability and add test case
      KVM: Add documentation for Xen hypercall and shared_info updates

Joao Martins (9):
      KVM: x86/xen: fix Xen hypercall page msr handling
      KVM: x86/xen: intercept xen hypercalls if enabled
      KVM: x86/xen: Fix coexistence of Xen and Hyper-V hypercalls
      KVM: x86/xen: add KVM_XEN_HVM_SET_ATTR/KVM_XEN_HVM_GET_ATTR
      KVM: x86/xen: register shared_info page
      KVM: x86/xen: update wallclock region
      KVM: x86/xen: register vcpu info
      KVM: x86/xen: setup pvclock updates
      KVM: x86/xen: register vcpu time info region


