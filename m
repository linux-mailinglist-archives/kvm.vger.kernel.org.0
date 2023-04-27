Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFAF6F0BFE
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 20:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244571AbjD0Sc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 14:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244561AbjD0Sc5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 14:32:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7092A19C
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 11:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682620331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p6LZTxbqMNSlOAcpVGltFAX5rwaxLlFX1/1eyhmddg0=;
        b=bPQfNoVOd4XbxBPsYNQ4d8p3n8ir32eJe2qSay3uzi4bvZBQ+k7ZwoWzES+4i35IOaNCZc
        BnQy5+FQD1GQctc4WkmG7FNzrHuhxANawRaiWGtuHauEcaHKPVqFMGSTR1AgqZvx5E33Wv
        pkmvUeI77cBS/1WEQZgwRlI7XAdXTjk=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-340-XfmisnipONmFeYDwcmlVmg-1; Thu, 27 Apr 2023 14:32:07 -0400
X-MC-Unique: XfmisnipONmFeYDwcmlVmg-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-32959198653so138735045ab.3
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 11:32:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682620326; x=1685212326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p6LZTxbqMNSlOAcpVGltFAX5rwaxLlFX1/1eyhmddg0=;
        b=Dl9OE+U7UIBP4ipLHa/tc2Rc+yADGl2fhhJAW74sc0UcmehmfT/mz8zbj+BG+Qpj1U
         4aNAfOpQADy2ck9CbcGb8q13sk696APewwURqAISNbR3jzcufjl2Xh9jiD9SM4NJfvcJ
         noclmSzpMaHGWtJn8cCKFDEScdWX+BaGunJQCts42SShQrq2FH7tWWm/GZI/eBZau2Xk
         I9coR2IjpeM1yfQej4j9BQe4zxPucBnPYX4zhgduOZc35EGvwbdKqLu3tD3wwZSZz7aK
         mi+Qv5LKVfGbGL/+8GwT82CtrWj+RKQCZNkcetnRvP522eOXiYKPVAk7Vv1lUOU5CmiU
         FtqQ==
X-Gm-Message-State: AC+VfDwMuCAY6dbkVH9oO3sh4zE+g8z1mfI66IjeA+NpKCwq/YPYaGYp
        iSVS/ik0DTT7zKv1LB94Z1TIvqpgnI57f8J9CAlMe9+ivd3HdZlkgXJYDfU7ThkAf9pwJAT4W2x
        Phi9nB3GGH51tw6yu1/q0
X-Received: by 2002:a92:d3c3:0:b0:329:43f0:1570 with SMTP id c3-20020a92d3c3000000b0032943f01570mr1980502ilh.23.1682620326429;
        Thu, 27 Apr 2023 11:32:06 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5ZjtNj+NU5UefOIsxARLgAXnZyiFoLNkWt/mynkGIjXDEBZIDUWBFQOZkzcIK9k2Lxdx+w+g==
X-Received: by 2002:a92:d3c3:0:b0:329:43f0:1570 with SMTP id c3-20020a92d3c3000000b0032943f01570mr1980473ilh.23.1682620326188;
        Thu, 27 Apr 2023 11:32:06 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a20-20020a027354000000b004090c67f155sm5693305jae.91.2023.04.27.11.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 11:32:05 -0700 (PDT)
Date:   Thu, 27 Apr 2023 12:32:03 -0600
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
Subject: Re: [PATCH v4 2/9] vfio-iommufd: Create iommufd_access for noiommu
 devices
Message-ID: <20230427123203.22307c4f.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB752972AC1A6030CB442ACF3FC36A9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
        <20230426145419.450922-3-yi.l.liu@intel.com>
        <BN9PR11MB52768AF474FAB2AF36AC00508C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <DS0PR11MB752972AC1A6030CB442ACF3FC36A9@DS0PR11MB7529.namprd11.prod.outlook.com>
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

On Thu, 27 Apr 2023 06:59:17 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Tian, Kevin <kevin.tian@intel.com>
> > Sent: Thursday, April 27, 2023 2:39 PM
> >   
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Wednesday, April 26, 2023 10:54 PM
> > > @@ -121,7 +128,8 @@ static void vfio_emulated_unmap(void *data,
> > > unsigned long iova,
> > >  {
> > >  	struct vfio_device *vdev = data;
> > >
> > > -	if (vdev->ops->dma_unmap)
> > > +	/* noiommu devices cannot do map/unmap */
> > > +	if (vdev->noiommu && vdev->ops->dma_unmap)
> > >  		vdev->ops->dma_unmap(vdev, iova, length);  
> > 
> > Is it necessary? All mdev devices implementing @dma_unmap won't
> > set noiommu flag.  
> 
> Hmmm. Yes, and all the devices set noiommu is not implementing @dma_unmap
> as far as I see. Maybe this noiommu check can be removed.

Not to mention that the polarity of the noiommu test is backwards here!
This also seems to be the only performance path where noiommu is tested
and therefore I believe the only actual justification of the previous
patch.
 
> > Instead in the future if we allow noiommu userspace to pin pages
> > we'd need similar logic too.  
> 
> I'm not quite sure about it so far. For mdev devices, the device driver
> may use vfio_pin_pages/vfio_dma_rw () to pin page. Hence such drivers
> need to listen to dma_unmap() event. But for noiommu users, does the
> device driver also participate in the page pin? At least for vfio-pci driver,
> it does not, or maybe it will in the future when enabling noiommu
> userspace to pin pages. It looks to me such userspace should order
> the DMA before calling ioctl to unpin page instead of letting device
> driver listen to unmap.

Whoa, noiommu is inherently unsafe an only meant to expose the vfio
device interface for userspace drivers that are going to do unsafe
things regardless.  Enabling noiommu to work with mdev, pin pages, or
anything else should not be on our agenda.  Userspaces relying on niommu
get the minimum viable interface and must impose a minuscule
incremental maintenance burden.  The only reason we're spending so much
effort on it here is to make iommufd noiommu support equivalent to
group/container noiommu support.  We should stop at that.  Thanks,

Alex

