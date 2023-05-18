Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73CC47088C0
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 21:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjERTyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 15:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjERTym (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 15:54:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63E9E75
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 12:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684439633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SOnz7FLeWFp9Eq20E/7cfvpQ/psIaNzbdtCx4JAp4z8=;
        b=Hit6H5wUQZBbS397wGKZ/yY5k/QPR0Omj3Cx95I7cM/k7FxuGxdrc6WSe4uCrMowDQlMJo
        LTipokZ4TeBEaHxgBHMf/vxI+xneZhggi5KgSD7qWrOF1L7dom32UjSrVFpdQGX5CPzjGt
        3tlEqY3A+fnxdH48zOAKka3fgCSQILM=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-maWF6sj4OLu-XQH9w9Fueg-1; Thu, 18 May 2023 15:53:52 -0400
X-MC-Unique: maWF6sj4OLu-XQH9w9Fueg-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3384bfb39b4so28655325ab.0
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 12:53:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684439632; x=1687031632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SOnz7FLeWFp9Eq20E/7cfvpQ/psIaNzbdtCx4JAp4z8=;
        b=RI+Sqj+9szGz3USyrs0kuMpIdSQ0R8SY7pgzoL5ecQ3OT+tmF3EZ63cAIeZXhNRu34
         2hsj7sePNz0WQXppCHJN7GGYCLQaynekwXMYbTe7+nQfpf8oCQgJYxNomtzjvLUCOVh3
         zia8/X3f5WZzTWD8UEwFmff7ivBLJPneY/BxEcx4Kh6jpwBAJsgtcOAZ+Dq+qXW3k//7
         COMKzLTm35/iTZnin2UN71U1I6BsTaYdUd8YK5jXJD3JmX9pggc0C4Myn9lb781KvwKy
         2K0dDI4VZGLvQ0RcmK3lRtaRBmYUSI8OScyjTHBi92zCNVP6H11JOxSZF3ygeybM/umo
         7XKA==
X-Gm-Message-State: AC+VfDxbNdLum8qgZWZs4qB83YO0RqIIKXZrvYEQWHp5RysEQkEvTOin
        5xJf7/75d8MZ9GmFxOVxFLb8TKE6g+kKymXgXrJFwMi8r/tZVkjFnBxMUUXQiiX/U8CnWDF09AI
        bz+qYniUpkDi7
X-Received: by 2002:a92:c952:0:b0:337:83fc:43c8 with SMTP id i18-20020a92c952000000b0033783fc43c8mr5511177ilq.10.1684439631917;
        Thu, 18 May 2023 12:53:51 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6Mt3onZ7ykj03VNoF8B/a0LVLffzU72IX2ayiTe6tSR9N5/g8PndWcoR1I1HxYqhwrE8Wk5Q==
X-Received: by 2002:a92:c952:0:b0:337:83fc:43c8 with SMTP id i18-20020a92c952000000b0033783fc43c8mr5511169ilq.10.1684439631723;
        Thu, 18 May 2023 12:53:51 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id cp12-20020a056638480c00b004165f64968csm676038jab.103.2023.05.18.12.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 12:53:51 -0700 (PDT)
Date:   Thu, 18 May 2023 13:53:49 -0600
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
Subject: Re: [PATCH v5 09/10] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Message-ID: <20230518135349.5dcf63c1.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB752951FE3826428345A6CF6DC37F9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230513132136.15021-1-yi.l.liu@intel.com>
        <20230513132136.15021-10-yi.l.liu@intel.com>
        <20230517160131.254be76b.alex.williamson@redhat.com>
        <DS0PR11MB75291457BBD647819B855DA0C37F9@DS0PR11MB7529.namprd11.prod.outlook.com>
        <DS0PR11MB752951FE3826428345A6CF6DC37F9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 May 2023 13:31:47 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Thursday, May 18, 2023 9:22 PM
> >   
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Thursday, May 18, 2023 6:02 AM
> > >
> > > On Sat, 13 May 2023 06:21:35 -0700
> > > Yi Liu <yi.l.liu@intel.com> wrote:  
> 
> > >
> > > static int vfio_hot_reset_devid(struct vfio_device *vdev,
> > >                                 struct iommufd_ctx *iommufd_ctx)
> > > {
> > >         struct iommu_group *group;
> > >         int devid;
> > >
> > >         if (!vdev)
> > >                 return VFIO_PCI_DEVID_NOT_OWNED;
> > >
> > >         if (vfio_iommufd_physical_ictx(vdev) == iommufd_ctx)
> > >                 return vfio_iommufd_physical_devid(vdev);  
> 
> Do we need to check the return of this helper? It returns -EINVAL
> when iommufd_access and iommufd_device are both null. Though
> not possible in this path. Is a WARN_ON needed or not?

I also came to the conclusion that it wasn't possible while reviewing
the code.  I wouldn't got to extreme measures to introduce paranoia
checks for impossible conditions.  Thanks,

Alex

> > >
> > >         group = iommu_group_get(vdev->dev);
> > >         if (!group)
> > >                 return VFIO_PCI_DEVID_NOT_OWNED;
> > >
> > >         if (iommufd_ctx_has_group(iommufd_ctx, group))
> > >                 devid = VFIO_PCI_DEVID_OWNED;
> > >
> > >         iommu_group_put(group);
> > >
> > >         return devid;
> > > }  

