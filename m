Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A2953A396
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 13:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352493AbiFALIP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 07:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352486AbiFALIM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 07:08:12 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA7387A1C;
        Wed,  1 Jun 2022 04:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=n2Sxt1LsbbmYzOd9zbBmcIleJm+O56cbx5JKEChxuKo=; b=P4ht6QkPLQI0A3+22aIZ/FRtmc
        wh+9jvIvULdQB2BOg4JxVu5zB788hW5qQI8OURFofkfDAcazQOhvb76dkvLop3Z0wCmMmuXi5Jkrq
        Oo0USUtCczKW4pszpzTr9/BUqfup8aEgN2ntlCkEtDapdFeA1+3SaGgzy+xQN1wL/PT5RXIIV92cK
        d5DXIVe69mkF5lIhTV9M62D7EPwzrvZusg5mdhe0cV/st6q+d58hjmzP7gJZg9/OJhS146c3Y7lX6
        zR6z5RODBZgauY9AJ7Jg/lU2HHYv3XelwFafSmuj6aNuTIZuh7OQhjhLBp7G77mCEZlPhbmzuhHxP
        cOoMbR2w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nwMCb-003krB-3i; Wed, 01 Jun 2022 11:07:49 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5687D98137D; Wed,  1 Jun 2022 13:07:46 +0200 (CEST)
Date:   Wed, 1 Jun 2022 13:07:46 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        Like Xu <likexu@tencent.com>
Subject: Re: [PATCH] x86: events: Do not return bogus capabilities if PMU is
 broken
Message-ID: <YpdIgm8c5YEFLCCH@worktop.programming.kicks-ass.net>
References: <20220601094256.362047-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601094256.362047-1-pbonzini@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 01, 2022 at 05:42:56AM -0400, Paolo Bonzini wrote:
> From: Like Xu <likexu@tencent.com>
> 
> If the PMU is broken due to firmware issues, check_hw_exists() will return
> false but perf_get_x86_pmu_capability() will still return data from x86_pmu.
> Likewise if some of the hotplug callbacks cannot be installed the contents
> of x86_pmu will not be reverted.
> 
> Handle the failure in both cases by clearing x86_pmu if init_hw_perf_events()
> or reverts to software events only.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

No SoB from Like,

> ---
>  arch/x86/events/core.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 99cf67d63cf3..d23f3821daf5 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -2095,14 +2095,15 @@ static int __init init_hw_perf_events(void)
>  	}
>  	if (err != 0) {
>  		pr_cont("no PMU driver, software events only.\n");
> -		return 0;
> +		err = 0;
> +		goto out_bad_pmu;
>  	}
>  
>  	pmu_check_apic();
>  
>  	/* sanity check that the hardware exists or is emulated */
>  	if (!check_hw_exists(&pmu, x86_pmu.num_counters, x86_pmu.num_counters_fixed))
> -		return 0;
> +		goto out_bad_pmu;
>  
>  	pr_cont("%s PMU driver.\n", x86_pmu.name);
>  
> @@ -2211,6 +2212,8 @@ static int __init init_hw_perf_events(void)
>  	cpuhp_remove_state(CPUHP_AP_PERF_X86_STARTING);
>  out:
>  	cpuhp_remove_state(CPUHP_PERF_X86_PREPARE);
> +out_bad_pmu:
> +	memset(&x86_pmu, 0, sizeof(x86_pmu));
>  	return err;
>  }
>  early_initcall(init_hw_perf_events);
> @@ -2982,6 +2985,11 @@ unsigned long perf_misc_flags(struct pt_regs *regs)
>  
>  void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
>  {
> +	if (!x86_pmu.name) {

We have x86_pmu_initialized(), the implementation is a bit daft, but
might as well use it here too, no?

> +		memset(cap, 0, sizeof(*cap));
> +		return;
> +	}
> +
>  	cap->version		= x86_pmu.version;
>  	/*
>  	 * KVM doesn't support the hybrid PMU yet.

Otherwise seems fine I suppose.
