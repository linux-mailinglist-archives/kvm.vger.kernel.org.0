Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A045D1D778B
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 13:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgERLni (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 07:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgERLni (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 07:43:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133ADC061A0C;
        Mon, 18 May 2020 04:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vqFtTJgrrYSVHcjYD6xL7NeKGj8OBrO9WYZrdZNFTPg=; b=Ic+l84u85aQa9NU4JISWSGcUT7
        JspapLxIoUC4p2cSrnYXmwwkgCgvGxo0Q+bsGUzytgc0vP8MpdPy7S83x0dBTEMFz2XY3UuE8bSHJ
        8YNjvaG19lKsoS5ccYJuzkZU/Q8pAsucYBHZGpqqZsXv5wE8fIZeKBYPQX9FO1L3Sec3P64yxzcm5
        wGzdwYH7VrCpcu8J/EDmELUtDk50YDb3qAh+wlCRaDpqG2Iawy++/9E1zTsxRkYNmV+q5fpOzLUdq
        ZvIuiYE8tnH0ZWhyDv8P5+OhRKNQtuu0b4ZEOGsp28K+uNyPmofy1h/Co0GLN1tYsOPL9Ib4ITumS
        SL4VVMpw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jaeAx-0001CZ-0L; Mon, 18 May 2020 11:43:19 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 0BCE03011E8;
        Mon, 18 May 2020 13:43:14 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 066CB2B3D07AA; Mon, 18 May 2020 13:43:14 +0200 (CEST)
Date:   Mon, 18 May 2020 13:43:13 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, ak@linux.intel.com,
        wei.w.wang@intel.com
Subject: Re: [PATCH v11 04/11] perf/x86: Add constraint to create guest LBR
 event without hw counter
Message-ID: <20200518114313.GD277222@hirez.programming.kicks-ass.net>
References: <20200514083054.62538-1-like.xu@linux.intel.com>
 <20200514083054.62538-5-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514083054.62538-5-like.xu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Subject: perf/x86: Add constraint to create guest LBR event without hw counter
From: Like Xu <like.xu@linux.intel.com>
Date: Thu, 14 May 2020 16:30:47 +0800

From: Like Xu <like.xu@linux.intel.com>

The hypervisor may request the perf subsystem to schedule a time window
to directly access the LBR stack msrs for its own use. Normally, it would
create a guest LBR event with callstack mode enabled, which is scheduled
along with other ordinary LBR events on the host but in an exclusive way.

To avoid wasting a counter for the guest LBR event, the perf tracks it via
needs_guest_lbr_without_counter() and assigns it with a fake VLBR counter
with the help of new lbr_without_counter_constraint. As with the BTS event,
there is actually no hardware counter assigned for the guest LBR event.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20200514083054.62538-5-like.xu@linux.intel.com
---
 arch/x86/events/core.c            |    1 +
 arch/x86/events/intel/core.c      |   18 ++++++++++++++++++
 arch/x86/events/intel/lbr.c       |    4 ++++
 arch/x86/events/perf_event.h      |    1 +
 arch/x86/include/asm/perf_event.h |   22 +++++++++++++++++++++-
 5 files changed, 45 insertions(+), 1 deletion(-)

--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -1104,6 +1104,7 @@ static inline void x86_assign_hw_event(s
 
 	switch (hwc->idx) {
 	case INTEL_PMC_IDX_FIXED_BTS:
+	case INTEL_PMC_IDX_FIXED_VLBR:
 		hwc->config_base = 0;
 		hwc->event_base	= 0;
 		break;
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2621,6 +2621,20 @@ intel_bts_constraints(struct perf_event
 	return NULL;
 }
 
+/*
+ * Note: matches a fake event, like Fixed2.
+ */
+static struct event_constraint *
+intel_vlbr_constraints(struct perf_event *event)
+{
+	struct event_constraint *c = &vlbr_constraint;
+
+	if (unlikely(constraint_match(c, event->hw.config)))
+		return c;
+
+	return NULL;
+}
+
 static int intel_alt_er(int idx, u64 config)
 {
 	int alt_idx = idx;
@@ -2811,6 +2825,10 @@ __intel_get_event_constraints(struct cpu
 {
 	struct event_constraint *c;
 
+	c = intel_vlbr_constraints(event);
+	if (c)
+		return c;
+
 	c = intel_bts_constraints(event);
 	if (c)
 		return c;
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1363,3 +1363,7 @@ int x86_perf_get_lbr(struct x86_pmu_lbr
 	return 0;
 }
 EXPORT_SYMBOL_GPL(x86_perf_get_lbr);
+
+struct event_constraint vlbr_constraint =
+	FIXED_EVENT_CONSTRAINT(INTEL_FIXED_VLBR_EVENT,
+			       (INTEL_PMC_IDX_FIXED_VLBR - INTEL_PMC_IDX_FIXED));
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -990,6 +990,7 @@ void release_ds_buffers(void);
 void reserve_ds_buffers(void);
 
 extern struct event_constraint bts_constraint;
+extern struct event_constraint vlbr_constraint;
 
 void intel_pmu_enable_bts(u64 config);
 
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -192,10 +192,30 @@ struct x86_pmu_capability {
 #define GLOBAL_STATUS_UNC_OVF				BIT_ULL(61)
 #define GLOBAL_STATUS_ASIF				BIT_ULL(60)
 #define GLOBAL_STATUS_COUNTERS_FROZEN			BIT_ULL(59)
-#define GLOBAL_STATUS_LBRS_FROZEN			BIT_ULL(58)
+#define GLOBAL_STATUS_LBRS_FROZEN_BIT			58
+#define GLOBAL_STATUS_LBRS_FROZEN			BIT_ULL(GLOBAL_STATUS_LBRS_FROZEN_BIT)
 #define GLOBAL_STATUS_TRACE_TOPAPMI			BIT_ULL(55)
 
 /*
+ * We model guest LBR event tracing as another fixed-mode PMC like BTS.
+ *
+ * We choose bit 58 because it's used to indicate LBR stack frozen state
+ * for architectural perfmon v4, also we unconditionally mask that bit in
+ * the handle_pmi_common(), so it'll never be set in the overflow handling.
+ *
+ * With this fake counter assigned, the guest LBR event user (such as KVM),
+ * can program the LBR registers on its own, and we don't actually do anything
+ * with then in the host context.
+ */
+#define INTEL_PMC_IDX_FIXED_VLBR	(GLOBAL_STATUS_LBRS_FROZEN_BIT)
+
+/*
+ * Pseudo-encoding the guest LBR event as event=0x00,umask=0x1b,
+ * since it would claim bit 58 which is effectively Fixed26.
+ */
+#define INTEL_FIXED_VLBR_EVENT	0x1b00
+
+/*
  * Adaptive PEBS v4
  */
 
