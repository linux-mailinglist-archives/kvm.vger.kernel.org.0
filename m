Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B63C811BAD2
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 18:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730970AbfLKR6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 12:58:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:29189 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730918AbfLKR6X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 12:58:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 09:58:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,302,1571727600"; 
   d="scan'208";a="203645151"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 11 Dec 2019 09:58:22 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: x86: Add build-time assertion on usage of bit()
Date:   Wed, 11 Dec 2019 09:58:21 -0800
Message-Id: <20191211175822.1925-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191211175822.1925-1-sean.j.christopherson@intel.com>
References: <20191211175822.1925-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add build-time checks to ensure KVM isn't trying to do a reverse CPUID
lookup on Linux-defined feature bits, along with comments to explain
the gory details of X86_FEATUREs and bit().

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

Note, the premature newline in the first line of the second comment is
intentional to reduce churn in the next patch.

 arch/x86/kvm/x86.h | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index cab5e71f0f0f..4ee4175c66a7 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -144,9 +144,28 @@ static inline bool is_pae_paging(struct kvm_vcpu *vcpu)
 	return !is_long_mode(vcpu) && is_pae(vcpu) && is_paging(vcpu);
 }
 
-static inline u32 bit(int bitno)
+/*
+ * Retrieve the bit mask from an X86_FEATURE_* definition.  Features contain
+ * the hardware defined bit number (stored in bits 4:0) and a software defined
+ * "word" (stored in bits 31:5).  The word is used to index into arrays of
+ * bit masks that hold the per-cpu feature capabilities, e.g. this_cpu_has().
+ */
+static __always_inline u32 bit(int feature)
 {
-	return 1 << (bitno & 31);
+	/*
+	 * bit() is intended to be used only for hardware-defined
+	 * words, i.e. words whose bits directly correspond to a CPUID leaf.
+	 * Retrieving the bit mask from a Linux-defined word is nonsensical
+	 * as the bit number/mask is an arbitrary software-defined value and
+	 * can't be used by KVM to query/control guest capabilities.
+	 */
+	BUILD_BUG_ON((feature >> 5) == CPUID_LNX_1);
+	BUILD_BUG_ON((feature >> 5) == CPUID_LNX_2);
+	BUILD_BUG_ON((feature >> 5) == CPUID_LNX_3);
+	BUILD_BUG_ON((feature >> 5) == CPUID_LNX_4);
+	BUILD_BUG_ON((feature >> 5) > CPUID_7_EDX);
+
+	return 1 << (feature & 31);
 }
 
 static inline u8 vcpu_virt_addr_bits(struct kvm_vcpu *vcpu)
-- 
2.24.0

