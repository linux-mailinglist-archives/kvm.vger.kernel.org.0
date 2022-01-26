Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC1D49C246
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 04:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237295AbiAZDry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 22:47:54 -0500
Received: from mga14.intel.com ([192.55.52.115]:26333 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233406AbiAZDrx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 22:47:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643168873; x=1674704873;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YJvfPZ+Ryyuw8LzQBKnmgNZUzpx/Ro+K1QSwSjRhuHo=;
  b=Py5+8wwPQf4TBj3Hd4huH2pdYhP7Bcu8P19nCho4+8zkF3Emq8YCV4eq
   hfpVpJr9V/2tUzkkNJtrJCj3PY/YYZNjpNJ0RCTMCji6n74ayWDkLhd7U
   cg4mYTHhieu1ARE0U/jNXOaVAyiN2qSbE8bDP9mLRDkeN8p539FORSDds
   fAVYprfbMY+F25Yxff9jwjE5N7IJYfXPlcE8IkJwPYCagndh8v19yfu5P
   M2KAPzjAQeVSnKJeos8xxCc07onQg59JxASZmu5ME79xXw365NauX2SZz
   Bc2G9EgGP6KdSRr1jGaksfae9bgbQnbIM7aBY1Pxjvd24n85o0PN9gjov
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="246693222"
X-IronPort-AV: E=Sophos;i="5.88,316,1635231600"; 
   d="scan'208";a="246693222"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 19:47:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,316,1635231600"; 
   d="scan'208";a="520653248"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga007.jf.intel.com with ESMTP; 25 Jan 2022 19:47:51 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiaoyao.li@intel.com
Subject: [PATCH] KVM: x86: Keep MSR_IA32_XSS unchanged for INIT
Date:   Wed, 26 Jan 2022 11:47:50 +0800
Message-Id: <20220126034750.2495371-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It has been corrected from SDM version 075 that MSR_IA32_XSS is reset to
zero on Power up and Reset but keeps unchanged on INIT.

Fixes: a554d207dc46 ("KVM: X86: Processor States following Reset or INIT")
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/x86.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 55518b7d3b96..c0727939684e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11257,6 +11257,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		vcpu->arch.msr_misc_features_enables = 0;
 
 		vcpu->arch.xcr0 = XFEATURE_MASK_FP;
+		vcpu->arch.ia32_xss = 0;
 	}
 
 	/* All GPRs except RDX (handled below) are zeroed on RESET/INIT. */
@@ -11273,8 +11274,6 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	cpuid_0x1 = kvm_find_cpuid_entry(vcpu, 1, 0);
 	kvm_rdx_write(vcpu, cpuid_0x1 ? cpuid_0x1->eax : 0x600);
 
-	vcpu->arch.ia32_xss = 0;
-
 	static_call(kvm_x86_vcpu_reset)(vcpu, init_event);
 
 	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
-- 
2.27.0

