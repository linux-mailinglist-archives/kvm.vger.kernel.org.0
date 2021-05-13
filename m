Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8420237F708
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 13:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbhEMLrB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 07:47:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24241 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230462AbhEMLrA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 May 2021 07:47:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620906350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MT3wo5NP4c6jdkY4rdnz2C8pxWgXXp6JkWRd1hEobAU=;
        b=g9lNaNobZgESD/ykD08L/iU8xz2b8kqaQaBv2qfrx+D2bpMbtHiVGX0jYC9VhdlfJyoeVT
        BujTGwMo5vym45isGIlVtbE4rdDDK6737gYuuXaRtYhDpzuYIxl5qbz7BiXkqeWl9ZToHT
        q1qGN1mNCfJjXuA9CEptGksD0nUXpr4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-ltwTy6pZO96rF9c3QNYIeg-1; Thu, 13 May 2021 07:45:48 -0400
X-MC-Unique: ltwTy6pZO96rF9c3QNYIeg-1
Received: by mail-ed1-f72.google.com with SMTP id p8-20020aa7c8880000b029038ce714c8d6so144125eds.10
        for <kvm@vger.kernel.org>; Thu, 13 May 2021 04:45:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MT3wo5NP4c6jdkY4rdnz2C8pxWgXXp6JkWRd1hEobAU=;
        b=BloyjVPDVg7XGTCzYjO/cSiwU4sMBO2iit7+fNeNVpq2YUcy0n+yOn838KKbhZlDmp
         7hKDXBRZ6xDXh1mA0fzFZxvABh6uru8EM9NBz8qKFLyzg6jmFOGQtIanMq7BkP13jSpd
         jcr/51w2EQx6pCDF+nTXgnyROtijRhNvtcThpcDinoKdcHsgauru878efqR38xA9TkRi
         NUcugbLlPhZniWHYB2q32pom0JDPiRixDjATwpBrgPAwAmDJY06y5Sa20RCfozO4zFg/
         SkbDCti4l7NXk52UIeoVCzKMPbdI8aN6kxMlOMVu0Xi9ccHkDGCIfmj2joSQJZcwtoCL
         ctwQ==
X-Gm-Message-State: AOAM530E6WkuU91Sza+rBOWew2QrXVxnAQqU89M+EOwR44DP3wRcLMIa
        9mcKTLxHMobuvJrXLdWA9nxgU+Hn2YFB+eSX93qe+ViJ1TM5X4ntewSWO/aT0sq0uC02krpQeZR
        LD1tpm2Gj5UDp
X-Received: by 2002:aa7:db90:: with SMTP id u16mr49671411edt.106.1620906347032;
        Thu, 13 May 2021 04:45:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzK9y97PFsnFtKG2m387tQ7wMAVv4mrXxkCxS1dn+cI2Zu3pe2nfVjZZrdViT0h2czbettl2g==
X-Received: by 2002:aa7:db90:: with SMTP id u16mr49671388edt.106.1620906346853;
        Thu, 13 May 2021 04:45:46 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id f7sm1685809ejz.95.2021.05.13.04.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 04:45:46 -0700 (PDT)
Date:   Thu, 13 May 2021 13:45:43 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v9 10/19] virtio/vsock: defines and constants for
 SEQPACKET
Message-ID: <20210513114543.hucvkhky3tlmvabl@steredhat>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
 <20210508163508.3431890-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210508163508.3431890-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 08, 2021 at 07:35:05PM +0300, Arseny Krasnov wrote:
>This adds set of defines and constants for SOCK_SEQPACKET
>support in vsock. Here is link to spec patch, which uses it:
>
>https://lists.oasis-open.org/archives/virtio-comment/202103/msg00069.html

Will you be submitting a new version?

>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> include/uapi/linux/virtio_vsock.h | 9 +++++++++
> 1 file changed, 9 insertions(+)
>
>diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
>index 1d57ed3d84d2..3dd3555b2740 100644
>--- a/include/uapi/linux/virtio_vsock.h
>+++ b/include/uapi/linux/virtio_vsock.h
>@@ -38,6 +38,9 @@
> #include <linux/virtio_ids.h>
> #include <linux/virtio_config.h>
>
>+/* The feature bitmap for virtio vsock */
>+#define VIRTIO_VSOCK_F_SEQPACKET	1	/* SOCK_SEQPACKET supported */
>+
> struct virtio_vsock_config {
> 	__le64 guest_cid;
> } __attribute__((packed));
>@@ -65,6 +68,7 @@ struct virtio_vsock_hdr {
>
> enum virtio_vsock_type {
> 	VIRTIO_VSOCK_TYPE_STREAM = 1,
>+	VIRTIO_VSOCK_TYPE_SEQPACKET = 2,
> };
>
> enum virtio_vsock_op {
>@@ -91,4 +95,9 @@ enum virtio_vsock_shutdown {
> 	VIRTIO_VSOCK_SHUTDOWN_SEND = 2,
> };
>
>+/* VIRTIO_VSOCK_OP_RW flags values */
>+enum virtio_vsock_rw {
>+	VIRTIO_VSOCK_SEQ_EOR = 1,
>+};
>+
> #endif /* _UAPI_LINUX_VIRTIO_VSOCK_H */
>-- 
>2.25.1
>

Looks good:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

