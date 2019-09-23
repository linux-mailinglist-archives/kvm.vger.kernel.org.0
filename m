Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4FB0BB21A
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 12:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404970AbfIWKTP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 06:19:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49576 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727143AbfIWKTP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 06:19:15 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 310DE80F6D
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 10:19:15 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id 32so4621116wrk.15
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 03:19:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nAyRQH3H07FmS67tnT6hsF/Qfh+8LuStTKrVaQ9zhw8=;
        b=N8of3f4Bbs+kwMu7AI6sthfzEgwZJPKUEOuLOdaU55V/kCoqNtPMv2t7FRl0ZVBTrL
         /OF4nECXtABixZ7yLkYIhIXpcDcKPPDb0fxo99QrTtWysTovfcA8kybXZ/g5cVqt8II0
         17rX30Vwuyk7ktgC4Nl87MEXQLMglFmTDLQuG5cstYMt9oHwTP4RajSGPozPJMmwWjb9
         AqMLDtFhJ63wqWzmRVsSp/zmEpwTTzuplfdkvtPHZ4hI0sZovP4NL1fPjdQmmRLrHdyp
         hjlEhqlGtqwjlp+REhgyrbCGlDfdTzJWVcBZHAVcbs8RxeiBa9W29VPhqoE533VJR9N7
         2UtA==
X-Gm-Message-State: APjAAAVP2ISIBEzCsc/8oFEx2fJCB+VfcCwMVZIQPim9ydcIQnG+qxJi
        aOroZlUTpgsb3/apmvH7GkKh6oMt6B9cw9u/EmzOnQ3TPO1k3TJqRhIlIq3bxj6OTCIXRcjb6O/
        swjVld5RGUHRo
X-Received: by 2002:a5d:458b:: with SMTP id p11mr905174wrq.160.1569233953899;
        Mon, 23 Sep 2019 03:19:13 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwmjLwnJ4DSwFegz6v4hMA/TVeGpRaJTbLpRqq1I+EuABUIXRx+oS++kj9174kVqcS9ORfEpQ==
X-Received: by 2002:a5d:458b:: with SMTP id p11mr905161wrq.160.1569233953665;
        Mon, 23 Sep 2019 03:19:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id s9sm10669778wme.36.2019.09.23.03.19.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2019 03:19:13 -0700 (PDT)
Subject: Re: [PATCH 14/17] KVM: monolithic: x86: inline more exit handlers in
 vmx.c
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-15-aarcange@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <6a1d66a1-74c0-25b9-692f-8875e33b2fae@redhat.com>
Date:   Mon, 23 Sep 2019 12:19:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920212509.2578-15-aarcange@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/09/19 23:25, Andrea Arcangeli wrote:
> They can be called directly more efficiently, so we can as well mark
> some of them inline in case gcc doesn't decide to inline them.

What is the output of size(1) before and after?

Paolo

> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ff46008dc514..a6e597025011 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4588,7 +4588,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -static int handle_external_interrupt(struct kvm_vcpu *vcpu)
> +static __always_inline int handle_external_interrupt(struct kvm_vcpu *vcpu)
>  {
>  	++vcpu->stat.irq_exits;
>  	return 1;
> @@ -4860,7 +4860,7 @@ static void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
>  	vmcs_writel(GUEST_DR7, val);
>  }
>  
> -static int handle_cpuid(struct kvm_vcpu *vcpu)
> +static __always_inline int handle_cpuid(struct kvm_vcpu *vcpu)
>  {
>  	return kvm_emulate_cpuid(vcpu);
>  }
> @@ -4891,7 +4891,7 @@ static int handle_interrupt_window(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> -static int handle_halt(struct kvm_vcpu *vcpu)
> +static __always_inline int handle_halt(struct kvm_vcpu *vcpu)
>  {
>  	return kvm_emulate_halt(vcpu);
>  }
> 

