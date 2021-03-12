Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D287A339099
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 16:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbhCLPBw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 10:01:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30224 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231786AbhCLPBW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 10:01:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615561281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dY5uAwZg117bNtRKEEBL+2LzAlswxrz2wq+X03tujc0=;
        b=DLjOU81I080QFBOxfI9lPAiTVOdKjLn8goYgM96HIIJTCn8n0QiaJDIbquFwtc6pU6kM9E
        e5aJSccq15MD9+fWd0n2RmIpRvKwGba+1I0m/myfDC/IkbfPDfrqnYKM89h84uMoIxoppN
        IUW4eaxqCGHhr4D7b30e4KgOX2073g4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-zDpNjDwmMR-FyaYPOcZcfw-1; Fri, 12 Mar 2021 10:01:20 -0500
X-MC-Unique: zDpNjDwmMR-FyaYPOcZcfw-1
Received: by mail-wm1-f72.google.com with SMTP id m17so2140735wml.3
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 07:01:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dY5uAwZg117bNtRKEEBL+2LzAlswxrz2wq+X03tujc0=;
        b=szqQzSAQaQqgueMP2AIm1nCGTN47+y/lmqytAwvHmh7UCPOirfTZk3CX8rrQ/jlUJN
         0y4vIltE3Yg/d3RqzSjfqwaG6uy1l7u4tRSviQsP//DdeB5Umnjfe79n4J49T5sxQWJC
         GvJxrHdwIkZwJ7spuz1aP5hyb6tMBG2Z9WOz2oHoVSotCX3Q8ZnwwrL4FIB7SY2tB80J
         Nz2wQeYoBLc40aFJBEW1dIH9kenrPiGUuyfocgti0yaGXeGWkGIvGxWK1pm732rjiAWu
         dUqGq1kqFoQSQFqbBS80qM8S5fQkUQ4uSmAymdUppa0ttvAD74RLzRQJaVhpTO+rPHs9
         wdcA==
X-Gm-Message-State: AOAM533gK/BCb9JqGFrxIby/dIzeICagPQjE3KqoT8GGdFsPchM3HYfg
        NOh07DYNWjPJsgO71z7CH1Z5QMRHE2e0n5EjzYmy/ByVNhRBPemq8UkFOqF2GBepxY+4YtTlASU
        b/Fmop02OUdwf
X-Received: by 2002:a1c:195:: with SMTP id 143mr13139788wmb.81.1615561274643;
        Fri, 12 Mar 2021 07:01:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwU/+j7YIHGGD7r2/oDTZXMPTuZH3Lx7EWKi5joHVZyKzFAUrs1mT0L3T9QcEyLqXmzz7K7Aw==
X-Received: by 2002:a1c:195:: with SMTP id 143mr13139730wmb.81.1615561274237;
        Fri, 12 Mar 2021 07:01:14 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id c8sm691886wmb.34.2021.03.12.07.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 07:01:13 -0800 (PST)
Date:   Fri, 12 Mar 2021 16:01:10 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v6 04/22] af_vsock: implement SEQPACKET receive loop
Message-ID: <20210312150110.344tr3wgz5cwruzz@steredhat>
References: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
 <20210307175948.3464885-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210307175948.3464885-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 07, 2021 at 08:59:45PM +0300, Arseny Krasnov wrote:
>This adds receive loop for SEQPACKET. It looks like receive loop for
>STREAM, but there is a little bit difference:
>1) It doesn't call notify callbacks.
>2) It doesn't care about 'SO_SNDLOWAT' and 'SO_RCVLOWAT' values, because
>   there is no sense for these values in SEQPACKET case.
>3) It waits until whole record is received or error is found during
>   receiving.
>4) It processes and sets 'MSG_TRUNC' flag.
>
>So to avoid extra conditions for two types of socket inside one loop, two
>independent functions were created.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> include/net/af_vsock.h   |  5 +++
> net/vmw_vsock/af_vsock.c | 95 +++++++++++++++++++++++++++++++++++++++-
> 2 files changed, 99 insertions(+), 1 deletion(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

