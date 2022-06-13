Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE43B548261
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 10:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240405AbiFMIye (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 04:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240072AbiFMIyd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 04:54:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B59EBB4A7
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 01:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655110471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4KjgQ8HGSq2J7WMLesh9KTKYS17SXSbspP3uqq4OPEY=;
        b=FplIrzeUgx+JLlqGubSL0uimS0Q2/Ck7UozME/qb0CIAkAfBMXHbFS3h/JlWYzWcV1ElQr
        rCPZSwiJrpPvC0q2hQG0aO00l/r32bhS28A7cULL2dSinvho8a5m6bizUUp9RxpgPe+Z0U
        WOLBLHMy5gQBizKmybWh+QSQspT4jsY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-445-9znk6q88NsajeUHquaYm_A-1; Mon, 13 Jun 2022 04:54:30 -0400
X-MC-Unique: 9znk6q88NsajeUHquaYm_A-1
Received: by mail-qk1-f200.google.com with SMTP id bk10-20020a05620a1a0a00b006a6b1d676ebso4576550qkb.0
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 01:54:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4KjgQ8HGSq2J7WMLesh9KTKYS17SXSbspP3uqq4OPEY=;
        b=jUhbt45I8LyNYgIvC7YwgWCPYOjDiAc8GUulLr9gGhJShCk4WC4lyt5Hcv0ECOAZyg
         Ra38W3TRmjCJUUpmtYa8ElkfRArRO9en9nE03ytVZEMjOFNc8pj1aS/bp8miGis7EdIH
         jgxRLv2/f1gWFU4BNpxiA5gH03mSJ+4fxSrkUSuc4yN51x7HRxYU5rUEi5CzSSXQ9m8u
         uuyYGVN+xxdkFa9cCvN6WneAXKL7Pcng+pcGQw6YE+OYikgfV16txJStTftWVfWY6HTN
         Gy/c82gdjY9xSwTCb1bztO5jtrQLjEAN9RNUsVWWLdgrdCbw25ITRWxUX9JKHAZHX2fq
         zzVg==
X-Gm-Message-State: AOAM530Z6uOYwvtWVy3v1Pwkma+wb5zBwZjdaMouLdEWMjYwlnD0eRrO
        9r1owZVRKWa9pu/rmitsJYWNJxxATwSp0eBgABTGAdYndnwII5RZI4hILe83dGi8sqfpGfCxN/v
        6ADi+N2LtX6HH
X-Received: by 2002:a37:a781:0:b0:6a6:9b4c:fc8d with SMTP id q123-20020a37a781000000b006a69b4cfc8dmr34331667qke.657.1655110470068;
        Mon, 13 Jun 2022 01:54:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxLKAhytZFfLQQeuW9E/Pm2tvxqTqKSiAxOefCJ0tsCfeagh1tGD4fU7pLQNZ/nHVdj1LceZg==
X-Received: by 2002:a37:a781:0:b0:6a6:9b4c:fc8d with SMTP id q123-20020a37a781000000b006a69b4cfc8dmr34331656qke.657.1655110469837;
        Mon, 13 Jun 2022 01:54:29 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-40.retail.telecomitalia.it. [79.46.200.40])
        by smtp.gmail.com with ESMTPSA id i198-20020a379fcf000000b006a73aefce28sm5814643qke.30.2022.06.13.01.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 01:54:29 -0700 (PDT)
Date:   Mon, 13 Jun 2022 10:54:20 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v2 0/8] virtio/vsock: experimental zerocopy receive
Message-ID: <20220613085420.e4limzn3dneuhu6y@sgarzare-redhat>
References: <e37fdf9b-be80-35e1-ae7b-c9dfeae3e3db@sberdevices.ru>
 <20220609085428.idi4qzydhdpzszzw@sgarzare-redhat>
 <1c58ec1f-f991-4527-726a-9f45c2ff5684@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1c58ec1f-f991-4527-726a-9f45c2ff5684@sberdevices.ru>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 09, 2022 at 12:33:32PM +0000, Arseniy Krasnov wrote:
>On 09.06.2022 11:54, Stefano Garzarella wrote:
>> Hi Arseniy,
>> I left some comments in the patches, and I'm adding something also here:
>Thanks for comments
>>
>> On Fri, Jun 03, 2022 at 05:27:56AM +0000, Arseniy Krasnov wrote:
>>>                              INTRODUCTION
>>>
>>>     Hello, this is experimental implementation of virtio vsock zerocopy
>>> receive. It was inspired by TCP zerocopy receive by Eric Dumazet. This API uses
>>> same idea: call 'mmap()' on socket's descriptor, then every 'getsockopt()' will
>>> fill provided vma area with pages of virtio RX buffers. After received data was
>>> processed by user, pages must be freed by 'madvise()'  call with MADV_DONTNEED
>>> flag set(if user won't call 'madvise()', next 'getsockopt()' will fail).
>>
>> If it is not too time-consuming, can we have a table/list to compare this and the TCP zerocopy?
>You mean compare API with more details?

Yes, maybe a comparison from the user's point of view to do zero-copy 
with TCP and VSOCK.

>>
>>>
>>>                                 DETAILS
>>>
>>>     Here is how mapping with mapped pages looks exactly: first page mapping
>>> contains array of trimmed virtio vsock packet headers (in contains only length
>>> of data on the corresponding page and 'flags' field):
>>>
>>>     struct virtio_vsock_usr_hdr {
>>>         uint32_t length;
>>>         uint32_t flags;
>>>         uint32_t copy_len;
>>>     };
>>>
>>> Field  'length' allows user to know exact size of payload within each sequence
>>> of pages and 'flags' allows user to handle SOCK_SEQPACKET flags(such as message
>>> bounds or record bounds). Field 'copy_len' is described below in 'v1->v2' part.
>>> All other pages are data pages from RX queue.
>>>
>>>             Page 0      Page 1      Page N
>>>
>>>     [ hdr1 .. hdrN ][ data ] .. [ data ]
>>>           |        |       ^           ^
>>>           |        |       |           |
>>>           |        *-------------------*
>>>           |                |
>>>           |                |
>>>           *----------------*
>>>
>>>     Of course, single header could represent array of pages (when packet's
>>> buffer is bigger than one page).So here is example of detailed mapping layout
>>> for some set of packages. Lets consider that we have the following sequence  of
>>> packages: 56 bytes, 4096 bytes and 8200 bytes. All pages: 0,1,2,3,4 and 5 will
>>> be inserted to user's vma(vma is large enough).
>>
>> In order to have a "userspace polling-friendly approach" and reduce number of syscall, can we allow for example the userspace to mmap at least the first header before packets arrive.
>> Then the userspace can poll a flag or other fields in the header to understand that there are new packets.
>You mean to avoid 'poll()' syscall, user will spin on some flag, provided by kernel on some mapped page? I think yes. This is ok. Also i think, that i can avoid 'madvise' call
>to clear memory mapping before each 'getsockopt()' - let 'getsockopt()' do 'madvise()' job by removing pages from previous data. In this case only one system call is needed - 'getsockopt()'.

Yes, that's right. I mean to support both, poll() for interrupt-based 
applications and the ability to actively poll a variable in the shared 
memory for applications that want to minimize latency.

Thanks,
Stefano

