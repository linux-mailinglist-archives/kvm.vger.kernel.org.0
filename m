Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650413318C3
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 21:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbhCHUlR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 15:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhCHUkx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 15:40:53 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DD4C06174A
        for <kvm@vger.kernel.org>; Mon,  8 Mar 2021 12:40:52 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so3844684pjg.5
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 12:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YieL4r+TN+gn7WlBHT97uAGWLZ5+RH9FuBAcVj4s06U=;
        b=ZFGEV3DPNQZz37SL1BXfQkCq19S9we9dg+Cy44D92qHZPJ9reMhamBLz2Pam8qT77S
         SGT9QYiesdFSexslHwU9naxYNHyljqxxbRs5YFvPAGNOETxfFZ21N0oCU8a03261XyVz
         IiOGbfRSo3FMXbevkMgJTXUZC6pUm1rUBrbb2BMH0HaL9tSnHKjGw+e87pqOIxL9bUsQ
         /cZRNaK1CiVXM/h/X0XpBYN6a6iw6uDG+TZ0k8ryt3VhHyMFIxLFaXNpquZ1JGdOQYkn
         z8YTagHXadjU9hp4ThfgAqAIsOiTcAmAGM1V5y3xjAnvFvAkuF2+EBzrt7GXArFYBhfy
         /R5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YieL4r+TN+gn7WlBHT97uAGWLZ5+RH9FuBAcVj4s06U=;
        b=AxqKZEZx3QbOrAcCU7/74X19C9xCXJIMHvaSI3NQ9yp0gpPhBkYh2rx0zhu1U8/ebk
         ra+vqhgMOnzfoM4bGuxms2A/eimIyl1rmRvSB80YkewwJU6I/NUqPjrCgVabw+Z5RRzM
         isLF8vHjVcSB/eh/q2oGJSl5jeFXEaD4jo1acUJ/GiXA4pauBS+q3ID5PijAAicJX5p0
         Ky8NKeiZEODmFUOWD32axl6ZeiQWFxuWm0+JJ9qB4PVi+r3U8ojLE1JqqSj9rlUe+xFY
         I0Cn0yvN7IfOn4Tc1CTwtFQw40MK2Xussq4iak7x7vGc2rWtmWD3896Setgm/zu/fAZV
         tCyA==
X-Gm-Message-State: AOAM530FMxX1ff4Ahp7aG3c/Ydvly9He2pjT6KCFupZQk8HFbn8HP99q
        b/f3CNT0S7jDvNARzfvv34xhfA==
X-Google-Smtp-Source: ABdhPJzcDQa65JtsCO7brDxr9Rg9TeLDEn0f6G2jrZtRXgde7MiweWhKYfiIc1B5lQfqL6h5LdfVaw==
X-Received: by 2002:a17:902:7287:b029:e5:bd05:4a97 with SMTP id d7-20020a1709027287b02900e5bd054a97mr22397043pll.27.1615236052207;
        Mon, 08 Mar 2021 12:40:52 -0800 (PST)
Received: from google.com ([2620:15c:f:10:8:847a:d8b5:e2cc])
        by smtp.gmail.com with ESMTPSA id gw20sm230132pjb.3.2021.03.08.12.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 12:40:51 -0800 (PST)
Date:   Mon, 8 Mar 2021 12:40:44 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <YEaLzKWd0wAmdqvs@google.com>
References: <20210305223331.4173565-1-seanjc@google.com>
 <053d0a22-394d-90d0-8d3b-3cd37ca3f378@intel.com>
 <YEXmILSHDNDuMk/N@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEXmILSHDNDuMk/N@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021, Peter Zijlstra wrote:
> On Mon, Mar 08, 2021 at 10:25:59AM +0800, Xu, Like wrote:
> > On 2021/3/6 6:33, Sean Christopherson wrote:
> > > Handle a NULL x86_pmu.guest_get_msrs at invocation instead of patching
> > > in perf_guest_get_msrs_nop() during setup.  If there is no PMU, setup
> > 
> > "If there is no PMU" ...
> 
> Then you shouldn't be calling this either ofcourse :-)

This effectively is KVM's check to find out there is no PMU.  I certainly don't
want to replicate the switch statement in init_hw_perf_events(), plus whatever
is buried in check_hw_exists().  The alternative would be to add X86_FEATURE_PMU
so that KVM can easily check for PMU existence.  I don't really see the point
though, as bare metal KVM, where we really care about performance, is likely to
have a functional PMU, and if it doesn't then I doubt whoever is running KVM
cares much about performance.

> > > @@ -671,7 +671,11 @@ void x86_pmu_disable_all(void)
> > >   struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
> > >   {
> > > -	return static_call(x86_pmu_guest_get_msrs)(nr);
> > > +	if (x86_pmu.guest_get_msrs)
> > > +		return static_call(x86_pmu_guest_get_msrs)(nr);
> > 
> > How about using "static_call_cond" per commit "452cddbff7" ?
> 
> Given the one user in atomic_switch_perf_msrs() that should work because
> it doesn't seem to care about nr_msrs when !msrs.

Uh, that commit quite cleary says:

   NOTE: this is 'obviously' limited to functions with a 'void' return type.

Even if we somehow bypass the (void) cast, IIUC it will compile to a single
'ret',  and return whatever happens to be in RAX, not NULL as is needed.

> Still, it calling atomic_switch_perf_msrs() and
> intel_pmu_lbr_is_enabled() when there isn't a PMU at all is of course, a
