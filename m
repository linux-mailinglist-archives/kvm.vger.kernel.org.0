Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61377220E8
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 10:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjFEIYL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 04:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjFEIYJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 04:24:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D622DAF
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 01:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685953401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=86ZFh5GA/RExUbbWyiQyYGG1RAfzp4GnwzXEclA8Onk=;
        b=EP468ZgPl7/58+tN0Fpe0PkBKZtgkHCT+NQEKLhX3Y2w5nbTKq6DE7IAidLo06SRWwvivY
        CocpdhpvqN6imKoo/Eyuv/JG+/D2rvtzliS0yC4gi7oqyOUi9CIb7zWH1ZZ2U1kH0SGyHE
        uLiboD8bb+x4Bt0RrFKkcNh2+LNQS7E=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-157-MNBjdHVeM2uOn6XSUcc70w-1; Mon, 05 Jun 2023 04:23:19 -0400
X-MC-Unique: MNBjdHVeM2uOn6XSUcc70w-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f613f5d290so79563195e9.2
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 01:23:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685953398; x=1688545398;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=86ZFh5GA/RExUbbWyiQyYGG1RAfzp4GnwzXEclA8Onk=;
        b=Pr80DucoRUx4z5RymnmD5CWG7yf0rsM606QT6AoFFfGmAwmpzDjE6xnGFzWEdBlcJc
         RhXhdBTqy4lMhqqBrvek4LXxReeT90RgAdzYZubcuEIOz8ZHuBo1NLxvo44XRFT7p3x3
         +7AfJkZiYkMaJodp8SvcNvA4KFFxypg93vC4L3hnr5d/GZEIxHhQv5SYQMYIEJiiAvPc
         n9P0aq/n5Q2VewVb5VKHktfBigx/OLYz9+hWiges3jPHwCB/qwejddGvfRkDl6Z+bhZC
         pzcleWlCsDr/xexnxgF6E5vnQtu746ulhbvQB/s2o4Wfbi+udGRjQdDVb0eOc0ahDbKl
         4N5Q==
X-Gm-Message-State: AC+VfDyXGOJ8a2bZ8Ir5lQsnAagdpknD1vsa7OUOOt+UdSe+VeIKGWLF
        LxKOCm/xaw2x2uwkmip4yhDCFEAgtbFxl/2mJLO0xKWVViDj+3BIVokTY0PRUedZppQDXtb2H2c
        vaAVJKK5ETb5y
X-Received: by 2002:a1c:4b07:0:b0:3f7:e58b:5898 with SMTP id y7-20020a1c4b07000000b003f7e58b5898mr882445wma.33.1685953398473;
        Mon, 05 Jun 2023 01:23:18 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6hVUnkxH+oJQ5oRiCoXFpO2zFIJ+WKZK6BlZQOQyvptTL7dZg8WRGJTwHG8y88m8Yq1Ixktg==
X-Received: by 2002:a1c:4b07:0:b0:3f7:e58b:5898 with SMTP id y7-20020a1c4b07000000b003f7e58b5898mr882423wma.33.1685953398180;
        Mon, 05 Jun 2023 01:23:18 -0700 (PDT)
Received: from sgarzare-redhat ([5.77.94.106])
        by smtp.gmail.com with ESMTPSA id d24-20020a1c7318000000b003f18b942338sm10015504wmb.3.2023.06.05.01.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 01:23:17 -0700 (PDT)
Date:   Mon, 5 Jun 2023 10:23:14 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobbyeshleman@gmail.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] virtio/vsock: fix sock refcnt bug on owner set
 failure
Message-ID: <nn4zy6aop35ljmf4vg6nelxwo45abvv7rvit62abjvd3eypwpz@kgiusizdyigd>
References: <20230531-b4-vsock-fix-refcnt-v1-1-0ed7b697cca5@bytedance.com>
 <35xlmp65lxd4eoal2oy3lwyjxd3v22aeo2nbuyknc4372eljct@vkilkppadayd>
 <ZHbAgkvSHEiQlFs6@bullseye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZHbAgkvSHEiQlFs6@bullseye>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 31, 2023 at 03:35:30AM +0000, Bobby Eshleman wrote:
>On Thu, Jun 01, 2023 at 09:58:47AM +0200, Stefano Garzarella wrote:
>> On Wed, May 31, 2023 at 07:47:32PM +0000, Bobby Eshleman wrote:
>> > Previous to setting the owner the socket is found via
>> > vsock_find_connected_socket(), which returns sk after a call to
>> > sock_hold().
>> >
>> > If setting the owner fails, then sock_put() needs to be called.
>> >
>> > Fixes: f9d2b1e146e0 ("virtio/vsock: fix leaks due to missing skb owner")
>> > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>> > ---
>> > net/vmw_vsock/virtio_transport_common.c | 1 +
>> > 1 file changed, 1 insertion(+)
>> >
>> > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> > index b769fc258931..f01cd6adc5cb 100644
>> > --- a/net/vmw_vsock/virtio_transport_common.c
>> > +++ b/net/vmw_vsock/virtio_transport_common.c
>> > @@ -1343,6 +1343,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
>> >
>> > 	if (!skb_set_owner_sk_safe(skb, sk)) {
>> > 		WARN_ONCE(1, "receiving vsock socket has sk_refcnt == 0\n");
>> > +		sock_put(sk);
>>
>> Did you have any warning, issue here?
>>
>> IIUC skb_set_owner_sk_safe() can return false only if the ref counter
>> is 0, so calling a sock_put() on it should have no effect except to
>> produce a warning.
>>
>
>Oh yeah, you're totally right. I did not recall how
>skb_set_owner_sk_safe() worked internally and thought I'd introduced an
>uneven hold/put count with that prior patch when reading through the
>code again. I haven't seen any live issue, just misread the code.
>
>Sorry about that, feel free to ignore this patch.

No problem ;-)

Maybe we should add a comment on it.

Thanks,
Stefano

