Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7675A7D3A76
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 17:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjJWPOM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 11:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjJWPOK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 11:14:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA60DD
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 08:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698074006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=63ahJT05F/ZrGQ5TMqsUAmjRR9M+pviQlbczcdS3kqc=;
        b=R6J8Dgg63Y9NkBQFUQ+dRO3xVV2zFEw5OC37V1U43njG+ncFUDp/eYodpYOXCp5bNgZOwQ
        TTgSpKu6UBydpDeq7DzbO33IItiGzp2M4MmhS2u0yTu8o/Ujv+rYFl9FPyPi/75BwWiPXu
        o/E7aF1Ci9QRElXr0hRV6xQpMAEzoBo=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-155-f6TaPycSO4iH2fqFtuXKtg-1; Mon, 23 Oct 2023 11:13:24 -0400
X-MC-Unique: f6TaPycSO4iH2fqFtuXKtg-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-77892d78dd3so453934485a.0
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 08:13:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698074004; x=1698678804;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=63ahJT05F/ZrGQ5TMqsUAmjRR9M+pviQlbczcdS3kqc=;
        b=fOvkl8mxRfmsXSE9SZdjMUUvDMIE50quQLoZrdy9fbbrrXVHNvvc7GCvQow9VM8rN8
         tGObHEBOAK2Mv6P5HDIiXF4zcvwzB1zAUx56CVKTaQjAMDmPH5mbeyUEHQrroJohpQv/
         4QNqJuPw6dDPHyUxtSS58dQXTCtvYZDj6guLypimMUOfZFXBWYLBZDErwtEd7p4EotmA
         DhtYEA0s+7s44RyuQ5gTSFUYvNjPi+d8sPYGIlSMYRz5f92/KuSsSxBeqHbcaBxEaJ2z
         4J8mQjJjCiU8TcJ9Znhe1MEMDz6MG3hMp6hJL7hNOBuKVohvO0CNvYL/KWxloDCPmnHZ
         DsLA==
X-Gm-Message-State: AOJu0YzdZQiiUIe2hfKrUfKqe4+mVswt/lJFUY8RVs+KbczXj47rOD/K
        MnzjsrW++wEBMRH6BmkBK+UasWxNk4rT4Z5u6V5AtCYhiQL+sPVPHX+/ccxZwkNilolLOkZGhCq
        +mhdEu/0zLg6u
X-Received: by 2002:a0c:df92:0:b0:66d:38e3:4ffd with SMTP id w18-20020a0cdf92000000b0066d38e34ffdmr9704305qvl.5.1698074004157;
        Mon, 23 Oct 2023 08:13:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEw5D/o5lkfr0V2xwj4iuqyXgrqpujFSbZWbAX/eMHBKn/lQ9LUbBZ9xVTrW6OSbaPfZVQ9iw==
X-Received: by 2002:a0c:df92:0:b0:66d:38e3:4ffd with SMTP id w18-20020a0cdf92000000b0066d38e34ffdmr9704288qvl.5.1698074003872;
        Mon, 23 Oct 2023 08:13:23 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-185-56.business.telecomitalia.it. [87.12.185.56])
        by smtp.gmail.com with ESMTPSA id ml14-20020a056214584e00b0066d04196c3dsm2939797qvb.49.2023.10.23.08.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 08:13:23 -0700 (PDT)
Date:   Mon, 23 Oct 2023 17:13:07 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Alexandru Matei <alexandru.matei@uipath.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: Re: [PATCH v2] vsock/virtio: initialize the_virtio_vsock before
 using VQs
Message-ID: <dynlbzmgtr35byn5etbar33ufhweii6gk2pct5wpqxpqubchce@cltop4aar7r6>
References: <20231023140833.11206-1-alexandru.matei@uipath.com>
 <2tc56vwgs5xwqzfqbv5vud346uzagwtygdhkngdt3wjqaslbmh@zauky5czyfkg>
 <0624137c-85cf-4086-8256-af2b8405f434@uipath.com>
 <632465d0-e04c-4e10-abb9-a740d6e3dc30@uipath.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <632465d0-e04c-4e10-abb9-a740d6e3dc30@uipath.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 05:59:45PM +0300, Alexandru Matei wrote:
>On 10/23/2023 5:52 PM, Alexandru Matei wrote:
>> On 10/23/2023 5:29 PM, Stefano Garzarella wrote:
>>> On Mon, Oct 23, 2023 at 05:08:33PM +0300, Alexandru Matei wrote:
>>>> Once VQs are filled with empty buffers and we kick the host,
>>>> it can send connection requests.  If 'the_virtio_vsock' is not
>>>> initialized before, replies are silently dropped and do not reach the host.
>>>>
>>>> Fixes: 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free on the_virtio_vsock")
>>>> Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
>>>> ---
>>>> v2:
>>>> - split virtio_vsock_vqs_init in vqs_init and vqs_fill and moved
>>>>  the_virtio_vsock initialization after vqs_init
>>>>
>>>> net/vmw_vsock/virtio_transport.c | 9 +++++++--
>>>> 1 file changed, 7 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>>>> index e95df847176b..92738d1697c1 100644
>>>> --- a/net/vmw_vsock/virtio_transport.c
>>>> +++ b/net/vmw_vsock/virtio_transport.c
>>>> @@ -559,6 +559,11 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
>>>>     vsock->tx_run = true;
>>>>     mutex_unlock(&vsock->tx_lock);
>>>>
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +static void virtio_vsock_vqs_fill(struct virtio_vsock *vsock)
>>>
>>> What about renaming this function in virtio_vsock_vqs_start() and move also the setting of `tx_run` here?
>>
>> It works but in this case we also need to move rcu_assign_pointer in virtio_vsock_vqs_start(),
>> the assignment needs to be right after setting tx_run to true and before filling the VQs.

Why?

If `rx_run` is false, we shouldn't need to send replies to the host 
IIUC.

If we need this instead, please add a comment in the code, but also in 
the commit, because it's not clear why.

>>
>
>And if we move rcu_assign_pointer then there is no need to split the function in two,
>We can move rcu_assign_pointer() directly inside virtio_vsock_vqs_init() after setting tx_run.

Yep, this could be another option, but we need to change the name of 
that function in this case.

Stefano

>
>>>
>>> Thanks,
>>> Stefano
>>>
>>>> +{
>>>>     mutex_lock(&vsock->rx_lock);
>>>>     virtio_vsock_rx_fill(vsock);
>>>>     vsock->rx_run = true;
>>>> @@ -568,8 +573,6 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
>>>>     virtio_vsock_event_fill(vsock);
>>>>     vsock->event_run = true;
>>>>     mutex_unlock(&vsock->event_lock);
>>>> -
>>>> -    return 0;
>>>> }
>>>>
>>>> static void virtio_vsock_vqs_del(struct virtio_vsock *vsock)
>>>> @@ -664,6 +667,7 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>>>>         goto out;
>>>>
>>>>     rcu_assign_pointer(the_virtio_vsock, vsock);
>>>> +    virtio_vsock_vqs_fill(vsock);
>>>>
>>>>     mutex_unlock(&the_virtio_vsock_mutex);
>>>>
>>>> @@ -736,6 +740,7 @@ static int virtio_vsock_restore(struct virtio_device *vdev)
>>>>         goto out;
>>>>
>>>>     rcu_assign_pointer(the_virtio_vsock, vsock);
>>>> +    virtio_vsock_vqs_fill(vsock);
>>>>
>>>> out:
>>>>     mutex_unlock(&the_virtio_vsock_mutex);
>>>> -- 
>>>> 2.34.1
>>>>
>>>
>

