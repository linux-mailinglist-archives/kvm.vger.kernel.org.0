Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFE37A9D88
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 21:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbjIUTj1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 15:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbjIUTjI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 15:39:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA48EFE35D
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 12:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695323599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uIcDHKJ63k2LO686PIhEvmmbJ6INtxlihcpXu8qTVw0=;
        b=d2SJLEqrAZHGkB9YWoxLgKu0X3sHygQfBXV0w4K8gMYG7jvUJXoCyuMBs08ADobUGNer9F
        udbDADKpyhXUY3b/96nDuiRjYijdpq5Gu9FG1V8Fa/Y59K7ErfXUHja61h9sQZvnho0CWe
        VyWwHmRgM0EJufG/pQVHXuRD7dDHzRs=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-139-zlqsjbj4Nx-Fumj77t5H5Q-1; Thu, 21 Sep 2023 15:13:17 -0400
X-MC-Unique: zlqsjbj4Nx-Fumj77t5H5Q-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-504319087d9so1015750e87.1
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 12:13:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695323596; x=1695928396;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uIcDHKJ63k2LO686PIhEvmmbJ6INtxlihcpXu8qTVw0=;
        b=NI1W6IW1hdXWMK1srOo87SyhtWaLT4wOoyvjnKlJ7fp7BU/bLTWAENd5PBbEsC/KRy
         uD9ixMH8/cLUAD5a6jikzFkq1v3ENQaCZJNMTsh4vcYbY83IThGBNz+abVq889s44Zkb
         G5/6PL6alv4QcgiIL1/35QtYfbKu1ZXjOvRXQ7+tIXaCXffxEEgt0KrUhQSSz67bsgLy
         cigEEUPcbwhV/pcdVZkyOXLH+67xrdth2YH2+QiAPKLBeJnDmkRrdfeyvvdA7/7HNxJH
         Y73tQfigvyssdYKUHvSlMxkQ2CJsr2EwKQ5HHceYCt44iVVxCVUIFw0Nf5QE2NeL3sDm
         GYUA==
X-Gm-Message-State: AOJu0YyJpa/CMIZ+g9wpjaXpKAKQNdisdsIEEFYg/WFA5HIg/9Ot4UX8
        Bwpvlustbon7PM6A/f6LqQbn8/QxjxsNqWWbejYvuCM4mKYGnPSWC9MRzxnB5U195CZaptm/f9w
        uS8tGtR+JY7tZ
X-Received: by 2002:ac2:5f73:0:b0:502:ff3b:7671 with SMTP id c19-20020ac25f73000000b00502ff3b7671mr5170706lfc.9.1695323596066;
        Thu, 21 Sep 2023 12:13:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8/iz5H5CKhlLgySdYaNA9eyFIKxMAik+l7vKm9bRvB3Re/xSzoPc116NYeijxnqI3CO20Tw==
X-Received: by 2002:ac2:5f73:0:b0:502:ff3b:7671 with SMTP id c19-20020ac25f73000000b00502ff3b7671mr5170689lfc.9.1695323595666;
        Thu, 21 Sep 2023 12:13:15 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id u11-20020a056402064b00b0053120f313cbsm1213956edx.39.2023.09.21.12.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 12:13:14 -0700 (PDT)
Date:   Thu, 21 Sep 2023 15:13:10 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230921150448-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921090844-mutt-send-email-mst@kernel.org>
 <20230921141125.GM13733@nvidia.com>
 <20230921101509-mutt-send-email-mst@kernel.org>
 <20230921164139.GP13733@nvidia.com>
 <20230921124331-mutt-send-email-mst@kernel.org>
 <20230921183926.GV13733@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921183926.GV13733@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 03:39:26PM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 21, 2023 at 12:53:04PM -0400, Michael S. Tsirkin wrote:
> > > vdpa is not vfio, I don't know how you can suggest vdpa is a
> > > replacement for a vfio driver. They are completely different
> > > things.
> > > Each side has its own strengths, and vfio especially is accelerating
> > > in its capability in way that vpda is not. eg if an iommufd conversion
> > > had been done by now for vdpa I might be more sympathetic.
> > 
> > Yea, I agree iommufd is a big problem with vdpa right now. Cindy was
> > sick and I didn't know and kept assuming she's working on this. I don't
> > think it's a huge amount of work though.  I'll take a look.
> > Is there anything else though? Do tell.
> 
> Confidential compute will never work with VDPA's approach.

I don't see how what this patchset is doing is different
wrt to Confidential compute - you trap IO accesses and emulate.
Care to elaborate?


> > There are a bunch of things that I think are important for virtio
> > that are completely out of scope for vfio, such as migrating
> > cross-vendor. 
> 
> VFIO supports migration, if you want to have cross-vendor migration
> then make a standard that describes the VFIO migration data format for
> virtio devices.

This has nothing to do with data formats - you need two devices to
behave identically. Which is what VDPA is about really.

> > What is the huge amount of work am I asking to do?
> 
> You are asking us to invest in the complexity of VDPA through out
> (keep it working, keep it secure, invest time in deploying and
> debugging in the field)
> 
> When it doesn't provide *ANY* value to the solution.

There's no "the solution" - this sounds like a vendor only caring about
solutions that involve that vendor's hardware exclusively, a little.

> The starting point is a completely working vfio PCI function and the
> end goal is to put that function into a VM. That is VFIO, not VDPA.
> 
> VPDA is fine for what it does, but it is not a reasonable replacement
> for VFIO.
> 
> Jason

VDPA basically should be a kind of "VFIO for virtio".

-- 
MST

