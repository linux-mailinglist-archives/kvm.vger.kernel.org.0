Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB2357B2CF
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 10:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235726AbiGTIXS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 04:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbiGTIXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 04:23:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 042496BC13
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 01:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658305394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WqWXkpMYDjGMkR6N048q9/Kkfh0q8LEuKcrhvdxBx9U=;
        b=Ryddgz21Hjea6a0njB3Qp8QEjnL8IPEMJWDYi4C3SPpe5pEuMuat8JPGDNKj5oeW2LjIVm
        k8l9e6kgDmeS/kTG6dN4AIY2KPdZLeejOFt/dCEjBbnQTRZwZKaDmKb81FypAumeEYt6o9
        cc3lmAmaWEKsbgw2SkUzvXIc/ncAC6Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-JXzcyXg3NtWT8t87lwmP_w-1; Wed, 20 Jul 2022 04:23:13 -0400
X-MC-Unique: JXzcyXg3NtWT8t87lwmP_w-1
Received: by mail-wm1-f71.google.com with SMTP id i133-20020a1c3b8b000000b003a2fe4c345cso909010wma.0
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 01:23:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=WqWXkpMYDjGMkR6N048q9/Kkfh0q8LEuKcrhvdxBx9U=;
        b=YXSiGpKKiK8KfNmmM4NNMBsdcvP7jmHtS2wxRSQrcTeJh/XPqJsE/G0LUQyYED96Rt
         cIkuWVNxi+EzeMvcHl2N0zGCSRgb1lGJ8Ldqa2FEP55eBZjkLMRe3RpQKOZxAJY5iTfa
         xJL7RsrYykP6WPDHaoN4bNLdQ8XwNpmAzu1L8hlKdPCH0xH4oGkr/BzETwly06qskrI2
         Z18duP2wktgKl3POW5FrDSc5jxZnikKGFI4xi6JsLN2yQwjluprDvVWDc6A6D9wfr1T6
         0OhEn8b3VlLVZhlnTsEYn/k40EMIZEM0gfFoKjmo8lSEclVIPOCk1VmvZcsie5mc4kR0
         2tIQ==
X-Gm-Message-State: AJIora+GCx0c1678F8IKjpJgFaIsf2ZNih5hoOYo7n61LSyV/f12IFIS
        j+MNbCD2sylKQfQlynsJTS7D0Yfu/XN/f1yqe8cbF2yxr2J2xHEfGZts0+h57QJvD18fbv7IMul
        HTbSMkpH9Dw+b
X-Received: by 2002:a05:600c:3227:b0:3a3:be7:2917 with SMTP id r39-20020a05600c322700b003a30be72917mr2760529wmp.83.1658305392324;
        Wed, 20 Jul 2022 01:23:12 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sk2lxdgaBkVc5Kem0cnAq2mfCBRvNA74098gzKOVACYFwhUlWyh6yfDCAwDcJmLBObthn+bA==
X-Received: by 2002:a05:600c:3227:b0:3a3:be7:2917 with SMTP id r39-20020a05600c322700b003a30be72917mr2760502wmp.83.1658305392025;
        Wed, 20 Jul 2022 01:23:12 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id g8-20020a05600c4ec800b003a317ee3036sm1887541wmq.2.2022.07.20.01.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 01:23:11 -0700 (PDT)
Date:   Wed, 20 Jul 2022 10:23:07 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Dexuan Cui <decui@microsoft.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 2/3] virtio/vsock: use 'target' in notify_poll_in,
 callback.
Message-ID: <20220720082307.djbf7qgnlsjmrxcf@sgarzare-redhat>
References: <c8de13b1-cbd8-e3e0-5728-f3c3648c69f7@sberdevices.ru>
 <358f8d52-fd88-ad2e-87e2-c64bfa516a58@sberdevices.ru>
 <20220719124857.akv25sgp6np3pdaw@sgarzare-redhat>
 <15f38fcf-f1ff-3aad-4c30-4436bb8c4c44@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <15f38fcf-f1ff-3aad-4c30-4436bb8c4c44@sberdevices.ru>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 20, 2022 at 05:38:03AM +0000, Arseniy Krasnov wrote:
>On 19.07.2022 15:48, Stefano Garzarella wrote:
>> On Mon, Jul 18, 2022 at 08:17:31AM +0000, Arseniy Krasnov wrote:
>>> This callback controls setting of POLLIN,POLLRDNORM output bits
>>> of poll() syscall,but in some cases,it is incorrectly to set it,
>>> when socket has at least 1 bytes of available data. Use 'target'
>>> which is already exists and equal to sk_rcvlowat in this case.
>>>
>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>> ---
>>> net/vmw_vsock/virtio_transport_common.c | 2 +-
>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>> index ec2c2afbf0d0..591908740992 100644
>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>> @@ -634,7 +634,7 @@ virtio_transport_notify_poll_in(struct vsock_sock *vsk,
>>>                 size_t target,
>>>                 bool *data_ready_now)
>>> {
>>> -    if (vsock_stream_has_data(vsk))
>>> +    if (vsock_stream_has_data(vsk) >= target)
>>>         *data_ready_now = true;
>>>     else
>>>         *data_ready_now = false;
>>
>> Perhaps we can take the opportunity to clean up the code in this way:
>>
>>     *data_ready_now = vsock_stream_has_data(vsk) >= target;
>Ack
>>
>> Anyway, I think we also need to fix the other transports (vmci and hyperv), what do you think?
>For vmci it is look clear to fix it. For hyperv i need to check it more, because it already
>uses some internal target value.

Yep, I see. Maybe you can pass `target` to hvs_channel_readable() and 
use it as parameter of HVS_PKT_LEN().

@Dexuan what do you think?

Thanks,
Stefano

