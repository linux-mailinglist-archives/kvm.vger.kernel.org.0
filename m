Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8784027DF3C
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 06:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgI3ERG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 00:17:06 -0400
Received: from mga18.intel.com ([134.134.136.126]:60796 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbgI3ERE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 00:17:04 -0400
IronPort-SDR: NhirzcgCtt3yLoyC2phvf9aQ7JgZwNVy57GTL7AEVDcXgpRT46mL8uoWU1a7pLkiReuMelpSqP
 NecUSJBmwNnA==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="150137439"
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="150137439"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 21:17:02 -0700
IronPort-SDR: RiVJiE8GxJ20RKMyGdjkRfqB3WEkixlcftzJ0kc9o1LUMjELbXdo0vtrzz5A2hzp8tasMPmlbL
 R4kicpeSOsRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="415607856"
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
Subject: [PATCH 1/5] KVM: x86: Intercept LA57 to inject #GP fault when it's reserved
Date:   Tue, 29 Sep 2020 21:16:55 -0700
Message-Id: <20200930041659.28181-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200930041659.28181-1-sean.j.christopherson@intel.com>
References: <20200930041659.28181-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Unconditionally intercept changes to CR4.LA57 so that KVM correctly
injects a #GP fault if the guest attempts to set CR4.LA57 when it's
supported in hardware but not exposed to the guest.

Long term, KVM needs to properly handle CR4 bits that can be under guest
control but also may be reserved from the guest's perspective.  But, KVM
currently sets the CR4 guest/host mask only during vCPU creation, and
reworking flows to change that will take a bit of elbow grease.

Even if/when generic support for intercepting reserved bits exists, it's
probably not worth letting the guest set CR4.LA57 directly.  LA57 can't
be toggled while long mode is enabled, thus it's all but guaranteed to
be set once (maybe twice, e.g. by BIOS and kernel) during boot and never
touched again.  On the flip side, letting the guest own CR4.LA57 may
incur extra VMREADs.  In other words, this temporary "hack" is probably
also the right long term fix.

Fixes: fd8cb433734e ("KVM: MMU: Expose the LA57 feature to VM.")
Cc: stable@vger.kernel.org
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
[sean: rewrote changelog]
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/kvm_cache_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index cfe83d4ae625..ca0781b41df9 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -7,7 +7,7 @@
 #define KVM_POSSIBLE_CR0_GUEST_BITS X86_CR0_TS
 #define KVM_POSSIBLE_CR4_GUEST_BITS				  \
 	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
-	 | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_PGE | X86_CR4_TSD)
+	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD)
 
 #define BUILD_KVM_GPR_ACCESSORS(lname, uname)				      \
 static __always_inline unsigned long kvm_##lname##_read(struct kvm_vcpu *vcpu)\
-- 
2.28.0

