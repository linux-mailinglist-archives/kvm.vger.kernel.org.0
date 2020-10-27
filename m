Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F0829CB6F
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 22:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374261AbgJ0VnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 17:43:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:17169 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S374255AbgJ0VnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 17:43:02 -0400
IronPort-SDR: jhBCm9qfTYj7cDTBCGQE3rafoavo71X0dvxRFhcKbDNxMe+TsYQwaY68C78srn84FkhJh55GHJ
 uZbymX0/fN2g==
X-IronPort-AV: E=McAfee;i="6000,8403,9787"; a="164667230"
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="164667230"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 14:43:01 -0700
IronPort-SDR: pBWXmGg2hoMlOZK03fXrXVykvhvHWMqpc14Ocyp6ZoqiswJy47qT2/VV+/ub4fZUz+Jv8muNnH
 S2Vc9/xB0A9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="334537302"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga002.jf.intel.com with ESMTP; 27 Oct 2020 14:43:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Subject: [PATCH 0/3] KVM: x86/mmu: Add macro for hugepage GFN mask
Date:   Tue, 27 Oct 2020 14:42:57 -0700
Message-Id: <20201027214300.1342-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a macro, which is probably long overdue, to replace open coded
variants of "~(KVM_PAGES_PER_HPAGE(level) - 1)".  The straw that broke the
camel's back is the TDP MMU's round_gfn_for_level(), which goes straight
for the optimized approach of using NEG instead of SUB+NOT (gcc uses NEG
for both).  The use of '-(...)' made me do a double take (more like a
quadrupal take) when reading the TDP MMU code as my eyes/brain have been
heavily trained to look for the more common '~(... - 1)'.

Sean Christopherson (3):
  KVM: x86/mmu: Add helper macro for computing hugepage GFN mask
  KVM: x86/mmu: Open code GFN "rounding" in TDP MMU
  KVM: x86/mmu: Use hugepage GFN mask to compute GFN offset mask

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu/mmu.c          |  4 ++--
 arch/x86/kvm/mmu/mmutrace.h     |  2 +-
 arch/x86/kvm/mmu/paging_tmpl.h  |  4 ++--
 arch/x86/kvm/mmu/tdp_iter.c     | 11 +++--------
 arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
 arch/x86/kvm/x86.c              |  6 +++---
 7 files changed, 13 insertions(+), 17 deletions(-)

-- 
2.28.0

