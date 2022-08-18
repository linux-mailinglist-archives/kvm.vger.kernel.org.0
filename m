Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA37597D77
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 06:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243250AbiHRE3I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 00:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243346AbiHRE3H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 00:29:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D2C47BB4
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 21:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660796944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KCPrqwMbhashZs9ajDG3ZLy61/uPNuf+3BvVHV/Odhk=;
        b=foaSqwItVnI8ICNq1K7ko3JxdBUXZvRJJaOg/Fl3pjIX99+9XB5WO8h5kgYyza3pChWPfs
        JIz/gepQ8FUQoTM49Vf5FO0S5UNqUi9pB6lecqEVoEP41QIYfTFK6K/JeCi0FpcO0616CH
        jA7agAuOlveUci3RUa07Leqt2OBXzrE=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-222-vLzQFiQeOBK63U-lWPoTuQ-1; Thu, 18 Aug 2022 00:29:03 -0400
X-MC-Unique: vLzQFiQeOBK63U-lWPoTuQ-1
Received: by mail-pg1-f199.google.com with SMTP id f128-20020a636a86000000b004291bf13aa8so262910pgc.18
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 21:29:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=KCPrqwMbhashZs9ajDG3ZLy61/uPNuf+3BvVHV/Odhk=;
        b=iJgmSOhrN6CwRQL+8YAEWvVofhaYhoXZks1pqcanwK6zAZ8aQ0QB/NA5QMTtiC56ef
         TbrWJFrY1gh8cNRV9de21chsOyLnjsqkQTPWb2pz5t93WRzzDAZw+oXzQXtQ/e5gKWnb
         q0oD2W4kv5e7XKcAxF/lpcB+bl02lwJIWg9Ia8JMqltrRwT/pC+QQzhr5ulmP4NZTtFy
         Hii6yxFhZel0owJwkMmqYtpckux2ntqb+lZKjhbS5jonUDoDSwyvKxaA9rr1kNEtI2FR
         VFN0u9ic8yjivkY5l3HN0S4a/wHIxF1LqBTrmqzL/+as4UcBWPv1gOhUb2o//qEKvQ2C
         82VA==
X-Gm-Message-State: ACgBeo1Sd6AdfxoJq5tIpAYgZdiiA1FrdZPq1vUs8v7+hqc8AQ921zh9
        GsZ5n/fM2HvoM3E4VgtodbDPyK8DqQDa10LUpw7lubOrg6dukdsM82l3QMSyXQ9i/v1yv038+QS
        ybizT3QPUmlTK
X-Received: by 2002:a05:6a00:2446:b0:528:5da9:cc7 with SMTP id d6-20020a056a00244600b005285da90cc7mr1293854pfj.51.1660796941423;
        Wed, 17 Aug 2022 21:29:01 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7NMD4EVf5aRXovcw/8GOgAQdQuu/1flQGm1/lUUdQvP3AM0nmVQZrsmhqQ7p+cfFoK7Zf2dQ==
X-Received: by 2002:a05:6a00:2446:b0:528:5da9:cc7 with SMTP id d6-20020a056a00244600b005285da90cc7mr1293831pfj.51.1660796941080;
        Wed, 17 Aug 2022 21:29:01 -0700 (PDT)
Received: from [10.72.13.223] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o21-20020a170903211500b00170a757a191sm296595ple.9.2022.08.17.21.28.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 21:29:00 -0700 (PDT)
Message-ID: <3abb1be9-b12c-e658-0391-8461e28f1b33@redhat.com>
Date:   Thu, 18 Aug 2022 12:28:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [PATCH 0/6] virtio/vsock: introduce dgrams, sk_buff, and qdisc
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>
Cc:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <20220817025250-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220817025250-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/8/17 14:54, Michael S. Tsirkin 写道:
> On Mon, Aug 15, 2022 at 10:56:03AM -0700, Bobby Eshleman wrote:
>> Hey everybody,
>>
>> This series introduces datagrams, packet scheduling, and sk_buff usage
>> to virtio vsock.
>>
>> The usage of struct sk_buff benefits users by a) preparing vsock to use
>> other related systems that require sk_buff, such as sockmap and qdisc,
>> b) supporting basic congestion control via sock_alloc_send_skb, and c)
>> reducing copying when delivering packets to TAP.
>>
>> The socket layer no longer forces errors to be -ENOMEM, as typically
>> userspace expects -EAGAIN when the sk_sndbuf threshold is reached and
>> messages are being sent with option MSG_DONTWAIT.
>>
>> The datagram work is based off previous patches by Jiang Wang[1].
>>
>> The introduction of datagrams creates a transport layer fairness issue
>> where datagrams may freely starve streams of queue access. This happens
>> because, unlike streams, datagrams lack the transactions necessary for
>> calculating credits and throttling.
>>
>> Previous proposals introduce changes to the spec to add an additional
>> virtqueue pair for datagrams[1]. Although this solution works, using
>> Linux's qdisc for packet scheduling leverages already existing systems,
>> avoids the need to change the virtio specification, and gives additional
>> capabilities. The usage of SFQ or fq_codel, for example, may solve the
>> transport layer starvation problem. It is easy to imagine other use
>> cases as well. For example, services of varying importance may be
>> assigned different priorities, and qdisc will apply appropriate
>> priority-based scheduling. By default, the system default pfifo qdisc is
>> used. The qdisc may be bypassed and legacy queuing is resumed by simply
>> setting the virtio-vsock%d network device to state DOWN. This technique
>> still allows vsock to work with zero-configuration.
> The basic question to answer then is this: with a net device qdisc
> etc in the picture, how is this different from virtio net then?
> Why do you still want to use vsock?


Or maybe it's time to revisit an old idea[1] to unify at least the 
driver part (e.g using virtio-net driver for vsock then we can all 
features that vsock is lacking now)?

Thanks

[1] 
https://lists.linuxfoundation.org/pipermail/virtualization/2018-November/039783.html


>
>> In summary, this series introduces these major changes to vsock:
>>
>> - virtio vsock supports datagrams
>> - virtio vsock uses struct sk_buff instead of virtio_vsock_pkt
>>    - Because virtio vsock uses sk_buff, it also uses sock_alloc_send_skb,
>>      which applies the throttling threshold sk_sndbuf.
>> - The vsock socket layer supports returning errors other than -ENOMEM.
>>    - This is used to return -EAGAIN when the sk_sndbuf threshold is
>>      reached.
>> - virtio vsock uses a net_device, through which qdisc may be used.
>>   - qdisc allows scheduling policies to be applied to vsock flows.
>>    - Some qdiscs, like SFQ, may allow vsock to avoid transport layer congestion. That is,
>>      it may avoid datagrams from flooding out stream flows. The benefit
>>      to this is that additional virtqueues are not needed for datagrams.
>>    - The net_device and qdisc is bypassed by simply setting the
>>      net_device state to DOWN.
>>
>> [1]: https://lore.kernel.org/all/20210914055440.3121004-1-jiang.wang@bytedance.com/
>>
>> Bobby Eshleman (5):
>>    vsock: replace virtio_vsock_pkt with sk_buff
>>    vsock: return errors other than -ENOMEM to socket
>>    vsock: add netdev to vhost/virtio vsock
>>    virtio/vsock: add VIRTIO_VSOCK_F_DGRAM feature bit
>>    virtio/vsock: add support for dgram
>>
>> Jiang Wang (1):
>>    vsock_test: add tests for vsock dgram
>>
>>   drivers/vhost/vsock.c                   | 238 ++++----
>>   include/linux/virtio_vsock.h            |  73 ++-
>>   include/net/af_vsock.h                  |   2 +
>>   include/uapi/linux/virtio_vsock.h       |   2 +
>>   net/vmw_vsock/af_vsock.c                |  30 +-
>>   net/vmw_vsock/hyperv_transport.c        |   2 +-
>>   net/vmw_vsock/virtio_transport.c        | 237 +++++---
>>   net/vmw_vsock/virtio_transport_common.c | 771 ++++++++++++++++--------
>>   net/vmw_vsock/vmci_transport.c          |   9 +-
>>   net/vmw_vsock/vsock_loopback.c          |  51 +-
>>   tools/testing/vsock/util.c              | 105 ++++
>>   tools/testing/vsock/util.h              |   4 +
>>   tools/testing/vsock/vsock_test.c        | 195 ++++++
>>   13 files changed, 1176 insertions(+), 543 deletions(-)
>>
>> -- 
>> 2.35.1

