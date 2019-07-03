Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 691605E8AD
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 18:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfGCQXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 12:23:07 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52436 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfGCQXH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 12:23:07 -0400
Received: by mail-wm1-f67.google.com with SMTP id s3so2838280wms.2
        for <kvm@vger.kernel.org>; Wed, 03 Jul 2019 09:23:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6axsB7tTSVN9+THoYftvz6QjMoumSr7HZztyJRyLa40=;
        b=r/nUtPJiPf99FL7F4QxfE6lDK4SrZCNda+1v6ghWWAgs59h2jtLynT1gnF8ofmbqHv
         sQIxAempgT/66PN0txsRFLzA04q1EQnk3/2V7urehj8QRVuQ+MOqw9MkgjpLDlJ9oY3/
         7EQCFDqNtL9XSD6mQiPICGo1FYGDgaBcK8myPTQf5B8GEWr+RKoL8Gm9TCdN92215Oj9
         0911A2q+19OKnfLaINSxOTtvH4eeqlK0GM1dHPBpo1nc4BRA0uG92UVYpqfxmh/Gd+bk
         dOSk645GRfv87c/7VhFUQtX2jaknwrjJ/oE88ZsBuAocL7K3e5epEgujSXxaE2ieg/33
         TELg==
X-Gm-Message-State: APjAAAXmOLz4A/P4vgQkj+oWAr5H/ZrlB0MQe73aY7cfrL3aAg6XdU2+
        GR1igpq0x0gT9H56vE6lQEqANg==
X-Google-Smtp-Source: APXvYqygT9WZyOJ4nfYw9a8h6FDTp6c08dZZj8PBT3AKeUmifPjaTG+t58PWdB/deIRlSKNZg6wJOw==
X-Received: by 2002:a1c:9a53:: with SMTP id c80mr8150575wme.173.1562170985443;
        Wed, 03 Jul 2019 09:23:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:6c1d:63cc:b81d:e1a9? ([2001:b07:6468:f312:6c1d:63cc:b81d:e1a9])
        by smtp.gmail.com with ESMTPSA id b2sm3582556wrp.72.2019.07.03.09.23.04
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 09:23:04 -0700 (PDT)
Subject: Re: [PATCH 2/4] kvm: x86: allow set apic and ioapic debug dynamically
To:     Yi Wang <wang.yi59@zte.com.cn>
Cc:     rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        up2wing@gmail.com, wang.liang82@zte.com.cn
References: <1561962071-25974-1-git-send-email-wang.yi59@zte.com.cn>
 <1561962071-25974-3-git-send-email-wang.yi59@zte.com.cn>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <685680d5-f642-0c48-08f2-8c73026ccaf0@redhat.com>
Date:   Wed, 3 Jul 2019 18:23:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1561962071-25974-3-git-send-email-wang.yi59@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/07/19 08:21, Yi Wang wrote:
> There are two *_debug() macros in kvm apic source file:
> - ioapic_debug, which is disable using #if 0
> - apic_debug, which is commented
> 
> Maybe it's better to control these two macros using CONFIG_KVM_DEBUG,
> which can be set in make menuconfig.
> 
> Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
> ---
>  arch/x86/kvm/ioapic.c | 2 +-
>  arch/x86/kvm/lapic.c  | 5 ++++-
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> index 1add1bc..8099253 100644
> --- a/arch/x86/kvm/ioapic.c
> +++ b/arch/x86/kvm/ioapic.c
> @@ -45,7 +45,7 @@
>  #include "lapic.h"
>  #include "irq.h"
>  
> -#if 0
> +#ifdef CONFIG_KVM_DEBUG
>  #define ioapic_debug(fmt,arg...) printk(KERN_WARNING fmt,##arg)
>  #else
>  #define ioapic_debug(fmt, arg...)
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 4924f83..dfff5c6 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -54,8 +54,11 @@
>  #define PRIu64 "u"
>  #define PRIo64 "o"
>  
> -/* #define apic_debug(fmt,arg...) printk(KERN_WARNING fmt,##arg) */
> +#ifdef CONFIG_KVM_DEBUG
> +#define apic_debug(fmt,arg...) printk(KERN_WARNING fmt,##arg)
> +#else
>  #define apic_debug(fmt, arg...) do {} while (0)
> +#endif
>  
>  /* 14 is the version for Xeon and Pentium 8.4.8*/
>  #define APIC_VERSION			(0x14UL | ((KVM_APIC_LVT_NUM - 1) << 16))
> 

I would just drop all of them.  I've never used them in years, the kvm
tracepoints are enough.

Paolo
