Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0A64019E4
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 12:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241967AbhIFKeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 06:34:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32724 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230249AbhIFKeP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 06:34:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630924390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gbgYfPTLlJOQv5aeXOIkWxZpgeJ+lFMDmBB0RWG18OQ=;
        b=Ut7AP6lXme0gubLZ+LRrD1qcJZbftspwN9ULOiDwyhd/ZpJbvMcw8b17zJSVpmBo2zlgr7
        KXJ3Jf6rYXIB0fu0nsYMbUM2Cqqk4kbR9Iw5oLCzwlXupZ41wDqyt12hnAeXOkFolPxoJx
        K54kZ1BYiU/bZHOtqW5D3wLDQ3Po6Gw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-SBnQcGK8M06_duq-d785PA-1; Mon, 06 Sep 2021 06:33:09 -0400
X-MC-Unique: SBnQcGK8M06_duq-d785PA-1
Received: by mail-ej1-f71.google.com with SMTP id m18-20020a170906849200b005c701c9b87cso2152796ejx.8
        for <kvm@vger.kernel.org>; Mon, 06 Sep 2021 03:33:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gbgYfPTLlJOQv5aeXOIkWxZpgeJ+lFMDmBB0RWG18OQ=;
        b=JpsBtqP+CUnrTjKfGAp/XpsRtLD+nBY1qCCs9+V5abg1dEXrDc6LW3L/nXqhvsGJmz
         +rSrxqC/81xtuAVYyJES21halebAp86cnVN/wocY3nDrL0ZjI45B+5P26fS0om1XH7MD
         mMV//jRM2KfUEoYZ/7pwwRxcuHvoPrfGEI0IxjI4OGGkqR+dtH84xT0qRmCQZ5uY2YVW
         2wavmVktLOQU4EN17SkOHWoQrnDGoH93WM0++Bzsbdn7R0dK4WR5YRX3WkOa0LFqNl/E
         +EJRwLaWm9ycCMR3WUKKXYfW2/90WO+JZrlwwzhEHeWx/mcWmwuFNNWyKk8lldEXjMBs
         M8gQ==
X-Gm-Message-State: AOAM5309h9Nw1v0RXl34ReJNRRFEZxFvtg4jyNrHB+TuCL8vdcxp3QYL
        kNJ2ba1KmjpOwxlMYA0dL8sN/UiD1ppG6Fqd6O3XgsLEob4BTHLdi3SZwcG0Z0XwV7wXFTNV09v
        vv3lAD4AiM3EGoxDv1BhdFV/j23+tVZyN3zQIZ4vXYF8pODuBMetUUMk3ppf7YA0Z
X-Received: by 2002:a17:907:9604:: with SMTP id gb4mr13153258ejc.142.1630924388330;
        Mon, 06 Sep 2021 03:33:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxBY2olHo2Ki9RRjv2l/H90deP2aWOgmMa3hYR5ayCqde3Mn92FjTYy/CTAk31/HiEaK4KcQA==
X-Received: by 2002:a17:907:9604:: with SMTP id gb4mr13153226ejc.142.1630924388012;
        Mon, 06 Sep 2021 03:33:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y24sm3662535ejc.80.2021.09.06.03.32.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 03:33:07 -0700 (PDT)
Subject: Re: [PATCH] x86/kvm: Don't enable IRQ when IRQ enabled in kvm_wait
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
References: <20210814035129.154242-1-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0d385f5d-c01f-2193-ee0f-54249ee149e7@redhat.com>
Date:   Mon, 6 Sep 2021 12:32:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210814035129.154242-1-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/08/21 05:51, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> Commit f4e61f0c9add3 ("x86/kvm: Fix broken irq restoration in kvm_wait")
> replaced "local_irq_restore() when IRQ enabled" with "local_irq_enable()
> when IRQ enabled" to suppress a warnning.
> 
> Although there is no similar debugging warnning for doing local_irq_enable()
> when IRQ enabled as doing local_irq_restore() in the same IRQ situation.  But
> doing local_irq_enable() when IRQ enabled is no less broken as doing
> local_irq_restore() and we'd better avoid it.
> 
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
> 
> The original debugging warnning was introduced in commit 997acaf6b4b5
> ("lockdep: report broken irq restoration").  I think a similar debugging
> check and warnning should also be added to "local_irq_enable() when IRQ
> enabled" and even maybe "local_irq_disable() when IRQ disabled" to detect
> something this:
> 
>      | local_irq_save(flags);
>      | local_irq_disable();
>      | local_irq_restore(flags);
>      | local_irq_enable();
> 
> Or even we can do the check in lockdep+TRACE_IRQFLAGS:
> 
> In lockdep_hardirqs_on_prepare(), lockdep_hardirqs_enabled() was checked
> (and exit) before checking DEBUG_LOCKS_WARN_ON(!irqs_disabled()), so lockdep
> can't give any warning for these kind of situations.  If we did the check
> in lockdep, we would have found the problem before, and we don't need
> 997acaf6b4b5.
> 
> Any thought? Mark? Peter?
> 
>   arch/x86/kernel/kvm.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index a26643dc6bd6..b656456c3a94 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -884,10 +884,11 @@ static void kvm_wait(u8 *ptr, u8 val)
>   	} else {
>   		local_irq_disable();
>   
> +		/* safe_halt() will enable IRQ */
>   		if (READ_ONCE(*ptr) == val)
>   			safe_halt();
> -
> -		local_irq_enable();
> +		else
> +			local_irq_enable();
>   	}
>   }
>   
> 

Queued, thanks.

paolo

