Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F4C7CEC91
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 02:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjJSAGh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 20:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjJSAGg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 20:06:36 -0400
Received: from out-203.mta1.migadu.com (out-203.mta1.migadu.com [IPv6:2001:41d0:203:375::cb])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586EA106
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 17:06:34 -0700 (PDT)
Date:   Thu, 19 Oct 2023 00:06:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697673992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hzjaIWah6RYMVBvI14tFSfFydhLBL9+gD67Q8Qa+q8o=;
        b=Mu1Ho+y3nPc2gCgNmE0x7g0+OC562KEeI3AkiOGEZgX2KWfHvGXyjVxRRNFtLT8RQB587x
        4Z0HeLG3XVWB+f7VAvsy6IORv+ddsOuWlZoCfM4CQc7kVcQ1ytzyuqnVS21I/H/wBru5oY
        LAAnco/ohZrd5G4pFILAwv7pMXd83bQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Eric Auger <eauger@redhat.com>
Cc:     Mark Brown <broonie@kernel.org>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org,
        Jing Zhang <jingzhangos@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 4/5] tools headers arm64: Update sysreg.h with kernel
 sources
Message-ID: <ZTBzAR1KsWuurob7@linux.dev>
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-5-oliver.upton@linux.dev>
 <73b94274-4561-1edd-6b1e-8c6245133af2@redhat.com>
 <3c5332b0-9035-4cb8-96ce-7a9b8d513c3a@sirena.org.uk>
 <8baca35a-9154-97e6-d682-032fc69d2da6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8baca35a-9154-97e6-d682-032fc69d2da6@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

Thanks for reviewing the series.

On Wed, Oct 18, 2023 at 03:06:12PM +0200, Eric Auger wrote:
> Hi Mark, Oliver,
> 
> On 10/18/23 14:16, Mark Brown wrote:
> > On Wed, Oct 18, 2023 at 01:57:31PM +0200, Eric Auger wrote:
> >> On 10/11/23 21:57, Oliver Upton wrote:
> > 
> >>>  #define set_pstate_pan(x)		asm volatile(SET_PSTATE_PAN(x))
> >>>  #define set_pstate_uao(x)		asm volatile(SET_PSTATE_UAO(x))
> >>>  #define set_pstate_ssbs(x)		asm volatile(SET_PSTATE_SSBS(x))
> >>> +#define set_pstate_dit(x)		asm volatile(SET_PSTATE_DIT(x))
> > 
> >> could you comment on the *DIT* addictions, what is it for?
> > 
> > DIT is data independent timing, this tells the processor to ensure that
> > instructions take a constant time regardless of the data they are
> > handling.
> 
> > 
> > Note that this file is just a copy of arch/arm64/include/asm/gpr-num.h,
> > the main purpose here is to sync with the original.
> 
> Ah thanks. that's helpful for me to understand where this gpr-num.h
> comes from. This could be documented in the commit msg though.
> 
> Something like:
> 
> adding tools/arch/arm64/include/asm/gpr-num.h matching linux
> arch/arm64/include/asm/gpr-num.h
> 
> and syncing tools/arch/arm64/include/asm/sysreg.h with the fellow header
> in the linux tree.

Yeah, I could've spelled it out a bit more. I already cracked this off
of an even larger patch from before I picked up the series because the
diff was massive.

> tbh I did not initially understand that all this diffstat was aimed to
> match the linux arch/arm64/include/asm/sysreg.h. Now diffing both I have
> some diffs. Doesn't it need a refresh?

I'm worried it is a fool's errand at this point to keep the two in sync,
as I'm sure there will be more in -rc1. The tools copy of sysreg.h isn't
a verbatim copy either, there are some deliberate deletions in there as
well.

I've taken this as is, we can always come back and update the headers
afterwards if we find a need for it

-- 
Thanks,
Oliver
