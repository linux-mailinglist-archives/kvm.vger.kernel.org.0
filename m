Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9800045344F
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 15:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237403AbhKPOin (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 09:38:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42247 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237463AbhKPOiS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 09:38:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637073320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rDz1YUR0AgNW1PyJTJkx0fL4NDM6le7gN2iBvKWyYhY=;
        b=LAP2fC13blgZ5WPpC3YT9Pd6Wk61TWY9M9jvEdHZ6TFQ8CDUlLvuq3a55kbkCt3M23Gd5m
        1Rx4Q0c+tiFlWuZb3BYNymwxSuKo1zt7zwHbpbnmp7xYuNq5z9QEbysfnHwXA66bnNf3Au
        SGyG8PpscXa0TLKU+GsB+yyoKdIc1yw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-46-2UTt_u6gOJmVb5aoVEWAPw-1; Tue, 16 Nov 2021 09:35:18 -0500
X-MC-Unique: 2UTt_u6gOJmVb5aoVEWAPw-1
Received: by mail-wr1-f70.google.com with SMTP id q17-20020adff791000000b00183e734ba48so4540357wrp.8
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 06:35:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rDz1YUR0AgNW1PyJTJkx0fL4NDM6le7gN2iBvKWyYhY=;
        b=l9vPv46UQRC9QF+sS8MAlx5eLK+8QHZkkBKZgADS4Tax0dJq0br0gAx5JFRYROSR1k
         iMdrF0MzK0KbwEFdYfcchoRNqLKXWawpQkr0yTnnXbNglNgShAR8xnvQ8p00s0hFKyiJ
         5OHdXH8YIDjYrf7PE2s1xjnyKUNvJsLCgkUqFBvSGmAJy2tI39cIftbffl33P49yi6+4
         2+vPdVSsxhKgUm9EN980aq0bjlbgUD//CPPBhtHAdfT2AKPQixF290MOYApKwUUR3E3Z
         tjWEmVfaSOgSz4Kpj/gKXCBl0DJ2gC1jJOumL1OcIEO4d/BqSO6WZ9RlMFd460FE8WnM
         DYiA==
X-Gm-Message-State: AOAM531uo0u+cgrIn5PS94h6VrHH2C+v0VkBWsQi999O/YJscN+5R5BX
        y2GfSlunllhQI7Irjgx7SuGOowmLaXoKXDQF/n5gfPTYvtUn2JumOHFS5SRVn63i2sea5grIyLz
        Xb6LGtGsIJS4x
X-Received: by 2002:adf:ded0:: with SMTP id i16mr10045251wrn.335.1637073317269;
        Tue, 16 Nov 2021 06:35:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyTqQ6byTlaJB2mMvVBJPVz/03fWQs2QX2Z7ktgMC1OpQia0Z85aodMjtpJrgMPy+iqkkZfiQ==
X-Received: by 2002:adf:ded0:: with SMTP id i16mr10045215wrn.335.1637073317064;
        Tue, 16 Nov 2021 06:35:17 -0800 (PST)
Received: from steredhat (host-87-10-72-39.retail.telecomitalia.it. [87.10.72.39])
        by smtp.gmail.com with ESMTPSA id s8sm4988581wra.9.2021.11.16.06.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 06:35:16 -0800 (PST)
Date:   Tue, 16 Nov 2021 15:35:14 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Andrey Ryabinin <arbn@yandex-team.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] vhost_vsock: simplify vhost_vsock_flush()
Message-ID: <20211116143514.2jvemtjrds4453me@steredhat>
References: <20211115153003.9140-1-arbn@yandex-team.com>
 <20211115153003.9140-4-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20211115153003.9140-4-arbn@yandex-team.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021 at 06:30:01PM +0300, Andrey Ryabinin wrote:
>vhost_vsock_flush() calls vhost_work_dev_flush(vsock->vqs[i].poll.dev)
>before vhost_work_dev_flush(&vsock->dev). This seems pointless
>as vsock->vqs[i].poll.dev is the same as &vsock->dev and several flushes
>in a row doesn't do anything useful, one is just enough.
>
>Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
>---
> drivers/vhost/vsock.c | 5 -----
> 1 file changed, 5 deletions(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index b0361ebbd695..b4dcefbb7e60 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -707,11 +707,6 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
>
> static void vhost_vsock_flush(struct vhost_vsock *vsock)
> {
>-	int i;
>-
>-	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++)
>-		if (vsock->vqs[i].handle_kick)
>-			vhost_work_dev_flush(vsock->vqs[i].poll.dev);
> 	vhost_work_dev_flush(&vsock->dev);
> }
>
>-- 
>2.32.0
>

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

