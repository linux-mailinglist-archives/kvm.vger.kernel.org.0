Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9345D176A5E
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 03:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgCCCCm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 21:02:42 -0500
Received: from mga05.intel.com ([192.55.52.43]:54060 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbgCCCCm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 21:02:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 18:02:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="440384923"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 02 Mar 2020 18:02:40 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/7]  KVM: x86/mmu: nVMX: 5-level paging cleanup and enabling
Date:   Mon,  2 Mar 2020 18:02:33 -0800
Message-Id: <20200303020240.28494-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clean up MMU code related to 5 level paging, expose 5-level EPT to L1, and
additional clean up on top (mostly renames of functions/variables that
caused me no end of confusion when trying to figure out what was broken
at various times).

v3:
  - Dropped fixes for existing 5-level bugs (merged for 5.6).
  - Use get_guest_pgd() instead of get_guest_cr3_or_eptp(). [Paolo]
  - Add patches to fix MMU role calculation to play nice with 5-level
    paging without requiring additional CR4.LA_57 bit.

v2:
  - Increase the nested EPT array sizes to accomodate 5-level paging in
    the patch that adds support for 5-level nested EPT, not in the bug
    fix for 5-level shadow paging.

Sean Christopherson (7):
  KVM: x86/mmu: Don't drop level/direct from MMU role calculation
  KVM: x86/mmu: Drop kvm_mmu_extended_role.cr4_la57 hack
  KVM: nVMX: Allow L1 to use 5-level page walks for nested EPT
  KVM: nVMX: Rename nested_ept_get_cr3() to nested_ept_get_eptp()
  KVM: nVMX: Rename EPTP validity helper and associated variables
  KVM: x86/mmu: Rename kvm_mmu->get_cr3() to ->get_guest_pgd()
  KVM: nVMX: Drop unnecessary check on ept caps for execute-only

 arch/x86/include/asm/kvm_host.h |  3 +-
 arch/x86/include/asm/vmx.h      | 12 +++++++
 arch/x86/kvm/mmu/mmu.c          | 59 +++++++++++++++++----------------
 arch/x86/kvm/mmu/paging_tmpl.h  |  4 +--
 arch/x86/kvm/svm.c              |  2 +-
 arch/x86/kvm/vmx/nested.c       | 52 ++++++++++++++++++-----------
 arch/x86/kvm/vmx/nested.h       |  4 +--
 arch/x86/kvm/vmx/vmx.c          |  3 +-
 arch/x86/kvm/x86.c              |  2 +-
 9 files changed, 82 insertions(+), 59 deletions(-)

-- 
2.24.1

