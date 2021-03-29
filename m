Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E72B34C331
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 07:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbhC2Ftm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 01:49:42 -0400
Received: from mga07.intel.com ([134.134.136.100]:15632 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229750AbhC2Ftf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Mar 2021 01:49:35 -0400
IronPort-SDR: cgAqumFL9HRj/7ly6kGIyv+1Mtv0R/cmT3efuai8TVajzfJHGkXLgvu6C/9CO4wy85bIPMXM4W
 2ZDxuM0y9kGA==
X-IronPort-AV: E=McAfee;i="6000,8403,9937"; a="255478726"
X-IronPort-AV: E=Sophos;i="5.81,285,1610438400"; 
   d="scan'208";a="255478726"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2021 22:49:35 -0700
IronPort-SDR: N8ZisTHitQWJCuetuddL/0yzyM8siP+bB99dHnYJNlNmnvL7CByWTkBKLvRLmSDRLakOv9nqBn
 ScqgdtEErO8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,285,1610438400"; 
   d="scan'208";a="417506722"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 28 Mar 2021 22:49:31 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     peterz@infradead.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     eranian@google.com, andi@firstfloor.org, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v4 03/16] perf/x86/core: Pass "struct kvm_pmu *" to determine the guest values
Date:   Mon, 29 Mar 2021 13:41:24 +0800
Message-Id: <20210329054137.120994-4-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210329054137.120994-1-like.xu@linux.intel.com>
References: <20210329054137.120994-1-like.xu@linux.intel.com>
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
index 06bef6ba8a9b..7e2264a8c3f7 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -673,9 +673,9 @@ void x86_pmu_disable_all(void)
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
index af9ac48fe840..e8fee7cf767f 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3837,7 +3837,7 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	return 0;
 }
 
-static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
+static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
@@ -3869,7 +3869,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
 	return arr;
 }
 
-static struct perf_guest_switch_msr *core_guest_get_msrs(int *nr)
+static struct perf_guest_switch_msr *core_guest_get_msrs(int *nr, void *data)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 85dc4e1d4514..e52b35333e1f 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -809,7 +809,7 @@ struct x86_pmu {
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
index c8a4a548e96b..8063cb7e8387 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6513,9 +6513,10 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
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
2.29.2

