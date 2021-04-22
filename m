Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F71367CCD
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 10:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbhDVIrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 04:47:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31910 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235551AbhDVIrY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 04:47:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619081210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=igvzL5hliAA2FzGw5dEDKa40CGCMUv5IZGyJe8BTj8Q=;
        b=h9ErolHulMq2N6vsJ+qzBJqX5ORmk39L1JJbSz+oYBKw5SPx0Q1pgwckG2Y/Ucy40j9Rxp
        7cpoYpkR/L4nD8rpWwhQ9b06FKVDJTjCjpHGguBIPIT/YiUuJUwIbvlbdxIG0hZg/WwqXa
        Mxo3glAPVOeFGxRE8syke6m8uf/e+A4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-WyNxRNgRMtugKXOFB46Gaw-1; Thu, 22 Apr 2021 04:46:42 -0400
X-MC-Unique: WyNxRNgRMtugKXOFB46Gaw-1
Received: by mail-ej1-f71.google.com with SMTP id g7-20020a1709065d07b029037c872d9cdcso6953783ejt.11
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 01:46:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=igvzL5hliAA2FzGw5dEDKa40CGCMUv5IZGyJe8BTj8Q=;
        b=T6jCYHR/uyDBbO7wytHZLpEDC7vYrAlzZgUOFwNwVP7gjsa7fh5BnQjh07a0mEfw0i
         6ag7FAAsqS+HtHdqOE2wEF2y2yhCnJNc73DFPLYD5rBx4XMGfjSAE8HUN4kqWMJV4mKz
         rkqCi1MJ4uiXAnOteBdeOKKt7n9cZVN8ckSZyv3q9OJO9GQrChueVjXUs27Ru24oYud2
         YaD11Nugvyc23aaIdqE+BvH/g+1IqFCVNl074gGqHdur9vqk7V7XoAkL55iFHeGEMPgh
         +gOwPqHxAtbNERuHEJMWetQf169bLscFUOSmq+NrWaM3ySWcPNG1eDXzfEoMYinXGXzP
         RKuA==
X-Gm-Message-State: AOAM532WVjLQeCyAa2hQ2LSVHyCImsfru0fYixpj5MT12cEEPLD8LoE8
        jr9wCqjNB4OVWdQG38TIzRH2ZFKiJN+NbjfzTX9sb1igyUoasvjsW8LsARmBvT/y2RmRN+Bk7Zq
        L3yrGV8eeYKff
X-Received: by 2002:a05:6402:1a52:: with SMTP id bf18mr2410633edb.289.1619081201234;
        Thu, 22 Apr 2021 01:46:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMOmZX/WNU70MrtatibX4Wtl/+Aav9csAem9coMeZKqvTUqG/etSg6TxT6HkUvxXRS4imtXQ==
X-Received: by 2002:a05:6402:1a52:: with SMTP id bf18mr2410622edb.289.1619081201063;
        Thu, 22 Apr 2021 01:46:41 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id q25sm1506681edt.51.2021.04.22.01.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 01:46:40 -0700 (PDT)
Date:   Thu, 22 Apr 2021 10:46:38 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Alexander Popov <alex.popov@linux.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v8 00/19] virtio/vsock: introduce SOCK_SEQPACKET
 support
Message-ID: <20210422084638.bvblk33b4oi6cec6@steredhat>
References: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
 <20210421095213.25hnfi2th7gzyzt2@steredhat>
 <2c3d0749-0f41-e064-0153-b6130268add2@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2c3d0749-0f41-e064-0153-b6130268add2@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 21, 2021 at 06:06:28PM +0300, Arseny Krasnov wrote:
>On 21.04.2021 12:52, Stefano Garzarella wrote:
>> On Tue, Apr 13, 2021 at 03:39:51PM +0300, Arseny Krasnov wrote:
>>> v7 -> v8:
>>> General changelog:
>>> - whole idea is simplified: channel now considered reliable,
>>>   so SEQ_BEGIN, SEQ_END, 'msg_len' and 'msg_id' were removed.
>>>   Only thing that is used to mark end of message is bit in
>>>   'flags' field of packet header: VIRTIO_VSOCK_SEQ_EOR. Packet
>>>   with such bit set to 1 means, that this is last packet of
>>>   message.
>>>
>>> - POSIX MSG_EOR support is removed, as there is no exact
>>>   description how it works.
>> It would be nice to support it, I'll try to see if I can find anything.
>>
>> I just reviewed the series. I think the most important things to fix are
>> the `seqpacket_allow` stored in the struct virtio_transport that is
>> wrong IMHO, and use cpu_to_le32()/le32_to_cpu() to access the flags.
>
>Thank You, i'll prepare next version. Main question is: does this
>approach(no SEQ_BEGIN, SEQ_END, 'msg_len' and 'msg_id') considered
>good? In this case it will be easier to prepare final version, because 
>is smaller and more simple than previous logic. Also patch to spec
>will be smaller.

Yes, it's definitely much better than before.

The only problem I see is that we add some overhead per fragment 
(header). We could solve that with the mergeable buffers that Jiang is 
considering for DGRAM.

If we have that support, I think we could reuse it here as well, but it 
might be a next step.

Thanks,
Stefano

