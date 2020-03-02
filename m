Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6007C1768A2
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 00:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbgCBX5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 18:57:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:25524 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727453AbgCBX52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384701"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:22 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 26/66] KVM: x86: Replace bare "unsigned" with "unsigned int" in cpuid helpers
Date:   Mon,  2 Mar 2020 15:56:29 -0800
Message-Id: <20200302235709.27467-27-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace "unsigned" with "unsigned int" to make checkpatch and people
everywhere a little bit happier, and to avoid propagating the filth when
future patches add more cpuid helpers that work with unsigned (ints).

No functional change intended.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.h | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 72a79bdfed6b..46b4b61b6cf8 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -63,7 +63,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
  * and can't be used by KVM to query/control guest capabilities.  And obviously
  * the leaf being queried must have an entry in the lookup table.
  */
-static __always_inline void reverse_cpuid_check(unsigned x86_leaf)
+static __always_inline void reverse_cpuid_check(unsigned int x86_leaf)
 {
 	BUILD_BUG_ON(x86_leaf == CPUID_LNX_1);
 	BUILD_BUG_ON(x86_leaf == CPUID_LNX_2);
@@ -87,15 +87,16 @@ static __always_inline u32 __feature_bit(int x86_feature)
 
 #define feature_bit(name)  __feature_bit(X86_FEATURE_##name)
 
-static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned x86_feature)
+static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned int x86_feature)
 {
-	unsigned x86_leaf = x86_feature / 32;
+	unsigned int x86_leaf = x86_feature / 32;
 
 	reverse_cpuid_check(x86_leaf);
 	return reverse_cpuid[x86_leaf];
 }
 
-static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu, unsigned x86_feature)
+static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu,
+						     unsigned int x86_feature)
 {
 	struct kvm_cpuid_entry2 *entry;
 	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
@@ -119,7 +120,8 @@ static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu, unsi
 	}
 }
 
-static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu, unsigned x86_feature)
+static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu,
+					    unsigned int x86_feature)
 {
 	u32 *reg;
 
@@ -130,7 +132,8 @@ static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu, unsigned x86_
 	return *reg & __feature_bit(x86_feature);
 }
 
-static __always_inline void guest_cpuid_clear(struct kvm_vcpu *vcpu, unsigned x86_feature)
+static __always_inline void guest_cpuid_clear(struct kvm_vcpu *vcpu,
+					      unsigned int x86_feature)
 {
 	u32 *reg;
 
-- 
2.24.1

