Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5961C4D019E
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 15:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243333AbiCGOna (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 09:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239324AbiCGOn2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 09:43:28 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D8A10FF;
        Mon,  7 Mar 2022 06:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dAZkd94tzcRdvRieKkWfcBkJvTkJnK9zBdITPJgPy6s=; b=mO9oSmUesbbSZM3vVK9HyTDYQq
        cK133canotMxKAZ16MzaSlEApH4hnCI5CtCI6hsR7A6tEwzzsv4IUQX/bl6HD1kjRWY8887uvn+2T
        6NUL7IIKV2it7/I+weTmFjEISS2i+GL1jllaCYFkdDROh+x3SM/j3u7m+tqv/+FnetomUX4A/TD5d
        RZonGU9B6SYDqGlYKFlkw77GZX99AJNEzK3XSLH0Io9vhxjZ8fdzQtQuh9Zf2X+C0UPRfn1u5d6WU
        xjS+BbZau/KIePTW8IudpNYy23HvK5oMyvndoV6Ov7JQBcwckuExbphCZQ6DwAiYLY67gF7wrnebe
        NbU6hTmw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nREYr-00FIlv-LY; Mon, 07 Mar 2022 14:42:09 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 462BC300169;
        Mon,  7 Mar 2022 15:42:07 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 30A5B203C59BB; Mon,  7 Mar 2022 15:42:07 +0100 (CET)
Date:   Mon, 7 Mar 2022 15:42:07 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, H Peter Anvin <hpa@zytor.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Leo Yan <leo.yan@linaro.org>, jgross@suse.com,
        sdeep@vmware.com, pv-drivers@vmware.com, pbonzini@redhat.com,
        seanjc@google.com, kys@microsoft.com, sthemmin@microsoft.com,
        virtualization@lists.linux-foundation.org,
        Andrew.Cooper3@citrix.com, christopher.s.hall@intel.com
Subject: Re: [PATCH V2 03/11] perf/x86: Add support for TSC in nanoseconds as
 a perf event clock
Message-ID: <YiYZv+LOmjzi5wcm@hirez.programming.kicks-ass.net>
References: <20220214110914.268126-1-adrian.hunter@intel.com>
 <20220214110914.268126-4-adrian.hunter@intel.com>
 <YiIXFmA4vpcTSk2L@hirez.programming.kicks-ass.net>
 <853ce127-25f0-d0fe-1d8f-0b0dd4f3ce71@intel.com>
 <YiXVgEk/1UClkygX@hirez.programming.kicks-ass.net>
 <30383f92-59cb-2875-1e1b-ff1a0eacd235@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30383f92-59cb-2875-1e1b-ff1a0eacd235@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 07, 2022 at 02:36:03PM +0200, Adrian Hunter wrote:

> > diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
> > index 4420499f7bb4..a1f179ed39bf 100644
> > --- a/arch/x86/kernel/paravirt.c
> > +++ b/arch/x86/kernel/paravirt.c
> > @@ -145,6 +145,15 @@ DEFINE_STATIC_CALL(pv_sched_clock, native_sched_clock);
> >  
> >  void paravirt_set_sched_clock(u64 (*func)(void))
> >  {
> > +	/*
> > +	 * Anything with ART on promises to have sane TSC, otherwise the whole
> > +	 * ART thing is useless. In order to make ART useful for guests, we
> > +	 * should continue to use the TSC. As such, ignore any paravirt
> > +	 * muckery.
> > +	 */
> > +	if (cpu_feature_enabled(X86_FEATURE_ART))
> 
> Does not seem to work because the feature X86_FEATURE_ART does not seem to get set.
> Possibly because detect_art() excludes anything running on a hypervisor.

Simple enough to delete that clause I suppose. Christopher, what is
needed to make that go away? I suppose the guest needs to be aware of
the active TSC scaling parameters to make it work ?
