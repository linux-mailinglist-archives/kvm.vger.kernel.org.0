Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1DF209D58
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 13:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404190AbgFYLPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 07:15:25 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21109 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404130AbgFYLPY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jun 2020 07:15:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593083723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8+cW2+MtWtr9r3SNwjSJmA7OT1dWutgD2FYAWJa7i9k=;
        b=fZdEm0A18VVy76yrr5n8c2iDfZwxpG+EmQ5vGDM3mkD73+nThc1wXdc+B7TpTvxsPD6sl4
        oiElBa3FocbolD85qzZXMoaUgeTcBkYPdSmrL0aAE92tEd2TvA1z2qTNJzXQV09rJ3Y5RE
        zB+9wKUtaN70GYwazDraQwRhwoqXFYw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-5Bq8PA7tMQGbQOj469bWZA-1; Thu, 25 Jun 2020 07:15:21 -0400
X-MC-Unique: 5Bq8PA7tMQGbQOj469bWZA-1
Received: by mail-wr1-f70.google.com with SMTP id e11so6627602wrs.2
        for <kvm@vger.kernel.org>; Thu, 25 Jun 2020 04:15:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8+cW2+MtWtr9r3SNwjSJmA7OT1dWutgD2FYAWJa7i9k=;
        b=M0qn76iITJ2xWrcL+dYKnlIgH3q9tDmwNuN4/aD3AXOPriOO8LjesOZm+0vSPxqR6y
         KxPOrb7ANy4Ma1eQxwrH9K6Zb10hc31rY7plWjkhcI+kf5fRbYjz/qSgKg5wDXGvVvoa
         IaH/3YPXw73L5HSnUwtFjjnLlA3EleyxMHVmRsdHhnpWO0aozcpt+5CiB29RfoitRfYY
         dSZE8tEPi0OwnG5ms8S1aQlRxqY4sFdO3raO0eKXnUHwjLBdWrM0TuBG/1d8cZMQlwef
         TOX/Umfpu/86yb76ZB9AzdONIXl3EreWpQAxroG8hwJ/0QKlgHhG6Q9sqq9SqRN1DJnu
         BDIQ==
X-Gm-Message-State: AOAM532dYDlGlteo8l/La0wJrzRJY9GZZmj1F3qNAKjq/+VVTB5uPjkw
        dTjRgwsJvVw6LUg8yPqmqIZKe3uk/uOahyWmlS5tIft3fmDUWaRB7WvMpdF5tYC0O9BoXCNA43J
        4T52Db/mFa2Yk
X-Received: by 2002:adf:eccd:: with SMTP id s13mr16092933wro.217.1593083720656;
        Thu, 25 Jun 2020 04:15:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2c/bxLNgPQz9DJ1tXKpGa+zR89BxeA1aoV++VWuhG2NvxgaMcKxmc27yype91FI381N7lMQ==
X-Received: by 2002:adf:eccd:: with SMTP id s13mr16092911wro.217.1593083720424;
        Thu, 25 Jun 2020 04:15:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:91d0:a5f0:9f34:4d80? ([2001:b07:6468:f312:91d0:a5f0:9f34:4d80])
        by smtp.gmail.com with ESMTPSA id d63sm12502520wmc.22.2020.06.25.04.15.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 04:15:19 -0700 (PDT)
Subject: Re: [PATCH] x86: fix smp_stacktop on 32-bit
To:     Nadav Amit <namit@vmware.com>
Cc:     kvm@vger.kernel.org
References: <20200624203602.44659-1-namit@vmware.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9cb6568a-88cc-d768-486f-c5bd6ff2fed3@redhat.com>
Date:   Thu, 25 Jun 2020 13:15:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200624203602.44659-1-namit@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/20 22:36, Nadav Amit wrote:
> smp_stacktop in 32-bit is fixed to some magic address. Use the address
> of the memory that was reserved for the stack instead.
> 
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  x86/cstart.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/x86/cstart.S b/x86/cstart.S
> index 1d8b8ac..a072aed 100644
> --- a/x86/cstart.S
> +++ b/x86/cstart.S
> @@ -134,7 +134,7 @@ prepare_32:
>  	mov %eax, %cr0
>  	ret
>  
> -smp_stacktop:	.long 0xa0000
> +smp_stacktop:	.long stacktop - 4096
>  
>  save_id:
>  	movl $(APIC_DEFAULT_PHYS_BASE + APIC_ID), %eax
> 

This uncovers a latent bug for which I've just sent a patch ("x86: fix
stack pointer after call").

Paolo

