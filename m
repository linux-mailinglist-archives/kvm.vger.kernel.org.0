Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D64205179
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 13:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732555AbgFWL63 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 07:58:29 -0400
Received: from mga05.intel.com ([192.55.52.43]:58474 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732545AbgFWL60 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 07:58:26 -0400
IronPort-SDR: ZZaexFbD141Mk2pSvW89eT79MoWwW6rfiW/LuL4X5EymcnSFe8DPqGw6FPPbx3PuHdV3Fy03VZ
 K+T/AEI2kd5Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="228710054"
X-IronPort-AV: E=Sophos;i="5.75,271,1589266800"; 
   d="scan'208";a="228710054"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 04:58:25 -0700
IronPort-SDR: cmKnDiupU7NuKvKVZZZyQrxn3TQxC/7la94fU0SvrNUDEanxzl1zzEi20zWE75okJaoltuDh8X
 AFlANa4NxW+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,271,1589266800"; 
   d="scan'208";a="285745359"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga007.jf.intel.com with ESMTP; 23 Jun 2020 04:58:23 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 2/7] KVM: X86: Go on updating other CPUID leaves when leaf 1 is absent
Date:   Tue, 23 Jun 2020 19:58:11 +0800
Message-Id: <20200623115816.24132-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200623115816.24132-1-xiaoyao.li@intel.com>
References: <20200623115816.24132-1-xiaoyao.li@intel.com>
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
index 1d13bad42bf9..0164dac95ef5 100644
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

