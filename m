Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1576861F775
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 16:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbiKGPUE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 10:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbiKGPUC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 10:20:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE1A1ADAA
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 07:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667834338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DPVWQ+YraXRChqzr4SQlG/qjPD1QpM0ZmFrgY+kvQEQ=;
        b=gd6w2bMniN8FYHUZ7hlaIMIgidZplfIaZn7BE5XdlsCN1+xA2JNsUkP1TRyhTaZatmdg6F
        jPYJFCXWfNrKunOLiOPadHHSrDVnJklWHgMECaJ1WJ02O79UYXR4xsduqb+SCuajUWwK2E
        0VWJoGTUUNuMxpdo2H+B9qpTHFxRu5A=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-35-YueFtTVyNL29nnjpXFv1AQ-1; Mon, 07 Nov 2022 10:18:57 -0500
X-MC-Unique: YueFtTVyNL29nnjpXFv1AQ-1
Received: by mail-io1-f72.google.com with SMTP id n23-20020a056602341700b00689fc6dbfd6so7265471ioz.8
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 07:18:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DPVWQ+YraXRChqzr4SQlG/qjPD1QpM0ZmFrgY+kvQEQ=;
        b=2o6aVHT2APydoz9nD9w8oNlcJ3G5IFHvbO90sinBP5FSpVv3apsRMcUDVzw01KhEpR
         WHUAVDv2NHXRHXzUT/2otSNs34DtnZV8XDgfk1e2ly565vGpxJRW/EIamPHBWtJ6VTz0
         ow9NVz7wGIeeDT7TiEIviXUBDoO+0mSa+zrfdb1+RvzQG2Zp6Td/C4OeRUPHNgfzJIGd
         IhuXJQEITKnhSYb2CuFp80AGkdyOducg4ITPVKY/n0WDxixdx4QFI+n0IZvSNnaVrn/I
         l2/RANB3+lf9j28f2ayMP1XPczpm5PpTO8XjcsYrY8DWy5gUGS/iLO/9x4wkxHMo3VA0
         NCFg==
X-Gm-Message-State: ACrzQf0P33yRtf4x6x6kQ2Cfhgj3Ids5nXnrpF0oJPDCZMoDzeEyClSQ
        x9l4wYOo5ViDRMOtfiO7Jx7OI0s6ydzWBeSYs7eDu1y8hpUslgKdUs5s+BIFtViaz1pabMZSC6s
        /Kvov2HLFVkdU
X-Received: by 2002:a92:d74f:0:b0:300:ad95:35c5 with SMTP id e15-20020a92d74f000000b00300ad9535c5mr25950901ilq.137.1667834336879;
        Mon, 07 Nov 2022 07:18:56 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4lWUzVNR72O39IQE6LeiepbZvM9WXMUgdmYx2bv2/TRXid0tlwA/a3n4EvaTSlM1yrwXs6uQ==
X-Received: by 2002:a92:d74f:0:b0:300:ad95:35c5 with SMTP id e15-20020a92d74f000000b00300ad9535c5mr25950861ilq.137.1667834336637;
        Mon, 07 Nov 2022 07:18:56 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id z101-20020a0293ee000000b0037556012c63sm2771396jah.132.2022.11.07.07.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 07:18:55 -0800 (PST)
Date:   Mon, 7 Nov 2022 08:18:53 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>,
        dri-devel@lists.freedesktop.org,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Longfang Liu <liulongfang@huawei.com>,
        linux-s390@vger.kernel.org, Yi Liu <yi.l.liu@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Will Deacon <will@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Halil Pasic <pasic@linux.ibm.com>, iommu@lists.linux.dev,
        Nicolin Chen <nicolinc@nvidia.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org, Zhi Wang <zhi.a.wang@intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        intel-gvt-dev@lists.freedesktop.org,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [PATCH 04/10] vfio: Move storage of allow_unsafe_interrupts to
 vfio_main.c
Message-ID: <20221107081853.18727337.alex.williamson@redhat.com>
In-Reply-To: <Y2kF75zVD581UeR2@nvidia.com>
References: <0-v1-4991695894d8+211-vfio_iommufd_jgg@nvidia.com>
        <4-v1-4991695894d8+211-vfio_iommufd_jgg@nvidia.com>
        <20221026152442.4855c5de.alex.williamson@redhat.com>
        <Y1wiCc33Jh5QY+1f@nvidia.com>
        <20221031164526.0712e456.alex.williamson@redhat.com>
        <Y2kF75zVD581UeR2@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
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

On Mon, 7 Nov 2022 09:19:43 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Oct 31, 2022 at 04:45:26PM -0600, Alex Williamson wrote:
> 
> > > It is one idea, it depends how literal you want to be on "module
> > > parameters are ABI". IMHO it is a weak form of ABI and the need of
> > > this paramter in particular is not that common in modern times, AFAIK.
> > > 
> > > So perhaps we just also expose it through vfio.ko and expect people to
> > > migrate. That would give a window were both options are available.  
> > 
> > That might be best.  Ultimately this is an opt-out of a feature that
> > has security implications, so I'd rather error on the side of requiring
> > the user to re-assert that opt-out.  It seems the potential good in
> > eliminating stale or unnecessary options outweighs any weak claims of
> > preserving an ABI for a module that's no longer in service.  
> 
> Ok, lets do this
> 
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -55,6 +55,11 @@ static struct vfio {
>  bool vfio_allow_unsafe_interrupts;
>  EXPORT_SYMBOL_GPL(vfio_allow_unsafe_interrupts);
>  
> +module_param_named(allow_unsafe_interrupts,
> +                  vfio_allow_unsafe_interrupts, bool, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(allow_unsafe_interrupts,
> +                "Enable VFIO IOMMU support for on platforms without interrupt remapping support.");
> +
>  static DEFINE_XARRAY(vfio_device_set_xa);
>  static const struct file_operations vfio_group_fops;
> 
> > However, I'd question whether vfio is the right place for that new
> > module option.  As proposed, vfio is only passing it through to
> > iommufd, where an error related to lack of the hardware feature is
> > masked behind an -EPERM by the time it gets back to vfio, making any
> > sort of advisory to the user about the module option convoluted.  It
> > seems like iommufd should own the option to opt-out universally, not
> > just through the vfio use case.  Thanks,  
> 
> My thinking is this option shouldn't exist at all in other iommufd
> users. eg I don't see value in VDPA supporting it.

I disagree, the IOMMU interface is responsible for isolating the
device, this option doesn't make any sense to live in vfio-main, which
is the reason it was always a type1 option.  If vdpa doesn't allow full
device access such that it can guarantee that a device cannot generate
a DMA that can spoof MSI, then it sounds like the flag we pass when
attaching a device to iommfd should to reflect this difference in usage.
The driver either requires full isolation, default, or can indicate a
form of restricted DMA programming that prevents interrupt spoofing.
The policy whether to permit unsafe configurations should exist in one
place, iommufd.  Thanks,

Alex

