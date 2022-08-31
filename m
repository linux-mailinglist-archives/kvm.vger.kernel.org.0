Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C92925A7771
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 09:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiHaH1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 03:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiHaH1f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 03:27:35 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D40EBBA5C;
        Wed, 31 Aug 2022 00:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aSjQx4zTSl4T130c1oUVgBbdvM/iu6syC3U3W+yrRPU=; b=dv87PGod13q5vEEeHqEIl4GR1/
        j2Y7LzcWd949yj79i6GwRKUkTYtpL1tyeYQIG+xpLym/I4I98x/L5qz6uLCLjgUxpVPUUni83td7Y
        9QvGs67O6XbckmQb1nIPaUTwlMDYvDHapLda+Ksvp/NFuYvWrlo1TrjPn5XApak3dBnDzwHYW0s+w
        K6Z6iEqHPWuNE1XyZnVfxgHrOfgTadvSsAwuR48QBHBQheaw/Sars2zFpVjE/G8PGysKHb8TI+uSn
        WrkSQMi5Lyrr4SQfl1vpGPoCyptXXP+zyz1gTpgxlRhNo1AgT0u5H4+F5fdV8qZIpHRlX9lngU6tV
        7o0D2VpQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oTI7z-0085hl-W4; Wed, 31 Aug 2022 07:27:12 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 1002E3002CD;
        Wed, 31 Aug 2022 09:27:11 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E0F732B842EDD; Wed, 31 Aug 2022 09:27:10 +0200 (CEST)
Date:   Wed, 31 Aug 2022 09:27:10 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Kan Liang <kan.liang@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "'H . Peter Anvin'" <hpa@zytor.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] perf/x86/core: Completely disable guest PEBS via
 guest's global_ctrl
Message-ID: <Yw8NToJ5reQ+1rzt@hirez.programming.kicks-ass.net>
References: <20220831033524.58561-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831033524.58561-1-likexu@tencent.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 31, 2022 at 11:35:24AM +0800, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> When a guest PEBS counter is cross-mapped by a host counter, software
> will remove the corresponding bit in the arr[global_ctrl].guest and
> expect hardware to perform a change of state "from enable to disable"
> via the msr_slot[] switch during the vmx transaction.
> 
> The real world is that if user adjust the counter overflow value small
> enough, it still opens a tiny race window for the previously PEBS-enabled
> counter to write cross-mapped PEBS records into the guest's PEBS buffer,
> when arr[global_ctrl].guest has been prioritised (switch_msr_special stuff)
> to switch into the enabled state, while the arr[pebs_enable].guest has not.
> 
> Close this window by clearing invalid bits in the arr[global_ctrl].guest.
> 
> Cc: linux-perf-users@vger.kernel.org
> Cc: Kan Liang <kan.liang@linux.intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Sean Christopherson <seanjc@google.com>
> Fixes: 854250329c02 ("KVM: x86/pmu: Disable guest PEBS temporarily in two rare situations")
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---

Thanks!
