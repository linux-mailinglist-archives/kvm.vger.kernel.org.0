Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810D7294A31
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 11:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437390AbgJUJKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 05:10:31 -0400
Received: from mga07.intel.com ([134.134.136.100]:58972 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388839AbgJUJKb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 05:10:31 -0400
IronPort-SDR: nR7oAk4RxekLulYMQ+2NpLAXEKnCAu5QVe05QmAgVlF+fzu/Gm9d6WsTfHz+H7VCEhE8rJw4Z8
 RmnExNyk2wSw==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="231530446"
X-IronPort-AV: E=Sophos;i="5.77,400,1596524400"; 
   d="scan'208";a="231530446"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 02:10:28 -0700
IronPort-SDR: Qa3Rf/7Pyb8PPlbS/6TpCPDQaiA1mdcrIDZFSo+noH1r13fL/UT7OwFGtR2b8ATAxO8E6UZInj
 YV1q+2YcMq9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,400,1596524400"; 
   d="scan'208";a="522682410"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 21 Oct 2020 02:10:26 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     sean.j.christopherson@intel.com, pbonzini@redhat.com,
        xiaoyao.li@intel.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
Cc:     kvm@vger.kernel.org, robert.hu@intel.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v2 1/7] kvm: x86: Extract kvm_apic_base_update_cpuid() from kvm_update_cpuid_runtime()
Date:   Wed, 21 Oct 2020 17:10:04 +0800
Message-Id: <1603271410-71343-2-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603271410-71343-1-git-send-email-robert.hu@linux.intel.com>
References: <1603271410-71343-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

And let kvm_lapic_set_base() call kvm_apic_base_update_cpuid() instead of
whole kvm_update_cpuid_runtime().

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/cpuid.c | 14 ++++++++++++++
 arch/x86/kvm/cpuid.h |  1 +
 arch/x86/kvm/lapic.c |  2 +-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 3fd6eec..b6dd4ee 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -73,6 +73,20 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static inline void guest_cpuid_change(struct kvm_vcpu *vcpu, u32 function,
+					    u32 index, unsigned int feature, bool set)
+{
+	struct kvm_cpuid_entry2 *e =  kvm_find_cpuid_entry(vcpu, function, index);
+
+	if (e)
+		cpuid_entry_change(e, feature, set);
+}
+
+void kvm_apic_base_update_cpuid(struct kvm_vcpu *vcpu, bool set)
+{
+	guest_cpuid_change(vcpu, 1, 0, X86_FEATURE_APIC, set);
+}
+
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 3a923ae..ef4cb9c 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -9,6 +9,7 @@
 extern u32 kvm_cpu_caps[NCAPINTS] __read_mostly;
 void kvm_set_cpu_caps(void);
 
+void kvm_apic_base_update_cpuid(struct kvm_vcpu *vcpu, bool set);
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 					      u32 function, u32 index);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 5ccbee7..5221b89 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2231,7 +2231,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 	vcpu->arch.apic_base = value;
 
 	if ((old_value ^ value) & MSR_IA32_APICBASE_ENABLE)
-		kvm_update_cpuid_runtime(vcpu);
+		kvm_apic_base_update_cpuid(vcpu, !!(value & MSR_IA32_APICBASE_ENABLE));
 
 	if (!apic)
 		return;
-- 
1.8.3.1

