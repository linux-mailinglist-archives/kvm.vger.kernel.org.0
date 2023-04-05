Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0AC86D8160
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 17:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238860AbjDEPQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 11:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238826AbjDEPQL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 11:16:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3151B55B2
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 08:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680707597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HHZ/jIzCBVCjw8Sv1KUUo+r8mPEiPRUgi3mJO20sEiE=;
        b=Edw05mmQvWEuKqnemiXByxNlK8sK1lXcsSFWLdjD5Wbg/kARqjOHHl+RaKlgCkCABhDMYN
        71QJ8nmLR3jPekwub7U2u8+jqV9z8RPNDESjOwDHaMmpurTNSIZahs6+Je4qGgxDRyU88d
        5XP9Zve8mAFAUA/HiPFjpdAmEKAkKt4=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-424-NTbkBrQGNC6azn2ja-tHWQ-1; Wed, 05 Apr 2023 11:13:16 -0400
X-MC-Unique: NTbkBrQGNC6azn2ja-tHWQ-1
Received: by mail-il1-f199.google.com with SMTP id c6-20020a056e020bc600b00325da077351so23453905ilu.11
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 08:13:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680707595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HHZ/jIzCBVCjw8Sv1KUUo+r8mPEiPRUgi3mJO20sEiE=;
        b=LmtyrKo75y+z7ZeR1BWONKt+ippjBFfVWJfiwWP0aEtcE/Gn8q0YGH+EJbm2Ctz0dl
         QXCQ0eb519De+YfQXWGwu+KZN+rWlhtaj3V30XBdVPd6FEwuQOCrJfZ9aoPhlJadv7Hd
         Sktlmc20XmDejWP1+CF1gUV+69gYpXny23scrrnOOZjvl4m/3G269gxqz5k5PxHV4jeA
         7KhIIvp6X6NiO87oJXosz5wOgLih95qhMXJXLHIhUE2SQZQYOdz6GOPy3uqfYRgKjLnB
         yE+cSsWjCf31ljQycu/+j2IEwKPO97pucfKN1FW6AkaEjbmEmcDpizMCB8TWZ3kLBxYN
         dmXw==
X-Gm-Message-State: AAQBX9eJoRCiemqSZ1jFNvp4+egLRqtnKWStZdqrgjzVoqNDQ+AKOMIq
        FHR8cZYzc+XOq2AT2QSphvR5qJpYeiTSS92iowW7lmRBH6+Eo0mzUkGr6ocSXvGz3QG0d3EOItI
        hzxJu56zjrMgA
X-Received: by 2002:a92:dd04:0:b0:326:1fb2:40c4 with SMTP id n4-20020a92dd04000000b003261fb240c4mr5004291ilm.23.1680707595590;
        Wed, 05 Apr 2023 08:13:15 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZP1bpPm4WhRQrqOqZKR50zNpeviNu90Bjdp+q5pCVln3oaoFR9YOzr1ahR+dQPp+xRvGH4tQ==
X-Received: by 2002:a92:dd04:0:b0:326:1fb2:40c4 with SMTP id n4-20020a92dd04000000b003261fb240c4mr5004271ilm.23.1680707595338;
        Wed, 05 Apr 2023 08:13:15 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q10-20020a027b0a000000b00406496ef3dcsm4195746jac.49.2023.04.05.08.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 08:13:14 -0700 (PDT)
Date:   Wed, 5 Apr 2023 09:13:12 -0600
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: Re: [PATCH v3 11/12] iommufd: Define IOMMUFD_INVALID_ID in uapi
Message-ID: <20230405091312.6e9dbae0.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB752985764A642C7B12436C53C3909@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230401144429.88673-12-yi.l.liu@intel.com>
        <20230404150034.312fbcac.alex.williamson@redhat.com>
        <DS0PR11MB752985764A642C7B12436C53C3909@DS0PR11MB7529.namprd11.prod.outlook.com>
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

On Wed, 5 Apr 2023 09:31:39 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Wednesday, April 5, 2023 5:01 AM
> > 
> > On Sat,  1 Apr 2023 07:44:28 -0700
> > Yi Liu <yi.l.liu@intel.com> wrote:
> >   
> > > as there are IOMMUFD users that want to know check if an ID generated
> > > by IOMMUFD is valid or not. e.g. vfio-pci optionaly returns invalid
> > > dev_id to user in the VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl. User
> > > needs to check if the ID is valid or not.
> > >
> > > IOMMUFD_INVALID_ID is defined as 0 since the IDs generated by IOMMUFD
> > > starts from 0.
> > >
> > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > ---
> > >  include/uapi/linux/iommufd.h | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
> > > index 98ebba80cfa1..aeae73a93833 100644
> > > --- a/include/uapi/linux/iommufd.h
> > > +++ b/include/uapi/linux/iommufd.h
> > > @@ -9,6 +9,9 @@
> > >
> > >  #define IOMMUFD_TYPE (';')
> > >
> > > +/* IDs allocated by IOMMUFD starts from 0 */
> > > +#define IOMMUFD_INVALID_ID 0
> > > +
> > >  /**
> > >   * DOC: General ioctl format
> > >   *  
> > 
> > If allocation "starts from 0" then 0 is a valid id, no?  Does allocation
> > start from 1, ie. skip 0?  Thanks,  
> 
> yes, it starts from 1, that's why we can use 0 as invalid id.

So the comment is wrong, correct?

