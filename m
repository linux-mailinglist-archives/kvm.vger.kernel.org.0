Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1ADD387A15
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 15:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349687AbhERNhw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 09:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349681AbhERNhu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 09:37:50 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC325C061573;
        Tue, 18 May 2021 06:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=yuqCWcIqul/1lj3NsVLBchoLnyRiKeIyOOoNOlV42Hs=; b=bQH0fgbqI9bCAw2E4kTrPyruHo
        Sdf8ZX08AyYdMekNB+R0Nlp/yhM9U2IuZ1SDaLoKzA+t8GbV4IItx2DuRb/HyEx0EjjcZlhTs7aTK
        zJ62HS1rYEuYpzendAp6+dMkOmjKGZC6vtjQQfXoMwm8aYb5jNRMzQc+kHQRm1UkHlngPyvZHdwWD
        cWPKa0Sra1qGZcFNAVklSi5LJRvds+V9ky6yJG9sCQMI44Goue5p1x2U0vU9xaXXUXFJmz6JUPjTL
        Pvu89thupqInO5dfCrWu2pd6APq8YAJz4+2KtOHzF5DhLD2NzfOjwgh0q6DTWI8FMtB6JKKhEyX5c
        aP8R+ndQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1liztH-000tHR-N2; Tue, 18 May 2021 13:36:07 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 54DFC30022C;
        Tue, 18 May 2021 15:36:06 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3DB893011B374; Tue, 18 May 2021 15:36:06 +0200 (CEST)
Date:   Tue, 18 May 2021 15:36:06 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: Re: [PATCH v6 07/16] KVM: x86/pmu: Reprogram PEBS event to emulate
 guest PEBS counter
Message-ID: <YKPCxnKc1MGqXsJ4@hirez.programming.kicks-ass.net>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
 <20210511024214.280733-8-like.xu@linux.intel.com>
 <YKIz/J1HoOvbmR42@hirez.programming.kicks-ass.net>
 <2d874bce-2823-13b4-0714-3de5b7c475f0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2d874bce-2823-13b4-0714-3de5b7c475f0@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 18, 2021 at 09:28:52PM +0800, Xu, Like wrote:

> > How would pebs && !intr be possible?
> 
> I don't think it's possible.

And yet you keep that 'intr||pebs' weirdness :/

> > Also; wouldn't this be more legible
> > when written like:
> > 
> > 	perf_overflow_handler_t ovf = kvm_perf_overflow;
> > 
> > 	...
> > 
> > 	if (intr)
> > 		ovf = kvm_perf_overflow_intr;
> > 
> > 	...
> > 
> > 	event = perf_event_create_kernel_counter(&attr, -1, current, ovf, pmc);
> > 
> 
> Please yell if you don't like this:
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 711294babb97..a607f5a1b9cd 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -122,6 +122,8 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc,
> u32 type,
>                 .config = config,
>         };
>         bool pebs = test_bit(pmc->idx, (unsigned long *)&pmu->pebs_enable);
> +       perf_overflow_handler_t ovf = (intr || pebs) ?
> +               kvm_perf_overflow_intr : kvm_perf_overflow;

This, that's exactly the kind of code I wanted to get rid of. ?: has
it's place I suppose, but you're creating dense ugly code for no reason.

	perf_overflow_handle_t ovf = kvm_perf_overflow;

	if (intr)
		ovf = kvm_perf_overflow_intr;

Is so much easier to read. And if you really worry about that pebs
thing; you can add:

	WARN_ON_ONCE(pebs && !intr);

