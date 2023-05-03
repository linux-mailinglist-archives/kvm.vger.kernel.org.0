Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5DAA6F6175
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 00:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjECWuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 18:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjECWuK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 18:50:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCA44681
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 15:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683154163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pZKMay62CKj/rRkV21aMrRSKMlokKOiJJhw6mGzAbD4=;
        b=hvDFiQUCEqzES4Q03V8rYtRFkv/ROJs+dj7h1rrHX5RxRG6cIJ05ZDjDKqn22JEKGIL1gh
        ZYjiabcyTWwUh5P+Vd0DHVlCbwHEDew5Uhq9EeWdOBQ+sJbeT1Egfc5RHbwlyCPj2LMI0b
        oFxyLes+MS++3aeu4Q583iLBAZXP4SQ=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-niL9r23LO3y8jZcJrw6TbQ-1; Wed, 03 May 2023 18:49:22 -0400
X-MC-Unique: niL9r23LO3y8jZcJrw6TbQ-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-32b42b751bcso36907625ab.3
        for <kvm@vger.kernel.org>; Wed, 03 May 2023 15:49:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683154161; x=1685746161;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pZKMay62CKj/rRkV21aMrRSKMlokKOiJJhw6mGzAbD4=;
        b=ELHEbEQHkDHmLml2rNx83vqeeeYA3GZvA3kG70tTP9tAlqoomm43XXsUUTMBXfQ6XD
         X3P9aiw3F+zvZ2iLPiTRUdE454EdQPdabTt6M5X89KkHi4m6Pzh2r0axFI+KcnkYCKML
         jOcMF2N6t7xJkN52byrH9ZhWNSa0bmvsbnsPXH8bDSGt+BHiVCsD3V3kTQrJE1gloWBB
         Nw96GClsG/LnQZyEHkVtJdxxLBb9Z98xROpTgy2JPeX9BHqBzc8rHtOkCDsZ++Ha9GHB
         yg56R/sYiB7/VH+9NtodY+RfDQiKM7QuAbJjpLW+54irS7q7LuQtl5qkHWpiJCUSy/V/
         OpUw==
X-Gm-Message-State: AC+VfDxb3Gfv3XOfiL3Lo3kr6tpk69t2KLrJ6zd2+WbI4EpbeEJH8VaO
        1H17SvnxD7R2bPduuWogxzpj5NU6I80phrdQwDBUdXUmq+/1d1tRzqvyyuOwzpMVx+wgXSMrDab
        Ex/UpD/LZWXcH
X-Received: by 2002:a92:c84d:0:b0:318:ab40:4e9b with SMTP id b13-20020a92c84d000000b00318ab404e9bmr15017929ilq.2.1683154161175;
        Wed, 03 May 2023 15:49:21 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4ntpPSWb/poW4t0J5+ldQYO37YiiaPp9DXn+9xjK5dBx+7eAyDqpM0q/3zcX+WxbzjTaBu6Q==
X-Received: by 2002:a92:c84d:0:b0:318:ab40:4e9b with SMTP id b13-20020a92c84d000000b00318ab404e9bmr15017917ilq.2.1683154160924;
        Wed, 03 May 2023 15:49:20 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g8-20020a056e020d0800b0032c9da1d89csm9093182ilj.78.2023.05.03.15.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 15:49:20 -0700 (PDT)
Date:   Wed, 3 May 2023 16:49:16 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
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
Subject: Re: [PATCH v4 2/9] vfio-iommufd: Create iommufd_access for noiommu
 devices
Message-ID: <20230503164916.652d7779.alex.williamson@redhat.com>
In-Reply-To: <ZFK5AJxhMBGKqWaH@nvidia.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
        <20230426145419.450922-3-yi.l.liu@intel.com>
        <BN9PR11MB52768AF474FAB2AF36AC00508C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <DS0PR11MB752972AC1A6030CB442ACF3FC36A9@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230427123203.22307c4f.alex.williamson@redhat.com>
        <c203f11f-4d9f-cf43-03ab-e41a858bdd92@intel.com>
        <ZFFUyhqID+LtUB/D@nvidia.com>
        <DS0PR11MB7529B4E4513B1A56A90F111DC36C9@DS0PR11MB7529.namprd11.prod.outlook.com>
        <ZFK5AJxhMBGKqWaH@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 3 May 2023 16:41:52 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> > > My general idea to complete the no-iommu feature is to add a new IOCTL
> > > to VFIO that is 'pin iova and return dma addr' that no-iommu userspace
> > > would call instead of trying to abuse mlock and /proc/ to do it. That
> > > ioctl would use the IOAS attached to the access just like a mdev would
> > > do, so it has a real IOVA, but it is not a mdev.  
> > 
> > This new ioctl may be IOMMUFD ioctl since its input is the IOAS and
> > addr, nothing related to the device. Is it?  
> 
> No, definately a VFIO special ioctl for VFIO no-iommu mode.

This seems like brushing off the dirty work to vfio.  Userspace drivers
relying on no-iommu are in pretty questionable territory already, do we
care if they don't have a good means to pin pages and derive the DMA
address of those pinned pages?  As I noted earlier, I'm really not
interested in expanding no-iommu, it's less important now than when it
was added (we have vIOMMUs in VMs now and more platforms with IOMMUs)
and we shouldn't be encouraging its use by further developing the
interface.  Thanks,

Alex

