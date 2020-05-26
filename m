Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64F91C22F3
	for <lists+kvm@lfdr.de>; Sat,  2 May 2020 06:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgEBEcg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 May 2020 00:32:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:55783 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726058AbgEBEcg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 May 2020 00:32:36 -0400
IronPort-SDR: dPOrQT68hPzbRpu4BLjy1w42EalcLWmDr0uGylPQ9ptmWRHkKpwUkVPMh7ttfj7f9sSOQuthHw
 8JxfQaGRTwrw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 21:32:35 -0700
IronPort-SDR: WSlDYZJPxF5NPd5/RIFQn10i2FBPG5MhLGuRPGyGB23uEj7G3/hwSgRpmNSE65kVC+redTE8XE
 AIi9MovEM9nA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,342,1583222400"; 
   d="scan'208";a="433516107"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga005.jf.intel.com with ESMTP; 01 May 2020 21:32:35 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/10] KVM: x86: Misc anti-retpoline optimizations
Date:   Fri,  1 May 2020 21:32:24 -0700
Message-Id: <20200502043234.12481-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A smattering of optimizations geared toward avoiding retpolines, though
IMO most of the patches are worthwhile changes irrespective of retpolines.
I can split this up into separate patches if desired, outside of the
obvious combos there are no dependencies.

I was mainly coming at this from a nVMX angle.  On a Haswell, this reduces
the best case latency for a nested VMX roundtrip by ~750 cycles, though I
doubt that much benefit will be realized in practice.


The CR0 and CR4 caching changes in particular are keepers, if only because
they get rid of the awful cache vs. decache naming.  And the CR4 change
can eliminate multiple of VMREADs in the nested VMX paths.

Ditto for the CR3 validation patch; it's arguably more readable and can
avoid a VMREAD.

I like the L1 TSC offset patch because VMX and SVM have inverted logic for
how they track the L1 offset, and because math is hard.

I think I like the TDP level change even if retpolines didn't exist?  The
nested EPT behavior is a bit scary, but it was already scary, this just
makes it more obvious.

The RIP/RSP accessors are definitely obsoleted by static calls, but IMO
the noise is worth the benefit unless static calls are imminent.

The DR6 change is gratuitous, though I do like not having to dive into the
VMX code when I inevitably forget the VMX implementations are nops.

Sean Christopherson (10):
  KVM: x86: Save L1 TSC offset in 'struct kvm_vcpu_arch'
  KVM: nVMX: Unconditionally validate CR3 during nested transitions
  KVM: x86: Make kvm_x86_ops' {g,s}et_dr6() hooks optional
  KVM: x86: Split guts of kvm_update_dr7() to separate helper
  KVM: nVMX: Avoid retpoline when writing DR7 during nested transitions
  KVM: VMX: Add proper cache tracking for CR4
  KVM: VMX: Add proper cache tracking for CR0
  KVM: VMX: Add anti-retpoline accessors for RIP and RSP
  KVM: VMX: Move nested EPT out of kvm_x86_ops.get_tdp_level() hook
  KVM: x86/mmu: Capture TDP level when updating CPUID

 arch/x86/include/asm/kvm_host.h |  7 +--
 arch/x86/kvm/cpuid.c            |  3 +-
 arch/x86/kvm/kvm_cache_regs.h   | 10 +++--
 arch/x86/kvm/mmu/mmu.c          |  6 +--
 arch/x86/kvm/svm/nested.c       |  2 +-
 arch/x86/kvm/svm/svm.c          | 21 ---------
 arch/x86/kvm/vmx/nested.c       | 49 +++++++++++----------
 arch/x86/kvm/vmx/vmx.c          | 77 +++++++++++++--------------------
 arch/x86/kvm/vmx/vmx.h          | 30 +++++++++++++
 arch/x86/kvm/x86.c              | 26 ++++-------
 arch/x86/kvm/x86.h              | 14 ++++++
 11 files changed, 125 insertions(+), 120 deletions(-)

-- 
2.26.0

