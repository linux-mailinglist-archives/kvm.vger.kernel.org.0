Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A405F176890
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 00:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbgCBX5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 18:57:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:25521 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727509AbgCBX5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:31 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384752"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:23 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 43/66] KVM: x86: Use KVM cpu caps to mark CR4.LA57 as not-reserved
Date:   Mon,  2 Mar 2020 15:56:46 -0800
Message-Id: <20200302235709.27467-44-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add accessor(s) for KVM cpu caps and use said accessor to detect
hardware support for LA57 instead of manually querying CPUID.

Note, the explicit conversion to bool via '!!' in kvm_cpu_cap_has() is
technically unnecessary, but it gives people a warm fuzzy feeling.

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.h | 13 +++++++++++++
 arch/x86/kvm/x86.c   |  2 +-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index b5155b8b4897..68c31d76e045 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -273,6 +273,19 @@ static __always_inline void kvm_cpu_cap_set(unsigned int x86_feature)
 	kvm_cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
 }
 
+static __always_inline u32 kvm_cpu_cap_get(unsigned int x86_feature)
+{
+	unsigned int x86_leaf = x86_feature / 32;
+
+	reverse_cpuid_check(x86_leaf);
+	return kvm_cpu_caps[x86_leaf] & __feature_bit(x86_feature);
+}
+
+static __always_inline bool kvm_cpu_cap_has(unsigned int x86_feature)
+{
+	return !!kvm_cpu_cap_get(x86_feature);
+}
+
 static __always_inline void kvm_cpu_cap_check_and_set(unsigned int x86_feature)
 {
 	if (boot_cpu_has(x86_feature))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b032fd144073..400d65125e91 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -910,7 +910,7 @@ static u64 kvm_host_cr4_reserved_bits(struct cpuinfo_x86 *c)
 {
 	u64 reserved_bits = __cr4_reserved_bits(cpu_has, c);
 
-	if (cpuid_ecx(0x7) & feature_bit(LA57))
+	if (kvm_cpu_cap_has(X86_FEATURE_LA57))
 		reserved_bits &= ~X86_CR4_LA57;
 
 	if (kvm_x86_ops->umip_emulated())
-- 
2.24.1

