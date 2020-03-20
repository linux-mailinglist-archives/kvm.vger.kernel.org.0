Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9548D18DA6B
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgCTV2n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:28:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:48422 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbgCTV2n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:28:43 -0400
IronPort-SDR: GU+Q+QeM5AKetiqrihQwQXv2HpmM/C3sog9g2UTTYoPrLvZyNSzMpo6PoAccwxsQkljQhBJudl
 HFqSc1LIdJ2w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 14:28:42 -0700
IronPort-SDR: FG4X1vP1tOia9kFijfJtEYk1fqaXP7us9tlN+/O9DXilhz36QnPgodZEp9c7fjA/O52xXnqpU9
 YUw1Abe4ILFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="269224390"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Mar 2020 14:28:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v3 00/37] KVM: x86: TLB flushing fixes and enhancements
Date:   Fri, 20 Mar 2020 14:27:56 -0700
Message-Id: <20200320212833.3507-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VMX TLB flushing cleanup series to fix a variety of bugs, and to avoid
unnecessary TLB flushes on nested VMX transitions.

  1) Nested VMX doesn't properly flush all ASIDs/contexts on system events,
     e.g. on mmu_notifier invalidate all contexts for L1 *and* L2 need to
     be invalidated, but KVM generally only flushes L1 or L2 (or just L1).

  2) #1 is largely benign because nested VMX always flushes the new
     context on nested VM-Entry/VM-Exit.

High level overview:

  a) Fix the main TLB flushing bug with a big hammer.

  b) Fix a few other flushing related bugs.

  c) Clean up vmx_tlb_flush(), i.e. what was v1 of this series.

  d) Reintroduce current-ASID/context flushing to regain some of the
     precision that got blasted away by the big hammer in #1.

  e) Fix random code paths that unnecessarily trigger TLB flushes on
     nested VMX transitions.

  f) Stop flushing on every nested VMX transition.

  g) Extra cleanup.


v3:
  - Fix freeing of roots during INVVPID, I botched things when tweaking
    Junaid's original patch.
  - Move "last vpid02" logic into nested VMX flushing helper. [Paolo]
  - Split "skip tlb flush" and "skip mmu sync" logic during fast roots
    switch. [Paolo]
  - Unconditionally skip tlb flush during fast roots switch on nested VMX
    transitions, i.e. let nested_vmx_transition_tlb_flush() do the work.
    This avoids flushing when EPT=0 and VPID=1. [Paolo]
  - Do more cr3->pgd conversions in related code that drove me bonkers
    when trying to figure out what was broken with VPID.  I think this
    knocks off the last code that uses "cr3" for variables/functions that
    work with cr3 or eptp.

v2:
  - Basically a new series.

v1:
  - https://patchwork.kernel.org/cover/11394987/

Junaid Shahid (2):
  KVM: nVMX: Invalidate all roots when emulating INVVPID without EPT
  KVM: x86: Sync SPTEs when injecting page/EPT fault into L1

Sean Christopherson (35):
  KVM: VMX: Flush all EPTP/VPID contexts on remote TLB flush
  KVM: nVMX: Validate the EPTP when emulating INVEPT(EXTENT_CONTEXT)
  KVM: nVMX: Invalidate all EPTP contexts when emulating INVEPT for L1
  KVM: x86: Export kvm_propagate_fault() (as
    kvm_inject_emulated_page_fault)
  KVM: x86: Consolidate logic for injecting page faults to L1
  KVM: VMX: Skip global INVVPID fallback if vpid==0 in
    vpid_sync_context()
  KVM: VMX: Use vpid_sync_context() directly when possible
  KVM: VMX: Move vpid_sync_vcpu_addr() down a few lines
  KVM: VMX: Handle INVVPID fallback logic in vpid_sync_vcpu_addr()
  KVM: VMX: Drop redundant capability checks in low level INVVPID
    helpers
  KVM: nVMX: Use vpid_sync_vcpu_addr() to emulate INVVPID with address
  KVM: x86: Move "flush guest's TLB" logic to separate kvm_x86_ops hook
  KVM: VMX: Clean up vmx_flush_tlb_gva()
  KVM: x86: Drop @invalidate_gpa param from kvm_x86_ops' tlb_flush()
  KVM: SVM: Wire up ->tlb_flush_guest() directly to svm_flush_tlb()
  KVM: VMX: Move vmx_flush_tlb() to vmx.c
  KVM: nVMX: Move nested_get_vpid02() to vmx/nested.h
  KVM: VMX: Introduce vmx_flush_tlb_current()
  KVM: SVM: Document the ASID logic in svm_flush_tlb()
  KVM: x86: Rename ->tlb_flush() to ->tlb_flush_all()
  KVM: nVMX: Add helper to handle TLB flushes on nested VM-Enter/VM-Exit
  KVM: x86: Introduce KVM_REQ_TLB_FLUSH_CURRENT to flush current ASID
  KVM: x86/mmu: Use KVM_REQ_TLB_FLUSH_CURRENT for MMU specific flushes
  KVM: nVMX: Selectively use TLB_FLUSH_CURRENT for nested
    VM-Enter/VM-Exit
  KVM: nVMX: Reload APIC access page on nested VM-Exit only if necessary
  KVM: VMX: Retrieve APIC access page HPA only when necessary
  KVM: VMX: Don't reload APIC access page if its control is disabled
  KVM: x86/mmu: Move fast_cr3_switch() side effects to
    __kvm_mmu_new_cr3()
  KVM: x86/mmu: Add separate override for MMU sync during fast CR3
    switch
  KVM: x86/mmu: Add module param to force TLB flush on root reuse
  KVM: nVMX: Skip MMU sync on nested VMX transition when possible
  KVM: nVMX: Don't flush TLB on nested VMX transition
  KVM: nVMX: Free only the affected contexts when emulating INVEPT
  KVM: x86: Replace "cr3" with "pgd" in "new cr3/pgd" related code
  KVM: VMX: Clean cr3/pgd handling in vmx_load_mmu_pgd()

 arch/x86/include/asm/kvm_host.h |  25 +++-
 arch/x86/kvm/mmu/mmu.c          | 145 +++++++++----------
 arch/x86/kvm/mmu/paging_tmpl.h  |   2 +-
 arch/x86/kvm/svm.c              |  19 ++-
 arch/x86/kvm/vmx/nested.c       | 249 ++++++++++++++++++++++----------
 arch/x86/kvm/vmx/nested.h       |   7 +
 arch/x86/kvm/vmx/ops.h          |  32 ++--
 arch/x86/kvm/vmx/vmx.c          | 119 ++++++++++++---
 arch/x86/kvm/vmx/vmx.h          |  19 +--
 arch/x86/kvm/x86.c              |  67 ++++++---
 arch/x86/kvm/x86.h              |   6 +
 11 files changed, 448 insertions(+), 242 deletions(-)

-- 
2.24.1

