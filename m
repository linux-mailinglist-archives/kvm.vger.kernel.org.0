Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891A76545AB
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 18:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiLVRlc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 12:41:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiLVRlb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 12:41:31 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2851922BF8
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 09:41:30 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id v23so2609407pju.3
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 09:41:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5K5LcgUGB4vNRNhgJoxHXF27hVKDF9DsAb1wrPlGN3k=;
        b=gsNby3EI8poWb5e16yXKuRL8tiuBogzWM6InrQO+cMr2vpBcF/towzJmrhHOxWeu9n
         moAj7IdVn+O7uTMowqIESHaiUs6scJ4iOwm7U2YZ6t1OLJcfhHLb7Ab4FQWROKjKG8oJ
         tCmWqix8+zp+eYwJBi+3d944zSWSev5pvwWsOFb9uh5o0QWuZopPfPpVzgtcYTURZvL5
         O+41X72nkUKULefWnxEZu6MKb+lnCMbY6THjBS3JA5+BiGaV+GWVOay8sn09gV8yrOn0
         G15l7iuzOPmcEcpM0Dj8dzt/rmx5703l+1USjMmArNfbu/XHYTSaem7v0Qi/ScVHZ6c1
         lkYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5K5LcgUGB4vNRNhgJoxHXF27hVKDF9DsAb1wrPlGN3k=;
        b=Ok9IbG6NdGeUeJCcMMXL0VIop0/EYXg0Onh8AUzrppBgzK8PtPln8xNSR/S4MzelT0
         jJSob83mLd3U4cHpInTwQwEOJc36131PB7M+PfwD0s256BAUxrTz7HYRnk4CBgTWV9zz
         sdRh+UCKgpASWOt3YJd9Qkx/7bWauI46jBP34mKVBrU3Pty7Em5QEglTYy/esQ4GQOxK
         HjTAWgkOrosxa0F6Jk+QF3JNavCTen//YdC3cwL2BsPCeUt9KFgdsyUgg65Tdbc3WsGf
         iYEpVkTU3vh33lYCQzWAKSQaU/2AF6Ejs5C0e/3FyJSoAucOKILqbfjVW3Ko30duwiAg
         V0pQ==
X-Gm-Message-State: AFqh2kqBzG5yGXQMKgfd6r6FkEgg25rQ5WF275RcQfn/xo/YIcCxYeRu
        LTRS+hnqPWi5nNgrqwKv92/nWg==
X-Google-Smtp-Source: AMrXdXu2yf9jn987y5mRMpYyKcp9Kx/63wMFiMCBUw99QfWgOJZlwCZ3dK5i71tYb6glrdauqu/WHA==
X-Received: by 2002:a05:6a20:5488:b0:a3:d7b0:aeef with SMTP id i8-20020a056a20548800b000a3d7b0aeefmr1386282pzk.0.1671730889523;
        Thu, 22 Dec 2022 09:41:29 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id mm2-20020a17090b358200b0021937b2118bsm3465146pjb.54.2022.12.22.09.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 09:41:28 -0800 (PST)
Date:   Thu, 22 Dec 2022 17:41:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, Like Xu <like.xu@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: Re: [PATCH v2 01/15] perf/x86/lbr: Simplify the exposure check for
 the LBR_INFO registers
Message-ID: <Y6SWxEZrIqDPD69l@google.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-2-weijiang.yang@intel.com>
 <449b561a-7053-8994-bcfe-581c0abb8d85@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <449b561a-7053-8994-bcfe-581c0abb8d85@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 22, 2022, Like Xu wrote:
> Hi Peter, would you help apply this one in your tip/perf tree,
> as it doesn't seem to be closely tied to the KVM changes. Thanks.
> 
> On 25/11/2022 12:05 pm, Yang Weijiang wrote:
> > From: Like Xu <like.xu@linux.intel.com>
> > 
> > The x86_pmu.lbr_info is 0 unless explicitly initialized, so there's
> > no point checking x86_pmu.intel_cap.lbr_format.
> > 
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
> > Reviewed-by: Andi Kleen <ak@linux.intel.com>
> > Signed-off-by: Like Xu <like.xu@linux.intel.com>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> >   arch/x86/events/intel/lbr.c | 4 +---
> >   1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
> > index 4dbde69c423b..e7caabfa1377 100644
> > --- a/arch/x86/events/intel/lbr.c
> > +++ b/arch/x86/events/intel/lbr.c
> > @@ -1606,12 +1606,10 @@ void __init intel_pmu_arch_lbr_init(void)
> >    */
> >   void x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
> >   {
> > -	int lbr_fmt = x86_pmu.intel_cap.lbr_format;
> > -
> >   	lbr->nr = x86_pmu.lbr_nr;
> >   	lbr->from = x86_pmu.lbr_from;
> >   	lbr->to = x86_pmu.lbr_to;
> > -	lbr->info = (lbr_fmt == LBR_FORMAT_INFO) ? x86_pmu.lbr_info : 0;
> > +	lbr->info = x86_pmu.lbr_info;

This stable-worthy a bug fix, no?  E.g. won't the existing code misreport lbr->info
if the format is LBR_FORMAT_INFO2?

> >   }
> >   EXPORT_SYMBOL_GPL(x86_perf_get_lbr);
