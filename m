Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5184C3214D6
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 12:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhBVLLm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 06:11:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44599 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230350AbhBVLLj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 06:11:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613992202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rTTgTnnEUriuNUbTSpJOg3TlbAf8UgyHGlIQQW3D8og=;
        b=Ji/52dYKr9oevUiMEuagexNNZyltQloGag7QnRa9Tidpxfy+Lga0/x6UfIqNv0+N4fc1Ph
        /dOSPTWp1y19tJfWLrzXznd2FABL1tEyS/buNUOFKa3UzoQapef89gE2uEp7q8FLXmlnWC
        H4B1cmHDJ9iySMxHdzTGpZym5bEF+Sc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-XlEkEI6mNoyTmQt4vb9hxg-1; Mon, 22 Feb 2021 06:10:00 -0500
X-MC-Unique: XlEkEI6mNoyTmQt4vb9hxg-1
Received: by mail-wm1-f69.google.com with SMTP id s192so4914550wme.6
        for <kvm@vger.kernel.org>; Mon, 22 Feb 2021 03:10:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rTTgTnnEUriuNUbTSpJOg3TlbAf8UgyHGlIQQW3D8og=;
        b=WhjIDD6RHQiek+GQYeRzQdKD5Hn8TaWHI3IjkUcdsFN4HVgafvD01nocFgSB5YPVo8
         g/aQ1E2TgLsuYh4weWq5gCkI5yRKvhhwyd3t2QDNTTl2HGgDwSTwj9zQyZklmQocS6qI
         sePzs+kDh5sFRNbVhhWM4jJEMxxiR+n1NCcX5xFZ9ENexEzRP1bbC5oSvGJdSUzlCctF
         YU/CREposg/WQWOOkk3HP7PWzpwh6z3hhK6Ph6FAc5VSHYNOLNKQSNh9sU3ffx8dP0wr
         KJSxcu0IeTxf5n9DPH2DC8pOnMN8/DBjOO1tqMm1UmxBYbpE57r6fJGEAm65ZooU4nq0
         zv7g==
X-Gm-Message-State: AOAM5304Xl2sMyu4coHlJOT7xHYuwQpVD6fPU2LdajQmfi4PCYhazrrx
        mnTVNDylALdaF1d+FnvvWlAqKzSpNIAoRrgCqBZHzJKE6zvIXwvDuCCwze9SSPwIDObX3gERobM
        A2CxdA+qS9mGK
X-Received: by 2002:adf:f0ce:: with SMTP id x14mr21067097wro.252.1613992199429;
        Mon, 22 Feb 2021 03:09:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwdwsRnGTQg4evIi4sY1oeSfuGUyHVWJW11J4EDEj0zsR/YaE8ZRE2845KqqVThW1r2aO7OIA==
X-Received: by 2002:adf:f0ce:: with SMTP id x14mr21067090wro.252.1613992199287;
        Mon, 22 Feb 2021 03:09:59 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id o2sm300089wrw.2.2021.02.22.03.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 03:09:58 -0800 (PST)
Date:   Mon, 22 Feb 2021 12:09:56 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v5 01/19] af_vsock: update functions for connectible
 socket
Message-ID: <20210222110956.3rwm2zm2ntctayci@steredhat>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
 <20210218053607.1066783-1-arseny.krasnov@kaspersky.com>
 <20210222105023.aqcu25irkeed6div@steredhat>
 <279059b2-4c08-16d4-3bca-03640c7932d9@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <279059b2-4c08-16d4-3bca-03640c7932d9@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 22, 2021 at 01:58:11PM +0300, Arseny Krasnov wrote:
>
>On 22.02.2021 13:50, Stefano Garzarella wrote:
>> On Thu, Feb 18, 2021 at 08:36:03AM +0300, Arseny Krasnov wrote:
>>> This prepares af_vsock.c for SEQPACKET support: some functions such
>>> as setsockopt(), getsockopt(), connect(), recvmsg(), sendmsg() are
>>> shared between both types of sockets, so rename them in general
>>> manner.
>>>
>>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>>> ---
>>> net/vmw_vsock/af_vsock.c | 64 +++++++++++++++++++++-------------------
>>> 1 file changed, 34 insertions(+), 30 deletions(-)
>> IIRC I had already given my R-b to this patch. Please carry it over when
>> you post a new version.
>>
>> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
>>
>> Thanks,
>> Stefano
>Ack, sorry, didn't know that

Don't worry :-)

It is documented here: Documentation/process/submitting-patches.rst

	Both Tested-by and Reviewed-by tags, once received on mailing list from tester
	or reviewer, should be added by author to the applicable patches when sending
	next versions.  However if the patch has changed substantially in following
	version, these tags might not be applicable anymore and thus should be removed.
	Usually removal of someone's Tested-by or Reviewed-by tags should be mentioned
	in the patch changelog (after the '---' separator).

Thanks,
Stefano

