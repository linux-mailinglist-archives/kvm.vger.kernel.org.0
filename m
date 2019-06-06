Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52FD336DB1
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 09:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbfFFHob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 03:44:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:24992 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbfFFHo3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 03:44:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 00:44:28 -0700
X-ExtLoop1: 1
Received: from devel-ww.sh.intel.com ([10.239.48.128])
  by orsmga005.jf.intel.com with ESMTP; 06 Jun 2019 00:44:26 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, ak@linux.intel.com, peterz@infradead.org
Cc:     kan.liang@intel.com, mingo@redhat.com, rkrcmar@redhat.com,
        like.xu@intel.com, wei.w.wang@intel.com, jannh@google.com,
        arei.gonglei@huawei.com, jmattson@google.com
Subject: [PATCH v6 02/12] perf/x86: add a function to get the lbr stack
Date:   Thu,  6 Jun 2019 15:02:21 +0800
Message-Id: <1559804551-42271-3-git-send-email-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559804551-42271-1-git-send-email-wei.w.wang@intel.com>
References: <1559804551-42271-1-git-send-email-wei.w.wang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The LBR stack MSRs are architecturally specific. The perf subsystem has
already assigned the abstracted MSR values based on the CPU architecture.

This patch enables a caller outside the perf subsystem to get the LBR
stack info. This is useful for hyperviosrs to prepare the lbr feature
for the guest.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/events/intel/lbr.c       | 23 +++++++++++++++++++++++
 arch/x86/include/asm/perf_event.h | 14 ++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 6f814a2..784642a 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1311,3 +1311,26 @@ void intel_pmu_lbr_init_knl(void)
 	if (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_LIP)
 		x86_pmu.intel_cap.lbr_format = LBR_FORMAT_EIP_FLAGS;
 }
+
+/**
+ * x86_perf_get_lbr_stack - get the lbr stack related MSRs
+ *
+ * @stack: the caller's memory to get the lbr stack
+ *
+ * Returns: 0 indicates that the lbr stack has been successfully obtained.
+ */
+int x86_perf_get_lbr_stack(struct x86_perf_lbr_stack *stack)
+{
+	stack->nr = x86_pmu.lbr_nr;
+	stack->tos = x86_pmu.lbr_tos;
+	stack->from = x86_pmu.lbr_from;
+	stack->to = x86_pmu.lbr_to;
+
+	if (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_INFO)
+		stack->info = MSR_LBR_INFO_0;
+	else
+		stack->info = 0;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(x86_perf_get_lbr_stack);
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 1392d5e..2606100 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -318,7 +318,16 @@ struct perf_guest_switch_msr {
 	u64 host, guest;
 };
 
+struct x86_perf_lbr_stack {
+	unsigned int	nr;
+	unsigned int	tos;
+	unsigned int	from;
+	unsigned int	to;
+	unsigned int	info;
+};
+
 extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
+extern int x86_perf_get_lbr_stack(struct x86_perf_lbr_stack *stack);
 extern void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap);
 extern void perf_check_microcode(void);
 extern int x86_perf_rdpmc_index(struct perf_event *event);
@@ -329,6 +338,11 @@ static inline struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
 	return NULL;
 }
 
+static inline int x86_perf_get_lbr_stack(struct x86_perf_lbr_stack *stack)
+{
+	return -1;
+}
+
 static inline void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 {
 	memset(cap, 0, sizeof(*cap));
-- 
2.7.4

