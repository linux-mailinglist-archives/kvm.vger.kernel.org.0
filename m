Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBDE93ACCC1
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 15:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbhFRNyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 09:54:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36462 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233947AbhFRNyD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Jun 2021 09:54:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624024313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4m43haMZkXo+6dMXFc2UeeK5bFqrx7krUnKM0CcDLn0=;
        b=YDGsMz+aYbC9Y8bemDniYqdmf8hii4zbdxoZby2JrQyv1RPCwAY2IOBvsQ86wf1chCVAoq
        tKqDp7Wb0s1blD0V+VcmIoyMaYhaCwQMDVEpr64P9Rql7zHLRTncYUp+lxHWHwIuIkE2LC
        VRh0SRlJHGBvlCPIVEp72MXiHbuiM1A=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-AvSM0eWQMLWGouJZ2d0OSQ-1; Fri, 18 Jun 2021 09:51:52 -0400
X-MC-Unique: AvSM0eWQMLWGouJZ2d0OSQ-1
Received: by mail-wr1-f69.google.com with SMTP id b3-20020a05600018a3b029011a84f85e1cso261324wri.10
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 06:51:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4m43haMZkXo+6dMXFc2UeeK5bFqrx7krUnKM0CcDLn0=;
        b=A3qKtpid3p8w9l+l5QwU4f3hEUtmNvOuTYFxLt/hbB15hA0TO11gl/OLh+xRCsepd9
         8oai61NaFCGXZpzlxe4dmt5w4qaPU235iMfQOIGkBAnaMMBymVnV9JwTv4bkZ2uMUhBi
         v3YGdIQ2Txvlplgd3C/US5sxvPOLJQXaezKBI9mwTsNuzqIgbmhgnmT5v77LTaQLPdWP
         d+8b6Cavt0c63GOF4+/ccqhkU8Ydw9weoHIbnzh0xlpdeNLpYrkkxa7avqjD3MHI0SPz
         dFDL+SYHhCEzrUDtkmXIaJz6wFfQf01bBfr2WVxORARSiJd5lAzw+CxFJHgq6LqEvgnb
         rIdQ==
X-Gm-Message-State: AOAM533shPeNCXUg40s++W/SQm0z3Vfa6DAVjYSPjWqaiwwW0ngu6Xjs
        6HPG1IVgayYEz1cXLU9pX+4hm7qGotoIOyXwFS85ReDkasaz0Gi2AV6jA752HGOPkG0xePar7rA
        m7ogrWQUxWKsN
X-Received: by 2002:a5d:6350:: with SMTP id b16mr12960564wrw.41.1624024310549;
        Fri, 18 Jun 2021 06:51:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzqJ3GZeW6jRvmnJbJ7b1ZhOousWSFHH5OW+Xxp1vDn8d5uUTDBmjRCWu6e4mCUYbWrxf7YAw==
X-Received: by 2002:a5d:6350:: with SMTP id b16mr12960548wrw.41.1624024310425;
        Fri, 18 Jun 2021 06:51:50 -0700 (PDT)
Received: from redhat.com ([77.126.22.11])
        by smtp.gmail.com with ESMTPSA id b11sm8767138wrf.43.2021.06.18.06.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 06:51:48 -0700 (PDT)
Date:   Fri, 18 Jun 2021 09:51:44 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        oxffffaa@gmail.com
Subject: Re: [PATCH v11 11/18] virtio/vsock: dequeue callback for
 SOCK_SEQPACKET
Message-ID: <20210618095006-mutt-send-email-mst@kernel.org>
References: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
 <20210611111241.3652274-1-arseny.krasnov@kaspersky.com>
 <20210618134423.mksgnbmchmow4sgh@steredhat.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210618134423.mksgnbmchmow4sgh@steredhat.lan>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 18, 2021 at 03:44:23PM +0200, Stefano Garzarella wrote:
> Hi Arseny,
> the series looks great, I have just a question below about
> seqpacket_dequeue.
> 
> I also sent a couple a simple fixes, it would be great if you can review
> them:
> https://lore.kernel.org/netdev/20210618133526.300347-1-sgarzare@redhat.com/

So given this was picked into net next, what's the plan? Just make spec
follow code? We can wait and see, if there are issues with the spec just
remember to mask the feature before release.

-- 
MST

