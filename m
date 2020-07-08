Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B77217FDC
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 08:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729916AbgGHGvL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 02:51:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:5284 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgGHGvF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 02:51:05 -0400
IronPort-SDR: U40pVOfGrmePo5fiPzCYSv4/YNlvZCC+XmyqCLBYDig4T8nGgQR9C7bELSAyzUcfeyi5qxUuZ5
 Mi5TGChEjpKw==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="145852065"
X-IronPort-AV: E=Sophos;i="5.75,326,1589266800"; 
   d="scan'208";a="145852065"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 23:51:05 -0700
IronPort-SDR: QmDEqBpqvGrubL0OVgodxjQAMGgTXWbxH2OPolVivEiamv/ICtZFtrYWipWn1+QYHpxS4Y5FK+
 65QnXIafcd5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,326,1589266800"; 
   d="scan'208";a="457399118"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga005.jf.intel.com with ESMTP; 07 Jul 2020 23:51:02 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v3 2/8] KVM: X86: Go on updating other CPUID leaves when leaf 1 is absent
Date:   Wed,  8 Jul 2020 14:50:48 +0800
Message-Id: <20200708065054.19713-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200708065054.19713-1-xiaoyao.li@intel.com>
References: <20200708065054.19713-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As handling of bits out of leaf 1 added over time, kvm_update_cpuid()
should not return directly if leaf 1 is absent, but should go on
updateing other CPUID leaves.

Keep the update of apic->lapic_timer.timer_mode_mask in a separate
wrapper, to minimize churn for code since it will be moved out of this
function in a future patch.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/cpuid.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 1d13bad42bf9..0e3a23c2ea55 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -60,18 +60,17 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
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
+	}
 
-	if (apic) {
+	if (best && apic) {
 		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
 			apic->lapic_timer.timer_mode_mask = 3 << 17;
 		else
-- 
2.18.4

