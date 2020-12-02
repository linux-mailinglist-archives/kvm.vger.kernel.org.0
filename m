Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960382CC488
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 19:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbgLBSIA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 13:08:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21500 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728414AbgLBSIA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Dec 2020 13:08:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606932393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UUhswDH4r20yUImWQBsMsC4a1fG4mX4+xvMVdq4Y3Co=;
        b=Hgr1Tq9XrkeTEMWpur1kyHhiqemT4/nII61kj4GnUSN6uXzqoXKEIokPqi4Gi58TCQecBm
        Rz3o/DXy/WTZ8vJt0ZE0nQT4EmT+kQNdfwNcDq3xn5gZtVKErGaFuyeYF2fW+gEPwokyL+
        PSEhtLSoqRSSt8ZRSa3OWNXVcrsGdVs=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-CD3Nb7zrO2WvIERYWOg4Kg-1; Wed, 02 Dec 2020 13:06:32 -0500
X-MC-Unique: CD3Nb7zrO2WvIERYWOg4Kg-1
Received: by mail-qv1-f70.google.com with SMTP id o16so1820472qvq.4
        for <kvm@vger.kernel.org>; Wed, 02 Dec 2020 10:06:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UUhswDH4r20yUImWQBsMsC4a1fG4mX4+xvMVdq4Y3Co=;
        b=oT2j77wc91VNn1oSi/3/mpeBukATV0EZYwg7/52KH7vHLpVFbDav/5GVxZ1tlkr78f
         QTQSH/IdECmoY4kXWG9n5SMEkssRsFIoTeZztJjHNIJViibyOKy/TFkpjleEj6smcZO3
         goSrNZWsBAidOJFSv12D3H6BzntYRfHWh2WI2OcrH10cle7eOozMewf429ane4ZfKlps
         SUK/aVuHI/yRVgQn/KOK/fINAsDV1t74TQ1Ftc57t1HvPXEcfucqjQ6UdMtQJizb8cLS
         YzwRvGwQO+3FQwyYtcn3Ou3kiwHoBMrF6xSDTAaG7TDGICme8wIcmpzQFOPQr0nJyVVd
         ypKw==
X-Gm-Message-State: AOAM530UTgm1f4s9g6r3EWpwxHjFTMh3Mx2u+Nf9Hnq9xvdsmYFxtVea
        MMWeVoviSBEjEsfdTzQ9fwTdnbmYIYS92YGsKKpjtt7Aqz7N3Qeul199jy0ubxCaUXx/fXUXOLW
        ZFVPrv4qSeTh3
X-Received: by 2002:a05:620a:7e8:: with SMTP id k8mr3736964qkk.273.1606932391683;
        Wed, 02 Dec 2020 10:06:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxxuKq3g+ANdmuQcQ4T1M4wF0P8m/TYFs4KsAkF3Uaz4a/JvvROJhb8A1fxanXalWrFjASseQ==
X-Received: by 2002:a05:620a:7e8:: with SMTP id k8mr3736933qkk.273.1606932391359;
        Wed, 02 Dec 2020 10:06:31 -0800 (PST)
Received: from xz-x1 ([142.126.94.187])
        by smtp.gmail.com with ESMTPSA id z23sm2470416qtq.66.2020.12.02.10.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 10:06:30 -0800 (PST)
Date:   Wed, 2 Dec 2020 13:06:28 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Elena Afanasova <eafanasova@gmail.com>
Cc:     kvm@vger.kernel.org, mst@redhat.com, john.g.johnson@oracle.com,
        dinechin@redhat.com, cohuck@redhat.com, jasowang@redhat.com,
        felipe@nutanix.com, stefanha@redhat.com,
        elena.ufimtseva@oracle.com, jag.raman@oracle.com
Subject: Re: MMIO/PIO dispatch file descriptors (ioregionfd) design discussion
Message-ID: <20201202180628.GA100143@xz-x1>
References: <88ca79d2e378dcbfb3988b562ad2c16c4f929ac7.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <88ca79d2e378dcbfb3988b562ad2c16c4f929ac7.camel@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 25, 2020 at 12:44:07PM -0800, Elena Afanasova wrote:

[...]

> Wire protocol
> -------------
> The protocol spoken over the file descriptor is as follows. The device reads
> commands from the file descriptor with the following layout::
> 
>   struct ioregionfd_cmd {
>       __u32 info;
>       __u32 padding;
>       __u64 user_data;
>       __u64 offset;
>       __u64 data;
>   };

I'm thinking whether it would be nice to have a handshake on the wire protocol
before starting the cmd/resp sequence.

I was thinking about migration - we have had a hard time trying to be
compatible between old/new qemus.  Now we fixed those by applying the same
migration capabilities on both sides always so we do the handshake "manually"
from libvirt, but it really should be done with a real handshake on the
channel, imho..  That's another story, for sure.

My understanding is that the wire protocol is kind of a standalone (but tiny)
protocol between kvm and the emulation process.  So I'm thinking the handshake
could also help when e.g. kvm can fallback to an old version of wire protocol
if it knows the emulation binary is old.  Ideally, I think this could even
happen without VMM's awareness.

[...]

> Ordering
> --------
> Guest accesses are delivered in order, including posted writes.

I'm wondering whether it should prepare for out-of-order commands assuming if
there's no handshake so harder to extend, just in case there could be some slow
commands so we still have chance to reply to a very trivial command during
handling the slow one (then each command may require a command ID, too).  But
it won't be a problem at all if we can easily extend the wire protocol so the
ordering constraint can be extended too when really needed, and we can always
start with in-order-only requests.

Thanks,

-- 
Peter Xu

