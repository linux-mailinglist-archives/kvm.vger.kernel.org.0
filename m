Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93FF9776E6
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2019 07:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbfG0FwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jul 2019 01:52:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:40956 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728220AbfG0FwT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jul 2019 01:52:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 22:52:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,313,1559545200"; 
   d="scan'208";a="254568595"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 26 Jul 2019 22:52:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC PATCH 06/21] KVM: x86: Add SGX sub-features leaf to reverse CPUID table
Date:   Fri, 26 Jul 2019 22:51:59 -0700
Message-Id: <20190727055214.9282-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190727055214.9282-1-sean.j.christopherson@intel.com>
References: <20190727055214.9282-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CPUID_12_EAX is an Intel-defined feature bits leaf dedicated for SGX
that enumerates the SGX instruction sets that are supported by the
CPU, e.g. SGX1, SGX2, etc...

Since Linux only cares about two bits at this time (SGX1 and SGX2), the
SGX bits were relocated to to Linux-defined word 8, i.e. CPUID_LNX_3,
instead of adding a dedicated SGX word so as to conserve space.  But,
to make KVM's life simple, the bit numbers of the SGX features were
intentionally kept the same between the Intel-defined leaf and the
Linux-defined leaf.

Add build-time assertions to ensure X86_FEATURE_SGX{1,2} are at the
expected locations, and that KVM isn't trying to do a reverse CPUID
lookup on a non-SGX bit in CPUID_LNX_3.

Relocate bit() to cpuid.h where it belongs (it's NOT a generic bit
function) and add a beefy comment explaining what the hell it's doing.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.h   | 20 ++++++++++++++++++++
 arch/x86/kvm/emulate.c |  1 +
 arch/x86/kvm/x86.h     |  5 -----
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index d78a61408243..aed49d639c3b 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -53,6 +53,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_7_ECX]         = {         7, 0, CPUID_ECX},
 	[CPUID_8000_0007_EBX] = {0x80000007, 0, CPUID_EBX},
 	[CPUID_7_EDX]         = {         7, 0, CPUID_EDX},
+	[CPUID_LNX_3]         = {      0x12, 0, CPUID_EAX},
 };
 
 static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned x86_feature)
@@ -61,6 +62,7 @@ static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned x86_feature)
 
 	BUILD_BUG_ON(x86_leaf >= ARRAY_SIZE(reverse_cpuid));
 	BUILD_BUG_ON(reverse_cpuid[x86_leaf].function == 0);
+	BUILD_BUG_ON(x86_leaf == CPUID_LNX_3 && (x86_feature & 31) > 1);
 
 	return reverse_cpuid[x86_leaf];
 }
@@ -89,6 +91,24 @@ static __always_inline int *guest_cpuid_get_register(struct kvm_vcpu *vcpu, unsi
 	}
 }
 
+/*
+ * Retrieve the bit from an X86_FEATURE_* definition using a simple AND to
+ * isolate the bit number from the feature definition.  Note that this works
+ * only for features that are NOT scattered, i.e. the X86_FEATURE_* bit number
+ * must match the hardware-defined CPUID bit number.  The only exception to
+ * this rule is the SGX sub-features leaf, which is scattered but only in the
+ * sense that its bits are relocated from hardware-defined leaf 0x12.0.EAX to
+ * Linux defined word 8, but its bit numbers are maintained (KVM asserts this
+ * expectation at build time).
+ */
+static __always_inline u32 bit(unsigned x86_feature)
+{
+	BUILD_BUG_ON((X86_FEATURE_SGX1 & 31) != 0);
+	BUILD_BUG_ON((X86_FEATURE_SGX2 & 31) != 1);
+
+	return 1 << (x86_feature & 31);
+}
+
 static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu, unsigned x86_feature)
 {
 	int *reg;
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 4a387a235424..6ffe23febcd7 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -29,6 +29,7 @@
 #include "tss.h"
 #include "mmu.h"
 #include "pmu.h"
+#include "cpuid.h"
 
 /*
  * Operand types
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a470ff0868c5..1e0c7b17effa 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -139,11 +139,6 @@ static inline int is_paging(struct kvm_vcpu *vcpu)
 	return likely(kvm_read_cr0_bits(vcpu, X86_CR0_PG));
 }
 
-static inline u32 bit(int bitno)
-{
-	return 1 << (bitno & 31);
-}
-
 static inline u8 vcpu_virt_addr_bits(struct kvm_vcpu *vcpu)
 {
 	return kvm_read_cr4_bits(vcpu, X86_CR4_LA57) ? 57 : 48;
-- 
2.22.0

