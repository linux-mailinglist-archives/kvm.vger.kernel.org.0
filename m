Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6B5776E8
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2019 07:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbfG0FwW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jul 2019 01:52:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:40960 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728222AbfG0FwT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jul 2019 01:52:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 22:52:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,313,1559545200"; 
   d="scan'208";a="254568598"
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
Subject: [RFC PATCH 07/21] KVM: x86: Add WARN_ON_ONCE(index!=0) in __do_cpuid_ent
Date:   Fri, 26 Jul 2019 22:52:00 -0700
Message-Id: <20190727055214.9282-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190727055214.9282-1-sean.j.christopherson@intel.com>
References: <20190727055214.9282-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Except for one outlier, function 7, all cases in __do_cpuid_ent and
its children assume that the index passed in is zero.  Furthermore,
the index is fully under KVM's control and all callers pass an index
of zero.  In other words, a non-zero index would indicate either a
bug in the caller or a new case that is expected to be handled.  WARN
and return an error on a non-zero index and remove the now unreachable
code in function 7 for handling a non-zero index.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 57 ++++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 4992e7c99588..70e488951f25 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -410,6 +410,14 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
 		F(MD_CLEAR);
 
+	/*
+	 * The code below assumes index == 0, which simplifies handling leafs
+	 * with a dynamic number of sub-leafs.  The index is fully under KVM's
+	 * control, i.e. a non-zero value is a bug.
+	 */
+	if (WARN_ON_ONCE(index != 0))
+		return -EINVAL;
+
 	/* all calls to cpuid_count() should be made on the same cpu */
 	get_cpu();
 
@@ -480,38 +488,31 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		entry->ecx = 0;
 		entry->edx = 0;
 		break;
-	case 7: {
+	case 7:
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 		/* Mask ebx against host capability word 9 */
-		if (index == 0) {
-			entry->ebx &= kvm_cpuid_7_0_ebx_x86_features;
-			cpuid_mask(&entry->ebx, CPUID_7_0_EBX);
-			// TSC_ADJUST is emulated
-			entry->ebx |= F(TSC_ADJUST);
-			entry->ecx &= kvm_cpuid_7_0_ecx_x86_features;
-			f_la57 = entry->ecx & F(LA57);
-			cpuid_mask(&entry->ecx, CPUID_7_ECX);
-			/* Set LA57 based on hardware capability. */
-			entry->ecx |= f_la57;
-			entry->ecx |= f_umip;
-			/* PKU is not yet implemented for shadow paging. */
-			if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
-				entry->ecx &= ~F(PKU);
-			entry->edx &= kvm_cpuid_7_0_edx_x86_features;
-			cpuid_mask(&entry->edx, CPUID_7_EDX);
-			/*
-			 * We emulate ARCH_CAPABILITIES in software even
-			 * if the host doesn't support it.
-			 */
-			entry->edx |= F(ARCH_CAPABILITIES);
-		} else {
-			entry->ebx = 0;
-			entry->ecx = 0;
-			entry->edx = 0;
-		}
+		entry->ebx &= kvm_cpuid_7_0_ebx_x86_features;
+		cpuid_mask(&entry->ebx, CPUID_7_0_EBX);
+		// TSC_ADJUST is emulated
+		entry->ebx |= F(TSC_ADJUST);
+		entry->ecx &= kvm_cpuid_7_0_ecx_x86_features;
+		f_la57 = entry->ecx & F(LA57);
+		cpuid_mask(&entry->ecx, CPUID_7_ECX);
+		/* Set LA57 based on hardware capability. */
+		entry->ecx |= f_la57;
+		entry->ecx |= f_umip;
+		/* PKU is not yet implemented for shadow paging. */
+		if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
+			entry->ecx &= ~F(PKU);
+		entry->edx &= kvm_cpuid_7_0_edx_x86_features;
+		cpuid_mask(&entry->edx, CPUID_7_EDX);
+		/*
+		 * We emulate ARCH_CAPABILITIES in software even
+		 * if the host doesn't support it.
+		 */
+		entry->edx |= F(ARCH_CAPABILITIES);
 		entry->eax = 0;
 		break;
-	}
 	case 9:
 		break;
 	case 0xa: { /* Architectural Performance Monitoring */
-- 
2.22.0

