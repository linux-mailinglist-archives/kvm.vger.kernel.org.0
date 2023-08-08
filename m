Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF511773F19
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 18:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbjHHQnT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 12:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjHHQm3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 12:42:29 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697C2559E;
        Tue,  8 Aug 2023 08:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rbJ3h3QmDJ6bpkUM4uMIuNPfbpSJD00kJV0NklJSmiA=; b=Fd8tgqsBPUOBIihzsg07e7aPVT
        mtAkvOyckQcpeet43iN8RS/Sm5K1j5GAM2ZXhRnNuDwgaqhsqUsTSVfPgioMMSQZ/QX5cQpz+0ObS
        cRvUq/mlXJyq9oqLxr666lHtgE2msZUZGku8cN1j6iYkLKpUsX5l8uNvqCXMnW3yGg4o2p974Dg9m
        MFcyxvNdBhiP0zx7762aynGeWFl8pFlVlHTa48JbUPsKpR4bH1bt+zSq0eWKOL6YLQ3+5P7q8yWa2
        lj5JhaA30KW8fEYxsR1+FP0BWgh74Vx8k1bYu/PfZY/asnuiyaMFeP1nbDcOM3WfYt99FXxTCr1aQ
        t2JPNPIA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qTJqD-004iKP-0C;
        Tue, 08 Aug 2023 10:21:29 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 21E5030026C;
        Tue,  8 Aug 2023 12:21:27 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D791C203D48A1; Tue,  8 Aug 2023 12:21:27 +0200 (CEST)
Date:   Tue, 8 Aug 2023 12:21:27 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
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
        Dapeng Mi <dapeng1.mi@intel.com>, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH RFV v2 05/13] perf/core: Add function
 perf_event_create_group_kernel_counters()
Message-ID: <20230808102127.GZ212435@hirez.programming.kicks-ass.net>
References: <20230808063111.1870070-1-dapeng1.mi@linux.intel.com>
 <20230808063111.1870070-6-dapeng1.mi@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230808063111.1870070-6-dapeng1.mi@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 08, 2023 at 02:31:03PM +0800, Dapeng Mi wrote:
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 15eb82d1a010..1877171e9590 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -12762,11 +12762,34 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
>  				 struct task_struct *task,
>  				 perf_overflow_handler_t overflow_handler,
>  				 void *context)
> +{
> +	return perf_event_create_group_kernel_counters(attr, cpu, task,
> +			NULL, overflow_handler, context);
> +}
> +EXPORT_SYMBOL_GPL(perf_event_create_kernel_counter);
> +
> +/**
> + * perf_event_create_group_kernel_counters
> + *
> + * @attr: attributes of the counter to create
> + * @cpu: cpu in which the counter is bound
> + * @task: task to profile (NULL for percpu)
> + * @group_leader: the group leader event of the created event
> + * @overflow_handler: callback to trigger when we hit the event
> + * @context: context data could be used in overflow_handler callback
> + */
> +struct perf_event *
> +perf_event_create_group_kernel_counters(struct perf_event_attr *attr,
> +					int cpu, struct task_struct *task,
> +					struct perf_event *group_leader,
> +					perf_overflow_handler_t overflow_handler,
> +					void *context)

I would much prefer if you just add the argument to
perf_event_create_kernel_counter(), there aren't *that* many users.
