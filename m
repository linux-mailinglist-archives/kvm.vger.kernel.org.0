Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867616F0C04
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 20:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244457AbjD0SgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 14:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243558AbjD0Sf7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 14:35:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C832E4
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 11:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682620512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hyhutbl1P5p00Ldo4kjlPS0faKiyka/h141Hh06aCdE=;
        b=M25jcg0dQh4SA/RgkpFHetKWCgB26mS5bQJCatuRRnk5W3v8uUSCERA4gZI0QhYIQjR+za
        JEA4LEhnw2Q1xaWRz22QjUJzTxZmUpJyUydBu2WC083Y/+J4E7rdD13gcyto+L2IXcAhHL
        IxwlPt1+XyFoibZ1zdC7ZowFOhOewQ8=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-9hJ4ERTFOni4LBwcY9KOwg-1; Thu, 27 Apr 2023 14:35:10 -0400
X-MC-Unique: 9hJ4ERTFOni4LBwcY9KOwg-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3294f07346aso63721535ab.0
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 11:35:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682620510; x=1685212510;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hyhutbl1P5p00Ldo4kjlPS0faKiyka/h141Hh06aCdE=;
        b=Jkp8JxQBCH9ImJ8SWTBEkqZhBnBQQmVC82MJeoPnlZmIHiLSGb2KZL8of853NfLZQl
         fmwqM0p9Im9yQn43HAUTV6iHIJzUiDUKglNOWzUVN7OI+r+w1jrBRSDFWMQ2ESvXVEuD
         PNGAgBAo/oDGFXi/jdwN0dVdGI0EIP8CJjGNY1fvGhv+wom3a6/aMM+s37oD8/dTVvNe
         6YbiNIRZSSLkdvHHC+pnYNDbggGuXXdjhqMdGG5qe1CEqAOy+FaJCJauMy8BjHopq7Mu
         s3xoHxvnu5xa2cuxM3gOO96Vc9zrs9GCixUADfyXCDFFHc4Nl5B8ruiA9W4WYl4G4m5Z
         goQg==
X-Gm-Message-State: AC+VfDwmK/GjkGlGxw92uzRSYvk18L/6EJKCrzq04R0obL7dK6mvh/1Z
        gks24Cd+S5S6vWBA9KxCQz54nifkFoKWqi79I7aU5jq5iPXep+Ag3/PjMyO2xxKXWL3uU3KNyAJ
        p29B6BCV+eOjy
X-Received: by 2002:a92:d6c9:0:b0:32a:8a24:31a0 with SMTP id z9-20020a92d6c9000000b0032a8a2431a0mr1740512ilp.31.1682620510012;
        Thu, 27 Apr 2023 11:35:10 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6qadVzYEMD+1W0+SRpJ/1qXTVhSN/ckiE2OD13eLxYiv9ISmKYP7X6A6gsdcovc2mbQDrEfA==
X-Received: by 2002:a92:d6c9:0:b0:32a:8a24:31a0 with SMTP id z9-20020a92d6c9000000b0032a8a2431a0mr1740495ilp.31.1682620509736;
        Thu, 27 Apr 2023 11:35:09 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id p26-20020a02b01a000000b0040f94ea2a2bsm5647408jah.40.2023.04.27.11.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 11:35:09 -0700 (PDT)
Date:   Thu, 27 Apr 2023 12:35:08 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
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
Subject: Re: [PATCH v4 1/9] vfio: Determine noiommu in vfio_device
 registration
Message-ID: <20230427123508.251617d4.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB75294AF4D8B4A886F7646F44C36A9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
        <20230426145419.450922-2-yi.l.liu@intel.com>
        <BN9PR11MB527688F8FBB299306400A1308C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <DS0PR11MB75294AF4D8B4A886F7646F44C36A9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 27 Apr 2023 07:05:37 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Tian, Kevin <kevin.tian@intel.com>
> > Sent: Thursday, April 27, 2023 2:36 PM
> >   
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Wednesday, April 26, 2023 10:54 PM
> > >
> > > -static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
> > > +static inline int vfio_device_set_noiommu(struct vfio_device *device)
> > >  {
> > > -	return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> > > -	       vdev->group->type == VFIO_NO_IOMMU;
> > > +	device->noiommu = IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> > > +			  device->group->type == VFIO_NO_IOMMU;
> > > +	return 0;  
> > 
> > Just void. this can't fail.  
> 
> Hmmm. Yes, before below commit, it cannot fail. Maybe this can be
> converted to int later.
> 
> https://lore.kernel.org/kvm/20230426150321.454465-22-yi.l.liu@intel.com/T/#u

AFAICT with the comments on the next patch, this change is not at all
justified within this series and should be dropped.  Thanks,

Alex

