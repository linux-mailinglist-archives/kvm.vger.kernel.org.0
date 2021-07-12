Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57EC83C62D0
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 20:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235629AbhGLSoo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 14:44:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20007 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230199AbhGLSon (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Jul 2021 14:44:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626115314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rz8zwYlKIBwilT7nuaKV92zNGRhD3wv0rHn55OLUrN8=;
        b=HBRCvuJoYtCL3w+DDft5SuLL8CK1BpQqw059rFkTTjej9hUenF51hLFivjlM6vAZqid4G0
        +hwxburtBZts3N5nTjAIYZdyEIa7XqYUxvHN1FElJHmB1Ci/QMC6JU09oZAsyp9/IfVTRI
        OqvrfXQ9hkykn4AzCo0R7u4EpvlaIBw=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-kvvP5WoROcqY2Yx-07436Q-1; Mon, 12 Jul 2021 14:41:53 -0400
X-MC-Unique: kvvP5WoROcqY2Yx-07436Q-1
Received: by mail-ot1-f70.google.com with SMTP id e14-20020a0568301f2eb0290405cba3beedso13820664oth.13
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 11:41:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rz8zwYlKIBwilT7nuaKV92zNGRhD3wv0rHn55OLUrN8=;
        b=jwxscdTalwqcktgg3d1NZtErmYXe1C7XVqGVI5MjPZt/NuP+SVfW8ayaaQqwOzlzP7
         X5pgpzXOZ0Dy7uzCmP7KaMxfqXnanSLAh43UE0LvN0owp7gwV8mP6Js51DBahm0LdrfM
         9bxuCqlcJmdtVeFE/kR/IiLWBjB0uG/gEXsPFic1CSwIxetIDMT1RkFkwueTBEBM9IaK
         avvdxI0Dgr2kIV11b7+Hhrsu8rdAZkXFj2x3mu1pwzQdtZ3nepkCnFVXQl81sWsb4sN3
         ezmmNiXZgBzw8JYiaU/Wyp2Ie4F5OPAKx4j4vGuaBBcJiDXm1ZRWKuEqKNqnha3WEoYX
         ghnQ==
X-Gm-Message-State: AOAM532UBxHAzY6BidQLnzZex1GglJ1uu5hK7/oapJsFryWQfMg6Xoao
        Qksh50iJlNWcLQTfOFudPunmsuGY9mLnAJhOgAWKIyLMIfP8BbGYmfMHMw+GOQPiaHKQlIxdP7U
        adpo7il6KdNnG
X-Received: by 2002:aca:59c3:: with SMTP id n186mr158949oib.98.1626115312780;
        Mon, 12 Jul 2021 11:41:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwoabeJODq5qo6mubZ8IkE3585WLLaxnVDFrK1i442BlsHLyAD65SVY+xLexK9+lGo6s2ymfw==
X-Received: by 2002:aca:59c3:: with SMTP id n186mr158927oib.98.1626115312574;
        Mon, 12 Jul 2021 11:41:52 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id o9sm1221754oiw.49.2021.07.12.11.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 11:41:52 -0700 (PDT)
Date:   Mon, 12 Jul 2021 12:41:50 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Subject: Re: [RFC v2] /dev/iommu uAPI proposal
Message-ID: <20210712124150.2bf421d1.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB54336FB9845649BB2D53022C8C159@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
        <20210709155052.2881f561.alex.williamson@redhat.com>
        <BN9PR11MB54336FB9845649BB2D53022C8C159@BN9PR11MB5433.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 12 Jul 2021 01:22:11 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Saturday, July 10, 2021 5:51 AM
> > On Fri, 9 Jul 2021 07:48:44 +0000
> > "Tian, Kevin" <kevin.tian@intel.com> wrote:  
 
> > > For mdev the struct device should be the pointer to the parent device.  
> > 
> > I don't get how iommu_register_device() differentiates an mdev from a
> > pdev in this case.  
> 
> via device cookie.


Let me re-add this section for more context:

> 3. Sample structures and helper functions
> --------------------------------------------------------
> 
> Three helper functions are provided to support VFIO_BIND_IOMMU_FD:
> 
> 	struct iommu_ctx *iommu_ctx_fdget(int fd);
> 	struct iommu_dev *iommu_register_device(struct iommu_ctx *ctx,
> 		struct device *device, u64 cookie);
> 	int iommu_unregister_device(struct iommu_dev *dev);
> 
> An iommu_ctx is created for each fd:
> 
> 	struct iommu_ctx {
> 		// a list of allocated IOASID data's
> 		struct xarray		ioasid_xa;
> 
> 		// a list of registered devices
> 		struct xarray		dev_xa;
> 	};
> 
> Later some group-tracking fields will be also introduced to support 
> multi-devices group.
> 
> Each registered device is represented by iommu_dev:
> 
> 	struct iommu_dev {
> 		struct iommu_ctx	*ctx;
> 		// always be the physical device
> 		struct device 		*device;
> 		u64			cookie;
> 		struct kref		kref;
> 	};
> 
> A successful binding establishes a security context for the bound
> device and returns struct iommu_dev pointer to the caller. After this
> point, the user is allowed to query device capabilities via IOMMU_
> DEVICE_GET_INFO.
> 
> For mdev the struct device should be the pointer to the parent device. 


So we'll have a VFIO_DEVICE_BIND_IOMMU_FD ioctl where the user provides
the iommu_fd and a cookie.  vfio will use iommu_ctx_fdget() to get an
iommu_ctx* for that iommu_fd, then we'll call iommu_register_device()
using that iommu_ctx* we got from the iommu_fd, the cookie provided by
the user, and for an mdev, the parent of the device the user owns
(the device_fd on which this ioctl is called)...

How does an arbitrary user provided cookie let you differentiate that
the request is actually for an mdev versus the parent device itself?

For instance, how can the IOMMU layer distinguish GVT-g (mdev) vs GVT-d
(direct assignment) when both use the same struct device* and cookie is
just a user provided value?  Still confused.  Thanks,

Alex

