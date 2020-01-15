Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2CDE13CC2E
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 19:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgAOSgI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 13:36:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:49268 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729157AbgAOSgI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 13:36:08 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jan 2020 10:36:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,323,1574150400"; 
   d="scan'208";a="220100394"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 15 Jan 2020 10:36:07 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Perform non-canonical checks in 32-bit KVM
Date:   Wed, 15 Jan 2020 10:36:05 -0800
Message-Id: <20200115183605.15413-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the CONFIG_X86_64 condition from the low level non-canonical
helpers to effectively enable non-canonical checks on 32-bit KVM.
Non-canonical checks are performed by hardware if the CPU *supports*
64-bit mode, whether or not the CPU is actually in 64-bit mode is
irrelevant.

For the most part, skipping non-canonical checks on 32-bit KVM is ok-ish
because 32-bit KVM always (hopefully) drops bits 63:32 of whatever value
it's checking before propagating it to hardware, and architecturally,
the expected behavior for the guest is a bit of a grey area since the
vCPU itself doesn't support 64-bit mode.  I.e. a 32-bit KVM guest can
observe the missed checks in several paths, e.g. INVVPID and VM-Enter,
but it's debatable whether or not the missed checks constitute a bug
because technically the vCPU doesn't support 64-bit mode.

The primary motivation for enabling the non-canonical checks is defense
in depth.  As mentioned above, a guest can trigger a missed check via
INVVPID or VM-Enter.  INVVPID is straightforward as it takes a 64-bit
virtual address as part of its 128-bit INVVPID descriptor and fails if
the address is non-canonical, even if INVVPID is executed in 32-bit PM.
Nested VM-Enter is a bit more convoluted as it requires the guest to
write natural width VMCS fields via memory accesses and then VMPTRLD the
VMCS, but it's still possible.  In both cases, KVM is saved from a true
bug only because its flows that propagate values to hardware (correctly)
take "unsigned long" parameters and so drop bits 63:32 of the bad value.

Explicitly performing the non-canonical checks makes it less likely that
a bad value will be propagated to hardware, e.g. in the INVVPID case,
if __invvpid() didn't implicitly drop bits 63:32 then KVM would BUG() on
the resulting unexpected INVVPID failure due to hardware rejecting the
non-canonical address.

The only downside to enabling the non-canonical checks is that it adds a
relatively small amount of overhead, but the affected flows are not hot
paths, i.e. the overhead is negligible.

Note, KVM technically could gate the non-canonical checks on 32-bit KVM
with static_cpu_has(X86_FEATURE_LM), but on bare metal that's an even
bigger waste of code for everyone except the 0.00000000000001% of the
population running on Yonah, and nested 32-bit on 64-bit already fudges
things with respect to 64-bit CPU behavior.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index cab5e71f0f0f..3ff590ec0238 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -166,21 +166,13 @@ static inline u64 get_canonical(u64 la, u8 vaddr_bits)
 
 static inline bool is_noncanonical_address(u64 la, struct kvm_vcpu *vcpu)
 {
-#ifdef CONFIG_X86_64
 	return get_canonical(la, vcpu_virt_addr_bits(vcpu)) != la;
-#else
-	return false;
-#endif
 }
 
 static inline bool emul_is_noncanonical_address(u64 la,
 						struct x86_emulate_ctxt *ctxt)
 {
-#ifdef CONFIG_X86_64
 	return get_canonical(la, ctxt_virt_addr_bits(ctxt)) != la;
-#else
-	return false;
-#endif
 }
 
 static inline void vcpu_cache_mmio_info(struct kvm_vcpu *vcpu,
-- 
2.24.1

