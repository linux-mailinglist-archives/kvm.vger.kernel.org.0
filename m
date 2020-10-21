Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C045B294A34
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 11:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437401AbgJUJKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 05:10:36 -0400
Received: from mga07.intel.com ([134.134.136.100]:58976 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437398AbgJUJKf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 05:10:35 -0400
IronPort-SDR: 7Wh4ehq6z7Yy3S7z53XFTpraBXM7HeZpQAVJ7dloiq1RMZZTWwz1Qg8EnlYym4uaK+dZn+NqeB
 BiA9a4AMOOKA==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="231530453"
X-IronPort-AV: E=Sophos;i="5.77,400,1596524400"; 
   d="scan'208";a="231530453"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 02:10:35 -0700
IronPort-SDR: qoHI6RhjSKe2OX+VFGQHv0w438xECTTfaK0GCJ4pqz5PISWmeZBaPPRjL7WINmpk7aSqq8WrOS
 vcEWgSHBhkfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,400,1596524400"; 
   d="scan'208";a="522682449"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 21 Oct 2020 02:10:33 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     sean.j.christopherson@intel.com, pbonzini@redhat.com,
        xiaoyao.li@intel.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
Cc:     kvm@vger.kernel.org, robert.hu@intel.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v2 4/7] kvm: x86: Extract kvm_mwait_update_cpuid() from kvm_update_cpuid_runtime()
Date:   Wed, 21 Oct 2020 17:10:07 +0800
Message-Id: <1603271410-71343-5-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603271410-71343-1-git-send-email-robert.hu@linux.intel.com>
References: <1603271410-71343-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

And let kvm_set_msr_common() call kvm_mwait_update_cpuid() instead of whole
kvm_update_cpuid_runtime().

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/cpuid.c | 5 +++++
 arch/x86/kvm/cpuid.h | 1 +
 arch/x86/kvm/x86.c   | 3 ++-
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 18cd27a..556c018 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -88,6 +88,11 @@ void kvm_osxsave_update_cpuid(struct kvm_vcpu *vcpu, bool set)
 		guest_cpuid_change(vcpu, 1, 0, X86_FEATURE_OSXSAVE, set);
 }
 
+void kvm_mwait_update_cpuid(struct kvm_vcpu *vcpu, bool set)
+{
+	guest_cpuid_change(vcpu, 1, 0, X86_FEATURE_MWAIT, set);
+}
+
 void kvm_apic_base_update_cpuid(struct kvm_vcpu *vcpu, bool set)
 {
 	guest_cpuid_change(vcpu, 1, 0, X86_FEATURE_APIC, set);
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 98ea431..7eabb44 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -12,6 +12,7 @@
 void kvm_osxsave_update_cpuid(struct kvm_vcpu *vcpu, bool set);
 void kvm_pke_update_cpuid(struct kvm_vcpu *vcpu, bool set);
 void kvm_apic_base_update_cpuid(struct kvm_vcpu *vcpu, bool set);
+void kvm_mwait_update_cpuid(struct kvm_vcpu *vcpu, bool set);
 void kvm_xcr0_update_cpuid(struct kvm_vcpu *vcpu);
 
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5e9a51d..0d3cb34 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2936,8 +2936,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    ((vcpu->arch.ia32_misc_enable_msr ^ data) & MSR_IA32_MISC_ENABLE_MWAIT)) {
 			if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
 				return 1;
+			kvm_mwait_update_cpuid(vcpu, !!(data & MSR_IA32_MISC_ENABLE_MWAIT));
+
 			vcpu->arch.ia32_misc_enable_msr = data;
-			kvm_update_cpuid_runtime(vcpu);
 		} else {
 			vcpu->arch.ia32_misc_enable_msr = data;
 		}
-- 
1.8.3.1

