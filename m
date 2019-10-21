Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17291DFF25
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 10:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388187AbfJVIM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 04:12:27 -0400
Received: from mga06.intel.com ([134.134.136.31]:64390 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388242AbfJVIM0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 04:12:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 01:12:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,326,1566889200"; 
   d="scan'208";a="200703497"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 22 Oct 2019 01:12:24 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     pbonzini@redhat.com, peterz@infradead.org, kvm@vger.kernel.org
Cc:     like.xu@intel.com, linux-kernel@vger.kernel.org,
        jmattson@google.com, sean.j.christopherson@intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com
Subject: [PATCH v3 2/6] perf/core: Provide a kernel-internal interface to pause perf_event
Date:   Tue, 22 Oct 2019 00:06:47 +0800
Message-Id: <20191021160651.49508-3-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191021160651.49508-1-like.xu@linux.intel.com>
References: <20191021160651.49508-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Exporting perf_event_pause() as an external accessor for kernel users (such
as KVM) who may do both disable perf_event and read count with just one
time to hold perf_event_ctx_lock. Also the value could be reset optionally.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 include/linux/perf_event.h |  5 +++++
 kernel/events/core.c       | 18 ++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index d601df36e671..e9768bfc76f6 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1337,6 +1337,7 @@ extern void perf_event_disable_inatomic(struct perf_event *event);
 extern void perf_event_task_tick(void);
 extern int perf_event_account_interrupt(struct perf_event *event);
 extern int perf_event_period(struct perf_event *event, u64 value);
+extern u64 perf_event_pause(struct perf_event *event, bool reset);
 #else /* !CONFIG_PERF_EVENTS: */
 static inline void *
 perf_aux_output_begin(struct perf_output_handle *handle,
@@ -1420,6 +1421,10 @@ static inline int perf_event_period(struct perf_event *event, u64 value)
 {
 	return -EINVAL;
 }
+static inline u64 perf_event_pause(struct perf_event *event, bool reset)
+{
+	return 0;
+}
 #endif
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index e1b83d2731da..fc9f5ebf4849 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5029,6 +5029,24 @@ static void _perf_event_reset(struct perf_event *event)
 	perf_event_update_userpage(event);
 }
 
+/* Assume it's not an event with inherit set. */
+u64 perf_event_pause(struct perf_event *event, bool reset)
+{
+	struct perf_event_context *ctx;
+	u64 count;
+
+	ctx = perf_event_ctx_lock(event);
+	WARN_ON_ONCE(event->attr.inherit);
+	_perf_event_disable(event);
+	count = local64_read(&event->count);
+	if (reset)
+		local64_set(&event->count, 0);
+	perf_event_ctx_unlock(event, ctx);
+
+	return count;
+}
+EXPORT_SYMBOL_GPL(perf_event_pause);
+
 /*
  * Holding the top-level event's child_mutex means that any
  * descendant process that has inherited this event will block
-- 
2.21.0

