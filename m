Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B0E764948
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 09:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbjG0HuA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 03:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbjG0Hta (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 03:49:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF2559E6
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 00:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690443718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jy/+mq+zfjK/pKvOWbWBiTODc1/IxuABqjbbQY71ff4=;
        b=Mw5gLVaOGRKrIWcUMyX85EsCXw9wTdP0XTuYAS+010ieuZMU4fyDNH2xKbl/bGisxoYzd3
        JNdbkPQWIAVhK3V0cvBoSF3QTSmkWkXIM/5UQzhhKTFBgFR6cqBL5Xn59BSy/iFGAp7mDw
        DYD+Hcbq6f784OIobMOGuajOVydmtBA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-Iosj9o5xOoCUUkzvcF1ypw-1; Thu, 27 Jul 2023 03:41:54 -0400
X-MC-Unique: Iosj9o5xOoCUUkzvcF1ypw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-314275b653eso342881f8f.1
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 00:41:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690443713; x=1691048513;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jy/+mq+zfjK/pKvOWbWBiTODc1/IxuABqjbbQY71ff4=;
        b=fGmtKj6v7k7fn2pwnot+WtkDWbti0tEqHrLSEP4GwaUtcxWWY5XaPc7O93xn9jqmjZ
         HE4E+o3sWgIaucyu3XUEZLe8QEVI/PEPAiENrIj60YIvIV6EJBLEE8gvXQgBaK3AN84s
         QCeUQx4gnJUGQ8zShfmFduAaH4hs8enptFlR78noeOYSfFZG5Y/ck2cKCNeq2P6vsO1Y
         ARB+9JSLe0e9Cjyf8+4J6AIIQ9IfY+0IGMyRCQuC+StGFI+yrl2ZkRQGhJj1IxkyBqNz
         CJbGM5Ei5iAtvQsr2mMeL9b/tDlliyKbSgMR12/EbJKlL/WxqBCQ0FyWq+b/1rsr5992
         T1UQ==
X-Gm-Message-State: ABy/qLYxlTH2YSU+gYpHPCtQnvkAHCnsVpzHN6btG6G0RmB7waYVG6lZ
        Cv3D0q/aAbM5BVBdooLzmQHFpw0eVcNmG3NQNS9xhnYpQg7UR9H5II/UAK8el58zroGG5eRkAXg
        D9730Z1GroZQF
X-Received: by 2002:adf:dd41:0:b0:315:a1bb:4d7b with SMTP id u1-20020adfdd41000000b00315a1bb4d7bmr975348wrm.35.1690443712956;
        Thu, 27 Jul 2023 00:41:52 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEWj6NWYz1V9DJZLTZS9vAF5zYV3B2QrEgtuXaicBFHgTO/JTDXFGo+ljlnKmZ0pNiQioKi9Q==
X-Received: by 2002:adf:dd41:0:b0:315:a1bb:4d7b with SMTP id u1-20020adfdd41000000b00315a1bb4d7bmr975337wrm.35.1690443712607;
        Thu, 27 Jul 2023 00:41:52 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id n1-20020a5d4c41000000b00314374145e0sm1177528wrt.67.2023.07.27.00.41.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jul 2023 00:41:52 -0700 (PDT)
Message-ID: <6f8951e2-9ea6-5bad-9c2c-b27d70d57ffe@redhat.com>
Date:   Thu, 27 Jul 2023 09:41:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 2/2] KVM: s390: add tracepoint in gmap notifier
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230510121822.546629-1-nrb@linux.ibm.com>
 <20230510121822.546629-3-nrb@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230510121822.546629-3-nrb@linux.ibm.com>
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

On 10.05.23 14:18, Nico Boehr wrote:
> The gmap notifier is called for changes in table entries with the
> notifier bit set. To diagnose performance issues, it can be useful to
> see what causes certain changes in the gmap.
> 
> Hence, add a tracepoint in the gmap notifier.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   arch/s390/kvm/kvm-s390.c   |  2 ++
>   arch/s390/kvm/trace-s390.h | 23 +++++++++++++++++++++++
>   2 files changed, 25 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index ded4149e145b..e8476c023b07 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3982,6 +3982,8 @@ static void kvm_gmap_notifier(struct gmap *gmap, unsigned long start,
>   	unsigned long prefix;
>   	unsigned long i;
>   
> +	trace_kvm_s390_gmap_notifier(start, end, gmap_is_shadow(gmap));
> +
>   	if (gmap_is_shadow(gmap))
>   		return;
>   	if (start >= 1UL << 31)
> diff --git a/arch/s390/kvm/trace-s390.h b/arch/s390/kvm/trace-s390.h
> index 6f0209d45164..5dabd0b64d6e 100644
> --- a/arch/s390/kvm/trace-s390.h
> +++ b/arch/s390/kvm/trace-s390.h
> @@ -333,6 +333,29 @@ TRACE_EVENT(kvm_s390_airq_suppressed,
>   		      __entry->id, __entry->isc)
>   	);
>   
> +/*
> + * Trace point for gmap notifier calls.
> + */
> +TRACE_EVENT(kvm_s390_gmap_notifier,
> +		TP_PROTO(unsigned long start, unsigned long end, unsigned int shadow),
> +		TP_ARGS(start, end, shadow),
> +
> +		TP_STRUCT__entry(
> +			__field(unsigned long, start)
> +			__field(unsigned long, end)
> +			__field(unsigned int, shadow)
> +			),
> +
> +		TP_fast_assign(
> +			__entry->start = start;
> +			__entry->end = end;
> +			__entry->shadow = shadow;
> +			),
> +
> +		TP_printk("gmap notified (start:0x%lx end:0x%lx shadow:%d)",
> +			__entry->start, __entry->end, __entry->shadow)
> +	);
> +
>   
>   #endif /* _TRACE_KVMS390_H */
>   

In the context of vsie, I'd have thought you'd be tracing 
kvm_s390_vsie_gmap_notifier() instead.

This should work as well, as all notifier are called.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb

