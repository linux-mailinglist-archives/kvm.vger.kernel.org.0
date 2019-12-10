Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F051119E66
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 23:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730568AbfLJWoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 17:44:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:9124 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728868AbfLJWoW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 17:44:22 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 14:44:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="413279340"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 10 Dec 2019 14:44:20 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jun Nakajima <jun.nakajima@intel.com>
Subject: [PATCH 4/4] KVM: x86: Add macro to ensure reserved cr4 bits checks stay in sync
Date:   Tue, 10 Dec 2019 14:44:16 -0800
Message-Id: <20191210224416.10757-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191210224416.10757-1-sean.j.christopherson@intel.com>
References: <20191210224416.10757-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper macro to generate the set of reserved cr4 bits for both
host and guest to ensure that adding a check on guest capabilities is
also added for host capabilities, and vice versa.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 65 ++++++++++++++++++----------------------------
 1 file changed, 25 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ab3a4104febf..d2ab4da75783 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -880,31 +880,34 @@ int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 }
 EXPORT_SYMBOL_GPL(kvm_set_xcr);
 
+#define __cr4_reserved_bits(__cpu_has, __c)		\
+({							\
+	u64 __reserved_bits = CR4_RESERVED_BITS;	\
+							\
+	if (!__cpu_has(__c, X86_FEATURE_XSAVE))		\
+		__reserved_bits |= X86_CR4_OSXSAVE;	\
+	if (!__cpu_has(__c, X86_FEATURE_SMEP))		\
+		__reserved_bits |= X86_CR4_SMEP;	\
+	if (!__cpu_has(__c, X86_FEATURE_SMAP))		\
+		__reserved_bits |= X86_CR4_SMAP;	\
+	if (!__cpu_has(__c, X86_FEATURE_FSGSBASE))	\
+		__reserved_bits |= X86_CR4_FSGSBASE;	\
+	if (!__cpu_has(__c, X86_FEATURE_PKU))		\
+		__reserved_bits |= X86_CR4_PKE;		\
+	if (!__cpu_has(__c, X86_FEATURE_LA57))		\
+		__reserved_bits |= X86_CR4_LA57;	\
+	__reserved_bits;				\
+})
+
 static u64 kvm_host_cr4_reserved_bits(struct cpuinfo_x86 *c)
 {
-	u64 reserved_bits = CR4_RESERVED_BITS;
+	u64 reserved_bits = __cr4_reserved_bits(cpu_has, c);
 
-	if (!cpu_has(c, X86_FEATURE_XSAVE))
-		reserved_bits |= X86_CR4_OSXSAVE;
+	if (cpuid_ecx(0x7) & bit(X86_FEATURE_LA57))
+		reserved_bits &= ~X86_CR4_LA57;
 
-	if (!cpu_has(c, X86_FEATURE_SMEP))
-		reserved_bits |= X86_CR4_SMEP;
-
-	if (!cpu_has(c, X86_FEATURE_SMAP))
-		reserved_bits |= X86_CR4_SMAP;
-
-	if (!cpu_has(c, X86_FEATURE_FSGSBASE))
-		reserved_bits |= X86_CR4_FSGSBASE;
-
-	if (!cpu_has(c, X86_FEATURE_PKU))
-		reserved_bits |= X86_CR4_PKE;
-
-	if (!cpu_has(c, X86_FEATURE_LA57) &&
-	    !(cpuid_ecx(0x7) & bit(X86_FEATURE_LA57)))
-		reserved_bits |= X86_CR4_LA57;
-
-	if (!cpu_has(c, X86_FEATURE_UMIP) && !kvm_x86_ops->umip_emulated())
-		reserved_bits |= X86_CR4_UMIP;
+	if (kvm_x86_ops->umip_emulated())
+		reserved_bits &= ~X86_CR4_UMIP;
 
 	return reserved_bits;
 }
@@ -914,25 +917,7 @@ static int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	if (cr4 & cr4_reserved_bits)
 		return -EINVAL;
 
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) && (cr4 & X86_CR4_OSXSAVE))
-		return -EINVAL;
-
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_SMEP) && (cr4 & X86_CR4_SMEP))
-		return -EINVAL;
-
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_SMAP) && (cr4 & X86_CR4_SMAP))
-		return -EINVAL;
-
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_FSGSBASE) && (cr4 & X86_CR4_FSGSBASE))
-		return -EINVAL;
-
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_PKU) && (cr4 & X86_CR4_PKE))
-		return -EINVAL;
-
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_LA57) && (cr4 & X86_CR4_LA57))
-		return -EINVAL;
-
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_UMIP) && (cr4 & X86_CR4_UMIP))
+	if (cr4 & __cr4_reserved_bits(guest_cpuid_has, vcpu))
 		return -EINVAL;
 
 	return 0;
-- 
2.24.0

