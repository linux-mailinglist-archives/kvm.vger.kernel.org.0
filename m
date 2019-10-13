Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1F2D5941
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 03:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729776AbfJNBU5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Oct 2019 21:20:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:18548 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729761AbfJNBU5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Oct 2019 21:20:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Oct 2019 18:20:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,294,1566889200"; 
   d="scan'208";a="395033642"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga005.fm.intel.com with ESMTP; 13 Oct 2019 18:20:54 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        peterz@infradead.org, Jim Mattson <jmattson@google.com>
Cc:     rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] perf/core: Provide a kernel-internal interface to pause perf_event
Date:   Sun, 13 Oct 2019 17:15:31 +0800
Message-Id: <20191013091533.12971-3-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191013091533.12971-1-like.xu@linux.intel.com>
References: <20191013091533.12971-1-like.xu@linux.intel.com>
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
 kernel/events/core.c       | 16 ++++++++++++++++
 2 files changed, 21 insertions(+)

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
index e1b83d2731da..e29038984cf4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5029,6 +5029,22 @@ static void _perf_event_reset(struct perf_event *event)
 	perf_event_update_userpage(event);
 }
 
+u64 perf_event_pause(struct perf_event *event, bool reset)
+{
+	struct perf_event_context *ctx;
+	u64 count, enabled, running;
+
+	ctx = perf_event_ctx_lock(event);
+	_perf_event_disable(event);
+	count = __perf_event_read_value(event, &enabled, &running);
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

