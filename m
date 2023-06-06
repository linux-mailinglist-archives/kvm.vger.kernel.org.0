Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01477724374
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 14:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237383AbjFFM7Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 08:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbjFFM7W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 08:59:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0719A10F7
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 05:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686056295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dtuylhemCFrocIQz72z/IvBRItNMZNPZwOBB6roSRDM=;
        b=VMQ+Roar/LRQZyjUSGQq/wpJkzdCHsZ2NNzjluy+ipew6O43Gnuiwoud+Mxmsaeyi3pzyx
        agTH1wyUPHIU3HmWNv70mQJHLBekU0brpjSN+UjoRSRR43IaAntHiZLXVwjRhtqs4lNYjD
        lgpgjm6NgZcVfdcfOLGHjkBvEzIOwGs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-twmHWNKnPq-iXZMf0aroNg-1; Tue, 06 Jun 2023 08:58:12 -0400
X-MC-Unique: twmHWNKnPq-iXZMf0aroNg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f7e7a6981cso7910785e9.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 05:58:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686056291; x=1688648291;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dtuylhemCFrocIQz72z/IvBRItNMZNPZwOBB6roSRDM=;
        b=fckj2nIWpwhxB6cRl49sNods3E3HXL0eR/ax2DVNr1GrVXpsLRq4M4T/8UZTz0NehR
         IZhnXIiQcE/ozega2gOBjlocwDYMIDBxrL/4wR3rdLVNlF/vCi9iuUvpn5sDnRzk4Zzg
         H7TpbRG4sY6k9kb6AvwMk6LZCEAC9/JLvjrAnonWzjqU0Ds8TZrR/xwZS7uO1Zs+4i8P
         NnkffXcnsLY2aE9hc8z1Slhh+VDCX2PFuTOEU5U21nB6yT/IiUxDqNpr2739tUEWYCqY
         EQ7ieRcUJgTdxGWpvis4a3d+2Pze5UiRyZruADafaGqiHVV5dkGXV5AC/lwB1RzJQ7Ik
         W5yw==
X-Gm-Message-State: AC+VfDxtRnC8k6m3JbxQsLuytjtnCC2YaQFE3btUWpFALjFqHC+FpFRO
        sRa2DnVE3hDToF0uWPpwEJ93myeD8ETjF6F4KKe0ObiLVyCqvzXxmf2IsGyOhsLy1iecw2dieOE
        e8EPhlYeBAUKN
X-Received: by 2002:a05:600c:3797:b0:3f4:2492:a91f with SMTP id o23-20020a05600c379700b003f42492a91fmr1985701wmr.27.1686056291609;
        Tue, 06 Jun 2023 05:58:11 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7iSPeYaUH/YZk+7SBXsnFurRNoLRH/Yr/5f9n7h0h6HrxGNUlFSlQiPwqzijjD8yGHRwJDSg==
X-Received: by 2002:a05:600c:3797:b0:3f4:2492:a91f with SMTP id o23-20020a05600c379700b003f42492a91fmr1985683wmr.27.1686056291295;
        Tue, 06 Jun 2023 05:58:11 -0700 (PDT)
Received: from redhat.com ([2.55.41.2])
        by smtp.gmail.com with ESMTPSA id q25-20020a7bce99000000b003eddc6aa5fasm17487714wmj.39.2023.06.06.05.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 05:58:10 -0700 (PDT)
Date:   Tue, 6 Jun 2023 08:58:06 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Shannon Nelson <shannon.nelson@amd.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <20230606085643-mutt-send-email-mst@kernel.org>
References: <20230605110644.151211-1-sgarzare@redhat.com>
 <20230605084104-mutt-send-email-mst@kernel.org>
 <24fjdwp44hovz3d3qkzftmvjie45er3g3boac7aezpvzbwvuol@lmo47ydvnqau>
 <20230605085840-mutt-send-email-mst@kernel.org>
 <gi2hngx3ndsgz5d2rpqjywdmou5vxhd7xgi5z2lbachr7yoos4@kpifz37oz2et>
 <20230605095404-mutt-send-email-mst@kernel.org>
 <32ejjuvhvcicv7wjuetkv34qtlpa657n4zlow4eq3fsi2twozk@iqnd2t5tw2an>
 <CACGkMEu3PqQ99UoKF5NHgVADD3q=BF6jhLiyumeT4S1QCqN1tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEu3PqQ99UoKF5NHgVADD3q=BF6jhLiyumeT4S1QCqN1tw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 06, 2023 at 09:29:22AM +0800, Jason Wang wrote:
> On Mon, Jun 5, 2023 at 10:58 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> >
> > On Mon, Jun 05, 2023 at 09:54:57AM -0400, Michael S. Tsirkin wrote:
> > >On Mon, Jun 05, 2023 at 03:30:35PM +0200, Stefano Garzarella wrote:
> > >> On Mon, Jun 05, 2023 at 09:00:25AM -0400, Michael S. Tsirkin wrote:
> > >> > On Mon, Jun 05, 2023 at 02:54:20PM +0200, Stefano Garzarella wrote:
> > >> > > On Mon, Jun 05, 2023 at 08:41:54AM -0400, Michael S. Tsirkin wrote:
> > >> > > > On Mon, Jun 05, 2023 at 01:06:44PM +0200, Stefano Garzarella wrote:
> > >> > > > > vhost-vdpa IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE)
> > >> > > > > don't support packed virtqueue well yet, so let's filter the
> > >> > > > > VIRTIO_F_RING_PACKED feature for now in vhost_vdpa_get_features().
> > >> > > > >
> > >> > > > > This way, even if the device supports it, we don't risk it being
> > >> > > > > negotiated, then the VMM is unable to set the vring state properly.
> > >> > > > >
> > >> > > > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> > >> > > > > Cc: stable@vger.kernel.org
> > >> > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > >> > > > > ---
> > >> > > > >
> > >> > > > > Notes:
> > >> > > > >     This patch should be applied before the "[PATCH v2 0/3] vhost_vdpa:
> > >> > > > >     better PACKED support" series [1] and backported in stable branches.
> > >> > > > >
> > >> > > > >     We can revert it when we are sure that everything is working with
> > >> > > > >     packed virtqueues.
> > >> > > > >
> > >> > > > >     Thanks,
> > >> > > > >     Stefano
> > >> > > > >
> > >> > > > >     [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/
> > >> > > >
> > >> > > > I'm a bit lost here. So why am I merging "better PACKED support" then?
> > >> > >
> > >> > > To really support packed virtqueue with vhost-vdpa, at that point we would
> > >> > > also have to revert this patch.
> > >> > >
> > >> > > I wasn't sure if you wanted to queue the series for this merge window.
> > >> > > In that case do you think it is better to send this patch only for stable
> > >> > > branches?
> > >> > > > Does this patch make them a NOP?
> > >> > >
> > >> > > Yep, after applying the "better PACKED support" series and being
> > >> > > sure that
> > >> > > the IOCTLs of vhost-vdpa support packed virtqueue, we should revert this
> > >> > > patch.
> > >> > >
> > >> > > Let me know if you prefer a different approach.
> > >> > >
> > >> > > I'm concerned that QEMU uses vhost-vdpa IOCTLs thinking that the kernel
> > >> > > interprets them the right way, when it does not.
> > >> > >
> > >> > > Thanks,
> > >> > > Stefano
> > >> > >
> > >> >
> > >> > If this fixes a bug can you add Fixes tags to each of them? Then it's ok
> > >> > to merge in this window. Probably easier than the elaborate
> > >> > mask/unmask dance.
> > >>
> > >> CCing Shannon (the original author of the "better PACKED support"
> > >> series).
> > >>
> > >> IIUC Shannon is going to send a v3 of that series to fix the
> > >> documentation, so Shannon can you also add the Fixes tags?
> > >>
> > >> Thanks,
> > >> Stefano
> > >
> > >Well this is in my tree already. Just reply with
> > >Fixes: <>
> > >to each and I will add these tags.
> >
> > I tried, but it is not easy since we added the support for packed
> > virtqueue in vdpa and vhost incrementally.
> >
> > Initially I was thinking of adding the same tag used here:
> >
> > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> >
> > Then I discovered that vq_state wasn't there, so I was thinking of
> >
> > Fixes: 530a5678bc00 ("vdpa: support packed virtqueue for set/get_vq_state()")
> >
> > So we would have to backport quite a few patches into the stable branches.
> > I don't know if it's worth it...
> >
> > I still think it is better to disable packed in the stable branches,
> > otherwise I have to make a list of all the patches we need.
> >
> > Any other ideas?
> 
> AFAIK, except for vp_vdpa, pds seems to be the first parent that
> supports packed virtqueue. Users should not notice anything wrong if
> they don't use packed virtqueue. And the problem of vp_vdpa + packed
> virtqueue came since the day0 of vp_vdpa. It seems fine to do nothing
> I guess.
> 
> Thanks


I have a question though, what if down the road there
is a new feature that needs more changes? It will be
broken too just like PACKED no?
Shouldn't vdpa have an allowlist of features it knows how
to support?

> >
> > Thanks,
> > Stefano
> >
> >

