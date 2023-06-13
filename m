Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F7072E9D5
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 19:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239102AbjFMRb7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 13:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbjFMRbv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 13:31:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5208BC9
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 10:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686677432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5rNyoH/Y9EWvlZq1BBIGJddx9uEaRVCPkhuzBz1faSI=;
        b=BOwi7AmtVGZgTJCqhNBYo9t74UhSjDn8kxgOEy8uoWEKtDYhCafk9ybbKctlB2Zcy2TJ1S
        Gp4E3ErQ2tRYVYYUvFG5vpZfzI2XL2pZ+WKpjEWkrVGPqbVtLwaJ39RUc3kPYP/Wxwizl6
        BLAtzM6Gs6b33ZkIC5DyPxVsuTTj7UI=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-GfkV-xnHNPuIxDO3Bi0tiw-1; Tue, 13 Jun 2023 13:30:30 -0400
X-MC-Unique: GfkV-xnHNPuIxDO3Bi0tiw-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7775a282e25so648812139f.0
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 10:30:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686677428; x=1689269428;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5rNyoH/Y9EWvlZq1BBIGJddx9uEaRVCPkhuzBz1faSI=;
        b=C2jIqBA5or1/drPazEp/JLgzEGhbAVgD3WOaX0oY2GNTqs681krYzWLRPa7VBYHA9I
         U7yZQj/rpdx24P9yc1PS/upSJ7hb+NhBvw365e1uOygkgKSZYBrYQIM5X4xsfURaJJH5
         13XqHpqVv9xUUT5DnZWkZVQ91FqzwOQ3qe2O+ZtIs8H/iYNgA+NHUWcTVWQZHyXqchHr
         dd5YZ40X03xVf5WC7mAq5FsJpkG56q0iavc1udKCdCkD3F60dMjpQ3WAoEKflW+EvT2l
         RkzxB/r9NDC5qleZmb2RXp83xufTKjSlzeafvDkTkeT5zkF1OUvArXW/EjQy+04Ts8Fr
         wwTA==
X-Gm-Message-State: AC+VfDwmG4aIqc4ktOS6XGPthYA625RyT3IZgniBaFtmeymiLeHSNsjg
        qOoOIDLV0xG6fo5MyxaAzWQivndo1l+vRtYqgVAhpCGC7IfxE4sR8S0nq8QnrkEfghb32rhUsHC
        xVKLIP9nTIYhI
X-Received: by 2002:a6b:904:0:b0:77a:de11:9725 with SMTP id t4-20020a6b0904000000b0077ade119725mr9574448ioi.15.1686677427778;
        Tue, 13 Jun 2023 10:30:27 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5BkMZ9qiNe1FeXH/PJLIwHPPeNkq0P/IdFrUDbi6Jh6yHJTHPsdlC06uC/X4+f1OrZwQUOEQ==
X-Received: by 2002:a6b:904:0:b0:77a:de11:9725 with SMTP id t4-20020a6b0904000000b0077ade119725mr9574417ioi.15.1686677427520;
        Tue, 13 Jun 2023 10:30:27 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id y26-20020a056602201a00b007791e286fdbsm4013655iod.21.2023.06.13.10.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 10:30:26 -0700 (PDT)
Date:   Tue, 13 Jun 2023 11:30:25 -0600
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
Subject: Re: [PATCH v12 24/24] docs: vfio: Add vfio device cdev description
Message-ID: <20230613113025.377411ee.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB7529C440A84B75234E49C77CC355A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-25-yi.l.liu@intel.com>
        <20230612170628.661ab2a6.alex.williamson@redhat.com>
        <DS0PR11MB7529B0A71849EA06DA953BBCC355A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230613082427.453748f5.alex.williamson@redhat.com>
        <DS0PR11MB75297AC071F2EF4F49D85999C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230613090403.1eecd1a3.alex.williamson@redhat.com>
        <DS0PR11MB7529C440A84B75234E49C77CC355A@DS0PR11MB7529.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Jun 2023 15:11:06 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Tuesday, June 13, 2023 11:04 PM
> >   
> > > > >  
> > > > > >
> > > > > > Unless I missed it, we've not described that vfio device cdev access is
> > > > > > still bound by IOMMU group semantics, ie. there can be one DMA owner
> > > > > > for the group.  That's a pretty common failure point for multi-function
> > > > > > consumer device use cases, so the why, where, and how it fails should
> > > > > > be well covered.  
> > > > >
> > > > > Yes. this needs to be documented. How about below words:
> > > > >
> > > > > vfio device cdev access is still bound by IOMMU group semantics, ie. there
> > > > > can be only one DMA owner for the group.  Devices belonging to the same
> > > > > group can not be bound to multiple iommufd_ctx.  
> > > >
> > > > ... or shared between native kernel and vfio drivers.  
> > >
> > > I suppose you mean the devices in one group are bound to different
> > > drivers. right?  
> > 
> > Essentially, but we need to be careful that we're developing multiple
> > vfio drivers for a given bus now, which is why I try to distinguish
> > between the two sets of drivers.  Thanks,  
> 
> Indeed. There are a set of vfio drivers. Even pci-stub can be considered
> in this set? Perhaps, it is more precise to say : or shared between drivers
> that set the struct pci_driver::driver_managed_dma flag and the drivers
> that do not.

Yeah, I wish there was a less technical way to describe this.  This is
essentially why we have the VIABLE flag on VFIO_GROUP_GET_STATUS in the
legacy interface, which is what QEMU uses to generate the warning
specific to binding all devices to vfio bus drivers.

Technically there are some exceptions, like pci-stub or "no driver" that
can be used to prevent direct access to devices within the group, but
except for that narrow use case a vfio driver is generally recommended,
and is currently required for certain things like the dev_set test
during hot-reset.

If we want to be accurate without being too pedantic, perhaps it would
be something like "vfio bus driver or other driver supporting the
driver_manged_dma flag".  Note the flag is supported for several
drivers other than pci_driver.  Thanks,

Alex

