Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0135179E1
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 00:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbiEBWYb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 18:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiEBWYa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 18:24:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5CE2EA1BE
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 15:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651530059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t+pDY+Ex4Ewd/QjNKkxD0rhZSfDGQ+G9GZjOekpOl0o=;
        b=K8mbuXpFEhHhYmGWemz5SkeUO1aivCPTnOeHw33bCPRt55EE4Pu8dz66IcQpHEVJpRxK1t
        cdY3IBzrT3B59V7RjCwSONXjnKvCAlwiGEeFadlTWW0KQ1vTJEkt1pcHS4sVCgaq+5DYok
        NHgF7xsl8ITMJ+K2BidGL8y0yKF3WU8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-504-huUqrWHVNUqCULmRIDqufw-1; Mon, 02 May 2022 18:20:58 -0400
X-MC-Unique: huUqrWHVNUqCULmRIDqufw-1
Received: by mail-wm1-f71.google.com with SMTP id bh7-20020a05600c3d0700b003940829b48dso340305wmb.1
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 15:20:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t+pDY+Ex4Ewd/QjNKkxD0rhZSfDGQ+G9GZjOekpOl0o=;
        b=Pm7av0evs81G/8A01rw99oqGEBxU3iJTBUjwSUXKZanSDLnWF5TFAaju3RI0Zy/sI8
         /MAQXLD53f+OSdlOE/gwsDk3+MlXUlnb2d/iC3RTmpTQwDI436UnjcaA3VE9UOoApX4N
         Ms5/Bh4kc+UapiMU6VuBCVphbqvdVkMrcaYJiBg92oEYtuwN/XOko4KQgcT7FvRTltxE
         HrRCZWVXNJxPzw04/qoRITJEMmX70wQWRWVvXo0H02QVnn7ldCXOU+4LoYy6sWvbvOwN
         KU68h8r0EilByBDU/wqlIltIgjF2k7J6UJQsh2fl5iVt1V2Xe7p2eyBerbDyZHOdmaU2
         id9w==
X-Gm-Message-State: AOAM533aq6Qhl4VTvNJcmjVuAGjk8eGSlgEPt+33MM9cBKJoa9tsl6qu
        MEXqp5HdwjF8vDXpkT2r5vXQLnx1SBFaVnf5/aHmwBniduWWuVPfZtxs029fsEv+dgDEMzMoSz9
        cWUvY7vIOJZK6
X-Received: by 2002:a05:600c:4f06:b0:393:ef13:62c5 with SMTP id l6-20020a05600c4f0600b00393ef1362c5mr902014wmq.33.1651530056991;
        Mon, 02 May 2022 15:20:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxuoQW8PNhRMhYZlNoJGzUoUBWE/Jea5rFAz7zLOoPbWOoUwrZafgD8evcGGLl1zeR1+/hnyg==
X-Received: by 2002:a05:600c:4f06:b0:393:ef13:62c5 with SMTP id l6-20020a05600c4f0600b00393ef1362c5mr901998wmq.33.1651530056770;
        Mon, 02 May 2022 15:20:56 -0700 (PDT)
Received: from redhat.com ([2.55.174.117])
        by smtp.gmail.com with ESMTPSA id w7-20020adf8bc7000000b0020c5253d8f9sm7963822wra.69.2022.05.02.15.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 15:20:56 -0700 (PDT)
Date:   Mon, 2 May 2022 18:20:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Vilas R K <vilas.r.k@intel.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 0/2] vsock/virtio: add support for device
 suspend/resume
Message-ID: <20220502180554-mutt-send-email-mst@kernel.org>
References: <20220428132241.152679-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428132241.152679-1-sgarzare@redhat.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 28, 2022 at 03:22:39PM +0200, Stefano Garzarella wrote:
> Vilas reported that virtio-vsock no longer worked properly after
> suspend/resume (echo mem >/sys/power/state).
> It was impossible to connect to the host and vice versa.
> 
> Indeed, the support has never been implemented.
> 
> This series implement .freeze and .restore callbacks of struct virtio_driver
> to support device suspend/resume.
> 
> The first patch factors our the code to initialize and delete VQs.
> The second patch uses that code to support device suspend/resume.
> 
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>


Acked-by: Michael S. Tsirkin <mst@redhat.com>

> Stefano Garzarella (2):
>   vsock/virtio: factor our the code to initialize and delete VQs
>   vsock/virtio: add support for device suspend/resume
> 
>  net/vmw_vsock/virtio_transport.c | 197 ++++++++++++++++++++-----------
>  1 file changed, 131 insertions(+), 66 deletions(-)
> 
> -- 
> 2.35.1

