Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E8B2CE4ED
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 02:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388396AbgLDBUO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 20:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388385AbgLDBUN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 20:20:13 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60802C08E860
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 17:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=5/ALs+wec0ATyor0qyB+ptL8rnFvrdLxgaVqB/c//Ts=; b=pLlRSn7dVAbUIKxLAgtAS/gZII
        8p/OqVEbwlRWZEgJy8zgLBWM5nvNS4iFvNYr6fHF3/jO/5fMnMXCnV2io2TDIG+s7s+2TvKmNYYGp
        WgMl5d8NDGc4TuCaE8JGleWKePJJrqf0xCDINmuVCNrP9ZAWc8MB/PR+rWwZehkBDlIs8Qzf1JpnC
        7IQrpTlyd5jozg/+FsvZr723o3teaVwhe57oDAqKQyueNP3w9IwA4TzftbRxg9pZU9VcDlwvnutKt
        jJ8Ln+/fVRYN6pAfk3euzoU9K6XwUMGaLnK+Lcrf07tIppWjCLSK+rnnoGZVbceA7fzC56WfkUXnK
        r1kzqn/A==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkzkK-0004KY-Jj; Fri, 04 Dec 2020 01:18:53 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kkzkK-00CS9i-67; Fri, 04 Dec 2020 01:18:52 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 00/15] KVM: Add Xen hypercall and shared info pages
Date:   Fri,  4 Dec 2020 01:18:33 +0000
Message-Id: <20201204011848.2967588-1-dwmw2@infradead.org>
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

I've updated and reworked the original a bit, including:
 • Support for 32-bit guests
 • 64-bit second support in wallclock
 • Time counters for runnable/blocked states in runstate support
 • Self-tests
 • Fixed Viridian coexistence
 • No new KVM_CAP_XEN_xxx, just more bits returned by KVM_CAP_XEN_HVM

I'm about to do the event channel support, but this part stands alone
and should be sufficient to get a fully functional Xen HVM guest running.

David Woodhouse (6):
      KVM: Fix arguments to kvm_{un,}map_gfn()
      KVM: x86/xen: Fix coexistence of Xen and Hyper-V hypercalls
      KVM: x86/xen: latch long_mode when hypercall page is set up
      KVM: x86/xen: add definitions of compat_shared_info, compat_vcpu_info
      xen: add wc_sec_hi to struct shared_info
      KVM: x86: declare Xen HVM shared info capability and add test case

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

 arch/x86/include/asm/kvm_host.h                    |  23 +
 arch/x86/include/asm/xen/interface.h               |   3 +
 arch/x86/kvm/Makefile                              |   2 +-
 arch/x86/kvm/hyperv.c                              |  40 +-
 arch/x86/kvm/trace.h                               |  36 ++
 arch/x86/kvm/x86.c                                 | 109 +++--
 arch/x86/kvm/x86.h                                 |   1 +
 arch/x86/kvm/xen.c                                 | 544 +++++++++++++++++++++
 arch/x86/kvm/xen.h                                 |  83 ++++
 include/linux/kvm_host.h                           |  34 +-
 include/uapi/linux/kvm.h                           |  47 ++
 include/xen/interface/xen.h                        |   4 +-
 tools/testing/selftests/kvm/Makefile               |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c         |   1 +
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c | 187 +++++++
 .../testing/selftests/kvm/x86_64/xen_vmcall_test.c | 150 ++++++
 virt/kvm/kvm_main.c                                |   8 +-
 17 files changed, 1201 insertions(+), 73 deletions(-)

32-bit guests, and fleshed out the runstate information a little more
to add times for all of running, runnable, blocked states.




