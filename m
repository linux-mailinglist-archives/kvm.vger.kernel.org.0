Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F039E6971EF
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 00:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjBNXn1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 18:43:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbjBNXn0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 18:43:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372DA2CC42
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 15:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676418160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZUUIJ0cR3hLFYeEAbqlgShBHqdmwbGBdBl0fRIuzsMc=;
        b=Z9SSNNWJKoUPjdd9hdfPIVUjcS0whPujKZRcq6bvwiX8GbmhGrfrvjndNY/rtYdwckTVQl
        qFmiJxEMGnWdm1D8R/qcuCGTS09dbUQ0raKbGE83gwi6N87pmZu0oby6HOPeDYGSA/ypz9
        f1BItQSug1Hi5RrkMZ824UZeQp1rsec=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-551-r1O-raUFP4ioTYUdeCmPdA-1; Tue, 14 Feb 2023 18:42:38 -0500
X-MC-Unique: r1O-raUFP4ioTYUdeCmPdA-1
Received: by mail-io1-f69.google.com with SMTP id n3-20020a056602340300b0073e7646594aso4649546ioz.8
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 15:42:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZUUIJ0cR3hLFYeEAbqlgShBHqdmwbGBdBl0fRIuzsMc=;
        b=mwFmmktl1Ct9Kvafl3ZuksWk2d29IB8A1YRMTtenJwrUBRLOsZtIe5f/oTi5k6Gsk8
         iKksFGGNsxV0Igotm3PikU3yH7cEUb9dbPKBk10qyHQvG8RqL2VtzSeplNJ8Hc5fp78D
         XD6ro6TQh3PrLycSVpTmIE66vzid251Y8b8uz4VfiDU3qpYbP1iOeUPxp5xAhhdEEJxV
         8Tc5YyrLtCek4Da62nd8S9+7QrGOxjLhkg2kqfUBPNvF62qXy3tdB/fomsSzW2PhTLPI
         SV6mHYD6cl75x1aSwRr0LswWgsBVRjmkxI2vh0djcH1e/eowAufLD3S3pNQNwz+WR2/2
         rHhg==
X-Gm-Message-State: AO0yUKWPry4l65A+1xNmaDAakMxXSMg2uV59JlUW5ZOKvF798np2lMPA
        yptp0o7P1oWktR65b5tLDqAs7DhslewgoEH01TlrWlScdTCuS29iWVMw1cU/nZ6X2tgtcqS9pSb
        +szEKs1QLNbCs
X-Received: by 2002:a05:6e02:1989:b0:311:66d:47aa with SMTP id g9-20020a056e02198900b00311066d47aamr486657ilf.26.1676418158129;
        Tue, 14 Feb 2023 15:42:38 -0800 (PST)
X-Google-Smtp-Source: AK7set+cnwaRu+xYLJYwKfQ18mKejRaIiksmj5ioXJ6on5Mp2TS8hLl7ygq6BKPlyKgT13iA1wicDA==
X-Received: by 2002:a05:6e02:1989:b0:311:66d:47aa with SMTP id g9-20020a056e02198900b00311066d47aamr486634ilf.26.1676418157875;
        Tue, 14 Feb 2023 15:42:37 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id b4-20020a02a584000000b003c4e8efcd09sm310027jam.32.2023.02.14.15.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 15:42:37 -0800 (PST)
Date:   Tue, 14 Feb 2023 16:42:35 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, kevin.tian@intel.com,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        Timothy Pearson <tpearson@raptorengineering.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v3 05/15] kvm/vfio: Accept vfio device file from
 userspace
Message-ID: <20230214164235.64e2dccb.alex.williamson@redhat.com>
In-Reply-To: <Y+wYX34sPvPQmGSr@nvidia.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
        <20230213151348.56451-6-yi.l.liu@intel.com>
        <20230214152627.3a399523.alex.williamson@redhat.com>
        <Y+wYX34sPvPQmGSr@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Feb 2023 19:25:19 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Feb 14, 2023 at 03:26:27PM -0700, Alex Williamson wrote:
> > > index 857d6ba349e1..d869913baafd 100644
> > > --- a/virt/kvm/vfio.c
> > > +++ b/virt/kvm/vfio.c
> > > @@ -286,18 +286,18 @@ static int kvm_vfio_set_file(struct kvm_device *dev, long attr,
> > >  	int32_t fd;
> > >  
> > >  	switch (attr) {
> > > -	case KVM_DEV_VFIO_GROUP_ADD:
> > > +	case KVM_DEV_VFIO_FILE_ADD:
> > >  		if (get_user(fd, argp))
> > >  			return -EFAULT;
> > >  		return kvm_vfio_file_add(dev, fd);
> > >  
> > > -	case KVM_DEV_VFIO_GROUP_DEL:
> > > +	case KVM_DEV_VFIO_FILE_DEL:
> > >  		if (get_user(fd, argp))
> > >  			return -EFAULT;
> > >  		return kvm_vfio_file_del(dev, fd);
> > >  
> > >  #ifdef CONFIG_SPAPR_TCE_IOMMU
> > > -	case KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE:
> > > +	case KVM_DEV_VFIO_FILE_SET_SPAPR_TCE:
> > >  		return kvm_vfio_file_set_spapr_tce(dev, arg);  
> > 
> > I don't see that the SPAPR code is so easily fungible to a device
> > file descriptor.  The kvm_vfio_spapr_tce data structure includes a
> > groupfd, which is required to match a groupfd on the file_list.  So
> > a SPAPR user cannot pass a cdev via FILE_ADD if they intend to use
> > this TCE code.  
> 
> SPAPR cannot use cdev at all, cdev mode only works with iommufd.
> 
> So with my other remark about blocking unbound cdevs, in SPAPR mode
> you can never open a cdev and make it bound thus
> kvm_vfio_file_iommu_group() and others will return NULL always for
> cdev.
> 
> Thus AFAICT this is all fine.

A device file opened through a group could be passed through this
interface though, right?  Do we just chalk that up to user error?
Maybe the SPAPR extension at least needs to be documented as relying on
registering groups rather than devices.
 
> Yi, you should also add some kconfig stuff to ensure that SPAPR always
> has the group interface compiled in.
> 
> > That also makes me wonder what we're really gaining in forcing this
> > generalization from group to file.    
> 
> I think it is just less code overall. Otherwise we need to needlessly
> double quite a lot of stuff, rather pointlessly, IMHO.
> 
> I'm still thinking about proposing to just delete all this SPAPR
> stuff. Power still hasn't had the patches applied to make it work
> again so it seems to all be dead.

There's been some off-list discussion about at least fixing SPAPR
support, but yes, it either needs to get some love or we ought to think
about its future.  Thanks,

Alex

