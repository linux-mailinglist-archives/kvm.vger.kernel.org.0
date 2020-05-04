Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CCA1C40A6
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 19:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729776AbgEDRAJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 13:00:09 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33746 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729540AbgEDRAJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 13:00:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588611608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T5ofgZ5+dv6kvzg6y8qAYvtHj1yOL06CYyaplh6HCPI=;
        b=TiA80AzvapkTObw96l/+0IhRii5ES9/H39kQC3eE0ZtXHpiZ5dfipv9n6MW9NL7u7Ex7BR
        0On8TinStg7uush96npPAR+pHpodB97KLluaVVNnsLUiyykxAdfobZbTIubOUoNXuTLOgx
        l0X5FjlpsZXVdZW2EaZAtbDY7JXOJK8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-HtgPs4HDPrGwG-CSPAREyA-1; Mon, 04 May 2020 12:59:56 -0400
X-MC-Unique: HtgPs4HDPrGwG-CSPAREyA-1
Received: by mail-wr1-f71.google.com with SMTP id q13so11682wrn.14
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 09:59:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T5ofgZ5+dv6kvzg6y8qAYvtHj1yOL06CYyaplh6HCPI=;
        b=JfpOvHHj6fbuG7bVCGnHGAlEwxRf6vZ+fC7zFeYnu21LFerY8MiDVdOF42d88FzfZ5
         HH8OljYNbq6kcK4L2wOtfzDLN+YLTzEbaQJNKbU6Sbq4frkY/oWSBdWmS5v0zARD6qOG
         VSdaW2k51KlFaSIUWMqS4p6Bqm7gjB7saJrt+2zQ7o3nNYG5YrVEuNLSuuTAy572yZGE
         lHnFy8wmQYXjkbIOynpa1b7udwz9Hx6NfGTbN7C53FR5oMB/Nz/Y92BH1uX+2WM3hVc2
         KteLvTIgeFk6FnqZS9zEo4rqEkaoFtjXmNggZtOPTrXEz96Sby/t7QB76UrEZ/C6RLuS
         Ty2A==
X-Gm-Message-State: AGi0PuacId9rSAIVEMrmFp97A0vQzfRUGSyJ32I0BQGFpUL0yirRAVOa
        YHzPeIiUHEs9kAYsJ9IO62zPcS1L+owO+bGnsuQyjOzicc7o/EeYfuDFpci2iJuOcKDm8wV435v
        WNymQWpyt1Y8I
X-Received: by 2002:adf:9447:: with SMTP id 65mr8663890wrq.331.1588611595430;
        Mon, 04 May 2020 09:59:55 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ+KIAi0eC0xc/MKvOmRj5G3YFr3fTwZrqCcx5ZM71qDGqxJYRhwafgE0Ns5QUMpNxOJyP2VA==
X-Received: by 2002:adf:9447:: with SMTP id 65mr8663867wrq.331.1588611595221;
        Mon, 04 May 2020 09:59:55 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id y9sm23390wmm.26.2020.05.04.09.59.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 09:59:54 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: Sanity check on gfn before removal
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200416155910.267514-1-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <62c1d747-aca3-fc9e-f4a5-8a147012ded5@redhat.com>
Date:   Mon, 4 May 2020 18:59:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200416155910.267514-1-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/04/20 17:59, Peter Xu wrote:
> The index returned by kvm_async_pf_gfn_slot() will be removed when an
> async pf gfn is going to be removed.  However kvm_async_pf_gfn_slot()
> is not reliable in that it can return the last key it loops over even
> if the gfn is not found in the async gfn array.  It should never
> happen, but it's still better to sanity check against that to make
> sure no unexpected gfn will be removed.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fc74dafa72ff..f1c6e604dd12 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10308,6 +10308,10 @@ static void kvm_del_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
>  	u32 i, j, k;
>  
>  	i = j = kvm_async_pf_gfn_slot(vcpu, gfn);
> +
> +	if (WARN_ON_ONCE(vcpu->arch.apf.gfns[i] != gfn))
> +		return;
> +
>  	while (true) {
>  		vcpu->arch.apf.gfns[i] = ~0;
>  		do {
> 

Queued, thanks.

Paolo

