Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 682842FCEEF
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 12:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731554AbhATLOZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 06:14:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36104 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730907AbhATLKI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 06:10:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611140919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yTm6KgxVEtqRp5BOUW1oggSfQz0/KqIRI5Ikpu2SIkI=;
        b=ThFdwWwUyVpvL24nEeSIZRAaihOygzoAolYK3hZ2J9WBSL/wZ5k9ztLvMHXxf6CJx8zoHa
        AQNe94T0JQUhQVsRvgGP9yNX8+Vuf78U9viGYY0HngSWo6EFFEJ60NWfX5xcrFV5enr/Nf
        IXZT9ajkDPMUgKpgaVd68iRBLwS39Bg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-9kg1WBBAPYGlLzQiK75T6w-1; Wed, 20 Jan 2021 06:08:38 -0500
X-MC-Unique: 9kg1WBBAPYGlLzQiK75T6w-1
Received: by mail-wr1-f70.google.com with SMTP id y4so802226wrt.18
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 03:08:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=yTm6KgxVEtqRp5BOUW1oggSfQz0/KqIRI5Ikpu2SIkI=;
        b=BtOHh/39F2wsNV9eFaWMi8yOuPaYryZP0+MTY0tvK73JZ59v41T7ky/PpDIXohiLYS
         ePsk3CkSEt/r/oL1xotXn2l8/0/EfoaMXGjhyIOjJFdUbfrjWwmg9A1mJaXpmkOt3VfA
         eOZK97Z73QLdPhxZ9ehM16kf9suHkQGa5WvVq1m4Nu2MNBoV9FeQfjZB86M62CRWJaQ1
         +wAJWa2nTJz6LvHcaIB0O8+Wpcy3+DUSj2DAouOz5+dRNfzrMYO5Z60Q+84G63exToXG
         EQTlSJw6lporh8Gmz2CwbkMeGbVXvQWs7GKigc890xPW1p44/d2rytxZUDsJ37Ka1rbU
         Y7tA==
X-Gm-Message-State: AOAM533tNUiX3FalQzhHf2fEmQgOYUIyW5T/0isBiq5OJqQ/BEBAUo6h
        yZnqluL1EWt9W3qJud6mx2FdsrwsJrOQHYyh641MIE+lkwtbVNVW7Pu4qXAWCVb1Lqw7NVSlsXt
        5pplbrBtowbKW
X-Received: by 2002:a05:600c:4e8e:: with SMTP id f14mr3838207wmq.139.1611140916748;
        Wed, 20 Jan 2021 03:08:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwzq+LHVW7iOIInxldWRs5h39ePpUe0nK/vVbhibAJ1v8IIbA+WZfiKJq98JGzyhbZvEFHziw==
X-Received: by 2002:a05:600c:4e8e:: with SMTP id f14mr3838181wmq.139.1611140916380;
        Wed, 20 Jan 2021 03:08:36 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id p9sm1619051wrj.11.2021.01.20.03.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 03:08:35 -0800 (PST)
Date:   Wed, 20 Jan 2021 12:08:32 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>
Cc:     mst@redhat.com, stefanha@redhat.com, parav@nvidia.com,
        bob.liu@oracle.com, hch@infradead.org, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC v3 03/11] vdpa: Remove the restriction that only supports
 virtio-net devices
Message-ID: <20210120110832.oijcmywq7pf7psg3@steredhat>
References: <20210119045920.447-1-xieyongji@bytedance.com>
 <20210119045920.447-4-xieyongji@bytedance.com>
 <310d7793-e4ff-fba3-f358-418cb64c7988@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <310d7793-e4ff-fba3-f358-418cb64c7988@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 20, 2021 at 11:46:38AM +0800, Jason Wang wrote:
>
>On 2021/1/19 下午12:59, Xie Yongji wrote:
>>With VDUSE, we should be able to support all kinds of virtio devices.
>>
>>Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
>>---
>>  drivers/vhost/vdpa.c | 29 +++--------------------------
>>  1 file changed, 3 insertions(+), 26 deletions(-)
>>
>>diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>>index 29ed4173f04e..448be7875b6d 100644
>>--- a/drivers/vhost/vdpa.c
>>+++ b/drivers/vhost/vdpa.c
>>@@ -22,6 +22,7 @@
>>  #include <linux/nospec.h>
>>  #include <linux/vhost.h>
>>  #include <linux/virtio_net.h>
>>+#include <linux/virtio_blk.h>
>>  #include "vhost.h"
>>@@ -185,26 +186,6 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
>>  	return 0;
>>  }
>>-static int vhost_vdpa_config_validate(struct vhost_vdpa *v,
>>-				      struct vhost_vdpa_config *c)
>>-{
>>-	long size = 0;
>>-
>>-	switch (v->virtio_id) {
>>-	case VIRTIO_ID_NET:
>>-		size = sizeof(struct virtio_net_config);
>>-		break;
>>-	}
>>-
>>-	if (c->len == 0)
>>-		return -EINVAL;
>>-
>>-	if (c->len > size - c->off)
>>-		return -E2BIG;
>>-
>>-	return 0;
>>-}
>
>
>I think we should use a separate patch for this.

For the vdpa-blk simulator I had the same issues and I'm adding a 
.get_config_size() callback to vdpa devices.

Do you think make sense or is better to remove this check in vhost/vdpa, 
delegating the boundaries checks to get_config/set_config callbacks.

Thanks,
Stefano

