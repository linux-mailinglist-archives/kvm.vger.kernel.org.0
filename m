Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0AA15D3C7
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 18:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfGBQAA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 12:00:00 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46079 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbfGBQAA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 12:00:00 -0400
Received: by mail-wr1-f68.google.com with SMTP id f9so18409794wre.12
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 08:59:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OaB4up98dDTI5y/oETRWo6fKaB+VLA/UvTLZA82H0m8=;
        b=OAn7SaZz4D9bedZpAjjDopdYjZtNrR4l49CKnxioDPnc5jBC+NdMRaITFEzxh20u4P
         bQhio4rpOp5lYtrKzbFZVxe51m0y4LEVfEan9RDAjBEdn4/yrvYzIrYh0IoBpZ6DrYa4
         ZVrywwTnqQNRIWBA/hSqpzo3RHPye9p5gTGIq0zPrFzXbHTRcN8k+ySx2EBbPxLXSEyj
         /Fk0uS53zI1ywLmzCpEBW+GJWtH8uI9edqpnrAW7Ie8VecCbfOUkqP/J4FN+XXCkQXry
         WpYSNtz7NWq65eYYHzoAef0TA3WXmRPW8C8/z7CbsLKK15NKa1dkwaGKjjxs1ayuUOsk
         CEGQ==
X-Gm-Message-State: APjAAAWAetgSuUf/mvwTVVUMM+tLTwScTJ1yzckmzUHwv1Ym60nOIioY
        qv8zjKRtbj0SGBNBOJmQkVNOm9JNmZA=
X-Google-Smtp-Source: APXvYqzOGvYaNAdXuBbm9ulZAdoJsllUMja2m3a7Rlzekw//yQhsimUF95mc3pqP6jAgI7KNAKdQ6Q==
X-Received: by 2002:a5d:554b:: with SMTP id g11mr21945336wrw.10.1562083198891;
        Tue, 02 Jul 2019 08:59:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b8:794:183e:9e2a? ([2001:b07:6468:f312:b8:794:183e:9e2a])
        by smtp.gmail.com with ESMTPSA id s10sm10714890wrt.49.2019.07.02.08.59.58
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 08:59:58 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: Load segments after GDT loading
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org
References: <20190627112334.3293-1-nadav.amit@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5bb777ff-bdeb-3582-2110-1cec43db690e@redhat.com>
Date:   Tue, 2 Jul 2019 17:59:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190627112334.3293-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/06/19 13:23, Nadav Amit wrote:
> Whenever we load the GDT, we need to reload the segment selectors so
> their hidden data (base, limit, type, etc.) would be reloaded.
> 
> It appears that loading GS overwrites the GS bases, so reload GS base
> after loading the segment to prevent per-cpu variable corruption.
> 
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  x86/cstart64.S | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/x86/cstart64.S b/x86/cstart64.S
> index c5561e7..9791282 100644
> --- a/x86/cstart64.S
> +++ b/x86/cstart64.S
> @@ -118,6 +118,21 @@ MSR_GS_BASE = 0xc0000101
>  	wrmsr
>  .endm
>  
> +.macro setup_segments
> +	mov $MSR_GS_BASE, %ecx
> +	rdmsr
> +
> +	mov $0x10, %bx
> +	mov %bx, %ds
> +	mov %bx, %es
> +	mov %bx, %fs
> +	mov %bx, %gs
> +	mov %bx, %ss
> +
> +	/* restore MSR_GS_BASE */
> +	wrmsr
> +.endm
> +
>  .globl start
>  start:
>  	mov %ebx, mb_boot_info
> @@ -149,6 +164,7 @@ switch_to_5level:
>  
>  prepare_64:
>  	lgdt gdt64_desc
> +	setup_segments
>  
>  enter_long_mode:
>  	mov %cr4, %eax
> @@ -196,12 +212,7 @@ sipi_end:
>  
>  .code32
>  ap_start32:
> -	mov $0x10, %ax
> -	mov %ax, %ds
> -	mov %ax, %es
> -	mov %ax, %fs
> -	mov %ax, %gs
> -	mov %ax, %ss
> +	setup_segments
>  	mov $-4096, %esp
>  	lock/xaddl %esp, smp_stacktop
>  	setup_percpu_area
> 

Queued, thanks.

Paolo
