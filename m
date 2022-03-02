Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A57B4CAA34
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 17:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbiCBQbZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 11:31:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241726AbiCBQbX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 11:31:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D379C6240
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 08:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646238639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kMa9v1xtxt05GLfYOo70TOSVE9rMZc+g01ANVJtihbg=;
        b=ALcWlOWAQjUmwtMjy+Co956Cs0mvEhfeU9Dz3ol3wIS5GdoTa97aF7uoHF1w0LVfqQlEEW
        LUv4cJWsqsHchY/V4IXxQJOddr+V+YBtf69QckILiFDcJwetNoasJfkIK1xYp8NWANWZap
        DB7PbqdFeBAZ/c/SwAVI/VGrHYB/ZH4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-269-brFLgBcFPkKaC_xuSad25w-1; Wed, 02 Mar 2022 11:30:36 -0500
X-MC-Unique: brFLgBcFPkKaC_xuSad25w-1
Received: by mail-wm1-f69.google.com with SMTP id c19-20020a05600c0ad300b00385bb3db625so479864wmr.4
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 08:30:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kMa9v1xtxt05GLfYOo70TOSVE9rMZc+g01ANVJtihbg=;
        b=nv8kZfW7zQY7JQrBqLzKkMKYEJcHb5VZezbQmTa2YVJ6IEkVkrVhJzg6/u1GOSPOmw
         8EiHWYZPTRJhe6EJOXWLDECzLFXMwWBYnzeZ6MXslflsCSj2zPHSHJRIygFu8i2Smy1O
         lCr8Q9xodHFjVV9hN2xWuqn7tX287L2lfBUrb07p7yHH2H1J7wsM53Xc157vzvPljJ64
         DaAk725j30yBI/1XMXiICf+dFqPKnm6nke1mz7rOvZmDDbqmeHRdp4ANRysVFxXI6Gcn
         7YNkH82xaNq5AytC0GsrtQP302d1wqp9Vz812kHcIWQ9+Ej8aOpM1KWXEFn1ixwb2CTy
         TwZQ==
X-Gm-Message-State: AOAM531UOs3MrS5O5TrHTzQclDU3rVvPcQu21BYQfHN9XqUYVuihXPBl
        bRQ62uns0UsbuSp0l/RPea7soNL49Lhi2wDqSo5JzANuh4UbllmqZNOs+yxQ3RxP9GySkluFJct
        jEMVHYeW3W7LB
X-Received: by 2002:a7b:c14c:0:b0:381:32fb:a128 with SMTP id z12-20020a7bc14c000000b0038132fba128mr489123wmi.116.1646238634138;
        Wed, 02 Mar 2022 08:30:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxPFSyJJ3cuBRpkY9KOm5MVNCqPvFnh7F/Ims38I9cMHs0dlB6ZbjMEGiiJX+VRcZzNYFLg0w==
X-Received: by 2002:a7b:c14c:0:b0:381:32fb:a128 with SMTP id z12-20020a7bc14c000000b0038132fba128mr489104wmi.116.1646238633941;
        Wed, 02 Mar 2022 08:30:33 -0800 (PST)
Received: from redhat.com ([2a10:8006:355c:0:48d6:b937:2fb9:b7de])
        by smtp.gmail.com with ESMTPSA id o11-20020adf9d4b000000b001f0077ea337sm5972902wre.22.2022.03.02.08.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 08:30:33 -0800 (PST)
Date:   Wed, 2 Mar 2022 11:30:30 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Lee Jones <lee.jones@linaro.org>, Jason Wang <jasowang@redhat.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <20220302112945-mutt-send-email-mst@kernel.org>
References: <20220302075421.2131221-1-lee.jones@linaro.org>
 <20220302082021-mutt-send-email-mst@kernel.org>
 <Yh93k2ZKJBIYQJjp@google.com>
 <20220302095045-mutt-send-email-mst@kernel.org>
 <Yh+F1gkCGoYF2lMV@google.com>
 <CAGxU2F4cUDrMzoHH1NT5_ivxBPgEE8HOzP5s_Bt5JURRaSsLdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGxU2F4cUDrMzoHH1NT5_ivxBPgEE8HOzP5s_Bt5JURRaSsLdQ@mail.gmail.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022 at 05:28:31PM +0100, Stefano Garzarella wrote:
> On Wed, Mar 2, 2022 at 3:57 PM Lee Jones <lee.jones@linaro.org> wrote:
> >
> > On Wed, 02 Mar 2022, Michael S. Tsirkin wrote:
> >
> > > On Wed, Mar 02, 2022 at 01:56:35PM +0000, Lee Jones wrote:
> > > > On Wed, 02 Mar 2022, Michael S. Tsirkin wrote:
> > > >
> > > > > On Wed, Mar 02, 2022 at 07:54:21AM +0000, Lee Jones wrote:
> > > > > > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > > > > > to vhost_get_vq_desc().  All we have to do is take the same lock
> > > > > > during virtqueue clean-up and we mitigate the reported issues.
> > > > > >
> > > > > > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> > > > > >
> > > > > > Cc: <stable@vger.kernel.org>
> > > > > > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> > > > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > > > ---
> > > > > >  drivers/vhost/vhost.c | 2 ++
> > > > > >  1 file changed, 2 insertions(+)
> > > > > >
> > > > > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > > > > index 59edb5a1ffe28..bbaff6a5e21b8 100644
> > > > > > --- a/drivers/vhost/vhost.c
> > > > > > +++ b/drivers/vhost/vhost.c
> > > > > > @@ -693,6 +693,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > > > > >         int i;
> > > > > >
> > > > > >         for (i = 0; i < dev->nvqs; ++i) {
> > > > > > +               mutex_lock(&dev->vqs[i]->mutex);
> > > > > >                 if (dev->vqs[i]->error_ctx)
> > > > > >                         eventfd_ctx_put(dev->vqs[i]->error_ctx);
> > > > > >                 if (dev->vqs[i]->kick)
> > > > > > @@ -700,6 +701,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > > > > >                 if (dev->vqs[i]->call_ctx.ctx)
> > > > > >                         eventfd_ctx_put(dev->vqs[i]->call_ctx.ctx);
> > > > > >                 vhost_vq_reset(dev, dev->vqs[i]);
> > > > > > +               mutex_unlock(&dev->vqs[i]->mutex);
> > > > > >         }
> > > > >
> > > > > So this is a mitigation plan but the bug is still there though
> > > > > we don't know exactly what it is.  I would prefer adding something like
> > > > > WARN_ON(mutex_is_locked(vqs[i]->mutex) here - does this make sense?
> > > >
> > > > As a rework to this, or as a subsequent patch?
> > >
> > > Can be a separate patch.
> > >
> > > > Just before the first lock I assume?
> > >
> > > I guess so, yes.
> >
> > No problem.  Patch to follow.
> >
> > I'm also going to attempt to debug the root cause, but I'm new to this
> > subsystem to it might take a while for me to get my head around.
> 
> IIUC the root cause should be the same as the one we solved here:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a58da53ffd70294ebea8ecd0eb45fd0d74add9f9
> 
> The worker was not stopped before calling vhost_dev_cleanup(). So while 
> the worker was still running we were going to free memory or initialize 
> fields while it was still using virtqueue.
> 
> Cheers,
> Stefano

Right, and I agree but it's not the root though, we do attempt to stop all workers.

-- 
MST

