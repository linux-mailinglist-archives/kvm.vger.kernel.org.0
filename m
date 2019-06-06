Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B98E736DAA
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 09:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbfFFHpK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 03:45:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:25012 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727026AbfFFHoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 03:44:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 00:44:46 -0700
X-ExtLoop1: 1
Received: from devel-ww.sh.intel.com ([10.239.48.128])
  by orsmga005.jf.intel.com with ESMTP; 06 Jun 2019 00:44:43 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, ak@linux.intel.com, peterz@infradead.org
Cc:     kan.liang@intel.com, mingo@redhat.com, rkrcmar@redhat.com,
        like.xu@intel.com, wei.w.wang@intel.com, jannh@google.com,
        arei.gonglei@huawei.com, jmattson@google.com
Subject: [PATCH v6 09/12] perf/x86: save/restore LBR_SELECT on vCPU switching
Date:   Thu,  6 Jun 2019 15:02:28 +0800
Message-Id: <1559804551-42271-10-git-send-email-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559804551-42271-1-git-send-email-wei.w.wang@intel.com>
References: <1559804551-42271-1-git-send-email-wei.w.wang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vCPU lbr event relies on the host to save/restore all the lbr
related MSRs. So add the LBR_SELECT save/restore to the related
functions for the vCPU case.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/events/intel/lbr.c  | 7 +++++++
 arch/x86/events/perf_event.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 118764b..4861a9d 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -383,6 +383,9 @@ static void __intel_pmu_lbr_restore(struct x86_perf_task_context *task_ctx)
 
 	wrmsrl(x86_pmu.lbr_tos, tos);
 	task_ctx->lbr_stack_state = LBR_NONE;
+
+	if (cpuc->vcpu_lbr)
+		wrmsrl(MSR_LBR_SELECT, task_ctx->lbr_sel);
 }
 
 static void __intel_pmu_lbr_save(struct x86_perf_task_context *task_ctx)
@@ -409,6 +412,10 @@ static void __intel_pmu_lbr_save(struct x86_perf_task_context *task_ctx)
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
index 86605d1..e37ff82 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -721,6 +721,7 @@ struct x86_perf_task_context {
 	u64 lbr_from[MAX_LBR_ENTRIES];
 	u64 lbr_to[MAX_LBR_ENTRIES];
 	u64 lbr_info[MAX_LBR_ENTRIES];
+	u64 lbr_sel;
 	int tos;
 	int valid_lbrs;
 	int lbr_callstack_users;
-- 
2.7.4

