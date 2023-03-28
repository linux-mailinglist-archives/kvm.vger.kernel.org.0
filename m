Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32D756CBD57
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 13:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbjC1LUN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 07:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbjC1LUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 07:20:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F2CAB
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 04:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680002361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xTS3qxFhBqMP5asqq6o4vShlFpc+3Cgiy/wm+SvxL0Q=;
        b=E4nXNwQoeURnz5bknTQx7aZmKkHu4q8IaDd94j01/oc6/LC+ckUjHJejWhksCnmPW9ZipZ
        zDL6L2eHDiMfDcDddU1qAHG1xeAmNyhklNczvYYd6gWgsCyADc6O49+wK+PqOC0aBAglsz
        lxpIBPQtJR9TeUzOyb04iv4CPU84JCY=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-tWtKoCW3MuqRDUlleVx50w-1; Tue, 28 Mar 2023 07:19:20 -0400
X-MC-Unique: tWtKoCW3MuqRDUlleVx50w-1
Received: by mail-qt1-f199.google.com with SMTP id x5-20020a05622a000500b003e259c363f9so7904581qtw.22
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 04:19:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680002360;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xTS3qxFhBqMP5asqq6o4vShlFpc+3Cgiy/wm+SvxL0Q=;
        b=KeswNrCQmWsbngt2dswWwlkZi0UOG1le2WyBCDMThnVWBxVvW5sF3bGsEozU6Bq7cL
         pD/CRloDXqQDWHufrq0Zjl3pOMH0EjMzmQFFi7s1zXrCkTWqx+Rr7KxaN1+M4PBoG44g
         kjjff9IwdMAyQQBkYLMSEu6nlAr5CYqmJeVB0p1iEUFmvgw+gW4qZHudGStCrU00FiOs
         q/GkLnBU2xlWuBwapgEYTIut2U4pvnpxBZLL9q4i70Ekr9pxu1yGY/JUNXoXejrE9jR1
         tmD6LGbpds4QnO45IRGaXbukgd9CaPVe7JZTtAH/94sPBCMZ2rjoIupJKD+dxm06Psjh
         mCpw==
X-Gm-Message-State: AO0yUKWbvYbrZxOV+QU82j8YwSYd2+GUrprzqZCexKX3kopZRyc7e3wJ
        HVvDI9WuYfWiB0fEZqg8hwRRGfzpyaRARjLwmtQ2giRO1c8dLQIjSpkOJZiJhcC3pd5vFSqmcwA
        B/caqETdS33rF
X-Received: by 2002:a05:622a:88:b0:3d8:3aed:66f4 with SMTP id o8-20020a05622a008800b003d83aed66f4mr26549972qtw.41.1680002359528;
        Tue, 28 Mar 2023 04:19:19 -0700 (PDT)
X-Google-Smtp-Source: AK7set9rLhqoc1M0lOv19pEk7kytc7wZbIHzVGbGY5clwetaWE5MDsGKBYhOBeIW8AABeuWV7JcagA==
X-Received: by 2002:a05:622a:88:b0:3d8:3aed:66f4 with SMTP id o8-20020a05622a008800b003d83aed66f4mr26549929qtw.41.1680002359066;
        Tue, 28 Mar 2023 04:19:19 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id v127-20020a379385000000b007456c75edbbsm17581456qkd.129.2023.03.28.04.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 04:19:18 -0700 (PDT)
Date:   Tue, 28 Mar 2023 13:19:13 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>,
        Vishnu Dasa <vdasa@vmware.com>
Cc:     Bryan Tan <bryantan@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v1 1/2] vsock: return errors other than -ENOMEM to
 socket
Message-ID: <ak74j6l2qesrixxmw7pfw56najqhdn32lv3xfxcb53nvmkyi3x@fr25vo2jlvbj>
References: <97f19214-ba04-c47e-7486-72e8aa16c690@sberdevices.ru>
 <99da938b-3e67-150c-2f74-41d917a95950@sberdevices.ru>
 <itjmw7vh3a7ggbodsu4mksu2hqbpdpxmu6cpexbra66nfhsw4x@hzpuzwldkfx5>
 <CAGxU2F648TyvAJN+Zk6YCnGUhn=0W_MZTox7RxQ45zHmHHO0SA@mail.gmail.com>
 <0f0a8603-e8a1-5fb2-23d9-5773c808ef85@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0f0a8603-e8a1-5fb2-23d9-5773c808ef85@sberdevices.ru>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 28, 2023 at 01:42:19PM +0300, Arseniy Krasnov wrote:
>
>
>On 28.03.2023 12:42, Stefano Garzarella wrote:
>> I pressed send too early...
>>
>> CCing Bryan, Vishnu, and pv-drivers@vmware.com
>>
>> On Tue, Mar 28, 2023 at 11:39 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>>
>>> On Sun, Mar 26, 2023 at 01:13:11AM +0300, Arseniy Krasnov wrote:
>>>> This removes behaviour, where error code returned from any transport
>>>> was always switched to ENOMEM. This works in the same way as:
>>>> commit
>>>> c43170b7e157 ("vsock: return errors other than -ENOMEM to socket"),
>>>> but for receive calls.
>>>>
>>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>>> ---
>>>> net/vmw_vsock/af_vsock.c | 4 ++--
>>>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>>> index 19aea7cba26e..9262e0b77d47 100644
>>>> --- a/net/vmw_vsock/af_vsock.c
>>>> +++ b/net/vmw_vsock/af_vsock.c
>>>> @@ -2007,7 +2007,7 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
>>>>
>>>>               read = transport->stream_dequeue(vsk, msg, len - copied, flags);
>>>
>>> In vmci_transport_stream_dequeue() vmci_qpair_peekv() and
>>> vmci_qpair_dequev() return VMCI_ERROR_* in case of errors.
>>>
>>> Maybe we should return -ENOMEM in vmci_transport_stream_dequeue() if
>>> those functions fail to keep the same behavior.
>
>Yes, seems i missed it, because several months ago we had similar question for send
>logic:
>https://www.spinics.net/lists/kernel/msg4611091.html
>And it was ok to not handle VMCI send path in this way. So i think current implementation
>for tx is a little bit buggy, because VMCI specific error from 'vmci_qpair_enquev()' is
>returned to af_vsock.c. I think error conversion must be added to VMCI transport for tx
>also.

Good point!

These are negative values, so there are no big problems, but I don't
know what the user expects in this case.

@Vishnu Do we want to return an errno to the user or a VMCI_ERROR_*?

In both cases I think we should do the same for both enqueue and
dequeue.

>
>Good thing is that Hyper-V uses general error codes.

Yeah!

Thanks,
Stefano

>
>Thanks, Arseniy
>>>
>>> CCing Bryan, Vishnu, and pv-drivers@vmware.com
>>>
>>> The other transports seem okay to me.
>>>
>>> Thanks,
>>> Stefano
>>>
>>>>               if (read < 0) {
>>>> -                      err = -ENOMEM;
>>>> +                      err = read;
>>>>                       break;
>>>>               }
>>>>
>>>> @@ -2058,7 +2058,7 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
>>>>       msg_len = transport->seqpacket_dequeue(vsk, msg, flags);
>>>>
>>>>       if (msg_len < 0) {
>>>> -              err = -ENOMEM;
>>>> +              err = msg_len;
>>>>               goto out;
>>>>       }
>>>>
>>>> --
>>>> 2.25.1
>>>>
>>
>

