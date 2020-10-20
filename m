Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F29AA285673
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 03:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgJGBoT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 21:44:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:7786 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbgJGBoT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 21:44:19 -0400
IronPort-SDR: VoyZ/K2RKGL7K/1W/VtnQlAfNA1ewa2myzY3VJNqqkRkV8MKWgooDw8gT/u1UDsute5/P/INoU
 Fjq7Nn0iPIIA==
X-IronPort-AV: E=McAfee;i="6000,8403,9766"; a="164914594"
X-IronPort-AV: E=Sophos;i="5.77,344,1596524400"; 
   d="scan'208";a="164914594"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 18:44:18 -0700
IronPort-SDR: QPTpCXDbpGbu6qD+HFtns6yMfN22f+KJcQgpbAfbRrLy6DfIPy/g07l97PC9VS/cMfGoFbGEii
 lRi9br9NlMaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,344,1596524400"; 
   d="scan'208";a="297410294"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga008.fm.intel.com with ESMTP; 06 Oct 2020 18:44:17 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stas Sergeev <stsp@users.sourceforge.net>
Subject: [PATCH 0/6] KVM: x86: KVM_SET_SREGS.CR4 bug fixes and cleanup
Date:   Tue,  6 Oct 2020 18:44:11 -0700
Message-Id: <20201007014417.29276-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two bug fixes to handle KVM_SET_SREGS without a preceding KVM_SET_CPUID2.

The overarching issue is that kvm_x86_ops.set_cr4() can fail, but its
invocation from __set_sregs(), a.k.a. KVM_SET_SREGS, ignores the result.
Fix the issue by moving all validity checks out of .set_cr4() in one way
or another.

I intentionally omitted a Cc to stable.  The first bug fix in particular
may break stable trees as it simply removes a check, and I don't know that
stable trees have the generic CR4 reserved bit check that is needed to
prevent the guest from setting VMXE when nVMX is not allowed.

Sean Christopherson (6):
  KVM: VMX: Drop guest CPUID check for VMXE in vmx_set_cr4()
  KVM: VMX: Drop explicit 'nested' check from vmx_set_cr4()
  KVM: SVM: Drop VMXE check from svm_set_cr4()
  KVM: x86: Move vendor CR4 validity check to dedicated kvm_x86_ops hook
  KVM: x86: Return bool instead of int for CR4 and SREGS validity checks
  KVM: selftests: Verify supported CR4 bits can be set before
    KVM_SET_CPUID2

 arch/x86/include/asm/kvm_host.h               |  3 +-
 arch/x86/kvm/svm/nested.c                     |  2 +-
 arch/x86/kvm/svm/svm.c                        | 12 ++-
 arch/x86/kvm/svm/svm.h                        |  2 +-
 arch/x86/kvm/vmx/nested.c                     |  2 +-
 arch/x86/kvm/vmx/vmx.c                        | 35 +++----
 arch/x86/kvm/vmx/vmx.h                        |  2 +-
 arch/x86/kvm/x86.c                            | 28 +++---
 arch/x86/kvm/x86.h                            |  2 +-
 .../selftests/kvm/include/x86_64/processor.h  | 17 ++++
 .../selftests/kvm/include/x86_64/vmx.h        |  4 -
 .../selftests/kvm/x86_64/set_sregs_test.c     | 92 ++++++++++++++++++-
 12 files changed, 153 insertions(+), 48 deletions(-)

-- 
2.28.0

