Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F13C866716D
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 12:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjALL6B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 06:58:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234347AbjALL50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 06:57:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27A712AC1
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 03:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673524116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=95wirmsHPNLLbdZPpOsP86iH4u3HKnqBlT4iNwBlJFg=;
        b=JrySaZOoQ0p8Hp8YQqyVDhM3xJzQoP3U4SqBUJi+X5OqNl6LLZIYihe7Lcuvwey2KTe1aa
        mK53It9XkykME5F29dg15L/w6cXh58EUMA0NW9uSdhznmhJay61eAjzVkDJ4BXDAaf43eX
        ANElwNtbwVPsyJWZan2sWKtSyMeeAjw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-590-fS2G8hpzOTuMwdPWtrw-PA-1; Thu, 12 Jan 2023 06:48:34 -0500
X-MC-Unique: fS2G8hpzOTuMwdPWtrw-PA-1
Received: by mail-wm1-f70.google.com with SMTP id fm25-20020a05600c0c1900b003d9702a11e5so9192485wmb.0
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 03:48:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=95wirmsHPNLLbdZPpOsP86iH4u3HKnqBlT4iNwBlJFg=;
        b=ULitaNTNrP7HhXzCBRs8T8dgxbZReH72KSVbLTR7sUFFfsh9YeXqUwShZoDf+YItNB
         s0Gzda1jkRfLN7gK6yAhrsQ6kKRl9c+UR1Z7EH8Y0rkir/675c6eax5zdpfG3P4gSrs1
         QEF7GTiEBn3jChVzyKCAbH/qcmf6FDJk9pddhT0W5sy1uR8ncHXDKxSoOWQDt6ITLU19
         FmWTx83oSdSXjBa8hiLmyjvUOI7Dp8ixmmZ96xSHzGvMkBwmjBb9iDq5Ulg6aZ3krSkW
         /FRB1bWU1g1/p5iA+S8GaQSS9/VThFtMy/i5pfDSzl+GqCt0N7+BYGD8ac1z/uXVvu/Y
         vW1A==
X-Gm-Message-State: AFqh2kqjlp3zzgf1V6AC9uUMihaCefpka//Sv+xJbmI9x30tGxJkLrAK
        iNJD8z/n8uJ497srQ+K+1SC0Moj8lmwgKv3lYtqDO/gEsRygqNUc997BDqlk0cK1+AnjlcMzCh4
        G3VqfE5HxEUDC
X-Received: by 2002:adf:f54d:0:b0:2bd:d85f:55cc with SMTP id j13-20020adff54d000000b002bdd85f55ccmr701160wrp.21.1673524113645;
        Thu, 12 Jan 2023 03:48:33 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvhTydT0YQCeqNRn5lCauk6pIfwvuPGowd6nXpLB1XwLEKM3f34e1P9ULgoySauUSE9CxhU7w==
X-Received: by 2002:adf:f54d:0:b0:2bd:d85f:55cc with SMTP id j13-20020adff54d000000b002bdd85f55ccmr701143wrp.21.1673524113406;
        Thu, 12 Jan 2023 03:48:33 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-177-128.web.vodafone.de. [109.43.177.128])
        by smtp.gmail.com with ESMTPSA id y7-20020a7bcd87000000b003d997e5e679sm24380280wmj.14.2023.01.12.03.48.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 03:48:32 -0800 (PST)
Message-ID: <114b34b1-303b-154b-6ac1-91e1718de49b@redhat.com>
Date:   Thu, 12 Jan 2023 12:48:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v14 09/11] qapi/s390/cpu topology: monitor query topology
 information
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-10-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230105145313.168489-10-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/01/2023 15.53, Pierre Morel wrote:
> Reporting the current topology informations to the admin through
> the QEMU monitor.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
...
> diff --git a/hmp-commands-info.hx b/hmp-commands-info.hx
> index 754b1e8408..5730a47f71 100644
> --- a/hmp-commands-info.hx
> +++ b/hmp-commands-info.hx
> @@ -993,3 +993,19 @@ SRST
>     ``info virtio-queue-element`` *path* *queue* [*index*]
>       Display element of a given virtio queue
>   ERST
> +
> +#if defined(TARGET_S390X) && defined(CONFIG_KVM)
> +    {
> +        .name       = "query-topology",
> +        .args_type  = "",
> +        .params     = "",
> +        .help       = "Show information about CPU topology",
> +        .cmd        = hmp_query_topology,
> +        .flags      = "p",
> +    },
> +
> +SRST
> +  ``info query-topology``

"info query-topology" sounds weird ... I'd maybe rather call it only "info 
topology" or "info cpu-topology" here.

  Thomas


> +    Show information about CPU topology
> +ERST
> +#endif

