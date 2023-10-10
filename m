Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5832A7C014F
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 18:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbjJJQNH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 12:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjJJQNG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 12:13:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E219497
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 09:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696954338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tSjnvG5NwalIEjKIQtTbuCFGAtOMZwRcBRSi/1kopbk=;
        b=GktVgk+QQMYmjPJu+DhTaJxtN9m9VYEauZfm+CThW1u8527tp+YoHtY9v3amG5GdUCls0L
        0vz57n5uxFMIoTkBhVGqHs+mJOeWG/vSd4/WR1yr3giY3E1PsgRRVEOL3eQfuReVnfnOmz
        0cc063yijVn0bwdrNSauGRUf7+D3CqU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-p4LOtSYCMdS6IG_6dofptA-1; Tue, 10 Oct 2023 12:12:16 -0400
X-MC-Unique: p4LOtSYCMdS6IG_6dofptA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-32339eee4c4so4201769f8f.3
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 09:12:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696954334; x=1697559134;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tSjnvG5NwalIEjKIQtTbuCFGAtOMZwRcBRSi/1kopbk=;
        b=fVjbdh1QYj9A4o59gG0cYGWFAfLj7nfP5hIZU9yAbPPCSQw2uC1S0Nb9d2wFImzaz2
         kxUtVOX7Dn9eUbTT1M277RBH+67jhgC81bkyBtTj3hyZOwYe/R0b1YDQckimYn+g5ubY
         9kjP2ntCz6THlP6dyYGIK+Sw5Ro9WGXF8QW8JSlKwGLOXqzb5CQlqAXfXCILaqzqMTtW
         IvnBdiV1TRewSWBp4Q+gtwU7TBgHq8Vr0XYr7s8datTDdFnovrnSKnFehBmwyVrKikRK
         G3qqwKjkxiW8YMNB1mq0u9P9XFfzG4sD90WFbQSRTF/7hGapPLswsUDXCG93W2A6xFJl
         8M1Q==
X-Gm-Message-State: AOJu0YyMFKB/YLnYRJ+Jbkm49uIGzgY4v7vZrFqcLiVhMbTcoDi3rqIj
        lQsihuhJwTHg0XeXb5U1qpa8szNWvUV0Pu6zIEK836QU7I/tytX7nhySVrpyfS7obit0Gpfgsku
        918aeMkQniCGq
X-Received: by 2002:a05:6000:cb:b0:321:7050:6fb6 with SMTP id q11-20020a05600000cb00b0032170506fb6mr14952073wrx.67.1696954334574;
        Tue, 10 Oct 2023 09:12:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHiVZprh6ZRHMJLcnBs1Xd6l1wpOAVgISEZ4kCScvw7gLyV/CxwFTkly37MyRE2XBOpVqncfw==
X-Received: by 2002:a05:6000:cb:b0:321:7050:6fb6 with SMTP id q11-20020a05600000cb00b0032170506fb6mr14952042wrx.67.1696954334151;
        Tue, 10 Oct 2023 09:12:14 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id j16-20020adff010000000b0032008f99216sm13043941wro.96.2023.10.10.09.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 09:12:13 -0700 (PDT)
Message-ID: <ce964b43f926708f30c85640591b2fc62397b719.camel@redhat.com>
Subject: Re: [PATCH v2 4/5] perf kvm: Support sampling guest callchains
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Tianyi Liu <i.pear@outlook.com>, seanjc@google.com,
        pbonzini@redhat.com, peterz@infradead.org, mingo@redhat.com,
        acme@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        namhyung@kernel.org, irogers@google.com, adrian.hunter@intel.com
Date:   Tue, 10 Oct 2023 19:12:11 +0300
In-Reply-To: <SY4P282MB108433024762F1F292D47C2A9DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
References: <SY4P282MB1084ECBCC1B176153B9E2A009DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
         <SY4P282MB108433024762F1F292D47C2A9DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У нд, 2023-10-08 у 22:57 +0800, Tianyi Liu пише:
> This patch provides support for sampling guests' callchains.
> 
> The signature of `get_perf_callchain` has been modified to explicitly
> specify whether it needs to sample the host or guest callchain.
> Based on the context, it will distribute the sampling request to one of
> `perf_callchain_user`, `perf_callchain_kernel`, or `perf_callchain_guest`.
> 
> The reason for separately implementing `perf_callchain_user` and
> `perf_callchain_kernel` is that the kernel may utilize special unwinders
> such as `ORC`. However, for the guest, we only support stackframe-based
> unwinding, so the implementation is generic and only needs to be
> separately implemented for 32-bit and 64-bit.
> 
> Signed-off-by: Tianyi Liu <i.pear@outlook.com>
> ---
>  arch/x86/events/core.c     | 56 +++++++++++++++++++++++++++++++-------
>  include/linux/perf_event.h |  3 +-
>  kernel/bpf/stackmap.c      |  8 +++---
>  kernel/events/callchain.c  | 27 +++++++++++++++++-
>  kernel/events/core.c       |  7 ++++-
>  5 files changed, 84 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 185f902e5..ea4c86175 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -2758,11 +2758,6 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
>  	struct unwind_state state;
>  	unsigned long addr;
>  
> -	if (perf_guest_state()) {
> -		/* TODO: We don't support guest os callchain now */
> -		return;
> -	}
> -
>  	if (perf_callchain_store(entry, regs->ip))
>  		return;
>  
> @@ -2778,6 +2773,52 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
>  	}
>  }
>  
> +static inline void
> +perf_callchain_guest32(struct perf_callchain_entry_ctx *entry)
> +{
> +	struct stack_frame_ia32 frame;
> +	const struct stack_frame_ia32 *fp;
> +
> +	fp = (void *)perf_guest_get_frame_pointer();
> +	while (fp && entry->nr < entry->max_stack) {
> +		if (!perf_guest_read_virt(&fp->next_frame, &frame.next_frame,
This should be fp->next_frame.
> +			sizeof(frame.next_frame)))
> +			break;
> +		if (!perf_guest_read_virt(&fp->return_address, &frame.return_address,
Same here.
> +			sizeof(frame.return_address)))
> +			break;
> +		perf_callchain_store(entry, frame.return_address);
> +		fp = (void *)frame.next_frame;
> +	}
> +}
> +
> +void
> +perf_callchain_guest(struct perf_callchain_entry_ctx *entry)
> +{
> +	struct stack_frame frame;
> +	const struct stack_frame *fp;
> +	unsigned int guest_state;
> +
> +	guest_state = perf_guest_state();
> +	perf_callchain_store(entry, perf_guest_get_ip());
> +
> +	if (guest_state & PERF_GUEST_64BIT) {
> +		fp = (void *)perf_guest_get_frame_pointer();
> +		while (fp && entry->nr < entry->max_stack) {
> +			if (!perf_guest_read_virt(&fp->next_frame, &frame.next_frame,
Same here.
> +				sizeof(frame.next_frame)))
> +				break;
> +			if (!perf_guest_read_virt(&fp->return_address, &frame.return_address,
And here.

> +				sizeof(frame.return_address)))
> +				break;
> +			perf_callchain_store(entry, frame.return_address);
> +			fp = (void *)frame.next_frame;
> +		}
> +	} else {
> +		perf_callchain_guest32(entry);
> +	}
> +}

For symmetry, maybe it makes sense to have perf_callchain_guest32 and perf_callchain_guest64
and then make perf_callchain_guest call each? No strong opinion on this of course.


> +
>  static inline int
>  valid_user_frame(const void __user *fp, unsigned long size)
>  {
> @@ -2861,11 +2902,6 @@ perf_callchain_user(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs
>  	struct stack_frame frame;
>  	const struct stack_frame __user *fp;
>  
> -	if (perf_guest_state()) {
> -		/* TODO: We don't support guest os callchain now */
> -		return;
> -	}
> -
>  	/*
>  	 * We don't know what to do with VM86 stacks.. ignore them for now.
>  	 */
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index d0f937a62..a2baf4856 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -1545,9 +1545,10 @@ DECLARE_PER_CPU(struct perf_callchain_entry, perf_callchain_entry);
>  
>  extern void perf_callchain_user(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs);
>  extern void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs);
> +extern void perf_callchain_guest(struct perf_callchain_entry_ctx *entry);
>  extern struct perf_callchain_entry *
>  get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
> -		   u32 max_stack, bool crosstask, bool add_mark);
> +		   bool host, bool guest, u32 max_stack, bool crosstask, bool add_mark);
>  extern int get_callchain_buffers(int max_stack);
>  extern void put_callchain_buffers(void);
>  extern struct perf_callchain_entry *get_callchain_entry(int *rctx);
> diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
> index 458bb80b1..2e88d4639 100644
> --- a/kernel/bpf/stackmap.c
> +++ b/kernel/bpf/stackmap.c
> @@ -294,8 +294,8 @@ BPF_CALL_3(bpf_get_stackid, struct pt_regs *, regs, struct bpf_map *, map,
>  	if (max_depth > sysctl_perf_event_max_stack)
>  		max_depth = sysctl_perf_event_max_stack;
>  
> -	trace = get_perf_callchain(regs, 0, kernel, user, max_depth,
> -				   false, false);
> +	trace = get_perf_callchain(regs, 0, kernel, user, true, false,
> +				   max_depth, false, false);
>  
>  	if (unlikely(!trace))
>  		/* couldn't fetch the stack trace */
> @@ -420,8 +420,8 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
>  	else if (kernel && task)
>  		trace = get_callchain_entry_for_task(task, max_depth);
>  	else
> -		trace = get_perf_callchain(regs, 0, kernel, user, max_depth,
> -					   false, false);
> +		trace = get_perf_callchain(regs, 0, kernel, user, true, false,
> +					   max_depth, false, false);
>  	if (unlikely(!trace))
>  		goto err_fault;
>  
> diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
> index 1273be843..7e80729e9 100644
> --- a/kernel/events/callchain.c
> +++ b/kernel/events/callchain.c
> @@ -45,6 +45,10 @@ __weak void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
>  {
>  }
>  
> +__weak void perf_callchain_guest(struct perf_callchain_entry_ctx *entry)
> +{
> +}
> +
>  static void release_callchain_buffers_rcu(struct rcu_head *head)
>  {
>  	struct callchain_cpus_entries *entries;
> @@ -178,11 +182,12 @@ put_callchain_entry(int rctx)
>  
>  struct perf_callchain_entry *
>  get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
> -		   u32 max_stack, bool crosstask, bool add_mark)
> +		   bool host, bool guest, u32 max_stack, bool crosstask, bool add_mark)
>  {
>  	struct perf_callchain_entry *entry;
>  	struct perf_callchain_entry_ctx ctx;
>  	int rctx;
> +	unsigned int guest_state;
>  
>  	entry = get_callchain_entry(&rctx);
>  	if (!entry)
> @@ -194,6 +199,26 @@ get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
>  	ctx.contexts       = 0;
>  	ctx.contexts_maxed = false;
>  
> +	guest_state = perf_guest_state();
> +	if (guest_state) {
> +		if (!guest)
> +			goto exit_put;
> +		if (user && (guest_state & PERF_GUEST_USER)) {
> +			if (add_mark)
> +				perf_callchain_store_context(&ctx, PERF_CONTEXT_GUEST_USER);
> +			perf_callchain_guest(&ctx);
> +		}
> +		if (kernel && !(guest_state & PERF_GUEST_USER)) {
> +			if (add_mark)
> +				perf_callchain_store_context(&ctx, PERF_CONTEXT_GUEST_KERNEL);
> +			perf_callchain_guest(&ctx);
> +		}
> +		goto exit_put;
> +	}
> +
> +	if (unlikely(!host))
> +		goto exit_put;
> +
>  	if (kernel && !user_mode(regs)) {
>  		if (add_mark)
>  			perf_callchain_store_context(&ctx, PERF_CONTEXT_KERNEL);
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index eaba00ec2..b3401f403 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -7559,6 +7559,8 @@ perf_callchain(struct perf_event *event, struct pt_regs *regs)
>  {
>  	bool kernel = !event->attr.exclude_callchain_kernel;
>  	bool user   = !event->attr.exclude_callchain_user;
> +	bool host   = !event->attr.exclude_host;
> +	bool guest  = !event->attr.exclude_guest;
>  	/* Disallow cross-task user callchains. */
>  	bool crosstask = event->ctx->task && event->ctx->task != current;
>  	const u32 max_stack = event->attr.sample_max_stack;
> @@ -7567,7 +7569,10 @@ perf_callchain(struct perf_event *event, struct pt_regs *regs)
>  	if (!kernel && !user)
>  		return &__empty_callchain;
>  
> -	callchain = get_perf_callchain(regs, 0, kernel, user,
> +	if (!host && !guest)
> +		return &__empty_callchain;
> +
> +	callchain = get_perf_callchain(regs, 0, kernel, user, host, guest,
>  				       max_stack, crosstask, true);
>  	return callchain ?: &__empty_callchain;
>  }


Best regards,
	Maxim Levitsky


