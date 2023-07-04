Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B93A7471D6
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 14:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbjGDM4V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 08:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjGDM4T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 08:56:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD37F113
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 05:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688475332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yt8OOmF/Qc2FhZfKBFaBIsbOKOzxd5G7Z5ZpCMV+xEY=;
        b=dKXTjrPM2ftoS0QZKeGlSTqZqOzJbd4G7a6iRi5TTnfBHKCgaJ81Amhvfkq0FY9DD+PgMG
        5TIEjQH8xRIElEvgGd1ofLyyczj/TBJHXvoyoQnr83phyjVVhJo1swRpI1dh2qz3odRaVV
        RN/2VBqoZx710Ko9VgeRJSBEl9K/cHo=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-yowfh-H6NneVwStdWE679g-1; Tue, 04 Jul 2023 08:55:30 -0400
X-MC-Unique: yowfh-H6NneVwStdWE679g-1
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-47e6be7cc44so107594e0c.3
        for <kvm@vger.kernel.org>; Tue, 04 Jul 2023 05:55:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688475330; x=1691067330;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yt8OOmF/Qc2FhZfKBFaBIsbOKOzxd5G7Z5ZpCMV+xEY=;
        b=TzDSs/D31K7Jy0iHy8BBvAo93DUGOkT9/HR/iMYecrLvHqPSdUw9OiyAjIjNVZrfsw
         RvGzGY3M+O66jwSuanWAEFynC7BLXOvYTVcY6Nj41/clIcvUpZdwbYCIBUo1t4v/qf22
         8zKUF4/ZEqT0t+dMFjHucRBdUyYnXU2WAF3ycG/maBO7PL7rtL9zdNeTPGC88Wl4RCep
         0W0zx7LZ2kXoCajmhLZHzcEjRgf25wx66ek4CIUriPNMlc0RaOtEkK3LKHkjaltsc3Za
         iwLclBKsJoTrrt8lws+6HGCTfW8omSB4u98AVgsabk6/vZo2VNfuPc/2PKMf1QUlA+zq
         QK9A==
X-Gm-Message-State: ABy/qLbHpQtHNY/oyC6PjNJXFU93Stb+b08I1f6tVgFkNt+1GJ75Flke
        nfkNfmERhr8+gLmgllAX6DvScz735Tfw5c3JawUXw3RHgi5vb0KbGouBdHplqtbUBNZqQwpearG
        W+da8irBIqdt3
X-Received: by 2002:a1f:4343:0:b0:47e:7c7:2ed1 with SMTP id q64-20020a1f4343000000b0047e07c72ed1mr6554954vka.5.1688475330392;
        Tue, 04 Jul 2023 05:55:30 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFNnhvbEPYarzUzZvU9N65kNkodvCxjJsUl6IJ9loWNtsx4o/6nApfANtVIund77GAsHLGHwQ==
X-Received: by 2002:a1f:4343:0:b0:47e:7c7:2ed1 with SMTP id q64-20020a1f4343000000b0047e07c72ed1mr6554946vka.5.1688475330149;
        Tue, 04 Jul 2023 05:55:30 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-179-126.web.vodafone.de. [109.43.179.126])
        by smtp.gmail.com with ESMTPSA id m6-20020a0c9d06000000b0063659410b04sm5027642qvf.107.2023.07.04.05.55.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jul 2023 05:55:29 -0700 (PDT)
Message-ID: <747a5678-6140-a0ca-b08c-841b2ae00802@redhat.com>
Date:   Tue, 4 Jul 2023 14:55:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v21 09/20] machine: adding s390 topology to query-cpu-fast
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
 <20230630091752.67190-10-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230630091752.67190-10-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/06/2023 11.17, Pierre Morel wrote:
> S390x provides two more topology attributes, entitlement and dedication.
> 
> Let's add these CPU attributes to the QAPI command query-cpu-fast.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   qapi/machine.json  | 9 ++++++++-
>   target/s390x/cpu.c | 4 ++++
>   2 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/qapi/machine.json b/qapi/machine.json
> index 08245beea1..a1920cb78d 100644
> --- a/qapi/machine.json
> +++ b/qapi/machine.json
> @@ -56,10 +56,17 @@
>   # Additional information about a virtual S390 CPU
>   #
>   # @cpu-state: the virtual CPU's state
> +# @dedicated: the virtual CPU's dedication (since 8.1)
> +# @entitlement: the virtual CPU's entitlement (since 8.1)
>   #
>   # Since: 2.12
>   ##
> -{ 'struct': 'CpuInfoS390', 'data': { 'cpu-state': 'CpuS390State' } }
> +{ 'struct': 'CpuInfoS390',
> +  'data': { 'cpu-state': 'CpuS390State',
> +            'dedicated': 'bool',
> +            'entitlement': 'CpuS390Entitlement'

Would it make sense to make them optional and only report those if the 
topology feature is enabled?

  Thomas


> +  }
> +}
>   
>   ##
>   # @CpuInfoFast:
> diff --git a/target/s390x/cpu.c b/target/s390x/cpu.c
> index 74405beb51..01938635eb 100644
> --- a/target/s390x/cpu.c
> +++ b/target/s390x/cpu.c
> @@ -146,6 +146,10 @@ static void s390_query_cpu_fast(CPUState *cpu, CpuInfoFast *value)
>       S390CPU *s390_cpu = S390_CPU(cpu);
>   
>       value->u.s390x.cpu_state = s390_cpu->env.cpu_state;
> +#if !defined(CONFIG_USER_ONLY)
> +    value->u.s390x.dedicated = s390_cpu->env.dedicated;
> +    value->u.s390x.entitlement = s390_cpu->env.entitlement;
> +#endif
>   }
>   
>   /* S390CPUClass::reset() */

