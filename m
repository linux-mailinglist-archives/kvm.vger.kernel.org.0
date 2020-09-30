Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0523E27DF41
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 06:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgI3ERL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 00:17:11 -0400
Received: from mga18.intel.com ([134.134.136.126]:60796 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbgI3ERF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 00:17:05 -0400
IronPort-SDR: BamU55C/aaQPyjxkn/PoFetVVBwvj3fi0UMC9v4Of+/tMIAygAiIWlZtc6xuH+288BBkEd6E52
 T5KbvXBF7WBA==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="150137455"
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="150137455"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 21:17:03 -0700
IronPort-SDR: /saY0BVd/QPYHi2iRfhP+TIsXqXfC2ZUELIrQ5kKEmWXwWZ/Kt5OUuoP71JLRX3Tj3J2liN954
 uoWY0rpNQ4uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="415607871"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga001.fm.intel.com with ESMTP; 29 Sep 2020 21:17:03 -0700
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
Subject: [PATCH 5/5] KVM: x86: Let the guest own CR4.FSGSBASE
Date:   Tue, 29 Sep 2020 21:16:59 -0700
Message-Id: <20200930041659.28181-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200930041659.28181-1-sean.j.christopherson@intel.com>
References: <20200930041659.28181-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Add FSGSBASE to the set of possible guest-owned CR4 bits, i.e. let the
guest own it on VMX.  KVM never queries the guest's CR4.FSGSBASE value,
thus there is no reason to force VM-Exit on FSGSBASE being toggled.

Note, because FSGSBASE is conditionally available, this is dependent on
recent changes to intercept reserved CR4 bits and to update the CR4
guest/host mask in response to guest CPUID changes.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
[sean: added justification in changelog]
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/kvm_cache_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index ca0781b41df9..a889563ad02d 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -7,7 +7,7 @@
 #define KVM_POSSIBLE_CR0_GUEST_BITS X86_CR0_TS
 #define KVM_POSSIBLE_CR4_GUEST_BITS				  \
 	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
-	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD)
+	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD | X86_CR4_FSGSBASE)
 
 #define BUILD_KVM_GPR_ACCESSORS(lname, uname)				      \
 static __always_inline unsigned long kvm_##lname##_read(struct kvm_vcpu *vcpu)\
-- 
2.28.0

