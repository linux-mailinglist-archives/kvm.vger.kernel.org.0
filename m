Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F9214F9BF
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbgBASyc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:54:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:11286 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727229AbgBASwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075559"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 01 Feb 2020 10:52:26 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 43/61] KVM: x86: Use KVM cpu caps to mark CR4.LA57 as not-reserved
Date:   Sat,  1 Feb 2020 10:52:00 -0800
Message-Id: <20200201185218.24473-44-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add accessor(s) for KVM cpu caps and use said accessor to detect
hardware support for LA57 instead of manually querying CPUID.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.h | 13 +++++++++++++
 arch/x86/kvm/x86.c   |  2 +-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 7b71ae0ca05e..5ce4219d465f 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -274,6 +274,19 @@ static __always_inline void kvm_cpu_cap_set(unsigned x86_feature)
 	kvm_cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
 }
 
+static __always_inline u32 kvm_cpu_cap_get(unsigned x86_feature)
+{
+	unsigned x86_leaf = x86_feature / 32;
+
+	reverse_cpuid_check(x86_leaf);
+	return kvm_cpu_caps[x86_leaf] & __feature_bit(x86_feature);
+}
+
+static __always_inline bool kvm_cpu_cap_has(unsigned x86_feature)
+{
+	return kvm_cpu_cap_get(x86_feature);
+}
+
 static __always_inline void kvm_cpu_cap_check_and_set(unsigned x86_feature)
 {
 	if (boot_cpu_has(x86_feature))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c5ed199d6cd9..cb40737187a1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -912,7 +912,7 @@ static u64 kvm_host_cr4_reserved_bits(struct cpuinfo_x86 *c)
 {
 	u64 reserved_bits = __cr4_reserved_bits(cpu_has, c);
 
-	if (cpuid_ecx(0x7) & feature_bit(LA57))
+	if (kvm_cpu_cap_has(X86_FEATURE_LA57))
 		reserved_bits &= ~X86_CR4_LA57;
 
 	if (kvm_x86_ops->umip_emulated())
-- 
2.24.1

