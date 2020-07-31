Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0642A234CEF
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 23:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgGaVX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 17:23:27 -0400
Received: from mga14.intel.com ([192.55.52.115]:50224 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728027AbgGaVX1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 17:23:27 -0400
IronPort-SDR: ZBz6V6WaNrLKHT/hmbuXgNaSK7/2VwSs/i68D9Wjyyg0HIZA7nv/YKfhEM3PlbdXDmixlQJ2Cb
 mF7NAMcfHcBg==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="151075125"
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="151075125"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 14:23:26 -0700
IronPort-SDR: FQX8kvUq1WMuEMWxYH69vvjsYSSY8E6ZU5NQ1EKCGQbaqITJBedMOoRgSTlM9BFkp6HK/5790Z
 +s+XfyFzG7bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="331191293"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga007.jf.intel.com with ESMTP; 31 Jul 2020 14:23:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        eric van tassell <Eric.VanTassell@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [RFC PATCH 0/8] KVM: x86/mmu: Introduce pinned SPTEs framework
Date:   Fri, 31 Jul 2020 14:23:15 -0700
Message-Id: <20200731212323.21746-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV currently needs to pin guest memory as it doesn't support migrating
encrypted pages.  Introduce a framework in KVM's MMU to support pinning
pages on demand without requiring additional memory allocations, and with
(somewhat hazy) line of sight toward supporting more advanced features for
encrypted guest memory, e.g. host page migration.

The idea is to use a software available bit in the SPTE to track that a
page has been pinned.  The decision to pin a page and the actual pinning
managment is handled by vendor code via kvm_x86_ops hooks.  There are
intentionally two hooks (zap and unzap) introduced that are not needed for
SEV.  I included them to again show how the flag (probably renamed?) could
be used for more than just pin/unpin.

Bugs in the core implementation are pretty much guaranteed.  The basic
concept has been tested, but in a fairly different incarnation.  Most
notably, tagging PRESENT SPTEs as PINNED has not been tested, although
using the PINNED flag to track zapped (and known to be pinned) SPTEs has
been tested.  I cobbled this variation together fairly quickly to get the
code out there for discussion.

The last patch to pin SEV pages during sev_launch_update_data() is
incomplete; it's there to show how we might leverage MMU-based pinning to
support pinning pages before the guest is live.

Sean Christopherson (8):
  KVM: x86/mmu: Return old SPTE from mmu_spte_clear_track_bits()
  KVM: x86/mmu: Use bits 2:0 to check for present SPTEs
  KVM: x86/mmu: Refactor handling of not-present SPTEs in mmu_set_spte()
  KVM: x86/mmu: Add infrastructure for pinning PFNs on demand
  KVM: SVM: Use the KVM MMU SPTE pinning hooks to pin pages on demand
  KVM: x86/mmu: Move 'pfn' variable to caller of direct_page_fault()
  KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by SEV
  KVM: SVM: Pin SEV pages in MMU during sev_launch_update_data()

 arch/x86/include/asm/kvm_host.h |   7 ++
 arch/x86/kvm/mmu.h              |   3 +
 arch/x86/kvm/mmu/mmu.c          | 186 +++++++++++++++++++++++++-------
 arch/x86/kvm/mmu/paging_tmpl.h  |   3 +-
 arch/x86/kvm/svm/sev.c          | 141 +++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c          |   3 +
 arch/x86/kvm/svm/svm.h          |   3 +
 7 files changed, 302 insertions(+), 44 deletions(-)

-- 
2.28.0

