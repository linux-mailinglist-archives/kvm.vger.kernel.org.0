Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801A9396F89
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 10:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbhFAIvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 04:51:36 -0400
Received: from mga07.intel.com ([134.134.136.100]:45208 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233958AbhFAIvL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 04:51:11 -0400
IronPort-SDR: Bt+Sjy6Izis6MJfuHuKSh2Omk0wg6E57TojLzEB0zr43BMQy0yeVHckTRoqvpsrHJy6EEXU4rr
 T4FurxyAT8xg==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="267381541"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="267381541"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 01:48:42 -0700
IronPort-SDR: KF3INlzmY+dy1eXTMBimHFb9/Jd4n/Vq4XJxMyxlgYoGEZLDyf1IywD3JbnXtL4F/RA0DuKsWI
 OpiqEcsDj14g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="437967879"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga007.jf.intel.com with ESMTP; 01 Jun 2021 01:48:39 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, robert.hu@intel.com,
        robert.hu@linux.intel.com
Subject: [PATCH 15/15] kvm/vmx/nested: Enable nested LOADIWKEY VM-exit
Date:   Tue,  1 Jun 2021 16:47:54 +0800
Message-Id: <1622537274-146420-16-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622537274-146420-1-git-send-email-robert.hu@linux.intel.com>
References: <1622537274-146420-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set the LOADIWKEY VM-exit bit in nested vmx ctrl MSR, and
let L1 intercept L2's LOADIWKEY VM-Exit.

Add helper nested_cpu_has3(), which returns if some feature in Tertiary
VM-Exec Control is set.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/vmx/nested.c | 5 ++++-
 arch/x86/kvm/vmx/nested.h | 7 +++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f5ec215..514df3f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5983,6 +5983,9 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
 			SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE);
 	case EXIT_REASON_ENCLS:
 		return nested_vmx_exit_handled_encls(vcpu, vmcs12);
+	case EXIT_REASON_LOADIWKEY:
+		return nested_cpu_has3(vmcs12,
+			TERTIARY_EXEC_LOADIWKEY_EXITING);
 	default:
 		return true;
 	}
@@ -6499,7 +6502,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 
 	if (msrs->procbased_ctls_high & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS)
 		rdmsrl(MSR_IA32_VMX_PROCBASED_CTLS3, msrs->tertiary_ctls);
-	msrs->tertiary_ctls &= 0;
+	msrs->tertiary_ctls &= TERTIARY_EXEC_LOADIWKEY_EXITING;
 	/*
 	 * We can emulate "VMCS shadowing," even if the hardware
 	 * doesn't support it.
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 184418b..f1e43e2 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -145,6 +145,13 @@ static inline bool nested_cpu_has2(struct vmcs12 *vmcs12, u32 bit)
 		(vmcs12->secondary_vm_exec_control & bit);
 }
 
+static inline bool nested_cpu_has3(struct vmcs12 *vmcs12, u32 bit)
+{
+	return (vmcs12->cpu_based_vm_exec_control &
+			CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) &&
+		(vmcs12->tertiary_vm_exec_control & bit);
+}
+
 static inline bool nested_cpu_has_preemption_timer(struct vmcs12 *vmcs12)
 {
 	return vmcs12->pin_based_vm_exec_control &
-- 
1.8.3.1

