Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE9972ECA3
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 22:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240522AbjFMUMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 16:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240504AbjFMUMH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 16:12:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F86268E
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 13:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686687056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sIOI1MZa8Qvt3GA5tgX3/QbGmFAGID2zKyAE50cAXvQ=;
        b=DE1DhmNbKZlE0eDtQ0H/ZUP+aWmgkGqzfCP9/fQa8bTd12g/ZeU/2i7+6ng9vbkuaj+Ldl
        9oJzqkQAiGHX0lTmFQQ7zC8gMSqh2f1wpz7llhtmeDDZY/xpq7l5LzmLsic5ocCAcoZ9zk
        jp4VHQ0R8AAI8Ssqw2h9aVuChSraT58=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-sqQTWsDJMFGtdD9VDPu_Vw-1; Tue, 13 Jun 2023 16:10:53 -0400
X-MC-Unique: sqQTWsDJMFGtdD9VDPu_Vw-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-77b257b9909so172486739f.0
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 13:10:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686687052; x=1689279052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sIOI1MZa8Qvt3GA5tgX3/QbGmFAGID2zKyAE50cAXvQ=;
        b=UFrKg4vAfygzKWlQuuDst2L4/6QCNpMd3+6Uja1c6xQuWs/YGOpWZqXz1dZBFYcxBD
         nCN5MZaBDUvhiA1HjlVcvWdAXEN3BxnBsM+jE/eMw2Kp21HNfUZsL5HUHLJS/bgjEzFw
         um9NnuL9qhnNiqtzE7h4LdjRMAS+N/pMh2ocexmZ8FZWwMvKbeCXzWDTsS/76XG3Ze7p
         QsDylVjFs9vw0+B/EL/gjdplGVKRRIr9rrddmoBwr6SB/YPFp2SgwWAt+hdgkVCmRFIl
         eMwgKLi5v65ibvhhpup0WPBxrnrVw6tTybmo+Q1FEbqdLz2T+i8RpvgMf/XGq+6vteOF
         QXxw==
X-Gm-Message-State: AC+VfDwM8X2tTQufSfRJ5epwIQFMZjJG6EEr2rLaCndlt8uZSoR0Riz6
        2n/ogDPMTWT6BsSbtz2JUCecah+nGo+eTVhTLmH1rmtqPsXDfTgoPSBr4rNZ20el1y3S7vayUQR
        NhBYSfTWrqip7
X-Received: by 2002:a5d:9d4e:0:b0:753:ca30:6bb0 with SMTP id k14-20020a5d9d4e000000b00753ca306bb0mr12540441iok.4.1686687052512;
        Tue, 13 Jun 2023 13:10:52 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4DNZHxVZbAxwbazA89i6boaoAMcqTbpYJSYBiB4fBVRBnBcDqPvcZYm0qsZ2hQJsBCtxR5uA==
X-Received: by 2002:a5d:9d4e:0:b0:753:ca30:6bb0 with SMTP id k14-20020a5d9d4e000000b00753ca306bb0mr12540429iok.4.1686687052264;
        Tue, 13 Jun 2023 13:10:52 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f13-20020a6bdd0d000000b0076c569c7a48sm3955848ioc.39.2023.06.13.13.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 13:10:51 -0700 (PDT)
Date:   Tue, 13 Jun 2023 14:10:50 -0600
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
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: Re: [PATCH v12 21/24] vfio: Determine noiommu device in
 __vfio_register_dev()
Message-ID: <20230613141050.29e7a22b.alex.williamson@redhat.com>
In-Reply-To: <ZIiozfqet185iLIs@nvidia.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-22-yi.l.liu@intel.com>
        <20230612164228.65b500e0.alex.williamson@redhat.com>
        <DS0PR11MB7529AE3701E154BF4C092E57C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230613081913.279dea9e.alex.williamson@redhat.com>
        <DS0PR11MB7529EB2903151B3399F636F5C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230613084828.7af51055.alex.williamson@redhat.com>
        <DS0PR11MB7529E84BCB100DE620FD2468C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230613091301.56986440.alex.williamson@redhat.com>
        <20230613111511.425bdeae.alex.williamson@redhat.com>
        <ZIiozfqet185iLIs@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Jun 2023 14:35:09 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Jun 13, 2023 at 11:15:11AM -0600, Alex Williamson wrote:
> > [Sorry for breaking threading, replying to my own message id with reply
> >  content from Yi since the Cc list got broken]  
> 
> Yikes it is really busted, I think I fixed it?
> 
> > If we renamed your function above to vfio_device_has_iommu_group(),
> > couldn't we just wrap device_add like below instead to not have cdev
> > setup for a noiommu device, generate an error for a physical device w/o
> > IOMMU backing, and otherwise setup the cdev device?
> > 
> > static inline int vfio_device_add(struct vfio_device *device, enum vfio_group_type type)
> > {
> > #if IS_ENABLED(CONFIG_VFIO_GROUP)
> > 	if (device->group->type == VFIO_NO_IOMMU)
> > 		return device_add(&device->device);  
> 
> vfio_device_is_noiommu() embeds the IS_ENABLED

But patch 23/ makes the definition of struct vfio_group conditional on
CONFIG_VFIO_GROUP, so while CONFIG_VFIO_NOIOMMU depends on
CONFIG_VFIO_GROUP and the result could be determined, I think the
compiler is still unhappy about the undefined reference.  We'd need a
!CONFIG_VFIO_GROUP stub for the function.

> > #else
> > 	if (type == VFIO_IOMMU && !vfio_device_has_iommu_group(device))
> > 		return -EINVAL;
> > #endif  
> 
> The require test is this from the group code:
> 
>  	if (!device_iommu_capable(dev, IOMMU_CAP_CACHE_COHERENCY)) {
> 
> We could lift it out of the group code and call it from vfio_main.c like:
> 
> if (type == VFIO_IOMMU && !vfio_device_is_noiommu(vdev) && !device_iommu_capable(dev,
>      IOMMU_CAP_CACHE_COHERENCY))
>    FAIL

Ack.  Thanks,

Alex

