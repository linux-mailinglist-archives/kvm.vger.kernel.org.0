Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2C417A2A6
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 11:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgCEJ7L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 04:59:11 -0500
Received: from mga03.intel.com ([134.134.136.65]:7415 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727071AbgCEJ7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 04:59:11 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 01:59:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,517,1574150400"; 
   d="scan'208";a="234366468"
Received: from snr.bj.intel.com ([10.240.193.90])
  by orsmga008.jf.intel.com with ESMTP; 05 Mar 2020 01:59:03 -0800
From:   Luwei Kang <luwei.kang@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@redhat.com, namhyung@kernel.org, tglx@linutronix.de,
        bp@alien8.de, hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        pawan.kumar.gupta@linux.intel.com, ak@linux.intel.com,
        thomas.lendacky@amd.com, fenghua.yu@intel.com,
        kan.liang@linux.intel.com, like.xu@linux.intel.com
Subject: [PATCH v1 03/11] perf/x86: Expose a function to disable auto-reload
Date:   Fri,  6 Mar 2020 01:56:57 +0800
Message-Id: <1583431025-19802-4-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
References: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

KVM needs to disable PEBS auto-reload for guest owned event to avoid
unnecessory drain_pebs() in host.

Expose a function to disable auto-reload mechanism by unset the related
flag. The function has to be invoked before event enabling, otherwise
there is no effect.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
---
 arch/x86/events/intel/core.c      | 14 ++++++++++++++
 arch/x86/include/asm/perf_event.h |  2 ++
 2 files changed, 16 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index ef95076..cd17601 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3299,6 +3299,20 @@ static int core_pmu_hw_config(struct perf_event *event)
 	return intel_pmu_bts_config(event);
 }
 
+/*
+ * Disable PEBS auto-reload mechanism by unset the flag.
+ * The function has to be invoked before event enabling,
+ * otherwise there is no effect.
+ *
+ * Currently, it's used by KVM to disable PEBS auto-reload
+ * for guest owned event.
+ */
+void perf_x86_pmu_unset_auto_reload(struct perf_event *event)
+{
+	event->hw.flags &= ~PERF_X86_EVENT_AUTO_RELOAD;
+}
+EXPORT_SYMBOL_GPL(perf_x86_pmu_unset_auto_reload);
+
 static int intel_pmu_hw_config(struct perf_event *event)
 {
 	int ret = x86_pmu_hw_config(event);
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 29964b0..6179234 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -325,6 +325,7 @@ struct perf_guest_switch_msr {
 extern void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap);
 extern void perf_check_microcode(void);
 extern int x86_perf_rdpmc_index(struct perf_event *event);
+extern void perf_x86_pmu_unset_auto_reload(struct perf_event *event);
 #else
 static inline void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 {
@@ -333,6 +334,7 @@ static inline void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 
 static inline void perf_events_lapic_init(void)	{ }
 static inline void perf_check_microcode(void) { }
+static inline void perf_x86_pmu_unset_auto_reload(struct perf_event *event) { }
 #endif
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
-- 
1.8.3.1

