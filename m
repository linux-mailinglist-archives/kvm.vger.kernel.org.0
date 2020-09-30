Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58ACC27DF42
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 06:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725798AbgI3ERD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 00:17:03 -0400
Received: from mga18.intel.com ([134.134.136.126]:60793 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgI3ERD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 00:17:03 -0400
IronPort-SDR: yP2s851zwsADPoqTbfxmReqQ3cF3nFVRqxVDbSJ/VzGwIRDIDzsUI9IQ/7SX+rowT2AGgm1ove
 EZ7BPTq45oKg==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="150137442"
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="150137442"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 21:17:02 -0700
IronPort-SDR: lP4CQa/l4bbc0mzz+ZwM7GnfsFmbuqynTTtO0n5TUvHt0elDV/NUxmWFCNaJzCrM49UE0mXyfN
 13vH5TGP9uPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="415607859"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga001.fm.intel.com with ESMTP; 29 Sep 2020 21:17:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Subject: [PATCH 0/5] KVM: x86: Handle reserved CR4 bit interception in VMX
Date:   Tue, 29 Sep 2020 21:16:54 -0700
Message-Id: <20200930041659.28181-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series stems from Lai's RFC patches to intercept LA57 and let the
guest own FSGSBASE[*].  Discussion and inspection revealed that KVM does
not handle the case where LA57 is supported in hardware but not exposed to
the guest.  This is actually true for all CR4 bits, but LA57 is currently
the only bit that can be reserved and also owned by the guest.  I have
a unit test for this that I'll post separately.

Intercepting LA57 was by far the easiest fix for the immedidate bug, and
is likely the right change in the long term as there's no justification
for letting the guest own LA57.

The middle three patches adjust VMX's CR4 guest/host mask to intercept
reserved bits.  This required reworking CPUID updates to also refresh said
mask at the correct time.

The last past is Lai's, which let's the guest own FSGSBASE.  This depends
on the reserved bit handling being in place.

Ran everything through unit tests, and ran the kernel's FSGSBASE selftests
in a VM.

[*] https://lkml.kernel.org/r/20200928083047.3349-1-jiangshanlai@gmail.com

Lai Jiangshan (2):
  KVM: x86: Intercept LA57 to inject #GP fault when it's reserved
  KVM: x86: Let the guest own CR4.FSGSBASE

Sean Christopherson (3):
  KVM: x86: Invoke vendor's vcpu_after_set_cpuid() after all common
    updates
  KVM: x86: Move call to update_exception_bitmap() into VMX code
  KVM: VMX: Intercept guest reserved CR4 bits to inject #GP fault

 arch/x86/kvm/cpuid.c          |  6 +++---
 arch/x86/kvm/kvm_cache_regs.h |  2 +-
 arch/x86/kvm/vmx/vmx.c        | 18 +++++++++++++-----
 3 files changed, 17 insertions(+), 9 deletions(-)

-- 
2.28.0

