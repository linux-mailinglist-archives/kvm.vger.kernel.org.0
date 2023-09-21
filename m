Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1567AA2A1
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 23:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbjIUVZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 17:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbjIUVY3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 17:24:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467BAC2
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695329713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x2GFnQYMs7RLu1Nka2/IBYuhXJchf/y41F4WyNwuFGY=;
        b=KBUPuVtnB4KQKz1I5RUUesOxb40qW+mGTxWtBDUE+cQupqJXTI2ZJOk9nvk/t3APY9C0JD
        8CRQ5zIbdECcCGXz2YiW36FoU5QRaaxhEBS47Myqk+yQu+7hu0s6mRGL0KrbzO3Gk+G7b0
        xr6eZhHwEhDBAxPFuiwBTdVa6400z2A=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-A8y-2GrZOnCumUrMdfAy1w-1; Thu, 21 Sep 2023 16:55:11 -0400
X-MC-Unique: A8y-2GrZOnCumUrMdfAy1w-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-94f7a2b21fdso99597166b.2
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:55:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695329710; x=1695934510;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x2GFnQYMs7RLu1Nka2/IBYuhXJchf/y41F4WyNwuFGY=;
        b=f4d9QKVKq8Duq5h4apyKBfsi9XMY0XdXnIfsz+jAZB7fwUxW0Y3iVITVgVDcs0RnaD
         t8EwC7fAzazDqhDthHYjxS5XLKfA0ebAvJJ6S7CDj1p+2kggm85bODswZjMET0bedETJ
         JgXv55C12SG+w3FnnSLUBgOrZb9KuCaVn+4bQl0a+e7a4CGwuk51O0z1gF9qmvdClX5O
         trTNhccbbfCO4uezcNmUK5emmXDyyCsUNccUnd2V9AOqVM1KKGntioDVFShy9VSlzaL7
         7jA2xFS9pqWQA8alTD4T1rU3jBayjK1a1HTB1mDb0/k0SG2PXvhQVeNtyvfJDdvnxAAg
         ipaQ==
X-Gm-Message-State: AOJu0YwNZgxDbkXJm/o5v6iyyKyzA5pwYFyArQmXmuxOG2ebhacgSozm
        Wx7QFxzPzFNHPfj3rufFuktt2flQl11+cFhEca9uBN6FiHzvk5rF99AEIt54VFaoywjFM3gGGeB
        zyJKkNNOqGjn4
X-Received: by 2002:a17:906:cc9:b0:9a1:bee8:9252 with SMTP id l9-20020a1709060cc900b009a1bee89252mr5499469ejh.29.1695329710700;
        Thu, 21 Sep 2023 13:55:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJ+gjiY2qKz49SqOzH96PvcDQ//acHYSyEsL/nahBhRDrFSrox1rM/f0uOn3wusa63GltzDg==
X-Received: by 2002:a17:906:cc9:b0:9a1:bee8:9252 with SMTP id l9-20020a1709060cc900b009a1bee89252mr5499456ejh.29.1695329710343;
        Thu, 21 Sep 2023 13:55:10 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id ce21-20020a170906b25500b009ad850d4760sm1555657ejb.219.2023.09.21.13.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 13:55:09 -0700 (PDT)
Date:   Thu, 21 Sep 2023 16:55:05 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230921164558-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921090844-mutt-send-email-mst@kernel.org>
 <20230921141125.GM13733@nvidia.com>
 <20230921101509-mutt-send-email-mst@kernel.org>
 <20230921164139.GP13733@nvidia.com>
 <20230921124331-mutt-send-email-mst@kernel.org>
 <20230921183926.GV13733@nvidia.com>
 <20230921151325-mutt-send-email-mst@kernel.org>
 <20230921195115.GY13733@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921195115.GY13733@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 04:51:15PM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 21, 2023 at 03:17:25PM -0400, Michael S. Tsirkin wrote:
> > On Thu, Sep 21, 2023 at 03:39:26PM -0300, Jason Gunthorpe wrote:
> > > > What is the huge amount of work am I asking to do?
> > > 
> > > You are asking us to invest in the complexity of VDPA through out
> > > (keep it working, keep it secure, invest time in deploying and
> > > debugging in the field)
> > 
> > I'm asking you to do nothing of the kind - I am saying that this code
> > will have to be duplicated in vdpa,
> 
> Why would that be needed?

For the same reason it was developed in the 1st place - presumably
because it adds efficient legacy guest support with the right card?
I get it, you specifically don't need VDPA functionality, but I don't
see why is this universal, or common.


> > and so I am asking what exactly is missing to just keep it all
> > there.
> 
> VFIO. Seriously, we don't want unnecessary mediation in this path at
> all.

But which mediation is necessary is exactly up to the specific use-case.
I have no idea why would you want all of VFIO to e.g. pass access to
random config registers to the guest when it's a virtio device and the
config registers are all nicely listed in the spec. I know nvidia
hardware is so great, it has super robust cards with less security holes
than the vdpa driver, but I very much doubt this is universal for all
virtio offload cards.

> > note I didn't ask you to add iommufd to vdpa though that would be
> > nice ;)
> 
> I did once send someone to look.. It didn't succeed :(
> 
> Jason

Pity. Maybe there's some big difficulty blocking this? I'd like to know.

-- 
MST

