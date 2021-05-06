Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61C5375661
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 17:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235036AbhEFPS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 11:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234888AbhEFPS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 11:18:57 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCE1C061761
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 08:17:57 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id q10so1078996qkc.5
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 08:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TnqymWt8DT7p/G3Ulxb2AlM+V3we7siDlvYQ85sUlP4=;
        b=T5Zs+/ZEWbNo/tIE2/cBZ1XPAqOn3QuSfuoVIoixc1phLbpeMaNVbXTUQtd/8pymk6
         a9ZQRn9LosPkR1SOAilSP7cNvxr+tfWYWUm2fuOXlGkFRqZjrzrQ4g2YjEhvW04D9tOE
         dWMEEUz+df8cce25S/MsAbfzW9GVuTbNU8RXoBrzdVIOXMT4IsCWBdCGB0FN2ihmBnSi
         5nnoOet1eVcc7PGExNbgSWZSo9CZ6ZjfnR+LnL6iM2p3vCueoUNXfhY9dVUYHlpE3lLp
         qAFnVvGX2hkGTfzeb+Dl2uCNk5aROr+aFC0nBKlGdp2TXDPEXn0/CHx2jcg+FREnv/j/
         5Dzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TnqymWt8DT7p/G3Ulxb2AlM+V3we7siDlvYQ85sUlP4=;
        b=qvepHy18tJeg+cTv8H7TStkAbDiby5dk+48FqR17F42kIv1WAvGlZhGWayV7gohZl/
         51t6ZmFpHX/FTi7F9WesVC9wwIV1O2Y4FXLw7B5asenOI7AsXA1L20VZ/6c1wLVaxsMe
         GfyzsZ+osgYVwhvcSm5aYnxafNIT0UTy91QQgiXKikxzVf8H+NrK2hm2GorB9YQ3bU4d
         Yhe9Yx17BaSOunZ0jziwsrlhafILYUnCzbD7zDuAjZBDJSNTiHMjkr7HOks9xxGmBmBG
         30/nAQ+HxFg/0J5VxZyqdkNaDUQ0Hy+hs+y5/WRVen8wr3SPbkNBJdFAp/ol85l3arUd
         Wt0w==
X-Gm-Message-State: AOAM5337ghx07W8hhRVsJ7TBLuOtVx2sP7fgploBiLIJLVK8SqvjJhrN
        ymEySUrGoV6NjcY5g6S+KP0doA==
X-Google-Smtp-Source: ABdhPJwaLJ6pZWp6/jCoVX1+5WZJhTT1qpGUrvvjeerJstNfEQCraV82M+xUumJh4eIQzkCfPQ/r+w==
X-Received: by 2002:a05:620a:381:: with SMTP id q1mr4746866qkm.243.1620314276515;
        Thu, 06 May 2021 08:17:56 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:4c4b])
        by smtp.gmail.com with ESMTPSA id a27sm2295146qtd.77.2021.05.06.08.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 08:17:55 -0700 (PDT)
Date:   Thu, 6 May 2021 11:17:54 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     tglx@linutronix.de, mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, bsingharora@gmail.com, pbonzini@redhat.com,
        maz@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        riel@surriel.com
Subject: Re: [PATCH 1/6] delayacct: Use sched_clock()
Message-ID: <YJQIopjVwzBjxg4n@cmpxchg.org>
References: <20210505105940.190490250@infradead.org>
 <20210505111525.001031466@infradead.org>
 <YJP2L1lUvUrur4pK@cmpxchg.org>
 <YJP6fWhwg95JZ1Kg@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJP6fWhwg95JZ1Kg@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 06, 2021 at 04:17:33PM +0200, Peter Zijlstra wrote:
> On Thu, May 06, 2021 at 09:59:11AM -0400, Johannes Weiner wrote:
> > On Wed, May 05, 2021 at 12:59:41PM +0200, Peter Zijlstra wrote:
> > > @@ -42,10 +42,9 @@ void __delayacct_tsk_init(struct task_st
> > >   * Finish delay accounting for a statistic using its timestamps (@start),
> > >   * accumalator (@total) and @count
> > >   */
> > > -static void delayacct_end(raw_spinlock_t *lock, u64 *start, u64 *total,
> > > -			  u32 *count)
> > > +static void delayacct_end(raw_spinlock_t *lock, u64 *start, u64 *total, u32 *count)
> > >  {
> > > -	s64 ns = ktime_get_ns() - *start;
> > > +	s64 ns = local_clock() - *start;
> > 
> > I don't think this is safe. These time sections that have preemption
> > and migration enabled and so might span multiple CPUs. local_clock()
> > could end up behind *start, AFAICS.
> 
> Only if you have really crummy hardware, and in that case the drift is
> bounded by around 1 tick. Also, this function actually checks: ns > 0.

Oh, I didn't realize it was that close. I just went off the dramatic
warnings on cpu_clock() :-) But yeah, that seems plenty accurate for
this purpose.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
