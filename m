Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE65036565D
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 12:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbhDTKmO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 06:42:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:42730 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231616AbhDTKmO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 06:42:14 -0400
IronPort-SDR: lG7L4W8RnIU5MD3t9L40ScotXDyhO78ah+b969iYS5qieuQo8UnlF1oUWYKhWT4z7mHIniMQp1
 9daQSdPkLgUg==
X-IronPort-AV: E=McAfee;i="6200,9189,9959"; a="216071823"
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="216071823"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 03:41:43 -0700
IronPort-SDR: 6ZzKjAGijILXCQakuNDkwtxSKSSj4WG7QnTq/nfOJEwHo+leqxCC6uKaiDMHlZs6c19yChpgOu
 RDVc4UFZ5DtA==
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="420359503"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 03:41:43 -0700
From:   Isaku Yamahata <isaku.yamahata@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Cc:     isaku.yamahata@gmail.com, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [RFC PATCH 00/10] KVM: x86/mmu: simplify argument to kvm page fault handler
Date:   Tue, 20 Apr 2021 03:39:10 -0700
Message-Id: <cover.1618914692.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a preliminary clean up for TDX which complicates KVM page fault
execution path. simplify those execution path as preparation.

The current kvm page fault handlers passes around many arguments to the
functions.
To simplify those arguments and local variables, introduce data structure,
struct kvm_page_fault,  to hold those arguments, variables, and passes around the pointer
to struct kvm_page_fault.

struct kvm_page_fault is allocated on stack on the caller of kvm fault handler,
kvm_mmu_do_page_fault().
And then  push down the pointer to inner functions step by step.
The conversion order is as follows
. kvm_mmu_do_page_fault() with introducing struct kvm_page_fault
. kvm_mmu.page_fault(): kvm_tdp_page_fault(), nonpaging_page_fault(), FNAME(page_fault)
. direct_page_fault()
. try_async_pf()
. page_fault_handle_page_track()
. handle_abnormal_pfn()
. fast_page_fault()
. __direct_map()
. kvm_tdp_mmu_map()
. FNAME(fetch)

Probably more functions should be converted. or some should not converted.
Only code refactoring and no functional change is intended.

Isaku Yamahata (10):
  KVM: x86/mmu: make kvm_mmu_do_page_fault() receive single argument
  KVM: x86/mmu: make kvm_mmu:page_fault receive single argument
  KVM: x86/mmu: make direct_page_fault() receive single argument
  KVM: x86/mmu: make try_async_pf() receive single argument
  KVM: x86/mmu: make page_fault_handle_page_track() receive single
    argument
  KVM: x86/mmu: make handle_abnormal_pfn() receive single argument
  KVM: x86/mmu: make fast_page_fault() receive single argument
  KVM: x86/mmu: make __direct_map() receive single argument
  KVM: x86/mmu: make kvm_tdp_mmu_map() receive single argument
  KVM: x86/mmu: make FNAME(fetch) receive single argument

 arch/x86/include/asm/kvm_host.h |   4 +-
 arch/x86/kvm/mmu.h              |  49 ++++++++++--
 arch/x86/kvm/mmu/mmu.c          | 130 +++++++++++++++++---------------
 arch/x86/kvm/mmu/paging_tmpl.h  |  60 +++++++--------
 arch/x86/kvm/mmu/tdp_mmu.c      |  21 +++---
 arch/x86/kvm/mmu/tdp_mmu.h      |   4 +-
 arch/x86/kvm/x86.c              |   4 +-
 7 files changed, 156 insertions(+), 116 deletions(-)

-- 
2.25.1

