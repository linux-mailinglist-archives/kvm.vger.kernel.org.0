Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5587E1668BB
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 21:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbgBTUn6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 15:43:58 -0500
Received: from mga12.intel.com ([192.55.52.136]:13654 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728582AbgBTUn6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 15:43:58 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2020 12:43:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,465,1574150400"; 
   d="scan'208";a="349237088"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 20 Feb 2020 12:43:57 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/10] KVM: x86: Clean up VMX's TLB flushing code
Date:   Thu, 20 Feb 2020 12:43:46 -0800
Message-Id: <20200220204356.8837-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is technically x86 wide, but it only superficially affects
SVM, the motivation and primary touchpoints are all about VMX.

The goal of this series to ultimately clean up __vmx_flush_tlb(), which,
for me, manages to be extremely confusing despite being only ten lines of
code.

The most confusing aspect of __vmx_flush_tlb() is that it is overloaded
for multiple uses:

 1) TLB flushes in response to a change in KVM's MMU

 2) TLB flushes during nested VM-Enter/VM-Exit when VPID is enabled

 3) Guest-scoped TLB flushes for paravirt TLB flushing

Handling (2) and (3) in the same flow as (1) is kludgy, because the rules
for (1) are quite different than the rules for (2) and (3).  They're all
squeezed into __vmx_flush_tlb() via the @invalidate_gpa param, which means
"invalidate gpa mappings", not "invalidate a specific gpa"; it took me
forever and a day to realize that.

To clean things up, handle (2) by directly calling vpid_sync_context()
instead of bouncing through __vmx_flush_tlb(), and handle (3) via a
dedicated kvm_x86_ops hook.  This allows for a less tricky implementation
of vmx_flush_tlb() for (1), and (hopefully) clarifies the rules for what
mappings must be invalidated when.

Sean Christopherson (10):
  KVM: VMX: Use vpid_sync_context() directly when possible
  KVM: VMX: Move vpid_sync_vcpu_addr() down a few lines
  KVM: VMX: Handle INVVPID fallback logic in vpid_sync_vcpu_addr()
  KVM: VMX: Fold vpid_sync_vcpu_{single,global}() into
    vpid_sync_context()
  KVM: nVMX: Use vpid_sync_vcpu_addr() to emulate INVVPID with address
  KVM: x86: Move "flush guest's TLB" logic to separate kvm_x86_ops hook
  KVM: VMX: Clean up vmx_flush_tlb_gva()
  KVM: x86: Drop @invalidate_gpa param from kvm_x86_ops' tlb_flush()
  KVM: VMX: Drop @invalidate_gpa from __vmx_flush_tlb()
  KVM: VMX: Fold __vmx_flush_tlb() into vmx_flush_tlb()

 arch/x86/include/asm/kvm_host.h |  8 +++++++-
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 arch/x86/kvm/svm.c              | 14 ++++++++++----
 arch/x86/kvm/vmx/nested.c       | 12 ++++--------
 arch/x86/kvm/vmx/ops.h          | 32 +++++++++-----------------------
 arch/x86/kvm/vmx/vmx.c          | 26 +++++++++++++++++---------
 arch/x86/kvm/vmx/vmx.h          | 19 ++++++++++---------
 arch/x86/kvm/x86.c              |  8 ++++----
 8 files changed, 62 insertions(+), 59 deletions(-)

-- 
2.24.1

