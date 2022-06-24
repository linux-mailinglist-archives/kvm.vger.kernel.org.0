Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE72559B40
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 16:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbiFXOMI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 10:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232303AbiFXOMH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 10:12:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 93CF862E6
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 07:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656079925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4yoKMHx8hwjlhiED35XD21wSiT8cy5Qt0nttKMguOFA=;
        b=c8nHUROhEKDTWTArVjucDTefGFE2VTQRvUh9quRpvn7UOsCKnz6FdMnBEL0eG4vDb7f8GB
        FvfsT5uX+mJcax0vGXRDwZHFKLCVColN9y4vWmM5qEWkHcZWLCmnOoMxI9KjMojL+RauVG
        gh5QwXWVUoA7EqyyZgyNM1qpYKopD90=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-4bxURHhaMnuNVFxFYIu_SA-1; Fri, 24 Jun 2022 10:12:02 -0400
X-MC-Unique: 4bxURHhaMnuNVFxFYIu_SA-1
Received: by mail-io1-f71.google.com with SMTP id y22-20020a056602215600b00673b11a9cd5so1367174ioy.7
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 07:12:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=4yoKMHx8hwjlhiED35XD21wSiT8cy5Qt0nttKMguOFA=;
        b=O9ZUodlMmiVi2fJcNKuWEnLlgV39g9O0cPQ5wKKTZe5K13AkI8zTYRqv+PNook0Hzt
         3GsGC+8hksATaO2O8JA7FUA1Jzmcpm16flTjZ6M9Pi9WeOxWsAwzkaUnzHOM7yQSiz44
         kiEmYc6tOgHnnD6M1YkazkntzLYSPMsWHyd0ufDzBd87GAYPgFzFfLtQlE3huHQeFoCY
         na0F4RpvJDwUOBcIF0BKpIxYg3y0RShgXjdAx5PZeUalasHyvyyvrW/u9WeN5STNKkRi
         qt7Kj4PSBNUFtAMQxHGH1ANCuFnVnGUVukzxVT4hmSBig9sZE/RF1VTuPgOpUnwTT5Rz
         imtw==
X-Gm-Message-State: AJIora/GNPvGqR1hhNilPfnL7GaKM06L/ZWdBdSuf+5a1EZJibw+JM6u
        9J3t0V2F858WDuavysWu/OcqTokClgNv2q6dr7FpIZ5el2KDL02gBKxr/8ys12uNZjqhZZix9dt
        1myXB7RY/MN8H
X-Received: by 2002:a05:6e02:1a49:b0:2d9:500e:4a06 with SMTP id u9-20020a056e021a4900b002d9500e4a06mr5757819ilv.43.1656079921961;
        Fri, 24 Jun 2022 07:12:01 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1svZazEj69RanON2dp4ypTbHsA9NUh03zO72gJcjs8JfjOdXtOKKxzpMQNeXHU8+oJ9Wo4RqA==
X-Received: by 2002:a05:6e02:1a49:b0:2d9:500e:4a06 with SMTP id u9-20020a056e021a4900b002d9500e4a06mr5757804ilv.43.1656079921645;
        Fri, 24 Jun 2022 07:12:01 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id t8-20020a5e9908000000b00674eedf7bbfsm1286144ioj.33.2022.06.24.07.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 07:12:00 -0700 (PDT)
Date:   Fri, 24 Jun 2022 08:11:59 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Robin Murphy <robin.murphy@arm.com>, cohuck@redhat.com,
        iommu@lists.linux.dev, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] vfio/type1: Simplify bus_type determination
Message-ID: <20220624081159.508baed3.alex.williamson@redhat.com>
In-Reply-To: <20220624015030.GJ4147@nvidia.com>
References: <b1d13cade281a7d8acbfd0f6a33dcd086207952c.1655898523.git.robin.murphy@arm.com>
        <20220622161721.469fc9eb.alex.williamson@redhat.com>
        <68263bd7-4528-7acb-b11f-6b1c6c8c72ef@arm.com>
        <20220623170044.1757267d.alex.williamson@redhat.com>
        <20220624015030.GJ4147@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Jun 2022 22:50:30 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Jun 23, 2022 at 05:00:44PM -0600, Alex Williamson wrote:
> 
> > > >> +struct vfio_device *vfio_device_get_from_iommu(struct iommu_group *iommu_group)
> > > >> +{
> > > >> +	struct vfio_group *group = vfio_group_get_from_iommu(iommu_group);
> > > >> +	struct vfio_device *device;    
> > > > 
> > > > Check group for NULL.    
> > > 
> > > OK - FWIW in context this should only ever make sense to call with an 
> > > iommu_group which has already been derived from a vfio_group, and I did 
> > > initially consider a check with a WARN_ON(), but then decided that the 
> > > unguarded dereference would be a sufficiently strong message. No problem 
> > > with bringing that back to make it more defensive if that's what you prefer.  
> > 
> > A while down the road, that's a bit too much implicit knowledge of the
> > intent and single purpose of this function just to simply avoid a test.  
> 
> I think we should just pass the 'struct vfio_group *' into the
> attach_group op and have this API take that type in and forget the
> vfio_group_get_from_iommu().

That's essentially what I'm suggesting, the vfio_group is passed as an
opaque pointer which type1 can use for a
vfio_group_for_each_vfio_device() type call.  Thanks,

Alex

