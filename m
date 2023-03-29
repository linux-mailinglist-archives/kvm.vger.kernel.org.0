Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC2EF6CED7F
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 17:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbjC2PvH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 11:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbjC2Puq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 11:50:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B994690
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 08:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680104997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hP1XBMM0doEA+LEJ78VJjS+VLo2jAysv8Y016r4ZnnY=;
        b=Mo2ZUsqzxOguOdxH4cc6vUOGJ8ilNc0++tWtoQiLQBzd83GxlNBr74pHLhaRPr5wfHkjWr
        GYb77WYCDVYDpHtFYO85j2sRezf3HfGW7+UtCBwjHoJEY1prY0dIk4Z3xwT+km0NyOwXIU
        qAloTroJpLAHmM8QIX3RpxkJfR3DZQQ=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-48-8Z1VNOV7NmujJQr4ttcQRQ-1; Wed, 29 Mar 2023 11:49:48 -0400
X-MC-Unique: 8Z1VNOV7NmujJQr4ttcQRQ-1
Received: by mail-io1-f69.google.com with SMTP id s3-20020a056602240300b007589413aea0so9674796ioa.5
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 08:49:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680104987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hP1XBMM0doEA+LEJ78VJjS+VLo2jAysv8Y016r4ZnnY=;
        b=tZ3LPPjUMFbV2JLiCJMkteB7c6wOyhD5NpH1g+uSqlWkvHYi1/gPSrk7EjvbyjqyyQ
         sYtaKWJEb07CsGAJ/eADt4vGRX68kVPGyjouaBVgV/u9/EYT72rX9qOnKiU5jNwumbjt
         RkODzgnu1jTs3BYS0wc07dr8XaPNGe29/N3Bcyq17EJDNLnrvrjKZPvIFYKelq0QvO0G
         bZthVvNEvFuAeB1DV/mJBpZwWgdoMr3KlXYTaa3w7YBf1OGBnj7YEO1zAUYOTN5DDqul
         aYBJzAj++8qTjLo8rsr9nInnmEWiy2FwL89ENlzt8L07ozS8zXbe9TV/HVdh/YWyDiyH
         pYHw==
X-Gm-Message-State: AAQBX9crBL8RMZTUaFRVkxOxFnA9Rb1RL2/+C5bxUlLM5zI5mAzJd68a
        XVDWIPAp2DV7igDnj4vjlBLbgqMZbutbGXIHwoHFoKs+R2TVQJz++xDFQ2R5KL5XO3CtzNZKABC
        uGUGQSjlLCeZA
X-Received: by 2002:a92:c743:0:b0:326:2902:e7d9 with SMTP id y3-20020a92c743000000b003262902e7d9mr2178933ilp.7.1680104987645;
        Wed, 29 Mar 2023 08:49:47 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZSyu7j44X/rupYZlbiuoYiWibGVg929WRZpz3ftBxDYQY1mBTe8lVgtKaDoJrTKTZsWHhhjA==
X-Received: by 2002:a92:c743:0:b0:326:2902:e7d9 with SMTP id y3-20020a92c743000000b003262902e7d9mr2178916ilp.7.1680104987361;
        Wed, 29 Mar 2023 08:49:47 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id n4-20020a056638110400b00400d715c57dsm10708357jal.29.2023.03.29.08.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 08:49:46 -0700 (PDT)
Date:   Wed, 29 Mar 2023 09:49:44 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: Re: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Message-ID: <20230329094944.50abde4e.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB52762E789B9C1D8021F54ECC8C899@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
        <20230327093458.44939-11-yi.l.liu@intel.com>
        <20230327132619.5ab15440.alex.williamson@redhat.com>
        <DS0PR11MB7529E969C27995D535A24EC0C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <BL1PR11MB52717FB9E6D5C10BF4B7DA0A8C889@BL1PR11MB5271.namprd11.prod.outlook.com>
        <20230328082536.5400da67.alex.williamson@redhat.com>
        <DS0PR11MB7529B6782565BE8489D922F9C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230328084616.3361a293.alex.williamson@redhat.com>
        <DS0PR11MB75290B84D334FC726A8BBA95C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230328091801.13de042a.alex.williamson@redhat.com>
        <DS0PR11MB752903CE3D5906FE21146364C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230328100027.3b843b91.alex.williamson@redhat.com>
        <DS0PR11MB7529C12E086DAB619FF9AFF0C3899@DS0PR11MB7529.namprd11.prod.outlook.com>
        <BN9PR11MB52762E789B9C1D8021F54ECC8C899@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 29 Mar 2023 09:41:26 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Wednesday, March 29, 2023 11:14 AM
> >   
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Wednesday, March 29, 2023 12:00 AM
> > >
> > >
> > > Personally I don't like the suggestion to fail with -EPERM if the user
> > > doesn't own all the affected devices.  This isn't a "probe if I can do
> > > a reset" ioctl, it's a "provide information about the devices affected
> > > by a reset to know how to call the hot-reset ioctl".  We're returning
> > > the bdf to the cdev version of this ioctl for exactly this debugging
> > > purpose when the devices are not owned, that becomes useless if we give
> > > up an return -EPERM if ownership doesn't align.  
> > 
> > Jason's suggestion makes sense for returning the case of returning dev_id
> > as dev_id is local to iommufd. If there are devices in the same dev_set are
> > opened by multiple users, multiple iommufd would be used. Then the
> > dev_id would have overlap. e.g. a dev_set has three devices. Device A and
> > B are opened by the current user as cdev, dev_id #1 and #2 are generated.
> > While device C opened by another user as cdev, dev_id #n is generated for
> > it. If dev_id #n happens to be #1, then user gets two info entries that have
> > the same dev_id.
> >   
> 
> In Alex's proposal you'll set a invalid dev_id for device C so the user can
> still get the info for diagnostic purpose instead of seeing an -EPERM error.

Yes, we shouldn't be reporting dev_ids outside of the user's iommufd
context.

> btw I found an open about fd pass scheme which may affect the choice here.
> 
> In concept even with cdev we still expect the userspace to maintain the
> group knowledge so it won't inadvertently attempt to assign devices in
> the same group to different IOAS's. It also needs such knowledge when
> constructing guest topology.
> 
> with fd passed in Qemu has no way to associate the fd to a group.

Hmm, QEMU tries to get the group for the device address space in the
guest, so finding an existing group with a different address space
indeed allows QEMU to know of this conflict since the group is the
fundamental unit IOMMU context in the legacy vfio model.

> We could extend bind_iommufd to return the group id or introduce a
> new ioctl to query it per dev_id.

That would be ironic to go to all this trouble to remove groups from
the API only to have them show up here.  But with a cdev interface,
don't we break that model of conflating isolation and address-ability?

For example, devices within a group cannot be bound to separate
iommufds due to lack of isolation, which is handled via DMA ownership,
but barring DMA aliasing issues, due to conventional PCI buses or
quirks, cdev could allow devices within the same group to be managed by
separate IOAS's.  So the group information really isn't enough for
userspace to infer address space restrictions with cdev anyway.

Therefore aren't we expecting this to be denied at attach_ioas() and
QEMU shouldn't be making these sorts of assumptions for cdev anyway?
Thanks,

Alex

