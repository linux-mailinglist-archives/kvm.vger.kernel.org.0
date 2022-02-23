Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 997944C06A3
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 02:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbiBWBKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 20:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232008AbiBWBKG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 20:10:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AE71A25E6
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 17:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645578578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VOIdj8LfS1quF8HrsiYyhYsFd/6gruTfw8BZDYs3h9Q=;
        b=Xy/JbyVE5jJWUph5dTVjeVSvMAZC/KDGgorQzbUonAMj9W3nC1Cs7CEZrPZ/enXGLB77X6
        GuWuX6GyshpTjUOKMkeOU+MNd/d+2qNSF48kUYOuIxAHxdepRTUaoor1SPeZP1093B278s
        ayTTxcaep9T67Se7SOEJAHpwPTR/Qyc=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-M6sGd8CxMUaMkDxppsIcfw-1; Tue, 22 Feb 2022 20:09:37 -0500
X-MC-Unique: M6sGd8CxMUaMkDxppsIcfw-1
Received: by mail-oi1-f198.google.com with SMTP id s83-20020acaa956000000b002d41cfd2926so6594636oie.0
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 17:09:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=VOIdj8LfS1quF8HrsiYyhYsFd/6gruTfw8BZDYs3h9Q=;
        b=2fmXVXqtmgxmR3vAirL9tL03GIdhab6v46HEU/Yeg3dIuazwoW17ntXl8I2mvOFs/S
         xxKdq3PGy9OF6yW9xorpQ3WexUuLeVWy+d8P98o6r8qlP3uQRPkuGamI+2XXUVo8EzIz
         VKxkvQOx8WKKcleyNuo6wmbHncboZ3tQY9RPM2TgvZNWxLUHVSlUxsEV1k0pqBZ9s8mt
         5Im8PJplMrJyC14+80HIJSJd0xfQKSFZ7VmvgClBcBtxkK/jQO9Y91kYg/gfNatE6P8+
         blu63FMXSaWVB2FlzPCz6APyaFhohWvzETOYeix9OBlJKpSD2BLXdqZPbu4QK9z7kjdo
         tFZQ==
X-Gm-Message-State: AOAM531EXFTBj1YtiCzMf+dxX7mDxiE8DcGzje2n50KgXQXNUAF6ypXw
        5lm9Fm6e9KdTxJpT0a94W314CKkew8cwCnWv2Zbpp+dsQYA8oNdCMTWBhZHm+8TSgteK2AYyX39
        zYPYtLss/jaoM
X-Received: by 2002:a05:6808:1a18:b0:2d3:a839:9a63 with SMTP id bk24-20020a0568081a1800b002d3a8399a63mr3283070oib.49.1645578577026;
        Tue, 22 Feb 2022 17:09:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw5kyhFx4+htnaM0l3I91ItDe+zVVFp1ujuNqQfpVUdehcJhe7A8Z6BfQmGQdwscqGL0UVHKw==
X-Received: by 2002:a05:6808:1a18:b0:2d3:a839:9a63 with SMTP id bk24-20020a0568081a1800b002d3a8399a63mr3283060oib.49.1645578576728;
        Tue, 22 Feb 2022 17:09:36 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q9sm1644757oif.9.2022.02.22.17.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 17:09:36 -0800 (PST)
Date:   Tue, 22 Feb 2022 18:09:34 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        cohuck@redhat.com, ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V8 mlx5-next 09/15] vfio: Define device migration
 protocol v2
Message-ID: <20220222180934.72400d6a.alex.williamson@redhat.com>
In-Reply-To: <20220223002136.GG10061@nvidia.com>
References: <20220220095716.153757-1-yishaih@nvidia.com>
        <20220220095716.153757-10-yishaih@nvidia.com>
        <20220222165300.4a8dd044.alex.williamson@redhat.com>
        <20220223002136.GG10061@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Feb 2022 20:21:36 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Feb 22, 2022 at 04:53:00PM -0700, Alex Williamson wrote:
> > On Sun, 20 Feb 2022 11:57:10 +0200
> > Yishai Hadas <yishaih@nvidia.com> wrote:
> >   
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > 
> > > Replace the existing region based migration protocol with an ioctl based
> > > protocol. The two protocols have the same general semantic behaviors, but
> > > the way the data is transported is changed.
> > > 
> > > This is the STOP_COPY portion of the new protocol, it defines the 5 states
> > > for basic stop and copy migration and the protocol to move the migration
> > > data in/out of the kernel.
> > > 
> > > Compared to the clarification of the v1 protocol Alex proposed:
> > > 
> > > https://lore.kernel.org/r/163909282574.728533.7460416142511440919.stgit@omen
> > > 
> > > This has a few deliberate functional differences:
> > > 
> > >  - ERROR arcs allow the device function to remain unchanged.
> > > 
> > >  - The protocol is not required to return to the original state on
> > >    transition failure. Instead userspace can execute an unwind back to
> > >    the original state, reset, or do something else without needing kernel
> > >    support. This simplifies the kernel design and should userspace choose
> > >    a policy like always reset, avoids doing useless work in the kernel
> > >    on error handling paths.
> > > 
> > >  - PRE_COPY is made optional, userspace must discover it before using it.
> > >    This reflects the fact that the majority of drivers we are aware of
> > >    right now will not implement PRE_COPY.
> > > 
> > >  - segmentation is not part of the data stream protocol, the receiver
> > >    does not have to reproduce the framing boundaries.  
> > 
> > I'm not sure how to reconcile the statement above with:
> > 
> > 	"The user must consider the migration data segments carried
> > 	 over the FD to be opaque and non-fungible. During RESUMING, the
> > 	 data segments must be written in the same order they came out
> > 	 of the saving side FD."
> > 
> > This is subtly conflicting that it's not segmented, but segments must
> > be written in order.  We'll naturally have some segmentation due to
> > buffering in kernel and userspace, but I think referring to it as a
> > stream suggests that the user can cut and join segments arbitrarily so
> > long as byte order is preserved, right?    
> 
> Yes, it is just some odd language that carried over from the v1 language
> 
> > I suspect the commit log comment is referring to the driver imposed
> > segmentation and framing relative to region offsets.  
> 
> v1 had some special behavior where qemu would carry each data_size as
> a single unit to the other side present it whole to the migration
> region. We couldn't find any use case for this, and it wasn't clear if
> this was deliberate or just a quirk of qemu's implementation.
> 
> We tossed it because doing an extra ioctl or something to learn this
> framing would hurt a zero-copy async iouring data mover scheme.

It was deliberate in the v1 because the data region might cover both
emulated and direct mapped ranges and might do so in combinations.  For
instance the driver could create a "frame" where the header lands in
emulated space to validate sequencing and setup the fault address for
mmap access.  A driver might use a windowing scheme to iterate across a
giant framebuffer, for example.
 
> > Maybe something like:
> > 
> > 	"The user must consider the migration data stream carried over
> > 	 the FD to be opaque and must preserve the byte order of the
> > 	 stream.  The user is not required to preserve buffer
> > 	 segmentation when writing the data stream during the RESUMING
> > 	 operation."  
> 
> Yes
> 
> > > + * The kernel migration driver must fully transition the device to the new state
> > > + * value before the operation returns to the user.  
> > 
> > The above statement certainly doesn't preclude asynchronous
> > availability of data on the stream FD, but it does demand that the
> > device state transition itself is synchronous and can cannot be
> > shortcut.  If the state transition itself exceeds migration SLAs, we're
> > in a pickle.  Thanks,  
> 
> Even if the commands were async, it is not easy to believe a device
> can instantaneously abort an arc when a timer hits and return to full
> operation. For instance, mlx5 can't do this.
> 
> The vCPU cannot be restarted to try to meet the SLA until a command
> going back to RUNNING returns.
> 
> If we want to have a SLA feature it feels better to pass in the
> deadline time as part of the set state ioctl and the driver can then
> internally do something appropriate and not have to figure out how to
> juggle an external abort. The driver would be expected to return fully
> completed from STOP or return back to RUNNING before the deadline.
> 
> For instance mlx5 could possibly implement this by checking the
> migration size and doing some maths before deciding if it should
> commit to its unabortable device command.
> 
> I have a feeling supporting SLA means devices are going to have to
> report latencies for various arcs and work in a more classical
> realtime deadline oriented way overall. Estimating the transfer
> latency and size is another factor too.
> 
> Overall, this SLA topic looks quite big to me, and I think a full
> solution will come with many facets. We are also quite interested in
> dirty rate limiting, for instance.

So if/when we were to support this, we might use a different SET_STATE
feature ioctl that allows the user to specify a deadline and we'd use
feature probing or a flag on the migration feature for userspace to
discover this?  I'd be ok with that, I just want to make sure we have
agreeable options to support it.  Thanks,

Alex

