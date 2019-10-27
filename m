Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A316E6B30
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2019 03:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbfJ1C60 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Oct 2019 22:58:26 -0400
Received: from mga12.intel.com ([192.55.52.136]:35133 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728229AbfJ1C60 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Oct 2019 22:58:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Oct 2019 19:58:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,238,1569308400"; 
   d="scan'208";a="229552470"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga002.fm.intel.com with ESMTP; 27 Oct 2019 19:58:22 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kan.liang@intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v4 1/6] perf/core: Provide a kernel-internal interface to recalibrate event period
Date:   Sun, 27 Oct 2019 18:52:38 +0800
Message-Id: <20191027105243.34339-2-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191027105243.34339-1-like.xu@linux.intel.com>
References: <20191027105243.34339-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, perf_event_period() is used by user tools via ioctl. Based on
naming convention, exporting perf_event_period() for kernel users (such
as KVM) who may recalibrate the event period for their assigned counter
according to their requirements.

The perf_event_period() is an external accessor, just like the
perf_event_{en,dis}able() and should thus use perf_event_ctx_lock().

Suggested-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 include/linux/perf_event.h |  5 +++++
 kernel/events/core.c       | 28 +++++++++++++++++++++-------
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 61448c19a132..d601df36e671 100644
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
+static inline int perf_event_period(struct perf_event *event, u64 value)
+{
+	return -EINVAL;
+}
 #endif
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index bb3748d29b04..2fbb485ae880 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5106,16 +5106,11 @@ static int perf_event_check_period(struct perf_event *event, u64 value)
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
 
@@ -5133,6 +5128,19 @@ static int perf_event_period(struct perf_event *event, u64 __user *arg)
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
@@ -5176,8 +5184,14 @@ static long _perf_ioctl(struct perf_event *event, unsigned int cmd, unsigned lon
 		return _perf_event_refresh(event, arg);
 
 	case PERF_EVENT_IOC_PERIOD:
-		return perf_event_period(event, (u64 __user *)arg);
+	{
+		u64 value;
+
+		if (copy_from_user(&value, (u64 __user *)arg, sizeof(value)))
+			return -EFAULT;
 
+		return _perf_event_period(event, value);
+	}
 	case PERF_EVENT_IOC_ID:
 	{
 		u64 id = primary_event_id(event);
-- 
2.21.0

