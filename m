Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEB3303414
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 06:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729996AbhAZFOe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:14:34 -0500
Received: from mga14.intel.com ([192.55.52.115]:22894 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbhAYJVt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 04:21:49 -0500
IronPort-SDR: kLpixzCbEWLgAImB9tzgTfik2BmW/2rKFmwjKUgesarkoVEWDBO5REJVXrWL2c7E7YGE8i274k
 LXF5gjuBAXEQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9874"; a="178915833"
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="178915833"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 01:07:27 -0800
IronPort-SDR: oZ3N02yOEcNYPhP41ed+7VkTEQYhBl3kxoe2rpWApfndI9MQKzlKG3YPlLG6AfEzb4YkKu5s69
 nOt5TTkK+D7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="402223980"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 25 Jan 2021 01:07:25 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     chang.seok.bae@intel.com, kvm@vger.kernel.org, robert.hu@intel.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [RFC PATCH 12/12] kvm/vmx/nested: Enable nested LOADIWKey VM-exit
Date:   Mon, 25 Jan 2021 17:06:20 +0800
Message-Id: <1611565580-47718-13-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
References: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set the LOADIWkey VM-exit bit in nested vmx ctrl MSR, and
let L1 intercept L2's LOADIWKEY VM-Exit.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/vmx/nested.c | 5 ++++-
 arch/x86/kvm/vmx/nested.h | 7 +++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index de36129..5a6b04d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5927,6 +5927,9 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu, u32 exit_reason)
 	case EXIT_REASON_TPAUSE:
 		return nested_cpu_has2(vmcs12,
 			SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE);
+	case EXIT_REASON_LOADIWKEY:
+		return nested_cpu_has3(vmcs12,
+			TERTIARY_EXEC_LOADIWKEY_EXITING);
 	default:
 		return true;
 	}
@@ -6441,7 +6444,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 	if (msrs->procbased_ctls_high & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS)
 		rdmsrl(MSR_IA32_VMX_PROCBASED_CTLS3,
 		      msrs->tertiary_ctls);
-	msrs->tertiary_ctls &= ~TERTIARY_EXEC_LOADIWKEY_EXITING;
+	msrs->tertiary_ctls &= TERTIARY_EXEC_LOADIWKEY_EXITING;
 	/*
 	 * We can emulate "VMCS shadowing," even if the hardware
 	 * doesn't support it.
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 197148d..3dda114 100644
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

