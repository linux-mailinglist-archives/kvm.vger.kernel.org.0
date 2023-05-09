Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13F506FCE33
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 21:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234360AbjEITDs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 15:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234743AbjEITDl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 15:03:41 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA7C4494;
        Tue,  9 May 2023 12:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=TSBh9Kcc3KUBCL5aBYO64M6mJ0lqBshLkhyf/of1TC0=; b=FCW62nSzYz/ok7iHxNvcDpG+dG
        p6YklNcqU1xc1R5gABl7j+pzt4edhSw9O4ekmaa3xTKe85WxJ7j//bk1Hq0aCLl67UaBbwwxCCHk/
        nBmP1Oh1U922UgmktErEM43hSE3cxvXYb9NGz9UhnoYMvGUoSgjnPgFVXoSKId4RFqoRyo4NHPoij
        bcScWKk9g+9EmYD6JUcbQy52qy2HwBwNUmDY8rkGLXv4ab46T6LJkJ9XmnxOAcFAsQwz8NgGbcGaF
        KscqydThd0TZMh7kkUKJjl966pJSmroQfUfcyEtrdVazmY6otdbItrWnRiZGbTqn4ostdQpRvv49n
        n+gHUO8Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pwSbb-006EfJ-1j;
        Tue, 09 May 2023 19:02:38 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id EA809300451;
        Tue,  9 May 2023 21:02:31 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id CC6D620F0E418; Tue,  9 May 2023 21:02:31 +0200 (CEST)
Date:   Tue, 9 May 2023 21:02:31 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     bigeasy@linutronix.de, mark.rutland@arm.com, maz@kernel.org,
        catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
        kernel@xen0n.name, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, pbonzini@redhat.com, wanpengli@tencent.com,
        vkuznets@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, jgross@suse.com, boris.ostrovsky@oracle.com,
        daniel.lezcano@linaro.org, kys@microsoft.com,
        haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        longman@redhat.com, boqun.feng@gmail.com, pmladek@suse.com,
        senozhatsky@chromium.org, rostedt@goodmis.org,
        john.ogness@linutronix.de, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, jstultz@google.com, sboyd@kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [RFC][PATCH 9/9] cpuidle: Use local_clock_noinstr()
Message-ID: <20230509190231.GA2148518@hirez.programming.kicks-ass.net>
References: <20230508211951.901961964@infradead.org>
 <20230508213147.990013706@infradead.org>
 <CAJZ5v0jc29fSGFzN2Yeb+xRQZ9Y0V2_Ge17YnsEG5Um9OV25uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJZ5v0jc29fSGFzN2Yeb+xRQZ9Y0V2_Ge17YnsEG5Um9OV25uw@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 09, 2023 at 06:18:08PM +0200, Rafael J. Wysocki wrote:
> On Mon, May 8, 2023 at 11:34 PM Peter Zijlstra <peterz@infradead.org> wrote:
> > --- a/drivers/cpuidle/poll_state.c
> > +++ b/drivers/cpuidle/poll_state.c
> > @@ -15,7 +15,7 @@ static int __cpuidle poll_idle(struct cp
> >  {
> >         u64 time_start;
> >
> > -       time_start = local_clock();
> > +       time_start = local_clock_noinstr();
> >
> >         dev->poll_time_limit = false;
> >
> > @@ -32,7 +32,7 @@ static int __cpuidle poll_idle(struct cp
> >                                 continue;
> >
> >                         loop_count = 0;
> > -                       if (local_clock() - time_start > limit) {
> > +                       if (local_clock_noinstr() - time_start > limit) {
> >                                 dev->poll_time_limit = true;
> >                                 break;
> >                         }
> >
> 
> The above LGTM, but the teo governors uses local_clock() too.  Should
> it use the _noinstr() version?

Only the callsites from noinstr or __cpuidle functions, IIRC the
governors are neither and should be OK.
