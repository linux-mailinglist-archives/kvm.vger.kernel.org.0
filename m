Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF1D023985
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 16:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388281AbfETOMY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 10:12:24 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42768 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730647AbfETOMX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 10:12:23 -0400
Received: by mail-wr1-f66.google.com with SMTP id l2so14795494wrb.9
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 07:12:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DvFHU0uDXzl5U3Jkxo0HRVbwppJm5R5lYf9g/H+DGF4=;
        b=DF0EY2TxwQT6NdNIVZxrs1EChHvI/TQ5Vj1nZ20BiOcOmhX+MQyy0W29bNx4Fj/2o8
         gYkF3nuUec0wjlgGa4E1mvJGK+22yGEmV7qkpS59lgFLsIjpe95+UQ9BkFL4RHRnw/WW
         tqVyUw0ud3IezpqUiU6FEBdr1bEsWYJ1MTZ1xLouYVai8SmzW/4Y4UjeKflv2JXs2ZAd
         s92Z40YUctDLc8Sol7BjSbJc5IUd7HgGE044Zd6iVdNNfSX7ZLJMuEFebL3RpauUCIVV
         iYhCmLncOn+oe2ELYfwkG0TJjUaU53V+QRDFf1wDvuLbLUod4fdNkConSEGgOh8p/O3d
         ouHQ==
X-Gm-Message-State: APjAAAUfbQ9PLzoHfFTcDjcQc6C286SZjNExP3DozwQDqEkPYw56rGt6
        vSCT1VHwO5imxdOt0+4DyKctHg==
X-Google-Smtp-Source: APXvYqzkfe8Xu1IMjmqXHceugHm1InIQZMuIt8MNToV1KshdgS+vfPjaGyU3cXccdZCxGU+fGy4OAg==
X-Received: by 2002:a5d:4e46:: with SMTP id r6mr45731065wrt.290.1558361542076;
        Mon, 20 May 2019 07:12:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id b206sm18067404wmd.28.2019.05.20.07.12.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 07:12:21 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: Fix APIC version register test
To:     "nadav.amit@gmail.com" <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20190430143242.4030-1-nadav.amit@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c9c9eee8-7e7b-1517-25df-f13706f4a016@redhat.com>
Date:   Mon, 20 May 2019 16:12:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190430143242.4030-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/04/19 16:32, nadav.amit@gmail.com wrote:
> From: Nadav Amit <nadav.amit@gmail.com>
> 
> The local APIC existance test considers reserved bits (bits [8:15]),
> which is not good. In addition, it is best to consider every integrated
> APIC version as valid.
> 
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  x86/apic.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/x86/apic.c b/x86/apic.c
> index cfdbef2..21041ec 100644
> --- a/x86/apic.c
> +++ b/x86/apic.c
> @@ -11,11 +11,11 @@
>  
>  static void test_lapic_existence(void)
>  {
> -    u32 lvr;
> +    u8 version;
>  
> -    lvr = apic_read(APIC_LVR);
> -    printf("apic version: %x\n", lvr);
> -    report("apic existence", (u16)lvr == 0x14);
> +    version = (u8)apic_read(APIC_LVR);
> +    printf("apic version: %x\n", version);
> +    report("apic existence", version >= 0x10 && version <= 0x15);
>  }
>  
>  #define TSC_DEADLINE_TIMER_VECTOR 0xef
> 

Queued, thanks.

Paolo
