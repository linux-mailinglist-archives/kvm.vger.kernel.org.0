Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC40B14D3E7
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 00:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbgA2XsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 18:48:04 -0500
Received: from mga06.intel.com ([134.134.136.31]:46692 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727142AbgA2Xqr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 18:46:47 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 15:46:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,379,1574150400"; 
   d="scan'208";a="309551724"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 29 Jan 2020 15:46:43 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/26] KVM: x86: Make kvm_mpx_supported() an inline function
Date:   Wed, 29 Jan 2020 15:46:25 -0800
Message-Id: <20200129234640.8147-12-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129234640.8147-1-sean.j.christopherson@intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expose kvm_mpx_supported() as a static inline so that it can be inlined
in kvm_intel.ko.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 6 ------
 arch/x86/kvm/cpuid.h | 1 -
 arch/x86/kvm/x86.h   | 5 +++++
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b951d9222ab5..e9e63faf0157 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -45,12 +45,6 @@ static u32 xstate_required_size(u64 xstate_bv, bool compacted)
 	return ret;
 }
 
-bool kvm_mpx_supported(void)
-{
-	return supported_xcr0 & (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
-}
-EXPORT_SYMBOL_GPL(kvm_mpx_supported);
-
 #define F feature_bit
 
 int kvm_update_cpuid(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 7366c618aa04..c1ac0995843d 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -7,7 +7,6 @@
 #include <asm/processor.h>
 
 int kvm_update_cpuid(struct kvm_vcpu *vcpu);
-bool kvm_mpx_supported(void);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 					      u32 function, u32 index);
 int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 02b49ee49e24..bfac4a80956c 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -283,6 +283,11 @@ enum exit_fastpath_completion handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vc
 extern u64 host_xcr0;
 extern u64 supported_xcr0;
 
+static inline bool kvm_mpx_supported(void)
+{
+	return supported_xcr0 & (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
+}
+
 extern unsigned int min_timer_period_us;
 
 extern bool enable_vmware_backdoor;
-- 
2.24.1

