Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 926A66A56D1
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 11:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjB1KdC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 05:33:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjB1KdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 05:33:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67CD3C2F
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 02:32:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677580332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pWE/IH7Gk0DOgzMvd0Lmdxjp64jnYWrJuTM5923X0kE=;
        b=Lt+N7wWFmnChMA292fPo1vPyNjczdrKd4xEFY4NnwOCaRwHi8DS+SeGROhEAVeAQEMPZ/q
        legc2NMRzsFD/7akTWLNn6+DBDxiAkQr1ZgPPFKd8iXcjtS65gB1rhJdH49DwiHX129kc0
        u5u8bcyn/9ciEc7XXtthQW67vNDqH3o=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-21-eQE3l2JJP8ek__28QaGzBA-1; Tue, 28 Feb 2023 05:32:10 -0500
X-MC-Unique: eQE3l2JJP8ek__28QaGzBA-1
Received: by mail-wr1-f69.google.com with SMTP id g6-20020adfa486000000b002c55ef1ec94so1422589wrb.0
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 02:32:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pWE/IH7Gk0DOgzMvd0Lmdxjp64jnYWrJuTM5923X0kE=;
        b=nZrUrMJ3/fI0clj9xenEwk/Epy3i5FWZ8oBr6auMn2UpjYfdX4S5IJlGPBfYXoL0oK
         rpGCAy+lRMQHxAH3y/1VUx/lWyXOmoqPIJYLkmuMvb9izZKUOLvCU1rkAxqITgHjtcWt
         B0GLmpUIByYxniQKzL78aSwTraFaDjTrGN5zkHEQBcNEZikU6H/C5Npk1SLUspBqa/EF
         p1mpCNOya4HMYb7ULQ8GbtYuuy7dnO1o4+xF6w5UwWefUecc/KlgxQ0OOq3ZeyHaV4uw
         +FKZhP66O7pZTiOHetbeVtLeWjahTcqx0O0NZmk48XIrk9dYeMi6l1Wf2C80TRWxNncF
         VoQg==
X-Gm-Message-State: AO0yUKVIIuyRRKCie+y2a/fQl4c473LITMA2AVvAKG4FHvahkXi1CbFL
        oKCAOGHsAjIV6Y4uQKZ1wTik1vIRB1USwmYI5KY2rcqAFTEtzGYP5BgSVUf1PVwO47ff50xLAkE
        T+j0eD4qnYfMf
X-Received: by 2002:a5d:6f1b:0:b0:2bf:bf05:85ac with SMTP id ay27-20020a5d6f1b000000b002bfbf0585acmr1808253wrb.23.1677580329580;
        Tue, 28 Feb 2023 02:32:09 -0800 (PST)
X-Google-Smtp-Source: AK7set9ZFVtpNUSDKjWbiaTH1BQVRiKxdUcmbd6hiGVcxOhG2xmXBJ61c13FJ8zRMszkvybFURNUgQ==
X-Received: by 2002:a5d:6f1b:0:b0:2bf:bf05:85ac with SMTP id ay27-20020a5d6f1b000000b002bfbf0585acmr1808234wrb.23.1677580329303;
        Tue, 28 Feb 2023 02:32:09 -0800 (PST)
Received: from sgarzare-redhat (c-115-213.cust-q.wadsl.it. [212.43.115.213])
        by smtp.gmail.com with ESMTPSA id k28-20020a5d525c000000b002c556a4f1casm9321915wrc.42.2023.02.28.02.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 02:32:08 -0800 (PST)
Date:   Tue, 28 Feb 2023 11:32:05 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Krasnov Arseniy <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 12/12] test/vsock: MSG_ZEROCOPY support for
 vsock_perf
Message-ID: <20230228103205.6vorc4z363wtxwlk@sgarzare-redhat>
References: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
 <03570f48-f56a-2af4-9579-15a685127aeb@sberdevices.ru>
 <20230216152945.qdh6vrq66pl2bfxe@sgarzare-redhat>
 <d5de8b79-f903-d65f-a5bc-e591578144e7@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d5de8b79-f903-d65f-a5bc-e591578144e7@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 20, 2023 at 09:05:12AM +0000, Krasnov Arseniy wrote:
>On 16.02.2023 18:29, Stefano Garzarella wrote:
>> On Mon, Feb 06, 2023 at 07:06:32AM +0000, Arseniy Krasnov wrote:
>>> To use this option pass '--zc' parameter:
>>
>> --zerocopy or --zero-copy maybe better follow what we did with the other parameters :-)
>>
>>>
>>> ./vsock_perf --zc --sender <cid> --port <port> --bytes <bytes to send>
>>>
>>> With this option MSG_ZEROCOPY flag will be passed to the 'send()' call.
>>>
>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>> ---
>>> tools/testing/vsock/vsock_perf.c | 127 +++++++++++++++++++++++++++++--
>>> 1 file changed, 120 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/tools/testing/vsock/vsock_perf.c b/tools/testing/vsock/vsock_perf.c
>>> index a72520338f84..1d435be9b48e 100644
>>> --- a/tools/testing/vsock/vsock_perf.c
>>> +++ b/tools/testing/vsock/vsock_perf.c
>>> @@ -18,6 +18,8 @@
>>> #include <poll.h>
>>> #include <sys/socket.h>
>>> #include <linux/vm_sockets.h>
>>> +#include <sys/mman.h>
>>> +#include <linux/errqueue.h>
>>>
>>> #define DEFAULT_BUF_SIZE_BYTES    (128 * 1024)
>>> #define DEFAULT_TO_SEND_BYTES    (64 * 1024)
>>> @@ -28,9 +30,14 @@
>>> #define BYTES_PER_GB        (1024 * 1024 * 1024ULL)
>>> #define NSEC_PER_SEC        (1000000000ULL)
>>>
>>> +#ifndef SOL_VSOCK
>>> +#define SOL_VSOCK 287
>>> +#endif
>>
>> I thought we use the current kernel headers when we compile the tests,
>> do we need to fix something in the makefile?
>Not sure, of course we are using uapi. But i see, that defines like SOL_XXX is not
>defined in uapi headers. For example SOL_IP is defined in include/linux/socket.h,
>but userspace app uses SOL_IP from in.h (at least on my machine). E.g. SOL_XXX is
>not exported to user.

Right, I see only few SOL_* in the uapi, e.g. SOL_TIPC in 
uapi/linux/tipc.h

So it's fine for now, otherwise we can define it in 
uapi/linux/vm_sockets.h

Thanks,
Stefano

