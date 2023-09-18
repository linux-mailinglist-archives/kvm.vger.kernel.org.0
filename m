Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435C77A50FA
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 19:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjIRR2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 13:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbjIRR2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 13:28:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2DCFD
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 10:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695058068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4mO3T2+ldSwa/yZAn9slxFEvO1YZrGLXM+EycGDV9no=;
        b=YWcb9uvRxrqS10TngfAAxDxcU9tJQa1/ScxHpHukL+IdvvlEo+80OVfuKLGILDKkI8Vceq
        bCQ41CCdw+Ujwkos+yf0//pJ8E5s6/4l9tQ6YQNxopSOcBImaMj3JbE6QkxQ6kXtZ1+Dqi
        EzUuGdCLjYssTmwkjwSWGasKjxn4SLY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-55-W5TM4Jv7P4-sD2AW5pzVWw-1; Mon, 18 Sep 2023 13:27:47 -0400
X-MC-Unique: W5TM4Jv7P4-sD2AW5pzVWw-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9a5d86705e4so338816666b.1
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 10:27:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695058066; x=1695662866;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4mO3T2+ldSwa/yZAn9slxFEvO1YZrGLXM+EycGDV9no=;
        b=gg/Nmzb8pCXErfaAQOftJHIFb8YfvTwZfYqYxwdPPXIv/vks2GcKWD1QF2pECh4Rzl
         /tNId4rJ2aiCdDhyCh+DEGdoKMglYhfZK2jw2rFaABR7FndY2oPK5A3mo/AUdheFJ49C
         JQU0MfwtSebqM7tSD9GdTXxNzfmblHAew3j51D+svo1DdyL79YiVPSUIx7B2WSasIY5X
         eUlrVCNIbXKXNfLdSoUFoaDq3KUp66HeqXBTFT8fhqykZbjZK8fww6iy3mixUYvzKzXI
         g8rgAHKjjvAZhqHpSV4FDW0EmYN/gkUrRRFCsCvUBwlfEQFwTctN7i2jQgdex8pmbqiM
         bpLA==
X-Gm-Message-State: AOJu0YzLVygtG2P3DJBXRdqRcSptzC7rH+mIhcS80mT/5Zv6vcUYyNbt
        o6YqCnin4aLl316lJs2dpF4RoxK2+zayG8rfD10WLrYV3QEYHkD7xHfU52EcheKDpEfRxEFA6JG
        te5nBRRJ5MoTz
X-Received: by 2002:a17:906:7685:b0:9a2:1e03:1572 with SMTP id o5-20020a170906768500b009a21e031572mr8451777ejm.19.1695058066166;
        Mon, 18 Sep 2023 10:27:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHpPy2kzt5JnkJCTcgB2EButqNerXTfWD1GcDkHlaa0llvCnOfY2tEEWBZorUMvFHNoEJTWng==
X-Received: by 2002:a17:906:7685:b0:9a2:1e03:1572 with SMTP id o5-20020a170906768500b009a21e031572mr8451755ejm.19.1695058065892;
        Mon, 18 Sep 2023 10:27:45 -0700 (PDT)
Received: from redhat.com ([2.52.3.35])
        by smtp.gmail.com with ESMTPSA id rp15-20020a170906d96f00b009a1b857e3a5sm6739045ejb.54.2023.09.18.10.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 10:27:45 -0700 (PDT)
Date:   Mon, 18 Sep 2023 13:27:41 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [PATCH net-next v9 0/4] vsock/virtio/vhost: MSG_ZEROCOPY
 preparations
Message-ID: <20230918132726-mutt-send-email-mst@kernel.org>
References: <20230916130918.4105122-1-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230916130918.4105122-1-avkrasnov@salutedevices.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 16, 2023 at 04:09:14PM +0300, Arseniy Krasnov wrote:
> Hello,
> 
> this patchset is first of three parts of another big patchset for
> MSG_ZEROCOPY flag support:
> https://lore.kernel.org/netdev/20230701063947.3422088-1-AVKrasnov@sberdevices.ru/
> 
> During review of this series, Stefano Garzarella <sgarzare@redhat.com>
> suggested to split it for three parts to simplify review and merging:
> 
> 1) virtio and vhost updates (for fragged skbs) <--- this patchset
> 2) AF_VSOCK updates (allows to enable MSG_ZEROCOPY mode and read
>    tx completions) and update for Documentation/.
> 3) Updates for tests and utils.
> 
> This series enables handling of fragged skbs in virtio and vhost parts.
> Newly logic won't be triggered, because SO_ZEROCOPY options is still
> impossible to enable at this moment (next bunch of patches from big
> set above will enable it).

Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> I've included changelog to some patches anyway, because there were some
> comments during review of last big patchset from the link above.
> 
> Head for this patchset is:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=f2fa1c812c91e99d0317d1fc7d845e1e05f39716
> 
> Link to v1:
> https://lore.kernel.org/netdev/20230717210051.856388-1-AVKrasnov@sberdevices.ru/
> Link to v2:
> https://lore.kernel.org/netdev/20230718180237.3248179-1-AVKrasnov@sberdevices.ru/
> Link to v3:
> https://lore.kernel.org/netdev/20230720214245.457298-1-AVKrasnov@sberdevices.ru/
> Link to v4:
> https://lore.kernel.org/netdev/20230727222627.1895355-1-AVKrasnov@sberdevices.ru/
> Link to v5:
> https://lore.kernel.org/netdev/20230730085905.3420811-1-AVKrasnov@sberdevices.ru/
> Link to v6:
> https://lore.kernel.org/netdev/20230814212720.3679058-1-AVKrasnov@sberdevices.ru/
> Link to v7:
> https://lore.kernel.org/netdev/20230827085436.941183-1-avkrasnov@salutedevices.com/
> Link to v8:
> https://lore.kernel.org/netdev/20230911202234.1932024-1-avkrasnov@salutedevices.com/


> Changelog:
>  v3 -> v4:
>  * Patchset rebased and tested on new HEAD of net-next (see hash above).
>  v4 -> v5:
>  * See per-patch changelog after ---.
>  v5 -> v6:
>  * Patchset rebased and tested on new HEAD of net-next (see hash above).
>  * See per-patch changelog after ---.
>  v6 -> v7:
>  * Patchset rebased and tested on new HEAD of net-next (see hash above).
>  * See per-patch changelog after ---.
>  v7 -> v8:
>  * Patchset rebased and tested on new HEAD of net-next (see hash above).
>  * See per-patch changelog after ---.
>  v8 -> v9:
>  * Patchset rebased and tested on new HEAD of net-next (see hash above).
>  * See per-patch changelog after ---.
> 
> Arseniy Krasnov (4):
>   vsock/virtio/vhost: read data from non-linear skb
>   vsock/virtio: support to send non-linear skb
>   vsock/virtio: non-linear skb handling for tap
>   vsock/virtio: MSG_ZEROCOPY flag support
> 
>  drivers/vhost/vsock.c                         |  14 +-
>  include/linux/virtio_vsock.h                  |  10 +
>  .../events/vsock_virtio_transport_common.h    |  12 +-
>  net/vmw_vsock/virtio_transport.c              |  92 +++++-
>  net/vmw_vsock/virtio_transport_common.c       | 307 ++++++++++++++----
>  5 files changed, 348 insertions(+), 87 deletions(-)
> 
> -- 
> 2.25.1

