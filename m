Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A0E379D03
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 04:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbhEKCoS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 22:44:18 -0400
Received: from mga03.intel.com ([134.134.136.65]:7532 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230144AbhEKCoQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 22:44:16 -0400
IronPort-SDR: WyaPsnpOp2XwB/LVbhUNuDX1nEcIgXCmUIk/T09iHC/MU2x2zu59eEdB8xLqJ/8cxaDR7MR6CN
 gkGaWLaqhvhg==
X-IronPort-AV: E=McAfee;i="6200,9189,9980"; a="199391182"
X-IronPort-AV: E=Sophos;i="5.82,290,1613462400"; 
   d="scan'208";a="199391182"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 19:43:11 -0700
IronPort-SDR: lfPlPgSwbxN//xgszgpVCMHd/OCKftUxRYyT+uXd7ymwDWx+FcquEu0iec6ixuGF4UEoXoS3Qn
 XvGGW5e91UCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,290,1613462400"; 
   d="scan'208";a="468591652"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga002.fm.intel.com with ESMTP; 10 May 2021 19:43:06 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v6 03/16] perf/x86/core: Pass "struct kvm_pmu *" to determine the guest values
Date:   Tue, 11 May 2021 10:42:01 +0800
Message-Id: <20210511024214.280733-4-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210511024214.280733-1-like.xu@linux.intel.com>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Splitting the logic for determining the guest values is unnecessarily
confusing, and potentially fragile. Perf should have full knowledge and
control of what values are loaded for the guest.

If we change .guest_get_msrs() to take a struct kvm_pmu pointer, then it
can generate the full set of guest values by grabbing guest ds_area and
pebs_data_cfg. Alternatively, .guest_get_msrs() could take the desired
guest MSR values directly (ds_area and pebs_data_cfg), but kvm_pmu is
vendor agnostic, so we don't see any reason to not just pass the pointer.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/core.c            | 4 ++--
 arch/x86/events/intel/core.c      | 4 ++--
 arch/x86/events/perf_event.h      | 2 +-
 arch/x86/include/asm/perf_event.h | 4 ++--
 arch/x86/kvm/vmx/vmx.c            | 3 ++-
 5 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index ccbe5b239c22..88e6540fe876 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -689,9 +689,9 @@ void x86_pmu_disable_all(void)
 	}
 }
 
-struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
+struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data)
 {
-	return static_call(x86_pmu_guest_get_msrs)(nr);
+	return static_call(x86_pmu_guest_get_msrs)(nr, data);
 }
 EXPORT_SYMBOL_GPL(perf_guest_get_msrs);
 
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 092ecacf8345..2f89fd599842 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3893,7 +3893,7 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	return 0;
 }
 
-static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
+static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
@@ -3926,7 +3926,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
 	return arr;
 }
 
-static struct perf_guest_switch_msr *core_guest_get_msrs(int *nr)
+static struct perf_guest_switch_msr *core_guest_get_msrs(int *nr, void *data)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 6a0f768c5330..685a1a4e9438 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -876,7 +876,7 @@ struct x86_pmu {
 	/*
 	 * Intel host/guest support (KVM)
 	 */
-	struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr);
+	struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr, void *data);
 
 	/*
 	 * Check period value for PERF_EVENT_IOC_PERIOD ioctl.
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 6a6e707905be..d5957b68906b 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -491,10 +491,10 @@ static inline void perf_check_microcode(void) { }
 #endif
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
-extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
+extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data);
 extern int x86_perf_get_lbr(struct x86_pmu_lbr *lbr);
 #else
-struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
+struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data);
 static inline int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
 {
 	return -1;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f2fd447eed45..df5c1c7f9bd3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6594,9 +6594,10 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 {
 	int i, nr_msrs;
 	struct perf_guest_switch_msr *msrs;
+	struct kvm_pmu *pmu = vcpu_to_pmu(&vmx->vcpu);
 
 	/* Note, nr_msrs may be garbage if perf_guest_get_msrs() returns NULL. */
-	msrs = perf_guest_get_msrs(&nr_msrs);
+	msrs = perf_guest_get_msrs(&nr_msrs, (void *)pmu);
 	if (!msrs)
 		return;
 
-- 
2.31.1

