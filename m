Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB96712688
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 14:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243420AbjEZMYK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 08:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbjEZMYJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 08:24:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81BA7116
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 05:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685103803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2Bwg3T31bZ+IgI/U7aTrux02yFikGDvD9aeFeEQO12U=;
        b=doUjJsKzjfwksvECZNMZNxO0Ejq7tLgYu5Tfo0nfKS5ehEP7IZEdWxJ2VCGf1MGqpvqHTr
        OWPX4suuye7nT2OuGavK3H5DQa4W1k3OJyYJEYeyqx8zgZsHXNNaVcSV1quIFRxVNF8zAF
        1Fw0CoNalqz65QNVSu2Q35ka+o3IX6M=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-VB2Y8mubNpS4XeZ7nhxXUQ-1; Fri, 26 May 2023 08:23:22 -0400
X-MC-Unique: VB2Y8mubNpS4XeZ7nhxXUQ-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-95847b4b4e7so84448766b.3
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 05:23:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685103801; x=1687695801;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Bwg3T31bZ+IgI/U7aTrux02yFikGDvD9aeFeEQO12U=;
        b=OApfTQ0LTIk3UYQyEAK04fmoHamghHajSlO0RrCE4JlRiv14XVawLh19YbDkzj3WGK
         4K7groyBHGiMPe7D/aWb4+1zE5UoK/4tuPHInAPw/BkG3VGnhWj9iZrhccXoETyqE0zn
         UP83J03vWYilHnsA8HCI2fx/58aPuFupl3AJM7MbKCnpXlDeVPyheDtKI/VpeCKeHLW9
         FgsS/X9/r3LwaUJE/vG7Ra9oR+NRh7/8SEofXIZYU8eDyoQspL/yHhIsCCNo5ijpxYKz
         2uZrjOBg7VjFxxKqpegQpgUcBfU0+mvzADQruqbMahm4cGl8gSEdcv0P228rusk9cFHs
         FcpQ==
X-Gm-Message-State: AC+VfDzKTreGerzh/yI5oMxXwfpqTLDQWNOEZp0PVoEO7K2p7ZpgY3mZ
        22p1tZrKissKggmItMzR9Ee6PAjoH+7QuJShG7YNNDjPFWMHSSmvuf1nPlq9MSz0T0C+h6xoHNQ
        m6aZSRTYQ0LV3
X-Received: by 2002:a17:906:9753:b0:96f:f50b:9b15 with SMTP id o19-20020a170906975300b0096ff50b9b15mr2168443ejy.35.1685103801339;
        Fri, 26 May 2023 05:23:21 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4p68NtoZoWsrla18nN4jigUwF5uKUcnp+Gb5FRHBIJzNJpRjw7/voNOUwf2ky2tlI7n7Dq4Q==
X-Received: by 2002:a17:906:9753:b0:96f:f50b:9b15 with SMTP id o19-20020a170906975300b0096ff50b9b15mr2168425ejy.35.1685103801031;
        Fri, 26 May 2023 05:23:21 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-16.business.telecomitalia.it. [87.12.25.16])
        by smtp.gmail.com with ESMTPSA id lz13-20020a170906fb0d00b0094f67ea6598sm2096292ejb.193.2023.05.26.05.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 05:23:20 -0700 (PDT)
Date:   Fri, 26 May 2023 14:23:18 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v3 00/17] vsock: MSG_ZEROCOPY flag support
Message-ID: <sdm43ibxqzdylwxaai4mjj2ucqpduc74ucyg3yrn75dxu2kix5@jynppv7kxyjz>
References: <20230522073950.3574171-1-AVKrasnov@sberdevices.ru>
 <76270fab-8af7-7597-9193-64cb553a543e@sberdevices.ru>
 <y5tgyj5awrd4hvlrsxsvrern6pd2sby2mdtskah2qp5hemmo2a@72nhcpilg7v2>
 <4baf786b-afe5-371d-9bc4-90226e5df3af@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4baf786b-afe5-371d-9bc4-90226e5df3af@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 26, 2023 at 02:36:17PM +0300, Arseniy Krasnov wrote:
>
>
>On 26.05.2023 13:30, Stefano Garzarella wrote:
>> On Thu, May 25, 2023 at 06:56:42PM +0300, Arseniy Krasnov wrote:
>>>
>>>
>>> On 22.05.2023 10:39, Arseniy Krasnov wrote:
>>>
>>> This patchset is unstable with SOCK_SEQPACKET. I'll fix it.
>>
>> Thanks for let us know!
>>
>> I'm thinking if we should start split this series in two, because it
>> becomes too big.
>>
>> But let keep this for RFC, we can decide later. An idea is to send
>> the first 7 patches with a preparation series, and the next ones with a
>> second series.
>
>Hello, ok! So i'll split patchset in the following way:
>1) Patches which adds new fields/flags and checks. But all of this is not used,
>   as it is preparation.
>2) Second part starts to use it and also carries tests.

As long as they're RFCs, maybe you can keep them together if they're
related, possibly specifying in the cover letter where you'd like to
split them. When we agree that we are in good shape, we can split it.

Thanks,
Stefano

