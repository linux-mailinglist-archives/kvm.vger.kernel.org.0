Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F400B3740B
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 14:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbfFFMZL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 08:25:11 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42836 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfFFMZL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 08:25:11 -0400
Received: by mail-wr1-f67.google.com with SMTP id x17so2197916wrl.9
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 05:25:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cOqNQgtD17il7RCuPYNmAywn2jheq0Ttb5150wXIDTo=;
        b=k4SR5u52vZUmO45lPB35Ehhbv29RyRdGn16d9l+aoalFHJi/a4U+QEhWNdphayaCCR
         GXpSN/G4Vhhfl07+nSEF4TkO7dQ/8GqZ61xd8TrSbDka9lo5+KeDgZPlllNdVyV0tllx
         RjVOguuCGiwtMhVbQ4gWXwCQNrJVzDPWf3v7qNJ1WHi52jveljaBS0354K6TckxPA5Gp
         0BoiBlJqPLnXDCSUcLEU09EEshz367tix+9t3bsxrbkIc9u7CTxXihh4svKj+GU54dPi
         QT5aixG4E+/wegU4cCwpOQL1UCFkk+EWWqScYblfTXqRQZOFiWHKCIfDmOaJ0uUQFEhW
         MozQ==
X-Gm-Message-State: APjAAAX3u9U1ufi2upuu3VyZ7JzCTJ+Sv5q9ObXMoDreqVxFmBxz1XC/
        mDYeyEUSfjdnROSN6X/gYRWilW6/Zxw=
X-Google-Smtp-Source: APXvYqwlHl3QDt0gAXOSQOp4oq35ZLX7JITpQ53pmQ4cSW8NbzU59WTEVudcgZMoHPKEYpzpMDqvHw==
X-Received: by 2002:adf:ea4a:: with SMTP id j10mr1038118wrn.114.1559823909451;
        Thu, 06 Jun 2019 05:25:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id 88sm2373179wrl.68.2019.06.06.05.25.08
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 05:25:08 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: Fix SMP stacks
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org
References: <20190520091730.15536-1-nadav.amit@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e3a3d62f-28b7-fa29-961f-f3585934d3c4@redhat.com>
Date:   Thu, 6 Jun 2019 14:25:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190520091730.15536-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/19 11:17, Nadav Amit wrote:
> Avoid smashing the SMP stacks during boot as currently happens by
> allocating sufficient space for them.
> 
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  x86/cstart64.S | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/x86/cstart64.S b/x86/cstart64.S
> index a4b55c5..71c3153 100644
> --- a/x86/cstart64.S
> +++ b/x86/cstart64.S
> @@ -19,7 +19,7 @@ max_cpus = MAX_TEST_CPUS
>  	.align 16
>  stacktop:
>  
> -	. = . + 4096
> +	. = . + 4096 * max_cpus
>  	.align 16
>  ring0stacktop:
>  
> @@ -170,7 +170,7 @@ efer = 0xc0000080
>  	mov %eax, %cr0
>  	ret
>  
> -smp_stacktop:	.long 0xa0000
> +smp_stacktop:	.long stacktop - 4096
>  
>  .align 16
>  
> 

Queued, thanks.

Paolo
