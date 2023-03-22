Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14CB96C497B
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 12:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjCVLqD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 07:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbjCVLpy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 07:45:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22A62366E
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 04:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679485510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EGY3txy78KciG2pIM8V6D2wAg4dR0OW/SD5ifs6Nnsk=;
        b=QSzVFmafFrb/4DUz40494099LUick3+7+H4WhWApMI7va3h2a1YG37rEwY8ETMpOJbIBW5
        60vwzc53ig5NrgQpUcSzd4zWwixhWzqt/oK3q2QQFBt9oqX8Xxo02//c+xzl4X4ayS+0GZ
        DnJvalE8rIkbnYzPPviXPmwcuMHJgsQ=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-1ZJSo46ZOBqXaTXR5ut8Lg-1; Wed, 22 Mar 2023 07:45:07 -0400
X-MC-Unique: 1ZJSo46ZOBqXaTXR5ut8Lg-1
Received: by mail-qt1-f199.google.com with SMTP id u1-20020a05622a198100b003e12a0467easo5638600qtc.11
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 04:45:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679485507;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EGY3txy78KciG2pIM8V6D2wAg4dR0OW/SD5ifs6Nnsk=;
        b=MRVc30wA+TBU+4Lb3RcB1GcvaVMaKEZnQLH4T1BN8ZH90UAO3R7+AbOkU4H43HtVuR
         7Xb4qpvagzSUuJCi71BGvqCME7yPp014XTUQ7UalklbZbjhJOj2FRtgBkFSQ5gGsGoey
         3fZJ/Vwj+ZV/QzlF9C6wzrvXJiHwaIaRko3VIk3n5hi5flrQ20fNCFxx7Ye8kRz6fQmN
         +Pqwhh8aLM7sC1EFkJiOAKKmnWqk3T/6kk0PLZ9L38SIHrN1dRtI7N0fBoL5U1lEjyTf
         OYFwicuxP7dSU5Oh2gEzENQuNseuBZYCmrIeUbYjYMKF48LPUwL5JIXlyPNPRIp1pRH8
         v3RA==
X-Gm-Message-State: AO0yUKW5fkNTtnFK0/GPl8/tQNN/4GGLDH34u0E8QFMPkN+W+d7KgNrt
        /aQv2j7qSSjHTRH9CUWzaGsINH5gftpdiv3QQ6WkxbIN0cekd9jfilTt7cPWPkBDsXpeDi5FoBJ
        p2G1e3uD2I42X
X-Received: by 2002:a05:622a:650:b0:3d7:b045:d39 with SMTP id a16-20020a05622a065000b003d7b0450d39mr4783499qtb.62.1679485507276;
        Wed, 22 Mar 2023 04:45:07 -0700 (PDT)
X-Google-Smtp-Source: AK7set/9ammCAP/s6lM4g8oRLriEtKlDgmHY2HuKKh3qD8fiIJlW+lvwd/fjxxh9mkVIGhgBQRZD/Q==
X-Received: by 2002:a05:622a:650:b0:3d7:b045:d39 with SMTP id a16-20020a05622a065000b003d7b0450d39mr4783474qtb.62.1679485507046;
        Wed, 22 Mar 2023 04:45:07 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-177-44.web.vodafone.de. [109.43.177.44])
        by smtp.gmail.com with ESMTPSA id 139-20020a370591000000b00745a78b0b3asm7200113qkf.130.2023.03.22.04.45.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Mar 2023 04:45:06 -0700 (PDT)
Message-ID: <a8bbbfe8-0d8e-3f68-4c55-e0c102bdf3f3@redhat.com>
Date:   Wed, 22 Mar 2023 12:45:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH] MAINTAINERS: Add Nico as s390x Maintainer
 and make Thomas reviewer
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        nrb@linux.ibm.com
Cc:     pbonzini@redhat.com, andrew.jones@linux.dev,
        imbrenda@linux.ibm.com, david@redhat.com, borntraeger@linux.ibm.com
References: <20230322113400.1123378-1-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230322113400.1123378-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/03/2023 12.34, Janosch Frank wrote:
> The circle of life continues as we bring in Nico as a s390x
> maintainer. Thomas moves from the maintainer position to reviewer but
> he's a general maintainer of the project anyway.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   MAINTAINERS | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 649de509..bd1761db 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -85,11 +85,12 @@ F: lib/powerpc/
>   F: lib/ppc64/
>   
>   S390X
> -M: Thomas Huth <thuth@redhat.com>
>   M: Janosch Frank <frankja@linux.ibm.com>
>   M: Claudio Imbrenda <imbrenda@linux.ibm.com>
> +M: Nico Böhr <nrb@linux.ibm.com>

Thanks for helping out, Nico!

>   S: Supported
>   R: David Hildenbrand <david@redhat.com>
> +R: Thomas Huth <thuth@redhat.com>
>   L: kvm@vger.kernel.org
>   L: linux-s390@vger.kernel.org
>   F: s390x/

Acked-by: Thomas Huth <thuth@redhat.com>

