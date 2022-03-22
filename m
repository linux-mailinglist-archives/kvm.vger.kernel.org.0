Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB194E4026
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 15:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236157AbiCVOHo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 10:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233787AbiCVOHk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 10:07:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D8B44C43B
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 07:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647957909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WWSu3wiWy99oqRDajCtjPLsUAPwXYFjyrn/okc9AKDQ=;
        b=H5ZiV1IkQCjx6eGQNVr/k4FINcyvTodsF77ZDZ9bXi9L7Ra6bTmsJbnHiTWO1Q4fZhE+1C
        flhzLj6FnYFG2FBMbX8jRN+Ua5GOU6pnELyRKU6uxcxnt6ApQQVNUW59DLz6w3grHMZvOJ
        U3xK+PnT2AWFTT4Sn/1b7A8pc0J33F4=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-113-lwb3-9BKMMqwb2WxkwiIqw-1; Tue, 22 Mar 2022 10:05:07 -0400
X-MC-Unique: lwb3-9BKMMqwb2WxkwiIqw-1
Received: by mail-qk1-f198.google.com with SMTP id z10-20020a05620a08ca00b0067d341e82edso11821628qkz.17
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 07:05:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WWSu3wiWy99oqRDajCtjPLsUAPwXYFjyrn/okc9AKDQ=;
        b=V3Ul1GvpCnrJxsNpFqHk6dmicv8At+cl/0paxQWiIc0aH2kRgs+2N+fElZUh3EXeLw
         xNBeaOtICGq3HJaw2gqECKt/2xk6v3WYIO62+572HuL0M7Td/BPi+bzu+N7CYk5bzY6x
         RORUzZt0dXDA3mnBDmIpragS0kD1OcKUTWDHo+bnl6Z05X0on/JxHb62TKKpmRhmp8Xe
         G3dkYABTu37jqKbB1aOkmzxZzuTSWcjuBnoOWXOaCRo1ZQblEPva9AsYOdmkyWW9MCBd
         0A+bPWvzR/rs3HZVMC96JVeiwDAtfvZtCb9EPErClAlfTIPjaiHAhdlZD4AjwpQUH5Nk
         hecg==
X-Gm-Message-State: AOAM5314OgwloQeNy+GDCkrBda85XLXoDHp6yqQ2DsjYhtqtvoeIDx1u
        2EP1iVhsSz/MKVFeur9905xdR7hFx46XfS1Smqazuf+LPMrYsyGwqGdpsgmpDUcOKX7S8q0v0Dr
        UbCCsX0yIP7iW
X-Received: by 2002:a05:6214:e87:b0:441:a5d:681c with SMTP id hf7-20020a0562140e8700b004410a5d681cmr12300776qvb.38.1647957907070;
        Tue, 22 Mar 2022 07:05:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy8/P7gBREOiebiPL6hs1ySKYG/JtpPyzM46Q58fFbmK5VNi/3+BC5pcuLrkbzn9AowdZrExg==
X-Received: by 2002:a05:6214:e87:b0:441:a5d:681c with SMTP id hf7-20020a0562140e8700b004410a5d681cmr12300737qvb.38.1647957906751;
        Tue, 22 Mar 2022 07:05:06 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-114.business.telecomitalia.it. [87.12.25.114])
        by smtp.gmail.com with ESMTPSA id l8-20020a05622a174800b002e1e3f7d4easm14583649qtk.86.2022.03.22.07.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 07:05:06 -0700 (PDT)
Date:   Tue, 22 Mar 2022 15:05:00 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net] vsock/virtio: enable VQs early on probe
Message-ID: <20220322140500.bn5yrqj5ljckhcdb@sgarzare-redhat>
References: <20220322103823.83411-1-sgarzare@redhat.com>
 <20220322092723-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220322092723-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 22, 2022 at 09:36:14AM -0400, Michael S. Tsirkin wrote:
>On Tue, Mar 22, 2022 at 11:38:23AM +0100, Stefano Garzarella wrote:
>> virtio spec requires drivers to set DRIVER_OK before using VQs.
>> This is set automatically after probe returns, but virtio-vsock
>> driver uses VQs in the probe function to fill rx and event VQs
>> with new buffers.
>
>
>So this is a spec violation. absolutely.
>
>> Let's fix this, calling virtio_device_ready() before using VQs
>> in the probe function.
>>
>> Fixes: 0ea9e1d3a9e3 ("VSOCK: Introduce virtio_transport.ko")
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> ---
>>  net/vmw_vsock/virtio_transport.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>> index 5afc194a58bb..b1962f8cd502 100644
>> --- a/net/vmw_vsock/virtio_transport.c
>> +++ b/net/vmw_vsock/virtio_transport.c
>> @@ -622,6 +622,8 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>>  	INIT_WORK(&vsock->event_work, virtio_transport_event_work);
>>  	INIT_WORK(&vsock->send_pkt_work, virtio_transport_send_pkt_work);
>>
>> +	virtio_device_ready(vdev);
>> +
>>  	mutex_lock(&vsock->tx_lock);
>>  	vsock->tx_run = true;
>>  	mutex_unlock(&vsock->tx_lock);
>
>Here's the whole code snippet:
>
>
>        mutex_lock(&vsock->tx_lock);
>        vsock->tx_run = true;
>        mutex_unlock(&vsock->tx_lock);
>
>        mutex_lock(&vsock->rx_lock);
>        virtio_vsock_rx_fill(vsock);
>        vsock->rx_run = true;
>        mutex_unlock(&vsock->rx_lock);
>
>        mutex_lock(&vsock->event_lock);
>        virtio_vsock_event_fill(vsock);
>        vsock->event_run = true;
>        mutex_unlock(&vsock->event_lock);
>
>        if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
>                vsock->seqpacket_allow = true;
>
>        vdev->priv = vsock;
>        rcu_assign_pointer(the_virtio_vsock, vsock);
>
>        mutex_unlock(&the_virtio_vsock_mutex);
>
>
>I worry that this is not the only problem here:
>seqpacket_allow and setting of vdev->priv at least after
>device is active look suspicious.

Right, so if you agree I'll move these before virtio_device_ready().

>E.g.:
>
>static void virtio_vsock_event_done(struct virtqueue *vq)
>{
>        struct virtio_vsock *vsock = vq->vdev->priv;
>
>        if (!vsock)
>                return;
>        queue_work(virtio_vsock_workqueue, &vsock->event_work);
>}
>
>looks like it will miss events now they will be reported earlier.
>One might say that since vq has been kicked it might send
>interrupts earlier too so not a new problem, but
>there's a chance device actually waits until DRIVER_OK
>to start operating.

Yes I see, should I break into 2 patches (one where I move the code 
already present and this one)?

Maybe a single patch is fine since it's the complete solution.

Thank you for the detailed explanation,
Stefano

