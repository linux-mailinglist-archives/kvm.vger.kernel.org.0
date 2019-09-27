Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46119C0D87
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 23:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbfI0VpZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 17:45:25 -0400
Received: from mga12.intel.com ([192.55.52.136]:45951 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbfI0VpZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 17:45:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 14:45:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,557,1559545200"; 
   d="scan'208";a="196852054"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Sep 2019 14:45:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v2 0/8] KVM: x86: nVMX GUEST_CR3 bug fix, and then some...
Date:   Fri, 27 Sep 2019 14:45:15 -0700
Message-Id: <20190927214523.3376-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

*sigh*

v2 was shaping up to be a trivial update, until I started working on
Vitaly's suggestion to add a helper to test for register availability.

The primary purpose of this series is to fix a CR3 corruption in L2
reported by Reto Buerki when running with HLT interception disabled in L1.
On a nested VM-Enter that puts L2 into HLT, KVM never actually enters L2
and instead mimics HLT interception by canceling the nested run and
pretending that VM-Enter to L2 completed and then exited on HLT (which
KVM intercepted).  Because KVM never actually runs L2, KVM skips the
pending MMU update for L2 and so leaves a stale value in vmcs02.GUEST_CR3.
If the next wake event for L2 triggers a nested VM-Exit, KVM will refresh
vmcs12->guest_cr3 from vmcs02.GUEST_CR3 and consume the stale value.

Fix the issue by unconditionally writing vmcs02.GUEST_CR3 during nested
VM-Enter instead of deferring the update to vmx_set_cr3(), and skip the
update of GUEST_CR3 in vmx_set_cr3() when running L2.  I.e. make the
nested code fully responsible for vmcs02.GUEST_CR3.

Patch 02/08 is a minor optimization to skip the GUEST_CR3 update if
vmcs01 is already up-to-date.

Patches 03 and beyond are Vitaly's fault ;-).

Patches 03 and 04 are tangentially related cleanup to vmx_set_rflags()
that was discovered when working through the avail/dirty testing code.
Ideally they'd be sent as a separate series, but they conflict with the
avail/dirty helper changes and are themselves minor and straightforward.

Patches 05 and 06 clean up the register caching code so that there is a
single enum for all registers which use avail/dirty tracking.  While not
a true prerequisite for the avail/dirty helpers, the cleanup allows the
new helpers to take an 'enum kvm_reg' instead of a less helpful 'int reg'.

Patch 07 is the helpers themselves, as suggested by Vitaly.

Patch 08 is a truly optional change to ditch decache_cr3() in favor of
handling CR3 via cache_reg() like any other avail/dirty register.


Note, I collected the Reviewed-by and Tested-by tags for patches 01 and 02
even though I inverted the boolean from 'skip_cr3' to 'update_guest_cr3'.
Please drop the tags if that constitutes a non-trivial functional change.

v2:
  - Invert skip_cr3 to update_guest_cr3.  [Liran]
  - Reword the changelog and comment to be more explicit in detailing
    how/when KVM will process a nested VM-Enter without runnin L2.  [Liran]
  - Added Reviewed-by and Tested-by tags.
  - Add a comment in vmx_set_cr3() to explicitly state that nested
    VM-Enter is responsible for loading vmcs02.GUEST_CR3.  [Jim]
  - All of the loveliness in patches 03-08. [Vitaly]

Sean Christopherson (8):
  KVM: nVMX: Always write vmcs02.GUEST_CR3 during nested VM-Enter
  KVM: VMX: Skip GUEST_CR3 VMREAD+VMWRITE if the VMCS is up-to-date
  KVM: VMX: Consolidate to_vmx() usage in RFLAGS accessors
  KVM: VMX: Optimize vmx_set_rflags() for unrestricted guest
  KVM: x86: Add WARNs to detect out-of-bounds register indices
  KVM: x86: Fold 'enum kvm_ex_reg' definitions into 'enum kvm_reg'
  KVM: x86: Add helpers to test/mark reg availability and dirtiness
  KVM: x86: Fold decache_cr3() into cache_reg()

 arch/x86/include/asm/kvm_host.h |  5 +-
 arch/x86/kvm/kvm_cache_regs.h   | 67 +++++++++++++++++------
 arch/x86/kvm/svm.c              |  5 --
 arch/x86/kvm/vmx/nested.c       | 14 ++++-
 arch/x86/kvm/vmx/vmx.c          | 94 ++++++++++++++++++---------------
 arch/x86/kvm/x86.c              | 13 ++---
 arch/x86/kvm/x86.h              |  6 +--
 7 files changed, 123 insertions(+), 81 deletions(-)

-- 
2.22.0

