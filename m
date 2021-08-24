Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505E33F5C2D
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 12:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236257AbhHXKcy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 06:32:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52485 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236068AbhHXKcr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Aug 2021 06:32:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629801102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=feIhjhva5jefoIxfoE0azoq+AbsdStJdrlY7GGgP55M=;
        b=Grp/aBGff6h+IQKzcuhP/volgFxSahSJj1muP9IeiGj7oGmiZSE36X3qiwXyuhVBf5EFrf
        W4K4wPx5IzdGKqYnD4G4faGs0xCPCLn6xFHR9eJnAWQOCpTfqzawi1sPNxXhn6wnE4THEu
        CaH+7hgkszL/EP52op9TNBSVnxWPmpY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-U7dK5MjnMgKIbaEFW6ZnLA-1; Tue, 24 Aug 2021 06:31:41 -0400
X-MC-Unique: U7dK5MjnMgKIbaEFW6ZnLA-1
Received: by mail-ej1-f69.google.com with SMTP id ne21-20020a1709077b95b029057eb61c6fdfso6869264ejc.22
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 03:31:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=feIhjhva5jefoIxfoE0azoq+AbsdStJdrlY7GGgP55M=;
        b=TTpGAN+zUSewxGsUoGcLsn7jGztEjwSzBfUj79cuNPS7NCXI6jahzsYG9FLPFQhDsi
         cXi9MRGHEPzB1iIzlI0XNX9BX+nFNXSvCNtkwF2z8va59z73XYUgAWSuOzDz0fhnNwL8
         qw2QkUsLk32QUMeJ2T7hcfV38ubeKSWg7cpLMFMOQYNRi1NjqzK3DYzFEVL3DeK23RY0
         r+8lCShQQDgauyKQ2gD+ellLc7CKgIb0KwVuaCpCv/3HOF7ZFNKQdb7GVv40t5Eqv/SK
         jIHROZIVGwPWX/IpEz79q8yzfE+Xy/l8tymjn6klSQ5yodBnRF5XTs0fMWaTOLGGB4GM
         eo5w==
X-Gm-Message-State: AOAM531yjQEBpUdyJ4eNki7K8gf2qr7/u4BS7wHcWbRxtipfySjF+1Bx
        FIoARd821W5QlsVhE1vEtBaWA+FNKYNCc4DGLIK9usE3nHMDB8eLxNXq7Bqs0ewFthO8k0KDBa6
        Lhvzepna1rkI4
X-Received: by 2002:a17:906:d04b:: with SMTP id bo11mr40707202ejb.513.1629801100363;
        Tue, 24 Aug 2021 03:31:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx1lClZImhRtvJCoGEAqkfeG/l8kJgXUskqq5Rw2DFLftK9EBSu/dk7LEDZ72T8m++O+df9pA==
X-Received: by 2002:a17:906:d04b:: with SMTP id bo11mr40707195ejb.513.1629801100235;
        Tue, 24 Aug 2021 03:31:40 -0700 (PDT)
Received: from steredhat (host-79-45-8-152.retail.telecomitalia.it. [79.45.8.152])
        by smtp.gmail.com with ESMTPSA id c28sm9029348ejc.102.2021.08.24.03.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 03:31:39 -0700 (PDT)
Date:   Tue, 24 Aug 2021 12:31:37 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v3 0/6] virtio/vsock: introduce MSG_EOR flag for
 SEQPACKET
Message-ID: <20210824103137.v3fny2yc5ww46p33@steredhat>
References: <20210816085036.4173627-1-arseny.krasnov@kaspersky.com>
 <3f3fc268-10fc-1917-32c2-dc0e7737dc48@kaspersky.com>
 <20210824100523.yn5hgiycz2ysdnvm@steredhat>
 <d28ff03e-c8ab-f7c6-68a2-90c9a400d029@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d28ff03e-c8ab-f7c6-68a2-90c9a400d029@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021 at 01:18:06PM +0300, Arseny Krasnov wrote:
>
>On 24.08.2021 13:05, Stefano Garzarella wrote:
>> Caution: This is an external email. Be cautious while opening links or attachments.
>>
>>
>>
>> Hi Arseny,
>>
>> On Mon, Aug 23, 2021 at 09:41:16PM +0300, Arseny Krasnov wrote:
>>> Hello, please ping :)
>>>
>> Sorry, I was off last week.
>> I left some minor comments in the patches.
>>
>> Let's wait a bit for other comments before next version, also on the
>> spec, then I think you can send the next version without RFC tag.
>> The target should be the net-next tree, since this is a new feature.
>Hello,
>
>E.g. next version will be [net-next] instead of [RFC] for both
>kernel and spec patches?

Nope, net-next tag is useful only for kernel patches (net tree - 
Documentation/networking/netdev-FAQ.rst).

Thanks,
Stefano

