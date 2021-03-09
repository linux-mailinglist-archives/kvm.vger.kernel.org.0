Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315BB332120
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 09:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhCIIqT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 03:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhCIIp5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 03:45:57 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35059C06174A;
        Tue,  9 Mar 2021 00:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=G2k3R4Tdi/Hx20QLdrIl7Gd0ODGJ454XbaXMZQmyqdc=; b=BfNvIj93IMzsXqG7n+fpKKD5HB
        7SyO6rt2YhcfAVUh1zG7n5g49xapE5f/5xmQofHqlr0e0OE+Hc5FDLiopskI1Q7uORjt53Y44TxVf
        tgJOEC4YBmW1sUP9+N1HIdM3Dr0F/DcHKxaqaCfdSS7G7GpVGjPYbiNVlcXNkPCG1tVo2Qm52sUjY
        gd2gK0bjnap+drG4izl2l2BTF1lSpOY9iVnNFbeMs+jWxD66jaX4IsW8O1sk2L0j81n1pSS8eXJLF
        JMmKnUb1XlFWgKkvyLVlb+5paovs1AWUbMaOmAbKvbwaR89l5BlE5Epd+QHPUSm/g2v1C3tbyWEti
        zcFfqNrw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lJXzN-000Fqx-W3; Tue, 09 Mar 2021 08:45:17 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5B4B5301A32;
        Tue,  9 Mar 2021 09:45:12 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 45CCA2351CF0D; Tue,  9 Mar 2021 09:45:12 +0100 (CET)
Date:   Tue, 9 Mar 2021 09:45:12 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Xu, Like" <like.xu@intel.com>, Dmitry Vyukov <dvyukov@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        "Thomas Gleixner
        (x86/pti/timer/core/smp/irq/perf/efi/locking/ras/objtool)
        (x86@kernel.org)" <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86/perf: Fix guest_get_msrs static call if there is no
 PMU
Message-ID: <YEc1mFkaILfF37At@hirez.programming.kicks-ass.net>
References: <20210305223331.4173565-1-seanjc@google.com>
 <053d0a22-394d-90d0-8d3b-3cd37ca3f378@intel.com>
 <YEXmILSHDNDuMk/N@hirez.programming.kicks-ass.net>
 <YEaLzKWd0wAmdqvs@google.com>
 <YEcn6bGYxdgrp0Ik@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEcn6bGYxdgrp0Ik@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 09, 2021 at 08:46:49AM +0100, Peter Zijlstra wrote:
> On Mon, Mar 08, 2021 at 12:40:44PM -0800, Sean Christopherson wrote:
> > On Mon, Mar 08, 2021, Peter Zijlstra wrote:
> 
> > > Given the one user in atomic_switch_perf_msrs() that should work because
> > > it doesn't seem to care about nr_msrs when !msrs.
> > 
> > Uh, that commit quite cleary says:
> 
> D0h! I got static_call_cond() and __static_call_return0 mixed up.
> Anyway, let me see if I can make something work here.

Does this work? I can never seem to start a VM, and if I do accidentally
manage, then it never contains the things I need :/

---
diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 6ddeed3cd2ac..fadcecd73e1a 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -81,7 +81,11 @@ DEFINE_STATIC_CALL_NULL(x86_pmu_swap_task_ctx, *x86_pmu.swap_task_ctx);
 DEFINE_STATIC_CALL_NULL(x86_pmu_drain_pebs,   *x86_pmu.drain_pebs);
 DEFINE_STATIC_CALL_NULL(x86_pmu_pebs_aliases, *x86_pmu.pebs_aliases);
 
-DEFINE_STATIC_CALL_NULL(x86_pmu_guest_get_msrs,  *x86_pmu.guest_get_msrs);
+/*
+ * This one is magic, it will get called even when PMU init fails (because
+ * there is no PMU), in which case it should simply return NULL.
+ */
+__DEFINE_STATIC_CALL(x86_pmu_guest_get_msrs, *x86_pmu.guest_get_msrs, __static_call_return0);
 
 u64 __read_mostly hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
@@ -1944,13 +1948,6 @@ static void _x86_pmu_read(struct perf_event *event)
 	x86_perf_event_update(event);
 }
 
-static inline struct perf_guest_switch_msr *
-perf_guest_get_msrs_nop(int *nr)
-{
-	*nr = 0;
-	return NULL;
-}
-
 static int __init init_hw_perf_events(void)
 {
 	struct x86_pmu_quirk *quirk;
@@ -2024,9 +2021,6 @@ static int __init init_hw_perf_events(void)
 	if (!x86_pmu.read)
 		x86_pmu.read = _x86_pmu_read;
 
-	if (!x86_pmu.guest_get_msrs)
-		x86_pmu.guest_get_msrs = perf_guest_get_msrs_nop;
-
 	x86_pmu_static_call_update();
 
 	/*
