Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6542582D78
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 10:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732419AbfHFIGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 04:06:17 -0400
Received: from mga03.intel.com ([134.134.136.65]:5868 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731735AbfHFIGQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 04:06:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 01:01:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,352,1559545200"; 
   d="scan'208";a="373337421"
Received: from devel-ww.sh.intel.com ([10.239.48.128])
  by fmsmga005.fm.intel.com with ESMTP; 06 Aug 2019 01:00:59 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, peterz@infradead.org, pbonzini@redhat.com
Cc:     kan.liang@intel.com, mingo@redhat.com, rkrcmar@redhat.com,
        like.xu@intel.com, wei.w.wang@intel.com, jannh@google.com,
        arei.gonglei@huawei.com, jmattson@google.com
Subject: [PATCH v8 11/14] perf/x86: save/restore LBR_SELECT on vcpu switching
Date:   Tue,  6 Aug 2019 15:16:11 +0800
Message-Id: <1565075774-26671-12-git-send-email-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565075774-26671-1-git-send-email-wei.w.wang@intel.com>
References: <1565075774-26671-1-git-send-email-wei.w.wang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The regular host lbr perf event doesn't save/restore the LBR_SELECT msr
during a thread context switching, because the LBR_SELECT value is
generated from attr.branch_sample_type and already stored in
event->hw.branch_reg (please see intel_pmu_setup_hw_filter), which
doesn't get lost during thread context switching.

The attr.branch_sample_type for the vcpu lbr event is deliberately set
to the user call stack mode to enable the perf core to save/restore the
lbr related msrs on vcpu switching. So the attr.branch_sample_type
essentially doesn't represent what the guest pmu driver will write to
LBR_SELECT. Meanwhile, the host lbr driver doesn't configure the lbr msrs,
including the LBR_SELECT msr, for the vcpu thread case, as the pmu driver
inside the vcpu will do that.

So for the vcpu case, add the LBR_SELECT save/restore to ensure what the
guest writes to the LBR_SELECT msr doesn't get lost during the vcpu context
switching.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Kan Liang <kan.liang@intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 arch/x86/events/intel/lbr.c  | 7 +++++++
 arch/x86/events/perf_event.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index a0f3686..236f8352 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -390,6 +390,9 @@ static void __intel_pmu_lbr_restore(struct x86_perf_task_context *task_ctx)
 
 	wrmsrl(x86_pmu.lbr_tos, tos);
 	task_ctx->lbr_stack_state = LBR_NONE;
+
+	if (cpuc->vcpu_lbr)
+		wrmsrl(MSR_LBR_SELECT, task_ctx->lbr_sel);
 }
 
 static void __intel_pmu_lbr_save(struct x86_perf_task_context *task_ctx)
@@ -416,6 +419,10 @@ static void __intel_pmu_lbr_save(struct x86_perf_task_context *task_ctx)
 		if (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_INFO)
 			rdmsrl(MSR_LBR_INFO_0 + lbr_idx, task_ctx->lbr_info[i]);
 	}
+
+	if (cpuc->vcpu_lbr)
+		rdmsrl(MSR_LBR_SELECT, task_ctx->lbr_sel);
+
 	task_ctx->valid_lbrs = i;
 	task_ctx->tos = tos;
 	task_ctx->lbr_stack_state = LBR_VALID;
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 8b90a25..0b2f660 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -699,6 +699,7 @@ struct x86_perf_task_context {
 	u64 lbr_from[MAX_LBR_ENTRIES];
 	u64 lbr_to[MAX_LBR_ENTRIES];
 	u64 lbr_info[MAX_LBR_ENTRIES];
+	u64 lbr_sel;
 	int tos;
 	int valid_lbrs;
 	int lbr_callstack_users;
-- 
2.7.4

