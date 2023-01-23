Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC19678A01
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 22:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbjAWVxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 16:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbjAWVxN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 16:53:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C7636479;
        Mon, 23 Jan 2023 13:53:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4FB061029;
        Mon, 23 Jan 2023 21:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F38C433EF;
        Mon, 23 Jan 2023 21:53:06 +0000 (UTC)
Date:   Mon, 23 Jan 2023 16:53:04 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     mingo@kernel.org, will@kernel.org, boqun.feng@gmail.com,
        mark.rutland@arm.com, tglx@linutronix.de, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, jgross@suse.com,
        srivatsa@csail.mit.edu, amakhalov@vmware.com,
        pv-drivers@vmware.com, mhiramat@kernel.org, wanpengli@tencent.com,
        vkuznets@redhat.com, boris.ostrovsky@oracle.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 3/6] ftrace/x86: Warn and ignore graph tracing when RCU
 is disabled
Message-ID: <20230123165304.370121e7@gandalf.local.home>
In-Reply-To: <20230123205515.059999893@infradead.org>
References: <20230123205009.790550642@infradead.org>
        <20230123205515.059999893@infradead.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 23 Jan 2023 21:50:12 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> All RCU disabled code should be noinstr and hence we should never get
> here -- when we do, WARN about it and make sure to not actually do
> tracing.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  arch/x86/kernel/ftrace.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -646,6 +646,9 @@ void prepare_ftrace_return(unsigned long
>  	if (unlikely(atomic_read(&current->tracing_graph_pause)))
>  		return;
>  
> +	if (WARN_ONCE(!rcu_is_watching(), "RCU not on for: %pS\n", (void *)ip))
> +		return;
> +

Please add this to after recursion trylock below. Although WARN_ONCE()
should not not have recursion issues, as function tracing can do weird
things, I rather be safe than sorry, and not have the system triple boot
due to some path that might get added in the future.

If rcu_is_watching() is false, it will still get by the below recursion
check and warn. That is, the below check should be done before this
function calls any other function.

>  	bit = ftrace_test_recursion_trylock(ip, *parent);
>  	if (bit < 0)
>  		return;
> 

-- Steve
