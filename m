Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8AF64E810
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 09:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiLPIS2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 03:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLPIS0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 03:18:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9F731DF3
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 00:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671178666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4KGOKUTEvzrBvEA1jxN7kPdKtnidXxtFVRo6lZX+D2Q=;
        b=RHQZZildndplTTcuTN4PN1ht4ZLFtS/qANn82bYYYxrg3XzDoJrlYh49/xWqXvXaw8tD9F
        LjfQln9M53T0l8CQ9qWxZJXtwSEvVMrOrRQluUPzh9dNLhXOYPZ9B+wQH32iqgXz58m8my
        akKefLyHzpXhDcHwMBRwkId0nXJChSg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-136-7pswXMicP8-auZfzsm4WqA-1; Fri, 16 Dec 2022 03:17:44 -0500
X-MC-Unique: 7pswXMicP8-auZfzsm4WqA-1
Received: by mail-ed1-f70.google.com with SMTP id r12-20020a05640251cc00b00463699c95aeso1330790edd.18
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 00:17:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4KGOKUTEvzrBvEA1jxN7kPdKtnidXxtFVRo6lZX+D2Q=;
        b=oD9BcujgQIdByYJ0orD4KiIfP4Bm2Wik359UWSVpOmqehbmSVAzdTT4cp72iVvm2D3
         /bju3c4ZOprqtaIgrIZ746yp7BlgJkxW7Bf0VvWJB1Y9LyZ9GZDto+IVNGohpzIPwUVG
         N9/gOU9Vy5Of5s01WswVJ8rUr8L9EmENvan+II/whJr2Sni9EpP4P5KzApxpTJK0IsFt
         +2s/UccwvL1SGph8R73Jq9YuRFhfgsZRY86CvA58rhFesiZag0dWXvSiQX/s/eYbQ/gd
         fyXvXYmKicP4SSPD0R3ILZI+0grdynCpD099lyJDkShUqpoxzYffZwBMRaR/1kNesPzZ
         NAig==
X-Gm-Message-State: ANoB5pmVcRRsASYVvPsZmjEI2tc65QYremj6eWXzURmFWb59jov3aai+
        QCuTrH3wtcLlroYUbIM9yN5zHFmizNUhyEg6VQcrz4Oi8x0W0Q9gQAqUWK52KT/mlUs5f7C3ayS
        oqzLQIS00DYGU
X-Received: by 2002:a17:906:2a8c:b0:78d:f454:3771 with SMTP id l12-20020a1709062a8c00b0078df4543771mr24774191eje.20.1671178663700;
        Fri, 16 Dec 2022 00:17:43 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6sZCQNVVSH0tlQ7oUCjhdaY1lAQnZ7t2cnJ55GlYG5/67gf8hOOHfNI/lL3sZrJTgcetWSDA==
X-Received: by 2002:a17:906:2a8c:b0:78d:f454:3771 with SMTP id l12-20020a1709062a8c00b0078df4543771mr24774184eje.20.1671178663487;
        Fri, 16 Dec 2022 00:17:43 -0800 (PST)
Received: from sgarzare-redhat (host-87-11-6-51.retail.telecomitalia.it. [87.11.6.51])
        by smtp.gmail.com with ESMTPSA id 10-20020a170906328a00b007bc8ef7416asm574385ejw.25.2022.12.16.00.17.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 00:17:42 -0800 (PST)
Date:   Fri, 16 Dec 2022 09:17:38 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, eperezma@redhat.com,
        stefanha@redhat.com, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 1/6] vdpa: add bind_mm callback
Message-ID: <20221216081738.wlhevfmvzfs3rsrg@sgarzare-redhat>
References: <20221214163025.103075-1-sgarzare@redhat.com>
 <20221214163025.103075-2-sgarzare@redhat.com>
 <CACGkMEtB6uQ_6fKU5F-D0vG+gQz9mMdYWUQwre-yp1sVpGvKPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CACGkMEtB6uQ_6fKU5F-D0vG+gQz9mMdYWUQwre-yp1sVpGvKPQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 16, 2022 at 02:37:45PM +0800, Jason Wang wrote:
>On Thu, Dec 15, 2022 at 12:30 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> This new optional callback is used to bind the device to a specific
>> address space so the vDPA framework can use VA when this callback
>> is implemented.
>>
>> Suggested-by: Jason Wang <jasowang@redhat.com>
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> ---
>>  include/linux/vdpa.h | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
>> index 6d0f5e4e82c2..34388e21ef3f 100644
>> --- a/include/linux/vdpa.h
>> +++ b/include/linux/vdpa.h
>> @@ -282,6 +282,12 @@ struct vdpa_map_file {
>>   *                             @iova: iova to be unmapped
>>   *                             @size: size of the area
>>   *                             Returns integer: success (0) or error (< 0)
>> + * @bind_mm:                   Bind the device to a specific address space
>> + *                             so the vDPA framework can use VA when this
>> + *                             callback is implemented. (optional)
>> + *                             @vdev: vdpa device
>> + *                             @mm: address space to bind
>
>Do we need an unbind or did a NULL mm mean unbind?

Yep, your comment in patch 6 makes it necessary. I will add it!

>
>> + *                             @owner: process that owns the address space
>
>Any reason we need the task_struct here?

Mainly to attach to kthread to the process cgroups, but that part is 
still in TODO since I need to understand it better.

Maybe we can remove the task_struct here and use `current` directly in 
the callback.

Thanks,
Stefano

