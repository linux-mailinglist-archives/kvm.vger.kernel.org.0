Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA6921878E4
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 05:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgCQExJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 00:53:09 -0400
Received: from mga04.intel.com ([192.55.52.120]:34097 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbgCQExJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 00:53:09 -0400
IronPort-SDR: 3yMsGf9fnBLKMNiJZMyP47GgCyn6MAoSw/UWZu/xMiC3mNUecYCZwn5Y45T0dXkr+nPD3Omnb8
 uhypt6e7pMiw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 21:53:08 -0700
IronPort-SDR: 3d28gK09PMBZ/J6yoSLgUKx3BNuzPShPJW+mwrgsT39SAcjuYY+Tl3QNShLTXf+TVPN7TXI5f3
 Ihjjsqj0XpqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="355252721"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2020 21:53:08 -0700
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
Subject: [PATCH v2 00/32] KVM: x86: TLB flushing fixes and enhancements
Date:   Mon, 16 Mar 2020 21:52:06 -0700
Message-Id: <20200317045238.30434-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is "v2" of the VMX TLB flushing cleanup series, but over 70% of the
patches are new in v2.  The new growth stems from two related revelations:

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


v2:
  - Basically a new series.

v1:
  - https://patchwork.kernel.org/cover/11394987/

Junaid Shahid (2):
  KVM: nVMX: Invalidate all L2 roots when emulating INVVPID without EPT
  KVM: x86: Sync SPTEs when injecting page/EPT fault into L1

Sean Christopherson (30):
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
  KVM: x86/mmu: Add module param to force TLB flush on root reuse
  KVM: nVMX: Don't flush TLB on nested VM transition with EPT enabled
  KVM: nVMX: Free only the affected contexts when emulating INVEPT

 arch/x86/include/asm/kvm_host.h |  16 ++-
 arch/x86/kvm/mmu/mmu.c          |  26 ++--
 arch/x86/kvm/mmu/paging_tmpl.h  |   2 +-
 arch/x86/kvm/svm.c              |  19 ++-
 arch/x86/kvm/vmx/nested.c       | 202 ++++++++++++++++++++------------
 arch/x86/kvm/vmx/nested.h       |   7 ++
 arch/x86/kvm/vmx/ops.h          |  32 +++--
 arch/x86/kvm/vmx/vmx.c          | 110 ++++++++++++++---
 arch/x86/kvm/vmx/vmx.h          |  19 +--
 arch/x86/kvm/x86.c              |  65 ++++++----
 arch/x86/kvm/x86.h              |   6 +
 11 files changed, 334 insertions(+), 170 deletions(-)

-- 
2.24.1

