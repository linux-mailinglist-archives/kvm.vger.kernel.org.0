Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99BE302375
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 11:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbhAYKC0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 05:02:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40381 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727293AbhAYKAc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Jan 2021 05:00:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611568728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I5qvNwK9Eh5sztpVmXUqhiLY8j0P2hRONqOuGd/Z0cw=;
        b=hsUthOawGbgnKbDw/8UbW5xgVubl35rSdLRhwNynULnCcv1AvNGh9spshT4hVJMElrOgeJ
        fTdalYrO79rLZXSvF/tEHcSrtnVKo8C26BoSM4+hIugpJUggHESUKH/D+V5cvg8VEYIeDz
        vV0zdic4n3FkYGyvD4kiD2wc8xAy9Kc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-UIhKZmDbOyaPH7NRroyLGw-1; Mon, 25 Jan 2021 04:58:46 -0500
X-MC-Unique: UIhKZmDbOyaPH7NRroyLGw-1
Received: by mail-ed1-f71.google.com with SMTP id n8so7048439edo.19
        for <kvm@vger.kernel.org>; Mon, 25 Jan 2021 01:58:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I5qvNwK9Eh5sztpVmXUqhiLY8j0P2hRONqOuGd/Z0cw=;
        b=LimbOMNF9czsP1dW5A1Iq+nbeZcJKm4YOQBkNpgMXndn6d9xaFEDl/7NTW/INt3ZdA
         4ShNl4AAJtzDTSpW9M6xX0eahrue5TbNjodpbrEBC96JQ++AljXNAvV92/MyDU0ZBtVw
         DuvEDinNTolL/R81m8hOZBxC1Bs4TpQxQHfoEHM82A3eQ/ejMmrjgUIrUuNZ4yHx9OhU
         hEGe6o/T+A5/l0skOZuO1MddLyh4N3zUGLw3822KEyLJiuVUDIFgljIV+jMnC+a+U1gz
         0RWspJevuYR0VIXOOxQpaAFPdaKq2dL2YYUnSWRQGSwrves8COarkRDoWx7AMHzmQ+Jf
         hYmA==
X-Gm-Message-State: AOAM532ONeGQVPL3GFGW0Vat8XrfpK/YUwCQZnUdUyfr2pKlrCAGGioA
        ApQYnCtEIDzS76Kjyi7MivDZLTervwFSuz2UgZQ1WU3PHauoDiRJzgfouP3McR5bJVdz170aRJy
        LhA3lH3pyQVNK
X-Received: by 2002:aa7:dace:: with SMTP id x14mr862798eds.300.1611568725549;
        Mon, 25 Jan 2021 01:58:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxQ4gfGMmhFnROhe7nsAtZpVsiUl1zkraUWm/PZk66fih7yway/EpdSqFBNEaVdkT9kgyApew==
X-Received: by 2002:aa7:dace:: with SMTP id x14mr862782eds.300.1611568725435;
        Mon, 25 Jan 2021 01:58:45 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k22sm10408741edv.33.2021.01.25.01.58.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 01:58:44 -0800 (PST)
Subject: Re: [PATCH] KVM: x86/mmu: improve robustness of some functions
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Stephen Zhang <stephenzhangzsd@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com
References: <1611314323-2770-1-git-send-email-stephenzhangzsd@gmail.com>
 <87a6sx4a0l.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <99258705-ff9e-aa0c-ba58-da87df760655@redhat.com>
Date:   Mon, 25 Jan 2021 10:58:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <87a6sx4a0l.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/01/21 10:54, Vitaly Kuznetsov wrote:
> 
> What if we do something like (completely untested):
> 
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index bfc6389edc28..5ec15e4160b1 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -12,7 +12,7 @@
>  extern bool dbg;
>  
>  #define pgprintk(x...) do { if (dbg) printk(x); } while (0)
> -#define rmap_printk(x...) do { if (dbg) printk(x); } while (0)
> +#define rmap_printk(fmt, args...) do { if (dbg) printk("%s: " fmt, __func__, ## args); } while (0)
>  #define MMU_WARN_ON(x) WARN_ON(x)
>  #else
>  #define pgprintk(x...) do { } while (0)
> 
> and eliminate the need to pass '__func__,' explicitly? We can probably
> do the same to pgprintk().

Nice indeed.  Though I wonder if anybody has ever used these.  For those 
that I actually needed in the past I created tracepoints instead.

Paolo

