Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAE4A764EE0
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 11:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbjG0JLm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 05:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbjG0JLJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 05:11:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CC649D4
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 01:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690448098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T/5paF6Ykf/HR83J793r3ewLreNBy44O4jgk14P4ZU8=;
        b=H955EESaArrm4U0/PbLujsB1wQdnG+cdqIyGTPt0R/JpkbhRqIqhyAXP/9nDbVfYtTXauQ
        /h5nX9Sr3P0cPJE21SP7HzVBNHsLjlroSz5dBmYgA1uNQelOTwTrGacVV7/9786tDOnM+w
        EEsb2l2Y3G67HG5Rc+wEgqdMTSC8RXo=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-4NJ0JRvVPa-t2RaM6-qqVg-1; Thu, 27 Jul 2023 04:54:57 -0400
X-MC-Unique: 4NJ0JRvVPa-t2RaM6-qqVg-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-978a991c3f5so41293066b.0
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 01:54:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690448096; x=1691052896;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T/5paF6Ykf/HR83J793r3ewLreNBy44O4jgk14P4ZU8=;
        b=KI9Mk7u2JqBbm+kWQ+Tetk5fRXYBjt00hMm99jwErSwya8ZWBMMjbdHMgfUauDCfE4
         kHxHVaqIRh9QTeCebCgqSW4ImDd/MQvUqOLR6J1TS2JSpQQ9nZa0xY7JGkGYmTUBTPCw
         DbqoZTnbn7e6T5ca3qNiIfMLuCs4oSMu3gC4368cu9ZHsnR0qO6GhN5VHFrBOGv4jLCU
         KuL1h03dlpiduqBfnAYMHt0J4LiCKwmpg3MFZJPceAvUVQNnQ6s/eoMkwXHTQMd6jCfO
         tPWkON4jvoHEaPUEfrHNC/sKG+A3ONDdMQYQsBPRh6fVe5GIZIKS9H8O8/OfRaR78XAq
         lRlQ==
X-Gm-Message-State: ABy/qLa8Eugcyw6soSxHiij4HCrW8wJJdAfPhyfqc/UohpjKGkx1o/Ih
        uQdLAjXa6qDcTgGAdPZ3VIzrjqTgd7dxJL9hUio35KK3aZpy2x8iKlDWbBhSFaG5XvM4K2iN+8Q
        utAvpB+dh+RD+
X-Received: by 2002:a17:906:4e:b0:994:54ff:10f6 with SMTP id 14-20020a170906004e00b0099454ff10f6mr1252755ejg.30.1690448095933;
        Thu, 27 Jul 2023 01:54:55 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHcD3CURJMdg3NYZ8AZsEK4plNky1gLjXd8Cwvx/xUzv38SfV6WriScq+IHFtwAhFGzRaQCvg==
X-Received: by 2002:a17:906:4e:b0:994:54ff:10f6 with SMTP id 14-20020a170906004e00b0099454ff10f6mr1252744ejg.30.1690448095632;
        Thu, 27 Jul 2023 01:54:55 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.217.102])
        by smtp.gmail.com with ESMTPSA id s15-20020a170906960f00b00988dbbd1f7esm500842ejx.213.2023.07.27.01.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 01:54:55 -0700 (PDT)
Date:   Thu, 27 Jul 2023 10:54:51 +0200
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
Subject: Re: [PATCH net-next v3 4/4] vsock/virtio: MSG_ZEROCOPY flag support
Message-ID: <p4v23nvilf45gl3snuyvypnhi3zfrmbi7qxtrdalluflt773sf@yt6tkgxiliar>
References: <20230720214245.457298-1-AVKrasnov@sberdevices.ru>
 <20230720214245.457298-5-AVKrasnov@sberdevices.ru>
 <091c067b-43a0-da7f-265f-30c8c7e62977@sberdevices.ru>
 <2k3cbz762ua3fmlben5vcm7rs624sktaltbz3ldeevwiguwk2w@klggxj5e3ueu>
 <51022d5f-5b50-b943-ad92-b06f60bef433@sberdevices.ru>
 <3d1d76c9-2fdb-3dfe-222a-b2184cf17708@sberdevices.ru>
 <o6axh6mxd6mxai2zrpax6wa25slns7ysz5xsegntskvfxl53mt@wowjgb3jazt6>
 <f020405e-86af-1b66-c5f4-9bec98298f44@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f020405e-86af-1b66-c5f4-9bec98298f44@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 27, 2023 at 11:32:00AM +0300, Arseniy Krasnov wrote:
>On 25.07.2023 15:28, Stefano Garzarella wrote:
>> On Tue, Jul 25, 2023 at 12:16:11PM +0300, Arseniy Krasnov wrote:
>>> On 25.07.2023 11:46, Arseniy Krasnov wrote:
>>>> On 25.07.2023 11:43, Stefano Garzarella wrote:
>>>>> On Fri, Jul 21, 2023 at 08:09:03AM +0300, Arseniy Krasnov wrote:

[...]

>>>>>>> +    t = vsock_core_get_transport(info->vsk);
>>>>>>>
>>>>>>> -        if (msg_data_left(info->msg) == 0 &&
>>>>>>> -            info->type == VIRTIO_VSOCK_TYPE_SEQPACKET) {
>>>>>>> -            hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>>>>>>> +    if (t->msgzerocopy_check_iov &&
>>>>>>> +        !t->msgzerocopy_check_iov(iov_iter))
>>>>>>> +        return false;
>>>>>
>>>>> I'd avoid adding a new transport callback used only internally in virtio
>>>>> transports.
>>>>
>>>> Ok, I see.
>>>>
>>>>>
>>>>> Usually the transport callbacks are used in af_vsock.c, if we need a
>>>>> callback just for virtio transports, maybe better to add it in struct
>>>>> virtio_vsock_pkt_info or struct virtio_vsock_sock.
>>>
>>> Hm, may be I just need to move this callback from 'struct vsock_transport' to parent 'struct virtio_transport',
>>> after 'send_pkt' callback. In this case:
>>> 1) AF_VSOCK part is not touched.
>>> 2) This callback stays in 'virtio_transport.c' and is set also in this file.
>>>   vhost and loopback are unchanged - only 'send_pkt' still enabled in both
>>>   files for these two transports.
>>
>> Yep, this could also work!
>>
>> Stefano
>
>Great! I'll send this implementation when this patchset for MSG_PEEK will be merged
>to net-next as both conflicts with each other.
>
>https://lore.kernel.org/netdev/20230726060150-mutt-send-email-mst@kernel.org/T/#m56f3b850361a412735616145162d2d9df25f6350

Ack!

Thanks,
Stefano

