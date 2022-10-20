Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B66A6067B8
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 20:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbiJTSDv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 14:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiJTSDZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 14:03:25 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B7095E51
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 11:02:41 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 128so254077pga.1
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 11:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yM+q1MLeyW2pRAnXBYaZyBXoFYvNATSrQID9soAtBIQ=;
        b=btxSZSWIOv2Rxc6fAtaWk7bAN7qW7fgOEBq2aKI0Xx9KYPNwkMQ4SExpKnwsOWicOa
         FCcfYtXOvChEeeD3kESeT7dVH9M5mBxQ7cO/j/BdqvS/T+qe8iELpnfWh/pXr4te8dCP
         pswekE55AdqpN6oHJBx6rzDB9IQ9c6ezKsrk8F89uZ2iljVE6uUSJ0geRPCy+JTVcxo8
         2bpRd/jNPUFmxOOsGVu3Jns/1Q5omsz1F7bOz+abqb8xs5P1kY29DqForsk6+U17Gs6s
         DlL5Nt6TnDYAy64xrCKy6SMjmec69Upe/pnYFT4Rb/kcYPfrEORHW9jQBoHkXdOa5nKV
         gLwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yM+q1MLeyW2pRAnXBYaZyBXoFYvNATSrQID9soAtBIQ=;
        b=ZkiFZ4KCxvPy7IKrlCuEwmTElw0/gkHdp9srPEURk1+7NvSM1PnwGg6ZFMJSAgLXYY
         5ixQAEpZZkp8WKHs8yCl6mi+vn0NMV+giyHONsluO4g7/SKi+2HHO5UXVjuGNvcPgfdF
         5qVH62/x/C4ZxAPJTC2IYDGzBKf4H0jIgph8t79OfJ/K8lbvl2D5NEXTkwsWK6vS9C1L
         289l/aYHWdwcOAHqeniaUiWkh0LCuX/NyxHohH9hNJKQnBTr9ssPd8jNT4zzbhbiB5Th
         zMui/DA4igABze3DEQRVmhXum9y2cVDs7p2jvEb7dPlIRpV3rUn4kzTlOlmTQ9jhSp68
         3EXA==
X-Gm-Message-State: ACrzQf3j6ZfWwH+RXEnS0boiD/HYTbDMX3XsZ+xF9jFdDnWk8ZjmqJfl
        SxSlv/+19wjZOG7nx956sAwsUg==
X-Google-Smtp-Source: AMsMyM6W5nuzSRWjom+4dNCGUfU6o2dEJnucCO7mCuKUq171uTqwDqTPSD3fjj5eYRsxNThWMCOeaw==
X-Received: by 2002:a63:555e:0:b0:43c:4f2e:dd25 with SMTP id f30-20020a63555e000000b0043c4f2edd25mr13127040pgm.131.1666288920750;
        Thu, 20 Oct 2022 11:02:00 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t20-20020a63f354000000b00451f4071151sm11780670pgj.65.2022.10.20.11.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 11:01:59 -0700 (PDT)
Date:   Thu, 20 Oct 2022 18:01:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 01/16] x86: make irq_enable avoid the
 interrupt shadow
Message-ID: <Y1GNE9YdEuGPkadi@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
 <20221020152404.283980-2-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020152404.283980-2-mlevitsk@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> Tests that need interrupt shadow can't rely on irq_enable function anyway,
> as its comment states,  and it is useful to know for sure that interrupts
> are enabled after the call to this function.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  lib/x86/processor.h       | 9 ++++-----
>  x86/apic.c                | 1 -
>  x86/ioapic.c              | 1 -
>  x86/svm_tests.c           | 9 ---------
>  x86/tscdeadline_latency.c | 1 -
>  x86/vmx_tests.c           | 7 -------
>  6 files changed, 4 insertions(+), 24 deletions(-)
> 
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 03242206..9db07346 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -720,13 +720,12 @@ static inline void irq_disable(void)
>  	asm volatile("cli");
>  }
>  
> -/* Note that irq_enable() does not ensure an interrupt shadow due
> - * to the vagaries of compiler optimizations.  If you need the
> - * shadow, use a single asm with "sti" and the instruction after it.
> - */
>  static inline void irq_enable(void)
>  {
> -	asm volatile("sti");
> +	asm volatile(
> +			"sti \n\t"

Formatting is odd.  Doesn't really matter, but I think this can simply be:

static inline void sti_nop(void)
{
	asm volatile("sti; nop");
}


> +			"nop\n\t"

I like the idea of a helper to enable IRQs and consume pending interrupts, but I
think we should add a new helper instead of changing irq_enable().

Hmm, or alternatively, kill off irq_enable() and irq_disable() entirely and instead
add sti_nop().  I like this idea even better.  The helpers are all x86-specific,
so there's no need to add a layer of abstraction, and sti() + sti_nop() has the
benefit of making it very clear what code is being emitted without having to come
up with clever function names.

And I think we should go even further and provide a helper to do the entire sequence
of enable->nop->disable, which is a very common pattern.  No idea what to call
this one, though I suppose sti_nop_cli() would work.

My vote is to replace all irq_enable() and irq_disable() usage with sti() and cli(),
and then introduce sti_nop() and sti_nop_cli() (or whatever it gets called) and
convert users as appropriate.

> +	);
>  }
>  
>  static inline void invlpg(volatile void *va)
> diff --git a/x86/apic.c b/x86/apic.c
> index 23508ad5..a8964d88 100644
> --- a/x86/apic.c
> +++ b/x86/apic.c
> @@ -36,7 +36,6 @@ static void __test_tsc_deadline_timer(void)
>      irq_enable();
>  
>      wrmsr(MSR_IA32_TSCDEADLINE, rdmsr(MSR_IA32_TSC));
> -    asm volatile ("nop");

I'm not entirely sure the existing nop is necessary here, but it's a functional
change since it hoists the nop above the WRMSR.  To be safe, probably best to
leave this as-is for now.

>      report(tdt_count == 1, "tsc deadline timer");
>      report(rdmsr(MSR_IA32_TSCDEADLINE) == 0, "tsc deadline timer clearing");
>  }

...

> diff --git a/x86/tscdeadline_latency.c b/x86/tscdeadline_latency.c
> index a3bc4ea4..c54530dd 100644
> --- a/x86/tscdeadline_latency.c
> +++ b/x86/tscdeadline_latency.c
> @@ -73,7 +73,6 @@ static void start_tsc_deadline_timer(void)
>      irq_enable();
>  
>      wrmsr(MSR_IA32_TSCDEADLINE, rdmsr(MSR_IA32_TSC)+delta);
> -    asm volatile ("nop");

Another functional change that should be skipped, at least for now.
