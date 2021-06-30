Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4463B81C3
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 14:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbhF3MOA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 08:14:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31375 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234404AbhF3MN7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Jun 2021 08:13:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625055090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HjLKivpmTxani+XPF3iGAiHLl5i/SxVPZjv2mKGxTR4=;
        b=EbluSdyFvc3I9Jb278vJRzcmj9H63nr1Uy1MKJ0/PmNffMiPhz2VcdyapobQYg9gl9MwPT
        qPvXxeXaNS6L4s4HvvwNGFWo8VYYpwBRphxVhsiV1N4RVOubkob13pcm3V+bEEfVeLp5hd
        r7s57EfPwA8HztDEfPId6IONjNfmccg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-SaLxfzGRNlqZe1ClSFWQ5g-1; Wed, 30 Jun 2021 08:11:28 -0400
X-MC-Unique: SaLxfzGRNlqZe1ClSFWQ5g-1
Received: by mail-ej1-f72.google.com with SMTP id w22-20020a17090652d6b029048a3391d9f6so688191ejn.12
        for <kvm@vger.kernel.org>; Wed, 30 Jun 2021 05:11:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HjLKivpmTxani+XPF3iGAiHLl5i/SxVPZjv2mKGxTR4=;
        b=XCnuL90jnS8aMCH7F2JIKjWISBqk4tVm7z5+LntYycI8qqvvdyvKorle5ljDPO8jOy
         zBsyFwoqodi8zzdH+WnuAoAEIvnojx+YoQ9DJc/BTXNMrGeKLs6iQTkMUPcsG2IoGfAC
         NNpIFyxrDq6H201gRyAvGbzXm/LL+5Z3LBOhL2EjMUvGBEUl5OCZ0Bugceekw2dMMGVK
         dQL5Mi2aMLrECU3qLODeC2ae7rEYrc0B5dp9FWUW7aX40+KkUZ2gRi+pLM4i7/BMZZ/c
         xyBCiWFukIdyfZ6PtWWhRjkCYGfeuzyaLrPTImB5Y8CNnjYWyobM1/zyq0hmFEPHl7bA
         dxcQ==
X-Gm-Message-State: AOAM531HXRDihCrgyTbMhrGIhydoYNIJsL6qjhNdXRfWPS5VHVDBuNti
        dW2hutARenowG0RFC5faC4fx+Qzg3iS26nS8PxWQ2Uqza7pzkEM2+nDqRR9kZYuJlz0kT3luIlZ
        +HtRDNo4nBzqe
X-Received: by 2002:a17:906:4899:: with SMTP id v25mr35863377ejq.451.1625055087445;
        Wed, 30 Jun 2021 05:11:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxS+TPipViKVTyOBRlKGUsXt+XwfFGYR4iIVDCFdEFv1bf670kbuHjhW5TA+alh5BwQNtL7Mw==
X-Received: by 2002:a17:906:4899:: with SMTP id v25mr35863362ejq.451.1625055087282;
        Wed, 30 Jun 2021 05:11:27 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id r12sm12637350edd.52.2021.06.30.05.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 05:11:26 -0700 (PDT)
Date:   Wed, 30 Jun 2021 14:11:24 +0200
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
        kvm <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v1 07/16] virtio/vsock: don't count EORs on receive
Message-ID: <CAGxU2F7SsxvCht2HbDb7dKsM_auHoxvHirgWwNMObjxOci=5nA@mail.gmail.com>
References: <20210628095959.569772-1-arseny.krasnov@kaspersky.com>
 <20210628100318.570947-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628100318.570947-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 28, 2021 at 01:03:15PM +0300, Arseny Krasnov wrote:
>There is no sense to count EORs, because 'rx_bytes' is
>used to check data presence on socket.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/virtio_transport_common.c | 3 ---
> 1 file changed, 3 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 84431d7a87a5..319c3345f3e0 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1005,9 +1005,6 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
>               goto out;
>       }
>
>-      if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)
>-              vvs->msg_count++;
>-

Same here, please remove it when you don't need it, and also remove from
the struct virtio_vsock_sock.

Thanks,
Stefano

>       /* Try to copy small packets into the buffer of last packet queued,
>        * to avoid wasting memory queueing the entire buffer with a small
>        * payload.
>--
>2.25.1
>

