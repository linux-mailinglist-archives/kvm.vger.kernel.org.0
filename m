Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74936149195
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2020 00:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbgAXXHZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 18:07:25 -0500
Received: from mga05.intel.com ([192.55.52.43]:25112 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729182AbgAXXHZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jan 2020 18:07:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jan 2020 15:07:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,359,1574150400"; 
   d="scan'208";a="221171775"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 24 Jan 2020 15:07:23 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] KVM: x86: Take a u64 when checking for a valid dr7 value
Date:   Fri, 24 Jan 2020 15:07:22 -0800
Message-Id: <20200124230722.8964-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Take a u64 instead of an unsigned long in kvm_dr7_valid() to fix a build
warning on i386 due to right-shifting a 32-bit value by 32 when checking
for bits being set in dr7[63:32].

Alternatively, the warning could be resolved by rewriting the check to
use an i386-friendly method, but taking a u64 fixes another oddity on
32-bit KVM.  Beause KVM implements natural width VMCS fields as u64s to
avoid layout issues between 32-bit and 64-bit, a devious guest can stuff
vmcs12->guest_dr7 with a 64-bit value even when both the guest and host
are 32-bit kernels.  KVM eventually drops vmcs12->guest_dr7[63:32] when
propagating vmcs12->guest_dr7 to vmcs02, but ideally KVM would not rely
on that behavior for correctness.

Cc: Jim Mattson <jmattson@google.com>
Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Fixes: ecb697d10f70 ("KVM: nVMX: Check GUEST_DR7 on vmentry of nested guests")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 2d2ff855773b..3624665acee4 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -357,7 +357,7 @@ static inline bool kvm_pat_valid(u64 data)
 	return (data | ((data & 0x0202020202020202ull) << 1)) == data;
 }
 
-static inline bool kvm_dr7_valid(unsigned long data)
+static inline bool kvm_dr7_valid(u64 data)
 {
 	/* Bits [63:32] are reserved */
 	return !(data >> 32);
-- 
2.24.1

