Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B958437311
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 09:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhJVHvq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 03:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbhJVHvp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Oct 2021 03:51:45 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C15EC061766
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 00:49:28 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id v17so1606278wrv.9
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 00:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l4ig/cSrg8mQN6aKAdfHWEATu5gWqjzgX7zon10Q9+E=;
        b=XNhjtbDMlD0fLOkQBRfHMcymLt/KXEWZO0gzlFJJkY7tBULpUdJRS/3zpdmfMBLV4H
         mDyJzKhY7XbOJxQruVq5kcUcL2jZDv1gnvQ9jlhLZbg5KSBTSxZeZvrngodKSZNSEl8T
         Pf8RChum9PCyRSCLuC4ch1v42ocyebTEN4wJh8w08Ks8CqkjNEC8HhO8Cuuz4OWdpkPv
         Ndv3qIL1U/ZUkmavejbqkHMkEQvYMfDd9YjvNpLjTz2JkhjTIni3XGjzgxXkPKZKg+Qy
         kQmnSmqvnDz0Wh6heFLPsNne7vzaPPNcev9WX9RnAprj7p04Nm7y9wLDcgRl/bor6Ngj
         L0nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l4ig/cSrg8mQN6aKAdfHWEATu5gWqjzgX7zon10Q9+E=;
        b=B1hSt23CwUQng+V9gT/7KdHC3xrafrYBnj0RQT6cvWGiDJ05/As/HZqSmeg2o2gJlD
         Z8SWjrq74i5CNgGDNfo0cCD04VU63/Mqt86grcxi+xclsI0EsJTISIZus977Zph44upY
         LCp024xQhbkImONkw1yUlXa0VfCOcHy5xuEwlV+5x4v6Yj99+oAdGJrGljeotm1Z1AcO
         3p8gH7HeUSwdrFKOJBLJ/aGr8CIxwojagd8G/yis1Wa+BGz4Ctp6Betg5Qnml00aHG1F
         /Zv+YC8mt/ND4xa7tQhltKB8mtWN5R1TDWeOsX4bayolJLlNl22hmJLvEYmGDswOJ4Pq
         pnXg==
X-Gm-Message-State: AOAM5308hvC4NtBT9hu6Xrpc66sroqlhKh0/WamzmSnHw5oBXiIDTAqB
        K0iYPDWabaYFOiXYtQxzS6xStA==
X-Google-Smtp-Source: ABdhPJxpO/NacPoc1tCOWgCvmhl6vzuBziA4+8Ev+IfkXnOna1GvDwP4ExJS99BeJ3odnzDfvvbRCQ==
X-Received: by 2002:a5d:6d81:: with SMTP id l1mr13601357wrs.110.1634888966529;
        Fri, 22 Oct 2021 00:49:26 -0700 (PDT)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id l2sm8802620wrs.90.2021.10.22.00.49.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 00:49:25 -0700 (PDT)
Date:   Fri, 22 Oct 2021 08:49:03 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
Subject: Re: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Message-ID: <YXJs7+nQJ++EKIyT@myrica>
References: <BN9PR11MB54333BDB1E58387FD9999DF18CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210923114219.GG964074@nvidia.com>
 <BN9PR11MB5433519229319BA951CA97638CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210930222355.GH964074@nvidia.com>
 <BN9PR11MB5433530032DC8400B71FCB788CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20211014154259.GT2744544@nvidia.com>
 <BN9PR11MB543327BB6D58AEF91AD2C9D18CB99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <BL1PR11MB5429973588E4FBCEC8F519A88CBF9@BL1PR11MB5429.namprd11.prod.outlook.com>
 <YXF/+jxRtjnlXU7w@myrica>
 <20211021232223.GM2744544@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021232223.GM2744544@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 21, 2021 at 08:22:23PM -0300, Jason Gunthorpe wrote:
> On Thu, Oct 21, 2021 at 03:58:02PM +0100, Jean-Philippe Brucker wrote:
> > On Thu, Oct 21, 2021 at 02:26:00AM +0000, Tian, Kevin wrote:
> > > > I'll leave it to Jean to confirm. If only coherent DMA can be used in
> > > > the guest on other platforms, suppose VFIO should not blindly set
> > > > IOMMU_CACHE and in concept it should deny assigning a non-coherent
> > > > device since no co-ordination with guest exists today.
> > > 
> > > Jean, what's your opinion?
> > 
> > Yes a sanity check to prevent assigning non-coherent devices would be
> > good, though I'm not particularly worried about non-coherent devices. PCIe
> > on Arm should be coherent (according to the Base System Architecture). So
> > vfio-pci devices should be coherent, but vfio-platform and mdev are
> > case-by-case (hopefully all coherent since it concerns newer platforms).
> > 
> > More worrying, I thought we disabled No-Snoop for VFIO but I was wrong,
> > it's left enabled. On Arm I don't think userspace can perform the right
> > cache maintenance operations to maintain coherency with a device that
> > issues No-Snoop writes. Userspace can issue clean+invalidate but not
> > invalidate alone, so there is no equivalent to
> > arch_sync_dma_for_cpu().
> 
> So what happens in a VM? Does a VM know that arch_sync_dma_for_cpu()
> is not available?

This would only affect userspace drivers, it's only host or guest
userspace that cannot issue the maintenance operations. The VM can do
arch_sync_dma_for_cpu()

Thanks,
Jean

> 
> And how does this work with the nested IOMMU translation? I thought I
> read in the SMMU spec that the io page table entries could control
> cachability including in nesting cases?
> 
> > I think the worse that can happen is the device owner shooting itself in
> > the foot by using No-Snoop, but would it hurt to disable it?
> 
> No, the worst is the same as Intel - a driver running in the guest VM
> assumes it can use arch_sync_dma_for_cpu() and acts accordingly,
> resulting in a broken VM.
> 
> Jason
