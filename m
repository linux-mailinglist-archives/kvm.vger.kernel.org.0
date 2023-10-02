Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629FE7B5411
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 15:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237373AbjJBNaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 09:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236717AbjJBNaQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 09:30:16 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F402AD;
        Mon,  2 Oct 2023 06:30:12 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-9a58dbd5daeso2323745166b.2;
        Mon, 02 Oct 2023 06:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696253411; x=1696858211; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q8lMj7UsL/Ml50KMNpFYKOAmY39cvImv/aSmmjUAHj8=;
        b=fsHBrjmmr8V+2Cn4jh0hnaIZ6RVqbSbn8ld1nKB4fd72KDBztOllkZRiMBorriMJOr
         0NeHEYmoRGq6odKLps3XcqxMH65/uhSphgqO3eBxF212gLpph634ZH47Oczxobd0dmID
         q1NT9uhFZxUiPWH3NPbF+j8iTKud2SkjP+WXsiHVgr0FSdF13vH24RonWasZDA7UeyAg
         LQD29+r/wSP89ynnirB9nEoVQ8sYe0GzgOzDC5RZcOLdjo3CSVTzMkUdrGtxhQZn08ms
         X0qkoHf23BFP+CEwMKrkY8S0gF74aERjOuWURkBPvfdHRsOOrzxEkciNShdwoBVWXEbX
         5Rmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696253411; x=1696858211;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q8lMj7UsL/Ml50KMNpFYKOAmY39cvImv/aSmmjUAHj8=;
        b=YZXKZRmDZ1jzHtmS8z3THHTnpsWXfJIlSFGeg7wbQ2ngvTqiuzqECcPZDwxlUcGY3G
         zIT6nl86DzW2Z/zQ7Ig6yn0KNJ8u9dg6isFNK859RGAWsaSpMk0UvCZS+ZPvCal8vyW4
         IR7ElM6J88IOTxmMVYDrYP0pcRH9OL14WICwXWf8IJGY8rcDSAOXQArtetQV+VsOu+Fy
         3A8vH1lhZxR7ISBbsC5c2LtxaVcr2h1cwzJsHgdHbkzKZk0UMoMU9WyDajyf/YjIub89
         vNO7g6OcuDFuIAcjtsckzk0NpMGa+gyOFrn2TGtTzBPG6V3lvrv+8xmo3MV3iXK29kPX
         BzRg==
X-Gm-Message-State: AOJu0YwpGbDA99WGdzCNwEy3hzvtGKE6caPeuJUJUXa+Gsh3BWkGZJNH
        VA+ca6sEorNRuI2ZQO24FY8=
X-Google-Smtp-Source: AGHT+IE1iH0CKusjU61Wbpb/lh63BPpwJy5u9+b6RQsHxM8FLrHqhuy0m8IBSPfzycAvYWrGEi997A==
X-Received: by 2002:a17:906:58c6:b0:9b2:6ce3:bdf3 with SMTP id e6-20020a17090658c600b009b26ce3bdf3mr13024153ejs.54.1696253410572;
        Mon, 02 Oct 2023 06:30:10 -0700 (PDT)
Received: from gmail.com (1F2EF530.nat.pool.telekom.hu. [31.46.245.48])
        by smtp.gmail.com with ESMTPSA id ox12-20020a170907100c00b00988f168811bsm17030237ejb.135.2023.10.02.06.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 06:30:09 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Mon, 2 Oct 2023 15:30:07 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics
 event
Message-ID: <ZRrF38RGllA04R8o@gmail.com>
References: <20230927033124.1226509-1-dapeng1.mi@linux.intel.com>
 <20230927033124.1226509-8-dapeng1.mi@linux.intel.com>
 <20230927113312.GD21810@noisy.programming.kicks-ass.net>
 <ZRRl6y1GL-7RM63x@google.com>
 <20230929115344.GE6282@noisy.programming.kicks-ass.net>
 <ZRbxb15Opa2_AusF@google.com>
 <20231002115718.GB13957@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231002115718.GB13957@noisy.programming.kicks-ass.net>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, Sep 29, 2023 at 03:46:55PM +0000, Sean Christopherson wrote:
> 
> > > I will firmly reject anything that takes the PMU away from the host
> > > entirely through.
> > 
> > Why?  What is so wrong with supporting use cases where the platform owner *wants*
> > to give up host PMU and NMI watchdog functionality?  If disabling host PMU usage
> > were complex, highly invasive, and/or difficult to maintain, then I can understand
> > the pushback.  
> 
> Because it sucks.
> 
> You're forcing people to choose between no host PMU or a slow guest PMU.
> And that's simply not a sane choice for most people -- worse it's not a
> choice based in technical reality.
> 
> It's a choice out of lazyness, disabling host PMU is not a requirement
> for pass-through. 

Not just a choice of laziness, but it will clearly be forced upon users
by external entities:

   "Pass ownership of the PMU to the guest and have no host PMU, or you
    won't have sane guest PMU support at all. If you disagree, please open
    a support ticket, which we'll ignore."

The host OS shouldn't offer facilities that severely limit its own capabilities,
when there's a better solution. We don't give the FPU to apps exclusively either,
it would be insanely stupid for a platform to do that.

Thanks,

	Ingo
