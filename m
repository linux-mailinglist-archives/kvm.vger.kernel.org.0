Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB9B1BD642
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 09:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbgD2HlY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 03:41:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:43114 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726355AbgD2HlY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 03:41:24 -0400
IronPort-SDR: 3PqwIIFQKMmXCLuypnL7o3Tfliz+Knx1gIw6ZRqe0LNsU2t3MGY13m02hqqejTzN1/2Zk1NM3I
 tQEdmded6nOw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 00:41:23 -0700
IronPort-SDR: phi0KJ//BVVxyKik5SX4LXIfbNkAfgUfknW+m75A2qkdVTQLjC1+fOjB60anFyH3w/m175ypCW
 NKGwCtOaEyMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,330,1583222400"; 
   d="scan'208";a="302931421"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Apr 2020 00:41:21 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kvm: x86: Cleanup vcpu->arch.guest_xstate_size
Date:   Wed, 29 Apr 2020 23:43:12 +0800
Message-Id: <20200429154312.1411-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.2
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vcpu->arch.guest_xstate_size lost its only user since commit df1daba7d1cb
("KVM: x86: support XSAVES usage in the host"), so clean it up.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/cpuid.c            | 8 ++------
 arch/x86/kvm/x86.c              | 2 --
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7cd68d1d0627..34a05ca3c904 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -654,7 +654,6 @@ struct kvm_vcpu_arch {
 
 	u64 xcr0;
 	u64 guest_supported_xcr0;
-	u32 guest_xstate_size;
 
 	struct kvm_pio_request pio;
 	void *pio_data;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 6828be99b908..f3eb4f171d3d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -84,15 +84,11 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 				   kvm_read_cr4_bits(vcpu, X86_CR4_PKE));
 
 	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
-	if (!best) {
+	if (!best)
 		vcpu->arch.guest_supported_xcr0 = 0;
-		vcpu->arch.guest_xstate_size = XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET;
-	} else {
+	else
 		vcpu->arch.guest_supported_xcr0 =
 			(best->eax | ((u64)best->edx << 32)) & supported_xcr0;
-		vcpu->arch.guest_xstate_size = best->ebx =
-			xstate_required_size(vcpu->arch.xcr0, false);
-	}
 
 	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
 	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 856b6fc2c2ba..7cd51a3acc43 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9358,8 +9358,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	}
 	fx_init(vcpu);
 
-	vcpu->arch.guest_xstate_size = XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET;
-
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
 
 	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
-- 
2.18.2

