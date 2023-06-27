Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5020173F60F
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 09:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbjF0HuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 03:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjF0Htz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 03:49:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F34710E4
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 00:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687852148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QskuoK2+u8nib14YsmgjwegctAeH9ldt3GHDxrpov3o=;
        b=QkWIMW5lUcjUXGGipQwToZZylucxHoBf0kBNJpUlAlqiNx2YmQcejg0puoP0BiICz7qCRP
        IZs4Fled02xf/XKUQBhHTs1e0nY+BoTJ69Jlk2IIi2ZlsliiDtUSbzC4VI/u5Vai3EzA+o
        bW6g8eM1CxilvWOUyA1zkqfxOa46CUo=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-375-DYBB5-evPCOT0VObYESoCQ-1; Tue, 27 Jun 2023 03:49:06 -0400
X-MC-Unique: DYBB5-evPCOT0VObYESoCQ-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9835bf83157so270828366b.2
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 00:49:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687852144; x=1690444144;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QskuoK2+u8nib14YsmgjwegctAeH9ldt3GHDxrpov3o=;
        b=ejyTSwZ4165G2KTo3tLgqGzPxoF3+tDjQU+lSmtt1yvGk0a+6VKhGWjt8zCe9wcoR1
         eCCQT1O3mmmHysdtoDZp0S5k4lKa4wUL0JkvODQCU0eXSgCp9efxrBpxaI7oCCRVkzqT
         kQ6AFIE0+7KsRAGAzBA5l0ydFPwitv+WzyCGZIefRlR7tAz0FJsgLi0kuNyLJf8mZTfl
         zgHVnR+wKoF401kteuIUDqg+P3KiY0gK0COS5SZTIAcMFkLy00SaiELPZA0RaRY8YeAI
         ENaJ9MQp0qJstJH5ihj1U0F0ZKYFXiZBE+ITy/bmH4SWGh9kjyxgsidRMYiviDcro3D1
         0BzA==
X-Gm-Message-State: AC+VfDwjCM4eZ8zAiedqVbShYoxBxnyC28zPUgJDHunIgLXdfLShvJOK
        we0kCcod39a6eOFWzTMIjGp+P2pTYZXnUyMBehtHhpSubHTH9q7xCLZk3gQf14gqbZxL9Zsk+Th
        qNDMpjyaflDcaumxFd3J+
X-Received: by 2002:a17:907:5c2:b0:974:55a2:cb0b with SMTP id wg2-20020a17090705c200b0097455a2cb0bmr27377793ejb.55.1687852144702;
        Tue, 27 Jun 2023 00:49:04 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5lPeO/qla5LYI8so4+wb692OOE9l0zoDT61iV17QvGS0n+RA4RN7JnC6UwGFHGHsZN1sj4ZQ==
X-Received: by 2002:a17:907:5c2:b0:974:55a2:cb0b with SMTP id wg2-20020a17090705c200b0097455a2cb0bmr27377778ejb.55.1687852144363;
        Tue, 27 Jun 2023 00:49:04 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-160.retail.telecomitalia.it. [87.11.6.160])
        by smtp.gmail.com with ESMTPSA id n5-20020a170906088500b0098963eb0c3dsm4208125eje.26.2023.06.27.00.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 00:49:03 -0700 (PDT)
Date:   Tue, 27 Jun 2023 09:49:01 +0200
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
Subject: Re: [RFC PATCH v4 03/17] vsock/virtio: support to send non-linear skb
Message-ID: <6g6rfqbfkmfn5or56v25xny6lyhixj6plmrnyg77hirz7dzzhn@jskeqmnbthhk>
References: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
 <20230603204939.1598818-4-AVKrasnov@sberdevices.ru>
 <3lg4apldxdrpbkgfa2o4wxe4qyayj2h7b2lfcw3q5a7u3hnofi@z2ifmmzt4xpc>
 <0a89e51b-0f7f-b64b-c827-7c943d6f08a6@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0a89e51b-0f7f-b64b-c827-7c943d6f08a6@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 07:39:41AM +0300, Arseniy Krasnov wrote:
>
>
>On 26.06.2023 18:36, Stefano Garzarella wrote:
>> On Sat, Jun 03, 2023 at 11:49:25PM +0300, Arseniy Krasnov wrote:
>>> For non-linear skb use its pages from fragment array as buffers in
>>> virtio tx queue. These pages are already pinned by 'get_user_pages()'
>>> during such skb creation.
>>>
>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>> ---
>>> net/vmw_vsock/virtio_transport.c | 37 ++++++++++++++++++++++++++------
>>> 1 file changed, 31 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>>> index e95df847176b..6053d8341091 100644
>>> --- a/net/vmw_vsock/virtio_transport.c
>>> +++ b/net/vmw_vsock/virtio_transport.c
>>> @@ -100,7 +100,9 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>>>     vq = vsock->vqs[VSOCK_VQ_TX];
>>>
>>>     for (;;) {
>>> -        struct scatterlist hdr, buf, *sgs[2];
>>> +        /* +1 is for packet header. */
>>> +        struct scatterlist *sgs[MAX_SKB_FRAGS + 1];
>>> +        struct scatterlist bufs[MAX_SKB_FRAGS + 1];
>>>         int ret, in_sg = 0, out_sg = 0;
>>>         struct sk_buff *skb;
>>>         bool reply;
>>> @@ -111,12 +113,35 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>>>
>>>         virtio_transport_deliver_tap_pkt(skb);
>>>         reply = virtio_vsock_skb_reply(skb);
>>> +        sg_init_one(&bufs[0], virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
>>> +        sgs[out_sg++] = &bufs[0];
>>
>> Can we use out_sg also to index bufs (here and in the rest of the code)?
>>
>> E.g.
>>
>>         sg_init_one(&bufs[out_sg], ...)
>>         sgs[out_sg] = &bufs[out_sg];
>>         ++out_sg;
>>
>>         ...
>>             if (skb->len > 0) {
>>                 sg_init_one(&bufs[out_sg], skb->data, skb->len);
>>                 sgs[out_sg] = &bufs[out_sg];
>>                 ++out_sg;
>>             }
>>
>>         etc...
>>
>>> +
>>
>> For readability, I would move the smaller branch above:
>>
>>         if (!skb_is_nonlinear(skb)) {
>>             // small block
>>             ...
>>         } else {
>>             // big block
>>             ...
>>         }
>>
>>> +        if (skb_is_nonlinear(skb)) {
>>> +            struct skb_shared_info *si;
>>> +            int i;
>>> +
>>> +            si = skb_shinfo(skb);
>>> +
>>> +            for (i = 0; i < si->nr_frags; i++) {
>>> +                skb_frag_t *skb_frag = &si->frags[i];
>>> +                void *va = page_to_virt(skb_frag->bv_page);
>>> +
>>> +                /* We will use 'page_to_virt()' for userspace page here,
>>> +                 * because virtio layer will call 'virt_to_phys()' later
>>> +                 * to fill buffer descriptor. We don't touch memory at
>>> +                 * "virtual" address of this page.
>>> +                 */
>>> +                sg_init_one(&bufs[i + 1],
>>> +                        va + skb_frag->bv_offset,
>>> +                        skb_frag->bv_len);
>>> +                sgs[out_sg++] = &bufs[i + 1];
>>> +            }
>>> +        } else {
>>> +            if (skb->len > 0) {
>>
>> Should we do the same check (skb->len > 0) for nonlinear skb as well?
>> Or do the nonlinear ones necessarily have len > 0?
>
>Yes, non-linear skb always has 'data_len' > 0, e.g. such skbs always have some
>data in it.

Okay, makes sense ;-)

Thanks,
Stefano

>
>Thanks, Arseniy
>
>>
>>> +                sg_init_one(&bufs[1], skb->data, skb->len);
>>> +                sgs[out_sg++] = &bufs[1];
>>> +            }
>>>
>>    ^
>> Blank line that we can remove.
>>
>> Stefano
>>
>>> -        sg_init_one(&hdr, virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
>>> -        sgs[out_sg++] = &hdr;
>>> -        if (skb->len > 0) {
>>> -            sg_init_one(&buf, skb->data, skb->len);
>>> -            sgs[out_sg++] = &buf;
>>>         }
>>>
>>>         ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, GFP_KERNEL);
>>> -- 
>>> 2.25.1
>>>
>>
>

