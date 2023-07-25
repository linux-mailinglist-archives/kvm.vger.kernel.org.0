Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99697618AE
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 14:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbjGYMqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 08:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233290AbjGYMqj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 08:46:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F102C4
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 05:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690289155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t+eENG+rkrOZJfNjBoNDuehMjca3+lXf+FSwHNM6NvM=;
        b=N66W56tAWcjUFro6arKFPlUKzmLsRXNMnjpLvFEipBlQk7EG18Nbwd0Sxgd4hXZxHTF895
        ZaAarRzB+37O19GK1B2K1JTElbssMVn/AddHokD+CWt0HrAPxslTZycTYMwJeAWCziillu
        QD55MeRPtR99wYDujr90KU434Pfpumc=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-336-ULz4W4JBPrOhzAfSMDhuzQ-1; Tue, 25 Jul 2023 08:45:54 -0400
X-MC-Unique: ULz4W4JBPrOhzAfSMDhuzQ-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-98df34aa83aso283336266b.1
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 05:45:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690289153; x=1690893953;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t+eENG+rkrOZJfNjBoNDuehMjca3+lXf+FSwHNM6NvM=;
        b=L8zBpSZaeWJ+WBlmxKf+uNdotbp4AqraHEtCh1WsZGvUMUiKNh3VsF4/VuP3u7j4ED
         0+r05Vgf38KezB0anPozBTD7wTd8lI93ua5Cs/MLAjF0DBjg3Ry5PMPJJIPMGYEv2mJu
         ziejkpiPObLnJvbW/w9+AHIoFfbcJTsuN5GUp9nTzVaOVvJisn+edD05fUhKztCZ4OdZ
         8yotID3r7kTSPkuHoWjVEO+mKbS9kdJDX4b/ZM1mQnbBGhZFhoNM/QV0+GCFUN8FgrHd
         lqFNG9u37uaGw0Avqkv8h69ph3Fl78xtX8IFLmkimt3zIf3MLAzTz6M32hHJCvcmHImf
         +pZQ==
X-Gm-Message-State: ABy/qLZiZniWeHZUehw1jFsJ0WCeBBMOxqDwQrWKqM4zFpdL1trMhFAG
        bND1uiiP372HhAPunbPknbqIa6INeJYNUpdP/Ni1wsv1UM38Lyhk326UKkSgIJ7EcO8Vkzy6cqB
        9fokijPXH60pv
X-Received: by 2002:a17:906:3f1a:b0:998:de72:4c8c with SMTP id c26-20020a1709063f1a00b00998de724c8cmr2222693ejj.35.1690289153282;
        Tue, 25 Jul 2023 05:45:53 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGeHiAYNGInnQAlVCX6nTI06/NOjTDYIJ/hUEthWuPlIk7sS6sNyToq0hN/g++ZIu00x02Vnw==
X-Received: by 2002:a17:906:3f1a:b0:998:de72:4c8c with SMTP id c26-20020a1709063f1a00b00998de724c8cmr2222669ejj.35.1690289152923;
        Tue, 25 Jul 2023 05:45:52 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.201.198])
        by smtp.gmail.com with ESMTPSA id se10-20020a170906ce4a00b0098dfec235ccsm8106374ejb.47.2023.07.25.05.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 05:45:52 -0700 (PDT)
Date:   Tue, 25 Jul 2023 14:45:48 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Arseniy Krasnov <avkrasnov@sberdevices.ru>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [PATCH net-next v3 4/4] vsock/virtio: MSG_ZEROCOPY flag support
Message-ID: <fwtkhndptzz42r23p622zggr5yxyfms7ymylelahmofw2zr26z@ygd7wyhfi7fs>
References: <20230720214245.457298-1-AVKrasnov@sberdevices.ru>
 <20230720214245.457298-5-AVKrasnov@sberdevices.ru>
 <091c067b-43a0-da7f-265f-30c8c7e62977@sberdevices.ru>
 <2k3cbz762ua3fmlben5vcm7rs624sktaltbz3ldeevwiguwk2w@klggxj5e3ueu>
 <51022d5f-5b50-b943-ad92-b06f60bef433@sberdevices.ru>
 <3d1d76c9-2fdb-3dfe-222a-b2184cf17708@sberdevices.ru>
 <o6axh6mxd6mxai2zrpax6wa25slns7ysz5xsegntskvfxl53mt@wowjgb3jazt6>
 <20230725083823-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230725083823-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 25, 2023 at 08:39:17AM -0400, Michael S. Tsirkin wrote:
>On Tue, Jul 25, 2023 at 02:28:02PM +0200, Stefano Garzarella wrote:
>> On Tue, Jul 25, 2023 at 12:16:11PM +0300, Arseniy Krasnov wrote:
>> >
>> >
>> > On 25.07.2023 11:46, Arseniy Krasnov wrote:
>> > >
>> > >
>> > > On 25.07.2023 11:43, Stefano Garzarella wrote:
>> > > > On Fri, Jul 21, 2023 at 08:09:03AM +0300, Arseniy Krasnov wrote:
>> > > > >
>> > > > >
>> > > > > On 21.07.2023 00:42, Arseniy Krasnov wrote:
>> > > > > > This adds handling of MSG_ZEROCOPY flag on transmission path: if this
>> > > > > > flag is set and zerocopy transmission is possible (enabled in socket
>> > > > > > options and transport allows zerocopy), then non-linear skb will be
>> > > > > > created and filled with the pages of user's buffer. Pages of user's
>> > > > > > buffer are locked in memory by 'get_user_pages()'. Second thing that
>> > > > > > this patch does is replace type of skb owning: instead of calling
>> > > > > > 'skb_set_owner_sk_safe()' it calls 'skb_set_owner_w()'. Reason of this
>> > > > > > change is that '__zerocopy_sg_from_iter()' increments 'sk_wmem_alloc'
>> > > > > > of socket, so to decrease this field correctly proper skb destructor is
>> > > > > > needed: 'sock_wfree()'. This destructor is set by 'skb_set_owner_w()'.
>> > > > > >
>> > > > > > Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> > > > > > ---
>> > > > > >  Changelog:
>> > > > > >  v5(big patchset) -> v1:
>> > > > > >   * Refactorings of 'if' conditions.
>> > > > > >   * Remove extra blank line.
>> > > > > >   * Remove 'frag_off' field unneeded init.
>> > > > > >   * Add function 'virtio_transport_fill_skb()' which fills both linear
>> > > > > >     and non-linear skb with provided data.
>> > > > > >  v1 -> v2:
>> > > > > >   * Use original order of last four arguments in 'virtio_transport_alloc_skb()'.
>> > > > > >  v2 -> v3:
>> > > > > >   * Add new transport callback: 'msgzerocopy_check_iov'. It checks that
>> > > > > >     provided 'iov_iter' with data could be sent in a zerocopy mode.
>> > > > > >     If this callback is not set in transport - transport allows to send
>> > > > > >     any 'iov_iter' in zerocopy mode. Otherwise - if callback returns 'true'
>> > > > > >     then zerocopy is allowed. Reason of this callback is that in case of
>> > > > > >     G2H transmission we insert whole skb to the tx virtio queue and such
>> > > > > >     skb must fit to the size of the virtio queue to be sent in a single
>> > > > > >     iteration (may be tx logic in 'virtio_transport.c' could be reworked
>> > > > > >     as in vhost to support partial send of current skb). This callback
>> > > > > >     will be enabled only for G2H path. For details pls see comment
>> > > > > >     'Check that tx queue...' below.
>> > > > > >
>> > > > > >  include/net/af_vsock.h                  |   3 +
>> > > > > >  net/vmw_vsock/virtio_transport.c        |  39 ++++
>> > > > > >  net/vmw_vsock/virtio_transport_common.c | 257 ++++++++++++++++++------
>> > > > > >  3 files changed, 241 insertions(+), 58 deletions(-)
>> > > > > >
>> > > > > > diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>> > > > > > index 0e7504a42925..a6b346eeeb8e 100644
>> > > > > > --- a/include/net/af_vsock.h
>> > > > > > +++ b/include/net/af_vsock.h
>> > > > > > @@ -177,6 +177,9 @@ struct vsock_transport {
>> > > > > >
>> > > > > >      /* Read a single skb */
>> > > > > >      int (*read_skb)(struct vsock_sock *, skb_read_actor_t);
>> > > > > > +
>> > > > > > +    /* Zero-copy. */
>> > > > > > +    bool (*msgzerocopy_check_iov)(const struct iov_iter *);
>> > > > > >  };
>> > > > > >
>> > > > > >  /**** CORE ****/
>> > > > > > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>> > > > > > index 7bbcc8093e51..23cb8ed638c4 100644
>> > > > > > --- a/net/vmw_vsock/virtio_transport.c
>> > > > > > +++ b/net/vmw_vsock/virtio_transport.c
>> > > > > > @@ -442,6 +442,43 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
>> > > > > >      queue_work(virtio_vsock_workqueue, &vsock->rx_work);
>> > > > > >  }
>> > > > > >
>> > > > > > +static bool
>> > > > > > virtio_transport_msgzerocopy_check_iov(const struct
>> > > > > > iov_iter *iov)
>> > > > > > +{
>> > > > > > +    struct virtio_vsock *vsock;
>> > > > > > +    bool res = false;
>> > > > > > +
>> > > > > > +    rcu_read_lock();
>> > > > > > +
>> > > > > > +    vsock = rcu_dereference(the_virtio_vsock);
>> > > > > > +    if (vsock) {
>>
>> Just noted, what about the following to reduce the indentation?
>>
>>         if (!vsock) {
>>             goto out;
>>         }
>
>no {} pls

ooops, true, too much QEMU code today, but luckily checkpatch would have
spotted it ;-)

>
>>             ...
>>             ...
>>     out:
>>         rcu_read_unlock();
>>         return res;
>
>indentation is quite modest here. Not sure goto is worth it.

It's a pattern we follow a lot in this file, and I find the early
return/goto more readable.
Anyway, I don't have a strong opinion, it's fine the way it is now,
actually we don't have too many indentations for now in this function.

Thanks,
Stefano

