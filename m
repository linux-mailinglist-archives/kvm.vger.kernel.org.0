Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C0033AC00
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 08:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhCOHH1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 03:07:27 -0400
Received: from mga12.intel.com ([192.55.52.136]:10118 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229890AbhCOHHK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 03:07:10 -0400
IronPort-SDR: GfalYTpPF8DeaZhPp9UVaCEUQY6EBZ/Thgwkmfj7hRKawPIFSDsnEnPL3kgSdki6bGQBliOF+4
 fQ03aD1QQLAg==
X-IronPort-AV: E=McAfee;i="6000,8403,9923"; a="168316620"
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="168316620"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 00:07:08 -0700
IronPort-SDR: GCFa2BMOPedcW6+MnZ3KjwQ3ndhYC29uTSMdHLp8OKWgmccx0DpqeiXxA1L+TBu2vYLZ9sMfY+
 oGkDKWhxGF4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="604749740"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.166])
  by fmsmga005.fm.intel.com with ESMTP; 15 Mar 2021 00:07:06 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v4 3/3] KVM: nVMX: Add CET entry/exit load bits to evmcs unsupported list
Date:   Mon, 15 Mar 2021 15:18:41 +0800
Message-Id: <20210315071841.7045-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20210315071841.7045-1-weijiang.yang@intel.com>
References: <20210315071841.7045-1-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nested guest doesn't support CET when KVM is running as an intermediate
layer between two Hyper-Vs for now, so mask out related CET entry/exit
load bits. Relevant enabling patches will be posted as a separate patch
series.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/evmcs.c | 4 ++--
 arch/x86/kvm/vmx/evmcs.h | 6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 41f24661af04..9f81db51fd8b 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -351,11 +351,11 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
 	switch (msr_index) {
 	case MSR_IA32_VMX_EXIT_CTLS:
 	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
-		ctl_high &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+		ctl_high &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
 		break;
 	case MSR_IA32_VMX_ENTRY_CTLS:
 	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
-		ctl_high &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		ctl_high &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
 		break;
 	case MSR_IA32_VMX_PROCBASED_CTLS2:
 		ctl_high &= ~SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index bd41d9462355..25588694eb04 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -59,8 +59,10 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
 	 SECONDARY_EXEC_SHADOW_VMCS |					\
 	 SECONDARY_EXEC_TSC_SCALING |					\
 	 SECONDARY_EXEC_PAUSE_LOOP_EXITING)
-#define EVMCS1_UNSUPPORTED_VMEXIT_CTRL (VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
-#define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
+#define EVMCS1_UNSUPPORTED_VMEXIT_CTRL (VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL | \
+					VM_EXIT_LOAD_CET_STATE)
+#define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL | \
+					 VM_ENTRY_LOAD_CET_STATE)
 #define EVMCS1_UNSUPPORTED_VMFUNC (VMX_VMFUNC_EPTP_SWITCHING)
 
 #if IS_ENABLED(CONFIG_HYPERV)
-- 
2.26.2

