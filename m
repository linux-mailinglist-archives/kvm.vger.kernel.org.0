Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFB8709E70
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 19:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjESRnl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 13:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjESRnj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 13:43:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E45F9
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 10:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684518173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rI/nokJy7Co9+EJrT1AwU9SSa4RbfcrZJoLtKk3W6aM=;
        b=MHZ0iAT/7eY13UPWTd+0BkB5WUSqH4jTPYbHM926o4UbVrnImc//kGztAsYzxVzUY/3X7v
        GColTGTWNBUJWnuqcbuLnzkdD/eD0HPxpZJaOmyiDZIuPZGOaHWoIqGFt5UxB/KFx08pXZ
        Jr0jY2YGMfwIO3uDVoGchj9D6lqu4Vw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-424-tLzYBNaWMu2gXcE9w_Scew-1; Fri, 19 May 2023 13:42:52 -0400
X-MC-Unique: tLzYBNaWMu2gXcE9w_Scew-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-94a355c9028so448565566b.3
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 10:42:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684518171; x=1687110171;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rI/nokJy7Co9+EJrT1AwU9SSa4RbfcrZJoLtKk3W6aM=;
        b=Z4azDL0aiwX4kI8aPAPSiM7LZ95je0u7Q/SWR1Yz9iI9DtTGhT2vWAvy+DBufFhMMw
         7Rss/gSNet4ReKx27XvjgI3UFvJ4TDh5GpFpMOdgUKGD3prsM1vHFnb3ImLJll4O2WeA
         4AMmYX4LjdQ+1jh6dYYbrpL5MF1BHyYBAeHMPdqNzCeVGR4SSVTCrxHzaoqs57ySNm8/
         +eEvV6a0PoIBRvF/fzsvDeFGvtavrapNUfwIlbkGUg6HvI9aZGfNR3RxX5UfR5pRMHqz
         7ijM1YW/uPmqE5bDo9hu1Fs09phAsCAfZg5mmZKUxgTwNOfrfZcFZI5GHuUWPzWUIfMW
         XNRw==
X-Gm-Message-State: AC+VfDwTcu05tZZ3Gbp4/ECZgM7nLThkO20UTRaQeedgZZhGsK9oWXpd
        AhvcGGzzNSuC6GlIkE0pZW0hlwZcT97yAzb6ZjTbDAIO+eR/G5VOXEqyKoVV6NRvcxSP7Q3cX1L
        OHGtFB6PeVQxRuU6JzE4F
X-Received: by 2002:a17:907:749:b0:966:3310:50ae with SMTP id xc9-20020a170907074900b00966331050aemr2100708ejb.47.1684518171081;
        Fri, 19 May 2023 10:42:51 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6ZjbIGJQq2HH1XRZWOBlCsKYuk0Cctnr1hyRjJzs4jxkYHYPWKWbGf37J46eLAihVg/CHCjA==
X-Received: by 2002:a17:907:749:b0:966:3310:50ae with SMTP id xc9-20020a170907074900b00966331050aemr2100693ejb.47.1684518170733;
        Fri, 19 May 2023 10:42:50 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id ju7-20020a17090798a700b00965c7c93655sm2513285ejc.213.2023.05.19.10.42.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 May 2023 10:42:50 -0700 (PDT)
Message-ID: <9810219f-342b-9537-9d9a-2c3e28fd86de@redhat.com>
Date:   Fri, 19 May 2023 19:42:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] KVM: VMX: Fix header file dependency of asm/vmx.h
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Jacob Xu <jacobhxu@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <20220225012959.1554168-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220225012959.1554168-1-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/25/22 02:29, Jim Mattson wrote:
> From: Jacob Xu <jacobhxu@google.com>
> 
> Include a definition of WARN_ON_ONCE() before using it.
> 
> Fixes: bb1fcc70d98f ("KVM: nVMX: Allow L1 to use 5-level page walks for nested EPT")
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Jacob Xu <jacobhxu@google.com>
> [reworded commit message; changed <asm/bug.h> to <linux/bug.h>]
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>   arch/x86/include/asm/vmx.h | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 0ffaa3156a4e..447b97296400 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -14,6 +14,7 @@
>   
>   #include <linux/bitops.h>
>   #include <linux/types.h>
> +#include <linux/bug.h>
>   #include <uapi/asm/vmx.h>
>   #include <asm/vmxfeatures.h>
>   

Queued, thanks.

Paolo

