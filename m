Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3E71F81A6
	for <lists+kvm@lfdr.de>; Sat, 13 Jun 2020 10:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgFMILb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Jun 2020 04:11:31 -0400
Received: from mga07.intel.com ([134.134.136.100]:64586 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726460AbgFMILZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Jun 2020 04:11:25 -0400
IronPort-SDR: pYzNTe0Xd55z7HhcqY9028+PY5CElDg0l108df3B0PUavyE36pWA9GV1MKm9KBWSlvrk9dYWWj
 wl+bfclPiWUA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2020 01:11:22 -0700
IronPort-SDR: EPDCaGcVwlryAc7sVuB5xVqbAiL5ymdfmM3YZiQJ55hQ8tNuxa1tJhT4DpoK2axaVgpNlcNM7N
 ad9aMQ6Hv4yA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,506,1583222400"; 
   d="scan'208";a="474467349"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 13 Jun 2020 01:11:08 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v12 03/11] perf/x86/lbr: Add interface to get LBR information
Date:   Sat, 13 Jun 2020 16:09:48 +0800
Message-Id: <20200613080958.132489-4-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200613080958.132489-1-like.xu@linux.intel.com>
References: <20200613080958.132489-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The LBR records msrs are model specific. The perf subsystem has already
obtained the base addresses of LBR records based on the cpu model.

Therefore, an interface is added to allow callers outside the perf
subsystem to obtain these LBR information. It's useful for hypervisors
to emulate the LBR feature for guests with less code.

Co-developed-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/intel/lbr.c       | 20 ++++++++++++++++++++
 arch/x86/include/asm/perf_event.h | 12 ++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 65113b16804a..2ed3f2a51bdf 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1343,3 +1343,23 @@ void intel_pmu_lbr_init_knl(void)
 	if (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_LIP)
 		x86_pmu.intel_cap.lbr_format = LBR_FORMAT_EIP_FLAGS;
 }
+
+/**
+ * x86_perf_get_lbr - get the LBR records information
+ *
+ * @lbr: the caller's memory to store the LBR records information
+ *
+ * Returns: 0 indicates the LBR info has been successfully obtained
+ */
+int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
+{
+	int lbr_fmt = x86_pmu.intel_cap.lbr_format;
+
+	lbr->nr = x86_pmu.lbr_nr;
+	lbr->from = x86_pmu.lbr_from;
+	lbr->to = x86_pmu.lbr_to;
+	lbr->info = (lbr_fmt == LBR_FORMAT_INFO) ? MSR_LBR_INFO_0 : 0;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(x86_perf_get_lbr);
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index e855e9cf2c37..5d2c30f0df02 100644
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
+extern int x86_perf_get_lbr(struct x86_pmu_lbr *lbr);
 #else
 static inline struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
 {
 	*nr = 0;
 	return NULL;
 }
+static inline int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
+{
+	return -1;
+}
 #endif
 
 #ifdef CONFIG_CPU_SUP_INTEL
-- 
2.21.3

