Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7E0E622A
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2019 12:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfJ0LMl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Oct 2019 07:12:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:12491 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726834AbfJ0LMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Oct 2019 07:12:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Oct 2019 04:12:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,236,1569308400"; 
   d="scan'208";a="282690165"
Received: from unknown (HELO snr.jf.intel.com) ([10.54.39.141])
  by orsmga001.jf.intel.com with ESMTP; 27 Oct 2019 04:12:37 -0700
From:   Luwei Kang <luwei.kang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, ak@linux.intel.com, thomas.lendacky@amd.com,
        peterz@infradead.org, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v1 4/8] KVM: x86: Aviod clear the PEBS counter when PEBS enabled in guest
Date:   Sun, 27 Oct 2019 19:11:13 -0400
Message-Id: <1572217877-26484-5-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
References: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch introduce a parameter that avoid clear the PEBS event
counter while running in the guest. The performance counter which
use for PEBS event can be enabled through VM-entry when PEBS is
enabled in guest by PEBS output to Intel PT.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 arch/x86/events/intel/core.c      | 19 +++++++++++--------
 arch/x86/events/perf_event.h      |  2 +-
 arch/x86/include/asm/perf_event.h |  5 +++--
 arch/x86/kvm/vmx/vmx.c            |  3 ++-
 4 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index fcef678..1fcc9fc 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3323,16 +3323,16 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	return 0;
 }
 
-struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
+struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, bool pebs)
 {
 	if (x86_pmu.guest_get_msrs)
-		return x86_pmu.guest_get_msrs(nr);
+		return x86_pmu.guest_get_msrs(nr, pebs);
 	*nr = 0;
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(perf_guest_get_msrs);
 
-static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
+static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, bool pebs)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
@@ -3340,10 +3340,13 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
 	arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
 	arr[0].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
 	arr[0].guest = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_host_mask;
-	if (x86_pmu.flags & PMU_FL_PEBS_ALL)
-		arr[0].guest &= ~cpuc->pebs_enabled;
-	else
-		arr[0].guest &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
+	if (!pebs) {
+		if (x86_pmu.flags & PMU_FL_PEBS_ALL)
+			arr[0].guest &= ~cpuc->pebs_enabled;
+		else
+			arr[0].guest &=
+				~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
+	}
 	*nr = 1;
 
 	if (x86_pmu.pebs && x86_pmu.pebs_no_isolation) {
@@ -3364,7 +3367,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
 	return arr;
 }
 
-static struct perf_guest_switch_msr *core_guest_get_msrs(int *nr)
+static struct perf_guest_switch_msr *core_guest_get_msrs(int *nr, bool pebs)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index ecacfbf..57058fe 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -696,7 +696,7 @@ struct x86_pmu {
 	/*
 	 * Intel host/guest support (KVM)
 	 */
-	struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr);
+	struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr, bool pebs);
 
 	/*
 	 * Check period value for PERF_EVENT_IOC_PERIOD ioctl.
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index ee26e92..e29075a 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -322,12 +322,13 @@ struct perf_guest_switch_msr {
 	u64 host, guest;
 };
 
-extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
+extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, bool pebs);
 extern void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap);
 extern void perf_check_microcode(void);
 extern int x86_perf_rdpmc_index(struct perf_event *event);
 #else
-static inline struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
+static inline struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr,
+								bool pebs)
 {
 	*nr = 0;
 	return NULL;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e7970a2..170afde 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6428,7 +6428,8 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 	int i, nr_msrs;
 	struct perf_guest_switch_msr *msrs;
 
-	msrs = perf_guest_get_msrs(&nr_msrs);
+	msrs = perf_guest_get_msrs(&nr_msrs,
+			vcpu_to_pmu(&vmx->vcpu)->pebs_enable);
 
 	if (!msrs)
 		return;
-- 
1.8.3.1

