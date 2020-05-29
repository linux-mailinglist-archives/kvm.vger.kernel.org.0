Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3441E78D8
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 10:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgE2Iz4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 04:55:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:46106 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgE2Izy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 04:55:54 -0400
IronPort-SDR: Ae21QEK0CQ6KMJeRat3LhVqS/VgOxZBp199U0weePgbINfKEbeAHni6G0nNpJknM7I4pO8oH2c
 6a93l82bqS1A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 01:55:53 -0700
IronPort-SDR: 0G1IatZTkY/3u39e0rTDos3/GLuuPqxBIqnHVJTSk4cvrAhewO3lmgWiXH/g3yUjfgeAeUs0bj
 bvi33qY9ZmtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,448,1583222400"; 
   d="scan'208";a="311188316"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by FMSMGA003.fm.intel.com with ESMTP; 29 May 2020 01:55:51 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 2/6] KVM: X86: Go on updating other CPUID leaves when leaf 1 is absent
Date:   Fri, 29 May 2020 16:55:41 +0800
Message-Id: <20200529085545.29242-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200529085545.29242-1-xiaoyao.li@intel.com>
References: <20200529085545.29242-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As handling of bits other leaf 1 added over time, kvm_update_cpuid()
should not return directly if leaf 1 is absent, but should go on
updateing other CPUID leaves.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/cpuid.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2f1a9650b7f2..795bbaf37110 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -60,22 +60,21 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	best = kvm_find_cpuid_entry(vcpu, 1, 0);
-	if (!best)
-		return 0;
-
-	/* Update OSXSAVE bit */
-	if (boot_cpu_has(X86_FEATURE_XSAVE) && best->function == 0x1)
-		cpuid_entry_change(best, X86_FEATURE_OSXSAVE,
+	if (best) {
+		/* Update OSXSAVE bit */
+		if (boot_cpu_has(X86_FEATURE_XSAVE))
+			cpuid_entry_change(best, X86_FEATURE_OSXSAVE,
 				   kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE));
 
-	cpuid_entry_change(best, X86_FEATURE_APIC,
+		cpuid_entry_change(best, X86_FEATURE_APIC,
 			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
 
-	if (apic) {
-		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
-			apic->lapic_timer.timer_mode_mask = 3 << 17;
-		else
-			apic->lapic_timer.timer_mode_mask = 1 << 17;
+		if (apic) {
+			if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
+				apic->lapic_timer.timer_mode_mask = 3 << 17;
+			else
+				apic->lapic_timer.timer_mode_mask = 1 << 17;
+		}
 	}
 
 	best = kvm_find_cpuid_entry(vcpu, 7, 0);
-- 
2.18.2

