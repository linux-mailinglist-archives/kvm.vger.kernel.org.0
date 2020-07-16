Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93512221AFF
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 05:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgGPDlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 23:41:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:49384 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726905AbgGPDlZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 23:41:25 -0400
IronPort-SDR: /rECrXmQotmxWnPcx0EoBt6V2wNPBDb2Z8LG1TYxqHOzKG0WytouaPiF++duP31wDYk9/IFbTx
 ptA1ef/0q3/w==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="147310947"
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="147310947"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 20:41:24 -0700
IronPort-SDR: 7CSdzCyxxWWy3tQqd6zryT58WT1lkLoWGg/ZFMryPCvwMYmrGoyVST5LGfeq3X+BMNHUbM4vmj
 UfVSxyC6ZQXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="316905467"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga008.jf.intel.com with ESMTP; 15 Jul 2020 20:41:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] KVM: x86: TDP level cleanups and shadow NPT fix
Date:   Wed, 15 Jul 2020 20:41:13 -0700
Message-Id: <20200716034122.5998-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The primary purpose of this series is to implement a suggestion from Paolo
to have the MMU make the decision between 4 and 5 level EPT/TDP (when
5-level page tables are supported).  Having the MMU "own" the decision of
whether or not to use 5-level paging leads to a variety of nice cleanups,
and ultimately gets rid of another kvm_x86_ops.

Patch 1 is a fix for SVM's shadow NPT that is compile tested only.  I
don't know enough about the shadow NPT details to know if it's a "real"
bug or just a supericial oddity that can't actually cause problems.

"Remove temporary WARN on expected vs. actual EPTP level mismatch" could
easily be squashed with "Pull the PGD's level from the MMU instead of
recalculating it", I threw it in as a separate patch to provide a
bisection helper in case things go sideways.

Sean Christopherson (9):
  KVM: nSVM: Correctly set the shadow NPT root level in its MMU role
  KVM: x86/mmu: Add separate helper for shadow NPT root page role calc
  KVM: VMX: Drop a duplicate declaration of construct_eptp()
  KVM: VMX: Make vmx_load_mmu_pgd() static
  KVM: x86: Pull the PGD's level from the MMU instead of recalculating
    it
  KVM: VXM: Remove temporary WARN on expected vs. actual EPTP level
    mismatch
  KVM: x86: Dynamically calculate TDP level from max level and
    MAXPHYADDR
  KVM: x86/mmu: Rename max_page_level to max_huge_page_level
  KVM: x86: Specify max TDP level via kvm_configure_mmu()

 arch/x86/include/asm/kvm_host.h |  9 ++---
 arch/x86/kvm/cpuid.c            |  2 --
 arch/x86/kvm/mmu.h              | 10 ++++--
 arch/x86/kvm/mmu/mmu.c          | 63 +++++++++++++++++++++++++--------
 arch/x86/kvm/svm/nested.c       |  1 -
 arch/x86/kvm/svm/svm.c          |  8 ++---
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/vmx/vmx.c          | 31 +++++++---------
 arch/x86/kvm/vmx/vmx.h          |  6 ++--
 arch/x86/kvm/x86.c              |  1 -
 10 files changed, 81 insertions(+), 52 deletions(-)

-- 
2.26.0

