Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5547663B9
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 07:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbjG1FqW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 01:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233414AbjG1FqI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 01:46:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC38B35B0
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 22:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690523120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oAXmH+qYY8bjmfYawJukNpxQ9bW1VMYi2zFEUqTpT64=;
        b=D+2zr3X6/pAk4+jmBJeQnbQwMsvJb/F06DMUvbCsyOwpBabgqKt3yb7kG+MhZ65unEFhOP
        xsntZlqA4kjJp8omrheZ9P8oRR6uSokwxUH+FC9PNSYgfHqojg6cjTDVh77fpKjf/EyiJ7
        /vg7qz9CKUvpNV+aym4DM1aQpdC20PM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-x3014GwLOFuQEdfQ5sboAQ-1; Fri, 28 Jul 2023 01:45:18 -0400
X-MC-Unique: x3014GwLOFuQEdfQ5sboAQ-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-521dd050a78so1087208a12.0
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 22:45:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690523117; x=1691127917;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oAXmH+qYY8bjmfYawJukNpxQ9bW1VMYi2zFEUqTpT64=;
        b=Sr9cqktXGpP6/kuhp8JBYonHTkEye9/pfPZ8oqyY+E9Wo3u4IL3WjRP1IrGicAnKpr
         TIf/jeQlKOz3yPXmJ1/wFNk8iuT2fNhq7XyYGDG4pPJBMyZfbxs/r/+km64aErySSC8z
         Oljbu05osyp7fzVG+V5E8asCWVvAc+Ghn8YKcJuofTGIgoOQpNQqxxlHaee4BQqC2xCD
         VwF6ojLlbY/H+a9AsXQEh5oBukUwrPBnD7+u00oZ58nvU+uXbBOYHzy51hIT3K89ZPKM
         0s9/Z+li8tbSQyX4pY+PsKeZA9yn2zpGOFuGWI4M3c72mUnKwx2NGfIfZ+72v/t+U0JI
         v/DA==
X-Gm-Message-State: ABy/qLZwzVx/LRK1PzGHLF6wpiZYLqDPWZOuUQXej7c9ssWahcCZSnQe
        G57TCc9rU7MCpF+Sx2NkldMYvt2TWK2TgtfBJ9qzUd0mlwkbn8M0JShhnL+IDSWjnj1W/zdlU+u
        cdjDFtyC/iB1I
X-Received: by 2002:a05:6402:1b1a:b0:522:5932:57ec with SMTP id by26-20020a0564021b1a00b00522593257ecmr857292edb.41.1690523117664;
        Thu, 27 Jul 2023 22:45:17 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFBXUrFKZkaaBFtalSQoz0QArd65X5FID0AfhTTUMyGnaIqLIFeqt+FaMOPM4wBS7TieKmTsQ==
X-Received: by 2002:a05:6402:1b1a:b0:522:5932:57ec with SMTP id by26-20020a0564021b1a00b00522593257ecmr857285edb.41.1690523117382;
        Thu, 27 Jul 2023 22:45:17 -0700 (PDT)
Received: from redhat.com ([2.52.14.22])
        by smtp.gmail.com with ESMTPSA id f26-20020a056402069a00b005224d960e66sm1384975edy.96.2023.07.27.22.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 22:45:15 -0700 (PDT)
Date:   Fri, 28 Jul 2023 01:45:10 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [PATCH net-next v4 0/4] vsock/virtio/vhost: MSG_ZEROCOPY
 preparations
Message-ID: <20230728012845-mutt-send-email-mst@kernel.org>
References: <20230727222627.1895355-1-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230727222627.1895355-1-AVKrasnov@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 28, 2023 at 01:26:23AM +0300, Arseniy Krasnov wrote:
> Hello,
> 
> this patchset is first of three parts of another big patchset for
> MSG_ZEROCOPY flag support:
> https://lore.kernel.org/netdev/20230701063947.3422088-1-AVKrasnov@sberdevices.ru/

overall looks good. Two points I'd like to see addressed:
- what's the performance with all these changes - still same?
- most systems have a copybreak scheme where buffers
  smaller than a given size are copied directly.
  This will address regression you see with small buffers -
  but need to find that value. we know it's between 4k and 32k :)


> During review of this series, Stefano Garzarella <sgarzare@redhat.com>
> suggested to split it for three parts to simplify review and merging:
> 
> 1) virtio and vhost updates (for fragged skbs) <--- this patchset
> 2) AF_VSOCK updates (allows to enable MSG_ZEROCOPY mode and read
>    tx completions) and update for Documentation/.
> 3) Updates for tests and utils.
> 
> This series enables handling of fragged skbs in virtio and vhost parts.
> Newly logic won't be triggered, because SO_ZEROCOPY options is still
> impossible to enable at this moment (next bunch of patches from big
> set above will enable it).
> 
> I've included changelog to some patches anyway, because there were some
> comments during review of last big patchset from the link above.
> 
> Head for this patchset is 9d0cd5d25f7d45bce01bbb3193b54ac24b3a60f3
> 
> Link to v1:
> https://lore.kernel.org/netdev/20230717210051.856388-1-AVKrasnov@sberdevices.ru/
> Link to v2:
> https://lore.kernel.org/netdev/20230718180237.3248179-1-AVKrasnov@sberdevices.ru/
> Link to v3:
> https://lore.kernel.org/netdev/20230720214245.457298-1-AVKrasnov@sberdevices.ru/
> 
> Changelog:
>  * Patchset rebased and tested on new HEAD of net-next (see hash above).
>  * See per-patch changelog after ---.
> 
> Arseniy Krasnov (4):
>   vsock/virtio/vhost: read data from non-linear skb
>   vsock/virtio: support to send non-linear skb
>   vsock/virtio: non-linear skb handling for tap
>   vsock/virtio: MSG_ZEROCOPY flag support
> 
>  drivers/vhost/vsock.c                   |  14 +-
>  include/linux/virtio_vsock.h            |   6 +
>  net/vmw_vsock/virtio_transport.c        |  79 +++++-
>  net/vmw_vsock/virtio_transport_common.c | 312 ++++++++++++++++++------
>  4 files changed, 330 insertions(+), 81 deletions(-)
> 
> -- 
> 2.25.1

