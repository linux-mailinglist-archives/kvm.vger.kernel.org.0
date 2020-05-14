Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21DAE1D2A2A
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 10:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgENIbY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 04:31:24 -0400
Received: from mga18.intel.com ([134.134.136.126]:12089 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgENIbU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 04:31:20 -0400
IronPort-SDR: dgtTiz2+vJY9DY48UKT2FXWSfYdc81CXAHCApoy+vTi8WE2rEpheb/vNfEjq/NhDJbsNwU0+4o
 /rTngXQVu27Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 01:31:19 -0700
IronPort-SDR: CVLpGAHYzEt/tuML19LGqujxwVkIiFHcSfpipO9qWg4C5gjLlM1GFTQMApNWhvLzmmte070B+F
 s/klU7cIuRjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,390,1583222400"; 
   d="scan'208";a="341539946"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga001.jf.intel.com with ESMTP; 14 May 2020 01:31:15 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, ak@linux.intel.com,
        wei.w.wang@intel.com, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v11 03/11] perf/x86/lbr: Add interface to get basic information about LBR stack
Date:   Thu, 14 May 2020 16:30:46 +0800
Message-Id: <20200514083054.62538-4-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200514083054.62538-1-like.xu@linux.intel.com>
References: <20200514083054.62538-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The LBR stack msrs are model specific. The perf subsystem has already
obtained the LBR stack base addresses based on the cpu model.

Therefore, an interface is added to allow callers outside the perf
subsystem to obtain the LBR stack base addresses. It's useful for
hypervisors to emulate the LBR feature for guests with less code.

Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Co-developed-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/intel/lbr.c       | 20 ++++++++++++++++++++
 arch/x86/include/asm/perf_event.h | 12 ++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 65113b16804a..6c60dcaaaf69 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1343,3 +1343,23 @@ void intel_pmu_lbr_init_knl(void)
 	if (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_LIP)
 		x86_pmu.intel_cap.lbr_format = LBR_FORMAT_EIP_FLAGS;
 }
+
+/**
+ * x86_perf_get_lbr - get the LBR stack information
+ *
+ * @stack: the caller's memory to store the LBR stack information
+ *
+ * Returns: 0 indicates the LBR stack info has been successfully obtained
+ */
+int x86_perf_get_lbr(struct x86_pmu_lbr *stack)
+{
+	int lbr_fmt = x86_pmu.intel_cap.lbr_format;
+
+	stack->nr = x86_pmu.lbr_nr;
+	stack->from = x86_pmu.lbr_from;
+	stack->to = x86_pmu.lbr_to;
+	stack->info = (lbr_fmt == LBR_FORMAT_INFO) ? MSR_LBR_INFO_0 : 0;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(x86_perf_get_lbr);
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index e855e9cf2c37..5071515f6b0f 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -333,6 +333,13 @@ struct perf_guest_switch_msr {
 	u64 host, guest;
 };
 
+struct x86_pmu_lbr {
+	unsigned int	nr;
+	unsigned int	from;
+	unsigned int	to;
+	unsigned int	info;
+};
+
 extern void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap);
 extern void perf_check_microcode(void);
 extern int x86_perf_rdpmc_index(struct perf_event *event);
@@ -348,12 +355,17 @@ static inline void perf_check_microcode(void) { }
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
 extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
+extern int x86_perf_get_lbr(struct x86_pmu_lbr *stack);
 #else
 static inline struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
 {
 	*nr = 0;
 	return NULL;
 }
+static inline int x86_perf_get_lbr(struct x86_pmu_lbr *stack)
+{
+	return -1;
+}
 #endif
 
 #ifdef CONFIG_CPU_SUP_INTEL
-- 
2.21.3

