Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA74239AF
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 16:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733299AbfETOSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 10:18:33 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53871 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731093AbfETOSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 10:18:32 -0400
Received: by mail-wm1-f68.google.com with SMTP id 198so13499366wme.3
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 07:18:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1w1a7fg9C+Jjo0pKpbERC0OWLwSEOFoXLBypK+7YsNA=;
        b=klErVrHASXRuocBDCN6ha2fMwCZ9Rb3gxZo5fmnX7yu42wjZ5pCVqtE0x6I72qPA2M
         mFqqREJ/BJUVCsGUxlUXBH+RKR0bXpnBZkejOfSoLwn0etOJHM+jmtyETyPAE51Px9D0
         jVgMiQBFONGnXGxfyA7qfnh25pjxFrcdyJvZfc7oy/Oax6poINcIDl3X4ToHYITeNLpa
         AAL6JWfwLY0jyJambKYwAotSoqNd23ykT+6KtHpRQ0s13sLT883WIdBCbcC6nkR8DTew
         GcQW7sXjqXdqtTkkrDEBHdVfTg8Rj+PfIjphJg4+eehQaZSzc7bSkWZKAb5rCqsYDjUA
         CLCg==
X-Gm-Message-State: APjAAAUNRCBkIY/PwRejcUiPEYPaJgApLhg7ztboTzMgsFLTfDriCLfw
        0gdfHThDTFcBKNn+wHc1tM7m/A==
X-Google-Smtp-Source: APXvYqyfdQ+MyX5SwfqA5Px6C0BOhTtswVE7/zfzwNRLaOtOBalys4H9qnZfoZf+UGPBz/w+yK8hig==
X-Received: by 2002:a1c:2dc2:: with SMTP id t185mr6174070wmt.52.1558361910688;
        Mon, 20 May 2019 07:18:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id b10sm41275954wrh.59.2019.05.20.07.18.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 07:18:30 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v3] x86: Incorporate timestamp in delay()
 and call the latter in io_delay()
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <20190504223618.26742-1-nadav.amit@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ce2d4dcc-b9d8-54f9-9f44-4d436ffd21d7@redhat.com>
Date:   Mon, 20 May 2019 16:18:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190504223618.26742-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/19 00:36, Nadav Amit wrote:
> There is no guarantee that a self-IPI would be delivered immediately.
> In eventinj, io_delay() is called after self-IPI is generated but does
> nothing.
> 
> In general, there is mess in regard to delay() and io_delay(). There are
> two definitions of delay() and they do not really look on the timestamp
> counter and instead count invocations of "pause" (or even "nop"), which
> might be different on different CPUs/setups, for example due to
> different pause-loop-exiting configurations.
> 
> To address these issues change io_delay() to really do a delay, based on
> timestamp counter, and move common functions into delay.[hc].
> 
> Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>

I had already included the fixed commit message in v2, thanks anyway for
sending this one. :)

Paolo

> ---
>  lib/x86/delay.c | 9 ++++++---
>  lib/x86/delay.h | 7 +++++++
>  x86/eventinj.c  | 5 +----
>  x86/ioapic.c    | 8 +-------
>  4 files changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/lib/x86/delay.c b/lib/x86/delay.c
> index 595ad24..e7d2717 100644
> --- a/lib/x86/delay.c
> +++ b/lib/x86/delay.c
> @@ -1,8 +1,11 @@
>  #include "delay.h"
> +#include "processor.h"
>  
>  void delay(u64 count)
>  {
> -	while (count--)
> -		asm volatile("pause");
> -}
> +	u64 start = rdtsc();
>  
> +	do {
> +		pause();
> +	} while (rdtsc() - start < count);
> +}
> diff --git a/lib/x86/delay.h b/lib/x86/delay.h
> index a9bf894..a51eb34 100644
> --- a/lib/x86/delay.h
> +++ b/lib/x86/delay.h
> @@ -3,6 +3,13 @@
>  
>  #include "libcflat.h"
>  
> +#define IPI_DELAY 1000000
> +
>  void delay(u64 count);
>  
> +static inline void io_delay(void)
> +{
> +	delay(IPI_DELAY);
> +}
> +
>  #endif
> diff --git a/x86/eventinj.c b/x86/eventinj.c
> index d2dfc40..901b9db 100644
> --- a/x86/eventinj.c
> +++ b/x86/eventinj.c
> @@ -7,6 +7,7 @@
>  #include "apic-defs.h"
>  #include "vmalloc.h"
>  #include "alloc_page.h"
> +#include "delay.h"
>  
>  #ifdef __x86_64__
>  #  define R "r"
> @@ -16,10 +17,6 @@
>  
>  void do_pf_tss(void);
>  
> -static inline void io_delay(void)
> -{
> -}
> -
>  static void apic_self_ipi(u8 v)
>  {
>  	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED |
> diff --git a/x86/ioapic.c b/x86/ioapic.c
> index 2ac4ac6..c32dabd 100644
> --- a/x86/ioapic.c
> +++ b/x86/ioapic.c
> @@ -4,6 +4,7 @@
>  #include "smp.h"
>  #include "desc.h"
>  #include "isr.h"
> +#include "delay.h"
>  
>  static void toggle_irq_line(unsigned line)
>  {
> @@ -165,13 +166,6 @@ static void test_ioapic_level_tmr(bool expected_tmr_before)
>  	       expected_tmr_before ? "true" : "false");
>  }
>  
> -#define IPI_DELAY 1000000
> -
> -static void delay(int count)
> -{
> -	while(count--) asm("");
> -}
> -
>  static void toggle_irq_line_0x0e(void *data)
>  {
>  	irq_disable();
> 

