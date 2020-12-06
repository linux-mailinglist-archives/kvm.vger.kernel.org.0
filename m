Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E062D0327
	for <lists+kvm@lfdr.de>; Sun,  6 Dec 2020 12:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbgLFLFE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 06:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727195AbgLFLE4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 06:04:56 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC542C08E863
        for <kvm@vger.kernel.org>; Sun,  6 Dec 2020 03:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=boRAwl+8YI6+G24ygg7y9yhULYmaOwaszHt5VWh3u9Q=; b=lrsLhNrr0jzWTw3Du4KdVtnOud
        3HuSyL9ZTVy/bYSUsuhUSxnKBTsltOM61DyVaNlmoogmNcUxJDZII3RVzNXAO1/9K8XgMMuzf/P4l
        6emUyNquJdd8CR29hWyrkGycNgSPyOXSQDIvRbfPMETtT2BEN/b6fFT3MFzadES8JzuDvxfwXDKzq
        sT1Z288tlUsKUgM4CPbazo9CAfp4eMY5LeWRhXQolmA40lcfoi/5nD7X7XqVJ7LYKS6E7y+zJn6iF
        hQGdwU9OspUanzW02imyhfVdzc1Qs1b2/6lrVjTFIYnKJBPg+vqVtecXX6qui5h1EAQoZje3pLWMb
        0cCuVsbQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1klrpD-0006Fn-WE; Sun, 06 Dec 2020 11:03:41 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1klrpD-000jp8-Ia; Sun, 06 Dec 2020 11:03:31 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de
Subject: [PATCH v2 00/16] KVM: Add Xen hypercall and shared info pages
Date:   Sun,  6 Dec 2020 11:03:11 +0000
Message-Id: <20201206110327.175629-1-dwmw2@infradead.org>
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

This adds basic hypercall interception support, and adds support for
timekeeping and runstate-related shared info regions.

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

David Woodhouse (7):
      KVM: Fix arguments to kvm_{un,}map_gfn()
      KVM: x86/xen: Fix coexistence of Xen and Hyper-V hypercalls
      KVM: x86/xen: latch long_mode when hypercall page is set up
      KVM: x86/xen: add definitions of compat_shared_info, compat_vcpu_info
      xen: add wc_sec_hi to struct shared_info
      KVM: x86: declare Xen HVM shared info capability and add test case
      KVM: Add documentation for Xen hypercall and shared_info updates

Joao Martins (9):
      KVM: x86/xen: fix Xen hypercall page msr handling
      KVM: x86/xen: intercept xen hypercalls if enabled
      KVM: x86/xen: add KVM_XEN_HVM_SET_ATTR/KVM_XEN_HVM_GET_ATTR
      KVM: x86/xen: register shared_info page
      KVM: x86/xen: setup pvclock updates
      KVM: x86/xen: update wallclock region
      KVM: x86/xen: register vcpu info
      KVM: x86/xen: register vcpu time info region
      KVM: x86/xen: register runstate info

 Documentation/virt/kvm/api.rst                       | 119 ++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h                      |  23 +++++++
 arch/x86/include/asm/xen/interface.h                 |   3 +
 arch/x86/kvm/Makefile                                |   2 +-
 arch/x86/kvm/hyperv.c                                |  40 ++++++++----
 arch/x86/kvm/trace.h                                 |  36 +++++++++++
 arch/x86/kvm/x86.c                                   | 110 ++++++++++++++++++++------------
 arch/x86/kvm/x86.h                                   |   1 +
 arch/x86/kvm/xen.c                                   | 557 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/xen.h                                   |  83 ++++++++++++++++++++++++
 include/linux/kvm_host.h                             |  34 +++++-----
 include/uapi/linux/kvm.h                             |  48 ++++++++++++++
 include/xen/interface/xen.h                          |   4 +-
 tools/testing/selftests/kvm/Makefile                 |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c           |   1 +
 tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c | 187 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c | 150 +++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c                                  |   8 +--
 18 files changed, 1335 insertions(+), 73 deletions(-)


