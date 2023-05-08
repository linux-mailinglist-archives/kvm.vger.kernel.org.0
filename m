Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7107E6FB854
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 22:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbjEHUay (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 16:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjEHUau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 16:30:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFD149C3
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 13:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683577806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DVSAqbGo/SYymxziE0Ynvj5CJeQ8fOYfiV63Ae36Jlg=;
        b=Vp3OXkB0Zp14ZyzkOhjvxXhvAnNAnwJHh9Z/srtpZJ7qRBP9eRIjqt4iaJjFNzmeUrYigK
        /F34YRrA1faGni9j4pCRsCO6AtOSY5rYcHd4yQX0GwT3puC7+v/UA7SeHHR2Y+OITB6ZjT
        YcJbrGXqdqtyqsGiGVe3auH4c9dbip8=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-sYQoVXOaNIOFTiQQAKjZeA-1; Mon, 08 May 2023 16:29:59 -0400
X-MC-Unique: sYQoVXOaNIOFTiQQAKjZeA-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3358657b57aso3696825ab.3
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 13:29:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683577798; x=1686169798;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DVSAqbGo/SYymxziE0Ynvj5CJeQ8fOYfiV63Ae36Jlg=;
        b=FOT146dhvjRWuK8hjNZVSqvREN+kpiNeXJ0VvLyI21I4n1ojfxwawGDdP/5TrhLNhX
         AZAUU6UHZkPKhbzn4X6KdmWQUrdaJWGbw6DpEOKnIM4nurLya06E6znSiIj7rQGSoCCJ
         2dF7jmhg8uEqo9/22AKu4LQSLyKCrqFxdRHBlMoUJD2dM6r0jTu5uN6uHCn88dMhGFZ7
         /09f9NmdEama7pawrHKTE/5r/MVWz2SWSBX2WaygIowZOzwcmG/aj9j64F6Qr0XQQuiL
         pSAGTpqCF+/lfyJZNoOLv+bU7E3VDnq1PTPOWPS3ZzAoT0WWTGIw0VZ0Q7oKao82t9UZ
         hV8w==
X-Gm-Message-State: AC+VfDzdWe0KnGyObhYwkPl66ZlJ1r8Ua4OV3kXp8NvBgGu8VyEmiOsO
        LoRc7MZ6CVmcPtJWtB5ovKas9L8Qt17OFnHd9p7iNsf4BuP3QRNPtQ/sSk9gvu/dEE/Md8sB4df
        h5VitcOy72xX+
X-Received: by 2002:a92:d403:0:b0:326:3a39:89d0 with SMTP id q3-20020a92d403000000b003263a3989d0mr8107223ilm.1.1683577798626;
        Mon, 08 May 2023 13:29:58 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7DrZnriZETaQ/90S6mqc6FkPi+6no4KK3rwJGM0g691+Xcp+XCrkWFWkbvezVgZkHdFJFtOw==
X-Received: by 2002:a92:d403:0:b0:326:3a39:89d0 with SMTP id q3-20020a92d403000000b003263a3989d0mr8107209ilm.1.1683577798310;
        Mon, 08 May 2023 13:29:58 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id l2-20020a056e0205c200b00334faa50484sm1915883ils.54.2023.05.08.13.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 13:29:57 -0700 (PDT)
Date:   Mon, 8 May 2023 14:29:55 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: Re: [PATCH v4 8/9] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Message-ID: <20230508142955.44566026.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB75295210DA7C4C2896D1FB6DC3719@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
        <20230426145419.450922-9-yi.l.liu@intel.com>
        <20230427140405.2afe27d4.alex.williamson@redhat.com>
        <20230427141533.7d8861ed.alex.williamson@redhat.com>
        <DS0PR11MB75295210DA7C4C2896D1FB6DC3719@DS0PR11MB7529.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 8 May 2023 15:32:44 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, April 28, 2023 4:16 AM
> >  
> > > > + *
> > > >   * Return: 0 on success, -errno on failure:
> > > >   *	-enospc = insufficient buffer, -enodev = unsupported for device.
> > > >   */
> > > >  struct vfio_pci_dependent_device {
> > > > -	__u32	group_id;
> > > > +	union {
> > > > +		__u32   group_id;
> > > > +		__u32	dev_id;
> > > > +#define VFIO_PCI_DEVID_NONBLOCKING	0
> > > > +#define VFIO_PCI_DEVID_BLOCKING	-1  
> > >
> > > The above description seems like it's leaning towards OWNED rather than
> > > BLOCKING.  
> > 
> > Also these should be defined relative to something defined in IOMMUFD
> > rather than inventing values here.  We can't have the valid devid
> > number space owned by IOMMUFD conflict with these definitions.  Thanks,  
> 
> Jason has proposed to reserve all negative IDs and 0 in iommufd. In that case,
> can vfio define the numbers now?

Ok, as long as it's guaranteed that we're overlapping invalid dev-ids,
as specified by IOMMUFD, then the mapping of specific invalid dev-ids
to error values here is interface specific and can be defined here.
Thanks,

Alex

