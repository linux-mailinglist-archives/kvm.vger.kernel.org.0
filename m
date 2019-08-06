Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7CC82D75
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 10:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732372AbfHFIGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 04:06:04 -0400
Received: from mga03.intel.com ([134.134.136.65]:5861 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732356AbfHFIGE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 04:06:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 01:00:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,352,1559545200"; 
   d="scan'208";a="373337398"
Received: from devel-ww.sh.intel.com ([10.239.48.128])
  by fmsmga005.fm.intel.com with ESMTP; 06 Aug 2019 01:00:57 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, peterz@infradead.org, pbonzini@redhat.com
Cc:     kan.liang@intel.com, mingo@redhat.com, rkrcmar@redhat.com,
        like.xu@intel.com, wei.w.wang@intel.com, jannh@google.com,
        arei.gonglei@huawei.com, jmattson@google.com
Subject: [PATCH v8 10/14] perf/x86/lbr: don't share lbr for the vcpu usage case
Date:   Tue,  6 Aug 2019 15:16:10 +0800
Message-Id: <1565075774-26671-11-git-send-email-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565075774-26671-1-git-send-email-wei.w.wang@intel.com>
References: <1565075774-26671-1-git-send-email-wei.w.wang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Perf event scheduling lets multiple lbr events share the lbr if they
use the same config for LBR_SELECT. For the vcpu case, the vcpu's lbr
event created on the host deliberately sets the config to the user
callstack mode to have the host support to save/restore the lbr state
on vcpu context switching, and the config won't be written to the
LBR_SELECT, as the LBR_SELECT is configured by the guest, which might
not be the same as the user callstack mode. So don't allow the vcpu's
lbr event to share lbr with other host lbr events.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 arch/x86/events/intel/lbr.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 4f4bd18..a0f3686 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -45,6 +45,12 @@ static const enum {
 #define LBR_CALL_STACK_BIT	9 /* enable call stack */
 
 /*
+ * Set this hardware reserved bit if the lbr perf event is for the vcpu lbr
+ * emulation. This makes the reg->config different from other regular lbr
+ * events' config, so that they will not share the lbr feature.
+ */
+#define LBR_VCPU_BIT		62
+/*
  * Following bit only exists in Linux; we mask it out before writing it to
  * the actual MSR. But it helps the constraint perf code to understand
  * that this is a separate configuration.
@@ -62,6 +68,7 @@ static const enum {
 #define LBR_FAR		(1 << LBR_FAR_BIT)
 #define LBR_CALL_STACK	(1 << LBR_CALL_STACK_BIT)
 #define LBR_NO_INFO	(1ULL << LBR_NO_INFO_BIT)
+#define LBR_VCPU	(1ULL << LBR_VCPU_BIT)
 
 #define LBR_PLM (LBR_KERNEL | LBR_USER)
 
@@ -818,6 +825,26 @@ static int intel_pmu_setup_hw_lbr_filter(struct perf_event *event)
 	    (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_INFO))
 		reg->config |= LBR_NO_INFO;
 
+	/*
+	 * An lbr perf event without a counter indicates this is for the vcpu
+	 * lbr emulation. The vcpu lbr emulation does not allow the lbr
+	 * feature to be shared with other lbr events on the host, because the
+	 * LBR_SELECT msr is configured by the guest itself. The reg->config
+	 * is deliberately configured to be user call stack mode via the
+	 * related attr fileds to get the host perf's help to save/restore the
+	 * lbr state on vcpu context switching. It doesn't represent what
+	 * LBR_SELECT will be configured.
+	 *
+	 * Set the reserved LBR_VCPU bit for the vcpu usage case, so that the
+	 * vcpu's lbr perf event will not share the lbr feature with other perf
+	 * events. (see __intel_shared_reg_get_constraints, failing to share
+	 * makes it return the emptyconstraint, which finally makes
+	 * x86_schedule_events fail to schedule the lower priority lbr event on
+	 * the lbr feature).
+	 */
+	if (is_no_counter_event(event))
+		reg->config |= LBR_VCPU;
+
 	return 0;
 }
 
-- 
2.7.4

