Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1FC1F82C5
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 23:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfKKWMc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 17:12:32 -0500
Received: from mga03.intel.com ([134.134.136.65]:2932 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726946AbfKKWMb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 17:12:31 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Nov 2019 14:12:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,294,1569308400"; 
   d="scan'208";a="287302340"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 11 Nov 2019 14:12:29 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Adam Borowski <kilobyte@angband.pl>,
        David Hildenbrand <david@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 0/3] KVM: MMU: Fix a refcount bug with ZONE_DEVICE pages
Date:   Mon, 11 Nov 2019 14:12:26 -0800
Message-Id: <20191111221229.24732-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This mini-series fixes a suspected, but technically unconfirmed, bug in
KVM related to ZONE_DEVICE pages.  The suspected issue is that KVM treats
ZONE_DEVICE pages as reserved PFNs, and so doesn't put references to such
pages when dropping references via KVM's generic kvm_release_pfn_clean().

David Hildenbrand uncovered the bug during a discussion about removing
PG_reserved from ZONE_DEVICE pages, after Dan Williams pointed out[1] that
there was a bug report from Adam Borowski[2] that was likely related to
KVM's interaction with PageReserved().

Patch 1/3 contains the actual fix, patches 2/3 and 3/3 are minor cleanup
that is mostly unrelated, but dependent and prompted by the fix itself.

v2:
  - Remove the kvm_is_zone_device_pfn(pfn) check from kvm_get_pfn().  It's
    not entirely clear whether or not the hva_to_pfn_remapped() case is
    actually broken, e.g. KVM's page fault handler is likely ok, whereas
    not calling get_page() willl definitely cause breakage as KVM would
    later call put_page() on the pfn/page. [Paolo]

  - WARN if kvm_is_zone_device_pfn() is called without the underlying
    page being pinned.  This won't necessarily catch all bugs, e.g. if
    the above hva_to_pfn_remapped case is indeed broken, but will
    prevent completely bogus usage. [Dan]

  - Remove the is_error_pfn() check from transparent_hugepage_adjust()
    instead of carrying it forward into the new kvm_is_hugepage_allowed()
    helper. [Paolo]

[1] http://lkml.kernel.org/r/20190919115547.GA17963@angband.pl
[2] https://lkml.kernel.org/r/01adb4cb-6092-638c-0bab-e61322be7cf5@redhat.com

Sean Christopherson (3):
  KVM: MMU: Do not treat ZONE_DEVICE pages as being reserved
  KVM: x86/mmu: Remove superfluous is_error_pfn() check from THP adjust
  KVM: x86/mmu: Add helper to consolidate huge page promotion

 arch/x86/kvm/mmu.c       | 15 +++++++++------
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 26 +++++++++++++++++++++++---
 3 files changed, 33 insertions(+), 9 deletions(-)

-- 
2.24.0

