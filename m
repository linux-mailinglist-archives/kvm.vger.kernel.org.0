Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0EC183F04
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 03:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgCMCS4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 22:18:56 -0400
Received: from mga14.intel.com ([192.55.52.115]:25868 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbgCMCSz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 22:18:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 19:18:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,546,1574150400"; 
   d="scan'208";a="261743775"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 12 Mar 2020 19:18:50 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Liran Alon <liran.alon@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Liang Kan <kan.liang@linux.intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Like Xu <like.xu@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v9 02/10] perf/x86/lbr: Add interface to get basic information about LBR stack
Date:   Fri, 13 Mar 2020 10:16:08 +0800
Message-Id: <20200313021616.112322-3-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200313021616.112322-1-like.xu@linux.intel.com>
References: <20200313021616.112322-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The LBR stack msrs are model specific. The perf subsystem has already
obtained the LBR stack base addresses based on the cpu model.

Therefore, an interface is added to enable callers outside the perf
subsystem to obtain the LBR stack base addresses. This is useful for
hypervisors to emulate the LBR feature for guests with less code.

Co-developed-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/intel/lbr.c       | 19 +++++++++++++++++++
 arch/x86/include/asm/perf_event.h | 12 ++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 534c76606049..5ed88e578eaa 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1334,3 +1334,22 @@ void intel_pmu_lbr_init_knl(void)
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
+	stack->nr = x86_pmu.lbr_nr;
+	stack->from = x86_pmu.lbr_from;
+	stack->to = x86_pmu.lbr_to;
+	stack->info = (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_INFO) ?
+			MSR_LBR_INFO_0 : 0;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(x86_perf_get_lbr);
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 29964b0e1075..e018a1cf604c 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -322,6 +322,13 @@ struct perf_guest_switch_msr {
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
@@ -337,12 +344,17 @@ static inline void perf_check_microcode(void) { }
 
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
2.21.1

