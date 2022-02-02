Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCC44A782A
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 19:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346725AbiBBSnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 13:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245220AbiBBSnb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 13:43:31 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C07AC061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 10:43:31 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 133so300506pgb.0
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 10:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SDBZmOfzCxzCugk5jd7ddO5i086r0OhAAAxVBt9bcn4=;
        b=oCI/z/rsP2tCXkQEN/+3HjveKSrAnKOcocJwYaxxXbEW1w/eYlt67jmoJECImLXl6Y
         m+naw7bWdoJmdRnn10lDq1HpA2C5Az22TBA6yOAyuycAtgvmvSp/UQeky9h/lq03T2xw
         lFjkXkSHdF4LLPF0HB4gynXj3rNLfI65rrGnjcnuUumbMu6jj8AaMwam+iUKe7nJpgCo
         iYbJCIHr1SG2YFaExtqHyGZ7n/VHGIJmWCAeqACFxUBHAO5mxQNGVKviHVdOY7eknFJ4
         iKjM6a0XZmYtrfGna/2nc/lbsI0MgMcoJPezmgMWAFHDODU9wJXJBWHksMfgYyj917xU
         GB0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SDBZmOfzCxzCugk5jd7ddO5i086r0OhAAAxVBt9bcn4=;
        b=Wa9HtfuWajj2QqJrMKMBpn0oREbtrpvlGq6+Eg6oS9lohiLYagnVQXB5J3pY1FPd4F
         r6a2tlO/0ltX1jbOA/T0M0WGNYT4kU+RUKWnXyjniW57LZxmRoKkO1YibZK4DrWDtXXp
         5MErJROz0dulsPOY85if5MJR2mmfzpwJ0lDFIMTtkscjTA6Yt2tHZ5sLeu4EPstuE7/p
         Hpp9Bk+GRRZoz8gMdvViTPSOI+T5mNcWQ72woXbSt8DPMpHSd0dv+eWNfkWRthT7soc4
         6zETncnOGH4xDJjzy6VqJ1JMifwyPI8E6WI4ICCAab+U5XBZSH2OMuDEu/TjB3TCeOuG
         Ia8Q==
X-Gm-Message-State: AOAM533WkhRimVnSfhp8d6t49YCIbfpIO/cXiOrOdXH5+p9eQK9GvMHx
        klTT5XGSJfdHuqHIT+jd03Op7Q==
X-Google-Smtp-Source: ABdhPJyKY2bmBpNsgwyDJ0PlfhIstJxwGXU5jBuEN8xCwoW4q9qfWAOqxr1alAqmED6qNrXosDZfnA==
X-Received: by 2002:aa7:9682:: with SMTP id f2mr31230350pfk.56.1643827410811;
        Wed, 02 Feb 2022 10:43:30 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p22sm26858049pfo.163.2022.02.02.10.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 10:43:30 -0800 (PST)
Date:   Wed, 2 Feb 2022 18:43:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Will McVicker <willmcvicker@google.com>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH v4 09/17] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
Message-ID: <YfrQzoIWyv9lNljh@google.com>
References: <20211111020738.2512932-1-seanjc@google.com>
 <20211111020738.2512932-10-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211111020738.2512932-10-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Will and Sami, -most everyone else

On Thu, Nov 11, 2021, Sean Christopherson wrote:
> Use static_call to optimize perf's guest callbacks on arm64 and x86,
> which are now the only architectures that define the callbacks.  Use
> DEFINE_STATIC_CALL_RET0 as the default/NULL for all guest callbacks, as
> the callback semantics are that a return value '0' means "not in guest".
> 
> static_call obviously avoids the overhead of CONFIG_RETPOLINE=y, but is
> also advantageous versus other solutions, e.g. per-cpu callbacks, in that
> a per-cpu memory load is not needed to detect the !guest case.
> 
> Based on code from Peter and Like.
> 
> Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Like Xu <like.xu.linux@gmail.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

...

> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 1c8d341ecc77..b4fd928e4ff8 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -6524,12 +6524,23 @@ static void perf_pending_event(struct irq_work *entry)
>  #ifdef CONFIG_GUEST_PERF_EVENTS
>  struct perf_guest_info_callbacks __rcu *perf_guest_cbs;
>  
> +DEFINE_STATIC_CALL_RET0(__perf_guest_state, *perf_guest_cbs->state);
> +DEFINE_STATIC_CALL_RET0(__perf_guest_get_ip, *perf_guest_cbs->get_ip);
> +DEFINE_STATIC_CALL_RET0(__perf_guest_handle_intel_pt_intr, *perf_guest_cbs->handle_intel_pt_intr);

Using __static_call_return0() makes clang's CFI sad on arm64 due to the resulting
function prototype mistmatch, which IIUC, is verified by clang's __cfi_check()
for indirect calls, i.e. architectures without CONFIG_HAVE_STATIC_CALL.

We could fudge around the issue by using stubs, massaging prototypes, etc..., but
that means doing that for every arch-agnostic user of __static_call_return0().

Any clever ideas?  Can we do something like generate a unique function for every
DEFINE_STATIC_CALL_RET0 for CONFIG_HAVE_STATIC_CALL=n, e.g. using typeof() to
get the prototype?

  Kernel panic - not syncing: CFI failure (target: __static_call_return0+0x0/0x8)
  CPU: 0 PID: 1625 Comm: batterystats-wo Tainted: G        W  OE     5.16.0-mainline #1$
  Hardware name: Raven EVT 1.1 (DT)$
  Call trace:$
   dump_backtrace+0xf0/0x130$
   show_stack+0x1c/0x2c$
   dump_stack_lvl+0x68/0x98$
   panic+0x168/0x420$
   __cfi_check_fail+0x58/0x5c$
   __cfi_slowpath_diag+0x150/0x1a4$
   perf_misc_flags+0x74/0xa4$
   perf_prepare_sample+0x50/0x44c$
   perf_event_output_forward+0x5c/0xcc$
   __perf_event_overflow+0xc8/0x188$
   perf_swevent_event+0x7c/0x10c$
   perf_tp_event+0x168/0x298$
   perf_trace_run_bpf_submit+0x8c/0xdc$
   perf_trace_sched_switch+0x180/0x1cc$
   __schedule+0x850/0x924$
   schedule+0x98/0xe0$
   binder_wait_for_work+0x158/0x368$
   binder_thread_read+0x278/0x243c$
   binder_ioctl_write_read+0x120/0x45c$
   binder_ioctl+0x1ac/0xc34$
   __arm64_sys_ioctl+0xa8/0x118$
   invoke_syscall+0x64/0x178$
   el0_svc_common+0x8c/0x100$
   do_el0_svc+0x28/0xa0$
   el0_svc+0x24/0x84$
   el0t_64_sync_handler+0x88/0xec$
   el0t_64_sync+0x1b4/0x1b8$
