Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBB5239B8
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 16:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731732AbfETOVP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 10:21:15 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33659 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730819AbfETOVP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 10:21:15 -0400
Received: by mail-wm1-f67.google.com with SMTP id c66so58452wme.0
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 07:21:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oCVHEvCDve3evlLHRcsJDEL+LNXiA60zNs/pA1OuzyE=;
        b=YeMLDoeaXZoUJg1TJjlh5gCelZkByUzmGRyeQIkYn/OfjKV5Q4d0Dv69h6ldC+RcL6
         9eHHh0YFI0RqtY+gN3eCBq0cvzNMMFE08DNKQyHW+lPZiv7PzrRUsrWE1lOQrqyhHlMP
         gzQckVBUj+zUsmKe48GVfiu7O1pmkikllbiE/Xutjr5iCA769qfaRz8wwDgal3VvkPvj
         mHVFS/SzZ3+r5Y+STwQ6o+C34LK/QAS4dZKkYYhEvolStdYVYr6yG+wvSRjIlsZt++TU
         YhAlM17FXU7VPiwYVwu15RpmUddz+cGkHtZcpqQIkH6FyIJXhzRho9LLnA1HfgnV7avx
         G2PA==
X-Gm-Message-State: APjAAAXYFmqKrN74Ju4V1FqFDefVo3PkoNcriPy4YVF8jwP11GhqMwIZ
        0vkWOrDwaujCmaRix069pgjcHg==
X-Google-Smtp-Source: APXvYqztyYBUwpkNHNRW5KVnGz+kWOpgwMEeHChfA33JCYwO/KeMC7qiXQHyKDkg0K+SvVRm75ApEg==
X-Received: by 2002:a1c:3cc2:: with SMTP id j185mr41378923wma.26.1558362073326;
        Mon, 20 May 2019 07:21:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id x4sm16513561wrn.41.2019.05.20.07.21.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 07:21:12 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2] x86: Halt on exit
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com
References: <20190513095828.41255-1-nadav.amit@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <af6abda7-d0d2-687c-4854-d5c021720f94@redhat.com>
Date:   Mon, 20 May 2019 16:21:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190513095828.41255-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/05/19 11:58, Nadav Amit wrote:
> In some cases, shutdown through the test device and Bochs might fail.
> Just hang in a loop that executes halt in such cases. Remove the
> __builtin_unreachable() as it is not needed anymore.
> 
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  lib/x86/io.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/x86/io.c b/lib/x86/io.c
> index f3e01f7..f4ffb44 100644
> --- a/lib/x86/io.c
> +++ b/lib/x86/io.c
> @@ -99,7 +99,11 @@ void exit(int code)
>  #else
>          asm volatile("out %0, %1" : : "a"(code), "d"((short)0xf4));
>  #endif
> -	__builtin_unreachable();
> +
> +	/* Fallback */
> +	while (1) {
> +		asm volatile("hlt" ::: "memory");
> +	}
>  }
>  
>  void __iomem *ioremap(phys_addr_t phys_addr, size_t size)
> 

Queued, thanks.

Paolo
