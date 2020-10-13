Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBC228CBA2
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 12:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731170AbgJMK2W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 06:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729516AbgJMK2W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 06:28:22 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031E6C0613D0
        for <kvm@vger.kernel.org>; Tue, 13 Oct 2020 03:28:21 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id u21so27514813eja.2
        for <kvm@vger.kernel.org>; Tue, 13 Oct 2020 03:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AOyGbFGBFW7IttULzsANlRi4lqSr3VNc7xD02DIgAWM=;
        b=akq3IGx88v65EmpzfX3uQCPH4Z/ifmvztR0aVsED6cf/SUl9WzA8IN0RykxXcIZswS
         FchIteuFvzAkYHkpkpAPrb0L2Y5WXvtSBsLbZvQuJsJBuu6oJevmkB/ECVXSY/itUMjc
         ENRlh/P7TgrixcQr9fnv01sRHxHygggxTusXO7yM13o+bof+VAskRyFDmMNIbWNSHMRm
         oPYrqoLgQAx4uzWDk6XxiTEML9iypT9O2f86gO7BpR2bWWa07vDL4CoQUi6OaPDpWV4t
         NszlZgoUZRPTgc+5AEM3GWTAgqpRZuHGOXQzNILgJpbppePhONqeNW2OpEuWg0rXtTKs
         ogPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AOyGbFGBFW7IttULzsANlRi4lqSr3VNc7xD02DIgAWM=;
        b=S1S6Jjy8GA0IKhY77HjJqPrVtYd/34L2MpWzHS4UxPwN6fXtFEvfazRvfnapVFRD0P
         ewSHvWKQ5qj7JQZIMz1yCHWHWWiEp6oGUYO1/ZTpGmULeQj+QgaPGLW331HKQ3QxuPwi
         Rx0HJHtGzxp5PqcYD2r2Oog+i1e5dLcOe1sCsYwhYk8xOxw+7+6mlzhZ5Pds73LUG7LS
         iBul6IlamGwzvIky/K2jHuFtffQp0VkW62vov3/PNp4KZzN2445rhuwk3Kk31Jk3q2eq
         jsyG0lDHSfNuinFeugTctnmhbDhgX4S1lsDxF/9h+7O5weWKgv2av6dMkDIxnG3I+ZYV
         OqOw==
X-Gm-Message-State: AOAM533PmbnszGNOOYSOAx8vvwUwU8dHePAJy6r/olkDFlRrqGti3pRH
        CJzOIpE6FLpUaKRuXxzGoOJ8SksFVT1uIw==
X-Google-Smtp-Source: ABdhPJziTva1KqYf14pDRVtwD3+jwROqc/Tcpgez4s5eirqsZWkYGdAehcgVgInF2li4RYF2MIEwMQ==
X-Received: by 2002:a17:906:d8e:: with SMTP id m14mr33694709eji.448.1602584898502;
        Tue, 13 Oct 2020 03:28:18 -0700 (PDT)
Received: from myrica ([2001:1715:4e26:a7e0:116c:c27a:3e7f:5eaf])
        by smtp.gmail.com with ESMTPSA id b6sm12848314edu.21.2020.10.13.03.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 03:28:17 -0700 (PDT)
Date:   Tue, 13 Oct 2020 12:27:58 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Wang <jasowang@redhat.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
Message-ID: <20201013102758.GB694407@myrica>
References: <MWHPR11MB1645CFB0C594933E92A844AC8C070@MWHPR11MB1645.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1645CFB0C594933E92A844AC8C070@MWHPR11MB1645.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 12, 2020 at 08:38:54AM +0000, Tian, Kevin wrote:
> > From: Jason Wang <jasowang@redhat.com>
> > Sent: Monday, September 14, 2020 12:20 PM
> >
> [...]
>  > If it's possible, I would suggest a generic uAPI instead of a VFIO
> > specific one.
> > 
> > Jason suggest something like /dev/sva. There will be a lot of other
> > subsystems that could benefit from this (e.g vDPA).
> > 
> > Have you ever considered this approach?
> > 
> 
> Hi, Jason,
> 
> We did some study on this approach and below is the output. It's a
> long writing but I didn't find a way to further abstract w/o losing 
> necessary context. Sorry about that.
> 
> Overall the real purpose of this series is to enable IOMMU nested
> translation capability with vSVA as one major usage, through
> below new uAPIs:
> 	1) Report/enable IOMMU nested translation capability;
> 	2) Allocate/free PASID;
> 	3) Bind/unbind guest page table;
> 	4) Invalidate IOMMU cache;
> 	5) Handle IOMMU page request/response (not in this series);
> 1/3/4) is the minimal set for using IOMMU nested translation, with 
> the other two optional. For example, the guest may enable vSVA on 
> a device without using PASID. Or, it may bind its gIOVA page table 
> which doesn't require page fault support. Finally, all operations can 
> be applied to either physical device or subdevice.
> 
> Then we evaluated each uAPI whether generalizing it is a good thing 
> both in concept and regarding to complexity.
> 
> First, unlike other uAPIs which are all backed by iommu_ops, PASID 
> allocation/free is through the IOASID sub-system. From this angle
> we feel generalizing PASID management does make some sense. 
> First, PASID is just a number and not related to any device before 
> it's bound to a page table and IOMMU domain. Second, PASID is a 
> global resource (at least on Intel VT-d), while having separate VFIO/
> VDPA allocation interfaces may easily cause confusion in userspace,
> e.g. which interface to be used if both VFIO/VDPA devices exist. 
> Moreover, an unified interface allows centralized control over how 
> many PASIDs are allowed per process.
> 
> One unclear part with this generalization is about the permission.
> Do we open this interface to any process or only to those which
> have assigned devices? If the latter, what would be the mechanism
> to coordinate between this new interface and specific passthrough 
> frameworks? A more tricky case, vSVA support on ARM (Eric/Jean
> please correct me) plans to do per-device PASID namespace which
> is built on a bind_pasid_table iommu callback to allow guest fully 
> manage its PASIDs on a given passthrough device.

Yes we need a bind_pasid_table. The guest needs to allocate the PASID
tables because they are accessed via guest-physical addresses by the HW
SMMU.

With bind_pasid_table, the invalidation message also requires a scope to
invalidate a whole PASID context, in addition to invalidating a mappings
ranges.

> I'm not sure 
> how such requirement can be unified w/o involving passthrough
> frameworks, or whether ARM could also switch to global PASID 
> style...

Not planned at the moment, sorry. It requires a PV IOMMU to do PASID
allocation, which is possible with virtio-iommu but not with a vSMMU
emulation. The VM will manage its own PASID space. The upside is that we
don't need userspace access to IOASID, so I won't pester you with comments
on that part of the API :)

> Second, IOMMU nested translation is a per IOMMU domain
> capability. Since IOMMU domains are managed by VFIO/VDPA
>  (alloc/free domain, attach/detach device, set/get domain attribute,
> etc.), reporting/enabling the nesting capability is an natural 
> extension to the domain uAPI of existing passthrough frameworks. 
> Actually, VFIO already includes a nesting enable interface even 
> before this series. So it doesn't make sense to generalize this uAPI 
> out.

Agree for enabling, but for reporting we did consider adding a sysfs
interface in /sys/class/iommu/ describing an IOMMU's properties. Then
opted for VFIO capabilities to keep the API nice and contained, but if
we're breaking up the API, sysfs might be more convenient to use and
extend.

> Then the tricky part comes with the remaining operations (3/4/5),
> which are all backed by iommu_ops thus effective only within an 
> IOMMU domain. To generalize them, the first thing is to find a way 
> to associate the sva_FD (opened through generic /dev/sva) with an 
> IOMMU domain that is created by VFIO/VDPA. The second thing is 
> to replicate {domain<->device/subdevice} association in /dev/sva 
> path because some operations (e.g. page fault) is triggered/handled 
> per device/subdevice. Therefore, /dev/sva must provide both per-
> domain and per-device uAPIs similar to what VFIO/VDPA already 
> does. Moreover, mapping page fault to subdevice requires pre-
> registering subdevice fault data to IOMMU layer when binding 
> guest page table, while such fault data can be only retrieved from 
> parent driver through VFIO/VDPA. 
> 
> However, we failed to find a good way even at the 1st step about
> domain association. The iommu domains are not exposed to the
> userspace, and there is no 1:1 mapping between domain and device.
> In VFIO, all devices within the same VFIO container share the address
> space but they may be organized in multiple IOMMU domains based
> on their bus type. How (should we let) the userspace know the
> domain information and open an sva_FD for each domain is the main
> problem here.
> 
> In the end we just realized that doing such generalization doesn't
> really lead to a clear design and instead requires tight coordination 
> between /dev/sva and VFIO/VDPA for almost every new uAPI 
> (especially about synchronization when the domain/device 
> association is changed or when the device/subdevice is being reset/
> drained). Finally it may become a usability burden to the userspace
> on proper use of the two interfaces on the assigned device.
>  
> Based on above analysis we feel that just generalizing PASID mgmt.
> might be a good thing to look at while the remaining operations are 
> better being VFIO/VDPA specific uAPIs. anyway in concept those are 
> just a subset of the page table management capabilities that an 
> IOMMU domain affords. Since all other aspects of the IOMMU domain 
> is managed by VFIO/VDPA already, continuing this path for new nesting
> capability sounds natural. There is another option by generalizing the 
> entire IOMMU domain management (sort of the entire vfio_iommu_
> type1), but it's unclear whether such intrusive change is worthwhile 
> (especially when VFIO/VDPA already goes different route even in legacy
> mapping uAPI: map/unmap vs. IOTLB).

I agree with your analysis. A new coarse /dev/sva interface would need to
carry all the VFIO abstractions of container (minus map/unmap) and
group+device, which are not necessarily needed by VDPA and others, while
the original VFIO interface needs to stay for compatibility. To me it
makes more sense to extend each API separately, but have them embed common
structures (bind/inval) and share some resources through external
interfaces (IOASID, nesting properties, IOPF queue).

Thanks,
Jean
