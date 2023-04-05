Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4F26D8216
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 17:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238770AbjDEPhi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 11:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237845AbjDEPhh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 11:37:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB39AE64
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 08:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680709010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TuiXIjl7StR1lWcqJYYE1fB/Z6K6yMMeGx6F0a8wvVw=;
        b=S7tSwdTqvz1YuAnnO1XSo+mTdpqXxrPZMjfU8iAWVEXIbN215w6CDlLdfEIzN9uh4tZF1U
        ZaoFX+04Q2ST9hpEm+c4hwZPl3Q7suXiJwz+eQXLbP5fYHWLaAW3UE53ULOw1DqbpT+S+h
        X7ko45yJqijsSSZSkywGXV6itrI+upM=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-2VSKgJBSPZ6LFKFebsKUpQ-1; Wed, 05 Apr 2023 11:36:49 -0400
X-MC-Unique: 2VSKgJBSPZ6LFKFebsKUpQ-1
Received: by mail-io1-f69.google.com with SMTP id b12-20020a6bb20c000000b007585c93862aso22447949iof.4
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 08:36:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680709008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TuiXIjl7StR1lWcqJYYE1fB/Z6K6yMMeGx6F0a8wvVw=;
        b=Et7k5lrHARkT5xPYSt1KmRW8qHulRig/HF37W5V5Si/Kupf7ki+nCJgbIOqs2VDp4q
         OcwxWhDJWUgFKnYQnHuBemhnIkqkbrrkxc89wDyIM0RsVgRD5umpwPD4iXnG6uJrrYPq
         aVDqd+R7C+qDNdfIngP5p4rAQzjm5aD2h6733ANjG7p0o9A7o/DhgMtwvUMUnGuTSSrz
         hjWRI/gg6NLqdewvVrv9Bbv2Yk35dwFQc5vn9DnplyPU3sfqgdFUKnXbApmYw+wuHKgq
         VQPfTEgbw6SV60BstUjhhdNwLNvOxeVSjIAb/1twLHqTuCTVLCcdppDFZUtefS4EL04w
         adUA==
X-Gm-Message-State: AAQBX9dd9wIdNtS10mj4nOe1jYY2BIV8jb8IUBtsVF2jToScBYK5E99F
        lFbCFGw2/XQ0EbkuvyZ5JztNef2Vn65kldA+uadnGaWHrkh2+Md6AfADm33pRlPwv7tt7TNY4Ay
        4R/NxxHFCCPxA
X-Received: by 2002:a5e:da44:0:b0:760:1fb6:c7d2 with SMTP id o4-20020a5eda44000000b007601fb6c7d2mr3357768iop.5.1680709008441;
        Wed, 05 Apr 2023 08:36:48 -0700 (PDT)
X-Google-Smtp-Source: AKy350Yiu+6jYuVXySDhz9l7TaJE2CbZAprEqCSA9voKn6Sxg2Pef1TWywH9iD954/Pk6M8+1tZHJQ==
X-Received: by 2002:a5e:da44:0:b0:760:1fb6:c7d2 with SMTP id o4-20020a5eda44000000b007601fb6c7d2mr3357742iop.5.1680709008129;
        Wed, 05 Apr 2023 08:36:48 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e11-20020a02210b000000b004050d92f6d4sm4046543jaa.50.2023.04.05.08.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 08:36:47 -0700 (PDT)
Date:   Wed, 5 Apr 2023 09:36:46 -0600
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
Subject: Re: [PATCH v3 05/12] vfio/pci: Allow passing zero-length fd array
 in VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <20230405093646.337f0992.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB7529730CD29F2BD13F1DD9AEC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230401144429.88673-6-yi.l.liu@intel.com>
        <20230404141838.6a4efdd4.alex.williamson@redhat.com>
        <DS0PR11MB752919BC81CCCAB1A13998CAC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
        <DS0PR11MB7529730CD29F2BD13F1DD9AEC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
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

On Wed, 5 Apr 2023 08:01:49 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Wednesday, April 5, 2023 3:55 PM  
>  
> > >
> > > Therefore, I think as written, the singleton dev_set hot-reset is
> > > enabled for iommufd and (unintentionally?) for the group path, while
> > > also negating a requirement for a group fd or that a provided group fd
> > > actually matches the device in this latter case.  The null-array
> > > approach is not however extended to groups for more general use.
> > > Additionally, limiting no-iommu hot-reset to singleton dev_sets
> > > provides only a marginal functional difference vs VFIO_DEVICE_RESET.  
> > 
> > I think the singletion dev_set hot-reset is for iommufd (or more accurately
> > for the noiommu case in cdev path).  
> 
> but actually, singleton dev_set hot-reset can work for group path as well.
> Based on this, I'm also wondering do we really want to have singleton dev_set
> hot-reset only for cdev noiommu case? or we allow it generally or just
> don't support it as it is equivalent with VFIO_DEVICE_RESET?

I think you're taking the potential that VFIO_DEVICE_RESET and
hot-reset could do the same thing too far.  The former is more likely
to do an FLR, or even a PM reset.  QEMU even tries to guess what reset
VFIO_DEVICE_RESET might use in order to choose to do a hot-reset if it
seems like the device might only support a PM reset otherwise.

Changing the reset method of a device requires privilege, which is
maybe something we'd compromise on for no-iommu, but the general
expectation is that VFIO_DEVICE_RESET provides a device level scope and
hot-reset provides a... hot-reset, and sometimes those are the same
thing, but that doesn't mean we can lean on the former.

> If we don't support singletion dev_set hot-reset, noiommu devices in cdev
> path shall fail the hot-reset if empty-fd array is provided. But we may just
> document that empty-fd array does not work for noiommu. User should
> use the device fd array.

I don't see any replies to my comment on 08/12 where I again question
why we need an empty array option.  It's causing all sorts of headaches
and I don't see the justification for it beyond some hand waving that
it reduces complexity for the user.  This singleton dev-set notion
seems equally unjustified.  Do we just need to deal with hot-reset
being unsupported for no-iommu devices with iommufd?  Thanks,

Alex

