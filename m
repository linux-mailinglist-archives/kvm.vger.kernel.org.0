Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20292233D59
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 04:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731294AbgGaCmy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 22:42:54 -0400
Received: from mga12.intel.com ([192.55.52.136]:47518 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731227AbgGaCmx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 22:42:53 -0400
IronPort-SDR: 7Mr7QF10CA8ogPI+NSJhfDLWLeeOidGpYkEGwarjL5cr7Xz7zeMNSaBN8mLacdOsZJLx701oBu
 KkpULj5FzVvQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="131290131"
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="131290131"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 19:42:53 -0700
IronPort-SDR: VSoI8lW80FqTAw6temP+K3l0ay0oOhjCDWaBOs6g7IYHm1dtDD0+NPI/wFsJrb3h/PbYEz+rNq
 B2Ve55yi5usA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="304806025"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 30 Jul 2020 19:42:50 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, xiaoyao.li@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
Cc:     robert.hu@intel.com, Robert Hoo <robert.hu@linux.intel.com>
Subject: [RFC PATCH 8/9] KVM:x86: Substitute kvm_vcpu_after_set_cpuid() with abstracted functions
Date:   Fri, 31 Jul 2020 10:42:26 +0800
Message-Id: <1596163347-18574-9-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596163347-18574-1-git-send-email-robert.hu@linux.intel.com>
References: <1596163347-18574-1-git-send-email-robert.hu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/cpuid.c | 26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index efa7182..1d206aa 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -217,32 +217,16 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 
 static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
-	struct kvm_cpuid_entry2 *best;
-
 	kvm_x86_ops.vcpu_after_set_cpuid(vcpu);
 
-	best = kvm_find_cpuid_entry(vcpu, 1, 0);
-	if (best && apic) {
-		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
-			apic->lapic_timer.timer_mode_mask = 3 << 17;
-		else
-			apic->lapic_timer.timer_mode_mask = 1 << 17;
+	kvm_update_lapic_timer_mode(vcpu);
+	kvm_apic_set_version(vcpu);
 
-		kvm_apic_set_version(vcpu);
-	}
+	kvm_xcr0_update_cpuid(vcpu);
 
-	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
-	if (!best)
-		vcpu->arch.guest_supported_xcr0 = 0;
-	else
-		vcpu->arch.guest_supported_xcr0 =
-			(best->eax | ((u64)best->edx << 32)) & supported_xcr0;
+	kvm_update_maxphyaddr(vcpu);
 
-	/* Note, maxphyaddr must be updated before tdp_level. */
-	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
-	vcpu->arch.tdp_level = kvm_x86_ops.get_tdp_level(vcpu);
-	kvm_mmu_reset_context(vcpu);
+	kvm_pv_unhalt_update_cpuid(vcpu);
 
 	kvm_pmu_refresh(vcpu);
 	vcpu->arch.cr4_guest_rsvd_bits =
-- 
1.8.3.1

