Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 887F57A06E6
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 16:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239712AbjINOIR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 10:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234873AbjINOIP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 10:08:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0FBFBDF
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 07:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694700444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yHudOf8iuVH8gSyXltnig2N3UnhuMoM7BMALuIknbpk=;
        b=FoZdgdnZ0hzdCN3TmjNqc+o+UsF7x86j9rKhT7L830aY1R0QKBlZolnOxEhgcuTToujxRB
        jUyA1PYLj/swq/H3PjIdKnU2/h9m+NKfqrJ4M4lejM8vZ3B292ZZq576BpMvE+g9hsdo8U
        /UP/zB31UewGioPUqtrZ6UnlPWvpGQo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-99-npEySOqKNEqrt77I8vgPiA-1; Thu, 14 Sep 2023 10:07:22 -0400
X-MC-Unique: npEySOqKNEqrt77I8vgPiA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40474e7323dso2855075e9.2
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 07:07:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694700441; x=1695305241;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yHudOf8iuVH8gSyXltnig2N3UnhuMoM7BMALuIknbpk=;
        b=N2ujqLP3Q9daDe56rwJ63VI//dIsfkCpmvQLol/2VRAPlmUFjYFOsd6leVpCQS666R
         Fp7rYrv0T9Tr1P/iCXUFSEJgZfCHqLwBoku3r2RTCTZiMfWIsrRmevH0I33mpDL5VuAR
         nwh+oxaSi91TEOAYkk97TrucTGBtpMzYhVbvdqvL6VOdscpICUYNAsHOOUtY/6IbDJ9o
         BcBtmVXoCXQc7I5v8jjbdz2uU6cPH8aDkeF2PjfBqPyRDGl1Jhkbjk0OoHi9Rlk67AGl
         uBC0smzW5gHIeUTjtRjArxTFKvsi/Aw1VbRxULsbcwWCUYBa0JUMGMxAlefzIdBtt/ZC
         aNWg==
X-Gm-Message-State: AOJu0YwMFYqSCj1Xy4s2xiJtks3NyXzp6fthdWoXcNhc+8Z9ZzVig2NX
        /Y3V9GU55jUp++T6syT9EBU6ggrATdqNMH8UcSMvidQHXk7nux/+ULsxOFgmSghGasR4QH7vJXF
        Fp/GiHR1tTZui
X-Received: by 2002:a05:600c:22c6:b0:401:b53e:6c57 with SMTP id 6-20020a05600c22c600b00401b53e6c57mr4834844wmg.9.1694700441105;
        Thu, 14 Sep 2023 07:07:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGIqdAUEhMIPyjpv+aXEvjvAdHzcpL3PZnpBEW96reh9Fs+X2mFI8Jv7Jj2JWmjIb6ifqV2MQ==
X-Received: by 2002:a05:600c:22c6:b0:401:b53e:6c57 with SMTP id 6-20020a05600c22c600b00401b53e6c57mr4834802wmg.9.1694700440710;
        Thu, 14 Sep 2023 07:07:20 -0700 (PDT)
Received: from sgarzare-redhat ([46.222.114.183])
        by smtp.gmail.com with ESMTPSA id c3-20020a056000104300b003143cb109d5sm1889389wrx.14.2023.09.14.07.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 07:07:20 -0700 (PDT)
Date:   Thu, 14 Sep 2023 16:07:13 +0200
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
Subject: Re: [PATCH net-next v8 0/4] vsock/virtio/vhost: MSG_ZEROCOPY
 preparations
Message-ID: <554ugdobcmxraek662xkxjdehcu5ri6awxvhvlvnygyru5zlsx@e7cyloz6so7u>
References: <20230911202234.1932024-1-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230911202234.1932024-1-avkrasnov@salutedevices.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Arseniy,

On Mon, Sep 11, 2023 at 11:22:30PM +0300, Arseniy Krasnov wrote:
>Hello,
>
>this patchset is first of three parts of another big patchset for
>MSG_ZEROCOPY flag support:
>https://lore.kernel.org/netdev/20230701063947.3422088-1-AVKrasnov@sberdevices.ru/
>
>During review of this series, Stefano Garzarella <sgarzare@redhat.com>
>suggested to split it for three parts to simplify review and merging:
>
>1) virtio and vhost updates (for fragged skbs) <--- this patchset
>2) AF_VSOCK updates (allows to enable MSG_ZEROCOPY mode and read
>   tx completions) and update for Documentation/.
>3) Updates for tests and utils.
>
>This series enables handling of fragged skbs in virtio and vhost parts.
>Newly logic won't be triggered, because SO_ZEROCOPY options is still
>impossible to enable at this moment (next bunch of patches from big
>set above will enable it).
>
>I've included changelog to some patches anyway, because there were some
>comments during review of last big patchset from the link above.

Thanks, I left some comments on patch 4, the others LGTM.
Sorry to not having spotted them before, but moving
virtio_transport_alloc_skb() around the file, made the patch a little
confusing and difficult to review.

In addition, I started having failures of test 14 (server: host,
client: guest), so I looked better to see if there was anything wrong,
but it fails me even without this series applied.

It happens to me intermittently (~30%), does it happen to you?
Can you take a look at it?

host$ ./vsock_test --mode=server --control-port=12345 --peer-cid=4
...
14 - SOCK_STREAM virtio skb merge...expected recv(2) returns 8 bytes, got 3

guest$ ./vsock_test --mode=client --control-host=192.168.133.2 --control-port=12345 --peer-cid=2

Thanks,
Stefano

