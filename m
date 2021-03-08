Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278BC3309C6
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 09:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhCHIzC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 03:55:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhCHIyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 03:54:40 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C27CC06174A;
        Mon,  8 Mar 2021 00:54:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ANaVFRfhdnFocYbReHLCZECtJVt3gnfyZgmlG+L6e9g=; b=BO4fm6t9c/hak3Yul5LcR2NTEW
        SbcjBht12dJpLW3Oavg3bAT/cmkoRHgVvhm72MkA0k/mV0eDg8JWoKP8q3xJKGh4JYYXh6M9hzFwS
        /Z8sYXGIJcln9AEXXr7uRnMyv2i5h1j7HvF4Ua3tEE//wY8SK5vl/+NtjlgZwUrp5lizKaWF3KL8c
        LqjRxJXAfd4Kv7NGlg3iUBGmMngwiMBNLI1eI91c46QKbvIT16uPWv/k0oeSe2r23yyV4zcxMo0pt
        G8QwATc7mf3uC9zFkF1M8Vy8on3ZTioa/w0DrySGlCvCqjx9yTOZd0qaPbtsKoNlVJJi+dw8ThSF6
        zQCU/lVw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lJBeF-00FFUW-98; Mon, 08 Mar 2021 08:54:00 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DB32F300238;
        Mon,  8 Mar 2021 09:53:52 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id BD7FB2BB25DDF; Mon,  8 Mar 2021 09:53:52 +0100 (CET)
Date:   Mon, 8 Mar 2021 09:53:52 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
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
Message-ID: <YEXmILSHDNDuMk/N@hirez.programming.kicks-ass.net>
References: <20210305223331.4173565-1-seanjc@google.com>
 <053d0a22-394d-90d0-8d3b-3cd37ca3f378@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <053d0a22-394d-90d0-8d3b-3cd37ca3f378@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021 at 10:25:59AM +0800, Xu, Like wrote:
> On 2021/3/6 6:33, Sean Christopherson wrote:
> > Handle a NULL x86_pmu.guest_get_msrs at invocation instead of patching
> > in perf_guest_get_msrs_nop() during setup.  If there is no PMU, setup
> 
> "If there is no PMU" ...

Then you shouldn't be calling this either ofcourse :-)

> > @@ -671,7 +671,11 @@ void x86_pmu_disable_all(void)
> >   struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
> >   {
> > -	return static_call(x86_pmu_guest_get_msrs)(nr);
> > +	if (x86_pmu.guest_get_msrs)
> > +		return static_call(x86_pmu_guest_get_msrs)(nr);
> 
> How about using "static_call_cond" per commit "452cddbff7" ?

Given the one user in atomic_switch_perf_msrs() that should work because
it doesn't seem to care about nr_msrs when !msrs.

Still, it calling atomic_switch_perf_msrs() and
intel_pmu_lbr_is_enabled() when there isn't a PMU at all is of course, a
complete waste of cycles.
