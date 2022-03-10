Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858544D4541
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 12:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238094AbiCJLBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 06:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235037AbiCJLBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 06:01:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CE91313AA11
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 03:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646910042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AsfeyKqrBgkYuQzWFN//9BncY2nLecQ3kO20U/V6vFk=;
        b=NmnpEnq0YO8KKyQLu8GL2pdKpFXNI6MHcmDfqaruCkAGQTIEwuqs1PjCiE1x9359yg5Ixc
        ieJ8Q312fruBml7C06vQ2UfrbpthRA0BQbr25g/WYxcBnNIhszL71nHpGgHqNbO2K6Bxre
        Eq/bfInyOy0Piay5/SVs4dZLkGoWN3o=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-jM3yx4RWOQGbvvXM6XMhyg-1; Thu, 10 Mar 2022 06:00:41 -0500
X-MC-Unique: jM3yx4RWOQGbvvXM6XMhyg-1
Received: by mail-wr1-f70.google.com with SMTP id f14-20020adfc98e000000b001e8593b40b0so1549691wrh.14
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 03:00:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AsfeyKqrBgkYuQzWFN//9BncY2nLecQ3kO20U/V6vFk=;
        b=iUYze26c9h+3ZSKelzVhQPf8t+/sCre354w9mJo924rfIv5DH6ZckdjK2Ww++Walh0
         8cV7qai1juWrIWgYLuKyFpPaQ8xl6MO0cwapupr7kNCGe/YeMotEWW+dF7oB1h/qMyAv
         sKn3qLl+5JExdMf58AWEktQQNa6wACwgBU4JQ73AMwDvTPUnwPIwSb6s6kdVWU/Ocguc
         uq7Y0M/l4CtyaXuHsqUsSRpq1VIzLoGUSzdoO/UJp/Knjf+AkKpk0O1VPksu4DCDbY8z
         Q2y6/ogzm6rjs4Ky4yfJhjFYvkTakrdYvio+652J+pyaIdHZ1u7iMwX5L6hmTcHjNZAe
         coIQ==
X-Gm-Message-State: AOAM5328jwxM3czJdVpscl2Rh0xm/eIyzth+wW8xzgsQRVdfyKbclGfd
        rmkJkeWzuT+ZCIDlJ+OIVKJd8tFXHo0TBNoNFuz1n7wDUvBu4WD5HzpAcyT3FeKOrI/yslwvu7p
        8nC1/Z53Jhucw
X-Received: by 2002:a1c:f30b:0:b0:37b:b5de:c804 with SMTP id q11-20020a1cf30b000000b0037bb5dec804mr11036409wmq.166.1646910040151;
        Thu, 10 Mar 2022 03:00:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzE//Um8fdzz7IHgiVk+0r92oJeOzoNXJHMsqiiiF0zWaYyYnqN4PdqnWhKpxWaqHo+iNwr5g==
X-Received: by 2002:a1c:f30b:0:b0:37b:b5de:c804 with SMTP id q11-20020a1cf30b000000b0037bb5dec804mr11036389wmq.166.1646910039856;
        Thu, 10 Mar 2022 03:00:39 -0800 (PST)
Received: from sgarzare-redhat (host-212-171-187-184.pool212171.interbusiness.it. [212.171.187.184])
        by smtp.gmail.com with ESMTPSA id m3-20020a5d6243000000b001e33760776fsm3863935wrv.10.2022.03.10.03.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 03:00:39 -0800 (PST)
Date:   Thu, 10 Mar 2022 12:00:36 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jiyong Park <jiyong@google.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, adelva@google.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost/vsock: reset only the h2g connections upon release
Message-ID: <20220310110036.fgy323c4hvk3mziq@sgarzare-redhat>
References: <20220310081854.2487280-1-jiyong@google.com>
 <20220310085931.cpgc2cv4yg7sd4vu@sgarzare-redhat>
 <CALeUXe6heGD9J+5fkLs9TJ7Mn0UT=BSdGNK_wZ4gkor_Ax_SqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CALeUXe6heGD9J+5fkLs9TJ7Mn0UT=BSdGNK_wZ4gkor_Ax_SqA@mail.gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 10, 2022 at 07:41:54PM +0900, Jiyong Park wrote:
>Hi Stefano,
>
>On Thu, Mar 10, 2022 at 5:59 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> Hi Jiyong,
>>
>> On Thu, Mar 10, 2022 at 05:18:54PM +0900, Jiyong Park wrote:
>> >Filtering non-h2g connections out when determining orphaned connections.
>> >Otherwise, in a nested VM configuration, destroying the nested VM (which
>> >often involves the closing of /dev/vhost-vsock if there was h2g
>> >connections to the nested VM) kills not only the h2g connections, but
>> >also all existing g2h connections to the (outmost) host which are
>> >totally unrelated.
>> >
>> >Tested: Executed the following steps on Cuttlefish (Android running on a
>> >VM) [1]: (1) Enter into an `adb shell` session - to have a g2h
>> >connection inside the VM, (2) open and then close /dev/vhost-vsock by
>> >`exec 3< /dev/vhost-vsock && exec 3<&-`, (3) observe that the adb
>> >session is not reset.
>> >
>> >[1] https://android.googlesource.com/device/google/cuttlefish/
>> >
>> >Signed-off-by: Jiyong Park <jiyong@google.com>
>> >---
>> > drivers/vhost/vsock.c | 4 ++++
>> > 1 file changed, 4 insertions(+)
>> >
>> >diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>> >index 37f0b4274113..2f6d5d66f5ed 100644
>> >--- a/drivers/vhost/vsock.c
>> >+++ b/drivers/vhost/vsock.c
>> >@@ -722,6 +722,10 @@ static void vhost_vsock_reset_orphans(struct sock *sk)
>> >        * executing.
>> >        */
>> >
>> >+      /* Only the h2g connections are reset */
>> >+      if (vsk->transport != &vhost_transport.transport)
>> >+              return;
>> >+
>> >       /* If the peer is still valid, no need to reset connection */
>> >       if (vhost_vsock_get(vsk->remote_addr.svm_cid))
>> >               return;
>> >--
>> >2.35.1.723.g4982287a31-goog
>> >
>>
>> Thanks for your patch!
>>
>> Yes, I see the problem and I think I introduced it with the
>> multi-transports support (ooops).
>>
>> So we should add this fixes tag:
>>
>> Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
>>
>>
>> IIUC the problem is for all transports that should only cycle on their
>> own sockets. Indeed I think there is the same problem if the g2h driver
>> will be unloaded (or a reset event is received after a VM migration), it
>> will close all sockets of the nested h2g.
>>
>> So I suggest a more generic solution, modifying
>> vsock_for_each_connected_socket() like this (not tested):
>>
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index 38baeb189d4e..f04abf662ec6 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -334,7 +334,8 @@ void vsock_remove_sock(struct vsock_sock *vsk)
>>   }
>>   EXPORT_SYMBOL_GPL(vsock_remove_sock);
>>
>> -void vsock_for_each_connected_socket(void (*fn)(struct sock *sk))
>> +void vsock_for_each_connected_socket(struct vsock_transport *transport,
>> +                                    void (*fn)(struct sock *sk))
>>   {
>>          int i;
>>
>> @@ -343,8 +344,12 @@ void vsock_for_each_connected_socket(void (*fn)(struct sock *sk))
>>          for (i = 0; i < ARRAY_SIZE(vsock_connected_table); i++) {
>>                  struct vsock_sock *vsk;
>>                  list_for_each_entry(vsk, &vsock_connected_table[i],
>> -                                   connected_table)
>> +                                   connected_table) {
>> +                       if (vsk->transport != transport)
>> +                               continue;
>> +
>>                          fn(sk_vsock(vsk));
>> +               }
>>          }
>>
>>
>> And all transports that call it.
>>
>> Thanks,
>> Stefano
>>
>
>Thanks for the suggestion, which looks much better. It actually worked well.

Thanks for trying this!

>
>By the way, the suggested change will alter the kernel-module interface (KMI),
>which will make it difficult to land the change on older releases where we'd
>like to keep the KMI stable [1]. Would it be OK if we let the supplied function
>(fn) be responsible for checking the transport? I think that there, in
>the future,
>might be a case where one needs to cycle over all sockets for inspection or so.
>I admit that this would be prone to error, though.
>
>Please let me know what you think. I don't have a strong preference. I will
>submit a revision as you want.

I see your point, and it makes sense to keep KMI on stable branches, but 
mainline I would like to have the proposed approach since all transports 
use it to cycle on their sockets.

So we could do a series with 2 patches:
- Patch 1 fixes the problem in all transports by checking the transport
   in the callback (here we insert the fixes tag so we backport it to the
   stable branches)
- Patch 2 moves the check in vsock_for_each_connected_socket() removing
   it from callbacks so it is less prone to errors and we merge it only
   mainline

What do you think?

Thanks,
Stefano

