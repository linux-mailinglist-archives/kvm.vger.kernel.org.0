Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C89D72E67D
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 17:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240894AbjFMPAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 11:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241780AbjFMPAe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 11:00:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5A5E6
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 07:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686668384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QRtfwNfvdV2+4M7kYHt2quGEQYXsOTq8+l44AMF6dzY=;
        b=hVuJn8b4klrmR/I6H5S3wc64OLD2ADnRaB/exHEMTykzdjqgmTiWVS+pv+SMoBqEyJZghC
        VcqlbqpfyCfybtB6cgpid4fXe5QWt1FQnnM2ZGyXHIaKZir3sCg3R699Tj7hjh20WjT5mX
        Ambi08YReESVdTVcPkJbzGWtx0ZFrJI=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-lKPRC1d1PwGZsKLiweeDLg-1; Tue, 13 Jun 2023 10:59:42 -0400
X-MC-Unique: lKPRC1d1PwGZsKLiweeDLg-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-33e5ad802b4so54612545ab.0
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 07:59:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686668382; x=1689260382;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QRtfwNfvdV2+4M7kYHt2quGEQYXsOTq8+l44AMF6dzY=;
        b=YtZVXB/eD/Ca4RkM8dBNs9uUHsvi0am+q1Gbxi4fALS+Xfc2mTnV74wGykQ0lPoMlu
         1PSl7Cdd34HHjOVyO/BhrSNyVG98/GmF9Io8Nes79xMG2BbE1S8fcDIIMXpxBmgzqMQv
         IbamDzj29nwuzELRiWfER6NSizPGEO7Lcw1Ma/SsRgT7JCpPdz5idCpJquvEXPUtpMjP
         jBlvkjwGlevd72jIA8mhBWLmiBoZ42oVkaXfWOzRm4oSi3UvY9TBCP+r5TsFifCgbInn
         NB+GxOMtJ6wLgtlQxAl9uTumy8vrCDu6SnT2xCZIYx+glA5gHpVCuOiliIyAYgVje3tV
         vL6w==
X-Gm-Message-State: AC+VfDzR+Odb8wH4fH0cg7FYIqKBJWlpI6fs7R8Oext7G5WolNdjTL+N
        +ULlgc3wwNX6XZ0lzGo4N9FVqjc3CDx6BwxSAAJGmPgJsano6ToOC7y6faYBJrNvF0OKuETm7yT
        LrVS7c5X7nc+a
X-Received: by 2002:a92:d692:0:b0:33b:16e9:bba5 with SMTP id p18-20020a92d692000000b0033b16e9bba5mr10637748iln.28.1686668381865;
        Tue, 13 Jun 2023 07:59:41 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ56wOGNrFHguy8G1gOdD07CDWsifOYqsxCJef6NrgWP3Bq+BzA/QCcECdkeDnWN+pMbBIXbEQ==
X-Received: by 2002:a92:d692:0:b0:33b:16e9:bba5 with SMTP id p18-20020a92d692000000b0033b16e9bba5mr10637725iln.28.1686668381652;
        Tue, 13 Jun 2023 07:59:41 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id ep25-20020a0566384e1900b0041f4f31ec7esm520823jab.71.2023.06.13.07.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 07:59:41 -0700 (PDT)
Date:   Tue, 13 Jun 2023 08:59:39 -0600
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
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: Re: [PATCH v12 18/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <20230613085939.63583166.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB7529E63E24335F6DF655E1A8C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-19-yi.l.liu@intel.com>
        <20230612162726.16f58ea4.alex.williamson@redhat.com>
        <DS0PR11MB752985BA514AFF36CA3A2785C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230613081808.049b9e6d.alex.williamson@redhat.com>
        <DS0PR11MB7529F0A41AA58AE37BCF8458C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230613083935.753430ed.alex.williamson@redhat.com>
        <DS0PR11MB7529E63E24335F6DF655E1A8C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Jun 2023 14:42:46 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Tuesday, June 13, 2023 10:40 PM
> > 
> > On Tue, 13 Jun 2023 14:28:43 +0000
> > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >   
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Tuesday, June 13, 2023 10:18 PM  
> > >  
> > > > > > > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > > > > > > index 83cc5dc28b7a..e80a8ac86e46 100644
> > > > > > > --- a/include/linux/vfio.h
> > > > > > > +++ b/include/linux/vfio.h
> > > > > > > @@ -66,6 +66,7 @@ struct vfio_device {
> > > > > > >  	struct iommufd_device *iommufd_device;
> > > > > > >  	bool iommufd_attached;
> > > > > > >  #endif
> > > > > > > +	bool cdev_opened:1;  
> > > > > >
> > > > > > Perhaps a more strongly defined data type here as well and roll
> > > > > > iommufd_attached into the same bit field scheme.  
> > > > >
> > > > > Ok, then needs to make iommufd_attached always defined.  
> > > >
> > > > That does not follow.  Thanks,  
> > >
> > > Well, I meant the iommufd_attached now is defined only when
> > > CONFIG_IOMMUFD is enabled. To toll it with cdev_opened, needs
> > > to change this.  
> > 
> > Understood, but I don't think it's true.  If defined we use one more
> > bit of the bit field, which is a consideration when we approach filling
> > it, but we're not using bit-shift operations to address these bits, so
> > why does it matter if one has compiler conditional usage?  Thanks,  
> 
> Aha, I see. So you are suggesting something like the below. Is it?
> 
> #if IS_ENABLED(CONFIG_IOMMUFD)
> 	struct iommufd_device *iommufd_device;
> 	u8 iommufd_attached:1;
> #endif
> 	u8 cdev_opened:1;


Precisely.  Thanks,

Alex

