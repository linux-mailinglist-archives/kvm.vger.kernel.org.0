Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EACDD34E9C
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 19:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfFDRUg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 13:20:36 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34415 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbfFDRUg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 13:20:36 -0400
Received: by mail-wr1-f66.google.com with SMTP id e16so8427562wrn.1
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2019 10:20:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MIeQ1hRc5hTWO/6y4ou8VBIQoDTI2KJ3dAfbqfPHsRY=;
        b=ZoRzh5QpyKrke9jT8Ls8LbRqFvymXJBr9F8huNHqjqYiT0dKKVVMt5ZUj2u6ceg4D3
         KyfzvuowmB+9FikAF578tHxCEUBtALgMljrUuVCLHeZOvuQQJ3sNy5h+EPqsXScdnQf0
         0lMJsYpYF4UCZTWKihw+CHAZIKLeZgjCHvBpgUEa4Io4bYTvc4u/aPBW/eA+qKsT5Edt
         aGcibB4uTuqf8j5Fl6oiiQbrX9SPJ2eG6VmO7PUXhoDB1lE8GlFgxV9t6srtlpb1fk59
         47FN3NMyY0U0kUsZzIejbYAs3/7xfz0v6XDmK8HAeMyALLZ4v0CYcuWz+6bdZbnFsUn2
         qP7g==
X-Gm-Message-State: APjAAAXMUwQ/u1aMB+wvG7T/dm20ITVrfB6pgq4C6ko7LAcQFlvwAR9r
        LatVLt2zC+FdFVsbiurdSNdiHw==
X-Google-Smtp-Source: APXvYqyCLCR9Tut/3XbRV2YRnUp9dQfHLcpQpwQKSuwwLKbot5ERpIMPqcoGXXa6IR6L1BCFAthjmg==
X-Received: by 2002:adf:ea87:: with SMTP id s7mr19107229wrm.24.1559668835069;
        Tue, 04 Jun 2019 10:20:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id e13sm21770174wra.16.2019.06.04.10.20.34
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:20:34 -0700 (PDT)
Subject: Re: [PATCH] KVM: irqchip: Use struct_size() in kzalloc()
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190531192453.GA13536@embeddedor>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0bc61102-47c6-5df3-aa2d-1f7ec91214c1@redhat.com>
Date:   Tue, 4 Jun 2019 19:20:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190531192453.GA13536@embeddedor>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/05/19 21:24, Gustavo A. R. Silva wrote:
> One of the more common cases of allocation size calculations is finding
> the size of a structure that has a zero-sized array at the end, along
> with memory for some number of elements for that array. For example:
> 
> struct foo {
>    int stuff;
>    struct boo entry[];
> };
> 
> instance = kzalloc(sizeof(struct foo) + count * sizeof(struct boo), GFP_KERNEL);
> 
> Instead of leaving these open-coded and prone to type mistakes, we can
> now use the new struct_size() helper:
> 
> instance = kzalloc(struct_size(instance, entry, count), GFP_KERNEL);
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  virt/kvm/irqchip.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
> index 79e59e4fa3dc..f8be6a3d1aa6 100644
> --- a/virt/kvm/irqchip.c
> +++ b/virt/kvm/irqchip.c
> @@ -196,9 +196,7 @@ int kvm_set_irq_routing(struct kvm *kvm,
>  
>  	nr_rt_entries += 1;
>  
> -	new = kzalloc(sizeof(*new) + (nr_rt_entries * sizeof(struct hlist_head)),
> -		      GFP_KERNEL_ACCOUNT);
> -
> +	new = kzalloc(struct_size(new, map, nr_rt_entries), GFP_KERNEL_ACCOUNT);
>  	if (!new)
>  		return -ENOMEM;
>  
> 

Queued, thanks.

Paolo
