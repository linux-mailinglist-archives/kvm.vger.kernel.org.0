Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211F24364DB
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 16:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbhJUPAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbhJUPAn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 11:00:43 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8970C061348
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 07:58:26 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id o20so1323382wro.3
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 07:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9NBqHjMa3wMvruHtwVGUR1gd7leMzib5uaeU+3Io4Fg=;
        b=qBP2L8NVoLfZGeQzfQjTFTNz0gG7byHV4/NfKy7g3ACmXnfyTURs/kJuCENa0ErjIS
         9gMeeYKQSF1EERRPA76Ma8B/Z6HgB6SfFqm9Il709BrqR/YoDXAldgU5CKMlgADTSnN2
         +xWx7oJkoq0MVJEHZ5Q30hgftm1JS1Tc3a1bbSPvAJb5xXVPzI2AcsY9t8VjUaYhnSP6
         TWAeS06C5u3UV5FCNmiy9Xh37uKHLLnkG2a0XPDHvr/phujaMvRMutXBnYx4hChmpAKu
         +6yYVvun+7Oh3nH135puLcVD82OOGl5Hh8iajWjPrmyw7VlXzrBoqR+P+P9nNKdBh9FR
         6ezQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9NBqHjMa3wMvruHtwVGUR1gd7leMzib5uaeU+3Io4Fg=;
        b=1EokWmxGTHCyPyLS53uy1nCbYliW0CX0V9xBAmQW8NTKiBQZmbqaxMcXQT1yDHy+nM
         soswv2y9TIgY3lvqYnn/N3AN2ihQk5FuknAR8Cf1PHmA3bnkytDcU/QF7v74sBbp/JTR
         6Z9Ay7s081WI4ceVIFkmu+PArJBopkRAbeydH1FaXuRHfzR/xwA2eiWMH1KWdODhwZ44
         lp8JkvlE6/zjZOKnbxy5vU5FdsjX5+nDHDBNmJFeT7vqY67hr7mycIZvtnXFElblHHXD
         talzzXD612hJsytfnwaLz84gX9rmsi9pqJBe2GMfYVZYRh/BOztFA7XzShIm6U+erce8
         Px4A==
X-Gm-Message-State: AOAM531oLFr0Xu4foMYnys5zFxdHwMcntiAygqk/NyLIqvLWCoSfhcnB
        wivmP1iBhe/DHAsXK9IxJtNgMA==
X-Google-Smtp-Source: ABdhPJx5RVth8E6qcEBrzprytwqqvFi257rdO6QMjjNBkE3Npatj68fYhqVFmrNYJlMyrm2jHzKLvw==
X-Received: by 2002:a5d:55cd:: with SMTP id i13mr8018641wrw.410.1634828305512;
        Thu, 21 Oct 2021 07:58:25 -0700 (PDT)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id d24sm4977061wmb.35.2021.10.21.07.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 07:58:24 -0700 (PDT)
Date:   Thu, 21 Oct 2021 15:58:02 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
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
Message-ID: <YXF/+jxRtjnlXU7w@myrica>
References: <20210922234954.GB964074@nvidia.com>
 <BN9PR11MB5433409DF766AAEF1BB2CF258CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <BN9PR11MB54333BDB1E58387FD9999DF18CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210923114219.GG964074@nvidia.com>
 <BN9PR11MB5433519229319BA951CA97638CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210930222355.GH964074@nvidia.com>
 <BN9PR11MB5433530032DC8400B71FCB788CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20211014154259.GT2744544@nvidia.com>
 <BN9PR11MB543327BB6D58AEF91AD2C9D18CB99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <BL1PR11MB5429973588E4FBCEC8F519A88CBF9@BL1PR11MB5429.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR11MB5429973588E4FBCEC8F519A88CBF9@BL1PR11MB5429.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 21, 2021 at 02:26:00AM +0000, Tian, Kevin wrote:
> > I'll leave it to Jean to confirm. If only coherent DMA can be used in
> > the guest on other platforms, suppose VFIO should not blindly set
> > IOMMU_CACHE and in concept it should deny assigning a non-coherent
> > device since no co-ordination with guest exists today.
> 
> Jean, what's your opinion?

Yes a sanity check to prevent assigning non-coherent devices would be
good, though I'm not particularly worried about non-coherent devices. PCIe
on Arm should be coherent (according to the Base System Architecture). So
vfio-pci devices should be coherent, but vfio-platform and mdev are
case-by-case (hopefully all coherent since it concerns newer platforms).

More worrying, I thought we disabled No-Snoop for VFIO but I was wrong,
it's left enabled. On Arm I don't think userspace can perform the right
cache maintenance operations to maintain coherency with a device that
issues No-Snoop writes. Userspace can issue clean+invalidate but not
invalidate alone, so there is no equivalent to arch_sync_dma_for_cpu().
I think the worse that can happen is the device owner shooting itself in
the foot by using No-Snoop, but would it hurt to disable it?

Thanks,
Jean

