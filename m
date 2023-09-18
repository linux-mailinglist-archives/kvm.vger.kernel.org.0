Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 482AD7A4C07
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 17:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbjIRPZM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 11:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239199AbjIRPZJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 11:25:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C9FCDE
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 08:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695050425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LcTISZgyQz7Bvk45tsdOeOYi0IZTcEbOF6L8io0wv6s=;
        b=cp2Mz3U24Ggcuo9FNS9C3MJiMzIwDFP/K+wN9PzWveuI5Hem808RtgQKlLRdcnk7jIN0IJ
        oQJg/+v+YVz01P7+HCZ+DZMoNFBJyMMfWz2ynXll0M024iFuv5bUMpEUrb6B3Xy4dx805r
        H1d/TVR9z4idxJhM4/6Jr3d6iDCo1MY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-7zX6qWTSPAqzDOwaUUZNJA-1; Mon, 18 Sep 2023 10:50:11 -0400
X-MC-Unique: 7zX6qWTSPAqzDOwaUUZNJA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-314256aedcbso3113451f8f.0
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 07:50:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695048610; x=1695653410;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LcTISZgyQz7Bvk45tsdOeOYi0IZTcEbOF6L8io0wv6s=;
        b=ea92JOPNZ0Dqu5s1kpxzWSpVhZth7rI0WM8cjvVICSNk6yluBavtQsAN2AteC+stW/
         Ve+GZC7IpQid0rnVOREQrQuXTiz7pFCa/HbNZlZYFiBrNTek2zFAVnsZY+XTljnE8gcE
         HPYaLh9QdMzqsM6DwRvq27S09t1pl6aBGQR5uTtNIaNTKoiw71mY37HInAL/pvsDdCGF
         ijljaDNeyf+bPdyumvlRHRBkEVOoPGgCiUZgi9Ndp0zw9UuXVIbNunSvrIr+5DpJY1X9
         ofxX7bZcBjeIevCSjfVSxICzNp05HKaoWC9W0fT6mu1E6CBaEmUi/V9oKPTFc/GillAT
         kzMA==
X-Gm-Message-State: AOJu0YyDuIqWpvg3r+8xEbtZKLzHbGYbkUkraAxCOF9J5EvY16NGAKLY
        4KZz9jzmhrvj+3pHS+MeomhxuctFFf3Y6/oRL6s0y91i8hAfRuz1JQFso166D/Z89ffotSas0ik
        1Pa8iRTMRwd0Z5T64Bw8wuo0=
X-Received: by 2002:a5d:4941:0:b0:319:72f8:7249 with SMTP id r1-20020a5d4941000000b0031972f87249mr7183133wrs.66.1695048609813;
        Mon, 18 Sep 2023 07:50:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGMpvQ2Hg0cP8tmtAOT3D6mlDBNWBlCvpd7g68aXHEpraHiZGH8Wu30Hj0RA2msYaZmefhIrA==
X-Received: by 2002:a5d:4941:0:b0:319:72f8:7249 with SMTP id r1-20020a5d4941000000b0031972f87249mr7183112wrs.66.1695048609417;
        Mon, 18 Sep 2023 07:50:09 -0700 (PDT)
Received: from sgarzare-redhat ([46.222.42.69])
        by smtp.gmail.com with ESMTPSA id m6-20020adfe946000000b0031980783d78sm12772049wrn.54.2023.09.18.07.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 07:50:08 -0700 (PDT)
Date:   Mon, 18 Sep 2023 16:50:05 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@salutedevices.com>
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
Subject: Re: [PATCH net-next v9 4/4] vsock/virtio: MSG_ZEROCOPY flag support
Message-ID: <fwv4zdqjfhtwqookpvqqlckoqnxgyiinzhs5mq5pevl7ucefrt@hgd67phghec6>
References: <20230916130918.4105122-1-avkrasnov@salutedevices.com>
 <20230916130918.4105122-5-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230916130918.4105122-5-avkrasnov@salutedevices.com>
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

On Sat, Sep 16, 2023 at 04:09:18PM +0300, Arseniy Krasnov wrote:
>This adds handling of MSG_ZEROCOPY flag on transmission path:
>
>1) If this flag is set and zerocopy transmission is possible (enabled
>   in socket options and transport allows zerocopy), then non-linear
>   skb will be created and filled with the pages of user's buffer.
>   Pages of user's buffer are locked in memory by 'get_user_pages()'.
>2) Replaces way of skb owning: instead of 'skb_set_owner_sk_safe()' it
>   calls 'skb_set_owner_w()'. Reason of this change is that
>   '__zerocopy_sg_from_iter()' increments 'sk_wmem_alloc' of socket, so
>   to decrease this field correctly, proper skb destructor is needed:
>   'sock_wfree()'. This destructor is set by 'skb_set_owner_w()'.
>3) Adds new callback to 'struct virtio_transport': 'can_msgzerocopy'.
>   If this callback is set, then transport needs extra check to be able
>   to send provided number of buffers in zerocopy mode. Currently, the
>   only transport that needs this callback set is virtio, because this
>   transport adds new buffers to the virtio queue and we need to check,
>   that number of these buffers is less than size of the queue (it is
>   required by virtio spec). vhost and loopback transports don't need
>   this check.
>
>Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>---
> Changelog:
> v5(big patchset) -> v1:
>  * Refactorings of 'if' conditions.
>  * Remove extra blank line.
>  * Remove 'frag_off' field unneeded init.
>  * Add function 'virtio_transport_fill_skb()' which fills both linear
>    and non-linear skb with provided data.
> v1 -> v2:
>  * Use original order of last four arguments in 'virtio_transport_alloc_skb()'.
> v2 -> v3:
>  * Add new transport callback: 'msgzerocopy_check_iov'. It checks that
>    provided 'iov_iter' with data could be sent in a zerocopy mode.
>    If this callback is not set in transport - transport allows to send
>    any 'iov_iter' in zerocopy mode. Otherwise - if callback returns 'true'
>    then zerocopy is allowed. Reason of this callback is that in case of
>    G2H transmission we insert whole skb to the tx virtio queue and such
>    skb must fit to the size of the virtio queue to be sent in a single
>    iteration (may be tx logic in 'virtio_transport.c' could be reworked
>    as in vhost to support partial send of current skb). This callback
>    will be enabled only for G2H path. For details pls see comment
>    'Check that tx queue...' below.
> v3 -> v4:
>  * 'msgzerocopy_check_iov' moved from 'struct vsock_transport' to
>    'struct virtio_transport' as it is virtio specific callback and
>    never needed in other transports.
> v4 -> v5:
>  * 'msgzerocopy_check_iov' renamed to 'can_msgzerocopy' and now it
>    uses number of buffers to send as input argument. I think there is
>    no need to pass iov to this callback (at least today, it is used only
>    by guest side of virtio transport), because the only thing that this
>    callback does is comparison of number of buffers to be inserted to
>    the tx queue and size of this queue.
>  * Remove any checks for type of current 'iov_iter' with payload (is it
>    'iovec' or 'ubuf'). These checks left from the earlier versions where I
>    didn't use already implemented kernel API which handles every type of
>    'iov_iter'.
> v5 -> v6:
>  * Refactor 'virtio_transport_fill_skb()'.
>  * Add 'WARN_ON_ONCE()' and comment on invalid combination of destination
>    socket and payload in 'virtio_transport_alloc_skb()'.
> v7 -> v8:
>  * Move '+1' addition from 'can_msgzerocopy' callback body to the caller.
>    This addition means packet header.
>  * In 'virtio_transport_can_zcopy()' rename 'max_to_send' argument to
>    'pkt_len'.
>  * Update commit message by adding details about new 'can_msgzerocopy'
>    callback.
>  * In 'virtio_transport_init_hdr()' move 'len' argument directly after
>    'info'.
>  * Add comment about processing last skb in tx loop.
>  * Update comment for 'can_msgzerocopy' callback for more details.
> v8 -> v9:
>  * Return and update comment for 'virtio_transport_alloc_skb()'.
>  * Pass pointer to transport ops to 'virtio_transport_can_zcopy()',
>    this allows to use it directly without calling virtio_transport_get_ops()'.
>  * Remove redundant call for 'msg_data_left()' in 'virtio_transport_fill_skb()'.
>  * Do not pass 'struct vsock_sock*' to 'virtio_transport_alloc_skb()',
>    use same pointer from already passed 'struct virtio_vsock_pkt_info*'.
>  * Fix setting 'end of message' bit for SOCK_SEQPACKET (add call for
>    'msg_data_left()' == 0).
>  * Add 'zcopy' parameter to packet allocation trace event.

Thanks for addressing the comments!
>
> include/linux/virtio_vsock.h                  |   9 +
> .../events/vsock_virtio_transport_common.h    |  12 +-
> net/vmw_vsock/virtio_transport.c              |  32 +++
> net/vmw_vsock/virtio_transport_common.c       | 250 ++++++++++++++----
> 4 files changed, 241 insertions(+), 62 deletions(-)

LGTM!

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

