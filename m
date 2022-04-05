Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD0D4F2F76
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 14:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354044AbiDEKLJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 06:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351814AbiDEKDV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 06:03:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA50E7D00C
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 02:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649152344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YV3h6IbH3R7bzysIjqVSxtvZ2NxYhrSDn1NoU0aTwAU=;
        b=doItOHkOxD/j2h0rWHIOXf8Z76WrhDsUHzuiCdb3BXmzX9wgExT55xaPgX6p7g9B+Lejmp
        KCKmmM+XfhLq8FhF6in3K5OZHsIKIYQFp3V+vNmPpX50mtkf2GG703TjDnlc1h6IWgc8le
        bInNUH+htZ6ga1vO7VOfVLl/0MahKcw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-6Rfx3BMFNjK3DxunewWp3w-1; Tue, 05 Apr 2022 05:52:23 -0400
X-MC-Unique: 6Rfx3BMFNjK3DxunewWp3w-1
Received: by mail-wr1-f71.google.com with SMTP id q15-20020adfab0f000000b002060c75e65aso1415836wrc.5
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 02:52:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YV3h6IbH3R7bzysIjqVSxtvZ2NxYhrSDn1NoU0aTwAU=;
        b=mGFTsllwbsglR7sV3GN7JyjS2X6+oQZ0pbFET0GENZj24kifl8Y3uhs2aTldRUBP64
         WygvdU6bwl9A+C9GXeHPWEnD9J3QSUFxY5uCg8AyG8T0qkVcVGryWNL/FwFZGtTDE1S9
         b7W0QVitw5s+yiXse+wVrvxlpKzw7OARCf48zIlAbqquudQIxss7b6qGBiFpY+ubbnPP
         +trHOb4LOB7TptinehIM/yOKAufha1RwAAZc1rsVJVQVKHni/3qkJ/Ov2jMlz19rsqMZ
         hlONY79lIwoUhDS0w9hb4vkbWozytI2DIBloBs1tx5v7w2Z4qPOE/o1BfJi6sreSNm5J
         p/Ag==
X-Gm-Message-State: AOAM533cYvdMGCXRhdD0/3DOE1LQBhKqeiIAs5jJ7gN18dufuYf2hRv9
        6dcE0CEKk/RE4+UKOuTj+Pt06dNA3uUFktSOwr8jOVnJLNsMArcJHzy1MMV34IBPiB1LcrC0rJJ
        8I/iFxFo2YeZc
X-Received: by 2002:a5d:54ca:0:b0:206:13ed:ea88 with SMTP id x10-20020a5d54ca000000b0020613edea88mr2016293wrv.167.1649152341994;
        Tue, 05 Apr 2022 02:52:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZnsvVWPr2Wavl4feEsY3PORr1u038rOu8MEtGNDFMvYXOGoPfp0TfEKhEP/6HHOyeVpUwPQ==
X-Received: by 2002:a5d:54ca:0:b0:206:13ed:ea88 with SMTP id x10-20020a5d54ca000000b0020613edea88mr2016280wrv.167.1649152341842;
        Tue, 05 Apr 2022 02:52:21 -0700 (PDT)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id a12-20020a5d53cc000000b00205a0ee9c74sm11158783wrw.89.2022.04.05.02.52.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 02:52:21 -0700 (PDT)
Message-ID: <5a99151d-f09e-b5ab-4397-2a0b97e42e41@redhat.com>
Date:   Tue, 5 Apr 2022 11:52:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [kvm-unit-tests PATCH 3/8] s390x: pfmf: Initialize pfmf_r1 union
 on declaration
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nrb@linux.ibm.com, seiden@linux.ibm.com
References: <20220405075225.15903-1-frankja@linux.ibm.com>
 <20220405075225.15903-4-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220405075225.15903-4-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/04/2022 09.52, Janosch Frank wrote:
> Let's make this test look a bit nicer.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   s390x/pfmf.c | 39 +++++++++++++++++++--------------------
>   1 file changed, 19 insertions(+), 20 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

