Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64167B858D
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 18:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243457AbjJDQn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 12:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233485AbjJDQn0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 12:43:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD08AAB
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 09:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696437757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PQchYUvGxxsCc4djV8D5Ngra+tr0SbVapL0lFjxteFg=;
        b=Wesc6ScHQPUSexd6hJ7NG/FRJfWCCKlXPe23WDHKKivc+EoH2D0LW2jeXnQoBcoQZUw5vN
        zfiQ+GGR0yUyI0LBN1RfS3XtmKMe38lTWQeIUBT3s713RF0BQhJ7eF1Ebxhf9Yt/ezol0R
        TbMRDjWP/miiW8gHF8D9vN6BQhEkS7M=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-jEHApPJwMxqi3bAZfPufgQ-1; Wed, 04 Oct 2023 12:42:25 -0400
X-MC-Unique: jEHApPJwMxqi3bAZfPufgQ-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-77593f7173eso1893385a.0
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 09:42:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696437745; x=1697042545;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PQchYUvGxxsCc4djV8D5Ngra+tr0SbVapL0lFjxteFg=;
        b=K3gzgeUO7msrgHxiphND25iIvq7de9mbT9erYKh5ezw8vF57Lfructgc/9Kq44Dkce
         PydgbjWbU1A8NAnKuQW3qaICFT0bOYnSZOmpykZiKoCqscdLX21Y1gi6Go9BqSH763Qq
         5xqxf71Qm/iagcDYIYJ8MpRscp7uelrhSDw8SMwA38e67G80yupXBqxal9ULexGNU/aS
         7Bp/l0RQ3X8ddcXF1uaqeeJmsJzGpNlIZzx8kamMWoNuMFTKnPb++njd/N5/+UwCes4E
         7u+lAVUh4HvbrWY3Bk1zM6VPKPYyvC8m+DgaXGi6INnDGuH151Dc34YzMEhEyC5e3z6J
         t/CQ==
X-Gm-Message-State: AOJu0Yznl1l9IeFPR133akiiwAtRyK/+cU5nceqbr1d7mjYNDhtyGyWK
        XxYmZzhiR6X7aa6WnGZNYU8SEONsl66UrPtB7iSpvWecrK+SNFTqQL3SzgCxObYVqg04US1GPTq
        uTtOGtBboyt7x
X-Received: by 2002:a05:620a:258f:b0:767:1d7e:ec40 with SMTP id x15-20020a05620a258f00b007671d7eec40mr3175079qko.1.1696437745120;
        Wed, 04 Oct 2023 09:42:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEt9ZzO3ODQL872WyKfk3Dg3TgfHXkRo+gA8ZChzf0rtqBB4Wiu+lGNy76VPmqz4kqAeDz51Q==
X-Received: by 2002:a05:620a:258f:b0:767:1d7e:ec40 with SMTP id x15-20020a05620a258f00b007671d7eec40mr3175068qko.1.1696437744855;
        Wed, 04 Oct 2023 09:42:24 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-114.retail.telecomitalia.it. [82.57.51.114])
        by smtp.gmail.com with ESMTPSA id o15-20020ae9f50f000000b0076cb1eff83csm1387058qkg.5.2023.10.04.09.42.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Oct 2023 09:42:24 -0700 (PDT)
Date:   Wed, 4 Oct 2023 18:42:18 +0200
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
Subject: Re: [PATCH net-next v2 00/12] vsock/virtio: continue MSG_ZEROCOPY
 support
Message-ID: <zilryvqespe5k4d3xjer2fcrseqo3yu3lvairvobvop6shqvsz@gzdmzpujxzkx>
References: <20230930210308.2394919-1-avkrasnov@salutedevices.com>
 <4nwo6nd2ihjqsoqnjdjhuucqyc4fhfhxk52q6ulrs6sd2fmf7z@24hi65hbpl4i>
 <aef9a438-3c61-44ec-688f-ed89eb886bfd@salutedevices.com>
 <5ae3b08d-bcbb-514c-856a-94c538796714@salutedevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5ae3b08d-bcbb-514c-856a-94c538796714@salutedevices.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 04, 2023 at 07:22:04PM +0300, Arseniy Krasnov wrote:
>
>
>On 04.10.2023 08:25, Arseniy Krasnov wrote:
>>
>>
>> On 03.10.2023 19:26, Stefano Garzarella wrote:
>>> Hi Arseniy,
>>>
>>> On Sun, Oct 01, 2023 at 12:02:56AM +0300, Arseniy Krasnov wrote:
>>>> Hello,
>>>>
>>>> this patchset contains second and third parts of another big patchset
>>>> for MSG_ZEROCOPY flag support:
>>>> https://lore.kernel.org/netdev/20230701063947.3422088-1-AVKrasnov@sberdevices.ru/
>>>>
>>>> During review of this series, Stefano Garzarella <sgarzare@redhat.com>
>>>> suggested to split it for three parts to simplify review and merging:
>>>>
>>>> 1) virtio and vhost updates (for fragged skbs) (merged to net-next, see
>>>>   link below)
>>>> 2) AF_VSOCK updates (allows to enable MSG_ZEROCOPY mode and read
>>>>   tx completions) and update for Documentation/. <-- this patchset
>>>> 3) Updates for tests and utils. <-- this patchset
>>>>
>>>> Part 1) was merged:
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=71b263e79370348349553ecdf46f4a69eb436dc7
>>>>
>>>> Head for this patchset is:
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=236f3873b517acfaf949c23bb2d5dec13bfd2da2
>>>>
>>>> Link to v1:
>>>> https://lore.kernel.org/netdev/20230922052428.4005676-1-avkrasnov@salutedevices.com/
>>>>
>>>> Changelog:
>>>> v1 -> v2:
>>>> * Patchset rebased and tested on new HEAD of net-next (see hash above).
>>>> * See per-patch changelog after ---.
>>>
>>> Thanks for this new version.
>>> I started to include vsock_uring_test in my test suite and tests are
>>> going well.
>>>
>>> I reviewed code patches, I still need to review the tests.
>>> I'll do that by the end of the week, but they looks good!
>>
>> Thanks for review! Ok, I'll wait for tests review, and then send next
>> version.
>
>Got your comments from review. I'll update patches by:
>1) Trying to avoid touching util.c/util.h

I mean, we can touch it ;-) but for this case it looks like we don't
need most of that functions to be there.

At least for now. If we need them to be used in more places, then it
makes sense.

>2) Add new header with functions shared between util vsock_perf and
>tests

We can do this also later in another PR as cleanup if you prefer.

Thanks,
Stefano

