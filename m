Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 317B6239A8
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 16:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391249AbfETOQC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 10:16:02 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35184 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730353AbfETOQC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 10:16:02 -0400
Received: by mail-wr1-f65.google.com with SMTP id m3so1845911wrv.2
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 07:16:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pQyJ4r/pIskiq2x4lBoZE1MWpmwpdgVXMYSxR5QT8Kg=;
        b=klvXmiKrJ30yO0YY1mPD1sZrhAoT7SUmabJ5fF5cwJMCxKoTKgUltNhOpnJD04zTIa
         z5WnhplDAXc4H8uiqHc13fytaXwLzxgOSwDJ2dbTEd5ulGhhOpqxRoddsh74RcVXoNZv
         cupturClQIczt42dmGr03XLKhNuVnVrNwI+t6xDNig3/rlmcajK841EL9VzGfGOM313K
         EH7iKdEs1f9O9qyvteTwnvoxfOmebwHRiW5rNI4agTgnsFRkItHgXx66x84KWUklJSFQ
         ZZ/WPOGpkDd7mf862a1bp0mX3cfcNjKZTEdEog/VGGQ8hHxbFQvgJ32XBEyPxbGQWHAg
         c2Qw==
X-Gm-Message-State: APjAAAWR4vcLZUrzK2PJ1toOCAWLOvYyKWM4DwgRf182VJdHYicawuBp
        qE0kh+e0rTgTUDQ+bQ2D+L5pIllWMrfMqA==
X-Google-Smtp-Source: APXvYqzNHQU1/VWwhaA0jYE1pbaIMp8CLASYZcL5r4obpsxo0doHqi9yUCFdoHnBOSODzByDB+B6Lw==
X-Received: by 2002:adf:f44b:: with SMTP id f11mr16313743wrp.128.1558361760156;
        Mon, 20 May 2019 07:16:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id m206sm22545413wmf.21.2019.05.20.07.15.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 07:15:59 -0700 (PDT)
Subject: Re: [PATCH v2] x86: Some cleanup of delay() and io_delay()
To:     "nadav.amit@gmail.com" <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <20190503111307.10716-1-nadav.amit@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <636e3100-fb0e-4fcb-9167-bea7f418a038@redhat.com>
Date:   Mon, 20 May 2019 16:15:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190503111307.10716-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/05/19 13:13, nadav.amit@gmail.com wrote:
> From: Nadav Amit <nadav.amit@gmail.com>
> 
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

Queued; there is another io_delay instance in taskswitch2.c, so I
removed it too.

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

