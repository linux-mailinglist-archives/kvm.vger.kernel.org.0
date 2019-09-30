Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7C2C2ADC
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 01:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732473AbfI3X2B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 19:28:01 -0400
Received: from mga05.intel.com ([192.55.52.43]:63706 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727850AbfI3X2A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 19:28:00 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Sep 2019 16:28:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,568,1559545200"; 
   d="scan'208";a="215880201"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 30 Sep 2019 16:27:57 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, peterz@infradead.org,
        Jim Mattson <jmattson@google.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] perf/core: Provide a kernel-internal interface to recalibrate event period
Date:   Mon, 30 Sep 2019 15:22:55 +0800
Message-Id: <20190930072257.43352-2-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190930072257.43352-1-like.xu@linux.intel.com>
References: <20190930072257.43352-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, perf_event_period() is used by user tool via ioctl. Exporting
perf_event_period() for kernel users (such as KVM) who may recalibrate the
event period for their assigned counters according to their requirements.

The perf_event_period() is an external accessor, just like the
perf_event_{en,dis}able() and should thus use perf_event_ctx_lock().

Suggested-by: Kan Liang <kan.liang@linux.intel.com>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 include/linux/perf_event.h |  5 +++++
 kernel/events/core.c       | 28 +++++++++++++++++++++-------
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 61448c19a132..83db24173e4d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1336,6 +1336,7 @@ extern void perf_event_disable_local(struct perf_event *event);
 extern void perf_event_disable_inatomic(struct perf_event *event);
 extern void perf_event_task_tick(void);
 extern int perf_event_account_interrupt(struct perf_event *event);
+extern int perf_event_period(struct perf_event *event, u64 value);
 #else /* !CONFIG_PERF_EVENTS: */
 static inline void *
 perf_aux_output_begin(struct perf_output_handle *handle,
@@ -1415,6 +1416,10 @@ static inline void perf_event_disable(struct perf_event *event)		{ }
 static inline int __perf_event_disable(void *info)			{ return -1; }
 static inline void perf_event_task_tick(void)				{ }
 static inline int perf_event_release_kernel(struct perf_event *event)	{ return 0; }
+extern int perf_event_period(struct perf_event *event, u64 value)
+{
+	return -EINVAL;
+}
 #endif
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4655adbbae10..de740d20b028 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5094,16 +5094,11 @@ static int perf_event_check_period(struct perf_event *event, u64 value)
 	return event->pmu->check_period(event, value);
 }
 
-static int perf_event_period(struct perf_event *event, u64 __user *arg)
+static int _perf_event_period(struct perf_event *event, u64 value)
 {
-	u64 value;
-
 	if (!is_sampling_event(event))
 		return -EINVAL;
 
-	if (copy_from_user(&value, arg, sizeof(value)))
-		return -EFAULT;
-
 	if (!value)
 		return -EINVAL;
 
@@ -5121,6 +5116,19 @@ static int perf_event_period(struct perf_event *event, u64 __user *arg)
 	return 0;
 }
 
+int perf_event_period(struct perf_event *event, u64 value)
+{
+	struct perf_event_context *ctx;
+	int ret;
+
+	ctx = perf_event_ctx_lock(event);
+	ret = _perf_event_period(event, value);
+	perf_event_ctx_unlock(event, ctx);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(perf_event_period);
+
 static const struct file_operations perf_fops;
 
 static inline int perf_fget_light(int fd, struct fd *p)
@@ -5164,8 +5172,14 @@ static long _perf_ioctl(struct perf_event *event, unsigned int cmd, unsigned lon
 		return _perf_event_refresh(event, arg);
 
 	case PERF_EVENT_IOC_PERIOD:
-		return perf_event_period(event, (u64 __user *)arg);
+	{
+		u64 value;
+
+		if (get_user(value, (u64 __user *)&arg))
+			return -EFAULT;
 
+		return _perf_event_period(event, value);
+	}
 	case PERF_EVENT_IOC_ID:
 	{
 		u64 id = primary_event_id(event);
-- 
2.21.0

