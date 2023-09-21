Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B461C7AA1D7
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 23:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbjIUVHY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 17:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbjIUVGI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 17:06:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D710E5AE0A
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695316894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Yfvcp/sQqGTMiLfnwncZE40pvpmDeNT1ERGwo6bROTE=;
        b=iR0+V7iuoHPJ/VxbXaU/141OZpLvDJ6+GxJuYdlCac9/5IhWOZtGMkPHyM9H/JbuB3n0MK
        1XTi5FiiOH/Rav70lUlmUd765jDqmL6jVaC8mQGIE3eEWTAbKUCeKVKYoYqVG5tx1kp7zE
        Es2SStUIlVzZ1fV8dJNSzYlYSlWes9Q=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-aLEZ7GCVPv2D9dVEqj3nvg-1; Thu, 21 Sep 2023 13:21:32 -0400
X-MC-Unique: aLEZ7GCVPv2D9dVEqj3nvg-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-53114797d43so850550a12.2
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:21:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695316891; x=1695921691;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yfvcp/sQqGTMiLfnwncZE40pvpmDeNT1ERGwo6bROTE=;
        b=C0b6zTqTXRKNS8//FfFy4iYeqfsG5q5e/ZfB6uhI7W8RiaFb7XFXjMHQhYerLXnV3c
         Pb6+3GoOIYumiWCVcZImySzFkjAnMw3MPd2JcbS7JM/bz7rTZ3KrDCE89Wx44q9O65c1
         4rHhXaqZPNzqx1xNY1xQ+CckRCjQ0NRgVSxRflZrElPZR5Ax/b8ReAc7ZFfySagivHhi
         XXbnN/zNrMeWKEbLmSsBspRzk0Y/gnhjGFfiKZbXSCAzV+XKsHuJw4ybert95ZQo63JW
         ijGyAvmmLmL1jYgIk8o5Ia3RitKZm5mceIl3rpPv5KqOql0DwK/YXZwYxhV44dJRqfRh
         l1+g==
X-Gm-Message-State: AOJu0YxQ9ftjJEaWbT5zl/2Z8M0urj0Dq4dOfdMGJFZU2SH2ZfPPBCrL
        CqLRrn4aSxpGoJTiq/Bff6ie1C8Dt3YdtNdlDq9i8UhsBgVt+SPQ56aUHOkoEpIxpiRSMO8GZRk
        7SfB2GVfPRSTL
X-Received: by 2002:a17:906:2216:b0:9ae:6bef:4a6a with SMTP id s22-20020a170906221600b009ae6bef4a6amr1282164ejs.16.1695316891620;
        Thu, 21 Sep 2023 10:21:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8DbU18CgGE/rzYdUfBFCWTzbAvRH225iJnMR97jIiNIWNmMT4Vftg9I2DLNAh448yV8cgCA==
X-Received: by 2002:a17:906:2216:b0:9ae:6bef:4a6a with SMTP id s22-20020a170906221600b009ae6bef4a6amr1282136ejs.16.1695316891261;
        Thu, 21 Sep 2023 10:21:31 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id dx26-20020a170906a85a00b0099bcd1fa5b0sm1314460ejb.192.2023.09.21.10.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 10:21:30 -0700 (PDT)
Date:   Thu, 21 Sep 2023 13:21:26 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230921131035-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921104350.6bb003ff.alex.williamson@redhat.com>
 <20230921165224.GR13733@nvidia.com>
 <20230921125348-mutt-send-email-mst@kernel.org>
 <20230921170709.GS13733@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921170709.GS13733@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 02:07:09PM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 21, 2023 at 01:01:12PM -0400, Michael S. Tsirkin wrote:
> > On Thu, Sep 21, 2023 at 01:52:24PM -0300, Jason Gunthorpe wrote:
> > > On Thu, Sep 21, 2023 at 10:43:50AM -0600, Alex Williamson wrote:
> > > 
> > > > > With that code in place a legacy driver in the guest has the look and
> > > > > feel as if having a transitional device with legacy support for both its
> > > > > control and data path flows.
> > > > 
> > > > Why do we need to enable a "legacy" driver in the guest?  The very name
> > > > suggests there's an alternative driver that perhaps doesn't require
> > > > this I/O BAR.  Why don't we just require the non-legacy driver in the
> > > > guest rather than increase our maintenance burden?  Thanks,
> > > 
> > > It was my reaction also.
> > > 
> > > Apparently there is a big deployed base of people using old guest VMs
> > > with old drivers and they do not want to update their VMs. It is the
> > > same basic reason why qemu supports all those weird old machine types
> > > and HW emulations. The desire is to support these old devices so that
> > > old VMs can work unchanged.
> > > 
> > > Jason
> > 
> > And you are saying all these very old VMs use such a large number of
> > legacy devices that over-counting of locked memory due to vdpa not
> > correctly using iommufd is a problem that urgently needs to be solved
> > otherwise the solution has no value?
> 
> No one has said that.
> 
> iommufd is gaining alot more functions than just pinned memory
> accounting.

Yea it's very useful - it's also useful for vdpa whether this patchset
goes in or not.  At some level, if vdpa can't keep up then maybe going
the vfio route is justified. I'm not sure why didn't anyone fix iommufd
yet - looks like a small amount of work. I'll see if I can address it
quickly because we already have virtio accelerators under vdpa and it
seems confusing to people to use vdpa for some and vfio for others, with
overlapping but slightly incompatible functionality.  I'll get back next
week, in either case. I am however genuinely curious whether all the new
functionality is actually useful for these legacy guests.

> > Another question I'm interested in is whether there's actually a
> > performance benefit to using this as compared to just software
> > vhost. I note there's a VM exit on each IO access, so ... perhaps?
> > Would be nice to see some numbers.
> 
> At least a single trap compared with an entire per-packet SW flow
> undoubtably uses alot less CPU power in the hypervisor.
> 
> Jason

Something like the shadow vq thing will be more or less equivalent then?
That's upstream in qemu and needs no hardware support. Worth comparing
against.  Anyway, there's presumably actual hardware this was tested
with, so why guess? Just test and post numbers.

-- 
MST

