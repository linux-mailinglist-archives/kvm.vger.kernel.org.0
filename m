Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25AC12CEA26
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 09:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgLDItd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 03:49:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54975 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726037AbgLDItc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Dec 2020 03:49:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607071685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6MMxa7zrFLtOLXox2hJ/V5Hrw06U6BAmIekgZQ7GgTk=;
        b=T8NHDSTs7E7P0I+1wMEZoT+sBO2NUsrJdY6rxT8/Fgvfv75Gkke9AQgSzyK5bSmipOPmhd
        5EFdd0Hx/ikmyU68SmVYM/+Yho2uqJLgKqO3bYx+wLHUpWFAtO8nqRC7kdtEvtOnCIwZMK
        8cS11L2ndKVAYPeKexVFLTUOdrEynuU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-IyZK54icM8uuxyHYofOncg-1; Fri, 04 Dec 2020 03:48:04 -0500
X-MC-Unique: IyZK54icM8uuxyHYofOncg-1
Received: by mail-ed1-f70.google.com with SMTP id f19so2063360edq.20
        for <kvm@vger.kernel.org>; Fri, 04 Dec 2020 00:48:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6MMxa7zrFLtOLXox2hJ/V5Hrw06U6BAmIekgZQ7GgTk=;
        b=SyWnYKZ0vgB9ThVrAt3hURzKAMntm0fvM+GAbS/1iy2/um0+G08gQI2hBt7yNXpDcK
         r/GG2nkTdlQaAyUGv1qabLiqyfAkULYkzLc/EhBfc+EHLIU1D/1fG8SBlxCBoFmds56l
         0W4sl7izNsRzRIpy+OTQGfScZ/wd8IETNYoGOUk0zjnVFV0iKCB9Oi2Jqy3Zn06IBKbd
         2aSkTq0kt04BIyILmyFEMY8o+kOyzN4iOZbj3nbjIKfL2PLUP7b791ySWyGGUafLhRRR
         Ohsr+AYHAttt2Pn8Ey8ZkoYPmSgXkBoLJhbobf8jTHkM3UGIhmG0LbpJ9xmsr8/WPG/p
         F/6Q==
X-Gm-Message-State: AOAM531oAprAXMv0KIlY5G3gzLjAuMZcX4/Tdhv/FBut9KgE2FenrP6M
        B8HzTVowOUpfb+TFjdnF3vNmTvZyCa43RQwCzUuoY3mfX0SGoMvkCukceCTHHkag0uS5gD1olEW
        PCy2nVhMitQsj
X-Received: by 2002:a17:906:2581:: with SMTP id m1mr6027362ejb.28.1607071682915;
        Fri, 04 Dec 2020 00:48:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyHFC+QWHXMUIE0IdFj/TFJAFBO6+tV1sGQBp5HVgsqZMLkL55A9lpIaom+F3ndTLLtMnGX+w==
X-Received: by 2002:a17:906:2581:: with SMTP id m1mr6027348ejb.28.1607071682694;
        Fri, 04 Dec 2020 00:48:02 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y6sm2588259ejl.15.2020.12.04.00.48.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 00:48:01 -0800 (PST)
Subject: Re: [PATCH] kvm: svm: de-allocate svm_cpu_data for all cpus in
 svm_cpu_uninit()
To:     Jacob Xu <jacobhxu@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201203205939.1783969-1-jacobhxu@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e5a132a0-4085-a5d5-eca9-d054f5375afd@redhat.com>
Date:   Fri, 4 Dec 2020 09:47:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201203205939.1783969-1-jacobhxu@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/12/20 21:59, Jacob Xu wrote:
> The cpu arg for svm_cpu_uninit() was previously ignored resulting in the
> per cpu structure svm_cpu_data not being de-allocated for all cpus.
> 
> Signed-off-by: Jacob Xu <jacobhxu@google.com>
> ---
>   arch/x86/kvm/svm/svm.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 79b3a564f1c9..da7eb4aaf44f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -530,12 +530,12 @@ static int svm_hardware_enable(void)
>   
>   static void svm_cpu_uninit(int cpu)
>   {
> -	struct svm_cpu_data *sd = per_cpu(svm_data, raw_smp_processor_id());
> +	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
>   
>   	if (!sd)
>   		return;
>   
> -	per_cpu(svm_data, raw_smp_processor_id()) = NULL;
> +	per_cpu(svm_data, cpu) = NULL;
>   	kfree(sd->sev_vmcbs);
>   	__free_page(sd->save_area);
>   	kfree(sd);
> 

Queued, thanks.

Paolo

