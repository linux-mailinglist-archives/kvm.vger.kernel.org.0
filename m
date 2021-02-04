Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E605930D399
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 08:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhBCG6u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 01:58:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:46077 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230193AbhBCG6t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 01:58:49 -0500
IronPort-SDR: LKHcjCk+MCJOvNtZ5Ana8J3Ine1IkrgSWZnOOmdLa9Wo5Q6rIkeBZ2wQcSdP4s+6LswureBZWf
 Pm2Ed3Gwj8LA==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="181141693"
X-IronPort-AV: E=Sophos;i="5.79,397,1602572400"; 
   d="scan'208";a="181141693"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 22:57:02 -0800
IronPort-SDR: yOYFXDoNims9sTqJO4yYV6ttQ36oBupccKAADmqXcJlbXrJY+OxBeeDTAfwotfwrqyU/ADOYoQ
 iCMOiQxyy+8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,397,1602572400"; 
   d="scan'208";a="433239012"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga001.jf.intel.com with ESMTP; 02 Feb 2021 22:56:59 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: vmx/pmu: Add VMCS fields check before exposing LBR_FMT
Date:   Wed,  3 Feb 2021 14:50:27 +0800
Message-Id: <20210203065027.314622-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before KVM exposes guest LBR_FMT perf capabilities, it needs to check
whether VMCS has GUEST_IA32_DEBUGCTL guest status field and vmx switch
support on IA32_DEBUGCTL MSR (including VM_EXIT_SAVE_DEBUG_CONTROLS
and VM_ENTRY_LOAD_DEBUG_CONTROLS). It helps nested LBR enablement.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/capabilities.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index d1d77985e889..ac3af06953a8 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -378,6 +378,12 @@ static inline bool vmx_pt_mode_is_host_guest(void)
 	return pt_mode == PT_MODE_HOST_GUEST;
 }
 
+static inline bool cpu_has_vmx_lbr(void)
+{
+	return (vmcs_config.vmexit_ctrl & VM_EXIT_SAVE_DEBUG_CONTROLS) &&
+		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_DEBUG_CONTROLS);
+}
+
 static inline u64 vmx_get_perf_capabilities(void)
 {
 	u64 perf_cap = 0;
@@ -385,7 +391,8 @@ static inline u64 vmx_get_perf_capabilities(void)
 	if (boot_cpu_has(X86_FEATURE_PDCM))
 		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
 
-	perf_cap &= PMU_CAP_LBR_FMT;
+	if (cpu_has_vmx_lbr())
+		perf_cap &= PMU_CAP_LBR_FMT;
 
 	/*
 	 * Since counters are virtualized, KVM would support full
-- 
2.29.2

