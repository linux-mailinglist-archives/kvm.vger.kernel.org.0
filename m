Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A69415131
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 22:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237419AbhIVUMM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 16:12:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56578 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237364AbhIVUML (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 16:12:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632341441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LVDSHQbpVe8JTY8isblrL8p142CPVwt8+X+MPr7eWPw=;
        b=a233ldhimVDIrls1bZs8+PfFFGWYCGNYZ4CfC0NXQcJty1QiPd0vpUzgKEnlG8O0mA/qEX
        FvtMxNi3GoN+USyDGNIEwOjzpQ8uEkLtFYkVLucsV7feU+sEEL2I8+RutpvS4r30nUg5m8
        eNG9RVvSPK7DTCvoozKZB988UmRE2Ro=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-nd62RlVEMBOSpShppZZGMw-1; Wed, 22 Sep 2021 16:10:40 -0400
X-MC-Unique: nd62RlVEMBOSpShppZZGMw-1
Received: by mail-oi1-f199.google.com with SMTP id y185-20020acaafc2000000b0027359453ad4so2470146oie.6
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 13:10:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=LVDSHQbpVe8JTY8isblrL8p142CPVwt8+X+MPr7eWPw=;
        b=nNAS/tzMD+573hcIaHesQWDgg4Rf+8bpT1mD5pvSQ9zGvpQvRq8PS8zWtQami5AokO
         xXlKxd1DEWWOVh9upSHnXGxN0zILKh61gquNAnNg1AUW8RDw4vitODtZe8Aa4gA44p1e
         fQjALny0OSI1HmGpfwvijcn6IpHVtRHhZmrn5C2qyvbHVljO5s36tbV9ZgLiXLlN2PXB
         ZQ61jCHDSyZ2EGMVTI695U43V6sGy9N06+8T2I93doQPuBaLCwfnRyfGLv86DN2F8C6E
         TWi4wr4hvCFn+pOAlJS5cB+LGWG5XgwiWDt6V4TXDArHDxlE+ERjmGQADsCxrKz4s6cP
         ziwA==
X-Gm-Message-State: AOAM533mtkNmAQquMlDpV85fR85PHmerbK7V/Zu1UeDhrShauJTETmcw
        yT07Aa07w198jg+qXbnNqvnxJCjDRYxz87wCFNlz3SdGJkZdew4pi6gF3iHk0gVzH9tkJJMDFt9
        QPuJwwmAMgZNI
X-Received: by 2002:aca:5f09:: with SMTP id t9mr785747oib.157.1632341439238;
        Wed, 22 Sep 2021 13:10:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsexkS3ssuL6wF9vSWKPex4M0QKWRz+hAFF7uOcJjumY+ZptpBRjRLEImjoapaxD27rGKTYw==
X-Received: by 2002:aca:5f09:: with SMTP id t9mr785712oib.157.1632341438954;
        Wed, 22 Sep 2021 13:10:38 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id a15sm720852otq.13.2021.09.22.13.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 13:10:38 -0700 (PDT)
Date:   Wed, 22 Sep 2021 14:10:36 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 03/20] vfio: Add vfio_[un]register_device()
Message-ID: <20210922141036.5cd46b2b.alex.williamson@redhat.com>
In-Reply-To: <20210922122252.GG327412@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
        <20210919063848.1476776-4-yi.l.liu@intel.com>
        <20210921160108.GO327412@nvidia.com>
        <BN9PR11MB5433D4590BA725C79196E0248CA19@BN9PR11MB5433.namprd11.prod.outlook.com>
        <20210922005337.GC327412@nvidia.com>
        <BN9PR11MB54338D108AF5A87614717EF98CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
        <20210922122252.GG327412@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 22 Sep 2021 09:22:52 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Sep 22, 2021 at 09:23:34AM +0000, Tian, Kevin wrote:
> 
> > > Providing an ioctl to bind to a normal VFIO container or group might
> > > allow a reasonable fallback in userspace..  
> > 
> > I didn't get this point though. An error in binding already allows the
> > user to fall back to the group path. Why do we need introduce another
> > ioctl to explicitly bind to container via the nongroup interface?   
> 
> New userspace still needs a fallback path if it hits the 'try and
> fail'. Keeping the device FD open and just using a different ioctl to
> bind to a container/group FD, which new userspace can then obtain as a
> fallback, might be OK.
> 
> Hard to see without going through the qemu parts, so maybe just keep
> it in mind

If we assume that the container/group/device interface is essentially
deprecated once we have iommufd, it doesn't make a lot of sense to me
to tack on a container/device interface just so userspace can avoid
reverting to the fully legacy interface.

But why would we create vfio device interface files at all if they
can't work?  I'm not really on board with creating a try-and-fail
interface for a mechanism that cannot work for a given device.  The
existence of the device interface should indicate that it's supported.
Thanks,

Alex

