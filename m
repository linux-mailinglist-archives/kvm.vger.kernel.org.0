Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556206802EF
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 00:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235011AbjA2XX2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Jan 2023 18:23:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjA2XX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Jan 2023 18:23:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D18193D8;
        Sun, 29 Jan 2023 15:23:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83D5360E8B;
        Sun, 29 Jan 2023 23:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03E9C4339B;
        Sun, 29 Jan 2023 23:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675034602;
        bh=ar04I+00ao3WPJgj7vlz995rVBYaif9cYaRh5qPyTXE=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=aTe0TtglGldzJzZNr/0s6eLZQS7IuRyZViRn8cjX7XP00sIrXEdJnzQAcGiMb3gCU
         dEOwAJ35nCTES/ZPUUghHysGdz/grZz9ZkZRLib89z4xTUXOc4WhfuMgZPbMIHlsSC
         Uj5ZR6IXr8VK4sN7XXqzCELysPlKXHnYyk4pxapN6uuVlzWp2HtrE7k+RRC0hZkSx8
         C+bbamOzo/nYwQvBVYKpRbyECGClcRjvRGZRV+xw6OAbr8XLyjWDX3rhWA+tfhwJvz
         DplJt5zUTLLeSAgzAUZ2ra/rxF+/3Hv+EwmE34szVq2bCCCQL2r8jXgBG8XUMtrrsa
         Dcjqc/a1gZPnw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 7C0785C08B3; Sun, 29 Jan 2023 15:23:22 -0800 (PST)
Date:   Sun, 29 Jan 2023 15:23:22 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     mingo@kernel.org, will@kernel.org, boqun.feng@gmail.com,
        mark.rutland@arm.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
        jgross@suse.com, srivatsa@csail.mit.edu, amakhalov@vmware.com,
        pv-drivers@vmware.com, wanpengli@tencent.com, vkuznets@redhat.com,
        boris.ostrovsky@oracle.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, lpieralisi@kernel.org,
        frederic@kernel.org, rostedt@goodmis.org, mhiramat@kernel.org,
        longman@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-pm@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] A few more cpuidle vs rcu fixes
Message-ID: <20230129232322.GM2948950@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230126150829.087606759@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126150829.087606759@infradead.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 26, 2023 at 04:08:29PM +0100, Peter Zijlstra wrote:
> 0-day robot reported graph-tracing made the cpuidle-vs-rcu rework go splat.
> 
> These patches appear to cure this, the ftrace selftest now runs to completion
> without spamming scary messages to dmesg.
> 
> Since v1:
> 
>  - fixed recursive RCU splats
>  - fixed psci thingies for arm (null)
>  - improved the tracing WARN (rostedt)
>  - fixed TRACE_PREEMPT_TOGGLE (null)
> 
> ---

Applying this gets me the name objtool warnings noted before, but only
on KASAN kernels.  Other than that, works fine as far as rcutorture
is concerned.

							Thanx, Paul
