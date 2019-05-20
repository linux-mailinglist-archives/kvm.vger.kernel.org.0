Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE9AA239AC
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 16:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387881AbfETORb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 10:17:31 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41759 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731093AbfETORb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 10:17:31 -0400
Received: by mail-wr1-f66.google.com with SMTP id g12so14536380wro.8
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 07:17:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4lAZErK7b2VHa1Zj4KqxqA7DIiJbWmQKebdWPmjtqLM=;
        b=qZzn/t7oJ7pN1VNPOTEVhYYvlZ9SeKi3Aro9STfdD2pzTomFFHuQXipgkH06xsqvuW
         cOd8j03nss7lSvyv6SraECiNtWC9vreLJkfbHtppXTsYR5ime+YWmAJtcvd/p0NtwXt2
         +ONVHtnEi5EADme4ObydOKccWaLH5BntoFx6eo/DCFlsknBbf5BOgFwvD1uX9wEFV/SQ
         wOBJtmj8QGWRwmPceJpslVNtvaA8ZhQr6iZjMTQjQ9YfXmzeKd5V8ZdyXVNriNGjv4Vl
         I3EpgjqqtwLfncWVOTWfmrNdZiJdaVdpsoaZ0z7nBSxLdE7BB3yTgfC38IaN0cgm2SQU
         5seA==
X-Gm-Message-State: APjAAAWcCf3y4JD+aKHnY+6ogl9dVdMTpUE2Z7YBkHuy2QGBw+VsucpQ
        jTr2FFDvP6vcaUfBEUC3cusz3l3U0z6aJQ==
X-Google-Smtp-Source: APXvYqzre9jAXpVh1+naIa2XF8M3acXzLBPvxLL5uy6uLCDqVtO3J49gjKkcy6il6D4e7W2v3sblrQ==
X-Received: by 2002:adf:cf0c:: with SMTP id o12mr36842393wrj.182.1558361849557;
        Mon, 20 May 2019 07:17:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id k17sm14607294wrm.73.2019.05.20.07.17.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 07:17:28 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 1/2] x86: PMU: Fix PMU counters masking
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org
References: <20190504223142.26668-1-nadav.amit@gmail.com>
 <20190504223142.26668-2-nadav.amit@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <466e8513-5271-0827-f81d-b4bc257d149c@redhat.com>
Date:   Mon, 20 May 2019 16:17:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190504223142.26668-2-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/19 00:31, Nadav Amit wrote:
> Intel SDM says that for MSR_IA32_PERFCTR0/1 "the lower-order 32 bits of
> each MSR may be written with any value, and the high-order 8 bits are
> sign-extended according to the value of bit 31." The current PMU tests
> ignored the fact that the high bit is sign-extended.
> 
> At the same time, the fixed counters are not limited to 32-bit, but
> appear to be limited to the width of the fixed counters (I could not
> find clear documentation).
> 
> Fix the tests accordingly.
> 
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> 
> ---
> 
> As a result of this fix, the fixed counters test currently fails on KVM.
> I am unable to provide a bug-fix although the fix is simple.

Fair enough, I'll give it a look.

Queued both, thanks.

Paolo

> ---
>  x86/pmu.c | 28 +++++++++++++++++++++-------
>  1 file changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 6658fe9..afb387b 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -316,14 +316,19 @@ static void check_counter_overflow(void)
>  	for (i = 0; i < num_counters + 1; i++, cnt.ctr++) {
>  		uint64_t status;
>  		int idx;
> -		if (i == num_counters)
> +
> +		cnt.count = 1 - count;
> +
> +		if (i == num_counters) {
>  			cnt.ctr = fixed_events[0].unit_sel;
> +			cnt.count &= (1ul << edx.split.bit_width_fixed) - 1;
> +		}
> +
>  		if (i % 2)
>  			cnt.config |= EVNTSEL_INT;
>  		else
>  			cnt.config &= ~EVNTSEL_INT;
>  		idx = event_to_global_idx(&cnt);
> -		cnt.count = 1 - count;
>  		measure(&cnt, 1);
>  		report("cntr-%d", cnt.count == 1, i);
>  		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
> @@ -357,16 +362,25 @@ static void check_rdpmc(void)
>  	report_prefix_push("rdpmc");
>  
>  	for (i = 0; i < num_counters; i++) {
> -		uint64_t x = (val & 0xffffffff) |
> -			((1ull << (eax.split.bit_width - 32)) - 1) << 32;
> +		uint64_t x;
> +
> +		/*
> +		 * Only the low 32 bits are writable, and the value is
> +		 * sign-extended.
> +		 */
> +		x = (uint64_t)(int64_t)(int32_t)val;
> +
> +		/* Mask according to the number of supported bits */
> +		x &= (1ull << eax.split.bit_width) - 1;
> +
>  		wrmsr(MSR_IA32_PERFCTR0 + i, val);
>  		report("cntr-%d", rdpmc(i) == x, i);
>  		report("fast-%d", rdpmc(i | (1<<31)) == (u32)val, i);
>  	}
>  	for (i = 0; i < edx.split.num_counters_fixed; i++) {
> -		uint64_t x = (val & 0xffffffff) |
> -			((1ull << (edx.split.bit_width_fixed - 32)) - 1) << 32;
> -		wrmsr(MSR_CORE_PERF_FIXED_CTR0 + i, val);
> +		uint64_t x = val & ((1ull << edx.split.bit_width_fixed) - 1);
> +
> +		wrmsr(MSR_CORE_PERF_FIXED_CTR0 + i, x);
>  		report("fixed cntr-%d", rdpmc(i | (1 << 30)) == x, i);
>  		report("fixed fast-%d", rdpmc(i | (3<<30)) == (u32)val, i);
>  	}
> 

