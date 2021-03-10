Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A3C333729
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 09:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhCJITV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 03:19:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhCJITJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 03:19:09 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506F3C06174A;
        Wed, 10 Mar 2021 00:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BplBrpcAUR9ox/acJYHH1QuTJwnq90Wzo2Tfibypmbw=; b=gCz2acIZJCzGp+dUiyEKZIQhEY
        Tpuy93Bkp1UYF1pjK8vXPSqabfP6KxcxVtxzfYh0KLITThZJ/AipWfFyBQ1Ki1QEtVjayr09YDiar
        JOcfbYrIBMeCe55IogUUSmrm6sa2iFJuOYTKluV0Ro0isXeiGtvkj8jGEgrJJ6NRKvgxgk0ASyCg+
        4mJMtjQgkS+WI+aam3cmo9UzaFOHREDcan2cViNtfyOsKSnLwTJUz29Ar+L6WxuxEGat46ad7OMZ2
        mC5DHQTHfUrTlZoix1+Fvlc0fck68WfPRUnhnX7l618NFHwMjaJrbuuKWHKy9qqyISi5fjq49QXvk
        dIvQ2eAg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lJu3F-006IBD-2l; Wed, 10 Mar 2021 08:18:41 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 704CE3010CF;
        Wed, 10 Mar 2021 09:18:38 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5C216284B819A; Wed, 10 Mar 2021 09:18:38 +0100 (CET)
Date:   Wed, 10 Mar 2021 09:18:38 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu@linux.intel.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        syzbot+cce9ef2dd25246f815ee@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] x86/perf: Use RET0 as default for guest_get_msrs to
 handle "no PMU" case
Message-ID: <YEiA3hoCTMJbhKXO@hirez.programming.kicks-ass.net>
References: <20210309171019.1125243-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309171019.1125243-1-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 09, 2021 at 09:10:19AM -0800, Sean Christopherson wrote:

> @@ -2024,9 +2021,6 @@ static int __init init_hw_perf_events(void)
>  	if (!x86_pmu.read)
>  		x86_pmu.read = _x86_pmu_read;
>  
> -	if (!x86_pmu.guest_get_msrs)
> -		x86_pmu.guest_get_msrs = perf_guest_get_msrs_nop;

I suspect I might've been over eager here and we're now in trouble when
*_pmu_init() clears x86_pmu.guest_get_msrs (like for instance on AMD).

When that happens we need to restore __static_call_return0, otherwise
the following static_call_update() will patch in a NOP and RAX will be
garbage again.

So I've taken the liberty to update the patch as below.

---

Subject: x86/perf: Use RET0 as default for guest_get_msrs to handle "no PMU" case
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 9 Mar 2021 09:10:19 -0800

From: Sean Christopherson <seanjc@google.com>

Initialize x86_pmu.guest_get_msrs to return 0/NULL to handle the "nop"
case.  Patching in perf_guest_get_msrs_nop() during setup does not work
if there is no PMU, as setup bails before updating the static calls,
leaving x86_pmu.guest_get_msrs NULL and thus a complete nop.  Ultimately,
this causes VMX abort on VM-Exit due to KVM putting random garbage from
the stack into the MSR load list.

Add a comment in KVM to note that nr_msrs is valid if and only if the
return value is non-NULL.

Fixes: abd562df94d1 ("x86/perf: Use static_call for x86_pmu.guest_get_msrs")
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Reported-by: syzbot+cce9ef2dd25246f815ee@syzkaller.appspotmail.com
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210309171019.1125243-1-seanjc@google.com
---

v2:
 - Use __static_call_return0 to return NULL instead of manually checking
   the hook at invocation.  [Peter]
 - Rebase to tip/sched/core, commit 4117cebf1a9f ("psi: Optimize task
   switch inside shared cgroups").

 arch/x86/events/core.c |   15 ++++++---------
 arch/x86/kvm/vmx/vmx.c |    2 +-
 2 files changed, 7 insertions(+), 10 deletions(-)

--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -81,7 +81,11 @@ DEFINE_STATIC_CALL_NULL(x86_pmu_swap_tas
 DEFINE_STATIC_CALL_NULL(x86_pmu_drain_pebs,   *x86_pmu.drain_pebs);
 DEFINE_STATIC_CALL_NULL(x86_pmu_pebs_aliases, *x86_pmu.pebs_aliases);
 
-DEFINE_STATIC_CALL_NULL(x86_pmu_guest_get_msrs,  *x86_pmu.guest_get_msrs);
+/*
+ * This one is magic, it will get called even when PMU init fails (because
+ * there is no PMU), in which case it should simply return NULL.
+ */
+DEFINE_STATIC_CALL_RET0(x86_pmu_guest_get_msrs, *x86_pmu.guest_get_msrs);
 
 u64 __read_mostly hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
@@ -1944,13 +1948,6 @@ static void _x86_pmu_read(struct perf_ev
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
@@ -2025,7 +2022,7 @@ static int __init init_hw_perf_events(vo
 		x86_pmu.read = _x86_pmu_read;
 
 	if (!x86_pmu.guest_get_msrs)
-		x86_pmu.guest_get_msrs = perf_guest_get_msrs_nop;
+		x86_pmu.guest_get_msrs = (void *)&__static_call_return0;
 
 	x86_pmu_static_call_update();
 
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6580,8 +6580,8 @@ static void atomic_switch_perf_msrs(stru
 	int i, nr_msrs;
 	struct perf_guest_switch_msr *msrs;
 
+	/* Note, nr_msrs may be garbage if perf_guest_get_msrs() returns NULL. */
 	msrs = perf_guest_get_msrs(&nr_msrs);
-
 	if (!msrs)
 		return;
 
