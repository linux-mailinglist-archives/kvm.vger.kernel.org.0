Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC786E76FB
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 12:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbjDSKBT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 06:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232548AbjDSKBP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 06:01:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40362D4C
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 03:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681898427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XQ6sCjmuWnVFb8UpDGaTI+MOdoOd+qfctALNM5m0k+g=;
        b=hyV+3+J5NOvASYRXZY6sjWgrk7FeoYvE6+CJOzZoFDjGnwiGxVV0k3Y0d8d11g+VL747i9
        XvPHjJCbgG/xxvbT/7Hv4d1ntscg1J1AvE5eN+J7sssgzasev3DVDknt2vfHSX9uyU5RW9
        tgcpXAucWBlnRf/xDCV6+ws4/JufQXY=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-7J8-nRs9P6KqHMZ0KVOPZg-1; Wed, 19 Apr 2023 06:00:25 -0400
X-MC-Unique: 7J8-nRs9P6KqHMZ0KVOPZg-1
Received: by mail-qt1-f199.google.com with SMTP id 13-20020ac8570d000000b003e37d3e6de2so22352976qtw.16
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 03:00:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681898425; x=1684490425;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XQ6sCjmuWnVFb8UpDGaTI+MOdoOd+qfctALNM5m0k+g=;
        b=TbP5VAu048YLx6U3acLr34edIw/CMjhzlEb4GGcktJiVg3BChYzmPXQNK3uEzhMxC/
         lFfjtrlfqvZjDovIF8xsa1rt2EcS6LcQpgHlJasGc4fl8e/3ltSYh6n+zR/hEk4P9NhE
         6sV2CyFyMpIGeyxSgU69Zvn8yWZdAgVIhsQxs7eOmmJw9b+aY/Ph3nRDod/TBqb4ovxf
         KeIzp91pHu53AW7IX4TMBwFMRtSdHoqXnTVgvI3B/2Je7cGMCQS3eY+/ItWf9s+tDmy5
         UvzRnL0RzxPYWtruu5m0tMtxjoTlranxa2D+dCrH4AOPnHWCwQ7JPjPLZK4TFpKfc/S4
         fS6w==
X-Gm-Message-State: AAQBX9cF1O1+jMT/rNR4kLsEKvb6Z/+7ET2Tdcl8tzv4Y/mLAspeNHav
        MrJppuRkzbcCw4WwgHFSGBNWiR4t349PI2+AaCC9LbHismL5hSpGRgsj2HjW9K3IAE2QWgB4MgR
        kcfs6bLE866Sz
X-Received: by 2002:a05:622a:44e:b0:3ef:437e:c828 with SMTP id o14-20020a05622a044e00b003ef437ec828mr1647525qtx.54.1681898424516;
        Wed, 19 Apr 2023 03:00:24 -0700 (PDT)
X-Google-Smtp-Source: AKy350bx/DlObVliHPvUfPOoqrhYKHpZuPyTlGGGIslCUKrTunefbYRtBDLkw2QCfpHp8ro/QNbCag==
X-Received: by 2002:a05:622a:44e:b0:3ef:437e:c828 with SMTP id o14-20020a05622a044e00b003ef437ec828mr1647485qtx.54.1681898424062;
        Wed, 19 Apr 2023 03:00:24 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-157.retail.telecomitalia.it. [82.53.134.157])
        by smtp.gmail.com with ESMTPSA id bq16-20020a05620a469000b007484d284cdasm4564029qkb.93.2023.04.19.03.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 03:00:23 -0700 (PDT)
Date:   Wed, 19 Apr 2023 12:00:17 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobbyeshleman@gmail.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH RFC net-next v2 0/4] virtio/vsock: support datagrams
Message-ID: <r6oxanmhwlonb7lcrrowpitlgobivzp7pcwk7snqvfnzudi6pb@4rnio5wef3qu>
References: <20230413-b4-vsock-dgram-v2-0-079cc7cee62e@bytedance.com>
 <ZDk2kOVnUvyLMLKE@bullseye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZDk2kOVnUvyLMLKE@bullseye>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Bobby,

On Fri, Apr 14, 2023 at 11:18:40AM +0000, Bobby Eshleman wrote:
>CC'ing Cong.
>
>On Fri, Apr 14, 2023 at 12:25:56AM +0000, Bobby Eshleman wrote:
>> Hey all!
>>
>> This series introduces support for datagrams to virtio/vsock.

Great! Thanks for restarting this work!

>>
>> It is a spin-off (and smaller version) of this series from the summer:
>>   https://lore.kernel.org/all/cover.1660362668.git.bobby.eshleman@bytedance.com/
>>
>> Please note that this is an RFC and should not be merged until
>> associated changes are made to the virtio specification, which will
>> follow after discussion from this series.
>>
>> This series first supports datagrams in a basic form for virtio, and
>> then optimizes the sendpath for all transports.
>>
>> The result is a very fast datagram communication protocol that
>> outperforms even UDP on multi-queue virtio-net w/ vhost on a variety
>> of multi-threaded workload samples.
>>
>> For those that are curious, some summary data comparing UDP and VSOCK
>> DGRAM (N=5):
>>
>> 	vCPUS: 16
>> 	virtio-net queues: 16
>> 	payload size: 4KB
>> 	Setup: bare metal + vm (non-nested)
>>
>> 	UDP: 287.59 MB/s
>> 	VSOCK DGRAM: 509.2 MB/s
>>
>> Some notes about the implementation...
>>
>> This datagram implementation forces datagrams to self-throttle according
>> to the threshold set by sk_sndbuf. It behaves similar to the credits
>> used by streams in its effect on throughput and memory consumption, but
>> it is not influenced by the receiving socket as credits are.

So, sk_sndbuf influece the sender and sk_rcvbuf the receiver, right?

We should check if VMCI behaves the same.

>>
>> The device drops packets silently. There is room for improvement by
>> building into the device and driver some intelligence around how to
>> reduce frequency of kicking the virtqueue when packet loss is high. I
>> think there is a good discussion to be had on this.

Can you elaborate a bit here?

Do you mean some mechanism to report to the sender that a destination
(cid, port) is full so the packet will be dropped?

Can we adapt the credit mechanism?

>>
>> In this series I am also proposing that fairness be reexamined as an
>> issue separate from datagrams, which differs from my previous series
>> that coupled these issues. After further testing and reflection on the
>> design, I do not believe that these need to be coupled and I do not
>> believe this implementation introduces additional unfairness or
>> exacerbates pre-existing unfairness.

I see.

>>
>> I attempted to characterize vsock fairness by using a pool of processes
>> to stress test the shared resources while measuring the performance of a
>> lone stream socket. Given unfair preference for datagrams, we would
>> assume that a lone stream socket would degrade much more when a pool of
>> datagram sockets was stressing the system than when a pool of stream
>> sockets are stressing the system. The result, however, showed no
>> significant difference between the degradation of throughput of the lone
>> stream socket when using a pool of datagrams to stress the queue over
>> using a pool of streams. The absolute difference in throughput actually
>> favored datagrams as interfering least as the mean difference was +16%
>> compared to using streams to stress test (N=7), but it was not
>> statistically significant. Workloads were matched for payload size and
>> buffer size (to approximate memory consumption) and process count, and
>> stress workloads were configured to start before and last long after the
>> lifetime of the "lone" stream socket flow to ensure that competing flows
>> were continuously hot.
>>
>> Given the above data, I propose that vsock fairness be addressed
>> independent of datagrams and to defer its implementation to a future
>> series.

Makes sense to me.

I left some preliminary comments, anyway now it seems reasonable to use
the same virtqueues, so we can go head with the spec proposal.

Thanks,
Stefano

